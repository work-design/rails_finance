module Finance
  class Admin::FundExpensesController < Admin::BaseController
    before_action :set_fund
    before_action :set_fund_expense, only: [:show, :edit, :update, :destroy]

    def index
      @fund_expenses = @fund.fund_expenses.page(params[:page])
    end

    def new
      @fund_expense = @fund.fund_expenses.build
    end

    def create
      @fund_expense = @fund.fund_expenses.build(fund_expense_params)

      unless @fund_expense.save
        render :new, locals: { model: @fund_expense }, status: :unprocessable_entity
      end
    end

    def show
    end

    def edit
    end

    def update
      @fund_expense.assign_attributes(fund_expense_params)

      unless @fund_expense.save
        render :edit, locals: { model: @fund_expense }, status: :unprocessable_entity
      end
    end

    def destroy
      @fund_expense.destroy
    end

    private
    def set_fund
      @fund = Fund.find params[:fund_id]
    end

    def set_fund_expense
      @fund_expense = @fund.fund_expenses.find(params[:id])
    end

    def fund_expense_params
      params.fetch(:fund_expense, {}).permit(
        :financial_type,
        :financial_id,
        :amount,
        :note
      )
    end

  end
end
