class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice

  validates :unit_price, presence: true
  validates :quantity, presence: true

  enum status: {pending: 0, packaged: 1, shipped: 2}

  def self.total_revenue
    sum("unit_price * quantity")
  end

  def applied_discount
    self.item.merchant.discounts.where("#{self.quantity} >= quantity_threshold").order(quantity_threshold: :desc).first
  end
end
