module Finance
  class Admin::FinancialTaxonsController < Admin::BaseController
    before_action :set_financial_taxon, only: [:show, :edit, :update, :destroy, :actions]
    before_action :set_new_financial_taxon, only: [:new, :create]
    before_action :prepare_form

    def index
      q_params = {}
      q_params.merge! default_ancestors_params
      q_params.merge! params.permit(:name)

      @financial_taxons = FinancialTaxon.roots.default_where(q_params).page(params[:page])
    end

    private
    def set_financial_taxon
      @financial_taxon = FinancialTaxon.find(params[:id])
    end

    def set_new_financial_taxon
      @financial_taxon = FinancialTaxon.new(financial_taxon_params)
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
end
