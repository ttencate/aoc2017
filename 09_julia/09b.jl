#!/usr/bin/julia --

input = readline()
i = 0

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
  next() # skip '<'
  score = 0
  while cur() != '>'
    score += 1
    next()
  end
  next()
  score
end

function readGroup(depth)
  next() # skip '{'
  score = 0
  while cur() != '}'
    if cur() == '<'
      score += readGarbage()
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
