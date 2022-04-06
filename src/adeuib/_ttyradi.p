/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _ttyradi.p

Description:
    Draws a tty style radio-set in an editor widget (in order to simulate what
    a TTY terminal would be doing).
    
    For example:         Using:
       ( ) Item 1          _F._LIST-ITEMS (contains the buttons)
       ( ) Item 2
       ( ) Item 3

Input Parameters:
   h_ed        : the handle of the editor widget (I do check to make sure the
   	         h_ed:TYPE is EDITOR.
   is_horz     : FALSE if radio-set is VERTICAL
   radio-btns  : the char radio-button phrase.
   
Output Parameters:
   <None>

Author:   Wm.T.Wood

Date Created: October 1, 1992 

----------------------------------------------------------------------------*/

/* -------------------------- INPUT PARAMETERS --------------------------- */
define input parameter h_ed          as widget-handle 	    	     NO-UNDO.
define input parameter is_horz       as logical		    	     NO-UNDO.
define input parameter rbs           as char		    	     NO-UNDO.

/* ---------------------------- LOCAL CONSTANTS --------------------------- */
/* The new-line and box characters used to simulate a TTY.                  */
&Scoped-define NL  CHR(10)
/* ---------------------------- LOCAL VARIABLES --------------------------- */
define var radio-text   as char					     NO-UNDO.
define var r-item       as char					     NO-UNDO.
define var spacer       as char					     NO-UNDO.
define var i 		as integer				     NO-UNDO.
define var cnt 		as integer				     NO-UNDO.
/* Make sure we are in an editor realization of a radio-set widget */
IF h_ed:TYPE <> "EDITOR" THEN return.
 
/* Gap character is a space in Horizontal, and new-line for Vertical buttons. */
ASSIGN cnt        = NUM-ENTRIES(rbs,{&NL}) 
       i          = 1
       spacer     = IF is_horz THEN " " ELSE {&NL} 
       radio-text = "".
 
DO WHILE i <=  cnt:
  r-item = TRIM(ENTRY(i,rbs,{&NL})).
  r-item = ENTRY(2,r-item,"~"").
  radio-text = radio-text + "( )" + r-item + spacer.
  /* Check next line */
  i = i + 1.
END.

/* Now assign the value to the editor */
h_ed:SCREEN-VALUE = radio-text.
