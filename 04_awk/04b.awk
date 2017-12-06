#!/bin/awk -f

BEGIN { count = 0 }
{
  split("", seen)
  for (i = 1; i <= NF; i++) {
    word = $i

    split(word, chars, "")
    for (a = 1; a <= length(chars); a++) {
      for (b = a + 1; b <= length(chars); b++) {
        if (chars[a] > chars[b]) {
          tmp = chars[a]
          chars[a] = chars[b]
          chars[b] = tmp
        }
      }
    }

    sorted = ""
    for (a = 1; a <= length(chars); a++) {
      sorted = sorted chars[a]
    }

    if (seen[sorted]) {
      next
    }
    seen[sorted] = 1
  }
  count++
}
END { print count }
