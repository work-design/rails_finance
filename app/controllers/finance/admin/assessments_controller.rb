class Finance::Admin::AssessmentsController < Finance::Admin::BaseController
  before_action :set_assessment, only: [:show, :edit, :update, :destroy]

  def index
    @assessments = Assessment.page(params[:page])
  end

  def new
    @assessment = Assessment.new
  end

  def create
    @assessment = Assessment.new(assessment_params)

    unless @assessment.save
      render :new, locals: { model: @assessment }, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    @assessment.assign_attributes(assessment_params)

    unless @assessment.save
      render :edit, locals: { model: @assessment }, status: :unprocessable_entity
    end
  end

  def destroy
    @assessment.destroy
  end

  private
  def set_assessment
    @assessment = Assessment.find(params[:id])
  end

  def assessment_params
    params.fetch(:assessment, {}).permit(
      :amount
    )
  end

end
