module RailsFinance::Fund
  extend ActiveSupport::Concern

  included do
    attribute :name, :string
    attribute :budget_amount, :decimal, default: 0
    attribute :amount, :decimal, default: 0
    attribute :expense_amount, :decimal, default: 0
    attribute :note, :string

    has_one_attached :proof

    has_many :fund_incomes, dependent: :destroy
    has_many :fund_plans, dependent: :destroy
  end

  def sum_income_amount
    self.amount = fund_incomes.sum(:amount)
  end

end
