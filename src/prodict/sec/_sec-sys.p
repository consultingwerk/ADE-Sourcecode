&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
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

DEFINE TEMP-TABLE saSys NO-UNDO RCODE-INFORMATION
    FIELD dType     AS CHARACTER LABEL "Domain Type"        FORMAT "x(25)"
    FIELD dDescrip  AS CHARACTER LABEL "Description"        FORMAT "x(65)"
    FIELD dDetails  AS CHARACTER LABEL "Comments" FORMAT "x(200)"
    INDEX idxSystem AS PRIMARY UNIQUE dType.

DEFINE QUERY qSystem FOR saSys SCROLLING.

DEFINE BROWSE bSystem QUERY qSystem
    DISPLAY dType
            dDescrip
    &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
      ENABLE dType &ENDIF
    WITH NO-ROW-MARKERS SEPARATORS 
         &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 3 DOWN WIDTH 75 NO-BOX
         &ELSE SIZE 77.6 BY 4.29 &ENDIF FIT-LAST-COLUMN.

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS bSystem fiType fiDescrip edDetails btnCreate btnSave btnCancel btnDelete btnDone

&Scoped-Define DISPLAYED-OBJECTS fiType fiDescrip edDetails lbldDetails 

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

DEFINE VARIABLE edDetails AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 61 BY 4
     &ELSE SIZE 62.4 BY 2.91 &ENDIF NO-UNDO.

DEFINE VARIABLE fiType AS CHARACTER FORMAT "X(256)":U 
     LABEL "Domain Type" 
     VIEW-AS FILL-IN 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 47 BY 1
     &ELSE SIZE 47 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE fiDescrip AS CHARACTER FORMAT "X(256)":U 
     LABEL "Description" 
     VIEW-AS FILL-IN 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 61 BY 1
     &ELSE SIZE 62.4 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE lbldDetails AS CHARACTER FORMAT "X(256)":U 
      INITIAL "Comments:" 
      VIEW-AS TEXT 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 9 BY 1
     &ELSE SIZE 10.6 BY .62 &ENDIF NO-UNDO.

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
     fiDescrip
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN COLON 14 SKIP
          &ELSE AT ROW 7 COL 14.6 COLON-ALIGNED &ENDIF
     lbldDetails
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT 6 
          &ELSE AT ROW 8.14 COL 3.4 COLON-ALIGNED &ENDIF NO-LABEL
     edDetails NO-LABEL
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT 15 SKIP(1)
          &ELSE AT ROW 8.14 COL 16.6 &ENDIF 
     BtnDone
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT 2
          &ELSE AT ROW 12.48 COL 2.6 &ENDIF
     btnCreate
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT 23
          &ELSE AT ROW 12.48 COL 17.8 &ENDIF
     btnSave
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT 35
          &ELSE AT ROW 12.48 COL 29.2 &ENDIF
     btnCancel
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT 47
          &ELSE AT ROW 12.48 COL 40.8 &ENDIF
     btnDelete
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT 59
          &ELSE AT ROW 12.48 COL 52.4 &ENDIF
     &IF '{&WINDOW-SYSTEM}' <> 'TTY':U &THEN               
       BtnHelp AT ROW 12.48 COL 67.4 
       RECT-1 AT ROW 12.25 COL 1.6 &ENDIF
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
  fiDescrip:HELP IN FRAME {&FRAME-NAME} =
                "Enter Description then hit " + KBLABEL("GO") +
                " to Save or " + KBLABEL("CTRL-N") + " to Cancel".
  edDetails:HELP IN FRAME {&FRAME-NAME} =
                "Enter Comments then hit " + KBLABEL("GO") +
                " to Save or " + KBLABEL("CTRL-N") + " to Cancel".
&ENDIF

{prodict/sec/sec-trgs.i
      &frame_name    =   "Dialog-Frame"}

/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

ASSIGN FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

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
      RUN setFieldState  ( INPUT "DisableMode" ).
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

ON VALUE-CHANGED OF fiDescrip IN FRAME {&FRAME-NAME} DO:
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
  
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  ON START-SEARCH OF BROWSE bSystem DO:
    DEFINE VARIABLE cCol AS CHARACTER   NO-UNDO.

    cCol = SELF:CURRENT-COLUMN:NAME.
    IF gcSort EQ cCol THEN
      gcSort = cCol + " DESC".
    ELSE gcSort = cCol.

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
  gcFileName = "Security Authentication Systems".

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN gcFieldHandles      = STRING(fiType:HANDLE)  + "," + "&1," +
                                 STRING(fiDescrip:HANDLE)  + "," + "&2," +
                                 STRING(edDetails:HANDLE)  + "," + "&3"
           gcFieldInits        = SUBSTITUTE(gcFieldHandles,
                                            CHR(1) + "",
                                            CHR(1) + "",
                                            CHR(1) + "")
           gcFieldInits        = REPLACE(gcFieldInits,"," + CHR(1),CHR(1))
           gcCreateModeFields  = SUBSTITUTE(gcFieldHandles,
                                            "yes",
                                            "yes",
                                            "yes")
           gcResetModeFields   = SUBSTITUTE(gcFieldHandles,
                                            "no",
                                            "iab",
                                            "iab")
           gcDisableModeFields = SUBSTITUTE(gcFieldHandles,
                                            "no",
                                            "no",
                                            "no")
           gcFieldHandles      = REPLACE(gcFieldHandles,",&1","")
           gcFieldHandles      = REPLACE(gcFieldHandles,",&2","")
           gcFieldHandles      = REPLACE(gcFieldHandles,",&3","")
           gcDBFields          = "_domain-type,_domain-type-description," +
                                 "_custom-detail"
           gcTTFields          = "dType,dDescrip,dDetails"
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
  END.
  ELSE DO:
      RUN setButtonState ( INPUT "ResetMode" ).
      RUN setFieldState  ( INPUT "ResetMode" ).
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
      ASSIGN dType     = hSASys::_domain-type
             dDescrip  = hSASys::_domain-type-description
             dDetails  = hSASys::_custom-detail.
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
    END. /* When Before */
    WHEN "End" THEN DO:
      IF glCreateMode THEN
        RETURN "INITIALS|_PAM-plug-in=FALSE".
    END.
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

