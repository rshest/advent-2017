set DIRS {{ 0 -1} { 1  0} { 0  1} {-1  0}}

proc turn_back  {dir} { return [expr ($dir + 2)%4] }
proc turn_right {dir} { return [expr ($dir + 1)%4] }
proc turn_left  {dir} { return [expr ($dir - 1)%4] }

proc move {x y dir} {
  global DIRS
  upvar 1 $x cx
  upvar 1 $y cy
  
  set cx [expr $cx + [lindex $DIRS $dir 0]]
  set cy [expr $cy + [lindex $DIRS $dir 1]]
}

proc init_state {path} {
  set fp [open $path r]
  set data [split [read $fp] "\n"]
  close $fp

  set offs [expr -([string length [lindex $data 0]]/2)]
  set y $offs
  array set state {}

  foreach line $data {
    set x $offs
    foreach c [split $line {}] {
      if {$c == "#"} { 
        set state($x,$y) $c 
      }
      incr x
    }
    incr y
  }
  return [array get state]
}


proc step {x y dir state} {
  upvar 1 $state s
  upvar 1 $dir d

  set infected 0
  if {[info exists s($x,$y)]} {
    array unset s $x,$y
    set d [turn_right $d] 
  } else {
    set infected 1
    set s($x,$y) "#"
    set d [turn_left $d]
  }
  return $infected
}


proc step2 {x y dir state} {
  upvar 1 $state s
  upvar 1 $dir d

  set infected 0
  if {[info exists s($x,$y)]} {
    set c $s($x,$y)
    if {$c == "W"} {
      set s($x,$y) "#"
      set infected 1
    } elseif {$c == "#"} {
      set s($x,$y) "F"
      set d [turn_right $d] 
    } elseif {$c == "F"} {
      array unset s $x,$y
      set d [turn_back $d]     
    }
  } else {
    set s($x,$y) "W"
    set d [turn_left $d]
  }
  return $infected  
}


proc step_many {mode steps state} {
  upvar $state s

  set dir 0
  set x 0
  set y 0
  set total_infected 0
  
  for {set i 0}  {$i < $steps} {incr i} {
    if {$mode == 0} {
      set infected [step $x $y dir s]
    } else {
      set infected [step2 $x $y dir s]      
    }
    set total_infected [expr $total_infected + $infected]
    move x y $dir
  }
  return $total_infected
}


proc solution {input_path} {
  array set state1 [init_state $input_path]
  set res1 [step_many 0 10000 state1]
  puts [format "Part 1: %d" $res1] 

  array set state2 [init_state $input_path]
  set res1 [step_many 1 10000000 state2]
  puts [format "Part 2: %d" $res1] 
}


solution "input.txt"