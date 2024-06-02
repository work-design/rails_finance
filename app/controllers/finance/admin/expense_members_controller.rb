module Finance
  class Admin::ExpenseMembersController < Admin::BaseController
    before_action :set_expense, only: [:index]
    before_action :set_expense_member, only: [:show, :edit, :update, :to_advance_pay, :to_pay, :destroy]

    def index
      @expense_members = @expense.expense_members.page(params[:page])
    end

    def to_advance_pay
      unless @expense_member.to_advance_payout
        render :edit, locals: { model: @expense_member }, status: :unprocessable_entity
      end
    end

    def to_pay
      unless @expense_member.to_payout
        render :edit, locals: { model: @expense_member }, status: :unprocessable_entity
      end
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
end
