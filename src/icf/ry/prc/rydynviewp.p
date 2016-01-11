&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
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
/*---------------------------------------------------------------------------------
  File: rydynviewp.p

  Description:  Dynamic Viewer Super Procedure

  Purpose:      Dynamic Viewer Super Procedure. Contains code for dynamic viewers.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   01/23/2003  Author:     Peter Judge

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rydynviewp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

/* This pre-processor is necessary to exclude certain code from firing in viewer.i,
 * even though there is a DynamicObject property.                                  */
 
{ ry/app/ryobjretri.i }
{ ry/app/rydynviewi.i }
/* Defines the NO-RESULT-CODE and DEFAULT-RESULT-CODE result codes. */
{ ry/app/rydefrescd.i }

{launch.i &define-only = YES }

DEFINE VARIABLE gcDefaultAttributes         AS CHARACTER            NO-UNDO.

/* gcCurrentObjectName is used to give prepareInstance the correct instanceID
 * for any objects which are built using constructObject.                   */
DEFINE VARIABLE gcCurrentObjectName         AS CHARACTER            NO-UNDO.

DEFINE VARIABLE ghQuery1                    AS HANDLE               NO-UNDO.
DEFINE VARIABLE ghCall1                     AS HANDLE               NO-UNDO.

/* These are the default attributes which are stored in the ttWidget temp-table. These
 * attributes must not be duplicated in any of the widget type temp-tables.
*/
ASSIGN gcDefaultAttributes = "LABEL,FORMAT,ROW,COLUMN,X,Y,PRIVATE-DATA,FONT,TOOLTIP,SENSITIVE,VISIBLE,HIDDEN,":U
                           + "HEIGHT,HEIGHT-PIXELS,HEIGHT-CHARS,WIDTH,WIDTH-PIXELS,WIDTH-CHARS,DATA-TYPE,FRAME,":U
                           + "NAME,SIDE-LABEL-HANDLE,":U.


/** Temp-table definition for TT used in storeAttributeValues
 *  ----------------------------------------------------------------------- **/
{ ry/inc/ryrepatset.i }

/* Preprocessors which resolve the STORED-AT values into the values stored
 * in the field.                                                          */
{ ry/inc/ryattstori.i }

/** This pre-processor is used to save space, since the section editor limits
 *  are exceeded when this code is included, as it is repeated for each event
 *  that is added. This pre-processor is used in createUiEvents.
 *  ----------------------------------------------------------------------- **/
&SCOPED-DEFINE RUN-PROCESS-EVENT-PROCEDURE ~
RUN processEventProcedure IN TARGET-PROCEDURE ( INPUT hEventBuffer:BUFFER-FIELD("tActionType":U):BUFFER-VALUE,      /* RUN/PUBLISH */~
                                                INPUT hEventBuffer:BUFFER-FIELD("tEventAction":U):BUFFER-VALUE,     /* The procedure to RUN or PUBLISH */~
                                                INPUT hEventBuffer:BUFFER-FIELD("tActionTarget":U):BUFFER-VALUE,    /* SELF,CONTAINER,ANYWHERE */ ~
                                                INPUT hEventBuffer:BUFFER-FIELD("tEventParameter":U):BUFFER-VALUE )

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-assignRadioSetWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignRadioSetWidth Procedure 
FUNCTION assignRadioSetWidth RETURNS DECIMAL
  ( pcRadioButtons AS CHARACTER,
    piFont         AS INTEGER,
    plHorizontal   AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createWidgetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createWidgetEvents Procedure 
FUNCTION createWidgetEvents RETURNS LOGICAL
    ( INPUT pdInstanceId        AS DECIMAL,
      INPUT phWidget            AS HANDLE       )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyWidgets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD destroyWidgets Procedure 
FUNCTION destroyWidgets RETURNS LOGICAL
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-displayInitialValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD displayInitialValues Procedure 
FUNCTION displayInitialValues RETURNS LOGICAL
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchObjectDetail) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fetchObjectDetail Procedure 
FUNCTION fetchObjectDetail RETURNS LOGICAL
  ( /* No parameters */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentLogicalName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentLogicalName Procedure 
FUNCTION getCurrentLogicalName RETURNS CHARACTER
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPopupHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPopupHandle Procedure 
FUNCTION getPopupHandle RETURNS HANDLE
    ( INPUT phWidgetHandle      AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setExtraAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setExtraAttributes Procedure 
FUNCTION setExtraAttributes RETURNS LOGICAL
    ( INPUT pdRecordIdentifier      AS DECIMAL,
      INPUT phField                 AS HANDLE,
      INPUT phAttributeBuffer       AS HANDLE,
      INPUT phCall                  AS HANDLE       )  FORWARD.

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
         HEIGHT             = 25.52
         WIDTH              = 73.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
CREATE CALL ghCall1.
CREATE QUERY ghQuery1.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-changeFrameSizeAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeFrameSizeAttributes Procedure 
PROCEDURE changeFrameSizeAttributes :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pdFrameHeight  AS DECIMAL    NO-UNDO.
    DEFINE INPUT  PARAMETER pdFrameWidth   AS DECIMAL    NO-UNDO.

    DEFINE VARIABLE dFrameMinWidth              AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dFrameMinHeight             AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dViewerObjectObj            AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dInstanceId                 AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE hObjectBuffer               AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hAttributeValueBuffer       AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hAttributeValueTable        AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hContainerSource            AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hField                      AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hAttributeBuffer            AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hDefaultFrame               AS HANDLE               NO-UNDO.

    {get ContainerSource hContainerSource}.
    {get ContainerHandle hDefaultFrame}.

    /* Set the property, too. */
    {get MinHeight dFrameMinHeight}.
    {get MinWidth  dFrameMinWidth}.

    {get InstanceID dInstanceID}.

    ASSIGN hObjectBuffer     = DYNAMIC-FUNCTION("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT dInstanceID)
           dViewerObjectObj  = hObjectBuffer:BUFFER-FIELD("tSmartObjectObj":U):BUFFER-VALUE
           hAttributeBuffer  = hObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE
           .
    hAttributeBuffer:FIND-FIRST(" WHERE ":U + hAttributeBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(dInstanceID) ).
    
    /* Update the Frame MinWidth and Frame MinHeight.
    * We don't particularly care of there are errors
    * here, since we can update the records at a later
    * stage.                                         */
    EMPTY TEMP-TABLE ttStoreAttribute.
    
    IF dFrameMinHeight NE pdFrameHeight AND
       pdFrameHeight   NE 0             AND 
       pdFrameHeight   NE ?             THEN
    DO:
        CREATE ttStoreAttribute.
        ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
               ttStoreAttribute.tAttributeParentObj = dViewerObjectObj
               ttStoreAttribute.tAttributeLabel     = "MinHeight":U
               ttStoreAttribute.tConstantValue      = YES
               ttStoreAttribute.tDecimalValue       = pdFrameHeight
               .
        /* Update the record in the cache. If the cache is cleared then the
         * correct value will be retrieved from the Repository . */
        ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("MinHeight":U) NO-ERROR.
        IF VALID-HANDLE(hField) THEN
            ASSIGN hField:BUFFER-VALUE = pdFrameHeight.
    END.    /* height  <> calculated height */
    
    IF dFrameMinWidth NE pdFrameWidth AND
       pdFrameWidth   NE 0            AND
       pdFrameWidth   NE ?            THEN
    DO:
        CREATE ttStoreAttribute.
        ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
               ttStoreAttribute.tAttributeParentObj = dViewerObjectObj
               ttStoreAttribute.tAttributeLabel     = "MinWidth":U
               ttStoreAttribute.tConstantValue      = YES
               ttStoreAttribute.tDecimalValue       = pdFrameWidth
               .
        /* Update the record in the cache. If the cache is cleared then the
         * correct value will be retrieved from the Repository . */
        ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("MinWidth":U) NO-ERROR.
        IF VALID-HANDLE(hField) THEN
            ASSIGN hField:BUFFER-VALUE = pdFrameWidth.
    END.    /* Width  <> calculated Width */
    
    ASSIGN hAttributeValueBuffer = TEMP-TABLE ttStoreAttribute:DEFAULT-BUFFER-HANDLE
           hAttributeValueTable  = ?
           .
    RUN storeAttributeValues IN gshRepositoryManager ( INPUT hAttributeValueBuffer,
                                                       INPUT TABLE-HANDLE hAttributeValueTable ) NO-ERROR.
    
    /* Set the property, too. */
    {set MinHeight pdFrameHeight}.
    {set MinWidth  pdFrameWidth}.

    /*  The window packing ensures that the container window is set to the correct minimum size. */
    RUN packWindow IN hContainerSource ( INPUT 0, INPUT YES ).

    ASSIGN hDefaultFrame:WIDTH-CHARS  = pdFrameWidth
           hDefaultFrame:HEIGHT-CHARS = pdFrameHeight
           NO-ERROR.

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.    
END PROCEDURE.  /* changeFrameSizeAttributes */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createObjects Procedure 
PROCEDURE createObjects :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hAttributeValueBuffer       AS HANDLE               NO-UNDO.
  DEFINE VARIABLE hAttributeValueTable        AS HANDLE               NO-UNDO.
  DEFINE VARIABLE hField                      AS HANDLE               NO-UNDO.
  DEFINE VARIABLE hLabel                      AS HANDLE               NO-UNDO.
  DEFINE VARIABLE hPopup                      AS HANDLE               NO-UNDO.
  DEFINE VARIABLE hDataFieldProcedure         AS HANDLE               NO-UNDO.
  DEFINE VARIABLE hDataFieldFrame             AS HANDLE               NO-UNDO.
  DEFINE VARIABLE hPreviousWidget             AS HANDLE               NO-UNDO.
  DEFINE VARIABLE hObjectBuffer               AS HANDLE               NO-UNDO.
  DEFINE VARIABLE cContainerObjectName        AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE dFrameWidth                 AS DECIMAL              NO-UNDO.
  DEFINE VARIABLE dFrameHeight                AS DECIMAL              NO-UNDO.
  DEFINE VARIABLE dWidgetWidth                AS DECIMAL              NO-UNDO.
  DEFINE VARIABLE dWidgetHeight               AS DECIMAL              NO-UNDO.
  DEFINE VARIABLE dColumnPosition             AS DECIMAL              NO-UNDO.
  DEFINE VARIABLE dRowPosition                AS DECIMAL              NO-UNDO.
  DEFINE VARIABLE dFrameMinHeight             AS DECIMAL              NO-UNDO.
  DEFINE VARIABLE dFrameMinWidth              AS DECIMAL              NO-UNDO.
  DEFINE VARIABLE dLabelWidth                 AS DECIMAL              NO-UNDO.
  DEFINE VARIABLE cButtonPressed              AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE cTempText                   AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE cDisplayedFields            AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE cEnabledFields              AS CHARACTER            NO-UNDO.    
  DEFINE VARIABLE cDisplayedObjects           AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE cEnabledObjects             AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE hDataSource                 AS HANDLE               NO-UNDO.
  DEFINE VARIABLE hDefaultFrame               AS HANDLE               NO-UNDO.
  DEFINE VARIABLE cAllFieldHandles            AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE cAllFieldNames              AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE cFieldName                  AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE cFieldSecurity              AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE dStoreFrameWidth            AS DECIMAL              NO-UNDO.
  DEFINE VARIABLE lPopupButtonInField         AS LOGICAL              NO-UNDO.
  DEFINE VARIABLE lHideOnInit                 AS LOGICAL              NO-UNDO.
  DEFINE VARIABLE cDataSourceNames            AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE cFieldPopupMapping          AS CHARACTER            NO-UNDO.

    DEFINE BUFFER bttWidget FOR ttWidget.

    IF NOT VALID-HANDLE(ghCall1) THEN
        CREATE CALL ghCall1.

    ASSIGN ghCall1:CALL-TYPE = SET-ATTR-CALL-TYPE.

  {get DataSource hDataSource}.
  {get ContainerHandle hDefaultFrame}.
  {get HideOnInit lHideOnInit}.
  {get DataSourceNames cDataSourceNames}.
    IF cDataSourceNames EQ ? THEN
        ASSIGN cDataSourceNames = "":U.

  /* Before we start - make the frame virtually big */
  ASSIGN hDefaultFrame:SCROLLABLE           = TRUE
         hDefaultFrame:VIRTUAL-WIDTH-CHARS  = SESSION:WIDTH-CHARS  - 1
         hDefaultFrame:VIRTUAL-HEIGHT-CHARS = SESSION:HEIGHT-CHARS - 1
         hDefaultFrame:WIDTH-CHARS          = hDefaultFrame:VIRTUAL-WIDTH-CHARS
         hDefaultFrame:HEIGHT-CHARS         = hDefaultFrame:VIRTUAL-HEIGHT-CHARS
         hDefaultFrame:SCROLLABLE           = FALSE.

  /* Determine whether the popup buttons should be in the field or not. */
  ASSIGN lPopupButtonInField = DYNAMIC-FUNCTION("getPopupButtonInField":U IN TARGET-PROCEDURE) NO-ERROR.
  IF lPopupButtonInField EQ ? THEN
      ASSIGN lPopupButtonInField = NO.
  
  IF DYNAMIC-FUNCTION("fetchObjectDetail":U IN TARGET-PROCEDURE) THEN
  FOR EACH ttWidget WHERE
           ttWidget.tTargetProcedure = TARGET-PROCEDURE
           BY ttWidget.tTabOrder:
      /* Clear all handle variables. */
      ASSIGN hField              = ?
             hLabel              = ?
             hDataFieldProcedure = ?
             hDataFieldFrame     = ?
             .
      IF ttWidget.tWidgetType EQ "SmartDataField":U THEN
      DO:
          /* Create the object.
           * We set the current logical name to the InstanceID of the instance we are creating,
           * so that the correct instance can be retrieved.                                       */
          ASSIGN gcCurrentObjectName = "InstanceID=":U + STRING(ttWidget.tRecordIdentifier).
        /* Even though the ADMProps TT is populated with the values from the Repository, there 
         * may be attributes which need to be explicitly set. The list of attributes returned
         * buildAttributeList contains those attributes whicha re to be set.                  */
          RUN constructObject IN TARGET-PROCEDURE ( INPUT  ttWidget.tPhysicalFilename,
                                                    INPUT  hDefaultFrame:HANDLE,
                                                    INPUT  DYNAMIC-FUNCTION("buildAttributeList":U IN gshRepositoryManager,
                                                                            INPUT ttWidget.tClassBufferHandle,
                                                                            INPUT ttWidget.tRecordIdentifier                    ),
                                                    OUTPUT hDataFieldProcedure ).
          RUN repositionObject IN hDataFieldProcedure (ttWidget.tRow, ttWidget.tColumn) NO-ERROR.
          RUN resizeObject     IN hDataFieldProcedure (IF ttWidget.tHeight <> 0 THEN ttWidget.tHeight ELSE 1, ttWidget.tWidth) NO-ERROR.

          {get FieldName cFieldName hDataFieldProcedure} NO-ERROR.
          IF cFieldName EQ ? THEN 
              {get ObjectName cFieldName hDataFieldProcedure} NO-ERROR.

          ASSIGN hDataFieldFrame        = DYNAMIC-FUNCTION("getContainerHandle" IN hDataFieldProcedure)
                 dWidgetWidth           = DYNAMIC-FUNCTION("getWidth" IN hDataFieldProcedure)
                 dWidgetHeight          = DYNAMIC-FUNCTION("getHeight" IN hDataFieldProcedure)
                 dRowPosition           = ttWidget.tRow
                 dColumnPosition        = ttWidget.tColumn
                 ttWidget.tFrameHandle  = hDataFieldFrame
                 ttWidget.tWidgetHandle = hDataFieldProcedure
                 ttWidget.tVisible      = YES
                 gcCurrentObjectName    = "":U
                 cFieldSecurity         = cFieldSecurity + (IF NUM-ENTRIES(cAllFieldHandles, ",":U) EQ 0 THEN "":U ELSE ",":U) +
                                          (IF ttWidget.tSecuredHidden THEN "Hidden":U 
                                          ELSE IF ttWidget.tSecuredReadOnly THEN "ReadOnly":U 
                                          ELSE "":U)
                 cAllFieldHandles       = cAllFieldHandles + (IF NUM-ENTRIES(cAllFieldHandles, ",":U) EQ 0 THEN "":U ELSE ",":U) +
                                          STRING(hDataFieldProcedure)
                 cAllFieldNames         = cAllFieldNames + (IF NUM-ENTRIES(cAllFieldNames, ",":U) EQ 0 THEN "":U ELSE ",":U) +
                                          cFieldName.

          IF NOT CAN-FIND(FIRST bttWidget
                          WHERE bttWidget.tWidgetName = cFieldName
                            AND ROWID(bttWidget) <> ROWID(ttWidget))
            AND DYNAMIC-FUNCTION("getLocalField":U IN ttWidget.tWidgetHandle) = FALSE
          THEN DO:
              /* If this is the case, the field that this SDF maps to is not going to be rendered on the frame. *
               * Make sure we add the lookup to the displayed and enabled field lists.                          */
              ASSIGN cDisplayedFields = cDisplayedFields + (IF NUM-ENTRIES(cDisplayedFields, ",":U) EQ 0 THEN "":U ELSE ",":U) + cFieldName
                     cEnabledFields = cEnabledFields + (IF NUM-ENTRIES(cEnabledFields, ",":U) EQ 0 THEN "":U ELSE ",":U) + cFieldName.
          END.  /* Local Field */
      END.    /* SDF */
      ELSE
      DO:
          /** Build lists of the the fields to display and enable
           *  ----------------------------------------------------------------------- **/
          IF ttWidget.tDisplayField THEN
          DO:
              /* Not a RowObject/DB field */
              IF ttWidget.tTableName EQ "":U OR ttWidget.tTableName EQ ? THEN
                  ASSIGN cDisplayedObjects = cDisplayedObjects + (IF NUM-ENTRIES(cDisplayedObjects, ",":U) EQ 0 THEN "":U ELSE ",":U)
                                            + ttWidget.tWidgetName.
              ELSE
                  ASSIGN cDisplayedFields = cDisplayedFields + (IF NUM-ENTRIES(cDisplayedFields, ",":U) EQ 0 THEN "":U ELSE ",":U)
                                           + (IF ttWidget.tTableName EQ "rowObject":U OR cDataSourceNames NE "":U THEN "":U ELSE ttWidget.tTableName + ".":U)
                                           + ttWidget.tWidgetName.
          END.    /* display field */

          IF ttWidget.tEnabled THEN
          DO:        
              /* Not a RowObject/DB field */
              IF ttWidget.tTableName EQ "":U OR ttWidget.tTableName EQ ? THEN
                  ASSIGN cEnabledObjects = cEnabledObjects + (IF NUM-ENTRIES(cEnabledObjects, ",":U) EQ 0 THEN "":U ELSE ",":U)
                                          + ttWidget.tWidgetName.
              ELSE
                  ASSIGN cEnabledFields = cEnabledFields + (IF NUM-ENTRIES(cEnabledFields, ",":U) EQ 0 THEN "":U ELSE ",":U)
                                           + (IF ttWidget.tTableName EQ "rowObject":U OR cDataSourceNames NE "":U THEN "":U ELSE ttWidget.tTableName + ".":U)
                                           + ttWidget.tWidgetName.
          END.    /* enabled */

          CREATE VALUE(ttWidget.tWidgetType) hField
              ASSIGN FRAME = hDefaultFrame:HANDLE.

          ASSIGN hField:DATA-TYPE = ttWidget.tDataType WHEN CAN-SET(hField, "DATA-TYPE":U) NO-ERROR.
          ASSIGN hField:FORMAT = ttWidget.tFormat WHEN CAN-SET(hField, "FORMAT":U) NO-ERROR.           

          /* Make sure the field width is valid.  If not, get it from the SDO. */
          IF (ttWidget.tWidth = ? OR ttWidget.tWidth = 0) AND VALID-HANDLE(hDataSource) THEN
              ASSIGN ttWidget.tWidth = DYNAMIC-FUNCTION("columnWidth":U IN hDataSource, INPUT ttWidget.tWidgetName) NO-ERROR.

          ASSIGN
            hField:PRIVATE-DATA = ttWidget.tPrivateData WHEN CAN-SET(hField, "PRIVATE-DATA":U)
            hField:NAME = ttWidget.tWidgetName WHEN CAN-SET(hField, "NAME":U)
            hField:TOOLTIP = ttWidget.tTooltip WHEN CAN-SET(hField, "TOOLTIP":U)
            hField:ROW = ttWidget.tRow WHEN CAN-SET(hField, "ROW":U)  /* layout posns in chars */
            hField:COLUMN = ttWidget.tColumn WHEN CAN-SET(hField, "COLUMN":U)
            hField:HEIGHT-CHARS = ttWidget.tHeight WHEN CAN-SET(hField, "HEIGHT-CHARS":U) /* Size already calculated in chars */ 
            hField:WIDTH-CHARS  = ttWidget.tWidth WHEN CAN-SET(hField, "WIDTH-CHARS":U)
            hField:FONT = ttWidget.tFont WHEN CAN-SET(hField, "FONT":U) AND ttWidget.tFont NE 0
            ttWidget.tWidgetHandle = hField
            ttWidget.tFrameHandle  = hField:FRAME /* Create a placeholder for this widget */
            cFieldSecurity         = cFieldSecurity + (IF NUM-ENTRIES(cAllFieldHandles, ",":U) EQ 0 THEN "":U ELSE ",":U) +
                                     (IF ttWidget.tSecuredHidden THEN "Hidden":U 
                                     ELSE IF ttWidget.tSecuredReadOnly THEN "ReadOnly":U 
                                     ELSE "":U)
            cAllFieldHandles       = cAllFieldHandles + (IF NUM-ENTRIES(cAllFieldHandles, ",":U) EQ 0 THEN "":U ELSE ",":U) +
                                     STRING(hField)

            cAllFieldNames         = cAllFieldNames + (IF NUM-ENTRIES(cAllFieldNames, ",":U) EQ 0 THEN "":U ELSE ",":U) +
                                     (IF CAN-QUERY(hField,"name":U) AND hField:NAME <> ? 
                                      THEN hField:NAME 
                                      ELSE "?":U ).

          /* Table Name */
          IF CAN-SET(hField, "PRIVATE-DATA":U) AND ttWidget.tTableName NE "":U AND cDataSourceNames EQ "":U THEN
              ASSIGN hField:PRIVATE-DATA = ("TableName,":U + ttWidget.tTableName + ",":U) + ( IF hField:PRIVATE-DATA EQ ? THEN "":U ELSE hField:PRIVATE-DATA).
          
          /** Create a label for this widget.
           *  ----------------------------------------------------------------------- **/
          IF ttWidget.tLabel NE ? THEN
          DO:
              /* Check whether the field has a SIDE-LABEL-HANDLE. This will be the case for most
               * widgets, but certain widget types (buttons in particular) do not use this mechanism
               * for displaying their labels. These will be handled separately in a following section */
              IF CAN-SET(hField, "SIDE-LABEL-HANDLE":U) THEN
              DO:
                IF INDEX(ttWidget.tLabel,":":U) = 0 THEN
                  ttWidget.tLabelWidth = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(ttWidget.tLabel + ":", ttWidget.tLabelFont) + 3.

                  CREATE TEXT hLabel
                      ASSIGN FRAME        = hDefaultFrame:HANDLE
                             FORMAT       = "x(" + STRING(LENGTH(ttWidget.tLabel, "CHARACTER":U) + 1) + ")":U
                             HEIGHT-CHARS = 1                             
                             NAME         = "LABEL_":U + REPLACE(ttWidget.tWidgetName, ".":U, "_":U)
                             TAB-STOP     = NO            /* Labels should never be in the tab order */
                             ROW          = hField:ROW
                             SCREEN-VALUE = ttWidget.tLabel + ":":U
                             .
                  ASSIGN
                    hLabel:FONT = ttWidget.tLabelFont WHEN ttWidget.tLabelFont NE ?
                    hLabel:FGCOLOR = ttWidget.tLabelFgColor WHEN ttWidget.tLabelFgColor NE ?
                    hLabel:BGCOLOR = ttWidget.tLabelBgColor WHEN ttWidget.tLabelBgColor NE ?
                    .
  
                  /** Position the label. We use pixels here since we can X and WIDTH-PIXELS
                   *  are denominated in the same units, unlike COLUMN and WIDTH-CHARS.
                   *  ----------------------------------------------------------------------- **/
                  IF ( ttWidget.tLabelWidth - 1 ) GT hField:X THEN
                      ASSIGN dLabelWidth = hField:X - 1.
                  ELSE
                      ASSIGN dLabelWidth = ttWidget.tLabelWidth - 1.
  
                  IF dLabelWidth LE 0 THEN
                      ASSIGN dLabelWidth = 0.
  
                  /* If the label's width is zero, don't create a label. */
                  IF dLabelWidth EQ 0 THEN
                      DELETE WIDGET hLabel.
                  ELSE
                      ASSIGN hLabel:WIDTH-PIXELS      = dLabelWidth  + 3
                             hLabel:X                 = hField:X - hLabel:WIDTH-PIXELS
                             hField:SIDE-LABEL-HANDLE = hLabel.

              END.    /* CAN-SET the SIDE-LABEL-HANDLE */
              ELSE
                  /* Labels which do not support the SIDE-LABEL-HANDLE principle are set here. */
                  IF CAN-SET(hField, "LABEL":U) THEN
                      ASSIGN hField:LABEL       = ttWidget.tLabel
                             hField:WIDTH-CHARS = IF hField:TYPE <> "BUTTON":U THEN MAX(hField:WIDTH-CHARS, FONT-TABLE:GET-TEXT-WIDTH-CHARS(hField:LABEL, hField:FONT) + 4) ELSE hField:WIDTH-CHARS
                             .
          END.    /* there is a label. */

          /* Before visualising, add any other attributes */
          DYNAMIC-FUNCTION("setExtraAttributes":U  IN TARGET-PROCEDURE,
                           INPUT ttWidget.tRecordIdentifier,
                           INPUT hField,
                           INPUT ttWidget.tClassBufferHandle,
                           INPUT ghCall1 ).

          /* If the field is to be made visible, then the label should be, too.
           * However, we cannot set the VISIBLE attribute to YES without the
           * viewer's frame's VISIBLE attribute also being set to YES by the 4GL.
           * This behaviour is not acceptable if the viewer's HideOnInit property
           * is true.
           * We also need to ensure that all hidden widgets are actually hidden,
           * so we explicitly set their VISIBLE property to NO.                   */
          IF CAN-SET(hField, "VISIBLE":U)                     AND
             ( lHideOnInit EQ NO OR ttWidget.tVisible EQ NO ) THEN
          DO:
              ASSIGN hField:VISIBLE = ttWidget.tVisible.
              IF CAN-QUERY(hField, "SIDE-LABEL-HANDLE":U) THEN DO:
                  IF VALID-HANDLE(hField:SIDE-LABEL-HANDLE) THEN
                    ASSIGN hField:SIDE-LABEL-HANDLE:VISIBLE = ttWidget.tVisible.
              END.
          END.  /* Set field and label's visible attributes */

          /* Text widgets are usually meant to display one piece of data,
           * and are not generally used for displaying data from an SDO.
           * It is however, possible to display data from an SDO in a text
           * widget. In this case, the format and value is taken from the
           * DataField. We know which fields these are because of the value
           * of the DisplayField attribute.
           *
           * The code below is only for those text widgets that are not going
           * to display data from a data source (ie things like the labels on
           * rectangles).                                                      */
          IF ttwidget.tWidgetType EQ "TEXT":U AND ttWidget.tDisplayField EQ NO THEN
              /* The value of the format should be greater than zero. */
              ASSIGN hField:FORMAT       = "X(":U + STRING(MAX(LENGTH(ttWidget.tInitialValue), 1)) + ")":U
                     hField:SCREEN-VALUE = ttWidget.tInitialValue
                     NO-ERROR.

          /* Set the initial SENSITIVE state of the field to FALSE and let the toolbar
             take care of enabling and disabling the fields - this was done to fix issue #3627 */
          IF CAN-SET(hField, "SENSITIVE":U) THEN ASSIGN hField:SENSITIVE = FALSE. /*ttWidget.tEnabled.*/

          ASSIGN dRowPosition             = hField:ROW
                 dColumnPosition          = hField:COLUMN
                 dWidgetWidth             = hField:WIDTH-CHARS
                 dWidgetHeight            = hField:HEIGHT-CHARS
                 .
          /* UI Events. */
          DYNAMIC-FUNCTION("createWidgetEvents":U IN TARGET-PROCEDURE, INPUT ttWidget.tRecordIdentifier, INPUT hField).

          /** Popup?
           *  ----------------------------------------------------------------------- **/
          /* If the widget is not visible then the popup should not be created */
          IF ttWidget.tShowPopup AND ttWidget.tVisible THEN
          DO:
              /* Create a popup button for pop-up calendar or calculator */
              CREATE BUTTON hPopup
                  ASSIGN FRAME         = hDefaultFrame:HANDLE
                         NO-FOCUS      = TRUE
                         WIDTH-PIXELS  = 15                                                  
                         LABEL         = "...":U
                         PRIVATE-DATA  = "POPUP":U 
                         HIDDEN        = FALSE
                  TRIGGERS:
                      ON CHOOSE PERSISTENT RUN runLookup IN gshSessionManager (INPUT hField).
                  END TRIGGERS.

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
              
              ASSIGN cFieldPopupMapping = cFieldPopupMapping
                                        + (IF cFieldPopupMapping = "":U THEN "":U ELSE ",":U)
                                        + STRING(hField)
                                        + ",":U
                                        + STRING(hPopup).
          END.    /* show popup */
      END.    /* non-SDF */

      IF ttWidget.tWidgetType = "SmartDataField"               OR
         ( CAN-SET(ttWidget.tWidgetHandle, "TAB-STOP":U) AND
           ttWidget.tWidgetHandle:TAB-STOP                   ) THEN
      DO:
          ASSIGN hPreviousWidget = ttWidget.tWidgetHandle.
          IF ttWidget.tTabOrder                         NE 1 AND
             CAN-QUERY(ttWidget.tWidgetHandle, "ADM-DATA":U) AND
             CAN-QUERY(hPreviousWidget, "ADM-DATA":U)        THEN
              RUN adjustTabOrder IN TARGET-PROCEDURE ( INPUT ttWidget.tWidgetHandle,
                                                       INPUT hPreviousWidget,
                                                       INPUT "AFTER":U              ).
      END.    /* TAB-STOP is true */

      /* Determine the size of the frame. */
      ASSIGN dFrameWidth  = MAX(dFrameWidth, dColumnPosition + dWidgetWidth )
             dFrameHeight = MAX(dFrameHeight, dRowPosition + dWidgetHeight).
  END.    /* each widget */

  /* Set the Enabled~ and DisplayedFields properties. */
  {set DisplayedFields cDisplayedFields}.
  {set EnabledFields cEnabledFields}.
  {set AllFieldHandles cAllFieldHandles}.
  {set AllFieldNames cAllFieldNames}.
  {set FieldSecurity cFieldSecurity}.
  {set FieldPopupMapping cFieldPopupMapping}.

  /* Ensure that the viewer is disabled if it is an update-target without
   * tableio-source (? will enable ) */
  {set SaveSource NO}. 

  /* If there *are* no enabled fields, don't let the viewer be an 
   * Update-Source or TableIO-Target. NOTE: This in principle belongs
   * in datavis.i because it's generic but EnabledFields has just been set. */
  IF cEnabledFields = "":U THEN
  DO:
      RUN modifyListProperty IN TARGET-PROCEDURE (TARGET-PROCEDURE, "REMOVE":U, "SupportedLinks":U, "Update-Source":U).
      RUN modifyListProperty IN TARGET-PROCEDURE (TARGET-PROCEDURE, "REMOVE":U, "SupportedLinks":U, "TableIO-Target":U).
  END.   /* END DO cEnabled "" */
  ELSE
  DO:
      /* If there are EnabledFields, set the Editable Property to true.
       * This is because the 'Add', 'Update' and 'Copy' actions require 
       * this property to be set as part of their ENABLE_RULEs.
       * This property is usually determined by reading the EnabledFields
       * property, but because we are only setting this property here, as
       * opposed to when the viewer is RUN, we need to explicitly set the
       * Editable property to true.                                      */
      {set Editable YES}.
  END.    /* EnabledFields exist. */

  /* Non-db fields. */
  {set EnabledObjFlds cEnabledObjects}.

  /* Clean up the call handle */
  ghCall1:CLEAR().

  /* All widgets are now complete. We set the frame to fit the widgets. */
  ASSIGN dFrameWidth                = MAX(dFrameWidth, 10)
         hDefaultFrame:WIDTH-CHARS  = dFrameWidth
         hDefaultFrame:HEIGHT-CHARS = dFrameHeight
         NO-ERROR.

  /* get the MinWidth and MinHeight attributes. */
  {get MinHeight dFrameMinHeight}.
  {get MinWidth  dFrameMinWidth}.

  IF (dFrameMinHeight NE dFrameHeight AND dFrameHeight GT dFrameMinHeight) OR
     (dFrameMinWidth  NE dFrameWidth  AND dFrameWidth  GT dFrameMinWidth) THEN
      RUN changeFrameSizeAttributes  IN TARGET-PROCEDURE (INPUT dFrameHeight, INPUT dFrameWidth).
  
  /* Ensure that we always set the viewer's size to the minHeight and MinWidth
     stored agains the object's attributes - but ONLY if their values are more
     than that calculated - see issue #6058 */
  /* Set MinHeight */  
  IF dFrameMinHeight <> ? AND
     dFrameMinHeight > dFrameHeight THEN
    ASSIGN hDefaultFrame:HEIGHT-CHARS = dFrameMinHeight.
  /* Set MinWidth */
  IF dFrameMinWidth <> ? AND 
     dFrameMinWidth > dFrameWidth THEN
    ASSIGN hDefaultFrame:WIDTH-CHARS = dFrameMinWidth.
        
  /* Finally the virtual size can be also reduced. */
  ASSIGN hDefaultFrame:VIRTUAL-WIDTH-CHARS  = hDefaultFrame:WIDTH-CHARS 
         hDefaultFrame:VIRTUAL-HEIGHT-CHARS = hDefaultFrame:HEIGHT-CHARS
         NO-ERROR.

  RUN SUPER.

  /* Flag this object as having been created. */
  {set ObjectsCreated YES}.

  RETURN.
END PROCEDURE.  /* createObjects */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:        
------------------------------------------------------------------------------*/
    DYNAMIC-FUNCTION("destroyWidgets":U  IN TARGET-PROCEDURE).

    RUN SUPER.

    DELETE OBJECT ghCall1 NO-ERROR.
    ASSIGN ghCall1 = ?.

    DELETE OBJECT ghQuery1 NO-ERROR.
    ASSIGN ghQuery1 = ?.

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* destroyObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disable_UI) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Procedure  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/    
    /* Ensure that the widgets on the viewer have been created. */
    IF NOT {fn getObjectsCreated} THEN
       RUN createObjects IN TARGET-PROCEDURE.

    RUN SUPER.

    {fn displayInitialValues}.
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* initializeObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-repositionWidgetForTranslation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionWidgetForTranslation Procedure 
PROCEDURE repositionWidgetForTranslation :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will be run to first check if we need to adjust
               any columns of objects due to translation and if so, it will 
               also adjust these columns and resize the viewer accordingly.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dNewLabelLength  AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE dMinCol          AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE dFirstCol        AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE dAddCol          AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE dMaxRow          AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE hAttributeBuffer AS HANDLE     NO-UNDO.
    DEFINE VARIABLE dRadioWidth      AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE hField           AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hFieldHorizontal AS HANDLE     NO-UNDO.
    DEFINE VARIABLE lHorizontal      AS LOGICAL    NO-UNDO.
    
    FOR EACH ttWidget WHERE
             ttWidget.tTargetProcedure = TARGET-PROCEDURE
             NO-LOCK:
        ASSIGN dNewLabelLength = FONT-TABLE:GET-TEXT-WIDTH-CHARS(ttWidget.tLabel, ttWidget.tFont)
               dMinCol         = MAXIMUM(dMinCol, dNewLabelLength + 2.4)
               .
        IF ttWidget.tColumn LT dFirstCol OR
           dFirstCol        EQ 0         THEN
            ASSIGN dFirstCol = ttWidget.tColumn.
    END.

    /* Check if we need to adjust any columns */
    IF dMinCol GT 0 AND dFirstCol GT 0 THEN
        ASSIGN dAddCol = (dMinCol - dFirstCol) + 1.
    ELSE
        ASSIGN dAddCol = 0.

    /* If we need to adjust the colmns then run run this code */
    IF dAddCol > 0 THEN
    DO:
        FOR EACH ttWidget WHERE
                 ttWidget.tTargetProcedure = TARGET-PROCEDURE
                 EXCLUSIVE-LOCK:

            /* Make sure that we have valid values */
            IF ttWidget.tRow EQ ? THEN
                ASSIGN dMaxRow       = dMaxRow + 1
                       ttWidget.tRow = dMaxRow
                       .

            IF ttWidget.tColumn EQ ? THEN
                ASSIGN ttWidget.tColumn = 1.

            /* Do we need to resize? */
            IF dAddCol GT 0 THEN
                ASSIGN ttWidget.tColumn =  ttWidget.tColumn + dAddCol.

            /* Check for translated RADIO-SETS */
            ASSIGN hAttributeBuffer = ttWidget.tClassBufferHandle.
            IF VALID-HANDLE(hAttributeBuffer) THEN
            DO:
                hAttributeBuffer:FIND-FIRST(" WHERE " + hAttributeBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(ttWidget.tRecordIdentifier)) NO-ERROR.
                IF hAttributeBuffer:AVAILABLE THEN
                DO:
                    ASSIGN hFieldHorizontal = hAttributeBuffer:BUFFER-FIELD("HORIZONTAL":U) NO-ERROR.
                    IF VALID-HANDLE(hFieldHorizontal) THEN
                        ASSIGN lHorizontal = hFieldHorizontal:BUFFER-VALUE.

                    ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("RADIO-BUTTONS":U) NO-ERROR.
                    IF VALID-HANDLE(hField) THEN
                        ASSIGN dRadioWidth = DYNAMIC-FUNCTION("assignRadioSetWidth":U IN TARGET-PROCEDURE, hField:BUFFER-VALUE,ttWidget.tFont,lHorizontal).
                END.    /* available buffer */
            END.    /* valid attribute */

            IF dRadioWidth = ? THEN
                ASSIGN dRadioWidth = 0.

            IF dRadioWidth > ttWidget.tWidth THEN
                ASSIGN ttWidget.tWidth = dRadioWidth + 3.5. /* Add 3.5 for RADIO-BUTTON UI */
        END.    /* each widget */
    END.    /* AddCol > 0 */
    ELSE
    DO:
        /* Check for translated RADIO-SETS 
         * This will only run if the any other translation on
         * labels did not affect their positions */
        FOR EACH ttWidget WHERE 
                 ttWidget.tTargetProcedure = TARGET-PROCEDURE AND
                 ttWidget.tWidgetType = "RADIO-SET":U
                 EXCLUSIVE-LOCK:
            ASSIGN hAttributeBuffer = ttWidget.tClassBufferHandle.

            IF VALID-HANDLE(hAttributeBuffer) THEN
            DO:
                hAttributeBuffer:FIND-FIRST(" WHERE " + hAttributeBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(ttWidget.tRecordIdentifier)) NO-ERROR.

                IF hAttributeBuffer:AVAILABLE THEN
                DO:
                    ASSIGN hFieldHorizontal = hAttributeBuffer:BUFFER-FIELD("HORIZONTAL":U) NO-ERROR.
                    IF VALID-HANDLE(hFieldHorizontal) THEN
                        ASSIGN lHorizontal = hFieldHorizontal:BUFFER-VALUE.

                    ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("RADIO-BUTTONS":U) NO-ERROR.
                    IF VALID-HANDLE(hField) THEN
                        ASSIGN dRadioWidth = DYNAMIC-FUNCTION("assignRadioSetWidth":U IN TARGET-PROCEDURE, hField:BUFFER-VALUE,ttWidget.tFont,lHorizontal).
                END.    /* available attribute buffer */
            END.    /* valid attribute buffer */
            
            IF dRadioWidth = ? THEN
                ASSIGN dRadioWidth = 0.

            IF dRadioWidth > ttWidget.tWidth THEN
                ASSIGN ttWidget.tWidth = dRadioWidth + 3.5. /* Add 3.5 for RADIO-BUTTON UI */
        END. /* ttWidget */
    END. /* Else */
    
    ASSIGN hField = ?.

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* repositionWidgetForTranslation */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-assignRadioSetWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignRadioSetWidth Procedure 
FUNCTION assignRadioSetWidth RETURNS DECIMAL
  ( pcRadioButtons AS CHARACTER,
    piFont         AS INTEGER,
    plHorizontal   AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  This function will determine the RADIO-SET's largest option in width
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dMaxWidth    AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iRadioLoop   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cRadioOption AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dOptionWidth AS DECIMAL    NO-UNDO.
  
  IF NOT plHorizontal THEN DO:
    DO iRadioLoop = 1 TO NUM-ENTRIES(pcRadioButtons) BY 2:
      cRadioOption = ENTRY(iRadioLoop, pcRadioButtons).
      dOptionWidth = FONT-TABLE:GET-TEXT-WIDTH-CHARS(cRadioOption, piFont).
      dMaxWidth = MAX(dMaxWidth,dOptionWidth).
    END.
  END.
  ELSE DO:
    dMaxWidth = 0.
    DO iRadioLoop = 1 TO NUM-ENTRIES(pcRadioButtons) BY 2:
      cRadioOption = ENTRY(iRadioLoop, pcRadioButtons).
      dOptionWidth = FONT-TABLE:GET-TEXT-WIDTH-CHARS(cRadioOption, piFont).
      dMaxWidth = dMaxWidth + dOptionWidth + 3.5 /* to reserve space for the UI (sircle) */.
    END.
  END.
  RETURN dMaxWidth.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createWidgetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createWidgetEvents Procedure 
FUNCTION createWidgetEvents RETURNS LOGICAL
    ( INPUT pdInstanceId        AS DECIMAL,
      INPUT phWidget            AS HANDLE       ) :
/*------------------------------------------------------------------------------
  Purpose:  Creates custom events for the widget. 
    Notes:  * A Dynamics Repository is required for this API.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hEventBuffer                AS HANDLE               NO-UNDO.
    DEFINE VARIABLE cEventName                  AS CHARACTER            NO-UNDO.
    
    ASSIGN hEventBuffer = DYNAMIC-FUNCTION("getCacheUiEventBuffer":U IN gshRepositoryManager).
    
    IF NOT VALID-HANDLE(ghQuery1) THEN
        CREATE QUERY ghQuery1.

    ghQuery1:SET-BUFFERS(hEventBuffer).
    ghQuery1:QUERY-PREPARE(" FOR EACH " + hEventBuffer:NAME + " WHERE ":U
                           + hEventBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(pdInstanceId)).

    ghQuery1:QUERY-OPEN().
    ghQuery1:GET-FIRST().
    DO WHILE hEventBuffer:AVAILABLE:
        ASSIGN cEventName = hEventBuffer:BUFFER-FIELD("tEventName":U):BUFFER-VALUE.
        /* Make sure that this is a valid event for the widget */
        IF VALID-EVENT(phWidget, cEventName ) THEN
        CASE cEventName:
            WHEN "ANY-KEY":U                THEN ON ANY-KEY                OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "ANY-PRINTABLE":U          THEN ON ANY-PRINTABLE          OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "BACK-TAB":U               THEN ON BACK-TAB               OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "BACKSPACE":U              THEN ON BACKSPACE              OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "BELL":U                   THEN ON BELL                   OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "CHOOSE":U                 THEN ON CHOOSE                 OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "CLEAR":U                  THEN ON CLEAR                  OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "DEFAULT-ACTION":U         THEN ON DEFAULT-ACTION         OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "DEL":U                    THEN ON DEL                    OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "DELETE-CHAR":U            THEN ON DELETE-CHAR            OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "DELETE-CHARACTER":U       THEN ON DELETE-CHARACTER       OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "DESELECT":U               THEN ON DESELECT               OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "DESELECTION":U            THEN ON DESELECTION            OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "DROP-FILE-NOTIFY":U       THEN ON DROP-FILE-NOTIFY       OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "EMPTY-SELECTION":U        THEN ON EMPTY-SELECTION        OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "END-BOX-SELECTION":U      THEN ON END-BOX-SELECTION      OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "END-ERROR":U              THEN ON END-ERROR              OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "END-MOVE":U               THEN ON END-MOVE               OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "END-RESIZE":U             THEN ON END-RESIZE             OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "ENDKEY":U                 THEN ON ENDKEY                 OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "ENTRY":U                  THEN ON ENTRY                  OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "ERROR":U                  THEN ON ERROR                  OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "GO":U                     THEN ON GO                     OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "HELP":U                   THEN ON HELP                   OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "LEAVE":U                  THEN ON LEAVE                  OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "MOUSE-MENU-CLICK":U       THEN ON MOUSE-MENU-CLICK       OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "MOUSE-SELECT-CLICK":U     THEN ON MOUSE-SELECT-CLICK     OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "MOUSE-SELECT-DBLCLICK":U  THEN ON MOUSE-SELECT-DBLCLICK  OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "PARENT-WINDOW-CLOSE"      THEN ON PARENT-WINDOW-CLOSE    OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "RECALL":U                 THEN ON RECALL                 OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "RETURN":U                 THEN ON RETURN                 OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "SELECT":U                 THEN ON SELECT                 OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "SELECTION":U              THEN ON SELECTION              OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "START-BOX-SELECTION":U    THEN ON START-BOX-SELECTION    OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "START-MOVE":U             THEN ON START-MOVE             OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "START-RESIZE":U           THEN ON START-RESIZE           OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "TAB":U                    THEN ON TAB                    OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "VALUE-CHANGED":U          THEN ON VALUE-CHANGED          OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "WINDOW-CLOSE":U           THEN ON WINDOW-CLOSE           OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "WINDOW-MAXIMIZED":U       THEN ON WINDOW-MAXIMIZED       OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "WINDOW-MINIMIZED":U       THEN ON WINDOW-MINIMIZED       OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "WINDOW-RESIZED":U         THEN ON WINDOW-RESIZED         OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            WHEN "WINDOW-RESTORED":U        THEN ON WINDOW-RESTORED        OF phWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.                    
        END CASE.    /* only valid events */

        ghQuery1:GET-NEXT().
    END.    /* UI events. */
    ghQuery1:QUERY-CLOSE().

    RETURN TRUE.
END FUNCTION.   /* createUiEvents */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyWidgets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION destroyWidgets Procedure 
FUNCTION destroyWidgets RETURNS LOGICAL
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Destroy everything in case we are morphing from one physical 
           object to another
    Notes:  * If this procedure is being called from another destroy routine,
              we don't delete the PROCEDURE objects. These will be gracefully
              destroyed by the ADM.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hWidget         AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hObjectBuffer   AS HANDLE     NO-UNDO.

    DEFINE BUFFER ttWidget  FOR ttWidget.

    FOR EACH ttWidget WHERE
             ttWidget.tTargetProcedure = TARGET-PROCEDURE:

        IF VALID-HANDLE(ttWidget.tWidgetHandle) THEN
        DO:
            IF ttWidget.tWidgetType = "SmartDataField":U AND
               PROGRAM-NAME(2) BEGINS "destroy":U        THEN
                NEXT.

            IF CAN-QUERY(ttWidget.tWidgetHandle, "SIDE-LABEL-HANDLE":U) THEN
            DO:
                ASSIGN hWidget = ttWidget.tWidgetHandle:SIDE-LABEL-HANDLE.
    
                IF VALID-HANDLE(hWidget) THEN
                    DELETE WIDGET hWidget.
            END.    /* label */
    
            DELETE OBJECT ttWidget.tWidgetHandle NO-ERROR.    
            ASSIGN 
              ttWidget.tWidgetHandle = ?
              ttWidget.tFrameHandle  = ?.
        END.    /* valid widget handle */

        DELETE ttWidget.
    END.    /* each widget */
    
    DYNAMIC-FUNCTION('destroyPopups':U IN TARGET-PROCEDURE).

    RETURN TRUE.
END FUNCTION.   /* destroyWidgets */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-displayInitialValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION displayInitialValues Procedure 
FUNCTION displayInitialValues RETURNS LOGICAL
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the initial (on viewer instantiation) value for various widgets.
    Notes:  * Only widgets that are not dataobject-based will have their initial
              values displayed.
            * The value in the InitialValue attribute/field is assumed to be the
              key value in cases where there is a key and display value, like combos
              and DynLookups.
------------------------------------------------------------------------------*/
    FOR EACH ttWidget WHERE
             ttWidget.tTargetProcedure = TARGET-PROCEDURE AND
             ttWidget.tVisible         = TRUE             AND
             ttWidget.tInitialValue   <> "":U             AND
             ttWidget.tInitialValue   <> ?
             BY ttWidget.tTabOrder:
        IF ttWidget.tWidgetType EQ "SmartDataField":U AND
           {fn getLocalField ttWidget.tWidgetHandle}  THEN            
            RUN assignNewValue IN ttWidget.tWidgetHandle ( INPUT ttWidget.tInitialValue,
                                                           INPUT "":U,              /* pcDisplayedValue */
                                                           INPUT NO   ) NO-ERROR.   /* plSetModified */
        ELSE
        IF CAN-SET(ttWidget.tWidgetHandle, "SCREEN-VALUE":U)         AND
           (ttWidget.tTableName EQ ? OR ttWidget.tTableName EQ "":U) THEN
            ASSIGN ttWidget.tWidgetHandle:SCREEN-VALUE = ttWidget.tInitialValue.
    END.    /* all objects */    

    /* There may be no override for this API: execture with NO-ERROR. */
    SUPER() NO-ERROR.

    RETURN TRUE.
END FUNCTION.   /* displayInitialValues */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchObjectDetail) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fetchObjectDetail Procedure 
FUNCTION fetchObjectDetail RETURNS LOGICAL
  ( /* No parameters */ ) :
/*------------------------------------------------------------------------------
  Purpose: Creates the ttWidget table from the cache_Object records.
    Notes: 
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hObjectBuffer               AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hAttributeBuffer            AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hField                      AS HANDLE               NO-UNDO.
    DEFINE VARIABLE dInstanceId                 AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE cLogicalObjectName          AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cDataSourceNames            AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE lObjectTranslated           AS LOGICAL              NO-UNDO.
    
    /* Get the InstanceID of the viewer. We use this to determine what the contained instances are
     * because it is used as the tContainerRecordIdentifier of the contained instances.            */
    {get InstanceId dInstanceID}.
    {get LogicalObjectName cLogicalObjectName}.
    {get DataSourceNames cDataSourceNames}.
    IF cDataSourceNames EQ ? THEN
        ASSIGN cDataSourceNames = "":U.

    ASSIGN hObjectBuffer     = DYNAMIC-FUNCTION("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT dInstanceID)
           hAttributeBuffer  = hObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE
           lObjectTranslated = NO
           .
    /* Create the viewer widgets */
    FOR EACH ttWidget WHERE ttWidget.tTargetProcedure = TARGET-PROCEDURE:
        DELETE ttWidget.
    END.

    /* Now process the viewer widgets */
    IF NOT VALID-HANDLE(ghQuery1) THEN
        CREATE QUERY ghQuery1.

    ghQuery1:SET-BUFFERS(hObjectBuffer).
    ghQuery1:QUERY-PREPARE(" FOR EACH ":U + hObjectBuffer:NAME + " WHERE ":U
                           + hObjectBuffer:NAME + ".tContainerRecordIdentifier = ":U + QUOTER(dInstanceID) ).

    ghQuery1:QUERY-OPEN().
    ghQuery1:GET-FIRST().
    DO WHILE hObjectBuffer:AVAILABLE: 
        CREATE ttWidget.
        ASSIGN ttWidget.tViewerObjectName  = cLogicalObjectName
               ttWidget.tTargetProcedure   = TARGET-PROCEDURE
               ttWidget.tRecordIdentifier  = hObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE
               ttWidget.tClassBufferHandle = hObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE
               ttWidget.tObjectInstanceObj = hObjectBuffer:BUFFER-FIELD("tObjectInstanceObj":U):BUFFER-VALUE
               ttWidget.tCustomSuperProc   = hObjectBuffer:BUFFER-FIELD("tCustomSuperProcedure":U):BUFFER-VALUE
               ttWidget.tPhysicalFilename  = hObjectBuffer:BUFFER-FIELD("tObjectPathedFilename":U):BUFFER-VALUE
               ttWidget.tSecuredHidden     = hObjectBuffer:BUFFER-FIELD("tSecuredHidden":U):BUFFER-VALUE
               ttWidget.tSecuredReadOnly   = hObjectBuffer:BUFFER-FIELD("tSecuredReadOnly":U):BUFFER-VALUE
               ttWidget.tWidgetHandle      = ?
               ttWidget.tFrameHandle       = ?
               hAttributeBuffer            = ttWidget.tClassBufferHandle
               .
        hAttributeBuffer:FIND-FIRST(" WHERE ":U + hAttributeBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(ttWidget.tRecordIdentifier) ) NO-ERROR.

        /* We only want to reposition objects if translation occurred.
           To do this we will set this variable and check it before
           we run the extra code */
        IF lObjectTranslated = FALSE AND hObjectBuffer:BUFFER-FIELD("tObjectTranslated":U):BUFFER-VALUE = TRUE THEN
            ASSIGN lObjectTranslated = TRUE.

        ASSIGN ttWidget.tWidgetType = hAttributeBuffer:BUFFER-FIELD("VisualizationType":U):BUFFER-VALUE NO-ERROR.
        ASSIGN ttWidget.tRow        = hAttributeBuffer:BUFFER-FIELD("ROW":U):BUFFER-VALUE NO-ERROR.
        /* Ensure that there are valid Row values */
        IF ttWidget.tRow EQ 0 OR ttWidget.tRow EQ ? THEN
            ASSIGN ttWidget.tRow = 1.

        ASSIGN ttWidget.tColumn = hAttributeBuffer:BUFFER-FIELD("COLUMN":U):BUFFER-VALUE NO-ERROR.
        /* Ensure that there are valid Column values*/
        IF ttWidget.tColumn EQ 0 OR ttWidget.tColumn EQ ? THEN
            ASSIGN ttWidget.tColumn = 1.

        ASSIGN ttWidget.tHeight = hAttributeBuffer:BUFFER-FIELD("HEIGHT-CHARS":U):BUFFER-VALUE NO-ERROR.
        /* Ensure that there are valid Height values*/
        IF ttWidget.tHeight EQ 0 OR ttWidget.tHeight EQ ? THEN
            ASSIGN ttWidget.tHeight = 1.

        ASSIGN ttWidget.tFont  = hAttributeBuffer:BUFFER-FIELD("FONT":U):BUFFER-VALUE NO-ERROR.
        ASSIGN ttWidget.tWidth = hAttributeBuffer:BUFFER-FIELD("WIDTH-CHARS":U):BUFFER-VALUE NO-ERROR.
        /* Ensure that there are valid Width values. Make it the equivalent of 8 characters wide. */
        IF ttWidget.tWidth EQ 0 OR ttWidget.tWidth EQ ? THEN
            ASSIGN ttWidget.tWidth = FONT-TABLE:GET-TEXT-WIDTH-CHARS("wwwwwwww":U, ttWidget.tFont).

        /* This break up is necessary because not all widgets have InitialValue and DisplayField  attributes. */
        ASSIGN ttWidget.tInitialValue = hAttributeBuffer:BUFFER-FIELD("InitialValue":U):BUFFER-VALUE NO-ERROR.
        ASSIGN ttWidget.tDisplayField = hAttributeBuffer:BUFFER-FIELD("DisplayField":U):BUFFER-VALUE NO-ERROR.
        
        /* Check that DisplayField is not ? */
        IF ttWidget.tDisplayField = ? THEN
            ASSIGN ttWidget.tDisplayField = NO.

        /* Objects of type Procedure should be treated as static SDFs as far as possible. */
        IF CAN-DO(hObjectBuffer:BUFFER-FIELD("tInheritsFromClasses":U):BUFFER-VALUE, "Field":U)     OR
           CAN-DO(hObjectBuffer:BUFFER-FIELD("tInheritsFromClasses":U):BUFFER-VALUE, "Procedure":U) THEN
        DO:
            ASSIGN ttWidget.tWidgetType = "SmartDataField":U.
            ASSIGN ttWidget.tTooltip    = hAttributeBuffer:BUFFER-FIELD("FieldTooltip":U):BUFFER-VALUE NO-ERROR.
            ASSIGN ttWidget.tLabel      = hAttributeBuffer:BUFFER-FIELD("FieldLabel":U):BUFFER-VALUE NO-ERROR.
            ASSIGN ttWidget.tEnabled    = hAttributeBuffer:BUFFER-FIELD("EnableField":U):BUFFER-VALUE NO-ERROR.
            ASSIGN ttWidget.tTabOrder   = hAttributeBuffer:BUFFER-FIELD("Order":U):BUFFER-VALUE NO-ERROR.
        END.    /* SDF */
        ELSE
        DO:
            /* We have individual ASSIGN statements here because we cannot assume that the attributes referenced
             * below exist for the object type of the widget we want to create. 
             * These attributes should probably exist in the Repository, but for belts-and-braces we break the 
             * ASSIGN statements up.                                                                           */
            ASSIGN ttWidget.tVisible      = hAttributeBuffer:BUFFER-FIELD("VISIBLE":U):BUFFER-VALUE NO-ERROR.
            ASSIGN ttWidget.tTabOrder     = hAttributeBuffer:BUFFER-FIELD("Order":U):BUFFER-VALUE NO-ERROR.
            ASSIGN ttWidget.tTooltip      = hAttributeBuffer:BUFFER-FIELD("TOOLTIP":U):BUFFER-VALUE NO-ERROR.

            /* The ObjectName attribute is populated from the INSTANCE_NAME field on the object instance record.
             * If there is no ObjectName attribute then populate using the NAME attribute.                      */
            ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("ObjectName":U) NO-ERROR.
            IF NOT VALID-HANDLE(hField) OR hField:BUFFER-VALUE EQ "":U OR hField:BUFFER-VALUE EQ ? THEN
                ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("NAME":U) NO-ERROR.

            ASSIGN ttWidget.tWidgetName = hField:BUFFER-VALUE NO-ERROR.

            /* Some widgets may not have the LABELS attribute. */
            ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("LABELS":U) NO-ERROR.
            IF VALID-HANDLE(hField) THEN
                ASSIGN ttWidget.tLabel = (IF hAttributeBuffer:BUFFER-FIELD("LABELS":U):BUFFER-VALUE THEN hAttributeBuffer:BUFFER-FIELD("LABEL":U):BUFFER-VALUE ELSE ?) NO-ERROR.
            ELSE
                ASSIGN ttWidget.tLabel = hAttributeBuffer:BUFFER-FIELD("LABEL":U):BUFFER-VALUE NO-ERROR.

            /* Remove any colons in the label, we'll add them again when we render the label */
            ASSIGN ttWidget.tLabel = REPLACE(ttWidget.tLabel, ":":U, "":U)
                   ttWidget.tLabel = TRIM(ttWidget.tLabel).

            ASSIGN ttWidget.tLabelFont    = hAttributeBuffer:BUFFER-FIELD("LabelFont":U):BUFFER-VALUE NO-ERROR.
            ASSIGN ttWidget.tLabelBgColor = hAttributeBuffer:BUFFER-FIELD("LabelBgColor":U):BUFFER-VALUE NO-ERROR.
            ASSIGN ttWidget.tLabelFgColor = hAttributeBuffer:BUFFER-FIELD("LabelFgColor":U):BUFFER-VALUE NO-ERROR.
            ASSIGN ttWidget.tLabelWidth   = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(ttWidget.tLabel, ttWidget.tLabelFont) NO-ERROR.
            
            ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("TableName":U) NO-ERROR.
            IF VALID-HANDLE(hField) THEN
            DO:
                IF cDataSourceNames EQ "":U THEN
                    ASSIGN ttWidget.tTableName = "RowObject":U.
                ELSE
                    ASSIGN ttWidget.tTableName = hField:BUFFER-VALUE.                   
            END.    /* available Table */

            ASSIGN ttWidget.tPrivateData     = hAttributeBuffer:BUFFER-FIELD("PRIVATE-DATA":U):BUFFER-VALUE NO-ERROR.
            ASSIGN ttWidget.tFormat          = hAttributeBuffer:BUFFER-FIELD("FORMAT":U):BUFFER-VALUE NO-ERROR.
            ASSIGN ttWidget.tDataType        = hAttributeBuffer:BUFFER-FIELD("DATA-TYPE":U):BUFFER-VALUE NO-ERROR.
            ASSIGN ttWidget.tEnabled         = hAttributeBuffer:BUFFER-FIELD("ENABLED":U):BUFFER-VALUE NO-ERROR.
            ASSIGN ttWidget.tShowPopup       = hAttributeBuffer:BUFFER-FIELD("ShowPopup":U):BUFFER-VALUE NO-ERROR.
        END. /* Else it is not a SmartDataField */

        ghQuery1:GET-NEXT().
    END.    /* ttobject query  */
    ghQuery1:QUERY-CLOSE().
    
    /* If translation was done - then we need to check if we need to adjust
       any columns for larger labels */
    IF lObjectTranslated THEN
        RUN repositionWidgetForTranslation IN TARGET-PROCEDURE.

    RETURN TRUE.
END FUNCTION.   /* fetchObjectDetail */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentLogicalName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentLogicalName Procedure 
FUNCTION getCurrentLogicalName RETURNS CHARACTER
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the name of the object currently being worked with.
    Notes:  * this API is called from prepareInstance.
------------------------------------------------------------------------------*/
    RETURN gcCurrentObjectName.
END FUNCTION.   /* getCurrentLogicalName */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPopupHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPopupHandle Procedure 
FUNCTION getPopupHandle RETURNS HANDLE
    ( INPUT phWidgetHandle      AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes: This is kept for backwards compatibility and should NOT be moved to 
           adm2 as it clashes with naming convention.      
------------------------------------------------------------------------------*/
  RETURN {fn popupHandle phWidgetHandle}.  
END FUNCTION.   /* getPopupHandle */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setExtraAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setExtraAttributes Procedure 
FUNCTION setExtraAttributes RETURNS LOGICAL
    ( INPUT pdRecordIdentifier      AS DECIMAL,
      INPUT phField                 AS HANDLE,
      INPUT phAttributeBuffer       AS HANDLE,
      INPUT phCall                  AS HANDLE       ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the attibutes for the specified widget. These will be attributes
            for widget types other than FILL-INs, which are the default widget
            type. 
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cAttributeName          AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE iFieldLoop              AS INTEGER                  NO-UNDO.

    /* Reposition the attribute buffer to the correct field attributes */
    phAttributeBuffer:FIND-FIRST(" WHERE " + phAttributeBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(pdRecordIdentifier)) NO-ERROR.

    IF NOT VALID-HANDLE(phAttributeBuffer) THEN
        RETURN TRUE.

    DO iFieldLoop = 1 TO phAttributeBuffer:NUM-FIELDS:

        ASSIGN cAttributeName = phAttributeBuffer:BUFFER-FIELD(iFieldLoop):NAME.

        /* There are certain attributes which are already set *
         * by CreateObject                                    */
        IF CAN-DO(gcDefaultAttributes,cAttributeName) THEN NEXT.

        /* Hardcode out bugs because 
           fill-ins can't assign an unknown (?) to their SUBTYPE attribute
           Widgets can't assign an unknown (?) to their FGCOLOR or BGCOLOR
           attribute                                                             */
        IF cAttributeName = "SUBTYPE":U AND phField:TYPE = "FILL-IN":U AND
           phAttributeBuffer:BUFFER-FIELD(iFieldLoop):BUFFER-VALUE = ? THEN NEXT.
        IF cAttributeName MATCHES "*COLOR":U AND
           phAttributeBuffer:BUFFER-FIELD(iFieldLoop):BUFFER-VALUE = ? THEN NEXT.
        IF cAttributeName = "SUBTYPE":U AND phField:TYPE = "COMBO-BOX":U AND
           phAttributeBuffer:BUFFER-FIELD(iFieldLoop):BUFFER-VALUE = ? THEN NEXT.

        /* deal with blank combo issues */
        IF cAttributeName BEGINS "list-item":U AND
           STRING(phAttributeBuffer:BUFFER-FIELD(iFieldLoop):BUFFER-VALUE) = "":U THEN NEXT.
        IF cAttributeName BEGINS "list-item":U AND
           STRING(phAttributeBuffer:BUFFER-FIELD(iFieldLoop):BUFFER-VALUE) = ? THEN NEXT.

        /* Deal with Editor issues */
        IF phField:TYPE EQ "EDITOR":U THEN
        DO:
            IF cAttributeName EQ "INNER-LINES":U AND CAN-DO("?,0,":U, STRING(phAttributeBuffer:BUFFER-FIELD(iFieldLoop):BUFFER-VALUE)) THEN
                NEXT.
        END.   /* editor special cases */

        IF phField:TYPE EQ "TOGGLE-BOX":U THEN
        DO:
            IF cAttributeName                                          EQ "CHECKED":U AND 
               phAttributeBuffer:BUFFER-FIELD(iFieldLoop):BUFFER-VALUE EQ ?           THEN
                ASSIGN phAttributeBuffer:BUFFER-FIELD(iFieldLoop):BUFFER-VALUE = NO.
        END.    /* Toggle box */

        IF (phField:TYPE = "IMAGE":U OR 
            phField:TYPE = "BUTTON":U) AND 
           cAttributeName = "IMAGE-FILE":U THEN
          phField:LOAD-IMAGE(STRING(phAttributeBuffer:BUFFER-FIELD(iFieldLoop):BUFFER-VALUE)) NO-ERROR.

        /* Only set this value if we are allowed to. */
        IF CAN-SET(phField, cAttributeName) THEN
        DO:
            phCall:IN-HANDLE = phField.                 
            phCall:CALL-NAME = cAttributeName.          
            phCall:NUM-PARAMETERS = 1.                   
            phCall:SET-PARAMETER(1, 
                                 phAttributeBuffer:BUFFER-FIELD(iFieldLoop):DATA-TYPE,
                                 "INPUT",
                                 STRING(phAttributeBuffer:BUFFER-FIELD(iFieldLoop):BUFFER-VALUE)
                                 ) .
            phCall:INVOKE.                               /* Invoke the call */
        END.    /* can set attribute */
    END.    /* field loop */

    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

