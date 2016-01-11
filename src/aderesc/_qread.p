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
/* _qread.p - read in form view query file header
*
*    The basis for this file was prores/q-read.p
*/

{ aderes/s-system.i }
{ aderes/s-define.i }

DEFINE INPUT  PARAMETER qbf-f AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER lRet  AS LOGICAL   NO-UNDO.

DEFINE SHARED VARIABLE convDir AS CHARACTER NO-UNDO.
DEFINE SHARED VARIABLE appName AS CHARACTER NO-UNDO.
DEFINE SHARED VARIABLE appDir  AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-c      AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-i      AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-j      AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-m      AS CHARACTER NO-UNDO EXTENT 9.
DEFINE VARIABLE qbf-v      AS CHARACTER NO-UNDO.
DEFINE VARIABLE fieldName3 AS CHARACTER NO-UNDO.
DEFINE VARIABLE fieldInfo  AS CHARACTER NO-UNDO.
DEFINE VARIABLE dName      AS CHARACTER NO-UNDO.
DEFINE VARIABLE tName      AS CHARACTER NO-UNDO.

DEFINE STREAM qbf-io.

ASSIGN
  qbf-rc# = 0
  qbf-c   = SEARCH(appDir + qbf-f + ".p":u)
  qbf-c   = SUBSTRING(qbf-c,1,LENGTH(qbf-c,"CHARACTER":u) 
                            - LENGTH(qbf-f,"CHARACTER":u) - 2,"CHARACTER":u)
  .

IF qbf-c = ? THEN DO:
  MESSAGE SUBSTITUTE("Form &1.p could not be found.",qbf-f)
    VIEW-AS ALERT-BOX ERROR.
  lRet = TRUE.
  RETURN.
END.

INPUT STREAM qbf-io FROM VALUE(qbf-c + qbf-f + ".p":u) NO-ECHO.

REPEAT:
  qbf-m = "".
  IMPORT STREAM qbf-io qbf-m.
  
  IF qbf-m[1] BEGINS "#":u THEN NEXT.
  IF qbf-m[1] = "*":u + "/":u THEN LEAVE.
 
  IF qbf-m[1] MATCHES "file1=":u THEN /* not "file*=" for now */
    ASSIGN
      dName  = ENTRY(1,qbf-m[2],".":u)
      tName  = qbf-m[2]
      .

  ELSE IF qbf-m[1] MATCHES "field*=":u THEN DO:
    fieldName3 = tName + ".":u + qbf-m[2]. /* name */

    /* The following hunk of code was copied from y-field.p */
    RUN adecomm/_y-schem.p (fieldName3,"","",OUTPUT fieldInfo).

    qbf-j = MAXIMUM(1,INTEGER(ENTRY(2,fieldInfo))).

    /* For all but array fields, this will iterate only once */
    DO qbf-i = 1 TO qbf-j:
      ASSIGN
        qbf-rc#          = qbf-rc# + 1
        qbf-rcn[qbf-rc#] = fieldName3
                         + (IF qbf-j = 1 THEN "" ELSE
                              "[":u + STRING(qbf-i) + "]":u)
        qbf-rcl[qbf-rc#] = ENTRY(3,fieldInfo,CHR(10))
                         + (IF qbf-j = 1 THEN "" ELSE
                              "[":u + STRING(qbf-i) + "]":u)
        qbf-rcf[qbf-rc#] = ENTRY(2,fieldInfo,CHR(10))
        qbf-rcg[qbf-rc#] = ""
        qbf-rct[qbf-rc#] = INTEGER(ENTRY(1,fieldInfo))
        qbf-rcc[qbf-rc#] = ""
        qbf-rcs[qbf-rc#] = ""
        qbf-rcp[qbf-rc#] = ",,,,,,,,":u
        .
    END. 
  END.
  /* for now, ignore: include= */
END.

INPUT STREAM qbf-io CLOSE.

RETURN.

/* _qread.p - end of file */

