module Finance
  class Expense < ApplicationRecord
    include Model::Expense
    include Audited::Ext::Audited
    include Audited::Ext::Verified
  end
end
