module Finance

  # 股权
  module Model::Stock
    extend ActiveSupport::Concern

    included do
      attribute :ratio, :decimal, precision: 4, scale: 2
      attribute :amount, :decimal, default: 0, comment: '发行量'
      attribute :expense_amount, :decimal, default: 0
      attribute :expense_detail, :json, default: {}
      attribute :note, :string

      belongs_to :assessment
    end

  end
end
