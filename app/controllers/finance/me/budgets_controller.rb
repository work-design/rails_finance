module Finance
  class Me::BudgetsController < Admin::BudgetsController
    include FinanceController::Me
    before_action :set_budget, only: [:show, :edit, :update, :submit, :transfer, :bill, :destroy]
    before_action :set_taxons
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
      @budget.expense_items.build

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

    def edit
      @taxon_options = FinancialTaxon.roots.map { |i| [i.name, i.id] }
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

    private
    def set_budget
      @budget = Budget.find params[:id]
    end

    def set_taxons
      q_params = {}
      q_params.merge! default_params

      @taxons = Taxon.default_where(q_params)
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
end
