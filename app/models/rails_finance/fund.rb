module RailsFinance::Fund
  extend ActiveSupport::Concern

  included do
    attribute :name, :string
    attribute :amount, :decimal, default: 0
    attribute :budget_amount, :decimal, default: 0
    attribute :expense_amount, :decimal, default: 0
    attribute :note, :string

    has_one_attached :proof

    has_many :fund_incomes, dependent: :destroy
    has_many :fund_budgets, dependent: :destroy
    has_many :fund_expenses, dependent: :destroy
  end

  def sum_income_amount
    self.amount = fund_incomes.sum(:amount)
  end

  def sum_used_amount
    self.expense_amount = fund_expenses.sum(:amount)
  end

  def sum_budget_amount
    self.budget_amount ||= fund_budgets.sum(:amount)
  end

end
