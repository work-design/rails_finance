class Finance::Me::ExpenseMembersController < Finance::Me::BaseController
  before_action :set_expense_member, only: [:show, :items, :edit, :update, :bill]

  def index
    @expense_members = current_member.expense_members.page(params[:page])
  end

  def show
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

  def update
    unless @expense_member.update(expense_member_params)
      render :edit, locals: { model: @expense_member }, status: :unprocessable_entity
    end
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
