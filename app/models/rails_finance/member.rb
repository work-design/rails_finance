module RailsFinance::Member
  extend ActiveSupport::Concern

  included do
    has_many :expense_members, dependent: :nullify
    has_many :expenses, through: :expense_members
    has_many :created_expenses, class_name: 'Expense', foreign_key: :creator_id
  end

end
