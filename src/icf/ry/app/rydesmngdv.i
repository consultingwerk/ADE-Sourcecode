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
    DEFINE VARIABLE dSdoInstanceId              AS DECIMAL            NO-UNDO.
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
    DEFINE VARIABLE hFieldBuffer                AS HANDLE             NO-UNDO.
    DEFINE VARIABLE hLocalField                 AS HANDLE             NO-UNDO.
    DEFINE VARIABLE hTableFieldTable            AS HANDLE             NO-UNDO.
    DEFINE VARIABLE hTableFieldBuffer           AS HANDLE             NO-UNDO.
    DEFINE VARIABLE hAttributeTable             AS HANDLE             NO-UNDO.
    DEFINE VARIABLE hAttributeBuffer            AS HANDLE             NO-UNDO.
    DEFINE VARIABLE hObjectBuffer               AS HANDLE             NO-UNDO.
    DEFINE VARIABLE hAttributeField             AS HANDLE             NO-UNDO.
    DEFINE VARIABLE cWidgetPoolName             AS CHARACTER          NO-UNDO.
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
    DEFINE VARIABLE hEntityTable                AS HANDLE             NO-UNDO.
    DEFINE VARIABLE hEntityFieldTable           AS HANDLE             NO-UNDO.
    DEFINE VARIABLE hFieldQuery                 AS HANDLE             NO-UNDO.
    DEFINE VARIABLE cAssignList                 AS CHARACTER          NO-UNDO.
    DEFINE VARIABLE hSmartDataObject            AS HANDLE             NO-UNDO.
    DEFINE VARIABLE hDesignFrame                AS HANDLE             NO-UNDO.
    DEFINE VARIABLE cFieldsByTable              AS CHARACTER          NO-UNDO.
    DEFINE VARIABLE cActualFieldName            AS CHARACTER          NO-UNDO.
    DEFINE VARIABLE iFieldNameLoop              AS INTEGER            NO-UNDO.
    DEFINE VARIABLE cAssignFieldTable           AS CHARACTER          NO-UNDO.
    DEFINE VARIABLE dFieldHeight                AS DECIMAL            NO-UNDO.
    
    DEFINE VARIABLE hDataFieldAttributeBuffer   AS HANDLE             NO-UNDO.
    DEFINE VARIABLE dInstanceId                 AS DECIMAL            NO-UNDO.
    DEFINE VARIABLE lIncludeFieldInViewer       AS LOGICAL            NO-UNDO.
    DEFINE VARIABLE hIncludeFieldInViewer       AS HANDLE             NO-UNDO.
    DEFINE VARIABLE cDataFieldName              AS CHARACTER          NO-UNDO.
    
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

    /** We now calculate the sizes and the row in which each datafield which appears.
     *  The fields are placed on the design frame here.
     *
     *  The buffer returned from this API contains the DataField information for the 
     *  DataFields contained by the Entity objects that represent that tables 
     *  passed in. This buffer should contain all the information needed to
     *  construct the viewer.
     *  ----------------------------------------------------------------------- **/   
    RUN buildSchemaFieldTable IN TARGET-PROCEDURE ( INPUT  pcDisplayedDatabases,
                                                    INPUT  pcDisplayedTables,
                                                    OUTPUT hTableFieldBuffer,
                                                    OUTPUT TABLE-HANDLE hTableFieldTable ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.

    IF NOT VALID-HANDLE(hTableFieldBuffer) THEN
        ASSIGN hTableFieldBuffer = hTableFieldTable:DEFAULT-BUFFER-HANDLE NO-ERROR.

    IF VALID-HANDLE(hTableFieldBuffer) THEN 
    DO:
        ASSIGN cAllFieldList = "":U.

        /* Use Data Object Field order */
        IF pcDataObjectFieldList NE "":U THEN
        DO:
            ASSIGN cAllFieldList = pcDataObjectFieldList.

            /* If we need to use the fields from the SDO we need to check for renamed fields */
            RUN startDataObject IN gshRepositoryManager ( INPUT pcSdoObjectName,
                                                          OUTPUT hSmartDataObject ) NO-ERROR.
            IF VALID-HANDLE(hSmartDataObject) THEN
                ASSIGN cAssignList    = DYNAMIC-FUNCTION("getAssignList":U IN hSmartDataObject) 
                       cFieldsByTable = DYNAMIC-FUNCTION("getDataColumnsByTable":U IN hSmartDataObject)
                       NO-ERROR.
        END.    /* there are fields from the SDO to use */
        ELSE
        DO:
            CREATE QUERY hFieldQuery.

            hFieldQuery:SET-BUFFERS(hTableFieldBuffer).
            hFieldQuery:QUERY-PREPARE("FOR EACH ":U + hTableFieldBuffer:NAME + " WHERE ":U
                                      + hTableFieldBuffer:NAME + ".tTableName = ":U + QUOTER(ENTRY(1,pcDisplayedTables)) 
                                      + " BY ":U + hTableFieldBuffer:NAME + "._Order ":U                               ).
            hFieldQuery:QUERY-OPEN().

            hFieldQuery:GET-FIRST().
            DO WHILE hTableFieldBuffer:AVAILABLE:
              /** Check for the 'IncludeInDefaultView' attribute to see if field should
                  be added to viewer */
              lIncludeFieldInViewer = TRUE.
              cDataFieldName = hTableFieldBuffer:BUFFER-FIELD("tTableName":U):BUFFER-VALUE + ".":U + hTableFieldBuffer:BUFFER-FIELD("_Field-name":U):BUFFER-VALUE.
              DYNAMIC-FUNCTION("cacheObjectOnClient":U IN gshRepositoryManager,
                               INPUT cDataFieldName, 
                               INPUT "":U, 
                               INPUT ?, 
                               INPUT YES).

              ASSIGN hObjectBuffer = DYNAMIC-FUNCTION("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT ?).

              IF hObjectBuffer:AVAILABLE THEN
              DO:
                  ASSIGN hDataFieldAttributeBuffer = hObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE.

                  ASSIGN dInstanceId = hObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE.
                  hDataFieldAttributeBuffer:FIND-FIRST(" WHERE ":U + hDataFieldAttributeBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(dInstanceId) ).
                  hIncludeFieldInViewer = hDataFieldAttributeBuffer:BUFFER-FIELD("IncludeInDefaultView":U) NO-ERROR.
                  IF hDataFieldAttributeBuffer:AVAILABLE AND
                     VALID-HANDLE(hIncludeFieldInViewer) THEN
                    lIncludeFieldInViewer = hIncludeFieldInViewer:BUFFER-VALUE.
              END.    /* clean to class */
                
              IF lIncludeFieldInViewer THEN
                  ASSIGN cAllFieldList = cAllFieldList + hTableFieldBuffer:BUFFER-FIELD("_Field-name":U):BUFFER-VALUE + ",":U.
                hFieldQuery:GET-NEXT().
            END.    /* available fields. */
            hFieldQuery:QUERY-CLOSE().

            ASSIGN cAllFieldList = RIGHT-TRIM(cAllFieldList, ",":U).
            
            DELETE OBJECT hFieldQuery NO-ERROR.
            ASSIGN hFieldQuery = ?.
        END.    /* don't use DO fields */
    END.        /* there are entity fields. */

    DO iFieldLoop = 1 TO NUM-ENTRIES(cAllFieldList):
        ASSIGN cActualFieldName = ENTRY(iFieldLoop, cAllFieldList).

        IF cAssignList NE "":U THEN        
            ASSIGN cAssignFieldTable  = DYNAMIC-FUNCTION("columnDbColumn":U IN hSmartDataObject, INPUT cActualFieldName)
                   cActualFieldName  = ENTRY(2, cAssignFieldTable, ".":U)
                   cAssignFieldTable = ENTRY(1, cAssignFieldTable, ".":U)
                   NO-ERROR.        
        ELSE
            ASSIGN cAssignFieldTable = "":U.

        /* Check for Renamed Field */
        IF cAssignFieldTable EQ "":U THEN 
            hTableFieldBuffer:FIND-FIRST(" WHERE ":U + hTableFieldBuffer:NAME + "._Field-name = ":U + QUOTER(cActualFieldName)) NO-ERROR.
        ELSE
            hTableFieldBuffer:FIND-FIRST(" WHERE ":U
                                         + hTableFieldBuffer:NAME + ".tTableName = ":U + QUOTER(cAssignFieldTable) + " AND ":U
                                         + hTableFieldBuffer:NAME + "._Field-name = ":U + QUOTER(cActualFieldName) ) NO-ERROR.
        IF hTableFieldBuffer:AVAILABLE AND CAN-DO(pcDisplayedFields, ENTRY(iFieldLoop,cAllFieldList)) THEN
        DO:
            ASSIGN iFieldsInColumn = iFieldsInColumn + 1.
            
            CREATE ttFrameField.
            ASSIGN ttFrameField.tTableName         = hTableFieldBuffer:BUFFER-FIELD("tTableName":U):BUFFER-VALUE
                   ttFrameField.tTableDumpName     = hTableFieldBuffer:BUFFER-FIELD("tTableDumpName":U):BUFFER-VALUE
                   ttFrameField.tEntityObjectField = hTableFieldBuffer:BUFFER-FIELD("tEntityObjectField":U):BUFFER-VALUE
                   ttFrameField.tKeyField          = hTableFieldBuffer:BUFFER-FIELD("tKeyField":U):BUFFER-VALUE
                   ttFrameField.tOrder             = iFieldsInColumn
                   ttFrameField.tFormat            = hTableFieldBuffer:BUFFER-FIELD("_Format":U):BUFFER-VALUE
                   ttFrameField.tDataType          = hTableFieldBuffer:BUFFER-FIELD("_Data-type":U):BUFFER-VALUE
                   ttFrameField.tLabel             = hTableFieldBuffer:BUFFER-FIELD("_Label":U):BUFFER-VALUE
                   ttFrameField.tHelp              = hTableFieldBuffer:BUFFER-FIELD("_Help":U):BUFFER-VALUE
                   ttFrameField.tInitialValue      = hTableFieldBuffer:BUFFER-FIELD("_Initial":U):BUFFER-VALUE
                   ttFrameField.tViewAs            = hTableFieldBuffer:BUFFER-FIELD("_View-as":U):BUFFER-VALUE
                   ttFrameField.tSortOrder         = STRING(iFieldLoop, "99999":U)
                   ttFrameField.tDBFieldName       = hTableFieldBuffer:BUFFER-FIELD("_Field-name":U):BUFFER-VALUE
                   ttFrameField.tEnabled           = CAN-DO(pcEnabledFields, ttFrameField.tDbFieldName)
                   cViewAs                         = hTableFieldBuffer:BUFFER-FIELD("_View-as":U):BUFFER-VALUE.

            /* Set the FieldName */
            IF cActualFieldName <> ENTRY(iFieldLoop,cAllFieldList) THEN
                ASSIGN ttFrameField.tFieldName   = ENTRY(iFieldLoop, cAllFieldList).
            ELSE
                ASSIGN ttFrameField.tFieldName   = ttFrameField.tDBFieldName.

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
                                              ELSE MAX(iFieldLength, DYNAMIC-FUNCTION("getWidgetSizeFromFormat":U IN TARGET-PROCEDURE,
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
                                ASSIGN dFieldWidth = DYNAMIC-FUNCTION("getWidgetSizeFromFormat":U IN TARGET-PROCEDURE,
                                                                      INPUT ttFrameField.tFormat, INPUT "CHARACTER":U, OUTPUT dFieldHeight).
                        END CASE.   /* field length */
                    END.    /* not character or logical */

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

    DELETE OBJECT hTableFieldBuffer NO-ERROR.
    ASSIGN hTableFieldBuffer = ?.      

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

    ASSIGN hAttributeBuffer = BUFFER ttStoreAttribute:HANDLE
           hAttributeTable  = ?.

    /* We need to compare default values set at the class and master object 
     * level to ensure that we do not add attributes at instance level that
     * will cause unnecessary duplication of values */
    DYNAMIC-FUNCTION("cleanStoreAttributeValues":U IN TARGET-PROCEDURE,
                     INPUT pcObjectName,        /* pcObjectName     */
                     INPUT pcObjectTypeCode,    /* pcClassName      */
                     INPUT "CLASS":U,           /* pcCleanToLevel   */
                     INPUT hAttributeBuffer   ).
    
    RUN insertObjectMaster IN TARGET-PROCEDURE ( INPUT  pcObjectName,                             /* pcObjectName         */
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
        RUN removeObjectInstance IN TARGET-PROCEDURE ( INPUT pcObjectName,
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

        ASSIGN hAttributeBuffer = BUFFER ttStoreAttribute:HANDLE
               hAttributeTable  = ?.

        /* We need to compare default values set at the class and master object 
         * level to ensure that we do not add attributes at instance level that
         * will cause unnecessary duplication of values */
        DYNAMIC-FUNCTION("cleanStoreAttributeValues":U IN TARGET-PROCEDURE,
                         INPUT (ttFrameField.tTableName + ".":U + ttFrameField.tDBFieldName),   /* pcObjectName   */
                         INPUT "":U,                                                            /* pcClassName    */
                         INPUT "MASTER":U,                                                      /* pcCleanToLevel */
                         INPUT hAttributeBuffer   ).

        RUN insertObjectInstance IN TARGET-PROCEDURE ( INPUT  pdVisualObjectObj,                        /* pdContainerObjectObj               */
                                                       INPUT  (ttFrameField.tTableName + ".":U + ttFrameField.tDBFieldName),
                                                       INPUT  pcResultCode,                             /* pcResultCode,                      */
                                                       INPUT  ttFrameField.tFieldName,                  /* pcInstanceName                     */
                                                       INPUT  "":U,                                     /* pcInstanceDescription,             */
                                                       INPUT  "":U,                                     /* pcLayoutPosition,                  */
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

    DELETE OBJECT hTableFieldBuffer NO-ERROR.
    ASSIGN hTableFieldBuffer = ?.

    DELETE OBJECT hTableFieldTable NO-ERROR.
    ASSIGN hTableFieldTable = ?.

    DELETE OBJECT hDesignFrame NO-ERROR.
    ASSIGN hDesignFrame = ?.
    /* E - O - F */
