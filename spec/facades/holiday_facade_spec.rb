require 'rails_helper'

RSpec.describe HolidayFacade do
  it 'can create holidays' do
    response = [
        {:date=>"2021-09-06", :name=>"Memorial Day"},
        {:date=>"2021-10-11", :name=>"Columbus Day"},
        {:date=>"2021-11-11", :name=>"Veterans Day"}
      ]

    allow(DateSwaggerService).to receive(:next_three_holidays).and_return(response)

    expect(HolidayFacade.holidays.first).to be_an_instance_of(Holiday)
    expect(HolidayFacade.holidays.first.name).to eq("Memorial Day")
    expect(HolidayFacade.holidays.first.date).to eq("2021-09-06")
    expect(HolidayFacade.holidays.count).to eq(3)
  end
end
