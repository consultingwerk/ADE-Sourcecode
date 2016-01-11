/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _ttyedit.p

Description:
    Draws a tty style editor in an editor widget (in order to simulate what
    a TTY terminal would be doing).
    
    For example:         
    ___________________#
    ___________________ 
    ___________________#
    ___________________#
    # #################

Input Parameters:
   h_self : the handle of the editor widget (I do check to make sure the
   	    h_self:TYPE is EDITOR.
   h-bar  : TRUE for a horizontal scrollbar.
   v-bar  : TRUE for a vertical scrollbar.

Output Parameters:
   <None>

Author:   Wm.T.Wood

Date Created: December 12, 1992 

----------------------------------------------------------------------------*/
/* --------------------------- INPUT PARAMETERS --------------------------- */
define input parameter h_ed          as widget-handle 	    	     NO-UNDO.
define input parameter h-bar         as logical  init false 	     NO-UNDO.
define input parameter v-bar         as logical  init false 	     NO-UNDO.
  
/* ---------------------------- LOCAL CONSTANTS --------------------------- */
/* The new-line and box characters used to simulate a TTY.                  */
&Scoped-define NL  CHR(10)
&Scoped-define BOX CHR(127)

/* ---------------------------- LOCAL VARIABLES --------------------------- */
define var simulator as char					     NO-UNDO.
define var aline  as char					     NO-UNDO.
define var i      as integer 					     NO-UNDO.
define var wdth   as integer 					     NO-UNDO.
define var hgt    as integer 					     NO-UNDO.
  
/* Make sure we are in an editor realization of a slider widget */
IF h_ed:TYPE <> "EDITOR" THEN return.

/* Find out how big we can build our slider */
ASSIGN wdth      = h_ed:INNER-CHARS
       hgt       = h_ed:INNER-LINES
       simulator = "".

/* Editor is a line of "______" followed by a box on all but the second line.*/
IF (hgt > 0) AND (wdth > 4) THEN DO:
  aline = FILL ("_",wdth + IF v-bar THEN 1 ELSE 0).
  DO i = 1 TO (hgt):
    simulator = simulator + aline + " " + {&NL}.
  END. 
END.
  
/* Now assign the value to the editor */
h_ed:SCREEN-VALUE = simulator.
