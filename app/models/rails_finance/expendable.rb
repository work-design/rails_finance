module RailsFinance::Expendable
  extend ActiveSupport::Concern

  included do
    attribute :expense_budget, :decimal
    attribute :expense_amount, :decimal

    has_many :expenses, as: :expendable
  end

end
