require_relative 'list_file'
require_relative 'time_range'
require_relative 'range_list'

class TestCase
  class << self
    def test_sort_puts_smallest_lower_first
      range_one = IntegerRange.new(0, 4)
      range_two = IntegerRange.new(1, 3)

      output = [range_one, range_two]

      raise ScriptError unless [range_two, range_one].sort == output
      raise ScriptError unless [range_one, range_two].sort == output
    end

    def test_identical_lower_and_upper_are_equal
      range_one = IntegerRange.new(0, 3)
      range_two = IntegerRange.new(0, 3)

      output = [range_two, range_one]

      raise ScriptError unless [range_two, range_one].sort == output
    end

    def test_equal_lower_sorts_by_upper
      range_one = IntegerRange.new(1, 4)
      range_two = IntegerRange.new(1, 3)

      output = [range_one, range_two].sort

      raise ScriptError unless [range_one, range_two].sort == output
      raise ScriptError unless [range_two, range_one].sort == output
    end

    def test_inequality_when_ranges_are_different
      range_one = IntegerRange.new(0, 2)
      range_two = IntegerRange.new(0, 3)

      raise ScriptError unless range_one != range_two
    end

    def test_equality_when_lower_and_upper_are_equal
      range_one = IntegerRange.new(0, 2)
      range_two = IntegerRange.new(0, 2)

      raise ScriptError unless range_one == range_two
    end

    def test_exclusion_when_ranges_dont_overlap
      range_one = IntegerRange.new(0, 2)
      range_two = IntegerRange.new(4, 6)

      raise ScriptError unless !range_one.intersect?(range_two)
    end

    def test_intersection_when_ranges_are_identical
      range_one = IntegerRange.new(0, 6)
      range_two = IntegerRange.new(0, 6)

      raise ScriptError unless range_one.intersect?(range_two)
    end

    def test_intersect_when_superset
      range_one = IntegerRange.new(0, 6)
      range_two = IntegerRange.new(2, 4)

      raise ScriptError unless range_one.intersect?(range_two)
    end

    def test_intersect_when_subset
      range_one = IntegerRange.new(2, 4)
      range_two = IntegerRange.new(0, 6)

      raise ScriptError unless range_one.intersect?(range_two)
    end

    def test_intersect_when_range_overlaps_to_right
      range_one = IntegerRange.new(0, 6)
      range_two = IntegerRange.new(3, 9)

      raise ScriptError unless range_one.intersect?(range_two)
    end

    def test_intersect_when_range_overlaps_to_left
      range_one = IntegerRange.new(3, 9)
      range_two = IntegerRange.new(0, 6)

      raise ScriptError unless range_one.intersect?(range_two)
    end

    def test_no_intersect_when_range_is_left_but_touches
      range_one = IntegerRange.new(0, 3)
      range_two = IntegerRange.new(3, 6)

      raise ScriptError unless !range_one.intersect?(range_two)
    end

    def test_no_intersect_when_range_is_right_but_touches
      range_one = IntegerRange.new(3, 6)
      range_two = IntegerRange.new(0, 3)

      raise ScriptError unless !range_one.intersect?(range_two)
    end

    def test_equal_minuend_and_subtrahend_equals_zero
      minuend = IntegerRange.new(0, 10)
      subtrahend = IntegerRange.new(0, 10)

      range = minuend - subtrahend

      raise ScriptError unless range == []
    end

    def test_unaffected_minuend_when_subtrahend_doesnt_intersect
      minuend = IntegerRange.new(0, 5)
      subtrahend = IntegerRange.new(6, 10)

      range = minuend - subtrahend

      raise ScriptError unless range == [minuend]
    end

    def test_subtrahend_lowers_minuends_end
      minuend = IntegerRange.new(0, 10)
      subtrahend = IntegerRange.new(8, 11)

      range = minuend - subtrahend

      raise ScriptError unless range == [IntegerRange.new(0, 8)]
    end

    def test_subtrahend_raises_minuends_start
      minuend = IntegerRange.new(5, 10)
      subtrahend = IntegerRange.new(4, 8)

      range = minuend - subtrahend

      raise ScriptError unless range == [IntegerRange.new(8, 10)]
    end

    def test_subtrahend_splits_minuend
      minuend = IntegerRange.new(0, 10)
      subtrahend = IntegerRange.new(3, 6)

      range = minuend - subtrahend

      raise ScriptError unless range == [IntegerRange.new(0, 3), IntegerRange.new(6, 10)]
    end

    def test_range_is_superset_if_equal
      range_one = IntegerRange.new(0, 9)
      range_two = IntegerRange.new(0, 9)

      raise ScriptError unless range_one.superset?(range_two)
    end

    def test_range_is_superset_if_containing_range
      range_one = IntegerRange.new(0, 9)
      range_two = IntegerRange.new(1, 8)

      raise ScriptError unless range_one.superset?(range_two)
    end

    def test_range_is_superset_if_containing_range_but_equal_lower
      range_one = IntegerRange.new(0, 9)
      range_two = IntegerRange.new(0, 5)

      raise ScriptError unless range_one.superset?(range_two)
    end

    def test_range_is_superset_if_containing_range_but_equal_upper
      range_one = IntegerRange.new(0, 9)
      range_two = IntegerRange.new(5, 9)

      raise ScriptError unless range_one.superset?(range_two)
    end

    def test_range_is_not_superset_if_subset
      range_one = IntegerRange.new(3, 6)
      range_two = IntegerRange.new(0, 9)

      raise ScriptError unless !range_one.superset?(range_two)
    end

    def test_range_is_not_superset_if_smaller_range
      range_one = IntegerRange.new(0, 6)
      range_two = IntegerRange.new(0, 9)

      raise ScriptError unless !range_one.superset?(range_two)
    end
  end
end

(TestCase.methods - Object.methods).each { |method| TestCase.send(method) }

