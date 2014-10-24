#include <stdio.h>
#include <platform.h>
#include <timer.h>

#include "ant_defender.h"

#ifndef ANT_DEFENDER_TEST
out port cled0 = PORT_CLOCKLED_0;
out port cled1 = PORT_CLOCKLED_1;
out port cled2 = PORT_CLOCKLED_2;
out port cled3 = PORT_CLOCKLED_3;
out port cledG = PORT_CLOCKLED_SELG;
out port cledR = PORT_CLOCKLED_SELR;
in port  buttons = PORT_BUTTON;
out port speaker = PORT_SPEAKER;
#endif

/*
/////////////////////////////////////////////////////////////////////////////////////////
//
// COMS20001
// ASSIGNMENT 1
// TITLE: "LED Ant Defender Game"
//
/////////////////////////////////////////////////////////////////////////////////////////

#include <stdio.h>
#include <platform.h>

out port cled0 = PORT_CLOCKLED_0;
out port cled1 = PORT_CLOCKLED_1;
out port cled2 = PORT_CLOCKLED_2;
out port cled3 = PORT_CLOCKLED_3;
out port cledG = PORT_CLOCKLED_SELG;
out port cledR = PORT_CLOCKLED_SELR;
in port  buttons = PORT_BUTTON;
out port speaker = PORT_SPEAKER;

int showLED(out port quadrant, chanend fromVisualiser) {
    unsigned int lightUpPattern;
    while (1) {
        fromVisualiser :> lightUpPattern; //read LED pattern from visualiser process
        quadrant <: lightUpPattern;              //send pattern to LEDs
    }
    return 0;
}

void visualiser(chanend fromUserAnt, chanend fromAttackerAnt, chanend toQuadrant0, chanend toQuadrant1, chanend toQuadrant2, chanend toQuadrant3) {
    unsigned int userAntToDisplay = 11;
    unsigned int attackerAntToDisplay = 5;
    int i, j;
    cledR <: 1;
    while (1) {
        select {
                case fromUserAnt :> userAntToDisplay:
                    break;
                case fromAttackerAnt :> attackerAntToDisplay:
                    break;
        }
        j = 16<<(userAntToDisplay%3);
        i = 16<<(attackerAntToDisplay%3);
        toQuadrant0 <: (j*(userAntToDisplay/3==0)) + (i*(attackerAntToDisplay/3==0)) ;
        toQuadrant1 <: (j*(userAntToDisplay/3==1)) + (i*(attackerAntToDisplay/3==1)) ;
        toQuadrant2 <: (j*(userAntToDisplay/3==2)) + (i*(attackerAntToDisplay/3==2)) ;
        toQuadrant3 <: (j*(userAntToDisplay/3==3)) + (i*(attackerAntToDisplay/3==3)) ;
    }
}

void playSound(unsigned int wavelength, out port speaker) {
    timer  tmr;
    int t, isOn = 1;
    tmr :> t;
    for (int i=0; i<2; i++) {
        isOn = !isOn;
        t += wavelength;
        tmr when timerafter(t) :> void;
        speaker <: isOn;
    }
}

void buttonListener(in port b, out port spkr, chanend toUserAnt) {
    int r;
    while (1) {
        b when pinsneq(15) :> r;   // check if some buttons are pressed
        playSound(2 * 1000 * 1000,spkr);   // play sound
        toUserAnt <: r;            // send button pattern to userAnt
    }
}

//WAIT function
void waitMoment() {
    timer tmr;
    uint waitTime;
    tmr :> waitTime;
    waitTime += 10000000;
    tmr when timerafter(waitTime) :> void;
}

/////////////////////////////////////////////////////////////////////////////////////////
//
//  MOST RELEVANT PART OF CODE TO EXPAND FOR YOU
//
/////////////////////////////////////////////////////////////////////////////////////////

//DEFENDER PROCESS... The defender is controlled by this process userAnt,
//                    which has channels to a buttonListener, visualiser and controller
void userAnt(chanend fromButtons, chanend toVisualiser, chanend toController) {
    unsigned int userAntPosition = 11;       //the current defender position
    int buttonInput;                         //the input pattern from the buttonListener
    unsigned int attemptedAntPosition = 0;   //the next attempted defender position after considering button
    int moveForbidden;                       //the verdict of the controller if move is allowed
    toVisualiser <: userAntPosition;         //show initial position

    while (1) {  fromButtons :> buttonInput;
    if (buttonInput == 14) attemptedAntPosition = userAntPosition + 1;
    if (buttonInput == 7)  attemptedAntPosition = userAntPosition - 1;

    ////////////////////////////////////////////////////////////
    //
    // !!! place code here for userAnt behaviour
    //
    /////////////////////////////////////////////////////////////
    }
}

//ATTACKER PROCESS... The attacker is controlled by this process attackerAnt,
//                    which has channels to the visualiser and controller
void attackerAnt(chanend toVisualiser, chanend toController) {
    int moveCounter = 0;                       //moves of attacker so far
    unsigned int attackerAntPosition = 5;      //the current attacker position
    unsigned int attemptedAntPosition;         //the next attempted  position after considering move direction
    int currentDirection = 1;                  //the current direction the attacker is moving
    int moveForbidden = 0;                     //the verdict of the controller if move is allowed
    toVisualiser <: attackerAntPosition;       //show initial position

    while (1) {
        ////////////////////////////////////////////////////////////
        //
        // !!! place your code here for attacker behaviour
        //
        /////////////////////////////////////////////////////////////
        waitMoment();
    }
}

//COLLISION DETECTOR... the controller process responds to ¿permission-to-move¿ requests
//                      from attackerAnt and userAnt. The process also checks if an attackerAnt
//                      has moved to LED positions I, XII and XI.
void controller(chanend fromAttacker, chanend fromUser) {
    unsigned int lastReportedUserAntPosition = 11;      //position last reported by userAnt
    unsigned int lastReportedAttackerAntPosition = 5;   //position last reported by attackerAnt
    unsigned int attempt = 0;
    fromUser :> attempt;                                //start game when user moves
    fromUser <: 1;                                      //forbid first move
    while (1) {
        select {
            case fromAttacker :> attempt:
            /////////////////////////////////////////////////////////////
            //
            // !!! place your code here to give permission/deny attacker move or to end game
            //
            /////////////////////////////////////////////////////////////
            break;
            case fromUser :> attempt:
            /////////////////////////////////////////////////////////////
            //
            // !!! place your code here to give permission/deny user move
            //
            /////////////////////////////////////////////////////////////
            break;
        }
    }
}

//MAIN PROCESS defining channels, orchestrating and starting the processes
int main(void) {
    chan buttonsToUserAnt,         //channel from buttonListener to userAnt
    userAntToVisualiser,      //channel from userAnt to Visualiser
    attackerAntToVisualiser,  //channel from attackerAnt to Visualiser
    attackerAntToController,  //channel from attackerAnt to Controller
    userAntToController;      //channel from userAnt to Controller
    chan quadrant0,quadrant1,quadrant2,quadrant3; //helper channels for LED visualisation

    par {
        //PROCESSES FOR YOU TO EXPAND
        on stdcore[1]: userAnt(buttonsToUserAnt,userAntToVisualiser,userAntToController);
        on stdcore[2]: attackerAnt(attackerAntToVisualiser,attackerAntToController);
        on stdcore[3]: controller(attackerAntToController, userAntToController);

        //HELPER PROCESSES
        on stdcore[0]: buttonListener(buttons, speaker,buttonsToUserAnt);
        on stdcore[0]: visualiser(userAntToVisualiser,attackerAntToVisualiser,quadrant0,quadrant1,quadrant2,quadrant3);
        on stdcore[0]: showLED(cled0,quadrant0);
        on stdcore[1]: showLED(cled1,quadrant1);
        on stdcore[2]: showLED(cled2,quadrant2);
        on stdcore[3]: showLED(cled3,quadrant3);
    }
    return 0;
}
*/

int get_quadrant(Position position) {
    if (position <= 3) return 1;
    else if (position <= 6) return 2;
    else if (position <= 9) return 3;
    else return 4;
}

void show_led(out port quadrant, int position) {
    // LED register: 0b0cba000
    quadrant <: (1 << (4 + position));
}

void led_controller(out port quadrant, chanend communication_channel) {
    while (1) {
        int position;
        communication_channel :> position;
        show_led(quadrant, position);
    }
}


void display_ant(Ant *ant, chanend led_clocks[]) {
    // TODO: See if the chanends can be refactored into an array
    int quadrant_number = get_quadrant(ant->position);
    int position = ant->position % 3;
    switch(quadrant_number) {
    case 1:
        led_clocks[0] <: position;
        break;
    case 2:
        led_clocks[1] <: position;
        break;
    case 3:
        led_clocks[2] <: position;
        break;
    case 4:
        led_clocks[3] <: position;
        break;
    }
}

#ifndef ANT_DEFENDER_TEST
int main(void) {
    chan led_clock[4];

    par {
        // GAME LOGIC
        on stdcore[0]: {
            cledR <: 1; // Use red LED
            Ant defender = create_defender_ant();
            display_ant(&defender, led_clock);
            while (1) ;
        }
        on stdcore[1]: {
            Ant attacker = create_attacker_ant();
            //display_ant(&attacker, led_clock_for_attacker);
            while (1) ;
        }


        // LED CONTROLLERS
        on stdcore[0]: {
            led_controller(cled0, led_clock[0]);
        }
        on stdcore[1]: {
            led_controller(cled1, led_clock[1]);
        }
        on stdcore[2]: {
            led_controller(cled2, led_clock[2]);
        }
        on stdcore[3]: {
            led_controller(cled3, led_clock[3]);
        }
    }
    return 0;
}
#endif

