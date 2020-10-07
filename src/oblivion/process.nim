import re, os, strformat, strutils

proc countParams*(cmd: string): int =
  let matches = cmd.findAll(re"\$[1-9]+")
  var numbers: seq[int]
  for m in matches:
    let n = parseInt(m[1..^1])
    numbers.add(n)
  if numbers.len > 0:
    result = max(numbers)

proc substitute*(cmd: string): string =
  result = cmd
  for i in 1 .. paramCount() - 2:
    result = result.replace(re(fmt"\${i}"), paramStr(i+2))
