module Finance
  module Model::ExpenseItem
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
      belongs_to :financial_taxon, optional: true

      before_save :ensure_amount, if: -> { budget_amount_changed? }
      after_save :sync_budget_amount, if: -> { saved_change_to_budget_amount? }
      after_update_commit :sync_member_amount, if: -> { saved_change_to_amount? }
    end

    def sync_budget_amount
      budget.amount = budget.expense_items.sum(&:budget_amount)
      budget.save
    end

    def ensure_amount
      self.amount = budget_amount if budget
    end

    def sync_member_amount
      self.expense.update(amount: self.expense.expense_items.sum(:amount)) if expense
    end

  end
end
