module RailsFinance::Fund
  extend ActiveSupport::Concern

  included do
    attribute :name, :string
    attribute :budget_amount, :decimal, default: 0
    attribute :amount, :decimal, default: 0
    attribute :used_amount, :decimal, default: 0
    attribute :note, :string

    has_one_attached :proof

    has_many :fund_incomes, dependent: :destroy
    has_many :fund_uses, dependent: :destroy
  end

  def sum_income_amount
    self.amount = fund_incomes.sum(:amount)
  end

  def sum_used_amount
    self.used_amount = fund_uses.sum(:amount)
  end

  def sum_budget_amount
    self.budget_amount ||= fund_uses.sum(:budget_amount)
  end

end
