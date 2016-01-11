&Scoped-define WINDOW-NAME CURRENT-WINDOW
/*********************************************************************
* Copyright (C) 2005,2010 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*------------------------------------------------------------------------

  File: adecomm/_cust-filt.p

  Description: This dialog allows users the ability to define a granular 
               filter on audit data

  Input Parameters:
      pcDbName   -   Name of the database that will be filtered

  Output Parameters:
      pcFilter   -   Formatted query filter, based on user defined criteria

  Author: Kenneth S. McIntosh

  Created: July 18, 2005
  History:
      kmcintos  July 22, 2005  Removed AUTO-GO option from Apply button
                               20050722-024.
      kmcintos  Aug 8, 2005    Added context sensitive help 20050808-028.
      kmcintos  Aug 17, 2005   Fixed problem with context filtering
                               20050804-021.
      fernando  01/05/2010     Expand format for transaction id                         
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

{adecomm/commeng.i}

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER pcDbName AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER pcFilter AS CHARACTER   NO-UNDO.

DEFINE VARIABLE gcDateFormat AS CHARACTER   NO-UNDO.
DEFINE VARIABLE gcNumSep     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE gcNumDec     AS CHARACTER   NO-UNDO.

DEFINE VARIABLE giContOff    AS INTEGER     NO-UNDO.
DEFINE VARIABLE giSysOff     AS INTEGER     NO-UNDO.

ASSIGN gcDateFormat           = SESSION:DATE-FORMAT
       gcNumSep               = SESSION:NUMERIC-SEPARATOR
       gcNumDec               = SESSION:NUMERIC-DECIMAL-POINT
       SESSION:DATE-FORMAT    = "mdy"
       SESSION:NUMERIC-FORMAT = "American".

/* Local Variable Definitions ---                                       */

/* ********************  Preprocessor Definitions  ******************** */

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME auditFilter

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiDateFrom fiDateTo fiUserId fiEvtIdFrom fiEvtIdTo fiTxnId fiSystem btnSep1 fiContext btnSep2 rsOperator btnApply btnCancel
&Scoped-Define DISPLAYED-OBJECTS fiDateFrom fiDateTo fiUserId fiEvtIdFrom fiEvtIdTo fiTxnId fiContext rsOperator lblDateRange lblEvtIdRange lblContext lblMisc

/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnApply 
     LABEL "&Apply" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 11 BY 1
     &ELSE SIZE 11 BY .95 &ENDIF
     BGCOLOR 8 .

DEFINE BUTTON btnSep1 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN 
       LABEL "SEP" SIZE 5 BY 1
     &ELSE 
       LABEL "<SEP>" SIZE 8 BY .95 
     &ENDIF.

DEFINE BUTTON btnSep2
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN 
       LABEL "SEP" SIZE 5 BY 1
     &ELSE 
       LABEL "<SEP>" SIZE 8 BY .95 
     &ENDIF.

DEFINE BUTTON btnCancel 
     LABEL "Cancel" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 11 BY 1
     &ELSE SIZE 11 BY .95 &ENDIF
     BGCOLOR 8 .

DEFINE VARIABLE lblContext AS CHARACTER FORMAT "X(256)":U 
     INITIAL "Event Context Info" 
     VIEW-AS TEXT 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 22 BY 1
     &ELSE SIZE 22 BY .62 &ENDIF NO-UNDO.
     
DEFINE VARIABLE fiSystem AS CHARACTER FORMAT "X(256)":U 
     LABEL "System Context" 
     VIEW-AS FILL-IN 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 50 BY 1
     &ELSE SIZE 52 BY 1 &ENDIF NO-UNDO.
     
DEFINE VARIABLE fiContext AS CHARACTER FORMAT "X(256)":U 
     LABEL "Policy Context" 
     VIEW-AS FILL-IN 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 50 BY 1
     &ELSE SIZE 52 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE fiDateFrom AS DATE FORMAT "99/99/9999":U INITIAL ? 
     LABEL "From Date" 
     VIEW-AS FILL-IN 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 22 BY 1
     &ELSE SIZE 22 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE fiDateTo AS DATE FORMAT "99/99/9999":U INITIAL ? 
     LABEL "To Date" 
     VIEW-AS FILL-IN 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 22 BY 1
     &ELSE SIZE 22 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE fiEvtIdFrom AS INTEGER FORMAT ">>>>>>9":U INITIAL 0 
     LABEL "From Id" 
     VIEW-AS FILL-IN 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 22 BY 1
     &ELSE SIZE 22 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE fiEvtIdTo AS INTEGER FORMAT ">>>>>>9":U INITIAL 0 
     LABEL "To Id" 
     VIEW-AS FILL-IN 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 22 BY 1
     &ELSE SIZE 22 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE fiTxnId AS INT64 FORMAT ">>>>>>>>>9":U INITIAL 0 
     LABEL "Transaction Id" 
     VIEW-AS FILL-IN 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 22 BY 1
     &ELSE SIZE 22 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE fiUserId AS CHARACTER FORMAT "X(256)":U 
     LABEL "User Id" 
     VIEW-AS FILL-IN 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 22 BY 1
     &ELSE SIZE 22 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE lblDateRange AS CHARACTER FORMAT "X(256)":U 
     INITIAL "Audit Date Range" 
     VIEW-AS TEXT 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 18 BY 1
     &ELSE SIZE 22 BY .62 &ENDIF NO-UNDO.

DEFINE VARIABLE lblMisc AS CHARACTER FORMAT "X(256)":U 
     INITIAL "Miscellaneous" 
     VIEW-AS TEXT 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 18 BY 1
     &ELSE SIZE 22 BY .62 &ENDIF NO-UNDO.
     
DEFINE VARIABLE lblEvtIdRange AS CHARACTER FORMAT "X(256)":U 
     INITIAL "Audit Event Id Range" 
     VIEW-AS TEXT 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 22 BY 1
     &ELSE SIZE 22 BY .62 &ENDIF NO-UNDO.

DEFINE VARIABLE rsOperator AS CHARACTER
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "BEGINS", "BEGINS",
          "MATCHES", "MATCHES",
          "EQUALS", "EQ"
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 52 BY 3
     &ELSE SIZE 52 BY .71 &ENDIF NO-UNDO.

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
  DEFINE BUTTON btnHelp 
           LABEL "&Help" 
           SIZE 11 BY .95
           BGCOLOR 8 .

  DEFINE RECTANGLE RECT-1
       EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
       SIZE 78.6 BY 1.52.
&ENDIF

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME auditFilter 
     &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN SKIP(.1) &ENDIF
     
     lblDateRange 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN
            TO 51 NO-LABEL
          &ELSE
            TO 55 NO-LABEL
          &ENDIF
     fiDateFrom
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN 
            AT ROW 2 COL 12 COLON-ALIGNED
            HELP "Enter starting date for query"
          &ELSE 
            AT ROW 1.9 COL 18 COLON-ALIGNED 
          &ENDIF
     fiDateTo 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN 
            AT ROW 2 COL 50 COLON-ALIGNED
            HELP "Enter ending date for query" SKIP(1)
          &ELSE
            AT ROW 1.9 COL 55 COLON-ALIGNED SKIP(.5) 
          &ENDIF 
          
     lblEvtIdRange TO 53 NO-LABEL
     fiEvtIdFrom
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN 
            AT ROW 5 COL 12 COLON-ALIGNED
            HELP "Enter starting event id for query"
          &ELSE 
            AT ROW 4.1 COL 18 COLON-ALIGNED 
          &ENDIF
     fiEvtIdTo
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN 
            AT ROW 5 COL 50 COLON-ALIGNED
            HELP "Enter ending event id for query" SKIP(1)
          &ELSE
            AT ROW 4.1 COL 55 COLON-ALIGNED SKIP(.5)
          &ENDIF 
          
     lblMisc
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN
            TO 52 NO-LABEL
          &ELSE
            TO 57 NO-LABEL
          &ENDIF
     fiUserId
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN 
            AT ROW 8 COL 12 COLON-ALIGNED
            HELP "Enter user id for query"
          &ELSE AT ROW 6.3 COL 18 COLON-ALIGNED &ENDIF
     fiTxnId
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN 
            AT ROW 8 COL 50 COLON-ALIGNED 
            HELP "Enter transaction id for query" SKIP(1)
          &ELSE 
            AT ROW 6.3 COL 55 COLON-ALIGNED SKIP(.5) 
          &ENDIF
          
     lblContext 
       &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
         TO 54 NO-LABEL
       &ELSE
         TO 55 NO-LABEL
       &ENDIF
     fiSystem
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN 
            AT ROW 11 COL 18 COLON-ALIGNED
            HELP "Enter system context string for query"
          &ELSE 
            AT ROW 8.5 COL 18 COLON-ALIGNED 
          &ENDIF
     btnSep1
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN 
            AT ROW 11 COL 71
            HELP "Press to insert a separator character"
          &ELSE AT ROW 8.5 COL 72 &ENDIF
     fiContext
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN 
            AT ROW 12 COL 18 COLON-ALIGNED
            HELP "Enter policy context string for query"
          &ELSE 
            AT ROW 9.5 COL 18 COLON-ALIGNED 
          &ENDIF
     btnSep2
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN 
            AT ROW 12 COL 71
            HELP "Press to insert a separator character"
          &ELSE AT ROW 9.5 COL 72 &ENDIF
     rsOperator
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN 
            AT ROW 13 COL 20
            HELP "Choose operator to use for context string"
          &ELSE AT ROW 10.8 COL 20 &ENDIF NO-LABEL
     btnApply
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN 
            AT ROW 15 COL 27
            HELP "Press to apply filter criteria"
          &ELSE AT ROW 12.42 COL 3 &ENDIF
     btnCancel
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN 
            AT ROW 15 COL 39
            HELP "Press, or hit ENDKEY, to cancel"
          &ELSE AT ROW 12.42 COL 15.2 &ENDIF
     &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
       btnHelp AT ROW 12.42 COL 67.4
       RECT-1 AT ROW 12.13 COL 1.4 &ENDIF
     SPACE(0.79) SKIP(0.24)
    WITH &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN 
         VIEW-AS DIALOG-BOX &ENDIF KEEP-TAB-ORDER
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Custom Audit Data Filter".

ASSIGN FRAME auditFilter:SCROLLABLE = FALSE
       FRAME auditFilter:HIDDEN     = TRUE
       fiSystem:TOOLTIP             = "Enter system context string for query"
       fiContext:TOOLTIP            = "Enter policy context string for query".

/* ************************  Control Triggers  ************************ */

ON WINDOW-CLOSE OF FRAME auditFilter 
  APPLY "END-ERROR":U TO SELF.

ON LEAVE OF fiContext IN FRAME auditFilter
  giContOff = fiContext:CURSOR-OFFSET.

ON LEAVE OF fiSystem IN FRAME auditFilter
  giSysOff = fiSystem:CURSOR-OFFSET.

ON CHOOSE OF btnSep1 IN FRAME auditFilter DO:
  DEFINE VARIABLE cTempVal AS CHARACTER   NO-UNDO.

  cTempVal = fiSystem:SCREEN-VALUE.

  IF giSysOff = 0 THEN
    giSysOff = LENGTH(cTempVal).
  
  fiSystem:SCREEN-VALUE = SUBSTRING(cTempVal,1,giSysOff - 1) + 
                           '<SEP>' +
                           SUBSTRING(cTempVal,giSysOff).

  APPLY "ENTRY" TO fiSystem IN FRAME auditFilter.
  ASSIGN fiSystem:CURSOR-OFFSET = giSysOff + 5
         giSysOff               = giSysOff + 5.
END.

ON CHOOSE OF btnSep2 IN FRAME auditFilter DO:
  DEFINE VARIABLE cTempVal AS CHARACTER   NO-UNDO.

  cTempVal = fiContext:SCREEN-VALUE.

  IF giContOff = 0 THEN
    giContOff = LENGTH(cTempVal).

  fiContext:SCREEN-VALUE = SUBSTRING(cTempVal,1,giContOff - 1) + 
                           '<SEP>' +
                           SUBSTRING(cTempVal,giContOff).

  APPLY "ENTRY" TO fiContext IN FRAME auditFilter.
  ASSIGN fiContext:CURSOR-OFFSET = giContOff + 5
         giContOff               = giContOff + 5.
END.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  ON CHOOSE OF btnHelp IN FRAME {&FRAME-NAME} OR 
     HELP   OF FRAME {&FRAME-NAME} 
    RUN "adecomm/_adehelp.p" ( INPUT "admn", 
                               INPUT "CONTEXT", 
                               INPUT {&Custom_Audit_Data_Filter_Report_Dialog_Box},
                               INPUT ?).
&ENDIF

ON CHOOSE OF btnApply IN FRAME auditFilter 
  APPLY "GO" TO FRAME {&FRAME-NAME}.

ON END-ERROR OF FRAME auditFilter DO:
  ASSIGN SESSION:DATE-FORMAT = gcDateFormat
         pcFilter            = ?.
  SESSION:SET-NUMERIC-FORMAT(gcNumSep,gcNumDec).
END.

ON GO OF FRAME auditFilter DO:
  DEFINE VARIABLE lContinue AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE cContext  AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cSystem   AS CHARACTER   NO-UNDO.

  /* Check each section for changes by the user */

  /* Date Range stuff */
  IF fiDateFrom:SCREEN-VALUE NE "" THEN
    pcFilter = (IF fiDateTo:SCREEN-VALUE NE "" THEN "(" ELSE "") + 
               "DATE(_audit-date-time) >= DATE(~"" + 
               fiDateFrom:SCREEN-VALUE + "~")".

  IF fiDateTo:SCREEN-VALUE NE "" THEN
    pcFilter = pcFilter + (IF pcFilter NE "" THEN " AND " ELSE "") +
               "DATE(_audit-date-time) <= DATE(~"" + 
               fiDateTo:SCREEN-VALUE + "~")" +
               (IF fiDateFrom:SCREEN-VALUE NE "" THEN ")" ELSE "").

  IF fiUserId:SCREEN-VALUE NE "" THEN
    pcFilter = pcFilter + (IF pcFilter NE "" THEN " AND " ELSE "") +
               "_user-id = ~'" + fiUserId:SCREEN-VALUE + "~'".

  IF fiEvtIdFrom:SCREEN-VALUE NE "0" THEN
    pcFilter = pcFilter + (IF pcFilter NE "" THEN " AND " ELSE "") +
               (IF fiEvtIdTo:SCREEN-VALUE NE "0" THEN "(" ELSE "") +
               "_event-id >= " + fiEvtIdFrom:SCREEN-VALUE.

  IF fiEvtIdTo:SCREEN-VALUE NE "0" THEN
    pcFilter = pcFilter + (IF pcFilter NE "" THEN " AND " ELSE "") +
               "_event-id <= " + fiEvtIdTo:SCREEN-VALUE +
               (IF fiEvtIdFrom:SCREEN-VALUE NE "0" THEN ")" ELSE "").

  IF fiTxnId:SCREEN-VALUE NE "0" THEN
    pcFilter = pcFilter + (IF pcFilter NE "" THEN " AND " ELSE "") +
               "_transaction-id = " + fiTxnId:SCREEN-VALUE.

  IF fiSystem:SCREEN-VALUE NE "" THEN
    cSystem  = REPLACE(fiSystem:SCREEN-VALUE,"<SEP>",CHR(7)).
  IF fiContext:SCREEN-VALUE NE "" THEN
    cContext = REPLACE(fiContext:SCREEN-VALUE,"<SEP>",CHR(7)).

  IF cSystem NE "" THEN
    pcFilter = pcFilter + (IF pcFilter NE "" THEN " AND " ELSE "") +
               "ENTRY(1,_event-context,CHR(6)) " + rsOperator:SCREEN-VALUE + 
               " ~'" + cSystem + "~'".

  IF cContext NE "" THEN
    pcFilter = pcFilter + (IF pcFilter NE "" THEN " AND " ELSE "") +
               "ENTRY(2,_event-context,CHR(6)) " + rsOperator:SCREEN-VALUE + 
               " ~'" + cContext + "~'".

  IF pcFilter NE "" THEN
    pcFilter = "WHERE " + pcFilter.
  ELSE DO:
    MESSAGE "You have specified no filter criteria for this report." SKIP(1)
            "If you choose to continue, the report could take a long time " +
            "to generate and could exceed platform specific file size " +
            "limitations."  SKIP(1)
            "Select Yes to generate the report without filters.  Select No " +
            "to return to the filter dialog to enter filter criteria."
        VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO 
                          TITLE "Continue?" UPDATE lContinue.
    IF NOT lContinue THEN DO:
      APPLY "ENTRY" TO fiDateFrom.
      RETURN NO-APPLY.
    END.
  END.
  SESSION:DATE-FORMAT       = gcDateFormat.
  SESSION:SET-NUMERIC-FORMAT(gcNumSep,gcNumDec).
END.

ON CHOOSE OF btnCancel IN FRAME auditFilter 
  APPLY "WINDOW-CLOSE" TO FRAME {&FRAME-NAME}.

/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  RUN initializeUI.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* **********************  Internal Procedures  *********************** */
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME auditFilter.
END PROCEDURE.

PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY {&DISPLAYED-OBJECTS} WITH FRAME auditFilter.
  ENABLE {&ENABLED-OBJECTS} &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
                              RECT-1 btnHelp &ENDIF
      WITH FRAME auditFilter.
  
  VIEW FRAME auditFilter.
END PROCEDURE.

PROCEDURE initializeUI :
/*------------------------------------------------------------------------------
  Purpose:     Setup defaults and initialize the user interface
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FRAME {&FRAME-NAME}:TITLE = FRAME {&FRAME-NAME}:TITLE +
                              " (" + pcDbName + ")".
  ASSIGN fiDateFrom:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ?
         fiDateTo:SCREEN-VALUE IN FRAME {&FRAME-NAME}   = ?.
END PROCEDURE.
