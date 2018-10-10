class Finance::Admin::ExpenseMembersController < Finance::Admin::BaseController
  before_action :set_expense, only: [:index]
  before_action :set_expense_member, only: [:show, :edit, :update, :to_advance_pay, :to_pay, :destroy]

  def index
    @expense_members = @expense.expense_members.page(params[:page])
  end

  def my
    q_params = {
      'expense_member.verifier_id': current_member.id
    }
    q_params.merge! params.fetch(:q, {}).permit!
    q_params.merge! params.permit(:state, :id)
    @expense_members = ExpenseMember.default_where(q_params).page(params[:page])

    render :my, layout: 'my'
  end

  def show
  end

  def edit
  end

  def update
    if @expense_member.update(expense_member_params)
      redirect_to finance_expense_expense_members_url(@expense_member.expense_id), notice: 'Expense member was successfully updated.'
    else
      render :edit
    end
  end

  def to_advance_pay
    if @expense_member.to_advance_payout
      redirect_to finance_expense_expense_members_url(@expense_member.expense_id), notice: 'Expense member was successfully updated.'
    else
      render :edit
    end
  end

  def to_pay
    if @expense_member.to_payout
      redirect_to finance_expense_expense_members_url(@expense_member.expense_id), notice: 'Expense member was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @expense_member.destroy
    redirect_to finance_expense_expense_members_url(@expense_member.expense_id), notice: 'Expense member was successfully destroyed.'
  end

  private
  def set_expense
    @expense = Expense.find params[:expense_id]
  end

  def set_expense_member
    @expense_member = ExpenseMember.find(params[:id])
    @expense = @expense_member.expense
  end

  def expense_member_params
    params.fetch(:expense_member, {}).permit(
      :state,
      :payment_method_id,
      :advance
    )
  end

end
