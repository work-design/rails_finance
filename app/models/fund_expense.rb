class FundExpense < ApplicationRecord
  include RailsFinance::FundExpense
end unless defined? FundExpense
