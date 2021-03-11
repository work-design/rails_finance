module Finance
  class Admin::FundsController < Admin::BaseController
    before_action :set_fund, only: [:show, :edit, :update, :destroy]

    def index
      q_params = {}
      q_params.merge! default_params

      @funds = Fund.default_where(q_params).order(id: :asc).page(params[:page])
    end

    def new
      @fund = Fund.new
    end

    def create
      @fund = Fund.new(fund_params)

      unless @fund.save
        render :new, locals: { model: @fund }, status: :unprocessable_entity
      end
    end

    def show
    end

    def edit
    end

    def update
      @fund.assign_attributes(fund_params)

      unless @fund.save
        render :edit, locals: { model: @fund }, status: :unprocessable_entity
      end
    end

    def destroy
      @fund.destroy
    end

    private
    def set_fund
      @fund = Fund.find(params[:id])
    end

    def fund_params
      p = params.fetch(:fund, {}).permit(
        :name,
        :budget_amount,
        :amount,
        :note
      )
      p.merge! default_form_params
    end

  end
end
