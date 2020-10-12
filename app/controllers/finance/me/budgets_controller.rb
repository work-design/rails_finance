class Finance::Me::BudgetsController < Finance::Admin::BudgetsController
  include FinanceController::Me
  before_action :set_budget, only: [:show, :edit, :update, :submit, :transfer, :bill, :destroy]
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
    @budget = current_member.budgets.build(budget_params)

    unless @budget.save
      render :new, locals: { model: @budget }, status: :unprocessable_entity
    end
  end

  def financial_taxons
    budget_params.fetch('expense_items_attributes', {}).each do |_, v|
      v.delete('id')
    end
    @budget = current_member.budgets.build(financial_taxon_id: budget_params[:financial_taxon_id])
    @financial_taxons = @budget.financial_taxon.children.map { |i| [i.name, i.id] }
  end

  def add_item
    @budget = current_member.budgets.build(financial_taxon_id: params[:financial_taxon_id])
    if @budget.financial_taxon
      @taxon_options = @budget.financial_taxon.children.map { |i| [i.name, i.id] }
    else
      @taxon_options = []
    end
    @budget.expense_items.build
  end

  def remove_item
  end

  def show
  end

  def edit
    @taxon_options = FinancialTaxon.roots.map { |i| [i.name, i.id] }
  end

  def update
    @budget.assign_attributes(budget_params)

    unless @budget.save
      render :edit, locals: { model: @budget }, status: :unprocessable_entity
    end
  end

  def transfer
    @budget.transfer(params[:type])
  end

  def submit
    @budget.state = 'verifying' if @budget.init?
    @budget.save
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
  def set_budget
    @budget = Budget.find params[:id]
  end

  def prepare_form
    q_params = {}
    q_params.merge! default_params

    @financial_taxons = FinancialTaxon.default_where(q_params)
  end

  def budget_params
    params.fetch(:budget, {}).permit(
      :subject,
      :amount,
      :note,
      :financial_taxon_id,
      expense_items_attributes: {}
    )
  end

end
