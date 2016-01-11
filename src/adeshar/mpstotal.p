/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* 
 * MPSTOTAL.P
 *
 * This procedure writes a subtotal for the given timer to the stream of choice 
 * through mpdisp.p
 *
 * NOTE: This procedure is internal to mp.  You should not call
 *       it directly.  First, it will not remove the time it 
 *       uses from the timers.  Second it will not comment itself
 *       out if {&MP-DOTIMING} is not defined.  This procedure
 *       has an identically named include file.  Reference that
 *       through mp.i.
 *
 * Parameters: mpS- The mpS_{&TIMER} variable
 *             mpA- The mpA_{&TIMER} variable
 *             TimerName- The name of the timer (a string) to be put in stream.
 *             mpTime- the Global mp variable mpTime.
 *             InfoStr- Text to write to the stream explaining the subtotal.
 */                                                               

DEFINE INPUT-OUTPUT PARAMETER mpS AS INT NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER mpA AS INT NO-UNDO.
DEFINE INPUT        PARAMETER TimerName AS CHAR NO-UNDO.
DEFINE INPUT        PARAMETER mpTime AS INT NO-UNDO.
DEFINE INPUT        PARAMETER InfoStr AS CHAR NO-UNDO.


/* If timer is not paused, then update time from mpTime count */
if mpS NE -1 then
   do:
      /* Update actual time, and saved time for timer, before dumping */
      mpA = mpA + (mpTime - mpS).
      mpS = mpTime.
   end.

/* Now run the display function. */
run adeshar/mpdisp.p (TimerName + " subtotal = "
                      + STRING (mpA,"ZZZZZZZ9")
                      + InfoStr
                      ).

