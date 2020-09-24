class Expense < ApplicationRecord
  include RailsFinance::Expense
  include RailsAudit::Audited
  include RailsAudit::CheckMachine
  include RailsVerify::Verified
end unless defined? Expense
