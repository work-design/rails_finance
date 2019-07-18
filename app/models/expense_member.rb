class ExpenseMember < ApplicationRecord
  include RailsFinance::ExpenseMember
  include CheckMachine
  include RailsVip::Payout
end unless defined? ExpenseMember
