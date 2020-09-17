class FinancialTaxon < ApplicationRecord
  include RailsTaxon::Node
  include RailsFinance::FinancialTaxon
end unless defined? FinancialTaxon
