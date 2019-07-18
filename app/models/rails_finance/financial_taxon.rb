module RailsFinance::FinancialTaxon
  acts_as_list

  belongs_to :verifier, class_name: 'Member', optional: true
  has_many :expense_items, dependent: :nullify

  before_save :sync_verifier, if: -> { parent_id_changed? }

  private
  def sync_verifier
    return if parent.nil?
    self.verifier_id ||= self.parent.verifier_id
    self.individual ||= self.parent.individual
    self.take_stock ||= self.parent.take_stock
  end

end
