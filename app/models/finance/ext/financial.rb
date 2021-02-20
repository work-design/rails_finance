module Finance
  module Ext::Financial
    extend ActiveSupport::Concern

    included do
      attribute :fund_budget, :decimal, default: 0
      attribute :fund_expense, :decimal, default: 0
      attribute :budget_amount, :decimal, default: 0
      attribute :expense_amount, :decimal, default: 0

      has_many :fund_budgets, class_name: 'Finance::FundBudget', as: :financial, dependent: :nullify
      has_many :fund_expenses, class_name: 'Finance::FundExpense', as: :financial, dependent: :nullify
      has_many :budgets, class_name: 'Finance::Budget', as: :financial
      has_many :expenses, class_name: 'Finance::Expense', as: :financial
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
end
