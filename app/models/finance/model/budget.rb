module Finance
  module Model::Budget
    extend ActiveSupport::Concern

    included do
      attribute :type, :string, default: 'Finance::FundBudget'
      attribute :subject, :string
      attribute :amount, :decimal
      attribute :note, :string

      belongs_to :organ, class_name: 'Org::Organ', optional: true
      belongs_to :member, class_name: 'Org::Member', optional: true
      belongs_to :financial, polymorphic: true, optional: true
      belongs_to :fund, optional: true
      belongs_to :stock, optional: true

      belongs_to :financial_taxon, optional: true
      belongs_to :taxon, foreign_key: :financial_taxon_id, optional: true

      has_many :verifiers, -> { where(verifiable_type: 'FinancialTaxon').order(position: :asc) }, class_name: 'Auditor::Verifier', primary_key: :financial_taxon_id, foreign_key: :verifiable_id
      has_many :expense_items, dependent: :destroy
      has_many :expenses, dependent: :destroy
      accepts_nested_attributes_for :expense_items, allow_destroy: true, reject_if: :all_blank

      #validate :amount_sum
      validates :subject, presence: true

      has_one_attached :proof
      has_one_attached :invoice

      enum :state, {
        init: 'init',
        verifying: 'verifying',
        finished: 'finished',
        rejected: 'rejected'
      }, default: 'init'

      acts_as_notify(
        :default,
        only: [:subject, :amount, :type],
        methods: [:creator_name, :state_i18n]
      )
      acts_as_notify(
        :request,
        only: [:subject, :amount, :type],
        methods: [:creator_name]
      )

      after_save :sum_amount, if: -> { financial.present? && saved_change_to_amount? }
      after_save :sum_fund_amount, if: -> { fund && saved_change_to_amount? }
      after_save :sum_stock_amount, if: -> { stock && saved_change_to_amount? }
    end

    def can_operate?(member)
      return true if member.admin?
      self.next_operator == current_member && !['init', 'rejected', 'finished'].include?(self.state)
    end

    def next_state_state
      if ['pending_om', 'pending_cfo'].include? state
        next_state_states.without('pending_md').first
      else
        next_state_states.first
      end
    end

    def next_state_states
      next_states(:state) do |states|
        unless self.financial_taxon.verifiers
          states - ['pending_verifier']
        end

        if self.amount <= 5000
          states - ['pending_cfo']
        elsif self.amount > 5000 && self.amount <= 20000
          states - ['pending_om']
        elsif self.amount > 20000
          states - ['pending_om', 'pending_cfo']
        end
      end
    end

    def do_trigger(params = {})
      self.trigger_to(state: params[:state])

      self.class.transaction do
        self.save!
        to_notification(
          member: creator,
          link: url_helpers.me_expenses_url(id: self.id),
          verbose: true
        )
        if next_verifier
          to_notification(
            member: next_verifier.member,
            link: url_helpers.admin_me_expenses_url(id: self.id),
            code: :request,
            verbose: true
          )
        end
      end
    end

    def amount_cn
      NumHelper.to_rmb amount&.to_f || 0
    end

    def details
      expense_items.map do |item|
        "#{item.financial_taxon&.name} #{item.note} #{item.amount}"
      end.join("\n")
    end

    def amount_sum
      unless self.amount == self.expense_members.sum(&->(i){ i.amount.to_d })
        self.errors.add :amount, 'Amount must equal to amount sum'
      end

      unless self.amount == self.expense_items.sum(&->(i){ i.amount.to_d })
        self.errors.add :amount, 'Amount must equal to cost sum'
      end
    end

    def transfer(type)
      expense = self.expenses.build(type: type)
      expense.assign_attributes self.attributes.slice('financial_taxon_id', 'subject', 'amount')
      expense.creator_id = member_id
      expense.expendable_type = budgeting_type
      expense.expendable_id = budgeting_id
      expense.save!
    end

    def sum_amount
      financial.compute_budget_amount
      financial.save
    end

    def sum_fund_amount
      fund.sum_budget_amount(financial_type)
      fund.save
      if financial
        financial.compute_fund_budget
        financial.save
      end
    end

    def sum_stock_amount

    end

  end
end
