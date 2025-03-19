module Finance
  class Admin::BudgetsController < Admin::BaseController
    before_action :set_fund
    before_action :set_budget, only: [:show, :edit, :update, :trigger, :destroy]
    before_action :prepare_form

    def index
      q_params = {}
      q_params.merge! default_params
      q_params.merge! params.permit(:budget_id, :stock_id, :state, :id, :financial_type)

      @budgets = Budget.default_where(q_params).page(params[:page])
    end

    def show
      @budget_members = @budget.budget_members
      @budget_items = @budget.budget_items.where(member_id: nil)
    end

    def edit
      if @budget.expense_items.size == 0
        @budget.expense_items.build
      end
      @taxon_options = Taxon.roots.map { |i| [i.name, i.id] }
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
    def set_fund
      @fund = Fund.find params[:fund_id] if params[:fund_id]
    end

    def set_budget
      @budget = Budget.find params[:id]
    end

    def prepare_form
      q_params = {}
      q_params.merge! default_params

      @financial_taxons = Taxon.default_where(q_params)
    end

    def budget_params
      p = params.fetch(:budget, {}).permit(
        :state
      )
      p.merge! default_form_params
    end

  end
end
