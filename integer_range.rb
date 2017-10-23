##
# This class calculates privides subtraction and comparison operators for number ranges. Other
# type of ranges can inherit from this class but must translate the new type of range to integer.
class IntegerRange
  include Comparable

  attr_reader :lower, :upper

  def initialize(lower, upper)
    @lower = @lower || lower.to_i
    @upper = @upper || upper.to_i

    raise ArgumentError.new('Start cannot be greater than end') if @lower > @upper
  end

  ##
  # Subtracts two ranges of numbers from eachother and returns 0, 1, or 2 ranges as an array
  # depending on if the subtrahend was equal to, partialy intersecting, or a subset of the minuend
  # respectively.
  #
  # ==== Attributes
  #
  # * +:subtrahend+ - A IntegerRange object with the same class as this.
  #
  # ==== Examples
  #
  # IntegerRange.new(0, 3) - IntegerRange.new(0, 4) #=> []
  # IntegerRange.new(0, 3) - IntegerRange.new(1, 4) #=> [#<IntegerRange @lower: 0, @upper: 1>]
  # IntegerRange.new(0, 6) - IntegerRange.new(2, 4) #=> [#<IntegerRange @lower: 0, @upper: 2>, #<IntegerRange @lower: 4, @upper: 6>]
  def -(subtrahend)
    # The range is completely removed if the subtrahend is equal or a superset of self
    return [] if subtrahend.superset?(self) || subtrahend == self

    # If self is a superset of subtrahend, the subtrahend splits self.
    return [self.class.new(@lower, subtrahend.lower), self.class.new(subtrahend.upper, @upper)] if superset?(subtrahend)

    # If there is no intersection between both ranges, the minuend range is returned
    return [self.clone] if !intersect?(subtrahend)

    # Use the subtrahend to choose a new upper or lower bound depending on which side its on
    lower, upper = @upper > subtrahend.upper ? [subtrahend.upper, @upper] : [@lower, subtrahend.lower]

    return [self.class.new(lower, upper)]
  end

  ##
  # Returns true of both ranges have identical lower and upper range values and false otherwise.
  #
  # ==== Examples
  #
  # Range.new(0, 1) == Range.new(0, 1) #=> true
  # Range.new(0, 2) == Range.new(0, 1) #=> false
  def ==(range)
    @lower == range.lower && @upper == range.upper
  end

  ##
  # Sorts ranges first by their lower value, and then by their upper value.
  def <=>(range)
    lower_comparison = @lower <=> range.lower
    upper_comparison = @upper <=> range.upper

    compared = if lower_comparison == 0
                 if upper_comparison == 0
                   0
                 elsif upper_comparison == 1
                   1
                 elsif upper_comparison == -1
                   -1
                 end
               elsif lower_comparison == 1
                 1
               else
                 -1
               end

    return compared
  end

  ##
  # Returns true when there is any overlap of ranges
  #
  # ==== Attributes
  #
  # * :+range+ A range object to be compared to
  #
  # ==== Examples
  #
  # Range.new(0, 3).intersect?(Range.new(2, 4) #=> true
  # Range.new(0, 3).intersect?(Range.new(3, 5) #=> false
  def intersect?(range)
    return false if range.nil?

    (@lower <= range.lower && @upper > range.lower) ||
      (@lower < range.upper && @upper >= range.upper) ||
      (range.lower <= @lower && range.upper > @lower) ||
      (range.lower < @upper && range.upper >= @upper)
  end

  ##
  # Returns true when self completely encompases a range.
  #
  # ==== Attributes
  #
  # * :+range+ A range object to be compared to
  #
  # ==== Examples
  #
  # Range.new(0, 4).superset?(Range.new(1, 3) #=> true
  # Range.new(0, 4).superset?(Range.new(3, 5) #=> false
  def superset?(range)
    return false if self.length < range.length

    return true if self == range
    return true if @lower == range.lower && @upper > range.upper
    return true if @upper == range.upper && @lower < range.upper

    @lower < range.lower &&
      @upper > range.lower &&
      @lower < range.upper &&
      @upper > range.upper
  end

  ##
  # Returns the total length of the range.
  #
  # ==== Example
  #
  # Range.new(0,3).length #=> 3
  def length
    @upper - @lower
  end

  ##
  # Return a new Range with identical lower and upper values.
  def clone
    self.class.new(@lower, @upper)
  end
end
