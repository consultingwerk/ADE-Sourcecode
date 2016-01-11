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
 * MPDECL.I
 *
 * Declares a timer.  Does NOT initalize the timer.  Also declares
 * the standard mp globals.  This file should be included once for 
 * each timer that will be used in a file.
 *
 * Note: This can't take itself out of the timing stream because it 
 *       gets called TO DECLARE the variables.
 *
 * Parameters: {&TIMER} name of the timer to declare/init.
 */
 
&IF "{&MP-DOTIMING}" NE "" &THEN  
  &IF "{&MP-DROP-{&TIMER}}" EQ "" &THEN
    {adeshar/mpd.i} /* Include mp globals */                        
  
    /* These two lines used to be in mpdtimer.i.  But, no more. */
    define new global SHARED var mpA_{&TIMER} as int no-undo.  /* actual time */
    define new global SHARED var mpS_{&TIMER} as int no-undo.  /* saved time */
  &ENDIF
&ENDIF
