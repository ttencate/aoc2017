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
  childList = (match[3] || '').split(', ')
  names.push(name)
  children[name] = childList
  for child in childList
    parents[child] = name
  weights[name] = parseInt(weight)

for name in names
  if !parents[name]
    console.log name
