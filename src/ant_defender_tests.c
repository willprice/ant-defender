#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include "ant_defender.h"
#include "greatest.h"

int teardown_was_called;

#define ASSERT_EQUALS(EXP, ACT)                                                                 \
        do {                                                                                    \
            char error_message[50]; \
            sprintf(error_message, "expected %d but got %d instead", (EXP), (ACT));             \
            ASSERT_EQm(error_message, (EXP), (ACT));                                            \
        } while(0);                                                                             \
        PASS();

SUITE(suite);


TEST test_moving_ant(Position expected_position, Position start_position, Direction direction, int number_of_moves) {
    // 0b0cba0000, a, b, c are LEDs
    Ant ant = { start_position, stationary };

    for (int i = 0; i < number_of_moves; i++) {
        ant_move(&ant, direction);
    }
    ASSERT_EQUALS(expected_position, ant.position);
    PASS();
}

TEST test_position(Position expected, Ant ant) {
    ASSERT_EQUALS(expected, ant.position);
    PASS();
}

static void trace_setup(void *arg) {
    printf("-- in setup callback\n");
    teardown_was_called = 0;
    (void)arg;
}

static void trace_teardown(void *arg) {
    printf("-- in teardown callback\n");
    teardown_was_called = 1;
    (void)arg;
}

SUITE(suite) {
    RUN_TESTp(test_position, 5, create_attacker_ant());
    RUN_TESTp(test_position, 11, create_defender_ant());
    RUN_TESTp(test_moving_ant, 1, 0, clockwise, 1);
    RUN_TESTp(test_moving_ant, 0, 11, clockwise, 1);
    RUN_TESTp(test_moving_ant, 11, 0, anticlockwise, 1);
    RUN_TESTp(test_moving_ant, 1, 2, anticlockwise, 1);

    /* Set so asserts below won't fail if running in list-only or
     * first-fail modes. (setup() won't be called and clear it.) */
    teardown_was_called = -1;

    /* Add setup/teardown for each test case. */
    GREATEST_SET_SETUP_CB(trace_setup, NULL);
    GREATEST_SET_TEARDOWN_CB(trace_teardown, NULL);
}

/* Add all the definitions that need to be in the test runner's main file. */
GREATEST_MAIN_DEFS();

#ifdef ANT_DEFENDER_TEST
int main(int argc, char **argv) {
    GREATEST_MAIN_BEGIN();      /* command-line arguments, initialization. */
    RUN_SUITE(suite);
    GREATEST_MAIN_END();        /* display results */
}
#endif
