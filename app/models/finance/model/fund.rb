module Finance
  module Model::Fund
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :amount, :decimal, default: 0
      attribute :budget_amount, :decimal, default: 0
      attribute :budget_detail, :json, default: {}
      attribute :expense_amount, :decimal, default: 0
      attribute :expense_detail, :json, default: {}
      attribute :note, :string

      has_one_attached :proof

      has_many :fund_incomes, dependent: :destroy
      has_many :fund_budgets, dependent: :destroy
      has_many :fund_expenses, dependent: :destroy
    end

    def sum_budget_amount(financial_type)
      self.budget_detail.merge! financial_type => fund_budgets.where(financial_type: financial_type).sum(:amount)
    end

    def sum_income_amount
      self.amount = fund_incomes.sum(:amount)
    end

    def sum_expense_amount(financial_type)
      self.expense_detail.merge! financial_type => fund_expenses.where(financial_type: financial_type).sum(:amount)
    end

  end
end
