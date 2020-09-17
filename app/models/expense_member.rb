class ExpenseMember < ApplicationRecord
  include RailsFinance::ExpenseMember
  include RailsAudit::CheckMachine
  include RailsVip::Payout if defined? RailsVip
end unless defined? ExpenseMember
