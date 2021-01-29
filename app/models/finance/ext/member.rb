module Finance
  module Ext::Member
    extend ActiveSupport::Concern

    included do
      has_many :expense_members, class_name: 'Finance::ExpenseMember', dependent: :nullify
      has_many :expenses, class_name: 'Finance::Expense', through: :expense_members
      has_many :created_expenses, class_name: 'Finance::Expense', foreign_key: :creator_id
      has_many :budgets, class_name: 'Finance::Budget'
    end

  end
end
