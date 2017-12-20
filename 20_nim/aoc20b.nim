import math
import pegs
import sequtils
import strutils
import tables

type Vec3 = tuple[x: int, y: int, z: int]

proc `+`(a: Vec3, b: Vec3): Vec3 =
  return (a.x + b.x, a.y + b.y, a.z + b.z)

type Particle = tuple[p: Vec3, v: Vec3, a: Vec3]

proc timeStep(p: Particle): Particle =
  result.a = p.a
  result.v = p.v + result.a
  result.p = p.p + result.v

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

for i in countup(1, 1000):
  # Note: starting positions are unique, so no need to check for collisions
  # before we start.
  particles = particles.map(timeStep)
  var collided = repeat(false, particles.len())
  var counts = initTable[Vec3, int](nextPowerOfTwo(particles.len()))
  for particle in particles:
    counts[particle.p] = counts.getOrDefault(particle.p) + 1
  particles.keepIf(proc(p: Particle): bool = counts[p.p] <= 1)
echo($len(particles))
