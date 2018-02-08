
void rotate(char[] arr, int n) {
  int len = arr.length;
  char[] narr = new char[len];
  for (int i = 0; i < len; i++) {
    narr[i] = arr[(len - n + i)%len];
  }
  arrayCopy(narr , arr,len);
}


int index(char[] arr, char c) {
  for (int i = 0; i < arr.length; i++) {
    if (arr[i] == c) return i;
  }
  return -1;
}


void swap(char[] arr, int pos1, int pos2) {
  char c = arr[pos1];
  arr[pos1] = arr[pos2];
  arr[pos2] = c;
}


void dance(char[] state, String[] commands) {
  for (String cmd: commands) {
    char c = cmd.charAt(0);
    String[] rest = cmd.substring(1, cmd.length()).split("/");
    switch (c) {
      case 's':
        rotate(state, int(rest[0]));
        break;
      case 'x':
        swap(state, int(rest[0]), int(rest[1]));
        break;
      case 'p':
        int ap = index(state, rest[0].charAt(0));
        int bp = index(state, rest[1].charAt(0));
        swap(state, ap, bp);
        break;
    }
  }
}


class Period {
 int start;
 int length; 

 Period(int _start, int _length) {
   start = _start;
   length = _length;
 }
}


Period findPeriod(char[] state, String[] commands) {
  char[] stateCopy = new char[state.length];
  arrayCopy(state, stateCopy);
  state = stateCopy;

  HashMap<String, Integer> visited = new HashMap<String, Integer>();
  int step = 0;
  Period period = null;

  while (true) {
    String s = new String(state);
    if (visited.containsKey(s)) {
      int start = visited.get(s);
      period = new Period(start, step - start);
      break;
    }
    visited.put(s, step);
    step += 1;
    dance(state, commands);
  }

  return period;
}


void danceMany(char[] state, String[] commands, int steps) {
  Period period = findPeriod(state, commands);
  int remainingSteps = (steps - period.start)%period.length;
  for (int i = 0; i < remainingSteps; i++) {
    dance(state, commands);
  }
}


char[] initState(int size) {
  char[] state = new char[size];
  for (int i = 0 ; i < size; i++) {
    state[i] = char('a' + i);
  }
  return state;
}


final int     NUM_PROGRAMS  = 16;
final String  DATA_PATH     = "input.txt";
final int     NUM_STEPS     = 1000000000;

void solution() {
  String[] lines = loadStrings(DATA_PATH);
  String[] commands = split(lines[0], ',');

  char[] state = initState(NUM_PROGRAMS);
  
  dance(state, commands);
  println("Part 1:", new String(state));

  state = initState(NUM_PROGRAMS);
  danceMany(state, commands, NUM_STEPS);
  println("Part 2:", new String(state));
}

void setup() {
  solution();
  exit();
}
