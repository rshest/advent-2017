#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>

#define INPUT_PATH          "input.txt"
#define TAPE_GROWTH_BYTES   1024*1024

#define STATE0_PREFIX       "Begin in state "
#define STATE_START_PREFIX  "In state "
#define STEPS_PREFIX        "checksum after "
#define IF_PREFIX           "If the current value is "
#define WRITE_PREFIX        "Write the value "
#define MOVE_PREFIX         "Move one slot to the "
#define TARGET_STATE_PREFIX "Continue with state "

typedef struct {
  int   write;
  int   move;
  char  target_state;
} IfBlock;

typedef struct {
   char state;
   IfBlock if0, if1;
} StateBlock;

StateBlock* get_block(StateBlock* program, size_t program_len, char state) {
  for (size_t i = 0; i < program_len; i++) {
    if (program[i].state == state) return program + i;
  }
  return NULL;
}

char parse_char(char** text, char* prefix) {
  char* pos = strstr(*text, prefix);
  assert(pos != NULL);
  *text = pos + strlen(prefix);
  return (*text)[0];
}

int parse_int(char** text, char* prefix) {
  char* pos = strstr(*text, prefix);
  assert(pos != NULL);
  *text = pos + strlen(prefix);
  return atoi(*text);
}

size_t count_substrings(char* text, char* substr) {
  char* p = text;
  size_t len = strlen(substr);
  size_t res = 0;
  while (p = strstr(p, substr)) {
    res++;
    p += len;
  }
  return res;
}

char* parse_if_block(char* pos, IfBlock* ifb) {
  ifb->write = parse_int(&pos, WRITE_PREFIX);
  char m = parse_char(&pos, MOVE_PREFIX);
  ifb->move = m == 'r' ? 1 : -1;
  ifb->target_state = parse_char(&pos, TARGET_STATE_PREFIX);
  return pos;
}

StateBlock* parse_program(char* text, size_t* program_len) {
  *program_len = count_substrings(text, STATE_START_PREFIX);
  size_t plen = strlen(STATE_START_PREFIX);
  
  StateBlock* res = malloc(*program_len*sizeof(StateBlock));
  char* pos = text;
  for (size_t i = 0; i < *program_len; i++) {
    pos = strstr(pos, STATE_START_PREFIX) + plen;
    res[i].state = pos[0];
    pos = parse_if_block(pos, &res[i].if0);
    pos = parse_if_block(pos, &res[i].if1);
  }
  return res;
}

int checksum(char* tape, size_t tape_len) {
  int res = 0;
  for (size_t i = 0; i < tape_len; i++) {
    res += tape[i];
  }
  return res;
}

int eval_program(StateBlock* program, size_t program_len, 
  char start_state, int steps) 
{
  char state = start_state;
  int pos = 0;
  char* tape = malloc(TAPE_GROWTH_BYTES + 1);
  int tape_len = TAPE_GROWTH_BYTES + 1;
  memset(tape, 0, tape_len);

  for (int i = 0; i < steps; i++) {
    StateBlock* block = get_block(program, program_len, state);
    assert(block != NULL);
    
    if (pos >= tape_len/2 || pos <= -tape_len/2) {
      // grow the tape buffer
      int new_tape_len = tape_len + TAPE_GROWTH_BYTES;
      char* new_tape = malloc(new_tape_len);
      memset(new_tape, 0, new_tape_len);
      memcpy(new_tape + new_tape_len/2 - tape_len/2, tape, tape_len);
      free(tape);
      tape = new_tape;
      tape_len = new_tape_len;
    }

    char val = tape[pos + tape_len/2];
    IfBlock* ifb = (val == 1) ? &block->if1 : &block->if0;
    tape[pos + tape_len/2] = ifb->write;
    pos += ifb->move;
    state = ifb->target_state;
  }

  int res = checksum(tape, tape_len);
  free(tape);
  return res;
}

void solution(char* input_path) {
  FILE* file = fopen(INPUT_PATH, "r");
  fseek(file, 0, SEEK_END);
  long length = ftell(file);
  assert(length > 0);
  fseek(file, 0, SEEK_SET);

  char* text = malloc(length + 1);
  size_t nread = fread(text, 1, length, file);
  text[length] = '\0';

  char* pos = text;
  char start_state = parse_char(&pos, STATE0_PREFIX);
  int steps = parse_int(&pos, STEPS_PREFIX);
  size_t program_len = 0;
  StateBlock* program = parse_program(pos, &program_len);

  free(text);

  int res = eval_program(program, program_len, start_state, steps);
  printf("Part 1: %d\n", res);
  printf("Part 2: -\n");

  free(program);
}


int main() {
  solution(INPUT_PATH);
  return 0;
}