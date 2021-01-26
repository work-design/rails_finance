class FinancialTaxon < ApplicationRecord
  include Com::Ext::Taxon
  include RailsFinance::FinancialTaxon
  include Audited::Ext::Verifiable if defined? RailsAudit
end
