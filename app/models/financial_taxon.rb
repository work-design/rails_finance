class FinancialTaxon < ApplicationRecord
  include RailsTaxon::Node
  include RailsFinance::FinancialTaxon
  include RailsAudit::Verifiable
end unless defined? FinancialTaxon
