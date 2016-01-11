&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME chgid-frame
/*------------------------------------------------------------------------
/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/

  File: prodict/misc/_db-chgid.p

  Description: Dialog for changing database guid & or mac-key.

  Input Parameters:
      INPUT phTTDbDetail - Handle to the DbDetail Temp-Table

  Output Parameters:
      <none>

  Author: Kenneth S. McIntosh

  Created: April 1, 2005
  
  History: 
    kmcintos May 23, 2005  Disable "Verify" field unless changes have been made. 
                           Bug # 20050506-002.
    kmcintos May 25, 2005  Major changes to UI in order to make changing Passkey 
                           seem more intuitive.
    kmcintos May 26, 2005  Changed "Blank Passkey" logic around a bit 
                           20050526-010.    
    kmcintos June 7, 2005  Added context sensitive help to dialog.
    kmcintos June 17, 2005 Added logic to encrypt the mac key using the 
                           new ENCRYPT-AUDIT-MAC-KEY method of the 
                           AUDIT-POLICY handle 20050614-032.
    kmcintos June 21, 2005 Added HEX-DECODE function for turning MacKey
                           into RAW 20050620-031.
    kmcintos Oct  26, 2005 Assigning hex-decode output to temp var before 
                           comparison 20050928-003.
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE STREAM utilStream.

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER phDbDetail AS HANDLE      NO-UNDO.
DEFINE INPUT  PARAMETER phOldBuff  AS HANDLE      NO-UNDO.
DEFINE OUTPUT PARAMETER pcStatus   AS CHARACTER   NO-UNDO.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE glMacMod  AS LOGICAL     NO-UNDO.
DEFINE VARIABLE glCancel  AS LOGICAL     NO-UNDO.
DEFINE VARIABLE glHasMac  AS LOGICAL     NO-UNDO.
DEFINE VARIABLE lProceed  AS LOGICAL     NO-UNDO.

DEFINE VARIABLE gcInitial AS CHARACTER   NO-UNDO.

{prodict/admnhlp.i}
{prodict/misc/misc-funcs.i}

/* ********************  Preprocessor Definitions  ******************** */

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME chgid-frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbBlank fiMacKey fiVerifMac btnPasskey Btn_OK Btn_Cancel   
&Scoped-Define DISPLAYED-OBJECTS fiGuid btnPasskey tbBlank fiMacKey fiVerifMac txtLine1 txtLine2 txtLine3 txtLine4 btn_OK btn_Cancel

/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
  DEFINE BUTTON BtnHelp DEFAULT 
     LABEL "&Help" 
     SIZE 10 BY .95 BGCOLOR 8.
     
  DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 75.8 BY 1.57.
&ENDIF

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

DEFINE BUTTON btnPasskey
     LABEL "Change Passkey"
     &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
       SIZE 18 BY .95 BGCOLOR 8
     &ELSE
       SIZE 16 BY .95 
     &ENDIF .
                    
DEFINE VARIABLE fiGuid AS CHARACTER FORMAT "X(256)":U 
     LABEL "DB Identifier" 
     VIEW-AS FILL-IN SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE fiMacKey AS CHARACTER FORMAT "X(256)":U 
     LABEL "DB Passkey" 
     VIEW-AS FILL-IN SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE fiVerifMac AS CHARACTER FORMAT "X(256)":U 
     LABEL "Verify Passkey" 
     VIEW-AS FILL-IN SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE txtLine1 AS CHARACTER FORMAT "X(256)":U 
    INITIAL 
"Generating a new Database Passkey or Identifier may change how your" 
      VIEW-AS TEXT 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 74 BY 1
     &ELSE SIZE 74 BY .62 &ENDIF NO-UNDO.

DEFINE VARIABLE txtLine2 AS CHARACTER FORMAT "X(256)":U 
    INITIAL "database is identified in utilities that use these values." 
      VIEW-AS TEXT 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 74 BY 1
     &ELSE SIZE 74 BY .62 &ENDIF NO-UNDO.

DEFINE VARIABLE txtLine3 AS CHARACTER FORMAT "X(256)":U 
    INITIAL 
"You should be very certain that it is your intention to perform this" 
      VIEW-AS TEXT 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 74 BY 1
     &ELSE SIZE 74 BY .62 &ENDIF NO-UNDO.

DEFINE VARIABLE txtLine4 AS CHARACTER FORMAT "X(256)":U 
    INITIAL "action before saving changes." 
      VIEW-AS TEXT 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 74 BY 1
     &ELSE SIZE 74 BY .62 &ENDIF NO-UNDO.

DEFINE VARIABLE tbBlank AS LOGICAL 
    INITIAL FALSE VIEW-AS TOGGLE-BOX
    LABEL "No Passkey" NO-UNDO.
    
/* ************************  Frame Definitions  *********************** */

DEFINE FRAME chgid-frame
     fiGuid
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 1 COL 6 
          &ELSE AT ROW 1.24 COL 8.2 &ENDIF
     btnPasskey
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 2 COL 62 
          &ELSE AT ROW 2.33 COL 60 COLON-ALIGNED PASSWORD-FIELD &ENDIF
     tbBlank
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 4 COL 45 
          &ELSE AT ROW 4.52 COL 45 COLON-ALIGNED PASSWORD-FIELD &ENDIF
     fiMacKey
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN 
            AT ROW 2 COL 19 COLON-ALIGNED BLANK 
          &ELSE AT ROW 2.33 COL 19 COLON-ALIGNED PASSWORD-FIELD &ENDIF  
     fiVerifMac
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN 
            AT ROW 3 COL 19 COLON-ALIGNED BLANK 
          &ELSE AT ROW 3.43 COL 19 COLON-ALIGNED PASSWORD-FIELD &ENDIF 
     txtLine1 NO-LABEL
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 6 COL 1 COLON-ALIGNED
          &ELSE AT ROW 5.81 COL 3 &ENDIF
     txtLine2 NO-LABEL
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 7 COL 1 COLON-ALIGNED
          &ELSE AT ROW 6.48 COL 1 COLON-ALIGNED &ENDIF
     txtLine3 NO-LABEL
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 9 COL 1 COLON-ALIGNED
          &ELSE AT ROW 7.86 COL 1 COLON-ALIGNED &ENDIF
     txtLine4 NO-LABEL
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 10 COL 1 COLON-ALIGNED
          &ELSE AT ROW 8.48 COL 1 COLON-ALIGNED &ENDIF
     Btn_OK
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 28
          &ELSE AT ROW 9.76 COL 2.8 &ENDIF
     Btn_Cancel
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 39
          &ELSE AT ROW 9.76 COL 13.4 &ENDIF
     &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
       BtnHelp AT ROW 9.76 COL 66.2 
       RECT-1 AT ROW 9.43 COL 1.6 
     &ENDIF
     SPACE(0.99) &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN SKIP(1) &ENDIF
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER CENTERED
         &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN ROW 1 &ENDIF
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "New Database Passkey/Identifier"
         DEFAULT-BUTTON Btn_OK.

ASSIGN FRAME chgid-frame:SCROLLABLE            = FALSE
       FRAME chgid-frame:HIDDEN                = TRUE
       fiGuid:READ-ONLY IN FRAME {&FRAME-NAME} = TRUE.

/* ************************  Control Triggers  ************************ */

ON WINDOW-CLOSE OF FRAME chgid-frame /* New Database Passkey/Identifier */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
  ON CHOOSE OF BtnHelp IN FRAME chgid-frame OR
     HELP OF FRAME {&FRAME-NAME}
    RUN "adecomm/_adehelp.p" ( INPUT "admn", 
                               INPUT "CONTEXT", 
                               INPUT {&Database_Passkey_Identifier_Dialog_Box},
                               INPUT ?).
  
&ENDIF

ON CHOOSE OF Btn_Cancel IN FRAME chgid-frame /* Cancel */
DO:
  APPLY "WINDOW-CLOSE" TO FRAME chgid-frame.
END.

ON CHOOSE OF Btn_OK IN FRAME chgid-frame /* OK */
DO:
  APPLY "GO" TO FRAME chgid-frame.
END.

ON VALUE-CHANGED OF tbBlank
  RUN valueChangedTB.

ON CHOOSE OF btnPasskey IN FRAME {&FRAME-NAME} DO:
  IF SELF:LABEL = "Change Passkey" THEN
    ASSIGN tbBlank:SENSITIVE = TRUE
           SELF:LABEL        = "Undo".
  ELSE
    ASSIGN tbBlank:SENSITIVE = FALSE
           tbBlank:CHECKED   = NOT glHasMac
           SELF:LABEL        = "Change Passkey"
           glMacMod          = FALSE.
  
  /* Put TB VALUE-CHANGED trigger code in a procedure because
     of differences in the way this behaves between GUI and TTY. 
     Bug # 19970128-029 */        
  RUN valueChangedTB.

  IF tbBlank:SENSITIVE THEN
    APPLY "ENTRY" TO tbBlank.
  ELSE APPLY "ENTRY" TO fiMacKey.
END.

ON VALUE-CHANGED OF fiMacKey OR 
   VALUE-CHANGED OF fiVerifMac 
  glMacMod = TRUE.
  
/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

ON END-ERROR OF FRAME {&FRAME-NAME}
  pcStatus = "Cancelled".

ON GO OF FRAME {&FRAME-NAME} DO:
  DEFINE VARIABLE tmpRaw AS RAW.
  DEFINE VARIABLE rawBI  AS RAW.

  IF NOT tbBlank:CHECKED AND
     glMacMod AND
     COMPARE(fiMacKey:SCREEN-VALUE,"NE",
             fiVerifMac:SCREEN-VALUE,"CASE-SENSITIVE") THEN DO:
    MESSAGE "DB Passkey value does not match Verify Passkey value!" SKIP(1)
            "You must verify the database passkey, or hit Cancel to undo " +
            "changes."
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    APPLY "CHOOSE" TO btnPasskey.
    APPLY "ENTRY" TO btnPasskey.
    RETURN NO-APPLY.
  END.
  
  phDbDetail:EMPTY-TEMP-TABLE().
  phDbDetail:BUFFER-CREATE().
  phDbDetail:BUFFER-COPY(phOldBuff,"_db-guid").
      
  phDbDetail::_db-guid      = fiGuid:SCREEN-VALUE.
  
  IF glMacMod AND
     (tbBlank:CHECKED OR
      (fiMacKey:SCREEN-VALUE NE "" AND
       fiMacKey:SCREEN-VALUE NE ?))THEN DO:
    /* If the user blanked out the mac key, reset the db to not use a 
       mac key. */
    IF tbBlank:CHECKED THEN DO:
      /* Only make the change if necessary. */
      IF glHasMac THEN
        phDbDetail::_db-mac-key = tmpRaw.
    END.
    ELSE DO:
      tmpRaw = HEX-DECODE(AUDIT-POLICY:ENCRYPT-AUDIT-MAC-KEY(fiMacKey:SCREEN-VALUE)).
      IF tmpRaw NE phOldBuff::_db-mac-key THEN
        phDbDetail::_db-mac-key = tmpRaw.
    END.
  END.
  ELSE IF tbBlank:CHECKED        EQ FALSE  AND
          glHasMac               EQ FALSE  AND
          btnPasskey:LABEL       EQ "Undo" AND
          (fiMacKey:SCREEN-VALUE EQ ""     OR
           fiMacKey:SCREEN-VALUE EQ ?) THEN DO:
    MESSAGE "You have deselected the ~"No Passkey~" toggle, indicating that " +
            "you wish to assign a Passkey to this database, but have " +
            "entered no Passkey value!" SKIP(1)
            "Please enter a Passkey, re-select the ~"No Passkey~" toggle or " +
            "choose the Cancel button to cancel this transaction."
        VIEW-AS ALERT-BOX ERROR BUTTONS OK-CANCEL UPDATE lProceed.
    
    IF lProceed THEN DO:
      APPLY "ENTRY" TO tbBlank.
      RETURN NO-APPLY.
    END.
    ELSE pcStatus = "Cancelled".
  END.
END.
  
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
  HIDE FRAME chgid-frame.
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
  DISPLAY {&DISPLAYED-OBJECTS} 
      WITH FRAME chgid-frame.
  ENABLE fiGuid WHEN NOT (SESSION:DISPLAY-TYPE = "TTY")
         {&ENABLED-OBJECTS}
         &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
           RECT-1
           BtnHelp 
         &ENDIF
      WITH FRAME chgid-frame.
  VIEW FRAME chgid-frame.
END PROCEDURE.

PROCEDURE initializeUI :
/*------------------------------------------------------------------------------
  Purpose:     Generate and display new GUID and initialize interface.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cGuid     AS CHARACTER   NO-UNDO.

  FRAME chgid-frame:TITLE = FRAME chgid-frame:TITLE + 
                            " (" + LDBNAME("DICTDB") + ")".

  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
    SESSION:SET-WAIT-STATE("GENERAL").
  &ENDIF
  
  cGuid = generateGuid().
 
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
    SESSION:SET-WAIT-STATE("").
  &ENDIF
  
  DO WITH FRAME chgid-frame:
    ASSIGN glHasMac                = 
                            (STRING(phOldBuff::_db-mac-key) NE "020000")
           gcInitial               = (IF glHasMac THEN "_db-chgid_initial_" 
                                      ELSE "")
           fiGuid:SCREEN-VALUE     = cGuid
           fiMacKey:SCREEN-VALUE   = gcInitial 
           fiVerifMac:SCREEN-VALUE = gcInitial
           tbBlank:CHECKED         = NOT glHasMac
           fiMacKey:SENSITIVE      = FALSE
           fiVerifMac:SENSITIVE    = FALSE
           tbBlank:SENSITIVE       = FALSE.
  END.
END PROCEDURE.

PROCEDURE valueChangedTB:
  DO WITH FRAME {&FRAME-NAME}:
    IF tbBlank:CHECKED THEN
      ASSIGN fiMacKey:SCREEN-VALUE   = ""
             fiMacKey:SENSITIVE      = FALSE
             fiVerifMac:SCREEN-VALUE = ""
             fiVerifMac:SENSITIVE    = FALSE.
    ELSE
      ASSIGN fiMacKey:SCREEN-VALUE   = (IF btnPasskey:LABEL = "Undo" THEN
                                          "" ELSE gcInitial)
             fiMacKey:SENSITIVE      = (btnPasskey:LABEL = "Undo")
             fiVerifMac:SCREEN-VALUE = (IF btnPasskey:LABEL = "Undo" THEN
                                          "" ELSE gcInitial)
             fiVerifMac:SENSITIVE    = (btnPasskey:LABEL = "Undo").
           
    glMacMod = TRUE.
    IF tbBlank:CHECKED = FALSE THEN
      APPLY "ENTRY" TO fiMacKey.
  END.
END PROCEDURE.

