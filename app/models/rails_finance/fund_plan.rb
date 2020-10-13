module RailsFinance::FundIncome
  extend ActiveSupport::Concern

  included do
    attribute :budget, :decimal

    belongs_to :fund
    belongs_to :financial, polymorphic: true, optional: true
  end

end
