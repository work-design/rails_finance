module RailsFinanceExt::Budgeting
  extend ActiveSupport::Concern

  included do
    attribute :budget_amount, :decimal
    attribute :expense_amount, :decimal

    has_many :funds, dependent: :nullify
    has_many :budgets, as: :budgeting
    has_many :expenses, as: :expendable
  end

end
