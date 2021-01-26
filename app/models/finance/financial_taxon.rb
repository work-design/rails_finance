module Finance
  class FinancialTaxon < ApplicationRecord
    include Com::Ext::Taxon
    include Model::FinancialTaxon
    include Audited::Ext::Verifiable if defined? RailsAudit
  end
end
