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
