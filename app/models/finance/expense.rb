module Finance
  class Expense < ApplicationRecord
    include Model::Expense
    include Auditor::Ext::Audited
    include Auditor::Ext::Verified
  end
end
