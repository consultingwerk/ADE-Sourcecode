/*--------------------------------------------------------------------------------
  File: rydynsdvvc.i

  Description:  validateClass in rydynsdvcp.p

  Purpose:      This procedure customises the viewer object, before passing it back 
                to the client. This code appears in an inlcude because it blows the
                section editor limits.
                
  Parameters:   These parameters appear here for reference only.
    DEFINE INPUT PARAMETER pcLogicalObjectName          AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pcResultCode                 AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pdUserObj                    AS DECIMAL      NO-UNDO.
    DEFINE INPUT PARAMETER pcRunAttribute               AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pdLanguageObj                AS DECIMAL      NO-UNDO.
    DEFINE INPUT PARAMETER pdInstanceId                 AS DECIMAL      NO-UNDO.


  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   18/06/2002  Author:     Peter Judge

  Update Notes: Created from scratch.
---------------------------------------------------------------------------*/
    DEFINE VARIABLE cContainerName              AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cSecuredTokens              AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cWidgetName                 AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cWidgetType                 AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cFormat                     AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cLabel                      AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cTooltip                    AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cWidth                      AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cFieldName                  AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cDataType                   AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cTableName                  AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cRadioButtons               AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE hObjectBuffer               AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hLocalObjectBuffer          AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hReplicateObjectBuffer      AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hReplicateAttributeBuffer   AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hField                      AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hAttributeBuffer            AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hClassObject                AS HANDLE               NO-UNDO.
    DEFINE VARIABLE lViewerShowPopup            AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE lLocalField                 AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE lEnabled                    AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE lHidden                     AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE lReadOnly                   AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE lForceValidLabel            AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE iRadioLoop                  AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iWidgetCounter              AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iMaxInstanceOrder           AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iFont                       AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iEntry                      AS INTEGER              NO-UNDO.
    DEFINE VARIABLE dRow                        AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dColumn                     AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dMaxRow                     AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dLabelWidth                 AS DECIMAL              NO-UNDO.  
    DEFINE VARIABLE dAddCol                     AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dMinCol                     AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dFirstCol                   AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dMasterInstanceId           AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dInstanceId                 AS DECIMAL              NO-UNDO.  
    DEFINE VARIABLE dWidgetInstanceId           AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE cDataSourceNames            AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cInheritsFromClasses        AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cCurrentNameField           AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cSecuredFields              AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cListItems                  AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cDelimiter                  AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE iCnt                        AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iWhereInList                AS INTEGER              NO-UNDO.
    DEFINE VARIABLE lStripSdoName               AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE cSecurityFieldName          AS CHARACTER            NO-UNDO.

    EMPTY TEMP-TABLE ttTranslate.
    EMPTY TEMP-TABLE ttTransLink.

    /* Get field security.  We run through all the available viewer instances that haven't been secured, and set their securedFields *
     * field.  This field will be used by the client to determine which fields need to be set to READ-ONLY and HIDDEN.               */
    IF NOT VALID-HANDLE(ghQuery1) THEN
        CREATE QUERY ghQuery1.

    /* If the pdInstanceId is passed in then we know that this is the instance of a viewer on 
     * a particular window. If not, then this is the master instance of the viewer. This should
     * only rarely happen in runtime mode (if ever).                                             */
    IF pdInstanceId EQ 0 THEN    
        /* This call has the (intentional) side-effect of repositioning the cache object to this record. */
        DYNAMIC-FUNCTION("isObjectCached":U IN gshRepositoryManager,
                         INPUT pcLogicalObjectName,
                         INPUT pdUserObj,
                         INPUT pcResultCode,
                         INPUT pcRunAttribute,
                         INPUT pdLanguageObj,
                         INPUT NO   ).      /* if we are here then we are never in design mode */

    /* We set the pdInstanceId even though we may have a value. */
    ASSIGN hObjectBuffer = DYNAMIC-FUNCTION("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT pdInstanceId)
           pdInstanceId  = hObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE
           .
    /* We need to get the attribute buffer to be able to identify if the object has already been secured */
    ASSIGN hAttributeBuffer = hObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE.
    hAttributeBuffer:FIND-FIRST(" WHERE ":U + hAttributeBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(pdInstanceId) ) NO-ERROR.

    /* We need this InstanceId because this is how the field-level widget Object instances are 
     * connected to the viewer. If this is a viewer instance, we need to change this value to the
     * pcInstanceID because we have secured/translated for the container on which this viewer 
     * appears, and these actions may not be true for the master viewer.                      
     *
     * We in effect create "instances of instances" - DataField instances of the Viewer instance
     * which differs from the way the data is stored in the Repository - here is it DataField
     * instances of VIewer masters. This is because security (in particular) is applied at the    
     * window (container) level and applies all the way down to the fields on a viewer.             */
    ASSIGN dMasterInstanceId = hObjectBuffer:BUFFER-FIELD("tMasterRecordIdentifier":U):BUFFER-VALUE
           cContainerName    = hObjectBuffer:BUFFER-FIELD("tContainerObjectName"):BUFFER-VALUE
           .
    CREATE BUFFER hLocalObjectBuffer  FOR TABLE hObjectBuffer BUFFER-NAME "viewer_Objects":U.

    /* Get the ShowPopup setting for the viewer. */
    ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("ShowPopup":U) NO-ERROR.
    IF VALID-HANDLE(hField) THEN
        ASSIGN lViewerShowPopup = hField:BUFFER-VALUE. 

    /* Get the DataSourceNames for the viewer. */
    ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("DataSourceNames":U) NO-ERROR.
    IF VALID-HANDLE(hField) THEN
        ASSIGN cDataSourceNames = hField:BUFFER-VALUE. 

    /* Makes life easier for comparisons. */
    IF cDataSourceNames EQ ? THEN
        ASSIGN cDataSourceNames = "":U.

    /* This caters for an empty string or a string with just one SDO name in it.
     * If just one SDO in the SBO is being referenced in this viewer, then we
     * pretend that this is just an SDO-bsed viewer.                            */
    ASSIGN lStripSdoName = NUM-ENTRIES(cDataSourceNames) LE 1.

    /** SECURITY CHECKS 
     *  We check for secured fields and tokens at the container level. 
     *  ----------------------------------------------------------------------- **/
    /* Field security for the container - i.e for the viewer instance */    
    IF cContainerName NE "":U AND cContainerName NE ? AND cContainerName <> pcLogicalObjectName 
    THEN DO:
        RUN fieldSecurityGet IN gshSecurityManager ( INPUT  ?,
                                                     INPUT  cContainerName,
                                                     INPUT  pcRunAttribute,
                                                     OUTPUT cSecuredFields  ).
MESSAGE cContainerName SKIP
        cSecuredFields
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

        /* Tokens are ued to secure buttons, etc. The secured tokens which are 
         * returned by this API are to be disabled.                             */
    
        /* Token security for the viewer master */
        RUN tokenSecurityGet IN gshSecurityManager (INPUT ?,
                                                    INPUT cContainerName,
                                                    INPUT pcRunAttribute,
                                                    OUTPUT cSecuredTokens  ).
    END.

    /** Set the ObjectSecured and ObjectTranslated properties to yes. We do this 
     *  to prevent the translation and security checks from happening more than
     *  once.  Set the TokenSecurity attribute as well for use client side.
     *  ----------------------------------------------------------------------- **/
    ASSIGN hAttributeBuffer:BUFFER-FIELD("ObjectTranslated":U):BUFFER-VALUE = YES
           hAttributeBuffer:BUFFER-FIELD("ObjectSecured":U):BUFFER-VALUE    = YES
           hAttributeBuffer:BUFFER-FIELD("SecuredTokens":U):BUFFER-VALUE    = cSecuredTokens
           NO-ERROR.

    ghQuery1:SET-BUFFERS(hLocalObjectBuffer).
    /* Use a PRESELECT instead of a FOR because we want to be absolutely sure that query result set is the one
     * we expect it to be. We create and find new records in the DO WHILE AVAILABLE ... loop and for safety's
     * sake this is a preselect.                                                                             */
    ghQuery1:QUERY-PREPARE(" PRESELECT EACH ":U + hLocalObjectBuffer:NAME + " WHERE ":U
                         + hLocalObjectBuffer:NAME + ".tContainerRecordIdentifier = " + QUOTER(dMasterInstanceId)    + " AND ":U
                         + hLocalObjectBuffer:NAME + ".tResultCode                = " + QUOTER(pcResultCode)         + " AND ":U
                         + hLocalObjectBuffer:NAME + ".tUserObj                   = " + QUOTER(pdUserObj)            + " AND ":U
                         + hLocalObjectBuffer:NAME + ".tRunAttribute              = " + QUOTER(pcRunAttribute)       + " AND ":U
                         + hLocalObjectBuffer:NAME + ".tLanguageObj               = " + QUOTER(pdLanguageObj)        + " NO-LOCK ":U ).

    ghQuery1:QUERY-OPEN().
    ghQuery1:GET-FIRST().

    ASSIGN dAddCol   = 0
           dMinCol   = 0
           dFirstCol = 0
           .
    IF dMasterInstanceId NE pdInstanceId THEN
        CREATE BUFFER hReplicateObjectBuffer FOR TABLE hObjectBuffer BUFFER-NAME "replicate_Objects":U.

    /** First make sure that all fields have valid values.
     *  ----------------------------------------------------------------------- **/
    DO WHILE hLocalObjectBuffer:AVAILABLE:
        ASSIGN hAttributeBuffer  = hLocalObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE
               iWidgetCounter    = iWidgetCounter + 1
               dWidgetInstanceId = hLocalObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE
               .
        hAttributeBuffer:FIND-FIRST(" WHERE ":U + hAttributeBuffer:NAME + ".tRecordIdentifier = ":U
                                    + QUOTER(dWidgetInstanceId) ) NO-ERROR.

        /* We need to create "instance of instances" here so that security, translation and some other things
         * work properly. See http://icf.possenet.org/issues/show_bug.cgi?id=3793 amongst others. */
        IF dMasterInstanceId NE pdInstanceId THEN
        DO:
            /* Create the object record. */
            hReplicateObjectBuffer:BUFFER-CREATE().
            hReplicateObjectBuffer:BUFFER-COPY(hLocalObjectBuffer, "tRecordIdentifier":U).
            ASSIGN gsdTempUniqueId = gsdTempUniqueId + 1
                   dInstanceId     = gsdTempUniqueId
                   
                   hReplicateObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE          = dInstanceId
                   hReplicateObjectBuffer:BUFFER-FIELD("tContainerRecordIdentifier":U):BUFFER-VALUE = pdInstanceId
                   .
            hReplicateObjectBuffer:BUFFER-RELEASE().

            /* Create the attribute record. */
            CREATE BUFFER hReplicateAttributeBuffer FOR TABLE hAttributeBuffer BUFFER-NAME "replicate_Attribute":U.

            hReplicateAttributeBuffer:BUFFER-CREATE().
            hReplicateAttributeBuffer:BUFFER-COPY(hAttributeBuffer, "tRecordIdentifier":U).
            ASSIGN hReplicateAttributeBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE = dInstanceId.
            hReplicateAttributeBuffer:BUFFER-RELEASE().
            
            DELETE OBJECT hReplicateAttributeBuffer NO-ERROR.
            ASSIGN hReplicateAttributeBuffer = ?.

            /* Create duplicate UI event records. */
            DYNAMIC-FUNCTION("replicateUiEvents":U, INPUT dWidgetInstanceId, INPUT dInstanceId).

            /* Once these records are created, we need to find the new versions. */
            hLocalObjectBuffer:FIND-FIRST(" WHERE ":U + hLocalObjectBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(dInstanceId) ) NO-ERROR.
            hAttributeBuffer:FIND-FIRST(" WHERE ":U + hAttributeBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(dInstanceId) ) NO-ERROR.
        END.    /* this is an instance, and not a master viewer */

        ASSIGN cInheritsFromClasses = hLocalObjectBuffer:BUFFER-FIELD("tInheritsFromClasses":U):BUFFER-VALUE.

        /* Visualisation */
        ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("VisualizationType":U) NO-ERROR.
        IF VALID-HANDLE(hField) THEN
        DO:
            IF hField:BUFFER-VALUE EQ ? OR hField:BUFFER-VALUE EQ "":U THEN
                ASSIGN hField:BUFFER-VALUE = "FILL-IN":U.

            ASSIGN cWidgetType = hField:BUFFER-VALUE.
        END.    /* valid field */
        ELSE
        DO:
            /* If there is no VisualisationType attribute specified then
             * we assume that the object is a static (although still registered
             * in the Repository) object. We thus set the WidgetType to SmartDataField
             * if the DynamicObject field is set to NO or if it doesn't exist. If this
             * object is a dynamic object (and it really shouldn't be if it gets here)
             * then we assume the widget is a fill-in.                                  */
            ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("DynamicObject":U) NO-ERROR.

            IF NOT VALID-HANDLE(hField) OR hField:BUFFER-VALUE EQ NO THEN
                ASSIGN cWidgetType = "SmartDataField":U.
            ELSE
                ASSIGN cWidgetType = "FILL-IN":U.
        END.    /* no visualisation type stored for this class. */

        /* Get the value of the ObjectName first. This attribute contains the
         * value of the INSTANCE_NAME field.                                 */

        /* Take the name of the widget from the ObjectInstanceName field. 
         * the rendere uses the relevant attribute.                        */
        ASSIGN cWidgetName = hLocalObjectBuffer:BUFFER-FIELD("tObjectInstanceName":U):BUFFER-VALUE.

        ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("ObjectName":U) NO-ERROR.
        IF NOT VALID-HANDLE(hField) THEN
            ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("NAME":U) NO-ERROR.
        IF NOT VALID-HANDLE(hField) THEN
            ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("FieldName":U) NO-ERROR.
        IF NOT VALID-HANDLE(hField) THEN
            ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("WidgetName":U) NO-ERROR.

        /* Determine the NAME of the field. */
        IF (cWidgetName EQ "":U OR cWidgetName EQ ?) AND NOT VALID-HANDLE(hField) THEN
        DO:
            ASSIGN cWidgetName = cWidgetType + "-":U + STRING(iWidgetCounter).

            /* If there is a NAME (or related) attribute available for our use, 
             * then we need to assign the derived widget name to that attribute. */
            IF VALID-HANDLE(hField) THEN
                ASSIGN hField:BUFFER-VALUE = cWidgetName.
        END.    /* No NAME determined yet. */

        /** For backwards compatibility, we need to ensure that the ObjectName is actually
         *  the value that we want it to be. Older viewers (constructed either with the
         *  Object Generator or the AppBuilder) may have instances on them where the 
         *  instance names are not equivalent to the relevant name attribute.
         *
         *  (1) For viewers generated by the object generator, the instance name of contained
         *      DataFields may be of the format TableName(space)FieldName. We assume that the
         *      fieldname portion of this is the piece we want to use, and strip off the TableName.
         *
         *  (2) For SDFs (dyn lookups and/or dyn combos) added by the AppBuilder, the instance name
         *      may take the format of H_DYNLOOKUP* or H_DYNCOMBO*. If this is the case, then
         *      we use the value of the FieldName attribute and assign it to the ObjectName.
         *
         *  (3) There may be cases where the instance name is SDOName.Fieldname for DataFields
         *      contained by viewers. If this viewer is running against an SDO then we strip off 
         *      the SdoName part. If this viewer is running against an SBO we check whether the
         *      SdoName is part of the DataSourceNames. If it is,then we leave things alone.
         *      If not, then we remove the SdoName.
         *  ----------------------------------------------------------------------- **/
        IF VALID-HANDLE(hField) THEN
            ASSIGN cCurrentNameField = hField:NAME.
        
        ASSIGN cSecurityFieldName = "":U.

        /* Make sure SDFs are OK. */
        IF CAN-DO(cInheritsFromClasses, "DynLookup":U) AND cWidgetName BEGINS "h_dynlookup":U THEN
        DO:
            ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("FieldName":U) NO-ERROR.
            IF VALID-HANDLE(hField) THEN
                ASSIGN cWidgetName = hField:BUFFER-VALUE.
        END.    /* DynLookups  */
        ELSE
        IF CAN-DO(cInheritsFromClasses, "DynCombo":U) AND cWidgetName BEGINS "h_dyncombo":U THEN
        DO:
            ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("FieldName":U) NO-ERROR.
            IF VALID-HANDLE(hField) THEN
                ASSIGN cWidgetName = hField:BUFFER-VALUE.
        END.    /* DynCombos  */
        ELSE
        /* For widgets that are not DynLookups or DynCombos */
        DO:
            /* Always take the second entry of TableName(space)FieldName */
            IF NUM-ENTRIES(cWidgetName, " ":U) EQ 2 THEN
                ASSIGN cWidgetName = ENTRY(2, cWidgetName, " ":U).
            ELSE DO:
                /* Assume that an instance name of "XXX.YYY" means "TableName.FieldName". */
                IF NUM-ENTRIES(cWidgetName, ".":U) EQ 2 
                THEN DO:
                    /* Security ALWAYS uses the unqualified field name */
                    ASSIGN cSecurityFieldName = ENTRY(2, cWidgetName, ".":U).

                    IF (lStripSdoName OR NOT CAN-DO(cDataSourceNames, ENTRY(1, cWidgetName, ".":U)) ) THEN
                        ASSIGN cWidgetName = ENTRY(2, cWidgetName, ".":U) NO-ERROR.
                END.
            END.
        END.    /* non-SDF widgets */

        IF cSecurityFieldName = "":U THEN
            ASSIGN cSecurityFieldName = cWidgetName.

        /* Once we have cleaned up the widget name, assign it back to the attribute table. */
        ASSIGN hField = hAttributeBuffer:BUFFER-FIELD(cCurrentNameField) NO-ERROR.
        IF VALID-HANDLE(hField) THEN
            ASSIGN hField:BUFFER-VALUE = cWidgetName.        

        /* Table Name */
        ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("TableName":U) NO-ERROR.
        ASSIGN lLocalField = VALID-HANDLE(hField).

        IF VALID-HANDLE(hField) THEN
            ASSIGN cTableName = hField:BUFFER-VALUE.
        ELSE
            ASSIGN cTableName = "":U.

        /* Tab Order */
        ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("Order":U) NO-ERROR.
        IF VALID-HANDLE(hField) THEN
        DO:
            IF hField:BUFFER-VALUE EQ ? THEN
                ASSIGN hField:BUFFER-VALUE = 0.

            ASSIGN iMaxInstanceOrder = MAX(iMaxInstanceOrder, hField:BUFFER-VALUE).
        END.    /* Tab order */

        /* If we have auto-attached and SDF to a local fill-in, we need to set the FieldName attribute 
         * to "<Local>", so that we know which property to store that handle in.                       */
        IF CAN-DO(cInheritsFromClasses, "Field":U) THEN
        DO:
            /* This is local widget */
            IF lLocalField THEN
                ASSIGN cFieldName = "<":U + TRIM(cWidgetName) + ">":U.
            ELSE
                ASSIGN cFieldName = cWidgetName.

            ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("FieldName":U) NO-ERROR.
            IF VALID-HANDLE(hField) THEN
                ASSIGN hField:BUFFER-VALUE = cFieldName.
        END.    /* SDF  */

        /* Data Type */
        ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("DATA-TYPE":U) NO-ERROR.
        IF VALID-HANDLE(hField) THEN
        DO:
            IF hField:BUFFER-VALUE EQ "":U OR hField:BUFFER-VALUE EQ ? THEN
                ASSIGN hField:BUFFER-VALUE = "CHARACTER":U.

            ASSIGN cDataType = hField:BUFFER-VALUE.
        END.    /* data type */
        ELSE
            ASSIGN cDataType = "CHARACTER":U.

        /* Font. The font may be needed to calculate the width of the widget. */
        ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("FONT":U) NO-ERROR.
        IF VALID-HANDLE(hField) THEN
            ASSIGN iFont = hField:BUFFER-VALUE.
        ELSE
            ASSIGN iFont = ?.

        /* Widget Label */
        ASSIGN cLabel = "":U
               hField = hAttributeBuffer:BUFFER-FIELD("LABELS":U)
               NO-ERROR.
        IF ( VALID-HANDLE(hField) AND hField:BUFFER-VALUE ) OR
           NOT VALID-HANDLE(hField)                             THEN
        DO:
            /* If there is a LABELS attribute, assume that there should
             * always be a label unless the vlaue of the LABELS attribute is
             * explicitly set to NO. If there is no LABELS attribute, then 
             * we assume that a blank or null label is allowed.             */
            ASSIGN lForceValidLabel = VALID-HANDLE(hField).

            /* Force NO-LABEL by setting the LABELS property correctly.
             * If there is no LABELS attribute then we need to set the value
             * of the label to null (?).                                     */
            IF CAN-DO("{&FORCE-NO-LABEL-TYPES}":U, cWidgetType) AND
               VALID-HANDLE(hField)                             THEN
                ASSIGN hField:BUFFER-VALUE = NO.
            ELSE
            DO:
                IF CAN-DO(cInheritsFromClasses, "Field":U) THEN
                    ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("FieldLabel":U) NO-ERROR.            
                ELSE
                    ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("LABEL":U) NO-ERROR.
    
                IF VALID-HANDLE(hField) THEN
                DO:
                    IF CAN-DO("{&FORCE-NO-LABEL-TYPES}":U, cWidgetType) THEN
                        ASSIGN hField:BUFFER-VALUE = ?.
                    ELSE
                    IF lForceValidLabel THEN
                    DO:
                        IF hField:BUFFER-VALUE EQ ? OR hField:BUFFER-VALUE EQ "":U THEN
                            ASSIGN hField:BUFFER-VALUE = REPLACE(cWidgetName, "_":U, " ":U)
                                   hField:BUFFER-VALUE = REPLACE(cWidgetName, "-":U, " ":U).
                    END.    /* Make sure that there is a label */

                    ASSIGN cLabel = hField:BUFFER-VALUE.
                    
                    /* Strip off any colons. */
                    ASSIGN cLabel = RIGHT-TRIM(cLabel, ":":U).
                    
                    /* ... and assign back to the attribute buffer  */
                    ASSIGN hField:BUFFER-VALUE = cLabel.
                END.    /* is a label field available */
            END.    /* widget needs a label */
        END.    /* use a label */

        /* Format */
        ASSIGN cFormat = "":U
               hField  = hAttributeBuffer:BUFFER-FIELD("Format":U)
               NO-ERROR.
        IF VALID-HANDLE(hField) THEN
        DO:
            IF hField:BUFFER-VALUE EQ "":U OR hField:BUFFER-VALUE EQ ? THEN
                /* These default formats are the same as the Progress data type default formats. */
                CASE cWidgetType:
                    WHEN "CHARACTER":U THEN ASSIGN hField:BUFFER-VALUE = "x(8)":U.
                    WHEN "DECIMAL":U   THEN ASSIGN hField:BUFFER-VALUE = "->>,>>9.99":U.
                    WHEN "INTEGER":U   THEN ASSIGN hField:BUFFER-VALUE = "->,>>>,>>9":U.
                    WHEN "DATE":U      THEN ASSIGN hField:BUFFER-VALUE = "99/99/9999":U.
                    WHEN "LOGICAL":U   THEN ASSIGN hField:BUFFER-VALUE = "YES/NO":U.
                END CASE.   /* data type */

            ASSIGN cFormat = hField:BUFFER-VALUE.
        END.    /* valid format */
        ELSE
            CASE cWidgetType:
                WHEN "CHARACTER":U THEN ASSIGN cFormat = "x(8)":U.
                WHEN "DECIMAL":U   THEN ASSIGN cFormat = "->>,>>9.99":U.
                WHEN "INTEGER":U   THEN ASSIGN cFormat = "->,>>>,>>9":U.
                WHEN "DATE":U      THEN ASSIGN cFormat = "99/99/9999":U.
                WHEN "LOGICAL":U   THEN ASSIGN cFormat = "YES/NO":U.
            END CASE.   /* data type */

        /* Height */
        ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("HEIGHT-CHARS":U) NO-ERROR.
        IF VALID-HANDLE(hField) THEN
        DO:
            IF hField:BUFFER-VALUE EQ ? OR hField:BUFFER-VALUE EQ 0 THEN
                ASSIGN hField:BUFFER-VALUE = 1.
        END.    /* height */

        /* Width */
        ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("WIDTH-CHARS":U) NO-ERROR.
        IF VALID-HANDLE(hField) THEN
        DO:
            /* Default the width to the format size if none is specified. */
            IF hField:BUFFER-VALUE = 0 OR hField:BUFFER-VALUE = ? THEN
            DO:
                /* Reget the WIDTH-CHARS field */
                ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("WIDTH-CHARS":U) NO-ERROR.

                CASE cDataType:
                    WHEN "CHARACTER":U THEN
                    DO:
                        /* If the format is of type 'x(n)', then */
                        IF INDEX(cFormat, "(":U) NE 0 THEN
                        DO:
                            ASSIGN cWidth = SUBSTRING(cFormat, INDEX(cFormat, "(":U ) + 1).
                            ASSIGN cWidth = SUBSTRING(cWidth, 1, R-INDEX(cWidth, ")":U) - 1).

                            ASSIGN hField:BUFFER-VALUE = FONT-TABLE:GET-TEXT-WIDTH-CHARS(FILL("w":U, INTEGER(cWidth)), iFont) NO-ERROR.
                        END.    /* format x(n) type */
                        ELSE
                            ASSIGN hField:BUFFER-VALUE = FONT-TABLE:GET-TEXT-WIDTH-CHARS(cFormat, iFont).
                    END.    /* character */
                    WHEN "LOGICAL":U THEN
                        ASSIGN hField:BUFFER-VALUE = FONT-TABLE:GET-TEXT-WIDTH-CHARS(IF LENGTH(ENTRY(1, cFormat, "/":U)) GE LENGTH(ENTRY(2, cFormat, "/":U)) THEN
                                                                                    ENTRY(1, cFormat, "/":U)
                                                                                 ELSE
                                                                                    ENTRY(2, cFormat, "/":U)
                                                                                 , iFont) NO-ERROR.
                    OTHERWISE
                        ASSIGN hField:BUFFER-VALUE = FONT-TABLE:GET-TEXT-WIDTH-CHARS(cFormat, iFont).
                END CASE.   /* data type */
            END.    /* invalid width */
        END.    /* width */

        /* Tooltip */
        IF CAN-DO(cInheritsFromClasses, "Field":U) THEN
            ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("FieldTooltip":U) NO-ERROR.
        ELSE
            ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("TOOLTIP":U) NO-ERROR.

        IF VALID-HANDLE(hField) THEN
        DO:
            IF hField:BUFFER-VALUE EQ ? THEN
                ASSIGN hField:BUFFER-VALUE = "":U.
            ASSIGN cTooltip = hField:BUFFER-VALUE.
        END.    /* Tooltip */

        /* ROW */
        ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("ROW":U) NO-ERROR.
        IF VALID-HANDLE(hField) THEN
        DO:
            IF hField:BUFFER-VALUE EQ ? THEN
                ASSIGN hField:BUFFER-VALUE = 0.

            ASSIGN dMaxRow = MAX(dMaxRow, hField:BUFFER-VALUE)
                   
                   hLocalObjectBuffer:BUFFER-FIELD("tLayoutPosition":U):BUFFER-VALUE = STRING(hField:BUFFER-VALUE).
        END.    /* ROW */
        ELSE
            ASSIGN hLocalObjectBuffer:BUFFER-FIELD("tLayoutPosition":U):BUFFER-VALUE = "?":U.

        /* Column */
        ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("COLUMN":U) NO-ERROR.
        IF VALID-HANDLE(hField) THEN
        DO:
            /* If there is no column specified, put the  field on the left-hand side of the viewer. */
            IF hField:BUFFER-VALUE EQ ? OR hField:BUFFER-VALUE EQ 0 THEN
                ASSIGN hField:BUFFER-VALUE = dLabelWidth + 1.

            ASSIGN hLocalObjectBuffer:BUFFER-FIELD("tLayoutPosition":U):BUFFER-VALUE = hLocalObjectBuffer:BUFFER-FIELD("tLayoutPosition":U):BUFFER-VALUE
                                                                                 + ",":U + STRING(hField:BUFFER-VALUE).
        END.    /* Column */
        ELSE
            ASSIGN hLocalObjectBuffer:BUFFER-FIELD("tLayoutPosition":U):BUFFER-VALUE = hLocalObjectBuffer:BUFFER-FIELD("tLayoutPosition":U):BUFFER-VALUE
                                                                                 + ",?":U.
        /** Security
         *  ----------------------------------------------------------------------- **/
        IF cTableName EQ "":U OR cTableName EQ ? THEN
            ASSIGN cFieldName = cWidgetName.
        ELSE
            ASSIGN cFieldName = cTableName + ".":U + cWidgetName.

        IF (cFieldName NE "":U
        OR CAN-DO(cInheritsFromClasses, "DynLookup":U) /* cWidgetName will be the name of the parent field, we check security against that */
        OR CAN-DO(cInheritsFromClasses, "DynCombo":U))   /* cWidgetName will be the name of the parent field, we check security against that */
        AND NOT CAN-DO(cInheritsFromClasses, "DynText":U)  /* We don't check security for text widgets */
        THEN DO:
            /* These variables are set to default values only to be able to 
             * determine if they have changed. Only if the values have changed 
             * are they set for the widgets.                                   */
            ASSIGN lEnabled  = YES
                   lReadOnly = NO
                   lHidden   = NO.

            /* Field security */
            ASSIGN iWhereInList = LOOKUP(cSecurityFieldName, cSecuredFields). /* We don't want a qualified field name */
            IF iWhereInList GT 0 THEN
            DO:
                IF ENTRY(iWhereInList + 1, cSecuredFields) EQ "Read Only":U THEN
                    ASSIGN lReadOnly = YES.
                ELSE
                    ASSIGN lHidden = YES.
            END.    /* secured field. */
            
            /* Token security */
            IF CAN-DO(cSecuredTokens, cSecurityFieldName) THEN
                ASSIGN lEnabled = NO.

            IF NOT lEnabled THEN
            DO:
                IF CAN-DO(cInheritsFromClasses, "Field":U) THEN
                    ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("EnableField":U) NO-ERROR.
                ELSE
                    ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("ENABLED":U) NO-ERROR.

                IF VALID-HANDLE(hField) THEN
                    ASSIGN hField:BUFFER-VALUE = NO
                           hLocalObjectBuffer:BUFFER-FIELD("tSecuredDisabled":U):BUFFER-VALUE = YES
                           .
            END.    /* not enabled */

            IF lReadOnly THEN
            DO:
                ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("READ-ONLY":U) NO-ERROR.
                IF VALID-HANDLE(hField) THEN /* will be false for dynLookups and dynCombos */
                    ASSIGN hField:BUFFER-VALUE = YES.

                ASSIGN hLocalObjectBuffer:BUFFER-FIELD("tSecuredReadOnly":U):BUFFER-VALUE = YES.
            END.    /* Read Only */

            IF lHidden THEN
            DO:
                ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("VISIBLE":U) NO-ERROR.
                IF VALID-HANDLE(hField) THEN /* will be false for dynLookups and dynCombos */
                    ASSIGN hField:BUFFER-VALUE = NO.

                ASSIGN hLocalObjectBuffer:BUFFER-FIELD("tSecuredHidden":U):BUFFER-VALUE = YES.
            END.    /* Hidden */
        END.    /* field name exists. */

        /** Delimiters. We try to avoid issues where the decimal point and the delimiter
         *  of the widget are the same.
         *  ----------------------------------------------------------------------- **/
        IF CAN-DO("{&WIDGETS-WITH-DELIMITERS}":U, cWidgetType) THEN
            ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("DELIMITER":U) NO-ERROR.
        ELSE
            ASSIGN hField = ?.
        IF VALID-HANDLE(hField) THEN
        DO:
            IF cDataType                     EQ "DECIMAL":U         AND
               SESSION:NUMERIC-DECIMAL-POINT EQ hField:BUFFER-VALUE THEN
                ASSIGN hField:BUFFER-VALUE = CHR(3).

            ASSIGN cDelimiter = hField:BUFFER-VALUE.
        END.    /* has a delimiter. */

        /** Perform any further Class-related actions by running validateClassData.
         *  This will typically be run for SDFs like DynLookups and DynCombos, although
         *  we don't want to restrict ourselves to those classes only.
         *  --------------------------------------------------------------------------- **/
        ASSIGN hClassObject = DYNAMIC-FUNCTION("launchClassObject":U IN gshRepositoryManager,
                                               INPUT hLocalObjectBuffer:BUFFER-FIELD("tClassName":U):BUFFER-VALUE ).
        IF VALID-HANDLE(hClassObject) AND LOOKUP("validateClassData":U, hClassObject:INTERNAL-ENTRIES) GT 0 THEN
        DO:
            /* Pass in all parameters anyway, but the tRecordIdentifier is going to be used to find the correct record. */
            RUN validateClassData IN hClassObject ( INPUT hLocalObjectBuffer:BUFFER-FIELD("tLogicalObjectName":U):BUFFER-VALUE,
                                                    INPUT pcResultCode,
                                                    INPUT pdUserObj,
                                                    INPUT pcRunAttribute,
                                                    INPUT pdLanguageObj,
                                                    INPUT hLocalObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE ) NO-ERROR.
        END.    /* can run validateClassData(). */

        /** Translations
         *  ----------------------------------------------------------------------- **/
        CASE cWidgetType:
            WHEN "SELECTION-LIST":U OR WHEN "COMBO-BOX":U THEN
            DO:
                /* Only translate list-item-pairs since we do not want to translate
                 * the key values, only the displayed labels.                       */
                ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("LIST-ITEM-PAIRS":U) NO-ERROR.
                IF VALID-HANDLE(hField) THEN
                DO:
                    ASSIGN cListItems = hField:BUFFER-VALUE.

                    /* Make sure there's something there. */
                    IF cListItems NE ? AND NUM-ENTRIES(cListItems, cDelimiter) GE 2 THEN
                    DO:
                        DO iRadioLoop = 1 TO NUM-ENTRIES(cListItems, cDelimiter) BY 2:
                            CREATE ttTranslate.
                            ASSIGN ttTranslate.dLanguageObj       = 0
                                   ttTranslate.cObjectName        = pcLogicalObjectName
                                   ttTranslate.lGlobal            = NO
                                   ttTranslate.lDelete            = NO
                                   ttTranslate.cWidgetType        = cWidgetType
                                   ttTranslate.cWidgetName        = cWidgetName
                                   ttTranslate.hWidgetHandle      = ?
                                   ttTranslate.iWidgetEntry       = (iRadioLoop + 1) / 2
                                   ttTranslate.cOriginalLabel     = ENTRY(iRadioLoop, cListItems, cDelimiter)
                                   ttTranslate.cTranslatedLabel   = "":U
                                   ttTranslate.cOriginalTooltip   = "":U    /* tooltip is translated by the object itself. */
                                   ttTranslate.cTranslatedTooltip = "":U.
                            /* Create a link record so that we can quickly get the relevant cahce_Object record. */
                            CREATE ttTransLink.
                            ASSIGN ttTransLink.tWidgetName       = ttTranslate.cWidgetName
                                   ttTransLink.tWidgetEntry      = ttTranslate.iWidgetEntry
                                   ttTransLink.tRecordIdentifier = hLocalObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE.
                        END.    /* list item pairs loop */
                    END.    /* There is data to translate. */
                END.    /* there is a LIST-ITEM-PAIRS field. */

                /* Also translate the Label. */
                CREATE ttTranslate.
                ASSIGN ttTranslate.dLanguageObj       = 0
                       ttTranslate.cObjectName        = pcLogicalObjectName + (IF CAN-DO(cInheritsFromClasses, "Field":U) THEN ":":U + cWidgetName ELSE "":U)
                       ttTranslate.lGlobal            = NO
                       ttTranslate.lDelete            = NO
                       ttTranslate.cWidgetType        = cWidgetType
                       ttTranslate.cWidgetName        = cWidgetName
                       ttTranslate.hWidgetHandle      = ?
                       ttTranslate.iWidgetEntry       = 0
                       ttTranslate.cOriginalLabel     = cLabel
                       ttTranslate.cTranslatedLabel   = "":U
                       ttTranslate.cOriginalTooltip   = cTooltip
                       ttTranslate.cTranslatedTooltip = "":U.
                /* Create a link record so that we can quickly get the relevant cahce_Object record. */
                CREATE ttTransLink.
                ASSIGN ttTransLink.tWidgetName       = ttTranslate.cWidgetName
                       ttTransLink.tWidgetEntry      = ttTranslate.iWidgetEntry
                       ttTransLink.tRecordIdentifier = hLocalObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE.
            END.    /* Combo box. */
            WHEN "RADIO-SET":U THEN
            DO:
                ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("RADIO-BUTTONS":U) NO-ERROR.
                IF VALID-HANDLE(hField) THEN
                DO:
                    ASSIGN cRadioButtons = hField:BUFFER-VALUE.
        
                    DO iRadioLoop = 1 TO NUM-ENTRIES(cRadioButtons) BY 2:
                        CREATE ttTranslate.
                        ASSIGN ttTranslate.dLanguageObj       = 0
                               ttTranslate.cObjectName        = pcLogicalObjectName
                               ttTranslate.lGlobal            = NO
                               ttTranslate.lDelete            = NO
                               ttTranslate.cWidgetType        = cWidgetType
                               ttTranslate.cWidgetName        = cWidgetName
                               ttTranslate.hWidgetHandle      = ?
                               ttTranslate.iWidgetEntry       = (iRadioLoop + 1) / 2
                               ttTranslate.cOriginalLabel     = ENTRY(iRadioLoop, cRadioButtons)
                               ttTranslate.cTranslatedLabel   = "":U
                               ttTranslate.cOriginalTooltip   = cTooltip
                               ttTranslate.cTranslatedTooltip = "":U
                               .           
        
                        /* Create a link record so that we can quickly get the relevant cahce_Object record. */
                        CREATE ttTransLink.
                        ASSIGN ttTransLink.tWidgetName       = ttTranslate.cWidgetName
                               ttTransLink.tWidgetEntry      = ttTranslate.iWidgetEntry
                               ttTransLink.tRecordIdentifier = hLocalObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE
                               .
                    END.    /* radio button loop */
                END.    /* has radio buttons */
            END.    /* radio sets */
            OTHERWISE
            DO:
                CREATE ttTranslate.
                ASSIGN ttTranslate.dLanguageObj       = 0
                       ttTranslate.cObjectName        = pcLogicalObjectName + (IF CAN-DO(cInheritsFromClasses, "Field":U) THEN ":":U + cWidgetName ELSE "":U)
                       ttTranslate.lGlobal            = NO
                       ttTranslate.lDelete            = NO
                       ttTranslate.cWidgetType        = cWidgetType
                       ttTranslate.cWidgetName        = cWidgetName
                       ttTranslate.hWidgetHandle      = ?
                       ttTranslate.iWidgetEntry       = 0
                       ttTranslate.cOriginalLabel     = cLabel
                       ttTranslate.cTranslatedLabel   = "":U
                       ttTranslate.cOriginalTooltip   = cTooltip
                       ttTranslate.cTranslatedTooltip = "":U.
                /* We do not store translations for DynLookup and DynCombos as Type 'SmartDataField' - 
                   change them for translation, but change them back after translation */
                IF cWidgetType = "SmartDataField":U THEN DO:
                   IF CAN-DO(cInheritsFromClasses, "DynLookup":U) THEN
                       ASSIGN ttTranslate.cWidgetType = "FILL-IN":U
                              ttTranslate.cWidgetName = "fiLookup":U.
                   IF CAN-DO(cInheritsFromClasses, "DynCombo":U) THEN
                       ASSIGN ttTranslate.cWidgetType = "COMBO-BOX":U
                              ttTranslate.cWidgetName = "fiCombo":U.
                 END.
                
                 /* Create a link record so that we can quickly get the relevant cahce_Object record. */
                CREATE ttTransLink.
                ASSIGN ttTransLink.tWidgetName       = ttTranslate.cWidgetName
                       ttTransLink.tWidgetEntry      = ttTranslate.iWidgetEntry
                       ttTransLink.tRecordIdentifier = hLocalObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE.
            END. /* not a radio-set */
        END CASE.   /* Widget type */
        /** Popups.
         *  If the viewer ShowPopup is NO, then there should be no popups on this viewer.
         *  The popups will be created  by the dynamic viewer.
         *  ----------------------------------------------------------------------- **/
        IF NOT lViewerShowPopup THEN
        DO:
            ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("ShowPopup":U) NO-ERROR.
            IF VALID-HANDLE(hField) THEN
                ASSIGN hField:BUFFER-VALUE = NO.
        END.    /* no viewer popups. */
        ELSE
        DO:
            /* Even if the value has been set, we only use popups in certain
             * circumstances.                                                */
            ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("ShowPopup":U) NO-ERROR.
            IF VALID-HANDLE(hField) AND hField:BUFFER-VALUE THEN
            DO:
                IF NOT CAN-DO("DECIMAL,INTEGER,DATE":U, cDataType) THEN
                    ASSIGN hField:BUFFER-VALUE = NO.
                ELSE
                IF cDataType   EQ "DECIMAL":U    AND
                   cWidgetName MATCHES "*_obj":U THEN
                    ASSIGN hField:BUFFER-VALUE = NO.
            END.    /* can use ShowPopup */
        END.    /* can use ShowPopup  */

        ghQuery1:GET-NEXT().
    END.    /* each object on the viewer. */
    /* Get the translated strings. */
    RUN multiTranslation IN gshTranslationManager ( INPUT NO, INPUT-OUTPUT TABLE ttTranslate) NO-ERROR.
    
    /* There will usually only be on entry in this TT. Radio
     * sets are the exception.                               */
    FOR EACH ttTranslate,
       FIRST ttTransLink WHERE
             ttTransLink.tWidgetName  = ttTranslate.cWidgetName AND
             ttTransLink.tWidgetEntry = ttTranslate.iWidgetEntry    :

        IF NUM-ENTRIES(ttTranslate.cObjectName,":":U) > 1 THEN
          ASSIGN ttTranslate.cWidgetType = "SmartDataField":U
                 ttTranslate.cWidgetName = ENTRY(2,ttTranslate.cObjectName,":":U)
                 ttTransLink.tWidgetName = ttTranslate.cWidgetName.

        hLocalObjectBuffer:FIND-FIRST(" WHERE ":U + hLocalObjectBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(ttTransLink.tRecordIdentifier) ) NO-ERROR.

        hAttributeBuffer = hLocalObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE NO-ERROR.
        hAttributeBuffer:FIND-FIRST(" WHERE ":U + hAttributeBuffer:NAME + ".tRecordIdentifier = ":U
                                    + QUOTER(hLocalObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE) ) NO-ERROR.

        CASE ttTranslate.cWidgetType:
            WHEN "SmartDataField":U THEN
            DO:
                IF ttTranslate.cTranslatedLabel NE "":U AND ttTranslate.cTranslatedLabel NE ? THEN
                DO:
                    ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("FieldLabel":U) NO-ERROR.
                    IF VALID-HANDLE(hField) THEN
                        ASSIGN hField:BUFFER-VALUE = ttTranslate.cTranslatedLabel.
                END.    /* Label has a value. */

                IF ttTranslate.cTranslatedTooltip NE "":U AND ttTranslate.cTranslatedTooltip NE ? THEN
                DO:
                    ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("FieldTooltip":U) NO-ERROR.
                    IF VALID-HANDLE(hField) THEN
                        ASSIGN hField:BUFFER-VALUE = ttTranslate.cTranslatedTooltip.
                END.    /* Tooltip has a value. */
            END.    /* SDF */                   
            WHEN "RADIO-SET":U THEN
            DO:
                IF ttTranslate.cTranslatedLabel NE "":U AND ttTranslate.cTranslatedLabel NE ? THEN
                DO:
                    ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("RADIO-BUTTONS":U) NO-ERROR.
                    IF VALID-HANDLE(hField) THEN
                    DO:
                        ASSIGN cRadioButtons = hField:BUFFER-VALUE
                               iEntry        = (ttTranslate.iWidgetEntry * 2) - 1
                               .
                        IF ttTranslate.cTranslatedLabel <> "":U THEN
                            ENTRY(iEntry, cRadioButtons) = ttTranslate.cTranslatedLabel.

                        ASSIGN hField:BUFFER-VALUE = cRadioButtons.
                    END.    /* radio buttons */
                END.    /* translated label has a value */

                IF ttTranslate.cTranslatedTooltip NE "":U AND ttTranslate.cTranslatedTooltip NE ? THEN
                DO:
                    ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("TOOLTIP":U) NO-ERROR.
                    IF VALID-HANDLE(hField) THEN
                        ASSIGN hField:BUFFER-VALUE = ttTranslate.cTranslatedTooltip.
                END.    /* translated tooltip has a value */
            END.    /* RADIO-SET */
            WHEN "SELECTION-LIST":U OR WHEN "COMBO-BOX":U THEN
            DO:
                IF ttTranslate.cTranslatedLabel NE "":U AND ttTranslate.cTranslatedLabel NE ? THEN
                DO:
                    IF ttTranslate.iWidgetEntry EQ 0 THEN
                    DO:
                        ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("LABEL":U) NO-ERROR.
                        IF VALID-HANDLE(hField) THEN
                            ASSIGN hField:BUFFER-VALUE = ttTranslate.cTranslatedLabel.
                    END.    /* object itself. */
                    ELSE
                    DO:
                        ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("DELIMITER":U) NO-ERROR.
                        IF VALID-HANDLE(hField) THEN
                            ASSIGN cDelimiter = hField:BUFFER-VALUE.
    
                        /* Default to comma */
                        IF NOT VALID-HANDLE(hField) OR cDelimiter = ? THEN
                            ASSIGN cDelimiter = ",":U.
    
                        ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("LIST-ITEM-PAIRS":U) NO-ERROR.
                        IF VALID-HANDLE(hField) THEN                        
                            ASSIGN cListItems = hField:BUFFER-VALUE
                                   iEntry     = (ttTranslate.iWidgetEntry * 2) - 1
                                   
                                   ENTRY(iEntry, cListItems, cDelimiter) = ttTranslate.cTranslatedLabel
                                   
                                   hField:BUFFER-VALUE = cListItems.                        
                    END.    /* items */
                END.    /* translated label has a value */

                /* Only take the tooltip from the obejct itself, not any of the items. */
                IF ttTranslate.cTranslatedTooltip NE "":U AND ttTranslate.cTranslatedTooltip NE ? AND
                   ttTranslate.iWidgetEntry                                                  EQ 0 THEN
                DO:
                    ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("TOOLTIP":U) NO-ERROR.
                    IF VALID-HANDLE(hField) THEN
                        ASSIGN hField:BUFFER-VALUE = ttTranslate.cTranslatedTooltip.
                END.    /* translated tooltip has a value */
            END.    /* selection-list or combo-box. */
            OTHERWISE
            DO:
                IF ttTranslate.cTranslatedLabel NE "":U AND ttTranslate.cTranslatedLabel NE ? THEN
                DO:                                        
                    ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("LABEL":U) NO-ERROR.
                    IF VALID-HANDLE(hField) THEN
                        ASSIGN hField:BUFFER-VALUE = ttTranslate.cTranslatedLabel.
                END.    /* translated label has a value */

                IF ttTranslate.cTranslatedTooltip NE "":U AND ttTranslate.cTranslatedTooltip NE ? THEN
                DO:
                    ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("TOOLTIP":U) NO-ERROR.
                    IF VALID-HANDLE(hField) THEN
                        ASSIGN hField:BUFFER-VALUE = ttTranslate.cTranslatedTooltip.
                END.    /* translated tooltip has a value */
            END.    /* others */
        END CASE.   /* widget type */
        
        /** Mark the field to indicate that we have translated it **/
        IF ttTranslate.cTranslatedLabel NE "":U AND ttTranslate.cTranslatedLabel NE ? THEN
          hLocalObjectBuffer:BUFFER-FIELD("tObjectTranslated":U):BUFFER-VALUE = TRUE.
    END.    /* each ttTranslate. */
   
    /** Make sure that all widgets have an order, a row and a column.
     *  Also make sure that the viewer still looks OK after translating things.
     *  ----------------------------------------------------------------------- **/
    ghQuery1:GET-FIRST().
    DO WHILE hLocalObjectBuffer:AVAILABLE:
        ASSIGN hAttributeBuffer = hLocalObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE
               iWidgetCounter   = iWidgetCounter + 1
               .
        hAttributeBuffer:FIND-FIRST(" WHERE ":U + hAttributeBuffer:NAME + ".tRecordIdentifier = ":U
                                    + QUOTER(hLocalObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE)) NO-ERROR.

        IF hLocalObjectBuffer:BUFFER-FIELD("tInstanceOrder":U):BUFFER-VALUE EQ 0 THEN
            ASSIGN iMaxInstanceOrder                                                = iMaxInstanceOrder + 1
                   hLocalObjectBuffer:BUFFER-FIELD("tInstanceOrder":U):BUFFER-VALUE = iMaxInstanceOrder
                   .
        ghQuery1:GET-NEXT().
    END.    /* order */
    ghQuery1:QUERY-CLOSE().
    
    DELETE OBJECT hReplicateObjectBuffer NO-ERROR.
    DELETE OBJECT hLocalObjectBuffer NO-ERROR.

    ASSIGN hLocalObjectBuffer     = ?
           hReplicateObjectBuffer = ?
           hField                 = ?
           .
    /* EOF */
