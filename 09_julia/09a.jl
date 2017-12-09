#!/usr/bin/julia --

input = readline()
i = 0
score = 0
depth = 0

function eof()
  global input
  global i
  i > length(input)
end

function cur()
  global input
  global i
  input[i]
end

function next()
  global i
  i += 1
  while !eof() && cur() == '!'
    i += 2
  end
end

function readGarbage()
  while cur() != '>'
    next()
  end
  next()
end

function readGroup(depth)
  next() # skip '{'
  score = depth
  while cur() != '}'
    if cur() == '<'
      readGarbage()
    elseif cur() == '{'
      score += readGroup(depth + 1)
    end
    if cur() == ','
      next()
    end
  end
  next()
  score
end

next()
println(readGroup(1))
