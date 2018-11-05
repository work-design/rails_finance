class Finance::Admin::ExpensesController < Finance::Admin::BaseController
  before_action :set_expense, only: [:show, :edit, :update, :trigger, :destroy]

  def index
    q_params = params.fetch(:q, {}).permit!
    q_params.merge! params.permit(:state, :id)
    @expenses = Expense.default_where(q_params).page(params[:page])
  end

  def my
    q_params = {
      verifier_id: current_member.id
    }
    q_params.merge! params.fetch(:q, {}).permit!
    q_params.merge! params.permit(:state, :id)
    @expenses = Expense.default_where(q_params).page(params[:page])

    render :my, layout: 'my'
  end

  def new
    @expense = Expense.new
  end

  def create
    @expense = Expense.new(expense_params)

    if @expense.save
      redirect_to finance_expenses_url, notice: 'Expense was successfully created.'
    else
      render :new
    end
  end

  def show
    @expense_members = @expense.expense_members
    @expense_items = @expense.expense_items.where(member_id: nil)
  end

  def edit
  end

  def update
    if @expense.update(expense_params)
      redirect_to finance_expense_url(@expense), notice: 'Expense was successfully updated.'
    else
      render :edit
    end
  end

  def next
    @expense.do_next(state: params[:state], auditor_id: current_member.id)
    redirect_to finance_expenses_url(member_id: @expense.member_id)
  end

  def trigger
    @expense.do_trigger(state: params[:state], auditor_id: current_member.id)
    redirect_to finance_expenses_url(member_id: @expense.member_id)
  end

  def destroy
    @expense.destroy
    redirect_to finance_expenses_url, notice: 'Expense was successfully destroyed.'
  end

  private
  def set_expense
    @expense = Expense.find(params[:id])
  end

  def expense_params
    params.fetch(:expense, {}).permit(:state)
  end

end