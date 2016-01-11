/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * MPDO.I
 *
 * This file doesn't actually do anything.  Its just a handy
 * counter-part to mpdrop.i.  We use it in our global include
 * file which controls which timers are run.
 *
 * NOTE: Don't call this as a macro through mp.i
 *
 * Parameters: {&TIMER} Name of timer to continue including.
 */             
 
&IF "{&MP-DOTIMING}" NE "" &THEN /* if timing is on then process */
  &MESSAGE Using timer {&TIMER}
&ENDIF
