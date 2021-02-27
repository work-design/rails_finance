module Finance
  class PayableExpense < Expense
    include Model::Expense::PayableExpense
  end
end
