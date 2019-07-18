class FinancialTaxon < ApplicationRecord
  prepend RailsTaxon::Node
  include RailsFinance::FinancialTaxon
end unless defined? FinancialTaxon
