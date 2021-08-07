require 'rails_helper'

RSpec.describe 'merchant discounts index page' do
  before(:each) do
    @merchant = create(:merchant)
    @discount1 = @merchant.discounts.create!(percentage: 0.10, quantity_threshold: 10)
    @discount2 = @merchant.discounts.create!(percentage: 0.20, quantity_threshold: 20)
    @discount3 = @merchant.discounts.create!(percentage: 0.30, quantity_threshold: 30)

    visit merchant_discounts_path(@merchant.id)
  end

  describe 'contents' do
    it 'displays each discount and attributes' do
      #unable to use view helper from html in test file, so math is done here to correctly represent discount value in test
      within "#discount-#{@discount1.id}" do
        expect(page).to have_content((@discount1.percentage * 100).to_i)
        expect(page).to have_content(@discount1.quantity_threshold)
      end

      within "#discount-#{@discount2.id}" do
        expect(page).to have_content((@discount2.percentage * 100).to_i)
        expect(page).to have_content(@discount2.quantity_threshold)
      end

      within "#discount-#{@discount3.id}" do
        expect(page).to have_content((@discount3.percentage * 100).to_i)
        expect(page).to have_content(@discount3.quantity_threshold)
      end
    end

    describe 'link to discount show page' do
      it 'each discount listed has a link to its show page' do
        within "#discount-#{@discount1.id}" do
          expect(page).to have_link('View Details')
        end

        within "#discount-#{@discount2.id}" do
          expect(page).to have_link('View Details')
        end
      end

      it 'when clicking on link, visitor is ' do
        within "#discount-#{@discount1.id}" do
          click_link 'View Details'
        end

        expect(current_path).to eq(merchant_discount_path(@merchant.id, @discount1.id))
      end
    end

    describe 'holidays content' do
      it 'displays the name and date of the next 3 upcoming holdays' do
        holidays = {
          "Labor Day" => "2021-09-06",
          "Columbus Day" => "2021-10-11",
          "Veterans Day" => "2021-11-11"
        }

        allow_any_instance_of(DateSwaggerService).to receive(:next_three_holidays).and_return(holidays)

        expect(page).to have_content("Upcoming Holidays")
        expect(page).to have_content(holidays.keys[0])
        expect(page).to have_content(holidays.keys[1])
        expect(page).to have_content(holidays.keys[2])
        expect(page).to have_content("Monday September 6, 2021")
        expect(page).to have_content("Monday October 11, 2021")
        expect(page).to have_content("Thursday November 11, 2021")
      end
    end

    describe 'creating a discount' do
      it 'displays a link to create a new discount and when clicking on this link, visitor is redirected to a new page' do
        expect(page).to have_link('New Discount')

        click_link 'New Discount'

        expect(current_path).to eq(new_merchant_discount_path(@merchant.id))
      end
    end
  end
end
