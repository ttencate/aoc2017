#!/usr/bin/coffee

fs = require 'fs'

input = fs.readFileSync('/dev/stdin').toString()
lines = input.trim().split('\n')

names = []
children = {}
parents = {}
weights = {}
for line in lines
  match = /^(\S+) \((\d+)\)(?: -> (.*))?$/.exec(line)
  name = match[1]
  weight = match[2]
  childList = if match[3] then match[3].split(', ') else []
  names.push(name)
  children[name] = childList
  for ch in childList
    parents[ch] = name
  weights[name] = parseInt(weight)

root = null
for name in names
  if !parents[name]
    root = name

sumWeights = {}
computeSumWeights = (name) ->
  sumWeight = weights[name]
  for child in children[name]
    computeSumWeights(child)
    sumWeight += sumWeights[child]
  sumWeights[name] = sumWeight
computeSumWeights(root)

isBalanced = (name) ->
  ch = children[name]
  if ch.length < 2
    true
  else
    expectedSumWeight = sumWeights[ch[0]]
    for c in ch
      if sumWeights[c] != expectedSumWeight
        return false
    true

for name in names
  if !isBalanced(name)
    continue
  if !parents[name]
    continue
  siblings = children[parents[name]]
  if siblings.length < 3
    continue
  mySumWeight = sumWeights[name]
  differentSiblings = 0
  siblingsSumWeight = 0
  for sibling in siblings
    if sumWeights[sibling] != mySumWeight
      differentSiblings++
      siblingsSumWeight = sumWeights[sibling]
  if differentSiblings >= 2
    console.log weights[name] + siblingsSumWeight - mySumWeight
