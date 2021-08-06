/*---------------------------------------------------------------------------------
  File: rydynsdvvc.i

  Description:  validateClass in rydynsdvcp.p

  Purpose:      This procedure customises the viewer object, before passing it back 
                to the client. This code appears in an inlcude because it blows the
                section editor limits.
                
  Parameters:   These parameters appear here for reference only.
    DEFINE INPUT PARAMETER phObjectBuffer               AS HANDLE       NO-UNDO. 
    DEFINE INPUT PARAMETER pcLogicalObjectName          AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pcResultCode                 AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pdUserObj                    AS DECIMAL      NO-UNDO.
    DEFINE INPUT PARAMETER pcRunAttribute               AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pdLanguageObj                AS DECIMAL      NO-UNDO.


  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   18/06/2002  Author:     Peter Judge

  Update Notes: Created from scratch.

---------------------------------------------------------------------------*/
    DEFINE VARIABLE cSdoProcedureName           AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cSecuredFields              AS CHARACTER            NO-UNDO.
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
    DEFINE VARIABLE hSdo                        AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hRowObjectBuffer            AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hField                      AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hAttributeBuffer            AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hColumnHandle               AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hDbColumnHandle             AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hQuery                      AS HANDLE               NO-UNDO.
    DEFINE VARIABLE lViewerShowPopup            AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE lLocalField                 AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE lEnabled                    AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE lHidden                     AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE lReadOnly                   AS LOGICAL              NO-UNDO.
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
    DEFINE VARIABLE dNewLabelLength             AS DECIMAL              NO-UNDO.

    EMPTY TEMP-TABLE ttTranslate.

    /* Security */
    /* A list of the secured fields and their security type
     * are returned. Entry 1 is table.fieldname. Entry 2 is
     * either "Hidden" or "Read Only".                      */
    RUN fieldSecurityCheck IN gshSecurityManager ( INPUT  pcLogicalObjectName,
                                                   INPUT  pcRunAttribute,
                                                   OUTPUT cSecuredFields      ).

    /* Tokens are ued to secure buttons, etc. The secured tokens which are 
     * returned by this API are to be disabled.                             */
    RUN tokenSecurityCheck IN gshSecurityManager ( INPUT  pcLogicalObjectName,
                                                   INPUT  pcRunAttribute,
                                                   OUTPUT cSecuredTokens      ).

    phObjectBuffer:FIND-FIRST(" WHERE ":U
                              + phObjectBuffer:NAME + ".tContainerObjectName = '" + pcLogicalObjectName   + "' AND ":U
                              + phObjectBuffer:NAME + ".tLogicalObjectName   = '" + pcLogicalObjectName   + "' AND ":U
                              + phObjectBuffer:NAME + ".tResultCode          = '" + pcResultCode          + "' AND ":U
                              + phObjectBuffer:NAME + ".tUserObj             = '" + STRING(pdUserObj)     + "' AND ":U
                              + phObjectBuffer:NAME + ".tRunAttribute        = '" + pcRunAttribute        + "' AND ":U
                              + phObjectBuffer:NAME + ".tLanguageObj         = '" + STRING(pdLanguageObj) + "' ":U    ).

    /* If the ShowPopup attribute is set to NO for the viewer, no popups should appear. */
    ASSIGN hAttributeBuffer = phObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE.
    hAttributeBuffer:FIND-FIRST(" WHERE ":U
                                + hAttributeBuffer:NAME + ".tRecordIdentifier = '" 
                                + STRING(phObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE)
                                + "' ":U) NO-ERROR.

    ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("ShowPopup":U) NO-ERROR.
    IF VALID-HANDLE(hField) THEN
        ASSIGN lViewerShowPopup = hField:BUFFER-VALUE. 

    /* Start the design SDO to extract some information for some columns. */
    ASSIGN cSdoProcedureName = phObjectBuffer:BUFFER-FIELD("tSdoPathedFilename":U):BUFFER-VALUE.

    IF cSdoProcedureName NE "":U AND cSdoProcedureName NE ? THEN
    DO ON STOP  UNDO, LEAVE ON ERROR UNDO, LEAVE:
        RUN VALUE(cSdoProcedureName) PERSISTENT SET hSDO NO-ERROR.
    END.

    IF VALID-HANDLE(hSDO) THEN
        {get rowObject hRowObjectBuffer hSDO}.

    CREATE QUERY hQuery.
    hQuery:ADD-BUFFER(phObjectBuffer).
    hQuery:QUERY-PREPARE(" FOR EACH ":U + phObjectBuffer:NAME + " WHERE ":U
                         + phObjectBuffer:NAME + ".tContainerObjectName = '" + pcLogicalObjectName   + "' AND ":U
                         + phObjectBuffer:NAME + ".tLogicalObjectName  <> '" + pcLogicalObjectName   + "' AND ":U
                         + phObjectBuffer:NAME + ".tResultCode          = '" + pcResultCode          + "' AND ":U
                         + phObjectBuffer:NAME + ".tUserObj             = '" + STRING(pdUserObj)     + "' AND ":U
                         + phObjectBuffer:NAME + ".tRunAttribute        = '" + pcRunAttribute        + "' AND ":U
                         + phObjectBuffer:NAME + ".tLanguageObj         = '" + STRING(pdLanguageObj) + "' ":U
                         + " NO-LOCK ":U ).

    hQuery:QUERY-OPEN().
    hQuery:GET-FIRST().

    ASSIGN dAddCol   = 0
           dMinCol   = 0
           dFirstCol = 0
           .
    /** First make sure that all fields have valid values.
     *  ----------------------------------------------------------------------- **/
    DO WHILE phObjectBuffer:AVAILABLE:    
        ASSIGN hAttributeBuffer = phObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE
               iWidgetCounter   = iWidgetCounter + 1
               .
        hAttributeBuffer:FIND-FIRST(" WHERE ":U
                                    + hAttributeBuffer:NAME + ".tRecordIdentifier = '" 
                                    + STRING(phObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE)
                                    + "' ":U) NO-ERROR.

        /* Visualisation */
        ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("VisualizationType":U) NO-ERROR.
        IF VALID-HANDLE(hField) THEN
        DO:
            IF hField:BUFFER-VALUE EQ ? OR hField:BUFFER-VALUE EQ "":U THEN
                ASSIGN hField:BUFFER-VALUE = "FILL-IN":U.

            ASSIGN cWidgetType = hField:BUFFER-VALUE.
        END.    /* valid field */

        ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("NAME":U) NO-ERROR.
        IF NOT VALID-HANDLE(hField) THEN
            ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("FieldName":U) NO-ERROR.
        IF NOT VALID-HANDLE(hField) THEN
            ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("WidgetName":U) NO-ERROR.

        IF VALID-HANDLE(hField) THEN
        DO:
            ASSIGN cWidgetName = hField:BUFFER-VALUE.
            IF VALID-HANDLE(hRowObjectBuffer) THEN
                ASSIGN hColumnHandle = hRowObjectBuffer:BUFFER-FIELD(cWidgetName) NO-ERROR.
        END.    /* valid field. */
        ELSE
            ASSIGN cWidgetName = cWidgetType + "-":U + STRING(iWidgetCounter).

        /* Table Name */
        ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("TableName":U) NO-ERROR.
        IF VALID-HANDLE(hField) AND VALID-HANDLE(hColumnHandle) THEN
        DO:
            IF DYNAMIC-FUNCTION("getWhereStoredLevel":U IN gshRepositoryManager, INPUT hAttributeBuffer, INPUT hField) EQ "CLASS":U THEN
                ASSIGN hField:BUFFER-VALUE = hColumnHandle:TABLE.
            ASSIGN lLocalField = NO.
        END.    /* Table */
        ELSE
        IF cWidgetType EQ "SmartDataField":U THEN
            ASSIGN lLocalField = NOT VALID-HANDLE(hColumnHandle).
        ELSE
            ASSIGN lLocalField = YES.

        /* Initial Value */
        ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("InitialValue":U) NO-ERROR.
        IF VALID-HANDLE(hField) AND VALID-HANDLE(hColumnHandle) THEN
        DO:
            IF DYNAMIC-FUNCTION("getWhereStoredLevel":U IN gshRepositoryManager, INPUT hAttributeBuffer, INPUT hField) EQ "CLASS":U THEN
                ASSIGN hField:BUFFER-VALUE = hColumnHandle:INITIAL.
        END.    /* Initial Value */

        /* Tab Order */
        ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("Order":U) NO-ERROR.
        IF VALID-HANDLE(hField) THEN
        DO:
            IF VALID-HANDLE(hColumnHandle) AND 
               DYNAMIC-FUNCTION("getWhereStoredLevel":U IN gshRepositoryManager, INPUT hAttributeBuffer, INPUT hField) EQ "CLASS":U THEN
                ASSIGN hField:BUFFER-VALUE = hColumnHandle:POSITION - 1.

            IF hField:BUFFER-VALUE EQ ? THEN
                ASSIGN hField:BUFFER-VALUE = 0.

            ASSIGN iMaxInstanceOrder = MAX(iMaxInstanceOrder, hField:BUFFER-VALUE).
        END.    /* Tab order */

        /* If we have auto-attached and SDF to a local fill-in, we need to set the FieldName attribute 
         * to "<Local>", so that we know which property to store that handle in.                       */        
        IF cWidgetType EQ "SmartDataField":U THEN
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
            IF VALID-HANDLE(hColumnHandle) AND
               DYNAMIC-FUNCTION("getWhereStoredLevel":U IN gshRepositoryManager, INPUT hAttributeBuffer, INPUT hField) EQ "CLASS":U THEN
                ASSIGN hField:BUFFER-VALUE = hColumnHandle:DATA-TYPE.
            
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
            IF cWidgetType EQ "SmartDataField":U THEN
                ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("FieldLabel":U) NO-ERROR.            
            ELSE
                ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("LABEL":U) NO-ERROR.

            IF VALID-HANDLE(hField) THEN
            DO:
                IF VALID-HANDLE(hColumnHandle) AND
                   DYNAMIC-FUNCTION("getWhereStoredLevel":U IN gshRepositoryManager, INPUT hAttributeBuffer, INPUT hField) EQ "CLASS":U THEN
                    ASSIGN hField:BUFFER-VALUE = hColumnHandle:LABEL.

                IF hField:BUFFER-VALUE EQ ? OR hField:BUFFER-VALUE EQ "":U THEN
                    ASSIGN hField:BUFFER-VALUE = REPLACE(cWidgetName, "_":U, " ":U).
    
                IF LOOKUP(cWidgetType, "{&FORCE-NO-LABEL-TYPES}":U) GT 0 THEN
                    ASSIGN hField:BUFFER-VALUE = ?.  /* Force NO-LABEL */
                ELSE
                IF LOOKUP(cWidgetType, "{&NO-COLON-LABEL-TYPES}":U) EQ 0 THEN
                    ASSIGN hField:BUFFER-VALUE = hField:BUFFER-VALUE + ": ":U.

                ASSIGN cLabel = hField:BUFFER-VALUE.
            END.    /* is a label field available */
        END.    /* use a label */

        /* Format */
        ASSIGN cFormat = "":U
               hField  = hAttributeBuffer:BUFFER-FIELD("Format":U)
               NO-ERROR.
        IF VALID-HANDLE(hField) THEN
        DO:
            IF VALID-HANDLE(hColumnHandle) AND
               DYNAMIC-FUNCTION("getWhereStoredLevel":U IN gshRepositoryManager, INPUT hAttributeBuffer, INPUT hField) EQ "CLASS":U THEN
                ASSIGN hField:BUFFER-VALUE = hColumnHandle:FORMAT.

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
            IF VALID-HANDLE(hColumnHandle) AND
               DYNAMIC-FUNCTION("getWhereStoredLevel":U IN gshRepositoryManager, INPUT hAttributeBuffer, INPUT hField) EQ "CLASS":U THEN
                ASSIGN hField:BUFFER-VALUE = hColumnHandle:WIDTH-CHARS.

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
                                                                                 , iFont).
                    OTHERWISE
                        ASSIGN hField:BUFFER-VALUE = FONT-TABLE:GET-TEXT-WIDTH-CHARS(cFormat, iFont).
                END CASE.   /* data type */
            END.    /* invalid width */
        END.    /* width */

        /* Tooltip */
        IF cWidgetType EQ "SmartDataField":U THEN
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

            ASSIGN dMaxRow                                                       = MAX(dMaxRow, hField:BUFFER-VALUE)
                   phObjectBuffer:BUFFER-FIELD("tLayoutPosition":U):BUFFER-VALUE = STRING(hField:BUFFER-VALUE)
                   .
        END.    /* ROW */
        ELSE
            ASSIGN phObjectBuffer:BUFFER-FIELD("tLayoutPosition":U):BUFFER-VALUE = "?":U.

        /* Column */
        ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("COLUMN":U) NO-ERROR.
        IF VALID-HANDLE(hField) THEN
        DO:
            /* If there is no column specified, put the  field on the left-hand side of the viewer. */
            IF hField:BUFFER-VALUE EQ ? OR hField:BUFFER-VALUE EQ 0 THEN
                ASSIGN hField:BUFFER-VALUE = dLabelWidth + 1.

            ASSIGN phObjectBuffer:BUFFER-FIELD("tLayoutPosition":U):BUFFER-VALUE = phObjectBuffer:BUFFER-FIELD("tLayoutPosition":U):BUFFER-VALUE
                                                                                 + ",":U + STRING(hField:BUFFER-VALUE).
        END.    /* Column */
        ELSE
            ASSIGN phObjectBuffer:BUFFER-FIELD("tLayoutPosition":U):BUFFER-VALUE = phObjectBuffer:BUFFER-FIELD("tLayoutPosition":U):BUFFER-VALUE
                                                                                 + ",?":U.

        /** Security
         *  ----------------------------------------------------------------------- **/
        IF NOT VALID-HANDLE(hColumnHandle) AND 
           cWidgetName NE "":U AND 
           VALID-HANDLE(hSDO) THEN
          ASSIGN cTableName = DYNAMIC-FUNCTION("columnTable":U IN hSDO, INPUT cWidgetName).

        IF cTableName EQ "":U OR cTableName EQ ? THEN
            ASSIGN cFieldName = cWidgetName.
        ELSE
            ASSIGN cFieldName = cTableName + ".":U + cWidgetName.

        IF cFieldName NE "":U THEN
        DO:        
            /* These variables are set to default values only to be able to 
             * determine if they have changed. Only if the values have changed 
             * are they set for the widgets.                                   */
            ASSIGN lEnabled  = YES
                   lHidden   = NO
                   lReadOnly = NO
                   .
            IF CAN-DO(cSecuredFields, cFieldName) THEN
            DO:
                IF ENTRY(LOOKUP(cFieldName, cSecuredFields) + 1, cSecuredFields) EQ "Hidden":U THEN
                    ASSIGN lHidden = YES.
                ELSE
                    ASSIGN lReadOnly = YES.
            END.    /* is a secured field */
            ELSE
            IF CAN-DO(cSecuredTokens, cFieldName) THEN
                ASSIGN lEnabled = NO.
    
            IF NOT lEnabled THEN
            DO:
                IF cWidgetType EQ "SmartDataField":U THEN
                    ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("EnableField":U) NO-ERROR.
                ELSE
                    ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("ENABLED":U) NO-ERROR.
    
                IF VALID-HANDLE(hField) THEN
                    ASSIGN hField:BUFFER-VALUE = NO.
            END.    /* not enabled */
    
            IF lHidden THEN
            DO:
                ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("VISIBLE":U) NO-ERROR.
                IF VALID-HANDLE(hField) THEN
                    ASSIGN hField:BUFFER-VALUE = NO.
            END.    /* hidden field */
    
            IF lReadOnly THEN
            DO:
                ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("READ-ONLY":U) NO-ERROR.
                IF VALID-HANDLE(hField) THEN
                    ASSIGN hField:BUFFER-VALUE = YES.
            END.    /* read only */
        END.    /* field name exists. */

        /** Delimiters. We try to avoid issues where the decimal point and the delimiter
         * of the widget are the same.
         *  ----------------------------------------------------------------------- **/
        IF CAN-DO("{&WIDGETS-WITH-DELIMITERS}":U, cWidgetType) THEN
            ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("DELIMITER":U) NO-ERROR.
        IF VALID-HANDLE(hField) THEN
        DO:
            IF cDataType                     EQ "DECIMAL":U         AND
               SESSION:NUMERIC-DECIMAL-POINT EQ hField:BUFFER-VALUE THEN
                ASSIGN hField:BUFFER-VALUE = CHR(3).
        END.    /* has a delimiter. */

        /** Translations
         *  ----------------------------------------------------------------------- **/
        EMPTY TEMP-TABLE ttTranslate.

        IF cWidgetType EQ "RADIO-SET":U THEN
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
                           ttTranslate.cWidgetName        = cFieldName
                           ttTranslate.hWidgetHandle      = hWidget
                           ttTranslate.iWidgetEntry       = (iRadioLoop + 1) / 2
                           ttTranslate.cOriginalLabel     = ENTRY(iRadioLoop, cRadioButtons)
                           ttTranslate.cTranslatedLabel   = "":U
                           ttTranslate.cOriginalTooltip   = cTooltip
                           ttTranslate.cTranslatedTooltip = "":U
                           .
                END.    /* radio button loop */
            END.    /* has radio buttons */
        END.    /* radio sets */
        ELSE
        DO:
            CREATE ttTranslate.
            ASSIGN ttTranslate.dLanguageObj       = 0
                   ttTranslate.cObjectName        = pcLogicalObjectName + (IF cWidgetType EQ "SmartDataField":U THEN ":":U + cFieldName ELSE "":U)
                   ttTranslate.lGlobal            = NO
                   ttTranslate.lDelete            = NO
                   ttTranslate.cWidgetType        = cWidgetType
                   ttTranslate.cWidgetName        = cFieldName
                   ttTranslate.hWidgetHandle      = ?
                   ttTranslate.iWidgetEntry       = 0
                   ttTranslate.cOriginalLabel     = cLabel
                   ttTranslate.cTranslatedLabel   = "":U
                   ttTranslate.cOriginalTooltip   = cTooltip
                   ttTranslate.cTranslatedTooltip = "":U
                   .
        END. /* not a radio-set */

        /* Get the translated strings. */
        RUN multiTranslation IN gshTranslationManager ( INPUT NO, INPUT-OUTPUT TABLE ttTranslate).

        /* There will usually only be on entry in this TT. Radio
         * sets are the exception.                               */
        FOR EACH ttTranslate:
            CASE cWidgetType:
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

            /** Resize Based on translations 
             *  ----------------------------------------------------------------------- **/
            IF NOT(ttTranslate.cTranslatedLabel EQ "":U AND ttTranslate.cTranslatedTooltip EQ "":U )  AND
               NOT(ttTranslate.cWidgetType EQ "BROWSE":U OR ttTranslate.cWidgetType EQ "RADIO-SET":U) THEN
            DO:
                ASSIGN dNewLabelLength = FONT-TABLE:GET-TEXT-WIDTH-CHARS(ttTranslate.cTranslatedLabel, iFont)
                       dMinCol         = MAXIMUM(dMinCol, dNewLabelLength + 1.2)
                       .
                ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("COLUMN":U) NO-ERROR.
                IF VALID-HANDLE(hField) THEN
                DO:
                    IF hField:BUFFER-VALUE LT dFirstCol OR
                       dFirstCol           EQ 0         THEN
                        ASSIGN dFirstCol = hField:BUFFER-VALUE.
                END.    /* column exists */
            END.    /* we want to resize. */
        END.    /* each ttTranslate. */

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
                IF cDataType  EQ "DECIMAL":U    AND
                   cFieldName MATCHES "*_obj":U THEN
                    ASSIGN hField:BUFFER-VALUE = NO.
            END.    /* can use ShowPopup */
        END.    /* can use ShowPopup  */

        hQuery:GET-NEXT().
    END.    /* each object on the viewer. */
    
    /* Kill the SDO if it is running. */
    IF VALID-HANDLE(hSDO) THEN
        RUN destroyObject IN hSDO.

    /** Make sure that all widgets have an order, a row and a column.
     * ALso make sure that the viewer still looks OK after translating things.
     *  ----------------------------------------------------------------------- **/
    hQuery:GET-FIRST().
    DO WHILE phObjectBuffer:AVAILABLE:    
        ASSIGN hAttributeBuffer = phObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE
               iWidgetCounter   = iWidgetCounter + 1
               .
        hAttributeBuffer:FIND-FIRST(" WHERE ":U
                                    + hAttributeBuffer:NAME + ".tRecordIdentifier = '" 
                                    + STRING(phObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE)
                                    + "' ":U) NO-ERROR.        

        IF phObjectBuffer:BUFFER-FIELD("tInstanceOrder":U):BUFFER-VALUE EQ 0 THEN
            ASSIGN iMaxInstanceOrder                                            = iMaxInstanceOrder + 1
                   phObjectBuffer:BUFFER-FIELD("tInstanceOrder":U):BUFFER-VALUE = iMaxInstanceOrder
                   .
        ASSIGN dRow    = DECIMAL(ENTRY(1, phObjectBuffer:BUFFER-FIELD("tLayoutPosition":U):BUFFER-VALUE))
               dColumn = DECIMAL(ENTRY(2, phObjectBuffer:BUFFER-FIELD("tLayoutPosition":U):BUFFER-VALUE))
               NO-ERROR.

        ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("VisualizationType":U) NO-ERROR.
        IF VALID-HANDLE(hField) THEN
            ASSIGN cWidgetType = hField:BUFFER-VALUE.

        IF dMinCol GT 0 AND dFirstCol GT 0 THEN
            ASSIGN dAddCol = (dMinCol - dFirstCol) + 1.
        ELSE
            ASSIGN dAddCol = 0.

        /* Make sure that we have valid values */
        IF dRow EQ ? THEN
            ASSIGN dMaxRow = dMaxRow + 1
                   dRow    = dMaxRow
                   .
        IF dColumn EQ ? THEN
            ASSIGN dColumn = 1.

        /* Do we need to resize? */
        IF dAddCol GT 0 THEN
            ASSIGN dColumn =  dColumn + dAddCol.

        /* Put the entries back into the layout position. */
        ASSIGN phObjectBuffer:BUFFER-FIELD("tLayoutPosition":U):BUFFER-VALUE = STRING(dRow) + ",":U + STRING(dColumn).

        hQuery:GET-NEXT().
    END.    /* order */
    hQuery:QUERY-CLOSE().

    DELETE OBJECT hQuery NO-ERROR.
    ASSIGN hQuery = ?
           hField = ?
           .
    /* EOF */
