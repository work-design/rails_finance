class Expense < ApplicationRecord
  include RailsFinance::Expense
  include RailsAudit::Audited
  include RailsAudit::CheckMachine
end unless defined? Expense
