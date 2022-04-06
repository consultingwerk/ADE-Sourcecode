/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* 
 * MPTOTAL.I
 *
 * Dumps a total to the output stream.
 * NOTE: RESETS TIMER AFTER DISPLAYING TOTAL.
 * 
 * NOTE: Do not include this file directly.  First, it will not
 *       remove itself from the count of time executed.  Second,
 *       it will not comment itself out if {&MP-DOTIMING} is not
 *       defined.  Call using mp.i as a wrapper.
 *
 * Parameters: {&TIMER} name of timer to total
 *             {&INFOSTR} text to write after the total [OPTIONAL]
 *             {&INFOVAR} var to dump to output file [OPTIONAL]
 */
 
do:                         
 /* If timer is not paused then update it */
 if mpS_{&TIMER} NE -1 then 
  do:
    mpA_{&TIMER} = mpA_{&TIMER} + (mpTime - mpS_{&TIMER}).
    mpS_{&TIMER} = mpTime.
  end.

 /* Write total to stream */
 run adeshar/mpdisp.p ("{&TIMER} total= " 
                       + STRING (mpA_{&TIMER}) 
                       + " {&INFOSTR}"
                       &IF "{&INFOVAR}" NE "" &THEN
                          + {&INFOVAR}
                       &ENDIF
                       ).

 /* Reset the timer. */
 mpA_{&TIMER} = 0.     
 mpS_{&TIMER} = mpTime. 
end.
