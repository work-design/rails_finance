module Finance
  class Me::ExpenseMembersController < Admin::ExpenseMembersController
    include FinanceController::Me
    skip_before_action :set_expense, only: [:index]
    before_action :set_expense_member, only: [:show, :items, :edit, :update, :bill]

    def index
      @expense_members = current_member.expense_members.page(params[:page])
    end

    def admin
      q_params = {
        'expense_member.verifier_id': current_member.id
      }
      q_params.merge! params.permit(:state, :id)

      @expense_members = ExpenseMember.default_where(q_params).page(params[:page])
    end

    def bill
      disposition = params[:disposition] || 'inline'
      if params[:type] == 'borrow'
        @pdf = BorrowExpensePdf.new(@expense_member.id)
      elsif params[:type] == 'reimburse'
        @pdf = PrepayExpensePdf.new(@expense_member.id)
      end
      respond_to do |format|
        format.html
        format.js
        format.pdf { send_data @pdf.render, filename: 'bill_file', disposition: disposition, type: 'application/pdf' }
      end
    end

    def items
      disposition = params[:disposition] || 'inline'

      respond_to do |format|
        format.html
        format.js
        format.xlsx { send_data @pdf.render, filename: 'bill_file', disposition: disposition, type: 'application/pdf' }
      end
    end

    def edit
      @payment_methods = current_member.payment_methods
    end

    private
    def set_expense_member
      @expense_member = ExpenseMember.find(params[:id])
    end

    def expense_member_params
      params.fetch(:expense_member, {}).permit(
        :amount,
        :advance,
        :financial_taxon_id,
        :note,
        :payment_method_id
      )
    end

  end
end
