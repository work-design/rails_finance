class Finance::My::ExpensesController < Finance::My::BaseController
  before_action :set_expense, only: [:show, :edit, :update, :requested, :transfer, :confirm, :bill, :destroy]
  # after_action only: [:create, :update, :destroy] do
  #   mark_audits(Purchase: [:purchase_items], note: 'record test')
  # end
  skip_before_action :verify_authenticity_token, only: [:financial_taxons] #todo removed

  def index
    q_params = params.fetch(:q, {}).permit!
    q_params.merge! params.permit(:state)
    @expenses = current_member.created_expenses.default_where(q_params).page(params[:page])
  end

  def new
    @expense = current_member.created_expenses.build(type: params[:type])
    @expense.expense_items.build(member_id: current_member.id)
    @taxon_options = []
  end

  def create
    @expense = current_member.created_expenses.build(expense_params)

    if @expense.save
      redirect_to my_expense_url(@expense), notice: 'Expense was successfully created.'
    else
      render :new
    end
  end

  def financial_taxons
    q = expense_params
    q['expense_items_attributes'].each do |_, v|
      v.delete('id')
    end
    q.fetch('expense_members_attributes', {}).each do |_, v|
      v.delete('id')
    end
    @expense = current_member.created_expenses.build(q)
    @taxon_options = @expense.financial_taxon.children.map { |i| [i.name, i.id] }

    respond_to do |format|
      format.js
      format.json { render json: { values: @results } }
    end
  end

  def add_item
    @expense = current_member.created_expenses.build(type: params[:type], financial_taxon_id: params[:financial_taxon_id])
    if params[:item] == 'member'
      @expense.expense_members.build
    elsif params[:item] == 'item'
      if @expense.financial_taxon
        @taxon_options = @expense.financial_taxon.children.map { |i| [i.name, i.id] }
      else
        @taxon_options = []
      end
      @expense.expense_items.build
    end
  end

  def remove_item

  end

  def show
  end

  def edit
    if @expense.expense_members.count == 0
      @expense.expense_members.build(member_id: current_member.id)
    end
    @payment_methods = current_member.payment_methods.where(myself: true)
    @taxon_options = FinancialTaxon.roots.map { |i| [i.name, i.id] }
  end

  def update
    @expense.assign_attributes(expense_params)
    if @expense.save
      redirect_to my_expense_url(@expense), notice: 'Expense was successfully updated.'
    else
      render :edit
    end
  end

  def transfer
    @expense.transfer(params[:type])
    redirect_to confirm_my_expense_url(@expense), notice: 'Purchase was successfully requested.'
  end

  def confirm
    @payment_methods = PaymentMethod.where(myself: false)
    if @expense.type == 'PrepayExpense'
      @expense.expense_members.build(member_id: current_member.id, amount: @expense.amount)
    end
  end

  def requested
    @expense.request!
    redirect_to my_expenses_url, notice: 'Purchase was successfully requested.'
  end

  def bill
    disposition = params[:disposition] || 'inline'
    @pdf = PayoutExpensePdf.new(@expense.id)

    respond_to do |format|
      format.html
      format.js
      format.pdf { send_data @pdf.render, filename: 'bill_file', disposition: disposition, type: 'application/pdf' }
    end
  end

  def destroy
    @expense.destroy
    redirect_to my_expenses_url, notice: 'Expense was successfully destroyed.'
  end

  private
  def set_expense
    @expense = Expense.find(params[:id])
  end

  def expense_params
    params.fetch(:expense, {}).permit(
      :subject,
      :type,
      :amount,
      :note,
      :proof,
      :financial_taxon_id,
      :payment_method_id,
      expense_members_attributes: {},
      expense_items_attributes: {}
    )
  end

end