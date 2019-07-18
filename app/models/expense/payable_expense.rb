class PayableExpense < Expense
  include RailsFinance::Expense::PayableExpense
end unless defined? PayableExpense
