module Finance
  module Model::ExpenseMember
    extend ActiveSupport::Concern

    included do
      attribute :amount, :decimal
      attribute :advance, :decimal
      attribute :state, :string
      attribute :note, :string

      belongs_to :member, class_name: 'Org::Member'

      belongs_to :expense
      belongs_to :payment_method, optional: true

      has_many :expense_items, ->(o){ where(member_id: o.member_id) }, foreign_key: :expense_id, primary_key: :expense_id

      validates :member_id, uniqueness: { scope: [:expense_id] }

      enum state: {
        pending_borrow: 'pending_borrow',
        advance_pay: 'advance_pay',
        advance_paid: 'advance_paid',
        pending_reimburse: 'pending_reimburse',
        to_pay: 'to_pay',
        paid: 'paid'
      }, _default: 'pending_borrow'

      acts_as_notify(
        :default,
        only: [:amount, :advance],
        methods: [:expense_subject, :state_i18n]
      )
      acts_as_notify(
        :request,
        only: [:amount, :advance],
        methods: [:member_name, :expense_subject]
      )

      delegate :subject, to: :expense, prefix: true
      delegate :name, to: :member, prefix: true
    end

    def approve_config
      {
        pending_borrow: advance_verifier,
        advance_pay: member.cashier,
        advance_paid: member,
        pending_reimburse: verifier,
        to_pay: member.cashier,
        paid: member
      }
    end

    def next_operator
      approve_config[next_state(:state)]
    end

    def advance_verifier
      if self.advance <= 5000
        member.office.leader
      elsif self.advance > 5000
        Member.find_by(email: SETTING['cfo_email'])
      end
    end

    def verifier
      if self.amount <= 5000
        member.office.leader
      elsif self.amount > 5000
        Member.find_by(email: SETTING['cfo_email'])
      end
    end

    def can_operate?(member)
      return true if member.admin?
      self.next_operator == current_member && !['paid'].include?(self.state)
    end

    def amount_cn
      NumHelper.to_rmb amount.to_f
    end

    def advance_cn
      NumHelper.to_rmb advance.to_f
    end

    def payout_amount
      self.amount.to_d - self.advance.to_d
    end

    def do_trigger(params = {})
      self.trigger_to(state: params[:state])

      # case state_was
      # when 'pending_borrow'
      #   self.to_advance_payout
      # when 'pending_reimburse'
      #   self.to_payout
      # end

      self.class.transaction do
        self.save!
        if next_operator
          to_notification(
            member: next_operator,
            link: url_helpers.finance_expense_url(self.expense_id),
            code: :request,
            verbose: true
          )
        end
      end
    end

    def details
      text = ''
      items = expense_items.limit(4).map do |item|
        "#{item.financial_taxon&.name} #{item.note} #{item.amount}"
      end.join("\n")

      if expense.note.present?
        text << expense.note
      else
        text << '详情请查看附件'
      end
      text
    end

  end
end
