module RailsFinance::ExpenseItem
  extend ActiveSupport::Concern

  included do
    attribute :budget_amount, :decimal
    attribute :amount, :decimal
    attribute :note, :string
    attribute :state, :string
    attribute :quantity, :integer, default: 1
    attribute :price, :decimal

    belongs_to :expense, optional: true
    belongs_to :budget, optional: true
    belongs_to :member, optional: true
    belongs_to :financial_taxon, optional: true
    has_one :expense_member, ->(o){ where(member_id: o.member_id) }, foreign_key: :expense_id, primary_key: :expense_id

    before_save :ensure_amount, if: -> { budget_amount_changed? }
    after_update_commit :sync_member_amount, if: -> { saved_change_to_amount? }
  end

  def same_items
    self.class.where(expense_id: self.expense_id, member_id: self.member_id)
  end

  def ensure_amount
    self.amount = budget_amount if budget
  end

  def sync_member_amount
    self.expense_member.update(amount: self.same_items.sum(:amount))
    self.expense.update(amount: self.expense.expense_items.sum(:amount))
  end

end
