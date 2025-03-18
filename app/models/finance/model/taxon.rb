module Finance
  module Model::Taxon
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :position, :integer
      attribute :take_stock, :boolean, default: false, comment: '是否有库存'
      attribute :individual, :boolean, default: false, comment: '是否可盘点'

      belongs_to :organ, class_name: 'Org::Organ', optional: true

      has_many :expense_items, dependent: :nullify

      before_save :sync_verifier, if: -> { parent_id_changed? && parent }

      positioned
    end

    private
    def sync_verifier
      self.individual ||= self.parent.individual
      self.take_stock ||= self.parent.take_stock
    end

  end
end
