&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 

/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/

/*------------------------------------------------------------------------
    
    File        : prodict/sec/ui-procs.i
    Purpose     : Definitions of common User Interface API for Security
                  interfaces in the Data Administration Tool.

    Syntax      :

    Description : 

    Author(s)   : Kenneth S. McIntosh
    Created     : April 18, 2005

    History: kmcintos May 26, 2005 Check for value-change instead of depending
                                   on MODIFIED attribute, bug # 20050525-017.
             kmcintos May 27, 2005 Moved call to localSave(after) to 
                                   the last thing done in saveRecord 
                                   20050527-021.
             kmcintos May 27, 2005 Moved mode reset to after call to localSave
                                   20050527-024.
             kmcintos Oct 21, 2005 Added logic to allow assignment of initial
                                   values for fields not visible in the UI
                                   20050926-003.
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Variables that are populated, at initialization, in tools that utilize
   this API */
DEFINE VARIABLE gcCreateModeFields  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE gcResetModeFields   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE gcDisableModeFields AS CHARACTER   NO-UNDO.
DEFINE VARIABLE gcFieldHandles      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE gcFieldInits        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE gcFileName          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE gcKeyField          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE gcDBBuffer          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE gcDBFields          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE gcTTFields          AS CHARACTER   NO-UNDO.

/* Global User Interface State variable, generally assigned by the 
   procedures contained in this file. */
DEFINE VARIABLE gcUIState           AS CHARACTER   NO-UNDO.

/* Global HANDLE variables that are populated, at initialization, in the
   tools that utilize this API */
DEFINE VARIABLE ghFrame             AS HANDLE      NO-UNDO.
DEFINE VARIABLE ghBuffer            AS HANDLE      NO-UNDO.

/* Set/Unset when the User Interface is in Create Mode */
DEFINE VARIABLE glCreateMode        AS LOGICAL     NO-UNDO.

/* Intentionally not a NO-UNDO variable.  Just in case there's a problem 
   with a create operation, we can keep track of the last rowid */
DEFINE VARIABLE grwLastRowid        AS ROWID.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelRecord Include 
PROCEDURE cancelRecord :
/*------------------------------------------------------------------------------
  Purpose:     Generic procedure for use with common security UI features.
  Parameters:  <none>
  Notes:       This routine handles reseting the UI components after the
               user cancels an update or create operation.
------------------------------------------------------------------------------*/
  IF CAN-DO(THIS-PROCEDURE:INTERNAL-ENTRIES,"localCancel") THEN DO:
    RUN localCancel ( INPUT "Before" ).
    IF RETURN-VALUE NE "" THEN
      RETURN RETURN-VALUE.
  END.
    
  glCreateMode = FALSE.

  /* Reset the state of the interface. */
  RUN setFieldState ( INPUT "ResetMode" ).
  IF RETURN-VALUE NE "" THEN
    RETURN RETURN-VALUE.
  
  /* Disable/Enable the necessary buttons. */
  RUN setButtonState ( INPUT "ResetMode" ).
  IF RETURN-VALUE NE "" THEN
    RETURN RETURN-VALUE.
  
  /* Redisplay the current record. */
  RUN displayRecord.
  IF RETURN-VALUE NE "" THEN
    RETURN RETURN-VALUE.
  
  IF CAN-DO(THIS-PROCEDURE:INTERNAL-ENTRIES,"localCancel") THEN DO:
    RUN localCancel ( INPUT "After" ).
    IF RETURN-VALUE NE "" THEN
      RETURN RETURN-VALUE.
  END.

  RETURN "".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearUserFields Include 
PROCEDURE clearUserFields :
/*------------------------------------------------------------------------------
  Purpose:     Generic procedure for use with common security UI features.
  Parameters:  <none>
  Notes:       Reset the UI fields to default values...
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iField AS INTEGER     NO-UNDO.

  DEFINE VARIABLE hField AS HANDLE      NO-UNDO.

  DO iField = 1 TO NUM-ENTRIES(gcFieldInits):
    hField = WIDGET-HANDLE(ENTRY(1,ENTRY(iField,gcFieldInits),CHR(1))).
    hField:SCREEN-VALUE = ENTRY(2,ENTRY(iField,gcFieldInits),CHR(1)).
  END.

  IF CAN-DO(THIS-PROCEDURE:INTERNAL-ENTRIES,"localClearFields") THEN DO:
    RUN localClearFields.
  END.  
  RETURN "".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteRecord Include 
PROCEDURE deleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     Generic procedure for use with common security UI features.
  Parameters:  <none>
  Notes:       This routine handles deleting the current record.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lOk         AS LOGICAL     NO-UNDO.

  DEFINE VARIABLE hDBBuff     AS HANDLE      NO-UNDO.
  DEFINE VARIABLE hTTField    AS HANDLE      NO-UNDO. 

  DEFINE VARIABLE cDBKeyField AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cTTKeyField AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cQuote      AS CHARACTER   NO-UNDO.
  
  IF CAN-DO(THIS-PROCEDURE:INTERNAL-ENTRIES,"localDelete") THEN DO:
    RUN localDelete ( INPUT "Before" ).
    IF RETURN-VALUE = "Cancel" THEN
      RETURN "Failed".
  END.

  CREATE BUFFER hDBBuff FOR TABLE gcDBBuffer.
  
  ASSIGN cDBKeyField = ENTRY(1,gcKeyField)
         cTTKeyField = ENTRY(2,gcKeyField)
         hTTField    = ghBuffer:BUFFER-FIELD(cTTKeyField)
         cTTKeyField = (IF ghBuffer:AVAILABLE THEN 
                          TRIM(STRING(hTTField:BUFFER-VALUE))
                        ELSE "")
         cQuote      = (IF ENTRY(3,gcKeyField) EQ "CHAR" THEN "~'" ELSE "").

  lOk = hDBBuff:FIND-FIRST("WHERE " + hDBBuff:NAME + "." + cDBKeyField + 
                           " = " + cQuote + cTTKeyField + cQuote) NO-ERROR.
  IF NOT lOk THEN DO:
    MESSAGE "Database record for " hDBBuff:NAME " no longer exists."
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN "Failed".
  END.

  DEL-BLK:
  DO TRANSACTION ON ERROR UNDO DEL-BLK, LEAVE DEL-BLK:
    IF CAN-DO(THIS-PROCEDURE:INTERNAL-ENTRIES,"localDelete") THEN DO:
      RUN localDelete ( INPUT "Start" ).
      IF RETURN-VALUE = "Cancel" THEN
        RETURN "Failed".
    END.

    /* Need lots of error checking in this routine, in order to preserve the
       state of the UI and the location of the record we'll reposition to
       after the delete operation. */
    IF ghBuffer:BUFFER-DELETE() THEN DO:
      lOk = hDBBuff:BUFFER-DELETE().
      IF NOT (lOk = TRUE) THEN DO:
        MESSAGE "Could not delete record from " ghBuffer:NAME " table."
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN "Failed".
      END.
    END.
    ELSE DO:
      MESSAGE "Could not delete record from " ghBuffer:NAME " table."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      RETURN "Failed".
    END.

    IF CAN-DO(THIS-PROCEDURE:INTERNAL-ENTRIES,"localDelete") THEN DO:
      RUN localDelete ( INPUT "End" ).
      IF RETURN-VALUE NE "" THEN DO:
        UNDO DEL-BLK, RETURN "Failed".
      END.
    END.
  END.

  DELETE OBJECT hDBBuff.

  IF CAN-DO(THIS-PROCEDURE:INTERNAL-ENTRIES,"localDelete") THEN
    RUN localDelete ( INPUT "After" ).

  RETURN "".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayRecord Include 
PROCEDURE displayRecord :
/*------------------------------------------------------------------------------
  Purpose:     Generic procedure for use with common security UI features.
  Parameters:  <none>
  Notes:       Displays the current record, or the default values if there is
               no record available...
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iField   AS INTEGER     NO-UNDO.
  
  DEFINE VARIABLE hField   AS HANDLE      NO-UNDO.
  DEFINE VARIABLE hTTField AS HANDLE      NO-UNDO.

  /* If there is no record available we need to reset the fields to their
     initial values. */
  IF NOT ghBuffer:AVAILABLE THEN DO:
    RUN clearUserFields.
    RETURN "".
  END.

  DO iField = 1 TO NUM-ENTRIES(gcFieldHandles):
    hField = WIDGET-HANDLE(ENTRY(iField,gcFieldHandles)).
    
    hTTField = ghBuffer:BUFFER-FIELD(ENTRY(iField,gcTTFields)).
    IF hField:TYPE = "TOGGLE-BOX" THEN
      hField:CHECKED = hTTField:BUFFER-VALUE.
    ELSE hField:SCREEN-VALUE = hTTField:BUFFER-VALUE.
  END.
  IF CAN-DO(THIS-PROCEDURE:INTERNAL-ENTRIES,"localDisplay") THEN DO:
    RUN localDisplay.
    IF RETURN-VALUE NE "" THEN
      RETURN RETURN-VALUE.
  END. 

  RETURN "".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE newRecord Include 
PROCEDURE newRecord :
/*------------------------------------------------------------------------------
  Purpose:     Generic procedure for use with common security UI features.
  Parameters:  <none>
  Notes:       This routine handles setting up the state for the creation of
               a new record.
------------------------------------------------------------------------------*/
  glCreateMode = TRUE.
  grwLastRowid = (IF ghBuffer:AVAILABLE THEN ghBuffer:ROWID ELSE ?).

  IF CAN-DO(THIS-PROCEDURE:INTERNAL-ENTRIES,"localCreate") THEN DO:
    RUN localCreate ( INPUT "Start" ).
    IF RETURN-VALUE NE "" THEN DO:
      glCreateMode = FALSE.
      RETURN RETURN-VALUE.
    END.
  END.

  /* Reset fields to their initial values */
  RUN clearUserFields.
  IF RETURN-VALUE NE "" THEN DO:
    glCreateMode = FALSE.
    RETURN RETURN-VALUE.
  END.

  /* Enable the appropriate UI fields */
  RUN setFieldState ( INPUT "CreateMode" ).
  IF RETURN-VALUE NE "" THEN DO:
    glCreateMode = FALSE.
    RETURN RETURN-VALUE.
  END.

  /* Enable/Disable the appropriate buttons on the toolbar. */
  RUN setButtonState ( INPUT "CreateMode" ).
  IF RETURN-VALUE NE "" THEN DO:
    glCreateMode = FALSE.
    RETURN RETURN-VALUE.
  END.
  
  IF CAN-DO(THIS-PROCEDURE:INTERNAL-ENTRIES,"localCreate") THEN DO:
    RUN localCreate ( INPUT "End" ).
    IF RETURN-VALUE NE "" THEN DO:
      glCreateMode = FALSE.
      RETURN RETURN-VALUE.
    END.
  END.

  RETURN "".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveRecord Include 
PROCEDURE saveRecord :
/*------------------------------------------------------------------------------
  Purpose:     Generic procedure for use with common security UI features.
  Parameters:  <none>
  Notes:       Saves changes to current record.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iField      AS INTEGER     NO-UNDO.

  DEFINE VARIABLE hField      AS HANDLE      NO-UNDO.
  DEFINE VARIABLE hDBField    AS HANDLE      NO-UNDO.
  DEFINE VARIABLE hDBBuff     AS HANDLE      NO-UNDO.
  DEFINE VARIABLE hTTField    AS HANDLE      NO-UNDO.

  DEFINE VARIABLE cDBKeyField AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cTTKeyField AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cQuote      AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cDBKeyValue AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cField      AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cValue      AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cFieldList  AS CHARACTER   NO-UNDO.

  DEFINE VARIABLE lOk         AS LOGICAL     NO-UNDO.

  IF CAN-DO(THIS-PROCEDURE:INTERNAL-ENTRIES,"localSave") THEN DO:
    RUN localSave ( INPUT "Before" ).
    IF RETURN-VALUE NE "" THEN
      RETURN RETURN-VALUE.
  END.

  CREATE BUFFER hDBBuff FOR TABLE gcDBBuffer.

  ASSIGN cDBKeyField = ENTRY(1,gcKeyField)
         cTTKeyField = ENTRY(2,gcKeyField)
         httField    = ghBuffer:BUFFER-FIELD(cTTKeyField)
         cTTKeyField = (IF ghBuffer:AVAILABLE THEN 
                          STRING(hTTField:BUFFER-VALUE)
                        ELSE "")
         cQuote      = (IF ENTRY(3,gcKeyField) EQ "CHAR" THEN "~'" ELSE "").

  SAVE-BLK:
  DO TRANSACTION ON ERROR UNDO, LEAVE:
    IF CAN-DO(THIS-PROCEDURE:INTERNAL-ENTRIES,"localSave") THEN DO:
      RUN localSave ( INPUT "Start" ).
      IF RETURN-VALUE NE "" THEN DO:
        glCreateMode = FALSE.
        RETURN RETURN-VALUE.
      END.
    END.

    IF glCreateMode THEN DO:
      /* Create a new record in the temp-table. */
      lOk = ghBuffer:BUFFER-CREATE().
      IF lOk THEN /* Assign the rowid that we will reposition to. */
        grwLastRowid = ghBuffer:ROWID.
      ELSE DO:
        MESSAGE "Create failed! " SKIP(1) 
                "Cannot create record in table" ghBuffer:NAME "."
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN "Failed".
      END.

      /* Create a new record in the DB buffer. */
      lOk = hDBBuff:BUFFER-CREATE().
      IF NOT lOk THEN DO:
        MESSAGE "Create failed! Cannot create record in table " hDBBuff:NAME "."
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        UNDO SAVE-BLK, RETURN "Failed".
      END.
      /* If the key is an abstract, or a GUID, the routine should have it's 
         own routine for generating it.  Call this now, if it indeed exists. */
      IF CAN-DO(THIS-PROCEDURE:INTERNAL-ENTRIES,"generateKey") THEN DO:
        ASSIGN hDBField    = hDBBuff:BUFFER-FIELD(cDBKeyField)
               cDBKeyValue = DYNAMIC-FUNCTION('generateKey').

        IF cDBKeyValue = "" OR
           cDBKeyValue = ? THEN DO:
          MESSAGE "Create failed! " SKIP(1) 
                  "Could not generate key for" hDBBuff:NAME "record."
              VIEW-AS ALERT-BOX ERROR BUTTONS OK.
          UNDO SAVE-BLK, RETURN "Failed".
        END.

        ASSIGN hDBField:BUFFER-VALUE = TRIM(cDBKeyValue)
               hTTField:BUFFER-VALUE = TRIM(cDBKeyValue).
      END. /* If generateKey exists. */
    END. /* If new record */
    ELSE IF NOT ghBuffer:AVAILABLE THEN DO:
      glCreateMode = FALSE.
      MESSAGE "Save failed!  Couldn't locate record in local buffer."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      RETURN "Failed".
    END.
    ELSE DO: 
      grwLastRowid = ghBuffer:ROWID.
      lOk = hDBBuff:FIND-FIRST("WHERE " + hDBBuff:NAME + "." + cDBKeyField +
                               " = " + cQuote + cTTKeyField + cQuote) NO-ERROR.
      IF NOT hDBBuff:AVAILABLE OR NOT lOk OR ERROR-STATUS:ERROR THEN DO:
        glCreateMode = FALSE.
        MESSAGE "Save failed!  Couldn't locate record in database."
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        UNDO SAVE-BLK, RETURN "Failed".
      END.
    END.
    
    /* Loop through the UI fields and save their values to the Temp-Table and
       Database Buffers. */
    DO iField = 1 TO NUM-ENTRIES(gcFieldHandles):
      hField   = WIDGET-HANDLE(ENTRY(iField,gcFieldHandles)).
      hDBField = hDBBuff:BUFFER-FIELD(ENTRY(iField,gcDBFields)).
      
      IF hField:SCREEN-VALUE NE hDBField:BUFFER-VALUE THEN
        hField:MODIFIED = TRUE.

      IF NOT glCreateMode AND
         NOT hField:MODIFIED THEN NEXT.

      IF hField:TYPE = "TOGGLE-BOX" THEN
        ASSIGN hTTField              = ghBuffer:BUFFER-FIELD(ENTRY(iField,
                                                                   gcTTFields))
               hTTField:BUFFER-VALUE = hField:CHECKED
               hDBField:BUFFER-VALUE = hField:CHECKED.
      ELSE 
        ASSIGN hTTField              = ghBuffer:BUFFER-FIELD(ENTRY(iField,
                                                                   gcTTFields))
               hTTField:BUFFER-VALUE = hField:SCREEN-VALUE
               hDBField:BUFFER-VALUE = hField:SCREEN-VALUE.
    END. /* Field assign loop */

    IF CAN-DO(THIS-PROCEDURE:INTERNAL-ENTRIES,"localSave") THEN DO:
      RUN localSave ( INPUT "End" ).
      IF RETURN-VALUE BEGINS "INITIAL" THEN 
        DO iField = 1 TO NUM-ENTRIES(ENTRY(2,RETURN-VALUE,"|")):
        IF iField = 1 THEN 
          cFieldList = ENTRY(2,RETURN-VALUE,"|").

        ASSIGN cField = ENTRY(1,ENTRY(iField,cFieldList),"=") 
               cValue = ENTRY(2,ENTRY(iField,cFieldList),"=").

        ASSIGN hDBField              = hDBBuff:BUFFER-FIELD(cField)
               hDBField:BUFFER-VALUE = cValue.
        
      END. /* Additional assign fields initial values. */
      ELSE IF RETURN-VALUE NE "" THEN DO:
        glCreateMode = FALSE.
        UNDO SAVE-BLK, RETURN RETURN-VALUE.
      END.
    END.
  END. /* Transaction block */
  
  DELETE OBJECT hDBBuff.

  RUN setButtonState ( INPUT "ResetMode" ).
  RUN setFieldState  ( INPUT "ResetMode" ).

  /* Don't bother to return a return-value after localSave, at this point,
     because the transaction is over and it would be pointless. */
  IF CAN-DO(THIS-PROCEDURE:INTERNAL-ENTRIES,"localSave") THEN 
    RUN localSave ( INPUT "After" ).

  glCreateMode = FALSE.

  RETURN "".                                      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setButtonState Include 
PROCEDURE setButtonState :
/*------------------------------------------------------------------------------
  Purpose:     Sets up the button state
  Parameters:  INPUT pcMode - Button Mode
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcMode   AS CHARACTER   NO-UNDO.
  
  DEFINE VARIABLE hButton AS HANDLE      NO-UNDO.

  /* Walk the widget tree and find the toolbar buttons. */
  hButton = ghFrame:FIRST-CHILD:FIRST-CHILD.
  DO WHILE VALID-HANDLE(hButton):
    IF hButton:TYPE = "BUTTON" THEN DO:
      CASE pcMode:
        WHEN "CreateMode" THEN DO:
          IF CAN-DO("btnCreate,btnDelete,btnDone",
                    hButton:NAME) THEN
            hButton:SENSITIVE = FALSE.
          ELSE IF CAN-DO("btnSave,btnCancel",hButton:NAME) THEN
            hButton:SENSITIVE = TRUE.
          gcUIState = "Create".
        END. /* WHEN CreateMode */
        WHEN "ResetMode" THEN DO:
          IF CAN-DO("btnCreate,btnDone",
                    hButton:NAME) THEN
            hButton:SENSITIVE = TRUE.
          ELSE IF CAN-DO("btnSave,btnCancel",hButton:NAME) THEN
            hButton:SENSITIVE = FALSE.
          ELSE IF hButton:NAME = "btnDelete" THEN
            hButton:SENSITIVE = ghBuffer:AVAILABLE.
          gcUIState = "Reset".  
        END. /* WHEN CreateMode */
        WHEN "UpdateMode" THEN DO:
          IF CAN-DO("btnCreate,btnDelete,btnDone",
                    hButton:NAME) THEN
            hButton:SENSITIVE = FALSE.
          ELSE IF CAN-DO("btnSave,btnCancel",
                         hButton:NAME) THEN
            hButton:SENSITIVE = TRUE.
          gcUIState = "Update".  
        END.
        WHEN "DisableMode" THEN DO:
          IF CAN-DO("btnCreate,btnDelete,btnSave,btnCancel",
                    hButton:NAME) THEN
            hButton:SENSITIVE = FALSE.
          ELSE
            hButton:SENSITIVE = TRUE.
          gcUIState = "Disable".
        END.
      END CASE.
    END. /* IF type = button */
    hButton = hButton:NEXT-SIBLING.
  END. /* DO WHILE */

  IF CAN-DO(THIS-PROCEDURE:INTERNAL-ENTRIES,"localButtonState") THEN
    RUN localButtonState ( INPUT pcMode ).

  IF RETURN-VALUE NE "" THEN
    RETURN RETURN-VALUE.
  
  RETURN "".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setFieldState Include 
PROCEDURE setFieldState:
/*------------------------------------------------------------------------------
  Purpose:     Generic procedure for use with common security UI features.
  Parameters:  <none>
  Notes:       Enable/Disable fields in interface.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcMode AS CHARACTER   NO-UNDO.

  DEFINE VARIABLE hField AS HANDLE      NO-UNDO.

  DEFINE VARIABLE iField AS INTEGER     NO-UNDO.

  DEFINE VARIABLE cField AS CHARACTER   NO-UNDO.
  
  DO iField = 1 TO NUM-ENTRIES(gcFieldHandles):
    cField = ENTRY(iField,gcFieldHandles).
    hField = WIDGET-HANDLE(cField).
    CASE pcMode:
      WHEN "CreateMode" THEN
        ASSIGN 
        hField:SENSITIVE = (IF ENTRY(LOOKUP(cField,gcCreateModeFields) + 1,
                                     gcCreateModeFields) EQ "yes" THEN TRUE
                            ELSE (IF ENTRY(LOOKUP(cField,
                                                  gcCreateModeFields) + 1,
                                           gcCreateModeFields) = "iab" THEN
                                    ghBuffer:AVAILABLE
                                  ELSE FALSE))
        hField:MODIFIED   = TRUE.
      WHEN "ResetMode" THEN
        ASSIGN
        hField:SENSITIVE = (IF ENTRY(LOOKUP(cField,gcResetModeFields) + 1,
                                     gcResetModeFields) EQ "yes" THEN TRUE
                            ELSE (IF ENTRY(LOOKUP(cField,gcResetModeFields) + 1,
                                           gcResetModeFields) = "iab" THEN
                                    ghBuffer:AVAILABLE
                                  ELSE FALSE))
        hField:MODIFIED  = FALSE.
      WHEN "DisableMode" THEN
        ASSIGN
        hField:SENSITIVE = (IF ENTRY(LOOKUP(cField,gcDisableModeFields) + 1,
                                     gcDisableModeFields) EQ "yes" THEN TRUE
                            ELSE (IF ENTRY(LOOKUP(cField,
                                                  gcDisableModeFields) + 1,
                                           gcDisableModeFields) = "iab" THEN
                                    ghBuffer:AVAILABLE
                                  ELSE FALSE))
        hField:MODIFIED  = FALSE.
    END CASE.
  END.

  IF CAN-DO(THIS-PROCEDURE:INTERNAL-ENTRIES,"localFieldState") THEN
    RUN localFieldState ( INPUT pcMode ).

  IF RETURN-VALUE NE "" THEN
    RETURN RETURN-VALUE.
  
  RETURN "".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setRowidForDelete Include 
PROCEDURE setRowidForDelete :
/*------------------------------------------------------------------------------
  Purpose:     Find a rowid to reposition the query to after a delete 
               operation.  First we search forward and, if there are no 
               more records, we search backward.
  Parameters:  pcQuery - Query string from the current query
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcQuery AS CHARACTER   NO-UNDO.

  DEFINE VARIABLE hBuff  AS HANDLE      NO-UNDO.
  DEFINE VARIABLE hQuery AS HANDLE      NO-UNDO.

  DEFINE VARIABLE cQuery AS CHARACTER   NO-UNDO.

  DEFINE VARIABLE lOk    AS LOGICAL     NO-UNDO.

  cQuery = pcQuery.

  /* Create a new buffer for the temp-table so that we
     don't affect the current query's position */
  CREATE BUFFER hBuff FOR TABLE ghBuffer.
  
  /* We use a query, instead of buffer methods, so that 
     we search, forward and backward, in exactly the same 
     order as the query was opened */
  CREATE QUERY hQuery.

  lOk = hQuery:SET-BUFFERS(hBuff).
  IF lOk THEN
    lOk = hQuery:QUERY-PREPARE(cQuery).
  ELSE RETURN "Cancel".
  IF lOk THEN
    lOk = hQuery:QUERY-OPEN().
  ELSE RETURN "Cancel".
  IF lOk THEN
    lOk = hQuery:GET-FIRST().
  IF NOT lOk THEN
    RETURN "Cancel".

  /* Reposition to the record we're currently positioned at in 
     the browser */
  lOk = hQuery:REPOSITION-TO-ROWID(ghBuffer:ROWID).
  IF lOk THEN
    lOk = hQuery:GET-NEXT().
  
  /* Try going forward */
  IF lOk THEN
    lOk = hQuery:GET-NEXT().
  IF hBuff:AVAILABLE THEN
    grwLastRowid = hBuff:ROWID.
  ELSE DO:
    /* Replace the query's cursor to the current record before
       searching backward */
    lOk = hQuery:REPOSITION-TO-ROWID(ghBuffer:ROWID).
    IF lOk THEN
      lOk = hQuery:GET-NEXT().

    /* If we couldn't find a record below it, try going
       backward */
    IF lOk THEN
      lOk = hQuery:GET-PREV().
    IF lOk THEN
      grwLastRowid = hBuff:ROWID.

    /* We're out of records... */
    ELSE grwLastRowid = ?.
  END.

  DELETE OBJECT hQuery.
  DELETE OBJECT hBuff.

  RETURN "".
END PROCEDURE.
