module Finance

  # 股权
  module Model::Stock
    extend ActiveSupport::Concern

    included do
      attribute :ratio, :decimal, precision: 4, scale: 2
      attribute :assess_amount, :decimal
      attribute :amount, :integer, default: 0, comment: '发行量'
      attribute :expense_amount, :integer, default: 0
      attribute :expense_detail, :json, default: {}
      attribute :note, :string

      belongs_to :member, class_name: 'Org::Member'  # 托管股东

      belongs_to :assessment

      before_validation :compute_assess_amount, if: -> { ratio_changed? }
    end

    def compute_assess_amount
      self.assess_amount = assessment.amount * ratio
    end

  end
end
