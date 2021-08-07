require 'rails_helper'

RSpec.describe 'edit discount information' do
  describe 'form to edit merchant discount' do
    it 'displays a form with fields pre populated with discount information' do
      merchant = create(:merchant)
      discount = merchant.discounts.create!(percentage: 10, quantity_threshold: 10)

      visit edit_merchant_discount_path(merchant.id, discount.id)

      expect(page).to have_field(:percentage, with: 10.0)
      expect(page).to have_field(:quantity_threshold, with: 10)
    end

    it 'merchant can edit any/all fields to edit discount and click on submit to redirect to the discount show page' do
      merchant = create(:merchant)
      discount = merchant.discounts.create!(percentage: 10, quantity_threshold: 15)

      visit edit_merchant_discount_path(merchant.id, discount.id)

      fill_in :percentage, with: 20
      click_on 'Edit Discount'

      expect(current_path).to eq(merchant_discount_path(merchant.id, discount.id))
      expect(page).to_not have_content(10)
      expect(page).to have_content(20)
      expect(page).to have_content(discount.quantity_threshold)
      # As a merchant
      # When I visit my bulk discount show page
      # Then I see a link to edit the bulk discount
      # When I click this link
      # Then I am taken to a new page with a form to edit the discount
      # And I see that the discounts current attributes are pre-populated in the form
      # When I change any/all of the information and click submit
      # Then I am redirected to the bulk discount's show page
      # And I see that the discount's attributes have been updated
    end
  end
end
