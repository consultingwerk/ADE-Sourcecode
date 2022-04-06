/*************************************************************/
/* Copyright (c) 1984-2007,2009 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/

/*------------------------------------------------------------------------

  File: prodict/sec/_sec-perm.p

  Description: Permissions editor for records in the _sec-granted-role
               table

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Kenneth S. McIntosh

  Created: April 4, 2005

  History: 
    kmcintos  May 24, 2005 Fixed code that checks if Audit Admin already 
                           exists 20050523-033.
    kmcintos  May 25, 2005 Fixed code that checks Grant/Revoke Perms for 
                           DBA 20050525-007.         
    kmcintos  May 27, 2005 Using guid for for hasChildren 20050526-026.
    kmcintos  May 27, 2005 Always reload role list in localDelete (After) 
                           20050527-023.
    kmcintos June 17, 2005 Made calls to security API more generic 
                           20050617-003.      
    kmcintos June 17, 2005 Tweaked security API to allow DBA Audit Admin
                           permissions when none exist 20050606-003.
    kmcintos June 17, 2005 Added localCancel event to apply local logic
                           after a cancel.
    kmcintos June 17, 2005 Added localFieldState routine and changed 
                           function calls in the security API 20050615-024.
    kmcintos June 21, 2005 Added VALUE-CHANGED trigger after save 20050621-011.
    kmcintos Aug 18, 2005  Increased format of gcUserId to x(40) 20050622-022.
    fernando Nov 03, 2005  Make sure 'grant' toggle-box is not selected by default
                           if scrolling through roles, after it gets sensitive again.
    fernando 11/30/07      Check if read-only mode.                           
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
{prodict/user/uservar.i}
{prodict/sec/sec-func.i}
{prodict/misc/misc-funcs.i}
{prodict/sec/ui-procs.i}

DEFINE VARIABLE gcRoles     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE gcGuid      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c_sec_mode  AS CHARACTER   NO-UNDO.

DEFINE VARIABLE glAdmin     AS LOGICAL     NO-UNDO.

DEFINE VARIABLE iRole       AS INTEGER     NO-UNDO.

IF checkReadOnly("DICTDB","_sec-granted-role") NE "" OR
   checkReadOnly("DICTDB","_sec-role") NE "" THEN
   RETURN.

c_sec_mode = user_env[9].

gcRoles = getPermissions(USERID("DICTDB"),c_sec_mode).

IF gcRoles EQ "" THEN DO:
  MESSAGE "You do not have permission to run this tool!"
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.


DEFINE VARIABLE cRole       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cPerm       AS CHARACTER   NO-UNDO.

DO iRole = 1 TO NUM-ENTRIES(gcRoles) BY 2:
  ASSIGN cRole   = ENTRY(iRole,gcRoles)
         cPerm   = ENTRY(iRole + 1,gcRoles)
         glAdmin = ((cPerm = "w" AND cRole = "dba") OR
                    (cRole = "_sys.audit.admin")).
  IF glAdmin THEN LEAVE.
END.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE TEMP-TABLE sgRole RCODE-INFORMATION
    FIELD guid      AS CHARACTER FORMAT "x(40)"
    FIELD grantee   AS CHARACTER FORMAT "x(32)"  LABEL "UserId"
    FIELD role      AS CHARACTER FORMAT "x(32)"
    FIELD roledesc  AS CHARACTER FORMAT "x(40)"  LABEL "Permission"
    FIELD granter   AS LOGICAL                   LABEL "Can Grant"
    FIELD grantor   AS CHARACTER FORMAT "x(32)"  LABEL "Grantor"
    FIELD comments  AS CHARACTER FORMAT "x(300)" LABEL "Comments"
    FIELD deleted   AS LOGICAL
    INDEX guid AS PRIMARY UNIQUE guid.

DEFINE QUERY qRole FOR sgRole SCROLLING.

DEFINE BROWSE bRole QUERY qRole
    DISPLAY grantee
            roledesc
            grantor
            granter
    &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
      ENABLE grantee
    &ENDIF
    WITH &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 5
         &ELSE 3 &ENDIF DOWN
         WIDTH &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 74
               &ELSE 70 NO-BOX &ENDIF.

DEFINE VARIABLE gcQuery       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE gcPermissions AS CHARACTER   NO-UNDO.
DEFINE VARIABLE gcModFlds     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE gcKeys        AS CHARACTER   NO-UNDO
     INITIAL "CTRL-A Grant  CTRL-S Save  CTRL-N/END-ERROR Cancel  DEL/CTRL-D Revoke"  .
DEFINE VARIABLE gcSort        AS CHARACTER   NO-UNDO INITIAL "roledesc".
DEFINE VARIABLE gcUserId      AS CHARACTER   NO-UNDO.

DEFINE VARIABLE glCanChange   AS LOGICAL     NO-UNDO.
DEFINE VARIABLE lImmedDisp    AS LOGICAL     NO-UNDO.

/* ********************  Preprocessor Definitions  ******************** */
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

&Scoped-define LAYOUT-VARIABLE CURRENT-WINDOW-layout

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-3 figrantee cbroledesc edcomments tbgranter btnDone btnCreate btnCancel btnDelete btnHelp 
&Scoped-Define DISPLAYED-OBJECTS figrantee cbroledesc figrantor edcomments tbgranter lblComments gcUserId 

/* ************************  Function Implementations ***************** */
FUNCTION generateKey RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Generate a new guid for the _granted-role-guid field.
    Notes:  
------------------------------------------------------------------------------*/

  RETURN generateGuid().

END FUNCTION.

FUNCTION hasChildren RETURNS LOGICAL
  ( INPUT pcRole    AS CHARACTER,
    INPUT pcGrantor AS CHARACTER,
    INPUT pcGuid    AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Returns whether or not the specified user has granted permissions,
           in the passed role, to any other users.
Parameters: INPUT pcRole    - Permission to check
            INPUT pcGrantor - User who granted the permission
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lChildren AS LOGICAL     NO-UNDO.

  DEFINE VARIABLE hSGRole   AS HANDLE      NO-UNDO.

  DEFINE VARIABLE cQuery    AS CHARACTER   NO-UNDO.

  CREATE BUFFER hSGRole FOR TABLE "DICTDB._sec-granted-role".

  cQuery = "WHERE _grantor = ~'" + pcGrantor + "~'" +
           " AND _granted-role-guid NE ~'" + pcGuid + "~'".

  IF pcRole NE "_sys.audit.admin" THEN
    cQuery = cQuery + " AND _role-name = ~'" + pcRole + "~'".

  hSGRole:FIND-FIRST(cQuery,NO-LOCK) NO-ERROR.
  lChildren = hSGRole:AVAILABLE.

  DELETE OBJECT hSGRole.
  RETURN lChildren.

END FUNCTION.

/* Define a variable to store the name of the active layout.            */
DEFINE VAR CURRENT-WINDOW-layout AS CHAR INITIAL "Master Layout":U NO-UNDO.

/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnCancel 
     LABEL "Ca&ncel" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 11 BY 1
     &ELSE SIZE 11 BY .95 &ENDIF.

DEFINE BUTTON btnCreate 
     LABEL "&Grant" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 11 BY 1
     &ELSE SIZE 11 BY .95 &ENDIF.

DEFINE BUTTON btnDelete 
     LABEL "&Revoke" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 11 BY 1
     &ELSE SIZE 11 BY .95 &ENDIF.

DEFINE BUTTON btnDone
     LABEL "&Done" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 11 BY 1
     &ELSE SIZE 11 BY .95 &ENDIF
     BGCOLOR 8 .

DEFINE BUTTON btnHelp 
     LABEL "&Help" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 11 BY 1
     &ELSE SIZE 11 BY .95 &ENDIF
     BGCOLOR 8 .

DEFINE BUTTON btnSave 
     LABEL "&Save" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 11 BY 1
     &ELSE SIZE 11 BY .95 &ENDIF.

DEFINE VARIABLE cbroledesc AS CHARACTER 
     LABEL "Permission" FORMAT "x(75)"
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 50 BY 1 
       
     &ELSE SIZE 50 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE edcomments AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 50 BY 5
     &ELSE SIZE 50.2 BY 2.86 &ENDIF NO-UNDO.

DEFINE VARIABLE figrantee AS CHARACTER FORMAT "X(75)":U 
     LABEL "UserId" 
     VIEW-AS FILL-IN 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN 
     SIZE 50 BY 1
     &ELSE SIZE 50 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE figrantor AS CHARACTER FORMAT "X(256)":U 
     LABEL "Grantor" 
     VIEW-AS FILL-IN 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 50 BY 1
     &ELSE SIZE 50.2 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE lblComments AS CHARACTER FORMAT "X(256)":U INITIAL "Comments:" 
      VIEW-AS TEXT 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 11 BY 1
     &ELSE SIZE 11 BY .62 &ENDIF NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 74 BY 1
     &ELSE SIZE 74 BY 1.43 &ENDIF.

DEFINE VARIABLE tbgranter AS LOGICAL INITIAL no 
     LABEL "Can Grant Permissions for" 
     VIEW-AS TOGGLE-BOX
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 63 BY 1
     &ELSE SIZE 63 BY .81 &ENDIF NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     figrantee
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN 
            AT ROW 8 COL 11 COLON-ALIGNED
          &ELSE AT ROW 8 COL 10.8 COLON-ALIGNED &ENDIF
     cbroledesc
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN 
            AT ROW 9 COL 11 COLON-ALIGNED
          &ELSE 
            AT ROW 9.1 COL 10.8 COLON-ALIGNED 
          &ENDIF
     figrantor
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 10 COL 11 COLON-ALIGNED
          &ELSE AT ROW 10.19 COL 10.8 COLON-ALIGNED &ENDIF
     edcomments
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN 
            AT ROW 11 COL 13
          &ELSE                          
            AT ROW 11.29 COL 12.8 
          &ENDIF NO-LABEL
     tbgranter
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN 
            AT ROW 15 COL 4 
          &ELSE AT ROW 14.19 COL 13 &ENDIF
     btnDone
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 17 COL 3
          &ELSE AT ROW 16.19 COL 3.4 &ENDIF
     btnCreate
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 17 COL 18
          &ELSE AT ROW 16.19 COL 16.2 &ENDIF
     btnSave
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 16 COL 28
          &ELSE AT ROW 16.19 COL 27.8 &ENDIF
     btnCancel
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 17 COL 41
          &ELSE AT ROW 16.19 COL 39.2 &ENDIF
     btnDelete
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 17 COL 52
          &ELSE AT ROW 16.19 COL 50.6 &ENDIF
     btnHelp
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 14 COL 65
          &ELSE AT ROW 16.19 COL 63.8 &ENDIF
     lblComments
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 11 COL 2
          &ELSE AT ROW 11.33 COL 1.8 &ENDIF NO-LABEL
     RECT-3
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 14 COL 2
          &ELSE AT ROW 15.95 COL 2 &ENDIF
     SPACE(0.99) SKIP
     gcUserId VIEW-AS TEXT FORMAT "x(40)" AT 2 NO-LABEL
    WITH &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN 
           VIEW-AS DIALOG-BOX &ENDIF KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Edit Audit Permissions"
         DEFAULT-BUTTON btnDone.

DEFINE FRAME {&FRAME-NAME} 
    bRole AT COL 2.5 
             ROW &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN 2 &ELSE 1 &ENDIF.

&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
  BROWSE bRole:HELP = "Press " + KBLABEL("CTRL-A") +
                      " to Grant new Permission or " + KBLABEL("DEL") +
                      " to Revoke selection".
  figrantee:HELP IN FRAME {&FRAME-NAME} = 
                "Enter userid then hit " + KBLABEL("GO") +
                " to Save or " + KBLABEL("CTRL-N") + " to Cancel".
  cbroledesc:HELP IN FRAME {&FRAME-NAME} = 
                "Choose Permission then hit " + KBLABEL("GO") +
                " to Save or " + KBLABEL("CTRL-N") + " to Cancel".
  edcomments:HELP IN FRAME {&FRAME-NAME} =
                "Enter data then hit " + KBLABEL("GO") +
                " to Save or " + KBLABEL("CTRL-N") + " to Cancel".
  tbgranter:HELP IN FRAME {&FRAME-NAME} =
                "Hit spacebar to Select, " + KBLABEL("GO") +
                " to Save or " + KBLABEL("CTRL-N") + " to Cancel".
&ENDIF                

ghFrame = FRAME {&FRAME-NAME}:HANDLE.

gcKeyField = "_granted-role-guid,guid,CHAR".
gcDBBuffer = "DICTDB._sec-granted-role".
BROWSE bRole:SET-REPOSITIONED-ROW(&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 3
                                  &ELSE 2 &ENDIF).

ASSIGN FRAME Dialog-Frame:SCROLLABLE                     = FALSE
       FRAME Dialog-Frame:HIDDEN                         = TRUE
       edcomments:RETURN-INSERTED IN FRAME Dialog-Frame  = TRUE.

IF SESSION:DISPLAY-TYPE = 'TTY':U  THEN 
  RUN CURRENT-WINDOW-layouts (INPUT 'Standard Character':U) NO-ERROR.

/* ************************  Control Triggers  ************************ */

ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Edit Audit Permissions */ DO:
  APPLY "END-ERROR":U TO SELF.
END.

ON ENTRY OF cbroledesc IN FRAME Dialog-Frame /* Permission */ DO:
  DEFINE VARIABLE cLastValue AS CHARACTER NO-UNDO.
  
  cLastValue = SELF:SCREEN-VALUE.

  RUN loadPermissionList ( INPUT c_sec_mode,
                           INPUT "canGrant" ).
  cbroledesc:LIST-ITEM-PAIRS = gcPermissions.
  SELF:SCREEN-VALUE = cLastValue.  
END.

ON LEAVE OF cbroledesc IN FRAME Dialog-Frame /* Permission */ DO:
  DEFINE VARIABLE cLastValue AS CHARACTER NO-UNDO.
  
  cLastValue = SELF:SCREEN-VALUE.
  RUN loadPermissionList ( INPUT c_sec_mode,
                           INPUT "All" ).
  cbroledesc:LIST-ITEM-PAIRS = gcPermissions.
  SELF:SCREEN-VALUE = cLastValue.
END.

ON VALUE-CHANGED OF cbroledesc IN FRAME Dialog-Frame /* Permission */ DO:
  ASSIGN tbgranter:LABEL IN FRAME {&FRAME-NAME} = 
      "Can Grant Permissions for " + ENTRY(LOOKUP(SELF:SCREEN-VALUE,
                                                  SELF:LIST-ITEM-PAIRS) - 1,
                                           SELF:LIST-ITEM-PAIRS).
  RUN localFieldState ( INPUT "Trigger" ).
END.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN

  ON VALUE-CHANGED OF edcomments IN FRAME Dialog-Frame DO:
    IF glCreateMode EQ FALSE THEN DO: 
      IF (AVAILABLE sgRole      AND 
          SELF:SCREEN-VALUE NE sgRole.comments) THEN DO:
        ASSIGN SELF:MODIFIED          = TRUE
               BROWSE bRole:SENSITIVE = FALSE.
        RUN setButtonState ( INPUT "UpdateMode" ).
    
        IF NOT CAN-DO(gcModFlds,SELF:NAME) THEN
          gcModFlds = gcModFlds + (IF gcModFlds NE "" THEN "," ELSE "") + 
                      SELF:NAME.
      END.
      ELSE 
        ASSIGN SELF:MODIFIED = FALSE
               gcModFlds     = REPLACE(gcModFlds,SELF:NAME,"")
               gcModFlds     = TRIM(REPLACE(gcModFlds,",,",","),",").

      IF gcModFlds = "" THEN DO:
        ASSIGN SELF:MODIFIED          = FALSE
               BROWSE bRole:SENSITIVE = FALSE.
        RUN setButtonState ( INPUT "ResetMode" ).
      END.
    END.
  END.

  ON START-SEARCH OF BROWSE bRole DO:
    DEFINE VARIABLE cCol AS CHARACTER   NO-UNDO.

    IF NOT AVAILABLE sgRole THEN DO:
      APPLY "END-SEARCH" TO SELF.
      RETURN NO-APPLY.
    END.

    grwLastRowid = ROWID(sgRole).
    cCol = SELF:CURRENT-COLUMN:NAME.
    IF cCol = gcSort THEN
      gcSort = cCol + " DESC".
    ELSE gcSort = cCol.
    
    RUN openQuery.
    
    APPLY "END-SEARCH" TO SELF.
  END.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

ON VALUE-CHANGED OF bRole IN FRAME {&FRAME-NAME} DO:
  IF AVAILABLE sgRole THEN DO:
    glCanChange = canChange(sgRole.role,
                            sgRole.grantee,
                            sgRole.grantor,
                            USERID("DICTDB"),
                            c_sec_mode).
    
    gcGuid = sgRole.guid.
  END.

  RUN displayRecord.
  RUN setFieldState ( INPUT (IF glCanChange THEN "ResetMode" 
                             ELSE "DisableMode") ).
  RUN setButtonState ( INPUT (IF glCanChange THEN "ResetMode"
                              ELSE "DisableMode") ).
END.

ON DEL OF BROWSE bRole
  APPLY "CHOOSE" TO btnDelete IN FRAME {&FRAME-NAME}.

ON VALUE-CHANGED OF tbgranter IN FRAME Dialog-Frame DO:
  IF glCreateMode THEN LEAVE.

  IF (AVAILABLE sgRole AND 
      SELF:CHECKED NE sgRole.granter) OR
     (NOT AVAILABLE sgRole AND 
      SELF:CHECKED) THEN DO:
    RUN setButtonState ( INPUT "UpdateMode" ).
    ASSIGN SELF:MODIFIED          = TRUE
           BROWSE bRole:SENSITIVE = FALSE.
    
    IF NOT CAN-DO(gcModFlds,SELF:NAME) THEN
      gcModFlds = gcModFlds + (IF gcModFlds NE "" THEN "," ELSE "") + SELF:NAME.
  END.
  ELSE 
    ASSIGN SELF:MODIFIED = FALSE
           gcModFlds     = REPLACE(gcModFlds,SELF:NAME,"")
           gcModFlds     = TRIM(REPLACE(gcModFlds,",,",","),",").
  
  IF gcModFlds = "" THEN DO:
    RUN setButtonState ( INPUT "ResetMode" ).
    BROWSE bRole:SENSITIVE = FALSE.
  END.
END.

ON GO OF FRAME {&FRAME-NAME} DO:
  IF btnSave:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
    APPLY "CHOOSE" TO btnSave.
    RETURN NO-APPLY.
  END.
  ELSE APPLY "CHOOSE" TO btnDone IN FRAME {&FRAME-NAME}.
END.

&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
  ON CTRL-A ANYWHERE DO:
    IF btnCreate:SENSITIVE IN FRAME {&FRAME-NAME} OR 
      (FOCUS = edcomments:HANDLE IN FRAME {&FRAME-NAME} AND
       gcModFlds EQ "") THEN
      APPLY "CHOOSE" TO btnCreate IN FRAME {&FRAME-NAME}.
    ELSE do:
        BELL.
        RETURN NO-APPLY.
    END.
  END.
             
  ON CTRL-N ANYWHERE DO:
    IF btnCancel:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
      IF FOCUS EQ edcomments:HANDLE IN FRAME {&FRAME-NAME} THEN DO:
        IF gcModFlds NE "" THEN
          APPLY "CHOOSE" TO btnCancel IN FRAME {&FRAME-NAME}.
        ELSE RETURN NO-APPLY.
      END.
      ELSE APPLY "CHOOSE" TO btnCancel IN FRAME {&FRAME-NAME}.
    END.
    ELSE RETURN NO-APPLY.
  END.

  ON "ENTRY" OF edcomments IN FRAME {&FRAME-NAME} DO:
    IF glCreateMode OR ronly THEN LEAVE.
  
    /* There is no "VALUE-CHANGED" event for TTY so we need to assume that
       when the user enters this field they intend to update it.  There is
       a corresponding LEAVE event which resets the state if no changes were
       made. */
    IF gcModFlds = "" THEN
      RUN setButtonState ( INPUT "UpdateMode" ).
  
    IF NOT CAN-DO(gcModFlds,SELF:NAME) THEN
      ASSIGN gcModFlds     = gcModFlds +
                             (IF gcModFlds NE "" THEN "," ELSE "") +
                             SELF:NAME
             SELF:MODIFIED = TRUE.
  END.

  ON "LEAVE" OF edcomments IN FRAME {&FRAME-NAME} DO:
    IF glCreateMode OR ronly THEN LEAVE.
  
    /* If no modifications were made then leave */
    IF (AVAILABLE sgRole AND
        SELF:SCREEN-VALUE NE sgRole.comments) OR
       (NOT AVAILABLE sgRole    AND
        SELF:SCREEN-VALUE NE "" AND
        SELF:SCREEN-VALUE NE ?) THEN LEAVE.
      
    ELSE DO: /* If the field was not modified while we were here, reset it.
                If it was the only field in the modified list, reset the
                buttons and the list.*/
      ASSIGN SELF:MODIFIED = FALSE
             gcModFlds     = REPLACE(gcModFlds,SELF:NAME,"")
             gcModFlds     = TRIM(REPLACE(gcModFlds,",,",","),",").
    
      IF gcModFlds = "" THEN DO:
        ASSIGN SELF:MODIFIED          = FALSE
               BROWSE bRole:SENSITIVE = FALSE.
        RUN setButtonState ( INPUT "ResetMode" ).
      END.
    END.
    BROWSE bRole:SENSITIVE = TRUE.
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
  
  PAUSE 0 NO-MESSAGE.
  lImmedDisp = SESSION:IMMEDIATE-DISPLAY.
  SESSION:IMMEDIATE-DISPLAY = TRUE.
  
  &GLOBAL-DEFINE MY-OBJECTS {&ENABLED-OBJECTS} bRole
  &UNDEFINE ENABLED-OBJECTS
  &GLOBAL-DEFINE ENABLED-OBJECTS {&MY-OBJECTS}
  {prodict/sec/sec-trgs.i
      &frame_name = "{&FRAME-NAME}"}

  gcUserId = "User ID: " + USERID("DICTDB").
  RUN enable_UI.
  
  RUN initializeUI.
  IF RETURN-VALUE = "Fatal" THEN
    APPLY "WINDOW-CLOSE" TO FRAME {&FRAME-NAME}.

  WAIT-FOR WINDOW-CLOSE OF FRAME {&FRAME-NAME}.
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
  DISPLAY figrantee 
          cbroledesc 
          figrantor 
          edcomments 
          tbgranter 
          lblComments 
          gcUserId
      WITH FRAME Dialog-Frame.

  IF ronly THEN
     edcomments:READ-ONLY = YES.

  ENABLE RECT-3 WHEN NOT (SESSION:DISPLAY-TYPE = 'TTY':U ) 
         figrantee
         cbroledesc
         edcomments WHEN NOT ronly
         tbgranter 
         btnDone 
         btnCreate WHEN NOT ronly
         btnCancel 
         btnDelete WHEN NOT ronly
         bRole 
         btnHelp WHEN NOT (SESSION:DISPLAY-TYPE = 'TTY':U ) 
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
  gcQuery = "FOR EACH _sec-granted-role WHERE " +
            (IF c_sec_mode = "a" THEN "" ELSE "NOT ") +
            "_sec-granted-role._role-name BEGINS ~'_sys.audit~'".

  ghBuffer   = BUFFER sgRole:HANDLE.
  gcFileName = "Edit " + (IF c_sec_mode = "a" THEN 
                            "Audit " ELSE "") + "Permissions".

  RUN loadPermissionList ( INPUT c_sec_mode,
                           INPUT "All" ).
  IF RETURN-VALUE = "Fatal" THEN
    RETURN "Fatal".

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN gcFieldHandles      = STRING(figrantee:HANDLE)  + "," + "&1," +
                                 STRING(cbroledesc:HANDLE) + "," + "&2," +
                                 STRING(figrantor:HANDLE)  + "," + "&3," +
                                 STRING(edcomments:HANDLE) + "," + "&4," +
                                 STRING(tbgranter:HANDLE)  + ",&5"
           gcFieldInits        = SUBSTITUTE(gcFieldHandles,
                                            CHR(1) + "",
                                            CHR(1) + " ",
                                            CHR(1) + USERID("DICTDB"),
                                            CHR(1) + "",
                                            CHR(1) + "FALSE")
           gcFieldInits        = REPLACE(gcFieldInits,"," + CHR(1),CHR(1))
           gcCreateModeFields  = SUBSTITUTE(gcFieldHandles,
                                            "yes",
                                            "yes",
                                            "no",
                                            "yes",
                                            "yes")
           gcResetModeFields   = SUBSTITUTE(gcFieldHandles,
                                            "no",
                                            "no",
                                            "no",
                                            "iab",
                                            "iab")
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
           gcDBFields          = "_grantee,_role-name,_grantor," + 
                                 "_custom-grant-detail,_grant-rights"
           gcTTFields          = "grantee,role,grantor,comments,granter".
  END.
  RUN loadRolesTT.
      
  cbroledesc:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = gcPermissions.

  ENABLE bRole WITH FRAME {&FRAME-NAME}.
 
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
    ASSIGN grantee:SENSITIVE IN BROWSE bRole = FALSE
           grantee:READ-ONLY IN BROWSE bRole = TRUE.
  &ENDIF

  FRAME {&FRAME-NAME}:TITLE = FRAME {&FRAME-NAME}:TITLE + " (" +
                              LDBNAME("DICTDB") + ")".

  RUN openQuery.
  APPLY "ENTRY" TO BROWSE bRole.
END PROCEDURE.

PROCEDURE loadPermissionList :
/*------------------------------------------------------------------------------
  Purpose:     Loads appropriate permissions from the _sec-role table.
  Parameters:  INPUT pcMode - Mode this dialog is running in e.g. 
                                "a" = Audit Permissions
                                "o" = Other Permissions 
               INPUT pcPerm - Permissions to load into list
                                "All" = All permissions pertinent to this mode
                                "canGrant" = Just the permissions I can Grant
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcMode AS CHARACTER   NO-UNDO.
  DEFINE INPUT  PARAMETER pcPerm AS CHARACTER   NO-UNDO.

  DEFINE VARIABLE hSecRole AS HANDLE      NO-UNDO.
  DEFINE VARIABLE hQuery   AS HANDLE      NO-UNDO.

  CREATE BUFFER hSecRole FOR TABLE "DICTDB._sec-role" NO-ERROR.
  IF NOT VALID-HANDLE(hSecRole) THEN DO:
    MESSAGE "This Database doesn~'t contain the necessary tables for" SKIP
            "Permissions Maintenance operations!"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN "Fatal".
  END.

  CREATE QUERY hQuery.
  hQuery:SET-BUFFERS(hSecRole).
  hQuery:QUERY-PREPARE("FOR EACH _sec-role WHERE " + 
                       (IF pcMode EQ "a" THEN "" ELSE "NOT ") +
                       "_sec-role._role-name BEGINS ~'_sys.audit~'").
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST().

  gcPermissions = ",".
  DO WHILE NOT hQuery:QUERY-OFF-END:
    IF pcPerm EQ "All" OR
       canGrant(hSecRole::_role-name,gcRoles,c_sec_mode) THEN
      gcPermissions = gcPermissions + (IF gcPermissions NE "" THEN "," ELSE "") +
                      hSecRole::_role-description + "," + hSecRole::_role-name.
    hQuery:GET-NEXT().
  END.

  DELETE OBJECT hQuery.
  DELETE OBJECT hSecRole.
  RETURN "".
END PROCEDURE.

PROCEDURE loadRolesTT :
/*------------------------------------------------------------------------------
  Purpose:     Load existing permissions records into the sgRole temp-table
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSGRole   AS HANDLE      NO-UNDO.
  DEFINE VARIABLE hQuery    AS HANDLE      NO-UNDO.

  DEFINE VARIABLE cRoleDesc AS CHARACTER   NO-UNDO.

  CREATE BUFFER hSGRole FOR TABLE "DICTDB._sec-granted-role".

  CREATE QUERY hQuery.
  hQuery:SET-BUFFERS(hSGRole).
  hQuery:QUERY-PREPARE(gcQuery).
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST().

  DO TRANSACTION:
    EMPTY TEMP-TABLE sgRole.
  END.

  DO WHILE NOT hQuery:QUERY-OFF-END:
    DO ON ERROR UNDO, LEAVE TRANSACTION:
      CREATE sgRole.
      cRoleDesc = getRoleDesc(hSGRole::_role-name).
      ASSIGN sgRole.guid     = hSGRole::_granted-role-guid
             sgRole.grantee  = hSGRole::_grantee
             sgRole.role     = hSGRole::_role-name
             sgRole.roledesc = cRoleDesc
             sgRole.granter  = hSGRole::_grant-rights
             sgRole.grantor  = hSGRole::_grantor
             sgRole.comments = hSGRole::_custom-grant-detail.
    END.
    hQuery:GET-NEXT().
  END.
  DELETE OBJECT hQuery.
  DELETE OBJECT hSGRole.
END PROCEDURE.

PROCEDURE localButtonState :
/*------------------------------------------------------------------------------
  Purpose:     Local hook for additional logic to occur during the 
               setButtonState event.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcMode AS CHARACTER   NO-UNDO.

  IF glCreateMode THEN RETURN "".

  DEFINE VARIABLE iPerm      AS INTEGER     NO-UNDO.

  DEFINE VARIABLE lCanGrant  AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE lCanChange AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE lCanRevoke AS LOGICAL     NO-UNDO.

  IF NOT ronly THEN
  GRANT-BLK:
  DO iPerm = 1 TO NUM-ENTRIES(gcRoles) BY 2:
    lCanGrant = canGrant(ENTRY(iPerm,gcRoles),gcRoles,c_sec_mode).
    IF lCanGrant THEN LEAVE GRANT-BLK.
  END.

  lCanChange = canChange(cbroledesc:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                         figrantee:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                         figrantor:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                         USERID("DICTDB"),
                         c_sec_mode).

  lCanRevoke = (NOT ronly) AND 
               canRevoke(cbroledesc:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                         figrantee:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                         figrantor:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                         USERID("DICTDB"),
                         c_sec_mode).

  DO WITH FRAME {&FRAME-NAME}:

    ASSIGN btnCreate:SENSITIVE = lCanGrant AND (gcUIState NE "Update")
           btnSave:SENSITIVE   = (IF CAN-DO("Disable,Reset",gcUIState) THEN 
                                    FALSE 
                                  ELSE (IF btnSave:SENSITIVE THEN 
                                          (gcPermissions NE ",")
                                        ELSE btnSave:SENSITIVE))
           btnCancel:SENSITIVE = (IF CAN-DO("Disable,Reset",gcUIState) THEN 
                                    FALSE 
                                  ELSE (IF btnCancel:SENSITIVE THEN 
                                          (gcPermissions NE ",")
                                        ELSE btnCancel:SENSITIVE))
           btnDelete:SENSITIVE = (IF CAN-DO("Disable",gcUIState) THEN 
                                    FALSE 
                                  ELSE (lCanRevoke                            AND
                                        NOT CAN-DO("Create,Update",gcUIState) AND
                                        AVAILABLE sgRole)).
  END.
  RETURN "".
END PROCEDURE.

PROCEDURE localCancel:
/*------------------------------------------------------------------------------
  Purpose:     Local hook for additional logic to occur during a cancelRecord
               event.
  Parameters:  INPUT pcMode  -  Where we are in the cancel process
                                "Before" = Nothing has occurred yet
                                "After"  = All of the cancel logic has transpired
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcMode AS CHARACTER   NO-UNDO.

  IF pcMode EQ "After" THEN
    APPLY "VALUE-CHANGED" TO BROWSE bRole.
END PROCEDURE.

PROCEDURE localCreate :
/*------------------------------------------------------------------------------
  Purpose:     Local hook for additional logic to occur during a newRecord
               event.
  Parameters:  pcMode - Point of execution of standard behavior.  This is
                        either "Start", which is before standard behavior, or
                        "End", which is after standard behavior.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcMode AS CHARACTER   NO-UNDO.

  DEFINE VARIABLE iField AS INTEGER     NO-UNDO.
  DEFINE VARIABLE hField AS HANDLE      NO-UNDO.

  IF pcMode = "Start" THEN
    BROWSE bRole:SENSITIVE = FALSE.
  
  IF pcMode = "End" THEN DO:
    DO iField = 1 TO NUM-ENTRIES(gcFieldHandles):
      hField = WIDGET-HANDLE(ENTRY(iField,gcFieldHandles)).
      hField:MODIFIED = TRUE.
    END.
  END.
  RETURN "".
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

  CASE pcTxnLoc:
    WHEN "Before" THEN DO:
      MESSAGE "Are you sure you want to revoke this permission?"
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lDelete.
      IF NOT lDelete THEN RETURN "Cancel".

      RUN setRowidForDelete ( INPUT QUERY qRole:PREPARE-STRING ).
      IF RETURN-VALUE NE "" THEN
        RETURN "Cancel".
      ELSE RETURN "".
    END.
    WHEN "After" THEN DO:
      lChildren = hasChildren(cbroledesc:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                              figrantee:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                              gcGuid).
      IF lChildren THEN DO:
        RUN prodict/sec/_cascrvk.p 
            ( INPUT figrantee:SCREEN-VALUE IN FRAME {&FRAME-NAME},
              INPUT cbroledesc:SCREEN-VALUE IN FRAME {&FRAME-NAME},
              INPUT gcGuid ).
        RUN loadRolesTT.
      END.
      RUN openQuery.
      gcRoles = getPermissions(USERID("DICTDB"),c_sec_mode).
      RETURN "".
    END.
  END CASE.
END PROCEDURE.

PROCEDURE localDisplay :
/*------------------------------------------------------------------------------
  Purpose:     Local hook for additional logic to occur during a displayRecord
               event.  
  Parameters:  <none>
  Notes:       This procedure is called from displayRecord in 
               prodict/sec/sec-funcs.i.
------------------------------------------------------------------------------*/
  IF NOT AVAILABLE sgRole THEN RETURN.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN cbroledesc:SCREEN-VALUE = sgRole.role 
           tbgranter:LABEL         = "Can Grant Permissions for " + 
                                     sgRole.roledesc.
  END.
  RETURN "".
END PROCEDURE.

PROCEDURE localFieldState:
  DEFINE INPUT  PARAMETER pcMode AS CHARACTER   NO-UNDO.

  DEFINE VARIABLE lCanChange AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE lAdminRole AS LOGICAL     NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:

    lCanChange = canChange(cbroledesc:SCREEN-VALUE,
                           figrantee:SCREEN-VALUE,
                           figrantor:SCREEN-VALUE,
                           USERID("DICTDB"),
                           c_sec_mode).

    lAdminRole = (cbroledesc:SCREEN-VALUE = "_sys.audit.admin").
    
    IF c_sec_mode = "a" AND 
       (tbgranter:SCREEN-VALUE = "_sys.audit.admin" OR
        lCanChange) THEN
      ASSIGN tbgranter:CHECKED   = (IF lAdminRole THEN 
                                      TRUE 
                                    ELSE IF NOT tbgranter:SENSITIVE THEN FALSE ELSE tbgranter:CHECKED)
             tbgranter:SENSITIVE = (IF lAdminRole THEN FALSE ELSE lCanChange)
             tbgranter:MODIFIED  = (IF glCreateMode THEN 
                                      TRUE ELSE tbgranter:MODIFIED).
    ELSE IF glCreateMode THEN
      ASSIGN tbgranter:CHECKED   = (IF pcMode = "Trigger" THEN 
                                      FALSE ELSE tbgranter:CHECKED)
             tbgranter:SENSITIVE = TRUE
             tbgranter:MODIFIED  = TRUE.
    ELSE tbgranter:SENSITIVE = FALSE.
  END.
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

  DEFINE VARIABLE hSGRole AS HANDLE      NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    CASE pcTxnLoc:
      WHEN "Before" THEN DO:
        IF glCreateMode THEN DO:
          IF figrantee:SCREEN-VALUE = "" OR
             figrantee:SCREEN-VALUE = ? THEN DO:
            MESSAGE "You must specify a user to assign this permission to!"
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            APPLY "ENTRY" TO figrantee.
            RETURN "Retry".
          END.
          IF cbroledesc:SCREEN-VALUE = "" OR
             cbroledesc:SCREEN-VALUE = ? THEN DO:
            MESSAGE "You must select a permission to assign!"
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            APPLY "ENTRY" TO cbroledesc.
            RETURN "Retry".
          END.
          CREATE BUFFER hSGRole FOR TABLE "DICTDB._sec-granted-role".
          hSGRole:FIND-FIRST("WHERE _sec-granted-role._grantee = ~'" +
                                          figrantee:SCREEN-VALUE + "~' AND " +
                                          "_sec-granted-role._role-name = ~'" + 
                                          cbroledesc:SCREEN-VALUE + "~'",NO-LOCK) NO-ERROR.
          IF hSGRole:AVAILABLE THEN DO:
            MESSAGE figrantee:SCREEN-VALUE "has already been granted" 
                              getRoleDesc(cbroledesc:SCREEN-VALUE) "Permissions!" SKIP(1)
                             "Change Userid or Permission, or press the Cancel button."
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            RETURN "Retry".
          END.
          DELETE OBJECT hSGRole.
        END.
        RETURN "".
      END.
      WHEN "Start"  THEN RETURN "".
      WHEN "End"    THEN RETURN "".
      WHEN "After"  THEN DO:
        IF glCreateMode THEN
          ASSIGN sgRole.role     = sgRole.role 
                 sgRole.roledesc = getRoleDesc(sgRole.role).
        
        gcRoles = getPermissions(USERID("DICTDB"),c_sec_mode).
        RUN openQuery.
        RETURN RETURN-VALUE.
      END.
    END CASE.
  END. /* Do with frame {&FRAME-NAME} */
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
      APPLY "ENTRY" TO figrantee IN FRAME {&FRAME-NAME}.
      RETURN "".
    END.
    WHEN "Save" THEN DO:
      BROWSE bRole:SENSITIVE = TRUE.
      APPLY "VALUE-CHANGED" TO BROWSE bRole.
      RETURN "".
    END.
    WHEN "Cancel" THEN DO:
      BROWSE bRole:SENSITIVE = TRUE.
      RETURN "".
    END.
  END CASE.
END PROCEDURE.

PROCEDURE openQuery :
/*------------------------------------------------------------------------------
  Purpose:     Sets up and opens the query for the sgRole temp-table.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery AS HANDLE      NO-UNDO.
  
  /* This is a static query but we prepare it like a dynamic query so
     that we can get the PREPARE-STRING later on for repositioning */
  hQuery = QUERY qRole:HANDLE.
  hQuery:QUERY-PREPARE("FOR EACH sgRole BY " + gcSort).
  hQuery:QUERY-OPEN().

  IF grwLastRowid NE ? THEN
    REPOSITION qRole TO ROWID grwLastRowid NO-ERROR.
  
  /* This fires off the display of the ui fields */
  APPLY "VALUE-CHANGED" TO BROWSE bRole.
    
  RETURN "".
END PROCEDURE.

PROCEDURE localClearFields:
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN tbgranter:LABEL         = "Can Grant Permissions for "
           tbgranter:CHECKED       = FALSE.
  END.
END PROCEDURE.

PROCEDURE CURRENT-WINDOW-layouts:
  DEFINE INPUT PARAMETER layout AS CHARACTER                     NO-UNDO.
  DEFINE VARIABLE lbl-hndl AS WIDGET-HANDLE                      NO-UNDO.
  DEFINE VARIABLE widg-pos AS DECIMAL                            NO-UNDO.
  DEFINE VARIABLE hFrame   AS HANDLE                             NO-UNDO.
  
  hFrame = FRAME {&FRAME-NAME}:HANDLE.
  
  /* Copy the name of the active layout into a variable accessible to   */
  /* the rest of this file.                                             */
  CURRENT-WINDOW-layout = layout.

  CASE layout:
    WHEN "Master Layout" THEN DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
         &IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN
         hFrame:HIDDEN                = yes &ENDIF
         hFrame:HEIGHT                = 16.43 + 
                                        hFrame:BORDER-TOP + 
                                        hFrame:BORDER-BOTTOM
         hFrame:WIDTH                 = 76 + 
                                        hFrame:BORDER-LEFT + 
                                        hFrame:BORDER-RIGHT.

      ASSIGN
         btnCancel:HIDDEN             = yes
         btnCancel:COL                = 39.2
         btnCancel:HEIGHT             = .95
         btnCancel:ROW                = 16.19
         btnCancel:HIDDEN             = no.

      ASSIGN
         btnCreate:HIDDEN             = yes
         btnCreate:COL                = 16.2
         btnCreate:HEIGHT             = .95
         btnCreate:ROW                = 16.19
         btnCreate:HIDDEN             = no.

      ASSIGN
         btnDelete:HIDDEN             = yes
         btnDelete:COL                = 50.6
         btnDelete:HEIGHT             = .95
         btnDelete:ROW                = 16.19
         btnDelete:HIDDEN             = no.

      ASSIGN
         btnDone:HIDDEN               = yes
         btnDone:COL                  = 3.4
         btnDone:HEIGHT               = .95
         btnDone:ROW                  = 16.19
         btnDone:HIDDEN               = no.

      ASSIGN
         btnHelp:HIDDEN               = yes
         btnHelp:COL                  = 63.8
         btnHelp:HEIGHT               = .95
         btnHelp:ROW                  = 16.19
         btnHelp:HIDDEN               = no
         btnHelp:HIDDEN               = no.

      ASSIGN
         btnSave:HIDDEN               = yes
         btnSave:COL                  = 27.8
         btnSave:HEIGHT               = .95
         btnSave:ROW                  = 16.19
         btnSave:HIDDEN               = no.

      ASSIGN
         edcomments:HIDDEN            = yes
         edcomments:COL               = 12.8
         edcomments:HEIGHT            = 2.86
         edcomments:ROW               = 11.29
         edcomments:WIDTH             = 50.2
         edcomments:HIDDEN            = no.

      ASSIGN
         figrantee:HIDDEN             = yes
         widg-pos                     = figrantee:COL  
         figrantee:COL                = 12.8
         lbl-hndl                     = figrantee:SIDE-LABEL-HANDLE  
         lbl-hndl:COL                 = lbl-hndl:COL + 
                                        figrantee:COL   - widg-pos
         figrantee:HIDDEN             = no.

      ASSIGN
         figrantor:HIDDEN             = yes
         widg-pos                     = figrantor:COL  
         figrantor:COL                = 12.8
         lbl-hndl                     = figrantor:SIDE-LABEL-HANDLE  
         lbl-hndl:COL                 = lbl-hndl:COL + 
                                        figrantor:COL   - widg-pos
         widg-pos                     = figrantor:ROW  
         figrantor:ROW                = 10.19
         lbl-hndl                     = figrantor:SIDE-LABEL-HANDLE  
         lbl-hndl:ROW                 = lbl-hndl:ROW + 
                                        figrantor:ROW   - widg-pos
         figrantor:WIDTH              = 50.2
         figrantor:HIDDEN             = no.

      ASSIGN
         lblComments:HIDDEN           = yes
         lblComments:COL              = 1.8
         lblComments:HEIGHT           = .62
         lblComments:ROW              = 11.33
         lblComments:HIDDEN           = no.

      ASSIGN
         RECT-3:HIDDEN                = yes
         RECT-3:HEIGHT                = 1.43
         RECT-3:ROW                   = 15.95
         RECT-3:HIDDEN                = no
         RECT-3:HIDDEN                = no.

      ASSIGN
         tbgranter:HIDDEN             = yes
         tbgranter:COL                = 13
         tbgranter:HEIGHT             = .81
         tbgranter:ROW                = 14.19
         tbgranter:HIDDEN             = no.

      ASSIGN
         hFrame:VIRTUAL-HEIGHT        = 16.43 WHEN hFrame:SCROLLABLE
         &IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN
           hFrame:HIDDEN              = no &ENDIF.

    END.  /* Master Layout Layout Case */

    WHEN "Standard Character":U THEN DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
         &IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN
           hFrame:HIDDEN              = yes &ENDIF
         hFrame:HEIGHT                = 19 +
                                        hFrame:BORDER-TOP + 
                                        hFrame:BORDER-BOTTOM
         hFrame:WIDTH                 = 75 + 
                                        hFrame:BORDER-LEFT + 
                                        hFrame:BORDER-RIGHT NO-ERROR.

      ASSIGN
         btnCancel:HIDDEN             = yes
         btnCancel:COL                = 44
         btnCancel:HEIGHT             = 1
         btnCancel:ROW                = 17
         btnCancel:HIDDEN             = no NO-ERROR.

      ASSIGN
         btnCreate:HIDDEN             = yes
         btnCreate:COL                = 18
         btnCreate:HEIGHT             = 1
         btnCreate:ROW                = 17
         btnCreate:HIDDEN             = no NO-ERROR.

      ASSIGN
         btnDelete:HIDDEN             = yes
         btnDelete:COL                = 57
         btnDelete:HEIGHT             = 1
         btnDelete:ROW                = 17
         btnDelete:HIDDEN             = no NO-ERROR.

      ASSIGN
         btnDone:HIDDEN               = yes
         btnDone:COL                  = 3
         btnDone:HEIGHT               = 1
         btnDone:ROW                  = 17
         btnDone:HIDDEN               = no NO-ERROR.

      
      ASSIGN
         btnHelp:HIDDEN               = yes
         btnHelp:COL                  = 72
         btnHelp:HEIGHT               = 1
         btnHelp:ROW                  = 14 NO-ERROR.

      ASSIGN
         btnSave:HIDDEN               = yes
         btnSave:COL                  = 31
         btnSave:HEIGHT               = 1
         btnSave:ROW                  = 17
         btnSave:HIDDEN               = no NO-ERROR.

      ASSIGN
         edcomments:HIDDEN            = yes
         edcomments:COL               = 13
         edcomments:HEIGHT            = 5
         edcomments:ROW               = 10
         edcomments:WIDTH             = 50
         edcomments:HIDDEN            = no NO-ERROR.

      ASSIGN
         figrantee:HIDDEN             = yes
         widg-pos                     = figrantee:COL  
         figrantee:COL                = 13
         figrantee:ROW                = 7
         lbl-hndl                     = figrantee:SIDE-LABEL-HANDLE  
         lbl-hndl:COL                 = lbl-hndl:COL + 
                                        figrantee:COL   - widg-pos
         lbl-hndl:ROW                 = 7
         figrantee:HIDDEN             = no NO-ERROR.

      ASSIGN
         figrantor:HIDDEN             = yes
         widg-pos                     = figrantor:COL  
         figrantor:COL                = 13
         lbl-hndl                     = figrantor:SIDE-LABEL-HANDLE  
         lbl-hndl:COL                 = lbl-hndl:COL + 
                                        figrantor:COL   - widg-pos
         widg-pos                     = figrantor:ROW           
         figrantor:ROW                = 10
         lbl-hndl                     = figrantor:SIDE-LABEL-HANDLE  
         lbl-hndl:ROW                 = lbl-hndl:ROW + 
                                        figrantor:ROW   - widg-pos
         figrantor:ROW                = 9
         lbl-hndl:ROW                 = 9
         figrantor:WIDTH              = 50
         figrantor:HIDDEN             = no NO-ERROR.

      ASSIGN
         lblComments:HIDDEN           = yes
         lblComments:COL              = 2
         lblComments:HEIGHT           = 1
         lblComments:ROW              = 10
         lblComments:HIDDEN           = no NO-ERROR.

      ASSIGN
         RECT-3:HIDDEN                = yes
         RECT-3:HEIGHT                = 1
         RECT-3:ROW                   = 14 NO-ERROR.

      ASSIGN
         tbgranter:HIDDEN             = yes
         tbgranter:COL                = 13
         tbgranter:HEIGHT             = 1
         tbgranter:ROW                = 15
         tbgranter:HIDDEN             = no NO-ERROR.

      ASSIGN
         cbroledesc:HIDDEN            = yes
         cbroledesc:ROW               = 8
         cbroledesc:WIDTH             = 50
         lbl-hndl                     = cbroledesc:SIDE-LABEL-HANDLE 
         lbl-hndl:ROW                 = 8
         cbroledesc:HIDDEN            = no NO-ERROR.

      ASSIGN 
         gcUserId:HIDDEN              = TRUE
         gcUserId:ROW                 = 18
         gcUserId:HIDDEN              = FALSE NO-ERROR.
             
      ASSIGN
         hFrame:VIRTUAL-HEIGHT        = 16.00 WHEN hFrame:SCROLLABLE
         &IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN
           hFrame:HIDDEN              = no &ENDIF NO-ERROR.

    END.  /* Standard Character Layout Case */

  END CASE.
END PROCEDURE.  /* CURRENT-WINDOW-layouts */
