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
    end

    describe 'link to discount show page' do
      it 'each discount listed has a link to its show page' do
        merchant = create(:merchant)
        discount1 = merchant.discounts.create!(percentage: 0.10, quantity_threshold: 10)
        discount2 = merchant.discounts.create!(percentage: 0.20, quantity_threshold: 20)

        visit merchant_discounts_path(merchant.id)

        within "#discount-#{discount1.id}" do
          expect(page).to have_link('View Details')
        end

        within "#discount-#{discount2.id}" do
          expect(page).to have_link('View Details')
        end
      end

      it 'when clicking on link, visitor is ' do
        merchant = create(:merchant)
        discount1 = merchant.discounts.create!(percentage: 0.10, quantity_threshold: 10)
        discount2 = merchant.discounts.create!(percentage: 0.20, quantity_threshold: 20)

        visit merchant_discounts_path(merchant.id)

        within "#discount-#{discount1.id}" do
          click_link 'View Details'
        end

        expect(current_path).to eq(merchant_discount_path(merchant.id, discount1.id))
      end
    end
  end
end
