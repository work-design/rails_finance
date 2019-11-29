module RailsFinance::Expense
  extend ActiveSupport::Concern

  included do
    attribute :type, :string
    attribute :state, :string, default: 'init'
    attribute :subject, :string
    attribute :amount, :decimal, precision: 10, scale: 2
    attribute :note, :string, limit: 4096
    attribute :invoices_count, :integer
    
    belongs_to :payout, optional: true
    belongs_to :creator, class_name: 'Member'
    belongs_to :financial_taxon
    belongs_to :payment_method, optional: true
    belongs_to :verifier, optional: true

    has_many :expense_members, dependent: :destroy
    has_many :members, through: :expense_members
    has_many :expense_items, dependent: :destroy
  
    accepts_nested_attributes_for :expense_members, allow_destroy: true, reject_if: :all_blank
    accepts_nested_attributes_for :expense_items, allow_destroy: true, reject_if: :all_blank
  
    #validate :amount_sum
    validates :subject, presence: true
  
    has_one_attached :proof
    has_one_attached :invoice
  
    enum state: {
      init: 'init',
      pending_verifier: 'pending_verifier',
      pending_financial: 'pending_financial',
      pending_om: 'pending_om',
      pending_cfo: 'pending_cfo',
      pending_md: 'pending_md',
      paying: 'paying',
      upload_invoice: 'upload_invoice',
      invoice_financial: 'invoice_financial',
      finished: 'finished',
      rejected: 'rejected'
    }
  
    enum type: {
      BudgetExpense: 'BudgetExpense',
      PayableExpense: 'PayableExpense',
      PrepayExpense: 'PrepayExpense'
    }
  
    delegate :name, to: :creator, prefix: true
    delegate :name, to: :verifier, prefix: true
  
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
    after_create :sync_members
    before_save :sync_amount
  end
  
  def approve_config
    {
      pending_verifier: financial_taxon.verifier,
      pending_financial: creator.financial,
      pending_om: creator.office.leader,
      pending_cfo: Member.find_by(email: SETTING['cfo_email']),
      pending_md: Member.find_by(email: SETTING['md_email'])
    }.with_indifferent_access
  end

  def next_operator(_state = next_state_state)
    approve_config[_state]
  end

  def can_operate?(member)
    return true if member.admin?
    self.next_operator == current_member && !['init', 'rejected', 'finished'].include?(self.state)
  end

  def request!
    next_to! state: 'pending_verifier'
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
      unless self.financial_taxon&.verifier
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
    self.verifier_id = next_operator(params[:state])&.id

    self.class.transaction do
      self.save!
      to_notification(
        receiver: creator,
        link: url_helpers.my_expenses_url(id: self.id),
        verbose: true
      )
      if next_operator(params[:state])
        to_notification(
          receiver: next_operator(params[:state]),
          link: url_helpers.my_finance_expenses_url(id: self.id),
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
    unless self.amount == self.expense_members.sum(&:amount)
      self.errors.add :amount, 'Amount must equal to amount sum'
    end

    unless self.amount == self.expense_items.sum(&:amount)
      self.errors.add :amount, 'Amount must equal to cost sum'
    end
  end

  def sync_amount
    self.amount = self.expense_items.sum(&:amount)
  end

  def sync_members
    self.expense_items.pluck(:member_id).compact.each do |member_id|
      amount = self.expense_items.where(member_id: member_id).sum(:amount)
      self.expense_members.create(member_id: member_id, amount: amount)
    end
  end

end
