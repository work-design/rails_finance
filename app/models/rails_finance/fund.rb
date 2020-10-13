module RailsFinance::Fund
  extend ActiveSupport::Concern

  included do
    attribute :name, :string
    attribute :budget, :decimal
    attribute :amount, :decimal
    attribute :note, :string

    has_one_attached :proof

    has_many :fund_incomes, dependent: :destroy
    has_many :fund_plans, dependent: :destroy
  end



end
