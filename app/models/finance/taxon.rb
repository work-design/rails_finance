module Finance
  class Taxon < ApplicationRecord
    include Com::Ext::Taxon
    include Model::Taxon
    include Auditor::Ext::Verifiable if defined? RailsAudit
  end
end
