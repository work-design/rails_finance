module RailsFinance::Expendable
  extend ActiveSupport::Concern

  included do
    has_many :expenses, as: :expendable
  end

end
