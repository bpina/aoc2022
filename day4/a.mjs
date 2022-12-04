#!/usr/bin/env node

import fs from 'fs'

const covers = (left, right) => {
  return right[0] >= left[0] && right[1] <= left[1]
}

const is_overlapping = pair => {
  const [left, right] = pair
  return covers(left, right) || covers(right, left)
}

const number_of_overlaps = (input, overlappingRanges = 0) => {
  if(input.length == 0) return overlappingRanges;

  const [current, ...rest] = input
  const pair = current.split(',').map(x => x.split('-').map(y => Number(y)))
  if(is_overlapping(pair)) overlappingRanges += 1

  return number_of_overlaps(rest, overlappingRanges)
}

const input = fs.readFileSync('a.txt').toString().split("\n")
console.log(`found ${number_of_overlaps(input)} overlapping`)
