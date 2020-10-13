module RailsFinance::Fund
  extend ActiveSupport::Concern

  included do
    attribute :name, :string
    attribute :budget, :decimal
    attribute :amount, :decimal
    attribute :note, :string
    attribute :x

    has_one_attached :proof

  end



end
