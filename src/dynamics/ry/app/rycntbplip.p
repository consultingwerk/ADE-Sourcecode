&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
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
/* Copyright (C) 2006-2007 by Progress Software Corporation. All rights    
   reserved.  Prior versions of this work may contain portions
   contributed by participants of Possenet. */
/*---------------------------------------------------------------------------------
  File: rycntbplip.p

  Description:  Container Builder PLIP

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   04/17/2002  Author:     Chris Koster

  Update Notes: Created from Template rytemplipp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rycntbplip.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

{src/adm2/globals.i}
{ry/inc/rycntnerbi.i}
{af/app/afdatatypi.i}

DEFINE TEMP-TABLE ttClassValues
  FIELD cClassCode      AS CHARACTER
  FIELD cAttributeLabel AS CHARACTER
  FIELD cAttributeValue AS CHARACTER
  INDEX idx1 cClassCode.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-attributeClasses) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD attributeClasses Procedure 
FUNCTION attributeClasses RETURNS CHARACTER
  (pcAttributeLabel AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-attributeExistsInClass) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD attributeExistsInClass Procedure 
FUNCTION attributeExistsInClass RETURNS LOGICAL
  (pcAttributeLabel AS CHARACTER,
   pcObjectTypeCode AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-compareLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD compareLinks Procedure 
FUNCTION compareLinks RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-compareObjectInstance) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD compareObjectInstance Procedure 
FUNCTION compareObjectInstance RETURNS LOGICAL
  (pcInstanceName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-comparePage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD comparePage Procedure 
FUNCTION comparePage RETURNS LOGICAL
  (pcPageReference AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAttributeValueNew) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAttributeValueNew Procedure 
FUNCTION getAttributeValueNew RETURNS CHARACTER
  (pcAttributeLabel           AS CHARACTER,
   pcInstanceName             AS CHARACTER,
   pdObjectTypeObj            AS DECIMAL,
   pdSmartObjectObj           AS DECIMAL,
   pdCustomizedSmartObjectObj AS DECIMAL,
   pdMainSmartObjectObj       AS DECIMAL,
   pdCustomizationResultObj   AS DECIMAL) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFirstAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFirstAvailable Procedure 
FUNCTION getFirstAvailable RETURNS CHARACTER
  (pcObjectTypeCode         AS CHARACTER,
   piPageNumber             AS INTEGER,
   pdCustomizationResultObj AS DECIMAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLastObjectOnRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLastObjectOnRow Procedure 
FUNCTION getLastObjectOnRow RETURNS INTEGER
  (pdObjectInstanceObj AS DECIMAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUniquePageSequence) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUniquePageSequence Procedure 
FUNCTION getUniquePageSequence RETURNS INTEGER
  (pdCustomizationResultObj AS DECIMAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-inheritsFrom) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD inheritsFrom Procedure 
FUNCTION inheritsFrom RETURNS CHARACTER
  (pcObjectTypeCode AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isAttributeValueSame) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isAttributeValueSame Procedure 
FUNCTION isAttributeValueSame RETURNS LOGICAL
  (BUFFER ttAttributeValue FOR ttAttributeValue,
   INPUT  pcObjectFilename            AS CHARACTER,
   INPUT  pdCustomizedSmartObjectObj  AS DECIMAL,
   INPUT  pdMainSmartObjectObj        AS DECIMAL,
   INPUT  pdCustomizationResultObj    AS DECIMAL) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isUiEventSame) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isUiEventSame Procedure 
FUNCTION isUiEventSame RETURNS LOGICAL
  (BUFFER ttUiEvent FOR ttUiEvent,
   INPUT  pcObjectFilename            AS CHARACTER,
   INPUT  pdCustomizedSmartObjectObj  AS DECIMAL,
   INPUT  pdMainSmartObjectObj        AS DECIMAL,
   INPUT  pdCustomizationResultObj    AS DECIMAL) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isVisibleObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isVisibleObject Procedure 
FUNCTION isVisibleObject RETURNS LOGICAL
  (pdObjectInstanceObj AS DECIMAL)  FORWARD.

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
         HEIGHT             = 18.52
         WIDTH              = 52.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */

{ry/app/ryplipmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-convertLayout) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE convertLayout Procedure 
PROCEDURE convertLayout :
/*------------------------------------------------------------------------------
  Purpose:     This procedure takes a layout code and converts it into row and
               column details to be used by the grid viewer. It also outputs a
               new layout code in the relative layout format incase the layout
               information received was not int the relative layout format.

  Parameters:  INPUT  pdObjectInstanceObj - Instance Obj of object we are converting the
                                            layout for
               INPUT  pcLayoutPosition    - Current layout code of the object
               INPUT  piPageNumber        - The number of the page the object is on
               INPUT  plVisibleObject     - Flag to indicate if it is a visible object
                                            or not
               OUTPUT pcNewLayoutCode     - The new layout code of the object (in
                                            relative layout format)
               OUTPUT piRow               - The row the object is on
               OUTPUT piColumn            - The column the boject is in
               OUTPUT pcJustification     - The justification of the object (i.e. 'L' - Left
                                                                                  'R' - Right
                                                                                  'C' - Centre)
               OUTPUT plRelativeLayout    - Indicator to see if the layout code passed
                                            in was in the relative layout format
  
  Notes:       When this procedure was written, the only layouts used in the system
               were Top/Centre/Bottom, Top/Multi/Bottom and the Relative Layout.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdObjectInstanceObj AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcLayoutPosition    AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER piPageNumber        AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER plVisibleObject     AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcNewLayoutCode     AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER piRow               AS INTEGER    NO-UNDO.
  DEFINE OUTPUT PARAMETER piColumn            AS INTEGER    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcJustification     AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER plRelativeLayout    AS LOGICAL    NO-UNDO.
  
  DEFINE VARIABLE cJustification  AS CHARACTER  NO-UNDO.
  
  /* Assign inital values */
  ASSIGN
      plRelativeLayout = FALSE
      pcLayoutPosition = ENTRY(1, pcLayoutPosition)
      pcLayoutPosition = (IF pcLayoutPosition BEGINS " ":U THEN pcLayoutPosition ELSE TRIM(pcLayoutPosition)).
  
  IF pcLayoutPosition BEGINS "Top":U    OR
     pcLayoutPosition BEGINS "Centre":U OR
     pcLayoutPosition BEGINS "Bottom":U THEN /* Convert the 'Top/Center/Bottom' and 'Top/Multi/Bottom' layouts */
  DO:
    CASE SUBSTRING(pcLayoutPosition, 1, 1):
      WHEN "T":U THEN piRow = 1.
      WHEN "B":U THEN piRow = 9.
      WHEN "C":U THEN ASSIGN
                          pcLayoutPosition = REPLACE(pcLayoutPosition, "Centre":U, "":U)
                          piRow            = INTEGER(pcLayoutPosition)
                          piRow            = piRow + 1.
    END CASE.

    ASSIGN
        pcJustification  = "L":U
        piColumn         = 1
        pcNewLayoutCode  = "M":U + STRING(piRow) + "1":U.
  END.
  ELSE
  DO:
    /* Convert objects that do not have any layout information. SmartFolders and non visual objects typically had no layout information */
    IF pcLayoutPosition = "":U THEN
    DO:
      IF plVisibleObject THEN
        ASSIGN
            pcJustification  = "L":U
            piColumn         = 1
            piRow            = 2
            pcNewLayoutCode  = "M21":U.
      ELSE
        ASSIGN
            pcJustification  = "L":U
            piColumn         = 1
            piRow            = 1
            pcNewLayoutCode  = "M11":U.
    END.
    ELSE
    /* Convert objects that had relative layouts */
    DO:
      ASSIGN
          pcNewLayoutCode  = pcLayoutPosition
          plRelativeLayout = TRUE
          piRow            = INTEGER(SUBSTRING(pcLayoutPosition, 2, 1))
          cJustification   = SUBSTRING(pcLayoutPosition, 3, 1).
      
      IF cJustification = "C":U THEN
        ASSIGN
            pcJustification = "C":U
            piColumn        = 1.
      ELSE
        IF cJustification = "R":U THEN
          ASSIGN
              pcJustification = "R":U
              piColumn        = 0.
        ELSE
          ASSIGN
              pcJustification = "L":U
              piColumn        = INTEGER(cJustification).
    END.
  END.
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteObjectData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteObjectData Procedure 
PROCEDURE deleteObjectData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE PARAMETER BUFFER ryc_smartobject FOR ryc_smartobject.

  DEFINE BUFFER ryc_object_instance FOR ryc_object_instance.
  DEFINE BUFFER ryc_page            FOR ryc_page.

  FOR EACH ryc_page EXCLUSIVE-LOCK
     WHERE ryc_page.container_smartobject_obj = ryc_smartobject.smartobject_obj:

    RUN deletePageData (BUFFER ryc_page) NO-ERROR.
    
    IF ERROR-STATUS:ERROR THEN
      RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).
  END.

  FOR EACH ryc_object_instance EXCLUSIVE-LOCK
     WHERE ryc_object_instance.container_smartobject_obj = ryc_smartobject.smartobject_obj:
    
    RUN deleteObjectInstanceData (BUFFER ryc_object_instance) NO-ERROR.
  
    IF ERROR-STATUS:ERROR THEN
      RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).
  END.

  DELETE ryc_smartobject NO-ERROR.

  IF ERROR-STATUS:ERROR THEN
    RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteObjectInstanceData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteObjectInstanceData Procedure 
PROCEDURE deleteObjectInstanceData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE PARAMETER BUFFER ryc_object_instance FOR ryc_object_instance.

  DEFINE BUFFER ryc_attribute_value FOR ryc_attribute_value.
  DEFINE BUFFER ryc_smartobject     FOR ryc_smartobject.
  DEFINE BUFFER ryc_smartlink       FOR ryc_smartlink.
  DEFINE BUFFER ryc_ui_event        FOR ryc_ui_event.
  
  FIND FIRST ryc_smartobject NO-LOCK
       WHERE ryc_smartobject.smartobject_obj = ryc_object_instance.smartobject_obj.
  
  /* Delete all the smartlinks associated with the object instance */
  FOR EACH  ryc_smartlink EXCLUSIVE-LOCK
     WHERE (ryc_smartlink.container_smartobject_obj   = ryc_object_instance.container_smartobject_obj
       AND   ryc_smartlink.source_object_instance_obj = ryc_object_instance.object_instance_obj)
        OR  (ryc_smartlink.container_smartobject_obj  = ryc_object_instance.container_smartobject_obj
       AND   ryc_smartlink.target_object_instance_obj = ryc_object_instance.object_instance_obj):

    DELETE ryc_smartlink NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
      RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).
  END.
  
  /* Delete all the attribute values associated with the object instance */
  FOR EACH ryc_attribute_value EXCLUSIVE-LOCK
     WHERE ryc_attribute_value.primary_smartobject_obj = ryc_object_instance.container_smartobject_obj
       AND ryc_attribute_value.object_instance_obj     = ryc_object_instance.object_instance_obj
       AND ryc_attribute_value.smartobject_obj         = ryc_object_instance.smartobject_obj
       AND ryc_attribute_value.object_type_obj         = ryc_smartobject.object_type_obj:

    DELETE ryc_attribute_value NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
      RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).
  END.
  
  /* Delete all the ui events associated with the object instance */
  FOR EACH ryc_ui_event EXCLUSIVE-LOCK
     WHERE ryc_ui_event.container_smartobject_obj = ryc_object_instance.container_smartobject_obj
       AND ryc_ui_event.object_instance_obj       = ryc_object_instance.object_instance_obj
       AND ryc_ui_event.smartobject_obj           = ryc_object_instance.smartobject_obj
       AND ryc_ui_event.object_type_obj           = ryc_smartobject.object_type_obj:

    DELETE ryc_ui_event NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
      RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).
  END.
  
  /* Finally delete the object instance */
  DELETE ryc_object_instance NO-ERROR.

  IF ERROR-STATUS:ERROR THEN
    RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).
  
  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deletePageData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deletePageData Procedure 
PROCEDURE deletePageData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE PARAMETER BUFFER ryc_page FOR ryc_page.

  DEFINE BUFFER ryc_object_instance FOR ryc_object_instance.

  /* Delete all the object instances associated with the page object */
  FOR EACH ryc_object_instance EXCLUSIVE-LOCK
     WHERE ryc_object_instance.container_smartobject_obj = ryc_page.container_smartobject_obj
       AND ryc_object_instance.page_obj                  = ryc_page.page_obj:

    RUN deleteObjectInstanceData (BUFFER ryc_object_instance) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
      RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).
  END.

  DELETE ryc_page NO-ERROR.

  IF ERROR-STATUS:ERROR THEN
    RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAttributeValueTT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getAttributeValueTT Procedure 
PROCEDURE getAttributeValueTT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcObjectFilename         AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pdCustomizationResultObj AS DECIMAL    NO-UNDO.
  
  DEFINE VARIABLE dCustomizedSmartObjectObj AS DECIMAL  NO-UNDO.
  DEFINE VARIABLE dCurrentSmartObjectObj    AS DECIMAL  NO-UNDO.
  DEFINE VARIABLE dCustomizedMasterObj      AS DECIMAL  NO-UNDO.
  DEFINE VARIABLE dMainSmartObjectObj       AS DECIMAL  NO-UNDO.
  DEFINE VARIABLE dSmartObjectObj           AS DECIMAL  NO-UNDO.
  DEFINE VARIABLE dObjectTypeObj            AS DECIMAL  NO-UNDO.
  DEFINE VARIABLE dMasterObj                AS DECIMAL  NO-UNDO.
  DEFINE VARIABLE lCreateAsMaster           AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE iCounter                  AS INTEGER  NO-UNDO.
  DEFINE VARIABLE iMaster                   AS INTEGER  NO-UNDO.
  
  DEFINE BUFFER ryc_customization_result FOR ryc_customization_result.
  DEFINE BUFFER ryc_attribute_value      FOR ryc_attribute_value.
  DEFINE BUFFER ryc_smartobject          FOR ryc_smartobject.

  FOR EACH ttSmartObject
     WHERE ttSmartObject.d_smartobject_obj <> 0.00:
    
    IF dObjectTypeObj = 0.00 THEN
      dObjectTypeObj = ttSmartObject.d_object_type_obj.
    
    IF ttSmartObject.d_customization_result_obj = 0.00 THEN
      dMainSmartObjectObj = ttSmartObject.d_smartobject_obj.
    ELSE
      dCustomizedSmartObjectObj = ttSmartObject.d_smartobject_obj.
  END.
  
  FIND FIRST ryc_customization_result NO-LOCK
       WHERE ryc_customization_result.customization_result_obj = pdCustomizationResultObj NO-ERROR.

  /* Read the attributes for the main and customized container */
  DO iCounter = 1 TO (IF pdCustomizationResultObj = 0.00 THEN 1 ELSE 2):
    
    IF iCounter = 1 THEN
      dSmartObjectObj = dMainSmartObjectObj.
    ELSE
      dSmartObjectObj = dCustomizedSmartObjectObj.
    
    /* Get the attribute values for the container */
    FOR EACH ryc_attribute_value NO-LOCK
       WHERE ryc_attribute_value.primary_smartobject_obj   = dSmartObjectObj
         AND ryc_attribute_value.container_smartobject_obj = 0.00
         AND ryc_attribute_value.object_instance_obj       = 0.00
         AND ryc_attribute_value.smartobject_obj           = dSmartObjectObj
         AND ryc_attribute_value.object_type_obj           = dObjectTypeObj,
       FIRST ryc_attribute NO-LOCK
       WHERE ryc_attribute.attribute_label = ryc_attribute_value.attribute_label:

      CREATE ttAttributeValue.
      ASSIGN ttAttributeValue.d_attribute_value_obj       = ryc_attribute_value.attribute_value_obj
             ttAttributeValue.d_object_type_obj           = ryc_attribute_value.object_type_obj
             ttAttributeValue.d_container_smartobject_obj = ryc_attribute_value.container_smartobject_obj
             ttAttributeValue.d_smartobject_obj           = ryc_attribute_value.smartobject_obj
             ttAttributeValue.d_object_instance_obj       = ryc_attribute_value.object_instance_obj
             ttAttributeValue.l_constant_value            = ryc_attribute_value.constant_value
             ttAttributeValue.c_attribute_label           = ryc_attribute_value.attribute_label
             ttAttributeValue.c_character_value           = ryc_attribute_value.character_value
             ttAttributeValue.i_integer_value             = ryc_attribute_value.integer_value
             ttAttributeValue.t_date_value                = ryc_attribute_value.date_value
             ttAttributeValue.d_decimal_value             = ryc_attribute_value.decimal_value
             ttAttributeValue.l_logical_value             = ryc_attribute_value.logical_value
             ttAttributeValue.r_raw_value                 = ryc_attribute_value.raw_value
             ttAttributeValue.d_primary_smartobject_obj   = ryc_attribute_value.primary_smartobject_obj
             ttAttributeValue.i_data_type                 = ryc_attribute.data_type
             ttAttributeValue.c_customization_result_code = (IF NOT AVAILABLE ryc_customization_result OR iCounter = 1 THEN "":U
                                                             ELSE ryc_customization_result.customization_result_code)
             ttAttributeValue.d_customization_result_obj  = (IF iCounter = 1 THEN 0.00 ELSE pdCustomizationResultObj).
    END.
    
    FOR EACH ttObjectInstance
       WHERE ttObjectInstance.d_container_smartobject_obj = dSmartObjectObj:
       
      /* This will read the attributes specified against the master */
      IF NOT CAN-FIND(FIRST ttAttributeValue
                      WHERE ttAttributeValue.d_primary_smartobject_obj   = ttObjectInstance.d_smartobject_obj
                        AND ttAttributeValue.d_container_smartobject_obj = 0.00
                        AND ttAttributeValue.d_object_instance_obj       = 0.00
                        AND ttAttributeValue.d_object_type_obj           = ttObjectInstance.d_object_type_obj
                        AND ttAttributeValue.d_smartobject_obj           = ttObjectInstance.d_smartobject_obj) THEN
      DO:
        /* See if we can find a customized version of the master smartobject */
        IF AVAILABLE ryc_customization_result THEN
          FIND FIRST ryc_smartobject NO-LOCK
               WHERE ryc_smartobject.object_filename          = ttObjectInstance.c_smartobject_filename
                 AND ryc_smartobject.customization_result_obj = pdCustomizationResultObj NO-ERROR.

        IF AVAILABLE ryc_smartobject THEN
          dCustomizedMasterObj = ryc_smartobject.smartobject_obj.

        FIND FIRST ryc_smartobject NO-LOCK
             WHERE ryc_smartobject.object_filename          = ttObjectInstance.c_smartobject_filename
               AND ryc_smartobject.customization_result_obj = 0.00 NO-ERROR.

        IF AVAILABLE ryc_smartobject THEN
          dMasterObj = ryc_smartobject.smartobject_obj.

        DO iMaster = 1 TO (IF dCustomizedMasterObj <> 0.00 THEN 2 ELSE 1):
          IF iMaster = 1 THEN
          DO:
            IF dCustomizedMasterObj <> 0.00 THEN
              dCurrentSmartObjectObj = dCustomizedMasterObj.
            ELSE
              dCurrentSmartObjectObj = dMasterObj.
          END.
          ELSE
            dCurrentSmartObjectObj = dMasterObj.

          FOR EACH ryc_attribute_value NO-LOCK
             WHERE ryc_attribute_value.primary_smartobject_obj   = dCurrentSmartObjectObj
               AND ryc_attribute_value.container_smartobject_obj = 0.00
               AND ryc_attribute_value.object_instance_obj       = 0.00
               AND ryc_attribute_value.smartobject_obj           = dCurrentSmartObjectObj
               AND ryc_attribute_value.object_type_obj           = ryc_smartobject.object_type_obj,
             FIRST ryc_attribute NO-LOCK
             WHERE ryc_attribute.attribute_label = ryc_attribute_value.attribute_label:

            /* See if we have not added it already (for the customization) */
            IF NOT CAN-FIND(FIRST ttAttributeValue
                            WHERE ttAttributeValue.d_primary_smartobject_obj   = dMasterObj
                              AND ttAttributeValue.d_container_smartobject_obj = 0.00
                              AND ttAttributeValue.d_object_instance_obj       = 0.00
                              AND ttAttributeValue.d_object_type_obj           = ttObjectInstance.d_object_type_obj
                              AND ttAttributeValue.d_smartobject_obj           = dMasterObj
                              AND ttAttributeValue.c_attribute_label           = ryc_attribute_value.attribute_label) THEN
            DO:
              CREATE ttAttributeValue.
              ASSIGN ttAttributeValue.d_attribute_value_obj       = ryc_attribute_value.attribute_value_obj
                     ttAttributeValue.d_object_type_obj           = ryc_attribute_value.object_type_obj
                     ttAttributeValue.d_container_smartobject_obj = ryc_attribute_value.container_smartobject_obj /* 0.00 */
                     ttAttributeValue.d_object_instance_obj       = ryc_attribute_value.object_instance_obj       /* 0.00 */
                     ttAttributeValue.d_smartobject_obj           = dMasterObj                                    /* This is intentional */
                     ttAttributeValue.l_constant_value            = ryc_attribute_value.constant_value
                     ttAttributeValue.c_attribute_label           = ryc_attribute_value.attribute_label
                     ttAttributeValue.c_character_value           = ryc_attribute_value.character_value
                     ttAttributeValue.i_integer_value             = ryc_attribute_value.integer_value
                     ttAttributeValue.t_date_value                = ryc_attribute_value.date_value
                     ttAttributeValue.d_decimal_value             = ryc_attribute_value.decimal_value
                     ttAttributeValue.l_logical_value             = ryc_attribute_value.logical_value
                     ttAttributeValue.r_raw_value                 = ryc_attribute_value.raw_value
                     ttAttributeValue.d_primary_smartobject_obj   = dMasterObj                                    /* This is intentional */
                     ttAttributeValue.i_data_type                 = ryc_attribute.data_type
                     ttAttributeValue.c_customization_result_code = "":U
                     ttAttributeValue.d_customization_result_obj  = (IF dCurrentSmartObjectObj = dCustomizedMasterObj THEN -1.00 ELSE 0.00)
                     ttAttributeValue.l_master_attribute          = TRUE.
            END. /* NOT CAN-FIND(FIRST ttAttributeValue) */
          END.  /* FOR EACH ryc_attribute_value         */
        END.   /* DO iMaster                           */
      END.    /* NO AttributeValue Master records     */

      /* This will read the attributes specified against the instances */
      FOR EACH ryc_attribute_value NO-LOCK
         WHERE ryc_attribute_value.primary_smartobject_obj = dSmartObjectObj
           AND ryc_attribute_value.smartobject_obj         = ttObjectInstance.d_smartobject_obj
           AND ryc_attribute_value.object_type_obj         = ttObjectInstance.d_object_type_obj
           AND ryc_attribute_value.object_instance_obj     = ttObjectInstance.d_object_instance_obj,
         FIRST ryc_attribute NO-LOCK
         WHERE ryc_attribute.attribute_label = ryc_attribute_value.attribute_label:
  
        /* If we do not have a customized master of the current object instance, then if we have any instance attributes on the main (uncustomized container),
           then that value will act as a master value if they choose to undo the value in the dynamic property sheet */
        IF dSmartObjectObj = dMainSmartObjectObj AND dCustomizedSmartObjectObj <> 0.00 THEN
        DO:
          /* See if we have not added it already (for the customized master) */
          IF CAN-FIND(FIRST ttAttributeValue
                      WHERE ttAttributeValue.d_primary_smartobject_obj   = ttObjectInstance.d_smartobject_obj
                        AND ttAttributeValue.d_container_smartobject_obj = 0.00
                        AND ttAttributeValue.d_object_instance_obj       = 0.00
                        AND ttAttributeValue.d_object_type_obj           = ttObjectInstance.d_object_type_obj
                        AND ttAttributeValue.d_smartobject_obj           = ttObjectInstance.d_smartobject_obj
                        AND ttAttributeValue.c_attribute_label           = ryc_attribute_value.attribute_label
                        AND ttAttributeValue.d_customization_result_obj  = -1.00) THEN
          DO:
            lCreateAsMaster = FALSE.
            NEXT.
          END.
          ELSE
            lCreateAsMaster = TRUE.
        END.
        ELSE
          lCreateAsMaster = FALSE.

        CREATE ttAttributeValue.
        ASSIGN ttAttributeValue.d_attribute_value_obj       = ryc_attribute_value.attribute_value_obj
               ttAttributeValue.d_object_type_obj           = ryc_attribute_value.object_type_obj
               ttAttributeValue.d_container_smartobject_obj = (IF lCreateAsMaster = TRUE THEN 0.00 ELSE ryc_attribute_value.container_smartobject_obj)
               ttAttributeValue.d_smartobject_obj           = ryc_attribute_value.smartobject_obj
               ttAttributeValue.d_object_instance_obj       = (IF lCreateAsMaster = TRUE THEN 0.00 ELSE ryc_attribute_value.object_instance_obj)
               ttAttributeValue.l_constant_value            = ryc_attribute_value.constant_value
               ttAttributeValue.c_attribute_label           = ryc_attribute_value.attribute_label
               ttAttributeValue.c_character_value           = ryc_attribute_value.character_value
               ttAttributeValue.i_integer_value             = ryc_attribute_value.integer_value
               ttAttributeValue.t_date_value                = ryc_attribute_value.date_value
               ttAttributeValue.d_decimal_value             = ryc_attribute_value.decimal_value
               ttAttributeValue.l_logical_value             = ryc_attribute_value.logical_value
               ttAttributeValue.r_raw_value                 = ryc_attribute_value.raw_value
               ttAttributeValue.d_primary_smartobject_obj   = (IF lCreateAsMaster = TRUE THEN ttObjectInstance.d_smartobject_obj
                                                                                         ELSE ryc_attribute_value.primary_smartobject_obj)
               ttAttributeValue.i_data_type                 = ryc_attribute.data_type
               ttAttributeValue.c_customization_result_code = (IF NOT AVAILABLE ryc_customization_result OR iCounter = 1 OR lCreateAsMaster THEN "":U
                                                               ELSE ryc_customization_result.customization_result_code)
               ttAttributeValue.d_customization_result_obj  = (IF iCounter = 1 OR lCreateAsMaster THEN 0.00 ELSE pdCustomizationResultObj)

               /* We assign it a ? because it is a dummy record and we do not want to delete it if MasterObjectModified is PUBLISHed anywhere */
               ttAttributeValue.l_master_attribute          = (IF lCreateAsMaster THEN ? ELSE FALSE).
      END.
    END.
  END.

  /* Fix the field in the temp-table I used temporarily */
  FOR EACH ttAttributeValue
     WHERE ttAttributeValue.d_customization_result_obj = -1.00:

    ttAttributeValue.d_customization_result_obj = 0.00.
  END.

  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBasicDetails) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getBasicDetails Procedure 
PROCEDURE getBasicDetails :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER TABLE FOR ttSmartLinkType.
  DEFINE OUTPUT PARAMETER TABLE FOR ttSupportedLink.
  DEFINE OUTPUT PARAMETER TABLE FOR ttObjectType.
/*DEFINE OUTPUT PARAMETER TABLE FOR ttLayout.*/

  EMPTY TEMP-TABLE ttSmartLinkType.
  EMPTY TEMP-TABLE ttSupportedLink.
  EMPTY TEMP-TABLE ttObjectType.
/*EMPTY TEMP-TABLE ttLayout.*/

  RUN getSmartLinkTypeTT.
  RUN getSupportedLinkTT.
  RUN getObjectTypeTT.
/*RUN getLayoutTT.*/  

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getClassValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getClassValues Procedure 
PROCEDURE getClassValues :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcObjectTypeCode AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttClassValues.
  
  DEFINE VARIABLE cParentClasses  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCounter        AS INTEGER    NO-UNDO.

  EMPTY TEMP-TABLE ttClassValues.

  cParentClasses = DYNAMIC-FUNCTION("getClassParentsFromDB":U IN gshRepositoryManager, pcObjectTypeCode).

  DO iCounter = 1 TO NUM-ENTRIES(cParentClasses):
    IF NOT CAN-FIND(FIRST ttClassValues
                    WHERE ttClassValues.cClassCode = ENTRY(iCounter, cParentClasses)) THEN
    DO:
      FOR FIRST gsc_object_type NO-LOCK
          WHERE gsc_object_type.object_type_code = ENTRY(iCounter, cParentClasses),
           EACH ryc_attribute_value NO-LOCK
          WHERE ryc_attribute_value.primary_smartobject_obj   = 0.00
            AND ryc_attribute_value.container_smartobject_obj = 0.00
            AND ryc_attribute_value.object_instance_obj       = 0.00
            AND ryc_attribute_value.smartobject_obj           = 0.00
            AND ryc_attribute_value.object_type_obj           = gsc_object_type.object_type_obj,
          FIRST ryc_attribute NO-LOCK
          WHERE ryc_attribute.attribute_label = ryc_attribute_value.attribute_label:

        CREATE ttClassValues.
        ASSIGN ttClassValues.cClassCode      = gsc_object_type.OBJECT_type_code
               ttClassValues.cAttributeLabel = ryc_attribute_value.attribute_label.

        CASE ryc_attribute.data_type:
          WHEN {&DECIMAL-DATA-TYPE}   THEN ttClassValues.cAttributeValue = STRING(ryc_attribute_value.decimal_value) NO-ERROR.
          WHEN {&INTEGER-DATA-TYPE}   THEN ttClassValues.cAttributeValue = STRING(ryc_attribute_value.integer_value) NO-ERROR.
          WHEN {&DATE-DATA-TYPE}      THEN ttClassValues.cAttributeValue = STRING(ryc_attribute_value.date_value)    NO-ERROR.
          WHEN {&RAW-DATA-TYPE}       THEN.
          WHEN {&LOGICAL-DATA-TYPE}   THEN ttClassValues.cAttributeValue = STRING(ryc_attribute_value.logical_value) NO-ERROR.
          WHEN {&CHARACTER-DATA-TYPE} THEN ttClassValues.cAttributeValue = ryc_attribute_value.character_value       NO-ERROR.
        END CASE.

        IF ttClassValues.cAttributeValue = ? THEN
          ttClassValues.cAttributeValue = "?":U.
      END.
    END.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainerDetails) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getContainerDetails Procedure 
PROCEDURE getContainerDetails :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcObjectFilename          AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcProductModuleCode       AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcObjectTypeCode          AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pdCustomizationResultObj  AS DECIMAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER TABLE FOR ttSmartObject.
  DEFINE OUTPUT PARAMETER TABLE FOR ttPage.
  DEFINE OUTPUT PARAMETER TABLE FOR ttPageObject.
  DEFINE OUTPUT PARAMETER TABLE FOR ttObjectInstance.
  DEFINE OUTPUT PARAMETER TABLE FOR ttAttributeValue.
  DEFINE OUTPUT PARAMETER TABLE FOR ttUiEvent.
  DEFINE OUTPUT PARAMETER TABLE FOR ttSmartLink.
  DEFINE OUTPUT PARAMETER TABLE FOR ttObjectMenuStructure.
  
  DEFINE BUFFER ryc_layout FOR ryc_layout.

  EMPTY TEMP-TABLE ttObjectMenuStructure.
  EMPTY TEMP-TABLE ttObjectInstance.
  EMPTY TEMP-TABLE ttAttributeValue.
  EMPTY TEMP-TABLE ttSmartObject.
  EMPTY TEMP-TABLE ttSmartLink.
  EMPTY TEMP-TABLE ttUiEvent.
  EMPTY TEMP-TABLE ttPage.
  
  DEFINE BUFFER ryc_smartobject FOR ryc_smartobject.
  
  FIND FIRST ryc_smartobject NO-LOCK
       WHERE ryc_smartobject.object_filename          = pcObjectFilename
         AND ryc_smartobject.customization_result_obj = 0.00 NO-ERROR.
  
  IF AVAILABLE ryc_smartobject THEN
  DO:
    RUN getSmartObjectTT         (INPUT pcObjectFilename, INPUT pdCustomizationResultObj).
    RUN getObjectInstanceTT      (INPUT pcObjectFilename, INPUT pdCustomizationResultObj).
    RUN getAttributeValueTT      (INPUT pcObjectFilename, INPUT pdCustomizationResultObj).
    RUN getUiEventTT             (INPUT pcObjectFilename, INPUT pdCustomizationResultObj).
    RUN getPageTT                (INPUT pcObjectFilename, INPUT pdCustomizationResultObj).
    RUN getSmartLinkTT           (INPUT pcObjectFilename, INPUT pdCustomizationResultObj).
    RUN getObjectMenuStructureTT (INPUT pcObjectFilename, INPUT pdCustomizationResultObj).

    RUN getLayoutDetails (INPUT pdCustomizationResultObj).
  END.
  ELSE
  DO:
    IF pcObjectTypeCode = "":U THEN
      pcObjectTypeCode = "DynObjc":U.

    FIND FIRST gsc_product_module NO-LOCK
         WHERE gsc_product_module.product_module_code = pcProductModuleCode NO-ERROR.

    FIND FIRST gsc_object_type NO-LOCK
         WHERE gsc_object_type.object_type_code = pcObjectTypeCode NO-ERROR.

    FIND FIRST ryc_layout
         WHERE ryc_layout.layout_code = "06":U NO-ERROR.

    CREATE ttSmartObject.
    ASSIGN ttSmartObject.c_action                   = "A":U
           ttSmartObject.d_smartobject_obj          = DYNAMIC-FUNCTION("getTemporaryObj":U)
           ttSmartObject.d_layout_obj               = ryc_layout.layout_obj
           ttSmartObject.d_product_module_obj       = (IF AVAILABLE gsc_product_module THEN gsc_product_module.product_module_obj ELSE 0.00)
           ttSmartObject.d_object_type_obj          = (IF AVAILABLE gsc_object_type    THEN gsc_object_type.object_type_obj       ELSE 0.00)
           ttSmartObject.d_customization_result_obj = pdCustomizationResultObj.

    CREATE ttPage.
    ASSIGN ttPage.d_container_smartobject_obj = ttSmartObject.d_smartobject_obj
           ttPage.d_layout_obj                = ryc_layout.layout_obj
           ttPage.d_page_obj                  = 0
           ttPage.i_page_sequence             = 0
           ttPage.c_page_label                = "Container (Pg. 0)":U
           ttPage.c_plain_label               = "Container (Pg. 0)":U
           ttPage.c_security_token            = "":U
           ttPage.l_enable_on_create          = TRUE
           ttPage.l_enable_on_modify          = TRUE
           ttPage.l_enable_on_view            = TRUE
           ttPage.d_customization_result_obj  = pdCustomizationResultObj.

    CREATE ttSmartObject.
    ASSIGN ttSmartObject.c_object_description       = "THIS-OBJECT"
           ttSmartObject.d_smartobject_obj          = 0.00
           ttSmartObject.c_object_filename          = "THIS-OBJECT"
           ttSmartObject.d_product_module_obj       = (IF AVAILABLE gsc_product_module THEN gsc_product_module.product_module_obj ELSE 0.00)
           ttSmartObject.d_object_type_obj          = (IF AVAILABLE gsc_object_type    THEN gsc_object_type.object_type_obj       ELSE 0.00)
           ttSmartObject.d_customization_result_obj = pdCustomizationResultObj.

    CREATE ttObjectInstance.
    ASSIGN ttObjectInstance.d_container_smartobject_obj = 0.00
           ttObjectInstance.c_instance_name             = "THIS-OBJECT":U
           ttObjectInstance.d_object_instance_obj       = 0.00
           ttObjectInstance.d_smartobject_obj           = 0.00
           ttObjectInstance.d_object_type_obj           = (IF AVAILABLE gsc_object_type THEN gsc_object_type.object_type_obj ELSE 0.00)
           ttObjectInstance.d_customization_result_obj  = pdCustomizationResultObj
           ttObjectInstance.i_column                    = -32 /* This is to get the Links Maintenance to display a space (' ') in the column calculated column */.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLayoutDetails) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLayoutDetails Procedure 
PROCEDURE getLayoutDetails :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdCustomizationResultObj AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE cNewLayout    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLCR          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iColumn       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iRow          AS INTEGER    NO-UNDO.

  DEFINE VARIABLE cFirstAvailable AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCropPages      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lRelativeLayout AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lCropPage       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iCounter        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iPage           AS INTEGER    NO-UNDO.

  DEFINE BUFFER bttObjectInstance FOR ttObjectInstance.
  DEFINE BUFFER  ttObjectInstance FOR ttObjectInstance.
  DEFINE BUFFER  ttSmartObject    FOR ttSmartObject.
  DEFINE BUFFER bttPage           FOR ttPage.
  DEFINE BUFFER  ttPage           FOR ttPage.
  DEFINE BUFFER bgsc_object_type  FOR gsc_object_type.
  DEFINE BUFFER  gsc_object_type  FOR gsc_object_type.
  DEFINE BUFFER  ryc_layout       FOR ryc_layout.

  /* Find the container object */
  FIND FIRST ttSmartObject
       WHERE ttSmartObject.d_smartobject_obj <> 0.00.

  /* Ensure the pages are running from 1 up... */
  FOR EACH ttPage
     WHERE ttPage.d_customization_result_obj = pdCustomizationResultObj
       AND ttPage.i_page_sequence            > 0
       AND ttPage.i_page_sequence            < 1000000
        BY ttPage.i_page_sequence:

    ttPage.i_page_sequence = ttPage.i_page_sequence + 1000000.
  END.

  iPage = 0.
  FOR EACH ttPage
     WHERE ttPage.d_customization_result_obj = pdCustomizationResultObj
       AND ttPage.i_page_sequence           >= 1000000
        BY ttPage.i_page_sequence:

    ASSIGN
        iPage                  = iPage + 1
        ttPage.i_page_sequence = iPage.
  END.

  /* Determine the pages the objects are on */
  FOR EACH ttObjectInstance,
     FIRST ttPage
     WHERE ttPage.d_page_obj = ttObjectInstance.d_page_obj:

    IF AVAILABLE bttPage THEN
      RELEASE bttPage.

    IF pdCustomizationResultObj <> 0.00 AND ttPage.d_customization_result_obj = 0.00 THEN
      FIND FIRST bttPage
           WHERE bttPage.c_page_reference            = ttPage.c_page_reference
             AND bttPage.d_customization_result_obj <> 0.00 NO-ERROR.
      
      ttObjectInstance.i_page = (IF AVAILABLE bttPage THEN bttPage.i_page_sequence ELSE ttPage.i_page_sequence).
  END.

  /* Get the layout details of the objects */
  FOR EACH ttObjectInstance
     WHERE ttObjectInstance.d_smartobject_obj <> 0.00
     BREAK
        BY ttObjectInstance.i_page:

    IF FIRST-OF(ttObjectInstance.i_page) THEN
      lCropPage = FALSE.

    FIND FIRST ttPage
         WHERE ttPage.d_page_obj = ttObjectInstance.d_page_obj NO-ERROR.

    RUN convertLayout (INPUT  ttObjectInstance.d_object_instance_obj,
                       INPUT  ttObjectinstance.c_layout_position,
                       INPUT  ttObjectInstance.i_page,
                       INPUT  ttObjectInstance.l_visible_object,
                       OUTPUT cNewLayout,
                       OUTPUT iRow,
                       OUTPUT iColumn,
                       OUTPUT cLCR,
                       OUTPUT lRelativeLayout).

    IF lRelativeLayout = FALSE AND
       lCropPage       = FALSE THEN
      lCropPage = TRUE.

    FIND FIRST ryc_layout NO-LOCK
         WHERE ryc_layout.layout_code = "06":U NO-ERROR.

    ASSIGN
        iColumn = IF iColumn = 0 THEN 1 ELSE iColumn
        iRow    = IF iRow    = 0 THEN 1 ELSE iRow

        ttObjectInstance.c_layout_position = cNewLayout
        ttObjectInstance.i_column          = iColumn
        ttObjectInstance.i_row             = iRow
        ttObjectInstance.c_lcr             = cLCR.

    IF AVAILABLE ttPage THEN
      ttPage.d_layout_obj = ryc_layout.layout_obj.

    IF LAST-OF(ttObjectInstance.i_page) AND
       lCropPage = TRUE                 THEN
      cCropPages = cCropPages
                 + (IF cCropPages = "":U THEN "":U ELSE ",":U)
                 + TRIM(STRING(ttObjectInstance.i_page)).
  END.

  /* Get correct details for right-aligned objects */
  FOR EACH ttObjectInstance
     WHERE ttObjectInstance.c_lcr = "R":U:

    iColumn = DYNAMIC-FUNCTION("getLastObjectOnRow":U, ttObjectInstance.d_object_instance_obj).
    
    IF iColumn <> ttObjectInstance.i_column THEN
    DO:
      /* Clash on the Right aligned instance positioning */
      FOR EACH bttObjectInstance
         WHERE bttObjectInstance.d_container_smartobject_obj = ttObjectInstance.d_container_smartobject_obj
           AND bttObjectInstance.d_customization_result_obj  = ttObjectInstance.d_customization_result_obj
           AND bttObjectInstance.d_object_instance_obj      <> ttObjectInstance.d_object_instance_obj
           AND bttObjectInstance.l_visible_object            = ttObjectInstance.l_visible_object
           AND bttObjectInstance.i_column                    = iColumn
           AND bttObjectInstance.i_page                      = ttObjectInstance.i_page
           AND bttObjectInstance.i_row                       = ttObjectInstance.i_row.

        bttObjectInstance.i_column = ttObjectInstance.i_column.

        IF bttObjectInstance.c_lcr = "L":U THEN
          SUBSTRING(bttObjectInstance.c_layout_position, 3, 1) = STRING(ttObjectInstance.i_column).
      END.

      ttObjectInstance.i_column = iColumn.
    END.
  END.

  /* Crop all the pages that need to be cropped... */
  DO iCounter = 1 TO NUM-ENTRIES(cCropPages):
    iPage = INTEGER(ENTRY(iCounter, cCropPages)).

    blk_Object:
    FOR EACH ttObjectInstance
       WHERE ttObjectInstance.i_page           = iPage
         AND ttObjectInstance.i_row            < 9
         AND ttObjectInstance.l_visible_object = TRUE
          BY ttObjectInstance.i_row:

      DO iRow = 1 TO ttObjectInstance.i_row - 1.

        FIND FIRST bttObjectInstance
             WHERE bttObjectInstance.i_page = iPage
               AND bttObjectInstance.i_row  = iRow NO-ERROR.

        IF AVAILABLE bttObjectInstance        = FALSE  OR
          (AVAILABLE bttObjectInstance        = TRUE   AND
           bttObjectInstance.l_visible_object = FALSE) THEN
        DO:
          ASSIGN
              ttObjectInstance.i_row                              = iRow
              SUBSTRING(ttObjectInstance.c_layout_position, 2, 1) = TRIM(STRING(iRow)).

          NEXT blk_Object.
        END.
      END.
    END.
  END.

  /* Check for multiple objects in the same position. Objects that had no valid layout will all have a row of 0 and column of 0, meaning they
     will occupy the same grid position */
  FOR EACH bttObjectInstance,
     FIRST bgsc_object_type
     WHERE bgsc_object_type.object_type_obj = bttObjectInstance.d_object_type_obj
        BY bttObjectInstance.i_page
        BY bttObjectInstance.i_row
        BY bttObjectInstance.i_column
        BY bgsc_object_type.object_type_code DESCENDING:

    FOR EACH ttObjectInstance
       WHERE ttObjectInstance.d_object_instance_obj     <> bttObjectInstance.d_object_instance_obj
         AND ttObjectInstance.i_column                   = bttObjectInstance.i_column
         AND ttObjectInstance.i_row                      = bttObjectInstance.i_row
         AND ttObjectInstance.i_page                     = bttObjectInstance.i_page
         AND ttObjectInstance.d_customization_result_obj = bttObjectInstance.d_customization_result_obj
         AND ttObjectInstance.l_visible_object           = bttObjectInstance.l_visible_object,
       FIRST gsc_object_type NO-LOCK
       WHERE gsc_object_type.object_type_obj = ttObjectInstance.d_object_type_obj:

       cFirstAvailable = DYNAMIC-FUNCTION("getFirstAvailable":U, gsc_object_type.object_type_code, ttObjectInstance.i_page, bttObjectInstance.d_customization_result_obj).

       IF cFirstAvailable <> "":U THEN
          ASSIGN
              ttObjectInstance.c_layout_position = cFirstAvailable
              ttObjectInstance.i_row             = INTEGER(SUBSTRING(cFirstAvailable, 2, 1))
              ttObjectInstance.i_column          = INTEGER(SUBSTRING(cFirstAvailable, 3, 1)).
    END.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMasterAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getMasterAttributes Procedure 
PROCEDURE getMasterAttributes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT        PARAMETER pcObjectFilename          AS CHARACTER  NO-UNDO.
  DEFINE INPUT        PARAMETER pcClassCode               AS CHARACTER  NO-UNDO.
  DEFINE INPUT        PARAMETER pdCustomizationResultObj  AS DECIMAL    NO-UNDO.
  DEFINE OUTPUT       PARAMETER TABLE FOR ttAttributeValue.
  DEFINE OUTPUT       PARAMETER TABLE FOR ttUiEvent.
  DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttClassValues.

  DEFINE VARIABLE dCustomizedSmartObjectObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dCurrentSmartObjectObj    AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dMasterSmartObjectObj     AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iCounter                  AS DECIMAL    NO-UNDO.

  DEFINE BUFFER ryc_attribute_value FOR ryc_attribute_value.
  DEFINE BUFFER ryc_smartobject     FOR ryc_smartobject.
  DEFINE BUFFER ryc_attribute       FOR ryc_attribute.

  EMPTY TEMP-TABLE ttAttributeValue.
  EMPTY TEMP-TABLE ttUiEvent.

  pdCustomizationResultObj = (IF pdCustomizationResultObj = ? THEN 0.00 ELSE pdCustomizationResultObj).
  
  IF pcObjectFilename <> "":U THEN
  DO:
    /* See if we can find a customized version of the master smartobject */
    FIND FIRST ryc_smartobject NO-LOCK
         WHERE ryc_smartobject.object_filename          = pcObjectFilename
           AND ryc_smartobject.customization_result_obj = pdCustomizationResultObj NO-ERROR.
      
    IF AVAILABLE ryc_smartobject THEN
      dCustomizedSmartObjectObj = ryc_smartobject.smartobject_obj.
    ELSE
      pdCustomizationResultObj = 0.00.

    FIND FIRST ryc_smartobject NO-LOCK
         WHERE ryc_smartobject.object_filename          = pcObjectFilename
           AND ryc_smartobject.customization_result_obj = 0.00 NO-ERROR.

    IF AVAILABLE ryc_smartobject THEN
      dMasterSmartObjectObj = ryc_smartobject.smartobject_obj.

    DO iCounter = 1 TO (IF pdCustomizationResultObj <> 0.00 THEN 2 ELSE 1):
      IF iCounter = 1 THEN
      DO:
        IF pdCustomizationResultObj <> 0.00 THEN
          dCurrentSmartObjectObj = dCustomizedSmartObjectObj.
        ELSE
          dCurrentSmartObjectObj = dMasterSmartObjectObj.
      END.
      ELSE
        dCurrentSmartObjectObj = dMasterSmartObjectObj.

      FOR EACH ryc_attribute_value NO-LOCK
         WHERE ryc_attribute_value.primary_smartobject_obj   = dCurrentSmartObjectObj
           AND ryc_attribute_value.container_smartobject_obj = 0.00
           AND ryc_attribute_value.object_instance_obj       = 0.00
           AND ryc_attribute_value.smartobject_obj           = dCurrentSmartObjectObj
           AND ryc_attribute_value.object_type_obj           = ryc_smartobject.object_type_obj,
         FIRST ryc_attribute NO-LOCK
         WHERE ryc_attribute.attribute_label = ryc_attribute_value.attribute_label:

        /* See if we have not added it already (for the customization) */
        IF NOT CAN-FIND(FIRST ttAttributeValue
                        WHERE ttAttributeValue.d_smartobject_obj = dMasterSmartObjectObj
                          AND ttAttributeValue.c_attribute_label = ryc_attribute_value.attribute_label) THEN
        DO:
          CREATE ttAttributeValue.
          ASSIGN ttAttributeValue.d_attribute_value_obj       = ryc_attribute_value.attribute_value_obj
                 ttAttributeValue.d_object_type_obj           = ryc_attribute_value.object_type_obj
                 ttAttributeValue.d_container_smartobject_obj = ryc_attribute_value.container_smartobject_obj /* 0.00 */
                 ttAttributeValue.d_object_instance_obj       = ryc_attribute_value.object_instance_obj       /* 0.00 */
                 ttAttributeValue.d_smartobject_obj           = dMasterSmartObjectObj                         /* This is intentional */
                 ttAttributeValue.l_constant_value            = ryc_attribute_value.constant_value
                 ttAttributeValue.c_attribute_label           = ryc_attribute_value.attribute_label
                 ttAttributeValue.c_character_value           = ryc_attribute_value.character_value
                 ttAttributeValue.i_integer_value             = ryc_attribute_value.integer_value
                 ttAttributeValue.t_date_value                = ryc_attribute_value.date_value
                 ttAttributeValue.d_decimal_value             = ryc_attribute_value.decimal_value
                 ttAttributeValue.l_logical_value             = ryc_attribute_value.logical_value
                 ttAttributeValue.r_raw_value                 = ryc_attribute_value.raw_value
                 ttAttributeValue.d_primary_smartobject_obj   = dMasterSmartObjectObj                         /* This is intentional */
                 ttAttributeValue.i_data_type                 = ryc_attribute.data_type
                 ttAttributeValue.c_customization_result_code = "":U
                 ttAttributeValue.d_customization_result_obj  = 0.00
                 ttAttributeValue.l_master_attribute          = TRUE.
        END.
      END.

      FOR EACH ryc_ui_event NO-LOCK
         WHERE ryc_ui_event.primary_smartobject_obj   = dCurrentSmartObjectObj
           AND ryc_ui_event.container_smartobject_obj = 0.00
           AND ryc_ui_event.object_instance_obj       = 0.00
           AND ryc_ui_event.smartobject_obj           = dCurrentSmartObjectObj
           AND ryc_ui_event.object_type_obj           = ryc_smartobject.object_type_obj:

        /* See if we have not added it already (for the customization) */
        IF NOT CAN-FIND(FIRST ttUiEvent
                        WHERE ttUiEvent.d_smartobject_obj = dMasterSmartObjectObj
                          AND ttUiEvent.c_event_name      = ryc_ui_event.event_name) THEN
        DO:
          CREATE ttUiEvent.
          ASSIGN ttUiEvent.d_ui_event_obj              = ryc_ui_event.ui_event_obj
                 ttUiEvent.d_object_type_obj           = ryc_ui_event.object_type_obj
                 ttUiEvent.d_container_smartobject_obj = ryc_ui_event.container_smartobject_obj /* 0.00 */
                 ttUiEvent.d_object_instance_obj       = ryc_ui_event.object_instance_obj       /* 0.00 */
                 ttUiEvent.d_smartobject_obj           = dMasterSmartObjectObj                  /* This is intentional */
                 ttUiEvent.c_event_name                = ryc_ui_event.event_name
                 ttUiEvent.l_constant_value            = ryc_ui_event.constant_value
                 ttUiEvent.c_action_type               = ryc_ui_event.action_type
                 ttUiEvent.c_action_target             = ryc_ui_event.action_target
                 ttUiEvent.c_event_action              = ryc_ui_event.event_action
                 ttUiEvent.c_event_parameter           = ryc_ui_event.event_parameter
                 ttUiEvent.l_event_disabled            = ryc_ui_event.event_disabled
                 ttUiEvent.d_primary_smartobject_obj   = dMasterSmartObjectObj                  /* This is intentional */
                 ttUiEvent.c_customization_result_code = "":U
                 ttUiEvent.d_customization_result_obj  = 0.00
                 ttUiEvent.l_master_event              = TRUE.
        END.
      END.
    END.
  END.

  IF pcClassCode <> "":U THEN
  DO:
    RUN getClassValues (INPUT pcClassCode,
                        INPUT-OUTPUT TABLE ttClassValues).
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectInstanceTT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getObjectInstanceTT Procedure 
PROCEDURE getObjectInstanceTT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcObjectFilename         AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pdCustomizationResultObj AS DECIMAL    NO-UNDO.
  
  DEFINE VARIABLE cAttributeValue           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizedSmartObjectObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dContainerSmartObjectObj  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dMainSmartObjectObj       AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iObjectInstance           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iIterations               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iContainer                AS INTEGER    NO-UNDO.
  
  DEFINE BUFFER b_ryc_object_instance FOR ryc_object_instance.
  DEFINE BUFFER   ryc_object_instance FOR ryc_object_instance.
  DEFINE BUFFER   ryc_smartobject     FOR ryc_smartobject.
  DEFINE BUFFER   ttSmartObject       FOR ttSmartObject.
    DEFINE BUFFER rycav_super           FOR ryc_attribute_value.

  FOR EACH ttSmartObject
     WHERE ttSmartObject.d_smartobject_obj <> 0.00:

    IF ttSmartObject.d_customization_result_obj = 0.00 THEN
      dMainSmartObjectObj = ttSmartObject.d_smartobject_obj.
    ELSE
      dCustomizedSmartObjectObj = ttSmartObject.d_smartobject_obj.
  END.

  /* Create the main container's object instances and the object instances for the customized container that don't exist */
  DO iContainer = 1 TO (IF pdCustomizationResultObj = 0.00 THEN 1 ELSE 2):
    
    dContainerSmartObjectObj = (IF iContainer = 1 THEN dMainSmartObjectObj ELSE dCustomizedSmartObjectObj).

    /* If we are creating the main container's object instances, then we need to create an object instance record for object instances which
       have not been customized yet to allow the container builder to customize them. The first iteration of iIteration creates the original
       object instances. Object instances that have been customized will be skipped during the second iteration of iIterations, but will be
       created during the second iteration of iContainer (when iIterations will only be iterated once)  */
    IF iContainer = 1 THEN
      iIterations = (IF pdCustomizationResultObj = 0.00 THEN 1 ELSE 2).
    ELSE
      iIterations = 1.
    
    FOR EACH ryc_object_instance NO-LOCK
       WHERE ryc_object_instance.container_smartobject_obj = dContainerSmartObjectObj,
       FIRST ryc_smartobject NO-LOCK
       WHERE ryc_smartobject.smartobject_obj = ryc_object_instance.smartobject_obj:
      
      DO iObjectInstance = 1 TO iIterations:

        /* If we are going to retrieve object instance data for a customized container, and we can find an object instance that has been customized, then
           skip the record if we are reading the data for the main container. */
        IF iObjectInstance = 2 THEN
          IF CAN-FIND(FIRST b_ryc_object_instance NO-LOCK
                      WHERE b_ryc_object_instance.container_smartobject_obj = dCustomizedSmartObjectObj
                        AND b_ryc_object_instance.smartobject_obj           = ryc_object_instance.smartobject_obj
                        AND b_ryc_object_instance.instance_name             = ryc_object_instance.instance_name) THEN
            NEXT.

        CREATE ttObjectInstance.
        ASSIGN ttObjectInstance.d_container_smartobject_obj = IF iObjectInstance = 1 THEN dContainerSmartObjectObj                  ELSE dCustomizedSmartObjectObj
               ttObjectInstance.d_object_instance_obj       = IF iObjectInstance = 1 THEN ryc_object_instance.object_instance_obj   ELSE DYNAMIC-FUNCTION("getTemporaryObj":U)
               ttObjectInstance.d_customization_result_obj  = IF iObjectInstance = 1 AND iContainer = 1 THEN 0.00                   ELSE pdCustomizationResultObj
               ttObjectInstance.c_action                    = IF iObjectInstance = 1 THEN "":U                                      ELSE "A":U
               ttObjectInstance.d_smartobject_obj           = ryc_object_instance.smartobject_obj
               ttObjectInstance.d_object_type_obj           = ryc_smartobject.object_type_obj
               ttObjectInstance.c_instance_description      = IF TRIM(ryc_object_instance.instance_description) = "":U THEN ryc_smartobject.object_description ELSE ryc_object_instance.instance_description
               ttObjectInstance.c_instance_name             = IF TRIM(ryc_object_instance.instance_name) = "":U THEN ryc_smartobject.object_filename ELSE ryc_object_instance.instance_name
               ttObjectInstance.l_system_owned              = ryc_object_instance.system_owned
               ttObjectInstance.c_layout_position           = ryc_object_instance.layout_position
               ttObjectInstance.c_smartobject_filename      = ryc_smartobject.object_filename
               ttObjectInstance.l_visible_object            = DYNAMIC-FUNCTION("isVisibleObject":U, ttObjectInstance.d_object_instance_obj)
               ttObjectInstance.d_page_obj                  = ryc_object_instance.page_obj
               ttObjectInstance.i_object_sequence           = ryc_object_instance.object_sequence
               cAttributeValue                              = DYNAMIC-FUNCTION("getAttributeValueNew":U, "ResizeHorizontal":U,             /* pcAttributeLabel           */
                                                                                                      ttObjectInstance.c_instance_name, /* pcInstanceName             */
                                                                                                      ryc_smartobject.object_type_obj,  /* pdObjectTypeObj            */
                                                                                                      ryc_smartobject.smartobject_obj,  /* pdSmartObjectObj           */
                                                                                                      dCustomizedSmartObjectObj,        /* pdCustomizedSmartObjectObj */
                                                                                                      dMainSmartObjectObj,              /* pdMainSmartObjectObj       */
                                                                                                      pdCustomizationResultObj)         /* pdCustomizationResultObj   */
               ttObjectInstance.l_resize_horizontal         = IF cAttributeValue = "TRUE":U OR cAttributeValue = "YES":U THEN TRUE ELSE FALSE
               cAttributeValue                              = DYNAMIC-FUNCTION("getAttributeValueNew":U, "ResizeVertical":U,               /* pcAttributeLabel           */
                                                                                                      ttObjectInstance.c_instance_name, /* pcInstanceName             */
                                                                                                      ryc_smartobject.object_type_obj,  /* pdObjectTypeObj            */
                                                                                                      ryc_smartobject.smartobject_obj,  /* pdSmartObjectObj           */
                                                                                                      dCustomizedSmartObjectObj,        /* pdCustomizedSmartObjectObj */
                                                                                                      dMainSmartObjectObj,              /* pdMainSmartObjectObj       */
                                                                                                      pdCustomizationResultObj)         /* pdCustomizationResultObj   */
               ttObjectInstance.l_resize_vertical           = IF cAttributeValue = "TRUE":U OR cAttributeValue = "YES":U THEN TRUE ELSE FALSE
               ttObjectInstance.c_foreign_fields            = DYNAMIC-FUNCTION("getAttributeValueNew":U, "ForeignFields":U,               /* pcAttributeLabel           */
                                                                                                      ttObjectInstance.c_instance_name, /* pcInstanceName             */
                                                                                                      ryc_smartobject.object_type_obj,  /* pdObjectTypeObj            */
                                                                                                      ryc_smartobject.smartobject_obj,  /* pdSmartObjectObj           */
                                                                                                      dCustomizedSmartObjectObj,        /* pdCustomizedSmartObjectObj */
                                                                                                      dMainSmartObjectObj,              /* pdMainSmartObjectObj       */
                                                                                                      pdCustomizationResultObj)         /* pdCustomizationResultObj   */
               .
               /** Populate the custom super procedure obj from the attribute value, not 
                *  from a field on the ryc-smartobject record. 
                *  ----------------------------------------------------------------------- **/
               FIND FIRST rycav_super WHERE
                          rycav_super.object_type_obj           = ryc_smartObject.object_type_obj               AND
                          rycav_super.smartObject_obj           = ryc_smartObject.smartObject_obj               AND
                          rycav_super.object_instance_obj       = ryc_object_instance.object_instance_obj       AND
                          rycav_super.container_smartObject_obj = ryc_object_instance.container_smartObject_obj AND
                          rycav_super.attribute_label           = "SuperProcedure":U
                          NO-LOCK NO-ERROR.
               IF AVAILABLE rycav_super THEN
               DO:
                   ASSIGN ttObjectInstance.d_custom_smartobject_obj = DYNAMIC-FUNCTION("getSmartObjectObj":U IN gshRepositoryManager,
                                                                                       INPUT rycav_super.character_value,
                                                                                       INPUT ryc_smartobject.customization_result_obj).
                   IF ttObjectInstance.d_custom_smartobject_obj EQ ? THEN
                       ASSIGN ttObjectInstance.d_custom_smartobject_obj = 0.
               END.    /* thre is a superProcedure attribute for this master. */
      END.  /* iterations loop */
    END.
  END.
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectMenuStructureTT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getObjectMenuStructureTT Procedure 
PROCEDURE getObjectMenuStructureTT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcObjectFilename         AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pdCustomizationResultObj AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE dCustomizedSmartObjectObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dMainSmartObjectObj       AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dSmartObjectObj           AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iCounter                  AS INTEGER    NO-UNDO.

  DEFINE BUFFER gsm_object_menu_structure FOR gsm_object_menu_structure.
  DEFINE BUFFER gsc_instance_attribute    FOR gsc_instance_attribute.
  DEFINE BUFFER gsm_menu_structure        FOR gsm_menu_structure.
  DEFINE BUFFER bgsm_menu_item            FOR gsm_menu_item.
  DEFINE BUFFER gsm_menu_item             FOR gsm_menu_item.

  FOR EACH ttSmartObject
     WHERE ttSmartObject.d_smartobject_obj <> 0.00:
    
    IF ttSmartObject.d_customization_result_obj = 0.00 THEN
      dMainSmartObjectObj = ttSmartObject.d_smartobject_obj.
    ELSE
      dCustomizedSmartObjectObj = ttSmartObject.d_smartobject_obj.
  END.

  DO iCounter = 1 TO (IF pdCustomizationResultObj = 0.00 THEN 1 ELSE 2):

    IF iCounter = 1 THEN
      dSmartObjectObj = dMainSmartObjectObj.
    ELSE
      dSmartObjectObj = dCustomizedSmartObjectObj.

    FOR EACH gsm_object_menu_structure NO-LOCK
       WHERE gsm_object_menu_structure.object_obj = dSmartObjectObj,
       FIRST gsm_menu_structure NO-LOCK
       WHERE gsm_menu_structure.menu_structure_obj = gsm_object_menu_structure.menu_structure_obj:

      FIND FIRST gsc_instance_attribute NO-LOCK
           WHERE gsc_instance_attribute.instance_attribute_obj = gsm_object_menu_structure.instance_attribute_obj NO-ERROR.

      FIND FIRST gsm_menu_item NO-LOCK
           WHERE gsm_menu_item.menu_item_obj = gsm_menu_structure.menu_item_obj NO-ERROR.

      FIND FIRST bgsm_menu_item NO-LOCK
           WHERE bgsm_menu_item.menu_item_obj = gsm_object_menu_structure.menu_item_obj NO-ERROR.

      CREATE ttObjectMenuStructure.
      ASSIGN ttObjectMenuStructure.d_object_obj                 = gsm_object_menu_structure.object_obj
             ttObjectMenuStructure.d_menu_structure_obj         = gsm_object_menu_structure.menu_structure_obj
             ttObjectMenuStructure.d_instance_attribute_obj     = gsm_object_menu_structure.instance_attribute_obj
             ttObjectMenuStructure.d_object_menu_structure_obj  = gsm_object_menu_structure.object_menu_structure_obj
             ttObjectMenuStructure.d_menu_item_obj              = gsm_object_menu_structure.menu_item_obj
             ttObjectMenuStructure.l_insert_submenu             = gsm_object_menu_structure.insert_submenu
             ttObjectMenuStructure.i_menu_structure_sequence    = gsm_object_menu_structure.menu_structure_sequence
             ttObjectMenuStructure.c_menu_structure_description = gsm_menu_structure.menu_structure_description
             ttObjectMenuStructure.c_menu_structure_code        = gsm_menu_structure.menu_structure_code

             ttObjectMenuStructure.c_attribute_code             = (IF NOT AVAILABLE gsc_instance_attribute THEN "":U ELSE gsc_instance_attribute.attribute_code)
             ttObjectMenuStructure.c_menu_item_label            = (IF NOT AVAILABLE gsm_menu_item          THEN "":U ELSE gsm_menu_item.menu_item_label)
             ttObjectMenuStructure.c_item_placeholder_label     = (IF NOT AVAILABLE bgsm_menu_item         THEN "":U ELSE bgsm_menu_item.menu_item_label)

             ttObjectMenuStructure.d_customization_result_obj   = (IF iCounter = 1 THEN 0.00 ELSE pdCustomizationResultObj).

      IF ttObjectMenuStructure.c_menu_item_label = "":U THEN
        ttObjectMenuStructure.c_menu_item_label = gsm_menu_structure.menu_structure_code.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectTypeTT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getObjectTypeTT Procedure 
PROCEDURE getObjectTypeTT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE BUFFER gsc_object_type FOR gsc_object_type.

  FOR EACH gsc_object_type NO-LOCK:

    CREATE ttObjectType.
    ASSIGN ttObjectType.c_object_type_code  = gsc_object_type.object_type_code
           ttObjectType.d_object_type_obj   = gsc_object_type.object_type_obj
           .
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPageTT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPageTT Procedure 
PROCEDURE getPageTT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcObjectFilename         AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pdCustomizationResultObj AS DECIMAL    NO-UNDO.

  DEFINE BUFFER ryc_smartobject FOR ryc_smartobject.
  DEFINE BUFFER ttSmartObject   FOR ttSmartObject.
  DEFINE BUFFER b_ryc_page      FOR ryc_page.
  DEFINE BUFFER   ryc_page      FOR ryc_page.

  DEFINE VARIABLE dCustomizedSmartObjectObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dMainSmartObjectObj       AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dLayoutObj                AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iPageSequence             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCounter                  AS INTEGER    NO-UNDO.

  /* Find the containers' smartobject object numbers an the layout of the container */
  FOR EACH ttSmartObject
     WHERE ttSmartObject.d_smartobject_obj <> 0.00:

    IF ttSmartObject.d_customization_result_obj = 0.00 THEN
      ASSIGN
          dMainSmartObjectObj = ttSmartObject.d_smartobject_obj
          dLayoutObj          = ttSmartObject.d_layout_obj.
    ELSE
      dCustomizedSmartObjectObj = ttSmartObject.d_smartobject_obj.
  END.

  /* Create the main container's pages and pages for (to be / already) customized container that doesn't have any customizations yet*/
  FOR EACH ryc_page NO-LOCK
     WHERE ryc_page.container_smartobject_obj = dMainSmartObjectObj:

    DO iCounter = 1 TO (IF pdCustomizationResultObj = 0.00 THEN 1 ELSE 2):
      /* Exclude pages that have been customized */
      IF iCounter = 2 THEN
        IF CAN-FIND(FIRST b_ryc_page
                    WHERE b_ryc_page.container_smartobject_obj = dCustomizedSmartObjectObj
                      AND b_ryc_page.page_reference            = ryc_page.page_reference) THEN
          NEXT.

      CREATE ttPage.
      ASSIGN ttPage.d_container_smartobject_obj = IF iCounter = 1 THEN dMainSmartObjectObj ELSE dCustomizedSmartObjectObj
             ttPage.d_customization_result_obj  = IF iCounter = 1 THEN 0.00                ELSE pdCustomizationResultObj
             ttPage.c_action                    = IF iCounter = 1 THEN "":U                ELSE "A":U
             ttPage.d_layout_obj                = ryc_page.layout_obj
             ttPage.i_page_sequence             = ryc_page.page_sequence
             ttPage.c_page_label                = ryc_page.page_label
             ttPage.c_plain_label               = REPLACE(ttPage.c_page_label, "&":U, "":U)
             ttPage.c_security_token            = ryc_page.security_token
             ttPage.l_enable_on_create          = ryc_page.enable_on_create
             ttPage.l_enable_on_modify          = ryc_page.enable_on_modify
             ttPage.l_enable_on_view            = ryc_page.enable_on_view
             ttPage.i_original_page_sequence    = ryc_page.page_sequence
             ttPage.c_page_reference            = ryc_page.page_reference.
             ttPage.d_page_obj                  = IF iCounter = 1 THEN ryc_page.page_obj ELSE DYNAMIC-FUNCTION("getTemporaryObj":U).
    END.
  END.
  
  /* Now create the pages that have been customized or added */
  FOR EACH ryc_page NO-LOCK
     WHERE ryc_page.container_smartobject_obj = dCustomizedSmartObjectObj:

    CREATE ttPage.
    ASSIGN /*iPageSequence                    = {fnarg getUniquePageSequence pdCustomizationResultObj}*/
           ttPage.d_container_smartobject_obj = dCustomizedSmartObjectObj
           ttPage.d_customization_result_obj  = pdCustomizationResultObj
           ttPage.d_page_obj                  = ryc_page.page_obj
           ttPage.d_layout_obj                = ryc_page.layout_obj
         /*ttPage.i_page_sequence             = iPageSequence*/
           ttPage.i_page_sequence             = ryc_page.page_sequence
           ttPage.c_page_label                = ryc_page.page_label
           ttPage.c_plain_label               = REPLACE(ttPage.c_page_label, "&":U, "":U)
           ttPage.c_security_token            = ryc_page.security_token
           ttPage.l_enable_on_create          = ryc_page.enable_on_create
           ttPage.l_enable_on_modify          = ryc_page.enable_on_modify
           ttPage.l_enable_on_view            = ryc_page.enable_on_view
           ttPage.i_original_page_sequence    = ryc_page.page_sequence
           ttPage.c_page_reference            = ryc_page.page_reference.
  END.
  
  /* Create page number zero for the main and customized container */
  DO iCounter = 1 TO (IF pdCustomizationResultObj = 0.00 THEN 1 ELSE 2):
    CREATE ttPage.
    ASSIGN ttPage.d_container_smartobject_obj = IF iCounter = 1 THEN dMainSmartObjectObj ELSE dCustomizedSmartObjectObj
           ttPage.d_customization_result_obj  = IF iCounter = 1 THEN 0.00                ELSE pdCustomizationResultObj
           ttPage.d_page_obj                  = 0
           ttPage.i_page_sequence             = 0
           ttPage.d_layout_obj                = dLayoutObj
           ttPage.c_page_label                = "Container (Pg. 0)":U
           ttPage.c_plain_label               = "Container (Pg. 0)":U
           ttPage.c_security_token            = "":U
           ttPage.l_enable_on_create          = TRUE
           ttPage.l_enable_on_modify          = TRUE
           ttPage.l_enable_on_view            = TRUE.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSmartLinkTT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSmartLinkTT Procedure 
PROCEDURE getSmartLinkTT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcObjectFilename         AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pdCustomizationResultObj AS DECIMAL    NO-UNDO.

  DEFINE BUFFER ryc_smartobject FOR ryc_smartobject.
  DEFINE BUFFER ryc_smartlink   FOR ryc_smartlink.
  
  DEFINE VARIABLE dCustomizedSmartObjectObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dMainSmartObjectObj       AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iCounter                  AS INTEGER    NO-UNDO.
  
  FOR EACH ttSmartObject
     WHERE ttSmartObject.d_smartobject_obj <> 0.00:
    
    IF ttSmartObject.d_customization_result_obj = 0.00 THEN
      dMainSmartObjectObj = ttSmartObject.d_smartobject_obj.
    ELSE
      dCustomizedSmartObjectObj = ttSmartObject.d_smartobject_obj.
  END.

  /* Create the main container's links */
  FOR EACH ryc_smartlink NO-LOCK
     WHERE ryc_smartlink.container_smartobject_obj = dMainSmartObjectObj:
    
    CREATE ttSmartLink.
    ASSIGN ttSmartLink.d_container_smartobject_obj  = dMainSmartObjectObj
           ttSmartLink.d_customization_result_obj   = 0.00
           ttSmartLink.d_smartlink_obj              = ryc_smartlink.smartlink_obj
           ttSmartLink.d_smartlink_type_obj         = ryc_smartlink.smartlink_type_obj
           ttSmartLink.c_link_name                  = ryc_smartlink.link_name
           ttSmartLink.d_source_object_instance_obj = ryc_smartlink.source_object_instance_obj
           ttSmartLink.d_target_object_instance_obj = ryc_smartlink.target_object_instance_obj
           .
  END.
  
  /* Create the customized container's links */
  FOR EACH ryc_smartlink NO-LOCK
     WHERE ryc_smartlink.container_smartobject_obj = dCustomizedSmartObjectObj:
    
    CREATE ttSmartLink.
    ASSIGN ttSmartLink.d_container_smartobject_obj  = dCustomizedSmartObjectObj
           ttSmartLink.d_customization_result_obj   = pdCustomizationResultObj
           ttSmartLink.d_smartlink_obj              = ryc_smartlink.smartlink_obj
           ttSmartLink.d_smartlink_type_obj         = ryc_smartlink.smartlink_type_obj
           ttSmartLink.c_link_name                  = ryc_smartlink.link_name
           ttSmartLink.d_source_object_instance_obj = ryc_smartlink.source_object_instance_obj
           ttSmartLink.d_target_object_instance_obj = ryc_smartlink.target_object_instance_obj
           .
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSmartLinkTypeTT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSmartLinkTypeTT Procedure 
PROCEDURE getSmartLinkTypeTT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE BUFFER ryc_smartlink_type FOR ryc_smartlink_type.
  
  FOR EACH ryc_smartlink_type NO-LOCK:
    
    CREATE ttSmartLinkType.
    ASSIGN ttSmartLinkType.d_smartlink_type_obj       = ryc_smartlink_type.smartlink_type_obj
           ttSmartLinkType.c_link_name                = ryc_smartlink_type.link_name
           ttSmartLinkType.l_user_defined_link        = ryc_smartlink_type.user_defined_link
           .
  END.
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSmartObjectTT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSmartObjectTT Procedure 
PROCEDURE getSmartObjectTT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       This procedure will retrieve the data of the container smartobject.
               It will also retrieve the data for a customized version of the
               smartobject. If it doesn't exist, it will create a copy of the
               smartobject that can then be customized. If nothing was found
               to differ, then the record should not be saved.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcObjectFilename         AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pdCustomizationResultObj AS DECIMAL    NO-UNDO.

  /*DEFINE BUFFER b_ryc_smartobject FOR ryc_smartobject.*/
  DEFINE BUFFER   ryc_smartobject FOR ryc_smartobject.
    DEFINE BUFFER rycav_super       FOR ryc_attribute_value.
  
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dMainSmartObjectObj     AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lCustomizationAvailable AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iCounter                AS INTEGER    NO-UNDO.
  
  lCustomizationAvailable = CAN-FIND(FIRST ryc_smartobject NO-LOCK
                                     WHERE ryc_smartobject.object_filename          = pcObjectFilename
                                       AND ryc_smartobject.customization_result_obj = pdCustomizationResultObj).

  DO iCounter = 1 TO (IF pdCustomizationResultObj = 0.00 THEN 1 ELSE 2):
    dCustomizationResultObj = (IF iCounter = 1 THEN 0.00 ELSE (IF lCustomizationAvailable THEN pdCustomizationResultObj ELSE 0.00)).
    
    /* This is the main smartobject containing all the other smartobjects */
    FOR FIRST ryc_smartobject NO-LOCK
        WHERE ryc_smartobject.object_filename          = pcObjectFilename
          AND ryc_smartobject.customization_result_obj = dCustomizationResultObj:

      IF iCounter = 1 THEN
        dMainSmartObjectObj = ryc_smartobject.smartobject_obj.

      CREATE ttSmartObject.
      ASSIGN ttSmartObject.c_object_description       = ryc_smartobject.object_description
             ttSmartObject.d_smartobject_obj          = IF iCounter = 1 THEN ryc_smartobject.smartobject_obj
                                                                        ELSE (IF lCustomizationAvailable THEN ryc_smartobject.smartobject_obj ELSE DYNAMIC-FUNCTION("getTemporaryObj":U))
             ttSmartObject.d_customization_result_obj = IF iCounter = 1 THEN 0.00 ELSE pdCustomizationResultObj
             ttSmartObject.c_action                   = IF lCustomizationAvailable THEN "":U ELSE "A":U
             ttSmartObject.d_layout_obj               = ryc_smartobject.layout_obj
             ttSmartObject.d_object_type_obj          = ryc_smartobject.object_type_obj
             ttSmartObject.c_object_filename          = ryc_smartobject.object_filename
             ttSmartObject.d_product_module_obj       = ryc_smartobject.product_module_obj
             ttSmartObject.l_static_object            = ryc_smartobject.static_object
             
             ttSmartObject.l_system_owned             = ryc_smartobject.system_owned
             ttSmartObject.c_shutdown_message_text    = ryc_smartobject.shutdown_message_text
             ttSmartObject.d_sdo_smartobject_obj      = ryc_smartobject.sdo_smartobject_obj
             ttSmartObject.l_template_smartobject     = ryc_smartobject.template_smartobject
/*           ttSmartObject.c_default_mode             = DYNAMIC-FUNCTION("getAttributeValue":U, "ContainerMode":U,               /* pcAttributeLabel          */
                                                                                                ryc_smartobject.object_type_obj, /* pdObjectTypeObj           */
                                                                                                ryc_smartobject.smartobject_obj, /* pdSmartObjectObj          */
                                                                                                0.00,                            /* pdObjectInstanceObj       */
                                                                                                0.00)                            /* pdContainerSmartObjectObj */
*/
             ttSmartObject.c_template_object_name = DYNAMIC-FUNCTION("getAttributeValueNew":U, "TemplateObjectName":U,          /* pcAttributeLabel           */
                                                                                               "":U,                            /* pcInstanceName             */
                                                                                               ryc_smartobject.object_type_obj, /* pdObjectTypeObj            */
                                                                                               dMainSmartObjectObj,             /* pdSmartObjectObj           */
                                                                                               0.00,                            /* pdCustomizedSmartObjectObj */
                                                                                               dMainSmartObjectObj,             /* pdMainSmartObjectObj       */
                                                                                               0.00)                            /* pdCustomizationResultObj   */
             .
        /** Populate the custom super procedure obj from the attribute value, not 
         *  from a field on the ryc-smartobject record. 
         *  ----------------------------------------------------------------------- **/
        FIND FIRST rycav_super WHERE
                   rycav_super.object_type_obj     = ryc_smartObject.object_type_obj AND
                   rycav_super.smartObject_obj     = ryc_smartObject.smartObject_obj AND
                   rycav_super.object_instance_obj = 0                               AND
                   rycav_super.attribute_label     = "SuperProcedure":U
                   NO-LOCK NO-ERROR.
        IF AVAILABLE rycav_super THEN
        DO:
            ASSIGN ttSmartObject.d_custom_smartobject_obj = DYNAMIC-FUNCTION("getSmartObjectObj":U IN gshRepositoryManager,
                                                                             INPUT rycav_super.character_value,
                                                                             INPUT ryc_smartobject.customization_result_obj)
                   ttSmartObject.c_custom_super_procedure = rycav_super.character_value.
            IF ttSmartObject.d_custom_smartobject_obj EQ ? THEN
                ASSIGN ttSmartObject.d_custom_smartobject_obj = 0
                       ttSmartObject.c_custom_super_procedure = "":U.
        END.    /* thre is a superProcedure attribute for this master. */        

      IF iCounter = 1 THEN
      DO:
        CREATE ttSmartObject.
        ASSIGN ttSmartObject.c_object_description     = "THIS-OBJECT"
               ttSmartObject.d_smartobject_obj        = 0.00
               ttSmartObject.c_object_filename        = "THIS-OBJECT"
               ttSmartObject.d_object_type_obj        = ryc_smartobject.object_type_obj.
      
        CREATE ttObjectInstance.
        ASSIGN ttObjectInstance.d_container_smartobject_obj = 0.00
               ttObjectInstance.c_instance_name             = "THIS-OBJECT":U
               ttObjectInstance.d_object_instance_obj       = 0.00
               ttObjectInstance.d_smartobject_obj           = 0.00
               ttObjectInstance.d_customization_result_obj  = pdCustomizationResultObj
               ttObjectInstance.d_object_type_obj           = ryc_smartobject.object_type_obj
               ttObjectInstance.i_column                    = -32 /* This is to get the Links Maintenance to display a space (' ') in the column calculated column */.
      END.
    END.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSupportedLinkTT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSupportedLinkTT Procedure 
PROCEDURE getSupportedLinkTT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cInheritsFrom AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCounter      AS INTEGER    NO-UNDO.
  
  DEFINE BUFFER  ryc_supported_link FOR ryc_supported_link.
  DEFINE BUFFER bgsc_object_type    FOR gsc_object_type.
  DEFINE BUFFER  gsc_object_type    FOR gsc_object_type.

  FOR EACH bgsc_object_type NO-LOCK:
    cInheritsFrom = DYNAMIC-FUNCTION("inheritsFrom":U, bgsc_object_type.object_type_code).

    DO iCounter = 1 TO NUM-ENTRIES(cInheritsFrom):
      FOR FIRST gsc_object_type NO-LOCK
          WHERE gsc_object_type.object_type_code = ENTRY(iCounter, cInheritsFrom),
           EACH ryc_supported_link
          WHERE ryc_supported_link.object_type_obj = gsc_object_type.object_type_obj:
      
        CREATE ttSupportedLink.
        ASSIGN ttSupportedLink.d_object_type_obj          = bgsc_object_type.object_type_obj
               ttSupportedLink.d_smartlink_type_obj       = ryc_supported_link.smartlink_type_obj
               ttSupportedLink.l_link_source              = ryc_supported_link.link_source
               ttSupportedLink.l_link_target              = ryc_supported_link.link_target
               .
      END.
    END.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUiEventTT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getUiEventTT Procedure 
PROCEDURE getUiEventTT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcObjectFilename         AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pdCustomizationResultObj AS DECIMAL    NO-UNDO.
  
  DEFINE VARIABLE dCustomizedSmartObjectObj AS DECIMAL  NO-UNDO.
  DEFINE VARIABLE dCurrentSmartObjectObj    AS DECIMAL  NO-UNDO.
  DEFINE VARIABLE dCustomizedMasterObj      AS DECIMAL  NO-UNDO.
  DEFINE VARIABLE dMainSmartObjectObj       AS DECIMAL  NO-UNDO.
  DEFINE VARIABLE dSmartObjectObj           AS DECIMAL  NO-UNDO.
  DEFINE VARIABLE dObjectTypeObj            AS DECIMAL  NO-UNDO.
  DEFINE VARIABLE dMasterObj                AS DECIMAL  NO-UNDO.
  DEFINE VARIABLE lCreateAsMaster           AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE iCounter                  AS INTEGER  NO-UNDO.
  DEFINE VARIABLE iMaster                   AS INTEGER  NO-UNDO.
  
  DEFINE BUFFER ryc_customization_result FOR ryc_customization_result.
  DEFINE BUFFER ryc_ui_event      FOR ryc_ui_event.
  
  FOR EACH ttSmartObject
     WHERE ttSmartObject.d_smartobject_obj <> 0.00:
    
    IF dObjectTypeObj = 0.00 THEN
      dObjectTypeObj = ttSmartObject.d_object_type_obj.
    
    IF ttSmartObject.d_customization_result_obj = 0.00 THEN
      dMainSmartObjectObj = ttSmartObject.d_smartobject_obj.
    ELSE
      dCustomizedSmartObjectObj = ttSmartObject.d_smartobject_obj.
  END.
  
  FIND FIRST ryc_customization_result NO-LOCK
       WHERE ryc_customization_result.customization_result_obj = pdCustomizationResultObj NO-ERROR.

  /* Read the attributes for the main and customized container */
  DO iCounter = 1 TO (IF pdCustomizationResultObj = 0.00 THEN 1 ELSE 2):
    
    IF iCounter = 1 THEN
      dSmartObjectObj = dMainSmartObjectObj.
    ELSE
      dSmartObjectObj = dCustomizedSmartObjectObj.

    /* Get the ui events for the container */
    FOR EACH ryc_ui_event NO-LOCK
       WHERE ryc_ui_event.primary_smartobject_obj   = dSmartObjectObj
         AND ryc_ui_event.container_smartobject_obj = 0.00
         AND ryc_ui_event.object_instance_obj       = 0.00
         AND ryc_ui_event.smartobject_obj           = dSmartObjectObj
         AND ryc_ui_event.object_type_obj           = dObjectTypeObj:

      CREATE ttUiEvent.
      ASSIGN ttUiEvent.d_ui_event_obj              = ryc_ui_event.ui_event_obj
             ttUiEvent.d_object_type_obj           = ryc_ui_event.object_type_obj
             ttUiEvent.d_container_smartobject_obj = ryc_ui_event.container_smartobject_obj
             ttUiEvent.d_smartobject_obj           = ryc_ui_event.smartobject_obj
             ttUiEvent.d_object_instance_obj       = ryc_ui_event.object_instance_obj
             ttUiEvent.c_event_name                = ryc_ui_event.event_name
             ttUiEvent.l_constant_value            = ryc_ui_event.constant_value
             ttUiEvent.c_action_type               = ryc_ui_event.action_type
             ttUiEvent.c_action_target             = ryc_ui_event.action_target
             ttUiEvent.c_event_action              = ryc_ui_event.event_action
             ttUiEvent.c_event_parameter           = ryc_ui_event.event_parameter
             ttUiEvent.l_event_disabled            = ryc_ui_event.event_disabled
             ttUiEvent.d_primary_smartobject_obj   = ryc_ui_event.primary_smartobject_obj
             ttUiEvent.c_customization_result_code = (IF NOT AVAILABLE ryc_customization_result OR iCounter = 1 THEN "":U
                                                             ELSE ryc_customization_result.customization_result_code)
             ttUiEvent.d_customization_result_obj  = (IF iCounter = 1 THEN 0.00 ELSE pdCustomizationResultObj).
    END.
    
    FOR EACH ttObjectInstance
       WHERE ttObjectInstance.d_container_smartobject_obj = dSmartObjectObj:
       
      /* This will read the attributes specified against the master */
      IF NOT CAN-FIND(FIRST ttUiEvent
                      WHERE ttUiEvent.d_container_smartobject_obj = 0.00
                        AND ttUiEvent.d_primary_smartobject_obj   = ttObjectInstance.d_smartobject_obj
                        AND ttUiEvent.d_object_instance_obj       = 0.00
                        AND ttUiEvent.d_object_type_obj           = ttObjectInstance.d_object_type_obj
                        AND ttUiEvent.d_smartobject_obj           = ttObjectInstance.d_smartobject_obj) THEN
      DO:
        /* See if we can find a customized version of the master smartobject */
        FIND FIRST ryc_smartobject NO-LOCK
             WHERE ryc_smartobject.object_filename          = ttObjectInstance.c_smartobject_filename
               AND ryc_smartobject.customization_result_obj = pdCustomizationResultObj NO-ERROR.

        IF AVAILABLE ryc_smartobject THEN
          dCustomizedMasterObj = ryc_smartobject.smartobject_obj.

        FIND FIRST ryc_smartobject NO-LOCK
             WHERE ryc_smartobject.object_filename          = ttObjectInstance.c_smartobject_filename
               AND ryc_smartobject.customization_result_obj = 0.00 NO-ERROR.

        IF AVAILABLE ryc_smartobject THEN
          dMasterObj = ryc_smartobject.smartobject_obj.

        DO iMaster = 1 TO (IF dCustomizedMasterObj <> 0.00 THEN 2 ELSE 1):
          IF iMaster = 1 THEN
          DO:
            IF dCustomizedMasterObj <> 0.00 THEN
              dCurrentSmartObjectObj = dCustomizedMasterObj.
            ELSE
              dCurrentSmartObjectObj = dMasterObj.
          END.
          ELSE
            dCurrentSmartObjectObj = dMasterObj.

          FOR EACH ryc_ui_event NO-LOCK
             WHERE ryc_ui_event.primary_smartobject_obj   = dCurrentSmartObjectObj
               AND ryc_ui_event.container_smartobject_obj = 0.00
               AND ryc_ui_event.object_instance_obj       = 0.00
               AND ryc_ui_event.smartobject_obj           = dCurrentSmartObjectObj
               AND ryc_ui_event.object_type_obj           = ryc_smartobject.object_type_obj:
    
            /* See if we have not added it already (for the customization) */
            IF NOT CAN-FIND(FIRST ttUiEvent
                            WHERE ttUiEvent.d_primary_smartobject_obj   = dMasterObj
                              AND ttUiEvent.d_container_smartobject_obj = 0.00
                              AND ttUiEvent.d_object_instance_obj       = 0.00
                              AND ttUiEvent.d_object_type_obj           = ttObjectInstance.d_object_type_obj
                              AND ttUiEvent.d_smartobject_obj           = dMasterObj
                              AND ttUiEvent.c_event_name                = ryc_ui_event.event_name) THEN
             DO:
              CREATE ttUiEvent.
              ASSIGN ttUiEvent.d_ui_event_obj              = ryc_ui_event.ui_event_obj
                     ttUiEvent.d_object_type_obj           = ryc_ui_event.object_type_obj
                     ttUiEvent.d_container_smartobject_obj = ryc_ui_event.container_smartobject_obj /* 0.00 */
                     ttUiEvent.d_object_instance_obj       = ryc_ui_event.object_instance_obj       /* 0.00 */
                     ttUiEvent.d_smartobject_obj           = dMasterObj                             /* This is intentional */
                     ttUiEvent.c_event_name                = ryc_ui_event.event_name
                     ttUiEvent.l_constant_value            = ryc_ui_event.constant_value
                     ttUiEvent.c_action_type               = ryc_ui_event.action_type
                     ttUiEvent.c_action_target             = ryc_ui_event.action_target
                     ttUiEvent.c_event_action              = ryc_ui_event.event_action
                     ttUiEvent.c_event_parameter           = ryc_ui_event.event_parameter
                     ttUiEvent.l_event_disabled            = ryc_ui_event.event_disabled
                     ttUiEvent.d_primary_smartobject_obj   = dMasterObj                             /* This is intentional */
                     ttUiEvent.c_customization_result_code = "":U
                     ttUiEvent.d_customization_result_obj  = (IF dCurrentSmartObjectObj = dCustomizedMasterObj THEN -1.00 ELSE 0.00)
                     ttUiEvent.l_master_event              = TRUE.
            END. /* NOT CAN-FIND(FIRST ttUiEvent) */
          END.  /* FOR EACH ryc_ui_event         */
        END.   /* DO iMaster                    */
      END.    /* NO UiEvent Master records     */

      /* This will read the attributes specified against the instances */
      FOR EACH ryc_ui_event NO-LOCK
         WHERE ryc_ui_event.primary_smartobject_obj = dSmartObjectObj
           AND ryc_ui_event.smartobject_obj         = ttObjectInstance.d_smartobject_obj
           AND ryc_ui_event.object_type_obj         = ttObjectInstance.d_object_type_obj
           AND ryc_ui_event.object_instance_obj     = ttObjectInstance.d_object_instance_obj:
  
        /* If we do not have a customized master of the current object instance, then if we have any ui events on the main (uncustomized container),
           then that value will act as a master event if they choose to undo the event override in the dynamic property sheet */
        IF dSmartObjectObj = dMainSmartObjectObj AND dCustomizedSmartObjectObj <> 0.00 THEN
        DO:
          /* See if we have not added it already (for the customized master) */
          IF CAN-FIND(FIRST ttUiEvent
                      WHERE ttUiEvent.d_primary_smartobject_obj   = ttObjectInstance.d_smartobject_obj
                        AND ttUiEvent.d_container_smartobject_obj = 0.00
                        AND ttUiEvent.d_object_instance_obj       = 0.00
                        AND ttUiEvent.d_object_type_obj           = ttObjectInstance.d_object_type_obj
                        AND ttUiEvent.d_smartobject_obj           = ttObjectInstance.d_smartobject_obj
                        AND ttUiEvent.c_event_name                = ryc_ui_event.event_name
                        AND ttUiEvent.d_customization_result_obj  = -1.00) THEN
          DO:
            lCreateAsMaster = FALSE.
            NEXT.
          END.
          ELSE
            lCreateAsMaster = TRUE.
        END.
        ELSE
          lCreateAsMaster = FALSE.

        CREATE ttUiEvent.
        ASSIGN ttUiEvent.d_ui_event_obj              = ryc_ui_event.ui_event_obj
               ttUiEvent.d_object_type_obj           = ryc_ui_event.object_type_obj
               ttUiEvent.d_container_smartobject_obj = (IF lCreateAsMaster = TRUE THEN 0.00 ELSE ryc_ui_event.container_smartobject_obj)
               ttUiEvent.d_smartobject_obj           = ryc_ui_event.smartobject_obj
               ttUiEvent.d_object_instance_obj       = (IF lCreateAsMaster = TRUE THEN 0.00 ELSE ryc_ui_event.object_instance_obj)
               ttUiEvent.c_event_name                = ryc_ui_event.event_name
               ttUiEvent.l_constant_value            = ryc_ui_event.constant_value
               ttUiEvent.c_action_type               = ryc_ui_event.action_type
               ttUiEvent.c_action_target             = ryc_ui_event.action_target
               ttUiEvent.c_event_action              = ryc_ui_event.event_action
               ttUiEvent.c_event_parameter           = ryc_ui_event.event_parameter
               ttUiEvent.l_event_disabled            = ryc_ui_event.event_disabled
               ttUiEvent.d_primary_smartobject_obj   = (IF lCreateAsMaster = TRUE THEN ttObjectInstance.d_smartobject_obj
                                                                                  ELSE ryc_ui_event.primary_smartobject_obj)
               ttUiEvent.c_customization_result_code = (IF NOT AVAILABLE ryc_customization_result OR iCounter = 1 OR lCreateAsMaster THEN "":U
                                                               ELSE ryc_customization_result.customization_result_code)
               ttUiEvent.d_customization_result_obj  = (IF iCounter = 1 OR lCreateAsMaster THEN 0.00 ELSE pdCustomizationResultObj)

               /* We assign it a ? because it is a dummy record and we do not want to delete it if MasterObjectModified is PUBLISHed anywhere */
               ttUiEvent.l_master_event              = (IF lCreateAsMaster THEN ? ELSE FALSE).
      END.
    END.
  END.

  /* Fix the field in the temp-table I used temporarily */
  FOR EACH ttUiEvent
     WHERE ttUiEvent.d_customization_result_obj = -1.00:

    ttUiEvent.d_customization_result_obj = 0.00.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-killPlip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE killPlip Procedure 
PROCEDURE killPlip :
/*------------------------------------------------------------------------------
  Purpose:     entry point to instantly kill the plip if it should get lost in memory
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipkill.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-objectDescription) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE objectDescription Procedure 
PROCEDURE objectDescription :
/*------------------------------------------------------------------------------
  Purpose:     Pass out a description of the PLIP, used in Plip temp-table
  Parameters:  <none>
  Notes:       This should be changed manually for each plip
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER cDescription AS CHARACTER NO-UNDO.

ASSIGN cDescription = "Dynamics Template PLIP".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipSetup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipSetup Procedure 
PROCEDURE plipSetup :
/*------------------------------------------------------------------------------
  Purpose:    Run by main-block of PLIP at startup of PLIP
  Parameters: <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipsetu.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipShutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown Procedure 
PROCEDURE plipShutdown :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will be run just before the calling program 
               terminates
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipshut.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAttributesAndEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setAttributesAndEvents Procedure 
PROCEDURE setAttributesAndEvents :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdCustomizationResultObj AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE cAttributeValue AS CHARACTER  NO-UNDO.

  DEFINE BUFFER ryc_attribute_value FOR ryc_attribute_value.
  DEFINE BUFFER ttObjectInstance    FOR ttObjectInstance.
  DEFINE BUFFER ttSmartObject       FOR ttSmartObject.

  FIND FIRST ttSmartObject
       WHERE ttSmartObject.d_smartobject_obj         <> 0.00
         AND ttSmartObject.d_customization_result_obj = pdCustomizationResultObj.
  
  /* Make the required database update for all the attributes */

  /* First delete the attributes that should be deleted */
  FOR EACH ttAttributeValue
     WHERE ttAttributeValue.d_customization_result_obj = pdCustomizationResultObj
       AND ttAttributeValue.c_action                   = "D":U
       AND ttAttributeValue.l_master_attribute         = FALSE:

    IF ttAttributeValue.d_attribute_value_obj > 0.00  THEN
    DO:
      FIND FIRST ryc_attribute_value EXCLUSIVE-LOCK
           WHERE ryc_attribute_value.attribute_value_obj = ttAttributeValue.d_attribute_value_obj NO-ERROR.

      IF NOT AVAILABLE ryc_attribute_value THEN
        NEXT.

      DELETE ryc_attribute_value NO-ERROR.

      IF ERROR-STATUS:ERROR THEN
        RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).
    END.
    
    DELETE ttAttributeValue.
  END.

  /* Set/update the new/updated attributes */
  FOR EACH ttAttributeValue
     WHERE ttAttributeValue.d_customization_result_obj = pdCustomizationResultObj
       AND ttAttributeValue.c_action                  <> "":U
       AND ttAttributeValue.l_master_attribute         = FALSE:

    RUN setAttributeValue (INPUT  pdCustomizationResultObj,
                           BUFFER ttAttributeValue) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
      RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).
  END.

  /* First delete the ui events that should be deleted */
  FOR EACH ttUiEvent
     WHERE ttUiEvent.d_customization_result_obj = pdCustomizationResultObj
       AND ttUiEvent.c_action                   = "D":U
       AND ttUiEvent.l_master_event             = FALSE:

    IF ttUiEvent.d_ui_event_obj > 0.00  THEN
    DO:
      FIND FIRST ryc_ui_event EXCLUSIVE-LOCK
           WHERE ryc_ui_event.ui_event_obj = ttUiEvent.d_ui_event_obj NO-ERROR.

      IF NOT AVAILABLE ryc_ui_event THEN
        NEXT.

      DELETE ryc_ui_event NO-ERROR.

      IF ERROR-STATUS:ERROR THEN
        RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).
    END.

    DELETE ttUiEvent.
  END.

  /* Set/update the new/updated ui events */
  FOR EACH ttUiEvent
     WHERE ttUiEvent.d_customization_result_obj = pdCustomizationResultObj
       AND ttUiEvent.c_action                  <> "":U
       AND ttUiEvent.l_master_event             = FALSE:

    RUN setUiEvent (INPUT  pdCustomizationResultObj,
                    BUFFER ttUiEvent) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
      RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAttributeValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setAttributeValue Procedure 
PROCEDURE setAttributeValue :
/*------------------------------------------------------------------------------
  Purpose:     Sets attribute values.
  Parameters:  pdObjectTypeObj        -
               pdSmartObjectObj       -
               pdContainerSmartObject -
               pdObjectInstanceObj    -
               pcAttributeLabel       -
               pcAttributeValue       -   
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE       PARAMETER BUFFER bttAttributeValue FOR ttAttributeValue.

  DEFINE VARIABLE iErrorCount   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cErrorText    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cReturnValue  AS CHARACTER  NO-UNDO.

  DEFINE BUFFER ryc_attribute_value           FOR ryc_attribute_value.
  DEFINE BUFFER ryc_attribute                 FOR ryc_attribute.

  FIND FIRST ryc_attribute_value EXCLUSIVE-LOCK
       WHERE ryc_attribute_value.attribute_value_obj = bttAttributeValue.d_attribute_value_obj NO-WAIT NO-ERROR.

  IF NOT AVAILABLE ryc_attribute_value THEN
    FIND FIRST ryc_attribute_value EXCLUSIVE-LOCK
         WHERE ryc_attribute_value.object_type_obj           = bttAttributeValue.d_object_type_obj
           AND ryc_attribute_value.smartobject_obj           = bttAttributeValue.d_smartobject_obj
           AND ryc_attribute_value.attribute_label           = bttAttributeValue.c_attribute_label
           AND ryc_attribute_value.object_instance_obj       = bttAttributeValue.d_object_instance_obj
           AND ryc_attribute_value.container_smartobject_obj = bttAttributeValue.d_container_smartobject_obj NO-WAIT NO-ERROR.

  IF NOT AVAILABLE ryc_attribute_value THEN
  DO:
    FIND FIRST ryc_attribute NO-LOCK
         WHERE ryc_attribute.attribute_label = bttAttributeValue.c_attribute_label NO-ERROR.

    IF NOT AVAILABLE ryc_attribute THEN
        RETURN ERROR {aferrortxt.i 'AF' '5' 'ryc_attribute' '?' '"attribute"' "'Attribute Label = ~~'' + bttAttributeValue.c_attribute_label + '~~''"}.

    CREATE ryc_attribute_value NO-ERROR.

    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN RETURN-VALUE.

    ASSIGN ryc_attribute_value.object_type_obj             = bttAttributeValue.d_object_type_obj
           ryc_attribute_value.smartobject_obj             = bttAttributeValue.d_smartobject_obj
           ryc_attribute_value.object_instance_obj         = bttAttributeValue.d_object_instance_obj
           ryc_attribute_value.container_smartobject_obj   = bttAttributeValue.d_container_smartobject_obj
           ryc_attribute_value.attribute_label             = bttAttributeValue.c_attribute_label NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
    DO:
      cErrorText = "":U.

      DO iErrorCount = 1 TO ERROR-STATUS:NUM-MESSAGES:

        cErrorText = cErrorText + (IF NUM-ENTRIES(cErrorText, "~n":U) EQ 0 THEN "":U ELSE "~n":U)
                   + ERROR-STATUS:GET-MESSAGE(iErrorCount).
      END.    /* loop through errors */

      RETURN ERROR {aferrortxt.i 'AF' '40' 'rycsm_actual' '?' cErrorText}.
    END.    /* error */
  END.    /* n/a attrib */
  ELSE
  DO:
    /* The instance might have been replaced with another instance */
    ASSIGN
        ryc_attribute_value.object_type_obj = bttAttributeValue.d_object_type_obj
        ryc_attribute_value.smartobject_obj = bttAttributeValue.d_smartobject_obj.
  END.

  /* Assign the appropriate Attribute Value */
  CASE bttAttributeValue.i_data_type:
    WHEN {&DECIMAL-DATA-TYPE}   THEN ryc_attribute_value.decimal_value   = bttAttributeValue.d_decimal_value   NO-ERROR.
    WHEN {&INTEGER-DATA-TYPE}   THEN ryc_attribute_value.integer_value   = bttAttributeValue.i_integer_value   NO-ERROR.
    WHEN {&DATE-DATA-TYPE}      THEN ryc_attribute_value.date_value      = bttAttributeValue.t_date_value      NO-ERROR.
    WHEN {&RAW-DATA-TYPE}       THEN ryc_attribute_value.raw_value       = bttAttributeValue.r_raw_value       NO-ERROR.
    WHEN {&LOGICAL-DATA-TYPE}   THEN ryc_attribute_value.logical_value   = bttAttributeValue.l_logical_value   NO-ERROR.
    WHEN {&CHARACTER-DATA-TYPE} THEN ryc_attribute_value.character_value = bttAttributeValue.c_character_value NO-ERROR.
  END CASE.
  
  IF ERROR-STATUS:ERROR THEN
  DO:
    cErrorText = "":U.

    DO iErrorCount = 1 TO ERROR-STATUS:NUM-MESSAGES:

      cErrorText = cErrorText + (IF NUM-ENTRIES(cErrorText, "~n":U) EQ 0 THEN "":U ELSE "~n":U)
                 + ERROR-STATUS:GET-MESSAGE(iErrorCount).
    END.    /* loop through errors */

    RETURN ERROR {aferrortxt.i 'AF' '40' 'rycsm_actual' '?' cErrorText}.
  END.    /* error */

  VALIDATE ryc_attribute_value NO-ERROR.

  IF ERROR-STATUS:ERROR THEN
    RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContainerDetails) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setContainerDetails Procedure 
PROCEDURE setContainerDetails :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttSmartObject.
  DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttPage.
  DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttPageObject.
  DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttObjectInstance.
  DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttAttributeValue.
  DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttUiEvent.
  DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttSmartLink.
  DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttObjectMenuStructure.

  DEFINE VARIABLE cInheritsFrom             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContainerName            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectFilename           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizedSmartObjectObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dMainSmartObjectObj       AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lSameValue                AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iLookup                   AS INTEGER    NO-UNDO.

  DEFINE BUFFER ryc_attribute_value FOR ryc_attribute_value.
  DEFINE BUFFER ryc_ui_event        FOR ryc_ui_event.
  DEFINE BUFFER ttAttributeValue    FOR ttAttributeValue.
  DEFINE BUFFER ttObjectInstance    FOR ttObjectInstance.
  DEFINE BUFFER gsc_object_type     FOR gsc_object_type.
  DEFINE BUFFER ttSmartObject       FOR ttSmartObject.
  DEFINE BUFFER ttUiEvent           FOR ttUiEvent.

  DO TRANSACTION ON ERROR UNDO:
    /* Manage the details of the container */
    RUN setSmartObject (INPUT pdCustomizationResultObj) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
      RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).

    FIND FIRST ttSmartObject
         WHERE ttSmartObject.d_smartobject_obj         <> 0.00
           AND ttSmartObject.d_customization_result_obj = pdCustomizationResultObj.

    cContainerName = (IF ttSmartObject.c_action = "D":U THEN "":U ELSE ttSmartObject.c_object_filename).

    IF ttSmartObject.c_action <> "D":U THEN
    DO:
      /* Get the object numbers of the main and the customized container It is retrieved here because it could have been modified in the setSmartObject */
      FOR EACH ttSmartObject
         WHERE ttSmartObject.d_smartobject_obj <> 0.00:
    
        IF cObjectFilename = "":U THEN
          cObjectFilename = ttSmartObject.c_object_filename.
    
        IF ttSmartObject.d_customization_result_obj = 0.00 THEN
          dMainSmartObjectObj = ttSmartObject.d_smartobject_obj.
        ELSE
          dCustomizedSmartObjectObj = ttSmartObject.d_smartobject_obj.
      END.  

      /* Before we get to the object instances, we need to check which attributes are going to be stored as this will be checked
         to see if the object instance needs to be stored */
      FOR EACH ttAttributeValue
         WHERE ttAttributeValue.d_customization_result_obj = pdCustomizationResultObj
           AND ttAttributeValue.c_action                  <> "D":U
           AND ttAttributeValue.d_primary_smartobject_obj <> 0.00
           AND ttAttributeValue.l_master_attribute         = FALSE,
         FIRST ttObjectInstance
         WHERE ttObjectInstance.d_object_instance_obj = ttAttributeValue.d_object_instance_obj,
         FIRST gsc_object_type
         WHERE gsc_object_type.object_type_obj = ttObjectInstance.d_object_type_obj:

        /* See if the attribute value exists against the class */
        IF NOT DYNAMIC-FUNCTION("attributeExistsInClass":U, ttAttributeValue.c_attribute_label, gsc_object_type.object_type_code) THEN
          lSameValue = TRUE.
        ELSE
          /* This means the attribute exists against the class, so compare the values */
          lSameValue = DYNAMIC-FUNCTION("isAttributeValueSame":U, BUFFER ttAttributeValue,
                                                                  cObjectFilename,
                                                                  dCustomizedSmartObjectObj,
                                                                  dMainSmartObjectObj,
                                                                  pdCustomizationResultObj).
        IF lSameValue THEN
          ttAttributeValue.c_action = "D":U.
      END.

      FOR EACH ttUiEvent
         WHERE ttUiEvent.d_customization_result_obj = pdCustomizationResultObj
           AND ttUiEvent.c_action                  <> "D":U
           AND ttUiEvent.d_primary_smartobject_obj <> 0.00
           AND ttUiEvent.l_master_event             = FALSE:

        /* See if the ui event exists against the class */
        IF NOT CAN-FIND(FIRST ryc_ui_event NO-LOCK
                        WHERE ryc_ui_event.object_type_obj           = ttUiEvent.d_object_type_obj
                          AND ryc_ui_event.event_name                = ttUiEvent.c_event_name
                          AND ryc_ui_event.container_smartobject_obj = 0.00
                          AND ryc_ui_event.object_instance_obj       = 0.00
                          AND ryc_ui_event.smartobject_obj           = 0.00) THEN
          lSameValue = TRUE.
        ELSE
          /* This means the ui event exists against the class, so compare the values */
          lSameValue = DYNAMIC-FUNCTION("isUiEventSame":U, BUFFER ttUiEvent,
                                                                  cObjectFilename,
                                                                  dCustomizedSmartObjectObj,
                                                                  dMainSmartObjectObj,
                                                                  pdCustomizationResultObj).
        IF lSameValue THEN
          ttUiEvent.c_action = "D":U.
      END.

      /* Manage the details of the pages */
      RUN setPage (INPUT pdCustomizationResultObj) NO-ERROR.

      IF ERROR-STATUS:ERROR THEN
        RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).

      /* Manage the details of the object instances */
      RUN setObjectInstance (INPUT pdCustomizationResultObj) NO-ERROR.

      IF ERROR-STATUS:ERROR THEN
        RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).

      /* Resequence the pages */
      RUN updatePageSequence (INPUT (IF pdCustomizationResultObj = 0.00 THEN dMainSmartObjectObj ELSE dCustomizedSmartObjectObj), TRUE) NO-ERROR.

      IF ERROR-STATUS:ERROR THEN
        RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).

      /* Manage the details of the smartinks */
      RUN setSmartLink (INPUT pdCustomizationResultObj) NO-ERROR.

      IF ERROR-STATUS:ERROR THEN
        RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).

      /* Manage the attributes and events */
      RUN setAttributesAndEvents (INPUT pdCustomizationResultObj) NO-ERROR.

      IF ERROR-STATUS:ERROR THEN
        RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).

      /* Manage the menu structures associated with the container */
      RUN setObjectMenuStructure (INPUT pdCustomizationResultObj) NO-ERROR.

      IF ERROR-STATUS:ERROR THEN
        RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).

      /* Make sure everything is switched to the relative layout */
      RUN updateLayout (INPUT pdCustomizationResultObj) NO-ERROR.

      IF ERROR-STATUS:ERROR THEN
        RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).
    END.

    /* Finally, clean up the temp tables */
    RUN getContainerDetails (INPUT  cContainerName,
                             INPUT  "":U,
                             INPUT  "":U,
                             INPUT  pdCustomizationResultObj,
                             OUTPUT TABLE ttSmartObject,
                             OUTPUT TABLE ttPage,
                             OUTPUT TABLE ttPageObject,
                             OUTPUT TABLE ttObjectInstance,
                             OUTPUT TABLE ttAttributeValue,
                             OUTPUT TABLE ttUiEvent,
                             OUTPUT TABLE ttSmartLink,
                             OUTPUT TABLE ttObjectMenuStructure).
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setObjectInstance) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setObjectInstance Procedure 
PROCEDURE setObjectInstance :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdCustomizationResultObj AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE lDifferent  AS LOGICAL    NO-UNDO.
  
  DEFINE BUFFER b_ryc_object_instance FOR ryc_object_instance.
  DEFINE BUFFER   ryc_object_instance FOR ryc_object_instance.
  DEFINE BUFFER   ryc_smartobject     FOR ryc_smartobject.
  DEFINE BUFFER   ttPage              FOR ttPage.

  /* Only work with objects that have changed */
  FOR EACH ttObjectInstance
     WHERE ttObjectInstance.c_action                  <> "":U
       AND ttObjectInstance.d_customization_result_obj = pdCustomizationResultObj,
     FIRST ttSmartObject
     WHERE ttSmartObject.d_smartobject_obj = ttObjectInstance.d_container_smartobject_obj
        BY ttObjectInstance.c_action DESCENDING:

    /* If it is a customized object instance, check to see if it is the same as the main instance */
    IF pdCustomizationResultObj  <> 0.00  AND
       ttObjectInstance.c_action <> "D":U THEN
    DO:
      lDifferent = DYNAMIC-FUNCTION("compareObjectInstance":U, ttObjectInstance.c_instance_name).

      /* If it is not different, then we can delete the customized instance. It either wasn't changed or was changed so that it looks similar
         than the main instance. If it is an existing record in the database, flag it so it can be deleted, else delete the TEMP-TABLE record */
      IF lDifferent = FALSE THEN
      DO:
        FOR EACH  ttSmartLink
           WHERE  ttSmartLink.d_customization_result_obj   = pdCustomizationResultObj
             AND (ttSmartLink.d_source_object_instance_obj = ttObjectInstance.d_object_instance_obj
              OR  ttSmartLink.d_target_object_instance_obj = ttObjectInstance.d_object_instance_obj):

          IF ttSmartLink.d_smartlink_obj > 0.00 THEN
            ttSmartLink.c_action = "D":U.
          ELSE
            DELETE ttSmartLink.
        END.

        FOR EACH ttAttributeValue
           WHERE ttAttributeValue.d_customization_result_obj = pdCustomizationResultObj
             AND ttAttributeValue.d_primary_smartobject_obj  = ttObjectInstance.d_container_smartobject_obj
             AND ttAttributeValue.d_object_instance_obj      = ttObjectInstance.d_object_instance_obj:

          IF ttAttributeValue.d_attribute_value_obj > 0.00 THEN
            ttAttributeValue.c_action = "D":U.
          ELSE
            DELETE ttAttributeValue.
        END.

        IF ttObjectInstance.d_object_instance_obj > 0.00 THEN
          ttObjectInstance.c_action = "D":U.
        ELSE
        DO:
          DELETE ttObjectInstance.

          NEXT.
        END.
      END.
      ELSE
        IF lDifferent = ? THEN
          ASSIGN
              lDifferent = TRUE.
    END.

    /* Find the object exclusively as we would need to need to update or delete it */
    FIND FIRST ryc_object_instance EXCLUSIVE-LOCK
         WHERE ryc_object_instance.object_instance_obj = ttObjectInstance.d_object_instance_obj NO-ERROR.

    /* Delete objects that should be deleted */
    IF ttObjectInstance.c_action = "D":U THEN
    DO:
      /* If it doesn't exist, then it never did (object instance added and deleted in the same session) */
      IF AVAILABLE ryc_object_instance THEN
      DO:
        /* If we are working with the master instance and we delete an object instance, delete all customized instances of this object */
        IF pdCustomizationResultObj = 0.00 THEN
        DO:
          FOR EACH ryc_smartobject
             WHERE ryc_smartobject.object_filename           = ttSmartObject.c_object_filename
               AND ryc_smartobject.customization_result_obj <> 0.00,
              EACH b_ryc_object_instance
             WHERE b_ryc_object_instance.container_smartobject_obj = ryc_smartobject.smartobject_obj
               AND b_ryc_object_instance.instance_name             = ryc_object_instance.instance_name
               AND b_ryc_object_instance.object_instance_obj      <> ryc_object_instance.object_instance_obj: /* Just in case... */

            RUN deleteObjectInstanceData (BUFFER b_ryc_object_instance) NO-ERROR.

            IF ERROR-STATUS:ERROR THEN
              RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).
          END.
        END.

        RUN deleteObjectInstanceData (BUFFER ryc_object_instance) NO-ERROR.

        IF ERROR-STATUS:ERROR THEN
          RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).
      END.

      FOR EACH  ttSmartLink
         WHERE  ttSmartLink.d_customization_result_obj   = pdCustomizationResultObj
           AND (ttSmartLink.d_source_object_instance_obj = ttObjectInstance.d_object_instance_obj
            OR  ttSmartLink.d_target_object_instance_obj = ttObjectInstance.d_object_instance_obj):

        DELETE ttSmartLink.
      END.

      FOR EACH ttAttributeValue
         WHERE ttAttributeValue.d_customization_result_obj = pdCustomizationResultObj
           AND ttAttributeValue.d_object_instance_obj      = ttObjectInstance.d_object_instance_obj:

        DELETE ttAttributeValue.
      END.

      DELETE ttObjectInstance.

      /* If the record in the find was not available, the ERROR-STATUS would be raised */
      ERROR-STATUS:ERROR = FALSE.

      NEXT.
    END.

    /* If the master instance name has changed, change the customized instances' names */
    IF pdCustomizationResultObj           = 0.00                             AND
       AVAILABLE ryc_object_instance      = TRUE                             AND
       ryc_object_instance.instance_name <> ttObjectInstance.c_instance_name THEN
    DO:
      FOR EACH ryc_smartobject
         WHERE ryc_smartobject.object_filename           = ttSmartObject.c_object_filename
           AND ryc_smartobject.customization_result_obj <> 0.00,
          EACH b_ryc_object_instance
         WHERE b_ryc_object_instance.container_smartobject_obj = ryc_smartobject.smartobject_obj
           AND b_ryc_object_instance.object_instance_obj      <> ryc_object_instance.object_instance_obj: /* Just in case... */

        b_ryc_object_instance.instance_name = ttObjectInstance.c_instance_name NO-ERROR.

        IF ERROR-STATUS:ERROR THEN
          RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).
      END.
    END.

    /* Create smartobjects that should be created */
    IF ttObjectInstance.c_action     = "A":U AND
       AVAILABLE ryc_object_instance = FALSE THEN
    DO:
      CREATE ryc_object_instance NO-ERROR.

      IF ERROR-STATUS:ERROR THEN
        RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).

      /* Replace the temporary object numbers in the other tables:
         --------------------------------------------------------- */
      /* ttSmartLink */
      FOR EACH ttSmartLink
         WHERE ttSmartLink.d_source_object_instance_obj = ttObjectInstance.d_object_instance_obj
            OR ttSmartLink.d_target_object_instance_obj = ttObjectInstance.d_object_instance_obj:
        
        IF ttSmartLink.d_source_object_instance_obj = ttObjectInstance.d_object_instance_obj THEN
          ttSmartLink.d_source_object_instance_obj = ryc_object_instance.object_instance_obj.

        IF ttSmartLink.d_target_object_instance_obj = ttObjectInstance.d_object_instance_obj THEN
          ttSmartLink.d_target_object_instance_obj = ryc_object_instance.object_instance_obj.
      END.

      /* ttAttributeValue */
      FOR EACH ttAttributeValue
         WHERE ttAttributeValue.d_object_instance_obj = ttObjectInstance.d_object_instance_obj:
        
        ttAttributeValue.d_object_instance_obj = ryc_object_instance.object_instance_obj.
      END.

      ttObjectInstance.d_object_instance_obj = ryc_object_instance.object_instance_obj.
    END.

    /* Assign the new values */
    IF ttObjectInstance.c_action = "A":U OR
       ttObjectInstance.c_action = "M":U THEN
    DO:
      FIND FIRST ttPage
           WHERE ttPage.d_page_obj = ttObjectInstance.d_page_obj NO-ERROR.

      IF AVAILABLE ttPage AND ttPage.i_page_sequence = 0 THEN
        ttObjectInstance.d_page_obj = 0.00.

      ASSIGN
          ryc_object_instance.container_smartobject_obj = ttObjectInstance.d_container_smartobject_obj
          ryc_object_instance.smartobject_obj           = ttObjectInstance.d_smartobject_obj
          ryc_object_instance.instance_description      = ttObjectInstance.c_instance_description
          ryc_object_instance.instance_name             = ttObjectInstance.c_instance_name
          ryc_object_instance.page_obj                  = ttObjectInstance.d_page_obj
          ryc_object_instance.object_sequence           = ttObjectInstance.i_object_sequence
          ryc_object_instance.system_owned              = ttObjectInstance.l_system_owned
          ryc_object_instance.layout_position           = ttObjectInstance.c_layout_position NO-ERROR. 

      IF ERROR-STATUS:ERROR THEN
        RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).
      
      VALIDATE ryc_object_instance NO-ERROR.

      IF ERROR-STATUS:ERROR THEN
        RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).
    END.
  END.

  /* Always update the layout position as it might have changed because of layout conversions */
  FOR EACH ttObjectInstance
     WHERE ttObjectInstance.d_customization_result_obj = pdCustomizationResultObj,
     FIRST ryc_object_instance EXCLUSIVE-LOCK
     WHERE ryc_object_instance.object_instance_obj = ttObjectInstance.d_object_instance_obj:
  
    ryc_object_instance.layout_position = ttObjectInstance.c_layout_position NO-ERROR. 

    IF ERROR-STATUS:ERROR THEN
      RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).
    
    VALIDATE ryc_object_instance NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
      RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).
  END.

  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setObjectMenuStructure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setObjectMenuStructure Procedure 
PROCEDURE setObjectMenuStructure :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdCustomizationResultObj AS DECIMAL    NO-UNDO.
  
  DEFINE VARIABLE lDifferent AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lDoneOnce  AS LOGICAL   NO-UNDO.
  
  DEFINE BUFFER gsm_object_menu_structure FOR gsm_object_menu_structure.

  /* Only work with objects that have changed */
  FOR EACH ttObjectMenuStructure
     WHERE ttObjectMenuStructure.c_action                  <> "":U
       AND ttObjectMenuStructure.d_customization_result_obj = pdCustomizationResultObj
        BY ttObjectMenuStructure.c_action DESCENDING:

    /* Find the object exclusively as we would need to need to update or delete it */
    FIND FIRST gsm_object_menu_structure EXCLUSIVE-LOCK
         WHERE gsm_object_menu_structure.object_menu_structure_obj = ttObjectMenuStructure.d_object_menu_structure_obj NO-ERROR.

    /* Delete objects that should be deleted */
    IF ttObjectMenuStructure.c_action = "D":U THEN
    DO:
      /* If it doesn't exist, then it never did (object instance added and deleted in the same session) */
      IF AVAILABLE gsm_object_menu_structure THEN
      DO:
        DELETE gsm_object_menu_structure NO-ERROR.

        IF ERROR-STATUS:ERROR THEN
          RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).
      END.

      /* If the record in the find was not available, the ERROR-STATUS would be raised */
      ERROR-STATUS:ERROR = FALSE.

      DELETE ttObjectMenuStructure.

      NEXT.
    END.

    /* Create smartobjects that should be created */
    IF ttObjectMenuStructure.c_action      = "A":U AND
       AVAILABLE gsm_object_menu_structure = FALSE THEN
    DO:
      CREATE gsm_object_menu_structure NO-ERROR.

      IF ERROR-STATUS:ERROR THEN
        RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).

      ttObjectMenuStructure.d_object_menu_structure_obj = gsm_object_menu_structure.object_menu_structure_obj.
    END.

    /* Assign the new values */
    IF ttObjectMenuStructure.c_action = "A":U OR
       ttObjectMenuStructure.c_action = "M":U THEN
    DO:
      ASSIGN
          gsm_object_menu_structure.object_obj              = ttObjectMenuStructure.d_object_obj
          gsm_object_menu_structure.menu_structure_obj      = ttObjectMenuStructure.d_menu_structure_obj
          gsm_object_menu_structure.instance_attribute_obj  = ttObjectMenuStructure.d_instance_attribute_obj
          gsm_object_menu_structure.menu_item_obj           = ttObjectMenuStructure.d_menu_item_obj
          gsm_object_menu_structure.insert_submenu          = ttObjectMenuStructure.l_insert_submenu
          gsm_object_menu_structure.menu_structure_sequence = ttObjectMenuStructure.i_menu_structure_sequence NO-ERROR.

      IF ERROR-STATUS:ERROR THEN
        RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).
      
      VALIDATE gsm_object_menu_structure NO-ERROR.
      
      IF ERROR-STATUS:ERROR THEN
        RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).
    END.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setPage Procedure 
PROCEDURE setPage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdCustomizationResultObj AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE dContainerSmartObjectObj  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lDifferent                AS LOGICAL    NO-UNDO.

  DEFINE BUFFER ttObjectInstance FOR ttObjectInstance.
  DEFINE BUFFER ryc_page         FOR ryc_page.

  /* Find the container smartobject obj of the container we are currently working with */
  FIND FIRST ttPage
       WHERE ttPage.i_page_sequence           <> 0
         AND ttPage.d_customization_result_obj = pdCustomizationResultObj NO-ERROR.

  IF AVAILABLE ttPage THEN
    dContainerSmartObjectObj = ttPage.d_container_smartobject_obj.

  /* Only work with objects that have changed */
  FOR EACH ttPage
     WHERE ttPage.i_page_sequence           <> 0
       AND ttPage.d_customization_result_obj = pdCustomizationResultObj
        BY ttPage.c_action DESCENDING:

    /* Customization check */
    IF pdCustomizationResultObj <> 0.00  AND
       ttPage.c_action          <> "D":U THEN
    DO:
      lDifferent = DYNAMIC-FUNCTION("comparePage":U, ttPage.c_page_reference).

      IF lDifferent = FALSE THEN
      DO:
        FOR EACH ttObjectInstance
           WHERE ttObjectInstance.d_page_obj = ttPage.d_page_obj:

          FOR EACH  ttSmartLink
             WHERE  ttSmartLink.d_customization_result_obj   = pdCustomizationResultObj
               AND (ttSmartLink.d_source_object_instance_obj = ttObjectInstance.d_object_instance_obj
                OR  ttSmartLink.d_target_object_instance_obj = ttObjectInstance.d_object_instance_obj):

            DELETE ttSmartLink.
          END.

          FOR EACH ttAttributeValue
             WHERE ttAttributeValue.d_customization_result_obj = pdCustomizationResultObj
               AND ttAttributeValue.d_object_instance_obj      = ttObjectInstance.d_object_instance_obj:

            DELETE ttAttributeValue.
          END.

          DELETE ttObjectInstance.
        END.

        /* We do not delete the page record as we still need it for resequencing purposes */
        ttPage.c_action = "R":U.

        NEXT.
      END.
    END.

    /* Find the object exclusively as we would need to need to update or delete it */
    FIND FIRST ryc_page EXCLUSIVE-LOCK
         WHERE ryc_page.page_obj = ttPage.d_page_obj NO-ERROR.

    /* Create smartobjects that should be created */
    IF ttPage.c_action    = "A":U AND
       AVAILABLE ryc_page = FALSE THEN
    DO:
      CREATE ryc_page NO-ERROR.

      IF ERROR-STATUS:ERROR THEN
        RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).

      /* Replace the temporary object numbers in the other tables:
         --------------------------------------------------------- */
      /* ttObjectInstance */
      FOR EACH ttObjectInstance
         WHERE ttObjectInstance.d_page_obj = ttPage.d_page_obj:

        ASSIGN
            ttObjectInstance.d_page_obj = ryc_page.page_obj
            ttObjectInstance.c_action   = (IF ttObjectInstance.d_object_instance_obj > 0 THEN "M":U ELSE (IF c_action = "D":U THEN "D":U ELSE "A":U)).
      END.

      ttPage.d_page_obj = ryc_page.page_obj.

      IF pdCustomizationResultObj <> 0.00 THEN
        ryc_page.page_reference = ttPage.c_page_reference.
    END.

    /* Assign the new values */
    IF ttPage.c_action = "A":U OR
       ttPage.c_action = "M":U THEN
    DO:
      ASSIGN
          ryc_page.container_smartobject_obj = ttPage.d_container_smartobject_obj
          ryc_page.page_sequence             = ?
        /*ryc_page.page_sequence             = (IF ttPage.c_action = "A":U THEN ttPage.i_page_sequence ELSE ryc_page.page_sequence)*/
          ryc_page.layout_obj                = ttPage.d_layout_obj
          ryc_page.page_label                = ttPage.c_page_label
          ryc_page.security_token            = ttPage.c_security_token
          ryc_page.enable_on_create          = ttPage.l_enable_on_create
          ryc_page.enable_on_modify          = ttPage.l_enable_on_modify
          ryc_page.enable_on_view            = ttPage.l_enable_on_view NO-ERROR. 

      IF ERROR-STATUS:ERROR THEN
        RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).

      VALIDATE ryc_page NO-ERROR.

      IF ERROR-STATUS:ERROR THEN
        RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).

      IF ttPage.c_action = "A":U THEN
        ttPage.c_page_reference = ryc_page.page_reference.
    END.

    IF ttPage.c_action    = "D":U AND 
       AVAILABLE ryc_page = TRUE  THEN
    DO:
      ASSIGN
          ryc_page.page_sequence  = ?
          ryc_page.page_reference = ? NO-ERROR.

      IF ERROR-STATUS:ERROR THEN
        RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).
    END.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSmartLink) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSmartLink Procedure 
PROCEDURE setSmartLink :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdCustomizationResultObj AS DECIMAL    NO-UNDO.
  
  /* Only work with objects that have changed */
  FOR EACH ttSmartLink
     WHERE ttSmartLink.c_action                  <> "":U
       AND ttSmartLink.d_customization_result_obj = pdCustomizationResultObj
        BY ttSmartLink.c_action DESCENDING:
    
    /* Find the object exclusively as we would need to need to update or delete it */
    FIND FIRST ryc_smartlink EXCLUSIVE-LOCK
         WHERE ryc_smartlink.smartlink_obj = ttSmartLink.d_smartlink_obj NO-ERROR.

    /* Delete objects that should be deleted */
    IF ttSmartLink.c_action    = "D":U THEN
    DO:
      /* If it doesn't exist, then it never did (object instance added and deleted in the same session) */
      IF AVAILABLE ryc_smartlink = TRUE  THEN
      DO:
        DELETE ryc_smartlink NO-ERROR.
        
        IF ERROR-STATUS:ERROR THEN
          RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).
      END.

      /* If the record in the find was not available, the ERROR-STATUS would be raised */
      ERROR-STATUS:ERROR = FALSE.
      
      DELETE ttSmartLink.
      NEXT.
    END.

    /* Create smartobjects that should be created */
    IF ttSmartLink.c_action     = "A":U AND
       AVAILABLE ryc_smartlink = FALSE THEN
    DO:
      CREATE ryc_smartlink NO-ERROR.

      IF ERROR-STATUS:ERROR THEN
        RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).

      ttSmartLink.d_smartlink_obj = ryc_smartlink.smartlink_obj.
    END.

    /* Assign the new values */
    IF ttSmartLink.c_action = "A":U OR
       ttSmartLink.c_action = "M":U THEN
    DO:
      ASSIGN
          ryc_smartlink.container_smartobject_obj  = ttSmartLink.d_container_smartobject_obj
          ryc_smartlink.smartlink_type_obj         = ttSmartLink.d_smartlink_type_obj
          ryc_smartlink.link_name                  = ttSmartLink.c_link_name
          ryc_smartlink.source_object_instance_obj = ttSmartLink.d_source_object_instance_obj
          ryc_smartlink.target_object_instance_obj = ttSmartLink.d_target_object_instance_obj NO-ERROR. 

      IF ERROR-STATUS:ERROR THEN
        RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).
      
      VALIDATE ryc_smartlink NO-ERROR.

      IF ERROR-STATUS:ERROR THEN
        RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).
    END.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSmartObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSmartObject Procedure 
PROCEDURE setSmartObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       * We do nothing abouyt setting the physical_smartobject_obj since 
                 that value is now stored in the attribute values. It may be that
                 it is inherited from the class or it may have an override. Either
                 way, we let the attribute values take care of that process.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdCustomizationResultObj AS DECIMAL    NO-UNDO.
  
  DEFINE VARIABLE dPhysicalSmartObjectObj AS DECIMAL    NO-UNDO.
  
  DEFINE BUFFER   gsc_product_module  FOR gsc_product_module.
  DEFINE BUFFER b_ryc_smartobject     FOR ryc_smartobject.
  DEFINE BUFFER   ryc_smartobject     FOR ryc_smartobject.
  DEFINE BUFFER   rycso               FOR ryc_smartobject.
  DEFINE BUFFER   rycso_super         FOR ryc_smartObject.
  DEFINE BUFFER   ryc_layout          FOR ryc_layout.

/* Only find the container smartobject */
  FOR FIRST ttSmartObject
      WHERE ttSmartObject.d_smartobject_obj         <> 0.00
        AND ttSmartObject.c_action                  <> "":U
        AND ttSmartObject.d_customization_result_obj = pdCustomizationResultObj
         BY ttSmartObject.c_action DESCENDING:
    
    /* Find the object exclusively as we would need to need to update or delete it */
    FIND FIRST ryc_smartobject EXCLUSIVE-LOCK
         WHERE ryc_smartobject.smartobject_obj          = ttSmartObject.d_smartobject_obj
           AND ryc_smartobject.customization_result_obj = pdCustomizationResultObj NO-ERROR.

    /* Delete objects that should be deleted */
    IF ttSmartObject.c_action = "D" THEN
    DO:
      /* If it doesn't exist, then it never did (object added and deleted in the same session) */
      IF AVAILABLE ryc_smartobject THEN
      DO:
        IF pdCustomizationResultObj = 0.00 THEN
        DO:
          FOR EACH b_ryc_smartobject EXCLUSIVE-LOCK
             WHERE b_ryc_smartobject.object_filename          = ryc_smartobject.object_filename
               AND b_ryc_smartobject.customization_result_obj <> 0.00:
            
            RUN deleteObjectData (BUFFER b_ryc_smartobject) NO-ERROR.
    
            IF ERROR-STATUS:ERROR THEN
              RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).
          END.
        END.
        
        RUN deleteObjectData (BUFFER ryc_smartobject) NO-ERROR.

        IF ERROR-STATUS:ERROR THEN
          RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).
      END.

      /* If the record in the find was not available, the ERROR-STATUS would be raised */
      ERROR-STATUS:ERROR = FALSE.
      
      NEXT.
    END.

    /* Create smartobjects that should be created */
    IF ttSmartObject.c_action    = "A":U AND
       AVAILABLE ryc_smartobject = FALSE THEN
    DO:
      CREATE ryc_smartobject NO-ERROR.

      IF ERROR-STATUS:ERROR THEN
        RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).
    END.    

    IF ttSmartObject.d_layout_obj = 0.00 THEN
    DO:
      FIND FIRST ryc_layout NO-LOCK
           WHERE ryc_layout.layout_code = "06":U.
      
      ttSmartObject.d_layout_obj = ryc_layout.layout_obj.
    END.

    /* Assign the new values */
    IF ttSmartObject.c_action = "A":U OR
       ttSmartObject.c_action = "M":U THEN
    DO:
      FIND FIRST gsc_product_module NO-LOCK
           WHERE gsc_product_module.product_module_obj = ttSmartObject.d_product_module_obj NO-ERROR.

      ASSIGN
          ryc_smartobject.object_path              = (IF AVAILABLE gsc_product_module THEN gsc_product_module.relative_path ELSE "":U)
          ryc_smartobject.customization_result_obj = ttSmartObject.d_customization_result_obj
          ryc_smartobject.layout_obj               = ttSmartObject.d_layout_obj
          ryc_smartobject.object_type_obj          = ttSmartObject.d_object_type_obj
          ryc_smartobject.object_filename          = ttSmartObject.c_object_filename
          ryc_smartobject.product_module_obj       = ttSmartObject.d_product_module_obj
          ryc_smartobject.static_object            = ttSmartObject.l_static_object
          ryc_smartobject.system_owned             = ttSmartObject.l_system_owned
          ryc_smartobject.shutdown_message_text    = ttSmartObject.c_shutdown_message_text
          ryc_smartobject.sdo_smartobject_obj      = ttSmartObject.d_sdo_smartobject_obj
          ryc_smartobject.template_smartobject     = ttSmartObject.l_template_smartobject
          ryc_smartobject.object_description       = ttSmartObject.c_object_description
          ryc_smartobject.container_object         = TRUE
          ryc_smartobject.disabled                 = FALSE
          NO-ERROR.
         

      IF ERROR-STATUS:ERROR THEN
        RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).
      
      VALIDATE ryc_smartobject NO-ERROR.
    END.
    
    /* This must be done after the write because of reusing of object ids of possible deleted objects */
    /* Replace the temporary object numbers in the other tables:
       --------------------------------------------------------- */
    /* ttObjectInstance */
    FOR EACH ttObjectInstance
       WHERE ttObjectInstance.d_container_smartobject_obj = ttSmartObject.d_smartobject_obj:
      
      ttObjectInstance.d_container_smartobject_obj = ryc_smartobject.smartobject_obj.
    END.
    
    /* ttPage */
    FOR EACH ttPage
       WHERE ttPage.d_container_smartobject_obj = ttSmartObject.d_smartobject_obj:
      
      ttPage.d_container_smartobject_obj = ryc_smartobject.smartobject_obj.
    END.

    /* ttSmartLink */
    FOR EACH ttSmartLink
       WHERE ttSmartLink.d_container_smartobject_obj = ttSmartObject.d_smartobject_obj:
      
      ttSmartLink.d_container_smartobject_obj = ryc_smartobject.smartobject_obj.
    END.

    /* ttAttributeValue */
    FOR EACH ttAttributeValue
       WHERE ttAttributeValue.d_container_smartobject_obj = ttSmartObject.d_smartobject_obj
          OR ttAttributeValue.d_primary_smartobject_obj   = ttSmartObject.d_smartobject_obj
          OR ttAttributeValue.d_smartobject_obj           = ttSmartObject.d_smartobject_obj:

      /* If the container smartobject is the same as the container just created, point the attribute in its direction */
      IF ttAttributeValue.d_container_smartobject_obj = ttSmartObject.d_smartobject_obj THEN
        ttAttributeValue.d_container_smartobject_obj = ryc_smartobject.smartobject_obj.

      /* If the primary smartobject is the same as the container just created, point the attribute in its direction */
      IF ttAttributeValue.d_primary_smartobject_obj = ttSmartObject.d_smartobject_obj THEN
        ttAttributeValue.d_primary_smartobject_obj = ryc_smartobject.smartobject_obj.

      /* If the primary smartobject is the same as the container just created, point the attribute in its direction */
      IF ttAttributeValue.d_smartobject_obj = ttSmartObject.d_smartobject_obj THEN
        ttAttributeValue.d_smartobject_obj = ryc_smartobject.smartobject_obj.
    END.

    /* ttUiEvent */
    FOR EACH ttUiEvent
       WHERE ttUiEvent.d_container_smartobject_obj = ttSmartObject.d_smartobject_obj
          OR ttUiEvent.d_primary_smartobject_obj   = ttSmartObject.d_smartobject_obj
          OR ttUiEvent.d_smartobject_obj           = ttSmartObject.d_smartobject_obj:

      /* If the container smartobject is the same as the container just created, point the attribute in its direction */
      IF ttUiEvent.d_container_smartobject_obj = ttSmartObject.d_smartobject_obj THEN
        ttUiEvent.d_container_smartobject_obj = ryc_smartobject.smartobject_obj.

      /* If the primary smartobject is the same as the container just created, point the attribute in its direction */
      IF ttUiEvent.d_primary_smartobject_obj = ttSmartObject.d_smartobject_obj THEN
        ttUiEvent.d_primary_smartobject_obj = ryc_smartobject.smartobject_obj.

      /* If the primary smartobject is the same as the container just created, point the attribute in its direction */
      IF ttUiEvent.d_smartobject_obj = ttSmartObject.d_smartobject_obj THEN
        ttUiEvent.d_smartobject_obj = ryc_smartobject.smartobject_obj.
    END.

    /* ttObjectMenuStructure */
    FOR EACH ttObjectMenuStructure
       WHERE ttObjectMenuStructure.d_object_obj = ttSmartObject.d_smartobject_obj:

      ttObjectMenuStructure.d_object_obj = ryc_smartobject.smartobject_obj.
    END.
    
    ASSIGN 
      ryc_smartobject.security_smartobject_obj = ryc_smartobject.smartobject_obj
      ttSmartObject.d_smartobject_obj = ryc_smartobject.smartobject_obj.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUiEvent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setUiEvent Procedure 
PROCEDURE setUiEvent :
/*------------------------------------------------------------------------------
  Purpose:     Sets attribute values.
  Parameters:  pdObjectTypeObj        -
               pdSmartObjectObj       -
               pdContainerSmartObject -
               pdObjectInstanceObj    -
               pcAttributeLabel       -
               pcUiEvent       -   
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE       PARAMETER BUFFER bttUiEvent FOR ttUiEvent.

  DEFINE VARIABLE iErrorCount   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cErrorText    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cReturnValue  AS CHARACTER  NO-UNDO.

  DEFINE BUFFER ryc_ui_event           FOR ryc_ui_event.

  FIND FIRST ryc_ui_event EXCLUSIVE-LOCK
       WHERE ryc_ui_event.ui_event_obj = bttUiEvent.d_ui_event_obj NO-WAIT NO-ERROR.

  IF NOT AVAILABLE ryc_ui_event THEN
    FIND FIRST ryc_ui_event EXCLUSIVE-LOCK
         WHERE ryc_ui_event.object_type_obj           = bttUiEvent.d_object_type_obj
           AND ryc_ui_event.smartobject_obj           = bttUiEvent.d_smartobject_obj
           AND ryc_ui_event.event_name                = bttUiEvent.c_event_name
           AND ryc_ui_event.object_instance_obj       = bttUiEvent.d_object_instance_obj
           AND ryc_ui_event.container_smartobject_obj = bttUiEvent.d_container_smartobject_obj NO-WAIT NO-ERROR.

  IF NOT AVAILABLE ryc_ui_event THEN
  DO:
    CREATE ryc_ui_event NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
      RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).

    ASSIGN ryc_ui_event.object_type_obj           = bttUiEvent.d_object_type_obj
           ryc_ui_event.smartobject_obj           = bttUiEvent.d_smartobject_obj
           ryc_ui_event.object_instance_obj       = bttUiEvent.d_object_instance_obj
           ryc_ui_event.container_smartobject_obj = bttUiEvent.d_container_smartobject_obj
           ryc_ui_event.event_name                = bttUiEvent.c_event_name NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
    DO:
      cErrorText = "":U.

      DO iErrorCount = 1 TO ERROR-STATUS:NUM-MESSAGES:

        cErrorText = cErrorText + (IF NUM-ENTRIES(cErrorText, "~n":U) EQ 0 THEN "":U ELSE "~n":U)
                   + ERROR-STATUS:GET-MESSAGE(iErrorCount).
      END.    /* loop through errors */

      RETURN ERROR {aferrortxt.i 'AF' '40' 'rycsm_actual' '?' cErrorText}.
    END.    /* error */
  END.    /* n/a attrib */
  ELSE
  DO:
    /* The instance might have been replaced with another instance */
    ASSIGN
        ryc_ui_event.object_type_obj = bttUiEvent.d_object_type_obj
        ryc_ui_event.smartobject_obj = bttUiEvent.d_smartobject_obj.
  END.

  /* Assign the appropriate Ui Events */
  ASSIGN
      ryc_ui_event.constant_value  = bttUiEvent.l_constant_value
      ryc_ui_event.action_type     = bttUiEvent.c_action_type
      ryc_ui_event.action_target   = bttUiEvent.c_action_target
      ryc_ui_event.event_name      = bttUiEvent.c_event_name
      ryc_ui_event.event_action    = bttUiEvent.c_event_action
      ryc_ui_event.event_parameter = bttUiEvent.c_event_parameter
      ryc_ui_event.event_disabled  = bttUiEvent.l_event_disabled.

  IF ERROR-STATUS:ERROR THEN
  DO:
    cErrorText = "":U.

    DO iErrorCount = 1 TO ERROR-STATUS:NUM-MESSAGES:

      cErrorText = cErrorText + (IF NUM-ENTRIES(cErrorText, "~n":U) EQ 0 THEN "":U ELSE "~n":U)
                 + ERROR-STATUS:GET-MESSAGE(iErrorCount).
    END.    /* loop through errors */

    RETURN ERROR {aferrortxt.i 'AF' '40' 'rycsm_actual' '?' cErrorText}.
  END.    /* error */

  VALIDATE ryc_ui_event NO-ERROR.

  IF ERROR-STATUS:ERROR THEN
    RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateLayout) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateLayout Procedure 
PROCEDURE updateLayout :
/*------------------------------------------------------------------------------
  Purpose:  Step through the container and make sure that the main container
            and all of its children are on the relative layout
  
  Parameters:  INPUT pdCustomizationResultObj - The customization we are currently
                                                working on for a specific container
  Notes:  
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdCustomizationResultObj AS DECIMAL    NO-UNDO.

  DEFINE BUFFER ryc_object_instance FOR ryc_object_instance.
  DEFINE BUFFER ryc_smartobject     FOR ryc_smartobject.
  DEFINE BUFFER ryc_layout          FOR ryc_layout.
  DEFINE BUFFER ryc_page            FOR ryc_page.

  DEFINE BUFFER ttObjectInstance  FOR ttObjectInstance.
  DEFINE BUFFER ttSmartObject     FOR ttSmartObject.

  FIND FIRST ttSmartObject
       WHERE ttSmartObject.d_smartobject_obj <> 0.00.

  /* Find the relative layout */
  FIND FIRST ryc_layout NO-LOCK
       WHERE ryc_layout.layout_code = "06":U NO-ERROR.
  
  FOR FIRST ryc_smartobject EXCLUSIVE-LOCK
      WHERE ryc_smartobject.object_filename          = ttSmartObject.c_object_filename
        AND ryc_smartobject.customization_result_obj = pdCustomizationResultObj.

    /* Check if the layout for page zero changed */
    IF ryc_smartobject.layout_obj <> ryc_layout.layout_obj THEN
    DO:
      /* Now find all the objects that are on page zero, as we need to update their layout codes */
      FOR EACH ryc_object_instance EXCLUSIVE-LOCK
         WHERE ryc_object_instance.container_smartobject_obj = ryc_smartobject.smartobject_obj,
         FIRST ttObjectInstance
         WHERE ttObjectInstance.d_object_instance_obj = ryc_object_instance.object_instance_obj:

        /* If a page object record exist, then the object is not on page zero */
        IF ttObjectInstance.d_page_obj <> 0.00 THEN NEXT.

        /* Update the object instance record */
        ryc_object_instance.layout_position = ttObjectInstance.c_layout_position NO-ERROR.

        IF ERROR-STATUS:ERROR THEN
          RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).

        /* Validate the object instance record */
        VALIDATE ryc_object_instance NO-ERROR.

        IF ERROR-STATUS:ERROR THEN
          RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).
      END.

      /* Update the smartobject record */
      ryc_smartobject.layout_obj = ryc_layout.layout_obj NO-ERROR.

      IF ERROR-STATUS:ERROR THEN
        RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).

      /* Validate the smartobject record */
      VALIDATE ryc_smartobject NO-ERROR.

      IF ERROR-STATUS:ERROR THEN
        RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).
    END.

    /* Check if the layout for the rest of the pages have changed */
    FOR EACH ryc_page EXCLUSIVE-LOCK
       WHERE ryc_page.container_smartobject_obj = ryc_smartobject.smartobject_obj
         AND ryc_page.layout_obj               <> ryc_layout.layout_obj:

      /* Find all the pages that are not relatively laid out and then all the object instances on them */
      FOR EACH ryc_object_instance EXCLUSIVE-LOCK
         WHERE ryc_object_instance.page_obj = ryc_page.page_obj,
         FIRST ttObjectInstance
         WHERE ttObjectInstance.d_object_instance_obj = ryc_object_instance.object_instance_obj:

        /* Update the object instance record */
        ryc_object_instance.layout_position = ttObjectInstance.c_layout_position NO-ERROR.

        IF ERROR-STATUS:ERROR THEN
          RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).

        /* Validate the object instance record */
        VALIDATE ryc_object_instance NO-ERROR.

        IF ERROR-STATUS:ERROR THEN
          RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).
      END.

      /* Update the page record */
      ryc_page.layout_obj = ryc_layout.layout_obj NO-ERROR.

      IF ERROR-STATUS:ERROR THEN
        RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).

      /* Validate the page record */
      VALIDATE ryc_page NO-ERROR.

      IF ERROR-STATUS:ERROR THEN
        RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).
    END.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updatePageSequence) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updatePageSequence Procedure 
PROCEDURE updatePageSequence :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdContainerSmartObjectObj  AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER plUseTempTableSequence     AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE iPageSequence AS INTEGER  NO-UNDO.

  DEFINE BUFFER ryc_smartobject FOR ryc_smartobject.
  DEFINE BUFFER ttSmartObject   FOR ttSmartObject.
  DEFINE BUFFER ryc_page        FOR ryc_page.
  DEFINE BUFFER ttPage          FOR ttPage.

  /* Make the page sequence ? to avoid index clashes */
  FOR EACH ryc_page EXCLUSIVE-LOCK
     WHERE ryc_page.container_smartobject_obj = pdContainerSmartObjectObj:

    ryc_page.page_sequence = ?.
  END.

  iPageSequence = 0.
  FOR EACH ttPage
     WHERE ttPage.d_container_smartobject_obj = pdContainerSmartObjectObj,
     FIRST ryc_page EXCLUSIVE-LOCK
     WHERE ryc_page.container_smartobject_obj = pdContainerSmartObjectObj
       AND ryc_page.page_reference            = ttPage.c_page_reference
        BY ttPage.i_page_sequence:

    ASSIGN
        iPageSequence          = iPageSequence + 1
        ryc_page.page_sequence = (IF plUseTempTableSequence THEN ttPage.i_page_sequence ELSE iPageSequence).

    /* Pages that were compared and found */
    IF ttPage.c_action = "R":U THEN
    DO:
      IF ttPage.d_page_obj > 0.00 THEN
      DO:
        RUN deletePageData (BUFFER ryc_page).
      END.

      DELETE ttPage.
    END.
  END.

  FOR EACH ryc_page EXCLUSIVE-LOCK
     WHERE ryc_page.container_smartobject_obj = pdContainerSmartObjectObj
       AND ryc_page.page_sequence  = ?
       AND ryc_page.page_reference = ?:

    DELETE ryc_page NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
      RETURN ERROR (IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-attributeClasses) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION attributeClasses Procedure 
FUNCTION attributeClasses RETURNS CHARACTER
  (pcAttributeLabel AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAttributeClasses AS CHARACTER  NO-UNDO.

  FOR EACH ryc_attribute_value NO-LOCK
     WHERE ryc_attribute_value.attribute_label           = pcAttributeLabel
       AND ryc_attribute_value.container_smartobject_obj = 0.00
       AND ryc_attribute_value.object_instance_obj       = 0.00
       AND ryc_attribute_value.object_type_obj          <> 0.00
       AND ryc_attribute_value.smartobject_obj           = 0.00,
     FIRST gsc_object_type NO-LOCK
     WHERE gsc_object_type.object_type_obj = ryc_attribute_value.object_type_obj:

    cAttributeClasses = cAttributeClasses
                      + (IF cAttributeClasses = "":U THEN "":U ELSE ",":U)
                      + gsc_object_type.object_type_code.
  END.

  RETURN cAttributeClasses.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-attributeExistsInClass) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION attributeExistsInClass Procedure 
FUNCTION attributeExistsInClass RETURNS LOGICAL
  (pcAttributeLabel AS CHARACTER,
   pcObjectTypeCode AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAttributeClasses AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cInheritsFrom     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrentEntry     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lExistsInClass    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iAttribute        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iInherit          AS INTEGER    NO-UNDO.

  ASSIGN
      cAttributeClasses = DYNAMIC-FUNCTION("attributeClasses":U, pcAttributeLabel)
      cInheritsFrom     = DYNAMIC-FUNCTION("inheritsFrom":U, pcObjectTypeCode)
      lExistsInClass    = FALSE.

  existsInClass_BLOCK:
  DO iInherit = 1 TO NUM-ENTRIES(cInheritsFrom):

    cCurrentEntry = TRIM(ENTRY(iInherit, cInheritsFrom)).

    DO iAttribute = 1 TO NUM-ENTRIES(cAttributeClasses):

      IF cCurrentEntry = TRIM(ENTRY(iAttribute, cAttributeClasses)) THEN
      DO:
        lExistsInClass = TRUE.

        LEAVE existsInClass_BLOCK.
      END.
    END.
  END.

  RETURN lExistsInClass.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-compareLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION compareLinks Procedure 
FUNCTION compareLinks RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lSmartLinkChanged AS LOGICAL    NO-UNDO.
  
  DEFINE BUFFER ttSmartLink  FOR ttSmartLink.

  lSmartLinkChanged = CAN-FIND(FIRST ttSmartLink
                               WHERE ttSmartLink.d_customization_result_obj <> 0.00).

  RETURN lSmartLinkChanged.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-compareObjectInstance) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION compareObjectInstance Procedure 
FUNCTION compareObjectInstance RETURNS LOGICAL
  (pcInstanceName AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lInstanceChanged    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lAreTheSame         AS LOGICAL    NO-UNDO.

  DEFINE BUFFER ttCObjectInstance FOR ttObjectInstance. /* Customization Object Instance */
  DEFINE BUFFER ttObjectInstance  FOR ttObjectInstance. /* Original Object Instance      */
  DEFINE BUFFER ttCAttributeValue FOR ttAttributeValue. /* Customization Attribute Value */
  DEFINE BUFFER ttAttributeValue  FOR ttAttributeValue. /* Original Attribute Value      */
  DEFINE BUFFER ttCUiEvent        FOR ttUiEvent.        /* Customization Ui Event        */
  DEFINE BUFFER ttUiEvent         FOR ttUiEvent.        /* Original Ui Event             */

  FOR EACH ttCObjectInstance
     WHERE ttCObjectInstance.d_customization_result_obj <> 0.00:

    IF pcInstanceName <> ?                                 AND
       pcInstanceName <> ttCObjectInstance.c_instance_name THEN
      NEXT.

    lInstanceChanged = FALSE.

    FIND FIRST ttObjectInstance
         WHERE ttObjectInstance.d_customization_result_obj = 0.00
           AND ttObjectInstance.c_instance_name            = ttCObjectInstance.c_instance_name
           AND ttObjectInstance.d_smartobject_obj          = ttCObjectInstance.d_smartobject_obj NO-ERROR.

    IF NOT AVAILABLE ttObjectInstance THEN /* a page or an object has been added */
      lInstanceChanged = TRUE.
    ELSE
    DO:
      BUFFER-COMPARE ttCObjectInstance
               USING ttCObjectInstance.c_instance_description
                     ttCObjectInstance.c_layout_position
                     ttCObjectInstance.i_column
                     ttCObjectInstance.i_row
                     ttCObjectInstance.c_lcr
                  TO ttObjectInstance
      SAVE RESULT IN lAreTheSame.

      lInstanceChanged = NOT lAreTheSame.
    END.

    IF lInstanceChanged = TRUE THEN
      LEAVE.

    IF ttCObjectInstance.d_page_obj <> ttObjectInstance.d_page_obj THEN
      ASSIGN
          lInstanceChanged = ?.

    IF lInstanceChanged = ? THEN
      LEAVE.

    /* Compare the attributes - Step through all the customized attribute values and compare them against the master instance */
    FOR EACH ttCAttributeValue
       WHERE ttCAttributeValue.d_object_instance_obj      = ttCObjectInstance.d_object_instance_obj
         AND ttCAttributeValue.d_customization_result_obj = ttCObjectInstance.d_customization_result_obj
         AND ttCAttributeValue.d_smartobject_obj          = ttCObjectInstance.d_smartobject_obj
         AND ttCAttributeValue.d_object_type_obj          = ttCObjectInstance.d_object_type_obj
         AND ttCAttributeValue.d_primary_smartobject_obj  = ttCObjectInstance.d_container_smartobject_obj
         AND ttCAttributeValue.c_action                  <> "D":U:

      FIND FIRST ttAttributeValue
           WHERE ttAttributeValue.d_object_instance_obj      = ttObjectInstance.d_object_instance_obj
             AND ttAttributeValue.d_customization_result_obj = ttObjectInstance.d_customization_result_obj
             AND ttAttributeValue.d_smartobject_obj          = ttObjectInstance.d_smartobject_obj
             AND ttAttributeValue.d_object_type_obj          = ttObjectInstance.d_object_type_obj
             AND ttAttributeValue.d_primary_smartobject_obj  = ttObjectInstance.d_container_smartobject_obj
             AND ttAttributeValue.c_action                  <> "D":U NO-ERROR.

      IF NOT AVAILABLE ttAttributeValue THEN /* an attribute value has been added */
        lInstanceChanged = TRUE.
      ELSE
      DO:
        CASE ttCAttributeValue.i_data_type:
          WHEN {&DECIMAL-DATA-TYPE}   THEN lInstanceChanged = NOT ttCAttributeValue.d_decimal_value   = ttAttributeValue.d_decimal_value.
          WHEN {&INTEGER-DATA-TYPE}   THEN lInstanceChanged = NOT ttCAttributeValue.i_integer_value   = ttAttributeValue.i_integer_value.
          WHEN {&DATE-DATA-TYPE}      THEN lInstanceChanged = NOT ttCAttributeValue.t_date_value      = ttAttributeValue.t_date_value.
          WHEN {&RAW-DATA-TYPE}       THEN lInstanceChanged = NOT ttCAttributeValue.r_raw_value       = ttAttributeValue.r_raw_value.
          WHEN {&LOGICAL-DATA-TYPE}   THEN lInstanceChanged = NOT ttCAttributeValue.l_logical_value   = ttAttributeValue.l_logical_value.
          WHEN {&CHARACTER-DATA-TYPE} THEN lInstanceChanged = NOT ttCAttributeValue.c_character_value = ttAttributeValue.c_character_value.
        END CASE.
      END.

      IF lInstanceChanged = TRUE THEN LEAVE.
    END.

    /* Compare the ui events - Step through all the customized ui events and compare them against the master instance */
    FOR EACH ttCUiEvent
       WHERE ttCUiEvent.d_object_instance_obj      = ttCObjectInstance.d_object_instance_obj
         AND ttCUiEvent.d_customization_result_obj = ttCObjectInstance.d_customization_result_obj
         AND ttCUiEvent.d_smartobject_obj          = ttCObjectInstance.d_smartobject_obj
         AND ttCUiEvent.d_object_type_obj          = ttCObjectInstance.d_object_type_obj
         AND ttCUiEvent.d_primary_smartobject_obj  = ttCObjectInstance.d_container_smartobject_obj
         AND ttCUiEvent.c_action                  <> "D":U:

      FIND FIRST ttUiEvent
           WHERE ttUiEvent.d_object_instance_obj      = ttObjectInstance.d_object_instance_obj
             AND ttUiEvent.d_customization_result_obj = ttObjectInstance.d_customization_result_obj
             AND ttUiEvent.d_smartobject_obj          = ttObjectInstance.d_smartobject_obj
             AND ttUiEvent.d_object_type_obj          = ttObjectInstance.d_object_type_obj
             AND ttUiEvent.d_primary_smartobject_obj  = ttObjectInstance.d_container_smartobject_obj
             AND ttUiEvent.c_action                  <> "D":U NO-ERROR.

      IF NOT AVAILABLE ttUiEvent THEN /* an attribute value has been added */
        lInstanceChanged = TRUE.
      ELSE
        lInstanceChanged = NOT (ttCUiEvent.c_action_type     = ttUiEvent.c_action_type
                           AND  ttCUiEvent.c_action_target   = ttUiEvent.c_action_target
                           AND  ttCUiEvent.c_event_action    = ttUiEvent.c_event_action
                           AND  ttCUiEvent.c_event_parameter = ttUiEvent.c_event_parameter
                           AND  ttCUiEvent.l_event_disabled  = ttUiEvent.l_event_disabled).

      IF lInstanceChanged = TRUE THEN LEAVE.
    END.
  END.

  RETURN lInstanceChanged.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-comparePage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION comparePage Procedure 
FUNCTION comparePage RETURNS LOGICAL
  (pcPageReference AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lPageChanged  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lAreTheSame   AS LOGICAL    NO-UNDO.

  DEFINE BUFFER ttObjectInstance  FOR ttObjectInstance.
  DEFINE BUFFER ttCPage           FOR ttPage.
  DEFINE BUFFER ttPage            FOR ttPage.

  FOR EACH ttCPage
     WHERE ttCPage.d_customization_result_obj <> 0.00:

    lPageChanged = FALSE.

    IF pcPageReference <> ?                        AND
       pcPageReference <> ttCPage.c_page_reference THEN
      NEXT.

    FIND FIRST ttPage
         WHERE ttPage.d_customization_result_obj = 0.00
           AND ttPage.c_page_reference           = ttCPage.c_page_reference NO-ERROR.

    IF NOT AVAILABLE ttPage THEN /* a page has been added */
      lPageChanged = TRUE.
    ELSE
    DO:
      BUFFER-COMPARE ttCPage
               USING ttCPage.c_page_label
                     ttCPage.i_page_sequence
                     ttCPage.c_security_token
                     ttCPage.l_enable_on_create
                     ttCPage.l_enable_on_modify
                     ttCPage.l_enable_on_view
                     ttCPage.d_layout_obj
                  TO ttPage
      SAVE RESULT IN lAreTheSame.

      lPageChanged = NOT lAreTheSame.
    END.

    IF lPageChanged = TRUE THEN LEAVE.

    lPageChanged = NOT (ttCPage.i_page_sequence = ttCPage.i_original_page_sequence).

    IF lPageChanged = TRUE THEN LEAVE.

    IF CAN-FIND(FIRST ttObjectInstance
                WHERE ttObjectInstance.d_page_obj = ttCPage.d_page_obj
                  AND ttObjectInstance.c_action  <> "D":U) THEN
      lPageChanged = TRUE.

    IF lPageChanged = TRUE THEN LEAVE.
  END.

  RETURN lPageChanged.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAttributeValueNew) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAttributeValueNew Procedure 
FUNCTION getAttributeValueNew RETURNS CHARACTER
  (pcAttributeLabel           AS CHARACTER,
   pcInstanceName             AS CHARACTER,
   pdObjectTypeObj            AS DECIMAL,
   pdSmartObjectObj           AS DECIMAL,
   pdCustomizedSmartObjectObj AS DECIMAL,
   pdMainSmartObjectObj       AS DECIMAL,
   pdCustomizationResultObj   AS DECIMAL):
/*------------------------------------------------------------------------------
  Purpose:  To see if an attribute needs to be stored based on its value. We only
            store the value if it is different than the master instance / object type.
            
    Notes:  Returning FALSE will ensure that the attribute will be created / updated.
            IF TRUE is returned however, the attribute will be flagged to be deleted -
            ensuring that only the minimum number of attributes are stored.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAttributeValue         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldValue             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldname              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBaseWhere              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWhere                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAvailable              AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hRycAttributeValue      AS HANDLE     NO-UNDO.
  
  DEFINE BUFFER ttObjectInstance    FOR ttObjectInstance.
  DEFINE BUFFER ryc_attribute       FOR ryc_attribute.

  FIND FIRST ryc_attribute NO-LOCK
       WHERE ryc_attribute.attribute_label = pcAttributeLabel NO-ERROR.

  IF NOT AVAILABLE ryc_attribute THEN
    RETURN "":U.

  CREATE BUFFER hRycAttributeValue FOR TABLE "ryc_attribute_value":U.

  /* Construct the base 'WHERE' clause. SUBSTITUTE will be used to make the necessary replacements */
  cBaseWhere = "WHERE ryc_attribute_value.container_smartobject_obj = DECIMAL('&1')":U
             + "  AND ryc_attribute_value.primary_smartobject_obj   = DECIMAL('&2')":U
             + "  AND ryc_attribute_value.object_instance_obj       = DECIMAL('&3')":U
             + "  AND ryc_attribute_value.smartobject_obj           = DECIMAL('&4')":U
             + "  AND ryc_attribute_value.object_type_obj           = DECIMAL('&5')":U
             + "  AND ryc_attribute_value.attribute_label           = '&6' USE-INDEX XAK1ryc_attribute_value":U.

  /* Contstruct the 'AND' clause that will be appended to the 'WHERE' clause. This will remain the same for all the the finds */
  CASE ryc_attribute.data_type:
    WHEN {&DECIMAL-DATA-TYPE}   THEN cFieldname = "decimal_value":U.
    WHEN {&INTEGER-DATA-TYPE}   THEN cFieldname = "integer_value":U.
    WHEN {&DATE-DATA-TYPE}      THEN cFieldname = "date_value":U.
    WHEN {&LOGICAL-DATA-TYPE}   THEN cFieldname = "logical_value":U.
    WHEN {&CHARACTER-DATA-TYPE} THEN cFieldname = "character_value":U.
    WHEN {&RAW-DATA-TYPE}       THEN cFieldname = "raw_value":U.
  END CASE.

  IF pdCustomizationResultObj <> 0.00 THEN
  DO:
    IF pcInstanceName <> "":U THEN
    DO:
      FOR FIRST ttObjectInstance
          WHERE ttObjectInstance.c_instance_name             = pcInstanceName
            AND ttObjectInstance.d_customization_result_obj <> 0.00:
        
        IF CAN-FIND(FIRST ryc_attribute_value
                    WHERE ryc_attribute_value.container_smartobject_obj = pdCustomizedSmartObjectObj
                      AND ryc_attribute_value.primary_smartobject_obj   = pdCustomizedSmartObjectObj
                      AND ryc_attribute_value.object_instance_obj       = ttObjectInstance.d_object_instance_obj
                      AND ryc_attribute_value.smartobject_obj           = pdSmartObjectObj
                      AND ryc_attribute_value.object_type_obj           = pdObjectTypeObj
                      AND ryc_attribute_value.attribute_label           = pcAttributeLabel) THEN
        DO:
          cWhere = SUBSTITUTE(cBaseWhere, pdCustomizedSmartObjectObj,             /* container_smartobject_obj */
                                          pdCustomizedSmartObjectObj,             /* primary_smartobject_obj   */
                                          ttObjectInstance.d_object_instance_obj, /* object_instance_obj       */
                                          pdSmartObjectObj,                       /* smartobject_obj           */
                                          pdObjectTypeObj,                        /* object_type_obj           */
                                          pcAttributeLabel).                      /* attribute_label           */
  
          lAvailable = hRycAttributeValue:FIND-FIRST(cWhere) NO-ERROR.
  
          IF lAvailable = TRUE THEN
          DO:
            cFieldValue = STRING(hRycAttributeValue:BUFFER-FIELD(cFieldname):BUFFER-VALUE).
  
            DELETE OBJECT hRycAttributeValue.
            hRycAttributeValue = ?.
  
            RETURN cFieldValue.   /* Function return value. */
          END.
        END.
      END.
/*      
      /* If we reach this point, the attribute has not been stored against any other customization, so now check to see if it would be the same
         as the as the value on the master object instance. */
      FOR FIRST ttObjectInstance
          WHERE ttObjectInstance.c_instance_name            = ttObjectInstance.c_instance_name
            AND ttObjectInstance.d_customization_result_obj = 0.00:
  
        IF CAN-FIND(FIRST ryc_attribute_value
                    WHERE ryc_attribute_value.container_smartobject_obj = pdMainSmartObjectObj
                      AND ryc_attribute_value.primary_smartobject_obj   = pdMainSmartObjectObj
                      AND ryc_attribute_value.object_instance_obj       = ttObjectInstance.d_object_instance_obj
                      AND ryc_attribute_value.smartobject_obj           = pdSmartObjectObj
                      AND ryc_attribute_value.object_type_obj           = pdObjectTypeObj
                      AND ryc_attribute_value.attribute_label           = pcAttributeLabel) THEN
        DO:
          cWhere = SUBSTITUTE(cBaseWhere, pdMainSmartObjectObj,                   /* container_smartobject_obj */
                                          pdMainSmartObjectObj,                   /* primary_smartobject_obj   */
                                          ttObjectInstance.d_object_instance_obj, /* object_instance_obj       */
                                          pdSmartObjectObj,                       /* smartobject_obj           */
                                          pdObjectTypeObj,                        /* object_type_obj           */
                                          pcAttributeLabel).                      /* attribute_label           */

          lAvailable = hRycAttributeValue:FIND-FIRST(cWhere) NO-ERROR.
    
          IF lAvailable = TRUE THEN
          DO:
            cFieldValue = STRING(hRycAttributeValue:BUFFER-FIELD(cFieldname):BUFFER-VALUE).
    
            DELETE OBJECT hRycAttributeValue.
            hRycAttributeValue = ?.
    
            RETURN cFieldValue.   /* Function return value. */
          END.
        END.
      END.
*/
    END.
  END.

  FOR FIRST ttObjectInstance
      WHERE ttObjectInstance.c_instance_name            = pcInstanceName
        AND ttObjectInstance.d_customization_result_obj = 0.00:

    IF CAN-FIND(FIRST ryc_attribute_value
                WHERE ryc_attribute_value.container_smartobject_obj = pdMainSmartObjectObj
                  AND ryc_attribute_value.primary_smartobject_obj   = pdMainSmartObjectObj
                  AND ryc_attribute_value.object_instance_obj       = ttObjectInstance.d_object_instance_obj
                  AND ryc_attribute_value.smartobject_obj           = pdSmartObjectObj
                  AND ryc_attribute_value.object_type_obj           = pdObjectTypeObj
                  AND ryc_attribute_value.attribute_label           = pcAttributeLabel) THEN
    DO:
      cWhere = SUBSTITUTE(cBaseWhere, pdMainSmartObjectObj,                   /* container_smartobject_obj */
                                      pdMainSmartObjectObj,                   /* primary_smartobject_obj   */
                                      ttObjectInstance.d_object_instance_obj, /* object_instance_obj       */
                                      pdSmartObjectObj,                       /* smartobject_obj           */
                                      pdObjectTypeObj,                        /* object_type_obj           */
                                      pcAttributeLabel).                      /* attribute_label           */
      lAvailable = hRycAttributeValue:FIND-FIRST(cWhere) NO-ERROR.
  
      IF lAvailable = TRUE THEN
      DO:
        cFieldValue = STRING(hRycAttributeValue:BUFFER-FIELD(cFieldname):BUFFER-VALUE).
        
        DELETE OBJECT hRycAttributeValue.
        hRycAttributeValue = ?.
  
        RETURN cFieldValue.   /* Function return value. */
      END.
    END.
  END.
  
  
  /* This will compare the value of the attribute against the master instance. For instance, we will compare the value of the BackColor attribute
     of an instance of a SmartDataViewer against the original instance of the SmartDataViewer... This check should however not be done against the
     container itself BECAUSE: on adding, the value would be different / non-existent. However, on subsequent saving, it would be compared to itself
     and would be found to be the same, causing it to be deleted if we did the check */
  IF CAN-FIND(FIRST ryc_attribute_value
              WHERE ryc_attribute_value.container_smartobject_obj = 0.00
                AND ryc_attribute_value.primary_smartobject_obj   = pdSmartObjectObj
                AND ryc_attribute_value.object_instance_obj       = 0.00
                AND ryc_attribute_value.smartobject_obj           = pdSmartObjectObj
                AND ryc_attribute_value.object_type_obj           = pdObjectTypeObj
                AND ryc_attribute_value.attribute_label           = pcAttributeLabel) THEN
  DO:
    cWhere = SUBSTITUTE(cBaseWhere, 0.00,              /* container_smartobject_obj */
                                    pdSmartObjectObj,  /* primary_smartobject_obj   */
                                    0.00,              /* object_instance_obj       */
                                    pdSmartObjectObj,  /* smartobject_obj           */
                                    pdObjectTypeObj,   /* object_type_obj           */
                                    pcAttributeLabel). /* attribute_label           */

    lAvailable = hRycAttributeValue:FIND-FIRST(cWhere) NO-ERROR.
  
    IF lAvailable = TRUE THEN
    DO:
      cFieldValue = STRING(hRycAttributeValue:BUFFER-FIELD(cFieldname):BUFFER-VALUE).
  
      DELETE OBJECT hRycAttributeValue.
      hRycAttributeValue = ?.
  
      RETURN cFieldValue.   /* Function return value. */
    END.
  END.

  /* Reaching this point, we will be comparing the attribute value against the value of the class / object type */
  ASSIGN
      cWhere = SUBSTITUTE(cBaseWhere, 0.00,               /* container_smartobject_obj */
                                      0.00,               /* primary_smartobject_obj   */
                                      0.00,               /* object_instance_obj       */
                                      0.00,               /* smartobject_obj           */
                                      pdObjectTypeObj,    /* object_type_obj           */
                                      pcAttributeLabel).  /* attribute_label           */

  lAvailable = hRycAttributeValue:FIND-FIRST(cWhere) NO-ERROR.

  IF lAvailable = TRUE THEN
  DO:
    cFieldValue = STRING(hRycAttributeValue:BUFFER-FIELD(cFieldname):BUFFER-VALUE).

    DELETE OBJECT hRycAttributeValue.
    hRycAttributeValue = ?.

    RETURN cFieldValue.   /* Function return value. */
  END.
  
  IF VALID-HANDLE(hRycAttributeValue) THEN
  DO:
    DELETE OBJECT hRycAttributeValue.

    hRycAttributeValue = ?.
  END.

  RETURN "":U.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFirstAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFirstAvailable Procedure 
FUNCTION getFirstAvailable RETURNS CHARACTER
  (pcObjectTypeCode         AS CHARACTER,
   piPageNumber             AS INTEGER,
   pdCustomizationResultObj AS DECIMAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAvailable  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lFinished   AS LOGICAL    NO-UNDO INITIAL FALSE.
  DEFINE VARIABLE lFound      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iColumn     AS INTEGER    NO-UNDO INITIAL 0.
  DEFINE VARIABLE iRow        AS INTEGER    NO-UNDO INITIAL 1.
  
  DEFINE BUFFER ttObjectInstance FOR ttObjectInstance.
  
  IF DYNAMIC-FUNCTION("isVisibleObjectType":U, pcObjectTypeCode) = TRUE THEN
  DO WHILE lFinished = FALSE:
    ASSIGN
        iColumn   = iColumn + 1
        iRow      = IF iColumn > 9 THEN iRow + 1 ELSE iRow
        iColumn   = IF iColumn > 9 THEN 1        ELSE iColumn
        lFinished = IF iRow    > 9 THEN TRUE     ELSE FALSE
        lFound    = FALSE.
  
    IF lFinished = FALSE THEN
    DO:
      FOR EACH ttObjectInstance
         WHERE ttObjectInstance.d_customization_result_obj = pdCustomizationResultObj
           AND ttObjectInstance.i_row                      = iRow
           AND ttObjectInstance.i_page                     = piPageNumber
           AND lFound                                      = FALSE:
        
        IF ttObjectInstance.l_visible_object THEN
          lFound = TRUE.
      END.

      ASSIGN  
          lFinished  = NOT lFound
          cAvailable = IF lFinished = TRUE THEN
                         (IF iRow < 9 THEN "M":U ELSE "B":U) + STRING(iRow) + STRING(iColumn)
                       ELSE "":U.
    END.
  END.
  ELSE
  DO WHILE lFinished = FALSE:
    ASSIGN
        iColumn   = iColumn + 1
        iRow      = IF iColumn > 9 THEN iRow + 1 ELSE iRow
        iColumn   = IF iColumn > 9 THEN 1        ELSE iColumn
        lFinished = IF iRow    > 9 THEN TRUE     ELSE FALSE.
  
    IF lFinished = FALSE THEN
    DO:
      ASSIGN  
          lFinished  = NOT CAN-FIND(FIRST ttObjectInstance
                                    WHERE ttObjectInstance.d_customization_result_obj = pdCustomizationResultObj
                                      AND ttObjectInstance.i_column                   = iColumn
                                      AND ttObjectInstance.i_row                      = iRow
                                      AND ttObjectInstance.i_page                     = piPageNumber
                                      AND ttObjectInstance.l_visible_object           = FALSE)
          cAvailable = IF lFinished = TRUE THEN " ":U + STRING(iRow) + STRING(iColumn) ELSE "":U.
    END.
  END.
  
  RETURN cAvailable.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLastObjectOnRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLastObjectOnRow Procedure 
FUNCTION getLastObjectOnRow RETURNS INTEGER
  (pdObjectInstanceObj AS DECIMAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttObjectInstance FOR ttObjectInstance.
  DEFINE BUFFER ttObjectInstance  FOR ttObjectInstance.

  DEFINE VARIABLE iLastObject AS INTEGER    NO-UNDO.

  FOR FIRST bttObjectInstance
      WHERE bttObjectInstance.d_object_instance_obj = pdObjectInstanceObj,
       EACH ttObjectInstance
      WHERE ttObjectInstance.d_container_smartobject_obj = bttObjectInstance.d_container_smartobject_obj
        AND ttObjectInstance.d_object_instance_obj      <> bttObjectInstance.d_object_instance_obj
        AND ttObjectInstance.l_visible_object            = bttObjectInstance.l_visible_object
        AND ttObjectInstance.i_page                      = bttObjectInstance.i_page
        AND ttObjectInstance.i_row                       = bttObjectInstance.i_row:

     iLastObject = iLastObject + 1.
  END.

  iLastObject = iLastObject + 1.

  RETURN iLastObject.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUniquePageSequence) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUniquePageSequence Procedure 
FUNCTION getUniquePageSequence RETURNS INTEGER
  (pdCustomizationResultObj AS DECIMAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iPageSequence AS INTEGER    NO-UNDO.

  DEFINE BUFFER ttPage FOR ttPage.

  FOR EACH ttPage
     WHERE ttPage.d_customization_result_obj = pdCustomizationResultObj
     BREAK
        BY ttPage.i_page_sequence:
    
    IF LAST-OF(ttPage.i_page_sequence) THEN
      iPageSequence = ttPage.i_page_sequence + 1.
  END.
  
  IF iPageSequence = 0 THEN
    iPageSequence = 1.

  RETURN iPageSequence.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-inheritsFrom) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION inheritsFrom Procedure 
FUNCTION inheritsFrom RETURNS CHARACTER
  (pcObjectTypeCode AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Determines which classes (object types) a specific class (object type)
            inherits from
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cReversedOTString    AS CHARACTER                 NO-UNDO.
    DEFINE VARIABLE cInheritsFromOT      AS CHARACTER                 NO-UNDO.
    DEFINE variable cPropertyName        as character                 no-undo.
    DEFINE variable iCounter             as integer                   no-undo.
    
    cPropertyName = 'InheritsFromClasses':U.
    
    run getClassProperties in gshRepositoryManager ( input  pcObjectTypeCode,
                                                     input-output cPropertyName,
                                                     output cReversedOTString   ) no-error.
    
    cInheritsFromOT = FILL(",":U, NUM-ENTRIES(cReversedOTString) - 1).

    DO iCounter = 1 TO NUM-ENTRIES(cReversedOTString):
        ENTRY(NUM-ENTRIES(cReversedOTString) - iCounter + 1,  cInheritsFromOT) = ENTRY(iCounter, cReversedOTString).
    END.
  
    RETURN cInheritsFromOT.
END FUNCTION.    /* inheritsFrom */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isAttributeValueSame) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isAttributeValueSame Procedure 
FUNCTION isAttributeValueSame RETURNS LOGICAL
  (BUFFER ttAttributeValue FOR ttAttributeValue,
   INPUT  pcObjectFilename            AS CHARACTER,
   INPUT  pdCustomizedSmartObjectObj  AS DECIMAL,
   INPUT  pdMainSmartObjectObj        AS DECIMAL,
   INPUT  pdCustomizationResultObj    AS DECIMAL):
/*------------------------------------------------------------------------------
  Purpose:  To see if an attribute needs to be stored based on its value. We only
            store the value if it is different than the master instance / object type.
            
    Notes:  Returning FALSE will ensure that the attribute will be created / updated.
            IF TRUE is returned however, the attribute will be flagged to be deleted -
            ensuring that only the minimum number of attributes are stored.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cParentClasses          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBaseWhere              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAndString              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWhere                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cClass                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dMainObjectInstanceObj  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lSpecifiedOnMaster      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lAvailable              AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSameValue              AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iCounter                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hRycAttributeValue      AS HANDLE     NO-UNDO.

  DEFINE BUFFER bttObjectInstance   FOR ttObjectInstance.
  DEFINE BUFFER  ttObjectInstance   FOR ttObjectInstance.
  DEFINE BUFFER  ttSmartObject      FOR ttSmartObject.
  DEFINE BUFFER  gsc_object_type    FOR gsc_object_type.

  CREATE BUFFER hRycAttributeValue FOR TABLE "ryc_attribute_value":U.

  /* Construct the base 'WHERE' clause. SUBSTITUTE will be used to make the necessary replacements */
  cBaseWhere = "WHERE ryc_attribute_value.container_smartobject_obj = DECIMAL('&1')":U
             + "  AND ryc_attribute_value.primary_smartobject_obj   = DECIMAL('&2')":U
             + "  AND ryc_attribute_value.object_instance_obj       = DECIMAL('&3')":U
             + "  AND ryc_attribute_value.smartobject_obj           = DECIMAL('&4')":U
             + "  AND ryc_attribute_value.object_type_obj           = DECIMAL('&5')":U
             + "  AND ryc_attribute_value.attribute_label           = '&6'":U.

  /* Contstruct the 'AND' clause that will be appended to the 'WHERE' clause. This will remain the same for all the the finds */
  CASE ttAttributeValue.i_data_type:
    WHEN {&DECIMAL-DATA-TYPE}   THEN cAndString = " AND ryc_attribute_value.decimal_value     = DECIMAL('":U + STRING(ttAttributeValue.d_decimal_value) + "')":U.
    WHEN {&INTEGER-DATA-TYPE}   THEN cAndString = " AND ryc_attribute_value.integer_value     = ":U          + STRING(ttAttributeValue.i_integer_value).
    WHEN {&DATE-DATA-TYPE}      THEN cAndString = " AND ryc_attribute_value.date_value        = DATE('":U    + STRING(ttAttributeValue.t_date_value)    + "')":U.
    WHEN {&LOGICAL-DATA-TYPE}   THEN cAndString = " AND ryc_attribute_value.logical_value     = ":U          + STRING(ttAttributeValue.l_logical_value).
    WHEN {&CHARACTER-DATA-TYPE} THEN cAndString = " AND ryc_attribute_value.character_value   = '":U         + ttAttributeValue.c_character_value       + "'":U.
    WHEN {&RAW-DATA-TYPE}       THEN cAndString = " AND STRING(ryc_attribute_value.raw_value) = '":U         + STRING(ttAttributeValue.r_raw_value).
  END CASE.

  IF pdCustomizationResultObj <> 0.00 THEN
  DO:
    IF ttAttributeValue.d_object_instance_obj <> 0.00 THEN
    DO:
      FIND FIRST ttObjectInstance
           WHERE ttObjectInstance.d_object_instance_obj = ttAttributeValue.d_object_instance_obj NO-ERROR.

      /* Check to see if the attribute is specified against the object instance on ANY customized container. If so, the attribute would need to be
         stored - even if it has the same value as the master instance of the object. This is because a value can be overridden with customization, but
         can be put back to its default value with another customization... */
      FOR EACH ryc_smartobject NO-LOCK
         WHERE ryc_smartobject.object_filename           = pcObjectFilename
           AND ryc_smartobject.customization_result_obj <> 0.00
           AND ryc_smartobject.customization_result_obj <> pdCustomizationResultObj,
          EACH ryc_object_instance NO-LOCK
         WHERE ryc_object_instance.container_smartobject_obj = ryc_smartobject.smartobject_obj
           AND ryc_object_instance.smartobject_obj           = ttAttributeValue.d_smartobject_obj
           AND ryc_object_instance.instance_name             = ttObjectInstance.c_instance_name:

        ASSIGN
            cWhere = SUBSTITUTE(cBaseWhere, ryc_smartobject.smartobject_obj,          /* container_smartobject_obj */
                                            ryc_smartobject.smartobject_obj,          /* primary_smartobject_obj   */
                                            ryc_object_instance.object_instance_obj,  /* object_instance_obj       */
                                            ttAttributeValue.d_smartobject_obj,       /* smartobject_obj           */
                                            ttAttributeValue.d_object_type_obj,       /* object_type_obj           */
                                            ttAttributeValue.c_attribute_label).      /* attribute_label           */

        lAvailable = hRycAttributeValue:FIND-FIRST(cWhere) NO-ERROR.

        IF lAvailable = TRUE THEN
        DO:
          DELETE OBJECT hRycAttributeValue.
          hRycAttributeValue = ?.

          RETURN FALSE.   /* Function return value. */
        END.
      END.

      /* If we reach this point, the attribute has not been stored against any other customization, so now check to see if it would be the same
         as the as the value on the master object instance. */
      dMainObjectInstanceObj = ttObjectInstance.d_object_instance_obj.

      FOR FIRST bttObjectInstance
          WHERE bttObjectInstance.c_instance_name            = ttObjectInstance.c_instance_name
            AND bttObjectInstance.d_customization_result_obj = 0.00:

        dMainObjectInstanceObj = bttObjectInstance.d_object_instance_obj.
      END.

      ASSIGN
          cWhere = SUBSTITUTE(cBaseWhere, pdMainSmartObjectObj,                 /* container_smartobject_obj */
                                          pdMainSmartObjectObj,                 /* primary_smartobject_obj   */
                                          dMainObjectInstanceObj,               /* object_instance_obj       */
                                          ttAttributeValue.d_smartobject_obj,   /* smartobject_obj           */
                                          ttAttributeValue.d_object_type_obj,   /* object_type_obj           */
                                          ttAttributeValue.c_attribute_label).  /* attribute_label           */

      lAvailable         = hRycAttributeValue:FIND-FIRST(cWhere + cAndString) NO-ERROR.
      lSpecifiedOnMaster = hRycAttributeValue:FIND-FIRST(cWhere)              NO-ERROR. /* Instance on UnCustomized Container */

      IF lAvailable = TRUE THEN
      DO:
        DELETE OBJECT hRycAttributeValue.
        hRycAttributeValue = ?.

        RETURN TRUE.   /* Function return value. */
      END.
      ELSE
        IF lSpecifiedOnMaster THEN
        DO:
          DELETE OBJECT hRycAttributeValue.
          hRycAttributeValue = ?.

          RETURN FALSE.   /* Function return value. */
        END.
    END.
    ELSE
    DO:
      /* Check to see if the attribute is specified against ANY customized container. If so, the attribute would need to be stored - even
         if it has the same value as the master container. This is because a value can be overridden with customization, but can be put
         back to its default value with another customization... */
      FOR EACH ryc_smartobject NO-LOCK
         WHERE ryc_smartobject.object_filename           = pcObjectFilename
           AND ryc_smartobject.customization_result_obj <> 0.00
           AND ryc_smartobject.customization_result_obj <> pdCustomizationResultObj:

        ASSIGN
            cWhere = SUBSTITUTE(cBaseWhere, 0.00,                                 /* container_smartobject_obj */
                                            ryc_smartobject.smartobject_obj,      /* primary_smartobject_obj   */
                                            0.00,                                 /* object_instance_obj       */
                                            ttAttributeValue.d_smartobject_obj,   /* smartobject_obj           */
                                            ttAttributeValue.d_object_type_obj,   /* object_type_obj           */
                                            ttAttributeValue.c_attribute_label).  /* attribute_label           */

        lAvailable = hRycAttributeValue:FIND-FIRST(cWhere) NO-ERROR.

        IF lAvailable = TRUE THEN
        DO:
          DELETE OBJECT hRycAttributeValue.
          hRycAttributeValue = ?.

          RETURN FALSE.   /* Function return value. */
        END.
      END.
    END.
  END.

  /* This will compare the value of the attribute against the master instance. For instance, we eill compare the value of the BackColor attribute
     of an instance of a SmartDataViewer against the original instance of the SmartDataViewer... This check should however not be done against the
     container itself BECAUSE: on adding, the value would be different / non-existent. However, on subsequent saving, it would be compares to itself
     and would be found to be the same, causing it to be deleted if we did the check */
  IF NOT ((ttAttributeValue.d_smartobject_obj = pdMainSmartObjectObj
     AND   pdCustomizationResultObj           = 0.00)
      OR  (ttAttributeValue.d_smartobject_obj = pdCustomizedSmartObjectObj
     AND   pdCustomizationResultObj          <> 0.00))                     THEN
  DO:
    ASSIGN
        cWhere = SUBSTITUTE(cBaseWhere, 0.00,                                 /* container_smartobject_obj */
                                        ttAttributeValue.d_smartobject_obj,   /* primary_smartobject_obj   */
                                        0.00,                                 /* object_instance_obj       */
                                        ttAttributeValue.d_smartobject_obj,   /* smartobject_obj           */
                                        ttAttributeValue.d_object_type_obj,   /* object_type_obj           */
                                        ttAttributeValue.c_attribute_label).  /* attribute_label           */

    lSpecifiedOnMaster = hRycAttributeValue:FIND-FIRST(cWhere)              NO-ERROR.
    lAvailable         = hRycAttributeValue:FIND-FIRST(cWhere + cAndString) NO-ERROR.

    IF lAvailable = TRUE THEN
    DO:
      DELETE OBJECT hRycAttributeValue.
      hRycAttributeValue = ?.

      RETURN TRUE.   /* Function return value. */
    END.
    ELSE
      IF lSpecifiedOnMaster THEN
      DO:
        DELETE OBJECT hRycAttributeValue.
        hRycAttributeValue = ?.

        RETURN FALSE.   /* Function return value. */
      END.
  END.

  /* Reaching this point, we will be comparing the attribute value against the value of the class / object type */
  FIND FIRST gsc_object_type NO-LOCK
       WHERE gsc_object_type.object_type_obj = ttAttributeValue.d_object_type_obj.

  cParentClasses = DYNAMIC-FUNCTION("getClassParentsFromDB":U IN gshRepositoryManager, gsc_object_type.object_type_code).

  /* We need to compare up into the classes as the classes inherit from each other */
  Att_blk:
  DO iCounter = 1 TO NUM-ENTRIES(cParentClasses):
    FIND FIRST gsc_object_type NO-LOCK
         WHERE gsc_object_type.object_type_code = ENTRY(iCounter, cParentClasses).

    ASSIGN
        cWhere = SUBSTITUTE(cBaseWhere, 0.00,                                 /* container_smartobject_obj */
                                        0.00,                                 /* primary_smartobject_obj   */
                                        0.00,                                 /* object_instance_obj       */
                                        0.00,                                 /* smartobject_obj           */
                                        gsc_object_type.object_type_obj,      /* object_type_obj           */
                                        ttAttributeValue.c_attribute_label).  /* attribute_label           */

    lAvailable = hRycAttributeValue:FIND-FIRST(cWhere + cAndString) NO-ERROR.

    IF lAvailable = TRUE THEN
    DO:
      DELETE OBJECT hRycAttributeValue.
      hRycAttributeValue = ?.

      RETURN TRUE.   /* Function return value. */
    END.

    /* The first class we encountered, will be the one with which we need to compare the value bcause that value takes precedence.
       So if the value existed in the class and the values are different, then the attribute should be stored */
    IF CAN-FIND(FIRST ryc_attribute_value
                WHERE ryc_attribute_value.container_smartobject_obj = 0.00
                  AND ryc_attribute_value.primary_smartobject_obj   = 0.00
                  AND ryc_attribute_value.object_instance_obj       = 0.00
                  AND ryc_attribute_value.smartobject_obj           = 0.00
                  AND ryc_attribute_value.object_type_obj           = gsc_object_type.object_type_obj
                  AND ryc_attribute_value.attribute_label           = ttAttributeValue.c_attribute_label) THEN
      LEAVE Att_blk.
  END.

  IF VALID-HANDLE(hRycAttributeValue) THEN
  DO:
    DELETE OBJECT hRycAttributeValue.

    hRycAttributeValue = ?.
  END.

  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isUiEventSame) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isUiEventSame Procedure 
FUNCTION isUiEventSame RETURNS LOGICAL
  (BUFFER ttUiEvent FOR ttUiEvent,
   INPUT  pcObjectFilename            AS CHARACTER,
   INPUT  pdCustomizedSmartObjectObj  AS DECIMAL,
   INPUT  pdMainSmartObjectObj        AS DECIMAL,
   INPUT  pdCustomizationResultObj    AS DECIMAL):
/*------------------------------------------------------------------------------
  Purpose:  To see if a ui event needs to be stored based on its value. We only
            store the event if it is different than the master instance / object type.
            
    Notes:  Returning FALSE will ensure that the event will be created / updated.
            IF TRUE is returned however, the event will be flagged to be deleted -
            ensuring that only the minimum number of events are stored.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cParentClasses          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBaseWhere              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAndString              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWhere                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dMainObjectInstanceObj  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lSpecifiedOnMaster      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lAvailable              AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSameValue              AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iCounter                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hRycUiEvent             AS HANDLE     NO-UNDO.

  DEFINE BUFFER bttObjectInstance   FOR ttObjectInstance.
  DEFINE BUFFER  ttObjectInstance   FOR ttObjectInstance.
  DEFINE BUFFER  ttSmartObject      FOR ttSmartObject.
  DEFINE BUFFER  gsc_object_type    FOR gsc_object_type.

  CREATE BUFFER hRycUiEvent FOR TABLE "ryc_ui_event":U.
  
  /* Construct the base 'WHERE' clause. SUBSTITUTE will be used to make the necessary replacements */
  cBaseWhere = "WHERE ryc_ui_event.container_smartobject_obj = DECIMAL('&1')":U
             + "  AND ryc_ui_event.primary_smartobject_obj   = DECIMAL('&2')":U
             + "  AND ryc_ui_event.object_instance_obj       = DECIMAL('&3')":U
             + "  AND ryc_ui_event.smartobject_obj           = DECIMAL('&4')":U
             + "  AND ryc_ui_event.object_type_obj           = DECIMAL('&5')":U
             + "  AND ryc_ui_event.event_name                = '&6'":U.

  /* Contstruct the 'AND' clause that will be appended to the 'WHERE' clause. This will remain the same for all the the finds */
  cAndString = " AND ryc_ui_event.action_type     = ":U + QUOTER(ttUiEvent.c_action_type)
             + " AND ryc_ui_event.action_target   = ":U + QUOTER(ttUiEvent.c_action_target)
             + " AND ryc_ui_event.event_action    = ":U + QUOTER(ttUiEvent.c_event_action)
             + " AND ryc_ui_event.event_parameter = ":U + QUOTER(ttUiEvent.c_event_parameter)
             + " AND ryc_ui_event.event_disabled  = ":U + QUOTER(ttUiEvent.l_event_disabled).

  IF pdCustomizationResultObj <> 0.00 THEN
  DO:
    IF ttUiEvent.d_object_instance_obj <> 0.00 THEN
    DO:
      FIND FIRST ttObjectInstance
           WHERE ttObjectInstance.d_object_instance_obj = ttUiEvent.d_object_instance_obj NO-ERROR.

      /* Check to see if the event is specified against the object instance on ANY customized container. If so, the event would need to be
         stored - even if it has the same value as the master instance of the object. This is because a value can be overridden with customization, but
         can be put back to its default value with another customization... */
      FOR EACH ryc_smartobject NO-LOCK
         WHERE ryc_smartobject.object_filename           = pcObjectFilename
           AND ryc_smartobject.customization_result_obj <> 0.00
           AND ryc_smartobject.customization_result_obj <> pdCustomizationResultObj,
          EACH ryc_object_instance NO-LOCK
         WHERE ryc_object_instance.container_smartobject_obj = ryc_smartobject.smartobject_obj
           AND ryc_object_instance.smartobject_obj           = ttUiEvent.d_smartobject_obj
           AND ryc_object_instance.instance_name             = ttObjectInstance.c_instance_name:
  
        ASSIGN
            cWhere = SUBSTITUTE(cBaseWhere, ryc_smartobject.smartobject_obj,          /* container_smartobject_obj */
                                            ryc_smartobject.smartobject_obj,          /* primary_smartobject_obj   */
                                            ryc_object_instance.object_instance_obj,  /* object_instance_obj       */
                                            ttUiEvent.d_smartobject_obj,              /* smartobject_obj           */
                                            ttUiEvent.d_object_type_obj,              /* object_type_obj           */
                                            ttUiEvent.c_event_name).                  /* event_name                */
  
        lAvailable = hRycUiEvent:FIND-FIRST(cWhere) NO-ERROR.
        
        IF lAvailable = TRUE THEN
        DO:
          DELETE OBJECT hRycUiEvent.
          hRycUiEvent = ?.
  
          RETURN FALSE.   /* Function return value. */
        END.
      END.
  
      /* If we reach this point, the event has not been stored against any other customization, so now check to see if it would be the same
         as the as the value on the master object instance. */
      dMainObjectInstanceObj = ttObjectInstance.d_object_instance_obj.
  
      FOR FIRST bttObjectInstance
          WHERE bttObjectInstance.c_instance_name            = ttObjectInstance.c_instance_name
            AND bttObjectInstance.d_customization_result_obj = 0.00:
  
        dMainObjectInstanceObj = bttObjectInstance.d_object_instance_obj.
      END.
  
      ASSIGN
          cWhere = SUBSTITUTE(cBaseWhere, pdMainSmartObjectObj,         /* container_smartobject_obj */
                                          pdMainSmartObjectObj,         /* primary_smartobject_obj   */
                                          dMainObjectInstanceObj,       /* object_instance_obj       */
                                          ttUiEvent.d_smartobject_obj,  /* smartobject_obj           */
                                          ttUiEvent.d_object_type_obj,  /* object_type_obj           */
                                          ttUiEvent.c_event_name).      /* event_name                */
  
      lAvailable         = hRycUiEvent:FIND-FIRST(cWhere + cAndString) NO-ERROR.
      lSpecifiedOnMaster = hRycUiEvent:FIND-FIRST(cWhere)              NO-ERROR. /* Instance on UnCustomized Container */
  
      IF lAvailable = TRUE THEN
      DO:
        DELETE OBJECT hRycUiEvent.
        hRycUiEvent = ?.
  
        RETURN TRUE.   /* Function return value. */
      END.
      ELSE
        IF lSpecifiedOnMaster THEN
        DO:
          DELETE OBJECT hRycUiEvent.
          hRycUiEvent = ?.

          RETURN FALSE.   /* Function return value. */
        END.
    END.
    ELSE
    DO:
      /* Check to see if the event is specified against ANY customized container. If so, the event would need to be stored - even
         if it has the same value as the master container. This is because a value can be overridden with customization, but can be put
         back to its default value with another customization... */
      FOR EACH ryc_smartobject NO-LOCK
         WHERE ryc_smartobject.object_filename           = pcObjectFilename
           AND ryc_smartobject.customization_result_obj <> 0.00
           AND ryc_smartobject.customization_result_obj <> pdCustomizationResultObj:

        ASSIGN        
            cWhere = SUBSTITUTE(cBaseWhere, 0.00,                             /* container_smartobject_obj */
                                            ryc_smartobject.smartobject_obj,  /* primary_smartobject_obj   */
                                            0.00,                             /* object_instance_obj       */
                                            ttUiEvent.d_smartobject_obj,      /* smartobject_obj           */
                                            ttUiEvent.d_object_type_obj,      /* object_type_obj           */
                                            ttUiEvent.c_event_name).          /* event_name                */

        lAvailable = hRycUiEvent:FIND-FIRST(cWhere) NO-ERROR.

        IF lAvailable = TRUE THEN
        DO:
          DELETE OBJECT hRycUiEvent.
          hRycUiEvent = ?.

          RETURN FALSE.   /* Function return value. */
        END.
      END.
    END.
  END.

  /* This will compare the value of the event against the master instance. For instance, we eill compare the value of the BackColor event
     of an instance of a SmartDataViewer against the original instance of the SmartDataViewer... This check should however not be done against the
     container itself BECAUSE: on adding, the value would be different / non-existent. However, on subsequent saving, it would be compares to itself
     and would be found to be the same, causing it to be deleted if we did the check */
  IF NOT ((ttUiEvent.d_smartobject_obj = pdMainSmartObjectObj
     AND   pdCustomizationResultObj    = 0.00)
      OR  (ttUiEvent.d_smartobject_obj = pdCustomizedSmartObjectObj
     AND   pdCustomizationResultObj   <> 0.00))                     THEN
  DO:
    ASSIGN
        cWhere = SUBSTITUTE(cBaseWhere, 0.00,                         /* container_smartobject_obj */
                                        ttUiEvent.d_smartobject_obj,  /* primary_smartobject_obj   */
                                        0.00,                         /* object_instance_obj       */
                                        ttUiEvent.d_smartobject_obj,  /* smartobject_obj           */
                                        ttUiEvent.d_object_type_obj,  /* object_type_obj           */
                                        ttUiEvent.c_event_name).      /* event_name                */

    lSpecifiedOnMaster = hRycUiEvent:FIND-FIRST(cWhere)              NO-ERROR.
    lAvailable         = hRycUiEvent:FIND-FIRST(cWhere + cAndString) NO-ERROR.
  
    IF lAvailable = TRUE THEN
    DO:
      DELETE OBJECT hRycUiEvent.
      hRycUiEvent = ?.
  
      RETURN TRUE.   /* Function return value. */
    END.
    ELSE
      IF lSpecifiedOnMaster THEN
      DO:
        DELETE OBJECT hRycUiEvent.
        hRycUiEvent = ?.

        RETURN FALSE.   /* Function return value. */
      END.
  END.

  /* Reaching this point, we will be comparing the event against the value of the class / object type */
  FIND FIRST gsc_object_type NO-LOCK
       WHERE gsc_object_type.object_type_obj = ttUiEvent.d_object_type_obj.

  cParentClasses = DYNAMIC-FUNCTION("getClassParentsFromDB":U IN gshRepositoryManager, gsc_object_type.object_type_code).

  /* We need to compare up into the classes as the classes inherit from each other */
  Eve_blk:
  DO iCounter = 1 TO NUM-ENTRIES(cParentClasses):
    FIND FIRST gsc_object_type NO-LOCK
         WHERE gsc_object_type.object_type_code = ENTRY(iCounter, cParentClasses).

    ASSIGN
        cWhere = SUBSTITUTE(cBaseWhere, 0.00,                                 /* container_smartobject_obj */
                                        0.00,                                 /* primary_smartobject_obj   */
                                        0.00,                                 /* object_instance_obj       */
                                        0.00,                                 /* smartobject_obj           */
                                        gsc_object_type.object_type_obj,      /* object_type_obj           */
                                        ttUiEvent.c_event_name).              /* event_name                */

    lAvailable = hRycUiEvent:FIND-FIRST(cWhere + cAndString) NO-ERROR.

    IF lAvailable = TRUE THEN
    DO:
      DELETE OBJECT hRycUiEvent.
      hRycUiEvent = ?.

      RETURN TRUE.   /* Function return value. */
    END.

    /* The first class we encountered, will be the one with which we need to compare the value bcause that value takes precedence.
       So if the value existed in the class and the values are different, then the event should be stored */
    IF CAN-FIND(FIRST ryc_ui_event
                WHERE ryc_ui_event.container_smartobject_obj = 0.00
                  AND ryc_ui_event.primary_smartobject_obj   = 0.00
                  AND ryc_ui_event.object_instance_obj       = 0.00
                  AND ryc_ui_event.smartobject_obj           = 0.00
                  AND ryc_ui_event.object_type_obj           = gsc_object_type.object_type_obj
                  AND ryc_ui_event.event_name                = ttUiEvent.c_event_name) THEN
      LEAVE Eve_blk.
  END.

  IF VALID-HANDLE(hRycUiEvent) THEN
  DO:
    DELETE OBJECT hRycUiEvent.

    hRycUiEvent = ?.
  END.

  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isVisibleObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isVisibleObject Procedure 
FUNCTION isVisibleObject RETURNS LOGICAL
  (pdObjectInstanceObj AS DECIMAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lVisibleObject  AS LOGICAL    NO-UNDO.
  
  DEFINE BUFFER ttObjectInstance FOR ttObjectInstance.
  DEFINE BUFFER gsc_object_type  FOR gsc_object_type.
  
  FOR FIRST ttObjectInstance
      WHERE ttObjectInstance.d_object_instance_obj = pdObjectInstanceObj,
      FIRST gsc_object_type
      WHERE gsc_object_type.object_type_obj = ttObjectInstance.d_object_type_obj:
    
    lVisibleObject = DYNAMIC-FUNCTION("isVisibleObjectType":U, gsc_object_type.object_type_code).
  END.
  
  RETURN lVisibleObject.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

