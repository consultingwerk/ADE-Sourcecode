&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
/*************************************************************/
/* Copyright (c) 1984-2012 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/

/*------------------------------------------------------------------------

  File: prodict/sec/_sec-sys.p

  Description: Maintenance dialog for _sec-authentication-system table.

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Kenneth S. McIntosh

  Created: April 25, 2005

  History: 
    kmcintos May 24, 2005  Added validation for Domain Type field 20050524-013.
    kmcintos May 25, 2005  Removed return when not available from browse 
                           value-changed trigger 20050524-009.
                           
                           Also had to remove extra VALUE-CHANGED trigger and 
                           redefine some of the navigation logic.
    kmcintos May 26, 2005  Added validation to prevent saving a duplicate 
                           system 20050525-047.
    kmcintos June 7, 2005  Removed local help button trigger to allow the one 
                           in sec-trgs.i to fire.
    kmcintos Oct 21, 2005  Set initial value of _PAM-plug-in field to FALSE
                           when it's set from this UI 20050926-003.
    fernando 11/30/07      Check if read-only mode.
    rkamboj  08/16/11      Added new terminology for security items and windows. 
    rkamboj  04/04/2012    Added field "Enable Authentication" and "Callback" for the
                           PAM plug-in feature.
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{prodict/sec/sec-func.i}
{prodict/sec/ui-procs.i}
{prodict/misc/misc-funcs.i}

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
CREATE WIDGET-POOL.

IF NOT dbAdmin(USERID("DICTDB")) THEN DO:
  MESSAGE "You must be a Security Administrator to access this utility!"
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN "".
END.

IF checkReadOnly("DICTDB","_sec-authentication-system") NE "" THEN
   RETURN.

DEFINE VARIABLE hColumn AS HANDLE      NO-UNDO EXTENT 2.

DEFINE VARIABLE gcSort  AS CHARACTER   NO-UNDO INITIAL "dType".
DEFINE VARIABLE gcMods  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE inbuild AS LOGICAL     NO-UNDO.
DEFINE VARIABLE derr    AS LOGICAL     NO-UNDO.
DEFINE TEMP-TABLE saSys NO-UNDO RCODE-INFORMATION
    FIELD dType         AS CHARACTER LABEL "Domain Type"        FORMAT "x(25)"
    FIELD dDescrip      AS CHARACTER LABEL "Description"        FORMAT "x(65)"
    FIELD dDetails      AS CHARACTER LABEL "Comments" FORMAT "x(200)"
    FIELD dAuthEnabled  AS LOGICAL   LABEL "Enable Authentication"
    FIELD dCallback  AS CHARACTER LABEL "Callback" FORMAT "x(100)"
    INDEX idxSystem AS PRIMARY UNIQUE dType.

DEFINE QUERY qSystem FOR saSys SCROLLING.

DEFINE BROWSE bSystem QUERY qSystem
    DISPLAY dType
            dDescrip
    &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
      ENABLE dType &ENDIF
    WITH NO-ROW-MARKERS SEPARATORS 
         &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 3 DOWN WIDTH 75 NO-BOX
         &ELSE 4 DOWN WIDTH 77.6  &ENDIF FIT-LAST-COLUMN.

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no
&Scoped-define frame_name  Dialog-Frame
/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS bSystem fiType edDescrip edDetails btnCreate btnSave btnCancel btnDelete btnDone ~
authenabled  callback 

&Scoped-Define DISPLAYED-OBJECTS fiType edDescrip edDetails authenabled  callback  

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
     LABEL "&Delete" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 11 BY 1
     &ELSE SIZE 11 BY .95 &ENDIF.

DEFINE BUTTON BtnDone 
     LABEL "&Done" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 11 BY 1
     &ELSE SIZE 11 BY .95 &ENDIF
     BGCOLOR 8 .

DEFINE BUTTON BtnHelp DEFAULT 
     LABEL "&Help" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 11 BY 1
     &ELSE SIZE 11 BY .95 &ENDIF
     BGCOLOR 8 .

DEFINE BUTTON btnSave 
     LABEL "&Save" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 11 BY 1
     &ELSE SIZE 11 BY .95 &ENDIF.

DEFINE VARIABLE edDetails AS CHARACTER label "Comments"
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 61 BY 4
     &ELSE SIZE 62.4 BY 2.91 &ENDIF NO-UNDO.

DEFINE VARIABLE fiType AS CHARACTER FORMAT "X(256)":U 
     LABEL "Domain Type" 
     VIEW-AS FILL-IN 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 47 BY 1
     &ELSE SIZE 47 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE edDescrip AS CHARACTER label "Description"
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 61 BY 4
     &ELSE SIZE 62.4 BY 2.91 &ENDIF NO-UNDO.
     
DEFINE VARIABLE authenabled  AS LOGICAL label "Enable Authentication"
     VIEW-AS TOGGLE-BOX NO-UNDO.     

DEFINE VARIABLE callback AS CHARACTER LABEL "Callback" 
     VIEW-AS FILL-IN SIZE &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN 48 
     &ELSE 51 &ENDIF BY 1 NO-UNDO FORMAT "x(100)". 
     
DEFINE BUTTON btnFile LABEL "File..." SIZE 10 BY .95.        
    
/*

DEFINE VARIABLE fiDescrip AS CHARACTER FORMAT "X(256)":U 
     LABEL "Description" 
     VIEW-AS FILL-IN 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 61 BY 1
     &ELSE SIZE 62.4 BY 1 &ENDIF NO-UNDO.
*/
 

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 78 BY 1
     &ELSE SIZE 78 BY 1.43 &ENDIF.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     bSystem
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT 2 SKIP(1)
          &ELSE AT ROW 1.24 COL 1.8 &ENDIF
     fiType
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN COLON 14 SKIP
          &ELSE AT ROW 5.86 COL 14.6 COLON-ALIGNED &ENDIF
     edDescrip
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN COLON 14 SKIP
          &ELSE AT ROW 7 COL 14.6 COLON-ALIGNED &ENDIF
     
     callback
            &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN COLON 14  
            &ELSE AT ROW 10 COL 14.6 COLON-ALIGNED &ENDIF
     
     btnFile
            &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN COLON 64 SKIP 
            &ELSE AT ROW 10 COL 69 SKIP(1)  &ENDIF          
     
     authenabled
         &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN COLON 14 SKIP
         &ELSE AT ROW 11.00 COL 14.6 COLON-ALIGNED SKIP(1) &ENDIF
       
     edDetails 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN  COLON 14  SKIP(1)
          &ELSE AT ROW 12.25 COL 14.6 COLON-ALIGNED  &ENDIF 
          
     BtnDone
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT 2
          &ELSE AT ROW 15.78 COL 2.6 &ENDIF
     btnCreate
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT 23
          &ELSE AT ROW 15.78 COL 17.8 &ENDIF
     btnSave
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT 35
          &ELSE AT ROW 15.78 COL 29.2 &ENDIF
     btnCancel
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT 47
          &ELSE AT ROW 15.78 COL 40.8 &ENDIF
     btnDelete
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT 59
          &ELSE AT ROW 15.78 COL 52.4 &ENDIF
     &IF '{&WINDOW-SYSTEM}' <> 'TTY':U &THEN               
       BtnHelp AT ROW 15.78 COL 67.4 
       RECT-1 AT ROW 15.55 COL 1.6 &ENDIF
     SPACE(0.00) SKIP(0.18)
    WITH &IF '{&WINDOW-SYSTEM}' <> 'TTY':U &THEN  
           VIEW-AS DIALOG-BOX &ENDIF KEEP-TAB-ORDER ROW 2 CENTERED
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Authentication Systems" 
         DEFAULT-BUTTON BtnDone.

&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
  BROWSE bSystem:HELP = KBLABEL("CTRL-A") + "=Create  " + 
                        KBLABEL("DEL")    + "=Delete  " +
                        KBLABEL("GO")     + "=Save/Done".
  fiType:HELP IN FRAME {&FRAME-NAME} = 
                "Enter Domain Type then hit " + KBLABEL("GO") +
                " to Save or " + KBLABEL("CTRL-N") + " to Cancel".
  edDescrip:HELP IN FRAME {&FRAME-NAME} =
                "Enter Description then hit " + KBLABEL("GO") +
                " to Save or " + KBLABEL("CTRL-N") + " to Cancel".
  edDetails:HELP IN FRAME {&FRAME-NAME} =
                "Enter Comments then hit " + KBLABEL("GO") +
                " to Save or " + KBLABEL("CTRL-N") + " to Cancel".
&ENDIF

/*{prodict/sec/sec-trgs.i                 */
/*      &frame_name    =   "Dialog-Frame"}*/
/* moved all sec-trgs.i code here, 'coz we need to do modifications in
"on choose of btnsave" button for inbuild types. */
{prodict/admnhlp.i}

DEFINE VARIABLE giContextId AS INTEGER     NO-UNDO.

ON CHOOSE OF btnCancel IN FRAME {&frame_name} DO:
  RUN cancelRecord.
  IF CAN-DO(THIS-PROCEDURE:INTERNAL-ENTRIES,"localTrig") THEN
     RUN localTrig ( INPUT "Cancel" ).
  IF derr THEN 
  DO:
      RUN setButtonState ( INPUT "ResetMode" ).
      RUN displayRecord.
      
  END.      
END.

ON CHOOSE OF btnCreate IN FRAME {&frame_name} DO:
  RUN newRecord.
  IF RETURN-VALUE = "Retry" THEN
    RETURN NO-APPLY.
  IF RETURN-VALUE = "Fatal" THEN DO:
    RUN cancelRecord.
    RETURN NO-APPLY.
  END.
  IF CAN-DO(THIS-PROCEDURE:INTERNAL-ENTRIES,"localTrig") THEN
    RUN localTrig ( INPUT "Create" ).
END.

ON CHOOSE OF btnDelete IN FRAME {&frame_name} DO:
  RUN deleteRecord.
  
  IF CAN-DO(THIS-PROCEDURE:INTERNAL-ENTRIES,"localTrig") THEN
    RUN localTrig ( INPUT "Delete" ).
END.

ON CHOOSE OF btnSave   IN FRAME {&frame_name} DO:
  DEFINE VARIABLE locStr AS CHARACTER NO-UNDO.
  ASSIGN locStr = "0123456789"
         derr   = NO.
  IF index(locstr,substring(fiType:SCREEN-VALUE,1,1)) > 0 THEN 
  DO:
      MESSAGE "Invalid domain type entered!" SKIP
              "Please enter a correct type for this system."
              VIEW-AS ALERT-BOX ERROR BUTTONS OK.

          APPLY "ENTRY" TO fiType.
          derr = YES.
          RETURN "Retry".
  END.     
  
  IF NOT inbuild THEN  
  DO:
     RUN saveRecord.
     IF callback:SCREEN-VALUE <> "" THEN 
        ASSIGN authenabled:SENSITIVE    = TRUE.
     else
        ASSIGN authenabled:SENSITIVE    = FALSE.   
  END.   
  else
  DO:
      RUN localSave ( INPUT "Before" ).
      IF RETURN-VALUE NE "" THEN
         RETURN RETURN-VALUE.
      Find first DICTDB._sec-authentication-system 
         WHERE DICTDB._sec-authentication-system._domain-type = fiType:SCREEN-VALUE no-error.
      IF AVAILABLE DICTDB._sec-authentication-system THEN 
         ASSIGN DICTDB._sec-authentication-system._PAM-callback-procedure = callback:SCREEN-VALUE.
      FIND FIRST saSys WHERE saSys.dtype = fiType:SCREEN-VALUE NO-ERROR. 
      IF AVAILABLE saSys then
      DO:
         ASSIGN saSys.dCallBack = callback:SCREEN-VALUE.
         ghBuffer   = BUFFER saSys:HANDLE.
         grwLastRowid = ghBuffer:ROWID.
      END.   
      RUN localSave ( INPUT "After" ).
      RUN setButtonState ( INPUT "ResetMode" ).
      RUN setFieldState  ( INPUT "ResetMode" ).
      ASSIGN authenabled:SENSITIVE    = FALSE.      
  END.    
  
  IF RETURN-VALUE = "Retry" THEN
    RETURN NO-APPLY.
  IF RETURN-VALUE = "Fatal" THEN DO:
    RUN cancelRecord.
    RETURN NO-APPLY.
  END.
                  
  IF CAN-DO(THIS-PROCEDURE:INTERNAL-ENTRIES,"localTrig") THEN
    RUN localTrig ( INPUT "Save" ).
  
  APPLY "ENTRY" TO btnDone IN FRAME {&FRAME-NAME}.
END.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  ON CHOOSE OF btnHelp   IN FRAME {&frame_name} OR 
     HELP OF FRAME {&frame_name} DO:
    
    DEFINE VARIABLE cUtility AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cSlash   AS CHARACTER   NO-UNDO.

    cSlash = &IF "{&WINDOW-SYSTEM}" EQ "TTY" &THEN "~\" &ELSE "~/" &ENDIF.

    cUtility = ENTRY(NUM-ENTRIES(THIS-PROCEDURE:FILE-NAME,cSlash),
                     THIS-PROCEDURE:FILE-NAME,
                     cSlash).

    CASE cUtility:
      WHEN "_sec-perm.p" THEN
        giContextId = {&Edit_Audit_Permissions_Dialog_Box}.
      WHEN "_sec-sys.p" THEN
        giContextId = {&Authentication_Systems_Dialog_Box}.
      WHEN "_sec-dom.p" THEN
        giContextId = {&Domains_Dialog_Box}.
      OTHERWISE
        giContextId = 0.
    END CASE.

    IF giContextId > 0 THEN
      RUN adecomm/_adehelp.p ( INPUT "admn", 
                               INPUT "CONTEXT", 
                               INPUT giContextId,
                               INPUT ? ).
    ELSE
      MESSAGE "Help for File: {&FILE-NAME}" 
          VIEW-AS ALERT-BOX INFORMATION.
  END.
&ENDIF
  
ON CHOOSE OF btnDone   IN FRAME {&frame_name} DO:
  IF CAN-DO(THIS-PROCEDURE:INTERNAL-ENTRIES,"localTrig") THEN
    RUN localTrig ( INPUT "Done" ).
    
  APPLY "WINDOW-CLOSE" TO FRAME {&frame_name}.
END.

/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

ASSIGN FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* ************************  Functions  ************************ */

function isReadOnly returns logical(phBuffer as handle):
     return phBuffer:avail and phBuffer::dType begins "_". 
end function.    

/* ************************  Control Triggers  ************************ */

ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Authentication Systems */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

ON CHOOSE OF BtnDone IN FRAME Dialog-Frame /* Done */
DO:
  APPLY "GO":U TO FRAME {&FRAME-NAME}.
END.

ON VALUE-CHANGED OF BROWSE bSystem DO:

  RUN displayRecord.
  IF ronly THEN DO:
      RUN setFieldState  ( INPUT "DisableMode" ).
      RUN setButtonState ( INPUT "DisableMode" ).
  END.
  ELSE DO:
      RUN setFieldState  ( INPUT "ResetMode" ).
      RUN setButtonState ( INPUT "ResetMode" ).
  END.
  
END.

ON GO OF FRAME {&FRAME-NAME} DO:
  IF btnSave:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
    APPLY "CHOOSE" TO btnSave.
    RETURN NO-APPLY.
  END.
  ELSE APPLY "CHOOSE" TO btnDone IN FRAME {&FRAME-NAME}.
END.

ON VALUE-CHANGED OF edDescrip IN FRAME {&FRAME-NAME} DO:
  IF glCreateMode THEN LEAVE.
  
  IF AVAILABLE saSys AND
     saSys.dDescrip NE SELF:SCREEN-VALUE THEN DO:
    RUN setButtonState ( INPUT "UpdateMode" ).
    BROWSE bSystem:SENSITIVE = FALSE.
    IF NOT CAN-DO(gcMods,SELF:NAME) THEN
      gcMods = gcMods + (IF gcMods NE "" THEN "," ELSE "") +
               SELF:NAME.
  END.
  ELSE DO:
    gcMods = REPLACE(REPLACE(gcMods,SELF:NAME,""),",,",",").
    IF gcMods EQ "" OR
       gcMods EQ "," THEN DO:
      BROWSE bSystem:SENSITIVE = TRUE.
      gcMods = "".
      RUN setButtonState ( "ResetMode" ).
    END.
  END.
END.  
ON VALUE-CHANGED OF authenabled IN FRAME {&FRAME-NAME} DO:
   IF AVAILABLE saSys AND
     saSys.dauthenabled NE LOGICAL(SELF:SCREEN-VALUE) THEN DO:
    RUN setButtonState ( INPUT "UpdateMode" ).
    BROWSE bSystem:SENSITIVE = FALSE.
    IF NOT CAN-DO(gcMods,SELF:NAME) THEN
      gcMods = gcMods + (IF gcMods NE "" THEN "," ELSE "") +
               SELF:NAME.
  END.
  ELSE DO:
    gcMods = REPLACE(REPLACE(gcMods,SELF:NAME,""),",,",",").
    IF gcMods EQ "" OR
       gcMods EQ "," THEN DO:
      BROWSE bSystem:SENSITIVE = TRUE.
      gcMods = "".
      RUN setButtonState ( "ResetMode" ).
    END.
  END.
      
END.  
ON VALUE-CHANGED OF callback IN FRAME {&FRAME-NAME} DO:
  IF AVAILABLE saSys AND
     saSys.dcallback NE SELF:SCREEN-VALUE THEN DO:
     RUN setButtonState ( INPUT "UpdateMode" ).
    BROWSE bSystem:SENSITIVE = FALSE.
    IF NOT CAN-DO(gcMods,SELF:NAME) THEN
      gcMods = gcMods + (IF gcMods NE "" THEN "," ELSE "") +
               SELF:NAME.

  END.
  ELSE DO:
     
    gcMods = REPLACE(REPLACE(gcMods,SELF:NAME,""),",,",",").
    IF gcMods EQ "" OR
       gcMods EQ "," THEN DO:
      BROWSE bSystem:SENSITIVE = TRUE.
      gcMods = "".
      RUN setButtonState ( "ResetMode" ).
    END.
  END.
  
  IF NOT inbuild THEN 
  DO: 
     IF TRIM(callback:SCREEN-VALUE) <> "" THEN
       ASSIGN authenabled:SENSITIVE    = TRUE
              authenabled:SCREEN-VALUE = "yes".
     ELSE
       ASSIGN authenabled:SENSITIVE    = FALSE
              authenabled:SCREEN-VALUE = "no".     
  END.
END.     

ON LEAVE OF callback IN FRAME {&FRAME-NAME} DO:
    IF glCreateMode THEN LEAVE.
    
    IF AVAILABLE saSys AND
       saSys.dcallback NE SELF:SCREEN-VALUE THEN DO:
       RUN setButtonState ( INPUT "UpdateMode" ).
      BROWSE bSystem:SENSITIVE = FALSE.
      IF NOT CAN-DO(gcMods,SELF:NAME) THEN  
        gcMods = gcMods + (IF gcMods NE "" THEN "," ELSE "") +
                 SELF:NAME.
    END.
    ELSE 
    DO:
        gcMods = REPLACE(REPLACE(gcMods,SELF:NAME,""),",,",",").
        IF gcMods EQ "" OR
           gcMods EQ "," THEN 
        DO:
           BROWSE bSystem:SENSITIVE = TRUE.
           gcMods = "".
           RUN setButtonState ( "ResetMode" ).
        END.
    END.
END.  
  
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  ON START-SEARCH OF BROWSE bSystem DO:
    DEFINE VARIABLE cCol AS CHARACTER   NO-UNDO.

    cCol = SELF:CURRENT-COLUMN:NAME.
    self:clear-sort-arrows().
    cCol = SELF:CURRENT-COLUMN:NAME.
    IF gcSort EQ cCol THEN
    do:
       SELF:CURRENT-COLUMN:sort-ascending = false.
       gcSort = cCol + " DESC".
    end.
    ELSE do:
       SELF:CURRENT-COLUMN:sort-ascending = true. 
       gcSort = cCol.
    end.
     
    RUN openQuery.
    APPLY "END-SEARCH" TO SELF.
  END.
  
  ON VALUE-CHANGED OF edDetails IN FRAME {&FRAME-NAME} DO:
    IF glCreateMode THEN LEAVE.
    
    IF AVAILABLE saSys AND
       saSys.dDetails NE SELF:SCREEN-VALUE THEN DO:
      RUN setButtonState ( INPUT "UpdateMode" ).
      BROWSE bSystem:SENSITIVE = FALSE.
      IF NOT CAN-DO(gcMods,SELF:NAME) THEN 
        gcMods = gcMods + (IF gcMods NE "" THEN "," ELSE "") +
                 SELF:NAME.
    END.
    ELSE DO:
      gcMods = REPLACE(REPLACE(gcMods,SELF:NAME,""),",,",",").
      IF gcMods EQ "" OR 
         gcMods EQ "," THEN DO:
        BROWSE bSystem:SENSITIVE = TRUE.
        gcMods = "".
        RUN setButtonState ( "ResetMode" ).
      END.  
    END.
       
  END.
  
&ELSE

  ON ENTRY OF BROWSE bSystem DO:
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
         BROWSE bSystem:HANDLE  THEN DO:
      APPLY "ENTRY" TO btnCreate IN FRAME {&FRAME-NAME}.
      RETURN NO-APPLY.
    END.
  END.

  ON ENTRY OF btnCreate DO:
    IF LAST-EVENT:WIDGET-LEAVE =
        btnDone:HANDLE IN FRAME {&FRAME-NAME} THEN DO:
      APPLY "ENTRY" TO BROWSE bSystem.
      RETURN NO-APPLY.
    END.
  END.
                  
  ON CTRL-A ANYWHERE DO:
    IF btnCreate:SENSITIVE IN FRAME {&FRAME-NAME} OR
       (FOCUS = edDetails:HANDLE IN FRAME {&FRAME-NAME} AND
        gcMods EQ "") THEN
      APPLY "CHOOSE" TO btnCreate IN FRAME {&FRAME-NAME}.
    ELSE RETURN NO-APPLY.
  END.
                                 
  ON DEL OF BROWSE bSystem DO:
    IF AVAILABLE saSys THEN
      APPLY "CHOOSE" TO btnDelete IN FRAME {&FRAME-NAME}.
  END.

  ON CTRL-N ANYWHERE DO:
    IF btnCancel:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
      IF FOCUS EQ edDetails:HANDLE IN FRAME {&FRAME-NAME} THEN DO:
        IF gcMods NE "" THEN
          APPLY "CHOOSE" TO btnCancel IN FRAME {&FRAME-NAME}.
        ELSE RETURN NO-APPLY.
      END.
      ELSE APPLY "CHOOSE" TO btnCancel IN FRAME {&FRAME-NAME}.
    END.
    ELSE RETURN NO-APPLY.
  END.
                              
  ON ENTRY OF edDetails IN FRAME {&FRAME-NAME} DO:
    IF glCreateMode THEN LEAVE.
    
    RUN setButtonState ( INPUT "UpdateMode" ).
    BROWSE bSystem:SENSITIVE = FALSE.
  END.

  ON LEAVE OF edDetails IN FRAME {&FRAME-NAME} DO:
    IF glCreateMode THEN LEAVE.
    
    IF AVAILABLE saSys AND
       saSys.dDetails NE SELF:SCREEN-VALUE THEN DO:
       RUN setButtonState ( INPUT "UpdateMode" ).
      BROWSE bSystem:SENSITIVE = FALSE.
      IF NOT CAN-DO(gcMods,SELF:NAME) THEN  
        gcMods = gcMods + (IF gcMods NE "" THEN "," ELSE "") +
                 SELF:NAME.
    END.
    ELSE DO:
  
      gcMods = REPLACE(REPLACE(gcMods,SELF:NAME,""),",,",",").
      IF gcMods EQ "" OR
         gcMods EQ "," THEN DO:
        BROWSE bSystem:SENSITIVE = TRUE.
        gcMods = "".
        RUN setButtonState ( "ResetMode" ).
      END.
    END.
  END.
  
  ON ENTRY OF btnDelete IN FRAME {&FRAME-NAME} DO:
    IF LAST-EVENT:WIDGET-LEAVE = 
            edDetails:HANDLE IN FRAME {&FRAME-NAME} THEN DO:
      APPLY "ENTRY" TO btnCreate.
      RETURN NO-APPLY.
    END.
  END.

&ENDIF

/*----- HIT of FILE BUTTON -----*/
ON CHOOSE OF btnFile in frame {&FRAME-NAME} DO:
  DEFINE VARIABLE picked_ok AS logical NO-UNDO.
  DEFINE VARIABLE fname AS CHARACTER NO-UNDO.
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
    SYSTEM-DIALOG GET-FILE callback
       TITLE    "Find File" 
       FILTERS  "*.p"   "*.p",
                "*.*" "*.*"
       MUST-EXIST
       UPDATE   picked_ok.
       
    fname = callback.
  &ELSE  
    fname = callback:SCREEN-VALUE.
    RUN adecomm/_filecom.p ( INPUT "*.*", /* p_Filter */
                           INPUT "", /* p_Dir */
                           INPUT "", /* p_Drive */
                           INPUT NO, /* p_Save_As */
                           INPUT "Find File",
                           INPUT "MUST-EXIST",
                           INPUT-OUTPUT fname,
                           OUTPUT picked_ok ).
                              
  &ENDIF 
  IF picked_ok THEN
    DO: 
       callback:SCREEN-VALUE = fname.
       APPLY "VALUE-CHANGED" TO callback IN FRAME {&FRAME-NAME}.
    END.         
END.

ON END-ERROR ANYWHERE DO:
  IF btnCancel:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
    APPLY "CHOOSE" TO btnCancel.
    APPLY "ENTRY" TO SELF.
    RETURN NO-APPLY.
  END.
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
           btnHelp RECT-1
         &ENDIF
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

PROCEDURE initializeUI :
/*------------------------------------------------------------------------------
  Purpose:     Initialization of the User Interface, and global variables
  Parameters:  <none>
  Notes:   
------------------------------------------------------------------------------*/
  ghBuffer   = BUFFER saSys:HANDLE.
  gcFileName = "Domains" /* "Security Authentication Systems" */ .

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN gcFieldHandles      = STRING(fiType:HANDLE)  + "," + "&1," +
                                 STRING(edDescrip:HANDLE)  + "," + "&2," +
                                 STRING(edDetails:HANDLE)  + "," + "&3," +
                                 STRING(authenabled:HANDLE)  + "," + "&4," +
                                 STRING(callback:HANDLE)  + "," + "&5"
           gcFieldInits        = SUBSTITUTE(gcFieldHandles,
                                            CHR(1) + "",
                                            CHR(1) + "",
                                            CHR(1) + "",
                                            CHR(1) + "",
                                            CHR(1) + "")
           gcFieldInits        = REPLACE(gcFieldInits,"," + CHR(1),CHR(1))
           gcCreateModeFields  = SUBSTITUTE(gcFieldHandles,
                                            "yes",
                                            "yes",
                                            "yes",
                                            "yes",
                                            "yes")
           gcResetModeFields   = SUBSTITUTE(gcFieldHandles,
                                            "no",
                                            "yes",
                                            "yes",
                                            "no",
                                            "no")
           gcDisableModeFields = SUBSTITUTE(gcFieldHandles,
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
           gcDBFields          = "_domain-type,_domain-type-description," +
                                 "_custom-detail,_PAM-plug-in,_PAM-callback-procedure"
           gcTTFields          = "dType,dDescrip,dDetails,dAuthEnabled,dCallback"
           ghFrame             = FRAME {&FRAME-NAME}:HANDLE
           gcKeyField          = "_domain-type,dType,CHAR"
           gcDBBuffer          = "DICTDB._sec-authentication-system".
  END.

  RUN loadSystems.
      
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
    saSys.dType:READ-ONLY IN BROWSE bSystem = TRUE.
  &ENDIF

  FRAME {&FRAME-NAME}:TITLE = FRAME {&FRAME-NAME}:TITLE + " (" +
                              LDBNAME("DICTDB") + ")".

  IF ronly THEN DO:
      RUN setButtonState ( INPUT "DisableMode" ).
      RUN setFieldState  ( INPUT "DisableMode" ).
      btnFile:SENSITIVE = FALSE.
  END.
  ELSE DO:
      RUN setButtonState ( INPUT "ResetMode" ).
      RUN setFieldState  ( INPUT "ResetMode" ).
      btnFile:SENSITIVE = FALSE.
  END.
  RUN openQuery.

  APPLY "ENTRY" TO BROWSE bSystem.
  APPLY "VALUE-CHANGED" TO BROWSE bSystem.
END PROCEDURE.

PROCEDURE loadSystems:
  DEFINE VARIABLE hSASys AS HANDLE      NO-UNDO.
  DEFINE VARIABLE hQuery AS HANDLE      NO-UNDO.

  CREATE BUFFER hSASys FOR TABLE "DICTDB._sec-authentication-system".
  CREATE QUERY hQuery.

  hQuery:SET-BUFFERS(hSASys).
  hQuery:QUERY-PREPARE("FOR EACH _sec-authentication-system NO-LOCK").
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST().

  DO WHILE NOT hQuery:QUERY-OFF-END:
    DO TRANSACTION ON ERROR UNDO, NEXT:
      CREATE saSys.
      ASSIGN dType        = hSASys::_domain-type
             dDescrip     = hSASys::_domain-type-description
             dDetails     = hSASys::_custom-detail
             dAuthEnabled = hSASys::_PAM-plug-in
             dCallBack    = hSASys::_PAM-callback-procedure.
    END.
    hQuery:GET-NEXT().
  END.

  DELETE OBJECT hSASys.
  DELETE OBJECT hQuery.
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
  DEFINE VARIABLE lChildren AS LOGICAL     NO-UNDO.

  DEFINE VARIABLE hDom      AS HANDLE      NO-UNDO.

  CASE pcTxnLoc:
    WHEN "Before" THEN DO 
        WITH FRAME {&FRAME-NAME}:
      CREATE BUFFER hDom FOR TABLE "DICTDB._sec-authentication-domain".
      hDom:FIND-FIRST("WHERE _domain-type = ~'" + fiType:SCREEN-VALUE +
                      "~'",NO-LOCK) NO-ERROR.
      lChildren = hDom:AVAILABLE.
      IF lChildren THEN DO:
        MESSAGE "There are Domains defined against this System. you must " +
                "delete all dependant Domains before deleting a System!"
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN "Cancel".
      END.

      MESSAGE "Are you sure you want to delete this system?"
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lDelete.
      IF NOT lDelete THEN RETURN "Cancel".

      RUN setRowidForDelete (INPUT QUERY qSystem:PREPARE-STRING ).
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

  DEFINE VARIABLE hAuthSys AS HANDLE NO-UNDO.
  DEFINE VARIABLE ans      AS LOGICAL NO-UNDO.
  DEFINE VARIABLE err      AS LOGICAL NO-UNDO.
        
  CASE pcTxnLoc:
    WHEN "Before" THEN DO WITH FRAME {&FRAME-NAME}:
      IF fiType:SCREEN-VALUE EQ "" OR
         fiType:SCREEN-VALUE EQ ? THEN DO:
        MESSAGE "You must enter a domain type for this system."
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        APPLY "ENTRY" TO fiType.
        RETURN "Retry".
      END.
      IF glCreateMode THEN DO:
        CREATE BUFFER hAuthSys FOR TABLE "DICTDB._sec-authentication-system".
        hAuthSys:FIND-FIRST("WHERE _domain-type = ~"" +
                            fiType:SCREEN-VALUE + "~"",NO-LOCK) NO-ERROR.
        IF hAuthSys:AVAILABLE THEN DO:
          MESSAGE "A system already exists of this type!" SKIP(1)
                  "Please enter a unique domain type for this system."
              VIEW-AS ALERT-BOX ERROR BUTTONS OK.

          APPLY "ENTRY" TO fiType.
          RETURN "Retry".
        END.
      END. /* If glCreateMode */
            
      IF AVAILABLE saSys AND saSys.dcallback NE callback:SCREEN-VALUE THEN
      DO:
           IF SEARCH(callback:SCREEN-VALUE) = ? THEN
             err = yes.
           else
             err = NO.
      END.    
      ELSE IF NOT AVAILABLE saSys AND SEARCH(callback:SCREEN-VALUE) = ? THEN
      err = YES.
     
      IF TRIM(callback:SCREEN-VALUE) = "" THEN 
         ASSIGN err = NO.
        
      IF err THEN 
      DO:
           MESSAGE "The " + callback:SCREEN-VALUE + 
                   " file does not exist." Skip 
                   "Confirm that you want to save this as the callback procedure?"
           VIEW-AS ALERT-BOX QUESTION BUTTON YES-NO UPDATE ans.
           IF NOT ans THEN
           DO:
               APPLY "ENTRY" TO callback.
               RETURN "Retry". 
           END.
      END.       
      IF INDEX(callback:SCREEN-VALUE,".cls") > 0 THEN 
      DO:
          MESSAGE "Classes are currently not supported as callback." skip 
                  "Confirm that you want to save this as the callback procedure?"
           VIEW-AS ALERT-BOX QUESTION BUTTON YES-NO UPDATE ans.
           IF NOT ans THEN
           DO:
               APPLY "ENTRY" TO callback.
               RETURN "Retry". 
           END.
      END.    
      RETURN "".           
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
      APPLY "ENTRY" TO fiType IN FRAME {&FRAME-NAME}.
      BROWSE bSystem:SENSITIVE = FALSE.
      RETURN "".
    END.
    WHEN "Save" THEN DO:
      BROWSE bSystem:SENSITIVE = TRUE.
      RETURN "".
    END.
    WHEN "Cancel" THEN DO:
      BROWSE bSystem:SENSITIVE = TRUE.
      RETURN "".
    END.
  END CASE.
END PROCEDURE.

procedure localFieldState:
/*------------------------------------------------------------------------------
        Purpose:                                                                      
        Notes:                                                                        
------------------------------------------------------------------------------*/
  define input  parameter pcMode as character no-undo.
  define variable lok as logical no-undo.
  
  if pcMode = "CreateMode":u then 
  do with frame {&frame-name}:
      /* use read-only for editors */
      assign
          edDescrip:read-only = false 
          edDetails:read-only = FALSE
          btnFile:SENSITIVE = TRUE
          authenabled:SCREEN-VALUE = "no"
          authenabled:SENSITIVE = FALSE
          inbuild               = no.     
  end.
  else if pcMode = "ResetMode":u then 
  do:
      /* don't enable fields for built-ins - category = 0 user defined
         (finame is always disabled in edit mode   
          tbEnabled is defined as "iab" and handled in ui-procs.i */
      if ghbuffer:avail 
      and not isReadOnly(ghBuffer) then
      do with frame {&frame-name}:
            /* use read-only for editors */
           
          assign
              edDescrip:read-only = false 
              edDetails:read-only = false
              inbuild               = no.  
          IF callback:SCREEN-VALUE = "" THEN 
             authenabled:SENSITIVE = FALSE.
          ELSE 
             authenabled:SENSITIVE = TRUE.                  
      end.     
      
      else do:
            /* use read-only for editors */
           
          assign
              edDescrip:read-only = true 
              edDetails:read-only = true
              authenabled:SENSITIVE = false
              inbuild               = yes.         
      end. 
      ASSIGN btnFile:SENSITIVE     = TRUE 
             callback:SENSITIVE    = TRUE.
             
  end.
end procedure.


PROCEDURE openQuery:
  DEFINE VARIABLE hQuery AS HANDLE      NO-UNDO.
  
  /* This is a static query but we prepare it like a dynamic query so
     that we can get the PREPARE-STRING later on for repositioning */
  hQuery = QUERY qSystem:HANDLE.
  hQuery:QUERY-PREPARE("FOR EACH saSys BY " + gcSort).
  hQuery:QUERY-OPEN().

  IF grwLastRowid NE ? THEN
    REPOSITION qSystem TO ROWID grwLastRowid NO-ERROR.
  
  /* This fires off the display of the ui fields */
  APPLY "VALUE-CHANGED" TO BROWSE bSystem.
    
  RETURN "".
END PROCEDURE.

