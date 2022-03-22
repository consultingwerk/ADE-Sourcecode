/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _setcurs.p

Description:
   Sets the cursor on all windows and on any dialog box frames that are
   currently on the screen.
    
Input Parameters:
   p_cursor - name of cursor to use.  This should be either
      	      "WAIT" or "".

Output Parameters:
   <none>

Author: Wm.T.Wood, Laura Stern

Date Created: May 14, 1993

Modified:

----------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p_cursor  AS CHAR    	   NO-UNDO.

DEFINE VAR ldummy AS LOGICAL NO-UNDO.

&IF "{&WINDOW-SYSTEM}" ne "TTY" &THEN
   &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
      /* Set the Wait state, which changes the cursor automatically */
      ldummy = SESSION:SET-WAIT-STATE(IF p_cursor = "WAIT" THEN "GENERAL" 
      	       	     	      	       	     	      	   ELSE "").
   &ELSE /* Motif */
      /* Cycle through all current Progress windows */
      RUN set_window_cursors (SESSION).
      
      /* set_window_cursors: Recursively cycle though all childen of the
         input widget setting the cursors or windows and dialog-boxes.  
         If any child is another window, then recursively call. */
      PROCEDURE set_window_cursors:
        DEF INPUT PARAMETER hParent AS WIDGET NO-UNDO.
        
        DEF VAR hChild AS WIDGET NO-UNDO.
        
        hChild = hParent:FIRST-CHILD.
        DO WHILE hChild NE ?:
	  /* Load the pointer on WINDOWS and DIALOG-BOXES. */
          CASE hChild:TYPE:
            WHEN "DIALOG-BOX" THEN 
	      ASSIGN ldummy = hChild:LOAD-MOUSE-POINTER(p_cursor).
      	    WHEN "WINDOW" THEN DO:
	      ASSIGN ldummy = hChild:LOAD-MOUSE-POINTER(p_cursor).
      	      RUN set_window_cursors (INPUT hChild).
      	    END.
      	  END CASE.
	 
          /* Move to next child. */
	  hChild = hChild:NEXT-SIBLING.
	END.
      END PROCEDURE.
   &ENDIF
&ENDIF

