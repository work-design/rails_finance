class FinancialTaxon < ApplicationRecord
  include RailsTaxon::Node
  include RailsFinance::FinancialTaxon
  include RailsAuditExt::Verifiable
end unless defined? FinancialTaxon
