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
 * i-read.p - read in user directory
 */
 
{ aderes/s-system.i }
{ aderes/i-define.i }
{ aderes/j-define.i }
 
DEFINE INPUT-OUTPUT PARAMETER qbf-d AS CHARACTER NO-UNDO. /* source directory */
 
DEFINE VARIABLE qbf-a AS LOGICAL            NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-c AS LOGICAL            NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-i AS INTEGER            NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-l AS CHARACTER EXTENT 4 NO-UNDO. /* input line */
DEFINE VARIABLE qbf-j AS INTEGER            NO-UNDO.
 
DEFINE VARIABLE qbf-f AS CHARACTER NO-UNDO.
 
RUN adecomm/_statdsp.p (wGlbStatus, 1, "").
 
IF qbf-dir-ent# = 0 THEN
  RUN adecomm/_statdsp.p (wGlbStatus, 1, "Reading directory...":l72).
 
ASSIGN
  qbf-dir-ent    = ""
  qbf-dir-dbs    = ""
  qbf-dir-flg    = FALSE
  qbf-dir-num    = 0
  qbf-j          = 0
.
 
qbf-f = search(qbf-d).
RUN is_valid_qdfile (qbf-f, OUTPUT qbf-a).
 
IF NOT qbf-a THEN DO:
  qbf-d = ?.
  RUN adecomm/_statdsp.p (wGlbStatus, 1, "").
  RETURN.
END.
 
_outer:
DO ON ERROR UNDO,RETRY:
  INPUT FROM VALUE(qbf-f) NO-ECHO.
  
  REPEAT:
    qbf-l = ?.
    IMPORT qbf-l.
 
    IF qbf-l[1] MATCHES "query[*]=":u THEN DO:
      qbf-j = qbf-j + 1.
 
      /* If we hit the limit tell the user and then leave. */
       IF qbf-j > 256 THEN DO:
         RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-c,"information":u,"ok":u,
           SUBSTITUTE("The limit of entries in &1 has been reached. The remaining entries will not be used.",
           qbf-f)).
        LEAVE.
      END.
 
      ASSIGN
        qbf-dir-num[qbf-j] = 
          INTEGER(SUBSTRING(qbf-l[1],7,LENGTH(qbf-l[1],"CHARACTER":u) - 8,
                            "CHARACTER":u))
        qbf-dir-ent[qbf-j] = qbf-l[3]
        qbf-dir-dbs[qbf-j] = qbf-l[4]
      .
 
      /* Set the "Connected" databases flag. This is used in the UI */
      DO qbf-i = 1 TO NUM-ENTRIES(qbf-l[4])
        WHILE CAN-DO(qbf-dbs, ENTRY(qbf-i,qbf-l[4])):
 
        IF qbf-i = NUM-ENTRIES(qbf-l[4]) THEN qbf-dir-flg[qbf-j] = TRUE.
      END.
    END.
    ELSE IF qbf-l[1] = "results.forward=":u AND qbf-d = qbf-qdhome THEN DO:
      qbf-i = SEEK(INPUT).
      INPUT CLOSE.
      RUN is_valid_qdfile (qbf-l[2],OUTPUT qbf-a).
      IF qbf-a THEN DO:
        qbf-d = SEARCH(qbf-l[2]).
        UNDO _outer,RETRY _outer.
      END.
      INPUT FROM VALUE(qbf-d) NO-ECHO.
      SEEK INPUT TO qbf-i.
    END.
 
  END.
  INPUT CLOSE.
END.
 
qbf-dir-ent# = qbf-j.
 
RUN adecomm/_statdsp.p (wGlbStatus, 1, "").
 
RETURN.
 
/*---------------------------------------------------------------------------*/
PROCEDURE is_valid_qdfile:
  DEFINE INPUT  PARAMETER qbf_q AS CHARACTER NO-UNDO. /* qd file in question */
  DEFINE OUTPUT PARAMETER qbf_o AS LOGICAL INITIAL FALSE NO-UNDO. /* answer */
 
  DEFINE VARIABLE qbf-f AS CHARACTER          NO-UNDO.
  DEFINE VARIABLE qbf_l AS CHARACTER EXTENT 2 NO-UNDO. /* input lines */
 
  /*
   * If the file exists and is of the right extension then we've found a
   * directory file. Note: The definition for qdExt includes the '.'
   */
  qbf-f = search(qbf_q).
  IF qbf-f= ? 
    OR {&qdExt} <> SUBSTRING(qbf_q,LENGTH(qbf_q,"CHARACTER":u) 
                                   - (LENGTH({&qdExt},"CHARACTER":u) - 1),
                             -1,"CHARACTER":u) THEN RETURN.
 
  INPUT FROM VALUE(qbf-f) NO-ECHO.
  REPEAT WHILE NOT qbf_o:
    IMPORT qbf_l.
    qbf_o = (qbf_l[1] = "config=":u AND qbf_l[2] = "directory":u).
  END.
  INPUT CLOSE.
 
END PROCEDURE. /* is_valid_qdfile */
 
/* i-read.p - end of file */

