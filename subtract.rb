require_relative 'list_file'
require_relative 'time_range'
require_relative 'range_list'

string_to_range = -> (range) { TimeRange.parse(range) }

# Import range files and convert them to TimeRange objects.
minuend_ranges = ListFile.import(ARGV[0]).map(&string_to_range)
subtrahend_ranges = ListFile.import(ARGV[1]).map(&string_to_range)

# Instantiate RangeList objects to subtract
minuend_list = RangeList.new(minuend_ranges)
subtrahend_list = RangeList.new(subtrahend_ranges)
difference_list = minuend_list - subtrahend_list

# Export difference
ListFile.export(difference_list.map(&:to_s), ARGV[2])
