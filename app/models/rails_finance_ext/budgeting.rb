module RailsFinanceExt::Budgeting
  extend ActiveSupport::Concern

  included do
    attribute :budget_amount, :decimal

    has_many :budgets, as: :budgeting
  end

end
