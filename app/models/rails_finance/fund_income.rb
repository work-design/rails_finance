module RailsFinance::FundIncome
  extend ActiveSupport::Concern

  included do
    attribute :name, :string
    attribute :visible, :boolean, default: false
    attribute :amount, :decimal

    belongs_to :fund
    belongs_to :user, optional: true
    belongs_to :financial, polymorphic: true, optional: true

    has_one_attached :proof
  end

end
