#!/usr/bin/tclsh

proc area {shell} {
  return [expr {(1 + 2*$shell) * (1 + 2*$shell)}]
}

set input [gets stdin]
set shell 0
set area 1
while {$input > [area $shell]} {
  incr shell
}
set i [expr {$input - 1 - [area [expr {$shell - 1}]]}]
set side_len [expr {2 * $shell}]
set side [expr {$i / $side_len}]
set i_in_side [expr {$i % $side_len}]
if {$side == 0} {
  set x [expr {$shell}]
  set y [expr {-$shell + 1 + $i_in_side}]
} elseif {$side == 1} {
  set x [expr {$shell - 1 - $i_in_side}]
  set y [expr {$shell}]
} elseif {$side == 2} {
  set x [expr {-$shell}]
  set y [expr {$shell - 1 - $i_in_side}]
} elseif {$side == 3} {
  set x [expr {-$shell + 1 + $i_in_side}]
  set y [expr {-$shell}]
} else {
  puts "ERROR"
}
puts [expr {abs($x) + abs($y)}]
