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
  File: rydynbrwcp.p

  Description:  Dynamics Browse Class Object Procedure

  Purpose:      Dynamics Browse Class Object Procedure

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   06/21/2002  Author:     Peter Judge

  Update Notes: Created from Template rytemplipp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rydynbrwcp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

{ src/adm2/globals.i }

/* temp-table for translations */
{ af/app/aftttranslate.i }

DEFINE VARIABLE ghQuery1                    AS HANDLE                   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-prepareAttributeString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD prepareAttributeString Procedure 
FUNCTION prepareAttributeString RETURNS CHARACTER
    ( INPUT piFieldsInBrowser       AS INTEGER,
      INPUT pcAttributeString       AS CHARACTER,
      INPUT pcDefaultFiller         AS CHARACTER,
      INPUT pcDelimiter             AS CHARACTER    )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateAttributeStringValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD updateAttributeStringValue Procedure 
FUNCTION updateAttributeStringValue RETURNS CHARACTER
    ( INPUT piListEntry         AS INTEGER,
      INPUT pcDelimiter         AS CHARACTER,
      INPUT pcDefaultFiller     AS CHARACTER,
      INPUT pcAttributeString   AS CHARACTER,
      INPUT phBufferField       AS HANDLE           )  FORWARD.

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
         HEIGHT             = 13.95
         WIDTH              = 64.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */

{ry/app/ryplipmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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

ASSIGN cDescription = "Dynamics Browse Class Object Procedure PLIP".

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

&IF DEFINED(EXCLUDE-validateClassData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateClassData Procedure 
PROCEDURE validateClassData:
/*------------------------------------------------------------------------------
  Purpose:     Performs certain customisations for objects belonging to the
               Browse Class.
  Parameters:  pcLogicalObjectName -
               pcResultCode        -
               pdUserObj           -
               pcRunAttribute      -
               pdLanguageObj       -
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcLogicalObjectName          AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pcResultCode                 AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pdUserObj                    AS DECIMAL      NO-UNDO.
    DEFINE INPUT PARAMETER pcRunAttribute               AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pdLanguageObj                AS DECIMAL      NO-UNDO.
    DEFINE INPUT PARAMETER pdInstanceId                 AS DECIMAL      NO-UNDO.

    DEFINE VARIABLE cContainerName              AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cSecurityType               AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cDisplayedFields            AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cFieldSecurity              AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cFieldName                  AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cDbFieldName                AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cTranslationEnabled         AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cStoredBrowseLabels         AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cListValue                  AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE iFieldLoop                  AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iFieldEntry                 AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iFieldsInBrowser            AS INTEGER              NO-UNDO.
    DEFINE VARIABLE hAttributeBuffer            AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hBrowserAttributeBuffer     AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hField                      AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hRowObject                  AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hSdo                        AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hColumn                     AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hObjectBuffer               AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hLocalObjectBuffer          AS HANDLE               NO-UNDO.
    DEFINE VARIABLE lTranslationEnabled         AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE lIncludeInBrowser           AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE lFieldsFromDataObject       AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE cColumnBGColors             AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cColumnFGColors             AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cColumnLabelBGColors        AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cColumnLabelFGColors        AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cColumnLabelFonts           AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cColumnWidths               AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cColumnFonts                AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cSecuredFields              AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cExcludeFields              AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE iCnt                        AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iWhereInList                AS INTEGER              NO-UNDO.

    DEFINE BUFFER rycso_SDO        FOR ryc_smartObject.

    /** TEMPORARY FIX ** TEMPORARY FIX ** TEMPORARY FIX ** TEMPORARY FIX ** 
     *  For performance reasons, only perform these checks in a DynaWeb environment.
     *  ----------------------------------------------------------------------- **/
    IF SESSION:CLIENT-TYPE NE "WEBSPEED":U THEN RETURN.

    ASSIGN cTranslationEnabled = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                  INPUT "translationEnabled":U,
                                                  INPUT NO).
    ASSIGN lTranslationEnabled = LOGICAL(cTranslationEnabled) NO-ERROR.
    IF lTranslationEnabled EQ ? THEN
        ASSIGN lTranslationEnabled = YES.

    IF NOT VALID-HANDLE(ghQuery1) THEN
        CREATE QUERY ghQuery1.

    /* If the pdInstanceId is passed in then we know that this is the instance of a browser on 
     * a particular window. If not, then this is the master instance of the browser. This should
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
    ASSIGN hObjectBuffer  = DYNAMIC-FUNCTION("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT pdInstanceId).

    ASSIGN cContainerName = hObjectBuffer:BUFFER-FIELD("tContainerObjectName":U):BUFFER-VALUE
           pdInstanceId   = hObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE
           .
    EMPTY TEMP-TABLE ttTranslate.

    /* Get the secured fields for the browse container  */
    IF cContainerName NE "":U AND cContainerName NE ? AND cContainerName <> pcLogicalObjectName THEN
        RUN fieldSecurityGet IN gshSecurityManager (INPUT  ?,
                                                    INPUT  cContainerName,
                                                    INPUT  pcRunAttribute,
                                                    OUTPUT cSecuredFields).

    /* Find the browser class attribute table */
    ASSIGN hBrowserAttributeBuffer = hObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE.
    hBrowserAttributeBuffer:FIND-FIRST(" WHERE ":U + hBrowserAttributeBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(pdInstanceId) ) NO-ERROR.

    ASSIGN hField           = hBrowserAttributeBuffer:BUFFER-FIELD("DisplayedFields":U)
           cDisplayedFields = hField:BUFFER-VALUE
           cFieldSecurity   = "":U
           .
    /* Translations */
    FIND FIRST rycso_SDO WHERE
               rycso_SDO.smartObject_obj = DECIMAL(hObjectBuffer:BUFFER-FIELD("tSdoSmartObjectObj":U):BUFFER-VALUE)
               NO-LOCK NO-ERROR.
    IF AVAILABLE rycso_SDO THEN
    DO:
        RUN startDataObject IN gshRepositoryManager ( INPUT rycso_SDO.object_filename, OUTPUT hSdo ) NO-ERROR.
        IF VALID-HANDLE(hSdo) THEN
            {get RowObject hRowObject hSdo}.        
    END.    /* design SDO available */

    /* If there are no fields in the DisplayedFields attribute, then add them from the SDO */
    IF cDisplayedFields EQ "":U AND VALID-HANDLE(hRowObject) THEN
    DO:
        {get DataColumns cDisplayedFields hSdo}.
        /* Set the attribute in the local TT */
        ASSIGN hField:BUFFER-VALUE   = cDisplayedFields
               lFieldsFromDataObject = YES.
    END.    /* no displayed fields */
    ELSE
        ASSIGN lFieldsFromDataObject = NO.

    /* Keep this handy for use all over the show. */
    ASSIGN iFieldsInBrowser = NUM-ENTRIES(cDisplayedFields).

    /* Get the list of things we want to know about.
     * We also make sure that the number of entires in the string matches the
     * number of fields in the browser's DisplayedFields property.            */
    ASSIGN hField               = hBrowserAttributeBuffer:BUFFER-FIELD("BrowseColumnLabels":U)
           cStoredBrowseLabels  = DYNAMIC-FUNCTION("prepareAttributeString":U IN TARGET-PROCEDURE,
                                                   INPUT iFieldsInBrowser, INPUT hField:BUFFER-VALUE, INPUT "?":U, INPUT CHR(5))
           NO-ERROR.

    ASSIGN hField         = hBrowserAttributeBuffer:BUFFER-FIELD("BrowseColumnBGColors":U)
           cColumnBGColors = DYNAMIC-FUNCTION("prepareAttributeString":U IN TARGET-PROCEDURE,
                                              INPUT iFieldsInBrowser, INPUT hField:BUFFER-VALUE, INPUT "?":U, INPUT CHR(5))
           NO-ERROR.

    ASSIGN hField         = hBrowserAttributeBuffer:BUFFER-FIELD("BrowseColumnFGColors":U)
           cColumnFGColors = DYNAMIC-FUNCTION("prepareAttributeString":U IN TARGET-PROCEDURE,
                                              INPUT iFieldsInBrowser, INPUT hField:BUFFER-VALUE, INPUT "?":U, INPUT CHR(5))
           NO-ERROR.

    ASSIGN hField               = hBrowserAttributeBuffer:BUFFER-FIELD("BrowseColumnLabelBGColors":U)
           cColumnLabelBGColors = DYNAMIC-FUNCTION("prepareAttributeString":U IN TARGET-PROCEDURE,
                                                   INPUT iFieldsInBrowser, INPUT hField:BUFFER-VALUE, INPUT "?":U, INPUT CHR(5))
           NO-ERROR.

    ASSIGN hField               = hBrowserAttributeBuffer:BUFFER-FIELD("BrowseColumnLabelFGColors":U)
           cColumnLabelFGColors = DYNAMIC-FUNCTION("prepareAttributeString":U IN TARGET-PROCEDURE,
                                                   INPUT iFieldsInBrowser, INPUT hField:BUFFER-VALUE, INPUT "?":U, INPUT CHR(5))
           NO-ERROR.

    ASSIGN hField       = hBrowserAttributeBuffer:BUFFER-FIELD("BrowseColumnFonts":U)
           cColumnFonts = DYNAMIC-FUNCTION("prepareAttributeString":U IN TARGET-PROCEDURE,
                                           INPUT iFieldsInBrowser, INPUT hField:BUFFER-VALUE, INPUT "?":U, INPUT CHR(5))
           NO-ERROR.

    ASSIGN hField            = hBrowserAttributeBuffer:BUFFER-FIELD("BrowseColumnLabelFonts":U)
           cColumnLabelFonts = DYNAMIC-FUNCTION("prepareAttributeString":U IN TARGET-PROCEDURE,
                                                INPUT iFieldsInBrowser, INPUT hField:BUFFER-VALUE, INPUT "?":U, INPUT CHR(5))
           NO-ERROR.

    ASSIGN hField       = hBrowserAttributeBuffer:BUFFER-FIELD("BrowseColumnWidths":U)
           cColumnWidths = DYNAMIC-FUNCTION("prepareAttributeString":U IN TARGET-PROCEDURE,
                                            INPUT iFieldsInBrowser, INPUT hField:BUFFER-VALUE, INPUT "?":U, INPUT CHR(5))
           NO-ERROR.
    FIELD-LOOP:
    DO iFieldLoop = 1 TO iFieldsInBrowser:
            ASSIGN cFieldName  = ENTRY(iFieldLoop, cDisplayedFields)
                   iFieldEntry = LOOKUP(cFieldName, cSecuredFields)
                   NO-ERROR.

        /* Set security */
        IF iFieldEntry GT 0 THEN
            ASSIGN cSecurityType = ENTRY(iFieldEntry + 1, cSecuredFields).
        ELSE
            ASSIGN cSecurityType = "":U.

        ASSIGN cFieldSecurity = cFieldSecurity + (IF iFieldLoop > 1 THEN ",":U ELSE "":U) +
                                cSecurityType.

        /* Get the field name as it is in the DB.
         * We do this because the field may be an assigned field. In this case we
         * need to know the name of the underlying field.                         */
        ASSIGN cDbFieldName = DYNAMIC-FUNCTION("columnDbColumn":U IN hSdo, INPUT cFieldName).

        /* Get rid of the [] for array fields. */
        ASSIGN cDBFieldName = REPLACE(cDBFieldName, "[":U, "":U)
               cDBFieldName = REPLACE(cDBFieldName, "]":U, "":U).

        /* Get the DataField Master from the Repository. */
        DYNAMIC-FUNCTION("cacheObjectOnClient":U IN gshRepositoryManager, INPUT cDbFieldName, INPUT ?, INPUT ?, INPUT NO).
        ASSIGN hObjectBuffer = DYNAMIC-FUNCTION("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT ?).

        IF hObjectBuffer:AVAILABLE THEN
        DO:
            ASSIGN hAttributeBuffer = hObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE.
            hAttributeBuffer:FIND-FIRST(" WHERE ":U + hAttributeBuffer:NAME + ".tRecordIdentifier = ":U
                                        + QUOTER(hObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE) ).
        END.    /* available object. */
        ELSE
            ASSIGN hAttributeBuffer = ?.

        /* Decide whether the field should be included or not */
        IF lFieldsFromDataObject AND VALID-HANDLE(hAttributeBuffer) AND hAttributeBuffer:AVAILABLE THEN
        DO:
            /* Include field by default. */
            ASSIGN lIncludeInBrowser = YES.

            ASSIGN hColumn = hAttributeBuffer:BUFFER-FIELD("IncludeInDefaultListView") NO-ERROR.
            IF VALID-HANDLE(hColumn) THEN
                ASSIGN lIncludeInBrowser = hColumn:BUFFER-VALUE.
            IF lIncludeInBrowser EQ ? THEN
            DO:
                ASSIGN hColumn = hAttributeBuffer:BUFFER-FIELD("IncludeInDefaultView") NO-ERROR.
                IF VALID-HANDLE(hColumn) THEN
                    ASSIGN lIncludeInBrowser = hColumn:BUFFER-VALUE.
            END.    /* default value. */

            IF lIncludeInBrowser EQ NO THEN
                ASSIGN cExcludeFields = cExcludeFields + STRING(iFieldLoop) + ",":U.
        END.    /* fields from DataObject */

        /* Use the stored browse label, if any. */
        ASSIGN cListValue = "":U
               cListValue = ENTRY(iFieldLoop, cStoredBrowseLabels, CHR(5))
               NO-ERROR.

        IF CAN-DO("?,":U, cListValue) THEN
        DO:
            IF VALID-HANDLE(hAttributeBuffer) AND hAttributeBuffer:AVAILABLE THEN
            DO:
                /* First try to use the ColumnLabel attribute.
                 * If this has no decent value, then use the Label attribute. */
                ASSIGN hColumn = hAttributeBuffer:BUFFER-FIELD("ColumnLabel") NO-ERROR.
                IF VALID-HANDLE(hColumn) THEN
                    ASSIGN cListValue = hColumn:BUFFER-VALUE.

                IF CAN-DO("?,":U, cListValue) OR cListValue EQ ? THEN
                DO:
                    ASSIGN hColumn = hAttributeBuffer:BUFFER-FIELD("Label") NO-ERROR.
                    IF VALID-HANDLE(hColumn) THEN
                        ASSIGN cListValue = hColumn:BUFFER-VALUE.
                END.    /* bum ColumnLabel value. */
            END.    /* available buffer */
            ELSE
            DO:
                IF VALID-HANDLE(hRowObject) THEN
                    ASSIGN hColumn = hRowObject:BUFFER-FIELD(cFieldName) NO-ERROR.
                IF VALID-HANDLE(hColumn) THEN
                    ASSIGN cListValue = hColumn:COLUMN-LABEL.
            END.    /* not in repository. */
        END.    /* no label override */

        /* If nothing comes from the stored list, or the SDO, then use the field name. */
        IF CAN-DO("?,":U, cListValue) OR cListValue EQ ? THEN
            ASSIGN cListValue = cFieldName.

        CREATE ttTranslate.
        ASSIGN ttTranslate.dLanguageObj       = 0
               ttTranslate.cObjectName        = pcLogicalObjectName
               ttTranslate.lGlobal            = NO
               ttTranslate.lDelete            = NO
               ttTranslate.cWidgetType        = "BROWSE":U
               ttTranslate.cWidgetName        = cFieldName
               ttTranslate.hWidgetHandle      = ?
               ttTranslate.iWidgetEntry       = 0
               ttTranslate.cOriginalLabel     = cListValue
               ttTranslate.cTranslatedLabel   = "":U
               ttTranslate.cOriginalTooltip   = "":U
               ttTranslate.cTranslatedTooltip = "":U.

        /* Assign all that other stuff. */
        IF VALID-HANDLE(hAttributeBuffer) THEN
        DO:
            ASSIGN cColumnBGColors = DYNAMIC-FUNCTION("updateAttributeStringValue":U IN TARGET-PROCEDURE,
                                                      INPUT iFieldLoop, INPUT CHR(5), INPUT "?":U, INPUT cColumnBGColors, INPUT hAttributeBuffer:BUFFER-FIELD("BGCOLOR":U)) NO-ERROR.
        
            ASSIGN cColumnFGColors = DYNAMIC-FUNCTION("updateAttributeStringValue":U IN TARGET-PROCEDURE,
                                                      INPUT iFieldLoop, INPUT CHR(5), INPUT "?":U, INPUT cColumnFGColors, INPUT hAttributeBuffer:BUFFER-FIELD("FGCOLOR":U)) NO-ERROR.
        
            ASSIGN cColumnLabelBGColors = DYNAMIC-FUNCTION("updateAttributeStringValue":U IN TARGET-PROCEDURE,
                                                           INPUT iFieldLoop, INPUT CHR(5), INPUT "?":U, INPUT cColumnLabelBGColors, INPUT hAttributeBuffer:BUFFER-FIELD("LabelBGColor":U)) NO-ERROR.
        
            ASSIGN cColumnLabelFGColors = DYNAMIC-FUNCTION("updateAttributeStringValue":U IN TARGET-PROCEDURE,
                                                           INPUT iFieldLoop, INPUT CHR(5), INPUT "?":U, INPUT cColumnLabelFGColors, INPUT hAttributeBuffer:BUFFER-FIELD("LabelFGColor":U)) NO-ERROR.

            ASSIGN cColumnLabelFonts = DYNAMIC-FUNCTION("updateAttributeStringValue":U IN TARGET-PROCEDURE,
                                                        INPUT iFieldLoop, INPUT CHR(5), INPUT "?":U, INPUT cColumnLabelFonts, INPUT hAttributeBuffer:BUFFER-FIELD("LabelFont":U)) NO-ERROR.
        
            ASSIGN cColumnWidths = DYNAMIC-FUNCTION("updateAttributeStringValue":U IN TARGET-PROCEDURE,
                                                    INPUT iFieldLoop, INPUT CHR(5), INPUT "?":U, INPUT cColumnWidths, INPUT hAttributeBuffer:BUFFER-FIELD("WIDTH-CHARS":U)) NO-ERROR.
        
            ASSIGN cColumnFonts = DYNAMIC-FUNCTION("updateAttributeStringValue":U IN TARGET-PROCEDURE,
                                                   INPUT iFieldLoop, INPUT CHR(5), INPUT "?":U, INPUT cColumnFonts, INPUT hAttributeBuffer:BUFFER-FIELD("FONT":U)) NO-ERROR.
        END.    /* valid attribute buffer */
    END.    /* FIELD-LOOP: loop through fields */
    
    /* We no longer need the SDO to be running */
    IF VALID-HANDLE(hSdo) THEN
        RUN destroyObject IN hSdo NO-ERROR.
    IF VALID-HANDLE(hSdo) THEN
        DELETE OBJECT hSdo.

    DELETE OBJECT hRowObject NO-ERROR.
    ASSIGN hRowObject = ?
           hSdo       = ?.

    /** Remove any fields that should be excluded by virtue of their IncludeIn*View 
     *  values being NO.
     *  ----------------------------------------------------------------------- **/
    IF lFieldsFromDataObject THEN
    DO:    
        ASSIGN cExcludeFields = TRIM(cExcludeFields).
        DO iCnt = 1 TO NUM-ENTRIES(cExcludeFields):
            ASSIGN iFieldLoop = INTEGER(ENTRY(iCnt, cExcludeFields)) NO-ERROR.
            IF ERROR-STATUS:ERROR OR iFieldLoop EQ 0 THEN
                NEXT.

            /* Enpty from list */
            ENTRY(iFieldLoop, cStoredBrowseLabels, CHR(5)) = "":U.
            ENTRY(iFieldLoop, cColumnBGColors, CHR(5)) = "":U.
            ENTRY(iFieldLoop, cColumnFGColors, CHR(5)) = "":U.
            ENTRY(iFieldLoop, cColumnLabelBGColors, CHR(5)) = "":U.
            ENTRY(iFieldLoop, cColumnLabelFGColors, CHR(5)) = "":U.
            ENTRY(iFieldLoop, cColumnFonts, CHR(5)) = "":U.
            ENTRY(iFieldLoop, cColumnLabelFonts, CHR(5)) = "":U.
            ENTRY(iFieldLoop, cColumnWidths, CHR(5)) = "":U.
    
            ENTRY(iFieldLoop, cDisplayedFields) = "":U.
            ENTRY(iFieldLoop, cFieldSecurity) = "":U.
    
            /* Clean up list. */
            IF iFieldLoop EQ 1 THEN
                ASSIGN cStoredBrowseLabels  = LEFT-TRIM(cStoredBrowseLabels , CHR(5))
                       cColumnBGColors      = LEFT-TRIM(cColumnBGColors     , CHR(5))
                       cColumnFGColors      = LEFT-TRIM(cColumnFGColors     , CHR(5))
                       cColumnLabelBGColors = LEFT-TRIM(cColumnLabelBGColors, CHR(5))
                       cColumnLabelFGColors = LEFT-TRIM(cColumnLabelFGColors, CHR(5))
                       cColumnFonts         = LEFT-TRIM(cColumnFonts        , CHR(5))
                       cColumnLabelFonts    = LEFT-TRIM(cColumnLabelFonts   , CHR(5))
                       cColumnWidths        = LEFT-TRIM(cColumnWidths       , CHR(5))
                       cDisplayedFields     = LEFT-TRIM(cDisplayedFields, ",":U)
                       cFieldSecurity       = SUBSTRING(cFieldSecurity, 2).
            ELSE
                ASSIGN cStoredBrowseLabels  = REPLACE(cStoredBrowseLabels , CHR(5) + CHR(5), CHR(5))
                       cColumnBGColors      = REPLACE(cColumnBGColors     , CHR(5) + CHR(5), CHR(5))
                       cColumnFGColors      = REPLACE(cColumnFGColors     , CHR(5) + CHR(5), CHR(5))
                       cColumnLabelBGColors = REPLACE(cColumnLabelBGColors, CHR(5) + CHR(5), CHR(5))
                       cColumnLabelFGColors = REPLACE(cColumnLabelFGColors, CHR(5) + CHR(5), CHR(5))
                       cColumnFonts         = REPLACE(cColumnFonts        , CHR(5) + CHR(5), CHR(5))
                       cColumnLabelFonts    = REPLACE(cColumnLabelFonts   , CHR(5) + CHR(5), CHR(5))
                       cColumnWidths        = REPLACE(cColumnWidths       , CHR(5) + CHR(5), CHR(5))
                       cDisplayedFields     = REPLACE(cDisplayedFields, ",,":U, ",":U)
                       cFieldSecurity       = REPLACE(cFieldSecurity, ",,":U, ",":U).
        END.    /* loop through exclude fields. */
    END.    /* fields from data object */

    ASSIGN hField = hBrowserAttributeBuffer:BUFFER-FIELD("FieldSecurity":U) NO-ERROR.
    IF VALID-HANDLE(hField) THEN
        ASSIGN hField:BUFFER-VALUE = cFieldSecurity.

    ASSIGN hField = hBrowserAttributeBuffer:BUFFER-FIELD("securedTokens":U) NO-ERROR.
    IF VALID-HANDLE(hField) THEN
        ASSIGN hField:BUFFER-VALUE = "":U. /* Token security is not extracted for browsers */

    /* Only get the translation is translation is enabled. */
    IF lTranslationEnabled EQ YES THEN
        /* Get the translated strings. */
        RUN multiTranslation IN gshTranslationManager ( INPUT NO, INPUT-OUTPUT TABLE ttTranslate).

    /* Set the releavant attribute (BrowseColumnLabels)
     * There will always be a ttTranslate record for each column. */
    FOR EACH ttTranslate:
        ASSIGN iFieldEntry = LOOKUP(ttTranslate.cWidgetName, cDisplayedFields).
        IF iFieldEntry GT 0 THEN
        DO:
            IF ttTranslate.cOriginalLabel   NE ttTranslate.cTranslatedLabel AND
               ttTranslate.cTranslatedLabel NE "":U                         AND
               ttTranslate.cTranslatedLabel NE ?                            AND
               ttTranslate.cTranslatedLabel NE "?":U                        THEN
                ENTRY(iFieldEntry, cStoredBrowseLabels, CHR(5)) = ttTranslate.cTranslatedLabel.
            ELSE
                ENTRY(iFieldEntry, cStoredBrowseLabels, CHR(5)) = ttTranslate.cOriginalLabel.
        END.    /* field in list */
    END.    /* each translation */

    ASSIGN hBrowserAttributeBuffer:BUFFER-FIELD("BrowseColumnLabels":U):BUFFER-VALUE        = cStoredBrowseLabels
           hBrowserAttributeBuffer:BUFFER-FIELD("BrowseColumnBGColors":U):BUFFER-VALUE      = cColumnBGColors
           hBrowserAttributeBuffer:BUFFER-FIELD("BrowseColumnFGColors":U):BUFFER-VALUE      = cColumnFGColors
           hBrowserAttributeBuffer:BUFFER-FIELD("BrowseColumnLabelBGColors":U):BUFFER-VALUE = cColumnLabelBGColors
           hBrowserAttributeBuffer:BUFFER-FIELD("BrowseColumnLabelFGColors":U):BUFFER-VALUE = cColumnLabelFGColors
           hBrowserAttributeBuffer:BUFFER-FIELD("BrowseColumnFonts":U):BUFFER-VALUE         = cColumnFonts
           hBrowserAttributeBuffer:BUFFER-FIELD("BrowseColumnLabelFonts":U):BUFFER-VALUE    = cColumnLabelFonts
           hBrowserAttributeBuffer:BUFFER-FIELD("BrowseColumnWidths":U):BUFFER-VALUE        = cColumnWidths
           hBrowserAttributeBuffer:BUFFER-FIELD("DisplayedFields":U):BUFFER-VALUE           = cDisplayedFields
           NO-ERROR.

    /** Set the ObjectSecured and ObjectTranslated properties to yes. If we get
     *  then we muts have performed those actions - regardless of whether the
     *  security or translation are enabled, we have performed the checks, and
     *  they don't need to happen again.
     *  ----------------------------------------------------------------------- **/
    ASSIGN hBrowserAttributeBuffer:BUFFER-FIELD("ObjectTranslated":U):BUFFER-VALUE = YES
           hBrowserAttributeBuffer:BUFFER-FIELD("ObjectSecured":U):BUFFER-VALUE    = YES.

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.   
END PROCEDURE.  /* validateClassData */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-prepareAttributeString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION prepareAttributeString Procedure 
FUNCTION prepareAttributeString RETURNS CHARACTER
    ( INPUT piFieldsInBrowser       AS INTEGER,
      INPUT pcAttributeString       AS CHARACTER,
      INPUT pcDefaultFiller         AS CHARACTER,
      INPUT pcDelimiter             AS CHARACTER    ) :
/*------------------------------------------------------------------------------
  Purpose:  Ensures that there are the correct number of entries in the string.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iCurrentEntries             AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iLoop                       AS INTEGER              NO-UNDO.
    DEFINE VARIABLE cAttributeString            AS CHARACTER            NO-UNDO.

    IF pcAttributeString EQ ? THEN
        ASSIGN pcAttributeString = "":U.

    IF pcDelimiter EQ "":U OR pcDelimiter EQ ? THEN
        ASSIGN pcDelimiter = ",":U.

    ASSIGN pcAttributeString = RIGHT-TRIM(pcAttributeString, pcDelimiter)
           iCurrentEntries   = NUM-ENTRIES(pcAttributeString, pcDelimiter).

    IF iCurrentEntries GT piFieldsInBrowser THEN
    DO iLoop = piFieldsInBrowser + 1 TO iCurrentEntries:
        ENTRY(iLoop, pcAttributeString, pcDelimiter) = "":U.
    END.    /* more attributes in string */
    ELSE
    IF iCurrentEntries LT piFieldsInBrowser THEN
    DO:
        /* Easy case first */
        IF iCurrentEntries EQ 0 THEN
            ASSIGN pcAttributeString = FILL(pcDefaultFiller + pcDelimiter, piFieldsInBrowser).
        ELSE
        DO iLoop = iCurrentEntries + 1 TO piFieldsInBrowser:
            ASSIGN pcAttributeString = pcAttributeString + pcDelimiter + pcDefaultFiller.
        END.    /* there are some entries in the string. */        
    END.    /* fewer attributes in string. */

    /* Clean up string and return */
    RETURN RIGHT-TRIM(pcAttributeString, pcDelimiter).
END FUNCTION.   /* prepareAttributeString */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateAttributeStringValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION updateAttributeStringValue Procedure 
FUNCTION updateAttributeStringValue RETURNS CHARACTER
    ( INPUT piListEntry         AS INTEGER,
      INPUT pcDelimiter         AS CHARACTER,
      INPUT pcDefaultFiller     AS CHARACTER,
      INPUT pcAttributeString   AS CHARACTER,
      INPUT phBufferField       AS HANDLE           ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the relevant entry to the values as per the attribute buffer.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cListValue              AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cBufferValue            AS CHARACTER                NO-UNDO.

    ASSIGN cListValue = ENTRY(piListEntry, pcAttributeString, pcDelimiter).
    IF CAN-DO(pcDefaultFiller + ",":U, cListValue) THEN
    DO:
        ASSIGN cBufferValue = STRING(phBufferField:BUFFER-VALUE) NO-ERROR.
        IF cBufferValue EQ ? THEN
            ASSIGN cBufferValue = pcDefaultFiller.

        ENTRY(piListEntry, pcAttributeString, pcDelimiter) =  cBufferValue NO-ERROR.
    END.    /* not a blank or filler value. */

    RETURN pcAttributeString.
END FUNCTION.   /* updateAttributeStringValue */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

