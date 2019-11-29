module RailsFinance::FinancialTaxon
  extend ActiveSupport::Concern

  included do
    attribute :name, :string
    attribute :position, :integer
    attribute :take_stock, :boolean, default: false, comment: '是否有库存'
    attribute :individual, :boolean, default: false, comment: '是否可盘点'
  
    belongs_to :verifier, class_name: 'Member', optional: true
    has_many :expense_items, dependent: :nullify
  
    before_save :sync_verifier, if: -> { parent_id_changed? }
    
    acts_as_list
  end
  
  private
  def sync_verifier
    return if parent.nil?
    self.verifier_id ||= self.parent.verifier_id
    self.individual ||= self.parent.individual
    self.take_stock ||= self.parent.take_stock
  end

end
