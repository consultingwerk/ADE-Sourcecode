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
