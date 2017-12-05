#!/usr/bin/tclsh

set input [gets stdin]

set value(0,0) 1

proc get {x y} {
  global value
  if {[info exists value($x,$y)]} {
    return $value($x,$y)
  } else {
    return 0
  }
}

proc compute {x y} {
  global value
  set xm [expr {$x - 1}]
  set xp [expr {$x + 1}]
  set ym [expr {$y - 1}]
  set yp [expr {$y + 1}]
  set sum [expr {
    [get $xm $yp] + [get $x $yp] + [get $xp $yp] +
    [get $xm $y ] +                [get $xp $y ] +
    [get $xm $ym] + [get $x $ym] + [get $xp $ym]
  }]
  set value($x,$y) $sum
}

set shell 1
set side 0
set side_len 2
set i_in_side 0
set x 1
set y 0
compute $x $y

while {[get $x $y] < $input} {
  incr i_in_side
  if {$i_in_side >= $side_len} {
    incr side
    set i_in_side 0
    if {$side >= 4} {
      incr shell
      set side_len [expr {$side_len + 2}]
      set side 0
    }
  }
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
  puts "$shell/$side/$i_in_side -> $x, $y"
  compute $x $y
}
puts [get $x $y]
