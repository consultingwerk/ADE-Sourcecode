/*************************************************************/
/* Copyright (c) 1984-2005,2008,2010 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*----------------------------------------------------------------------------

File: adecomm/_auddtl.p

Description:
   Details frame for displaying audit data and audit data values.
   Called by selecting a record in Custom Filter browse.
 
Input Parameters:
   prRowid - Rowid of record to display
   pcTable - Table name to display
   phQuery - Handle to the query for the audData browse   
   
Author: Kenneth S. McIntosh

Date Created: August 19, 2005
History:
      fernando Aug  11, 2008 Fixing _Transaction-id format
      fernando 01/05/2010    Expanding _Transaction-id format

----------------------------------------------------------------------------*/
{adecomm/commeng.i}  /* Help contexts */
{adecomm/adestds.i}  /* Standard layout defines, colors etc. */
{adecomm/adeintl.i}  /* International support */
{adecomm/aud-tts.i}  /* Audit Data Temp-Tables */

DEFINE INPUT  PARAMETER prRowid AS ROWID       NO-UNDO.
DEFINE INPUT  PARAMETER pcTable AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER phQuery AS HANDLE      NO-UNDO.

DEFINE VARIABLE grCurrentData AS ROWID       NO-UNDO.
DEFINE VARIABLE grCurrentVal  AS ROWID       NO-UNDO.

DEFINE VARIABLE gcReportType  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE rsSortVals    AS CHARACTER   NO-UNDO
  VIEW-AS RADIO-SET
    RADIO-BUTTONS "Field Name","_field-name",
                  "Continuation Sequence","cs",
                  "Data Type","_data-type-name"
    HORIZONTAL.
DEFINE VARIABLE gcLastSort    AS CHARACTER   NO-UNDO.

DEFINE VARIABLE glEnd         AS LOGICAL     NO-UNDO.

DEFINE BUTTON btnOk      LABEL "OK"       {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON btnNext    LABEL "&Next"    {&STDPH_OKBTN}.
DEFINE BUTTON btnPrev    LABEL "&Prev"    {&STDPH_OKBTN}.
DEFINE BUTTON btnFirst   LABEL "&First"   {&STDPH_OKBTN}.
DEFINE BUTTON btnLast    LABEL "&Last"    {&STDPH_OKBTN}.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  DEFINE BUTTON    btnHelp  LABEL "&Help" {&STDPH_OKBTN}.
  DEFINE RECTANGLE rectBtns {&STDPH_OKBOX}. /* standard button rectangle */
  
  &GLOBAL-DEFINE HLP_BTN  &HELP = "btnHelp"
  &GLOBAL-DEFINE SPC      10
  &GLOBAL-DEFINE SUMMARY guiSummaryFrame
  &GLOBAL-DEFINE DETAIL  guiDetailFrame
&ELSE
  &GLOBAL-DEFINE HLP_BTN  
  &GLOBAL-DEFINE SPC     5 
  &GLOBAL-DEFINE SUMMARY ttySummaryFrame
  &GLOBAL-DEFINE DETAIL  ttyDetailFrame
&ENDIF

DEFINE QUERY qAudDataValue   FOR audDataValue SCROLLING.

DEFINE BROWSE bAudDataValue QUERY qAudDataValue
        DISPLAY audDataValue._field-name
                audDataValue._continuation-sequence
                audDataValue._data-type-name
        &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
          ENABLE audDataValue._field-name &ENDIF
        WITH WIDTH &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 76 2
                   &ELSE 98 5 &ENDIF DOWN FONT 0 
                   EXPANDABLE SCROLLBAR-VERTICAL .

/*=========================== Forms ====================================*/

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  FORM SKIP(1) 
     audData._audit-data-guid FORMAT "x(30)" 
                              COLON 33
                              VIEW-AS TEXT SKIP
     audData._transaction-id  FORMAT "->>>>>>>>>9"
                              COLON 33 
                              VIEW-AS TEXT SKIP
     audData._transaction-seq FORMAT ">>>>>ZZZ"
                              COLON 33 
                              VIEW-AS TEXT SKIP
     audData._audit-date-time FORMAT "99/99/9999 HH:MM:SS AM" 
                              COLON 33 
                              VIEW-AS TEXT SKIP
     audData._event-name      FORMAT "x(40)" 
                              COLON 33 
                              VIEW-AS TEXT SKIP
     audData._event-type      FORMAT "x(40)" 
                              COLON 33 
                              VIEW-AS TEXT SKIP
     audData._db-guid         FORMAT "x(45)" 
                              COLON 33 
                              VIEW-AS TEXT SKIP
     audData._db-description  FORMAT "x(40)" 
                              COLON 33 
                              VIEW-AS TEXT SKIP
     audData._database-connection-id
                              FORMAT "x(40)" 
                              COLON 33 
                              VIEW-AS TEXT SKIP
     audData._client-session-uuid
                              FORMAT "x(40)" 
                              COLON 33 
                              VIEW-AS TEXT SKIP
     audData._Audit-data-security-level-name
                              FORMAT "x(35)" 
                              LABEL "Security Level"
                              COLON 33 
                              VIEW-AS TEXT SKIP
     audData._data-sealed     FORMAT "Yes/No" 
                              COLON 33 
                              VIEW-AS TEXT SKIP(1)
     bAudDataValue

     {adecomm/okform.i
      &BOX    = rectBtns
      &STATUS = no
      &OK     = btnOK
      &OTHER  = " SPACE({&SPC}) btnFirst btnPrev btnNext btnLast "
      {&HLP_BTN}
     } 

  WITH FRAME guiSummaryFrame SIDE-LABELS 
                             WIDTH 100 
                             NO-ATTR-SPACE  
                             DOWN FONT 0
                             CANCEL-BUTTON btnOK SCROLLABLE
                             VIEW-AS DIALOG-BOX
                             TITLE "OpenEdge Custom Audit Filter Report".
&ELSE
  FORM  
     audData._audit-data-guid FORMAT "x(27)" 
                              COLON 18
                              VIEW-AS TEXT SKIP
     audData._transaction-id  FORMAT "->>>>>>>>>9" 
                              COLON 18 
                              VIEW-AS TEXT 
     audData._transaction-seq FORMAT "ZZZ"  
                              COLON 60
                              VIEW-AS TEXT 
                              LABEL "Txn Sequence" SKIP
     audData._Audit-data-security-level-name
                              FORMAT "x(33)"
                              LABEL "Security Level"
                              COLON 18
                              VIEW-AS TEXT
     audData._data-sealed     FORMAT "Yes/No"
                              LABEL "Sealed?"
                              COLON 60
                              VIEW-AS TEXT SKIP
     audData._audit-date-time FORMAT "99/99/9999 HH:MM:SS AM" 
                              COLON 18
                              VIEW-AS TEXT SKIP
     audData._event-name      FORMAT "x(25)" 
                              COLON 18 
                              VIEW-AS TEXT
     audData._event-type      FORMAT "x(15)"
                              COLON 60
                              VIEW-AS TEXT
     audData._db-guid         FORMAT "x(27)" 
                              COLON 18 
                              VIEW-AS TEXT
                              LABEL "Db Identifier" SKIP
     audData._db-description  FORMAT "x(55)" 
                              COLON 18
                              LABEL "Db Description" SKIP
     audData._database-connection-id
                              FORMAT "x(27)" 
                              COLON 18 
                              VIEW-AS TEXT 
                              LABEL "Db Connection Id" SKIP
     audData._client-session-uuid
                              FORMAT "x(27)" 
                              COLON 18
                              VIEW-AS TEXT
                              LABEL "Client Sess UUID" SKIP
     rsSortVals               LABEL "Sort by" SKIP
     bAudDataValue            

     {adecomm/okform.i
      &BOX    = rectBtns
      &STATUS = no
      &OK     = btnOK
      &OTHER  = " SPACE({&SPC}) btnFirst btnPrev btnNext btnLast "
      {&HLP_BTN}
     } 

  WITH FRAME ttySummaryFrame SIDE-LABELS 
                             WIDTH 78
                             NO-ATTR-SPACE  
                             DOWN FONT 0
                             CANCEL-BUTTON btnOK SCROLLABLE
                             VIEW-AS DIALOG-BOX
                             TITLE "OpenEdge Custom Audit Filter Report"
                             ROW 1.

&ENDIF

&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
  BROWSE bAudDataValue:HELP    = 
        "Select record and hit " + KBLABEL("RETURN") + " to view details...".
&ELSE
  BROWSE bAudDataValue:TOOLTIP = 
        "Double-Click or hit " + KBLABEL("RETURN") + " to view details...".
  audDataValue._field-name:READ-ONLY IN BROWSE bAudDataValue = TRUE.
&ENDIF

FORM audDataValue._audit-data-guid  FORMAT "x(30)"
                                    LABEL "Audit data guid"
                                    VIEW-AS TEXT
                                    COLON 25
     audDataValue._continuation-sequence FORMAT "->9"
                                    LABEL "Event Sequence"
                                    VIEW-AS TEXT
                                    COLON 25 
     audDataValue._field-name       FORMAT "x(30)"
                                    VIEW-AS TEXT
                                    COLON 25 
     audDataValue._data-type-name   FORMAT "x(30)"
                                    VIEW-AS TEXT
                                    COLON 25
     audDataValue._old-string-value FORMAT "x(30)"
                                    VIEW-AS EDITOR
                                            SIZE 60 BY 3
                                    COLON 25 
     audDataValue._new-string-value FORMAT "x(30)"
                                    VIEW-AS EDITOR
                                            SIZE 60 BY 3
                                    COLON 25 SKIP(1)

    {adecomm/okform.i
      &BOX    = rectBtns
      &STATUS = no
      &OK     = btnOK
      &OTHER  = "SPACE({&SPC}) btnFirst btnPrev btnNext btnLast "
      {&HLP_BTN}
     }

    WITH FRAME guiDetailFrame SIDE-LABELS
                           NO-ATTR-SPACE USE-TEXT
                           WIDTH &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 78
                                 &ELSE 100 &ENDIF
                           DOWN CANCEL-BUTTON btnOK
                           SCROLLABLE FONT 0
                           VIEW-AS DIALOG-BOX
                           TITLE "OpenEdge Custom Audit Filter Report". 

FORM audDataValue._audit-data-guid  FORMAT "x(30)"
                                    LABEL "Audit data guid"
                                    VIEW-AS TEXT
                                    COLON 25
     audDataValue._continuation-sequence FORMAT "->9"
                                    LABEL "Event Sequence"
                                    VIEW-AS TEXT
                                    COLON 25 
     audDataValue._field-name       FORMAT "x(30)"
                                    VIEW-AS TEXT
                                    COLON 25 
     audDataValue._data-type-name   FORMAT "x(30)"
                                    VIEW-AS TEXT
                                    COLON 25
     audDataValue._old-string-value FORMAT "x(30)"
                                    VIEW-AS EDITOR
                                            SIZE 50 BY 3
                                    COLON 25 
     audDataValue._new-string-value FORMAT "x(30)"
                                    VIEW-AS EDITOR
                                            SIZE 50 BY 3
                                    COLON 25 SKIP(1)

    {adecomm/okform.i
      &BOX    = rectBtns
      &STATUS = no
      &OK     = btnOK
      &OTHER  = "SPACE({&SPC}) btnFirst btnPrev btnNext btnLast "
      {&HLP_BTN}
     }

    WITH FRAME ttyDetailFrame SIDE-LABELS
                           NO-ATTR-SPACE USE-TEXT
                           WIDTH &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 78
                                 &ELSE 100 &ENDIF
                           DOWN CANCEL-BUTTON btnOK
                           SCROLLABLE FONT 0
                           VIEW-AS DIALOG-BOX
                           TITLE "OpenEdge Custom Audit Filter Report". 

&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
  rsSortVals:HELP IN FRAME ttySummaryFrame = "Select item to sort browse. (" +
                                             KBLABEL("CTRL-R") +
                                             " to reverse direction)".
&ENDIF

/*===========================Control Triggers=============================*/
ON START-SEARCH OF BROWSE bAudDataValue DO:
  DEFINE VARIABLE hCol AS HANDLE      NO-UNDO.

  hCol = SELF:CURRENT-COLUMN.
  RUN resortQuery ( INPUT hCol:NAME ).
  APPLY "END-SEARCH" TO SELF.
END.

ON DEFAULT-ACTION OF BROWSE bAudDataValue DO:
  IF NOT AVAILABLE audDataValue THEN
    RETURN NO-APPLY.

  grCurrentVal = ROWID(audDataValue).

  gcReportType = "audDataValue".

  RUN initializeUI ( INPUT grCurrentVal  ).
  HIDE FRAME {&DETAIL}.

  gcReportType = "audData".
END.

&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
  ON VALUE-CHANGED OF rsSortVals IN FRAME {&SUMMARY}
    RUN resortQuery ( INPUT SELF:SCREEN-VALUE ).

  ON CTRL-R OF rsSortVals IN FRAME {&SUMMARY}
    RUN resortQuery ( INPUT SELF:SCREEN-VALUE ).
&ENDIF

ON CHOOSE OF btnOk IN FRAME {&SUMMARY} OR
   GO     OF          FRAME {&SUMMARY}
  glEnd = TRUE.

ON CHOOSE OF btnLast IN FRAME {&SUMMARY} DO:
  DEFINE VARIABLE rTempRow AS ROWID       NO-UNDO.

  DEFINE VARIABLE hBuffer  AS HANDLE      NO-UNDO.

  hBuffer = phQuery:GET-BUFFER-HANDLE(1).

  phQuery:GET-LAST() NO-ERROR.

  IF NOT hBuffer:AVAILABLE THEN DO:
    MESSAGE "You have reached the last Audit Data record."
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RETURN NO-APPLY.
  END.

  rTempRow = hBuffer:ROWID.
  FIND audData WHERE ROWID(audData) = rTempRow NO-LOCK NO-ERROR.
  RUN showAudData.
  grCurrentData = ROWID(audData).
END.

ON CHOOSE OF btnNext IN FRAME {&SUMMARY} DO:
  DEFINE VARIABLE rTempRow AS ROWID       NO-UNDO.

  DEFINE VARIABLE hBuffer  AS HANDLE      NO-UNDO.

  hBuffer = phQuery:GET-BUFFER-HANDLE(1).

  phQuery:REPOSITION-TO-ROWID(grCurrentData).
  phQuery:GET-NEXT() NO-ERROR.

  IF NOT hBuffer:AVAILABLE THEN DO:
    MESSAGE "You have reached the last Audit Data record."
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RETURN NO-APPLY.
  END.

  rTempRow = hBuffer:ROWID.
  FIND audData WHERE ROWID(audData) = rTempRow NO-LOCK NO-ERROR.
  RUN showAudData.
  grCurrentData = ROWID(audData).
END.

ON CHOOSE OF btnPrev IN FRAME {&SUMMARY} DO:
  DEFINE VARIABLE rTempRow AS ROWID       NO-UNDO.

  DEFINE VARIABLE hBuffer  AS HANDLE      NO-UNDO.

  hBuffer = phQuery:GET-BUFFER-HANDLE(1).

  phQuery:REPOSITION-TO-ROWID(grCurrentData).
  phQuery:GET-PREV() NO-ERROR.

  IF NOT hBuffer:AVAILABLE THEN DO:
    MESSAGE "You have reached the first Audit Data record."
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RETURN NO-APPLY.
  END.

  rTempRow = hBuffer:ROWID.
  FIND audData WHERE ROWID(audData) = rTempRow NO-LOCK NO-ERROR.
  RUN showAudData.
  grCurrentData = ROWID(audData).
END.

ON CHOOSE OF btnFirst IN FRAME {&SUMMARY} DO:
  DEFINE VARIABLE rTempRow AS ROWID       NO-UNDO.

  DEFINE VARIABLE hBuffer  AS HANDLE      NO-UNDO.

  hBuffer = phQuery:GET-BUFFER-HANDLE(1).

  phQuery:GET-FIRST() NO-ERROR.

  IF NOT hBuffer:AVAILABLE THEN DO:
    MESSAGE "You have reached the first Audit Data record."
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RETURN NO-APPLY.
  END.

  rTempRow = hBuffer:ROWID.
  FIND audData WHERE ROWID(audData) = rTempRow NO-LOCK NO-ERROR.
  RUN showAudData.
  grCurrentData = ROWID(audData).
END.

ON CHOOSE OF btnNext IN FRAME {&DETAIL} DO:
  QUERY qAudDataValue:REPOSITION-TO-ROWID(grCurrentVal).
  QUERY qAudDataValue:GET-NEXT() NO-ERROR.
  
  IF NOT AVAILABLE audDataValue THEN DO:
    MESSAGE "You have reached the last Audit Data Value record."
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RETURN NO-APPLY.
  END.
  RUN showAudDataValue.
  grCurrentVal = ROWID(audDataValue).
END.

ON CHOOSE OF btnLast IN FRAME {&DETAIL} DO:
  QUERY qAudDataValue:GET-LAST() NO-ERROR.
  
  IF NOT AVAILABLE audDataValue THEN DO:
    MESSAGE "You have reached the last Audit Data Value record."
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RETURN NO-APPLY.
  END.
  RUN showAudDataValue.
  grCurrentVal = ROWID(audDataValue).
END.

ON CHOOSE OF btnPrev IN FRAME {&DETAIL} DO:
  QUERY qAudDataValue:REPOSITION-TO-ROWID(grCurrentVal).
  QUERY qAudDataValue:GET-PREV() NO-ERROR.
  
  IF NOT AVAILABLE audDataValue THEN DO:
    MESSAGE "You have reached the first Audit Data Value  record."
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RETURN NO-APPLY.
  END.
  RUN showAudDataValue.
  grCurrentVal = ROWID(audDataValue).
END.

ON CHOOSE OF btnFirst IN FRAME {&DETAIL} DO:
  QUERY qAudDataValue:GET-FIRST() NO-ERROR.
  
  IF NOT AVAILABLE audDataValue THEN DO:
    MESSAGE "You have reached the first Audit Data Value  record."
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RETURN NO-APPLY.
  END.
  RUN showAudDataValue.
  grCurrentVal = ROWID(audDataValue).
END.

/*=============================Main Block===============================*/
MAIN-BLK:
DO ON ERROR  UNDO MAIN-BLK, LEAVE MAIN-BLK 
   ON ENDKEY UNDO MAIN-BLK, LEAVE MAIN-BLK:
  /* Fix up report frame */
  {adecomm/okrun.i  
     &FRAME  = "FRAME {&SUMMARY}" 
     &BOX    = "rectBtns"
     &OK     = "btnOK"
     &OTHER  = " SPACE({&SPC}) btnFirst btnPrev btnNext btnLast "
     {&HLP_BTN}
  }

  /* Fix up detail frame */
  {adecomm/okrun.i  
     &FRAME  = "FRAME {&DETAIL}" 
     &BOX    = "rectBtns"
     &OK     = "btnOK"
     &OTHER  = " SPACE({&SPC}) btnFirst btnPrev btnNext btnLast "
     {&HLP_BTN}
  }

  grCurrentData = prRowid.
  gcReportType = pcTable.
  RUN initializeUI ( INPUT prRowid ).
END.

/*======================Internal Procedures=============================*/

PROCEDURE initializeUI:
  DEFINE INPUT  PARAMETER prRowid AS ROWID       NO-UNDO.

  VIEW FRAME {&SUMMARY}.

  IF gcReportType EQ "audData" THEN DO:
    FIND audData WHERE ROWID(audData) = prRowid NO-LOCK NO-ERROR.
    IF NOT AVAILABLE audData THEN RETURN "No Record".

    RUN showAudData.

    REPEAT ON ERROR  UNDO, LEAVE
           ON ENDKEY UNDO, LEAVE:
      WAIT-FOR DEFAULT-ACTION OF          FRAME {&SUMMARY} OR
               CHOOSE         OF btnOk IN FRAME {&SUMMARY} OR
               GO             OF          FRAME {&SUMMARY}
              FOCUS bAudDataValue.
      IF glEnd = TRUE THEN LEAVE.
    END.
  END.
  ELSE DO:
    FIND audDataValue WHERE ROWID(audDataValue) = prRowid NO-LOCK NO-ERROR.
    IF NOT AVAILABLE audDataValue THEN RETURN "No Record".

    RUN showAudDataValue.

    DO ON ERROR  UNDO, LEAVE 
       ON ENDKEY UNDO, LEAVE:
      WAIT-FOR CHOOSE OF btnOK IN FRAME {&DETAIL} OR
               GO     OF          FRAME {&DETAIL}
              FOCUS audDataValue._old-string-value.
    END.
    HIDE FRAME {&DETAIL}.
  END.
END PROCEDURE.

PROCEDURE resortQuery:
  DEFINE INPUT  PARAMETER pcColumn AS CHARACTER   NO-UNDO.

  DEFINE VARIABLE cSort  AS CHARACTER   NO-UNDO.

  DEFINE VARIABLE hQuery AS HANDLE      NO-UNDO.

  CASE pcColumn:
    WHEN "cs" THEN DO:
      IF gcLastSort = pcColumn THEN
        ASSIGN cSort      = " BY _continuation-sequence DESC"
               gcLastSort = "_continuation-sequence DESC".
      ELSE 
        ASSIGN cSort      = " BY _continuation-sequence "
               gcLastSort = "_continuation-sequence".
    END.
    OTHERWISE DO:
      IF gcLastSort = pcColumn THEN
        ASSIGN cSort      = " BY " + pcColumn + " DESC" + 
                            " BY _continuation-sequence" 
               gcLastSort = pcColumn + " DESC".
      ELSE 
        ASSIGN cSort      = " BY " + pcColumn + 
                            " BY _continuation-sequence"
               gcLastSort = pcColumn.
    END.
  END CASE.

  hQuery = QUERY qAudDataValue:HANDLE.

  hQuery:QUERY-CLOSE.
  hQuery:QUERY-PREPARE("FOR EACH audDataValue NO-LOCK " + 
                       "WHERE audDataValue._audit-data-guid EQ ~"" +
                       audData._audit-data-guid + "~"" + cSort).
  hQuery:QUERY-OPEN().
END PROCEDURE.

PROCEDURE showAudData:
  DISPLAY audData._audit-data-guid
          audData._transaction-id
          audData._transaction-seq
          audData._Audit-data-security-level-name
          audData._data-sealed
          audData._audit-date-time
          audData._event-name
          audData._event-type
          audData._db-guid
          audData._db-description
          audData._database-connection-id
          audData._client-session-uuid
          audData._Audit-data-security-level-name
          audData._data-sealed
          &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
            rsSortVals &ENDIF
      WITH FRAME {&SUMMARY}.

  OPEN QUERY qAudDataValue FOR EACH audDataValue NO-LOCK
      WHERE audDataValue._audit-data-guid EQ audData._audit-data-guid
            BY _continuation-sequence.

  gcLastSort = "_continuation-sequence".

  ENABLE &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
             rsSortVals &ENDIF
           bAudDataValue
           btnOk 
           btnFirst
           btnPrev
           btnNext
           btnLast
           &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
             btnHelp &ENDIF
        WITH FRAME {&SUMMARY}.
END PROCEDURE.

PROCEDURE showAudDataValue:
  DISPLAY audDataValue._audit-data-guid
          audDataValue._continuation-sequence
          audDataValue._field-name
          audDataValue._data-type-name
          audDataValue._old-string-value
          audDataValue._new-string-value
      WITH FRAME {&DETAIL}.

  ENABLE audDataValue._old-string-value
         audDataValue._new-string-value
         btnOk 
         btnFirst
         btnPrev
         btnNext
         btnLast
         &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
           btnHelp &ENDIF
      WITH FRAME {&DETAIL}.

  audDataValue._old-string-value:READ-ONLY IN FRAME {&DETAIL} = TRUE.
  audDataValue._new-string-value:READ-ONLY IN FRAME {&DETAIL} = TRUE.
END PROCEDURE.
