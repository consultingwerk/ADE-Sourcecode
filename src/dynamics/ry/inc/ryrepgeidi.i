/* Copyright © 1984 -2006 by Progress Software Corporation.  All rights 
   reserved.  Prior versions of this work may contain portions 
   contributed by participants of Possenet.  */   
/*---------------------------------------------------------------------------------
  FILE: ryrepgeidi.i
  
  DESCRIPTION:  Include file for getInstanceData() API in Dynamics Repository Manager.

  Purpose:      

  Parameters:   
    DEFINE INPUT PARAMETER pcContainerName              AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pdContainerInstanceId        AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pcInstanceName               AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pdObjectInstanceObj          AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pcLogicalObjectName          AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pdSmartObjectObj             AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pdClassObj                   AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pcLayoutPosition             AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER piPageNumber                 AS INTEGER              NO-UNDO.
    DEFINE INPUT PARAMETER piObjectSequence             AS INTEGER              NO-UNDO.
    DEFINE INPUT PARAMETER pdRenderTypeObj              AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pdLanguageObj                AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER plApplyTranslations          AS LOGICAL              NO-UNDO.
    DEFINE INPUT PARAMETER plStaticObject               AS LOGICAL              NO-UNDO.
    DEFINE INPUT PARAMETER pcSecuredFields              AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcSecuredTokens              AS CHARACTER            NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER pcClassesReferenced   AS CHARACTER            NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER pcEntitiesReferenced  AS CHARACTER            NO-UNDO.    
    DEFINE INPUT-OUTPUT PARAMETER pcToolbarsReferenced  AS CHARACTER            NO-UNDO.

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                DATE:   07/24/2003  Author:    pjudge 

  UPDATE Notes: INITIAL Implementation


---------------------------------------------------------------------------------*/    
    DEFINE VARIABLE hClassBuffer                AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE hBufferField                AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE cAttributeValue             AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cLabels                     AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cTooltips                   AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cEntry                      AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cWidgetType                 AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cWidgetName                 AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cLabelAttributeName         AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cTooltipAttributeName       AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cBrowserLabels              AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cPathedObjectName           AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cPageList                   AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cInstanceName               AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cContainerName              AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cObjectName                 AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cSecuredFields              AS CHARACTER                    NO-UNDO.    
    /* This is a scratch/general variable for storing attribute value strings,
       particularly when a comparison is needed with the primary attribute value
       set, as usually stored in the cAttributeValue variable.
     */
    DEFINE VARIABLE cAlternateAttributeValue    AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE iInstanceLoop               AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE iSkipBy                     AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE iWidgetEntries              AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE iAttributeEntry             AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE iLabelEntry                 AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE iDelimiterEntry             AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE iResultCodeLoop             AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE iNumberOfResultCodes        AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE dResultCodeObj              AS DECIMAL                      NO-UNDO.
    
    DEFINE BUFFER cacheObject      FOR cacheObject.
    DEFINE BUFFER containerObject  FOR cacheObject.
    DEFINE BUFFER cachePage        FOR cachePage.
    DEFINE BUFFER rycso_static     FOR ryc_smartobject.
    DEFINE BUFFER rycso            FOR ryc_smartobject.
    define buffer gscot            for gsc_object_type.
    define buffer gstrv            for gst_record_version.
    define buffer rycav            for ryc_attribute_value.
    define buffer rycue            for ryc_ui_event.
    define buffer rycoi            for ryc_object_instance.
    define buffer ryccr            for ryc_customization_result.
    define buffer rycla            for ryc_layout.
    DEFINE BUFFER ttClass          FOR ttClass.

    /* Find the object instance record.
     */
    find first rycoi where
               rycoi.object_instance_obj = pdObjectInstanceObj
               no-lock no-error.
    
    /* If the object instance record cannot be found, then
       return without giving an error.
       
       This is a temporary measure needed because pre-2.1 
       Repositories may have bad data in them. This data 
       did not cause problems in the pre-2.1 code, but this
       code is less fault-tolerant; we need to make sure that it is.
     */
    if not available rycoi then
        return.
    
    /** Get the class information for this object instance. **/
    FIND first ttClass where ttClass.ClassObj = pdClassObj no-error.
    if not available ttClass then
    do:
        find first gscot where
                   gscot.object_type_obj = pdClassObj
                   no-lock no-error.                                      
        IF NOT AVAILABLE gscot THEN
            RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' '"class"'}.
             
        RUN createClassCache IN TARGET-PROCEDURE ( input gscot.object_type_code ) NO-ERROR.
        find first ttClass where ttClass.ClassObj = pdClassObj no-error.
        if not available ttClass THEN
            RETURN ERROR {aferrortxt.i 'AF' '1' '?' '?' '"cached class"'}.
    END.    /* local class record not found */
    
    IF NOT CAN-DO(pcClassesReferenced, ttClass.ClassName) THEN
        ASSIGN pcClassesReferenced = pcClassesReferenced + ",":U + ttClass.ClassName.
    
    /* Find the relevant object instance record. 
     * We need to update the Attr* and Event* fields so find this
     * record rather than use CAN-FIND().
     */
    FIND cacheObject WHERE
         cacheObject.ContainerInstanceId = pdContainerInstanceId AND
         cacheObject.ObjectName          = pcInstanceName         
         NO-ERROR.
    IF NOT AVAILABLE cacheObject then
    DO:
        CREATE cacheObject.
        ASSIGN gsdTempUniqueId                 = gsdTempUniqueId + 1
               cacheObject.InstanceId          = gsdTempUniqueId
               cacheObject.ContainerInstanceId = pdContainerInstanceId
               cacheObject.ObjectName          = pcInstanceName
               cacheObject.PageNumber          = piPageNumber
               cacheObject.Order               = piObjectSequence
               cacheObject.ClassName           = ttClass.ClassName.
               
        /* Update the LogicalObjectName attribute. This attribute matches the object_filename
         * of this object. We only need to do this once per object.
         */
        ASSIGN hBufferField = ?
               hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("LogicalObjectName":U) NO-ERROR.
        IF VALID-HANDLE(hBufferField) then
            ASSIGN cacheObject.AttrOrdinals = cacheObject.AttrOrdinals + ",":U + STRING(hBufferField:POSITION - 1)
                   cacheObject.AttrValues   = cacheObject.AttrValues + {&Value-Delimiter} + pcLogicalObjectName.
        
        /* If we're dealing with a toolbar, add it to the toolbar list */
        IF CAN-DO(ttClass.InheritsFromClasses, "smartToolbar":U) AND
           LOOKUP(pcLogicalObjectName, pcToolbarsReferenced) = 0 THEN
            ASSIGN pcToolbarsReferenced = pcToolbarsReferenced 
                                        + (IF pcToolbarsReferenced = "":U THEN "":U ELSE ",":U)
                                        + pcLogicalObjectName.

        /* Get the name of the Entity referenced here and add it to the list.
         */
        IF CAN-DO(ttClass.InheritsFromClasses, "DataField":U)                     AND
           NOT CAN-DO(ttClass.InheritsFromClasses, "CalculatedField":U)           AND
           NOT CAN-DO(pcEntitiesReferenced, ENTRY(1, pcLogicalObjectName, ".":U)) THEN
            ASSIGN pcEntitiesReferenced = pcEntitiesReferenced + ",":U + ENTRY(1, pcLogicalObjectName, ".":U).
        
        /* LogicalVersion.
         */
        ASSIGN hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("LogicalVersion":U) NO-ERROR.
        IF VALID-HANDLE(hBufferField) THEN
        DO:
            FIND gstrv WHERE
                 gstrv.entity_mnemonic = "RYCSO":U AND
                 gstrv.key_field_value = STRING(pdSmartObjectObj)
                 NO-LOCK NO-ERROR.
            IF AVAILABLE gstrv THEN
                ASSIGN cacheObject.AttrOrdinals = cacheObject.AttrOrdinals + ",":U + STRING(hBufferField:POSITION - 1)
                       cacheObject.AttrValues   = cacheObject.AttrValues + {&Value-Delimiter}
                                                + STRING(gstrv.version_number_seq).
        END.    /* LogicalVersion */
        
        /* We need to set the Name and ObjectName attributes to the InstanceName. This is becase we reference
         * these attributes in the code, since the cacheObject table is not exposed in the ADM.
         */
        ASSIGN hBufferField = ?
               hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("Name":U) NO-ERROR.
        IF VALID-HANDLE(hBufferField) THEN
            ASSIGN cacheObject.AttrOrdinals = cacheObject.AttrOrdinals + ",":U + STRING(hBufferField:POSITION - 1)
                   cacheObject.AttrValues   = cacheObject.AttrValues + {&Value-Delimiter} + pcInstanceName.

        ASSIGN hBufferField = ?
               hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("ObjectName":U)
               NO-ERROR.
        IF VALID-HANDLE(hBufferField) THEN
            ASSIGN cacheObject.AttrOrdinals = cacheObject.AttrOrdinals + ",":U + STRING(hBufferField:POSITION - 1)
                   cacheObject.AttrValues   = cacheObject.AttrValues + {&Value-Delimiter} + pcInstanceName.
        
        /* Assign the LayoutPosition attribute. */
        ASSIGN hBufferField = ?
               hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("LayoutPosition":U) 
               NO-ERROR.
        IF VALID-HANDLE(hBufferField) THEN
            ASSIGN cacheObject.AttrOrdinals = cacheObject.AttrOrdinals + ",":U + STRING(hBufferField:POSITION - 1)
                   cacheObject.AttrValues   = cacheObject.AttrValues + {&Value-Delimiter} + pcLayoutPosition.
                   
        /* RenderingProcedure
         * For static objects, get the value from the object itself. FOR dynamic
         * objects, the RenderingProcedure IS stored AS an attribute AND IS dealt WITH as
         * ANY other attribute would be.
         */
        IF plStaticObject THEN
        DO:
            ASSIGN hBufferField = ?
                   hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("RenderingProcedure":U)
                   NO-ERROR.
            IF NOT VALID-HANDLE(hBufferField) THEN
                ASSIGN hBufferField = ?
                       hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("PhysicalObjectName":U)
                       NO-ERROR.
            
            IF VALID-HANDLE(hBufferField) then
            DO:
                ASSIGN cPathedObjectName = DYNAMIC-FUNCTION("getObjectPathedName":U IN gshRepositoryManager,
                                                            INPUT pdSmartObjectObj).
                ASSIGN cacheObject.AttrOrdinals = cacheObject.AttrOrdinals + ",":U + STRING(hBufferField:POSITION - 1)
                       cacheObject.AttrValues   = cacheObject.AttrValues + {&Value-Delimiter} + cPathedObjectName.
            END.    /* valid RenderingProcedure attribute. */
        END.    /* static object */
        
        /* Set the ObjectSecured flag. This flag indicates that the check for 
           security has been performed, rather than the fact that security was
           found. We know that we are going to check for security for dynamic objects
           and so can set this flag to true. Static objects will have their security 
           performed client-side by the widgetWalk procedure, but only those static
           objects that are ADM smartobjects (these inherit from the Base class), since
           these are the only objects that are passed through the widget walk. 
         */
        ASSIGN hBufferField = ?
               hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("ObjectSecured":U)
               NO-ERROR.
        IF VALID-HANDLE(hBufferField) THEN
            ASSIGN cacheObject.AttrOrdinals = cacheObject.AttrOrdinals + ",":U + STRING(hBufferField:POSITION - 1)
                   cacheObject.AttrValues   = cacheObject.AttrValues + {&Value-Delimiter}
                                            + STRING(NOT plStaticObject AND CAN-DO(ttClass.InheritsFromClasses, "Base":U)).
        
        /* Set the ObjectTranslated flag. This flag indicates that the check for 
           translations has been performed, rather than the fact that translations were
           found. We know that we are going to check for translations for dynamic objects
           and so can set this flag to true. Static objects will have their translations
           performed client-side by the widgetWalk procedure, but only those static
           objects that are ADM smartobjects (these inherit from the Base class).
           
           This attribute value differs from the ObjectTranslated field on the cacheObject
           temp-table. This field indicates whether the translations have a actually been performed.
         */
        ASSIGN hBufferField = ?
               hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("ObjectTranslated":U)
               NO-ERROR.
        IF VALID-HANDLE(hBufferField) THEN
            ASSIGN cacheObject.AttrOrdinals = cacheObject.AttrOrdinals + ",":U + STRING(hBufferField:POSITION - 1)            
                   cacheObject.AttrValues   = cacheObject.AttrValues + {&Value-Delimiter}
                                            + STRING(NOT plStaticObject AND CAN-DO(ttClass.InheritsFromClasses, "Base":U)).
        
        /* Get FIELD security */
        IF pcSecuredFields NE "":U THEN
        DO:
            ASSIGN iAttributeEntry = LOOKUP(cacheObject.ObjectName, pcSecuredFields).
            IF iAttributeEntry GT 0 THEN
            DO:
                ASSIGN hBufferField = ?
                       hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("FieldSecurity":U) NO-ERROR.
                IF VALID-HANDLE(hBufferField) THEN
                    ASSIGN cacheObject.AttrOrdinals = cacheObject.AttrOrdinals + ",":U + STRING(hBufferField:POSITION - 1)
                           cacheObject.AttrValues   = cacheObject.AttrValues + {&Value-Delimiter} 
                                                    + ENTRY(iAttributeEntry, pcSecuredFields) + ",":U
                                                    + ENTRY(iAttributeEntry + 1, pcSecuredFields).
            END.    /* this object has field secured. */
        END.    /* apply security */
        
        /* Get TOKEN security */
        IF CAN-DO(ttClass.InheritsFrom, "smartToolbar":U)
        THEN DO:
            ASSIGN hBufferField = ?
                   hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("SecuredTokens":U) NO-ERROR.
            IF VALID-HANDLE(hBufferField) THEN
                ASSIGN cacheObject.AttrOrdinals = cacheObject.AttrOrdinals + ",":U + STRING(hBufferField:POSITION - 1)
                       cacheObject.AttrValues   = cacheObject.AttrValues + {&Value-Delimiter} + pcSecuredTokens.
        END.
        ELSE
            IF pcSecuredTokens NE "":U THEN
                IF CAN-DO(pcSecuredTokens, cacheObject.ObjectName) THEN
                DO:
                    ASSIGN hBufferField = ?
                           hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("SecuredTokens":U) NO-ERROR.
                    IF VALID-HANDLE(hBufferField) THEN
                        ASSIGN cacheObject.AttrOrdinals = cacheObject.AttrOrdinals + ",":U + STRING(hBufferField:POSITION - 1)
                               cacheObject.AttrValues   = cacheObject.AttrValues + {&Value-Delimiter} + cacheObject.ObjectName.
                END.    /* this object has token security */    
    END.    /* n/a cacheObject */
    
    /* Translate the label and tooltip for SDFs.
     * We can DO this before retrieving attributes because there are NO dependencies on
     * ANY OF the attribute VALUES. IN the CASE OF fill-ins (FOR example) we need TO know 
     * the VALUE OF the VisualizationType attribute TO be determine the WIDGET TYPE.
     */
    IF plApplyTranslations AND cacheObject.ObjectTranslated EQ ? then
    DO:
        ASSIGN cWidgetName   = "":U
               cLabels       = "":U
               cTooltips     = "":U.

        /* SDFs */
        IF CAN-DO(ttClass.InheritsFrom, "DynLookup":U) then
            ASSIGN cWidgetType = "FILL-IN":U
                   cWidgetName = "fiLookup":U
                   cacheObject.ObjectTranslated = NO.
        ELSE
        IF CAN-DO(ttClass.InheritsFrom, "DynCombo":U) then
            ASSIGN cWidgetType = "COMBO-BOX":U
                   cWidgetName = "fiCombo":U
                   cacheObject.ObjectTranslated = NO.
        
        IF cWidgetName NE "":U THEN
        DO:
            RUN translateSingleObject IN gshTranslationManager ( INPUT  pdLanguageObj,
                                                                 INPUT  pcContainerName + ":":U + cacheObject.ObjectName,
                                                                 INPUT  cWidgetName,
                                                                 INPUT  cWidgetType,
                                                                 INPUT  0,          /* piWidgetEntries */
                                                                 OUTPUT cLabels,
                                                                 OUTPUT cTooltips               ) NO-ERROR.                                                                 
            IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
                RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
            
            /* The label has been translated. */
            IF cLabels NE "":U THEN
            DO:
                /* Indicate that there really are translations. */
                ASSIGN cacheObject.ObjectTranslated = YES
                       
                       hBufferField = ?
                       hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("FieldLabel":U)
                       NO-ERROR.
                IF VALID-HANDLE(hBufferField) THEN
                    /* We are applying the translations before the attribute values are retrieved. */
                    ASSIGN cacheObject.AttrOrdinals = cacheObject.AttrOrdinals + ",":U + STRING(hBufferField:POSITION - 1)
                           cacheObject.AttrValues   = cacheObject.AttrValues + {&Value-Delimiter} + cLabels.
            END.    /* there are translated labels */
    
            /* The tooltip has been translated. */
            IF cTooltips NE "":U THEN
            DO:
                /* Indicate that there really are translations. */
                ASSIGN cacheObject.ObjectTranslated = YES
                       
                       hBufferField = ?
                       hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("FieldTooltip":U) NO-ERROR.
                IF VALID-HANDLE(hBufferField) then
                    /* We are applying the translations before the attribute values are retrieved. */
                    ASSIGN cacheObject.AttrOrdinals = cacheObject.AttrOrdinals + ",":U + STRING(hBufferField:POSITION - 1)
                           cacheObject.AttrValues   = cacheObject.AttrValues + {&Value-Delimiter} + cTooltips.
            END.    /* there are translated tooltips */
        END.    /* we want to do the translation. */        
    END.    /* we should do the translation. */
    
    /** Get the attributes and UI events for this instance, in the following order:
     *  (1) GET the instance attributes FOR the client render TYPE.
     *  (2) GET the Instance attributes FOR the DEFAULT render TYPE (0).
     *  (3) GET the Master attributes FOR the client render TYPE.
     *  (4) GET the Master attributes FOR the DEFAULT render TYPE (0).
     *  ----------------------------------------------------------------------- **/
    /* Attributes (1) */
    IF pdRenderTypeObj NE 0 then
    FOR EACH rycav where
             rycav.smartObject_obj     = pdSmartObjectObj    and
             rycav.object_instance_obj = pdObjectInstanceObj and
             rycav.render_type_obj     = pdRenderTypeObj     and
             rycav.container_smartobject_obj = rycoi.container_smartobject_obj and             
             rycav.applies_at_runtime  = yes
             NO-LOCK:
        {ry/inc/getobjectattributes.i
            &AttributeTable = rycav
            &CacheTable     = cacheObject
            &ClassBuffer    = ttClass.ClassBufferHandle
            &InstanceID     = cacheObject.InstanceId }
    END.    /* each attribute that can be retrieved for this master/ default render type. */    

    /* Attributes (2) */
    FOR EACH rycav where
             rycav.smartObject_obj     = pdSmartObjectObj    and
             rycav.object_instance_obj = pdObjectInstanceObj and
             rycav.render_type_obj     = 0                   and
             rycav.container_smartobject_obj = rycoi.container_smartobject_obj and
             rycav.applies_at_runtime  = yes
             NO-LOCK:
        {ry/inc/getobjectattributes.i
            &AttributeTable = rycav
            &CacheTable     = cacheObject
            &ClassBuffer    = ttClass.ClassBufferHandle
            &InstanceID     = cacheObject.InstanceId }
    END.    /* each attribute that can be retrieved for this master/ render type. */

    /* Attributes (3) */
    IF pdRenderTypeObj NE 0 then
    FOR EACH rycav where
             rycav.smartObject_obj     = pdSmartObjectObj and
             rycav.object_instance_obj = 0                and
             rycav.render_type_obj     = pdRenderTypeObj  and
             rycav.container_smartobject_obj = 0                and
             rycav.applies_at_runtime  = yes
             NO-LOCK:
        {ry/inc/getobjectattributes.i
            &AttributeTable = rycav
            &CacheTable     = cacheObject
            &ClassBuffer    = ttClass.ClassBufferHandle
            &InstanceID     = cacheObject.InstanceId }
    END.    /* each attribute that can be retrieved for this master/ default render type. */    

    /* Attributes (4) */
    FOR EACH rycav where
             rycav.smartObject_obj     = pdSmartObjectObj and
             rycav.object_instance_obj = 0                and
             rycav.render_type_obj     = 0                and
             rycav.container_smartobject_obj = 0                and
             rycav.applies_at_runtime  = yes
             NO-LOCK:
        {ry/inc/getobjectattributes.i
            &AttributeTable = rycav
            &CacheTable     = cacheObject
            &ClassBuffer    = ttClass.ClassBufferHandle
            &InstanceID     = cacheObject.InstanceId }
    END.    /* each attribute that can be retrieved for this master/ render type. */        

    /* Events (1) */
    IF pdRenderTypeObj NE 0 then
    FOR EACH rycue WHERE
             rycue.smartObject_obj     = pdSmartObjectObj    AND
             rycue.object_instance_obj = pdObjectInstanceObj AND
             rycue.render_type_obj     = pdRenderTypeObj     and
             rycue.event_disabled      = NO                  and
             rycue.container_smartobject_obj = rycoi.container_smartobject_obj and
             rycue.event_action       <> "":U
             NO-LOCK:
        {ry/inc/getobjectevents.i
            &EventTable = rycue
            &CacheTable     = cacheObject }
    END.    /* UI events */

    /* Events (2) */
    FOR EACH rycue WHERE
             rycue.smartObject_obj     = pdSmartObjectObj    AND
             rycue.object_instance_obj = pdObjectInstanceObj AND
             rycue.render_type_obj     = 0                   and
             rycue.event_disabled      = NO                  and
             rycue.container_smartobject_obj = rycoi.container_smartobject_obj and
             rycue.event_action       <> "":U
             NO-LOCK:
        {ry/inc/getobjectevents.i
            &EventTable = rycue
            &CacheTable = cacheObject }
    END.    /* UI events */

    /* Events (3) */
    IF pdRenderTypeObj NE 0 then
    FOR EACH rycue WHERE
             rycue.smartObject_obj     = pdSmartObjectObj AND
             rycue.object_instance_obj = 0                AND
             rycue.render_type_obj     = pdRenderTypeObj  and
             rycue.event_disabled      = NO               and
             rycue.container_smartobject_obj = 0                   and
             rycue.event_action       <> "":U
             NO-LOCK:
        {ry/inc/getobjectevents.i
            &EventTable = rycue
            &CacheTable = cacheObject }
    END.    /* UI events */
    
    /* Events (4) */
    FOR EACH rycue WHERE
             rycue.smartObject_obj     = pdSmartObjectObj AND
             rycue.object_instance_obj = 0                AND
             rycue.render_type_obj     = 0                and
             rycue.event_disabled      = NO               and
             rycue.container_smartobject_obj = 0                and
             rycue.event_action       <> "":U
             NO-LOCK:
        {ry/inc/getobjectevents.i
            &EventTable = rycue
            &CacheTable = cacheObject }
    END.    /* UI events */

    /* Clean up the attributes and events. */
    ASSIGN cacheObject.AttrOrdinals = LEFT-TRIM(cacheObject.AttrOrdinals, ",":U)
           cacheObject.AttrValues   = LEFT-TRIM(cacheObject.AttrValues, {&Value-delimiter})
           cacheObject.EventNames   = LEFT-TRIM(cacheObject.EventNames, ",":U)
           cacheObject.EventActions = SUBSTRING(cacheObject.EventActions, 2).
    
    /* Perform translations that depend on other attributes being set, such as
     * the VisualizationType which determines the WIDGET TYPE used FOR the 
     * translations.
     */
    IF plApplyTranslations AND cacheObject.ObjectTranslated EQ ? THEN
    DO:
        /* Browser Columns are stored as a CSV in the DisplayedFields attribute.
         * The LABELS are stored IN the BrowseColumnLabels attribute. We need TO 
         * build a STRING OF the translated LABELS, AND place them INTO this 
         * attribute. ANY untranslated LABELS will be taken FROM the runtime SDO.
         * There are NO TOOLTIPS FOR browser COLUMNS.
         */
        IF CAN-DO(ttClass.InheritsFrom, "Browser":U) THEN
        DO:
            /* Only do this if both attributes are available. */
            ASSIGN hBufferField = ?
                   hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("DisplayedFields":U) NO-ERROR.
            IF VALID-HANDLE(hBufferField) THEN
            DO:
                ASSIGN iAttributeEntry = LOOKUP(STRING(hBufferField:POSITION - 1), cacheObject.AttrOrdinals)                       
                       hBufferField    = ?
                       hBufferField    = ttClass.ClassBufferHandle:BUFFER-FIELD("BrowseColumnLabels":U)
                       NO-ERROR.
                IF VALID-HANDLE(hBufferField) THEN
                DO:
                    ASSIGN cacheObject.ObjectTranslated = NO.
                    
                    IF iAttributeEntry GT 0 THEN
                    DO:
                        ASSIGN cAttributeValue = ENTRY(iAttributeEntry, cacheObject.AttrValues, {&Value-Delimiter}).
                        
                        /* This is the determining whether there is actually a BrowseColumnLabels 
                           attribute set.
                         */
                        ASSIGN iAttributeEntry = LOOKUP(STRING(hBufferField:POSITION - 1), cacheObject.AttrOrdinals).
                        IF iAttributeEntry GT 0 THEN
                            ASSIGN cAlternateAttributeValue = ENTRY(iAttributeEntry, cacheObject.AttrValues, {&Value-Delimiter}).
                        ELSE
                            ASSIGN cAlternateAttributeValue = "":U.                                    
                        
                        /* Loop through the columns and translate accordingly. */
                        DO iAttributeEntry = 1 TO NUM-ENTRIES(cAttributeValue):
                            RUN translateSingleObject IN gshTranslationManager ( INPUT  pdLanguageObj,
                                                                                 INPUT  cacheObject.ObjectName,
                                                                                 INPUT  ENTRY(iAttributeEntry, cAttributeValue),
                                                                                 INPUT  "BROWSE":U,
                                                                                 INPUT  0,
                                                                                 OUTPUT cLabels,
                                                                                 OUTPUT cTooltips               ) NO-ERROR.
                            IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
                                RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
                            
                            /* Build the list of label overrides, being careful not to overwrite any
                               developer-specific overrides when there are no translations.                            
                             */
                            IF cLabels EQ "":U THEN
                            DO:
                                IF cAlternateAttributeValue EQ "":U THEN
                                    ASSIGN cLabels = "?":U.
                                ELSE
                                    ASSIGN cLabels = ENTRY(iAttributeEntry,cAlternateAttributeValue, CHR(5)).
                            END.    /* no translation */
                            
                            /* Indicate that there really are translations. */
                            ASSIGN cacheObject.ObjectTranslated = YES
                                   cBrowserLabels               = cBrowserLabels + CHR(5) + cLabels.
                        END.    /* loop through fields */
                        
                        /* Since the iAttributeEntry variable is used for the loop, make sure that we 
                           get the right pointer to the attribute entry in the AttrOrdinals string.
                         */
                        ASSIGN cBrowserLabels  = LEFT-TRIM(cBrowserLabels, CHR(5))
                               iAttributeEntry = LOOKUP(STRING(hBufferField:POSITION - 1), cacheObject.AttrOrdinals).
                        
                        IF iAttributeEntry EQ 0 THEN
                            ASSIGN cacheObject.AttrOrdinals = cacheObject.AttrOrdinals + ",":U + STRING(hBufferField:POSITION - 1)
                                   cacheObject.AttrValues   = cacheObject.AttrValues + {&Value-Delimiter} + cBrowserLabels.
                        ELSE
                            ENTRY(iAttributeEntry, cacheObject.AttrValues, {&Value-Delimiter}) = cBrowserLabels.
                    END.    /* the displayedfields attribute is set. */
                END.    /* there are BrowseColumnLabels */
            END.    /* There are displayed fields */
        END.    /* browsers */
        ELSE
        /* Any non-ADM2 objects. We need to translate any
         * field-level widgets.
         */
        IF NOT CAN-DO(ttClass.InheritsFrom, "Base":U) THEN
        DO:
            /* Typically, only field-level widgets will have a VisualizationType attribute set. */
            ASSIGN hBufferField = ?
                   hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("VisualizationType":U) NO-ERROR.
            
            IF VALID-HANDLE(hBufferField) then
            DO:
                ASSIGN iAttributeEntry = LOOKUP(STRING(hBufferField:POSITION - 1), cacheObject.AttrOrdinals)
                       cLabels         = "":U
                       cTooltips       = "":U
                       cWidgetType     = "":U
                       cWidgetName     = "":U.

                IF iAttributeEntry GT 0 THEN
                    ASSIGN cWidgetType = ENTRY(iAttributeEntry, cacheObject.AttrValues, {&Value-Delimiter}).
                ELSE
                    ASSIGN cWidgetType = ttClass.ClassBufferHandle:BUFFER-FIELD("VisualizationType":U):INITIAL.
                    
                IF cWidgetType NE "":U THEN
                DO:
                    CASE cWidgetType:
                        WHEN "RADIO-SET":U then
                        DO:
                            ASSIGN hBufferField = ?
                                   hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("RADIO-BUTTONS":U) 
                                   NO-ERROR.
                            IF VALID-HANDLE(hBufferField) THEN
                            DO:
                                ASSIGN iAttributeEntry = LOOKUP(STRING(hBufferField:POSITION - 1), cacheObject.AttrOrdinals).
                                
                                /* We only attempt to do the translation if there is actually a value in the
                                   RADIO-BUTTONS attribute, because it is impossible (well, tough) to figure out
                                   what the values (not the labels) should be if they are missing.
                                 */
                                IF iAttributeEntry GT 0 THEN
                                    ASSIGN cWidgetName           = cacheObject.ObjectName
                                           iWidgetEntries        = NUM-ENTRIES(ENTRY(iAttributeEntry, cacheObject.AttrValues, {&Value-delimiter})) / 2
                                           iSkipBy               = 2
                                           cLabelAttributeName   = "RADIO-BUTTONS":U
                                           cTooltipAttributeName = "TOOLTIP":U                                           
                                           cacheObject.ObjectTranslated = NO.
                            END.    /* there is radio-buttons */
                        END.    /* radio set */
                        WHEN "TEXT":U THEN
                        DO:
                            /* FILL-IN VIEW-AS TEXT can be translated */
                            IF CAN-DO(ttClass.InheritsFrom, "DynFillIn":U) 
                            THEN DO:
                                ASSIGN hBufferField = ?
                                       hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("InitialValue":U) 
                                       NO-ERROR.
                                IF VALID-HANDLE(hBufferField) THEN
                                DO:
                                    ASSIGN iAttributeEntry = LOOKUP(STRING(hBufferField:POSITION - 1), cacheObject.AttrOrdinals).
                                    IF iAttributeEntry GT 0 THEN
                                        ASSIGN cWidgetName           = cacheObject.ObjectName
                                               iWidgetEntries        = 0
                                               iSkipBy               = 0
                                               cLabelAttributeName   = "InitialValue":U
                                               cTooltipAttributeName = "TOOLTIP":U
                                               cacheObject.ObjectTranslated = NO.
                                END.
                            END.
                        END.
                        WHEN "COMBO-BOX" THEN
                        DO:
                            /* Always try to translate the label. If we need to translate the LIST-ITEM-PAIRS
                               then the code below will do so. THere's a hard-coded check for the LABEL after
                               the translation is done. */
                            ASSIGN cWidgetName           = cacheObject.ObjectName
                                   iWidgetEntries        = 0
                                   iSkipBy               = 0
                                   cLabelAttributeName   = "LABEL":U
                                   cTooltipAttributeName = "TOOLTIP":U
                                   cacheObject.ObjectTranslated = NO.
                                                        
                            /* Can we find LIST-ITEM-PAIRS to translate? */
                            ASSIGN hBufferField = ?
                                   hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("LIST-ITEM-PAIRS":U) 
                                   NO-ERROR.
                            IF VALID-HANDLE(hBufferField) THEN
                            DO:
                                ASSIGN iAttributeEntry = LOOKUP(STRING(hBufferField:POSITION - 1), cacheObject.AttrOrdinals).
                                IF iAttributeEntry GT 0 
                                THEN DO:
                                    ASSIGN hBufferField = ?
                                           hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("DELIMITER":U) 
                                           NO-ERROR.
                                           
                                    IF VALID-HANDLE(hBufferField) THEN
                                        ASSIGN iDelimiterEntry = LOOKUP(STRING(hBufferField:POSITION - 1), cacheObject.AttrOrdinals).
                                    ELSE
                                        ASSIGN iDelimiterEntry = 0.
                                    
                                    ASSIGN iWidgetEntries        = NUM-ENTRIES(ENTRY(iAttributeEntry, cacheObject.AttrValues, {&Value-delimiter}),
                                                                               IF iDelimiterEntry = 0
                                                                               THEN ",":U
                                                                               ELSE ENTRY(iDelimiterEntry, cacheObject.AttrValues, {&Value-delimiter})) / 2
                                           iSkipBy               = 2
                                           cLabelAttributeName   = "LIST-ITEM-PAIRS":U.
                                END.                                           
                            END.
                        END.
                        WHEN "FILL-IN":U OR
                        WHEN "BUTTON":U OR
                        WHEN "EDITOR":U OR
                        WHEN "TOGGLE-BOX":U OR
                        WHEN "SELECTION-LIST":U THEN
                            ASSIGN cWidgetName           = cacheObject.ObjectName
                                   iWidgetEntries        = 0
                                   iSkipBy               = 0
                                   cLabelAttributeName   = "LABEL":U
                                   cTooltipAttributeName = "TOOLTIP":U
                                   cacheObject.ObjectTranslated = NO.
                    END CASE.   /* widget type */
                    
                    /* Only attempt the translations if there is a widget name to translate.
                     */
                    IF cWidgetName NE "":U THEN
                    DO:
                        RUN translateSingleObject IN gshTranslationManager ( INPUT  pdLanguageObj,
                                                                             INPUT  pcContainerName,
                                                                             INPUT  cWidgetName,
                                                                             INPUT  cWidgetType,
                                                                             INPUT  iWidgetEntries,
                                                                             OUTPUT cLabels,
                                                                             OUTPUT cTooltips               ) NO-ERROR.
  
                        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
                            RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
                        
                        IF cLabels NE "":U AND cLabelAttributeName NE "":U THEN
                        apply-translation-blk:
                        DO:
                            /* Indicate whether this object has actually been translated or not.
                             */
                            ASSIGN cacheObject.ObjectTranslated = YES.
                            
                            /* For a combo, we receive the translated label as entry 1 in the list. Apply it here *
                             * before we proceed with the translated combo items. */
                            IF cWidgetType = "COMBO-BOX":U 
                            THEN DO:
                                IF ENTRY(1, cLabels, CHR(3)) <> "":U 
                                THEN DO:
                                    ASSIGN hBufferField = ?
                                           hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("LABEL":U)
                                           NO-ERROR.
    
                                    IF VALID-HANDLE(hBufferField) 
                                    THEN DO:
                                        ASSIGN iAttributeEntry = LOOKUP(STRING(hBufferField:POSITION - 1), cacheObject.AttrOrdinals).
                                        IF iAttributeEntry = 0 THEN
                                            ASSIGN cacheObject.AttrOrdinals = cacheObject.AttrOrdinals + ",":U + STRING(hBufferField:POSITION - 1)
                                                   cacheObject.AttrValues   = cacheObject.AttrValues + {&Value-Delimiter} + ENTRY(1, cLabels, CHR(3)).
                                        ELSE
                                            ASSIGN ENTRY(iAttributeEntry, cacheObject.AttrValues, {&Value-Delimiter}) = ENTRY(1, cLabels, CHR(3)).
                                    END.
                                END.

                                /* Strip the first (label) entry from the list.  If only the label was translated, don't go on. */
                                IF NUM-ENTRIES(cLabels, CHR(3)) > 1 THEN
                                    ASSIGN cLabels = SUBSTRING(cLabels, INDEX(cLabels, CHR(3)) + 1).
                                ELSE
                                    LEAVE apply-translation-blk.
                            END.

                            /* Now apply translations to the widget.  Labels for fill-ins and internal-entries for *
                             * other widgets. */
                            ASSIGN hBufferField = ?
                                   hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD(cLabelAttributeName)
                                   NO-ERROR.
                            
                            /* Is the label being overridden?
                             */                                                                  
                            ASSIGN iAttributeEntry = LOOKUP(STRING(hBufferField:POSITION - 1), cacheObject.AttrOrdinals).
                         
                            /* If there are no widget entries, then always assign the value that
                               is returned from the translation.                               
                             */
                            IF iWidgetEntries EQ 0 THEN
                            DO:
                                 IF iAttributeEntry EQ 0 THEN
                                    ASSIGN cacheObject.AttrOrdinals = cacheObject.AttrOrdinals + ",":U + STRING(hBufferField:POSITION - 1)
                                           cacheObject.AttrValues   = cacheObject.AttrValues + {&Value-Delimiter} + cLabels.
                                ELSE
                                    ENTRY(iAttributeEntry, cacheObject.AttrValues, {&Value-Delimiter}) = cLabels.
                            END.    /* no widget entries */
                            ELSE
                            DO:
                                ASSIGN cAttributeValue = ENTRY(iAttributeEntry, cacheObject.AttrValues, {&Value-delimiter}).
                                                                                                
                                /* Loop through the translated string, and apply as needed. */
                                DO iLabelEntry = 1 TO NUM-ENTRIES(cLabels, CHR(3)):
                                    ASSIGN cEntry = ENTRY(iLabelEntry, cLabels, CHR(3)).
                                    
                                    IF cEntry EQ "":U THEN
                                        NEXT.
                                    
                                    /* Update the attribute. */
                                    IF iSkipBy LE 1 THEN
                                        ENTRY(iLabelEntry, cAttributeValue) = cEntry.
                                    ELSE
                                        ENTRY(iLabelEntry * iSkipBy - 1 , cAttributeValue) = cEntry.
                                END.    /* loop through translated labels */
                                
                                /* At this stage, we know that there is an attribute for
                                   the label (RADIO-BUTTONS), otherwise we would never have got here.
                                 */
                                ENTRY(iAttributeEntry, cacheObject.AttrValues, {&Value-Delimiter}) = cAttributeValue.
                            END.    /* there are widget entries. */                             
                        END.    /* there are translated labels. */
    
                        /* Translated tooltips. */
                        IF cTooltips NE "":U AND cTooltipAttributeName NE "":U THEN
                        DO:
                            /* Indicate whether this object has actually been translated or not.
                             */
                            ASSIGN cacheObject.ObjectTranslated = YES.
                            
                            ASSIGN hBufferField = ?
                                   hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD(cTooltipAttributeName)
                                   NO-ERROR.
                            
                            /* Is the Tooltip being overridden? */
                            ASSIGN iAttributeEntry = LOOKUP(STRING(hBufferField:POSITION - 1), cacheObject.AttrOrdinals).
    
                            /* The value of the tooltip will be blank when
                               there is not translation.
							   
                               When translating radio-sets, only take the first available
                               translation tooltip.
                             */
                            if cWidgetType eq 'Radio-Set' then
                                /* trim all separator characters, since
                                   we trying to find the first available 
                                   tooltip.
                                 */
                                assign cAttributeValue = trim(cTooltips, chr(3))
                                       cAttributeValue = entry(1, cAttributeValue, chr(3)).
                            else
                            IF iWidgetEntries EQ 0 THEN
                                ASSIGN cAttributeValue = cTooltips.
                            ELSE
                            DO:
                                 IF iAttributeEntry EQ 0 THEN
                                     ASSIGN cAttributeValue = FILL(",":U, 2 * iWidgetEntries - 1).
                                 ELSE
                                     ASSIGN cAttributeValue = ENTRY(iAttributeEntry, cacheObject.AttrValues, {&Value-delimiter}).
                                
                                /* Loop through the translated string, and apply as needed. */
                                DO iLabelEntry = 1 TO NUM-ENTRIES(cTooltips, CHR(3)):
                                    ASSIGN cEntry = ENTRY(iLabelEntry, cTooltips, CHR(3)).
                                    
                                    IF cEntry EQ "":U THEN
                                        NEXT.
                                    
                                    /* Update the attribute. */
                                    IF iSkipBy LE 1 THEN
                                        ENTRY(iLabelEntry, cAttributeValue) = cEntry.
                                    ELSE
                                        ENTRY(iLabelEntry * iSkipBy - 1 , cAttributeValue) = cEntry.
                                END.    /* loop through translated Tooltips */
                            END.    /* there are widget entries. */

                            ASSIGN cAttributeValue = TRIM(cAttributeValue, ",":U).
                            
                            IF cAttributeValue NE "":U THEN
                            DO:
                                IF iAttributeEntry EQ 0 then
                                    ASSIGN cacheObject.AttrOrdinals = cacheObject.AttrOrdinals + ",":U + STRING(hBufferField:POSITION - 1)
                                           cacheObject.AttrValues   = cacheObject.AttrValues + {&Value-Delimiter} + cAttributeValue.
                                ELSE
                                    ENTRY(iAttributeEntry, cacheObject.AttrValues, {&Value-Delimiter}) = cAttributeValue.
                            END.    /* there are translated tooltips. */
                        END.    /* there are translated Tooltips. */
                    END.    /* there is a widget tp translate  */
                END.    /* there is a widget type. */
            END.    /* valid VisualizationType */
        END.    /* Field-level widgets */        
    END.    /* translate objects */
    
    /* Browser objects need special handling for determining their security,
       since their column names are stored as an attribute (DisplayedFields).
       We need to figure out which columns are secured, and write the security
     */
    IF CAN-DO(ttClass.InheritsFrom, "Browser":U) AND cacheObject.ObjectSecured EQ ? THEN
    DO:
        /* Only do this if both attributes are available. */
        ASSIGN hBufferField = ?
               hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("DisplayedFields":U) NO-ERROR.
        IF VALID-HANDLE(hBufferField) THEN
        DO:
            ASSIGN iAttributeEntry = LOOKUP(STRING(hBufferField:POSITION - 1), cacheObject.AttrOrdinals).
            
            /* Only even bother trying if there are actually fields set.
             */
            IF iAttributeEntry GT 0 THEN
            DO:
                /* Reuse the cInstanceName variable, as it is a scratch variable.
                 */
                ASSIGN cacheObject.ObjectSecured = NO
                       
                       cInstanceName = ENTRY(iAttributeEntry, cacheObject.AttrValues, {&Value-Delimiter})
                       hBufferField  = ?
                       hBufferField  = ttClass.ClassBufferHandle:BUFFER-FIELD("FieldSecurity":U)
                       NO-ERROR.
                /* The value of the FieldSecurity property should only be set by
                   this process.
                 */
                IF VALID-HANDLE(hBufferField) THEN
                DO:
                    ASSIGN cSecuredFields = "":U.
                    
                    /* Loop through the columns and translate accordingly. */
                    DO iWidgetEntries = 1 TO NUM-ENTRIES(cInstanceName):                                            
                        ASSIGN iAttributeEntry = LOOKUP(ENTRY(iWidgetEntries, cInstanceName), pcSecuredFields).
               
                        IF iAttributeEntry GT 0 THEN
                            ASSIGN cacheObject.ObjectSecured = YES
                                   cSecuredFields = cSecuredFields + ",":U + ENTRY(iAttributeEntry + 1, pcSecuredFields).
                        ELSE
                            ASSIGN cSecuredFields = cSecuredFields + ",":U.
                    END.    /* loop through columns */
                    
                    /* Now update the FieldSecurity attribute and the ObjectSecured field.
                     */
                    ASSIGN iAttributeEntry           = LOOKUP(STRING(hBufferField:POSITION - 1), cacheObject.AttrOrdinals)
                           cSecuredFields            = SUBSTRING(cSecuredFields, 2)
                           NO-ERROR.
                    IF iAttributeEntry EQ 0 THEN
                        ASSIGN cacheObject.AttrOrdinals = cacheObject.AttrOrdinals + ",":U + STRING(hBufferField:POSITION - 1)
                               cacheObject.AttrValues   = cacheObject.AttrValues + {&Value-Delimiter} + cSecuredFields.
                    ELSE
                        ENTRY(iAttributeEntry, cacheObject.AttrValues, {&Value-Delimiter}) = cSecuredFields.                                         
                END.    /* there is a FieldSecurity attribute */
            END.    /* the DisplayedFields property has been set. */
        END.    /* there is a displayedfields attribute. */
    END.    /* This is a browser. */
        
    /* Now get my contained instances, if they exist. */
    IF CAN-FIND(FIRST rycoi WHERE
                      rycoi.container_smartobject_obj = pdSmartObjectObj) THEN
    DO:
        FIND FIRST rycso WHERE
                   rycso.smartobject_obj = pdSmartObjectObj
                   NO-LOCK NO-ERROR.
        IF NOT AVAILABLE rycso THEN
            RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' '"repository object"'}.
        
        /* There won't always be a layout */
        FIND FIRST rycla WHERE
                   rycla.layout_obj = rycso.layout_obj
                   NO-LOCK NO-ERROR.
                   
        /* Set the Page0LayoutManager property */
        ASSIGN hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("Page0LayoutManager":U) NO-ERROR.
        IF VALID-HANDLE(hBufferField) THEN
        DO:
            ASSIGN iAttributeEntry = LOOKUP(STRING(hBufferField:POSITION - 1), cacheObject.AttrOrdinals).
            IF iAttributeEntry EQ 0 THEN
                ASSIGN cacheObject.AttrOrdinals = cacheObject.AttrOrdinals + ",":U + STRING(hBufferField:POSITION - 1)
                       cacheObject.AttrValues   = cacheObject.AttrValues + {&Value-Delimiter}
                                                + (IF AVAILABLE rycla THEN rycla.layout_code ELSE "00":U).
            ELSE
                ENTRY(iAttributeEntry, cacheObject.AttrValues, {&Value-Delimiter}) = (IF AVAILABLE rycla THEN rycla.layout_code ELSE "00":U).        
        END.    /* There is a Page0LayoutManager attribute */                
        
        /* Recurse .... */
        RUN getObjectData ( INPUT pdSmartObjectObj,          /* container obj */
                            INPUT cacheObject.InstanceId,     /* pdContainerInstanceId */
                            INPUT (IF AVAILABLE rycla THEN rycla.layout_code ELSE "00":U) ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
        
        /* Get all the instances we need.
           
           For contained objects, always retrieve all pages, regardless
           of which pages need to be initialised at startup.
	     */
        ASSIGN cInstanceName  = "":U
               cContainerName = rycso.object_filename
               cPageList      = "*":U.
        FOR EACH cachePage WHERE cachePage.InstanceId = cacheObject.InstanceId:
            /* Only retrieve instances for those pages that were requested.
             * If page 0 was requested, there may be more page records than
             * pages requested (a request for a page means that all the stuff
             * inside it must be retrieved; a request for page 0 retrieves the
             * page meta-information).
             */
            IF CAN-DO(cPageList, STRING(cachePage.PageNumber)) THEN
                /* Since the instance name is unique across a container, we know that
                 * there are no duplicates.
                 */
                ASSIGN cInstanceName = cInstanceName + ",":U + cachePage.TOC.
        END.    /* each requested page */
        ASSIGN cInstanceName = LEFT-TRIM(cInstanceName, ",":U).
        
        /* Now we know the instances to retrieve, go and get them. */
        DO iInstanceLoop = 1 TO NUM-ENTRIES(cInstanceName):
            FIND FIRST rycoi WHERE
                       rycoi.container_smartobject_obj = pdSmartObjectObj                    AND
                       rycoi.instance_name             = ENTRY(iInstanceLoop, cInstanceName)
                       NO-LOCK NO-ERROR.
            /* The requested instance name may not exist on this customised version, so
             * we cannot return an error.
             */
            IF NOT AVAILABLE rycoi THEN
                NEXT.
            
            FIND FIRST rycso WHERE
                       rycso.smartobject_obj = rycoi.smartobject_obj
                       NO-LOCK NO-ERROR.
            /* Keep this code as-is: commented out. It is the
               correct way of dealing with orphan data, but due to the
               reported volumes cause by pre-v2.1 tools we need
               to simply skip this record and move on to the next.
               
               This emulates the 2.0SP2 behaviour.
               
            IF NOT AVAILABLE rycso_instance THEN
                RETURN ERROR {aferrortxt.i 'AF' '15' '?' '?'
                              "'the master object record is missing for instance ' + rycoi.instance_name + ' on the containing object ' + pcObjectName"}.
            */
            if not available rycso then
                next.
            
            /* Determine the correct page number. If this object has been
               customised, then the page order may have changed and so the
               page number on the ryc_page record will not necessarily be
               correct.
             */
            FIND FIRST ryc_page WHERE
                       ryc_page.page_obj = rycoi.page_obj
                       NO-LOCK NO-ERROR.
            IF AVAILABLE ryc_page THEN                       
                FIND cachePage WHERE
                     cachePage.InstanceId    = cacheObject.InstanceId  AND
                     cachePage.PageReference = ryc_page.page_reference
                     NO-ERROR.
            
            /* Loop through all the requested result codes for this contained
               instance.
             */
            assign iNumberOfResultCodes = NUM-ENTRIES(pcResultCode)
                   cObjectName          = rycso.object_filename.
            
            INSTANCE-RESULT-CODE-LOOP:
            DO iResultCodeLoop = 1 TO iNumberOfResultCodes:
                /* Only attempt to find the record if there is customisation 
                   in the session. If there is not, then we already have the 
                   ryc_smartObject record in the record buffer and we can use
                   that record. It also saves some processing around finding
                   the customisation result records etc.
                 */
                IF iNumberOfResultCodes GT 1 THEN
                DO:
                    /* Get the customisation result code.
                     */
                    IF ENTRY(iResultCodeLoop, pcResultCode) EQ "{&DEFAULT-RESULT-CODE}":U THEN
                        ASSIGN dResultCodeObj = 0.
                    ELSE
                    DO:
                        FIND FIRST ryccr WHERE
                                   ryccr.customization_result_code = ENTRY(iResultCodeLoop, pcResultCode)
                                   NO-LOCK NO-ERROR.
                        IF NOT AVAILABLE ryccr THEN
                            RETURN ERROR {aferrortxt.i 'AF' '5' 'ryc_customization_result' 'customization_result_code' '"result code"' "'Result code:' + ENTRY(iResultCodeLoop, pcResultCode)"}.
                        
                        ASSIGN dResultCodeObj = ryccr.customization_result_obj.
                    END.    /* there is a result code. */
                    
                    /* Find the master object for the object instance.
                     */
                    FIND rycso WHERE
                         rycso.object_filename          = cObjectName    AND
                         rycso.customization_result_obj = dResultCodeObj
                         NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE rycso THEN
                    DO:
                        IF dResultCodeObj EQ 0 THEN
                            RETURN ERROR {aferrortxt.i 'AF' '5' 'ryc_smartObject' 'object_filename' '"object"' "'Object name: ' + cObjectName" }.
                        ELSE
                            NEXT INSTANCE-RESULT-CODE-LOOP.
                    END.    /* n/a result code */
                END.    /* there is customisation in the client session. */
            
                /* Get the data for this instance. Object, attribute, event. 
                 * Also recurses so all instances instances are retrieved.
                 */
                RUN getInstanceData( INPUT cContainerName,
                                     INPUT cacheObject.InstanceId,                      /* pdContainerInstanceId */
                                     INPUT rycoi.instance_name,
                                     INPUT rycoi.object_instance_obj,
                                     INPUT rycso.object_filename,             /* pcLogicalObjectName */
                                     INPUT rycso.smartobject_obj,
                                     INPUT rycso.object_type_obj,
                                     INPUT rycoi.layout_position,
                                     INPUT (IF AVAILABLE ryc_page AND AVAILABLE cachePage THEN cachePage.PageNumber ELSE 0),
                                     INPUT rycoi.object_sequence,
                                     INPUT pdRenderTypeObj,
                                     INPUT pdLanguageObj,
                                     INPUT plApplyTranslations,
                                     INPUT rycso.static_object,
                                     INPUT pcSecuredFields,
                                     INPUT pcSecuredTokens,
                                     INPUT pcResultCode,         /* all result codes. */
                                     INPUT-OUTPUT pcClassesReferenced,
                                     INPUT-OUTPUT pcEntitiesReferenced,
                                     INPUT-OUTPUT pcToolbarsReferenced    ) NO-ERROR.
                IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
            END.    /* INSTANCE-RESULT-CODE-LOOP: loop through all result codes for the contained instance. */
        END.    /* loop through the requested instances. */        
    END.    /* this instance is a container. */
    
    /* EOF (ryrepgeidi.i) */ 
