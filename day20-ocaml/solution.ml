open Printf

(* basic types/operations *)
type point = {x: int; y: int; z: int}
type particle = {p: point; v: point; a: point}
type plist = particle list

let (@+) a b = {x = a.x + b.x; y = a.y + b.y; z = a.z + b.z}
let mag {x; y; z} = abs(x) + abs(y) + abs(z) 
let step {p; v; a} = let v = v @+ a in {p = p @+ v; v = v; a = a}


(* simulation *)
let closest_idx (particles: plist): int =
  let _, min_idx, _ = List.fold_left (
    fun (min_dist, min_idx, idx) {p} ->
      if min_idx < 0 || mag p < min_dist 
      then (mag p, idx, idx + 1)
      else (min_dist, min_idx, idx + 1)
  ) (0, -1, 0) particles in
  min_idx


let collide (particles: plist): plist = 
  let pmap = Hashtbl.create (List.length particles) in
  List.iter (fun {p} -> 
    try Hashtbl.replace pmap p ((Hashtbl.find pmap p) + 1)
    with Not_found -> Hashtbl.add pmap p 1
  ) particles;

  List.filter (fun {p} -> 
    try Hashtbl.find pmap p == 1
    with Not_found -> true
  ) particles


let max_steps = 1000000
let plateau_size = 1000

let converge (post_fn: plist -> plist) (attr_fn: plist -> 'a): plist -> 'a =
  let rec loop pidx idx cur_attr ps =  
    let ps1 = List.map step ps |> post_fn in
    let attr = attr_fn ps1 in
    if (attr == cur_attr && pidx == 0) || idx == 0 
    then attr
    else loop (pidx - 1) (idx - 1) attr ps1 in
  loop plateau_size max_steps (-1)


(* reading data *)
let parse_point (t: string): point =
  Str.split (Str.regexp ",") t 
  |> List.map (fun s -> int_of_string (String.trim s)) 
  |> fun [x; y; z] -> {x=x; y=y; z=z}


let regexp = Str.regexp "p=<\\([^>]+\\).*v=<\\([^>]+\\).*a=<\\([^>]+\\)"

let parse_particle (s: string): particle option = 
  if Str.string_match regexp s 0 
  then 
    let [p; v; a] = List.map (fun k -> Str.matched_group k s) [1; 2; 3] in
    Some {p=parse_point p; v=parse_point v; a=parse_point a} 
  else 
    None


let read_data (filename: string): plist =  
  let f = open_in filename in
  let rec loop res = 
    try loop (
      match parse_particle(input_line f) with
        Some(p) -> p :: res
      | None -> res) 
    with End_of_file -> close_in f; List.rev res in
  loop []


(* main solution function*)
let solution (input_path: string): unit = 
  let particles = read_data input_path in
  let closest = converge (fun p -> p) closest_idx particles in
  let nactive = converge collide List.length particles in
  printf "Part 1: %d\nPart 2: %d\n" closest nactive


let () = solution "input.txt"
