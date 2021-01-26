module Finance
  class FinancialTaxon < ApplicationRecord
    include Com::Ext::Taxon
    include Model::FinancialTaxon
    include Auditor::Ext::Verifiable if defined? RailsAudit
  end
end
