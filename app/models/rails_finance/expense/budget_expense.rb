module RailsFinance::Expense::BudgetExpense

  def transfer(type = self.next_state(:type))
    self.trigger_to type: type
    self.save
  end

  def next_type_states
    [
      'PrepayExpense',
      'PayableExpense'
    ]
  end

end
