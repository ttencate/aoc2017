import pegs
import sequtils
import strutils

proc sign(i: int): int =
  if i > 0:
    return 1
  if i < 0:
    return -1
  return 0
proc allSignsEqual(a: int, b: int, c: int): bool =
  return sign(a) == sign(b) and sign(a) == sign(c)

type Vec3 = tuple[x: int, y: int, z: int]

proc `$`(v: Vec3): string =
  return "<" & $v.x & "," & $v.y & "," & $v.z & ">"
proc `+`(a: Vec3, b: Vec3): Vec3 =
  return (a.x + b.x, a.y + b.y, a.z + b.z)
proc norm(p: Vec3): int =
  return abs(p.x) + abs(p.y) + abs(p.z)

type Particle = tuple[p: Vec3, v: Vec3, a: Vec3]

proc `$`(p: Particle): string =
  return "p=" & $p.p & ", v=" & $p.v & ", a=" & $p.a
proc distanceToOrigin(p: Particle): int =
  return norm(p.p)
proc isPastMinimum(p: Particle): bool =
  return allSignsEqual(p.p.x, p.v.x, p.a.x) and allSignsEqual(p.p.y, p.v.y, p.a.y) and allSignsEqual(p.p.z, p.v.z, p.a.z)
proc timeStep(p: Particle): Particle =
  var next: Particle
  next.a = p.a
  next.v = p.v + next.a
  next.p = p.p + next.v

# p=<-1021,-2406,1428>, v=<11,24,-73>, a=<4,9,0>
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
