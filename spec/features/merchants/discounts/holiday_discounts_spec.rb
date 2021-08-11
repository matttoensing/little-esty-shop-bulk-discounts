require 'rails_helper'

RSpec.describe 'creating a new holiday discount' do
  describe 'holiday discounts section on merchant discounts index page' do
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

    describe 'creating a holiday discount' do
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
      end

      it 'merchant can change fields on form instead of using default values' do
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

        fill_in :percentage, with: 20
        click_on 'Submit'

        expect(current_path).to eq(merchant_discounts_path(@merchant.id))

        new_discount = Discount.last

        within "#discount-#{new_discount.id}" do
          expect(page).to have_content('Labor Day')
          expect(page).to have_content(20)
        end
      end
    end

    describe 'after merchant creates a holiday discount' do
      it 'the link to create this discount no longer appears, and a link to view the discount in shown instead' do
        holiday1 = Holiday.new({name: 'Labor Day', date: '2021-09-06'})
        holiday2 = Holiday.new({name: 'Columbus Day', date: '2021-10-11'})
        holiday3 = Holiday.new({name: 'Veterans Day', date: '2021-11-11'})

        @holidays = [holiday1, holiday2, holiday3]

        allow(HolidayFacade).to receive(:holidays).and_return(@holidays)

        within "#holiday-#{holiday1.date}" do
          click_on 'Create Discount'
        end

        click_on 'Submit'

        within "#holiday-#{holiday1.date}" do
          expect(page).to_not have_button('Create Discount')
          expect(page).to have_button('View Discount')
        end
      end
    end
  end
end
