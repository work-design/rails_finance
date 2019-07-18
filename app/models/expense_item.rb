class ExpenseItem < ApplicationRecord
  include RailsFinance::ExpenseItem
end unless defined? ExpenseItem
