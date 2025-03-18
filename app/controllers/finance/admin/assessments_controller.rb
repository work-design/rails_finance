module Finance
  class Admin::AssessmentsController < Admin::BaseController
    before_action :set_assessment, only: [:show, :edit, :update, :destroy]

    def index
      q_params = {}
      q_params.merge! default_params

      @assessments = Assessment.default_where(q_params).page(params[:page])
    end

    private
    def set_assessment
      @assessment = Assessment.find(params[:id])
    end

    def assessment_params
      p = params.fetch(:assessment, {}).permit(
        :amount
      )
      p.merge! default_params
    end

  end
end
