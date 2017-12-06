#!/bin/awk -f

BEGIN { count = 0 }
{
  split("", seen)
  for (i = 1; i <= NF; i++) {
    if (seen[$i]) {
      next
    }
    seen[$i] = 1
  }
  count++
}
END { print count }
