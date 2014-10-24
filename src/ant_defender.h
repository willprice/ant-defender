#ifndef ANT_DEFENDER_H
#define ANT_DEFENDER_H

//#define ANT_DEFENDER_TEST
#define SIZE_OF_CLOCK 12

typedef unsigned int Position;

typedef enum {
    clockwise, anticlockwise, stationary
} Direction;

typedef struct {
    Position position;
    Direction direction;
} Ant;

void ant_move_clockwise(Ant*);
void ant_move_anticlockwise(Ant*);
void ant_move(Ant* ant, Direction direction);
Ant create_defender_ant();
Ant create_attacker_ant();

#endif /* ANT_DEFENDER_H */
