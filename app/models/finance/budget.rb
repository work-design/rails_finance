module Finance
  class Budget < ApplicationRecord
    include Model::Budget
    include Audited::Ext::Audited
    include Audited::Ext::Verified
  end
end
