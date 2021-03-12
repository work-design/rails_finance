module Finance
  class Admin::ExpensesController < Admin::BaseController
    before_action :set_fund
    before_action :set_expense, only: [:show, :edit, :update, :trigger, :destroy]

    def index
      q_params = {}
      q_params.merge! default_params
      q_params.merge! params.permit(:state, :id, :fund_id, :stock_id)

      @expenses = Expense.default_where(q_params).page(params[:page])
    end

    def new
      @expense = Expense.new
    end

    def create
      @expense = Expense.new(expense_params)

      unless @expense.save
        render :new, locals: { model: @expense }, status: :unprocessable_entity
      end
    end

    def show
      @expense_members = @expense.expense_members
      @expense_items = @expense.expense_items.where(member_id: nil)
    end

    def edit
    end

    def update
      @expense.assign_attributes expense_params

      unless @expense.save
        render :edit, locals: { model: @expense }, status: :unprocessable_entity
      end
    end

    def next
      @expense.do_next(state: params[:state], auditor_id: current_member.id)
    end

    def trigger
      @expense.do_trigger(state: params[:state], auditor_id: current_member.id)
    end

    def destroy
      @expense.destroy
    end

    private
    def set_fund
      @fund = Fund.find params[:fund_id] if params[:fund_id]
    end

    def set_expense
      @expense = Expense.find(params[:id])
    end

    def expense_params
      p = params.fetch(:expense, {}).permit(
        :state
      )
      p.merge! default_form_params
    end

  end
end
