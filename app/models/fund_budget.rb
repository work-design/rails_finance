class FundBudget < ApplicationRecord
  include RailsFinance::FundBudget
end unless defined? FundBudget
