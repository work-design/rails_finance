class Budget < ApplicationRecord
  include RailsFinance::Budget
  include RailsAuditExt::Audited
  include RailsAuditExt::Verified
end unless defined? Budget
