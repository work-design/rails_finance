class ExpenseMember < ApplicationRecord
  include RailsFinance::ExpenseMember
  include RailsAudit::CheckMachine
  include RailsVip::Payout
end unless defined? ExpenseMember
