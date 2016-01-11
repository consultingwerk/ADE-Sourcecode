&Scoped-define WINDOW-NAME CURRENT-WINDOW
/*------------------------------------------------------------------------
/*************************************************************/  
/* Copyright (c) 1984-2007,2009 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/

  File: prodict/misc/_db-optn.p

  Description: Dialog for modifying Progress owned _db-option fields.

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Kenneth S. McIntosh

  Created: April 19, 2005

  History: 
    kmcintos May 26, 2005  Renamed options and option-types for changes made 
                           by db group bug # 20050525-025.
    kmcintos June 7, 2005  Added context sensitive help for dialog and removed
                           appbuilder friendly code.
    kmcintos Aug 31, 2005  Added DB Option for _pvm.enforceauditinsert.
    kmcintos Sep  8, 2005  Ensure that option which don't exist and haven't
                           been modified don't get enabled or assigned
                           20050908-026.
    kmcintos Oct 21, 2005  Installed workaround for bug # 20050920-031 in 
                           order to complete fix for 20050908-026.  
                           20050921-017.
    fernando 11/30/07      Check if read-only mode.
    fernando 07/20/09      look at correct _db record
                            
------------------------------------------------------------------------*/
/*          This .p file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

{prodict/misc/misc-funcs.i}
{prodict/admnhlp.i}

/* ***************************  Definitions  ************************** */

IF NOT dbAdmin(USERID("DICTDB")) THEN DO:
  MESSAGE "You do not have permission to run this tool!"
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN "No Permission".
END.

IF checkReadOnly("DICTDB","_Db-option") NE "" THEN
   RETURN "No Permission".

CREATE WIDGET-POOL.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE        VARIABLE glAppUser     AS LOGICAL     NO-UNDO.
DEFINE        VARIABLE glAudInsrt    AS LOGICAL     NO-UNDO.
DEFINE        VARIABLE glTrustDomain AS LOGICAL     NO-UNDO.
DEFINE        VARIABLE glRecord      AS LOGICAL     NO-UNDO.
DEFINE        VARIABLE glNoBlank     AS LOGICAL     NO-UNDO.
DEFINE        VARIABLE glRuntime     AS LOGICAL     NO-UNDO.

DEFINE SHARED VARIABLE drec_db       AS RECID       NO-UNDO.

/* ********************  Preprocessor Definitions  ******************** */

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbAppUser tbAudInsrt tbTrustDomain tbNoBlank tbRecord tbRuntime btnOk btnCancel txtAuditing txtSecurity 
&Scoped-Define DISPLAYED-OBJECTS tbAppUser tbAudInsrt tbTrustDomain tbRecord tbNoBlank tbRuntime txtAuditing txtSecurity 

/* ***********************  Control Definitions  ********************** */

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnCancel AUTO-END-KEY 
     LABEL "Cancel" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 11 BY 1
     &ELSE SIZE 11 BY .95 &ENDIF
     BGCOLOR 8 .

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
  DEFINE BUTTON btnHelp 
     LABEL "&Help" 
     SIZE 11 BY .95
     BGCOLOR 8.

  DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 62 BY 1.29. &ENDIF

DEFINE BUTTON btnOk 
     LABEL "OK" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 11 BY 1
     &ELSE SIZE 11 BY .95 &ENDIF
     BGCOLOR 8 .

DEFINE VARIABLE txtAuditing AS CHARACTER FORMAT "X(256)":U 
      INITIAL "Auditing Options:" 
      VIEW-AS TEXT 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 23 BY 1
     &ELSE SIZE 23 BY .62 &ENDIF
     FONT 6 NO-UNDO.

DEFINE VARIABLE txtSecurity AS CHARACTER FORMAT "X(256)":U 
      INITIAL "Security Options:" 
      VIEW-AS TEXT 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 23 BY 1
     &ELSE SIZE 23 BY .62 &ENDIF
     FONT 6 NO-UNDO.

DEFINE VARIABLE tbAppUser AS LOGICAL INITIAL no 
     LABEL "Use Application User Id for Auditing" 
     VIEW-AS TOGGLE-BOX
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 44 BY 1
     &ELSE SIZE 44 BY .81 &ENDIF NO-UNDO.

DEFINE VARIABLE tbAudInsrt AS LOGICAL INITIAL no
     LABEL "Enforce Audit Insert Privilege"
     VIEW-AS TOGGLE-BOX
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 44 BY 1
     &ELSE SIZE 44 BY .81 &ENDIF NO-UNDO.
                    
DEFINE VARIABLE tbNoBlank AS LOGICAL INITIAL no 
     LABEL "Disallow Blank UserId" 
     VIEW-AS TOGGLE-BOX
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 41 BY 1
     &ELSE SIZE 41 BY .81 &ENDIF NO-UNDO.

DEFINE VARIABLE tbRecord AS LOGICAL INITIAL no 
     LABEL "Record Authenticated Client Sessions" 
     VIEW-AS TOGGLE-BOX
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 41 BY 1
     &ELSE SIZE 40.8 BY .81 &ENDIF NO-UNDO.

DEFINE VARIABLE tbRuntime AS LOGICAL INITIAL no 
     LABEL "Use Runtime Permissions Checking" 
     VIEW-AS TOGGLE-BOX
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 41 BY 1
     &ELSE SIZE 41 BY .81 &ENDIF NO-UNDO.

DEFINE VARIABLE tbTrustDomain AS LOGICAL INITIAL no 
     LABEL "Trust Application Domain Registry" 
     VIEW-AS TOGGLE-BOX
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 41 BY 1
     &ELSE SIZE 40.8 BY .81 &ENDIF NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     tbAppUser
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 3 COL 7
          &ELSE AT ROW 2.52 COL 7.2 &ENDIF
     tbAudInsrt
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 4 COL 7
          &ELSE AT ROW 3.38 COL 7.2 &ENDIF
     tbTrustDomain
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 7 COL 7
          &ELSE AT ROW 6.52 COL 7.2 &ENDIF
     tbRecord
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 8 COL 7
          &ELSE AT ROW 7.38 COL 7.2 &ENDIF 
     tbNoBlank
         &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 9 COL 7
         &ELSE AT ROW 8.24 COL 7.2 &ENDIF
     tbRuntime
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 10 COL 7
          &ELSE AT ROW 9.05 COL 7.2 &ENDIF
     btnOk
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 13 COL 18
          &ELSE AT ROW 12 COL 3 &ENDIF
     btnCancel
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 13 COL 30
          &ELSE AT ROW 12 COL 15 &ENDIF
     &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
       btnHelp AT ROW 12 COL 51.8 &ENDIF
     txtAuditing
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 2 COL 2 COLON-ALIGNED
          &ELSE AT ROW 1.71 COL 2 COLON-ALIGNED &ENDIF NO-LABEL
     txtSecurity
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 6 COL 2 COLON-ALIGNED
          &ELSE AT ROW 5.81 COL 2 COLON-ALIGNED &ENDIF NO-LABEL
     &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
       RECT-1 AT ROW 11.81 COL 2 &ENDIF
     SPACE(1.19) SKIP(0.18)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
           ROW 2
         &ENDIF
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE CENTERED
         TITLE "Database Options"
         CANCEL-BUTTON btnCancel.

/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

ASSIGN FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

DO WITH FRAME {&FRAME-NAME}:
  ASSIGN tbAppUser:PRIVATE-DATA     = "_pvm.useAppUserID|1"
         tbAudInsrt:PRIVATE-DATA    = "_pvm.enforceauditinsert|1"
         tbNoBlank:PRIVATE-DATA     = "_pvm.noBlankUser|2"
         tbRecord:PRIVATE-DATA      = "_pvm.recordSessions|2"
         tbRuntime:PRIVATE-DATA     = "_pvm.RuntimePermissions|2" 
         tbTrustDomain:PRIVATE-DATA = "_pvm.useAppRegistry|2".
END. /* Do With Frame {&Frame-Name} */

/* ************************  Control Triggers  ************************ */
ON WINDOW-CLOSE OF FRAME Dialog-Frame 
  APPLY "END-ERROR":U TO SELF.

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
  ON CHOOSE OF btnHelp IN FRAME {&FRAME-NAME} OR 
     HELP OF FRAME {&FRAME-NAME}
    RUN adecomm/_adehelp.p ( INPUT "admn", 
                             INPUT "CONTEXT", 
                             INPUT {&Database_Options_Dialog_Box},
                             INPUT ? ).
&ENDIF

ON CHOOSE OF btnOk IN FRAME {&FRAME-NAME}
  APPLY "GO" TO FRAME {&FRAME-NAME}.

ON GO OF FRAME {&FRAME-NAME}
  RUN saveOptions.

ON VALUE-CHANGED OF tbAppUser IN FRAME {&FRAME-NAME} 
  SELF:MODIFIED = (SELF:CHECKED NE glAppUser).

ON VALUE-CHANGED OF tbAudInsrt IN FRAME {&FRAME-NAME}
  SELF:MODIFIED = (SELF:CHECKED NE glAudInsrt).
  
ON VALUE-CHANGED OF tbNoBlank IN FRAME {&FRAME-NAME} 
  SELF:MODIFIED = (SELF:CHECKED NE glNoBlank).

ON VALUE-CHANGED OF tbRecord IN FRAME {&FRAME-NAME}
  SELF:MODIFIED = (SELF:CHECKED NE glRecord).

ON VALUE-CHANGED OF tbRuntime IN FRAME {&FRAME-NAME} 
  SELF:MODIFIED = (SELF:CHECKED NE glRuntime).

ON VALUE-CHANGED OF tbTrustDomain IN FRAME {&FRAME-NAME} 
  SELF:MODIFIED = (SELF:CHECKED NE glTrustDomain).

/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ? THEN 
  FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  RUN initializeUI.
  IF RETURN-VALUE = "No Db" THEN
    APPLY "WINDOW-CLOSE" TO FRAME {&FRAME-NAME}.

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
  HIDE FRAME {&FRAME-NAME}.
END PROCEDURE.

PROCEDURE displayOptions :
/*------------------------------------------------------------------------------
  Purpose:     This routine is responsible for displaying the values of the 
               current options in the _db-option table.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDbOption AS HANDLE      NO-UNDO.
  DEFINE VARIABLE hDb       AS HANDLE      NO-UNDO.
  
  DEFINE VARIABLE hField    AS HANDLE      NO-UNDO.

  DEFINE VARIABLE lFound    AS LOGICAL     NO-UNDO.

  DEFINE VARIABLE cPData    AS CHARACTER   NO-UNDO.

  CREATE BUFFER hDbOption FOR TABLE "DICTDB._db-option".
  CREATE BUFFER hDb       FOR TABLE "DICTDB._db".

  lFound = hDb:FIND-FIRST("WHERE RECID(_db) = " + 
                          STRING(drec_db),NO-LOCK) NO-ERROR.
  IF NOT lFound THEN DO:
    MESSAGE "No database connected!" SKIP(1)
            "You must be connected to a database to acces this tool!"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN "No Db".
  END.

  hField = FRAME {&FRAME-NAME}:FIRST-CHILD:FIRST-CHILD.

  DO WHILE VALID-HANDLE(hField):
    IF NOT hField:TYPE = "TOGGLE-BOX" THEN DO: 
      hField = hField:NEXT-SIBLING.
      NEXT.
    END.

    cPData = hField:PRIVATE-DATA.
    lFound = hDbOption:FIND-FIRST("WHERE _db-option._db-recid = " + 
                                  STRING(hDb:RECID) +
                                  " AND _db-option._db-option-code = ~'" +
                                  ENTRY(1,cPData,"|") + "~' AND " + 
                                  "_db-option._db-option-type = " +
                                  ENTRY(2,cPData,"|"),NO-LOCK) NO-ERROR.
    IF (lFound = TRUE) THEN 
      ASSIGN hField:CHECKED   = (hDbOption::_db-option-value = "yes")
             &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN 
               hField:TOOLTIP   
             &ELSE
               hField:HELP
             &ENDIF           = hDbOption::_db-option-description             
             hField:MODIFIED  = FALSE
             hField:SENSITIVE = (NOT ronly) AND 
                     featureEnabled(STRING(hDbOption::_db-option-type)).
    ELSE 
      ASSIGN hField:CHECKED   = FALSE
             hField:MODIFIED  = FALSE
             hField:SENSITIVE = FALSE.
    hField = hField:NEXT-SIBLING.
  END.
  DELETE OBJECT hDbOption.
  DELETE OBJECT hDb.
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
      WITH FRAME {&FRAME-NAME}.
  
  ENABLE &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN RECT-1 &ENDIF
         {&ENABLED-OBJECTS}
         &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN btnHelp &ENDIF
      WITH FRAME {&FRAME-NAME}.
  VIEW FRAME {&FRAME-NAME}.
  
END PROCEDURE.

PROCEDURE initializeUI :
/*------------------------------------------------------------------------------
  Purpose:     Initialization of the User Interface
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  FRAME {&FRAME-NAME}:TITLE = FRAME {&FRAME-NAME}:TITLE + 
                              " (" + LDBNAME("DICTDB") + ")".

  RUN displayOptions.
  IF RETURN-VALUE = "No Db" THEN
    RETURN RETURN-VALUE.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN glAppUser     = tbAppUser:CHECKED
           glAudInsrt    = tbAudInsrt:CHECKED
           glTrustDomain = tbTrustDomain:CHECKED
           glRecord      = tbRecord:CHECKED
           glNoBlank     = tbNoBlank:CHECKED
           glRuntime     = tbRuntime:CHECKED.
  END.
  
END PROCEDURE.

PROCEDURE saveOptions :
/*------------------------------------------------------------------------------
  Purpose:     This routine is responsible for saving the values of the 
               current options in the _db-option table.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDbOption AS HANDLE      NO-UNDO.
  DEFINE VARIABLE hDb       AS HANDLE      NO-UNDO.
  
  DEFINE VARIABLE hField    AS HANDLE      NO-UNDO.

  DEFINE VARIABLE lFound    AS LOGICAL     NO-UNDO.

  CREATE BUFFER hDbOption FOR TABLE "DICTDB._db-option".
  CREATE BUFFER hDb       FOR TABLE "DICTDB._db".

  lFound = hDb:FIND-FIRST("WHERE _db._db-type = ~'PROGRESS~' and _db-local",NO-LOCK) NO-ERROR.
  IF NOT lFound THEN DO:
    MESSAGE "No database connected!" SKIP(1)
            "You must be connected to a database to acces this tool!"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN "No Db".
  END.

  hField = FRAME {&FRAME-NAME}:FIRST-CHILD:FIRST-CHILD.
  DO WHILE VALID-HANDLE(hField):
    
    /* If this is not a TOGGLE-BOX or it's not sensitive then skip it. */
    IF hField:TYPE      <> "TOGGLE-BOX" OR
       hField:SENSITIVE =  FALSE THEN DO:
      hField = hField:NEXT-SIBLING.
      NEXT.
    END.

    lFound = hDbOption:FIND-FIRST("WHERE _db-option._db-recid = " + 
                                  STRING(hDb:RECID) +
                                  " AND _db-option-code = ~'" +
                                  ENTRY(1,hField:PRIVATE-DATA,"|") + "~'" +
                                  " AND _db-option-type = " +
                                  ENTRY(2,hField:PRIVATE-DATA,"|")) 
                                  NO-ERROR.
    /* If we couldn't find an option that matches this one (unlikely) or
       the value hasn't changed, skip it (don't attempt to change the value) */
    IF NOT (lFound = TRUE) OR
       hField:CHECKED = (IF hDbOption::_db-option-value EQ "yes" THEN
                           TRUE ELSE FALSE) THEN DO:
      hField = hField:NEXT-SIBLING.
      NEXT.
    END.
    
    DO TRANSACTION:
      lFound = hDbOption:FIND-FIRST("WHERE _db-option._db-recid = " +
                                    STRING(hDb:RECID) +
                                    " AND _db-option-code = ~'" +
                                    ENTRY(1,hField:PRIVATE-DATA,"|") + "~'" +
                                    " AND _db-option-type = " +
                                    ENTRY(2,hField:PRIVATE-DATA,"|"),
                                    EXCLUSIVE-LOCK) NO-ERROR.

      hDbOption::_db-option-value = (IF hField:CHECKED THEN "yes" 
                                     ELSE "no").
      hDbOption:BUFFER-RELEASE().
    END. /* Transaction Block */
    hField = hField:NEXT-SIBLING.
  END.
END PROCEDURE.

