module RailsFinance::FundUse
  extend ActiveSupport::Concern

  included do
    attribute :budget_amount, :decimal
    attribute :amount, :decimal, default: 0
    attribute :note, :string

    belongs_to :fund
    belongs_to :financial, polymorphic: true, optional: true

    after_save :sum_fund_amount, if: -> { saved_change_to_amount? || saved_change_to_budget_amount? }
  end

  def sum_fund_amount
    fund.sum_used_amount if saved_change_to_amount?
    fund.sum_budget_amount if saved_change_to_budget_amount?
    fund.save
  end

end
