class RangeList
  include Enumerable

  attr_reader :ranges

  ##
  # Instantiates a sorted RangeList object.
  #
  # ==== Attributes
  #
  # * +:ranges+ - A array of IntegerRange objects with no overlapping ranges
  def initialize(ranges)
    raise ArgumentError.new('All ranges must be an IntegerRange') unless ranges.all? { |range| range.is_a?(IntegerRange) }

    @ranges = ranges.sort

    intersecting_ranges = false

    @ranges.each_with_index do |range, i|
      previous_range = @ranges[i - 1] unless i == 0
      next_range = @ranges[i + 1] unless i == @ranges.size - 1

      intersecting_ranges = intersecting_ranges || range.intersect?(previous_range) || range.intersect?(next_range)
    end

    raise ArgumentError.new('Ranges cannot overlap in a list') if intersecting_ranges
  end

  def each(&block)
    @ranges.each { |member| block.call(member) }
  end

  ##
  # Subtracts two lists of ranges and returns a new list of ranges as the difference.
  #
  # ==== Attributes
  #
  # * +:subtrahend+ - A RangeList object that will subtract from this RangeList
  #
  # ==== Examples
  #
  # minuend = RangeList.new([IntegerRange.new(0,5), IntegerRange.new(5, 10)]
  # subtrahend = RangeList.new([IntegerRange.new(3,7)]
  #
  # minuend - subtrahend #=> RangeList.new([IntegerRange.new(0,3), IntegerRange.new(7, 10)]
  def -(subtrahend)
    RangeList.new(RangeList.subtract(@ranges, subtrahend.ranges))
  end

  private

  def self.subtract(minuend_list, subtrahend_list, difference_list = [])
    return difference_list if minuend_list.empty?
    return difference_list.push(*minuend_list) if subtrahend_list.empty?

    minuend = minuend_list.shift
    subtrahend = subtrahend_list.shift

    if minuend.intersect?(subtrahend)
      difference = minuend - subtrahend
      RangeList.subtract(minuend_list.unshift(*difference), subtrahend_list.unshift(subtrahend), difference_list)
    elsif minuend < subtrahend
      RangeList.subtract(minuend_list, subtrahend_list.unshift(subtrahend), difference_list.push(minuend))
    elsif subtrahend < minuend
      RangeList.subtract(minuend_list.unshift(minuend), subtrahend_list, difference_list)
    end
  end
end
