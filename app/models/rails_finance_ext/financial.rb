module RailsFinanceExt::Budgeting
  extend ActiveSupport::Concern

  included do
    attribute :fund_budget, :decimal
    attribute :fund_amount, :decimal
    attribute :budget_amount, :decimal
    attribute :expense_amount, :decimal

    has_many :funds, as: :financial, dependent: :nullify
    has_many :budgets, as: :financial
    has_many :expenses, as: :financial
  end

end
