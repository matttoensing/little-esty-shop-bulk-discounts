require 'rails_helper'

RSpec.describe Holiday do
  it 'exists and has attributes' do
    attributes = {
      :name => 'Labor Day',
      :date => '2021-09-06'
    }

    holiday = Holiday.new(attributes)

    expect(holiday).to be_an_instance_of(Holiday)
    expect(holiday.name).to eq('Labor Day')
    expect(holiday.date).to eq('2021-09-06')
  end
end
