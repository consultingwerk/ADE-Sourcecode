/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * MPSTART.I
 *
 * Starts a timer.
 *
 * NOTE: Do not include this file directly.  First, it will not
 *       remove itself from the count of time executed.  Second,
 *       it will not comment itself out if {&MP-DOTIMING} is not
 *       defined.  Call using mp.i as a wrapper.
 *
 * Parameters: {&TIMER} name of timer to start
 *
 */

/*
 &MESSAGE [mpstart.i] TIMER={&TIMER}; INFOSTR={&INFOSTR}; 
 &MESSAGE [mpstart.i] INFOVAR={&INFOVAR}; DELAY={&MP-DELAY};  -pat
*/
              
 mpA_{&TIMER} = 0.        /* Actual timer time is 0 */
 mpS_{&TIMER} = mpTime.   /* Set saved time to now. "Start" the timer. */
