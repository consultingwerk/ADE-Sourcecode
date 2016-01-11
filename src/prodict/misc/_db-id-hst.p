&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME history-frame
/*------------------------------------------------------------------------
/*************************************************************/  
/* Copyright (c) 1984-2007 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/

  File: prodict/aud/_db-aud-hst.p

  Description: Dialog for displaying all _db-detail records in a database

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Kenneth S. McIntosh

  Created: April 3, 2005
 
  History: 
    kmcintos May 24, 2005  Added NO-ERROR and _db-detail creation in case no 
                           _db-detail exists bug # 20050505-031.
    kmcintos May 26, 2005  Added code to check if field values changed, instead 
                           of depending on VALUE-CHANGED trig bug # 20050525-017.
    kmcintos June 7, 2005  Added context sensitive help to dialog and removed
                           appbuilder friendly code.
    kmcintos Oct 28, 2005  Changed context sensitive help id.
    fernando 11/30/07      Check if read-only mode.
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

CREATE WIDGET-POOL.

{prodict/misc/misc-funcs.i}
{prodict/admnhlp.i}

IF NOT dbAdmin(USERID("DICTDB")) THEN DO:
  MESSAGE "You must be a Database Administrator to run this tool!"
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN "No Permission".
END.

IF checkReadOnly("DICTDB","_Db-detail") NE "" THEN
   RETURN "No Permission".

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE TEMP-TABLE ttDetail RCODE-INFORMATION
    FIELD tcDBGuid       AS CHARACTER LABEL "DB Identifier"      FORMAT "x(36)"
    FIELD tcDescription  AS CHARACTER LABEL "Description"        FORMAT "x(35)"
    FIELD tcCustomDetail AS CHARACTER LABEL "Additional Details" FORMAT "x(500)"
    FIELD tlHasMacKey    AS LOGICAL
    FIELD tlModified     AS LOGICAL
    FIELD tiSequence     AS INTEGER
    INDEX tiSequence AS PRIMARY UNIQUE tcDBGuid.

DEFINE QUERY qDetail FOR ttDetail SCROLLING.

DEFINE BROWSE bDetail QUERY qDetail
    DISPLAY tcDescription
            tcDBGuid 
    WITH &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
           3 DOWN NO-BOX 
         &ELSE 4 DOWN &ENDIF WIDTH 75.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
  BROWSE bDetail:COLUMN-RESIZABLE = TRUE.
&ENDIF

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

&Scoped-define LAYOUT-VARIABLE CURRENT-WINDOW-layout

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME history-frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiDescription edCustDtl BtnOK-2 BtnCancel
&Scoped-Define DISPLAYED-OBJECTS fiGuid fiDescription edCustDtl tbHasMac lblCustDtl lblHasMac 

/* Define a variable to store the name of the active layout.            */
DEFINE VAR CURRENT-WINDOW-layout AS CHAR INITIAL "Master Layout":U NO-UNDO.

/* ***********************  Control Definitions  ********************** */

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnCancel AUTO-END-KEY DEFAULT 
     LABEL "Cancel" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 11 BY 1
     &ELSE SIZE 11 BY .95 &ENDIF
     BGCOLOR 8 .

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
  DEFINE BUTTON BtnHelp DEFAULT 
     LABEL "&Help" 
     SIZE 11 BY .95
     BGCOLOR 8.
   
  DEFINE RECTANGLE RECT-2
   EDGE-PIXELS 2 GRAPHIC-EDGE NO-FILL 
   SIZE 75 BY 1.38. &ENDIF

DEFINE BUTTON BtnOK-2 DEFAULT 
     LABEL "OK" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 11 BY 1
     &ELSE SIZE 11 BY .95 &ENDIF
     BGCOLOR 8 .

DEFINE VARIABLE edCustDtl AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 54 BY 5
     &ELSE SIZE 54.8 BY 2.62 &ENDIF NO-UNDO.

DEFINE VARIABLE fiDescription AS CHARACTER FORMAT "X(256)":U 
     LABEL "DB Description" 
     VIEW-AS FILL-IN 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 54 BY 1
     &ELSE SIZE 54.8 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE fiGuid AS CHARACTER FORMAT "X(256)":U 
     LABEL "DB Identifier" 
     VIEW-AS FILL-IN 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 54 BY 1
     &ELSE SIZE 54.8 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE lblCustDtl AS CHARACTER FORMAT "X(256)":U INITIAL "Additional Details:" 
      VIEW-AS TEXT 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 19 BY 1
     &ELSE SIZE 17.4 BY .62 &ENDIF NO-UNDO.

DEFINE VARIABLE lblHasMac AS CHARACTER FORMAT "X(256)":U INITIAL "Has Passkey:" 
      VIEW-AS TEXT 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 12 BY 1
     &ELSE SIZE 14 BY .62 &ENDIF NO-UNDO.

DEFINE VARIABLE tbHasMac AS LOGICAL INITIAL yes 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 3 BY 1
     &ELSE SIZE 2.4 BY .81 &ENDIF NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME history-frame
     bDetail AT COLUMN &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 1 ROW 2 
                       &ELSE 2 ROW 1 &ENDIF
     fiGuid
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 8 COL 19 COLON-ALIGNED
          &ELSE AT ROW 6.62 COL 18.2 COLON-ALIGNED &ENDIF
     fiDescription
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 9 COL 19 COLON-ALIGNED
          &ELSE AT ROW 7.81 COL 18.2 COLON-ALIGNED &ENDIF
     edCustDtl
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 11 COL 21
          &ELSE AT ROW 9 COL 20.2 &ENDIF NO-LABEL
     tbHasMac
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 16 COL 72
          &ELSE AT ROW 11.67 COL 72.2 &ENDIF
     BtnOK-2
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 17 COL 27
          &ELSE AT ROW 12.86 COL 3.6 &ENDIF
     BtnCancel
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 17 COL 40
          &ELSE AT ROW 12.86 COL 15.4 &ENDIF
     &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
       BtnHelp AT ROW 12.86 COL 64.8 &ENDIF
     lblCustDtl
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 11 COL 1
          &ELSE AT ROW 9.05 COL 2.6 &ENDIF NO-LABEL
     lblHasMac
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 16 COL 58 COLON-ALIGNED
          &ELSE AT ROW 11.71 COL 55.6 COLON-ALIGNED &ENDIF NO-LABEL
     &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
       RECT-2 AT ROW 12.62 COL 2.2 &ENDIF
     SPACE(0.79) SKIP(0.04)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER CENTERED
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Database Identification History"
         DEFAULT-BUTTON BtnOK-2 CANCEL-BUTTON BtnCancel.

/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

ASSIGN FRAME history-frame:SCROLLABLE       = FALSE
       FRAME history-frame:HIDDEN           = TRUE.

ASSIGN fiGuid:READ-ONLY IN FRAME history-frame        = TRUE.

IF SESSION:DISPLAY-TYPE = 'TTY':U  THEN 
  RUN CURRENT-WINDOW-layouts (INPUT 'Standard Character':U) NO-ERROR.

/* ************************  Control Triggers  ************************ */

ON WINDOW-CLOSE OF FRAME history-frame 
  APPLY "END-ERROR":U TO SELF.

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
  ON CHOOSE OF BtnHelp IN FRAME {&FRAME-NAME} OR 
     HELP OF FRAME {&FRAME-NAME}
    RUN adecomm/_adehelp.p ( INPUT "admn", 
                             INPUT "CONTEXT", 
                             INPUT {&Database_Identification_History_Dialog_Box},
                             INPUT ? ).
&ENDIF

ON CHOOSE OF BtnOK-2 IN FRAME {&FRAME-NAME}
  APPLY "GO" TO FRAME {&FRAME-NAME}.

ON LEAVE OF edCustDtl IN FRAME {&FRAME-NAME} DO:
  IF ttDetail.tcCustomDetail NE SELF:SCREEN-VALUE THEN
    ASSIGN ttDetail.tlModified     = TRUE
           ttDetail.tcCustomDetail = SELF:SCREEN-VALUE.
END.

ON VALUE-CHANGED OF fiDescription IN FRAME {&FRAME-NAME} DO:
  ASSIGN ttDetail.tlModified    = TRUE
         ttDetail.tcDescription = SELF:SCREEN-VALUE
         ttDetail.tcDescription:SCREEN-VALUE IN BROWSE bDetail = SELF:SCREEN-VALUE.
END.

ON 'VALUE-CHANGED':U OF BROWSE bDetail DO:
  IF NOT AVAILABLE ttDetail THEN
    RETURN.

  DISPLAY tcDBGuid @ fiGuid
          tcDescription @ fiDescription
    WITH FRAME {&FRAME-NAME}.
  
  tbHasMac:CHECKED = tlHasMacKey.
  edCustDtl:SCREEN-VALUE IN FRAME {&FRAME-NAME} = tcCustomDetail.  
END.

ON GO OF FRAME {&FRAME-NAME}
  RUN writeChanges.

/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT EQ ? THEN 
  FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

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
  HIDE FRAME history-frame.
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
  DISPLAY fiGuid fiDescription edCustDtl tbHasMac lblCustDtl lblHasMac 
      WITH FRAME history-frame.
   
  ENABLE &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN RECT-2 &ENDIF
         fiGuid WHEN NOT (SESSION:DISPLAY-TYPE = 'TTY':U )
         {&ENABLED-OBJECTS}
         &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN BtnHelp &ENDIF
      WITH FRAME history-frame.

  IF ronly THEN
      DISABLE fiDescription edCustDtl lblHasMac WITH FRAME history-frame.
  VIEW FRAME history-frame.
  
END PROCEDURE.

PROCEDURE initializeUI :
/*------------------------------------------------------------------------------
  Purpose:     Initialize the user interface
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  RUN loadDetailTT.

  FRAME {&FRAME-NAME}:TITLE = 
      FRAME {&FRAME-NAME}:TITLE + "(" + LDBNAME("DICTDB") + ")".

  OPEN QUERY qDetail FOR EACH ttDetail NO-LOCK BY tiSequence.
  ENABLE bDetail WITH FRAME {&FRAME-NAME}.
  
  APPLY "ENTRY" TO BROWSE bDetail.
  APPLY "VALUE-CHANGED" TO BROWSE bDetail.
END PROCEDURE.

PROCEDURE loadDetailTT :
/*------------------------------------------------------------------------------
  Purpose:     Load the local ttDetail temp-table with records from the
               _db-detail table.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDbDetail AS HANDLE      NO-UNDO.
  DEFINE VARIABLE hQuery    AS HANDLE      NO-UNDO.
  DEFINE VARIABLE hDb       AS HANDLE      NO-UNDO.

  DEFINE VARIABLE iSequence AS INTEGER     NO-UNDO.

  CREATE BUFFER hDbDetail FOR TABLE "DICTDB._db-detail".
  CREATE BUFFER hDb       FOR TABLE "DICTDB._db".


  hDb:FIND-FIRST().
  hDbDetail:FIND-FIRST("WHERE _db-guid = ~'" + hDb::_db-guid + "~'",NO-LOCK) NO-ERROR.
  IF hDbDetail:AVAILABLE THEN DO ON ERROR UNDO, LEAVE TRANSACTION:
    iSequence = iSequence + 1.
    CREATE ttDetail.
    ASSIGN ttDetail.tiSequence     = iSequence
           ttDetail.tcDBGuid       = hDbDetail::_db-guid + "  **"
           ttDetail.tcDescription  = hDbDetail::_db-description 
           ttDetail.tcCustomDetail = hDbDetail::_db-custom-detail
           ttDetail.tlHasMacKey    = (STRING(hDbDetail::_db-mac-key) NE "020000")
           ttDetail.tlModified     = FALSE NO-ERROR.
  END.
  ELSE DO TRANSACTION:
    hDbDetail:BUFFER-CREATE().
    ASSIGN hDbDetail::_db-guid          = hDb::_db-guid
           hDbDetail::_db-description   = hDbDetail:DBNAME
           hDbDetail::_db-custom-detail = "".

    iSequence = iSequence + 1.
    CREATE ttDetail.
    ASSIGN ttDetail.tiSequence     = iSequence
           ttDetail.tcDBGuid       = hDbDetail::_db-guid + "  **"
           ttDetail.tcDescription  = hDbDetail::_db-description 
           ttDetail.tcCustomDetail = hDbDetail::_db-custom-detail
           ttDetail.tlHasMacKey    = (STRING(hDbDetail::_db-mac-key) NE "020000")
           ttDetail.tlModified     = FALSE NO-ERROR.
  END.

  CREATE QUERY hQuery.
  hQuery:SET-BUFFERS(hDbDetail).

  hQuery:QUERY-PREPARE("FOR EACH " + hDbDetail:NAME + 
                       " WHERE _db-guid NE ~'" + hDb::_db-guid +
                       "~' NO-LOCK").
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST().

  QRY-BLK:
  DO WHILE NOT hQuery:QUERY-OFF-END:
    iSequence = iSequence + 1.

    DO ON ERROR UNDO, LEAVE TRANSACTION:
      CREATE ttDetail.
      ASSIGN ttDetail.tiSequence     = iSequence
             ttDetail.tcDBGuid       = hDbDetail::_db-guid
             ttDetail.tcDescription  = hDbDetail::_db-description
             ttDetail.tcCustomDetail = hDbDetail::_db-custom-detail
             ttDetail.tlHasMacKey    = (STRING(hDbDetail::_db-mac-key) NE "020000")
             ttDetail.tlModified     = FALSE NO-ERROR.
    END.
    hQuery:GET-NEXT().
  END.
  DELETE OBJECT hQuery.
  DELETE OBJECT hDb.
  DELETE OBJECT hDbDetail.
END PROCEDURE.

PROCEDURE writeChanges :
/*------------------------------------------------------------------------------
  Purpose:     Write any changes, made by the user during this session, back
               to the _db-detail table.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDbDetail AS HANDLE      NO-UNDO.

  CREATE BUFFER hDbDetail FOR TABLE "DICTDB._db-detail".

  FOR EACH ttDetail WHERE (ttDetail.tlModified = TRUE):
    DEFINE VARIABLE cGuid AS CHARACTER   NO-UNDO.

    DO ON ERROR UNDO, LEAVE TRANSACTION:
      cGuid = (IF ttDetail.tiSequence = 1 THEN 
                 TRIM(RIGHT-TRIM(ttDetail.tcDBGuid,"**"))
               ELSE ttDetail.tcDBGuid).

      hDbDetail:FIND-FIRST("WHERE _db-guid = ~'" + cGuid + "~'").
      IF hDbDetail:AVAILABLE THEN
        ASSIGN hDbDetail::_db-description   = ttDetail.tcDescription
               hDbDetail::_db-custom-detail = ttDetail.tcCustomDetail.
    END.
  END.
  
  DELETE OBJECT hDbDetail.
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
               FRAME history-frame:HIDDEN       = yes &ENDIF
               FRAME history-frame:HEIGHT       = 13.05 + 
                                                  FRAME history-frame:BORDER-TOP + 
                                                  FRAME history-frame:BORDER-BOTTOM.

      ASSIGN BtnCancel:HIDDEN            = yes
             BtnCancel:COL               = 15.4
             BtnCancel:HEIGHT            = .95
             BtnCancel:ROW               = 12.86
             BtnCancel:HIDDEN            = no.

      &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
        ASSIGN BtnHelp:HIDDEN            = yes
               BtnHelp:COL               = 64.8
               BtnHelp:HEIGHT            = .95
               BtnHelp:ROW               = 12.86
               BtnHelp:HIDDEN            = no
               BtnHelp:HIDDEN            = no.

          ASSIGN RECT-2:HIDDEN           = yes
               RECT-2:COL                = 2.2
               RECT-2:EDGE-PIXELS        = 2
               RECT-2:HEIGHT             = 1.38
               RECT-2:ROW                = 12.62
               RECT-2:HIDDEN             = no
               RECT-2:HIDDEN             = no.
      &ENDIF
      
      ASSIGN BtnOK-2:HIDDEN              = yes
             BtnOK-2:COL                 = 3.6
             BtnOK-2:HEIGHT              = .95
             BtnOK-2:ROW                 = 12.86
             BtnOK-2:HIDDEN              = no.

      ASSIGN edCustDtl:HIDDEN            = yes
             edCustDtl:COL               = 20.2
             edCustDtl:HEIGHT            = 2.62
             edCustDtl:ROW               = 9
             edCustDtl:WIDTH             = 54.8
             edCustDtl:HIDDEN            = no.

      ASSIGN fiDescription:HIDDEN        = yes
             widg-pos                    = fiDescription:COL  
             fiDescription:COL           = 20.2
             lbl-hndl                    = fiDescription:SIDE-LABEL-HANDLE  
             lbl-hndl:COL                = lbl-hndl:COL + 
                                           fiDescription:COL - widg-pos
             widg-pos                    = fiDescription:ROW  
             fiDescription:ROW           = 7.81
             lbl-hndl                    = fiDescription:SIDE-LABEL-HANDLE  
             lbl-hndl:ROW                = lbl-hndl:ROW + 
                                           fiDescription:ROW - widg-pos
             fiDescription:WIDTH         = 54.8
             fiDescription:HIDDEN        = no.

      ASSIGN fiGuid:HIDDEN               = yes
             widg-pos                    = fiGuid:COL  
             fiGuid:COL                  = 20.2
             lbl-hndl                    = fiGuid:SIDE-LABEL-HANDLE  
             lbl-hndl:COL                = lbl-hndl:COL + 
                                           fiGuid:COL - widg-pos
             widg-pos                    = fiGuid:ROW  
             fiGuid:ROW                  = 6.62
             lbl-hndl                    = fiGuid:SIDE-LABEL-HANDLE  
             lbl-hndl:ROW                = lbl-hndl:ROW + 
                                           fiGuid:ROW - widg-pos
             fiGuid:WIDTH                = 54.8
             fiGuid:HIDDEN               = no.

      ASSIGN lblCustDtl:HIDDEN           = yes
             lblCustDtl:COL              = 2.6
             lblCustDtl:HEIGHT           = .62
             lblCustDtl:ROW              = 9.05
             lblCustDtl:WIDTH            = 17.4
             lblCustDtl:HIDDEN           = no.

      ASSIGN lblHasMac:HIDDEN            = yes
             lblHasMac:COL               = 57.6
             lblHasMac:HEIGHT            = .62
             lblHasMac:ROW               = 11.71
             lblHasMac:WIDTH             = 14
             lblHasMac:HIDDEN            = no.

      ASSIGN tbHasMac:HIDDEN             = yes
             tbHasMac:COL                = 72.2
             tbHasMac:HEIGHT             = .81
             tbHasMac:ROW                = 11.67
             tbHasMac:WIDTH              = 2.4
             tbHasMac:HIDDEN             = no.

      ASSIGN FRAME history-frame:VIRTUAL-HEIGHT = 13.05
                                   WHEN FRAME history-frame:SCROLLABLE
             &IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN
               FRAME history-frame:HIDDEN       = no &ENDIF.

    END.  /* Master Layout Layout Case */

    WHEN "Standard Character":U THEN DO WITH FRAME {&FRAME-NAME}:
      ASSIGN &IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN
               FRAME history-frame:HIDDEN       = yes &ENDIF
             FRAME history-frame:HEIGHT         = 18 +
                                                  FRAME history-frame:BORDER-TOP + 
                                                  FRAME history-frame:BORDER-BOTTOM
           NO-ERROR.

      ASSIGN BtnCancel:HIDDEN            = yes
             BtnCancel:COL               = 40
             BtnCancel:HEIGHT            = 1
             BtnCancel:ROW               = 17
             BtnCancel:HIDDEN            = no NO-ERROR.

      ASSIGN BtnOK-2:HIDDEN              = yes
             BtnOK-2:COL                 = 27
             BtnOK-2:HEIGHT              = 1
             BtnOK-2:ROW                 = 17
             BtnOK-2:HIDDEN              = no NO-ERROR.

      ASSIGN edCustDtl:HIDDEN            = yes
             edCustDtl:COL               = 20.5
             edCustDtl:HEIGHT            = 5
             edCustDtl:ROW               = 10
             edCustDtl:WIDTH             = 54.5
             edCustDtl:HIDDEN            = no NO-ERROR.

      ASSIGN fiDescription:HIDDEN        = yes
             widg-pos                    = fiDescription:COL  
             fiDescription:COL           = 21
             lbl-hndl                    = fiDescription:SIDE-LABEL-HANDLE  
             lbl-hndl:COL                = lbl-hndl:COL + 
                                           fiDescription:COL - widg-pos
             widg-pos                    = fiDescription:ROW  
             fiDescription:ROW           = 9
             lbl-hndl                    = fiDescription:SIDE-LABEL-HANDLE  
             lbl-hndl:ROW                = lbl-hndl:ROW + 
                                           fiDescription:ROW   - widg-pos
             fiDescription:WIDTH         = 54
             fiDescription:HIDDEN        = no NO-ERROR.

      ASSIGN fiGuid:HIDDEN               = yes
             widg-pos                    = fiGuid:COL  
             fiGuid:COL                  = 21
             lbl-hndl                    = fiGuid:SIDE-LABEL-HANDLE  
             lbl-hndl:COL                = lbl-hndl:COL + 
                                           fiGuid:COL - widg-pos
             widg-pos                    = fiGuid:ROW  
             fiGuid:ROW                  = 8
             lbl-hndl                    = fiGuid:SIDE-LABEL-HANDLE  
             lbl-hndl:ROW                = lbl-hndl:ROW + 
                                           fiGuid:ROW - widg-pos
             fiGuid:WIDTH                = 54
             fiGuid:HIDDEN               = no NO-ERROR.

      ASSIGN lblCustDtl:HIDDEN           = yes
             lblCustDtl:COL              = 1
             lblCustDtl:HEIGHT           = 1
             lblCustDtl:ROW              = 10
             lblCustDtl:WIDTH            = 19
             lblCustDtl:HIDDEN           = no NO-ERROR.

      ASSIGN lblHasMac:HIDDEN            = yes
             lblHasMac:COL               = 60
             lblHasMac:HEIGHT            = 1
             lblHasMac:ROW               = 15
             lblHasMac:WIDTH             = 12
             lblHasMac:HIDDEN            = no NO-ERROR.

      ASSIGN tbHasMac:HIDDEN             = yes
             tbHasMac:COL                = 72
             tbHasMac:HEIGHT             = 1
             tbHasMac:ROW                = 15
             tbHasMac:WIDTH              = 3
             tbHasMac:HIDDEN             = no NO-ERROR.

      ASSIGN FRAME history-frame:VIRTUAL-HEIGHT = 11.00
                        WHEN FRAME history-frame:SCROLLABLE
             &IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN
               FRAME history-frame:HIDDEN       = no &ENDIF NO-ERROR.

    END.  /* Standard Character Layout Case */

  END CASE.
END PROCEDURE.  /* CURRENT-WINDOW-layouts */
