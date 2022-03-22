/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
