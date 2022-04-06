/*---------------------------------------------------------------------------------
  File: rydescpmoi.i

  Description:  Repository Design Manager Include for the copyMasterObject() API.

  Purpose:      This include contains the code from the copyMasterObject() API. It 
                has moved into this incvlude file because of section editor limits.

  Parameters:   pcSourceObjectName    -
                pcSourceResultCode    -
                pcTargetObjectName    -
                pcTargetClass         -
                pcTargetProductModule -
                pcTargetRelativePath  -
                pdSmartObjectObj      -
  
  

  History:
  --------
  (v:010000)    Task:           0   UserRef:    IZ 10361
                Date:   05/18/2003  Author:     Peter Judge

  Update Notes: 

---------------------------------------------------------------------------------*/ 
    DEFINE VARIABLE dPageObjectObj              AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE dObjectInstanceObj          AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE dCustomisationResultObj     AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE dSourceSmartObjectObj       AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE dProductModuleObj           AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE dObjectTypeObj              AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE dPageObj                    AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE dInstanceSmartObjectObj     AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE hStoreBuffer                AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hStoreTable                 AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hDesignManager              AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE cObjectPath                 AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cEnableOn                   AS CHARACTER                NO-UNDO.
    
    DEFINE BUFFER rycso             FOR ryc_smartObject.
    DEFINE BUFFER ryc_smartObject   FOR ryc_smartObject.

    ASSIGN hDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U IN TARGET-PROCEDURE,
                                             INPUT "RepositoryDesignManager":U).
    
    /** Find the source result code
     *  ----------------------------------------------------------------------- **/
    ASSIGN dCustomisationResultObj = DYNAMIC-FUNCTION("getResultCodeObj":U IN hDesignManager,
                                                      INPUT pcSourceResultCode).
    /* A value of 0 means that the default result code is used, and is a valid value. */
    IF dCustomisationResultObj EQ ? THEN
        RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' "'Customization Result'" pcSourceResultCode}.

    /* Make sure that the source object exists. */
    ASSIGN dSourceSmartObjectObj = DYNAMIC-FUNCTION("getSmartObjectObj":U IN hDesignManager,
                                                    INPUT pcSourceObjectName, INPUT dCustomisationResultObj).
    IF dSourceSmartObjectObj EQ 0 OR dSourceSmartObjectObj EQ ? THEN
        RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' '"source object"' "'Source object is ' + pcSourceObjectName" }.

    /** Validate all the parameters up front.
     *  ----------------------------------------------------------------------- **/
    /* Check if the target object already exists. If so, then use that object. */
    ASSIGN pdSmartObjectObj = DYNAMIC-FUNCTION("getSmartObjectObj":U IN hDesignManager,
                                               INPUT pcTargetObjectName, INPUT dCustomisationResultObj ).

    /* Find the source record. */
    FIND FIRST ryc_smartObject WHERE
               ryc_smartObject.smartObject_obj = dSourceSmartObjectObj
               NO-LOCK NO-ERROR.

    /* Check that the product module is OK */
    IF pcTargetProductModule NE "" THEN
    DO:
        FIND FIRST gsc_product_module WHERE
                   gsc_product_module.product_module_code = pcTargetProductModule
                   NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gsc_product_module THEN
            RETURN ERROR {aferrortxt.i 'AF' '5' 'gsc_product_module' 'product_module_code' '"product module"' "'' + pcTargetProductModule" }.

        ASSIGN dProductModuleObj = gsc_product_module.product_module_obj.
    END.    /* there is a product module to copy. */
    ELSE
        ASSIGN dProductModuleObj = ryc_smartObject.product_module_obj.

    /* Set up the object relative path. */
    IF pcTargetRelativePath EQ ? OR pcTargetRelativePath = "":U THEN
        ASSIGN cObjectPath = ryc_smartObject.object_path.
    ELSE
        ASSIGN cObjectPath = pcTargetRelativePath.

    /* Get the target class, and make sure that it inherits from the source class, or is the same. */    
    FIND FIRST gsc_object_type WHERE
               gsc_object_type.object_type_obj = ryc_smartObject.object_type_obj
               NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gsc_object_type THEN
        RETURN ERROR {aferrortxt.i 'AF' '5' 'gsc_object_type' 'object_type_obj' '"class of the source object"' }.

    IF NOT DYNAMIC-FUNCTION("classIsA":U IN gshRepositoryManager,
                            INPUT pcTargetClass, INPUT gsc_object_type.object_type_code ) THEN
        RETURN ERROR {aferrortxt.i 'RY' '13' '?' '?' '"pcTargetClass"' '"gsc_object_type.object_type_code"'}.
    ELSE
        FIND FIRST gsc_object_type WHERE
                   gsc_object_type.object_type_code = pcTargetClass
                   NO-LOCK NO-ERROR.

    /** Create the new object, if it doesn't exist. We may be recopying values.
     *  ----------------------------------------------------------------------- */
    IF pdSmartObjectObj EQ 0 THEN
    DO:
        CREATE rycso NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.

        BUFFER-COPY ryc_smartObject 
            EXCEPT
                ryc_smartObject.smartObject_obj ryc_smartObject.object_filename ryc_smartObject.object_extension
                ryc_smartObject.customization_result_obj ryc_smartObject.object_type_obj ryc_smartObject.product_module_obj
                ryc_smartObject.object_path
            TO rycso
                ASSIGN rycso.object_filename          = pcTargetObjectName
                       rycso.customization_result_obj = 0
                       rycso.product_module_obj       = dProductModuleObj
                       rycso.object_path              = cObjectPath
                       rycso.object_type_obj          = gsc_object_type.object_type_obj              
                       NO-ERROR.
        VALIDATE rycso NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    END.
    ELSE
        FIND FIRST rycso WHERE
                   rycso.smartObject_obj = pdSmartObjectObj
                   NO-LOCK NO-ERROR.

    /* The new _OBJ must be returned. */
    ASSIGN pdSmartObjectObj = rycso.smartObject_obj.
    
    /** Create Attributes, Links, Pages, Uievents 
     *  ----------------------------------------------------------------------- **/
    EMPTY TEMP-TABLE ttStoreAttribute.

    FOR EACH ryc_attribute_value WHERE
             ryc_attribute_value.object_type_obj     = ryc_smartObject.object_type_obj AND
             ryc_attribute_value.smartObject_obj     = ryc_smartObject.smartObject_obj AND
             ryc_attribute_value.object_instance_obj = 0
             NO-LOCK,
       FIRST ryc_attribute WHERE
             ryc_attribute.attribute_label = ryc_attribute_value.attribute_label
             NO-LOCK:
        CREATE ttStoreAttribute.
        ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
               ttStoreAttribute.tAttributeParentObj = pdSmartObjectObj
               ttStoreAttribute.tAttributeLabel     = ryc_attribute_value.attribute_label
               ttStoreAttribute.tConstantValue      = ryc_attribute_value.constant_value.

        CASE ryc_attribute.data_type:      
          WHEN {&CHARACTER-DATA-TYPE} THEN ASSIGN ttStoreAttribute.tCharacterValue = ryc_attribute_value.character_value.
          WHEN {&LOGICAL-DATA-TYPE}   THEN ASSIGN ttStoreAttribute.tLogicalValue   = ryc_attribute_value.logical_value.
          WHEN {&INTEGER-DATA-TYPE}   THEN ASSIGN ttStoreAttribute.tIntegerValue   = ryc_attribute_value.integer_value.
          WHEN {&DECIMAL-DATA-TYPE}   THEN ASSIGN ttStoreAttribute.tDecimalValue   = ryc_attribute_value.decimal_value.
          WHEN {&RAW-DATA-TYPE}       THEN ASSIGN ttStoreAttribute.tRawValue       = ryc_attribute_value.raw_value.
          WHEN {&DATE-DATA-TYPE}      THEN ASSIGN ttStoreAttribute.tDateValue      = ryc_attribute_value.date_value.
          WHEN {&RECID-DATA-TYPE}     THEN ASSIGN ttStoreAttribute.tIntegerValue   = ryc_attribute_value.integer_value.
          OTHERWISE                        ASSIGN ttStoreAttribute.tCharacterValue = ryc_attribute_value.character_value.
        END CASE.   /* DataType */
    END.    /* each attribute value. */

    ASSIGN hStoreBuffer = BUFFER ttStoreAttribute:HANDLE
           hStoreTable  = ?.
    
    RUN storeAttributeValues IN gshRepositoryManager ( INPUT hStoreBuffer, INPUT TABLE-HANDLE hStoreTable) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.

    EMPTY TEMP-TABLE ttStoreUiEvent.

    FOR EACH ryc_ui_event WHERE
             ryc_ui_event.object_type_obj     = ryc_smartObject.object_type_obj AND
             ryc_ui_event.smartObject_obj     = ryc_smartObject.smartObject_obj AND
             ryc_ui_event.object_instance_obj = 0
             NO-LOCK:
        CREATE ttStoreUiEvent.
        ASSIGN ttStoreUiEvent.tEventParent    = "MASTER":U
               ttStoreUiEvent.tEventParentObj = pdSmartObjectObj
               ttStoreUiEvent.tEventName      = ryc_ui_event.event_name
               ttStoreUiEvent.tActionType     = ryc_ui_event.action_type
               ttStoreUiEvent.tActionTarget   = ryc_ui_event.action_target
               ttStoreUiEvent.tEventAction    = ryc_ui_event.event_action
               ttStoreUiEvent.tEventParameter = ryc_ui_event.event_parameter
               ttStoreUiEvent.tEventDisabled  = ryc_ui_event.event_disabled
               ttStoreUiEvent.tConstantValue  = ryc_ui_event.constant_value.
    END.    /* each UI event. */

    ASSIGN hStoreBuffer = BUFFER ttStoreUiEvent:HANDLE
           hStoreTable  = ?.   
    RUN insertUiEvents IN hDesignManager ( INPUT hStoreBuffer, INPUT TABLE-HANDLE hStoreTable) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.

    FOR EACH ryc_page WHERE
             ryc_page.container_smartObject_obj = dSourceSmartObjectObj
             NO-LOCK:
        FIND FIRST ryc_layout WHERE
                   ryc_layout.layout_obj = ryc_page.layout_obj
                   NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ryc_layout THEN
            FIND FIRST ryc_layout WHERE
                       ryc_layout.layout_name = "RELATIVE":U
                       NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ryc_layout THEN
            RETURN ERROR {aferrortxt.i 'AF' '5' 'ryc_layout' 'layout_name' '"layout"' '"Layout name = RELATIVE"' }.

        /* Create the page record. */
        ASSIGN cEnableOn = (IF ryc_page.enable_on_create THEN "CREATE,":U ELSE "":U)
                         + (IF ryc_page.enable_on_view THEN "VIEW,":U ELSE "":U)
                         + (IF ryc_page.enable_on_modify THEN "MODIFY,":U ELSE "":U)
               cEnableOn = TRIM(cEnableOn, ",":U).

        /* Add the page. */
        RUN insertObjectPage IN hDesignManager ( INPUT  pcTargetObjectName,
                                                 INPUT  pcSourceResultCode,
                                                 INPUT  ryc_page.page_label,
                                                 INPUT  ryc_page.security_token,
                                                 INPUT  ryc_page.page_reference,
                                                 INPUT  ryc_page.page_sequence,
                                                 INPUT  ryc_layout.layout_code,
                                                 INPUT  cEnableOn,
                                                 OUTPUT dPageObj            ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    END. /* each page */

    /* Object instances */
    FOR EACH ryc_object_instance WHERE
             ryc_object_instance.container_smartObject_obj = dSourceSmartObjectObj
             NO-LOCK,
       FIRST ryc_smartObject WHERE
             ryc_smartObject.smartObject_obj = ryc_object_instance.smartObject_obj
             NO-LOCK:

        EMPTY TEMP-TABLE ttStoreAttribute.
        EMPTY TEMP-TABLE ttStoreUiEvent.

        FOR EACH ryc_attribute_value WHERE
                 ryc_attribute_value.object_type_obj     = ryc_smartObject.object_type_obj AND
                 ryc_attribute_value.smartObject_obj     = ryc_smartObject.smartObject_obj AND
                 ryc_attribute_value.object_instance_obj = ryc_object_instance.object_instance_obj
                 NO-LOCK,
           FIRST ryc_attribute WHERE
                 ryc_attribute.attribute_label = ryc_attribute_value.attribute_label
                 NO-LOCK:
            CREATE ttStoreAttribute.
            ASSIGN ttStoreAttribute.tAttributeParent    = "INSTANCE":U
                   ttStoreAttribute.tAttributeParentObj = 0
                   ttStoreAttribute.tAttributeLabel     = ryc_attribute_value.attribute_label
                   ttStoreAttribute.tConstantValue      = ryc_attribute_value.constant_value.

            CASE ryc_attribute.data_type:      
              WHEN {&CHARACTER-DATA-TYPE} THEN ASSIGN ttStoreAttribute.tCharacterValue = ryc_attribute_value.character_value.
              WHEN {&LOGICAL-DATA-TYPE}   THEN ASSIGN ttStoreAttribute.tLogicalValue   = ryc_attribute_value.logical_value.
              WHEN {&INTEGER-DATA-TYPE}   THEN ASSIGN ttStoreAttribute.tIntegerValue   = ryc_attribute_value.integer_value.
              WHEN {&DECIMAL-DATA-TYPE}   THEN ASSIGN ttStoreAttribute.tDecimalValue   = ryc_attribute_value.decimal_value.
              WHEN {&RAW-DATA-TYPE}       THEN ASSIGN ttStoreAttribute.tRawValue       = ryc_attribute_value.raw_value.
              WHEN {&DATE-DATA-TYPE}      THEN ASSIGN ttStoreAttribute.tDateValue      = ryc_attribute_value.date_value.
              WHEN {&RECID-DATA-TYPE}     THEN ASSIGN ttStoreAttribute.tIntegerValue   = ryc_attribute_value.integer_value.
              OTHERWISE                        ASSIGN ttStoreAttribute.tCharacterValue = ryc_attribute_value.character_value.
            END CASE.   /* DataType */
        END.    /* each attribute value. */

        ASSIGN hStoreBuffer = BUFFER ttStoreAttribute:HANDLE
               hStoreTable  = ?.

        RUN insertObjectInstance IN hDesignManager ( INPUT  pdSmartObjectObj,
                                                     INPUT  ryc_smartObject.object_filename,
                                                     INPUT  pcSourceResultCode,
                                                     INPUT  ryc_object_instance.instance_name,
                                                     INPUT  ryc_object_instance.instance_description,
                                                     INPUT  ryc_object_instance.layout_position,
                                                     INPUT  ryc_object_instance.page_obj,
                                                     INPUT  ryc_object_instance.object_sequence,
                                                     INPUT  NO,                  /* plForceCreateNew */
                                                     INPUT  hStoreBuffer,
                                                     INPUT  TABLE-HANDLE hStoreTable,
                                                     OUTPUT dInstanceSmartObjectObj,
                                                     OUTPUT dObjectInstanceObj                ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.

        /* We must store the relationship between the old and new object instances, so
         * that we can set up the links correctly.                                    */
        CREATE ttXref.
        ASSIGN ttXref.tElementType = "RYCOI":U
               ttXref.tSourceData  = STRING(ryc_object_instance.object_instance_obj)
               ttXref.tTargetData  = STRING(dObjectInstanceObj).

        /* Copy the UI events. */
        FOR EACH ryc_ui_event WHERE
                 ryc_ui_event.object_type_obj     = ryc_smartObject.object_type_obj AND
                 ryc_ui_event.smartObject_obj     = ryc_smartObject.smartObject_obj AND
                 ryc_ui_event.object_instance_obj = dObjectInstanceObj
                 NO-LOCK:
            CREATE ttStoreUiEvent.
            ASSIGN ttStoreUiEvent.tEventParent    = "INSTANCE":U
                   ttStoreUiEvent.tEventParentObj = dObjectInstanceObj
                   ttStoreUiEvent.tEventName      = ryc_ui_event.event_name
                   ttStoreUiEvent.tActionType     = ryc_ui_event.action_type
                   ttStoreUiEvent.tActionTarget   = ryc_ui_event.action_target
                   ttStoreUiEvent.tEventAction    = ryc_ui_event.event_action
                   ttStoreUiEvent.tEventParameter = ryc_ui_event.event_parameter
                   ttStoreUiEvent.tEventDisabled  = ryc_ui_event.event_disabled
                   ttStoreUiEvent.tConstantValue  = ryc_ui_event.constant_value.
        END.    /* each UI event. */

        ASSIGN hStoreBuffer = BUFFER ttStoreUiEvent:HANDLE
               hStoreTable  = ?.   
        RUN insertUiEvents IN hDesignManager ( INPUT hStoreBuffer, INPUT TABLE-HANDLE hStoreTable) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.

    END.    /* each object instance on the page */       

    /*  Only update the links once all object instances have been added. */
    FOR EACH ryc_smartlink WHERE
             ryc_smartlink.container_smartObject_obj = dSourceSmartObjectObj
             NO-LOCK:

        FIND FIRST ttXref WHERE
                   ttXref.tElementType = "RYCOI":U                              AND
                   ttXref.tSourceData  = STRING(ryc_smartLink.source_object_instance_obj)
                   NO-ERROR.

        CREATE ttSmartLink.
        ASSIGN ttSmartLink.tContainerObj = pdSmartObjectObj
               ttSmartLink.tLinkName     = ryc_smartlink.link_name
               ttSmartLink.tUserLinkName = ryc_smartlink.link_name
               ttSmartLink.tSourceObj    = DECIMAL(ttXref.tTargetData)           WHEN AVAILABLE ttXref.

        FIND FIRST ttXref WHERE
                   ttXref.tElementType = "RYCOI":U                                  AND
                   ttXref.tSourceData  = STRING(ryc_smartLink.target_object_instance_obj)
                   NO-ERROR.
        ASSIGN ttSmartLink.tTargetObj = DECIMAL(ttXref.tTargetData)           WHEN AVAILABLE ttXref.
    END.   /* each link */

    ASSIGN hStoreBuffer = BUFFER ttSmartLink:HANDLE
           hStoreTable = ?.
    RUN insertObjectLinks IN hDesignManager ( INPUT pdSmartObjectObj,
                                                INPUT hStoreBuffer,
                                                INPUT TABLE-HANDLE hStoreTable         ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.

    /** If the result code is not the default result code, then we create a record
     *  for the default result code AND one for the specified result code.
     *  At this stage the records have been created for the result code and now we 
     *  must create the records for the DEFAULT-RESULT-CODE.     
     *  ----------------------------------------------------------------------- **/
    IF pcSourceResultCode NE "{&DEFAULT-RESULT-CODE}":U THEN
    DO:
        RUN copyObjectMaster IN hDesignManager ( INPUT  pcSourceObjectName,
                                                   INPUT  "{&DEFAULT-RESULT-CODE}":U,
                                                   INPUT  pcTargetObjectName,
                                                   INPUT  pcTargetClass,
                                                   INPUT  pcTargetProductModule,
                                                   INPUT  pcTargetRelativePath,
                                                   OUTPUT pdSmartObjectObj        ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    END.    /* create aggregated */
    /* - EOF- */
