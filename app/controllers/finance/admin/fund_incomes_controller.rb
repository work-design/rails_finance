module Finance
  class Admin::FundIncomesController < Admin::BaseController
    before_action :set_fund
    before_action :set_fund_income, only: [:show, :edit, :update, :destroy]

    def index
      @fund_incomes = @fund.fund_incomes.page(params[:page])
    end

    def new
      @fund_income = @fund.fund_incomes.build
    end

    def create
      @fund_income = @fund.fund_incomes.build(fund_income_params)

      unless @fund_income.save
        render :new, locals: { model: @fund_income }, status: :unprocessable_entity
      end
    end

    def show
    end

    def edit
    end

    def update
      @fund_income.assign_attributes(fund_income_params)

      unless @fund_income.save
        render :edit, locals: { model: @fund_income }, status: :unprocessable_entity
      end
    end

    def destroy
      @fund_income.destroy
    end

    private
    def set_fund
      @fund = Fund.find params[:fund_id]
    end

    def set_fund_income
      @fund_income = FundIncome.find(params[:id])
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
