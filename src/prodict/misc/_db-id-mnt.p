&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME controls-frame
/*------------------------------------------------------------------------
/*************************************************************/  
/* Copyright (c) 1984-2007 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/

  File: prodict/misc/_db-id-mnt.p

  Description: Dialog for maintaining _db-detail records.

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Kenneth S. McIntosh

  Created: April 1st, 2005

  History: 
    kmcintos May 26, 2005  Checking for changes on leave of editor & displaying 
                           blank when no mac key:20050525-017
    kmcintos May 27, 2005  Removed ANY-PRINTABLE trigger from editor 
                           20050525-017.
    kmcintos June 7, 2005  Added context sensitive help to dialog and removed
                           appbuilder friendly code.
    fernando 11/30/07      Check if read-only mode.                           
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

CREATE WIDGET-POOL.

{prodict/misc/misc-funcs.i}
{prodict/admnhlp.i}

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE        VARIABLE glDescMod   AS LOGICAL     NO-UNDO.
DEFINE        VARIABLE glCustMod   AS LOGICAL     NO-UNDO.
DEFINE        VARIABLE glNew       AS LOGICAL     NO-UNDO.

DEFINE        VARIABLE ghDb        AS HANDLE      NO-UNDO.
DEFINE        VARIABLE ghDbDetail  AS HANDLE      NO-UNDO.
DEFINE        VARIABLE ghTTDetail  AS HANDLE      NO-UNDO.

DEFINE        VARIABLE cMessage    AS CHARACTER   NO-UNDO.
DEFINE        VARIABLE gcInitial   AS CHARACTER   NO-UNDO.

DEFINE SHARED VARIABLE drec_db     AS RECID       NO-UNDO.

/* Sanity check, to ensure that there is a DB connected.  This is
   probably unnecessary, but it's better to be safe... */
IF NUM-DBS = 0 THEN
  cMessage = "There is no database connected!" + CHR(10) + CHR(10) +
             "Please connect to a database and try again.".
ELSE DO:
  IF NOT dbAdmin(USERID("DICTDB")) THEN DO:
    MESSAGE "You must be a Database Administrator to run this tool!"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN "No Permission".
  END.

  IF checkReadOnly("DICTDB","_Db-detail") NE "" THEN
     RETURN "No Permission".

  CREATE BUFFER ghDb FOR TABLE "DICTDB._db".
  CREATE BUFFER ghDbDetail FOR TABLE "DICTDB._db-detail" NO-ERROR.
  IF NOT VALID-HANDLE(ghDbDetail) THEN
    cMessage = "The _db-detail table doesn't exist in this database.".
END.

IF cMessage NE "" THEN DO:
  MESSAGE cMessage
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

CREATE TEMP-TABLE ghTTDetail.
ghTTDetail:CREATE-LIKE(ghDbDetail).
ghTTDetail:TEMP-TABLE-PREPARE("dbDetail").

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

&Scoped-define LAYOUT-VARIABLE CURRENT-WINDOW-layout

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME controls-frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiDescription edCustomDetail btnMacId Btn_OK Btn_Cancel
&Scoped-Define DISPLAYED-OBJECTS fiDescription edCustomDetail fiGuid fiMacKey lblCustomDetail 

/* Define a variable to store the name of the active layout.            */
DEFINE VAR CURRENT-WINDOW-layout AS CHAR INITIAL "Master Layout":U NO-UNDO.

/* ***********************  Control Definitions  ********************** */

/* Definitions of the field level widgets                               */
&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
  DEFINE BUTTON BtnHelp DEFAULT 
     LABEL "&Help" 
     SIZE 10 BY .95 
     BGCOLOR 8. &ENDIF

DEFINE BUTTON btnMacId 
     LABEL "New DB Passkey/Identifier" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 34 BY 1
     &ELSE SIZE 34.2 BY .95 &ENDIF.

DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
     &ELSE SIZE 10 BY .95 &ENDIF
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK 
     LABEL "OK" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
     &ELSE SIZE 10 BY .95 &ENDIF
     BGCOLOR 8 .

DEFINE VARIABLE edCustomDetail AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 54 BY 6
     &ELSE SIZE 54.2 BY 2.76 &ENDIF NO-UNDO.

DEFINE VARIABLE fiDescription AS CHARACTER FORMAT "X(256)":U 
     LABEL "DB Description" 
     VIEW-AS FILL-IN 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 54 BY 1
     &ELSE SIZE 54 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE fiGuid AS CHARACTER FORMAT "X(256)":U 
     LABEL "DB Identifier" 
     VIEW-AS FILL-IN 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 54 BY 1
     &ELSE SIZE 54 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE fiMacKey AS CHARACTER FORMAT "X(256)":U 
     LABEL "DB Passkey" 
     VIEW-AS FILL-IN 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 54 BY 1
     &ELSE SIZE 54 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE lblCustomDetail AS CHARACTER FORMAT "X(256)":U INITIAL "Additional Details:" 
      VIEW-AS TEXT 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 19 BY 1
     &ELSE SIZE 17.4 BY .62 &ENDIF NO-UNDO.

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
  DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 75.8 BY 1.57 &ENDIF.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME controls-frame
     fiDescription
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 4 COL 20 COLON-ALIGNED
          &ELSE AT ROW 3.62 COL 18.8 COLON-ALIGNED &ENDIF
     edCustomDetail
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 5 COL 22
          &ELSE AT ROW 4.67 COL 20.8 &ENDIF NO-LABEL
     btnMacId
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 42
          &ELSE AT ROW 8.1 COL 28.2 &ENDIF
     Btn_OK
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 3
          &ELSE AT ROW 8.1 COL 3.2 &ENDIF
     Btn_Cancel
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 13
          &ELSE AT ROW 8.1 COL 13.8 &ENDIF
     &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
       BtnHelp AT ROW 8.1 COL 66.6 &ENDIF
     fiGuid
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 1 COL 20 COLON-ALIGNED
          &ELSE AT ROW 1.24 COL 18.8 COLON-ALIGNED &ENDIF
     fiMacKey
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 3 COL 20 COLON-ALIGNED
          &ELSE AT ROW 2.43 COL 18.8 COLON-ALIGNED &ENDIF PASSWORD-FIELD 
     lblCustomDetail
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 5 COL 2
          &ELSE AT ROW 4.67 COL 3.4 &ENDIF NO-LABEL
     &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
       RECT-1 AT ROW 7.76 COL 2 &ENDIF
     SPACE(0.59) &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN SKIP(1) &ENDIF
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER CENTERED
         &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN ROW 1 &ENDIF
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Database Identification Maintenance"
         DEFAULT-BUTTON Btn_OK.


/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

ASSIGN FRAME controls-frame:SCROLLABLE       = FALSE
       FRAME controls-frame:HIDDEN           = TRUE.

ASSIGN fiGuid:READ-ONLY IN FRAME controls-frame        = TRUE.

IF SESSION:DISPLAY-TYPE = 'TTY':U  THEN 
  RUN CURRENT-WINDOW-layouts (INPUT 'Standard Character':U) NO-ERROR.

/* ************************  Control Triggers  ************************ */

ON WINDOW-CLOSE OF FRAME controls-frame 
  APPLY "END-ERROR":U TO SELF.

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
  ON CHOOSE OF BtnHelp IN FRAME controls-frame OR 
     HELP OF FRAME {&FRAME-NAME} 
    RUN adecomm/_adehelp.p ( INPUT "admn", 
                             INPUT "CONTEXT", 
                             INPUT {&Database_Identification_Maintenance_Dialog_Box},
                             INPUT ? ).
&ENDIF

ON CHOOSE OF btnMacId IN FRAME controls-frame DO:
  DEFINE VARIABLE cStatus AS CHARACTER   NO-UNDO.

  RUN prodict/misc/_db-chgid.p ( INPUT ghTTDetail:DEFAULT-BUFFER-HANDLE,
                                 INPUT ghDbDetail,
                                 OUTPUT cStatus ).

  IF cStatus NE "cancelled" THEN DO:
    glNew = TRUE.
    RUN displayDbDetail ( INPUT ghTTDetail:DEFAULT-BUFFER-HANDLE ).
    APPLY "ENTRY" TO btn_Ok IN FRAME controls-frame.
  END.
END.

ON CHOOSE OF Btn_Cancel IN FRAME controls-frame 
  APPLY "WINDOW-CLOSE" TO FRAME {&FRAME-NAME}.

ON CHOOSE OF Btn_OK IN FRAME controls-frame 
  APPLY "GO" TO FRAME controls-frame.

ON VALUE-CHANGED OF fiDescription IN FRAME controls-frame 
  glDescMod = TRUE.

ON GO OF FRAME controls-frame DO:
  DO TRANSACTION ON ERROR UNDO, LEAVE:
    IF glNew THEN DO:
      ghDbDetail:BUFFER-CREATE().
      ghDbDetail:BUFFER-COPY(ghTTDetail:DEFAULT-BUFFER-HANDLE).
      ghDb::_db-guid = ghDbDetail::_db-guid.
    END.
    IF glDescMod OR
       ghDbDetail::_db-description NE fiDescription:SCREEN-VALUE THEN
      ghDbDetail::_db-description = fiDescription:SCREEN-VALUE.
      
    IF glCustMod OR
       ghDbDetail::_db-custom-detail NE edCustomDetail:SCREEN-VALUE THEN
      ghDbDetail::_db-custom-detail = edCustomDetail:SCREEN-VALUE.
  END. /* DO TRANSACTION */
END.

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
  ghDb:FIND-FIRST("WHERE RECID(_db) = " + STRING(drec_db),NO-LOCK) NO-ERROR.
  ghDbDetail:FIND-FIRST("WHERE _db-detail._db-guid = ~'" + 
                        ghDb::_db-guid + "~'") NO-ERROR.
    
  RUN initializeUI.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* **********************  Internal Procedures  *********************** */

PROCEDURE assignDbDetail :
/*------------------------------------------------------------------------------
  Purpose:     Generic proc to create a new _db-detail record and assign
               values to all of it's fields.
  Parameters:  INPUT phDbDetail     - Buffer handle to _db-detail buffer
               INPUT pcGuid         - Value of _db-guid field
               INPUT pcMacKey       - Value of _db-mac-key field
               INPUT pcDescription  - Value of _db-description field
               INPUT pcCustomDetail - Value of _db-custom-detail field
  Notes:        
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phDbDetail     AS HANDLE      NO-UNDO.
  DEFINE INPUT  PARAMETER pcGuid         AS CHARACTER   NO-UNDO.
  DEFINE INPUT  PARAMETER prMacKey       AS RAW         NO-UNDO.
  DEFINE INPUT  PARAMETER pcDescription  AS CHARACTER   NO-UNDO.
  DEFINE INPUT  PARAMETER pcCustomDetail AS CHARACTER   NO-UNDO.

  ASSIGN phDbDetail::_db-guid          = pcGuid
         phDbDetail::_db-mac-key       = prMacKey
         phDbDetail::_db-description   = pcDescription
         phDbDetail::_db-custom-detail = pcCustomDetail.

END PROCEDURE.

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
  HIDE FRAME controls-frame.
END PROCEDURE.

PROCEDURE displayDbDetail :
/*------------------------------------------------------------------------------
  Purpose:     To display the current _db-detail record on the screen.
  Parameters:  <none>
  Notes:       If no _db-detail record exists, we create one.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phDbDetail AS HANDLE      NO-UNDO.

  IF NOT phDbDetail:AVAILABLE THEN DO TRANSACTION:
    phDbDetail:BUFFER-CREATE().
    RUN assignDbDetail ( INPUT phDbDetail,
                         INPUT ghDb::_db-guid,
                         INPUT ?,
                         INPUT phDbDetail:DBNAME,
                         INPUT "" ).
  END.

  DO WITH FRAME controls-frame:
    ASSIGN fiGuid:SCREEN-VALUE         = phDbDetail::_db-guid
           fiMacKey:SCREEN-VALUE       = (IF STRING(phDbDetail::_db-mac-key) 
                                                EQ "020000" THEN ""
                                          ELSE "_db-id-mnt_initial_")    
           fiDescription:SCREEN-VALUE  = (IF NOT glDescMod THEN 
                                            phDbDetail::_db-description
                                          ELSE fiDescription:SCREEN-VALUE)
           edCustomDetail:SCREEN-VALUE = (IF NOT glCustMod THEN 
                                            phDbDetail::_db-custom-detail
                                          ELSE edCustomDetail:SCREEN-VALUE).
  END.
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
  DISPLAY fiDescription edCustomDetail fiGuid fiMacKey lblCustomDetail 
      WITH FRAME controls-frame.
  
  ENABLE {&ENABLED-OBJECTS}
         &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN BtnHelp &ENDIF
         fiGuid WHEN NOT (SESSION:DISPLAY-TYPE = 'TTY':U )
         &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN RECT-1 &ENDIF
      WITH FRAME controls-frame.
  IF ronly THEN
      DISABLE fiDescription edCustomDetail btnMacId WITH FRAME controls-frame.
  VIEW FRAME controls-frame.
  
END PROCEDURE.

PROCEDURE initializeUI :
/*------------------------------------------------------------------------------
  Purpose:     Find the current _db-detail record and display it in the 
               interface.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN displayDbDetail ( INPUT ghDbDetail ).

  FRAME controls-frame:TITLE = FRAME controls-frame:TITLE + 
                               " (" + LDBNAME("DICTDB") + ")".
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
               FRAME controls-frame:HIDDEN = yes &ENDIF
             FRAME controls-frame:HEIGHT   = 8.33 + 
                                             FRAME controls-frame:BORDER-TOP + 
                                             FRAME controls-frame:BORDER-BOTTOM
             FRAME controls-frame:WIDTH    = 77.4 + 
                                             FRAME controls-frame:BORDER-LEFT + 
                                             FRAME controls-frame:BORDER-RIGHT.

      &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
        ASSIGN BtnHelp:HIDDEN              = yes
               BtnHelp:COL                 = 66.6
               BtnHelp:HEIGHT              = .95
               BtnHelp:ROW                 = 8.1
               BtnHelp:HIDDEN              = no
               BtnHelp:HIDDEN              = no.

        ASSIGN RECT-1:EDGE-PIXELS          = 2
               RECT-1:HIDDEN               = yes
               RECT-1:HEIGHT               = 1.57
               RECT-1:ROW                  = 7.76
               RECT-1:WIDTH                = 75.8
               RECT-1:HIDDEN               = no
               RECT-1:HIDDEN               = no.
      &ENDIF

      ASSIGN btnMacId:HIDDEN               = yes
             btnMacId:COL                  = 28.2
             btnMacId:HEIGHT               = .95
             btnMacId:ROW                  = 8.1
             btnMacId:WIDTH                = 34.2
             btnMacId:HIDDEN               = no.

      ASSIGN Btn_Cancel:HIDDEN             = yes
             Btn_Cancel:COL                = 13.8
             Btn_Cancel:HEIGHT             = .95
             Btn_Cancel:ROW                = 8.1
             Btn_Cancel:HIDDEN             = no.

      ASSIGN Btn_OK:HIDDEN                 = yes
             Btn_OK:COL                    = 3.2
             Btn_OK:HEIGHT                 = .95
             Btn_OK:ROW                    = 8.1
             Btn_OK:HIDDEN                 = no.

      ASSIGN edCustomDetail:HIDDEN         = yes
             edCustomDetail:COL            = 20.8
             edCustomDetail:HEIGHT         = 2.76
             edCustomDetail:ROW            = 4.67
             edCustomDetail:WIDTH          = 54.2
             edCustomDetail:HIDDEN         = no.

      ASSIGN fiDescription:HIDDEN          = yes
             widg-pos                      = fiDescription:COL  
             fiDescription:COL             = 20.8
             lbl-hndl                      = fiDescription:SIDE-LABEL-HANDLE  
             lbl-hndl:COL                  = lbl-hndl:COL + 
                                             fiDescription:COL - widg-pos
             widg-pos                      = fiDescription:ROW  
             fiDescription:ROW             = 3.62
             lbl-hndl                      = fiDescription:SIDE-LABEL-HANDLE  
             lbl-hndl:ROW                  = lbl-hndl:ROW + 
                                             fiDescription:ROW - widg-pos
             fiDescription:HIDDEN          = no.

      ASSIGN fiGuid:HIDDEN                 = yes
             widg-pos                      = fiGuid:COL  
             fiGuid:COL                    = 20.8
             lbl-hndl                      = fiGuid:SIDE-LABEL-HANDLE  
             lbl-hndl:COL                  = lbl-hndl:COL + 
                                             fiGuid:COL - widg-pos
             widg-pos                      = fiGuid:ROW  
             fiGuid:ROW                    = 1.24
             lbl-hndl                      = fiGuid:SIDE-LABEL-HANDLE  
             lbl-hndl:ROW                  = lbl-hndl:ROW + 
                                             fiGuid:ROW - widg-pos
             fiGuid:HIDDEN                 = no.

      ASSIGN fiMacKey:HIDDEN               = yes
             widg-pos                      = fiMacKey:COL  
             fiMacKey:COL                  = 20.8
             lbl-hndl                      = fiMacKey:SIDE-LABEL-HANDLE  
             lbl-hndl:COL                  = lbl-hndl:COL + 
                                             fiMacKey:COL - widg-pos
             widg-pos                      = fiMacKey:ROW  
             fiMacKey:ROW                  = 2.43
             lbl-hndl                      = fiMacKey:SIDE-LABEL-HANDLE  
             lbl-hndl:ROW                  = lbl-hndl:ROW + fiMacKey:ROW   - widg-pos
             fiMacKey:HIDDEN               = no.

      ASSIGN lblCustomDetail:HIDDEN        = yes
             lblCustomDetail:COL           = 3.4
             lblCustomDetail:HEIGHT        = .62
             lblCustomDetail:ROW           = 4.67
             lblCustomDetail:WIDTH         = 17.4
             lblCustomDetail:HIDDEN        = no.

      ASSIGN &IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN
               FRAME controls-frame:HIDDEN = no &ENDIF.

    END.  /* Master Layout Layout Case */

    WHEN "Standard Character":U THEN DO WITH FRAME {&FRAME-NAME}:
      ASSIGN &IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN
               FRAME controls-frame:HIDDEN = yes &ENDIF
             FRAME controls-frame:HEIGHT   = 12 + 
                                             FRAME controls-frame:BORDER-TOP + 
                                             FRAME controls-frame:BORDER-BOTTOM
             FRAME controls-frame:WIDTH    = 77 + 
                                             FRAME controls-frame:BORDER-LEFT + 
                                             FRAME controls-frame:BORDER-RIGHT 
           NO-ERROR.

      ASSIGN btnMacId:HIDDEN               = yes
             btnMacId:COL                  = 42
             btnMacId:HEIGHT               = 1
             btnMacId:ROW                  = 12
             btnMacId:WIDTH                = 34
             btnMacId:HIDDEN               = no NO-ERROR.

      ASSIGN Btn_Cancel:HIDDEN             = yes
             Btn_Cancel:COL                = 14
             Btn_Cancel:HEIGHT             = 1
             Btn_Cancel:ROW                = 12
             Btn_Cancel:HIDDEN             = no NO-ERROR.

      ASSIGN Btn_OK:HIDDEN                 = yes
             Btn_OK:COL                    = 3
             Btn_OK:HEIGHT                 = 1
             Btn_OK:ROW                    = 12
             Btn_OK:HIDDEN                 = no NO-ERROR.

      ASSIGN edCustomDetail:HIDDEN         = yes
             edCustomDetail:COL            = 22
             edCustomDetail:HEIGHT         = 6
             edCustomDetail:ROW            = 5
             edCustomDetail:WIDTH          = 54
             edCustomDetail:HIDDEN         = no NO-ERROR.

      ASSIGN fiDescription:HIDDEN          = yes
             widg-pos                      = fiDescription:COL  
             fiDescription:COL             = 22
             lbl-hndl                      = fiDescription:SIDE-LABEL-HANDLE  
             lbl-hndl:COL                  = lbl-hndl:COL + 
                                             fiDescription:COL - widg-pos
             widg-pos                      = fiDescription:ROW  
             fiDescription:ROW             = 4
             lbl-hndl                      = fiDescription:SIDE-LABEL-HANDLE  
             lbl-hndl:ROW                  = lbl-hndl:ROW + 
                                             fiDescription:ROW - widg-pos
             fiDescription:HIDDEN          = no NO-ERROR.

      ASSIGN fiGuid:HIDDEN                 = yes
             widg-pos                      = fiGuid:COL  
             fiGuid:COL                    = 22
             lbl-hndl                      = fiGuid:SIDE-LABEL-HANDLE  
             lbl-hndl:COL                  = lbl-hndl:COL + 
                                             fiGuid:COL - widg-pos
             widg-pos                      = fiGuid:ROW  
             fiGuid:ROW                    = 1.5
             lbl-hndl                      = fiGuid:SIDE-LABEL-HANDLE  
             lbl-hndl:ROW                  = lbl-hndl:ROW + 
                                             fiGuid:ROW - widg-pos
             fiGuid:HIDDEN                 = no NO-ERROR.

      ASSIGN fiMacKey:HIDDEN               = yes
             widg-pos                      = fiMacKey:COL  
             fiMacKey:COL                  = 22
             lbl-hndl                      = fiMacKey:SIDE-LABEL-HANDLE  
             lbl-hndl:COL                  = lbl-hndl:COL + 
                                             fiMacKey:COL - widg-pos
             widg-pos                      = fiMacKey:ROW  
             fiMacKey:ROW                  = 3
             lbl-hndl                      = fiMacKey:SIDE-LABEL-HANDLE  
             lbl-hndl:ROW                  = lbl-hndl:ROW + 
                                             fiMacKey:ROW - widg-pos
             fiMacKey:HIDDEN               = no NO-ERROR.

      ASSIGN lblCustomDetail:HIDDEN        = yes
             lblCustomDetail:COL           = 2
             lblCustomDetail:HEIGHT        = 1
             lblCustomDetail:ROW           = 5
             lblCustomDetail:WIDTH         = 19
             lblCustomDetail:HIDDEN        = no NO-ERROR.

      ASSIGN &IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN
               FRAME controls-frame:HIDDEN = no &ENDIF NO-ERROR.

    END.  /* Standard Character Layout Case */

  END CASE.
END PROCEDURE.  /* CURRENT-WINDOW-layouts */
