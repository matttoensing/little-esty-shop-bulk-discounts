require 'rails_helper'

RSpec.describe 'merchant discounts index page' do
  describe 'contents' do
    it 'displays each discount and attributes' do
      merchant = create(:merchant)
      discount1 = merchant.discounts.create!(percentage: 0.10, quantity_threshold: 10)
      discount2 = merchant.discounts.create!(percentage: 0.20, quantity_threshold: 20)
      discount3 = merchant.discounts.create!(percentage: 0.30, quantity_threshold: 30)

      visit merchant_discounts_path(merchant.id)

      #unable to use view hlper from html in test file, so math is done here to correctly represent discount value in test
      within "#discount-#{discount1.id}" do
        expect(page).to have_content((discount1.percentage * 100).to_i)
        expect(page).to have_content(discount1.quantity_threshold)
      end

      within "#discount-#{discount2.id}" do
        expect(page).to have_content((discount2.percentage * 100).to_i)
        expect(page).to have_content(discount2.quantity_threshold)
      end

      within "#discount-#{discount3.id}" do
        expect(page).to have_content((discount3.percentage * 100).to_i)
        expect(page).to have_content(discount3.quantity_threshold)
      end
      
      # When I visit my merchant dashboard
      # Then I see a link to view all my discounts
      # When I click this link
      # Then I am taken to my bulk discounts index page
      # Where I see all of my bulk discounts including their
      # percentage discount and quantity thresholds
      # And each bulk discount listed includes a link to its show page
    end
  end
end
