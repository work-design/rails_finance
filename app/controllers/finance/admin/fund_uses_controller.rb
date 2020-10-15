class Finance::Admin::FundUsesController < Finance::Admin::BaseController
  before_action :set_fund
  before_action :set_fund_use, only: [:show, :edit, :update, :destroy]

  def index
    @fund_uses = @fund.fund_uses.page(params[:page])
  end

  def new
    @fund_use = @fund.fund_uses.build
  end

  def create
    @fund_use = @fund.fund_uses.build(fund_use_params)

    unless @fund_use.save
      render :new, locals: { model: @fund_use }, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    @fund_use.assign_attributes(fund_use_params)

    unless @fund_use.save
      render :edit, locals: { model: @fund_use }, status: :unprocessable_entity
    end
  end

  def destroy
    @fund_use.destroy
  end

  private
  def set_fund
    @fund = Fund.find params[:fund_id]
  end

  def set_fund_use
    @fund_use = @fund.fund_uses.find(params[:id])
  end

  def fund_use_params
    params.fetch(:fund_use, {}).permit(
      :financial_type,
      :financial_id,
      :budget_amount,
      :amount,
      :note
    )
  end

end
