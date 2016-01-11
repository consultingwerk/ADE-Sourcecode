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
/*
 * i-zap.p - selection list for mass-removal of queries from directory
 */

&GLOBAL-DEFINE WIN95-BTN YES

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/i-define.i }
{ adecomm/adestds.i }
{ aderes/_fdefs.i }
{ aderes/reshlp.i }

DEFINE VARIABLE qbf-a     AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-c     AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-i     AS INTEGER   NO-UNDO. /* scrap */

DEFINE VARIABLE r-pos     AS INTEGER   NO-UNDO.
DEFINE VARIABLE queryName AS CHARACTER NO-UNDO.
DEFINE VARIABLE fullLine  AS CHARACTER NO-UNDO.
DEFINE VARIABLE readable  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE writable  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE qbf-d     AS CHARACTER NO-UNDO. /* current active qd file */
DEFINE VARIABLE qbf-m     AS LOGICAL   NO-UNDO. /* true=changing qbf-qdfile */
DEFINE VARIABLE qbf-s     AS CHARACTER NO-UNDO. /* selection list */
DEFINE VARIABLE del-msg   AS CHARACTER NO-UNDO.

DEFINE BUTTON qbf-pd LABEL "Public &Directory" SIZE 24 BY 1.
DEFINE BUTTON qbf-au LABEL "D&irectory..."     SIZE 24 BY 1.

DEFINE BUTTON qbf-ok   LABEL "OK"     {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON qbf-ee   LABEL "Cancel" {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON qbf-help LABEL "&Help"   {&STDPH_OKBTN}.

/* standard button rectangle */
DEFINE RECTANGLE rect_btns {&STDPH_OKBOX}.

FORM
  SKIP({&TFM_WID})

  qbf-s AT 2 NO-LABEL
    VIEW-AS SELECTION-LIST MULTIPLE INNER-CHARS 45 INNER-LINES 12
    SCROLLBAR-VERTICAL SCROLLBAR-HORIZONTAL
  SKIP({&VM_WID})

  qbf-qdshow AT 2 LABEL "&Show Queries on Disconnected Databases" 
    VIEW-AS TOGGLE-BOX

  {adecomm/okform.i
    &BOX    = rect_btns
    &STATUS = NO
    &OK     = qbf-ok
    &CANCEL = qbf-ee
    &HELP   = qbf-help}

  "Switch listing to:" AT COLUMN 52 ROW 3
  SKIP({&VM_WID})
  
  qbf-pd AT 52
  SKIP({&VM_WID})
  
  qbf-au AT 52
  
  WITH FRAME qbf-qdir SIDE-LABELS THREE-D
  DEFAULT-BUTTON qbf-Ok CANCEL-BUTTON qbf-ee
  TITLE " ":u SCROLLABLE VIEW-AS DIALOG-BOX.

/*--------------------------------------------------------------------------*/

ON DEFAULT-ACTION OF qbf-s
  APPLY "GO":u TO FRAME qbf-qdir.

ON HELP OF FRAME qbf-qdir OR CHOOSE OF qbf-Help IN FRAME qbf-qdir
  RUN adecomm/_adehelp.p ("res":u, "CONTEXT":u, {&Delete_Queries_Dlg_Box}, ?).

ON GO OF FRAME qbf-qdir DO:
  DEFINE VARIABLE delCount AS INTEGER NO-UNDO.
  
  qbf-a = FALSE.
  
  IF qbf-s:SCREEN-VALUE IN FRAME qbf-qdir <> ? THEN DO:
    ASSIGN
      delCount = NUM-ENTRIES(qbf-s:SCREEN-VALUE, CHR(10))
      del-msg  = STRING(delCount) + IF (delCount > 1 ) THEN 
                                      " queries have " ELSE " query has "
      .
    RUN adecomm/_s-alert.p(INPUT-OUTPUT qbf-a,"question":u,"ok-cancel":u,
      SUBSTITUTE("&1 been selected to be deleted.  Choose OK to confirm this operation.",
      del-msg)).
  END.

  IF qbf-a THEN DO:
    RUN adecomm/_setcurs.p("WAIT":u).
    /*
    * Walk through the list and delete the selected queries.
    * Because of disconnected queries it is a little tricky. The
    * database names have been appended to those tables.
    *
    *  1. Try to delete the selection. If no error then fine.
    *  2. If there was an error, then it must be a disconnected
    *     query. Strip the database names and delete that.
    */

    DO qbf-i = 1 TO NUM-ENTRIES(qbf-s:SCREEN-VALUE, CHR(10)):
      queryName = ENTRY(qbf-i, qbf-s:SCREEN-VALUE, CHR(10)).
      RUN deleteQuery(queryName, OUTPUT qbf-a).

      IF NOT qbf-a THEN DO:
        /* Strip the name and delete again */
        queryName = SUBSTRING(queryName,1,
                      R-INDEX(queryName,"(":u) - 1,"CHARACTER":u).

        RUN deleteQuery(queryName, OUTPUT qbf-a).

        /* The following message should never get hit. */
        IF NOT qbf-a THEN
          RUN adecomm/_s-alert.p(INPUT-OUTPUT qbf-a,"error":u,"ok":u,
            SUBSTITUTE("Query Directory datastructures are not correct for &1.",
            queryName)).
      END.
    END.

    RUN aderes/i-write.p (?).
    RUN adecomm/_setcurs.p ("").
  END.
  ELSE
    RETURN NO-APPLY.
END.

ON CHOOSE OF qbf-ee IN FRAME qbf-qdir
  qbf-m = FALSE.

ON CHOOSE OF qbf-pd IN FRAME qbf-qdir DO:
  r-pos = R-INDEX(qbf-qdpubl,"~\":u).

  IF r-pos = 0 THEN
     r-pos = R-INDEX(qbf-qdpubl,"~:":u).

  ASSIGN
    r-pos      = r-pos + 1
    qbf-qdpubl = SUBSTRING(qbf-qdpubl,r-pos,LENGTH(qbf-qdpubl,"CHARACTER":u),
                           "CHARACTER":u)
    qbf-qdpubl = SEARCH(qbf-qdpubl)
    qbf-d      = (IF qbf-qdfile MATCHES "*PUBLIC*" THEN 
                    qbf-qdhome ELSE qbf-qdpubl)
    .

  RUN aderes/_ifile.p(qbf-d, OUTPUT readable, OUTPUT writable, OUTPUT qbf-a).

  qbf-m = TRUE.

  IF NOT writable THEN DO:
    RUN adecomm/_s-alert.p(INPUT-OUTPUT qbf-a,"information":u,"ok":u,
      SUBSTITUTE("You do not have permission to write to &1.  You cannot delete queries in this directory.",
      qbf-d)).
    RETURN NO-APPLY.
  END.

  ASSIGN 
    qbf-c            = SUBSTRING(
                         IF qbf-d MATCHES "*Public*" THEN
                           IF USERID("RESULTSDB":u) = "" THEN "Personal"
                           ELSE            CAPS(qbf-qdhome) + "'s"
                         ELSE "Public"
                         ,1,8,"FIXED":u) + " ":u + "&Directory"
    qbf-c            = FILL(" ":u,INTEGER(10 - LENGTH(qbf-c,"RAW":u) / 2)) 
                     + qbf-c
    qbf-pd:LABEL IN FRAME qbf-qdir = STRING(qbf-c,"x(20)":u)
    _qdWritable      = writable
    _qdReadable      = readable
    qbf-ok:SENSITIVE = TRUE
    .
END.

ON VALUE-CHANGED OF qbf-qdshow IN FRAME qbf-qdir DO:
  qbf-qdshow = INPUT FRAME qbf-qdir qbf-qdshow.

  DO qbf-i = 1 TO EXTENT(qbf-dir-ent):
    IF NOT qbf-dir-flg[qbf-i] AND qbf-dir-ent[qbf-i] <> "" THEN DO:

      /* We'll show the names of the other databases for the
       * disconnected databases */
      fullLine = qbf-dir-ent[qbf-i] + " (" + qbf-dir-dbs[qbf-i] + ")".

       /*
       * Use the text version to delete, since other things may have
       * been deleted making the numbers obsolete.
       */
      IF NOT qbf-qdshow THEN
        qbf-a = qbf-s:DELETE(fullLine).

      ELSE
      IF qbf-i > qbf-s:NUM-ITEMS THEN 
        qbf-a = qbf-s:ADD-LAST(fullLine).
      ELSE
        /* Insert the entry using the *number* version of insert.  */
        qbf-a = qbf-s:INSERT(fullLine, qbf-i).
    END.
  END.
END.

/*----- ANOTHER USER BUTTON -----*/
ON CHOOSE OF qbf-au IN FRAME qbf-qdir DO:

  hook:
  DO ON STOP UNDO hook, RETRY hook:
    IF RETRY THEN DO:
      RUN adecomm/_s-alert.p(INPUT-OUTPUT qbf-a,"error":u,"ok":u,
        SUBSTITUTE("There is a problem with &1.  &2 cannot change directories.  This feature will no longer be available.",
        _dirSwitch,qbf-product)).

      ASSIGN
        qbf-au:SENSITIVE IN FRAME qbf-qdir = FALSE
        _dirSwitch                         = ?.

      LEAVE hook.
    END.

    RUN VALUE(_dirSwitch) (INPUT-OUTPUT qbf-d, OUTPUT qbf-a).
    IF NOT qbf-a THEN
      RETURN NO-APPLY.  
      

    RUN aderes/_ifile.p(qbf-d, OUTPUT readable, OUTPUT writable, OUTPUT qbf-a).

    IF NOT writable THEN DO:
      RUN adecomm/_s-alert.p(INPUT-OUTPUT qbf-a,"information":u,"ok":u,
        SUBSTITUTE("You do not have permission to write to &1.  You cannot delete queries in this directory.",
        qbf-d)).
      RETURN NO-APPLY.
    END.

    ASSIGN
      qbf-m            = TRUE
      _qdWritable      = writable
      _qdReadable      = readable
      qbf-ok:SENSITIVE = TRUE
      .
  END.
END.

ON WINDOW-CLOSE OF FRAME qbf-qdir
  APPLY "END-ERROR":u TO SELF.

/*--------------------------------------------------------------------------*/

/* Run time layout for button area.  This defines eff_frame_width */
{adecomm/okrun.i
  &FRAME = "FRAME qbf-qdir"
  &BOX   = "rect_btns"
  &OK    = "qbf-ok"
  &HELP  = "qbf-help"
  }
  
IF NOT _qdWritable THEN
  RUN adecomm/_s-alert.p(INPUT-OUTPUT qbf-a,"information":u,"ok":u,
    SUBSTITUTE("You do not have permission to write to &1.  You cannot delete queries in this directory.",
    qbf-qdfile)).

/* The following code helps determine where the PUBLIC.QD7 file 'currently' 
   resides. */ 
r-pos = R-INDEX(qbf-qdpubl,"~\":u).

IF r-pos = 0 THEN
   r-pos = R-INDEX(qbf-qdpubl,"~:":u).

ASSIGN
   qbf-d                             = qbf-qdfile
   qbf-s:DELIMITER IN FRAME qbf-qdir = CHR(10)
   qbf-s:SENSITIVE IN FRAME qbf-qdir = TRUE
   r-pos                             = r-pos + 1
   qbf-qdpubl                        = SUBSTRING(qbf-qdpubl,r-pos,
                                         LENGTH(qbf-qdpubl,"CHARACTER":u),
                                         "CHARACTER":u)
   qbf-qdpubl                        = SEARCH(qbf-qdpubl)
 .

 IF qbf-d MATCHES "*Public*" THEN 
   ASSIGN 
     qbf-d      = qbf-qdpubl
     qbf-qdfile = qbf-d
     qbf-c      = SUBSTRING(
                    IF qbf-d MATCHES "*Public*" THEN
                      IF USERID("RESULTSDB":u) = "" THEN "Personal"
                      ELSE USERID("RESULTSDB":u) + "'s"
                    ELSE "Public"
                      ,1,8,"FIXED":u) + " ":u + "&Directory"
     qbf-c      = FILL(" ":u,INTEGER(10 - LENGTH(qbf-c,"RAW":u) / 2)) + qbf-c
     qbf-pd:LABEL IN FRAME qbf-qdir = STRING(qbf-c,"x(20)":u)
     .
           
IF qbf-dir-ent# = 0 THEN
  RUN aderes/i-read.p (INPUT-OUTPUT qbf-d).

/*
* Load up the selection list. Make sure the list has the proper set
* of things. If the user has previous selected show disconnected
* queries they have got to be loaded in
*/

DO qbf-i = 1 TO EXTENT(qbf-dir-ent):
  /* If we're not showing disconnected queries and this has a disconnected
   * query then move on */
  IF qbf-dir-ent[qbf-i] = "" OR
    (qbf-dir-flg[qbf-i] = FALSE AND qbf-qdshow = FALSE) THEN NEXT.

  /*
  * Build the line, depending on the disconnected query. Tthe then
  * clause will executed for disconnected database and we are to
  * show them
  */
  IF qbf-dir-flg[qbf-i] = FALSE THEN
    fullLine = qbf-dir-ent[qbf-i] + " (":u + qbf-dir-dbs[qbf-i] + ")":u.
  ELSE
    fullLine = qbf-dir-ent[qbf-i].

  qbf-a = qbf-s:ADD-LAST(fullLine) IN FRAME qbf-qdir.
END.

APPLY "ENTRY":u TO qbf-s IN FRAME qbf-qdir.

DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
  ASSIGN 
    qbf-c = SUBSTRING(
            IF qbf-d MATCHES "*Public*" THEN
               IF USERID("RESULTSDB":u) = "" THEN "Personal"
               ELSE            
                  CAPS(qbf-qdhome) + "'s"
               ELSE "Public"
               ,1,8,"FIXED":u) + " ":u + "&Directory"
    qbf-c = FILL(" ":u,INTEGER(10 - LENGTH(qbf-c,"RAW":u) / 2)) + qbf-c
    qbf-pd:LABEL IN FRAME qbf-qdir = STRING(qbf-c,"x(20)":u)
  
    qbf-s:SCREEN-VALUE IN FRAME qbf-qdir      = ""
    qbf-qdshow:SCREEN-VALUE IN FRAME qbf-qdir = STRING(qbf-qdshow,"yes/no":u)
    qbf-qdshow:SENSITIVE IN FRAME qbf-qdir    = TRUE
    FRAME qbf-qdir:TITLE                      = "Delete -":t20 + " " 
                                              + CAPS(qbf-qdfile)
    qbf-ok:SENSITIVE IN FRAME qbf-qdir        = (_qdWritable)
    qbf-ee:SENSITIVE IN FRAME qbf-qdir        = TRUE
    qbf-Help:SENSITIVE IN FRAME qbf-qdir      = TRUE
    .

  IF qbf-s:NUM-ITEMS > 0 THEN
    qbf-s:SCREEN-VALUE = qbf-s:ENTRY(1).

  qbf-pd:SENSITIVE IN FRAME qbf-qdir = (_rPublic AND _wPublic).
  qbf-au:SENSITIVE IN FRAME qbf-qdir = (_rOther AND _wOther).

  VIEW FRAME qbf-qdir.

  WAIT-FOR CHOOSE OF qbf-ok IN FRAME qbf-qdir
    OR     GO     OF           FRAME qbf-qdir
    OR     CHOOSE OF qbf-pd IN FRAME qbf-qdir
    OR     CHOOSE OF qbf-au IN FRAME qbf-qdir
    .

  IF qbf-m THEN DO:
    RUN adecomm/_setcurs.p("WAIT":u).

    ASSIGN
      qbf-c            = qbf-d
      qbf-qdfile       = qbf-c
      qbf-s:LIST-ITEMS = ""
      .

    RUN aderes/i-read.p (INPUT-OUTPUT qbf-c).

    IF qbf-dir-ent# > 0 THEN DO:
      qbf-m = FALSE.
      DO qbf-i = 1 TO EXTENT(qbf-dir-ent):
        IF qbf-dir-ent[qbf-i] = "" OR
          (qbf-dir-flg[qbf-i] = FALSE AND qbf-qdshow = FALSE) THEN NEXT.

        IF qbf-dir-flg[qbf-i] = FALSE THEN
          fullLine = qbf-dir-ent[qbf-i] + " (" + qbf-dir-dbs[qbf-i] + ")".
        ELSE
          fullLine = qbf-dir-ent[qbf-i].

        qbf-a = qbf-s:ADD-LAST(fullLine) IN FRAME qbf-qdir.
      END.
    END.
    RUN adecomm/_setcurs.p ("").
    UNDO,RETRY.
  END.
END.

HIDE FRAME qbf-qdir NO-PAUSE.
RETURN.

/*---------------------------------------------------------------------------*/
PROCEDURE deleteQuery:
  DEFINE INPUT  PARAMETER queryName AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER qbf-s     AS LOGICAL   NO-UNDO INITIAL FALSE.

  DEFINE VARIABLE qbf-i  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE f-name AS CHARACTER NO-UNDO.

  RUN aderes/s-prefix.p (qbf-qdfile, OUTPUT qbf-c).

  DO qbf-i = 1 TO EXTENT(qbf-dir-ent):
    IF queryName = qbf-dir-ent[qbf-i] THEN DO:

      /* Delete the file off of the disk, as well as from our datastructures */
      f-name = qbf-c + "que":u + STRING(qbf-dir-num[qbf-i],"99999":u) + ".p":u.

      /* Delete the file. Don't flag any errors. IF the file is already gone
       * then fine. */
      OS-DELETE VALUE(f-name).

      ASSIGN
        qbf-s              = TRUE
        qbf-dir-ent#       = qbf-dir-ent# - 1
        qbf-dir-dbs[qbf-i] = ""
        qbf-dir-num[qbf-i] = 0
        qbf-dir-ent[qbf-i] = ""
        qbf-dir-flg[qbf-i] = FALSE
        .
    END.
  END.
END PROCEDURE.

/* i-zap.p - end of file */

