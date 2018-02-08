{$mode objfpc} 

program solution;

uses sysutils, classes, math;


const
  INPUT_PATH = 'input.txt';


type
Point = record
  x: integer;
  y: integer;
end;


{ position on the hexagonal grid (in a "skewed" coordinate space) }
function add(pt: Point; x1, y1: integer): Point;
begin
  add.x := pt.x + x1; 
  add.y := pt.y + y1;
end;


{ returns distance to the center of coordinates }
function dist(pos: Point) : integer;
begin
  if (pos.x*pos.y <= 0) then
    dist := abs(pos.x) + abs(pos.y)
  else
    dist := max(abs(pos.x), abs(pos.y));
end;


{ evaluates one step according to the direction }
function step(dir: string; pos: Point) : Point;
begin
  case dir of
    'n':  step := add(pos,  0, -1);
    'ne': step := add(pos,  1,  0);
    'se': step := add(pos,  1,  1);
    's':  step := add(pos,  0,  1);
    'sw': step := add(pos, -1,  0);
    'nw': step := add(pos, -1, -1);
    else step := pos;
  end;
end;


procedure simulate(steps: TStringList; out curdist, fardist: integer);
var 
  i: integer;
  pos: Point;
begin
  pos.x := 0;
  pos.y := 0;
  fardist := 0;

  for i := 0 to steps.count - 1 do
  begin
    pos := step(steps[i], pos);
    curdist := dist(pos);
    if curdist > fardist then
      fardist := curdist;
  end;
end;


var
  fin: TextFile;
  s: ansistring;
  steps: TStringList;
  enddist, fardist: integer;
begin
  try
    assignfile(fin, INPUT_PATH);
    reset(fin);
    read(fin, s);
    closefile(fin);
  except
    on E: EInOutError do
     writeln('Failed to open input data file: ', E.Message);
  end;

  steps := TStringList.create;
  steps.Delimiter := ',';
  steps.DelimitedText := s;

  simulate(steps, enddist, fardist);

  writeln(format('Part 1: %d', [enddist]));
  writeln(format('Part 2: %d', [fardist]));
end.
