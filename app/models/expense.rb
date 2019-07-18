class Expense < ApplicationRecord
  include RailsFinance::Expense
  include Auditable
  include CheckMachine
end unless defined? Expense
