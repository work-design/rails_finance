class Finance::Me::BudgetsController < Finance::Admin::BudgetsController
  include FinanceController::Me
  before_action :set_expense, only: [:show, :edit, :update, :requested, :transfer, :confirm, :bill, :destroy]
  before_action :prepare_form
  # after_action only: [:create, :update, :destroy] do
  #   mark_audits(Purchase, include: [:purchase_items], note: 'record test')
  # end

  def index
    q_params = {}
    q_params.merge! params.permit(:state)
    @budgets = current_member.budgets.default_where(q_params).page(params[:page])
  end

  def admin
    q_params = {
      verifier_id: current_member.id
    }
    q_params.merge! params.permit(:state, :id)

    @budgets = Budget.default_where(q_params).page(params[:page])
  end

  def new
    @budget = current_member.budgets.build
    @budget.expense_items.build(member_id: current_member.id)
    @taxon_options = []
  end

  def create
    @budget = current_member.budgets.build(expense_params)

    unless @budget.save
      render :new, locals: { model: @budget }, status: :unprocessable_entity
    end
  end

  def financial_taxons
    q = expense_params['expense_items_attributes'].each do |_, v|
      v.delete('id')
    end
    q.fetch('expense_members_attributes', {}).each do |_, v|
      v.delete('id')
    end
    @budget = current_member.budgets.build(q)
    @taxon_options = @budget.financial_taxon.children.map { |i| [i.name, i.id] }
  end

  def add_item
    @budget = current_member.budgets.build(type: params[:type], financial_taxon_id: params[:financial_taxon_id])
    if params[:item] == 'member'
      @budget.expense_members.build
    elsif params[:item] == 'item'
      if @budget.financial_taxon
        @taxon_options = @budget.financial_taxon.children.map { |i| [i.name, i.id] }
      else
        @taxon_options = []
      end
      @budget.expense_items.build
    end
  end

  def remove_item

  end

  def show
  end

  def edit
    @taxon_options = FinancialTaxon.roots.map { |i| [i.name, i.id] }
  end

  def update
    @budget.assign_attributes(expense_params)

    unless @budget.save
      render :edit, locals: { model: @budget }, status: :unprocessable_entity
    end
  end

  def transfer
    @budget.transfer(params[:type])
  end

  def confirm
    @payment_methods = PaymentMethod.where(myself: false)
    if @budget.type == 'PrepayExpense'
      @budget.expense_members.build(member_id: current_member.id, amount: @budget.amount)
    end
  end

  def requested
    @budget.request!
  end

  def bill
    disposition = params[:disposition] || 'inline'
    @pdf = PayoutExpensePdf.new(@budget.id)

    respond_to do |format|
      format.html
      format.js
      format.pdf { send_data @pdf.render, filename: 'bill_file', disposition: disposition, type: 'application/pdf' }
    end
  end

  def destroy
    @budget.destroy
  end

  private
  def set_expense
    @budget = Budget.find(params[:id])
  end

  def prepare_form
    q_params = {}
    q_params.merge! default_params

    @financial_taxons = FinancialTaxon.default_where(q_params)
  end

  def expense_params
    params.fetch(:budget, {}).permit(
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
