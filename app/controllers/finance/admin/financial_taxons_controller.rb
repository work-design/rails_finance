class Finance::Admin::FinancialTaxonsController < Finance::Admin::BaseController
  before_action :set_financial_taxon, only: [:show, :edit, :update, :destroy]
  before_action :prepare_form

  def index
    q_params = {}
    q_params.merge! default_ancestors_params
    q_params.merge! params.permit(:name)

    @financial_taxons = FinancialTaxon.roots.default_where(q_params).page(params[:page])
  end

  def new
    @financial_taxon = FinancialTaxon.new(default_form_params)
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
    @financial_taxon.assign_attributes(financial_taxon_params)

    unless @financial_taxon.save
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

  def prepare_form
    @financial_taxon_root = FinancialTaxon.new(default_form_params)
  end

  def financial_taxon_params
    p = params.fetch(:financial_taxon, {}).permit(
      :name,
      :position,
      :verifier_id,
      :parent_id,
      :parent_ancestors,
      :individual,
      :take_stock
    )
    p.merge! default_form_params
  end

end
