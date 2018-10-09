class Payout < ApplicationRecord

  belongs_to :payment_method
  belongs_to :payable, polymorphic: true
  has_one_attached :proof

  enum state: {
    done: 'done'
  }

  after_initialize do |_|
    self.payout_uuid ||= UidHelper.nsec_uuid('POT')
  end

  before_save :sync_state
  before_create :sync_payment_method

  def sync_state
    if requested_amount == actual_amount
      self.state = 'done'

      if advance
        payable.do_trigger(state: 'advance_paid')
      else
        payable.do_trigger(state: 'paid')
      end
    end
  end

  def sync_payment_method
    self.to_bank = payment_method.bank
    self.to_name = payment_method.account_name
    self.to_identifier = payment_method.account_num
  end

end