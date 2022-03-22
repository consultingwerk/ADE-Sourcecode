/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* genshar.i - shared variables for adeuib/_gendefs.p.  This is defined
 *             in adeshar/_gen4gl.p, adeuib/_qikcomp.p and adeuib/_writedf.p 
 * By: Wm.T.Wood 
 * On: March 14, 1995
 */
 
DEFINE {1} SHARED VARIABLE CreatingSuper AS LOGICAL                    NO-UNDO.
DEFINE {1} SHARED VAR      curr_frame    AS CHAR                       NO-UNDO.
DEFINE {1} SHARED VARIABLE first_browse  AS CHAR                       NO-UNDO.
DEFINE {1} SHARED VARIABLE frame_name_f  AS CHAR                       NO-UNDO.
DEFINE {1} SHARED VAR      layout-var    AS CHAR                       NO-UNDO.
DEFINE {1} SHARED VARIABLE menubar_name  AS CHAR                       NO-UNDO.
DEFINE {1} SHARED VARIABLE stmnt_strt    AS INTEGER                    NO-UNDO.
DEFINE {1} SHARED VARIABLE tty_win       AS LOGICAL                    NO-UNDO.
DEFINE {1} SHARED VARIABLE u_status      AS CHARACTER INITIAL "NORMAL" NO-UNDO.
DEFINE {1} SHARED VARIABLE win_name      AS CHAR                       NO-UNDO.
DEFINE {1} SHARED VARIABLE wndw          AS LOGICAL                    NO-UNDO.
