class Expense < ApplicationRecord
  include RailsFinance::Expense
  include RailsAuditExt::Audited
  include RailsAuditExt::Verified
end unless defined? Expense
