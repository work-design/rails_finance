class FinancialTaxon < ApplicationRecord
  include RailsTaxon::Node
  include RailsFinance::FinancialTaxon
  include RailsVerify::Verifiable
end unless defined? FinancialTaxon
