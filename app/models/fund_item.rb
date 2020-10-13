class FundItem < ApplicationRecord
  include RailsFinance::FundItem
end unless defined? FundItem
