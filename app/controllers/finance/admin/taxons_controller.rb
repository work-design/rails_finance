module Finance
  class Admin::TaxonsController < Admin::BaseController
    before_action :set_taxon, only: [:show, :edit, :update, :destroy, :actions]
    before_action :set_new_taxon, only: [:new, :create]
    #before_action :prepare_form

    def index
      q_params = {}
      q_params.merge! default_ancestors_params
      q_params.merge! params.permit(:name)

      @taxons = Taxon.roots.default_where(q_params).page(params[:page])
    end

    private
    def set_taxon
      @taxon = Taxon.find(params[:id])
    end

    def set_new_taxon
      @taxon = Taxon.new(financial_taxon_params)
    end

    def prepare_form
      @financial_taxon_root = Taxon.new(default_form_params)
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
