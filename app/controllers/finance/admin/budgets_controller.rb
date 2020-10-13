class Finance::Admin::BudgetsController < Finance::Admin::BaseController
  before_action :set_budget, only: [:show, :edit, :update, :trigger, :destroy]

  def index
    q_params = {}
    q_params.merge! default_params
    q_params.merge! params.permit(:state, :id)

    @budgets = Budget.default_where(q_params).page(params[:page])
  end

  def new
    @budget = Budget.new
  end

  def create
    @budget = Budget.new(budget_params)

    unless @budget.save
      render :new, locals: { model: @budget }, status: :unprocessable_entity
    end
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
    @budget_members = @budget.budget_members
    @budget_items = @budget.budget_items.where(member_id: nil)
  end

  def edit
  end

  def update
    @budget.assign_attributes budget_params

    unless @budget.save
      render :edit, locals: { model: @budget }, status: :unprocessable_entity
    end
  end

  def next
    @budget.do_next(state: params[:state], auditor_id: current_member.id)
  end

  def trigger
    @budget.do_trigger(state: params[:state], auditor_id: current_member.id)
  end

  def destroy
    @budget.destroy
  end

  private
  def set_budget
    @budget = Budget.find params[:id]
  end

  def budget_params
    p = params.fetch(:budget, {}).permit(
      :state
    )
    p.merge! default_form_params
  end

end
