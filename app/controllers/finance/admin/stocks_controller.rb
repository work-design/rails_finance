module Finance
  class Admin::StocksController < Admin::BaseController
    before_action :set_assessment
    before_action :set_stock, only: [:show, :edit, :update, :destroy]

    def index
      @stocks = @assessment.stocks.order(id: :asc).page(params[:page])
    end

    def new
      @stock = @assessment.stocks.build(member: current_member)
    end

    def create
      @stock = @assessment.stocks.build(stock_params)
      @stock.member = current_member

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
    def set_assessment
      @assessment = Assessment.find params[:assessment_id]
    end

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
end
