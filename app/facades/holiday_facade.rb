class HolidayFacade
  def self.holidays
    json = DateSwaggerService.next_three_holidays

    holidays = json.map do |member_data|
      Holiday.new(member_data)
    end
  end
end
