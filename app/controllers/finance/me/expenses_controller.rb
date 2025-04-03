module Finance
  class Me::ExpensesController < Admin::ExpensesController
    before_action :set_expense, only: [:show, :edit, :update, :submit, :confirm, :bill, :destroy]
    before_action :set_taxons
    before_action :set_new_expense, only: [:new, :create]
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
      @expense.expense_items.build
      @expense.expense_members.build(member_id: current_member.id)
      @taxon_options = []
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

    def confirm
      @payment_methods = Trade::PaymentMethod.where(myself: false)
      if @expense.type == 'Finance::PrepayExpense'
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

    private
    def set_expense
      @expense = Expense.find(params[:id])
    end

    def set_new_expense
      @expense = current_member.created_expenses.build(expense_params)
    end

    def set_taxons
      q_params = {}
      q_params.merge! default_params

      @taxons = Taxon.default_where(q_params)
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
