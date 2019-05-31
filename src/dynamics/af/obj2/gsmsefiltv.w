&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" vTableWin _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" vTableWin _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE RowObject
       {"ry/obj/ryemptysdo.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*---------------------------------------------------------------------------------
  File: gscotfiltv.w

  Description:  Object Type Filter Viewer

  Purpose:      Object Type Filter Viewer to be used with TreeView style Object Type Maintenance.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    MIP
                Date:   08/12/2002  Author:     Mark Davies

  Update Notes: Created from Template rysttviewv.w

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       gsmsefiltv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{src/adm2/globals.i}

/* Dynamic Combo temp-table */
{src/adm2/ttdcombo.i}
/* Dynamic Lookup temp-table */
{src/adm2/ttlookup.i}

DEFINE VARIABLE ghContainerSource AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghTreeViewOCX     AS HANDLE     NO-UNDO.

DEFINE TEMP-TABLE ttSessionType
  FIELD dSessionTypeObj         AS DECIMAL
  FIELD cSessionTypeCode        AS CHARACTER
  FIELD dExtendsSessionTypeObj  AS DECIMAL
  INDEX idxSessionType
        dSessionTypeObj.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "ry/obj/ryemptysdo.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS buFind 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSessionTypeNodekey vTableWin 
FUNCTION getSessionTypeNodekey RETURNS CHARACTER
  (pcClassCode AS CHARACTER,
   pcParentNodeKey AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSessionTypeParents vTableWin 
FUNCTION getSessionTypeParents RETURNS CHARACTER
  (pcSessionTypeCode AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD refreshTree vTableWin 
FUNCTION refreshTree RETURNS LOGICAL
  (pcReposToSessionType AS CHARACTER,
   plSessionTypeNode    AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE hSessionType AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buFind 
     LABEL "F&ind" 
     SIZE 15 BY 1
     BGCOLOR 8 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     buFind AT ROW 1.33 COL 72.6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "ry/obj/ryemptysdo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {ry/obj/ryemptysdo.i}
      END-FIELDS.
   END-TABLES.
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW vTableWin ASSIGN
         HEIGHT             = 1.33
         WIDTH              = 86.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB vTableWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW vTableWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME buFind
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buFind vTableWin
ON CHOOSE OF buFind IN FRAME frMain /* Find */
DO:
  RUN findSessionType.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK vTableWin 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects vTableWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE currentPage  AS INTEGER NO-UNDO.

  ASSIGN currentPage = getCurrentPage().

  CASE currentPage: 

    WHEN 0 THEN DO:
       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsm_session_type.session_type_codeKeyFieldgsm_session_type.session_type_codeFieldLabelSession type codeFieldTooltipPress F4 for LookupKeyFormatX(20)KeyDatatypecharacterDisplayFormatX(20)DisplayDatatypecharacterBaseQueryStringFOR EACH gsm_session_type NO-LOCK,
                     FIRST bgsm_session_type WHERE bgsm_session_type.session_type_obj = gsm_session_type.extends_session_type_obj NO-LOCK OUTER-JOIN
                     BY gsm_session_type.session_type_code INDEXED-REPOSITIONQueryTablesgsm_session_type,bgsm_session_typeBrowseFieldsgsm_session_type.session_type_code,gsm_session_type.session_type_description,bgsm_session_type.session_type_code,bgsm_session_type.session_type_descriptionBrowseFieldDataTypescharacter,character,character,characterBrowseFieldFormatsX(20)|X(35)|X(20)|X(35)RowsToBatch200BrowseTitleSession Type LookupViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabels,,Extends session type (code),Extends session type (Description)ColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNames,ICFDB.gsm_session_typeTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesFieldName<Local>DisplayFieldyesEnableFieldyesLocalFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hSessionType ).
       RUN repositionObject IN hSessionType ( 1.33 , 21.80 ) NO-ERROR.
       RUN resizeObject IN hSessionType ( 1.00 , 50.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( hSessionType ,
             buFind:HANDLE IN FRAME frMain , 'BEFORE':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI vTableWin  _DEFAULT-DISABLE
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
  HIDE FRAME frMain.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findSessionType vTableWin 
PROCEDURE findSessionType :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will walk through the dynamic temp-table build
               for the TreeView and expand nodes to find a specific object type
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFindSessionType  AS CHARACTER  NO-UNDO.

  {get DataValue cFindSessionType hSessionType}.

  RUN repositionToSessionType (INPUT cFindSessionType).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject vTableWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hLookup AS HANDLE     NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  {get LookupHandle    hLookup hSessionType}.

  IF VALID-HANDLE(hLookup) THEN
    ON RETURN OF hLookup PERSISTENT RUN returnOnLookup IN TARGET-PROCEDURE.

  IF NOT VALID-HANDLE(ghContainerSource) THEN
    {get ContainerSource ghContainerSource}.

  IF NOT VALID-HANDLE(ghTreeViewOCX)     AND
         VALID-HANDLE(ghContainerSource) THEN
    ghTreeViewOCX = DYNAMIC-FUNCTION("getTreeViewOCX":U IN ghContainerSource).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionToSessionType vTableWin 
PROCEDURE repositionToSessionType :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcSessionType  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cSessionTypeNodeKey AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentSessionType  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessageList        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop               AS INTEGER    NO-UNDO.
  
  cParentSessionType = getSessionTypeParents(pcSessionType).

  IF pcSessionType      = "":U OR
     cParentSessionType = ?    THEN
  DO:
    cMessageList = {aferrortxt.i 'AF' '1' '' '' "'Session type'"}.

    RUN showMessages IN gshSessionManager (INPUT  cMessageList,     /* message to display */
                                           INPUT  "ERR":U,          /* error type */
                                           INPUT  "&OK":U,          /* button list */
                                           INPUT  "&OK":U,          /* default button */ 
                                           INPUT  "&OK":U,          /* cancel button */
                                           INPUT  "Error":U,        /* error window title */
                                           INPUT  YES,              /* display if empty */ 
                                           INPUT  ?,                /* container handle */ 
                                           OUTPUT cButton).         /* button pressed */

    RETURN.
  END.

  /* First see if we can find the SessionType in the list, it might be expanded already */
  cSessionTypeNodeKey = getSessionTypeNodeKey(pcSessionType, ?).

  IF cSessionTypeNodeKey <> "":U THEN
  DO:
    {fnarg lockWindow TRUE ghContainerSource}.

    RUN tvNodeSelected IN ghContainerSource (INPUT cSessionTypeNodeKey).

    DYNAMIC-FUNCTION("selectNode" IN ghTreeViewOCX, cSessionTypeNodeKey).

    {fnarg lockWindow FALSE ghContainerSource}.

    RETURN.
  END.

  /* Ensure the Root node is expanded */
  ASSIGN
      cSessionTypeNodeKey = {fnarg getProperty "'Text':U, '':U" ghTreeViewOCX}
      cSessionTypeNodeKey = getSessionTypeNodeKey(cSessionTypeNodeKey, ?).

  IF cSessionTypeNodeKey <> "":U THEN
  DO:
    {fnarg lockWindow TRUE ghContainerSource}.

    {fnarg expandNode "cSessionTypeNodeKey, TRUE" ghTreeViewOCX}.

    {fnarg lockWindow FALSE ghContainerSource}.
  END.
  
  /* If we couldn't find it at first, then expand until it exists in the tree */
  {fnarg lockWindow TRUE ghContainerSource}.

  DO iLoop = NUM-ENTRIES(cParentSessionType) TO 1 BY -1:
    cSessionTypeNodeKey = getSessionTypeNodeKey(ENTRY(iLoop, cParentSessionType), ?).

    {fnarg expandNode "cSessionTypeNodeKey, TRUE" ghTreeViewOCX}.
  END.

  DYNAMIC-FUNCTION("setLastLaunchedNode":U IN ghContainerSource, INPUT "":U).

  RUN tvNodeSelected IN ghContainerSource (INPUT cSessionTypeNodeKey).

  DYNAMIC-FUNCTION("selectNode" IN ghTreeViewOCX, cSessionTypeNodeKey).

  {fnarg lockWindow FALSE ghContainerSource}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnOnLookup vTableWin 
PROCEDURE returnOnLookup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN leaveLookup IN hSessionType.
  APPLY "CHOOSE":U TO buFind IN FRAME {&FRAME-NAME}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewObject vTableWin 
PROCEDURE viewObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainer AS HANDLE     NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  SESSION:SET-WAIT-STATE("general":U).
  PUBLISH "filterDataAvailable" FROM THIS-PROCEDURE (INPUT "":U).
  SESSION:SET-WAIT-STATE("":U).
  RUN displayFields (INPUT "?":U).
  RUN enableField IN hSessionType.

  {get ContainerSource hContainer}.
  IF VALID-HANDLE(hContainer) THEN
    RUN destroyNonTreeObjects IN hContainer.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSessionTypeNodekey vTableWin 
FUNCTION getSessionTypeNodekey RETURNS CHARACTER
  (pcClassCode AS CHARACTER,
   pcParentNodeKey AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainer     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuf           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable         AS HANDLE     NO-UNDO.
  
  {get ContainerSource hContainer}.
  
  IF VALID-HANDLE(hContainer) THEN DO:
    hTreeViewOCX = DYNAMIC-FUNCTION("getTreeViewOCX":U IN hContainer).

    IF VALID-HANDLE(hTreeViewOCX) THEN
      {get TreeDataTable hTable hTreeViewOCX}.  
    IF NOT VALID-HANDLE(hTable) THEN
      RETURN "":U.
    
    ASSIGN hBuf = hTable:DEFAULT-BUFFER-HANDLE.

    hBuf:FIND-FIRST("WHERE ":U + (IF pcParentNodeKey <> ? THEN "parent_node_key = '":U + pcParentNodeKey + "' AND ":U ELSE "":U)
                               + " node_label = '" + pcClassCode + "'":U) NO-ERROR.
    IF hBuf:AVAILABLE THEN
      RETURN hBuf:BUFFER-FIELD("node_key":U):BUFFER-VALUE.
  END.

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSessionTypeParents vTableWin 
FUNCTION getSessionTypeParents RETURNS CHARACTER
  (pcSessionTypeCode AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSessionTypeParents AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dSessionTypeObj     AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iCounter            AS INTEGER    NO-UNDO.

  EMPTY TEMP-TABLE ttDCombo.
  EMPTY TEMP-TABLE ttSessionType.

  CREATE ttDCombo.

  ASSIGN
      ttDCombo.hWidget             = TARGET-PROCEDURE
      ttDCombo.hViewer             = TARGET-PROCEDURE
      ttDCombo.cWidgetName         = "Temporary":U
      ttDCombo.cWidgetType         = "DECIMAL":U
      ttDCombo.cForEach            = "FOR EACH gsm_session_type NO-LOCK INDEXED-REPOSITION":U
      ttDCombo.cBufferList         = "gsm_session_type":U
      ttDCombo.cKeyFieldName       = "gsm_session_type.session_type_obj":U
      ttDCombo.cKeyFormat          = "->>>>>>>>>>>>>>>>>>>>>>>>>>9.999999999999":U
      ttDCombo.cDescFieldNames     = "gsm_session_type.session_type_code,gsm_session_type.extends_session_type_obj":U
      ttDCombo.cDescSubstitute     = "&1":U + CHR(10) + "&2":U
      ttDCombo.cFlag               = "":U
      ttDCombo.cListItemDelimiter  = CHR(3)
      ttDCombo.cCurrentKeyValue    = "":U
      ttDCombo.cFlagValue          = "":U
      ttDCombo.cParentField        = "":U
      ttDCombo.cParentFilterQuery  = "":U
      ttDCombo.iBuildSequence      = 0
      ttDCombo.cPhysicalTableNames = "":U
      ttDCombo.cTempTableNames     = "":U.

  RUN adm2/lookupqp.p ON gshAstraAppserver (INPUT-OUTPUT TABLE ttLookup,
                                            INPUT-OUTPUT TABLE ttDCombo,
                                            INPUT              "":U,
                                            INPUT              "":U,
                                            INPUT              TARGET-PROCEDURE).

  FIND FIRST ttDCombo
       WHERE ttDCombo.cWidgetName = "Temporary":U
         AND ttDCombo.hWidget     = TARGET-PROCEDURE
         AND ttDCombo.hViewer     = TARGET-PROCEDURE NO-ERROR.

  IF AVAILABLE ttDCombo THEN
  DO:
    ttDCombo.cListItemPairs = REPLACE(ttDCombo.cListItemPairs, CHR(10), CHR(3)).

    /* In case an invalid value was passed in, we have nothing to find... */
    IF NUM-ENTRIES(ttDCombo.cListItemPairs, CHR(3)) < 3 THEN
      RETURN "":U.  /* Function return value. */

    DO iCounter = 1 TO NUM-ENTRIES(ttDCombo.cListItemPairs, CHR(3)) BY 3:
      CREATE ttSessionType.

      ASSIGN
          ttSessionType.dSessionTypeObj        = DECIMAL(ENTRY(iCounter + 2, ttDCombo.cListItemPairs, CHR(3)))
          ttSessionType.dExtendsSessionTypeObj = DECIMAL(ENTRY(iCounter + 1, ttDCombo.cListItemPairs, CHR(3)))
          ttSessionType.cSessionTypeCode       =         ENTRY(iCounter,     ttDCombo.cListItemPairs, CHR(3)).
    END.
  
    FIND FIRST ttSessionType
         WHERE ttSessionType.cSessionTypeCode = pcSessionTypeCode NO-ERROR.

    IF AVAILABLE ttSessionType THEN
    DO:
      dSessionTypeObj = ttSessionType.dSessionTypeObj.

      DO WHILE dSessionTypeObj <> 0.00 AND
               dSessionTypeObj <> ?:

        FIND FIRST ttSessionType
             WHERE ttSessionType.dSessionTypeObj = dSessionTypeObj.

        ASSIGN
            cSessionTypeParents = cSessionTypeParents
                                + (IF cSessionTypeParents = "":U THEN "":U ELSE ",":U)
                                + ttSessionType.cSessionTypeCode
            dSessionTypeObj     = ttSessionType.dExtendsSessionTypeObj.  
      END.
    END.
    ELSE
      cSessionTypeParents = ?.
  END.

  RETURN cSessionTypeParents.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION refreshTree vTableWin 
FUNCTION refreshTree RETURNS LOGICAL
  (pcReposToSessionType AS CHARACTER,
   plSessionTypeNode    AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cNodeKey  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabels   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lSuccess  AS LOGICAL    NO-UNDO.

  IF plSessionTypeNode THEN
  DO:
    {fnarg lockWindow TRUE ghContainerSource}.

    PUBLISH "filterDataAvailable":U FROM THIS-PROCEDURE ("":U).

    RUN repositionToSessionType (INPUT pcReposToSessionType).

    {fnarg lockWindow FALSE ghContainerSource}.
  END.
  ELSE
  DO:
    {fnarg lockWindow TRUE ghContainerSource}.

    ASSIGN
        cNodeKey = DYNAMIC-FUNCTION("getProperty":U IN ghTreeViewOCX, "SELECTEDITEM":U, "":U)
        cLabels  = {fnarg getProperty "'Text':U,   cNodeKey" ghTreeViewOCX}
        cNodeKey = {fnarg getProperty "'Parent':U, cNodeKey" ghTreeViewOCX}
        cLabels  = cLabels + ",":U
                 + {fnarg getProperty "'Text':U,   cNodeKey" ghTreeViewOCX}.

    PUBLISH "filterDataAvailable":U FROM THIS-PROCEDURE ("":U).

    RUN repositionToSessionType (INPUT pcReposToSessionType).
    
    ASSIGN
        cNodeKey = getSessionTypeNodeKey(ENTRY(2, cLabels), DYNAMIC-FUNCTION("getProperty":U IN ghTreeViewOCX, "SELECTEDITEM":U, "":U))
        lSuccess = {fnarg expandNode "cNodeKey, TRUE" ghTreeViewOCX}
        cNodeKey = getSessionTypeNodeKey(ENTRY(1, cLabels), cNodeKey)
        lSuccess = {fnarg selectNode cNodeKey ghTreeViewOCX}.

    RUN tvNodeSelected IN ghContainerSource (INPUT cNodeKey).

    {fnarg lockWindow FALSE ghContainerSource}.
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

