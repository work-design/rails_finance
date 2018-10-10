class Finance::Admin::PayoutsController < Finance::Admin::BaseController
  before_action :set_payout, only: [:show, :edit, :update, :destroy]

  def index
    q_params = {}.with_indifferent_access
    q_params.merge! params.permit(:id)
    q_params.merge! params.fetch(:q, {}).permit!
    @payouts = Payout.default_where(q_params).page(params[:page])
  end

  def new
    @payout = Payout.new
  end

  def create
    @payout = Payout.new(payout_params)

    if @payout.save
      redirect_to payouts_url, notice: 'Payout was successfully created.'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @payout.update(payout_params)
      redirect_to finance_payouts_url(id: @payout.id), notice: 'Payout was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @payout.destroy
    redirect_to payouts_url, notice: 'Payout was successfully destroyed.'
  end

  private
  def set_payout
    @payout = Payout.find(params[:id])
  end

  def payout_params
    p = params.fetch(:payout, {}).permit(
      :actual_amount,
      :payout_uuid,
      :to_bank,
      :to_name,
      :to_identifier,
      :proof
    )
    p.merge! operator_id: current_member.id
    p
  end

end
