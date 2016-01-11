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
{af/sup/afproducts.i}
TRIGGER PROCEDURE FOR DELETE OF rtb_task.
/*
FOR EACH rtb_tnot EXCLUSIVE-LOCK
   WHERE rtb_tnot.task-num = rtb_task.task-num:
  DELETE rtb_tnot.
END.

DEFINE VARIABLE hQuery              AS HANDLE       NO-UNDO.
DEFINE VARIABLE hBuffer             AS HANDLE       NO-UNDO.
DEFINE VARIABLE cQueryString        AS CHARACTER    NO-UNDO.

IF CONNECTED("ICFDB":U) THEN
DO:
  ASSIGN cQueryString = "FOR EACH rvm_task EXCLUSIVE-LOCK WHERE rvm_task.task_number = "
                      + STRING(rtb_task.task-num).
  CREATE QUERY hQuery.
  CREATE BUFFER hBuffer FOR TABLE "rvm_task":U.
  hQuery:ADD-BUFFER(hBuffer).
  hQuery:QUERY-PREPARE(cQueryString).
  hQuery:QUERY-OPEN().

  QueryLoop:
  REPEAT:
    hQuery:GET-NEXT().
    IF  hQuery:QUERY-OFF-END THEN LEAVE QueryLoop.

    IF hBuffer:AVAILABLE THEN
      hBuffer:BUFFER-DELETE().
    hBuffer:BUFFER-RELEASE().
  END.

  hQuery:QUERY-CLOSE().
  DELETE OBJECT hQuery.
  DELETE OBJECT hBuffer.

  ASSIGN
      hQuery = ?
      hBuffer = ?
      ERROR-STATUS:ERROR = NO.
END.
*/