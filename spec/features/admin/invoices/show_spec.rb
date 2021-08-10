require 'rails_helper'

RSpec.describe 'Admin Invoice Show Page' do
  before(:each) do
    @customer = create(:customer)

    @invoice = create(:invoice, customer_id: @customer.id)

    @merchant = create(:merchant)

    @item1 = create(:item, merchant_id: @merchant.id)
    @item2 = create(:item, merchant_id: @merchant.id)

    @invoice_item1 = create(:invoice_item, item_id: @item1.id, invoice_id: @invoice.id, status: 0)
    @invoice_item2 = create(:invoice_item, item_id: @item1.id, invoice_id: @invoice.id, status: 0)
    @invoice_item3 = create(:invoice_item, item_id: @item1.id, invoice_id: @invoice.id, status: 1)
    @invoice_item4 = create(:invoice_item, item_id: @item2.id, invoice_id: @invoice.id, status: 1)
    @invoice_item5 = create(:invoice_item, item_id: @item2.id, invoice_id: @invoice.id, status: 2)
    @invoice_item6 = create(:invoice_item, item_id: @item2.id, invoice_id: @invoice.id, status: 0)


    @transaction1 = create(:transaction, invoice_id: @invoice.id)
    @transaction2 = create(:transaction, invoice_id: @invoice.id)
    @transaction3 = create(:transaction, invoice_id: @invoice.id)
    @transaction4 = create(:transaction, invoice_id: @invoice.id)
    @transaction5 = create(:transaction, invoice_id: @invoice.id)
    @transaction6 = create(:transaction, invoice_id: @invoice.id)
    @transaction7 = create(:transaction, invoice_id: @invoice.id)

    visit admin_invoice_path(@invoice.id)
  end

  describe 'Admin Invoice Show Page' do
    it 'Displays an Invoice and its attributes' do

      expect(page).to have_content(@invoice.id)
      expect(page).to have_content(@invoice.status)
      expect(page).to have_content(@invoice.created_at.strftime("%A, %B, %d, %Y"))
      expect(page).to have_content("#{@customer.first_name} #{@customer.last_name}")
    end
  end

  describe 'Admin Invoice Show Page: Invoice Item Information' do
    it 'It displays Invoice Item attributes' do

      expect(page).to have_content(@item1.name)
      expect(page).to have_content(@invoice_item1.quantity)
      expect(page).to have_content(@item1.unit_price.to_f / 100)
      expect(page).to have_content(@invoice_item1.status)
    end
  end

  describe 'Admin Invoice Show Page: Total Revenue' do
    it 'displays the total revenue' do

      within('#totalrev') do

        expect(page).to have_content("Total Revenue: $#{(@invoice.total_revenue.to_f / 100)}")
      end
    end
  end

  describe 'Admin Invoice Show Page: Update Invoice Status' do
    it 'has a select field to change status' do

      within('#status') do
        expect(page).to have_content('Invoice Status: cancelled')
        expect(page).to have_content('cancelled')
      end

      page.select 'completed', from: "invoice[status]"

      click_on "Submit"
      expect(page).to have_content('Invoice Status: completed')
    end
  end

  describe 'bulk discount user stories' do
    describe 'total revenue and discounted revenue' do
      it 'displays total merchant revenue as well as discounted revenue on page' do

        InvoiceItem.destroy_all
        Item.destroy_all
        Transaction.destroy_all
        Invoice.destroy_all
        Customer.destroy_all
        Merchant.destroy_all

        merchant = create(:merchant)
        discount = create(:discount, merchant: merchant)
        item1 = create(:item, merchant: merchant, unit_price: 20)
        item2 = create(:item, merchant: merchant, unit_price: 45)
        customer = create(:customer)
        invoice = create(:invoice, customer: customer)
        transaction1 = create(:transaction, invoice: invoice)
        transaction2 = create(:transaction, invoice: invoice)
        invoice_item1 = create(:invoice_item, item: item1, invoice: invoice, unit_price: 20, quantity: 10)
        invoice_item2 = create(:invoice_item, item: item2, invoice: invoice, unit_price: 45, quantity: 5)

        visit admin_invoice_path(invoice.id)

        expect(page).to have_content(invoice.total_revenue_for_merchant(merchant.id))
        expect(page).to have_content(invoice.discounted_revenue(merchant.id))
# As an admin
# When I visit an admin invoice show page
# Then I see the total revenue from this invoice (not including discounts)
# And I see the total discounted revenue from this invoice which includes bulk discounts in the calculation
      end
    end
  end
end
