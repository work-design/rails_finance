module RailsFinance::FinancialTaxon
  extend ActiveSupport::Concern

  included do
    attribute :name, :string
    attribute :position, :integer
    attribute :take_stock, :boolean, default: false, comment: '是否有库存'
    attribute :individual, :boolean, default: false, comment: '是否可盘点'

    belongs_to :organ, optional: true
    has_many :expense_items, dependent: :nullify

    before_save :sync_verifier, if: -> { parent_id_changed? && parent }

    acts_as_list
  end

  private
  def sync_verifier
    self.individual ||= self.parent.individual
    self.take_stock ||= self.parent.take_stock
  end

end
