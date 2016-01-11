&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
/*************************************************************/
/* Copyright (c) 1984-2005,2008 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/

/*------------------------------------------------------------------------

  File: adecomm/_auddfilt.p

  Description: Date Range Filter for Audit, or client session, Data.

  Input Parameters:
      pcMode    -   This parameter descibes the mode in which this 
                    dialog should run.  The mode should be one of the 
                    following:
                    
                    1-15 Modes 1 through 15 tell the utility that this
                         dialog has been called by an Auditing Report.
                         
                         Auditing Reports require only Audit Reader 
                         permissions to run.
                         
                    "y"  Mode y indicates that this was called from the
                         "Dump Audit Data" option in the Data Administration
                         Tool.  
                         
                         Mode y requires Audit Archiver permissions to run.
  Output Parameters:
      pcData    -   Used to return the date range to the user.

  Author: Kenneth S. McIntosh

  Created: March 11,2005
  
  History: 
    kmcintos June 7, 2005  Added context help for dialog and removed appbuilder 
                           friendly code.
    kmcintos July 19, 2005 Fixed security stuff and adapted for general usage 
                           to be used with auditing reports.
    kmcintos Oct 28, 2005  Changed help context id depending on usage.
    fernando Dec 23, 2008  Reports for encryption
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

CREATE WIDGET-POOL.

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER pcMode AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER pcData AS CHARACTER   NO-UNDO.

/* Local Variable Definitions ---                                       */

&GLOBAL-DEFINE DATE-RANGE fiStartDate fiEndDate
&GLOBAL-DEFINE TEXT-LINES txtLine1 txtLine2 txtLine3 txtLine4 txtLine5

{prodict/user/uservar.i}
{prodict/sec/sec-func.i}
{adecomm/commeng.i}   

DEFINE VARIABLE cRoles     AS CHARACTER   NO-UNDO.
  
DEFINE VARIABLE iContextId AS INTEGER     NO-UNDO.

cRoles = getPermissions(USERID("DICTDB"),pcMode).

/* If dumping audit data */
IF pcMode EQ "y" THEN DO: 
  IF NOT CAN-DO(cRoles,"_sys.audit.archive") THEN DO:
    MESSAGE "You must have Audit Archiver permissions to access this " +
            "Dump Option!"
         VIEW-AS ALERT-BOX ERROR BUTTONS OK.
 
    pcData = ?.
    RETURN.
  END.
END.
/* If running an audit report */
ELSE IF CAN-DO("1,2,3,4,5,6,7,8,9,10,11,13,14,15",pcMode) THEN DO:
  IF cRoles NE "dba,w"                       AND
     NOT CAN-DO(cRoles,"_sys.audit.admin")   AND
     NOT CAN-DO(cRoles,"_sys.audit.archive") AND
     NOT CAN-DO(cRoles,"_sys.audit.read")    THEN DO:

    MESSAGE "You must have a minimum of Audit Reader permissions to access " +
            "this option."
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

    pcData = ?.
    RETURN.
  END.
END.
ELSE DO:
  MESSAGE "Permission Denied!" SKIP(1)
          "You have called this dialog from an unsupported tool."
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.

  pcData = ?.
  RETURN.
END.

DEFINE VARIABLE ghBuffer    AS HANDLE      NO-UNDO.

DEFINE VARIABLE lImmedDisp   AS LOGICAL     NO-UNDO.

DEFINE VARIABLE gcDateFormat AS CHARACTER   NO-UNDO.
DEFINE VARIABLE gcNumSep     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE gcNumDec     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE gcTitle      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE gcFunction   AS CHARACTER   NO-UNDO FORMAT "x(50)"
       EXTENT 15
       INITIAL ["Audit Policy Changes",
                "Schema Changes",
                "Audit Data Administration",
                "Application Data Administration",
                "User Maintenance",
                "Security Permissions Changes",
                "SQL DBA Changes",
                "Authentication Systems Changes",
                "Client Session Authentication",
                "Database Utilities",
                "Database Access",
                ?, /* not used - for custom report */
                "Encryption Policy Changes", 
                "Key Store Changes",
                "Database Encryption Administration"].

ASSIGN gcDateFormat           = SESSION:DATE-FORMAT
       gcNumSep               = SESSION:NUMERIC-SEPARATOR
       gcNumDec               = SESSION:NUMERIC-DECIMAL-POINT
       SESSION:DATE-FORMAT    = "mdy"
       SESSION:NUMERIC-FORMAT = "American".

IF pcMode = "9" THEN DO:
  CREATE BUFFER ghBuffer FOR TABLE "DICTDB._client-session".
  gcTitle = "Date Range - " + gcFunction[INTEGER(pcMode)].
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
    iContextId = {&Date_Range_Auditing_Reports_Dialog_Box}.
  &ENDIF
END.
ELSE IF pcMode = "y" THEN DO:
  CREATE BUFFER ghBuffer FOR TABLE "DICTDB._aud-audit-data".
  gcTitle = "Date Range - Dump Audit Data".
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
    iContextId = {&Dump_Audit_Data_Filter_Dialog_Box}.
  &ENDIF
END.
ELSE IF CAN-DO("1,2,3,4,5,6,7,8,9,10,11,12,13,14,15",pcMode) THEN DO:
  CREATE BUFFER ghBuffer FOR TABLE "DICTDB._aud-audit-data".
  gcTitle = "Date Range - " + gcFunction[INTEGER(pcMode)].
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
    iContextId = {&Date_Range_Auditing_Reports_Dialog_Box}.
  &ENDIF
END.

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

&Scoped-define LAYOUT-VARIABLE CURRENT-WINDOW-layout

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rsChoice fiStartDate fiEndDate btnOk btnCancel txtDateRange 
&Scoped-Define DISPLAYED-OBJECTS rsChoice fiStartDate fiEndDate txtDateRange 

/* Define a variable to store the name of the active layout.            */
DEFINE VAR CURRENT-WINDOW-layout AS CHAR INITIAL "Master Layout":U NO-UNDO.

/* ***********************  Control Definitions  ********************** */

/* Definitions of the field level widgets                               */
DEFINE VARIABLE fiEndDate AS DATE FORMAT "99/99/9999":U
     LABEL "End Date" 
     VIEW-AS FILL-IN 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 16 BY 1
     &ELSE SIZE 16.4 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE fiStartDate AS DATE FORMAT "99/99/9999":U
     LABEL "Start Date" 
     VIEW-AS FILL-IN 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 16 BY 1
     &ELSE SIZE 16.4 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE txtDateRange AS CHARACTER FORMAT "X(256)":U INITIAL "Date Range:" 
      VIEW-AS TEXT 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 18 BY 1
     &ELSE SIZE 18 BY .62 &ENDIF
     FONT 6 NO-UNDO.

DEFINE VARIABLE rsChoice AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Select All", 1,
          "Select Some", 2
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 20 BY 3
     &ELSE SIZE 20 BY 1.91 &ENDIF NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 62 BY 1
     &ELSE SIZE 61.6 BY 1.38 &ENDIF.

DEFINE BUTTON btnOk     LABEL "OK" SIZE 11 BY .95 AUTO-GO.

DEFINE BUTTON btnCancel LABEL "Cancel" SIZE 11 BY .95.

&IF '{&WINDOW-SYSTEM}' <> 'TTY':U &THEN
  DEFINE BUTTON btnHelp   LABEL "&Help" SIZE 11 BY .95.
&ENDIF

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     rsChoice
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 2 COL 2
          &ELSE AT ROW 1.71 COL 3 &ENDIF NO-LABEL
     txtDateRange
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 5 COL 2
          &ELSE AT ROW 3.95 COL 2.8 &ENDIF NO-LABEL
     fiStartDate
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 6 COL 12 COLON-ALIGNED
          &ELSE AT ROW 4.86 COL 11.8 COLON-ALIGNED &ENDIF
     fiEndDate
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 6 COL 43 COLON-ALIGNED
          &ELSE AT ROW 4.86 COL 43 COLON-ALIGNED &ENDIF
     btnOk
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 9 COL 20
          &ELSE AT ROW 6.38 COL 3.4 &ENDIF
     btnCancel
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 9 COL 32
          &ELSE AT ROW 6.38 COL 15.2 &ENDIF
     &IF '{&WINDOW-SYSTEM}' <> 'TTY':U &THEN
       btnHelp AT ROW 6.38 COL 52 
       RECT-2 AT ROW 6.14 COL 2.4 
     &ENDIF
     SPACE(1.19) SKIP(0.28)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER DEFAULT-BUTTON btnOk
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE CENTERED
         TITLE gcTitle.


/* ***********  Runtime Attributes and AppBuilder Settings  *********** */
ASSIGN FRAME Dialog-Frame:SCROLLABLE = FALSE
       FRAME Dialog-Frame:HIDDEN     = TRUE.

IF SESSION:DISPLAY-TYPE = 'TTY':U  THEN 
  RUN CURRENT-WINDOW-layouts (INPUT 'Standard Character':U) NO-ERROR.

/* ************************  Control Triggers  ************************ */

ON WINDOW-CLOSE OF FRAME Dialog-Frame
  APPLY "END-ERROR" TO SELF.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  ON CHOOSE OF btnHelp IN FRAME Dialog-Frame /* Help */ OR 
     HELP   OF FRAME {&FRAME-NAME} 
    RUN "adecomm/_adehelp.p" ( INPUT "admn", 
                               INPUT "CONTEXT", 
                               INPUT iContextId,
                               INPUT ?).
&ENDIF

ON VALUE-CHANGED OF rsChoice IN FRAME Dialog-Frame DO:
  DEFINE VARIABLE lFound AS LOGICAL     NO-UNDO.

  IF SELF:SCREEN-VALUE = "1" THEN
    DISABLE {&DATE-RANGE} WITH FRAME {&FRAME-NAME}.
  ELSE DO:
    IF "9" = pcMode THEN DO:
      lFound = ghBuffer:FIND-FIRST("USE-INDEX _auth-time",NO-LOCK) NO-ERROR.
      IF (lFound = TRUE) THEN DO:
        fiStartDate:SCREEN-VALUE = STRING(DATE(ghBuffer::_authentication-date-time)).
        lFound = ghBuffer:FIND-LAST("USE-INDEX _auth-time",NO-LOCK) NO-ERROR.
        IF (lFound = TRUE) THEN
          fiEndDate:SCREEN-VALUE = STRING(DATE(ghBuffer::_authentication-date-time)).
      END.
    END.
    ELSE DO:
      lFound = ghBuffer:FIND-FIRST("USE-INDEX _Audit-time",NO-LOCK) NO-ERROR.
      IF (lFound = TRUE) THEN DO:
        fiStartDate:SCREEN-VALUE = STRING(DATE(ghBuffer::_audit-date-time)).
        lFound = ghBuffer:FIND-LAST("USE-INDEX _Audit-time",NO-LOCK) NO-ERROR.
        IF (lFound = TRUE) THEN
          fiEndDate:SCREEN-VALUE = STRING(DATE(ghBuffer::_audit-date-time)).
      END.
    END.
    ENABLE {&DATE-RANGE} WITH FRAME {&FRAME-NAME}.
    APPLY "ENTRY" TO fiStartDate IN FRAME {&FRAME-NAME}.
  END.
END.

ON CHOOSE OF btnOk IN FRAME Dialog-Frame 
  APPLY "GO" TO FRAME {&FRAME-NAME}.

ON END-ERROR OF FRAME Dialog-Frame DO:
  ASSIGN SESSION:DATE-FORMAT = gcDateFormat
         pcData              = ?.
  SESSION:SET-NUMERIC-FORMAT(gcNumSep,gcNumDec).
END.

ON GO OF FRAME Dialog-Frame DO:
  IF rsChoice:SCREEN-VALUE = "1" THEN
    pcData = "All".
  ELSE pcData = STRING(fiStartDate:SCREEN-VALUE) + "," +
                     STRING(fiEndDate:SCREEN-VALUE).
  SESSION:DATE-FORMAT       = gcDateFormat.
  SESSION:SET-NUMERIC-FORMAT(gcNumSep,gcNumDec).
END.

ON CHOOSE OF btnCancel IN FRAME Dialog-Frame 
  APPLY "WINDOW-CLOSE" TO FRAME {&FRAME-NAME}.

/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ? THEN 
  FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
   
  PAUSE 0 NO-MESSAGE.
  lImmedDisp = SESSION:IMMEDIATE-DISPLAY.
  SESSION:IMMEDIATE-DISPLAY = TRUE.

  RUN enable_UI.
  APPLY 'VALUE-CHANGED' TO rsChoice IN FRAME {&FRAME-NAME}.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
SESSION:IMMEDIATE-DISPLAY = lImmedDisp.
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
  HIDE FRAME Dialog-Frame.
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
  DISPLAY rsChoice fiStartDate fiEndDate txtDateRange 
      WITH FRAME Dialog-Frame.
  
  ENABLE {&ENABLED-OBJECTS}
         &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
           btnHelp RECT-2 &ENDIF
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  
END PROCEDURE.

PROCEDURE CURRENT-WINDOW-layouts:
  DEFINE INPUT PARAMETER layout AS CHARACTER                     NO-UNDO.
  DEFINE VARIABLE lbl-hndl AS WIDGET-HANDLE                      NO-UNDO.
  DEFINE VARIABLE widg-pos AS DECIMAL                            NO-UNDO.

  /* Copy the name of the active layout into a variable accessible to   */
  /* the rest of this file.                                             */
  CURRENT-WINDOW-layout = layout.

  CASE layout:
    WHEN "Master Layout" THEN DO WITH FRAME {&FRAME-NAME}:
      ASSIGN &IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN
               FRAME Dialog-Frame:HIDDEN       = yes &ENDIF
             FRAME Dialog-Frame:HEIGHT         = 6.81 + 
                                                 FRAME Dialog-Frame:BORDER-TOP + 
                                                 FRAME Dialog-Frame:BORDER-BOTTOM
             FRAME Dialog-Frame:WIDTH          = 64.2 + 
                                                 FRAME Dialog-Frame:BORDER-LEFT + 
                                                 FRAME Dialog-Frame:BORDER-RIGHT.

      ASSIGN btnCancel:HIDDEN                  = yes
             btnCancel:COL                     = 15.2
             btnCancel:HEIGHT                  = .95
             btnCancel:ROW                     = 6.38
             btnCancel:HIDDEN                  = no.

      &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
        ASSIGN btnHelp:HIDDEN                  = yes
               btnHelp:COL                     = 52
               btnHelp:HEIGHT                  = .95
               btnHelp:ROW                     = 6.38
               btnHelp:HIDDEN                  = no
               btnHelp:HIDDEN                  = no.

        ASSIGN RECT-2:HIDDEN                   = yes
               RECT-2:COL                      = 2.4
               RECT-2:HEIGHT                   = 1.38
               RECT-2:ROW                      = 6.14
               RECT-2:WIDTH                    = 61.6
               RECT-2:HIDDEN                   = no.
      &ENDIF
                                               
      ASSIGN btnOk:HIDDEN                      = yes
             btnOk:COL                         = 3.4
             btnOk:HEIGHT                      = .95
             btnOk:ROW                         = 6.38
             btnOk:HIDDEN                      = no.

      ASSIGN fiEndDate:HIDDEN                  = yes
             widg-pos                          = fiEndDate:ROW  
             fiEndDate:ROW                     = 4.86
             lbl-hndl                          = fiEndDate:SIDE-LABEL-HANDLE  
             lbl-hndl:ROW                      = lbl-hndl:ROW + 
                                                 fiEndDate:ROW - widg-pos
             fiEndDate:WIDTH                   = 16.4
             fiEndDate:HIDDEN                  = no.

      ASSIGN fiStartDate:HIDDEN                = yes
             widg-pos                          = fiStartDate:COL  
             fiStartDate:COL                   = 13.8
             lbl-hndl                          = fiStartDate:SIDE-LABEL-HANDLE  
             lbl-hndl:COL                      = lbl-hndl:COL + 
                                                 fiStartDate:COL - widg-pos
             widg-pos                          = fiStartDate:ROW  
             fiStartDate:ROW                   = 4.86
             lbl-hndl                          = fiStartDate:SIDE-LABEL-HANDLE  
             lbl-hndl:ROW                      = lbl-hndl:ROW + 
                                                 fiStartDate:ROW - widg-pos
             fiStartDate:WIDTH                 = 16.4
             fiStartDate:HIDDEN                = no.

      ASSIGN rsChoice:HIDDEN                   = yes
             rsChoice:COL                      = 3
             rsChoice:HEIGHT                   = 1.91
             rsChoice:ROW                      = 1.71
             rsChoice:HIDDEN                   = no.

      ASSIGN txtDateRange:HIDDEN               = yes
             txtDateRange:COL                  = 2.8
             txtDateRange:HEIGHT               = .62
             txtDateRange:ROW                  = 3.95
             txtDateRange:HIDDEN               = no.

      ASSIGN FRAME Dialog-Frame:VIRTUAL-HEIGHT = 10.76
                    WHEN FRAME Dialog-Frame:SCROLLABLE
             FRAME Dialog-Frame:VIRTUAL-WIDTH  = 64.20
                    WHEN FRAME Dialog-Frame:SCROLLABLE
             &IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN
               FRAME Dialog-Frame:HIDDEN       = no &ENDIF.

    END.  /* Master Layout Layout Case */

    WHEN "Standard Character":U THEN DO WITH FRAME {&FRAME-NAME}:
      ASSIGN &IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN
               FRAME Dialog-Frame:HIDDEN       = yes &ENDIF
             FRAME Dialog-Frame:HEIGHT         = 9 + 
                                                 FRAME Dialog-Frame:BORDER-TOP + 
                                                 FRAME Dialog-Frame:BORDER-BOTTOM
             FRAME Dialog-Frame:WIDTH          = 64 + 
                                                 FRAME Dialog-Frame:BORDER-LEFT + 
                                                 FRAME Dialog-Frame:BORDER-RIGHT 
           NO-ERROR.

      ASSIGN btnCancel:HIDDEN                  = yes
             btnCancel:COL                     = 32
             btnCancel:HEIGHT                  = 1
             btnCancel:ROW                     = 9
             btnCancel:HIDDEN                  = no NO-ERROR.

      ASSIGN btnOk:HIDDEN                      = yes
             btnOk:COL                         = 20
             btnOk:HEIGHT                      = 1
             btnOk:ROW                         = 9
             btnOk:HIDDEN                      = no NO-ERROR.

      ASSIGN fiEndDate:HIDDEN                  = yes
             widg-pos                          = fiEndDate:ROW  
             fiEndDate:ROW                     = 6
             lbl-hndl                          = fiEndDate:SIDE-LABEL-HANDLE  
             lbl-hndl:ROW                      = lbl-hndl:ROW + 
                                                 fiEndDate:ROW - widg-pos
             fiEndDate:WIDTH                   = 16
             fiEndDate:HIDDEN                  = no NO-ERROR.

      ASSIGN fiStartDate:HIDDEN                = yes
             widg-pos                          = fiStartDate:COL  
             fiStartDate:COL                   = 14
             lbl-hndl                          = fiStartDate:SIDE-LABEL-HANDLE  
             lbl-hndl:COL                      = lbl-hndl:COL + 
                                                 fiStartDate:COL - widg-pos
             widg-pos                          = fiStartDate:ROW  
             fiStartDate:ROW                   = 6
             lbl-hndl                          = fiStartDate:SIDE-LABEL-HANDLE  
             lbl-hndl:ROW                      = lbl-hndl:ROW + 
                                                 fiStartDate:ROW - widg-pos
             fiStartDate:WIDTH                 = 16
             fiStartDate:HIDDEN                = no NO-ERROR.

      ASSIGN rsChoice:HIDDEN                   = yes
             rsChoice:COL                      = 2
             rsChoice:HEIGHT                   = 3
             rsChoice:ROW                      = 2
             rsChoice:HIDDEN                   = no NO-ERROR.

      ASSIGN txtDateRange:HIDDEN               = yes
             txtDateRange:COL                  = 2
             txtDateRange:HEIGHT               = 1
             txtDateRange:ROW                  = 5
             txtDateRange:HIDDEN               = no NO-ERROR.

      ASSIGN FRAME Dialog-Frame:VIRTUAL-HEIGHT = 11.00
                    WHEN FRAME Dialog-Frame:SCROLLABLE
             FRAME Dialog-Frame:VIRTUAL-WIDTH  = 64.00
                    WHEN FRAME Dialog-Frame:SCROLLABLE
             &IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN
               FRAME Dialog-Frame:HIDDEN       = no &ENDIF NO-ERROR.

    END.  /* Standard Character Layout Case */

  END CASE.
END PROCEDURE.  /* CURRENT-WINDOW-layouts */
