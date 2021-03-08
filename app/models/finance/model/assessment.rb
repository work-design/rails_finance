module Finance

  # 估值
  module Model::Assessment
    extend ActiveSupport::Concern

    included do
      attribute :amount, :decimal, default: 0

      belongs_to :organ, class_name: 'Org::Organ'
    end

  end
end
