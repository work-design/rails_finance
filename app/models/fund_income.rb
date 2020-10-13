class FundIncome < ApplicationRecord
  include RailsFinance::FundIncome
end unless defined? FundIncome
