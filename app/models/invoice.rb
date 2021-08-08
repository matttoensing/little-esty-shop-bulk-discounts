class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions
  has_many :merchants, through: :items

  enum status: { cancelled: 0,  "in progress"  => 1, completed: 2 }

  def self.incomplete_invoices
    joins(:invoice_items)
    .where.not('invoice_items.status = 2')
    .select('invoices.id, invoices.created_at')
    .order(:created_at)
    .distinct
  end

  def total_revenue
    invoice_items.sum('quantity * unit_price')
  end

  def discounted_revenue_using_discounts
    self.merchants.joins(:invoice_items).joins(:discounts).select(:invoice_items, :discounts).where('invoice_items.quantity >= discounts.quantity_threshold').distinct.sum('(invoice_items.quantity * invoice_items.unit_price) - ((invoice_items.quantity * invoice_items.unit_price) * discounts.percentage)').to_i
  end

  def discounted_revenue_no_discounts
    self.merchants.joins(:discounts).joins(:invoice_items).select(:invoice_items, :discounts).where('invoice_items.quantity < discounts.quantity_threshold').distinct.sum('(invoice_items.quantity * invoice_items.unit_price)').to_i
  end

  def discounted_revenue
    discounted_revenue_using_discounts + discounted_revenue_no_discounts
  end
end


# joins(:discounts).select(:invoice_items, :discounts).where('invoice_items.quantity >= discounts.quantity_threshold').distinct.sum('(invoice_items.quantity * invoice_items.unit_price) - ((invoice_items.quantity * invoice_items.unit_price) * discounts.percentage)').to_i
