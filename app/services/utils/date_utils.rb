# frozen_string_literal: true

class DateUtils
  def self.format_datetime(datetime)
    datetime.strftime('%Y-%m-%dT%H:%M:%SZ')
  end
end
