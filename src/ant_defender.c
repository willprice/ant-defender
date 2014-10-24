#include "ant_defender.h"

void ant_move_clockwise(Ant* ant) {
    ant->position = (ant->position + 1) % SIZE_OF_CLOCK;
}

void ant_move_anticlockwise(Ant* ant) {
    if (ant->position == 0) { ant->position = 11; }
    else { ant->position -= 1; }
}

Ant create_defender_ant() {
    Position initial_position = 11;
    Ant players_ant = { initial_position, stationary };
    return players_ant;
}

Ant create_attacker_ant() {
    Position initial_position = 5;
    Ant attacking_ant = { initial_position, stationary };
    return attacking_ant;
}

void ant_move(Ant* ant, Direction direction) {
    switch(direction) {
    case clockwise:
        ant_move_clockwise(ant);
        break;
    case anticlockwise:
        ant_move_anticlockwise(ant);
        break;
    default:
        printf("Error: Not a valid direction to move the ant in");
    }
}
