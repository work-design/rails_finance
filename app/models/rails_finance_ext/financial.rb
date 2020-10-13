module RailsFinanceExt::Financial
  extend ActiveSupport::Concern

  included do
    attribute :fund_budget, :decimal
    attribute :fund_amount, :decimal
    attribute :budget_amount, :decimal
    attribute :expense_amount, :decimal

    has_many :fund_items, as: :financial, dependent: :nullify
    has_many :budgets, as: :financial
    has_many :expenses, as: :financial
  end

  def compute_budget_amount
    self.budget_amount = budgets.sum(:amount)
  end

  def compute_expense_amount
    self.expense_amount = expenses.sum(:amount)
  end

end
