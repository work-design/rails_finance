module RailsFinance::FundIncome
  extend ActiveSupport::Concern

  included do
    attribute :name, :string
    attribute :visible, :boolean, default: false

    belongs_to :fund
    belongs_to :user, optional: true
    belongs_to :financial, polymorphic: true, optional: true
  end

end
