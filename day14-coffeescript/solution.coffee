fs = require 'fs'

# The knothash implementation (from day10)
rev = (arr, pos, size) ->
  if size > 0
    n = arr.length;
    for i in [0...size//2]
      p1 = (pos + i)%n
      p2 = (pos + size - i - 1)%n
      [arr[p1], arr[p2]] = [arr[p2], arr[p1]]

transform = (nums, offsets, times) ->
  pos = 0
  skip = 0
  for i in [0...times]
    for length in offsets
      rev nums, pos, length
      pos = (pos + length + skip)%nums.length
      skip += 1
  nums

densify = (nums) ->
  dh = []
  for i in [0...256] by 16
    res = 0
    for j in [i...i + 16]
      res = res^nums[j]
    dh.push res
  dh

knothash = (seed) ->
  arr = seed.split('').map (s) -> s.charCodeAt(0)
  arr = [arr..., 17, 31, 73, 47, 23]
  arr = densify transform [0...256], arr, 64
  arr = arr.map (k) -> ('0' + k.toString(16)).substr(-2, 2)
  arr.join("")


# The actual problem implementation
buildLocs = (seed) ->
  locs = ((-1 for i in [0...128]) for j in [0...128])
  for i in [0...128]
    h = knothash "#{seed}-#{i}"
    for j in [0...4]
      start = j*8
      num = parseInt('0x' + h.substr(start, 8))
      bnum = num.toString(2)
      bnum = new Array(32 - bnum.length + 1).join('0') + bnum
      for k in [0...32]
        if bnum[k] == '1'
          locs[start*4 + k][i] = 0
  locs

countElem = (arr2d, elem) ->
  res = 0
  for i in [0...arr2d.length]
    for j in [0...arr2d[i].length]
      res = res + 1 if arr2d[i][j] == elem
  res

inBounds = (x, y, locs) ->
  x >= 0 && y >= 0 && y < locs.length && x < locs[0].length

countRegions = (locs) ->
  curReg = 1
  flood = (x, y, val) ->
    if inBounds(x, y, locs) && locs[x][y] == 0
      locs[x][y] = val
      flood(x + 1, y, val)
      flood(x - 1, y, val)
      flood(x, y + 1, val)
      flood(x, y - 1, val)

  for i in [0...locs.length]
    for j in [0...locs[i].length]
      if locs[i][j] == 0
        flood(i, j, curReg)
        curReg += 1
  curReg - 1


solution = (inputPath) ->
  seed = fs.readFileSync inputPath, 'utf8'
  seed = seed .replace /\s+/g, ''

  locs = buildLocs seed

  process.stdout.write "Part 1: #{countElem(locs, 0)}\n"
  process.stdout.write "Part 2: #{countRegions(locs)}\n"


solution "input.txt"