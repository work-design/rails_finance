class ExpenseMember < ApplicationRecord
  include RailsFinance::ExpenseMember
  include RailsVip::Payout if defined? RailsVip
end unless defined? ExpenseMember
