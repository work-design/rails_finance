class BudgetExpense < Expense
  include RailsFinance::Expense::BudgetExpense
end unless defined? BudgetExpense
