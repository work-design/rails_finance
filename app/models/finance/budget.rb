module Finance
  class Budget < ApplicationRecord
    include Model::Budget
    include Auditor::Ext::Audited
    include Auditor::Ext::Verified
  end
end
