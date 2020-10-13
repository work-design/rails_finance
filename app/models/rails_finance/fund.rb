module RailsFinance::Fund
  extend ActiveSupport::Concern

  included do
    attribute :budget, :decimal
    attribute :amount, :decimal
    attribute :visible, :boolean, default: true
    attribute :note, :string

    belongs_to :user
    belongs_to :financial, polymorphic: true, optional: true

    has_one_attached :proof

    after_save :sum_amount, if: -> { saved_change_to_amount? || saved_change_to_budget? }
  end

  def sum_amount
    project.compute_fund_budget_amount
    project.save
  end

end
