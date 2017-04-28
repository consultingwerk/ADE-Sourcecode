/* Copyright © 1984-2007 by Progress Software Corporation.  All rights 
   reserved.  Prior versions of this work may contain portions 
   contributed by participants of Possenet.  */   
/*---------------------------------------------------------------------------------
  File: rydynvcroi.i

  Description:  createObjects API for dynviewerp.p

  Purpose:      createObjects API for dynviewerp.p.
                Code moved to this include to prevent blowing section editor limits.

  Parameters:

  History:
  --------
  (v:010000)    Task:          00   UserRef:    
                Date:   30/07/2003  Author:     Neil Bell

  Update Notes: Create include

---------------------------------------------------------------------------------*/
DEFINE VARIABLE hField                      AS HANDLE               NO-UNDO.
DEFINE VARIABLE dInstanceId                 AS DECIMAL              NO-UNDO.
DEFINE VARIABLE cDataSourceNames            AS CHARACTER            NO-UNDO.
DEFINE VARIABLE lObjectTranslated           AS LOGICAL              NO-UNDO.
DEFINE VARIABLE hLabel                      AS HANDLE               NO-UNDO.
DEFINE VARIABLE hPopup                      AS HANDLE               NO-UNDO.
DEFINE VARIABLE hDataFieldProcedure         AS HANDLE               NO-UNDO.
DEFINE VARIABLE hPreviousWidget             AS HANDLE               NO-UNDO.
DEFINE VARIABLE dFrameWidth                 AS DECIMAL              NO-UNDO.
DEFINE VARIABLE dFrameHeight                AS DECIMAL              NO-UNDO.
DEFINE VARIABLE dWidgetWidth                AS DECIMAL              NO-UNDO.
DEFINE VARIABLE dWidgetHeight               AS DECIMAL              NO-UNDO.
DEFINE VARIABLE dColumnPosition             AS DECIMAL              NO-UNDO.
DEFINE VARIABLE dRowPosition                AS DECIMAL              NO-UNDO.
DEFINE VARIABLE dFrameMinHeight             AS DECIMAL              NO-UNDO.
DEFINE VARIABLE dFrameMinWidth              AS DECIMAL              NO-UNDO.
DEFINE VARIABLE iLabelWidthP                AS INTEGER              NO-UNDO.
DEFINE VARIABLE dLabelMinHeight             AS DECIMAL              NO-UNDO.
DEFINE VARIABLE hDefaultFrame               AS HANDLE               NO-UNDO.
DEFINE VARIABLE cDisplayedFields            AS CHARACTER            NO-UNDO.
DEFINE VARIABLE cFieldHandles               AS CHARACTER            NO-UNDO.
DEFINE VARIABLE cEnabledFields              AS CHARACTER            NO-UNDO.    
DEFINE VARIABLE cEnabledHandles             AS CHARACTER            NO-UNDO.    
DEFINE VARIABLE cEnabledObjFlds             AS CHARACTER            NO-UNDO.
DEFINE VARIABLE cEnabledObjHdls             AS CHARACTER            NO-UNDO.
DEFINE VARIABLE cAllFieldHandles            AS CHARACTER            NO-UNDO.
DEFINE VARIABLE cAllFieldNames              AS CHARACTER            NO-UNDO.
DEFINE VARIABLE cFieldSecurity              AS CHARACTER            NO-UNDO.
DEFINE VARIABLE lPopupButtonInField         AS LOGICAL              NO-UNDO.
DEFINE VARIABLE lHideOnInit                 AS LOGICAL              NO-UNDO.
DEFINE VARIABLE lViewerShowPopup            AS LOGICAL              NO-UNDO.
DEFINE VARIABLE cFieldPopupMapping          AS CHARACTER            NO-UNDO.
DEFINE VARIABLE iPageNumber                 AS INTEGER              NO-UNDO.
DEFINE VARIABLE cPropertyNames              AS CHARACTER            NO-UNDO.
DEFINE VARIABLE cPropertyValues             AS CHARACTER            NO-UNDO.
DEFINE VARIABLE cSecuredFields              AS CHARACTER            NO-UNDO.
DEFINE VARIABLE cSecuredTokens              AS CHARACTER            NO-UNDO.
DEFINE VARIABLE lHasLabel                   AS LOGICAL              NO-UNDO.
DEFINE VARIABLE lKeepPositions              AS LOGICAL              NO-UNDO.
DEFINE VARIABLE iAttributeEntry             AS INTEGER              NO-UNDO.
DEFINE VARIABLE cClassName                  AS CHARACTER            NO-UNDO.
DEFINE VARIABLE lLocalField                 AS LOGICAL              NO-UNDO.
DEFINE VARIABLE cInstanceProperties         AS CHARACTER            NO-UNDO.

DEFINE VARIABLE cPhysicalFilename AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cWidgetName       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dHeight           AS DECIMAL    NO-UNDO.
DEFINE VARIABLE lDisplayField     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lEnabled          AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cPrivateData      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFormat           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDataType         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lShowPopup        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE iLabelFont        AS INTEGER    NO-UNDO.
DEFINE VARIABLE iLabelBGColor     AS INTEGER    NO-UNDO.
DEFINE VARIABLE iLabelFgColor     AS INTEGER    NO-UNDO.
DEFINE VARIABLE lUseThinRendering AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cSDFDataSource    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lUseWidgetID      AS LOGICAL    NO-UNDO.

/* Is this viewer a generated object? If so, then we don't need
   to create the widgets dynamically, since they are created in the
   generated procedure itself.
 */
IF NOT CAN-DO(TARGET-PROCEDURE:INTERNAL-ENTRIES, 'adm-assignObjectProperties') THEN
do:
    /* Don't do this more than once. */
    IF {fn getObjectsCreated} THEN
        RETURN.

    ASSIGN lUseWidgetID = DYNAMIC-FUNCTION('getUseWidgetID':U IN TARGET-PROCEDURE).

    /* Get the InstanceID of the viewer. We use this to determine what the contained instances are.
     * Also, use the ObjectName property since this contains the instance name of this viewer (as opposed
     * to the object filename/logical object name). This is the name that is used to cache this object.
     */
    &SCOPED-DEFINE xp-assign
    {get InstanceId dInstanceID}
    {get DataSourceNames cDataSourceNames}
    {get ContainerHandle hDefaultFrame}
    {get HideOnInit lHideOnInit}
    {get PopupButtonsInFields lPopupButtonInField}
    {get KeepChildPositions lKeepPositions}
    {get ObjectPage iPageNumber}.
    &UNDEFINE xp-assign
    
    /* Make sure we start from scratch */
    FOR EACH ttWidget WHERE ttWidget.tTargetProcedure = TARGET-PROCEDURE: 
      DELETE ttWidget. 
    END.

    /* Give ourselves plenty of room to work with. */
    ASSIGN hDefaultFrame:SCROLLABLE           = YES
           hDefaultFrame:VIRTUAL-HEIGHT-CHARS = SESSION:HEIGHT
           hDefaultFrame:VIRTUAL-WIDTH-CHARS  = SESSION:WIDTH
           hDefaultFrame:SCROLLABLE           = NO.

    IF cDataSourceNames EQ ? THEN
        ASSIGN cDataSourceNames = "":U.

    ASSIGN cPropertyNames = "ShowPopup":U.
    /* Pass in the instance Id to find the record because we want to get the
       right record, as quickly as possible.
     */
    RUN getInstanceProperties IN gshRepositoryManager ( INPUT        STRING(dInstanceID),
                                                        INPUT        "":U,
                                                        INPUT-OUTPUT cPropertyNames,
                                                              OUTPUT cPropertyValues ) NO-ERROR.                                                                                                                        
    ASSIGN lViewerShowPopup = LOGICAL(ENTRY(LOOKUP("ShowPopup":U, cPropertyNames), cPropertyValues, {&Value-Delimiter})) NO-ERROR.
    IF lViewerShowPopup EQ ? THEN
        ASSIGN lViewerShowPopup = YES.

    /* Determine whether the popup buttons should be in the field or not. */
    IF lPopupButtonInField EQ ? THEN
        ASSIGN lPopupButtonInField = NO.

    IF NOT VALID-HANDLE(ghCacheObject) THEN
        RUN returnCacheBuffers IN gshRepositoryManager ( OUTPUT ghCacheObject,
                                                         OUTPUT ghCachePage,
                                                         OUTPUT ghCacheLink     ).
    /* Ain't gonna do nuttin' without the cache records. */
    IF NOT VALID-HANDLE(ghCacheObject) THEN
        RETURN.

    /* Set defaults */
    ASSIGN lObjectTranslated        = NO
           gcErrorMessage           = "":U
           hDefaultFrame:SCROLLABLE = TRUE.

    /* Now process the viewer widgets */
    IF NOT VALID-HANDLE(ghRenderingQuery) THEN
        CREATE QUERY ghRenderingQuery.

    ghRenderingQuery:SET-BUFFERS(ghCacheObject).
    ghRenderingQuery:QUERY-PREPARE("FOR EACH ":U + ghCacheObject:NAME + " WHERE ":U
                                   + ghCacheObject:NAME + ".ContainerInstanceId = ":U + QUOTER(dInstanceId)
                                   + " BY ":U + ghCacheObject:NAME + ".Order ":U).
    ghRenderingQuery:QUERY-OPEN().

    ghRenderingQuery:GET-FIRST().
    DO WHILE ghCacheObject:AVAILABLE:
        /* Get all the property values from the Repository.
         */
        ASSIGN dInstanceId     = DECIMAL(ghCacheObject:BUFFER-FIELD("InstanceId":U):BUFFER-VALUE)
               cWidgetName     = ghCacheObject:BUFFER-FIELD("ObjectName":U):BUFFER-VALUE
               cPropertyNames  = "*":U
               cPropertyValues = "":U.

        RUN getInstanceProperties IN gshRepositoryManager ( INPUT        STRING(dInstanceId),
                                                            INPUT        "":U,
                                                            INPUT-OUTPUT cPropertyNames,
                                                                  OUTPUT cPropertyValues ) NO-ERROR.
        
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
        DO:
            ASSIGN gcErrorMessage  = (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
            LEAVE.
        END.    /* error retrieving properties. */

        CREATE ttWidget.

        /* We HAVE to re-initialize our variables to ensure we don't carry over the previous widget assignments */
        ASSIGN cPhysicalFilename  = ?
               dHeight            = ?
               lDisplayField      = ?
               lEnabled           = ?
               cPrivateData       = ?
               cFormat            = ?
               cDataType          = ?
               /* The default of the ShowPopup is no, since a widget is more
                  likely to have no popup that it is to have one (by observation).
                */
               lShowPopup         = NO
               iLabelFont         = ?
               iLabelBGColor      = ?
               iLabelFgColor      = ?

               ttWidget.tTargetProcedure   = TARGET-PROCEDURE.

        /* We only want to reposition objects if translation occurred. To do this we will set this variable and check it before
           we run the extra code.
         */
        ASSIGN ttWidget.tTranslated = LOGICAL(ENTRY(LOOKUP("ObjectHasTranslation":U, cPropertyNames), cPropertyValues, {&Value-Delimiter})) NO-ERROR.
        If ttWidget.tTranslated EQ ? THEN
            ASSIGN ttWidget.tTranslated = NO.

        IF NOT lObjectTranslated 
        AND ttWidget.tTranslated THEN
            ASSIGN lObjectTranslated = TRUE.

        /* Retrieve the security */
        ASSIGN cSecuredFields  = ENTRY(LOOKUP("FieldSecurity":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}) NO-ERROR.
        ASSIGN cSecuredTokens  = ENTRY(LOOKUP("SecuredTokens":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}) NO-ERROR.

        ASSIGN ttWidget.tWidgetType = ENTRY(LOOKUP("VisualizationType":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}) NO-ERROR.
        IF ttWidget.tWidgetType EQ "":U OR ttWidget.tWidgetType EQ ? THEN
          ASSIGN ttWidget.tWidgetType = "FILL-IN":U.
        ASSIGN cClassName = ENTRY(LOOKUP("ClassName":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}) NO-ERROR.

        ASSIGN ttWidget.tTabOrder = INTEGER(ENTRY(LOOKUP("Order":U, cPropertyNames), cPropertyValues, {&Value-Delimiter})) NO-ERROR.    
        ASSIGN ttWidget.tRow = DECIMAL(ENTRY(LOOKUP("Row":U, cPropertyNames), cPropertyValues, {&Value-Delimiter})) NO-ERROR.
        ASSIGN ttWidget.tColumn = DECIMAL(ENTRY(LOOKUP("Column":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}))  NO-ERROR.
        ASSIGN ttWidget.tWidth = DECIMAL(ENTRY(LOOKUP("Width-Chars":U, cPropertyNames), cPropertyValues, {&Value-Delimiter})) NO-ERROR.
        ASSIGN ttWidget.tFont = INTEGER(ENTRY(LOOKUP("Font":U, cPropertyNames), cPropertyValues, {&Value-Delimiter})) NO-ERROR.
        ASSIGN ttWidget.tInitialValue = ENTRY(LOOKUP("InitialValue":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}) NO-ERROR.

        ASSIGN lDisplayField = LOGICAL(ENTRY(LOOKUP("DisplayField":U, cPropertyNames), cPropertyValues, {&Value-Delimiter})) NO-ERROR.    
        If lDisplayField EQ ? THEN 
            ASSIGN lDisplayField = NO.

        ASSIGN dHeight = DECIMAL(ENTRY(LOOKUP("Height-Chars":U, cPropertyNames), cPropertyValues, {&Value-Delimiter})) NO-ERROR.

        /* Validation */
        IF ttWidget.tRow = ?    OR ttWidget.tRow = 0    THEN ASSIGN ttWidget.tRow = 1.
        IF ttWidget.tColumn = ? OR ttWidget.tColumn = 0 THEN ASSIGN ttWidget.tColumn = 1.       
        IF ttWidget.tWidth = ?  OR ttWidget.tWidth = 0  THEN ASSIGN ttWidget.tWidth = FONT-TABLE:GET-TEXT-WIDTH-CHARS("wwwwwwww":U, ttWidget.tFont).
        IF dHeight = ? OR dHeight = 0 THEN ASSIGN dHeight = 1.

        ASSIGN ttWidget.tEndRow = ttWidget.tRow + dHeight.

        /* Objects of type Procedure should be treated as static SDFs as far as possible. */
        IF DYNAMIC-FUNCTION("ClassIsA":U IN gshRepositoryManager, cClassName, "Field":U) OR
           DYNAMIC-FUNCTION("ClassIsA":U IN gshRepositoryManager, cClassName, "Procedure":U) THEN
        DO:        
            ASSIGN ttWidget.tWidgetType = "SmartDataField":U.
            ASSIGN ttWidget.tLabel = ENTRY(LOOKUP("FieldLabel":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}) NO-ERROR.        
            ASSIGN lEnabled = LOGICAL(ENTRY(LOOKUP("EnableField":U, cPropertyNames), cPropertyValues, {&Value-Delimiter})) NO-ERROR.
            IF lEnabled EQ ? THEN
                ASSIGN lEnabled = YES.
            ASSIGN lLocalField = LOGICAL(ENTRY(LOOKUP("LocalField":U, cPropertyNames), cPropertyValues, {&Value-Delimiter})) NO-ERROR.    
            IF lLocalField EQ ? THEN
                ASSIGN lLocalField = NO.

            ASSIGN lUseThinRendering = DYNAMIC-FUNCTION("getSessionParam":U IN TARGET-PROCEDURE,
                                                         INPUT "UseThinRendering":U ).
            ASSIGN cPhysicalFilename = IF lUseThinRendering THEN
                                         ENTRY(LOOKUP("ThinRenderingProcedure":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}) 
                                       ELSE ENTRY(LOOKUP("RenderingProcedure":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}) NO-ERROR.
            /* If using thin rendering and cPhysicalFileName is not valid, then ThinRenderingProcedure must 
               not have been set and RenderingProcedure should be used. */
            IF (cPhysicalFilename EQ "":U OR cPhysicalFilename EQ ?) AND lUseThinRendering THEN
              ASSIGN cPhysicalFilename = ENTRY(LOOKUP("RenderingProcedure":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}) NO-ERROR.

            IF cPhysicalFilename EQ "":U OR cPhysicalFilename EQ ? THEN
                ASSIGN cPhysicalFilename = ENTRY(LOOKUP("PhysicalObjectName":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}) NO-ERROR.

            /* Can't do very much without the rendering procedure ... */
            IF cPhysicalFilename EQ "":U OR cPhysicalFilename EQ ? THEN
            DO:
                ghRenderingQuery:GET-NEXT().
                NEXT.
            END.    /* no physical file */

            /* Create the object.
               We set the current logical name to the InstanceID of the instance we are creating,
               so that the correct instance can be retrieved.
             */
            {set CurrentLogicalName string(dInstanceId)}.
            cInstanceProperties = 'LogicalObjectName' + chr(4)
                                + ENTRY(LOOKUP("LogicalObjectName":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}) 
                                NO-ERROR.

            RUN constructObject IN TARGET-PROCEDURE (INPUT  cPhysicalFilename,
                                                     INPUT  hDefaultFrame:HANDLE,
                                                     INPUT  cInstanceProperties,
                                                     OUTPUT hDataFieldProcedure ).
            {set CurrentLogicalName ''}.

            RUN repositionObject IN hDataFieldProcedure (ttWidget.tRow, ttWidget.tColumn) NO-ERROR.
            RUN resizeObject     IN hDataFieldProcedure (dHeight, ttWidget.tWidth) NO-ERROR.

            &SCOPED-DEFINE xp-assign
            {get Width dWidgetWidth hDataFieldProcedure}
            {get Height dWidgetHeight hDataFieldProcedure}
            {set FieldName cWidgetName hDataFieldProcedure}.
            &UNDEFINE xp-assign

            /* Build lists of the fields to display and enable */
            IF lDisplayField AND NOT lLocalField THEN
              ASSIGN
                cDisplayedFields = cDisplayedFields + cWidgetName + ",":U
                cFieldHandles    = cFieldHandles + STRING(hDataFieldProcedure) + ",":U.    

            IF lEnabled THEN
                IF lLocalField THEN
                   ASSIGN 
                      cEnabledObjFlds = cEnabledObjFlds + cWidgetName + ",":U
                      cEnabledObjHdls = cEnabledObjHdls + STRING(hDataFieldProcedure) + ",":U.
                ELSE
                   ASSIGN
                      cEnabledFields  = cEnabledFields + cWidgetName + ",":U
                      cEnabledHandles = cEnabledHandles + STRING(hDataFieldProcedure) + ",":U.

            cSDFDataSource = ''.  
            {get DataSourceName cSDFDataSource hDataFieldProcedure} NO-ERROR.
            IF cSDFDataSource > '' THEN
              {fn createDataSource hDataFieldProcedure} NO-ERROR.

            ASSIGN dRowPosition           = ttWidget.tRow
                   dColumnPosition        = ttWidget.tColumn
                   ttWidget.tWidgetHandle = hDataFieldProcedure
                   ttWidget.tVisible      = YES
                   cFieldSecurity         = cFieldSecurity + ",":U
                                          + (IF cSecuredFields NE "":U THEN ENTRY(2, cSecuredFields) ELSE "":U) 
                   cAllFieldHandles       = cAllFieldHandles + STRING(hDataFieldProcedure) + ",":U
                   cAllFieldNames         = cAllFieldNames + cWidgetName + ",":U.

        END.    /* render the SmartDataField */
        ELSE
        DO:
            /* We have individual ASSIGN statements here because we cannot assume that the attributes referenced
             * below exist for the object type of the widget we want to create. 
             * These attributes should probably exist in the Repository, but for belts-and-braces we break the 
             * ASSIGN statements up.                                                                           */
            ASSIGN ttWidget.tVisible = LOGICAL(ENTRY(LOOKUP("Visible":U, cPropertyNames), cPropertyValues, {&Value-Delimiter})) NO-ERROR.        
            ASSIGN iLabelBGColor = INTEGER(ENTRY(LOOKUP("LabelBgColor":U, cPropertyNames), cPropertyValues, {&Value-Delimiter})) NO-ERROR.
            ASSIGN iLabelFgColor = INTEGER(ENTRY(LOOKUP("LabelFgColor":U, cPropertyNames), cPropertyValues, {&Value-Delimiter})) NO-ERROR.
            ASSIGN cPrivateData = ENTRY(LOOKUP("Private-Data":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}) NO-ERROR.
            ASSIGN cFormat = ENTRY(LOOKUP("Format":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}) NO-ERROR.
            ASSIGN cDataType = ENTRY(LOOKUP("Data-Type":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}) NO-ERROR.
            ASSIGN lEnabled = LOGICAL(ENTRY(LOOKUP("Enabled":U, cPropertyNames), cPropertyValues, {&Value-Delimiter})) NO-ERROR.
            IF lEnabled EQ ? THEN
                ASSIGN lEnabled = YES.

            /* Only certain widget types with certain data types get to have
               popups added. In addition, only add popups if this frame supports
               them, as per the ShowPopup attribute of the viewer/frame.
             */
            IF ttWidget.tWidgetType EQ "FILL-IN":U         AND
               CAN-DO("DATE,DECIMAL,INTEGER,INT64":U, cDataType) AND
               lViewerShowPopup                            THEN
            DO:
                /* Is there value set on the widget? */
                ASSIGN lShowPopup = LOGICAL(ENTRY(LOOKUP("ShowPopup":U, cPropertyNames), cPropertyValues, {&Value-Delimiter})) NO-ERROR.
                /* If there isn't then show the popup by default. */
                IF lShowPopup EQ ? THEN
                    ASSIGN lShowPopup = YES.
            END.    /* a fill-in of type dec or date */

            ASSIGN iLabelFont = INTEGER(ENTRY(LOOKUP("LabelFont":U, cPropertyNames), cPropertyValues, {&Value-Delimiter})) NO-ERROR.

            /* Some widgets may not have the LABELS attribute. */        
            ASSIGN iAttributeEntry = LOOKUP("Labels":U, cPropertyNames).
            IF iAttributeEntry GT 0 THEN
                ASSIGN lHasLabel = LOGICAL(ENTRY(iAttributeEntry, cPropertyValues, {&Value-Delimiter})) NO-ERROR.
            ELSE
                ASSIGN lHasLabel = YES.

            IF lHasLabel THEN
                ASSIGN ttWidget.tLabel = TRIM(REPLACE(ENTRY(LOOKUP("Label":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}), ":":U, "":U)) NO-ERROR.

            /* Assign the widget tablename */
            ASSIGN ttWidget.tTableName  = ENTRY(LOOKUP("TableName":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}) NO-ERROR.

            /* If the table name is a null, that means that this attribute does not exist 
               for the widget. In this case, this widget cannot be attached to an SDO and so 
               the table name should be set to blank (to indicate that it is not to be associated
               with an SDO.
             */
            IF ttWidget.tTableName EQ ? THEN
                ASSIGN ttWidget.tTableName = "":U.
            ELSE
            /* If it's a Calculated Field or if the data source is a SDO, set TableName to RowObject
             */
            IF cDataSourceNames EQ "":U OR
               DYNAMIC-FUNCTION("ClassIsA":U IN gshRepositoryManager, cClassName, "CalculatedField":U) THEN
                ASSIGN ttWidget.tTableName = "RowObject":U.

            /* Sanity check: make sure that we have a valid value. */
            IF ttWidget.tTableName EQ ? THEN
                ASSIGN ttWidget.tTableName = "":U.           

            ASSIGN hLabel = ?.

            /* Now create the widget */
            CREATE VALUE(ttWidget.tWidgetType) hField
                ASSIGN FRAME       = hDefaultFrame:HANDLE
                       NAME        = cWidgetName
                       ROW         = ttWidget.tRow
                       WIDTH-CHARS = ttWidget.tWidth.

            IF lUseWidgetID THEN
                RUN assignWidgetID IN TARGET-PROCEDURE (INPUT hField).

            /* Build lists of the fields to display and enable */
            IF lDisplayField AND ttWidget.tTableName > "":U THEN
              ASSIGN 
                cDisplayedFields = cDisplayedFields + cWidgetName + ",":U 
                cFieldHandles    = cFieldHandles + STRING(hField) + ",":U.

            /* display field */
            IF lEnabled THEN
                IF ttWidget.tTableName EQ "":U THEN
                   ASSIGN cEnabledObjFlds = cEnabledObjFlds + cWidgetName + ",":U
                          cEnabledObjHdls = cEnabledObjHdls + STRING(hField) + ",":U.
                ELSE
                   ASSIGN
                      cEnabledFields  = cEnabledFields  + cWidgetName + ",":U
                      cEnabledHandles = cEnabledHandles + STRING(hField) + ",":U.

            /* Set widget attributes */           
            /* CLOB must be visualized as longchar */
            IF cDataType = 'CLOB':U OR cDataType = 'LONGCHAR':U THEN 
              ASSIGN    
                hField:LARGE = TRUE /* Large BEFORE datatype to avoid 4GL error  */
                hField:DATA-TYPE = 'LONGCHAR':U
                cDataType = 'LONGCHAR':U.
            ELSE
              ASSIGN hField:DATA-TYPE = cDataType WHEN CAN-SET(hField, "DATA-TYPE":U) NO-ERROR.
            ASSIGN hField:FORMAT = cFormat WHEN CAN-SET(hField, "FORMAT":U) NO-ERROR.        
            ASSIGN hField:TOOLTIP = ENTRY(LOOKUP("Tooltip":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}) NO-ERROR.        
            ASSIGN hField:PRIVATE-DATA = cPrivateData WHEN CAN-SET(hField, "PRIVATE-DATA":U)
                   hField:COLUMN = ttWidget.tColumn WHEN CAN-SET(hField, "COLUMN":U)
                   hField:HEIGHT-CHARS = dHeight WHEN CAN-SET(hField, "HEIGHT-CHARS":U)
                   hField:FONT = ttWidget.tFont WHEN CAN-SET(hField, "FONT":U) AND ttWidget.tFont NE 0
                   ttWidget.tWidgetHandle = hField
                   cFieldSecurity         = cFieldSecurity + ",":U
                                             + ( IF cSecuredFields NE "":U THEN ENTRY(2, cSecuredFields)
                                                 ELSE
                                                 IF cSecuredTokens NE "":U THEN "ReadOnly":U
                                                 ELSE
                                                 "":U)
                   ttWidget.tVisible = IF NOT ttWidget.tVisible
                                       THEN ttWidget.tVisible
                                       ELSE NOT (cSecuredFields NE "":U AND ENTRY(2, cSecuredFields) = "HIDDEN":U)
                   cAllFieldHandles = cAllFieldHandles + STRING(hField) + ",":U
                   cAllFieldNames   = cAllFieldNames + cWidgetName + ",":U
                   .
            {ry/prc/rysetattrv.i 
                &widgetBeingProcessed = hField
                &PropertyNames        = cPropertyNames
                &PropertyValues       = cPropertyValues
                &Value-Delimiter      = {&Value-Delimiter}
            }

            /* Create a label for this widget. */
            IF ttWidget.tLabel <> ? THEN
            DO:
                /* Check whether the field has a SIDE-LABEL-HANDLE. This will be the case for most      *
                 * widgets, but certain widget types (buttons in particular) do not use this mechanism  *
                 * for displaying their labels. These will be handled separately in a following section */
                IF CAN-SET(hField, "SIDE-LABEL-HANDLE":U) THEN 
                DO:
                    ASSIGN iLabelWidthP = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(ttWidget.tLabel + ":":U, iLabelFont) + 3.

                    IF iLabelWidthP > 0 THEN
                    DO:
                        CREATE TEXT hLabel
                            ASSIGN FRAME        = hDefaultFrame
                                   FORMAT       = "x(":U + STRING(LENGTH(ttWidget.tLabel, "Column":U) + 1) + ")":U
                                   NAME         = "LABEL_":U + REPLACE(cWidgetName, ".":U, "_":U)
                                   TAB-STOP     = NO            /* Labels should never be in the tab order */
                                   ROW          = hField:ROW
                                   SCREEN-VALUE = ttWidget.tLabel + ":":U.

                    ASSIGN hField:SIDE-LABEL-HANDLE = hLabel.

                    /*The widget-id for the widget itself was set before, but then the widget didn't have the label assigned yet.
                      So re-assigning the widget-id for the object also assigns the widget-id for its label, which should be
                      the widget widget-id -1.
                      Assign the widget-id only here causes two problems:
                      1- Widget-id won't be assigned for widgets that don't have lables, like buttons.
                      2- Core realizes combo-box and selection-lists when hField:HEIGHT-CHARS, above in the code is set, widget-id
                         cannot be assigned to widgets already realized.*/
                    IF lUseWidgetID THEN
                        RUN assignWidgetID IN TARGET-PROCEDURE (INPUT hField).

                      /*Because HEIGHT-CHARS and WIDTH-PIXELS realize combo-box, editor and selection-list widgets
                        we have to move those attributes after the widget-id is assigned.*/
                      ASSIGN dLabelMinHeight = IF hField:HEIGHT >= 1 
                                        THEN 1
                                        ELSE FONT-TABLE:GET-TEXT-HEIGHT(iLabelFont)
                             hLabel:HEIGHT-CHARS = MIN(hField:HEIGHT,dLabelMinHeight)
                             hLabel:WIDTH-PIXELS = iLabelWidthP.

                        IF hField:X - hLabel:WIDTH-PIXELS > 0 THEN
                          ASSIGN hLabel:X = hField:X - hLabel:WIDTH-PIXELS.
                        ELSE
                        DO:
                            /* Make sure the label doesn't start off the viewer. */
                            ASSIGN hLabel:X = 1.
                            
                            /* If this viewer has the KeepChildPositions set to yes,
                               make sure that the label doesn't overwrite the widget.
                               This is a danger primarily for translated wigets; if the KeepChildPositions
                               attribute is false, then this viewer will later take care of sorting 
                               itself out.
                               
                               The tooltip of the label is set to the whole label's value 
                               so that we can see what the correct label is.                                                      
                             */
                             IF lKeepPositions THEN
                                 ASSIGN hLabel:WIDTH-PIXELS = hField:X - hLabel:X - 2
                                        hLabel:TOOLTIP      = hLabel:SCREEN-VALUE.
                        END.    /* Label won't fit as things stand */
                        
                        ASSIGN hLabel:FONT    = iLabelFont WHEN iLabelFont NE ?
                               hLabel:FGCOLOR = iLabelFgColor WHEN iLabelFgColor NE ?
                               hLabel:BGCOLOR = iLabelBGColor WHEN iLabelBGColor NE ?.
                        
                        /* When KCP = yes, make sure that the label doesn't overwrite any 
                           other widget. When KCP=no, then we will sort out the layout a 
                           little later. 
                           
                           We have no way of knowing what the original label width was
                           with the current design of Dynamics, so we sweep the long
                           label under the carpet, so to speak. */
                        if lKeepPositions then
                            hLabel:move-to-bottom().
                    END.    /* there is a valid label */
                END.    /* there is a side-label-handle */
                ELSE
                    /* Labels which do not support the SIDE-LABEL-HANDLE principle are set here. */
                    IF CAN-SET(hField, "LABEL":U) THEN
                        ASSIGN hField:LABEL       = ttWidget.tLabel
                               hField:WIDTH-CHARS = IF hField:TYPE <> "BUTTON":U
                                                    THEN MAX(hField:WIDTH-CHARS, FONT-TABLE:GET-TEXT-WIDTH-CHARS(hField:LABEL, hField:FONT) + 4)
                                                    ELSE hField:WIDTH-CHARS.
            END.  /* ttWidget.tlabel <> ? */

            /* Text widgets are usually meant to display one piece of data, and are not generally used for displaying data from an SDO.
             * It is however, possible to display data from an SDO in a text widget. In this case, the format and value is taken from the
             * DataField. We know which fields these are because of the value of the DisplayField attre.
             *
             * The code below is only for those text widgets that are not going to display data from a data source (ie things like 
             * labels on rectangles) */
             IF ttwidget.tWidgetType = "TEXT":U AND lDisplayField = NO THEN
                 /* The value of the format should be greater than zero. */
                 ASSIGN hField:FORMAT       = cFormat
                        hField:SCREEN-VALUE = ttWidget.tInitialValue
                        NO-ERROR.
        
            /* Set the initial SENSITIVE state of non-editor fields to FALSE and let the toolbar take care of enabling and 
               disabling the fields.  SENSITIVE is set to TRUE for editors because they need to be initially sensitive 
               to be scrollable.  The toolbar takes care of "enabling and disabling" editors by setting READ-ONLY as appropriate.
               (We must thus also set READ-ONLY true as objects need to be 'disabled' at startup)  */
            IF hField:TYPE = "EDITOR":U THEN 
                hField:READ-ONLY = TRUE.
                ASSIGN hField:SENSITIVE = IF hField:TYPE = "EDITOR":U THEN TRUE ELSE FALSE
                       dRowPosition     = hField:ROW
                       dColumnPosition  = hField:COLUMN
                       dWidgetWidth     = hField:WIDTH-CHARS
                       dWidgetHeight    = hField:HEIGHT-CHARS
                       NO-ERROR.
             
                /* UI Events. Generally, more widgets don't have UI events that widgets that do.  If we check if we can find      *
                 * a UI event before we invoke createWidgetEvents, we are saving the overhead of invoking a function and creating *
                 * a dynamic query if the widget does not have any events.                                                    */
                IF ghCacheObject:BUFFER-FIELD("EventNames":U):BUFFER-VALUE NE "":U THEN
                    DYNAMIC-FUNCTION("createWidgetEvents":U IN TARGET-PROCEDURE,            
                                     INPUT hField,
                                     INPUT ghCacheObject:BUFFER-FIELD("EventNames":U):BUFFER-VALUE,
                                     INPUT ghCacheObject:BUFFER-FIELD("EventActions":U):BUFFER-VALUE ).
                
                /* Popup? If the widget is not visible then the popup should not be created */
                IF lShowPopup AND ttWidget.tVisible THEN
                DO:
                    /* Create a popup button for pop-up calendar or calculator */
                    CREATE BUTTON hPopup
                        ASSIGN FRAME         = hDefaultFrame
                               NO-FOCUS      = TRUE
                               WIDTH-PIXELS  = 15
                               LABEL         = "...":U
                               PRIVATE-DATA  = "POPUP":U 
                        TRIGGERS:
                            ON CHOOSE PERSISTENT RUN runLookup IN gshSessionManager (INPUT hField).
                        END TRIGGERS.
                    
                    IF lUseWidgetID THEN
                        RUN assignPopupWidgetID IN TARGET-PROCEDURE (INPUT hField, INPUT hPopup).
                    /* The lookup widget should be placed outside of the fill-in */
                    IF lPopupButtonInField = NO THEN
                        ASSIGN hPopup:HEIGHT-PIXELS = hField:HEIGHT-PIXELS - 4
                               hPopup:Y             = hField:Y + 2
                               dFrameWidth          = MAX(dFrameWidth, dColumnPosition + dWidgetWidth + hPopup:WIDTH-CHARS) /* make sure the calced frame width is correct */
                               hPopup:X             = hField:X + hField:WIDTH-PIXELS - 2
                               hField:WIDTH-PIXELS  = hField:WIDTH-PIXELS + 15
                               NO-ERROR.
                    ELSE
                        ASSIGN hPopup:HEIGHT-PIXELS = hField:HEIGHT-PIXELS - 4
                               hPopup:Y             = hField:Y + 2
                               hPopup:X             = (hField:X + hField:WIDTH-PIXELS) - 17.
        
                    hPopup:MOVE-TO-TOP().
        
                    /* Add F4 trigger to widget */
                    ON F4 OF hField PERSISTENT RUN runLookup IN gshSessionManager (INPUT hField).
                    ASSIGN cFieldPopupMapping = cFieldPopupMapping + STRING(hField) + ",":U + STRING(hPopup) + ",":U
                           hPopup:HIDDEN      = hField:Hidden.
                END.    /* show a popup */
                else
                    hPopup = ?.
            
                /* MODIFIED is set to true by the 4GL after setting visible to true up above.  MODIFIED is set
                   to false for datafields when they are displayed.  When certain widgets that are not 
                   dataobject-based are enabled, MODIFIED is set to false by the 4GL, for others it is not
                   so we need to set it to false here. */
                IF CAN-SET(hField, "MODIFIED":U) AND ttWidget.tVisible AND ttWidget.tTableName EQ "":U THEN
                    ASSIGN hField:MODIFIED = NO.
             
                /* If the field is to be made visible, then the label should be, too. However, we cannot set the *
                 * VISIBLE attribute to YES without the viewer's frame's VISIBLE attribute also being set to YES *
                 * by the 4GL.  This behaviour is not acceptable if the viewer's HideOnInit property is true.    *
                 * We also need to ensure that all hidden widgets are actually hidden, so we explicitly set      *
                 * their VISIBLE property to NO.                                                             */
                IF CAN-SET(hField, "HIDDEN":U) AND (lHideOnInit EQ NO OR ttWidget.tVisible EQ NO) THEN
                    ASSIGN hField:HIDDEN = NOT ttWidget.tVisible
                           hField:SIDE-LABEL-HANDLE:HIDDEN = hField:HIDDEN
                           hPopup:Hidden = hField:Hidden       when valid-handle(hPopup)
                           NO-ERROR.
            END. /* Else it is not a SmartDataField */
            
            IF ttWidget.tTabOrder > 1 AND
               (CAN-SET(ttWidget.tWidgetHandle, "TAB-STOP":U) AND ttWidget.tWidgetHandle:TAB-STOP) OR
               ttWidget.tWidgetType EQ "SmartDataField" THEN 
            DO:
                IF CAN-QUERY(ttWidget.tWidgetHandle, "ADM-DATA":U) AND 
                   CAN-QUERY(hPreviousWidget, "ADM-DATA":U) THEN
                    RUN adjustTabOrder IN TARGET-PROCEDURE ( INPUT ttWidget.tWidgetHandle,
                                                             INPUT hPreviousWidget,
                                                             INPUT "AFTER":U).
                ASSIGN hPreviousWidget = ttWidget.tWidgetHandle.                                                     
            END.    /* udpate the tab order */
            
            /* Determine the size of the frame. */
            ASSIGN dFrameWidth  = MAX(dFrameWidth, dColumnPosition + dWidgetWidth - 1)
                   dFrameHeight = MAX(dFrameHeight, dRowPosition + dWidgetHeight  - 1).
        
            ghRenderingQuery:GET-NEXT().
        END.    /* ttobject query  */
        ghRenderingQuery:QUERY-CLOSE().

        /* Set the Enabled~ and DisplayedFields properties. */
        ASSIGN cAllFieldHandles   = RIGHT-TRIM(cAllFieldHandles, ",":U)
               cAllFieldNames     = RIGHT-TRIM(cAllFieldNames, ",":U)
               cFieldSecurity     = SUBSTRING(cFieldSecurity, 2)
               cDisplayedFields   = RIGHT-TRIM(cDisplayedFields, ",":U)
               cFieldHandles      = RIGHT-TRIM(cFieldHandles, ",":U)
               cEnabledFields     = RIGHT-TRIM(cEnabledFields, ",":U)
               cEnabledHandles    = RIGHT-TRIM(cEnabledHandles, ",":U)
               cEnabledObjFlds    = RIGHT-TRIM(cEnabledObjFlds, ",":U)
               cEnabledObjHdls    = RIGHT-TRIM(cEnabledObjHdls, ",":U)
               cFieldPopupMapping = RIGHT-TRIM(cFieldPopupMapping, ",":U).
               
        &SCOPED-DEFINE xp-assign
        {set AllFieldHandles cAllFieldHandles}
        {set AllFieldNames cAllFieldNames}
        {set FieldSecurity cFieldSecurity}
        {set DisplayedFields cDisplayedFields}
        {set FieldHandles cFieldHandles}
        {set EnabledFields cEnabledFields}
        {set EnabledHandles cEnabledHandles}
        {set EnabledObjFlds cEnabledObjFlds}
        {set EnabledObjHdls cEnabledObjHdls}
        {set FieldPopupMapping cFieldPopupMapping}
        /* Ensure that the viewer is disabled if it is an update-target without tableio-source (? will enable ) */
        {set SaveSource NO}. 
        &UNDEFINE xp-assign
        
        /* If there *are* no enabled fields, don't let the viewer be an Update-Source or TableIO-Target.      *
         * NOTE: This in principle belongs in datavis.i because it's generic but EnabledFields has just been set. */
        IF cEnabledFields = "":U THEN 
        DO:
            RUN modifyListProperty IN TARGET-PROCEDURE (TARGET-PROCEDURE, "REMOVE":U, "SupportedLinks":U, "Update-Source":U).
            RUN modifyListProperty IN TARGET-PROCEDURE (TARGET-PROCEDURE, "REMOVE":U, "SupportedLinks":U, "TableIO-Target":U).
        END.
        ELSE
            /* If there are EnabledFields, set the Editable Property to true.
             * This is because the 'Add', 'Update' and 'Copy' actions require 
             * this property to be set as part of their ENABLE_RULEs.
             * This property is usually determined by reading the EnabledFields
             * property, but because we are only setting this property here, as
             * opposed to when the viewer is RUN, we need to explicitly set the
             * Editable property to true.                                  */
            {set Editable YES}.
            
        /* If translation was done - then we need to check if we need to adjust any 
           columns for larger labels. However, only do this if allowed to by the KeepChildPositions
           attribute.
         */
        IF NOT lKeepPositions AND lObjectTranslated THEN
            RUN repositionWidgetForTranslation IN TARGET-PROCEDURE (INPUT-OUTPUT dFrameWidth).
        
        /* get the MinWidth and MinHeight attributes. */
        &SCOPED-DEFINE xp-assign
        {get MinHeight dFrameMinHeight}
        {get MinWidth  dFrameMinWidth}.
        &UNDEFINE xp-assign
        
        IF dFrameWidth < 10 THEN ASSIGN dFrameWidth = 10.
        
        /* Set the frame width */
        IF dFrameHeight > dFrameMinHeight OR dFrameWidth  > dFrameMinWidth THEN
            RUN changeFrameSizeAttributes IN TARGET-PROCEDURE (INPUT iPageNumber, INPUT dFrameHeight, INPUT dFrameWidth).
        ELSE DO:
            ASSIGN hDefaultFrame:SCROLLABLE = YES.
            
            /* If we get here, we know minWidth and minHeight were greater than the calculated width and height. *
             * Set the frame width */
            IF dFrameMinWidth < hDefaultFrame:WIDTH-CHARS THEN
                ASSIGN hDefaultFrame:WIDTH-CHARS          = dFrameMinWidth
                       hDefaultFrame:VIRTUAL-WIDTH-CHARS  = hDefaultFrame:WIDTH-CHARS.
            ELSE
                ASSIGN hDefaultFrame:VIRTUAL-WIDTH-CHARS  = dFrameMinWidth
                       hDefaultFrame:WIDTH-CHARS          = hDefaultFrame:VIRTUAL-WIDTH-CHARS.
        
            /* Set the frame height */
            IF dFrameMinHeight < hDefaultFrame:HEIGHT-CHARS THEN
                ASSIGN hDefaultFrame:HEIGHT-CHARS         = dFrameMinHeight
                       hDefaultFrame:VIRTUAL-HEIGHT-CHARS = hDefaultFrame:HEIGHT-CHARS.
            ELSE
                ASSIGN hDefaultFrame:VIRTUAL-HEIGHT-CHARS = dFrameMinHeight
                       hDefaultFrame:HEIGHT-CHARS         = hDefaultFrame:VIRTUAL-HEIGHT-CHARS.
            
            ASSIGN hDefaultFrame:SCROLLABLE = FALSE NO-ERROR.               
        END.    /* frame is smaller than min size. */
end.    /* dynamic viewr not generated */

RUN SUPER.

/* Flag this object as having been created. */
{set ObjectsCreated YES}.

if not can-do(target-procedure:internal-entries, 'adm-assignObjectProperties') then
do:
    IF gcErrorMessage <> "":U THEN
        RUN showWarningMessages IN gshSessionManager (INPUT  gcErrorMessage,    
                                                      INPUT  "WAR":U,          /* error type */
                                                      INPUT  "Error creating viewer objects" ).
end.

/* --- EOF --- */
