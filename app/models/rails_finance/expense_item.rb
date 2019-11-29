module RailsFinance::ExpenseItem
  extend ActiveSupport::Concern

  included do
    attribute :budget, :decimal, precision: 10, scale: 2
    attribute :amount, :decimal, precision: 10, scale: 2
    attribute :note, :string
    attribute :state, :string
    attribute :quantity, :integer, default: 1
    attribute :price, precision: 10, scale: 2
    
    belongs_to :expense
    belongs_to :member, optional: true
    belongs_to :financial_taxon, optional: true
    has_one :expense_member, ->(o){ where(member_id: o.member_id) }, foreign_key: :expense_id, primary_key: :expense_id
  
    after_initialize if: :new_record? do
      ensure_amount
    end
    before_update :ensure_amount
    after_update_commit :sync_member_amount, if: -> { saved_change_to_amount? }
  end
  
  def same_items
    self.class.where(expense_id: self.expense_id, member_id: self.member_id)
  end

  def ensure_amount
    self.amount = budget if expense.init?
  end

  def sync_member_amount
    self.expense_member.update(amount: self.same_items.sum(:amount))
    self.expense.update(amount: self.expense.expense_items.sum(:amount))
  end

end
