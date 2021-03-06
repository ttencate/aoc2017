import pegs
import sequtils
import strutils

type Vec3 = tuple[x: int, y: int, z: int]

proc norm(p: Vec3): int =
  return abs(p.x) + abs(p.y) + abs(p.z)

type Particle = tuple[p: Vec3, v: Vec3, a: Vec3]

let assignmentPeg: Peg = peg"""
  assignment <- ws name ws '=' ws value ws ( ',' ws ) ?
  name <- { \w } +
  value <- '<' ws int ws ',' ws int ws ',' ws int ws '>'
  int <- { '-' ? \d + }
  ws <- \white *
"""

proc matchSubstr(s: string, c: Captures, i: int): string =
  return s.substr(c.bounds(i).first, c.bounds(i).last)
var particles: seq[Particle] = @[]
for line in lines(stdin):
  var particle: Particle
  var start: int = 0
  var length: int
  while true:
    var captures: Captures
    length = rawMatch(line, assignmentPeg, start, captures)
    if length < 0:
      break
    let name = line.matchSubstr(captures, 0)
    let vec: Vec3 = (
        parseInt(line.matchSubstr(captures, 1)),
        parseInt(line.matchSubstr(captures, 2)),
        parseInt(line.matchSubstr(captures, 3)))
    case name
    of "p":
      particle.p = vec
    of "v":
      particle.v = vec
    of "a":
      particle.a = vec
    start += length
  particles &= particle

var minAcceleration: int = high(int)
var index: int = -1
for i in countup(particles.low, particles.high):
  let acceleration = particles[i].a.norm()
  if acceleration < minAcceleration:
    minAcceleration = acceleration
    index = i
echo($index)
