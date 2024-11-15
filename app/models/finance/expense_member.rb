module Finance
  class ExpenseMember < ApplicationRecord
    include Model::ExpenseMember
    #include Trade::Model::Payout if defined? RailsTrade
  end
end
