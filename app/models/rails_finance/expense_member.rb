class ExpenseMember < ApplicationRecord
  include CheckMachine

  attribute :state, :string, default: 'pending_borrow'
  belongs_to :expense
  belongs_to :member
  belongs_to :payment_method, optional: true
  has_many :payouts, as: :payable, autosave: true
  has_many :expense_items, ->(o){ where(member_id: o.member_id) }, foreign_key: :expense_id, primary_key: :expense_id

  validates :member_id, uniqueness: { scope: [:expense_id] }

  enum state: {
    pending_borrow: 'pending_borrow',
    advance_pay: 'advance_pay',
    advance_paid: 'advance_paid',
    pending_reimburse: 'pending_reimburse',
    to_pay: 'to_pay',
    paid: 'paid'
  }

  acts_as_notify :default,
                 only: [:amount, :advance],
                 methods: [:expense_subject, :state_i18n]
  acts_as_notify :request,
                 only: [:amount, :advance],
                 methods: [:member_name, :expense_subject]

  delegate :subject, to: :expense, prefix: true
  delegate :name, to: :member, prefix: true

  def approve_config
    {
      pending_borrow: advance_verifier,
      advance_pay: member.cashier,
      advance_paid: member,
      pending_reimburse: verifier,
      to_pay: member.cashier,
      paid: member
    }.with_indifferent_access
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
          receiver: next_operator,
          link: url_helpers.finance_expense_url(self.expense_id),
          code: :request,
          verbose: true
        )
      end
    end
  end

  def to_advance_payout
    return unless payment_method
    payout = self.payouts.find_or_initialize_by(advance: true)
    payout.requested_amount = self.advance
    payout.payment_method_id = self.payment_method_id

    self.do_trigger state: 'advance_pay'
  end

  def advance_payout_id
    self.payouts.find_by(advance: true)&.id
  end

  def to_payout
    return unless payment_method
    payout = self.payouts.find_or_initialize_by(advance: false)
    payout.requested_amount = self.payout_amount
    payout.payment_method_id = self.payment_method_id

    self.do_trigger state: 'to_pay'
  end

  def payout_id
    self.payouts.find_by(advance: false)&.id
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
