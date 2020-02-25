class PrepayExpense < Expense
  include RailsFinance::Expense::PrepayExpense
end unless defined? PrepayExpense
