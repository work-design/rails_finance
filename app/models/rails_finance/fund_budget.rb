module RailsFinance::FundBudget
  extend ActiveSupport::Concern

  included do
    attribute :amount, :decimal, default: 0
    attribute :note, :string

    belongs_to :fund
    belongs_to :financial, polymorphic: true
  end

  def sum_fund_amount
    fund.sum_budget_amount
    fund.save
    if financial
      financial.compute_fund_budget
      financial.save
    end
  end

end
