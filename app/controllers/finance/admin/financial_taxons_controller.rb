class Finance::Admin::FinancialTaxonsController < Finance::Admin::BaseController
  before_action :set_financial_taxon, only: [:show, :edit, :update, :destroy]

  def index
    q_params = {}.with_indifferent_access
    q_params.merge! params.fetch(:q, {}).permit!
    @financial_taxons = FinancialTaxon.roots.default_where(q_params).page(params[:page])
  end

  def new
    @financial_taxon = FinancialTaxon.new
  end

  def create
    @financial_taxon = FinancialTaxon.new(financial_taxon_params)

    unless @financial_taxon.save
      render :new, locals: { model: @financial_taxon }, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    unless @financial_taxon.update(financial_taxon_params)
      render :edit, locals: { model: @financial_taxon }, status: :unprocessable_entity
    end
  end

  def destroy
    @financial_taxon.destroy
  end

  private
  def set_financial_taxon
    @financial_taxon = FinancialTaxon.find(params[:id])
  end

  def financial_taxon_params
    params.fetch(:financial_taxon, {}).permit(
      :name,
      :position,
      :verifier_id,
      :parent_id,
      :parent_ancestors,
      :individual,
      :take_stock
    )
  end

end
