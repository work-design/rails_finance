module Finance

  # 估值
  module Model::Assessment
    extend ActiveSupport::Concern

    included do
      attribute :amount, :decimal, default: 0
      attribute :trustee_amount, :decimal

      belongs_to :organ, class_name: 'Org::Organ'

      has_many :stocks

      after_save :sync_assess_amount, if: -> { saved_change_to_amount? }
    end

    def sync_assess_amount
      stocks.each do |stock|
        stock.update assess_amount: amount * stock.ratio
      end
      self.update trustee_amount: stocks.sum(:assess_amount)
    end

  end
end
