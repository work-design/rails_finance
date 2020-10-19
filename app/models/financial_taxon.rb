class FinancialTaxon < ApplicationRecord
  include RailsCom::Taxon
  include RailsFinance::FinancialTaxon
  include RailsAuditExt::Verifiable
end unless defined? FinancialTaxon
