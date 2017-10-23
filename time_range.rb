require 'time'
require_relative 'integer_range'

##
# Subclass used to convert Time objects to Integer objects to leverage IntegerRange class

class TimeRange < IntegerRange

  ##
  # Turns a string into a TimeRange object
  #
  # ==== Attributes
  #
  # * +:string+ - A string in the format 'Time..Time'
  #
  # ==== Examples
  #
  # TimeRange.parse('2017-10-22 22:10:12 -0400..2017-10-23 22:10:12 -0400') #=> #<TimeRange>
  def self.parse(string)
    lower, upper = string.split('..').map { |time| Time.parse(time).to_i }

    TimeRange.new(lower, upper)
  end

  ##
  # Converts a TimeRange instance to a string
  #
  # ==== Examples
  # range = TimeRange.parse('2017-10-22 22:10:12 -0400..2017-10-23 22:10:12 -0400')
  # range.to_s #=> '2017-10-22 22:10:12 -0400..2017-10-23 22:10:12 -0400'
  def to_s
    "#{Time.at(@lower)}..#{Time.at(@upper)}"
  end
end
