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
 * MP.I 
 *
 * Main macro.  Most macros are called "through" this one.
 *
 * Globals   : {&MP-DOTIMING} Global define used to comment out mp.
 * Parameters: {&MP-MACRO} submacro to call
 *             {&TIMER} name of timer to use.  Restrict to one token.
 *             {&INFOSTR} string parameter for macros that use them.
 *             {&INFOVAR} variable reference for macros that use them.
 *             {&MP-DELAY} hundreths' of seconds to delay, for delay macro.
 *             {&MP-DEBUG} define as anything to include useful &MESSSAGE.
 *
 */

/* If debugging display some helpful info. */
&IF "{&MP-DEBUG}" NE "" &THEN
  &MESSAGE [mp.i] MP-DOTIMING= {&MP-DOTIMING}
  &MESSAGE [mp.i] MP-DROP-{&TIMER}= {&MP-DROP-{&TIMER}}
  &MESSAGE [mp.i] >MP-MACRO = {&MP-MACRO} 
  &MESSAGE [mp.i] >>TIMER={&TIMER}; INFOSTR={&INFOSTR}; 
  &MESSAGE [mp.i] >>INFOVAR={&INFOVAR}; DELAY={&MP-DELAY};
&ENDIF

&IF {&mp-dotiming} &THEN
   &IF "{&MP-DROP-{&TIMER}}" EQ "" &THEN
     
     &IF "{&MP-MACRO}" EQ "delay" &THEN
         &MESSAGE [mp.i] Include mpdelay.i directly.  Won't do any good otherwise.
     &ENDIF

     do:                                          
       /* Timer will reflect time since last mp.i call-- which is 
        * the last place mpSavedEtime was updated. */
       mpTime = mpTime + (etime - mpSavedEtime).            

       /* Call appropriate submacro */
       /* Sub macros reference all preprocessor names EXACTLY the same as those
          passed to mp.i. So, pass `em all on*/
       {adeshar/mp{&MP-MACRO}.i {&*}}

       /* Restart mpSavedTime */
       mpSavedEtime = etime. 
     end.
   &ENDIF
&ENDIF
