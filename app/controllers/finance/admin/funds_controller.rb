module Finance
  class Admin::FundsController < Admin::BaseController
    before_action :set_fund, only: [:show, :edit, :update, :destroy, :actions]

    def index
      q_params = {}
      q_params.merge! default_params

      @funds = Fund.default_where(q_params).order(id: :asc).page(params[:page])
    end

    private
    def set_fund
      @fund = Fund.find(params[:id])
    end

    def fund_params
      _p = params.fetch(:fund, {}).permit(
        :name,
        :budget_amount,
        :amount,
        :note
      )
      _p.merge! default_form_params
    end

  end
end
