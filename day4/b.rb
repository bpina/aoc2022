#!/usr/bin/env ruby

def overlapping?(pair)
  left, right = pair.map { |x| (x[0]..x[1]) }
  left.first <= right.last && left.last >= right.first 
end

def number_of_overlaps(input, overlapping_ranges = 0)
  return overlapping_ranges if input.empty?

  current, *rest = input
  pair = current.split(',').map {|x| x.split('-').map(&:to_i) }
  overlapping_ranges += 1 if overlapping?(pair)

  number_of_overlaps(rest, overlapping_ranges)
end

input = File.readlines('a.txt')
p "found #{number_of_overlaps(input)} overlapping"