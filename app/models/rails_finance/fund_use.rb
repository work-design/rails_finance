module RailsFinance::FundUse
  extend ActiveSupport::Concern

  included do
    attribute :budget_amount, :decimal
    attribute :amount, :decimal, default: 0
    attribute :note, :string

    belongs_to :fund
    belongs_to :financial, polymorphic: true, optional: true
  end

end
