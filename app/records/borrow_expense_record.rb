module PrepayExpenseRecord
  extend RailsData::Record

  config do
    object -> (params) { PrepayExpense.default_where(params).take }
    column :to, field: ->(o){ o.member.name }
    column :date, field: ->(o) { Date.today }, as: 'date'
  end

end
