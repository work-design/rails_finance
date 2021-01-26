module Finance
  module Model::FundIncome
    extend ActiveSupport::Concern

    included do
      attribute :amount, :decimal
      attribute :visible, :boolean, default: false
      attribute :note, :string

      enum state: {
        init: 'init',
        done: 'done'
      }, _default: 'init'

      belongs_to :fund
      belongs_to :user, optional: true
      belongs_to :financial, polymorphic: true, optional: true

      has_one_attached :proof

      after_save :sum_fund_amount, if: -> { saved_change_to_amount? }
    end

    def sum_fund_amount
      fund.sum_income_amount
      fund.save
    end

  end
end
