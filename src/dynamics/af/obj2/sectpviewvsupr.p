&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
/* Procedure Description
"Super Procedure for Security Header Viewer"
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Procedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Procedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*---------------------------------------------------------------------------------
  File: sectpviewvsupr.p

  Description:  Security Header Viewer

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   05/08/2003  Author:     

  Update Notes: Created from Template viewv

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       sectpviewvsupr.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   AstraProcedure    yes

DEFINE VARIABLE gcRunAttribute   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glDataSecurity   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE gcEntityName     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcHeadingFor     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcCurrentUserObj AS CHARACTER  NO-UNDO.

{src/adm2/globals.i}


/* PLIP definitions */
{dynlaunch.i &define-only = YES }

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-setDataModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataModified Procedure 
FUNCTION setDataModified RETURNS LOGICAL
  ( plModified AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: Basic,Browse,DB-Fields
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 14.1
         WIDTH              = 47.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/customsuper.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    /* RUN initializeObject. */  /* Commented out by migration progress */
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-chooseRefresh) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE chooseRefresh Procedure 
PROCEDURE chooseRefresh :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSecuritySource AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE dUserObj      AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dCompanyObj   AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iRowsToBatch  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cEntity       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEntityName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessageList  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton       AS CHARACTER  NO-UNDO.
  define variable hContainer    as handle no-undo.
  DEFINE VARIABLE cUserOrGroups AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAllUsers     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUserObj      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCompanyObj   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRowsToBatch  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cProfileDataValue AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE rRowid            AS ROWID      NO-UNDO.

  hSecuritySource = WIDGET-HANDLE(DYNAMIC-FUNCTION("linkHandles":U IN TARGET-PROCEDURE, INPUT "Security-Target":U)).
  ASSIGN dUserObj     = DECIMAL(formattedWidgetValue("fiUserObj":U))
         dCompanyObj  = DECIMAL(formattedWidgetValue("fiLoginCompanyObj":U))
         iRowsToBatch = INTEGER(formattedWidgetValue("fiRowsToBatch":U))
         cEntityName  = WidgetValue("fiEntityName":U)
         cEntity      = formattedWidgetValue("fiEntity":U).

  IF cEntity = "":U AND 
     NOT glDataSecurity AND
     gcRunAttribute <> "":U THEN
    cEntity = ENTRY(1,gcRunAttribute,"^":U).
  IF cEntityName = "":U AND
     gcRunAttribute <> "":U AND
     NUM-ENTRIES(gcRunAttribute,"^":U) > 1 THEN
    cEntityName = ENTRY(2,gcRunAttribute,"^":U).

  IF cEntity = "":U OR 
     cEntity = ? OR 
     cEntity = "?":U THEN DO:
    cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                  {af/sup2/aferrortxt.i 'AF' '1' '' '' '"Entity"'}.
    IF cMessageList <> "":U THEN
      RUN showMessages IN gshSessionManager (INPUT cMessageList,
                                             INPUT "ERR":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "Error",
                                             INPUT YES,
                                             INPUT ?,
                                             OUTPUT cButton).

    RETURN.
  END.

  IF gcEntityName <> "":U THEN
    cEntityName = gcEntityName.

  IF VALID-HANDLE(hSecuritySource) 
  THEN DO:
      /* Users cannot query or allocate security on entity GSMGA as this entity is       *
       * used for internal security allocations.  Give an error message if they want to. */
      IF cEntity = "GSMGA":U 
      THEN DO:
          ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                                {af/sup2/aferrortxt.i 'AF' '40' '' '' '"Data security against entity GSMGA is used internally by Dynamics.  You cannot specify security against this entity."'}.
          IF cMessageList <> "":U THEN
            RUN showMessages IN gshSessionManager (INPUT cMessageList,
                                                   INPUT "ERR":U,
                                                   INPUT "OK":U,
                                                   INPUT "OK":U,
                                                   INPUT "OK":U,
                                                   INPUT "Error",
                                                   INPUT YES,
                                                   INPUT ?,
                                                   OUTPUT cButton).

          RETURN.
      END.

      RUN refreshQueryDetail IN hSecuritySource (INPUT dUserObj, 
                                                 INPUT dCompanyObj, 
                                                 INPUT cEntity,
                                                 INPUT cEntityName,
                                                 INPUT glDataSecurity,
                                                 INPUT iRowsToBatch).
  END.
 
  /* Save the header info entered by the user for next time. */
  IF NUM-ENTRIES(gcRunAttribute,"^":U) > 3 
  THEN DO:
      ASSIGN cUserOrGroups     = widgetValue("raUsersGroups":U)
             cAllUsers         = formattedWidgetValue("toAllUsers":U)
             cUserObj          = REPLACE(formattedWidgetValue("fiUserObj":U), SESSION:NUMERIC-DECIMAL-POINT, ".":U)
             cCompanyObj       = REPLACE(formattedWidgetValue("fiLoginCompanyObj":U), SESSION:NUMERIC-DECIMAL-POINT, ".":U)
             cRowsToBatch      = formattedWidgetValue("fiRowsToBatch":U)
             cProfileDataValue = cUserOrGroups + CHR(4)
                               + cAllUsers     + CHR(4)
                               + cUserObj      + CHR(4)
                               + cCompanyObj   + CHR(4)
                               + cRowsToBatch.

      RUN setProfileData IN gshProfileManager (INPUT "General":U,
                                               INPUT "Preference":U,
                                               INPUT gcHeadingFor + "|":U + gcCurrentUserObj,
                                               INPUT rRowid,
                                               INPUT cProfileDataValue,
                                               INPUT NO,
                                               INPUT "PER":U).
  END.
  
  {get ContainerSource hContainer}.      
  run selectPage in hContainer ('1').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-comboValueChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE comboValueChanged Procedure 
PROCEDURE comboValueChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcKeyValue        AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcLoginCompanyObj AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER phComboHandle     AS HANDLE     NO-UNDO.

  DEFINE VARIABLE dUSerObj AS DECIMAL    NO-UNDO.
  
  dUserObj = DECIMAL(formattedWidgetValue("fiUserObj":U)).
  
  RUN listGroups IN TARGET-PROCEDURE (INPUT dUserObj).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataChanged Procedure 
PROCEDURE dataChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hToolbarHandle   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContainer       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cHiddenActions   AS CHARACTER  NO-UNDO.

  {get containerSource hContainer}.
  IF VALID-HANDLE(hContainer) THEN
    hToolbarHandle = WIDGET-HANDLE(DYNAMIC-FUNCTION("linkHandles":U IN hContainer, "ContainerToolbar-Source":U)).
    
  IF VALID-HANDLE(hToolbarHandle) THEN
    DYNAMIC-FUNCTION("sensitizeActions":U IN hToolbarHandle, "Save,Reset":U, TRUE).
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fieldValueChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fieldValueChanged Procedure 
PROCEDURE fieldValueChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcFieldName AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hLookup     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hAllToggle  AS HANDLE     NO-UNDO.

  hLookup = DYNAMIC-FUNCTION("internalWidgetHandle":U IN TARGET-PROCEDURE, "fiUserObj":U, "ALL":U).
  
  IF pcFieldName = "raUsersGroups":U THEN DO:
    hAllToggle = DYNAMIC-FUNCTION("internalWidgetHandle":U IN TARGET-PROCEDURE, "TOAllUsers":U, "ALL":U).
    IF VALID-HANDLE(hLookup) THEN DO:
      RUN assignNewValue IN hLookup (INPUT "":U,INPUT "":U,INPUT FALSE).
      RUN listGroups IN TARGET-PROCEDURE (INPUT 0).
    END.
    IF VALID-HANDLE(hAllToggle) THEN DO:
      CASE widgetValue("raUsersGroups":U):
        WHEN "ALL":U THEN
          ASSIGN hAllToggle:LABEL = "All Users and Groups".
        WHEN "USERS":U THEN
          ASSIGN hAllToggle:LABEL = "All Users".
        WHEN "GROUPS":U THEN
          ASSIGN hAllToggle:LABEL = "All Groups".
      END CASE.
    END.
  END.
  
  IF pcFieldName = "ToAllUsers":U THEN DO:
    IF LOGICAL(widgetValue("ToAllUsers":U)) = TRUE THEN DO:
      IF VALID-HANDLE(hLookup) THEN DO:
        RUN assignNewValue IN hLookup (INPUT "":U,INPUT "":U,INPUT FALSE).
        RUN listGroups IN TARGET-PROCEDURE (INPUT 0).
      END.
      disableWidget("fiUserObj":U).
    END.
    ELSE
      enableWidget("fiUserObj":U).
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hideRowsToBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE hideRowsToBatch Procedure 
PROCEDURE hideRowsToBatch :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    hideWidget("fiRowsToBatch":U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hContainerSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFolderHandle    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cEntity          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEntityName      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hEntity          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cWindowTitle     AS CHARACTER  NO-UNDO.  
  DEFINE VARIABLE rRowid           AS ROWID      NO-UNDO.

  DEFINE VARIABLE cHeadingValues AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUserOrGroups  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAllUsers      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUserObj       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCompanyObj    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRowsToBatch   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hWidget        AS HANDLE     NO-UNDO.

  {get ContainerSource hContainerSource}.
  
  SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "DataChanged":U IN hContainerSource.
  SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "resetSecurity":U IN hContainerSource.
  SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "LookupComplete":U IN TARGET-PROCEDURE.
  SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "comboValueChanged":U IN TARGET-PROCEDURE.
  
  {set hideOnInit TRUE}.
  
  RUN SUPER.
  
  {get PageSource hFolderHandle hContainerSource}.

  IF VALID-HANDLE(hContainerSource) THEN
    gcRunAttribute = DYNAMIC-FUNCTION("getRunTimeAttribute":U IN hContainerSource).

  IF gcRunAttribute = "":U OR 
     gcRunAttribute = ? THEN
    disableWidget("buRefresh":U).
  ELSE
    enableWidget("buRefresh":U).

  enableWidget("fiRowsToBatch":U).

  cEntity = ENTRY(1,gcRunAttribute,"^":U).
  
  IF gcRunAttribute <> "":U AND
    NUM-ENTRIES(gcRunAttribute,"^":U) > 1 THEN
    cEntityName = ENTRY(2,gcRunAttribute,"^":U).
  
  IF cEntityName <> "":U AND
    VALID-HANDLE(hContainerSource) THEN DO:
    cWindowTitle = DYNAMIC-FUNCTION("getWindowName":U IN hContainerSource) + " - ":U + cEntityName.
    DYNAMIC-FUNCTION("setWindowName":U IN hContainerSource, cWindowTitle).
  END.

  IF cEntity = "DATA":U THEN
    ASSIGN glDataSecurity = TRUE
           cEntity        = "":U.

  IF glDataSecurity 
  THEN DO:
    IF gcRunAttribute <> "":U AND
       NUM-ENTRIES(gcRunAttribute,"^":U) > 2 THEN
      cEntity = ENTRY(3,gcRunAttribute,"^":U).
    IF cEntity <> "":U THEN DO:
      hEntity = DYNAMIC-FUNCTION("internalWidgetHandle":U IN TARGET-PROCEDURE, INPUT "fiEntity":U, "ALL":U).
      IF VALID-HANDLE(hEntity) THEN DO:
        RUN assignNewValue IN hEntity (INPUT cEntity, INPUT "":U, FALSE).
      END.
      assignWidgetValue("fiEntityName":U, cEntityName).
      gcEntityName = cEntityName.
    END.
  END.

  /* Disable the filter page - until we have a browse up and running */
  RUN disableFolderPage IN hFolderHandle (INPUT 2).
  
  RUN displayFields IN TARGET-PROCEDURE ("?":U).

  RUN viewObject IN TARGET-PROCEDURE.

  hideWidget("fiEntity":U).
  hideWidget("fiEntityName":U).
  disableWidget("fiAllocGroups":U).
  disableWidget("seList":U).
  
  enableWidget("fiUserObj").
  enableWidget("fiLoginCompanyObj").

  IF glDataSecurity AND
     cEntity = "":U THEN DO:
    viewWidget("fiEntity":U).
    enableWidget("fiEntity":U).
  END.
  /* Check for login company */
  IF cEntity = "GSMLG":U THEN
    disableWidget("fiLoginCompanyObj":U).

  /* For saving our header info, we need to know if we're the header for the allocations or enquiry viewers (entry4) */
  IF NUM-ENTRIES(gcRunAttribute,"^":U) > 3 
  THEN DO:
      ASSIGN gcHeadingFor     = ENTRY(4, gcRunAttribute, "^":U)
             gcCurrentUserObj = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager, INPUT "currentUserObj":U, INPUT YES).

      RUN getProfileData IN gshProfileManager (INPUT "General":U,
                                               INPUT "Preference":U,
                                               INPUT gcHeadingFor + "|":U + gcCurrentUserObj,
                                               INPUT NO,
                                               INPUT-OUTPUT rRowid,
                                               OUTPUT cHeadingValues)
                                               NO-ERROR.

      /* Display the stored heading values */
      IF NUM-ENTRIES(cHeadingValues, CHR(4)) = 5 
      THEN DO:
          ASSIGN cUserOrGroups = ENTRY(1, cHeadingValues, CHR(4))
                 cAllUsers     = ENTRY(2, cHeadingValues, CHR(4))
                 cUserObj      = REPLACE(ENTRY(3, cHeadingValues, CHR(4)), ".":U, SESSION:NUMERIC-DECIMAL-POINT)
                 cCompanyObj   = REPLACE(ENTRY(4, cHeadingValues, CHR(4)), ".":U, SESSION:NUMERIC-DECIMAL-POINT)
                 cRowsToBatch  = ENTRY(5, cHeadingValues, CHR(4)).
    
          assignWidgetValue("raUsersGroups":U, cUserOrGroups).
          ASSIGN hWidget = DYNAMIC-FUNCTION("internalWidgetHandle":U IN TARGET-PROCEDURE, INPUT "raUsersGroups":U, "ALL":U).
          APPLY "value-changed":U TO hWidget.

          assignWidgetValue("toAllUsers":U, cAllUsers).
          ASSIGN hWidget = DYNAMIC-FUNCTION("internalWidgetHandle":U IN TARGET-PROCEDURE, INPUT "toAllUsers":U, "ALL":U).
          APPLY "value-changed":U TO hWidget.

          IF cAllUsers <> "YES":U 
          THEN DO:
              ASSIGN hWidget = DYNAMIC-FUNCTION("internalWidgetHandle":U IN TARGET-PROCEDURE, INPUT "fiUserObj":U, "ALL":U).
              IF VALID-HANDLE(hWidget) THEN
                  RUN assignNewValue IN hWidget (INPUT cUserObj, INPUT "":U, FALSE).
          END.

          IF cEntity <> "GSMLG":U THEN
              assignWidgetValue("fiLoginCompanyObj":U, cCompanyObj).

          assignWidgetValue("fiRowsToBatch":U, cRowsToBatch).
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-listGroups) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE listGroups Procedure 
PROCEDURE listGroups :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdUserObj AS DECIMAL    NO-UNDO.
  
  DEFINE VARIABLE hSelList    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE dCompanyObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cGroupList  AS CHARACTER  NO-UNDO.
  
  IF pdUserObj = 0 THEN DO:
    hideWidget("fiAllocGroups":U).
    hideWidget("seList":U).
  END.
  ELSE DO:
    SESSION:SET-WAIT-STATE("GENERAL":U).
    hSelList = DYNAMIC-FUNCTION("internalWidgetHandle":U IN TARGET-PROCEDURE, "seList":U, "ALL":U).
    dCompanyObj = DECIMAL(formattedWidgetValue("fiLoginCompanyObj":U)).
    {dynlaunch.i 
              &PLIP     = "'SecurityManager'"
              &iProc    = "'getSecurityGroups'"              
              &OnApp    = YES
              &AutoKill = YES   
              &mode1    = INPUT        &parm1  = pdUserObj   &dataType1  = DECIMAL
              &mode2    = INPUT        &parm2  = dCompanyObj &dataType2  = DECIMAL
              &mode3    = INPUT        &parm3  = FALSE       &dataType3  = LOGICAL
              &mode4    = INPUT        &parm4  = FALSE       &dataType4  = LOGICAL
              &mode5    = INPUT-OUTPUT &parm5  = cGroupList  &dataType5  = CHARACTER
    }

    ASSIGN cGroupList = REPLACE(cGroupList,CHR(4),",":U)
           cGroupList = RIGHT-TRIM(cGroupList,",":U).
    
    IF VALID-HANDLE(hSelList) THEN
      ASSIGN hSelList:LIST-ITEMS = "":U
             hSelList:LIST-ITEMS = cGroupList.

    SESSION:SET-WAIT-STATE("":U).
    viewWidget("seList":U).
    viewWidget("fiAllocGroups":U).
    enableWidget("seList":U).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-lookupComplete) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE lookupComplete Procedure 
PROCEDURE lookupComplete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcColumnNames           AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcColumnValues          AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcKeyFieldValue         AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcDisplayedFieldValue   AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcOldFieldValue         AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER plLookup                AS LOGICAL      NO-UNDO.
  DEFINE INPUT  PARAMETER phObject                AS HANDLE       NO-UNDO.

  DEFINE VARIABLE dUserObj  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE hLookup   AS HANDLE     NO-UNDO.

  hLookup = DYNAMIC-FUNCTION("internalWidgetHandle":U IN TARGET-PROCEDURE, INPUT "fiUserObj":U, "ALL":U).
  
  IF phObject = hLookup THEN DO:
    dUserObj = DECIMAL(pcKeyFieldValue).
  
    RUN listGroups IN TARGET-PROCEDURE (INPUT dUserObj).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetSecurity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetSecurity Procedure 
PROCEDURE resetSecurity :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hToolbarHandle   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContainer       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cHiddenActions   AS CHARACTER  NO-UNDO.

  {get containerSource hContainer}.
  IF VALID-HANDLE(hContainer) THEN
    hToolbarHandle = WIDGET-HANDLE(DYNAMIC-FUNCTION("linkHandles":U IN hContainer, "ContainerToolbar-Source":U)).
    
  IF VALID-HANDLE(hToolbarHandle) THEN
    DYNAMIC-FUNCTION("sensitizeActions":U IN hToolbarHandle, "Save,Reset":U, FALSE).
  
  RUN chooseRefresh IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-setDataModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataModified Procedure 
FUNCTION setDataModified RETURNS LOGICAL
  ( plModified AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Override this procedure, otherwise we will be prompted to save the
            data on leave.
    Notes:  
------------------------------------------------------------------------------*/
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

