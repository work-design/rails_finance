module Finance
  module Model::FundExpense
    extend ActiveSupport::Concern

    included do
      attribute :amount, :decimal, default: 0
      attribute :note, :string

      belongs_to :fund
      belongs_to :fund_budget, optional: true
      belongs_to :financial, polymorphic: true

      after_save :sum_fund_amount, if: -> { saved_change_to_amount? }
    end

    def sum_fund_amount
      fund.sum_expense_amount(financial_type)
      fund.save

      if financial
        financial.compute_fund_expense
        financial.save
      end
    end

  end
end
