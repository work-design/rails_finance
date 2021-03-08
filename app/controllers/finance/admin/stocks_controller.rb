class Finance::Admin::StocksController < Finance::Admin::BaseController
  before_action :set_stock, only: [:show, :edit, :update, :destroy]

  def index
    @stocks = Stock.page(params[:page])
  end

  def new
    @stock = Stock.new
  end

  def create
    @stock = Stock.new(stock_params)

    unless @stock.save
      render :new, locals: { model: @stock }, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    @stock.assign_attributes(stock_params)

    unless @stock.save
      render :edit, locals: { model: @stock }, status: :unprocessable_entity
    end
  end

  def destroy
    @stock.destroy
  end

  private
  def set_stock
    @stock = Stock.find(params[:id])
  end

  def stock_params
    params.fetch(:stock, {}).permit(
      :ratio,
      :amount,
      :expense_amount,
      :note
    )
  end

end
