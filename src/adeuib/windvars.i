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
