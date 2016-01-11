/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
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

