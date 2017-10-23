# README

### Instructions
This script takes two files which contain a list of time ranges. Each range is in the format 'Time..Time' where Time is in the format YYYY-MM-DD HH:MM:SS ZONE (e.g. 2017-10-22 22:10:12 -0400). An example minuend and subtrahend file are provided. To generate a difference.txt output use the command

## I```ruby subtract.rb <minuend_filename> <subtrahend_filename> <difference_filename>```

### Assumptions
**Ranges in a single list cannot overlap** This added a bit more complexity when subtracting lists to avoid an O(n^2) list subtraction operation. Since each range cannot overlap, the list could be sorted and a O(nlogn) function could be used to optimize the operation. If overlapping was allowed, then an worst case O(n^2) subtraction function would be unavoidable.

### Other notes
I didn't code too defensively here for the sake of time. And example would be trying to compare two different subclasses of IntegerRange.

Theres a test suite included with the majority of this code. Again, for time sake, not everything is tested. I also just wrote simple methods for my tests so no outside libraries would need to be installed and this project has no dependancies. The test suite can be run by using `ruby test.rb`.

The file structure is a bit of a mess. For a small project like this, its not a big deal, but it would probably need to be reorganized as it gets more complex.