class Fund < ApplicationRecord
  include RailsFinance::Fund
  include RailsTrade::Sell if defined? RailsTrade
end unless defined? Fund
