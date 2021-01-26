module Finance
  class Admin::FundBudgetsController < Admin::BaseController
    before_action :set_fund
    before_action :set_fund_budget, only: [:show, :edit, :update, :destroy]

    def index
      q_params = {}
      q_params.merge! params.permit(:id, :financial_type)

      @fund_budgets = @fund.fund_budgets.default_where(q_params).page(params[:page])
    end

    def new
      @fund_budget = @fund.fund_budgets.build
    end

    def create
      @fund_budget = @fund.fund_budgets.build(fund_budget_params)

      unless @fund_budget.save
        render :new, locals: { model: @fund_budget }, status: :unprocessable_entity
      end
    end

    def show
    end

    def edit
    end

    def update
      @fund_budget.assign_attributes(fund_budget_params)

      unless @fund_budget.save
        render :edit, locals: { model: @fund_budget }, status: :unprocessable_entity
      end
    end

    def destroy
      @fund_budget.destroy
    end

    private
    def set_fund
      @fund = Fund.find params[:fund_id]
    end

    def set_fund_budget
      @fund_budget = @fund.fund_budgets.find(params[:id])
    end

    def fund_budget_params
      params.fetch(:fund_budget, {}).permit(
        :financial_type,
        :financial_id,
        :amount,
        :note
      )
    end

  end
end
