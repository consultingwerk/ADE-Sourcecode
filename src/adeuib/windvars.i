/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* ===================================================================== */
/*  windvars.i -  Shared VARIABLE Definitions for WINDOW parameters      */
/* ===================================================================== */

/* X & Y position to draw a design window */
DEFINE {1} SHARED VAR _cur_win_x    AS INTEGER 		           NO-UNDO.
DEFINE {1} SHARED VAR _cur_win_y    AS INTEGER    		   NO-UNDO.

/* Size for a new design window - GUI default */
DEFINE {1} SHARED VAR _cur_win_rows AS DECIMAL 
                                      INITIAL 21  FORMAT ">>9.99"  NO-UNDO.
DEFINE {1} SHARED VAR _cur_win_cols AS DECIMAL
                                      INITIAL 80  FORMAT ">>9.99"  NO-UNDO.
DEFINE {1} SHARED VAR _cur_win_three-d AS LOGICAL INITIAL
  &IF "{&WINDOW-SYSTEM}" NE "OSF/MOTIF" &THEN YES &ELSE NO &ENDIF  NO-UNDO.

/* Size for a new design window - TTY */
DEFINE {1} SHARED VAR _tty_win_rows AS DECIMAL 
                                    INITIAL 24  FORMAT ">>9.99"  NO-UNDO.
DEFINE {1} SHARED VAR _tty_win_cols AS DECIMAL
                                    INITIAL 80  FORMAT ">>9.99"  NO-UNDO.
/* Size for a new design window - GUI */
DEFINE {1} SHARED VAR _gui_win_rows AS DECIMAL 
                                      INITIAL 21  FORMAT ">>9.99"  NO-UNDO.
DEFINE {1} SHARED VAR _gui_win_cols AS DECIMAL
                                      INITIAL 80  FORMAT ">>9.99"  NO-UNDO.

/* Draw new window with a message area */                                    
DEFINE {1} SHARED VAR _cur_win_msg        AS LOGICAL   INITIAL no  NO-UNDO. 
/* Draw new window with a status area */                                    
DEFINE {1} SHARED VAR _cur_win_status     AS LOGICAL   INITIAL no  NO-UNDO. 
/* Draw new window with a status area */     
DEFINE {1} SHARED VAR _cur_win_scrollbars AS LOGICAL   INITIAL yes NO-UNDO.
