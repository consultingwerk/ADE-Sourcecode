/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*---------------------------------------------------------------------------------
  FILE: ryrepdoori.i
  
  DESCRIPTION:  Include file for doObjectRetrieval() API in Dynamics Repository Manager.

  Purpose:      

  Parameters:   
    DEFINE INPUT  PARAMETER pcObjectName            AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pcResultCode            AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pdUserObj               AS DECIMAL          NO-UNDO.
    DEFINE INPUT  PARAMETER pdLanguageObj           AS DECIMAL          NO-UNDO.
    DEFINE INPUT  PARAMETER pcRunAttribute          AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pdRenderTypeObj         AS DECIMAL          NO-UNDO.
    DEFINE INPUT  PARAMETER pcPageList              AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pdInstanceId            AS DECIMAL            NO-UNDO.
    DEFINE INPUT  PARAMETER pcInstanceName          AS CHARACTER        NO-UNDO.    
    
  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                DATE:   07/24/2003  Author:    pjudge 

  UPDATE Notes: Initial Implementation
---------------------------------------------------------------------------------*/    
    DEFINE VARIABLE iResultCodeLoop             AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iInstanceLoop               AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iInstanceResultLoop         AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iAttributeEntry             AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iNumberOfResultCodes        AS INTEGER              NO-UNDO.
    DEFINE VARIABLE dResultCodeObj              AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dInstanceResultCodeObj      AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dSmartObjectObj             AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dContainerInstanceId        AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE hClassBuffer                AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hBufferField                AS HANDLE               NO-UNDO.
    DEFINE VARIABLE cAttributeValue             AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cUserProperties             AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cLabels                     AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cTooltips                   AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cEntry                      AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cSecuredTokens              AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cSecuredFields              AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cContainerName              AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cObjectName                 AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cObjectExtension            AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cInstancesToRetrieve        AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cSecurityModel              AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE lApplyTranslations          AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE lApplySecurity              AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE lContainerSecured           AS LOGICAL              NO-UNDO.
    define variable lGetInitialPages            as logical              no-undo.
        
    DEFINE BUFFER rycso_container   FOR ryc_smartObject.
    define buffer rycso_instance    for ryc_smartObject.
    define buffer ryccr             for ryc_customization_result.
    define buffer gscot             for gsc_object_type.
    define buffer gstrv             for gst_record_version.
    define buffer gsmom             for gsm_object_menu_structure.
    define buffer rycla             for ryc_layout.
    define buffer rycav             for ryc_attribute_value.
    define buffer rycue             for ryc_ui_event.
    define buffer rycoi             for ryc_object_instance.
    define buffer rycpa             for ryc_page.
    define buffer rycsm             for ryc_smartlink.
    DEFINE BUFFER cacheObject       FOR cacheObject.
    DEFINE BUFFER cachePage         FOR cachePage.
    DEFINE BUFFER ttClass           FOR ttClass.
    
    /* Setup */
    ASSIGN cUserProperties = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                              INPUT "TranslationEnabled,SecurityEnabled,GSMFFSecurityExists,GSMTOSecurityExists,SecurityModel":U,
                                              INPUT NO /* Session Only */ ).

    /* Do we need to bother with translations at all? */
    ASSIGN lApplyTranslations = LOGICAL(ENTRY(1, cUserProperties, CHR(3))) NO-ERROR.
    IF lApplyTranslations EQ ? THEN
        ASSIGN lApplyTranslations = YES.
    
    /* Do we need to bother with Security at all? */
    ASSIGN lApplySecurity = LOGICAL(ENTRY(2, cUserProperties, CHR(3))) NO-ERROR.
    IF lApplySecurity EQ ? THEN
        ASSIGN lApplySecurity = YES.
    
    /* If an object is requested as "abc.w", it may be stored in the Repository in one of
       two ways: filename of "abc.w" with an extension of "" or filename "abc" with an 
       extension of "w". In addition the same object may be requested as "abc".
       
       The same object needs to be retrieved in both cases, although it will be cached twice: 
       once for "abc" and once for "abc.w".
       
       It may be possible that more than one object exists with only a difference in the extension,
       for example "abc" extension "p". The check needs to make sure that the requested object
       extension matches the extension in the data base; this is necessary to ensure that a request
       for "abc.p" doesn't return "abc" extension "w".
       
       So, by example:
       ryc_smartobject name: "abc", extension "w"
       
       Requested object name: abc.w
       Found using requested name: no
       Found using name with separate extension: yes
       
       Requested object name: abc
       Found using requested name: yes
       Found using name with separate extension: n/a
       
       Requested object name: abc.p
       Found using requested name: no
       Found using name with separate extension: no
     */
     
    /* The record needs to be found (rather than queried via CAN-FIND) 
       because we need to know whether to perform container security on it.
     */
    find first rycso_container WHERE
               rycso_container.object_filename = pcObjectName
               no-lock no-error.
    if available rycso_container then
        ASSIGN cContainerName = pcObjectName.
    ELSE
    DO:
        ASSIGN cObjectExtension = ENTRY(NUM-ENTRIES(pcObjectName, ".":U), pcObjectName, ".":U)
               cContainerName   = REPLACE(pcObjectName, ".":U + cObjectExtension, "":U).
               
        /* Double check that the requested extension matches that on the DB. */
        find first rycso_container where
                   rycso_container.object_filename  = cContainerName and
                   rycso_container.object_extension = cObjectExtension
                   no-lock no-error.
                   
        IF cObjectExtension NE "":U AND not available rycso_container then
            RETURN ERROR {aferrortxt.i 'AF' '5' 'ryc_smartObject' 'object_filename' '"object"' "'Object name: ' + pcObjectName" }.
    END.    /* full name doesn't match */
    
    /* If we need to apply security, then get all secured fields and tokens
       up front. We then apply them selectively as we read through the contained
       objects.
     */
    IF lApplySecurity THEN
    DO:
        /* Check if the container is secured. If so, we don't even bother
           extracting information. We just return an error.
           
           At this point, temporarily set that value of the dSmartObjectObj variable
           to zero, so that the name of the object is used for securing the 
           container. This is important when dealing with customised containers,
           since the security is stored against the uncustomised container. If the
           first entry in the result code string is not the default (uncustomised)
           object, then security will not be found if the object ID is used.
           This should ensure that the check is correctly made, based on the object 
           name alone.
           
           Only attempt this check if this object can have container/object security.
         */
        if available rycso_container and rycso_container.container_object then
        do:
            ASSIGN dSmartObjectObj = 0.
            RUN objectSecurityCheck IN gshSecurityManager ( INPUT-OUTPUT pcObjectName,
                                                            INPUT-OUTPUT dSmartObjectObj,
                                                                  OUTPUT lContainerSecured).
            
            IF lContainerSecured THEN
                RETURN ERROR {aferrortxt.i 'AF' '17' '?' '?' '"You do not have the necessary security permission to launch this object"'}.
        end.    /* container object? */
        
        ASSIGN cSecurityModel = ENTRY(5, cUserProperties, CHR(3)).
        
        /* Apply FIELD security? */
        ASSIGN lApplySecurity = LOGICAL(ENTRY(3, cUserProperties, CHR(3))) NO-ERROR.
        IF lApplySecurity EQ ? THEN
            ASSIGN lApplySecurity = YES.
        
        IF lApplySecurity OR cSecurityModel EQ "Grant":U THEN
            RUN fieldSecurityCheck IN gshSecurityManager (INPUT  pcObjectName,
                                                          INPUT  pcRunAttribute,
                                                          OUTPUT cSecuredFields ).
        
        /* Apply TOKEN security? */
        ASSIGN lApplySecurity = LOGICAL(ENTRY(4, cUserProperties, CHR(3))) NO-ERROR.
        IF lApplySecurity EQ ? THEN
             ASSIGN lApplySecurity = YES.
        
        IF lApplySecurity OR cSecurityModel EQ "Grant":U THEN
            RUN tokenSecurityCheck IN gshSecurityManager ( INPUT  pcObjectName,
                                                           INPUT  pcRunAttribute,
                                                           OUTPUT cSecuredTokens  ).
    END.    /* apply the security. */
    
    /* Loop through the result codes. We loop FORWARDS (ie from most important to
     * least important) so that we can SKIP attribute VALUES IF ANY have been found.
     */
    ASSIGN iNumberOfResultCodes = NUM-ENTRIES(pcResultCode).
    
    RESULT-CODE-LOOP:
    DO iResultCodeLoop = 1 TO iNumberOfResultCodes:
        /** Get the customisation result
         *  ----------------------------------------------------------------------- **/
        IF ENTRY(iResultCodeLoop, pcResultCode) EQ "{&DEFAULT-RESULT-CODE}":U THEN
            ASSIGN dResultCodeObj = 0.
        ELSE
        DO:
            FIND FIRST ryccr WHERE
                       ryccr.customization_result_code = ENTRY(iResultCodeLoop, pcResultCode)
                       NO-LOCK NO-ERROR.
            IF NOT AVAILABLE ryccr THEN
                RETURN ERROR {aferrortxt.i 'AF' '5' 'ryccr' 'customization_result_code' '"result code"' "'Result code:' + ENTRY(iResultCodeLoop, pcResultCode)"}.
            
            ASSIGN dResultCodeObj = ryccr.customization_result_obj.
        END.    /* there is a result code. */
        
        /** Find the master object for the requested object.
         *  ----------------------------------------------------------------------- **/
        FIND rycso_container WHERE
             rycso_container.object_filename          = cContainerName AND
             rycso_container.customization_result_obj = dResultCodeObj
             NO-LOCK NO-ERROR.
        IF NOT AVAILABLE rycso_container THEN
        DO:
            IF dResultCodeObj EQ 0 THEN
                RETURN ERROR {aferrortxt.i 'AF' '5' 'ryc_smartObject' 'object_filename' '"object"' "'Object name: ' + pcObjectName" }.
            ELSE
                NEXT RESULT-CODE-LOOP.
        END.    /* n/a result code */
        
        /* The value of the object's smartobject_obj is needed for security and for retrieving
         * the instances.
         */
        ASSIGN dSmartObjectObj = rycso_container.smartobject_obj.
                
        /* If the passed in value of the instance id is zero, then we know that 
         * we need to create a cacheObject record for the requested object. If there
         * is a value for this parameter, then we know that this is a subsequent request
         * (eg. a request for additional pages or for additional object instances) and
         * then we know that the object is already cached on the client.
         */
        IF pdInstanceId EQ 0 THEN
        DO:
            FIND cacheObject WHERE
                 cacheObject.ObjectName          = pcObjectName AND
                 cacheObject.ContainerInstanceId = 0
                 NO-ERROR.
            IF NOT AVAILABLE cacheObject THEN
            DO:
                /* Store the classes we have accessed and their attribute buffer handles
                 * to avoid reading the DB again for oft-duplicated classes.
                 */
                FIND FIRST ttClass WHERE ttClass.ClassObj = rycso_container.object_type_obj NO-ERROR.
                IF NOT AVAILABLE ttClass THEN
                DO:
                    FIND FIRST gscot WHERE
                               gscot.object_type_obj = rycso_container.object_type_obj
                               no-lock no-error.
                    IF NOT AVAILABLE gscot THEN
                        RETURN ERROR {aferrortxt.i 'AF' '5' 'gscot' '?' '"class"'}.
                         
                    RUN createClassCache IN TARGET-PROCEDURE ( gscot.object_type_code ) NO-ERROR.
                    FIND FIRST ttClass where ttClass.ClassObj = rycso_container.object_type_obj no-error.
                    IF not available ttClass then
                        RETURN ERROR {aferrortxt.i 'AF' '1' '?' '?' '"cached class"'}.
                END.    /* local class record not found */
                
                CREATE cacheObject.
                ASSIGN gsdTempUniqueId        = gsdTempUniqueId + 1
                       cacheObject.InstanceId = gsdTempUniqueId
                       dContainerInstanceId   = cacheObject.InstanceId
                       cacheObject.ObjectName = pcObjectName
                       cacheObject.ClassName  = ttClass.ClassName.
                       
                IF NOT CAN-DO(pcClassesReferenced, ttClass.ClassName) THEN
                    ASSIGN pcClassesReferenced = pcClassesReferenced + ",":U + ttClass.ClassName.
                
                /* Update the LogicalObjectName attribute. This attribute matches the object_filename
                   of this object. We only need to do this once per object.
                 */
                ASSIGN hBufferField = ?
                       hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("LogicalObjectName":U) NO-ERROR.
                IF VALID-HANDLE(hBufferField) THEN
                    ASSIGN cacheObject.AttrOrdinals = cacheObject.AttrOrdinals + ",":U + STRING(hBufferField:POSITION - 1)
                           cacheObject.AttrValues   = cacheObject.AttrValues + {&Value-Delimiter}
                                                    + rycso_container.object_filename.
                /* LogicalVersion. */
                ASSIGN hBufferField = ?
                       hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("LogicalVersion":U) NO-ERROR.
                IF VALID-HANDLE(hBufferField) THEN
                DO:
                    FIND gstrv WHERE
                         gstrv.entity_mnemonic = "RYCSO":U AND
                         gstrv.key_field_value = STRING(rycso_container.smartobject_obj)
                         NO-LOCK NO-ERROR.
                    IF AVAILABLE gstrv THEN
                        ASSIGN cacheObject.AttrOrdinals = cacheObject.AttrOrdinals + ",":U + STRING(hBufferField:POSITION - 1)
                               cacheObject.AttrValues   = cacheObject.AttrValues + {&Value-Delimiter}
                                                        + STRING(gstrv.version_number_seq).
                END.    /* LogicalVersion */
                
                /* Object has menus */
                IF CAN-FIND(FIRST gsmom WHERE gsmom.object_obj = rycso_container.smartobject_obj) THEN
                DO:
                    ASSIGN hBufferField = ?
                           hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("hasObjectMenu":U) NO-ERROR.

                    IF VALID-HANDLE(hBufferField) THEN
                        ASSIGN cacheObject.AttrOrdinals = cacheObject.AttrOrdinals + ",":U + STRING(hBufferField:POSITION - 1)
                               cacheObject.AttrValues   = cacheObject.AttrValues + {&Value-Delimiter} + STRING(YES).
                END.    /* can find an object menu structure. */

                /* RenderingProcedure.
                   For static objects, get the value from the object itself. For dynamic
                   objects, the RenderingProcedure is stored as an attribute.
                 */
                IF rycso_container.static_object AND rycso_container.object_is_runnable THEN
                DO:
                    ASSIGN hBufferField = ?
                           hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("RenderingProcedure":U)
                           NO-ERROR.
                    
                    IF NOT VALID-HANDLE(hBufferField) THEN
                        ASSIGN hBufferField = ?
                               hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("PhysicalObjectName":U) NO-ERROR.
                    
                    IF VALID-HANDLE(hBufferField) THEN
                        ASSIGN cacheObject.AttrOrdinals = cacheObject.AttrOrdinals + ",":U + STRING(hBufferField:POSITION - 1)
                               cacheObject.AttrValues   = cacheObject.AttrValues + {&Value-Delimiter}
                                                        + DYNAMIC-FUNCTION("getObjectPathedName":U IN gshRepositoryManager,
                                                                           INPUT rycso_container.smartobject_obj).
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
                                                    + STRING(NOT rycso_container.static_object AND CAN-DO(ttClass.InheritsFromClasses, "Base":U)).
                
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
                                                    + STRING(NOT rycso_container.static_object AND CAN-DO(ttClass.InheritsFromClasses, "Base":U)).                                                    
                                                    
                /* Find the container object so that we can use its layout. */
                FIND FIRST rycla WHERE
                           rycla.layout_obj = rycso_container.layout_obj
                           NO-LOCK NO-ERROR.
                /* Set the Page0LayoutManager property */
                ASSIGN hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("Page0LayoutManager":U) NO-ERROR.
                IF VALID-HANDLE(hBufferField) THEN
                    ASSIGN cacheObject.AttrOrdinals = cacheObject.AttrOrdinals + ",":U + STRING(hBufferField:POSITION - 1)
                           cacheObject.AttrValues   = cacheObject.AttrValues + {&Value-Delimiter}
                                                    + (IF AVAILABLE rycla THEN rycla.layout_code ELSE "00":U).                                                    
            END.    /* new container record */
            
            /* Translate the window title, using the WindowName attribute, if one
             * exists.
             */
            IF lApplyTranslations AND iResultCodeLoop EQ 1 THEN
            DO:
                ASSIGN hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("WindowName":U) NO-ERROR.
                    
                /* At this stage we try to translate the window title. If we can find
                 * a translation, THEN we USE this translation. IF there IS a translation
                 * it will be applied ON the very FIRST loop THROUGH the RESULT-CODE-LOOP,
                 * since the translation doesn't care about customisation, only about the
                 * object's name. So if there is a translation at all, it will be found in 
                 * the FIRST loop.
                 * 
                 * ANY stored WindowName attributes will NOT be overlaid over this translated
                 * VALUE.
                 */
                IF VALID-HANDLE(hBufferField) AND
                   NOT CAN-DO(cacheObject.AttrOrdinals, STRING(hBufferField:POSITION - 1)) then
                DO:
                    RUN translateSingleObject IN gshTranslationManager ( INPUT  pdLanguageObj,
                                                                         INPUT  cacheObject.ObjectName,
                                                                         INPUT  "TITLE":U,     /* pcWidgetName */
                                                                         INPUT  "TITLE":U,     /* pcWidgetType */
                                                                         INPUT  0,             /* piWidgetEntries  */
                                                                         OUTPUT cLabels,
                                                                         OUTPUT cTooltips               ) NO-ERROR.                                                                 
                    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    
                    /* Update the translations.
                     * We know that this will be the FIRST ENTRY IN the list, since this
                     * CODE happens IN the FIRST loop, before ANY other attribute retrieval.
                     */
                    IF cLabels NE "":U THEN
                        ASSIGN cacheObject.AttrOrdinals     = cacheObject.AttrOrdinals + ",":U + STRING(hBufferField:POSITION - 1)
                               cacheObject.AttrValues       = cacheObject.AttrValues + {&Value-Delimiter} + cLabels
                               cacheObject.ObjectTranslated = YES.
                    ELSE
                        ASSIGN cacheObject.ObjectTranslated = NO.                                                   
                END.    /* we can translate. */                    
            END.    /* perform translations */
            
            /** Fetch all the attribute values. 
             *  FIRST GET the attributes FOR the DEFAULT render TYPE. Then
             *  GET the attributes FOR the specific render TYPE, IF different.
             **/
            
            /* (1) Get all attributes for the client session render type, if there is one. */
            IF pdRenderTypeObj NE 0 then
            FOR EACH rycav where
                     rycav.smartObject_obj     = rycso_container.smartObject_obj and
                     rycav.object_instance_obj = 0                               and
                     rycav.render_type_obj     = pdRenderTypeObj                 and
                     rycav.container_smartobject_obj = 0                               and
                     rycav.applies_at_runtime  = yes
                     NO-LOCK:
                {ry/inc/getobjectattributes.i
                    &AttributeTable = rycav
                    &CacheTable     = cacheObject
                    &ClassBuffer    = ttClass.ClassBufferHandle
                    &InstanceID     = cacheObject.InstanceId }
            END.    /* each attribute that can be retrieved for this master/ default render type. */
    
            /* (2) Retrieve all attributes for the default render type (0). */
            FOR EACH rycav where
                     rycav.smartObject_obj     = rycso_container.smartObject_Obj and
                     rycav.object_instance_obj = 0                               and
                     rycav.render_type_obj     = 0                               and
                     rycav.container_smartobject_obj = 0                               and
                     rycav.applies_at_runtime  = yes
                     NO-LOCK:
                {ry/inc/getobjectattributes.i
                    &AttributeTable = rycav
                    &CacheTable     = cacheObject
                    &ClassBuffer    = ttClass.ClassBufferHandle
                    &InstanceID     = cacheObject.InstanceId }
            END.    /* each attribute that can be retrieved for this master/ render type. */
            
            /** Ui Events **/
            /* (1) Get UI events for the client session render type, if one exists. */
            IF pdRenderTypeObj NE 0 then
            FOR EACH rycue WHERE
                     rycue.object_type_obj     = rycso_container.object_type_obj AND
                     rycue.smartObject_obj     = rycso_container.smartObject_obj AND
                     rycue.object_instance_obj = 0                               AND
                     rycue.render_type_obj     = pdRenderTypeObj                 and
                     rycue.event_disabled      = NO                              and
                     rycue.container_smartobject_obj = 0                               and
                     rycue.event_action       <> "":U
                     NO-LOCK:
                {ry/inc/getobjectevents.i
                    &EventTable = rycue
                    &CacheTable = cacheObject }
            END.    /* UI events */
    
            /* (2) Get UI events for the default render type */
            FOR EACH rycue WHERE
                     rycue.object_type_obj     = rycso_container.object_type_obj AND
                     rycue.smartObject_obj     = rycso_container.smartObject_obj AND
                     rycue.object_instance_obj = 0                               AND
                     rycue.render_type_obj     = 0                               and
                     rycue.event_disabled      = NO                              and
                     rycue.container_smartobject_obj = 0                               and
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
        END.    /* pdInstanceId = 0 */
        ELSE
            ASSIGN dContainerInstanceId = pdInstanceId.
        
        /* Now we have the container information we can get the
           contained instances and their associated information,
           such as page and link information, including any contained
           instances they themselves may have.
           
           It is not sufficient to check for the existentence of contained
           instances; if the customisation only consists of re-ordering pages,
           then there will be no instances stored against the customised container.
           Similarly, customisation may consist solely of changing links.
         */                      
        IF CAN-FIND(FIRST rycoi WHERE
                          rycoi.container_smartobject_obj = rycso_container.smartObject_obj) or
           CAN-FIND(FIRST rycpa WHERE
                          rycpa.container_smartobject_obj = rycso_container.smartObject_obj) or
           CAN-FIND(FIRST rycsm WHERE
                          rycsm.container_smartobject_obj = rycso_container.smartObject_obj) then
        DO:
            /* This record will only be available if the container itself is requested.
             */
            IF AVAILABLE cacheObject THEN
            DO:
                /* If we are requesting the initial [Init] pages, and the object has a 
                   InitPages and/or StartPage attribute, then we use these to construct
                   a list of pages to retrieve initially.
                 */
                lGetInitialPages = (pcPageList eq '[Init]').
                if lGetInitialPages then
                DO:
                    /* clear the list */
                    pcPageList = ''.
                    
                    /* Get the list of initial pages. */
                    ASSIGN hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("InitialPageList":U) NO-ERROR.
                    IF VALID-HANDLE(hBufferField) THEN
                    DO:
                        ASSIGN iAttributeEntry = LOOKUP(STRING(hBufferField:POSITION - 1), cacheObject.AttrOrdinals).
                        IF iAttributeEntry GT 0 then
                            ASSIGN cEntry = ENTRY(iAttributeEntry, cacheObject.AttrValues, {&Value-Delimiter}).
                        ELSE
                            ASSIGN cEntry = trim(hBufferField:INITIAL).
                        
                        IF cEntry NE ? AND /*NOT CAN-DO("*,", cEntry) */ 
                           cEntry ne '' THEN
                            ASSIGN pcPageList = trim(cEntry).
                    END.    /* valid attribute InitialPageList */
                                                    
                    ASSIGN hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("StartPage":U) NO-ERROR.
                    IF VALID-HANDLE(hBufferField) THEN
                    DO:
                        ASSIGN iAttributeEntry = LOOKUP(STRING(hBufferField:POSITION - 1), cacheObject.AttrOrdinals).
                        IF iAttributeEntry GT 0 then
                            ASSIGN cEntry = ENTRY(iAttributeEntry, cacheObject.AttrValues, {&Value-Delimiter}).
                        ELSE
                            ASSIGN cEntry = trim(hBufferField:INITIAL).
                            
                        /* The StartPage attribute is an integer value, and contains a single
                         * page.
                         */
                        IF cEntry NE ? AND cEntry NE "":U AND NOT CAN-DO(pcPageList, cEntry) THEN
                           ASSIGN pcPageList = pcPageList + ",":U + cEntry.
                    END.    /* valid attribute StartPage */
                    
                    pcPageList = left-trim(pcPageList, ',').                                                    
                    
                    /* Make sure page 0 is included. */
                    IF NOT CAN-DO(pcPageList, STRING(0)) THEN
                        ASSIGN pcPageList = STRING(0) + ',' + pcPageList
                               pcPageList = trim(pcPageList, ',').                                                   
                END.    /* page list is all [Init] */
                
                /* Get the page & link information. This excludes the actual
                 * instance information.
                 */
                RUN getObjectData ( INPUT rycso_container.smartObject_obj,      /* container obj */
                                    INPUT dContainerInstanceId,                 /* pdContainerInstanceId */
                                    INPUT (IF AVAILABLE rycla THEN rycla.layout_code ELSE "00":U) ) NO-ERROR.
                IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
                
                /* If the init page list only contains 0 , and there 
                   is at least one page, add page 1 (or whatever the first page is)
                   to the list of initial pages.
                 */
                if lGetInitialPages and
                   pcPageList eq '0' and
                   can-find(first cachePage where
                                  cachePage.InstanceId = dContainerInstanceId and
                                  cachePage.PageNumber > 0 ) then
                do:
                    find first cachePage where
                               cachePage.InstanceId = dContainerInstanceId and
                               cachePage.PageNumber > 0.
                    /* The can-find above tells us that there
                       is a page available, so no need to check 
                       availability.
                     */
                    pcPageList = pcPageList + ',' + string (cachePage.PageNumber).
                end.    /* no start page specified */
            END.    /* available cacheobject */
            
            /* Get all the instances we need. 
             *
             * If there is a value in the InstanceName parameter, use that. If
             * not, build the instance name from the requested pages.
             */
            IF pcInstanceName EQ "":U AND AVAILABLE cacheObject THEN
            DO:
                ASSIGN cInstancesToRetrieve = "":U.
                FOR EACH cachePage WHERE cachePage.InstanceId = dContainerInstanceId:
                    /* Only retrieve instances for those pages that were requested.
                     * If page 0 was requested, there may be more page records than
                     * pages requested (a request for a page means that all the stuff
                     * inside it must be retrieved; a request for page 0 retrieves the
                     * page meta-information).
                     */
                    IF CAN-DO(pcPageList, STRING(cachePage.PageNumber)) THEN
                        /* Since the instance name is unique across a container, we know that
                         * there are no duplicates.
                         */
                        ASSIGN cInstancesToRetrieve = cInstancesToRetrieve + ",":U + cachePage.TOC.
                END.    /* each requested page */
                ASSIGN cInstancesToRetrieve = LEFT-TRIM(cInstancesToRetrieve, ",":U).
            END.    /* this is the page/style request. */
            ELSE
                ASSIGN cInstancesToRetrieve = pcInstanceName.
            
            ASSIGN cContainerName = rycso_container.object_filename.
            
            /* Now we know the instances to retrieve, go and get them.
             */
            DO iInstanceLoop = 1 TO NUM-ENTRIES(cInstancesToRetrieve):
                FIND FIRST rycoi WHERE
                           rycoi.container_smartobject_obj = dSmartobjectObj                        AND
                           rycoi.instance_name             = ENTRY(iInstanceLoop, cInstancesToRetrieve)
                           NO-LOCK NO-ERROR.
                /* The requested instance name may not exist on this customised version, so
                   we cannot return an error.
                 */
                IF NOT AVAILABLE rycoi THEN
                    NEXT.
                
                FIND FIRST rycso_instance WHERE
                           rycso_instance.smartobject_obj = rycoi.smartobject_obj
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
                if not available rycso_instance then
                    next.
                
                ASSIGN cObjectName = rycso_instance.object_filename.
                
                FIND FIRST rycpa WHERE
                           rycpa.page_obj = rycoi.page_obj
                           NO-LOCK NO-ERROR.
                IF AVAILABLE rycpa THEN
                    FIND cachePage WHERE
                         cachePage.InstanceId    = dContainerInstanceId AND
                         cachePage.PageReference = rycpa.page_reference
                         NO-ERROR.
                
                /* Loop through all the requested result codes for this contained
                   instance.
                 */
                INSTANCE-RESULT-CODE-LOOP:
                DO iInstanceResultLoop = 1 TO iNumberOfResultCodes:
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
                        IF ENTRY(iInstanceResultLoop, pcResultCode) EQ "{&DEFAULT-RESULT-CODE}":U THEN
                            ASSIGN dInstanceResultCodeObj = 0.
                        ELSE
                        DO:
                            FIND FIRST ryccr WHERE
                                       ryccr.customization_result_code = ENTRY(iInstanceResultLoop, pcResultCode)
                                       NO-LOCK NO-ERROR.
                            IF NOT AVAILABLE ryccr THEN
                                RETURN ERROR {aferrortxt.i 'AF' '5' 'ryccr' 'customization_result_code' '"result code"' "'Result code:' + ENTRY(iResultCodeLoop, pcResultCode)"}.
                            
                            ASSIGN dInstanceResultCodeObj = ryccr.customization_result_obj.
                        END.    /* there is a result code. */
                                                       
                        /* Find the master object for the object instance.
                         */
                        FIND rycso_instance WHERE
                             rycso_instance.object_filename          = cObjectName    AND
                             rycso_instance.customization_result_obj = dInstanceResultCodeObj
                             NO-LOCK NO-ERROR.
                        IF NOT AVAILABLE rycso_instance THEN
                        DO:
                            IF dInstanceResultCodeObj EQ 0 THEN
                                RETURN ERROR {aferrortxt.i 'AF' '5' 'ryc_smartObject' 'object_filename' '"object"' "'Object name: ' + cObjectName" }.
                            ELSE
                                NEXT INSTANCE-RESULT-CODE-LOOP.
                        END.    /* n/a result code */
                    END.    /* there is customisation in the client session. */
                    
                    /* Get the data for this instance. Object, attribute, event. 
                     * Also recurses so all instances instances are retrieved.
                     */
                    RUN getInstanceData( INPUT cContainerName,
                                         INPUT dContainerInstanceId,
                                         INPUT rycoi.instance_name,
                                         INPUT rycoi.object_instance_obj,
                                         INPUT rycso_instance.object_filename,         /* pcLogicalObjectName */
                                         INPUT rycso_instance.smartobject_obj,
                                         INPUT rycso_instance.object_type_obj,
                                         INPUT rycoi.layout_position,
                                         INPUT (IF AVAILABLE rycpa AND AVAILABLE cachePage THEN cachePage.PageNumber ELSE 0),
                                         INPUT rycoi.object_sequence,
                                         INPUT pdRenderTypeObj,
                                         INPUT pdLanguageObj,
                                         INPUT lApplyTranslations,
                                         INPUT rycso_instance.static_object,
                                         INPUT cSecuredFields,
                                         INPUT cSecuredTokens,
                                         INPUT pcResultCode,                /* All result codes. need these fro recursion. */
                                         INPUT-OUTPUT pcClassesReferenced,
                                         INPUT-OUTPUT pcEntitiesReferenced,
                                         INPUT-OUTPUT pcToolbarsReferenced) NO-ERROR.
                    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
                END.    /* INSTANCE-RESULT-CODE-LOOP: loop through all result codes for the contained instance. */
            END.    /* loop through the requested instances. */
        END.    /* this is a container. */
    END.    /* RESULT-CODE-LOOP: loop backwards through result codes */
    
    /* Build the FolderLabels attribute after all pages have been
     * retrieved. There may be pages added by customisation. We also
     * need to perform translations ON these labels, if translation
     * is enabled.
     * 
     * We need to do this for all objects that have pages. There can be
     * more than one of these, since frame objects can be contained on
     * paged objects, and may themselves be paged.
     *
     * We need to execute this code even if the value of the pdInstanceId
     * parameter is non-zero because there may be pages contained by objects
     * themselves on pages (for instance, a dynamic frame object may be on a particular
     * page and itself have contained pages).
     */
    
    /* The Page link indicates the existence of the folder object */
    FIND FIRST cacheLink WHERE
               cacheLink.InstanceId         = dContainerInstanceId AND
               cacheLink.LinkName           = "Page":U             AND
               cacheLink.TargetInstanceName = "THIS-OBJECT":U
               NO-ERROR.
    IF AVAILABLE cacheLink THEN
    DO:
        /* This is a function call because recursion is required. */
        IF NOT DYNAMIC-FUNCTION("setFolderDetails":U IN TARGET-PROCEDURE,
                                INPUT cacheLink.InstanceId,
                                INPUT cacheLink.SourceInstanceName,
                                INPUT cSecuredTokens,
                                INPUT lApplyTranslations,
                                INPUT pdLanguageObj             ) THEN
            RETURN ERROR {aferrortxt.i 'AF' '40' '?' '?' "'unable to correctly set folder details for ' + pcObjectName " }.
    END.    /* we need to update the folder details. */
    else
    /* If the top-level container has no page link, it may be that it has contained objects that themselves
       contain objects with Page links (eg. DynFrames within DynFrames).
       
       The setFolderDetails() call recurses so if the top-level container has a page link,
       then it will recursively find all contained instances.
     */
    do:
        FOR EACH cacheObject WHERE
                 cacheObject.containerInstanceId = dContainerInstanceId,
            FIRST cacheLink WHERE
                  cacheLink.InstanceId         = cacheObject.InstanceId AND
                  cacheLink.LinkName           = "Page":U               AND
                  cacheLink.TargetInstanceName = "THIS-OBJECT":U:
            /* This is a function call because recursion is required. */
            IF NOT DYNAMIC-FUNCTION("setFolderDetails":U IN TARGET-PROCEDURE,
                                    INPUT cacheLink.InstanceId,
                                    INPUT cacheLink.SourceInstanceName,
                                    INPUT cSecuredTokens,
                                    INPUT lApplyTranslations,
                                    INPUT pdLanguageObj             ) THEN
                RETURN ERROR {aferrortxt.i 'AF' '40' '?' '?' "'unable to correctly set folder details for ' + pcObjectName " }.              
        end.    /* all contained objects */
    end.    /* the top-level object has no Page link. */
    
    ASSIGN pcClassesReferenced  = LEFT-TRIM(pcClassesReferenced, ",":U)
           pcEntitiesReferenced = LEFT-TRIM(pcEntitiesReferenced, ",":U).
    
    /* EOF (ryrepdoori.i) */
