class Expense < ApplicationRecord
  include RailsFinance::Expense
  include RailsAudit::Auditable
  include RailsAudit::CheckMachine
end unless defined? Expense
