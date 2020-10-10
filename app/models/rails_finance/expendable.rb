module RailsFinance::Expendable
  extend ActiveSupport::Concern

  included do
    attribute :budget_amount, :decimal
    attribute :expense_amount, :decimal

    has_many :expenses, as: :expendable
  end

end
