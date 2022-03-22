/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
