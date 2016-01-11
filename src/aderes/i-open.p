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
 * i-open.p - handle "File->New" and "File->Open" events
 */

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/y-define.i }
{ aderes/i-define.i }
{ aderes/reshlp.i }

/*
IN:
qbf-v = ""  for File->Open
        "b" for File->New->Browse
        "r" for File->New->Report
        "f" for File->New->Form
        "l" for File->New->Label
        "e" for File->New->Export
        ?   for File->Close
        "*" for File->Open     standalone report writer (not used)
        "%" for File->Generate

OUT:
lRet  = TRUE if open (or new) etc succeeds or if current query must be
      	cleared, FALSE if we should just leave things as is, e.g., user
      	Canceled out.

This routine can be called with qbf-v = ?, as in File->Close.  In
that case, it will check if the current query is dirty, and offer
to save it.  It will then initialize a new query, just in case.
*/

DEFINE INPUT  PARAMETER qbf-v AS CHARACTER NO-UNDO. /* which view? */
DEFINE OUTPUT PARAMETER lRet  AS LOGICAL   NO-UNDO. /* main_loop in y-menu.p */

DEFINE VARIABLE qbf-a           AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-f           AS CHARACTER NO-UNDO EXTENT 5. /* filters */
DEFINE VARIABLE qbf-l           AS LOGICAL   NO-UNDO. /* active query */
DEFINE VARIABLE qbf-n           AS CHARACTER NO-UNDO. /* name */
DEFINE VARIABLE queryIndex      AS INTEGER   NO-UNDO.
DEFINE VARIABLE queryName       AS CHARACTER NO-UNDO.
DEFINE VARIABLE queryFileNumber AS INTEGER   NO-UNDO.
DEFINE VARIABLE fileName        AS CHARACTER NO-UNDO.

ASSIGN
  qbf-v = TRIM(qbf-v)
  qbf-f[1] = (IF OPSYS = "UNIX":u THEN "*.[piw]":u ELSE "*.p~;*.i~;*.w":u)
  qbf-f[2] = "*.p":u
  qbf-f[3] = "*.i":u
  qbf-f[4] = "*.w":u
  qbf-f[5] = (IF OPSYS = "UNIX":u THEN "*":u ELSE "*.*":u).
  
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* Handle File->Generate */

IF qbf-v = "%":u THEN DO:
  SYSTEM-DIALOG GET-FILE qbf-report
    ASK-OVERWRITE
    DEFAULT-EXTENSION ".p":u
    RETURN-TO-START-DIR
    SAVE-AS
    TITLE "Generate 4GL":t32
    UPDATE qbf-a
    FILTERS
      "Procedures":t20 + " (":u + qbf-f[2] + ")":u qbf-f[2],
      "Includes":t20   + " (":u + qbf-f[3] + ")":u qbf-f[3],

      "Windows":t20    + " (":u + qbf-f[4] + ")":u qbf-f[4],
      "All Files":t20  + " (":u + qbf-f[5] + ")":u qbf-f[5]
      INITIAL-FILTER 1.
 
  lRet = FALSE. /* don't need to refresh since nothing's changed */
  IF NOT qbf-a THEN RETURN.

  RUN adecomm/_setcurs.p ("WAIT":u).
  RUN adecomm/_statdsp.p (wGlbStatus,1,"Generating " + qbf-report + "...":u).
  RUN aderes/s-write.p (qbf-report,"g":u).
  RUN adecomm/_statdsp.p (wGlbStatus,1,"").
  RUN adecomm/_setcurs.p ("":u).

  RETURN.
END.

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* This block allows the user to save the current query.    */
/* This is done no matter what when this program is called. */
   
IF qbf-module = ? OR qbf-tables = "" THEN
  qbf-dirty = FALSE.

IF qbf-dirty THEN DO:
    
  qbf-a = TRUE.
  RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"question":u,"yes-no-cancel":u,
    "Do you want to save the current query first?").

  IF qbf-a THEN DO:
    RUN aderes/i-opnsav.p (1,OUTPUT queryIndex,OUTPUT qbf-a).

    /* User cancelled save */
    IF qbf-a THEN RETURN.
  END.
  ELSE IF qbf-a = ? THEN DO:
    lRet = FALSE.
    RETURN.
  END.
END.

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* If user requested New or Close we must start from scratch with
   reinitialized field arrays etc.  For New, if the user cancels in the 
   middle - too late to put him back where he was.  So clear the current 
   state before starting New processing.  If, instead, user is doing Open 
   and he Cancels, he should just remain where he was.
*/
IF INDEX("brfle":u, qbf-v) > 0 OR qbf-v = "?":u THEN DO:
  /* shut down all display windows */
  FOR EACH qbf-wsys:
    RUN aderes/y-page2.p ("c":u,qbf-wsys.qbf-wwin,0).
  END.
  qbf-preview = 0. /* reset Print Preview numbering */
  
  RUN aderes/s-zap.p (FALSE). /* reset to defaults */
END.

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* now, if File->New something, then initialize that view. */

IF INDEX("brfle":u, qbf-v) > 0 THEN DO:
  qbf-module = qbf-v.
  RUN aderes/y-table.p (OUTPUT qbf-a).

  ASSIGN
    qbf-dirty  = TRUE
    qbf-redraw = TRUE. 
END.

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* this is executing a File->Open */

ELSE IF qbf-v = "" THEN DO:
  RUN adecomm/_statdsp.p (wGlbStatus, 1, "").

  /* Display the query directory to the user */
  RUN aderes/i-opnsav.p (3, OUTPUT queryIndex, OUTPUT qbf-a).

  /* User cancelled open */
  IF qbf-a THEN RETURN.

  IF queryIndex > 0 THEN DO:
    ASSIGN
      queryName       = qbf-dir-ent[queryIndex]
      queryFileNumber = qbf-dir-num[queryIndex]
    .

    RUN adecomm/_setcurs.p ("WAIT":u).
    DO ON ERROR UNDO, LEAVE:
      RUN aderes/s-prefix.p (qbf-qdfile,OUTPUT qbf-n).

      ASSIGN
        qbf-n    = qbf-n + "que":u 
                 + STRING(queryFileNumber,"99999":u) + ".p":u
        fileName = SEARCH(qbf-n)
        .

      IF fileName = ? THEN DO:
        RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u,
          SUBSTITUTE("There is a problem opening &1.  The file &2 cannot be found or does not exist.",queryName,qbf-n)).

        RUN adecomm/_setcurs.p ("").
        RETURN.
      END.

      RUN aderes/s-read.p (fileName,"open":u,OUTPUT qbf-a).
    END.

    /* query cannot be opened, so close any open query - dma */
    IF NOT qbf-a THEN do:
      RUN aderes/i-open.p ("?":u,OUTPUT qbf-a).
      qbf-redraw = TRUE.
      RETURN.
    END.

    RUN adecomm/_setcurs.p ("":u).

    /*
     * Check to make sure that the query description in the query file
     * matches the name found in the query directory. A mismatch can
     * occur if users have been copying files outside of Results. The main
     * thing is the catch this error so that Results doesn't explode later.
     */
    qbf-redraw = TRUE.

    IF qbf-name <> queryName THEN DO:
      /*
       * If the user has the ability to update the query directory then
       * give the user the option. Otherwise, just dump out a message
       * and leave. Also, handle the permission situation.
       */
      IF qbf-qdfile <> qbf-qdhome THEN DO:
        IF qbf-qdfile = qbf-qdpubl THEN qbf-l = _wPublic.
                                   ELSE qbf-l = _wOther.
      END.
      ELSE qbf-l = TRUE.

      IF qbf-l and _qdWritable THEN DO:
        RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"question":u,"yes-no":u, 
          SUBSTITUTE("There is a problem between the query and its entry in the query directory.  The names do not match.^^Query Name:^>  &1^Directory Entry:^>  &2^^Choose YES to update the query directory or NO to abort this operation.",
          qbf-name,queryName)).
          
        IF qbf-a THEN DO:
          /* Put the directory in synch and write out the query directory. */
          RUN adecomm/_setcurs.p ("WAIT":u).

          qbf-dir-ent[queryIndex] = qbf-name.
          RUN aderes/i-write.p (?).
          RUN adecomm/_setcurs.p ("").
        END.
        ELSE DO:
          RUN aderes/i-open.p ("?":u, OUTPUT qbf-a).
          qbf-redraw = TRUE.
          RETURN.
        END.
      END.
      ELSE DO:
        RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u, 
          SUBSTITUTE("There is a problem between the query and its entry in the query directory.  The names do not match.^^Query Name:^>  &1^Directory Entry:^>  &2^^The query cannot be opened.",
          qbf-name,queryName)).

        RUN aderes/i-open.p ("?":u, OUTPUT qbf-a).
        qbf-redraw = TRUE.
        RETURN.
      END.
    END.
  END.
END. /* qbf-v = "" */

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* Close the current query */
ELSE IF qbf-v = "?" THEN
  qbf-redraw = TRUE.

/* User really did open */
IF qbf-v = "" AND qbf-a THEN DO:
  /* shut down all display windows */
  FOR EACH qbf-wsys:
    RUN aderes/y-page2.p ("c":u,qbf-wsys.qbf-wwin,0).
  END.
  qbf-redraw = TRUE.
END.
	
RETURN.

/* i-open - end of file */ 

