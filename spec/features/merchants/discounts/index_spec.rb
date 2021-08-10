require 'rails_helper'

RSpec.describe 'merchant discounts index page' do
  describe 'contents' do
    before(:each) do
      @merchant = create(:merchant)
      @discount1 = @merchant.discounts.create!(name: 'Labor Day Sale', percentage: 10, quantity_threshold: 10)
      @discount2 = @merchant.discounts.create!(name: 'Thanksgiving Day Sale', percentage: 20, quantity_threshold: 20)
      @discount3 = @merchant.discounts.create!(name: '3 Day Weekend Sale', percentage: 30, quantity_threshold: 30)

      visit merchant_discounts_path(@merchant.id)
    end

    describe 'contents' do
      it 'displays each discount and attributes' do
        #unable to use view helper from html in test file, so math is done here to correctly represent discount value in test
        within "#discount-#{@discount1.id}" do
          expect(page).to have_content(@discount1.name)
          expect(page).to have_content(@discount1.percentage.to_i)
          expect(page).to have_content("#{@discount1.quantity_threshold} items")
        end

        within "#discount-#{@discount2.id}" do
          expect(page).to have_content(@discount2.name)
          expect(page).to have_content(@discount2.percentage.to_i)
          expect(page).to have_content("#{@discount2.quantity_threshold} items")
        end

        within "#discount-#{@discount3.id}" do
          expect(page).to have_content(@discount3.name)
          expect(page).to have_content(@discount3.percentage.to_i)
          expect(page).to have_content("#{@discount3.quantity_threshold} items")
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

      describe 'creating a discount' do
        it 'displays a link to create a new discount and when clicking on this link, visitor is redirected to a new page' do
          expect(page).to have_link('New Discount')

          click_link 'New Discount'

          expect(current_path).to eq(new_merchant_discount_path(@merchant.id))
        end
      end

      describe 'deleting a discount' do
        it 'next to each discount is a link to delete the specific discount' do

          within "#discount-#{@discount1.id}" do
            expect(page).to have_link('Remove Discount')
          end

          within "#discount-#{@discount2.id}" do
            expect(page).to have_link('Remove Discount')
          end

          within "#discount-#{@discount3.id}" do
            expect(page).to have_link('Remove Discount')
          end
        end

        it 'when clicking the remove link, merchant is redirected back to dicount index page where discount information is no longer listed' do
          within "#discount-#{@discount1.id}" do
            click_link 'Remove Discount'
          end

          expect(current_path).to eq(merchant_discounts_path(@merchant.id))
          expect(page).to_not have_content(@discount1.percentage.to_i)
          expect(page).to_not have_content("#{@discount1.quantity_threshold} items")
        end
      end
    end
  end

  describe 'holiday discounts section' do
    before(:each) do
      Discount.destroy_all
      Merchant.destroy_all

      @merchant = create(:merchant)

      visit merchant_discounts_path(@merchant.id)
    end

    describe 'holidays content' do
      it 'displays the name and date of the next 3 upcoming holdays' do
        holidays = [
          {:date=>"2021-09-06", :name=>"Labor Day"},
          {:date=>"2021-10-11", :name=>"Columbus Day"},
          {:date=>"2021-11-11", :name=>"Veterans Day"}
        ]

        allow(DateSwaggerService).to receive(:next_three_holidays).and_return(holidays)

        expect(page).to have_content("Upcoming Holidays")
        expect(page).to have_content(holidays[0][:name])
        expect(page).to have_content('Monday September 6, 2021')
        expect(page).to have_content(holidays[1][:name])
        expect(page).to have_content('Monday October 11, 2021')
        expect(page).to have_content(holidays[2][:name])
        expect(page).to have_content('Thursday November 11, 2021')
      end
    end

    it 'in the holiday section, each holiday has a link to create a new holiday discount' do
      holiday1 = Holiday.new({name: 'Labor Day', date: '2021-09-06'})
      holiday2 = Holiday.new({name: 'Columbus Day', date: '2021-10-11'})
      holiday3 = Holiday.new({name: 'Veterans Day', date: '2021-11-11'})

      @holidays = [holiday1, holiday2, holiday3]

      allow(HolidayFacade).to receive(:holidays).and_return(@holidays)

      within "#holiday-#{holiday1.date}" do
        expect(page).to have_button(`Create Discount`)
      end

      within "#holiday-#{holiday2.date}" do
        expect(page).to have_button(`Create Discount`)
      end

      within "#holiday-#{holiday3.date}" do
        expect(page).to have_button(`Create Discount`)
      end
    end

    it 'can generate a form with prepopulated fields for merchant to create new holiday discount' do
      holiday1 = Holiday.new({name: 'Labor Day', date: '2021-09-06'})
      holiday2 = Holiday.new({name: 'Columbus Day', date: '2021-10-11'})
      holiday3 = Holiday.new({name: 'Veterans Day', date: '2021-11-11'})

      @holidays = [holiday1, holiday2, holiday3]

      allow(HolidayFacade).to receive(:holidays).and_return(@holidays)

      within "#holiday-#{holiday1.date}" do
        click_on 'Create Discount'
      end

      expect(page).to have_field(:name, with: 'Labor Day')
      expect(page).to have_field(:percentage, with: 30)
      expect(page).to have_field(:quantity_threshold, with: 2)

      click_on 'Submit'

      expect(current_path).to eq(merchant_discounts_path(@merchant.id))

      new_discount = Discount.last

      within "#discount-#{new_discount.id}" do
        expect(page).to have_content('Labor Day')
      end
      # As a merchant,
      # when I visit the discounts index page,
      # In the Holiday Discounts section, I see a `create discount` button next to each of the 3 upcoming holidays.
      # When I click on the button I am taken to a new discount form that has the form fields auto populated with the following:
      #
      # Discount name: <name of holiday> discount
      # Percentage Discount: 30
      # Quantity Threshold: 2
      #
      # I can leave the information as is, or modify it before saving.
      # I should be redirected to the discounts index page where I see the newly created discount added to the list of discounts.
    end
  end
end
