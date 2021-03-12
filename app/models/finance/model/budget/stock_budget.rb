module Finance
  module Model::Budget::StockBudget
    extend ActiveSupport::Concern

    included do
      attribute :amount, :integer
    end

  end
end
