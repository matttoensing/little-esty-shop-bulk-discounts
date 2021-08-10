require 'rails_helper'

RSpec.describe InvoiceItem do
  before(:each) do
    @merchant_1 = create(:merchant)

    @customers = []
    @invoices = []
    @items = []
    @transactions = []
    @invoice_items = []

    5.times do
      @customers << create(:customer)
      @invoices << create(:invoice, customer_id: @customers.last.id, created_at: DateTime.new(2020,2,3,4,5,6))
      @items << create(:item, merchant_id: @merchant_1.id, unit_price: 20)
      @transactions << create(:transaction, invoice_id: @invoices.last.id)
      @invoice_items << create(:invoice_item, item_id: @items.last.id, invoice_id: @invoices.last.id, status: 1, quantity: 100, unit_price: @items.last.unit_price)
    end
  end

  describe 'relationships' do
    it { should belong_to(:item) }
    it { should belong_to(:invoice) }
  end

  describe 'validations' do
    it { should define_enum_for(:status).with([:pending, :packaged, :shipped]) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_presence_of(:quantity) }

    describe 'class methods' do
      describe '#total_revenue' do
        it 'can calculate the total revenue on an invoice' do
          expect(InvoiceItem.total_revenue).to eq(10000)
        end
      end
    end
  end

  describe 'bulk discount methods' do
    describe 'instance methods' do
      describe '#applied_discount' do
        it 'returns a discount if applied or nil if no discount is applied' do
          merchant1 = create(:merchant)
          discount1 = create(:discount, merchant: merchant1, percentage: 20)
          item1 = create(:item, merchant: merchant1, unit_price: 20)
          item2 = create(:item, merchant: merchant1, unit_price: 45)
          customer1 = create(:customer)
          invoice1 = create(:invoice, customer: customer1)
          transaction1 = create(:transaction, invoice: invoice1)
          transaction2 = create(:transaction, invoice: invoice1)
          invoice_item1 = create(:invoice_item, item: item1, invoice: invoice1, unit_price: 20, quantity: 10)
          invoice_item2 = create(:invoice_item, item: item2, invoice: invoice1, unit_price: 45, quantity: 5)

          expect(invoice_item1.applied_discount).to eq(discount1)
          expect(invoice_item2.applied_discount).to eq(nil)
        end
      end
    end
  end
end
