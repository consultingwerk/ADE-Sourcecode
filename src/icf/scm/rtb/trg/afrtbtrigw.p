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

TRIGGER PROCEDURE FOR WRITE OF rtb_task OLD BUFFER o_rtb_task.
/*
IF NOT CONNECTED("ICFDB":U) THEN RETURN.

  DEFINE VARIABLE lv_new_area                         AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE lv_new_status                       AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE lv_loop                             AS INTEGER      NO-UNDO.
  DEFINE VARIABLE lv_modified                         AS LOGICAL      NO-UNDO.
  DEFINE VARIABLE lv_new_task                         AS LOGICAL      NO-UNDO.
  DEFINE VARIABLE lv_empty                            AS LOGICAL      NO-UNDO.

  DEFINE VARIABLE hQuery                              AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hBuffer                             AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hRtbBuffer                          AS HANDLE       NO-UNDO.
  DEFINE VARIABLE cQueryString                        AS CHARACTER    NO-UNDO.

  DEFINE VARIABLE cFields1                            AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cFields2                            AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE hField1                             AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hField2                             AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hField3                             AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hField4                             AS HANDLE       NO-UNDO.
  DEFINE VARIABLE iLoop                               AS INTEGER      NO-UNDO.

  hRtbBuffer = BUFFER rtb_task:HANDLE.

  /* Ensure summary is copied to description if description is empty, to 
     prevent recursive trigger call in rvm_task as this trigger will do this
     for rvm_task and then try to update rtb_task again
  */
  ASSIGN lv_empty = YES.
  DO lv_loop = 1 TO 15:
    IF rtb_task.description[lv_loop] <> "":U THEN ASSIGN lv_empty = NO.  
  END.
  IF lv_empty = YES THEN
    ASSIGN rtb_task.description[1] = rtb_task.summary.

  ASSIGN cQueryString = "FOR EACH rvm_task EXCLUSIVE-LOCK WHERE rvm_task.task_number = "
                      + STRING(rtb_task.task-num).
  CREATE QUERY hQuery.
  CREATE BUFFER hBuffer FOR TABLE "rvm_task":U.
  hQuery:ADD-BUFFER(hBuffer).
  hQuery:QUERY-PREPARE(cQueryString).
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST() NO-ERROR.

  IF NOT hBuffer:AVAILABLE THEN
  DO:
    hBuffer:BUFFER-CREATE().  
    ASSIGN lv_new_task = YES.
  END.

  ASSIGN
    cFields1 = "task_number," +
               "task_workspace," +
               "task_manager," +
               "task_programmer," +
               "task_status," +
               "task_entered_date," +
               "task_completed_date," +
               "task_user_reference," +
               "task_summary"
    cFields2 = "task-num," +
               "wspace-id," +
               "manager," +
               "programmer," +
               "task-status," +
               "entered-when," +
               "compltd-when," +
               "user-task-ref," +
               "summary"
    .               

  DO iLoop = 1 TO NUM-ENTRIES(cFields1):
    hField1 = hBuffer:BUFFER-FIELD(ENTRY(iLoop,cFields1)).
    hField2 = hRtbBuffer:BUFFER-FIELD(ENTRY(iLoop,cFields2)).
    hField1:BUFFER-VALUE = hField2:BUFFER-VALUE  .
  END.

  IF lv_new_task = YES THEN 
  DO:
    ASSIGN
      hField1 = hBuffer:BUFFER-FIELD("task_priority":U)
      hField1:BUFFER-VALUE = 99.
  END.

  ASSIGN lv_modified = NO.
  DO lv_loop = 1 TO 15:
    IF rtb_task.description[lv_loop] <> o_rtb_task.description[lv_loop] THEN
      DO:
        ASSIGN lv_modified = YES.
        LEAVE.
      END.
  END.

  ASSIGN
    hField1 = hBuffer:BUFFER-FIELD("task_description":U)
    hField2 = hBuffer:BUFFER-FIELD("task_summary":U)
    .
  IF lv_modified = YES THEN
    DO:
        hField1:BUFFER-VALUE = "":U.
        DO lv_loop = 1 TO 15:
          IF LENGTH(rtb_task.description[lv_loop]) > 0 THEN
            ASSIGN hField1:BUFFER-VALUE = hField1:BUFFER-VALUE +
                                               (IF LENGTH(hField1:BUFFER-VALUE) > 0 THEN CHR(10) ELSE "":U) +
                                               rtb_task.description[lv_loop].
        END.
    END.
  IF LENGTH(hField1:BUFFER-VALUE) = 0 THEN
    ASSIGN hField1:BUFFER-VALUE = hField2:BUFFER-VALUE.


  ASSIGN
    hField1 = hBuffer:BUFFER-FIELD("current_test_area":U)
    hField2 = hBuffer:BUFFER-FIELD("current_test_status":U)
    hField3 = hBuffer:BUFFER-FIELD("test_status_date":U)
    hField4 = hBuffer:BUFFER-FIELD("test_status_user":U)
    .

  /* Must have just created the rvm_task */
  IF rtb_task.task-num > 0 AND /*rtb_task.ver-counter > 0 AND*/
     hField1:BUFFER-VALUE = "":U THEN
    DO:
        ASSIGN
            lv_new_area = CAPS(ENTRY(2, rtb_task.wspace-id, "-":U))
            NO-ERROR.
        IF lv_new_area = "":U THEN ASSIGN lv_new_area = "DEV":U.
        IF lv_new_area BEGINS "D":U THEN ASSIGN lv_new_area = "DEV":U.
        IF lv_new_area BEGINS "T":U THEN ASSIGN lv_new_area = "TST":U.
        IF lv_new_area BEGINS "V":U THEN ASSIGN lv_new_area = "V1X":U.
        IF rtb_task.task-status = "C":U THEN
            ASSIGN lv_new_status = "3-COM":U.
        ELSE
            ASSIGN lv_new_status = "1-OPN":U.
        IF lv_new_status = "3-COM":U AND lv_new_area <> "DEV":U THEN
          ASSIGN lv_new_status = "4-TOT":U.

      ASSIGN
        hField1:BUFFER-VALUE = lv_new_area
        hField2:BUFFER-VALUE = lv_new_status
        hField3:BUFFER-VALUE = rtb_task.entered-when
        hField4:BUFFER-VALUE = rtb_task.programmer
        .

    END.

  hBuffer:BUFFER-RELEASE().

  hQuery:QUERY-CLOSE().
  DELETE OBJECT hQuery.
  DELETE OBJECT hBuffer.
  DELETE OBJECT hRtbBuffer.

  ASSIGN
      hQuery = ?
      hBuffer = ?
      hRtbBuffer = ?
      ERROR-STATUS:ERROR = NO.
*/