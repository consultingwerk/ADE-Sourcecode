&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
/*************************************************************/
/* Copyright (c) 1984-2007 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/

/*------------------------------------------------------------------------

  File: prodict/sec/_sec-dom.p

  Description: Maintenance dialog for the _sec-authentication-domain table.

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Kenneth S. McIntosh

  Created: April 25, 2005

  History: 
    kmcintos May 24, 2005  Added validation for Name and Type fields 
                           20050524-013.
    kmcintos May 25, 2005  Removed return when not available from browse 
                           value-changed trigger 20050524-012.
                           
                           Also had to refine some navigation logic.
    kmcintos May 26, 2005  Added validation to prevent saving duplicate 
                           domain 20050525-047.
    kmcintos June 7, 2005  Removed local help button trigger to allow the one 
                           in sec-trgs.i to fire.
    kmcintos June 17, 2005 Added logic in localSave to encrypt access code 
                           using the new ENCRYPT-AUDIT-MAC-KEY method of
                           the AUDIT-POLICY handle 20050614-032.
    kmcintos Oct 28, 2005  Added code to enforce mandatory assignment of
                           access code 20051028-022.
    fernando 11/30/07      Check if read-only mode.                           
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

{prodict/sec/sec-func.i}
{prodict/sec/ui-procs.i}
{prodict/misc/misc-funcs.i}

/* ***************************  Definitions  ************************** */
CREATE WIDGET-POOL.

IF NOT dbAdmin(USERID("DICTDB")) THEN DO:
  MESSAGE "You must be a Security Administrator to access this utility!"
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN "".
END.
          
IF checkReadOnly("DICTDB","_sec-authentication-system") NE "" OR
   checkReadOnly("DICTDB","_sec-authentication-domain") NE "" THEN
   RETURN.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE TEMP-TABLE saDom NO-UNDO RCODE-INFORMATION
    FIELD dName       AS CHARACTER LABEL "Name"             FORMAT "x(20)"
                                   CASE-SENSITIVE
    FIELD dType       AS CHARACTER LABEL "Type"             FORMAT "x(30)"
    FIELD dDescrip    AS CHARACTER LABEL "Description"      FORMAT "x(40)"
    FIELD dAccessCode AS CHARACTER LABEL "Access Code"      FORMAT "x(45)"
    FIELD dAContext   AS CHARACTER LABEL "Auditing Context" FORMAT "x(45)"
    FIELD dROptions   AS CHARACTER LABEL "Runtime Options"  FORMAT "x(65)"
    FIELD dComments   AS CHARACTER LABEL "Custom Detail"    FORMAT "x(200)"
    FIELD dEnabled    AS LOGICAL   LABEL "Enabled"          FORMAT "Yes/No"
    INDEX idxDomain   AS PRIMARY UNIQUE dName.

DEFINE VARIABLE gcSort       AS CHARACTER   NO-UNDO INITIAL "dName".
DEFINE VARIABLE gcSystemList AS CHARACTER   NO-UNDO.
DEFINE VARIABLE gcMods       AS CHARACTER   NO-UNDO.

DEFINE QUERY qDomain FOR saDom SCROLLING.

DEFINE BROWSE bDomain QUERY qDomain
    DISPLAY dName
            dType
            dDescrip
            dEnabled
    &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
      ENABLE dName &ENDIF
    WITH NO-ROW-MARKERS SEPARATORS
         &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 3 DOWN WIDTH 75 NO-BOX
         &ELSE SIZE 78 BY 5.24 &ENDIF FIT-LAST-COLUMN.

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN

&Scoped-Define ENABLED-OBJECTS cbType tbEnabled fiName fiAccessCode fiAContext fiDescrip fiROptions edComments btnCreate btnSave btnCancel btnDelete btnDone bDomain

&Scoped-Define DISPLAYED-OBJECTS cbType lblEnabled tbEnabled fiName fiAccessCode fiAContext fiDescrip lblROptions fiROptions lblComments edComments   

&ELSE

&Scoped-Define ENABLED-OBJECTS cbType fiName fiAccessCode fiAContext fiDescrip fiROptions edComments tbEnabled btnCreate btnSave btnCancel btnDelete btnDone bDomain

&Scoped-Define DISPLAYED-OBJECTS cbType fiName fiAccessCode fiAContext fiDescrip lblROptions fiROptions lblComments edComments lblEnabled tbEnabled

&ENDIF
/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnCancel 
     LABEL "Ca&ncel" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 11 BY 1
     &ELSE SIZE 11 BY .95 &ENDIF.

DEFINE BUTTON btnCreate 
     LABEL "&Create" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 11 BY 1
     &ELSE SIZE 11 BY .95 &ENDIF.

DEFINE BUTTON btnDelete 
     LABEL "Delete" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 11 BY 1
     &ELSE SIZE 11 BY .95 &ENDIF.

DEFINE BUTTON btnDone 
     LABEL "&Done" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 11 BY 1
     &ELSE SIZE 11 BY .95 &ENDIF
     BGCOLOR 8 .

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  DEFINE BUTTON BtnHelp DEFAULT 
       LABEL "&Help" 
       SIZE 11 BY .95
       BGCOLOR 8 .
       
  DEFINE RECTANGLE RECT-2
       EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
       &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
       &ELSE SIZE 78 BY 1.43 &ENDIF.
&ENDIF

DEFINE BUTTON btnSave 
     LABEL "&Save" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 11 BY 1
     &ELSE SIZE 11 BY .95 &ENDIF.

DEFINE VARIABLE cbType AS CHARACTER FORMAT "X(256)":U 
     LABEL "Type" 
     VIEW-AS COMBO-BOX 
     INNER-LINES &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN 3 &ELSE 5 &ENDIF
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 37 BY 1
     &ELSE SIZE 59.4 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE edComments AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 53 BY 5
     &ELSE SIZE 59.4 BY 2.91 &ENDIF NO-UNDO.

DEFINE VARIABLE fiAContext AS CHARACTER FORMAT "X(256)":U 
     LABEL "Audit Context" 
     VIEW-AS FILL-IN 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 51 BY 1
     &ELSE SIZE 59.4 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE fiAccessCode AS CHARACTER FORMAT "X(256)":U  
     LABEL "Access Code" 
     VIEW-AS FILL-IN 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 51 BY 1
     &ELSE SIZE 59.4 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE fiDescrip AS CHARACTER FORMAT "X(256)":U 
     LABEL "Description" 
     VIEW-AS FILL-IN 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 51 BY 1
     &ELSE SIZE 59.4 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE fiName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Name" 
     VIEW-AS FILL-IN 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 51 BY 1
     &ELSE SIZE 59.4 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE lblComments AS CHARACTER FORMAT "X(256)":U 
                               INITIAL "Comments:" 
      VIEW-AS TEXT 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 9 BY 1
     &ELSE SIZE 10.2 BY .62 &ENDIF NO-UNDO.

DEFINE VARIABLE lblEnabled AS CHARACTER FORMAT "X(256)":U 
                              INITIAL "Domain Enabled:" 
      VIEW-AS TEXT 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 16 BY 1
     &ELSE SIZE 17 BY .62 &ENDIF NO-UNDO.

DEFINE VARIABLE lblROptions AS CHARACTER FORMAT "X(256)":U 
                               INITIAL "Runtime Options:" 
      VIEW-AS TEXT 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 16 BY 1
     &ELSE SIZE 18 BY .62 &ENDIF NO-UNDO.

DEFINE VARIABLE fiROptions AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 51 BY 1
     &ELSE SIZE 59.4 BY 1 &ENDIF NO-UNDO.
                    
DEFINE VARIABLE tbEnabled AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 3 BY 1
     &ELSE SIZE 3 BY .71 &ENDIF NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     bDomain
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT 2 SKIP(1)
          &ELSE AT ROW 1.14 COL 2.2 &ENDIF
     cbType
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN COLON 16 
          &ELSE AT ROW 7.24 COL 15 COLON-ALIGNED &ENDIF
     &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
       lblEnabled NO-LABEL VIEW-AS TEXT COLON 55
       tbEnabled NO-LABEL AT 73 SKIP
     &ENDIF
     fiName
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN COLON 16 SKIP
          &ELSE AT ROW 8.33 COL 15 COLON-ALIGNED &ENDIF
     fiAccessCode PASSWORD-FIELD
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN COLON 16 SKIP
          &ELSE AT ROW 9.43 COL 14.8 COLON-ALIGNED &ENDIF
     fiAContext
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN COLON 16 SKIP
          &ELSE AT ROW 10.52 COL 14.8 COLON-ALIGNED &ENDIF
     lblROptions VIEW-AS TEXT NO-LABEL
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT 1 SPACE(0)
          &ELSE AT ROW 11.61 COL 3 &ENDIF
     fiROptions NO-LABEL
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT 18 SKIP
          &ELSE AT ROW 12.24 COL 16.6 &ENDIF
     fiDescrip
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN COLON 16 SKIP
          &ELSE AT ROW 13.33 COL 5 &ENDIF
     lblComments NO-LABEL VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN COLON 6
          &ELSE AT ROW 14.43 COL 3.6 COLON-ALIGNED &ENDIF
     edComments NO-LABEL
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT 17 SKIP
          &ELSE AT ROW 14.43 COL 16.6 &ENDIF
     &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
       lblEnabled NO-LABEL VIEW-AS TEXT
                  AT ROW 17.43 COL 53 
                  COLON-ALIGNED 
       tbEnabled NO-LABEL AT ROW 17.43 COL 73.2 
     &ENDIF
     btnDone
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT 2
          &ELSE AT ROW 18.62 COL 3 &ENDIF
     btnCreate
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT 26
          &ELSE AT ROW 18.62 COL 18.2 &ENDIF
     btnSave
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT 38
          &ELSE AT ROW 18.62 COL 29.6 &ENDIF
     btnCancel
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT 50
          &ELSE AT ROW 18.62 COL 41 &ENDIF
     btnDelete
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT 62
          &ELSE AT ROW 18.62 COL 52.4 &ENDIF
     &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
       BtnHelp AT ROW 18.62 COL 67.8
       RECT-2 AT ROW 18.33 COL 2 &ENDIF 
     SPACE(1.39) SKIP(0.14)
    WITH &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
           VIEW-AS DIALOG-BOX THREE-D &ENDIF 
         KEEP-TAB-ORDER ROW 1 SIDE-LABELS 
         NO-UNDERLINE SCROLLABLE CENTERED
         TITLE "Authentication System Domains"
         DEFAULT-BUTTON btnDone.

{prodict/sec/sec-trgs.i
      &frame_name    =   "Dialog-Frame"}
      
&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
  BROWSE bDomain:HELP = KBLABEL("CTRL-A") + "=Create  " +
                        KBLABEL("DEL")    + "=Delete  " +
                        KBLABEL("GO")     + "=Done".
  cbType:HELP IN FRAME {&FRAME-NAME} =
                  "Enter Domain Type then hit " + KBLABEL("GO") +
                  " to Save or " + KBLABEL("CTRL-N") + " to Cancel".
  fiName:HELP IN FRAME {&FRAME-NAME} =
                  "Enter Domain Name then hit " + KBLABEL("GO") +
                  " to Save or " + KBLABEL("CTRL-N") + " to Cancel".
  fiAccessCode:HELP IN FRAME {&FRAME-NAME} =
                  "Enter Access Code then hit " + KBLABEL("GO") +
                  " to Save or " + KBLABEL("CTRL-N") + " to Cancel".
  fiAContext:HELP IN FRAME {&FRAME-NAME} =
                  "Enter Auditing Context then hit " + KBLABEL("GO") +
                  " to Save or " + KBLABEL("CTRL-N") + " to Cancel".
  fiROptions:HELP IN FRAME {&FRAME-NAME} =
                  "Enter Runtime Options then hit " + KBLABEL("GO") +
                  " to Save or " + KBLABEL("CTRL-N") + " to Cancel".
  fiDescrip:HELP IN FRAME {&FRAME-NAME} =
                  "Enter Description then hit " + KBLABEL("GO") +
                  " to Save or " + KBLABEL("CTRL-N") + " to Cancel".
  edComments:HELP IN FRAME {&FRAME-NAME} =
                  "Enter Comments then hit " + KBLABEL("GO") +
                  " to Save or " + KBLABEL("CTRL-N") + " to Cancel".
  tbEnabled:HELP IN FRAME {&FRAME-NAME} =
                  "Hit Spacebar, " + KBLABEL("GO") +
                  " to Save or " + KBLABEL("CTRL-N") + " to Cancel".
&ENDIF

/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

/* SETTINGS FOR DIALOG-BOX Dialog-Frame FRAME-NAME */
ASSIGN FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* ************************  Control Triggers  ************************ */

ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Authentication System Domains */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

ON CHOOSE OF btnDone IN FRAME {&FRAME-NAME} 
  APPLY "GO":U TO FRAME {&FRAME-NAME}.

ON "GO" OF FRAME {&FRAME-NAME} DO:
  IF btnSave:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE THEN
    LEAVE.
  
  APPLY "CHOOSE" TO btnSave IN FRAME {&FRAME-NAME}.
  RETURN NO-APPLY.
END.

ON VALUE-CHANGED OF fiDescrip IN FRAME {&FRAME-NAME} DO:
  IF glCreateMode THEN LEAVE.
  
  IF AVAILABLE saDom AND
    saDom.dDescrip NE SELF:SCREEN-VALUE THEN DO:
      RUN setButtonState ( INPUT "UpdateMode" ).
      BROWSE bDomain:SENSITIVE = FALSE.
      IF NOT CAN-DO(gcMods,SELF:NAME) THEN
        gcMods = gcMods + (IF gcMods NE "" THEN "," ELSE "") +
                 SELF:NAME.
  END.
  ELSE DO:
    gcMods = REPLACE(REPLACE(gcMods,SELF:NAME,""),",,",",").
    IF gcMods EQ "" OR
       gcMods EQ "," THEN DO:
      BROWSE bDomain:SENSITIVE = TRUE.
      gcMods = "".
      RUN setButtonState ( "ResetMode" ).
    END.
  END.
END.

ON VALUE-CHANGED OF fiAccessCode IN FRAME {&FRAME-NAME} DO:
  IF glCreateMode THEN LEAVE.
  
  IF AVAILABLE saDom AND
    saDom.dAccessCode NE SELF:SCREEN-VALUE THEN DO:
      RUN setButtonState ( INPUT "UpdateMode" ).
      BROWSE bDomain:SENSITIVE = FALSE.
      IF NOT CAN-DO(gcMods,SELF:NAME) THEN
        gcMods = gcMods + (IF gcMods NE "" THEN "," ELSE "") +
                 SELF:NAME.
  END.
  ELSE DO:
    gcMods = REPLACE(REPLACE(gcMods,SELF:NAME,""),",,",",").
    IF gcMods EQ "" OR
       gcMods EQ "," THEN DO:
      BROWSE bDomain:SENSITIVE = TRUE.
      gcMods = "".
      RUN setButtonState ( "ResetMode" ).
    END.
  END.
END.

ON VALUE-CHANGED OF fiROptions IN FRAME {&FRAME-NAME} DO:
  IF glCreateMode THEN LEAVE.
  
  IF AVAILABLE saDom AND
    saDom.dROptions NE SELF:SCREEN-VALUE THEN DO:
      RUN setButtonState ( INPUT "UpdateMode" ).
      BROWSE bDomain:SENSITIVE = FALSE.
      IF NOT CAN-DO(gcMods,SELF:NAME) THEN
        gcMods = gcMods + (IF gcMods NE "" THEN "," ELSE "") +
                 SELF:NAME.
  END.
  ELSE DO:
    gcMods = REPLACE(REPLACE(gcMods,SELF:NAME,""),",,",",").
    IF gcMods EQ "" OR
       gcMods EQ "," THEN DO:
      BROWSE bDomain:SENSITIVE = TRUE.
      gcMods = "".
      RUN setButtonState ( "ResetMode" ).
    END.
  END.
END.

ON VALUE-CHANGED OF tbEnabled IN FRAME {&FRAME-NAME} DO:
  IF glCreateMode THEN LEAVE.
  
  IF AVAILABLE saDom AND
    saDom.dEnabled NE SELF:CHECKED THEN DO:
      RUN setButtonState ( INPUT "UpdateMode" ).
      BROWSE bDomain:SENSITIVE = FALSE.
      IF NOT CAN-DO(gcMods,SELF:NAME) THEN
        gcMods = gcMods + (IF gcMods NE "" THEN "," ELSE "") +
                 SELF:NAME.
  END.
  ELSE DO:
    gcMods = REPLACE(REPLACE(gcMods,SELF:NAME,""),",,",",").
    IF gcMods EQ "" OR
       gcMods EQ "," THEN DO:
      BROWSE bDomain:SENSITIVE = TRUE.
      gcMods = "".
      RUN setButtonState ( "ResetMode" ).
    END.
  END.
END.

ON VALUE-CHANGED OF BROWSE bDomain DO:

  RUN displayRecord.
  IF ronly THEN DO:
      RUN setFieldState ( INPUT "DisableMode" ).
      RUN setButtonState ( INPUT "DisableMode" ).
  END.
  ELSE DO:
      RUN setFieldState ( INPUT "ResetMode" ).
      RUN setButtonState ( INPUT "ResetMode" ).
  END.

END.

ON END-ERROR ANYWHERE DO:
  IF btnCancel:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
    APPLY "CHOOSE" TO btnCancel.
    RETURN NO-APPLY.
  END.
END.

ON VALUE-CHANGED OF fiAContext IN FRAME {&FRAME-NAME} DO:
  IF glCreateMode THEN LEAVE.
  
  IF AVAILABLE saDom AND
    saDom.dAContext NE SELF:SCREEN-VALUE THEN DO:
      RUN setButtonState ( INPUT "UpdateMode" ).
      BROWSE bDomain:SENSITIVE = FALSE.
      IF NOT CAN-DO(gcMods,SELF:NAME) THEN
        gcMods = gcMods + (IF gcMods NE "" THEN "," ELSE "") +
                 SELF:NAME.
  END.
  ELSE DO:
    gcMods = REPLACE(REPLACE(gcMods,SELF:NAME,""),",,",",").
    IF gcMods EQ "" OR
       gcMods EQ "," THEN DO:
      BROWSE bDomain:SENSITIVE = TRUE.
      gcMods = "".
      RUN setButtonState ( "ResetMode" ).
    END.
  END.
END.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  saDom.dName:READ-ONLY IN BROWSE bDomain = TRUE.
  ON START-SEARCH OF BROWSE bDomain DO:
    DEFINE VARIABLE cCol AS CHARACTER  NO-UNDO.
    
    cCol = SELF:CURRENT-COLUMN:NAME.
    IF gcSort EQ cCol THEN
      gcSort = cCol + " DESC".
    ELSE gcSort = cCol.
    
    RUN openQuery.
  END.

  ON VALUE-CHANGED OF edComments IN FRAME {&FRAME-NAME} DO:
    IF glCreateMode THEN LEAVE.
    
    IF AVAILABLE saDom AND
       saDom.dComments NE SELF:SCREEN-VALUE THEN DO:
      RUN setButtonState ( INPUT "UpdateMode" ).
      BROWSE bDomain:SENSITIVE = FALSE.
      IF NOT CAN-DO(gcMods,SELF:NAME) THEN 
        gcMods = gcMods + (IF gcMods NE "" THEN "," ELSE "") +
                 SELF:NAME.
    END.
    ELSE DO:
      gcMods = REPLACE(REPLACE(gcMods,SELF:NAME,""),",,",",").
      IF gcMods EQ "" OR 
         gcMods EQ "," THEN DO:
        BROWSE bDomain:SENSITIVE = TRUE.
        gcMods = "".
        RUN setButtonState ( "ResetMode" ).
      END.  
    END.
  END.
&ELSE
  ON ENTRY OF BROWSE bDomain DO:
    IF LAST-EVENT:WIDGET-LEAVE = 
        btnDelete:HANDLE IN FRAME {&FRAME-NAME} THEN DO:
      APPLY "ENTRY" TO btnDone IN FRAME {&FRAME-NAME}.
      RETURN NO-APPLY.
    END.
  END.

  ON LEAVE OF btnCreate IN FRAME {&FRAME-NAME} DO:
    IF btnDelete:SENSITIVE IN FRAME {&FRAME-NAME} EQ FALSE THEN DO:
      APPLY "ENTRY" TO btnDone IN FRAME {&FRAME-NAME}.
      RETURN NO-APPLY.
    END.
  END.
                        
  ON ENTRY OF btnDone IN FRAME {&FRAME-NAME} DO:
    IF NOT ronly AND LAST-EVENT:WIDGET-LEAVE EQ
              BROWSE bDomain:HANDLE THEN DO:
      APPLY "ENTRY" TO btnCreate IN FRAME {&FRAME-NAME}.
      RETURN NO-APPLY.
    END.
  END.
            
  ON ENTRY OF btnCreate DO:
    IF LAST-EVENT:WIDGET-LEAVE =
        btnDone:HANDLE IN FRAME {&FRAME-NAME} THEN DO:
      APPLY "ENTRY" TO BROWSE bDomain.
      RETURN NO-APPLY.
    END.
  END.

  ON CTRL-N ANYWHERE DO:
    IF btnCancel:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
      IF FOCUS EQ edcomments:HANDLE IN FRAME {&FRAME-NAME} THEN DO:
        IF gcMods NE "" THEN
          APPLY "CHOOSE" TO btnCancel IN FRAME {&FRAME-NAME}.
        ELSE RETURN NO-APPLY.
      END.
      ELSE APPLY "CHOOSE" TO btnCancel IN FRAME {&FRAME-NAME}.
    END.
    ELSE RETURN NO-APPLY.
  END.

  ON CTRL-A ANYWHERE DO:
    IF btnCreate:SENSITIVE IN FRAME {&FRAME-NAME} OR
       (FOCUS = edcomments:HANDLE IN FRAME {&FRAME-NAME} AND
        gcMods EQ "") THEN
      APPLY "CHOOSE" TO btnCreate IN FRAME {&FRAME-NAME}.
    ELSE RETURN NO-APPLY.
  END.
  
  ON CTRL-S ANYWHERE DO:
    IF btnSave:SENSITIVE IN FRAME {&FRAME-NAME} OR
       (FOCUS = edcomments:HANDLE IN FRAME {&FRAME-NAME} AND
        gcMods EQ "") THEN
      APPLY "CHOOSE" TO btnSave   IN FRAME {&FRAME-NAME}.
    ELSE RETURN NO-APPLY.
  END.

  ON DEL OF BROWSE bDomain DO:
    IF AVAILABLE saDom THEN
      APPLY "CHOOSE" TO btnDelete IN FRAME {&FRAME-NAME}.
  END.

  ON ENTRY OF edComments IN FRAME {&FRAME-NAME} DO:
    IF glCreateMode THEN LEAVE.

    RUN setButtonState ( INPUT "UpdateMode" ).
    BROWSE bDomain:SENSITIVE = FALSE.
  END.

  ON LEAVE OF edComments IN FRAME {&FRAME-NAME} DO:
    IF glCreateMode THEN LEAVE.

    IF AVAILABLE saDom AND
     saDom.dComments NE SELF:SCREEN-VALUE THEN DO:
      RUN setButtonState ( INPUT "UpdateMode" ).
      BROWSE bDomain:SENSITIVE = FALSE.
      IF NOT CAN-DO(gcMods,SELF:NAME) THEN
        gcMods = gcMods + (IF gcMods NE "" THEN "," ELSE "") +
                 SELF:NAME.
    END.
    ELSE DO:
      gcMods = REPLACE(REPLACE(gcMods,SELF:NAME,""),",,",",").
      IF gcMods EQ "" OR
         gcMods EQ "," THEN DO:
        BROWSE bDomain:SENSITIVE = TRUE.
        gcMods = "".
        RUN setButtonState ( "ResetMode" ).
      END.
    END.
  END.

  ON ENTRY OF btnDelete DO:
    IF LAST-EVENT:WIDGET-LEAVE = 
        edComments:HANDLE IN FRAME {&FRAME-NAME} THEN DO:
      APPLY "ENTRY" TO btnCreate IN FRAME {&FRAME-NAME}.
      RETURN NO-APPLY.
    END.
  END.
&ENDIF

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
  DISPLAY {&DISPLAYED-OBJECTS}  
      WITH FRAME Dialog-Frame.

  ENABLE {&ENABLED-OBJECTS} 
        &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
         BtnHelp RECT-2 &ENDIF      
    WITH FRAME Dialog-Frame.

  VIEW FRAME Dialog-Frame.
END PROCEDURE.

PROCEDURE initializeUI:
  ghBuffer   = BUFFER saDom:HANDLE.
  gcFileName = "Authentication System Domains".
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN gcFieldHandles      = STRING(cbType:HANDLE)  + "," + "&1," +
                                 STRING(fiName:HANDLE)  + "," + "&2," +
                                 STRING(fiAccessCode:HANDLE)  + "," + "&3," +
                                 STRING(fiAContext:HANDLE)  + "," + "&4," +
                                 STRING(fiROptions:HANDLE)  + "," + "&5," +
                                 STRING(fiDescrip:HANDLE)  + "," + "&6," +
                                 STRING(edComments:HANDLE)  + "," + "&7," +
                                 STRING(tbEnabled:HANDLE)  + "," + "&8"
           gcFieldInits        = SUBSTITUTE(gcFieldHandles,
                                 CHR(1) + " ",
                                 CHR(1) + "",
                                 CHR(1) + "",
                                 CHR(1) + "",
                                 CHR(1) + "",
                                 CHR(1) + "",
                                 CHR(1) + "",
                                 CHR(1) + "YES")
           gcFieldInits        = REPLACE(gcFieldInits,"," + CHR(1),CHR(1))
           gcCreateModeFields  = SUBSTITUTE(gcFieldHandles,
                                            "yes",
                                            "yes",
                                            "yes",
                                            "yes",
                                            "yes",
                                            "yes",
                                            "yes",
                                            "yes")
           gcResetModeFields   = SUBSTITUTE(gcFieldHandles,
                                            "no",
                                            "no",
                                            "iab",
                                            "iab",
                                            "iab",
                                            "iab",
                                            "iab",
                                            "iab")
           gcDisableModeFields = SUBSTITUTE(gcFieldHandles,
                                            "no",
                                            "no",
                                            "no",
                                            "no",
                                            "no",
                                            "no",
                                            "no",
                                            "no")
           gcFieldHandles      = REPLACE(gcFieldHandles,",&1","")
           gcFieldHandles      = REPLACE(gcFieldHandles,",&2","")
           gcFieldHandles      = REPLACE(gcFieldHandles,",&3","")
           gcFieldHandles      = REPLACE(gcFieldHandles,",&4","")
           gcFieldHandles      = REPLACE(gcFieldHandles,",&5","")
           gcFieldHandles      = REPLACE(gcFieldHandles,",&6","")
           gcFieldHandles      = REPLACE(gcFieldHandles,",&7","")
           gcFieldHandles      = REPLACE(gcFieldHandles,",&8","")
           gcDBFields          = "_domain-type,_domain-name," +
                                 "_domain-access-code,_auditing-context," +
                                 "_domain-runtime-options," +
                                 "_domain-description," +
                                 "_domain-custom-detail,_domain-enabled"
           gcTTFields          = "dType,dName,dAccessCode,dAContext," + 
                                 "dROptions,dDescrip,dComments,dEnabled"
           ghFrame             = FRAME {&FRAME-NAME}:HANDLE
           gcKeyField          = "_domain-name,dName,CHAR"
           gcDBBuffer          = "DICTDB._sec-authentication-domain".
  
    RUN loadSystemList.
    cbType:LIST-ITEMS = gcSystemList.
  END.
  
  RUN loadDomains.
  
  IF NUM-DBS > 0 THEN
    FRAME {&FRAME-NAME}:TITLE = FRAME {&FRAME-NAME}:TITLE +
                                " (" + LDBNAME("DICTDB") + ")".

  IF ronly THEN DO:
      RUN setButtonState ( INPUT "DisableMode" ).
      RUN setFieldState  ( INPUT "DisableMode" ).
  END.
  ELSE DO:
      RUN setButtonState ( INPUT "ResetMode" ).
      RUN setFieldState  ( INPUT "ResetMode" ).
  END.
  RUN openQuery.
  
  APPLY "ENTRY" TO BROWSE bDomain.
  APPLY "VALUE-CHANGED" TO BROWSE bDomain.
END PROCEDURE.

PROCEDURE loadSystemList:
  DEFINE VARIABLE hBuff  AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hQuery AS HANDLE    NO-UNDO.
  
  CREATE BUFFER hBuff FOR TABLE "DICTDB._sec-authentication-system".
  
  CREATE QUERY hQuery.
  hQuery:SET-BUFFERS(hBuff).
  hQuery:QUERY-PREPARE("FOR EACH _sec-authentication-system NO-LOCK" +
                       " BY _domain-type").
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST().

  gcSystemList  = " ".
  DO WHILE NOT hQuery:QUERY-OFF-END:
    gcSystemList = gcSystemList + "," + 
                   hBuff::_domain-type.
    hQuery:GET-NEXT().
  END.

  DELETE OBJECT hQuery.
  DELETE OBJECT hBuff.
END PROCEDURE.

PROCEDURE loadDomains:
  DEFINE VARIABLE hBuff  AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hQuery AS HANDLE    NO-UNDO.
  
  CREATE BUFFER hBuff FOR TABLE "DICTDB._sec-authentication-domain".
  
  CREATE QUERY hQuery.
  hQuery:SET-BUFFERS(hBuff).
  hQuery:QUERY-PREPARE("FOR EACH _sec-authentication-domain NO-LOCK").
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST().
  
  DO WHILE NOT hQuery:QUERY-OFF-END:
    DO TRANSACTION ON ERROR UNDO, NEXT:
      CREATE saDom.
      ASSIGN dName       = hBuff::_domain-name
             dType       = hBuff::_domain-type
             dDescrip    = hBuff::_domain-description
             dAccessCode = hBuff::_domain-access-code
             dAContext   = hBuff::_auditing-context
             dROptions   = hBuff::_domain-runtime-options
             dEnabled    = hBuff::_domain-enabled
             dComments   = hBuff::_domain-custom-detail.
    END.
    hQuery:GET-NEXT().
  END.

  DELETE OBJECT hQuery.
  DELETE OBJECT hBuff.
END PROCEDURE.

PROCEDURE localDelete :
/*------------------------------------------------------------------------------
  Purpose:     Local hook for additional logic to occur during the 
               deleteRecord event.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcTxnLoc AS CHARACTER   NO-UNDO.
 
  DEFINE VARIABLE lDelete   AS LOGICAL     NO-UNDO.

  CASE pcTxnLoc:
    WHEN "Before" THEN DO:
      MESSAGE "Are you sure you want to delete this domain?"
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lDelete.
      IF NOT lDelete THEN RETURN "Cancel".

      RUN setRowidForDelete (INPUT QUERY qDomain:PREPARE-STRING ).
      IF RETURN-VALUE NE "" THEN
        RETURN "Cancel".
      ELSE RETURN "".
    END.
    WHEN "After" THEN DO:
      RUN openQuery.
      RETURN "".
    END.
  END CASE.
END PROCEDURE.

PROCEDURE localSave :
/*------------------------------------------------------------------------------
  Purpose:     Local hook for additional logic to occur during a saveRecord
               event.
  Parameters:  INPUT pcTxnLoc - The location where this was called in respect
                                to the actual transaction.
  Notes:       "Before" = Before the transaction even begins
               "Start"  = At the start of the transaction, before anything is 
                          done
               "End"    = At the end of the transaction, after all logic has
                          executed
               "After"  = After the transaction has been commited.  
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcTxnLoc AS CHARACTER   NO-UNDO.

  DEFINE VARIABLE hAuthDom AS HANDLE NO-UNDO.
  
  CASE pcTxnLoc:
    WHEN "Before" THEN DO WITH FRAME {&FRAME-NAME}:
      IF cbType:SCREEN-VALUE EQ ""  OR
         cbType:SCREEN-VALUE EQ "?" OR
	   cbType:SCREEN-VALUE EQ ? THEN DO:
        MESSAGE "You must select a domain type for this domain."
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        APPLY "ENTRY" TO cbType.
        RETURN "Retry".
      END.
      IF fiName:SCREEN-VALUE EQ ""  OR 
         fiName:SCREEN-VALUE EQ "?" OR
         fiName:SCREEN-VALUE EQ ? THEN DO:
        MESSAGE "You must enter a name for this domain." 
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        APPLY "ENTRY" TO fiName.
        RETURN "Retry".
      END.
      IF fiAccessCode:SCREEN-VALUE EQ ""  OR
         fiAccessCode:SCREEN-VALUE EQ "?" OR
         fiAccessCode:SCREEN-VALUE EQ ? THEN DO:
        MESSAGE "You must enter an access code."
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        APPLY "ENTRY" TO fiAccessCode.
        RETURN "Retry".
      END.
      IF glCreateMode THEN DO:
        CREATE BUFFER hAuthDom FOR TABLE "DICTDB._sec-authentication-domain".
        hAuthDom:FIND-FIRST("WHERE COMPARE(_domain-name,~"=~",~"" + 
                            fiName:SCREEN-VALUE + 
                            "~",~"CASE-SENSITIVE~")",NO-LOCK) NO-ERROR. 
        IF hAuthDom:AVAILABLE THEN DO:
          MESSAGE "A domain already exists with this name!" SKIP(1)
                  "Please enter a unique name for this domain." SKIP(1)
                  "Note: Domain Names are case sensitive."
              VIEW-AS ALERT-BOX ERROR BUTTONS OK.
          APPLY "ENTRY" TO fiName.
          RETURN "Retry".
        END.
      END. /* If glCreateMode */
      IF glCreateMode OR fiAccessCode:MODIFIED THEN
        fiAccessCode:SCREEN-VALUE = 
          AUDIT-POLICY:ENCRYPT-AUDIT-MAC-KEY(fiAccessCode:SCREEN-VALUE).
    END. /* When Before */
    WHEN "After" THEN DO:
      RUN openQuery.
      RETURN "".
    END.
  END CASE.
END PROCEDURE.

PROCEDURE localTrig :
/*------------------------------------------------------------------------------
  Purpose:     Local hook for additional logic to occur after a trigger fires
               prodict/sec/sec-trgs.i
  Parameters:  INPUT pcTrigger - The event that was fired
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcTrigger AS CHARACTER   NO-UNDO.

  CASE pcTrigger:
    WHEN "Create" THEN DO:
      APPLY "ENTRY" TO cbType IN FRAME {&FRAME-NAME}.
      BROWSE bDomain:SENSITIVE = FALSE.
      RETURN "".
    END.
    WHEN "Save" THEN DO:
      BROWSE bDomain:SENSITIVE = TRUE.
      RETURN "".
    END.
    WHEN "Cancel" THEN DO:
      BROWSE bDomain:SENSITIVE = TRUE.
      RETURN "".
    END.
  END CASE.
END PROCEDURE.

PROCEDURE openQuery:
  DEFINE VARIABLE hQuery AS HANDLE      NO-UNDO.
  
  /* This is a static query but we prepare it like a dynamic query so
     that we can get the PREPARE-STRING later on for repositioning */
  hQuery = QUERY qDomain:HANDLE.
  hQuery:QUERY-PREPARE("FOR EACH saDom BY " + gcSort).
  hQuery:QUERY-OPEN().
               
  IF grwLastRowid NE ? THEN
    REPOSITION qDomain TO ROWID grwLastRowid NO-ERROR.
                     
  /* This fires off the display of the ui fields */
  APPLY "VALUE-CHANGED" TO BROWSE bDomain.
                         
  RETURN "".
END PROCEDURE.

