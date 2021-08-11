class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions
  has_many :merchants, through: :items
  has_many :discounts, through: :merchants

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

  def item_ids(items)
    items.map { |item| item.id }
  end

  def total_revenue_for_merchant(merchant_id)
    self.items.joins(:invoice_items).where("invoice_items.item_id IN (?) AND items.merchant_id IN (?)", item_ids(self.items), merchant_id).distinct.sum('invoice_items.quantity * invoice_items.unit_price')
  end

  def item_discount(invoice_item_id)
    it = InvoiceItem.find(invoice_item_id)
    item = Item.find(it.item_id)
    merchant = item.merchant

    max_percentage = merchant.discounts.where('discounts.quantity_threshold <= ?', it.quantity).maximum(:percentage)

    max_percentage.nil? ? 0.0 : max_percentage
  end

  def discounted_amount(invoice_item_id)
    it = InvoiceItem.find(invoice_item_id)

    ((it.quantity * it.unit_price).to_f - ((it.quantity * it.unit_price) * (item_discount(it.id) / 100)))
  end

  def calculate_discounted_revenue(invoice_items)
    invoice_items.sum { |item| discounted_amount(item.id) }
  end

  def discounted_revenue(merchant_id)
    merchant = Merchant.find(merchant_id)
    items = merchant.items
    invoice_items = self.invoice_items.where(item_id: item_ids(items))

    merchant.discounts.empty? ? total_revenue_for_merchant(merchant_id) : calculate_discounted_revenue(invoice_items)
  end

  def discounted_revenue_for_admin
    invoice_items = self.invoice_items
    calculate_discounted_revenue(invoice_items)
  end

  def update_invoice_items(invoice_items)
    invoice_items.each do |it|
      it.update!(discount: item_discount(it.id))
    end
  end
end

# self.invoice_items.joins(:items { merchant: :discounts} ).select(:invoice_items, :discounts).where('invoice_items.quantity >= discounts.quantity_threshold').distinct.sum('(invoice_items.quantity * invoice_items.unit_price) - ((invoice_items.quantity * invoice_items.unit_price) * discounts.percentage)').to_i

 # self.merchants.joins(:invoice_items).joins(:discounts).select(:invoice_items, :discounts).where('invoice_items.quantity >= discounts.quantity_threshold').distinct.sum('(CASE
 #               WHEN invoice_items.quantity >= discounts.quantity_threshold
 #                  THEN SUM(invoice_items.quantity * invoice_items.unit_price) - ((invoice_items.quantity * invoice_items.unit_price) * discounts.percentage)
 #               END))').to_i


# joins(:discounts).select(:invoice_items, :discounts).where('invoice_items.quantity >= discounts.quantity_threshold').distinct.sum('(invoice_items.quantity * invoice_items.unit_price) - ((invoice_items.quantity * invoice_items.unit_price) * discounts.percentage)').to_i


# self.merchants.joins(:invoice_items).joins(:discounts).group('invoice_items.id, discounts.id').select('invoice_items.*, discounts.*, (CASE
#               WHEN invoice_items.quantity >= discounts.quantity_threshold
#                  THEN SUM(invoice_items.quantity * invoice_items.unit_price) - ((invoice_items.quantity * invoice_items.unit_price) * discounts.percentage)
#               ELSE SUM(invoice_items.quantity * invoice_items.unit_price)
#               END) AS revenue')
#
# count = 0
# x = discounts.uniq.sort {|a, b| b <=> a }
# x.each do |discount|
#   invoice_items.uniq.each do |it|
#     if it.quantity >= discount.quantity_threshold
#       count += ((it.quantity * it.unit_price) - ((it.quantity * it.unit_price) * discount.percentage))
#       invoice_items.delete(it)
#     end
#   end
# end
#
# count = 0
# x = discounts.uniq.sort {|a, b| b <=> a }
# x.each do |discount|
#   invoice_items.uniq.each do |it|
#       count += ((it.quantity * it.unit_price) - ((it.quantity * it.unit_price) * discount.percentage))if it.quantity >= discount.quantity_threshold
#     end
#   end

# count.to_i

# self.merchants.joins(:discounts)
# .joins(:invoice_items)
# .select(:invoice_items, :discounts)
# .where('invoice_items.quantity >= discounts.quantity_threshold').distinct
# .sum('(invoice_items.quantity * invoice_items.unit_price) - ((invoice_items.quantity * invoice_items.unit_price) * discounts.percentage)').to_i
