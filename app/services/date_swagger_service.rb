class DateSwaggerService
  def self.get_holidays
    response = Faraday.get 'https://date.nager.at/api/v3/NextPublicHolidays/us'

    JSON.parse(response.body)
  end

  def self.next_three_holidays_names
    names = get_holidays.map do |hash|
      hash["localName"]
    end
    names[0..2]
  end

  def self.next_three_holidays_dates
    dates = get_holidays.map do |hash|
      hash["date"]
    end
    dates[0..2]
  end

  def self.next_three_holidays
    holidays = []
    next_three_holidays_names.each do |name|
      holidays << {name: name, date: next_three_holidays_dates[next_three_holidays_names.index(name)]}
    end
    holidays
  end
end
