/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * MPPAUSE.I
 *
 * Pauses the timer.
 *
 * NOTE: Do not include this file directly.  First, it will not
 *       remove itself from the count of time executed.  Second,
 *       it will not comment itself out if {&MP-DOTIMING} is not
 *       defined.  Call using mp.i as a wrapper.
 *
 * Parameters: {&TIMER} name of timer to pause.
 */
 
 if mpS_{&TIMER} NE -1 then do:     /* If not already paused */
   mpA_{&TIMER} = mpA_{&TIMER} + (mpTime - mpS_{&TIMER}).  /* Update timer */
   mpS_{&TIMER} = -1.                                      /* Set saved time to -1 */
 end.

