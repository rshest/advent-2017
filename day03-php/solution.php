<?php

define("MAXNUM", 312051);

class Offset {
    public static $X = array(1, 0, -1, 0);
    public static $Y = array(0, -1, 0, 1);    

    public static $DX = array(1, 1, 0, -1, -1, -1,  0,  1);
    public static $DY = array(0, 1, 1,  1,  0, -1, -1, -1);    
}


//  the spiral positions generator
function spiral() {
    $x = $y = $dir = 0;
    $shift = 1;
    while (true) {
        for ($k = 0; $k < 2; $k++) {
            for ($i = 0; $i < $shift; $i++) {
                yield array($x, $y);
                $x += Offset::$X[$dir];
                $y += Offset::$Y[$dir];
            }
            $dir = ($dir + 1)%4;
        }
        $shift++;
    }
}


function manhattan($pos) {
    return abs($pos[0]) + abs($pos[1]);
}


function part1() {
    $step = 1;
    foreach (spiral() as $pos) {
        $step++;
        if ($step > MAXNUM) {
            echo "Part 1: ", manhattan($pos), "\n";        
            break;
        }
    }
}


//  PHP hash maps do not support complex keys, so workaround it by 
//  converting point coordinates to strings
function part2() {
    $vals = array();
    $vals["0,0"] = 1;
    foreach (spiral() as $pos) {
        $val = 0;
        for ($i = 0; $i < 8; $i++) {
            $x = $pos[0] + Offset::$DX[$i];
            $y = $pos[1] + Offset::$DY[$i];
            $key = "${x},${y}";
            if (isset($vals[$key])) {
                $val += $vals[$key];
            }
        }
        if ($val == 0) {
            $val = 1;
        }
        $vals["${pos[0]},${pos[1]}"] = $val;
        if ($val > MAXNUM) {
            echo "Part 2: ", $val, "\n";        
            break;
        }
    }
}


part1();
part2();

?>