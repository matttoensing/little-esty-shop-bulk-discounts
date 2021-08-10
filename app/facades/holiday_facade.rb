class HolidayFacade
  def self.holidays
    json = DateSwaggerService.next_three_holidays

    holidays = json.map do |holiday_info|
      Holiday.new(holiday_info)
    end
  end
end
