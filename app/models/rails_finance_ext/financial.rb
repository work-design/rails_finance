module RailsFinanceExt::Financial
  extend ActiveSupport::Concern

  included do
    attribute :fund_budget, :decimal, default: 0
    attribute :fund_expense, :decimal, default: 0
    attribute :budget_amount, :decimal, default: 0
    attribute :expense_amount, :decimal, default: 0

    has_many :fund_budgets, as: :financial, dependent: :nullify
    has_many :fund_expenses, as: :financial, dependent: :nullify
    has_many :budgets, as: :financial
    has_many :expenses, as: :financial
  end

  def compute_fund_budget
    self.fund_budget = fund_budgets.sum(:amount)
  end

  def compute_fund_expense
    self.fund_expense = fund_expenses.sum(:amount)
  end

  def compute_budget_amount
    self.budget_amount = budgets.sum(:amount)
  end

  def compute_expense_amount
    self.expense_amount = expenses.sum(:amount)
  end

end
