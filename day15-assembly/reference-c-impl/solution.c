#include <stdio.h> 

#define STARTX      722
#define STARTY      354

#define NUM_ITER1   40000000
#define NUM_ITER2   5000000

#define MULX        16807
#define MULY        48271
#define DIV         2147483647

#define MASK        0xFFFF
#define MASK1       3
#define MASK2       7


void part1() {
    unsigned long int x = STARTX;
    unsigned long int y = STARTY;
    unsigned int res = 0;

    for (unsigned int i = 0; i < NUM_ITER1; i++) {
        x = (x*MULX)%DIV;
        y = (y*MULY)%DIV;
        
        res += ((x&MASK) == (y&MASK));
    }
    printf("Part 1: %d\n", res);
}

void part2() {
    unsigned long int x = STARTX;
    unsigned long int y = STARTY;
    unsigned int res = 0;

    for (unsigned int i = 0; i < NUM_ITER2; i++) {
        do {
            x = (x*MULX)%DIV;
        } while ((x&MASK1) != 0);
        
        do {
            y = (y*MULY)%DIV;
        } while ((y&MASK2) != 0);

        res += ((x&MASK) == (y&MASK));
    }
    printf("Part 2: %d\n", res);
}

int main() {
    part1();
    part2();
}