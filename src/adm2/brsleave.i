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
/* brsleave.i - trigger code for ROW-LEAVE trigger of SmartDataBrowse - 02/18/99 */
/* If the object selected is not a SmartPanel button 
   (which could be e.g. Cancel or Reset), then save any changes to the row. 
   Otherwise let the button take the appropriate action. */
  DEFINE VARIABLE hEntered   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hFrame     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hParent    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cNewRecord AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lModified  AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hCell           AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hQuery          AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hBuffer         AS HANDLE    NO-UNDO.    
  DEFINE VARIABLE cEnabledHandles AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cModifiedFields AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iCnt            AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hUpdateTarget   AS HANDLE    NO-UNDO.

  /* 9.0B 99-02-03-026 */
  {get NewRecord cNewRecord}.
  {get EnabledHandles cEnabledHandles}.
  {get DataModified lModified}.
  
  /* Browse bug. if column is changed from blank and saved (toolbar) 
     without leaving focus the value is reset to blank on row-leave (9.1D03) */
  IF NOT lModified AND LOOKUP(STRING(FOCUS),cEnabledHandles) > 0 THEN
  DO:
    IF FOCUS:SCREEN-VALUE = '':U THEN
    DO:
      {get UpdateTarget hUpdateTarget}.
      IF VALID-HANDLE(hUpdateTarget) THEN
        FOCUS:SCREEN-VALUE = {fnarg columnValue FOCUS:NAME hUpdateTarget}.
    END.
  END.
  
  DO iCnt = 1 TO NUM-ENTRIES(cEnabledHandles):
    hCell = WIDGET-HANDLE(ENTRY(iCnt,cEnabledHandles)).
    IF hCell:MODIFIED THEN
        cModifiedFields = cModifiedFields + ',':U + STRING(hCell).
  END.
  ASSIGN
    hQuery          = {&BROWSE-NAME}:QUERY
    hBuffer         = hQuery:GET-BUFFER-HANDLE(1)
    cModifiedFields = (IF cNewRecord NE 'no':U 
                       THEN '':U 
                       ELSE STRING(hBuffer:ROWID))
                    + cModifiedFields
    .

  {set ModifiedFields cModifiedFields}.

  /* If the object has a valid frame attribute, see if it's a SmartPanel. */
  hEntered = LAST-EVENT:WIDGET-ENTER.
  IF VALID-HANDLE(hEntered) THEN hParent = hEntered:PARENT.
  IF VALID-HANDLE(hParent) AND hParent:TYPE NE "BROWSE":U
    THEN hFrame = hEntered:FRAME.  /* Can't check FRAME on Brs flds */

  IF ((NOT VALID-HANDLE(hEntered)) OR  /* Some events don't go to a widget*/
      (hParent:TYPE = "BROWSE":U) OR /* Clicked elsewhere in the Browser*/
      (NOT VALID-HANDLE(hFrame)) OR  /* Check parent Frame if present */
      (NOT CAN-DO(IF hFrame:PRIVATE-DATA EQ ? THEN "":U ELSE hFrame:PRIVATE-DATA, "ADM-PANEL":U))) /*SmartPanel?*/
  THEN DO:                                 /* If not a SmartPanel then do upd */

      /* NOTE: commented out until the V9 equivalent of this var is defined
      IF adm-brs-in-update THEN    
      DO:
        showMessage('6':U).
   /* "You must complete or cancel the update before leaving the current row."*/
        RETURN NO-APPLY.
      END.
      */
      /* If they selected some other object or the LEAVE was initiated 
         from outside then check before continuing. Otherwise just save. 
         If they were adding a new record and didn't change any initial values,
         make sure that gets Saved as well. */
       /* 9.0B 98-11-25-039 */
      IF lModified OR 
        (cNewRecord NE 'No':U AND 
         BROWSE {&BROWSE-NAME}:NUM-SELECTED-ROWS = 1) THEN
      DO:
        /* if the leave is because we went into a wait-for in the message 
           procedure then just return.. */          
        iCnt = 1.
        DO WHILE PROGRAM-NAME(iCnt) <> ?:
          iCnt = iCnt + 1.
          IF PROGRAM-NAME(iCnt) BEGINS 'showDataMessagesProcedure ':U THEN
            RETURN. 
        END.
        IF (VALID-HANDLE (hParent) AND hParent:TYPE NE "BROWSE":U) THEN
        DO:
         
          /* "Current record has been changed. save those changes?" */
          IF DYNAMIC-FUNCTION('showMessage':U, INPUT '7,Question':U) THEN
          DO:
             RUN updateRecord.
             IF RETURN-VALUE = "ADM-ERROR":U THEN DO:
                 IF VALID-HANDLE(FOCUS) THEN        /* 9.0B 99-01-26-030 */
                     APPLY "ENTRY":U TO FOCUS.           
                 RETURN NO-APPLY.
             END.    
          END.
          ELSE DO:
            RUN cancelRecord.
            IF VALID-HANDLE(hEntered) THEN
              APPLY "ENTRY":U TO hEntered.            /* 9.0B 99-01-26-030 */
          END.  
        END. 
        ELSE DO:
          RUN updateRecord.
          IF RETURN-VALUE = "ADM-ERROR":U THEN DO:
              IF VALID-HANDLE(FOCUS) THEN           /* 9.0B 99-01-26-030 */
                APPLY "ENTRY":U TO FOCUS.
              RETURN NO-APPLY.
          END.    
        END.
      END.
  END.


