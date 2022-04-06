&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
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
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: rycavupdtp.p

  Description:  Attribute Value Update Procedure

  Purpose:      Attribute Value Update Procedure

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:   0           UserRef:    
                Date:   dd/mm/yyyy  Author:     

  Update Notes: 

  (v:010001)    Task:           0   UserRef:    
                Date:   10/30/2001  Author:     Mark Davies (MIP)

  Update Notes: Created from Template rytemprocp.p

  (v:010002)    Task:           0   UserRef:    
                Date:   11/19/2001  Author:     Mark Davies (MIP)

  Update Notes: Assigning of new attributes didn't create the new attribute values correctly.

-------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rycavupdtp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{afglobals.i}
{afcheckerr.i &define-only = YES}
{afrun2.i     &define-only = YES}

{ry/inc/rycavtempt.i}

DEFINE INPUT  PARAMETER pcLogFileName   AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcADODir        AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER plAppendToFile  AS LOGICAL    NO-UNDO.
DEFINE INPUT  PARAMETER phWindowHandle  AS HANDLE     NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR ttAttributeOptions.
DEFINE INPUT  PARAMETER TABLE FOR ttObjects.
DEFINE OUTPUT PARAMETER pcError         AS CHARACTER  NO-UNDO.

DEFINE VARIABLE lGenerateADO AS LOGICAL    NO-UNDO.
DEFINE STREAM stOut.

DEFINE TEMP-TABLE ttCheckOut NO-UNDO
  FIELDS dSmartObjectObj  AS DECIMAL
  FIELDS cObjectFileName  AS CHARACTER
  FIELDS lCheckedOut      AS LOGICAL
  INDEX  idx1             AS PRIMARY UNIQUE dSmartObjectObj.

DEFINE TEMP-TABLE ttGenerateADO NO-UNDO
  FIELDS dSmartObjectObj  AS DECIMAL
  FIELDS cObjectFileName  AS CHARACTER
  INDEX  idx1             AS PRIMARY UNIQUE dSmartObjectObj.

/* This section is included for exporting .ADO files */

/* The following include contains the replaceCtrlChar function */
{afxmlreplctrl.i}
{af/app/afdatatypi.i}

/* ttRequiredRecord contains the list of parameters that decide how the 
   XML file is written out. */
DEFINE TEMP-TABLE ttRequiredRecord NO-UNDO {&RCodeInfo}
  FIELD iSequence       AS INTEGER   
  FIELD cJoinFieldValue AS CHARACTER FORMAT "X(50)":U
  INDEX pudx IS UNIQUE PRIMARY
    iSequence
  .

DEFINE TEMP-TABLE ttExportParam NO-UNDO
  FIELD cParam             AS CHARACTER
  FIELD cValue             AS CHARACTER
  INDEX dx IS PRIMARY
    cParam
  .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-FormatAttributeValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD FormatAttributeValue Procedure 
FUNCTION FormatAttributeValue RETURNS CHARACTER
    ( INPUT pcAttributeTypeTLA      AS CHARACTER,
      INPUT pcAttributeValue        AS CHARACTER    )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPathedFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPathedFile Procedure 
FUNCTION getPathedFile RETURNS CHARACTER
  ( INPUT pdSmartObjectObj AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-replaceExt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD replaceExt Procedure 
FUNCTION replaceExt RETURNS LOGICAL
  ( INPUT pcFileName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 19.33
         WIDTH              = 58.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* First we want to validate the data in the temp-table */
RUN validateData.
/* If we had some validation errors - return and report the error */
IF pcError <> "":U THEN
  RETURN.

/* Disable the Triggers */
ON WRITE OF ryc_attribute_value OVERRIDE DO: END.

EMPTY TEMP-TABLE ttCheckOut.
EMPTY TEMP-TABLE ttGenerateADO.

DEFINE FRAME F-OUTPUT
  ttAttributeOptions.cAction               LABEL "Action"                 COLON 20 FORMAT "X(10)":U
  ttAttributeOptions.cAttributeLabel       LABEL "Attribute Label"        COLON 20 FORMAT "X(20)":U
  ttAttributeOptions.cNewAttributeLabel    LABEL "New Attribute Label"    COLON 20 FORMAT "X(20)":U
  "Attribute Value:" TO 20                                               
  ttAttributeOptions.cAttributeValue       VIEW-AS EDITOR SIZE 55 BY 4    NO-LABEL 
  SKIP(1)
  ttAttributeOptions.lSetInheritedNo       LABEL "Set Inherited No"       COLON 20 FORMAT "YES/NO":U
  ttAttributeOptions.lOverrideValues       LABEL "Override Values"        COLON 20 FORMAT "YES/NO":U
  ttAttributeOptions.lGenerateADO          LABEL "Generate ADOs"          COLON 20 FORMAT "YES/NO":U
  ttAttributeOptions.lCheckOutObject       LABEL "Check Out (SCM)"        COLON 20 FORMAT "YES/NO":U
  SKIP(1)
  ttAttributeOptions.lUpdateTypes          LABEL "Object Types"           COLON 20 FORMAT "YES/NO":U
  ttAttributeOptions.lUpdateObject         LABEL "Object Masters"         COLON 48 FORMAT "YES/NO":U
  ttAttributeOptions.lUpdateObjectInstance LABEL "Object Instances"       TO 76    FORMAT "YES/NO":U
  SKIP(2)
  WITH SIDE-LABELS STREAM-IO NO-BOX WIDTH 80.
  
IF plAppendToFile THEN DO:
  OUTPUT STREAM stOut TO VALUE(pcLogFileName) APPEND PAGED.
  PAGE STREAM stOut.
END.
ELSE
  OUTPUT STREAM stOut TO VALUE(pcLogFileName) PAGED.
PUT UNFORMATTED "Attribute Value Update Started on " STRING(TODAY,"99/99/9999":U) " @ " STRING(TIME,"HH:MM:SS":U) SKIP(2).

lGenerateADO = FALSE.
FOR EACH ttAttributeOptions
    NO-LOCK:
  DISPLAY STREAM stOut
    ttAttributeOptions.cAction               
    ttAttributeOptions.cAttributeLabel       
    ttAttributeOptions.cNewAttributeLabel    
    ttAttributeOptions.cAttributeValue       
    ttAttributeOptions.lUpdateTypes          
    ttAttributeOptions.lUpdateObject         
    ttAttributeOptions.lUpdateObjectInstance 
    ttAttributeOptions.lSetInheritedNo       
    ttAttributeOptions.lOverrideValues       
    ttAttributeOptions.lGenerateADO          
    ttAttributeOptions.lCheckOutObject       
    WITH FRAME F-OUTPUT.
    
  RUN viewLogMessage (INPUT "Starting process for - " + ttAttributeOptions.cAttributeLabel + " @ ":U + STRING(TIME,"HH:MM:SS":U) + " ON ":U + STRING(TODAY,"99/99/9999":U)).
  
  CASE ttAttributeOptions.cAction:
    WHEN "ASSIGN" THEN
      RUN assignAttributeValues (INPUT ttAttributeOptions.cAttributeLabel,
                                 INPUT ttAttributeOptions.cAttributeValue,
                                 INPUT ttAttributeOptions.dObjectTypeObj,
                                 INPUT ttAttributeOptions.lSetInheritedNo,
                                 INPUT ttAttributeOptions.lOverrideValues,
                                 INPUT ttAttributeOptions.lUpdateTypes,
                                 INPUT ttAttributeOptions.lUpdateObject,
                                 INPUT ttAttributeOptions.lUpdateObjectInstance).
    WHEN "RENAME" THEN
      RUN renameAttribute (INPUT ttAttributeOptions.cAttributeLabel,
                           INPUT ttAttributeOptions.cNewAttributeLabel,
                           INPUT ttAttributeOptions.dObjectTypeObj,
                           INPUT ttAttributeOptions.lUpdateTypes,
                           INPUT ttAttributeOptions.lUpdateObject,
                           INPUT ttAttributeOptions.lUpdateObjectInstance).
    WHEN "DELETE" THEN
      RUN deleteAttributeValues (INPUT ttAttributeOptions.cAttributeLabel,
                                 INPUT ttAttributeOptions.dObjectTypeObj,
                                 INPUT ttAttributeOptions.lUpdateTypes,
                                 INPUT ttAttributeOptions.lUpdateObject,
                                 INPUT ttAttributeOptions.lUpdateObjectInstance).
  END CASE.
  
  IF pcError <> "":U THEN
    RETURN.
    
  IF ttAttributeOptions.lGenerateADO THEN DO:
    lGenerateADO = TRUE.
    RUN viewLogMessage (INPUT "Creating list of objects to regenerate ADO's for " + ttAttributeOptions.cAttributeLabel + " @ ":U + STRING(TIME,"HH:MM:SS":U) + " ON ":U + STRING(TODAY,"99/99/9999":U)).
    RUN createADOObjects (INPUT ttAttributeOptions.cAttributeLabel).
  END.
END.
IF lGenerateADO THEN DO:
  RUN viewLogMessage (INPUT "Regeneration of object ADO's started @ ":U + STRING(TIME,"HH:MM:SS":U) + " ON ":U + STRING(TODAY,"99/99/9999":U)).
  RUN exportADOs.
END.

RUN viewLogMessage (INPUT "Attribute Value Update Completed on " + STRING(TODAY,"99/99/9999":U) + " @ " + STRING(TIME,"HH:MM:SS":U)).

OUTPUT STREAM stOut CLOSE.

ON WRITE OF ryc_attribute_value REVERT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-assignAttributeValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignAttributeValues Procedure 
PROCEDURE assignAttributeValues :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will create/assign attribute values for the selected
               levels and objects.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcAttributeLabel       AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcAttributeValue       AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pdObjectTypeObj        AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plOverrideValues       AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plUpdateTypes          AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plUpdateObject         AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plUpdateObjectInstance AS LOGICAL    NO-UNDO.
  
  DEFINE VARIABLE lNewRecord  AS LOGICAL    NO-UNDO.

  DEFINE BUFFER bfryc_attribute FOR ryc_attribute.

  FIND FIRST bfryc_attribute
       WHERE bfryc_attribute.attribute_label = pcAttributeLabel
       NO-LOCK NO-ERROR.
  /* The validation should have taken care if this - just in case */
  IF NOT AVAILABLE bfryc_attribute THEN
    RETURN.
    
  /* Object Types */
  tran-block:
  DO TRANSACTION:
    IF plUpdateTypes THEN DO:
      FOR EACH  gsc_object_type
          WHERE (IF pdObjectTypeObj <> 0 THEN gsc_object_type.object_type_obj = pdObjectTypeObj ELSE TRUE)
          NO-LOCK:
        lNewRecord = FALSE.
        FIND FIRST ryc_attribute_value
             WHERE ryc_attribute_value.object_type_obj           = gsc_object_type.object_type_obj
             AND   ryc_attribute_value.container_smartobject_obj = 0
             AND   ryc_attribute_value.smartobject_obj           = 0
             AND   ryc_attribute_value.attribute_label           = bfryc_attribute.attribute_label
             EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE ryc_attribute_value THEN DO:
          /* Create New Attribute Value Record */
          CREATE ryc_attribute_value NO-ERROR.
          {afcheckerr.i &no-return = YES}    
          pcError = cMessageList.
          IF pcError <> "":U THEN UNDO tran-block, LEAVE tran-block.
          /* Assign Values */
          ASSIGN ryc_attribute_value.object_type_obj             = gsc_object_type.object_type_obj
                 ryc_attribute_value.container_smartobject_obj   = 0                              
                 ryc_attribute_value.smartobject_obj             = 0                              
                 ryc_attribute_value.constant_value              = FALSE
                 ryc_attribute_value.attribute_label             = bfryc_attribute.attribute_label
                 NO-ERROR.
            {afcheckerr.i &no-return = YES}    
            pcError = cMessageList.
            IF pcError <> "":U THEN UNDO tran-block, LEAVE tran-block.
            
            /* Validate the record */
            VALIDATE ryc_attribute_value NO-ERROR.
            {afcheckerr.i &no-return = YES}    
            pcError = cMessageList.
            IF pcError <> "":U THEN UNDO tran-block, LEAVE tran-block.
            RUN viewLogMessage (INPUT "Added new Attribute Value - " + ryc_attribute_value.attribute_label + " for Object Type - " + gsc_object_type.object_type_code).
            lNewRecord = TRUE.
        END.
        IF plOverrideValues OR 
           lNewRecord THEN DO:
          CASE bfryc_attribute.data_type:
            WHEN {&DECIMAL-DATA-TYPE}   THEN ryc_attribute_value.decimal_value   = DECIMAL(pcAttributeValue) NO-ERROR.
            WHEN {&INTEGER-DATA-TYPE}   THEN ryc_attribute_value.integer_value   = INTEGER(pcAttributeValue) NO-ERROR.
            WHEN {&DATE-DATA-TYPE}      THEN ryc_attribute_value.date_value      =    DATE(pcAttributeValue) NO-ERROR.
            WHEN {&RAW-DATA-TYPE}       THEN.
            WHEN {&LOGICAL-DATA-TYPE}   THEN ryc_attribute_value.logical_value   = (IF pcAttributeValue = "TRUE":U OR
                                                                                       pcAttributeValue = "YES":U  THEN TRUE ELSE FALSE) NO-ERROR.
            WHEN {&CHARACTER-DATA-TYPE} THEN ryc_attribute_value.character_value = pcAttributeValue NO-ERROR.
          END CASE.

          IF ERROR-STATUS:ERROR THEN
          DO:
              pcError = "Error assigning attribute value for " + ryc_attribute_value.attribute_label.
              UNDO tran-block, LEAVE tran-block.
          END.

          VALIDATE ryc_attribute_value NO-ERROR.
          {afcheckerr.i &no-return = YES}    
          pcError = cMessageList.
          IF pcError <> "":U THEN UNDO tran-block, LEAVE tran-block.
          RUN viewLogMessage (INPUT "Assigned New Attribute Value - " + ryc_attribute_value.attribute_label + " for Object Type - " + gsc_object_type.object_type_code + " to " + pcAttributeValue).
        END.
      END. /* gsc_object_type */
    END. /* plUpdateTypes */
    
    /* Object Masters */
    IF plUpdateObject THEN DO:
      FOR EACH  ttObjects
          WHERE ttObjects.cAttributeLabel = pcAttributeLabel
          NO-LOCK:
        FIND FIRST ryc_attribute_value
             WHERE ryc_attribute_value.object_type_obj           = ttObjects.dObjectTypeObj
             AND   ryc_attribute_value.container_smartobject_obj = 0
             AND   ryc_attribute_value.smartobject_obj           = ttObjects.dSmartObjectObj
             AND   ryc_attribute_value.attribute_label           = bfryc_attribute.attribute_label
             AND   ryc_attribute_value.primary_smartobject_obj   = ttObjects.dSmartObjectObj
             EXCLUSIVE-LOCK NO-ERROR.

        IF NOT AVAILABLE ryc_attribute_value THEN DO:
          /* Create New Attribute Value Record */
          CREATE ryc_attribute_value NO-ERROR.
          {afcheckerr.i &no-return = YES}    
          pcError = cMessageList.
          IF pcError <> "":U THEN UNDO tran-block, LEAVE tran-block.
          /* Assign Values */
          ASSIGN ryc_attribute_value.object_type_obj             = ttObjects.dObjectTypeObj 
                 ryc_attribute_value.container_smartobject_obj   = 0                        
                 ryc_attribute_value.smartobject_obj             = ttObjects.dSmartObjectObj
                 ryc_attribute_value.primary_smartobject_obj     = ttObjects.dSmartObjectObj
                 ryc_attribute_value.constant_value              = FALSE
                 ryc_attribute_value.attribute_label             = bfryc_attribute.attribute_label
                 NO-ERROR.
            {afcheckerr.i &no-return = YES}    
            pcError = cMessageList.
            IF pcError <> "":U THEN UNDO tran-block, LEAVE tran-block.
            
            /* Validate the record */
            VALIDATE ryc_attribute_value NO-ERROR.
            {afcheckerr.i &no-return = YES}    
            pcError = cMessageList.
            IF pcError <> "":U THEN UNDO tran-block, LEAVE tran-block.
            RUN viewLogMessage (INPUT "Added new Attribute Value - " + ryc_attribute_value.attribute_label + " for Object Master - " + ttObjects.cObjectFileName).
            lNewRecord = TRUE.
        END.
        IF plOverrideValues OR 
           lNewRecord THEN DO:
          CASE bfryc_attribute.data_type:
            WHEN {&DECIMAL-DATA-TYPE}   THEN ryc_attribute_value.decimal_value   = DECIMAL(pcAttributeValue) NO-ERROR.
            WHEN {&INTEGER-DATA-TYPE}   THEN ryc_attribute_value.integer_value   = INTEGER(pcAttributeValue) NO-ERROR.
            WHEN {&DATE-DATA-TYPE}      THEN ryc_attribute_value.date_value      =    DATE(pcAttributeValue) NO-ERROR.
            WHEN {&RAW-DATA-TYPE}       THEN.
            WHEN {&LOGICAL-DATA-TYPE}   THEN ryc_attribute_value.logical_value   = (IF pcAttributeValue = "TRUE":U OR
                                                                                       pcAttributeValue = "YES":U  THEN TRUE ELSE FALSE) NO-ERROR.
            WHEN {&CHARACTER-DATA-TYPE} THEN ryc_attribute_value.character_value = pcAttributeValue NO-ERROR.
          END CASE.

          IF ERROR-STATUS:ERROR THEN
            DO:
                pcError = "Error assigning attribute value for " + ryc_attribute_value.attribute_label.
                UNDO tran-block, LEAVE tran-block.
            END.

          VALIDATE ryc_attribute_value NO-ERROR.
          {afcheckerr.i &no-return = YES}    
          pcError = cMessageList.
          IF pcError <> "":U THEN UNDO tran-block, LEAVE tran-block.
          RUN viewLogMessage (INPUT "Assigned Attribute Value - " + ryc_attribute_value.attribute_label + " for Object Master - " + ttObjects.cObjectFileName).
        END.
      END. /* ttObjects */
    END. /* plUpdateObject */
  
    /* Object Instance */
    IF plUpdateObjectInstance THEN DO:
      FOR EACH  ttObjects
          WHERE ttObjects.cAttributeLabel = pcAttributeLabel
          NO-LOCK:
          FOR EACH  ryc_object_instance
              WHERE ryc_object_instance.smartobject_obj = ttObjects.dSmartObjectObj
              NO-LOCK:
          /* Make sure we regenerate the .ado for the master object too */
          IF NOT CAN-FIND(FIRST ttGenerateADO
                          WHERE ttGenerateADO.dSmartObjectObj = ryc_object_instance.container_smartobject_obj) THEN DO:
            FIND FIRST ryc_smartobject
                 WHERE ryc_smartobject.smartobject_obj = ryc_object_instance.container_smartobject_obj
                 NO-LOCK NO-ERROR.
            CREATE ttGenerateADO.
            ASSIGN ttGenerateADO.dSmartObjectObj = ryc_object_instance.container_smartobject_obj 
                   ttGenerateADO.cObjectFileName = IF AVAILABLE ryc_smartobject THEN ryc_smartobject.object_filename ELSE "UNKNOWN":U.
          END.
          FIND FIRST ryc_attribute_value
               WHERE ryc_attribute_value.object_type_obj           = ttObjects.dObjectTypeObj
               AND   ryc_attribute_value.container_smartobject_obj = ryc_object_instance.container_smartobject_obj
               AND   ryc_attribute_value.smartobject_obj           = ttObjects.dSmartObjectObj
               AND   ryc_attribute_value.attribute_label           = bfryc_attribute.attribute_label
               AND   ryc_attribute_value.primary_smartobject_obj   = ryc_object_instance.container_smartobject_obj
               EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE ryc_attribute_value THEN DO:
            /* Create New Attribute Value Record */
            CREATE ryc_attribute_value NO-ERROR.
            {afcheckerr.i &no-return = YES}    
            pcError = cMessageList.
            IF pcError <> "":U THEN UNDO tran-block, LEAVE tran-block.

            /* Assign Values */
            ASSIGN ryc_attribute_value.object_type_obj             = ttObjects.dObjectTypeObj 
                   ryc_attribute_value.container_smartobject_obj   = ryc_object_instance.container_smartobject_obj
                   ryc_attribute_value.smartobject_obj             = ttObjects.dSmartObjectObj
                   ryc_attribute_value.primary_smartobject_obj     = ryc_object_instance.container_smartobject_obj
                   ryc_attribute_value.constant_value              = FALSE
                   ryc_attribute_value.attribute_label             = bfryc_attribute.attribute_label
                   ryc_attribute_value.object_instance_obj         = ryc_object_instance.object_instance_obj
                   NO-ERROR.
              {afcheckerr.i &no-return = YES}    
              pcError = cMessageList.
              IF pcError <> "":U THEN UNDO tran-block, LEAVE tran-block.
              
              /* Validate the record */
              VALIDATE ryc_attribute_value NO-ERROR.
              {afcheckerr.i &no-return = YES}    
              pcError = cMessageList.
              IF pcError <> "":U THEN UNDO tran-block, LEAVE tran-block.
              RUN viewLogMessage (INPUT "Added new Attribute Value - " + ryc_attribute_value.attribute_label + " for Object Instance of - " + ttObjects.cObjectFileName).
              lNewRecord = TRUE.
          END.
          IF plOverrideValues OR 
              lNewRecord THEN DO:
              CASE bfryc_attribute.data_type:
                WHEN {&DECIMAL-DATA-TYPE}   THEN ryc_attribute_value.decimal_value   = DECIMAL(pcAttributeValue) NO-ERROR.
                WHEN {&INTEGER-DATA-TYPE}   THEN ryc_attribute_value.integer_value   = INTEGER(pcAttributeValue) NO-ERROR.
                WHEN {&DATE-DATA-TYPE}      THEN ryc_attribute_value.date_value      =    DATE(pcAttributeValue) NO-ERROR.
                WHEN {&RAW-DATA-TYPE}       THEN.
                WHEN {&LOGICAL-DATA-TYPE}   THEN ryc_attribute_value.logical_value   = (IF pcAttributeValue = "TRUE":U OR
                                                                                           pcAttributeValue = "YES":U  THEN TRUE ELSE FALSE) NO-ERROR.
                WHEN {&CHARACTER-DATA-TYPE} THEN ryc_attribute_value.character_value = pcAttributeValue NO-ERROR.
              END CASE.
  
              IF ERROR-STATUS:ERROR THEN
              DO:
                  pcError = "Error assigning attribute value for " + ryc_attribute_value.attribute_label.
                  UNDO tran-block, LEAVE tran-block.
              END.

            VALIDATE ryc_attribute_value NO-ERROR.
            {afcheckerr.i &no-return = YES}    
            pcError = cMessageList.
            IF pcError <> "":U THEN UNDO tran-block, LEAVE tran-block.
            RUN viewLogMessage (INPUT "Assigned Attribute Value - " + ryc_attribute_value.attribute_label + " for Object Instance of - " + ttObjects.cObjectFileName).
          END.
        END. /* ryc_object_instance */
      END. /* ttObjects */
    END. /* plUpdateObject */
  
  END. /* TRANSACTION */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createADOObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createADOObjects Procedure 
PROCEDURE createADOObjects :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will create a temp-table containing objects whose
               .ADO files must be created.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcAttributeLabel  AS CHARACTER  NO-UNDO.

  FOR EACH  ttObjects
      WHERE ttObjects.cAttributeLabel = pcAttributeLabel
      NO-LOCK:
    IF NOT CAN-FIND(FIRST ttGenerateADO
                    WHERE ttGenerateADO.dSmartObjectObj = ttObjects.dSmartObjectObj) THEN DO:
      CREATE ttGenerateADO.
      ASSIGN ttGenerateADO.dSmartObjectObj = ttObjects.dSmartObjectObj 
             ttGenerateADO.cObjectFileName = ttObjects.cObjectFileName.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteAttributeValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteAttributeValues Procedure 
PROCEDURE deleteAttributeValues :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will delete attribute values for the selected
               levels and objects.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcAttributeLabel       AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pdObjectTypeObj        AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plUpdateTypes          AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plUpdateObject         AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plUpdateObjectInstance AS LOGICAL    NO-UNDO.
  
  /* Object Types */
  tran-block:
  DO TRANSACTION:
    /* If we delete it from the object type we have to do it for the
       object master and the instances too. There is no option here */
    IF plUpdateTypes THEN DO:
      FOR EACH ryc_attribute_value
          WHERE ryc_attribute_value.object_type_obj = pdObjectTypeObj
          AND   ryc_attribute_value.attribute_label = pcAttributeLabel
          EXCLUSIVE-LOCK,
          FIRST gsc_object_type WHERE
                gsc_object_type.object_type_obj = ryc_attribute_value.object_type_obj
                NO-LOCK :
          /* Delete the record */
          DELETE ryc_attribute_value NO-ERROR.
          {afcheckerr.i &no-return = YES}    
          pcError = cMessageList.
          IF pcError <> "":U THEN UNDO tran-block, LEAVE tran-block.
          
          FIND FIRST ryc_smartobject
               WHERE ryc_smartobject.smartobject_obj = ryc_attribute_value.container_smartobject_obj
               NO-LOCK NO-ERROR.
          IF NOT AVAILABLE ryc_smartobject THEN
            FIND FIRST ryc_smartobject
                 WHERE ryc_smartobject.smartobject_obj = ryc_attribute_value.smartobject_obj
                 NO-LOCK NO-ERROR.
          IF AVAILABLE ryc_smartobject THEN
            IF ryc_attribute_value.container_smartobject_obj = 0 THEN
              RUN viewLogMessage (INPUT "Deleted Attribute Value for " + pcAttributeLabel + " for Object Master - " + ryc_smartobject.object_filename).
            ELSE
              RUN viewLogMessage (INPUT "Deleted Attribute Value for " + pcAttributeLabel + " for Object Instance on - " + ryc_smartobject.object_filename).
          ELSE
            RUN viewLogMessage (INPUT "Deleted Attribute Value for " + pcAttributeLabel + " for Object Type - " + gsc_object_type.object_type_code).
      END.
    END.
    ELSE DO:
      /* If we delete it from the object master we have to do it for the
         the instances too. There is no option here */
      IF plUpdateObject THEN DO:
        FOR EACH  ttObjects
            WHERE ttObjects.cAttributeLabel = pcAttributeLabel
            NO-LOCK:
          FOR EACH  ryc_attribute_value
              WHERE ryc_attribute_value.object_type_obj = ttObjects.dObjectTypeObj
              AND   ryc_attribute_value.smartobject_obj = ttObjects.dSmartObjectObj
              AND   ryc_attribute_value.attribute_label = pcAttributeLabel
              EXCLUSIVE-LOCK:
            /* Delete the record */
            DELETE ryc_attribute_value NO-ERROR.
            {afcheckerr.i &no-return = YES}    
            pcError = cMessageList.
            IF pcError <> "":U THEN UNDO tran-block, LEAVE tran-block.
            
            IF ryc_attribute_value.container_smartobject_obj = 0 THEN
              RUN viewLogMessage (INPUT "Deleted Attribute Value for " + pcAttributeLabel + " for Object Master - " + ttObjects.cObjectFilename).
            ELSE
              RUN viewLogMessage (INPUT "Deleted Attribute Value for " + pcAttributeLabel + " for Object Instance of - " + ttObjects.cObjectFilename).
          END. /* EACH ryc_attribute_value */
        END. /* ttObjects */
      END. /* plUpdateObject */
      ELSE DO:
        IF plUpdateObjectInstance THEN DO:
          FOR EACH  ttObjects
              WHERE ttObjects.cAttributeLabel = pcAttributeLabel
              NO-LOCK:
            FOR EACH  ryc_attribute_value
                WHERE ryc_attribute_value.object_type_obj            = ttObjects.dObjectTypeObj
                AND   ryc_attribute_value.smartobject_obj            = ttObjects.dSmartObjectObj
                AND   ryc_attribute_value.container_smartobject_obj <> 0
                AND   ryc_attribute_value.attribute_label            = pcAttributeLabel
                EXCLUSIVE-LOCK:
              /* Delete the record */
              DELETE ryc_attribute_value NO-ERROR.
              {afcheckerr.i &no-return = YES}    
              pcError = cMessageList.
              IF pcError <> "":U THEN UNDO tran-block, LEAVE tran-block.
              RUN viewLogMessage (INPUT "Deleted Attribute Value for " + pcAttributeLabel + " for Object Instance of - " + ttObjects.cObjectFilename).
            END. /* EACH ryc_attribute_value */
          END. /* ttObjects */
        END. /* plUpdateObjectInstance */
      END. /* ELSE - Not Master Objects */
    END. /* ELSE - NOT Object Type */
  END. /* TRANSACTION */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-exportADOs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exportADOs Procedure 
PROCEDURE exportADOs :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will read through the list of objects to be created
               and export their .ADO files
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cPathedFile AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE mptr        AS MEMPTR     NO-UNDO.
  DEFINE VARIABLE cRetVal     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDirName    AS CHARACTER  NO-UNDO.
  
  FOR EACH ttGenerateADO
      NO-LOCK:
    cPathedFile = getPathedFile(ttGenerateADO.dSmartObjectObj).
    IF cPathedFile <> "":U AND
       cPathedFile <> ?    AND 
       NOT cPathedFile BEGINS "**":U THEN DO:
      cDirName = SUBSTRING(cPathedFile,1,R-INDEX(cPathedFile,"/":U) - 1).
      OS-COMMAND SILENT VALUE("mkdir " + cDirName).
       cPathedFile = REPLACE(cPathedFile,(pcADODir + "/":U),"":U).
      {aflaunch.i &PLIP = 'af/app/gscddxmlp.p'
                        &IProc = 'writeDeploymentDataset'
                        &OnApp = 'NO'
                        &PList = "(INPUT 'RYCSO', ttGenerateADO.cObjectFileName, cPathedFile,pcADODir,YES,NO,INPUT TABLE ttExportParam,INPUT TABLE ttRequiredRecord,OUTPUT cRetVal)" 
                        &AutoKill = YES}

      IF cRetVal <> "":U THEN
        RUN viewLogMessage (INPUT "Error occurred while trying to export .ADO file for object - " + ttGenerateADO.cObjectFileName + CHR(13) + cRetVal).
      ELSE
        RUN viewLogMessage (INPUT "Exported " + cPathedFile + " for object - " + ttGenerateADO.cObjectFileName).
    END.
    ELSE DO:
      IF cPathedFile BEGINS "**":U THEN
        RUN viewLogMessage (INPUT cPathedFile + ttGenerateADO.cObjectFileName).
      ELSE
        RUN viewLogMessage (INPUT "Could not build relative path for object - " +  ttGenerateADO.cObjectFileName).
    END.
  END.
      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-renameAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE renameAttribute Procedure 
PROCEDURE renameAttribute :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will rename current attributes for the selected
               levels and objects.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcAttributeLabel       AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcNewAttributeLabel    AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pdObjectTypeObj        AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plUpdateTypes          AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plUpdateObject         AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plUpdateObjectInstance AS LOGICAL    NO-UNDO.

  FIND FIRST ryc_attribute
       WHERE ryc_attribute.attribute_label = pcNewAttributeLabel
       NO-LOCK NO-ERROR.
  /* The validation should have taken care if this - just in case */
  IF NOT AVAILABLE ryc_attribute THEN
    RETURN.
    
  /* Object Types */
  tran-block:
  DO TRANSACTION:
    IF plUpdateTypes THEN DO:
      FOR EACH  gsc_object_type
          WHERE (IF pdObjectTypeObj <> 0 THEN gsc_object_type.object_type_obj = pdObjectTypeObj ELSE TRUE)
          NO-LOCK:
        FIND FIRST ryc_attribute_value
             WHERE ryc_attribute_value.object_type_obj           = gsc_object_type.object_type_obj
             AND   ryc_attribute_value.container_smartobject_obj = 0
             AND   ryc_attribute_value.smartobject_obj           = 0
             AND   ryc_attribute_value.attribute_label           = pcAttributeLabel
             EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE ryc_attribute_value THEN DO:
          ASSIGN ryc_attribute_value.attribute_label     = ryc_attribute.attribute_label
                 NO-ERROR.
            {afcheckerr.i &no-return = YES}    
            pcError = cMessageList.
            IF pcError <> "":U THEN UNDO tran-block, LEAVE tran-block.
            
            /* Validate the record */
            VALIDATE ryc_attribute_value NO-ERROR.
            {afcheckerr.i &no-return = YES}    
            pcError = cMessageList.
            IF pcError <> "":U THEN UNDO tran-block, LEAVE tran-block.
            RUN viewLogMessage (INPUT "Renamed Attribute Label from " + pcAttributeLabel + " to " + pcNewAttributeLabel + " for Object Type - " + gsc_object_type.object_type_code).
        END.
      END.
    END.
    
    /* Object Masters */
    IF plUpdateObject THEN DO:
      FOR EACH  ttObjects
          WHERE ttObjects.cAttributeLabel = pcAttributeLabel
          NO-LOCK:
        FIND FIRST ryc_attribute_value
             WHERE ryc_attribute_value.object_type_obj           = ttObjects.dObjectTypeObj
             AND   ryc_attribute_value.container_smartobject_obj = 0
             AND   ryc_attribute_value.smartobject_obj           = ttObjects.dSmartObjectObj
             AND   ryc_attribute_value.attribute_label           = pcAttributeLabel
             EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE ryc_attribute_value THEN DO:
          ASSIGN ryc_attribute_value.attribute_label     = ryc_attribute.attribute_label
                 NO-ERROR.
          {afcheckerr.i &no-return = YES}    
          pcError = cMessageList.
          IF pcError <> "":U THEN UNDO tran-block, LEAVE tran-block.
          
          /* Validate the record */
          VALIDATE ryc_attribute_value NO-ERROR.
          {afcheckerr.i &no-return = YES}    
          pcError = cMessageList.
          IF pcError <> "":U THEN UNDO tran-block, LEAVE tran-block.
          RUN viewLogMessage (INPUT "Renamed Attribute Label from " + pcAttributeLabel + " to " + pcNewAttributeLabel + " for Object " + ttObjects.cObjectFileName).
        END. /* AVAILABLE */
      END. /* ttObjects */
    END. /* plUpdateObject */
  
  
    IF plUpdateObjectInstance THEN DO:
      FOR EACH  ttObjects
          WHERE ttObjects.cAttributeLabel = pcAttributeLabel
          NO-LOCK:
        FIND FIRST ryc_attribute_value
             WHERE ryc_attribute_value.object_type_obj            = ttObjects.dObjectTypeObj
             AND   ryc_attribute_value.container_smartobject_obj <> 0
             AND   ryc_attribute_value.smartobject_obj            = ttObjects.dSmartObjectObj
             AND   ryc_attribute_value.attribute_label            = pcAttributeLabel
             EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE ryc_attribute_value THEN DO:
          ASSIGN ryc_attribute_value.attribute_label     = ryc_attribute.attribute_label
                 NO-ERROR.
          {afcheckerr.i &no-return = YES}    
          pcError = cMessageList.
          IF pcError <> "":U THEN UNDO tran-block, LEAVE tran-block.
          
          /* Validate the record */
          VALIDATE ryc_attribute_value NO-ERROR.
          {afcheckerr.i &no-return = YES}    
          pcError = cMessageList.
          IF pcError <> "":U THEN UNDO tran-block, LEAVE tran-block.
          RUN viewLogMessage (INPUT "Renamed Attribute Label from " + pcAttributeLabel + " to " + pcNewAttributeLabel + " for Object Instance " + ttObjects.cObjectFileName).
        END. /* AVAILABLE */
      END. /* ttObjects */
    END. /* plUpdateObjectInstance */
  
  END. /* TRANSACTION */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateData Procedure 
PROCEDURE validateData :
/*------------------------------------------------------------------------------
  Purpose:     This process will validate the values send through with the 
               temp-table. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMessage  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dDecimal  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iInteger  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE dDate     AS DATE       NO-UNDO.
  DEFINE VARIABLE cDir      AS CHARACTER  NO-UNDO.
  
  DEFINE BUFFER buryc_attribute FOR ryc_attribute.
  
  pcError = "":U.
  
  FOR EACH ttAttributeOptions 
      NO-LOCK:
    IF LOOKUP(ttAttributeOptions.cAction,"ASSIGN,DELETE,RENAME":U) = 0 THEN
      pcError = pcError + (IF NUM-ENTRIES(pcError,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                        {aferrortxt.i 'AF' '5' '' '' "'action'" "'Valid actions are: ASSIGN, DELETE and RENAME.'"}.
    
    IF ttAttributeOptions.cAttributeLabel = "":U THEN
      pcError = pcError + (IF NUM-ENTRIES(pcError,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                        {aferrortxt.i 'AF' '1' '' '' "'Attribute Label'"}.
      
    FIND FIRST ryc_attribute
         WHERE ryc_attribute.attribute_label = ttAttributeOptions.cAttributeLabel
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ryc_attribute THEN
      ASSIGN cMessage = "The Attribute Label - " + ttAttributeOptions.cAttributeLabel + " does not exist in the database."
             pcError  = pcError + (IF NUM-ENTRIES(pcError,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                               {aferrortxt.i 'AF' '5' '' '' "'Attribute Label'" "cMessage"}.
    
    IF lUpdateTypes          = FALSE AND
       lUpdateObject         = FALSE AND
       lUpdateObjectInstance = FALSE THEN 
      pcError = pcError + (IF NUM-ENTRIES(pcError,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                        {aferrortxt.i 'AF' '15' '' '' "'the Change Level was not specified. You should select one or all of the Change Levels.'"}.
    
    /* If the Attribute label does not exist we will not
       validate the rest of the data - it must be a valid
       attribute label */
    IF pcError <> "":U OR
       NOT AVAILABLE ryc_attribute THEN
      NEXT.
      
    CASE ttAttributeOptions.cAction:
      WHEN "ASSIGN":U THEN DO:
        /* Attribute Value */
        CASE ryc_attribute.data_type:
          WHEN {&DECIMAL-DATA-TYPE}   THEN DO:
            ASSIGN dDecimal = DECIMAL(ttAttributeOptions.cAttributeValue) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN
              pcError = pcError + (IF NUM-ENTRIES(pcError,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                        {aferrortxt.i 'AF' '5' '' 'ttAttributeOptions.cAttributeValue' "'Attribute Value'" "'The value specified must be of type DECIMAL.'"}.
            ELSE
              IF TRIM(ttAttributeOptions.cAttributeValue) = "":U THEN
                pcError = pcError + (IF NUM-ENTRIES(pcError,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                          {aferrortxt.i 'AF' '1' '' 'ttAttributeOptions.cAttributeValue' "'Attribute Value'" "'You must specify a valid DECIMAL value.'"}.
          END.
          WHEN {&INTEGER-DATA-TYPE}   THEN DO:
            ASSIGN iInteger = INTEGER(ttAttributeOptions.cAttributeValue) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN
              pcError = pcError + (IF NUM-ENTRIES(pcError,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                        {aferrortxt.i 'AF' '5' '' 'ttAttributeOptions.cAttributeValue' "'Attribute Value'" "'The value specified must be of type INTEGER.'"}.
            ELSE
              IF TRIM(ttAttributeOptions.cAttributeValue) = "":U THEN
                pcError = pcError + (IF NUM-ENTRIES(pcError,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                          {aferrortxt.i 'AF' '1' '' 'ttAttributeOptions.cAttributeValue' "'Attribute Value'" "'You must specify a valid INTEGER value.'"}.
          END.
          WHEN {&DATE-DATA-TYPE}      THEN DO:
            cMessage = "The value specified must be of type DATE. " + "(":U + CAPS(SESSION:DATE-FORMAT) + ")":U.
            ASSIGN dDate = DATE(ttAttributeOptions.cAttributeValue) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN
              pcError = pcError + (IF NUM-ENTRIES(pcError,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                        {aferrortxt.i 'AF' '5' '' 'ttAttributeOptions.cAttributeValue' "'Attribute Value'" "cMessage"}.
            ELSE
              IF TRIM(ttAttributeOptions.cAttributeValue) = "":U THEN
                pcError = pcError + (IF NUM-ENTRIES(pcError,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                          {aferrortxt.i 'AF' '1' '' 'ttAttributeOptions.cAttributeValue' "'Attribute Value'" "'You must specify a valid DATE value.'"}.
          END.
          WHEN {&RAW-DATA-TYPE}       THEN.
          WHEN {&LOGICAL-DATA-TYPE}   THEN DO:
            IF ttAttributeOptions.cAttributeValue <> "TRUE":U  AND
               ttAttributeOptions.cAttributeValue <> "FALSE":U AND
               ttAttributeOptions.cAttributeValue <> "YES":U   AND
               ttAttributeOptions.cAttributeValue <> "NO":U    THEN
            IF ERROR-STATUS:ERROR THEN
              pcError = pcError + (IF NUM-ENTRIES(pcError,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                        {aferrortxt.i 'AF' '5' '' 'ttAttributeOptions.cAttributeValue' "'Attribute Value'" "'The value specified must be of type LOGICAL (YES/NO/TRUE/FALSE).'"}.
            ELSE
              IF TRIM(ttAttributeOptions.cAttributeValue) = "":U THEN
                pcError = pcError + (IF NUM-ENTRIES(pcError,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                          {aferrortxt.i 'AF' '1' '' 'ttAttributeOptions.cAttributeValue' "'Attribute Value'" "'You must specify a valid LOGICAL value.'"}.
          END.
        END CASE.

      END. /* ASSIGN */
      /* Rename */
      WHEN "RENAME":U THEN DO:
        IF ttAttributeOptions.cNewAttributeLabel = "":U THEN
          pcError = pcError + (IF NUM-ENTRIES(pcError,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                            {aferrortxt.i 'AF' '1' '' '' "'New Attribute Label'"}.
          
        FIND FIRST buryc_attribute
             WHERE buryc_attribute.attribute_label = ttAttributeOptions.cNewAttributeLabel
             NO-LOCK NO-ERROR.
        IF NOT AVAILABLE buryc_attribute THEN
          ASSIGN cMessage = "The New Attribute Label - " + ttAttributeOptions.cNewAttributeLabel + " does not exist in the database."
                 pcError  = pcError + (IF NUM-ENTRIES(pcError,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                                   {aferrortxt.i 'AF' '5' '' '' "'New Attribute Label'" "cMessage"}.
        
        IF ryc_attribute.data_type <> buryc_attribute.data_type THEN
          pcError  = pcError + (IF NUM-ENTRIES(pcError,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                     {aferrortxt.i 'AF' '5' '' '' "'New Attribute Label'" "'The new attribute must be of the same data type.'"}.
      END. /* RENAME */
    END CASE.
    IF lUpdateObject         = TRUE OR
       lUpdateObjectInstance = TRUE THEN DO:
      IF NOT CAN-FIND(FIRST ttObjects
                      WHERE ttObjects.cAttributeLabel = ttAttributeOptions.cAttributeLabel) THEN
        ASSIGN cMessage = "no Objects were selected to be changed for attribute " + ttAttributeOptions.cAttributeLabel + ". You must specify objects to be changed for the level specified."
               pcError  = pcError + (IF NUM-ENTRIES(pcError,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                                 {aferrortxt.i 'AF' '15' '' '' "cMessage"}.
    END.
    
    IF lUpdateTypes                       = TRUE AND
       ttAttributeOptions.dObjectTypeObj <> 0 AND
       NOT CAN-FIND(FIRST gsc_object_type 
                    WHERE gsc_object_type.object_type_obj = ttAttributeOptions.dObjectTypeObj) THEN DO:
        ASSIGN pcError  = pcError + (IF NUM-ENTRIES(pcError,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                                 {aferrortxt.i 'AF' '5' '' '' "'Object Type'" "'You selected to update the Attribute values at Object Type level, but the object specified does not exist in the database.'"}.
    END.
    IF ttAttributeOptions.lGenerateADO AND
       pcADODir = "":U THEN
      ASSIGN pcError  = pcError + (IF NUM-ENTRIES(pcError,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                               {aferrortxt.i 'AF' '1' '' '' "'ADO Export directory'"}.
    
    IF ttAttributeOptions.lGenerateADO AND
       pcADODir <> "":U THEN DO:
      ASSIGN FILE-INFO:FILE-NAME = pcADODir.
      IF FILE-INFO:FULL-PATHNAME = ? THEN
        ASSIGN pcError  = pcError + (IF NUM-ENTRIES(pcError,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                                 {aferrortxt.i 'AF' '5' '' '' "'ADO Export directory'" "'The ADO Export directory specified does not exists or the drive specified is invalid.'"}.
    END.
    
    IF ttAttributeOptions.lCheckOut AND
       NOT CONNECTED("RTB":U) THEN
        ASSIGN pcError  = pcError + (IF NUM-ENTRIES(pcError,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                                 {aferrortxt.i 'AF' '15' '' '' "'you have selected to check out the objects in the SCM tool and the only current supported SCM Tool (RTB) is not connected.'"}.
  END. /* EACH ttAttributeOptions */

  /* Check Log File */
  IF pcLogFileName = "":U THEN 
     pcError  = pcError + (IF NUM-ENTRIES(pcError,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                       {aferrortxt.i 'AF' '1' '' '' "'Log File'"}.
  ELSE DO:
    ASSIGN cDir = REPLACE(pcLogFileName,"~\":U,"/":U)
           cDir = SUBSTRING(cDir,1,R-INDEX(cDir,"/":U) - 1).
    ASSIGN FILE-INFO:FILE-NAME = cDir.
    IF FILE-INFO:FULL-PATHNAME = ? THEN
      pcError  = pcError + (IF NUM-ENTRIES(pcError,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                 {aferrortxt.i 'AF' '5' '' '' "'Log File'" "'Please make sure that the path exists and that the drive specified is valid.'"}.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-viewLogMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewLogMessage Procedure 
PROCEDURE viewLogMessage :
/*------------------------------------------------------------------------------
  Purpose:  This procedure will output a string message to the log file and also
            send this to a procedure called viewMessage in the caller if this
            procedure could be found.   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcMessage AS CHARACTER  NO-UNDO.
  
  PUT STREAM stOut UNFORMATTED pcMessage SKIP.
  
  IF VALID-HANDLE(phWindowHandle) AND 
     LOOKUP("viewMessage":U,phWindowHandle:INTERNAL-ENTRIES) > 0 THEN
    RUN viewMessage IN phWindowHandle (INPUT pcMessage).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-FormatAttributeValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION FormatAttributeValue Procedure 
FUNCTION FormatAttributeValue RETURNS CHARACTER
    ( INPUT pcAttributeTypeTLA      AS CHARACTER,
      INPUT pcAttributeValue        AS CHARACTER    ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  Handle potential numeric format issues and date format issues.
            Remove all numeric separators by assigning the decimal value to a string.
            Replace the decimal point with ".". When retrieving the attribute value
            we will need to convert the "." back into the session's decimal point.   
            
            Convert any dates into MDY format.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cAttributeValue         AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE dAttributeValue         AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE iAttributeValue         AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE lAttributeValue         AS LOGICAL                  NO-UNDO.
    DEFINE VARIABLE tAttributeValue AS DATE                     NO-UNDO.

    IF pcAttributeValue NE "":U THEN
    CASE pcAttributeTypeTLA:
        WHEN "DEC":U THEN
        DO:
            ASSIGN dAttributeValue = DECIMAL(pcAttributeValue) NO-ERROR.
            IF NOT ERROR-STATUS:ERROR THEN
                ASSIGN cAttributeValue = STRING(dAttributeValue)
                       cAttributeValue = REPLACE(pcAttributeValue,
                                                 SESSION:NUMERIC-DECIMAL-POINT,
                                                 ".":U)
                       .
            ELSE
            IF NUM-ENTRIES(pcAttributeValue, ".":U) EQ 2 THEN
                ASSIGN cAttributeValue = pcAttributeValue.
            ELSE
                ASSIGN cAttributeValue = ?.
        END.    /* DECIMAL */
        WHEN "DAT":U THEN
        DO:
            /* Always store dates as integers. The FormatAttributeValue API
             * in the Repository Manager transforms the date correctly, though.  */
            ASSIGN tAttributeValue = DATE(pcAttributeValue) NO-ERROR.
            IF NOT ERROR-STATUS:ERROR THEN
                ASSIGN cAttributeValue = STRING(INTEGER(tAttributeValue)).
            ELSE
                ASSIGN cAttributeValue = ?.
        END.    /* DAT */
        WHEN "INT":U THEN
        DO:
            /* String out any formatting, such as numeric separators. */
            ASSIGN iAttributeValue = INTEGER(pcAttributeValue) NO-ERROR.
            IF NOT ERROR-STATUS:ERROR THEN
                ASSIGN cAttributeValue = STRING(iAttributeValue).
            ELSE
                ASSIGN cAttributeValue = ?.
        END.    /* INT */
        WHEN "LOG":U THEN
        DO:
            IF LOOKUP(pcAttributeValue, "YES,TRUE":U) GT 0 THEN
                ASSIGN lAttributeValue = YES.
            ELSE
            IF LOOKUP(pcAttributeValue, "NO,FALSE":U) GT 0 THEN
                ASSIGN lAttributeValue = NO.
            ELSE
                ASSIGN lAttributeValue = ?.

            ASSIGN cAttributeValue = STRING(lAttributeValue).
        END.    /* LOG */
        OTHERWISE
            ASSIGN cAttributeValue = pcAttributeValue.
    END CASE.   /* attribute type TLA */

    RETURN cAttributeValue.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPathedFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPathedFile Procedure 
FUNCTION getPathedFile RETURNS CHARACTER
  ( INPUT pdSmartObjectObj AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cPath     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFileName AS CHARACTER  NO-UNDO.
  
  FIND FIRST ryc_smartobject
       WHERE ryc_smartobject.smartobject_obj = pdSmartObjectObj
       NO-LOCK NO-ERROR.

  IF NOT AVAILABLE ryc_smartobject THEN
    RETURN "** Could not find ryc_smartobject for object " + STRING(pdSmartObjectObj).
  
  IF ryc_smartobject.object_path <> "":U THEN
      cPath = ryc_smartobject.object_path.
  ELSE DO:
    FIND FIRST gsc_product_module NO-LOCK
         WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj
         NO-ERROR.
    IF AVAILABLE gsc_product_module AND
       gsc_product_module.relative_path <> "":U THEN
      cPath = gsc_product_module.relative_path.
  END.
  IF cPath = "":U OR
     SUBSTRING(cPath,2,1) = ":":U OR
     cPath = "src/adm2":U THEN
    cPath = "db/icf/dump".
  cFileName = ryc_smartobject.object_filename.
  IF cFileName = "":U THEN
    RETURN "":U.
    
  IF replaceExt(cFileName) THEN
    cFileName = SUBSTRING(cFileName,1,R-INDEX(cFileName,".":U)) + "ado":U.
  ELSE
    cFileName = cFileName + ".ado":U.
  ASSIGN pcADODir  = REPLACE(pcADODir,"~\":U,"/":U)
         pcADODir  = TRIM(pcADODir,"/":U)
         cFileName = LC(pcADODir + "/":U + cPath + "/":U + cFileName).
  
  RETURN cFileName.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-replaceExt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION replaceExt Procedure 
FUNCTION replaceExt RETURNS LOGICAL
  ( INPUT pcFileName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cExt AS CHARACTER  NO-UNDO.

  IF NUM-ENTRIES(pcFileName, ".":U) < 2 THEN
    RETURN FALSE.

  cExt = ENTRY(NUM-ENTRIES(pcFileName,".":U),pcFileName,".":U).
  RETURN CAN-DO("p,w,i,t,ado":U,cExt). 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

