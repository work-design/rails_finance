class Finance::Admin::FundsController < Finance::Admin::BaseController
  before_action :set_fund, only: [:show, :edit, :update, :destroy]

  def index
    @funds = Fund.order(id: :asc).page(params[:page])
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
    params.fetch(:fund, {}).permit(
      :name,
      :budget_amount,
      :amount,
      :note
    )
  end

end
