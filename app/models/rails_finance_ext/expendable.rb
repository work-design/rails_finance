module RailsFinanceExt::Expendable
  extend ActiveSupport::Concern

  included do
    attribute :expense_amount, :decimal

    has_many :expenses, as: :expendable
  end

end
