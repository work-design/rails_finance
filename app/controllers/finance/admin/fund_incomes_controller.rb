module Finance
  class Admin::FundIncomesController < Admin::BaseController
    before_action :set_fund
    before_action :set_fund_income, only: [:show, :edit, :update, :destroy, :actions]
    before_action :set_new_fund_income, only: [:new, :create]

    def index
      @fund_incomes = @fund.fund_incomes.page(params[:page])
    end

    private
    def set_fund
      @fund = Fund.find params[:fund_id]
    end

    def set_fund_income
      @fund_income = FundIncome.find(params[:id])
    end

    def set_new_fund_income
      @fund_income = @fund.fund_incomes.build(fund_income_params)
    end

    def fund_income_params
      params.fetch(:fund_income, {}).permit(
        :amount,
        :note,
        :user_id,
        :proof
      )
    end

  end
end
