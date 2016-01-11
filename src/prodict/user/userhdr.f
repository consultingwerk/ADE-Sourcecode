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


/* userhdr.f - user interface shared frame definitions */

DEFINE {1} SHARED FRAME user_hdr.

&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
  
  FORM
    user_hdr FORMAT "x(60)" 
    "Data Dictionary "
    WITH FRAME user_hdr 
    ROW SCREEN-LINES - 1 COLUMN 1 
    NO-BOX ATTR-SPACE NO-LABELS USE-TEXT
    COLOR DISPLAY VALUE(head-bg) PROMPT VALUE(head-bg).
&ENDIF

DEFINE {1} SHARED FRAME user_ftr.
FORM
  user_dbname   FORMAT "x(28)" LABEL "Database"
  user_filename FORMAT "x(34)" LABEL "Table"
  WITH FRAME user_ftr 
  ROW SCREEN-LINES COLUMN 1 &if "{&window-system}" = "ms-windows" &then width 95 &endif
  NO-BOX NO-ATTR-SPACE SIDE-LABELS USE-TEXT.

COLOR DISPLAY VALUE(head-fg) user_dbname user_filename WITH FRAME user_ftr.
