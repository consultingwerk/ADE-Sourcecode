/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * MPDROP.I
 *
 * Include this file if you want to prevent a specific timer
 * from being included in the build.  Only parsed if global 
 * timing is turned on.
 *
 * NOTE: You cannot call this macro through mp.i
 *       ALSO, this only affects the CURRENT file. (Scope 
 *       of &GLOBAL-DEFINE)
 *
 * Parameters: {&TIMER} Name of timer to stop including.
 */             
 
&IF "{&MP-DOTIMING}" NE "" &THEN /* if timing is on then process */
  &MESSAGE Shut off timer {&TIMER}
  &GLOBAL-DEFINE MP-DROP-{&TIMER} DROPPED
&ENDIF
