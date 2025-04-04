module Finance
  module Model::Expense
    extend ActiveSupport::Concern

    included do
      attribute :type, :string
      attribute :state, :string
      attribute :subject, :string
      attribute :amount, :decimal
      attribute :note, :string, limit: 4096
      attribute :invoices_count, :integer

      belongs_to :organ, class_name: 'Org::Organ', optional: true
      belongs_to :creator, class_name: 'Org::Member'
      belongs_to :payment_method, class_name: 'Trade::PaymentMethod', optional: true

      belongs_to :financial, polymorphic: true, optional: true
      belongs_to :budget, optional: true
      belongs_to :fund, optional: true
      belongs_to :stock, optional: true
      belongs_to :financial_taxon
      belongs_to :payout, optional: true
      belongs_to :taxon, foreign_key: :financial_taxon_id

      has_many :verifiers, -> { where(verifiable_type: 'FinancialTaxon').order(position: :asc) }, class_name: 'Auditor::Verifier', primary_key: :financial_taxon_id, foreign_key: :verifiable_id
      has_many :expense_members, dependent: :destroy
      has_many :members, through: :expense_members
      has_many :expense_items, dependent: :destroy

      accepts_nested_attributes_for :expense_members, allow_destroy: true, reject_if: :all_blank
      accepts_nested_attributes_for :expense_items, allow_destroy: true, reject_if: :all_blank

      #validate :amount_sum
      validates :subject, presence: true

      has_one_attached :proof
      has_one_attached :invoice

      enum :state, {
        init: 'init',
        verifying: 'verifying',
        paying: 'paying',
        upload_invoice: 'upload_invoice',
        invoice_verifying: 'invoice_verifying',
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

      before_save :sync_amount
      after_save :sum_amount, if: -> { saved_change_to_amount? }
      after_save :sum_fund_amount, if: -> { fund && saved_change_to_amount? }
      after_save :sync_items, if: -> { saved_change_to_budget_id? && budget }
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

    def sum_amount
      return unless financial
      financial.compute_expense_amount
      financial.save
    end

    def sum_fund_amount
      fund.sum_expense_amount(financial_type)
      fund.save

      if financial
        financial.compute_fund_expense
        financial.save
      end
    end

    def sync_amount
      self.amount = self.expense_items.sum(&->(i){ i.amount.to_d })
    end

    def sync_items
      budget.expense_items.update_all expense_id: self.id
    end

    def sync_members
      self.expense_items.pluck(:member_id).compact.each do |member_id|
        amount = self.expense_items.sum(:amount)
        self.expense_members.create(member_id: member_id, amount: amount)
      end
    end

  end
end
