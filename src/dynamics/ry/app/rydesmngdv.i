/*---------------------------------------------------------------------------------
  File: rydesmngdv.i

  Description:  Generate Dynamic Viewer Include File

  Purpose:      Generate Dynamic Viewer Include File for generateDynamicViewer IP in the
                Repository Design Manager. This IP is in a separate include file because the
                code is too large for the section editor.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   05/29/2002  Author:     Peter Judge

  Update Notes: Created from Template ryteminclu.i

  DEFINE INPUT  PARAMETER pcObjectTypeCode            AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcObjectName                AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcObjectDescription         AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcProductModuleCode         AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcResultCode                AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcSdoObjectName             AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER plDeleteExistingInstances   AS LOGICAL      NO-UNDO.
  DEFINE INPUT  PARAMETER pcDisplayedDatabases        AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcEnabledDatabases          AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcDisplayedTables           AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcEnabledTables             AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcDisplayedFields           AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcEnabledFields             AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER piMaxFieldsPerColumn        AS INTEGER      NO-UNDO.
  DEFINE INPUT  PARAMETER pcDataObjectFieldSequence   AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcDataObjectFieldList       AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER pdVisualObjectObj           AS DECIMAL      NO-UNDO. 
   
---------------------------------------------------------------------------------*/    
    DEFINE VARIABLE dInstanceSmartObjectObj     AS DECIMAL            NO-UNDO.
    DEFINE VARIABLE dObjectInstanceObj          AS DECIMAL            NO-UNDO.
    DEFINE VARIABLE dColumnMaxFieldWidth        AS DECIMAL            NO-UNDO.
    DEFINE VARIABLE dColumnMaxFieldHeight       AS DECIMAL            NO-UNDO.
    DEFINE VARIABLE dColumnMaxLabelWidth        AS DECIMAL            NO-UNDO.
    DEFINE VARIABLE dAllFieldWidths             AS DECIMAL  EXTENT 30 NO-UNDO.
    DEFINE VARIABLE dAllLabelWidths             AS DECIMAL  EXTENT 30 NO-UNDO.
    DEFINE VARIABLE dNewFrameWidth              AS DECIMAL            NO-UNDO.
    DEFINE VARIABLE dCurrentFrameWidth          AS DECIMAL            NO-UNDO.
    DEFINE VARIABLE dNewFrameHeight             AS DECIMAL            NO-UNDO.
    DEFINE VARIABLE dCurrentFrameHeight         AS DECIMAL            NO-UNDO.
    DEFINE VARIABLE dFrameWidthChars            AS DECIMAL            NO-UNDO.
    DEFINE VARIABLE dFrameHeightChars           AS DECIMAL            NO-UNDO.
    DEFINE VARIABLE iFieldsInColumn             AS INTEGER            NO-UNDO.
    DEFINE VARIABLE iCurrentColumn              AS INTEGER            NO-UNDO.
    DEFINE VARIABLE iBusyWithRow                AS INTEGER            NO-UNDO.
    DEFINE VARIABLE iBusyWithColumn             AS INTEGER            NO-UNDO.
    DEFINE VARIABLE iFieldLength                AS INTEGER            NO-UNDO.
    DEFINE VARIABLE iCurrentRow                 AS INTEGER            NO-UNDO.
    DEFINE VARIABLE iExtentLoop                 AS INTEGER            NO-UNDO.
    DEFINE VARIABLE iTotalFields                AS INTEGER            NO-UNDO.
    DEFINE VARIABLE iTotalColumns               AS INTEGER            NO-UNDO.
    DEFINE VARIABLE iTotalFieldsPerColumn       AS INTEGER            NO-UNDO.
    DEFINE VARIABLE iDatabaseLoop               AS INTEGER            NO-UNDO.
    DEFINE VARIABLE iMaxExtent                  AS INTEGER            NO-UNDO.
    DEFINE VARIABLE hLabel                      AS HANDLE             NO-UNDO.
    DEFINE VARIABLE hField                      AS HANDLE             NO-UNDO.
    DEFINE VARIABLE hWidget                     AS HANDLE             NO-UNDO.
    DEFINE VARIABLE hQuery                      AS HANDLE             NO-UNDO.
    DEFINE VARIABLE hAttributeTable             AS HANDLE             NO-UNDO.
    DEFINE VARIABLE hAttributeBuffer            AS HANDLE             NO-UNDO.
    DEFINE VARIABLE cFieldName                  AS CHARACTER          NO-UNDO.
    DEFINE VARIABLE cFormat                     AS CHARACTER          NO-UNDO.
    DEFINE VARIABLE cPrimaryTableObjField       AS CHARACTER          NO-UNDO.
    DEFINE VARIABLE cViewAs                     AS CHARACTER          NO-UNDO.
    DEFINE VARIABLE cAllFieldList               AS CHARACTER          NO-UNDO.
    DEFINE VARIABLE iFieldLoop                  AS INTEGER            NO-UNDO.
    DEFINE VARIABLE cFieldWidthChar             AS CHARACTER          NO-UNDO.
    DEFINE VARIABLE dFieldWidth                 AS DECIMAL            NO-UNDO.
    
    DEFINE VARIABLE hOTAttrs                    AS HANDLE             NO-UNDO.
    DEFINE VARIABLE hOTAttrsBuffer              AS HANDLE             NO-UNDO.
    DEFINE VARIABLE hMOAttrs                    AS HANDLE             NO-UNDO.
    DEFINE VARIABLE hMOAttrsBuffer              AS HANDLE             NO-UNDO.
    DEFINE VARIABLE hAllAttrs                   AS HANDLE             NO-UNDO.
    DEFINE VARIABLE hAllAttrsBuffer             AS HANDLE             NO-UNDO.
    DEFINE VARIABLE iLoop                       AS INTEGER            NO-UNDO.
    DEFINE VARIABLE hAttrField                  AS HANDLE             NO-UNDO.
    DEFINE VARIABLE lAttrValueSame              AS LOGICAL            NO-UNDO.
    DEFINE VARIABLE hFieldQuery                 AS HANDLE             NO-UNDO.
    DEFINE VARIABLE cAssignList                 AS CHARACTER          NO-UNDO.
    DEFINE VARIABLE hSmartDataObject            AS HANDLE             NO-UNDO.
    DEFINE VARIABLE hDesignFrame                AS HANDLE             NO-UNDO.
    DEFINE VARIABLE cFieldsByTable              AS CHARACTER          NO-UNDO.
    DEFINE VARIABLE cActualFieldName            AS CHARACTER          NO-UNDO.
    DEFINE VARIABLE iFieldNameLoop              AS INTEGER            NO-UNDO.
    DEFINE VARIABLE cAssignFieldTable           AS CHARACTER          NO-UNDO.
    DEFINE VARIABLE dFieldHeight                AS DECIMAL            NO-UNDO.    
    DEFINE VARIABLE lIncludeFieldInViewer       AS LOGICAL            NO-UNDO.
    DEFINE VARIABLE hIncludeFieldInViewer       AS HANDLE             NO-UNDO.
    DEFINE VARIABLE cPropertyNames              AS CHARACTER          NO-UNDO.
    DEFINE VARIABLE cPropertyValues             AS CHARACTER          NO-UNDO.
    DEFINE VARIABLE cInstanceNames              AS CHARACTER          NO-UNDO.
    DEFINE VARIABLE iInstanceLoop               AS INTEGER            NO-UNDO.
    DEFINE VARIABLE hEntityBuffer               AS HANDLE             NO-UNDO.
    DEFINE VARIABLE dEntityInstanceId           AS DECIMAL            NO-UNDO.
    
    DEFINE BUFFER fryc_smartobject FOR ryc_smartobject.
    
    ASSIGN hAttributeBuffer = BUFFER ttStoreAttribute:HANDLE
           hAttributeTable  = ?.
    
    /** Create the design frame.
    *  ----------------------------------------------------------------------- **/    
    CREATE FRAME hDesignFrame
        ASSIGN VIRTUAL-WIDTH-PIXELS  = SESSION:WIDTH-PIXELS - 1
               VIRTUAL-HEIGHT-PIXELS = SESSION:HEIGHT-PIXELS - 1
               WIDTH-CHARS           = hDesignFrame:VIRTUAL-WIDTH-CHARS 
               HEIGHT-CHARS          = hDesignFrame:VIRTUAL-HEIGHT-CHARS
               VISIBLE               = FALSE
               BOX                   = FALSE
               THREE-D               = TRUE
               SCROLLABLE            = FALSE
               OVERLAY               = TRUE
               HIDDEN                = TRUE
               SIDE-LABELS           = TRUE
               DOWN                  = 1.

    /** Determine the total number of columns
     *  ----------------------------------------------------------------------- **/
    ASSIGN iTotalFields = NUM-ENTRIES(pcDisplayedFields).

    IF piMaxFieldsPerColumn LE 0 THEN
        ASSIGN piMaxFieldsPerColumn = 16.

    IF iTotalFields <= piMaxFieldsPerColumn THEN
        ASSIGN iTotalColumns = 1.
    ELSE
    DO:
        ASSIGN iTotalColumns = TRUNCATE( iTotalFields / piMaxFieldsPerColumn, 0 ).
        IF iTotalFields MOD piMaxFieldsPerColumn GT 0 THEN
            ASSIGN iTotalColumns = iTotalColumns + 1.
    END.    /* more Fields than max Fields per column */

    ASSIGN iTotalFieldsPerColumn = iTotalFields / iTotalColumns
           iCurrentColumn        = 1.
   
    /** Get field information.
     *  ----------------------------------------------------------------------- **/
    EMPTY TEMP-TABLE ttFrameField.
    
    /* Get the Entity information. We need the key field, object field and dump
       name from the entity mnemonic.
       The entity_mnemonic_description field on the gsc_entity_mnemonic table is 
       used to store the physical table name.
     */
    ASSIGN hEntityBuffer = DYNAMIC-FUNCTION("getEntityCacheBuffer":U IN gshGenManager,
                                            INPUT "":U, 	/* Entity name */
                                            INPUT ENTRY(1,pcDisplayedTables) ).
    hEntityBuffer:FIND-FIRST(" WHERE ":U + hEntityBuffer:NAME
                             + ".entity_mnemonic_description = ":U + QUOTER(ENTRY(1,pcDisplayedTables))) NO-ERROR.
    
    IF NOT hEntityBuffer:AVAILABLE THEN
        RETURN ERROR {aferrortxt.i 'AF' '15' '?' '?' "'the entity mnemonic for ' + ENTRY(1,pcDisplayedTables) + ' could not be found.'"}.
    
    /* We now calculate the sizes and the row in which each datafield which appears.
       The fields are placed on the design frame here.
	 */
    ASSIGN cAllFieldList = "":U.

    /* Use Data Object Field order */
    IF pcDataObjectFieldList NE "":U THEN
    DO:
        ASSIGN cAllFieldList = pcDataObjectFieldList.

        /* If we need to use the fields from the SDO we need to check for renamed fields */
        RUN startDataObject IN gshRepositoryManager ( INPUT  pcSdoObjectName,
                                                      OUTPUT hSmartDataObject ) NO-ERROR.
        IF VALID-HANDLE(hSmartDataObject) THEN
            ASSIGN cAssignList    = DYNAMIC-FUNCTION("getAssignList":U IN hSmartDataObject) 
                   cFieldsByTable = DYNAMIC-FUNCTION("getDataColumnsByTable":U IN hSmartDataObject)
                   NO-ERROR.

        ASSIGN cPropertyNames = "InstanceId":U.
        RUN getInstanceProperties IN gshRepositoryManager ( INPUT        ENTRY(1,pcDisplayedTables),
                                                            INPUT        "":U,
                                                            INPUT-OUTPUT cPropertyNames,
                                                                  OUTPUT cPropertyValues ) NO-ERROR.
        ASSIGN dEntityInstanceId = DECIMAL(ENTRY(LOOKUP("InstanceId":U, cPropertyNames), cPropertyValues, {&Value-Delimiter})) NO-ERROR.
    END.    /* there are fields from the SDO to use */
    ELSE
    DO:
        /* Get all of the DataFields contained by this entity.
           These are ordered by the value of the Object_Sequence field on the object 
           instance record.
         */
        RUN getContainedInstanceNames IN gshRepositoryManager ( INPUT  ENTRY(1,pcDisplayedTables),
                                                                OUTPUT cInstanceNames ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
            RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
        
        /* Get the value of the InstanceId of the entity. This will make the retrieval of the instances
           faster and more robust.
         */
        ASSIGN cPropertyNames = "InstanceId":U.
        RUN getInstanceProperties IN gshRepositoryManager ( INPUT        ENTRY(1,pcDisplayedTables),
                                                            INPUT        "":U,
                                                            INPUT-OUTPUT cPropertyNames,
                                                                  OUTPUT cPropertyValues ) NO-ERROR.
        ASSIGN dEntityInstanceId = DECIMAL(ENTRY(LOOKUP("InstanceId":U, cPropertyNames), cPropertyValues, {&Value-Delimiter})) NO-ERROR.
        
        DO iInstanceLoop = 1 TO NUM-ENTRIES(cInstanceNames):
            /* Check for the 'IncludeInDefaultView' attribute to see if field should
               be added to viewer.
             */
            ASSIGN lIncludeFieldInViewer = TRUE
                   cPropertyNames        = "IncludeInDefaultView":U
                   cPropertyValues       = "":U.
            
            RUN getInstanceProperties IN gshRepositoryManager (INPUT        STRING(dEntityInstanceId),
                                                               INPUT        ENTRY(iInstanceLoop, cInstanceNames),
                                                               INPUT-OUTPUT cPropertyNames,
                                                                     OUTPUT cPropertyValues ) NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
                RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
                
            IF cPropertyValues <> ? AND cPropertyValues <> ""  THEN
                ASSIGN lIncludeFieldInViewer  =  LOGICAL(cPropertyValues)     NO-ERROR.
            
            IF lIncludeFieldInViewer THEN
                ASSIGN cAllFieldList = cAllFieldList + ENTRY(iInstanceLoop, cInstanceNames) + ",":U.
        END.    /* available fields. */
        ASSIGN cAllFieldList = RIGHT-TRIM(cAllFieldList, ",":U).
    END.    /* don't use DataObject fields */
    
    DO iFieldLoop = 1 TO NUM-ENTRIES(cAllFieldList):
        ASSIGN cPropertyNames   = "Format,Data-Type,Label,Help,DefaultValue,ViewAs,LogicalObjectName":U
               cActualFieldName = ENTRY(iFieldLoop, cAllFieldList).
        
        IF cAssignList NE "":U THEN
            ASSIGN cAssignFieldTable = DYNAMIC-FUNCTION("columnDbColumn":U IN hSmartDataObject, INPUT cActualFieldName)
                   cActualFieldName  = ENTRY(2, cAssignFieldTable, ".":U)
                   cAssignFieldTable = ENTRY(1, cAssignFieldTable, ".":U)
                   NO-ERROR.
        ELSE
            ASSIGN cAssignFieldTable = "":U.

        /* Retrieve the properties from the Repository. This API will return
           properties from the object master, instance and class.
         */
        RUN getInstanceProperties IN gshRepositoryManager (INPUT        STRING(dEntityInstanceId),
                                                           INPUT        cActualFieldName,
                                                           INPUT-OUTPUT cPropertyNames,
                                                                 OUTPUT cPropertyValues     ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
            RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

        IF CAN-DO(pcDisplayedFields, ENTRY(iFieldLoop,cAllFieldList)) THEN
        DO:
            CREATE ttFrameField.
            ASSIGN iFieldsInColumn = iFieldsInColumn + 1
                   /* Entity/Table information */
                   ttFrameField.tTableName         = hEntityBuffer:BUFFER-FIELD("entity_mnemonic_description":U):BUFFER-VALUE
                   ttFrameField.tTableDumpName     = hEntityBuffer:BUFFER-FIELD("entity_mnemonic":U):BUFFER-VALUE
                   ttFrameField.tEntityObjectField = hEntityBuffer:BUFFER-FIELD("entity_object_field":U):BUFFER-VALUE EQ cActualFieldName
                   ttFrameField.tKeyField          = hEntityBuffer:BUFFER-FIELD("entity_key_field":U):BUFFER-VALUE EQ cActualFieldName.
           /* Field information. Do separate assigns in case one of these doesn't exist.
            */
            ASSIGN ttFrameField.tFormat            = ENTRY(LOOKUP("Format":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}) NO-ERROR.
            ASSIGN ttFrameField.tDataType          = ENTRY(LOOKUP("Data-Type":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}) NO-ERROR.
            ASSIGN ttFrameField.tLabel             = ENTRY(LOOKUP("Label":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}) NO-ERROR.
            ASSIGN ttFrameField.tHelp              = ENTRY(LOOKUP("Help":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}) NO-ERROR.
            ASSIGN ttFrameField.tInitialValue      = ENTRY(LOOKUP("DefaultValue":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}) NO-ERROR.
            ASSIGN ttFrameField.tViewAs            = ENTRY(LOOKUP("ViewAs":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}) NO-ERROR.

            /* Ensure that an EDITOR visualization is used for CLOB fields. */
            IF ttFrameField.tDataType = "CLOB":U AND
               (NOT ttFrameField.tViewAs BEGINS "VIEW-AS EDITOR":U) THEN
                ASSIGN ttFrameField.tViewAs = "{&CLOB-VIEW-AS-PHRASE}":U.
            
            ASSIGN ttFrameField.tSortOrder    = STRING(iFieldLoop, "99999":U)                   
                   /* Set the FieldName. This is the instance_name */
                   ttFrameField.tFieldName    = ENTRY(iFieldLoop,cAllFieldList)            
                   /* This is the DataField name; the 2nd part anyway */
                   ttFrameField.tDBFieldName  = cActualFieldName
                   ttFrameField.tEnabled      = CAN-DO(pcEnabledFields, ttFrameField.tFieldName)
                   ttFrameField.tOrder        = iFieldsInColumn
                   cViewAs                    = ttFrameField.tViewAs.
            
            IF ttFrameField.tViewAs <> ? AND NUM-ENTRIES(ttFrameField.tViewAs, " ":U) GE 2 THEN
                ASSIGN ttFrameField.tViewAs = TRIM(ENTRY(2, ttFrameField.tViewAs, " ":U)).

            /*** This field sequence is only for SDOs and not for fields on a viewer 
            IF pcDataObjectFieldSequence = "ORDER":U THEN
            ttFrameField.tSortOrder = STRING(hTableFieldBuffer:BUFFER-FIELD("_Order":U):BUFFER-VALUE,"999999":U).
            ELSE 
            ttFrameField.tSortOrder = ttFrameField.tFieldName.
            ****/

            IF ttFrameField.tLabel EQ "?" OR ttFrameField.tLabel EQ ? THEN
                ASSIGN ttFrameField.tLabel = ttFrameField.tFieldName + ":":U.
            ELSE
                ASSIGN ttFrameField.tLabel = ttFrameField.tLabel + ":":U.

            IF LOOKUP(ttFrameField.tViewAs, "TOGGLE-BOX":U) GT 0 THEN
                ASSIGN ttFrameField.tLabel = TRIM(ttFrameField.tLabel, ":":U).

            IF INDEX(ttFrameField.tFormat, "(":U) GT 0 THEN
            DO:
                ASSIGN cFormat      = ttFrameField.tFormat
                       cFormat      = REPLACE(cFormat, "(":U, "":U)
                       cFormat      = REPLACE(cFormat, ")":U, "":U)
                       cFormat      = REPLACE(cFormat, "X":U, "":U)
                       iFieldLength = INTEGER(cFormat)
                        NO-ERROR.
                IF ERROR-STATUS:ERROR THEN
                    ASSIGN iFieldLength = LENGTH(cFormat).
            END.    /* ( in format. */
            ELSE
                ASSIGN iFieldLength = LENGTH(ttFrameField.tFormat).

            IF iFieldLength GT {&MAX-FIELD-LENGTH} THEN
            DO:
                ASSIGN iFieldLength = {&MAX-FIELD-LENGTH}.

                IF ttFrameField.tDataType EQ "CHARACTER" THEN
                    ASSIGN ttFrameField.tFormat = "x(":U + STRING({&MAX-FIELD-LENGTH}) + ")":U.
            END. /* ttFrameField.tFieldLength > MAX-FIELD-LENGTH */
            
            /* Allow for colon and space and padding */
            ASSIGN ttFrameField.tLabelChars = LENGTH(ttFrameField.tLabel).
            
            CREATE TEXT hLabel
                ASSIGN FRAME        = hDesignFrame
                       DATA-TYPE    = "CHARACTER":U
                       FORMAT       = "x(":U + STRING(ttFrameField.tLabelChars) + ")":U
                       WIDTH-PIXELS = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(ttFrameField.tLabel)
                       SCREEN-VALUE = ttFrameField.tLabel.

            ASSIGN ttFrameField.tLabelHandle = hLabel
                   ttFrameField.tLabelLength = hLabel:WIDTH-PIXELS.

            IF CAN-DO("COMBO-BOX,EDITOR,RADIO-SET,SELECTION-LIST":U, ttFrameField.tViewAs) THEN
                RUN ripViewAsPhrase IN TARGET-PROCEDURE ( INPUT cViewAs ).

            CASE ttFrameField.tViewAs:
                WHEN "EDITOR":U THEN
                DO:
                    CREATE EDITOR hField
                        ASSIGN FRAME = hDesignFrame.

                    FIND FIRST ttStoreAttribute WHERE ttStoreAttribute.tAttributeLabel = "HEIGHT-CHARS":U NO-LOCK NO-ERROR.
                    IF AVAILABLE ttStoreAttribute THEN
                        ASSIGN hField:HEIGHT-CHARS = ttStoreAttribute.tDecimalValue.

                    FIND FIRST ttStoreAttribute WHERE ttStoreAttribute.tAttributeLabel = "WIDTH-CHARS":U NO-LOCK NO-ERROR.
                    IF AVAILABLE ttStoreAttribute THEN
                        ASSIGN hField:WIDTH-CHARS = ttStoreAttribute.tDecimalValue.                        
                END.    /* Editor */
                WHEN "COMBO-BOX":U THEN
                DO:
                    CREATE COMBO-BOX hField
                        ASSIGN FRAME = hDesignFrame.

                    FIND FIRST ttStoreAttribute WHERE ttStoreAttribute.tAttributeLabel = "WIDTH-CHARS":U NO-LOCK NO-ERROR.
                    IF AVAILABLE ttStoreAttribute THEN
                        ASSIGN hField:WIDTH-CHARS = ttStoreAttribute.tDecimalValue.
                END. /* COMBO-BOX */
                WHEN "RADIO-SET":U THEN
                DO:
                    CREATE RADIO-SET hField
                        ASSIGN FRAME = hDesignFrame.

                    FIND FIRST ttStoreAttribute WHERE ttStoreAttribute.tAttributeLabel = "HEIGHT-CHARS":U NO-LOCK NO-ERROR.
                    IF AVAILABLE ttStoreAttribute THEN
                        ASSIGN hField:HEIGHT-CHARS = ttStoreAttribute.tDecimalValue.

                    FIND FIRST ttStoreAttribute WHERE ttStoreAttribute.tAttributeLabel = "WIDTH-CHARS":U NO-LOCK NO-ERROR.
                    IF AVAILABLE ttStoreAttribute THEN
                        ASSIGN hField:WIDTH-CHARS = ttStoreAttribute.tDecimalValue.

                    FIND FIRST ttStoreAttribute WHERE ttStoreAttribute.tAttributeLabel = "HORIZONTAL":U NO-LOCK NO-ERROR.
                    ASSIGN hField:HORIZONTAL = AVAILABLE ttStoreAttribute.

                    FIND FIRST ttStoreAttribute WHERE ttStoreAttribute.tAttributeLabel = "DELIMITER":U NO-LOCK NO-ERROR.
                    IF AVAILABLE ttStoreAttribute THEN
                        ASSIGN hField:DELIMITER = ttStoreAttribute.tCharacterValue.

                    FIND FIRST ttStoreAttribute WHERE ttStoreAttribute.tAttributeLabel = "RADIO-BUTTONS":U NO-LOCK NO-ERROR.
                    IF AVAILABLE ttStoreAttribute THEN
                        ASSIGN hField:RADIO-BUTTONS = ttStoreAttribute.tCharacterValue.                        
                END. /* RADIO-SET */
                WHEN "SELECTION-LIST":U THEN
                DO:
                    CREATE SELECTION-LIST hField 
                        ASSIGN FRAME = hDesignFrame.

                    FIND FIRST ttStoreAttribute WHERE ttStoreAttribute.tAttributeLabel = "HEIGHT-CHARS":U NO-LOCK NO-ERROR.
                    IF AVAILABLE ttStoreAttribute THEN
                        ASSIGN hField:HEIGHT-CHARS = ttStoreAttribute.tDecimalValue.

                    FIND FIRST ttStoreAttribute WHERE ttStoreAttribute.tAttributeLabel = "WIDTH-CHARS":U NO-LOCK NO-ERROR.
                    IF AVAILABLE ttStoreAttribute THEN
                        ASSIGN hField:WIDTH-CHARS = ttStoreAttribute.tDecimalValue.
                END. /* SELECTION-LIST */
                OTHERWISE
                DO:
                    IF CAN-DO("CHARACTER,LOGICAL":U, ttFrameField.tDataType) THEN
                        ASSIGN dFieldWidth = IF iFieldLength <= 0 THEN 14
                                              ELSE MAX(iFieldLength, DYNAMIC-FUNCTION("getWidgetSizeFromFormat":U IN ghDesignManager,
                                                                                      INPUT ttFrameField.tFormat, INPUT "CHARACTER":U, OUTPUT dFieldHeight)).
                    ELSE
                    DO:
                        /* For decimals and integers, there's no sequence in field width up to about 5 chars. *
                         * Hardcode up to there, and then calculate if larger.                                */
                        IF iFieldLength <= 0 THEN
                            ASSIGN dFieldWidth = 14.
                        ELSE
                        CASE iFieldLength:
                            WHEN 1 THEN ASSIGN dFieldWidth = 2.8.
                            WHEN 2 THEN ASSIGN dFieldWidth = 4.
                            WHEN 3 THEN ASSIGN dFieldWidth = 5.3.
                            WHEN 4 THEN ASSIGN dFieldWidth = 7.
                            WHEN 5 THEN ASSIGN dFieldWidth = 8.3.
                            OTHERWISE
                                /* The D works out the best for numeric */
                                ASSIGN dFieldWidth = DYNAMIC-FUNCTION("getWidgetSizeFromFormat":U IN ghDesignManager,
                                                                      INPUT ttFrameField.tFormat, INPUT "CHARACTER":U, OUTPUT dFieldHeight).
                        END CASE.   /* field length */
                    END.    /* not character or logical */

                    IF ttFrameField.tDataType = "BLOB":U THEN
                    DO:
                       FIND FIRST ttStoreAttribute WHERE ttStoreAttribute.tAttributeLabel = "WIDTH-CHARS":U NO-LOCK NO-ERROR.
                       IF AVAILABLE ttStoreAttribute THEN
                           ASSIGN dFieldWidth = ttStoreAttribute.tDecimalValue.                        
                       CREATE FILL-IN hField 
                        ASSIGN FRAME             = hDesignFrame
                               DATA-TYPE         = "CHARACTER":U
                               FORMAT            = "x(8)":U
                               WIDTH-CHARS       = dFieldWidth
                               SIDE-LABEL-HANDLE = hLabel.
                    END.
                    ELSE
                       CREATE FILL-IN hField 
                        ASSIGN FRAME             = hDesignFrame
                               DATA-TYPE         = ttFrameField.tDataType
                               FORMAT            = ttFrameField.tFormat
                               WIDTH-CHARS       = dFieldWidth
                               SIDE-LABEL-HANDLE = hLabel.
                END.    /* otherwise */
            END CASE.   /* View-As */

            EMPTY TEMP-TABLE ttStoreAttribute.  

            ASSIGN ttFrameField.tRow         = iCurrentRow
                   iCurrentRow               = iCurrentRow + hField:HEIGHT-PIXELS
                   ttFrameField.tFieldHandle = hField
                   ttFrameField.tFieldLength = hField:WIDTH-PIXELS.
                
            /* The lookup button is now placed next to the field - we only need to make provision for the
             * frame of the viewer to be 3 columns wider than the widest field                            */

             /* For decimals and dates, make provision for the lookup button to the right of the field 
                
                                  + (IF ttFrameField.tDataType = "DECIMAL":U 
                                     OR ttFrameField.tDataType = "DATE":U
                                     OR ttFrameField.tDataType = "INTEGER":U
                                     THEN 15
                                     ELSE 0
                                    ). */
            IF ttFrameField.tFieldLength GT dColumnMaxFieldWidth THEN
                ASSIGN dColumnMaxFieldWidth = ttFrameField.tFieldLength + 8.
            
            IF ttFrameField.tLabelLength GT dColumnMaxLabelWidth THEN
                ASSIGN dColumnMaxLabelWidth = ttFrameField.tLabelLength + 8.

            IF iFieldsInColumn MOD iTotalFieldsPerColumn EQ 0 THEN
                ASSIGN dAllFieldWidths[iCurrentColumn] = dColumnMaxFieldWidth
                       dAllLabelWidths[iCurrentColumn] = dColumnMaxLabelWidth
                       dColumnMaxFieldWidth            = 0
                       dColumnMaxLabelWidth            = 0
                       iCurrentColumn                  = iCurrentColumn + 1
                       iCurrentRow                     = 0.
        END.    /* available buffer */
    END. /* loop through all fields. */

    IF VALID-HANDLE(hSmartDataObject) THEN
        RUN destroyObject IN hSmartDataObject.

    IF VALID-HANDLE(hSmartDataObject) THEN
        DELETE OBJECT hSmartDataObject.

    IF iFieldsInColumn MOD iTotalFieldsPerColumn NE 0 THEN
        ASSIGN dAllFieldWidths[iCurrentColumn] = dColumnMaxFieldWidth
               dAllLabelWidths[iCurrentColumn] = dColumnMaxLabelWidth.

    /** Calculate the positions of each column, and the total size of the frame.
     *  ----------------------------------------------------------------------- **/
    ASSIGN iBusyWithRow        = 0
           iCurrentColumn      = 1
           iBusyWithColumn     = 2
           dNewFrameWidth      = 0
           dCurrentFrameWidth  = 0
           dNewFrameHeight     = 0
           dCurrentFrameHeight = 0.

    FOR EACH ttFrameField BY ttFrameField.tSortOrder:
        /* The fields must fit inside the frame. */
        IF hDesignFrame:WIDTH-PIXELS LT (iBusyWithColumn + dAllLabelWidths[iCurrentColumn] + dAllFieldWidths[iCurrentColumn]) THEN
            LEAVE.

        /* Don't position for the table's primary _obj field, since we are going
         * to skip these later anyway.
         * Other _obj (or _obj type) fields are left on the viewer because they
         * may be used for lookups.                                            */
        IF ttFrameField.tEntityObjectField THEN
            NEXT.

        ASSIGN iBusyWithRow                        = iBusyWithRow + 1
               ttFrameField.tLabelHandle:Y         = ttFrameField.tRow
               ttFrameField.tLabelHandle:X         = (iBusyWithColumn + dAllLabelWidths[iCurrentColumn]) - ttFrameField.tLabelLength
               ttFrameField.tLabelHandle:SENSITIVE = TRUE
               ttFrameField.tLabelHandle:VISIBLE   = TRUE
               iCurrentRow                         = iCurrentRow + 1
               ttFrameField.tFieldHandle:Y         = ttFrameField.tRow
               ttFrameField.tFieldHandle:X         = iBusyWithColumn + dAllLabelWidths[iCurrentColumn]
               ttFrameField.tFieldHandle:SENSITIVE = TRUE
               ttFrameField.tFieldHandle:VISIBLE   = TRUE.
        IF iBusyWithRow MOD iTotalFieldsPerColumn EQ 0 THEN
            ASSIGN iBusyWithRow    = 0
                   iBusyWithColumn = iBusyWithColumn + dAllLabelWidths[iCurrentColumn] + dAllFieldWidths[iCurrentColumn]
                   iCurrentColumn  = iCurrentColumn + 1.

        ASSIGN dCurrentFrameWidth = ttFrameField.tFieldHandle:X + ttFrameField.tFieldHandle:WIDTH-PIXELS + 4.
        
        IF dCurrentFrameWidth GT dNewFrameWidth THEN
            ASSIGN dNewFrameWidth = dCurrentFrameWidth.

        ASSIGN dCurrentFrameHeight = ttFrameField.tFieldHandle:Y + ttFrameField.tFieldHandle:HEIGHT-PIXELS + 4.

        IF dCurrentFrameHeight GT dNewFrameHeight THEN
            ASSIGN dNewFrameHeight = dCurrentFrameHeight.
    END.    /* each ttFrameField */

    IF iBusyWithRow MOD iTotalFieldsPerColumn NE 0 THEN
        ASSIGN iBusyWithColumn = iBusyWithColumn + dAllLabelWidths[iCurrentColumn] + dAllFieldWidths[iCurrentColumn].

    /** Calculate the minimum size of the objects contained withing the frame.
     *  We calculate this in this way to conform to the dynamic viewer's
     *  calculations.
     *  ----------------------------------------------------------------------- **/
    ASSIGN hWidget          = hDesignFrame:FIRST-CHILD
           hWidget          = hWidget:FIRST-CHILD
           /* The frame should be at least 10 chars wide. */
           dFrameWidthChars = 10.

    DO WHILE VALID-HANDLE(hWidget):
        IF CAN-QUERY(hWidget, "ROW":U) AND CAN-QUERY(hWidget, "HEIGHT-CHARS":U) THEN
            ASSIGN dFrameHeightChars = MAX(dFrameHeightChars, hWidget:ROW + hWidget:HEIGHT-CHARS).

        IF CAN-QUERY(hWidget, "COLUMN":U) AND CAN-QUERY(hWidget, "WIDTH-CHARS":U) THEN
            ASSIGN dFrameWidthChars  = MAX(dFrameWidthChars,  hWidget:COL + hWidget:WIDTH-CHARS).

        ASSIGN hWidget = hWidget:NEXT-SIBLING.
    END.    /* while valid handle. */

    ASSIGN hDesignFrame:WIDTH-CHARS    = dFrameWidthChars
           hDesignFrame:HEIGHT-CHARS   = dFrameHeightChars
           hDesignFrame:SCROLLABLE     = FALSE.

    /** Create the dynamic viewer master object, and any attribute values
     *  associated with it.
     *  ----------------------------------------------------------------------- **/
    EMPTY TEMP-TABLE ttStoreAttribute.
    
    CREATE ttStoreAttribute.
    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
           ttStoreAttribute.tAttributeParentObj = 0
           ttStoreAttribute.tAttributeLabel     = "MinHeight":U
           ttStoreAttribute.tConstantValue      = YES
           ttStoreAttribute.tDecimalValue       = MAX(hDesignFrame:HEIGHT-CHARS,dFrameHeightChars).

    CREATE ttStoreAttribute.
    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
           ttStoreAttribute.tAttributeParentObj = 0
           ttStoreAttribute.tAttributeLabel     = "MinWidth":U
           ttStoreAttribute.tConstantValue      = YES
           /* Provision for lookup button on DECIMAL,INTEGER and DATE fields */
           ttStoreAttribute.tDecimalValue       = hDesignFrame:WIDTH-CHARS + 5.

    /* We should be using the entity description or maybe key field here. This should come from the entity cache 
     * This comment is a note to update this.                                                                    */
    FIND FIRST ttFrameField WHERE
               ttFrameField.tKeyField = YES
               NO-ERROR.
    IF AVAILABLE ttFrameField THEN
    DO:
        CREATE ttStoreAttribute.
        ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
               ttStoreAttribute.tAttributeParentObj = 0
               ttStoreAttribute.tAttributeLabel     = "WindowTitleField":U
               ttStoreAttribute.tConstantValue      = YES
               ttStoreAttribute.tCharacterValue     = ttFrameField.tFieldName.
    END.    /* avail frame field */
    
    /* The tabbing order of viewers generated needs to be stored for
       use by the AppBuilder. The default generated here is Left-to-Right
       by Columns.
     */
    CREATE ttStoreAttribute.
    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
           ttStoreAttribute.tAttributeParentObj = 0
           ttStoreAttribute.tAttributeLabel     = "AppBuilderTabbing":U
           ttStoreAttribute.tConstantValue      = YES
           ttStoreAttribute.tCharacterValue     = "L-To-R,COLUMNS":U.
    
    /* We need to compare default values set at the class and master object 
     * level to ensure that we do not add attributes at instance level that
     * will cause unnecessary duplication of values */
    DYNAMIC-FUNCTION("cleanStoreAttributeValues":U IN TARGET-PROCEDURE,
                     INPUT pcObjectName,        /* pcObjectName     */
                     INPUT pcObjectTypeCode,    /* pcClassName      */
                     INPUT "CLASS":U,           /* pcCleanToLevel   */
                     INPUT hAttributeBuffer   ).
    
    RUN insertObjectMaster IN ghDesignManager ( INPUT  pcObjectName,                             /* pcObjectName         */
                                                INPUT  pcResultCode,                             /* pcResultCode         */
                                                INPUT  pcProductModuleCode,                      /* pcProductModuleCode  */
                                                INPUT  pcObjectTypeCode,                         /* pcObjectTypeCode     */
                                                INPUT  pcObjectDescription,                      /* pcObjectDescription  */
                                                INPUT  "":U,                                     /* pcObjectPath         */
                                                INPUT  pcSdoObjectName,                          /* pcSdoObjectName      */
                                                INPUT  "":U,                                     /* pcSuperProcedureName */
                                                INPUT  NO,                                       /* plIsTemplate         */
                                                INPUT  NO,                                       /* plIsStatic           */
                                                INPUT  "":U,                                     /* pcPhysicalObjectName : use the default*/
                                                INPUT  NO,                                       /* plRunPersistent      */
                                                INPUT  "":U,                                     /* pcTooltipText        */
                                                INPUT  "":U,                                     /* pcRequiredDBList     */
                                                INPUT  "":U,                                     /* pcLayoutCode         */
                                                INPUT  hAttributeBuffer,
                                                INPUT  TABLE-HANDLE hAttributeTable,
                                                OUTPUT pdVisualObjectObj               ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.

    IF plDeleteExistingInstances THEN
    DO:
        RUN removeObjectInstance IN ghDesignManager ( INPUT pcObjectName,
                                                      INPUT pcResultCode,
                                                      INPUT "":U,          /* pcInstanceObjectName */
                                                      INPUT "":U,          /* pcInstanceName       */
                                                      INPUT pcResultCode   ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    END.    /* delete instances. */
    
    FOR EACH ttFrameField BY ttFrameField.tSortOrder:
        /* Don't create DataField instances for the table's primary _obj field.
         * Other _obj (or _obj type) fields are left on the viewer because they
         * may be used for lookups.                                            */
        IF ttFrameField.tEntityObjectField THEN
            NEXT.
        
        EMPTY TEMP-TABLE ttStoreAttribute.
        
        CREATE ttStoreAttribute.
        ASSIGN ttStoreAttribute.tAttributeParent    = "INSTANCE":U
               ttStoreAttribute.tAttributeParentObj = 0
               ttStoreAttribute.tAttributeLabel     = "Row":U
               ttStoreAttribute.tConstantValue      = NO
               ttStoreAttribute.tDecimalValue       = ttFrameField.tFieldHandle:ROW.

        CREATE ttStoreAttribute.
        ASSIGN ttStoreAttribute.tAttributeParent    = "INSTANCE":U
               ttStoreAttribute.tAttributeParentObj = 0
               ttStoreAttribute.tAttributeLabel     = "Column":U
               ttStoreAttribute.tConstantValue      = NO
               ttStoreAttribute.tDecimalValue       = ttFrameField.tFieldHandle:COLUMN.

        CREATE ttStoreAttribute.
        ASSIGN ttStoreAttribute.tAttributeParent    = "INSTANCE":U
               ttStoreAttribute.tAttributeParentObj = 0
               ttStoreAttribute.tAttributeLabel     = "Enabled":U
               ttStoreAttribute.tConstantValue      = NO
               ttStoreAttribute.tLogicalValue       = ttFrameField.tEnabled.

        CREATE ttStoreAttribute.
        ASSIGN ttStoreAttribute.tAttributeParent    = "INSTANCE":U
               ttStoreAttribute.tAttributeParentObj = 0
               ttStoreAttribute.tAttributeLabel     = "DisplayField":U
               ttStoreAttribute.tConstantValue      = NO
               ttStoreAttribute.tLogicalValue       = YES.
        
        CREATE ttStoreAttribute.
        ASSIGN ttStoreAttribute.tAttributeParent    = "INSTANCE":U
               ttStoreAttribute.tAttributeParentObj = 0
               ttStoreAttribute.tAttributeLabel     = "Order":U
               ttStoreAttribute.tConstantValue      = NO
               ttStoreAttribute.tIntegerValue       = INTEGER(ttFrameField.tSortOrder).

        CREATE ttStoreAttribute.
        ASSIGN ttStoreAttribute.tAttributeParent    = "INSTANCE":U
               ttStoreAttribute.tAttributeParentObj = 0
               ttStoreAttribute.tAttributeLabel     = "WIDTH-CHARS":U
               ttStoreAttribute.tConstantValue      = NO
               ttStoreAttribute.tDecimalValue       = ttFrameField.tFieldLength / SESSION:PIXELS-PER-COLUMN.

        IF ttFrameField.tDataType = "CLOB":U THEN
        DO:
            CREATE ttStoreAttribute.
            ASSIGN ttStoreAttribute.tAttributeParent    = "INSTANCE":U
                   ttStoreAttribute.tAttributeParentObj = 0
                   ttStoreAttribute.tAttributeLabel     = "DATA-TYPE":U
                   ttStoreAttribute.tConstantValue      = NO
                   ttStoreAttribute.tCharacterValue     = "LongChar":U.

            CREATE ttStoreAttribute.
            ASSIGN ttStoreAttribute.tAttributeParent    = "INSTANCE":U
                   ttStoreAttribute.tAttributeParentObj = 0
                   ttStoreAttribute.tAttributeLabel     = "LABELS":U
                   ttStoreAttribute.tConstantValue      = NO
                   ttStoreAttribute.tLogicalValue       = NO.

            CREATE ttStoreAttribute.
            ASSIGN ttStoreAttribute.tAttributeParent    = "INSTANCE":U
                   ttStoreAttribute.tAttributeParentObj = 0
                   ttStoreAttribute.tAttributeLabel     = "RETURN-INSERTED":U
                   ttStoreAttribute.tConstantValue      = NO
                   ttStoreAttribute.tLogicalValue       = YES.

            CREATE ttStoreAttribute.
            ASSIGN ttStoreAttribute.tAttributeParent    = "INSTANCE":U
                   ttStoreAttribute.tAttributeParentObj = 0
                   ttStoreAttribute.tAttributeLabel     = "WORD-WRAP":U
                   ttStoreAttribute.tConstantValue      = NO
                   ttStoreAttribute.tLogicalValue       = YES.
        END.

        /* We need to compare default values set at the class and master object 
         * level to ensure that we do not add attributes at instance level that
         * will cause unnecessary duplication of values */
        DYNAMIC-FUNCTION("cleanStoreAttributeValues":U IN TARGET-PROCEDURE,
                         INPUT (ttFrameField.tTableName + ".":U + ttFrameField.tDBFieldName),   /* pcObjectName   */
                         INPUT "":U,                                                            /* pcClassName    */
                         INPUT "MASTER":U,                                                      /* pcCleanToLevel */
                         INPUT hAttributeBuffer   ).
        
        RUN insertObjectInstance IN ghDesignManager ( INPUT  pdVisualObjectObj,                        /* pdContainerObjectObj               */
                                                      INPUT  (ttFrameField.tTableName + ".":U + ttFrameField.tDBFieldName),    /* logical object name of instance */
                                                      INPUT  pcResultCode,                             /* pcResultCode,                      */
                                                      INPUT  ttFrameField.tFieldName,                  /* pcInstanceName                     */
                                                      INPUT  "":U,                                     /* pcInstanceDescription,             */
                                                      INPUT  "":U,                                     /* pcLayoutPosition,                  */
                                                      INPUT  ?,                                        /* Page obj - not applicable          */
                                                      INPUT  ttFrameField.tSortOrder,                  /* Object sequence 					 */
                                                      INPUT  NO,                                       /* plForceCreateNew,                  */
                                                      INPUT  hAttributeBuffer,                         /* phAttributeValueBuffer,            */
                                                      INPUT  TABLE-HANDLE hAttributeTable,             /* TABLE-HANDLE phAttributeValueTable */
                                                      OUTPUT dInstanceSmartObjectObj,                  /* pdSmartObjectObj,                  */
                                                      OUTPUT dObjectInstanceObj                ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    END.    /* each ttFrameField */

    /** Cleanup 
     *  ----------------------------------------------------------------------- **/
    FOR EACH ttFrameField NO-LOCK:
        IF VALID-HANDLE(ttFrameField.tFieldHandle) THEN
            DELETE OBJECT ttFrameField.tFieldHandle NO-ERROR.
        IF VALID-HANDLE(ttFrameField.tLabelHandle) THEN
            DELETE OBJECT ttFrameField.tLabelHandle NO-ERROR.

        DELETE ttFrameField.
    END. /* each ttFrameField */

    DELETE OBJECT hDesignFrame NO-ERROR.
    ASSIGN hDesignFrame = ?.
    /* E - O - F */
