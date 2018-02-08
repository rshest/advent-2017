REBOL [
    Title:   "Advent of code 2017/05 solution in REBOL"
    Version: 1.0.0
    Author:  "Ruslan Shestopalyuk"
]


count-steps: func [
  numbers
  part2?
] [
  k: 1 steps: 0
  nums: copy numbers
  forever [
    offs: nums/:k
    nums/:k: offs + (either part2? and (offs >= 3) [-1] [1])
    k: k + offs
    if k < 1 or (k > length? nums) [
      break/return steps + 1
    ]
    steps: steps + 1
  ]
]

numbers: map-each n (read/lines %input.txt) [to integer! n]

print rejoin ["Part 1: " (count-steps numbers false) " steps"]
print rejoin ["Part 2: " (count-steps numbers true) " steps"]
