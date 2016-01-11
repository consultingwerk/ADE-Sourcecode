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

/*----------------------------------------------------------------------------

File: _treldat.p

Description:
   Display table relations to the currently set output device (e.g., a file, 
   the printer).
 
Input Parameters:
   p_DbId    - Id of the _Db record for this database.
   p_Tbl     - The table to show relations for or "ALL"

Author: Tony Lavinio, Laura Stern

Date Created: 10/12/92

Modified on 06/14/94 by Gerry Seidl. Added NO-LOCKs to file accesses.        
Modified on 02/22/95 by D McMann to work with the AS/400 Data Dictionary
            07/14/98 D. McMann Removed _file check
----------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p_DbId  AS RECID NO-UNDO.
DEFINE INPUT PARAMETER p_Tbl   AS CHAR  NO-UNDO.

DEFINE SHARED STREAM rpt.

DEFINE WORKFILE g_relate NO-UNDO
  FIELD g_owner  LIKE as4dict.p__File._File-name
  FIELD g_member LIKE as4dict.p__File._File-name
  FIELD g_idx    LIKE as4dict.p__Index._Index-name.

DEFINE BUFFER g_mfile  FOR as4dict.p__File.
DEFINE BUFFER g_xfield FOR as4dict.p__Field.
DEFINE BUFFER g_xfile  FOR as4dict.p__File.

DEFINE VARIABLE noway    AS LOGICAL NO-UNDO.
DEFINE VARIABLE line     AS CHAR    NO-UNDO.  

FORM
  line FORMAT "x(77)" NO-LABEL
  WITH FRAME rptline DOWN NO-BOX USE-TEXT STREAM-IO.

FORM 
  SKIP(1)
  SPACE(3) g_mfile._File-name LABEL "Working on" FORMAT "x(32)" SPACE
  SKIP(1)
  WITH FRAME working_on SIDE-LABELS VIEW-AS DIALOG-BOX 
  TITLE "Generating Report".

/*-----------------------------Mainline code---------------------------*/

IF p_Tbl = "ALL" THEN
  SESSION:IMMEDIATE-DISPLAY = yes.

FOR EACH g_mfile NO-LOCK
  WHERE (IF p_Tbl = "ALL" THEN g_mfile._Hidden = "N"
                        ELSE g_mfile._File-name = p_Tbl):

  IF p_Tbl = "ALL" THEN
    DISPLAY g_mfile._File-name WITH FRAME working_on.

  /* Clear work file */
  FOR EACH g_relate NO-LOCK: DELETE g_relate.  END.

  FOR
    EACH as4dict.p__Index WHERE as4dict.p__Index._Unique = "y",
    EACH as4dict.p__File  WHERE as4dict.p__File._File-number = as4dict.p__Index._File-number,
    EACH as4dict.p__Idxfd WHERE as4dict.p__Idxfd._File-number = as4dict.p__Index._File-number
                            AND as4dict.p__Idxfd._Idx-num = as4dict.p__Index._Idx-num
                            AND  as4dict.p__Idxfd._If-Misc2[8]<> "Y" ,                 
     EACH as4dict.p__Field WHERE as4dict.p__Field._Fld-number = as4dict.p__Idxfd._Fld-number
                            AND as4dict.p__Field._File-number = as4dict.p__Idxfd._File-number NO-LOCK:

    IF as4dict.p__Idxfd._Index-seq = 1 THEN
      FOR EACH g_xfield WHERE g_xfield._Field-name = as4dict.p__Field._Field-name
        AND g_xfield._Fld-number <> as4dict.p__Field._Fld-number
        AND g_Xfield._File-number <> as4dict.p__Field._File-number,
        EACH g_xfile where g_xfile._file-number = g_xfield._File-number NO-LOCK:
        IF g_mfile._File-name <> as4dict.p__File._File-name
          AND g_mfile._File-name <> g_xfile._File-name THEN NEXT.
        CREATE g_relate.
        ASSIGN
          g_relate.g_owner  = as4dict.p__File._File-name
          g_relate.g_member = g_xfile._File-name
          g_relate.g_idx    = as4dict.p__Index._Index-name.
      END.
    ELSE
      FOR EACH g_relate
        WHERE g_idx = as4dict.p__Index._Index-name 
          AND g_owner = as4dict.p__File._File-name,
        EACH g_xfile WHERE g_xfile._File-name = g_member NO-LOCK:
        IF NOT CAN-FIND(g_xfield where g_xfield._File-number = g_xfile._File-number
          AND g_xfield._Field-name = as4dict.p__Field._Field-name) 
          AND available g_relate
          THEN DELETE g_relate.
      END.   
  END.

  FOR EACH g_relate NO-LOCK BREAK BY g_owner BY g_member:
    IF NOT (FIRST-OF(g_member) AND LAST-OF(g_member)) THEN DELETE g_relate.
  END.

  DISPLAY STREAM rpt g_mfile._File-nam + ":" @ line WITH FRAME rptline.
  DOWN STREAM rpt WITH FRAME rptline.
  line= ?.

  FOR EACH g_relate NO-LOCK WHERE g_owner = g_mfile._File-name BY g_owner:
    line = "  " + g_member + " OF " + g_owner + " ".
    FIND g_xfile NO-LOCK WHERE g_xfile._File-name = g_owner.
    FIND as4dict.p__Index WHERE as4dict.p__Index._File-number = g_xfile._File-number
                            AND as4dict.p__Index._Index-name = g_idx NO-LOCK.
    FOR EACH as4dict.p__Idxfd WHERE as4dict.p__Idxfd._File-number = as4dict.p__Index._File-number
                                AND as4dict.p__Idxfd._Idx-num = as4dict.p__Index._Idx-num,
      EACH as4dict.p__Field where as4dict.p__Field._File-number =  as4dict.p__Idxfd._File-number
                              AND as4dict.p__Field._Fld-number = as4dict.p__idxfd._Fld-number NO-LOCK:
      line = line + STRING(as4dict.p__Idxfd._Index-seq > 1,",/(") + as4dict.p__Field._Field-name.
    END.
    line = line + ")".
    DISPLAY STREAM rpt line WITH FRAME rptline.
    DOWN STREAM rpt WITH FRAME rptline.
  END.

  FOR EACH g_relate NO-LOCK 
        WHERE g_member = g_mfile._File-name BY g_member:
    line = "  " + g_member + " OF " + g_owner + " ".
    FIND g_xfile NO-LOCK WHERE g_xfile._File-name = g_owner.
    FIND as4dict.p__Index where as4dict.p__Index._File-number = g_xfile._File-number 
                            AND as4dict.p__Index._Index-name = g_idx NO-LOCK.
    FOR EACH as4dict.p__Idxfd where as4dict.p__Idxfd._File-number = as4dict.p__Index._File-number
                                and as4dict.p__Idxfd._Idx-num = as4dict.p__Index._Idx-num
                                and as4dict.p__Idxfd._If-misc2[8] <> "Y",
         EACH as4dict.p__Field where as4dict.p__Field._File-number = as4dict.p__Idxfd._File-number
                                 and as4dict.p__Field._Fld-number = as4dict.p__idxfd._Fld-number NO-LOCK:
      line = line + STRING(as4dict.p__Idxfd._Index-seq > 1,",/(") + 
                            as4dict.p__Field._Field-name.
    END.
    line = line + ")".
    DISPLAY STREAM rpt line WITH FRAME rptline.
    DOWN STREAM rpt WITH FRAME rptline.
  END.

  IF line = ? THEN DO:
    DISPLAY STREAM rpt "   No relations found for this file." 
      @ line WITH FRAME rptline.
    DOWN STREAM rpt 2 WITH FRAME rptline.
  END.
  ELSE
    DOWN STREAM rpt 1 WITH FRAME rptline.
END.

IF p_Tbl = "ALL" THEN DO:
  HIDE FRAME working_on NO-PAUSE. 
  SESSION:IMMEDIATE-DISPLAY = no.
END.

/* _treldat.p - end of file */

