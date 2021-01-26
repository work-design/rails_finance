module Finance
  class Me::ExpensesController < Admin::ExpensesController
    include FinanceController::Me
    before_action :set_expense, only: [:show, :edit, :update, :submit, :confirm, :bill, :destroy]
    before_action :prepare_form
    # after_action only: [:create, :update, :destroy] do
    #   mark_audits(Purchase, include: [:purchase_items], note: 'record test')
    # end

    def index
      q_params = {}
      q_params.merge! params.permit(:state)

      @expenses = current_member.created_expenses.default_where(q_params).page(params[:page])
    end

    def admin
      q_params = {
        verifier_id: current_member.id
      }
      q_params.merge! params.permit(:state, :id)

      @expenses = Expense.default_where(q_params).page(params[:page])
    end

    def new
      @expense = current_member.created_expenses.build(type: params[:type])
      @expense.expense_items.build(member_id: current_member.id)
      @taxon_options = []
    end

    def create
      @expense = current_member.created_expenses.build(expense_params)

      unless @expense.save
        render :new, locals: { model: @expense }, status: :unprocessable_entity
      end
    end

    def financial_taxons
      q = expense_params['expense_items_attributes'].each do |_, v|
        v.delete('id')
      end
      q.fetch('expense_members_attributes', {}).each do |_, v|
        v.delete('id')
      end
      @expense = current_member.created_expenses.build(q)
      @taxon_options = @expense.financial_taxon.children.map { |i| [i.name, i.id] }
    end

    def add_item
      @expense = current_member.created_expenses.build(type: params[:type], financial_taxon_id: params[:financial_taxon_id])
      if @expense.financial_taxon
        @taxon_options = @expense.financial_taxon.children.map { |i| [i.name, i.id] }
      else
        @taxon_options = []
      end
      @expense.expense_items.build
    end

    def remove_item
    end

    def add_member
      @expense = current_member.created_expenses.build(type: params[:type], financial_taxon_id: params[:financial_taxon_id])
      @expense.expense_members.build
    end

    def remove_member
    end

    def show
    end

    def edit
      if @expense.expense_members.count == 0
        @expense.expense_members.build(member_id: current_member.id)
      end
      if current_member.respond_to? :payment_methods
        @payment_methods = current_member.payment_methods.where(myself: true)
      else
        @payment_methods = []
      end
      @taxon_options = FinancialTaxon.roots.map { |i| [i.name, i.id] }
    end

    def update
      @expense.assign_attributes(expense_params)

      unless @expense.save
        render :edit, locals: { model: @expense }, status: :unprocessable_entity
      end
    end

    def confirm
      @payment_methods = PaymentMethod.where(myself: false)
      if @expense.type == 'PrepayExpense'
        @expense.expense_members.build(member_id: current_member.id, amount: @expense.amount)
      end
    end

    def submit
      @expense.state = 'verifying' if @expense.init?
      @expense.save
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
    end

    private
    def set_expense
      @expense = Expense.find(params[:id])
    end

    def prepare_form
      q_params = {}
      q_params.merge! default_params

      @financial_taxons = FinancialTaxon.default_where(q_params)
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
end
