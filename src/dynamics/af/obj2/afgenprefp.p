&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
/* Procedure Description
"Object Generator Preference Viewer"
*/
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
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
/*---------------------------------------------------------------------------------
  File: C:/work/possecode/wip/af/obj2/afgenprefp.p afgenprefv

  Description:  Object Generator Preference Viewer

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   01/31/2003  Author:     Mark Davies (MIP)

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

&scop object-name       afgenprefp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-DynamicSmartDataViewer yes

{src/adm2/globals.i}

DEFINE VARIABLE gcAllFieldNames           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcAllFieldHandles         AS CHARACTER  NO-UNDO.

/* Handles for each field on DynView */
DEFINE VARIABLE hSDOObjectType AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSDOProdMod    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSDOSuffix     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSDOSortOrder  AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSDOOverWrite  AS HANDLE     NO-UNDO.
DEFINE VARIABLE hFollowJoins   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hAppServPart   AS HANDLE     NO-UNDO.

DEFINE VARIABLE hDlpObjectType AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDlpProdMod    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDlpSuffix     AS HANDLE     NO-UNDO.

DEFINE VARIABLE hDflObjectType AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDflProdMod    AS HANDLE     NO-UNDO.

DEFINE VARIABLE hSDBObjectType AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSDBProdMod    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSDBSuffix     AS HANDLE     NO-UNDO.

DEFINE VARIABLE hSDVObjectType AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSDVProdMod    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSDVSuffix     AS HANDLE     NO-UNDO.

DEFINE VARIABLE gcPrefData     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ghTargetProc   AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "ry/obj/rytemfullo.i"



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getFieldHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFieldHandle Procedure 
FUNCTION getFieldHandle RETURNS HANDLE
  ( pcFieldName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-retrieveValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD retrieveValue Procedure 
FUNCTION retrieveValue RETURNS CHARACTER
  ( pcAttr AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDefaultValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDefaultValue Procedure 
FUNCTION setDefaultValue RETURNS LOGICAL
  ( pcAttribute AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Data Source: "ry/obj/rytemfullo.w"
   Allow: Basic,Browse,DB-Fields
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 17
         WIDTH              = 49.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    /* RUN initializeObject. */
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-assignFieldHandles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignFieldHandles Procedure 
PROCEDURE assignFieldHandles :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will assign handles to predefined variables to 
               allow the use of the variables on the viewer to be more accesable
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  ASSIGN hSDOObjectType = {fnarg getFieldHandle 'coSDOType'}
         hSDOProdMod    = {fnarg getFieldHandle 'cSDOProdMod'}
         hSDOSuffix     = {fnarg getFieldHandle 'fiSDOSuffix'}
         hSDOSortOrder  = {fnarg getFieldHandle 'raSort'}
         hSDOOverWrite  = {fnarg getFieldHandle 'toPromptSDOOvrWrt'}
         hFollowJoins   = {fnarg getFieldHandle 'toFollow'}
         hAppServPart   = {fnarg getFieldHandle 'coAppServer'}

         hDlpObjectType = {fnarg getFieldHandle 'coDlpType'}
         hDlpProdMod    = {fnarg getFieldHandle 'cDlpProdMod'}
         hDlpSuffix     = {fnarg getFieldHandle 'fiDlpSuffix'}

         hDflObjectType = {fnarg getFieldHandle 'coDflType'}
         hDflProdMod    = {fnarg getFieldHandle 'cDflProdMod'}

         hSDBObjectType = {fnarg getFieldHandle 'coSDBType'}
         hSDBProdMod    = {fnarg getFieldHandle 'cSDBProdMod'}
         hSDBSuffix     = {fnarg getFieldHandle 'fiSDBSuffix'}

         hSDVObjectType = {fnarg getFieldHandle 'coSDVType'}
         hSDVProdMod    = {fnarg getFieldHandle 'cSDVProdMod'}
         hSDVSuffix     = {fnarg getFieldHandle 'fiSDVSuffix'}.
  
  IF NOT VALID-HANDLE(hSDOProdMod) THEN
    hSDOProdMod = {fnarg getFieldHandle 'hSDOProdMod'}.
  IF NOT VALID-HANDLE(hDlpProdMod) THEN
    hDlpProdMod = {fnarg getFieldHandle 'hDlpProdMod'}.
  IF NOT VALID-HANDLE(hDflProdMod) THEN
    hDflProdMod = {fnarg getFieldHandle 'hDflProdMod'}.
  IF NOT VALID-HANDLE(hSDBProdMod) THEN
    hSDBProdMod = {fnarg getFieldHandle 'hSDBProdMod'}.
  IF NOT VALID-HANDLE(hSDVProdMod) THEN
    hSDVProdMod = {fnarg getFieldHandle 'hSDVProdMod'}.

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
  DEFINE INPUT PARAMETER pcKeyFieldValue        AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcScreenValue          AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER phCombo                AS HANDLE     NO-UNDO. 
  
  {set DataModified TRUE ghTargetProc}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPreferenceDetails) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPreferenceDetails Procedure 
PROCEDURE getPreferenceDetails :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE rRowid AS ROWID      NO-UNDO.

  /* Get Report Directory */
  ASSIGN rRowid = ?.
  IF VALID-HANDLE(gshProfileManager) THEN
  RUN getProfileData IN gshProfileManager (INPUT "General":U,         /* Profile type code     */
                                           INPUT "Preference":U,      /* Profile code          */
                                           INPUT "GenerateObjects":U, /* Profile data key      */
                                           INPUT "NO":U,              /* Get next record flag  */
                                           INPUT-OUTPUT rRowid,       /* Rowid of profile data */
                                           OUTPUT gcPrefData).     /* Found profile data.   */
  IF gcPrefData = ? OR
     gcPrefData = "":U THEN
    RUN setDefaultsAll IN TARGET-PROCEDURE.
  ELSE DO:
    
    hSDOObjectType:SCREEN-VALUE = {fnarg retrieveValue 'SDO_Type'}.
    hSDOSuffix:SCREEN-VALUE     = {fnarg retrieveValue 'OG_SDO_Suf'}.
    hSDOSortOrder:SCREEN-VALUE  = IF {fnarg retrieveValue 'SDO_Sort'} <> ? THEN {fnarg retrieveValue 'SDO_Sort'} ELSE "Order".
    hSDOOverWrite:CHECKED       = IF LOGICAL({fnarg retrieveValue 'SDO_OvrWrt'}) <> ? THEN LOGICAL({fnarg retrieveValue 'SDO_OvrWrt'}) ELSE TRUE.
    hFollowJoins:CHECKED        = IF LOGICAL({fnarg retrieveValue 'SDO_Follow'}) <> ? THEN LOGICAL({fnarg retrieveValue 'SDO_Follow'}) ELSE TRUE.
    hAppServPart:SCREEN-VALUE   = {fnarg retrieveValue 'SDO_ApsPart'}.
    hDlpObjectType:SCREEN-VALUE = {fnarg retrieveValue 'DLP_type'}.
    hDlpSuffix:SCREEN-VALUE     = {fnarg retrieveValue 'OG_SDO_DlpSuf'}.
    hDflObjectType:SCREEN-VALUE = {fnarg retrieveValue 'DFL_Type'}.
    hSDBObjectType:SCREEN-VALUE = {fnarg retrieveValue 'SDB_Type'}.
    hSDBSuffix:SCREEN-VALUE     = {fnarg retrieveValue 'OG_SDB_Suf'}.
    hSDVObjectType:SCREEN-VALUE = {fnarg retrieveValue 'SDV_Type'}.
    hSDVSuffix:SCREEN-VALUE     = {fnarg retrieveValue 'OG_SDV_Suf'}.
    
    IF hSDOSuffix:SCREEN-VALUE = ? OR
       hSDOSuffix:SCREEN-VALUE = "?":U THEN
      {fnarg setDefaultValue 'SDOSUFFIX'}.
    IF hDlpSuffix:SCREEN-VALUE = ? OR
       hDlpSuffix:SCREEN-VALUE = "?":U THEN
      {fnarg setDefaultValue 'DLPSUFFIX'}.
    IF hSDBSuffix:SCREEN-VALUE = ? OR
       hSDBSuffix:SCREEN-VALUE = "?":U THEN
      {fnarg setDefaultValue 'SDBSUFFIX'}.
    IF hSDVSuffix:SCREEN-VALUE = ? OR
       hSDVSuffix:SCREEN-VALUE = "?":U THEN
      {fnarg setDefaultValue 'SDVSUFFIX'}.

    DYNAMIC-FUNCTION("setDataValue":U IN hSDOProdMod, {fnarg retrieveValue 'SDO_PM'}).
    DYNAMIC-FUNCTION("setDataValue":U IN hDlpProdMod, {fnarg retrieveValue 'SDO_DlpPM'}).
    DYNAMIC-FUNCTION("setDataValue":U IN hDflProdMod, {fnarg retrieveValue 'DFL_PM'}).
    DYNAMIC-FUNCTION("setDataValue":U IN hSDBProdMod, {fnarg retrieveValue 'SDB_PM'}).
    DYNAMIC-FUNCTION("setDataValue":U IN hSDVProdMod, {fnarg retrieveValue 'SDV_PM'}).
    
    IF DYNAMIC-FUNCTION("getDataValue":U IN hSDOProdMod) = ? THEN
      RUN valueChanged IN hSDOProdMod.

    IF DYNAMIC-FUNCTION("getDataValue":U IN hDlpProdMod) = ? THEN
      RUN valueChanged IN hDlpProdMod.
    
    IF DYNAMIC-FUNCTION("getDataValue":U IN hDflProdMod) = ? THEN
      RUN valueChanged IN hDflProdMod.
    
    IF DYNAMIC-FUNCTION("getDataValue":U IN hSDBProdMod) = ? THEN
      RUN valueChanged IN hSDBProdMod.
    
    IF DYNAMIC-FUNCTION("getDataValue":U IN hSDVProdMod) = ? THEN
      RUN valueChanged IN hSDVProdMod.
  END.
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
  
  gcAllFieldNames = DYNAMIC-FUNCTION("getAllFieldNames":U IN TARGET-PROCEDURE).
  gcAllFieldHandles = DYNAMIC-FUNCTION("getAllFieldHandles":U IN TARGET-PROCEDURE).
  
  RUN assignFieldHandles IN TARGET-PROCEDURE.
  
  SUBSCRIBE TO "comboValueChanged":U IN TARGET-PROCEDURE.
  ghTargetProc = TARGET-PROCEDURE.
  RUN SUPER.

  RUN displayFields IN TARGET-PROCEDURE (?).
  RUN enableField IN hSDOProdMod.
  RUN enableField IN hDlpProdMod.
  RUN enableField IN hDflProdMod.
  RUN enableField IN hSDBProdMod.
  RUN enableField IN hSDVProdMod.

  RUN populateObjectTypes IN TARGET-PROCEDURE.

  ASSIGN hAppServPart:LIST-ITEMS = REPLACE(DYNAMIC-FUNCTION("getServiceList":U IN THIS-PROCEDURE, INPUT "AppServer":U),CHR(3),",":U).
  hAppServPart:ADD-FIRST("<None>").
  ASSIGN hAppServPart:SCREEN-VALUE = hAppServPart:ENTRY(1).
  
  RUN getPreferenceDetails IN TARGET-PROCEDURE.
  {set DataModified FALSE}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-populateObjectTypes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateObjectTypes Procedure 
PROCEDURE populateObjectTypes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cCalcFieldChildren AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iNumChild          AS INTEGER    NO-UNDO.

  /* Dynamic SDO */
  /* Make sure that the relevant object types are cached. */
  RUN createClassCache IN gshRepositoryManager ( INPUT "DynSDO":U ).

  /* Get the object type */
  ASSIGN hSDOObjectType:LIST-ITEMS = REPLACE(DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "DynSDO":U),CHR(3),",":U) NO-ERROR.
  IF hSDOObjectType:LIST-ITEMS = "":U
  OR hSDOObjectType:LIST-ITEMS = ?
  THEN ASSIGN hSDOObjectType:LIST-ITEMS = "DynSDO":U.
  ASSIGN hSDOObjectType:SCREEN-VALUE = hSDOObjectType:ENTRY(1) NO-ERROR.

  /* Data Logic Procedure */
  /* Make sure that the relevant object types are cached. */
  RUN createClassCache IN gshRepositoryManager ( INPUT "DLProc":U ).

  /* Get the object type */
  ASSIGN hDlpObjectType:LIST-ITEMS = REPLACE(DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "DLProc":U),CHR(3),",":U) NO-ERROR.
  IF hDlpObjectType:LIST-ITEMS = "":U
  OR hDlpObjectType:LIST-ITEMS = ?
  THEN ASSIGN hDlpObjectType:LIST-ITEMS = "DLProc":U.
  ASSIGN hDlpObjectType:SCREEN-VALUE = hDlpObjectType:ENTRY(1) NO-ERROR.
  
  /* Data Fields */
  /* Make sure that the relevant object types are cached. */
  RUN createClassCache IN gshRepositoryManager ( INPUT "DataField":U ).

  /* Get the object type */
  ASSIGN hDflObjectType:LIST-ITEMS = REPLACE(DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "DataField":U),CHR(3),",":U) NO-ERROR.
  /* Calculated fields should not be included in the list of object types
     for import.  This is a temporary fix that should be removed once
     CalculatedFields are changed to be siblings of DataFields rather
     than children of DataFields. */
  cCalcFieldChildren = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "CalculatedField":U).
  DO iNumChild = 1 TO NUM-ENTRIES(cCalcFieldChildren):
    hDflObjectType:DELETE(ENTRY(iNumChild,cCalcFieldChildren)).
  END.  /* do iNumChild */
  
  IF hDflObjectType:LIST-ITEMS = "":U
  OR hDflObjectType:LIST-ITEMS = ?
  THEN ASSIGN hDflObjectType:LIST-ITEMS = "DataField":U.
  ASSIGN hDflObjectType:SCREEN-VALUE = hDflObjectType:ENTRY(1) NO-ERROR.

  /* Dynamic Viewers */
  /* Make sure that the relevant object types are cached. */
  RUN createClassCache IN gshRepositoryManager ( INPUT "DynView":U ).

  /* Get the object type */
  ASSIGN hSDVObjectType:LIST-ITEMS = REPLACE(DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "DynView":U),CHR(3),",":U) NO-ERROR.
  IF hSDVObjectType:LIST-ITEMS = "":U
  OR hSDVObjectType:LIST-ITEMS = ?
  THEN ASSIGN hSDVObjectType:LIST-ITEMS = "DynView":U.
  ASSIGN hSDVObjectType:SCREEN-VALUE = hSDVObjectType:ENTRY(1) NO-ERROR.

  /* Dynamic Browsers */
  /* Make sure that the relevant object types are cached. */
  RUN createClassCache IN gshRepositoryManager ( INPUT "DynBrow":U ).

  /* Get the object type */
  ASSIGN hSDBObjectType:LIST-ITEMS = REPLACE(DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "DynBrow":U),CHR(3),",":U) NO-ERROR.
  IF hSDBObjectType:LIST-ITEMS = "":U
  OR hSDBObjectType:LIST-ITEMS = ?
  THEN ASSIGN hSDBObjectType:LIST-ITEMS = "DynBrow":U.
  ASSIGN hSDBObjectType:SCREEN-VALUE = hSDBObjectType:ENTRY(1) NO-ERROR.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetDefaults) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetDefaults Procedure 
PROCEDURE resetDefaults :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  RUN setDefaultsAll IN TARGET-PROCEDURE.
  
  {set DataModified TRUE}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDefaultsAll) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaultsAll Procedure 
PROCEDURE setDefaultsAll :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will set the default value for all the preferences
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DYNAMIC-FUNCTION("setDefaultValue":U IN TARGET-PROCEDURE, "SDOTYPE").
  DYNAMIC-FUNCTION("setDefaultValue":U IN TARGET-PROCEDURE, "SDOPM").
  DYNAMIC-FUNCTION("setDefaultValue":U IN TARGET-PROCEDURE, "SDOSUFFIX").
  DYNAMIC-FUNCTION("setDefaultValue":U IN TARGET-PROCEDURE, "DLPTYPE").
  DYNAMIC-FUNCTION("setDefaultValue":U IN TARGET-PROCEDURE, "DLPPM").
  DYNAMIC-FUNCTION("setDefaultValue":U IN TARGET-PROCEDURE, "DLPSUFFIX").
  DYNAMIC-FUNCTION("setDefaultValue":U IN TARGET-PROCEDURE, "SDVTYPE").
  DYNAMIC-FUNCTION("setDefaultValue":U IN TARGET-PROCEDURE, "SDVPM").
  DYNAMIC-FUNCTION("setDefaultValue":U IN TARGET-PROCEDURE, "SDVSUFFIX").
  DYNAMIC-FUNCTION("setDefaultValue":U IN TARGET-PROCEDURE, "SDBTYPE").
  DYNAMIC-FUNCTION("setDefaultValue":U IN TARGET-PROCEDURE, "SDBPM").
  DYNAMIC-FUNCTION("setDefaultValue":U IN TARGET-PROCEDURE, "SDBSUFFIX").
  DYNAMIC-FUNCTION("setDefaultValue":U IN TARGET-PROCEDURE, "DFLTYPE").
  DYNAMIC-FUNCTION("setDefaultValue":U IN TARGET-PROCEDURE, "DFLPM").
  DYNAMIC-FUNCTION("setDefaultValue":U IN TARGET-PROCEDURE, "SDOAPSPART").
  DYNAMIC-FUNCTION("setDefaultValue":U IN TARGET-PROCEDURE, "SDOSORT").
  DYNAMIC-FUNCTION("setDefaultValue":U IN TARGET-PROCEDURE, "SDOFOLLOW").
  DYNAMIC-FUNCTION("setDefaultValue":U IN TARGET-PROCEDURE, "SDOOVRWRT").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRecord Procedure 
PROCEDURE updateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValues     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEntries    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainer  AS HANDLE     NO-UNDO.
  
  ASSIGN gcPrefData = "":U.
  cEntries = "SDO_Type,SDO_PM,OG_SDO_Suf,SDO_Sort,SDO_OvrWrt,SDO_Follow,SDO_ApsPart,DLP_type,SDO_DlpPM,OG_SDO_DlpSuf,DFL_Type,DFL_PM,SDB_Type,SDB_PM,OG_SDB_Suf,SDV_Type,SDV_PM,OG_SDV_Suf".
  cEntries = REPLACE(cEntries,",":U,CHR(3)).
  
  cValues = (IF hSDOObjectType:SCREEN-VALUE <> ?                       THEN hSDOObjectType:SCREEN-VALUE                       ELSE "":U) + CHR(3) + 
            (IF DYNAMIC-FUNCTION("getDataValue":U IN hSDOProdMod) <> ? THEN DYNAMIC-FUNCTION("getDataValue":U IN hSDOProdMod) ELSE "":U) + CHR(3) + 
            (IF hSDOSuffix:SCREEN-VALUE <> ?                           THEN hSDOSuffix:SCREEN-VALUE                           ELSE "":U) + CHR(3) + 
            (IF hSDOSortOrder:SCREEN-VALUE <> ?                        THEN hSDOSortOrder:SCREEN-VALUE                        ELSE "":U) + CHR(3) + 
            (IF STRING(hSDOOverWrite:CHECKED) <> ?                     THEN STRING(hSDOOverWrite:CHECKED)                     ELSE "":U) + CHR(3) + 
            (IF STRING(hFollowJoins:CHECKED) <> ?                      THEN STRING(hFollowJoins:CHECKED)                      ELSE "":U) + CHR(3) + 
            (IF hAppServPart:SCREEN-VALUE <> ?                         THEN hAppServPart:SCREEN-VALUE                         ELSE "":U) + CHR(3) + 
            (IF hDlpObjectType:SCREEN-VALUE <> ?                       THEN hDlpObjectType:SCREEN-VALUE                       ELSE "":U) + CHR(3) + 
            (IF DYNAMIC-FUNCTION("getDataValue":U IN hDlpProdMod) <> ? THEN DYNAMIC-FUNCTION("getDataValue":U IN hDlpProdMod) ELSE "":U) + CHR(3) + 
            (IF hDlpSuffix:SCREEN-VALUE <> ?                           THEN hDlpSuffix:SCREEN-VALUE                           ELSE "":U) + CHR(3) + 
            (IF hDflObjectType:SCREEN-VALUE <> ?                       THEN hDflObjectType:SCREEN-VALUE                       ELSE "":U) + CHR(3) + 
            (IF DYNAMIC-FUNCTION("getDataValue":U IN hDflProdMod) <> ? THEN DYNAMIC-FUNCTION("getDataValue":U IN hDflProdMod) ELSE "":U) + CHR(3) + 
            (IF hSDBObjectType:SCREEN-VALUE <> ?                       THEN hSDBObjectType:SCREEN-VALUE                       ELSE "":U) + CHR(3) + 
            (IF DYNAMIC-FUNCTION("getDataValue":U IN hSDBProdMod) <> ? THEN DYNAMIC-FUNCTION("getDataValue":U IN hSDBProdMod) ELSE "":U) + CHR(3) + 
            (IF hSDBSuffix:SCREEN-VALUE <> ?                           THEN hSDBSuffix:SCREEN-VALUE                           ELSE "":U) + CHR(3) + 
            (IF hSDVObjectType:SCREEN-VALUE <> ?                       THEN hSDVObjectType:SCREEN-VALUE                       ELSE "":U) + CHR(3) + 
            (IF DYNAMIC-FUNCTION("getDataValue":U IN hSDVProdMod) <> ? THEN DYNAMIC-FUNCTION("getDataValue":U IN hSDVProdMod) ELSE "":U) + CHR(3) + 
            (IF hSDVSuffix:SCREEN-VALUE <> ?                           THEN hSDVSuffix:SCREEN-VALUE                           ELSE "":U). 
    
    /* build merged list */
    gcPrefData = DYNAMIC-FUNCTION("assignMappedEntry" IN target-procedure,
                   cEntries,           /* 18 Names         */
                   gcPrefData,         /* String to Change */
                   cValues,            /* 18 Vlaues        */
                   CHR(3),             /* Delimiter        */
                   TRUE).              /* Name then Value  */
    
  /* Store cProfile in repository */
  RUN setProfileData IN gshProfileManager (INPUT "General":U,       /* Profile type code */
                                           INPUT "Preference":U,    /* Profile code */
                                           INPUT "GenerateObjects", /* Profile data key */
                                           INPUT ?,                 /* Rowid of profile data */
                                           INPUT gcPrefData,        /* Profile data value */
                                           INPUT NO,                /* Delete flag */
                                           INPUT "PER":u).          /* Save flag (permanent) */
  
  {get containerSource hContainer}.
  hContainer = WIDGET-HANDLE(DYNAMIC-FUNCTION("getCallerProcedure":U IN hContainer)).
  IF VALID-HANDLE(hContainer) THEN
    PUBLISH "setPreferences":U FROM hContainer.

  {set DataModified FALSE}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-widgetValueChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE widgetValueChanged Procedure 
PROCEDURE widgetValueChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcWidgetName AS CHARACTER  NO-UNDO.

  {set DataModified TRUE}.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getFieldHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldHandle Procedure 
FUNCTION getFieldHandle RETURNS HANDLE
  ( pcFieldName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iEntry        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hFieldHandle  AS HANDLE     NO-UNDO.

  hFieldHandle = ?.

  iEntry = LOOKUP(pcFieldName,gcAllFieldNames).
  IF iEntry <> 0 THEN
    hFieldHandle = WIDGET-HANDLE(ENTRY(iEntry,gcAllFieldHandles)).

  RETURN hFieldHandle.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-retrieveValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION retrieveValue Procedure 
FUNCTION retrieveValue RETURNS CHARACTER
  ( pcAttr AS CHARACTER) :
    /*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cValue AS CHARACTER  FORMAT "X(100)":U NO-UNDO.

    cValue = DYNAMIC-FUNCTION("mappedEntry" IN target-procedure,
                             pcAttr,
                             gcPrefData,
                             TRUE,
                             CHR(3)).

    RETURN cValue.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDefaultValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDefaultValue Procedure 
FUNCTION setDefaultValue RETURNS LOGICAL
  ( pcAttribute AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCombo    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cProdMod  AS CHARACTER  NO-UNDO.

  CASE pcAttribute:
    WHEN "SDOTYPE"    THEN
      hSDOObjectType:SCREEN-VALUE = hSDOObjectType:ENTRY(1).
    WHEN "SDOPM"      THEN DO:
      {get ComboHandle hCombo hSDOProdMod}.
      cProdMod = ENTRY(2,hCombo:LIST-ITEM-PAIRS,hCombo:DELIMITER).
      DYNAMIC-FUNCTION("setDataValue":U IN hSDOProdMod, cProdMod).
    END.
    WHEN "SDOSUFFIX"  THEN
      hSDOSuffix:SCREEN-VALUE = "fullo":U.
    WHEN "DLPTYPE"    THEN
      hDlpObjectType:SCREEN-VALUE = hDlpObjectType:ENTRY(1).
    WHEN "DLPPM"      THEN DO:
      {get ComboHandle hCombo hDlpProdMod}.
      cProdMod = ENTRY(2,hCombo:LIST-ITEM-PAIRS,hCombo:DELIMITER).
      DYNAMIC-FUNCTION("setDataValue":U IN hDlpProdMod, cProdMod).
    END.
    WHEN "DLPSUFFIX"  THEN
      hDlpSuffix:SCREEN-VALUE = "logcp.p":U.
    WHEN "SDVTYPE"    THEN
      hSDVObjectType:SCREEN-VALUE = hSDVObjectType:ENTRY(1).
    WHEN "SDVPM"      THEN DO:
      {get ComboHandle hCombo hSDVProdMod}.
      cProdMod = ENTRY(2,hCombo:LIST-ITEM-PAIRS,hCombo:DELIMITER).
      {set DataValue cProdMod hSDVProdMod}.
    END.
    WHEN "SDVSUFFIX"  THEN
      hSDVSuffix:SCREEN-VALUE = "viewv":U.
    WHEN "SDBTYPE"    THEN
      hSDBObjectType:SCREEN-VALUE = hSDBObjectType:ENTRY(1).
    WHEN "SDBPM"      THEN DO:
      {get ComboHandle hCombo hSDBProdMod}.
      cProdMod = ENTRY(2,hCombo:LIST-ITEM-PAIRS,hCombo:DELIMITER).
      {set DataValue cProdMod hSDBProdMod}.
    END.
    WHEN "SDBSUFFIX"  THEN
      hSDBSuffix:SCREEN-VALUE = "fullb":U.
    WHEN "DFLTYPE"    THEN
      hDflObjectType:SCREEN-VALUE = hDflObjectType:ENTRY(1).
    WHEN "DFLPM"      THEN DO:
      {get ComboHandle hCombo hDflProdMod}.
      cProdMod = ENTRY(2,hCombo:LIST-ITEM-PAIRS,hCombo:DELIMITER).
      {set DataValue cProdMod hDflProdMod}.
    END.
    WHEN "SDOAPSPART" THEN
      hAppServPart:SCREEN-VALUE = hAppServPart:ENTRY(1).
    WHEN "SDOSORT"    THEN
      hSDOSortOrder:SCREEN-VALUE = "Order":U.
    WHEN "SDOFOLLOW"  THEN
      hFollowJoins:CHECKED = TRUE.
    WHEN "SDOOVRWRT"  THEN
      hSDOOverWrite:CHECKED = TRUE.
  END CASE.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

