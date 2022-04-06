&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
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
       {"af/obj2/gsmtlfullo.i"}.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: rydyntranv.w

  Description:  Translation Viewer

  Purpose:      Translation Viewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        7405   UserRef:    
                Date:   27/12/2000  Author:     Anthony Swindells

  Update Notes: Astra 2 translations

  (v:010001)    Task:           0   UserRef:    
                Date:   11/19/2001  Author:     Mark Davies (MIP)

  Update Notes: Changed Combo delimiter to CHR(3) - avoid -E parameter errors.

  (v:010002)    Task:           0   UserRef:    
                Date:   01/23/2002  Author:     Mark Davies (MIP)

  Update Notes: Fixed issue #3704 - Can't translate text treeview items.
                Allow translation of plain text nodes.

  (v:010003)    Task:           0   UserRef:    
                Date:   05/07/2002  Author:     Mark Davies (MIP)

  Update Notes: Added source_language_obj field to store the source language of a translation.

  (v:010004)    Task:           0   UserRef:    
                Date:   08/12/2002  Author:     Mark Davies (MIP)

  Update Notes: Fix for issue #5348 - Toolbar Button Translations

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

&scop object-name       rydyntranv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes
{af/sup2/afglobals.i}

DEFINE VARIABLE glModified                  AS LOGICAL INITIAL NO.
DEFINE VARIABLE ghCallerHandle              AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghContainerHandle           AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghWindow                    AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghCallerWindow              AS HANDLE     NO-UNDO.
DEFINE VARIABLE gcSavedLanguage             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ghObjectField               AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghGlobalField               AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghTypeField                 AS HANDLE     NO-UNDO.

DEFINE VARIABLE ghBrowse                    AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghQuery                     AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghTable                     AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghBuffer                    AS HANDLE     NO-UNDO.

{src/adm2/tttranslate.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "af/obj2/gsmtlfullo.i"

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS buDoNotRemove 
&Scoped-Define DISPLAYED-OBJECTS fiContainer 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE hLanguage AS HANDLE NO-UNDO.
DEFINE VARIABLE hSourceLanguage AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buDoNotRemove 
     LABEL "" 
     SIZE .8 BY .14
     BGCOLOR 8 .

DEFINE VARIABLE fiContainer AS CHARACTER FORMAT "X(256)":U 
     LABEL "Container" 
     VIEW-AS FILL-IN 
     SIZE 50 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     fiContainer AT ROW 1 COL 10.6 COLON-ALIGNED
     buDoNotRemove AT ROW 9.62 COL 132.8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1
         SIZE 133.8 BY 8.76.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "af/obj2/gsmtlfullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {af/obj2/gsmtlfullo.i}
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
         HEIGHT             = 8.76
         WIDTH              = 133.8.
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
   NOT-VISIBLE FRAME-NAME                                               */
ASSIGN 
       FRAME frMain:HIDDEN           = TRUE.

ASSIGN 
       buDoNotRemove:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN fiContainer IN FRAME frMain
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK vTableWin 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addContainer vTableWin 
PROCEDURE addContainer :
/*------------------------------------------------------------------------------
  Purpose:     Get translations for a container window.
  Parameters:  phContainer - the object handle of the container to translate
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter phContainer                  as handle no-undo.
    
    define variable cObjectList                        as character no-undo.
    define variable iLoop                              as integer no-undo.
    define variable hObject                            as handle no-undo.
    define variable cObjectName                        as character no-undo.
    define variable hFrame                             as handle no-undo.
    define variable cObjectType                        as character no-undo.
    define variable cWindowTitle                       as character no-undo.
    define variable cContainerName                     as character no-undo.
    
    /* Add entry for container window title */
    {get LogicalObjectName cContainerName phContainer} no-error.
    if cContainerName eq ? or cContainerName eq '':u then
        assign cContainerName = phContainer:file-name
               cContainerName = lc(trim(replace(cContainerName, '~\':u, '/':u)))
               cContainerName = substring(cContainerName, r-index(cContainerName ,'/':u) + 1).
               
    {get WindowName cWindowTitle phContainer} no-error.
    if cWindowTitle eq ? then
    do:
        {get ContainerHandle hFrame phContainer} no-error.
        if hFrame:type eq 'Window':u then
            cWindowTitle = hFrame:title.
    end.    /* no attribute */
    
    /* Only attempt a translation if there's a title available */
    if cWindowTitle ne ? then
    do:
        CREATE ttTranslate.
        ASSIGN ttTranslate.dLanguageObj        = DECIMAL(DYNAMIC-FUNCTION("getDataValue":U IN hLanguage))
               ttTranslate.cObjectName         = cContainerName 
               ttTranslate.lGlobal             = NO
               ttTranslate.lDelete             = NO
               ttTranslate.cWidgetType         = "TITLE":U
               ttTranslate.cWidgetName         = "TITLE":U
               ttTranslate.hWidgetHandle       = phContainer
               ttTranslate.iWidgetEntry        = 0
               ttTranslate.cOriginalLabel      = cWindowTitle
               ttTranslate.cTranslatedLabel    = "":U  
               ttTranslate.cOriginalTooltip    = "":U  
               ttTranslate.cTranslatedTooltip  = "":U.
        ttTranslate.dSourceLanguageObj = DECIMAL(DYNAMIC-FUNCTION("getDataValue":U IN hSourceLanguage)).
    end.    /* window title not ? */
    
    /* Now go through all calling container, container targets and get all
       widgets in these for translation - watch out for browsers and SDF's.
       Always use container object name for translations. */
    cObjectList = DYNAMIC-FUNCTION('linkHandles' IN phContainer, 'Container-Target':U).
    
    /* Add the container to the list of objects so its widgets can also be translated. */
    cObjectList = cObjectList + (IF cObjectList = "":U THEN "":U ELSE ",":U) + STRING(phContainer).
    
    object-loop:
    DO iLoop = 1 TO NUM-ENTRIES(cObjectList):
        ASSIGN hObject = ?
               hObject = WIDGET-HANDLE(ENTRY(iLoop, cObjectList))
               NO-ERROR. 
        IF NOT VALID-HANDLE(hObject) THEN NEXT object-loop.
        
        /* Get the object name */
        {get LogicalObjectName cObjectName hObject} no-error.
        IF cObjectName = "":U OR cObjectName = ? THEN
            ASSIGN cObjectName = hObject:FILE-NAME
                   /* strip off path if any */
                   cObjectName = LC(TRIM(REPLACE(cObjectName,"~\":U,"/":U)))
                   cObjectName = SUBSTRING(cObjectName,R-INDEX(cObjectName,"/":U) + 1).
        
        /* Ignore SDO's, SBOs and windows launched from container window */
        cObjectType = "":U.
        {get ObjectType cObjectType hObject} no-error.
        IF cObjectType = "":U THEN
            NEXT object-loop.
        
        /* Certain contained object types have their own handling. */
        if hObject ne phContainer then
        do:
            if index(cObjectType, 'Window':u) ne 0 then
                next OBJECT-LOOP.
            
            /* Dataobjects have translatable elements too */
            if index(cObjectType, 'SmartDataObject':u) ne 0 or
               index(cObjectType, 'SmartBusinessObject':u) ne 0 then
            do:
                run addEntity in target-procedure (hObject).
                next OBJECT-LOOP.
            end.    /* SDO/SBO */
        end.    /* current object not the container. */
        
        /* Be careful with SmartFrames. They should be dealt with as
           containers, but don't process the current frame more than once.
           Frame widgets will have been processed when this SmartFrame was 
           a ContainerTarget, so don't do it now. */
        if cObjectType eq 'SmartFrame':u then
        do:
            if hObject ne phContainer then
                run addContainer in target-procedure ( hObject ).
            
            next OBJECT-LOOP.
        end.    /* smartframes */
        
        /* have a valid object - walk widget tree for object to get objects widgets
           for translation */
        hFrame = ?.
        hFrame = DYNAMIC-FUNCTION("getContainerHandle":U IN hObject).
        IF hFrame:TYPE = "window":U THEN
            hFrame = hFrame:FIRST-CHILD.
        
        /* Tab folder object */
        IF hFrame:NAME = "FolderFrame":U THEN
            RUN addFolderTabs (INPUT hObject, INPUT cContainerName , INPUT hFrame).
        ELSE
        /* Viewer/browser/SDF/other visual object */
            RUN addWidgets (INPUT hObject, INPUT cObjectName, INPUT hFrame). 
    END. /* object-loop */
    
    error-status:error = no.
    return.
END PROCEDURE.    /* addContainer */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addEntity vTableWin 
PROCEDURE addEntity :
/*------------------------------------------------------------------------------
  Purpose:     Translates Entity objects in an SDO
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter phObject            as handle no-undo.
    
    /* not implmented yet */
    return.
    /***    not implmented yet
    define variable cSchemaLocation                as character no-undo.
    define variable lUseBuffer                     as logical no-undo.
    define variable lUseDLP                        as logical no-undo.
    define variable lUseEntity                     as logical no-undo.
    define variable iLoop                          as integer no-undo.
    define variable cDataColumns                   as character no-undo.
    
    {get SchemaLocation cSchemaLocation phObject}.
    ASSIGN /* deal with all variations here */
          lUseBuffer = (cSchemaLocation = 'BUF':U)
          lUseDLP    = (NOT (lUseBuffer = TRUE)) OR (cSchemaLocation = 'DLP':U)         
          /* use entity in any case including unknown and blank, except DLP and 'BUF'  */
          lUseEntity = NOT (lUseDLP = TRUE) AND NOT (lUseBuffer = TRUE).
    IF lUseEntity THEN
    do:
        /* Get DB column */
        /* Check whether it's an Entity at all. */
        /* Add to translate table */
        
        /*
                    MESSAGE 
                    'entity translation for SDO' dynamic-function('getlogicalobjectname' in phobject) 
                         VIEW-AS ALERT-BOX.
                */
    end.    /*SDO uses entity */
    
    /* Needs doing. here as a place-holder */
    error-status:error = no.
    return.
    **/
    
END PROCEDURE.    /* addEntity */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addFolderTabs vTableWin 
PROCEDURE addFolderTabs :
/*------------------------------------------------------------------------------
  Purpose:     Add folder tabs to translation temp-table
  Parameters:  input object procedure handle
               input object name
               input object frame handle
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phObject                 AS HANDLE     NO-UNDO.
DEFINE INPUT PARAMETER pcObjectName             AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER phFrame                  AS HANDLE     NO-UNDO.

DEFINE VARIABLE cTabVisualization               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFolderLabels                   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLabel                          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop                           AS INTEGER    NO-UNDO.
DEFINE VARIABLE hDisplayWidget                  AS HANDLE     NO-UNDO.
define variable dLanguageObj                    as decimal no-undo.
define variable dSourceLanguageObj              as decimal no-undo.

dLanguageObj = DECIMAL(DYNAMIC-FUNCTION("getDataValue":U IN hLanguage)).
dSourceLanguageObj = DECIMAL(DYNAMIC-FUNCTION("getDataValue":U IN hSourceLanguage)).

ASSIGN cFolderLabels = DYNAMIC-FUNCTION("getFolderLabels":U IN phObject).

label-loop:
DO iLoop = 1 TO NUM-ENTRIES(cFolderLabels, "|":U):

  ASSIGN cLabel = ENTRY(iLoop, cFolderLabels, "|":U).

  CREATE ttTranslate.
  ASSIGN
    ttTranslate.dLanguageObj       = dLanguageObj
    ttTranslate.cObjectName        = pcObjectName
    ttTranslate.lGlobal            = NO
    ttTranslate.lDelete            = NO
    ttTranslate.cWidgetType        = "TAB":U
    ttTranslate.cWidgetName        = "TAB":U
    ttTranslate.hWidgetHandle      = phObject
    ttTranslate.iWidgetEntry       = iLoop
    ttTranslate.cOriginalLabel     = cLabel
    ttTranslate.cTranslatedLabel   = "":U
    ttTranslate.cOriginalTooltip   = "":U
    ttTranslate.cTranslatedTooltip = "":U
    ttTranslate.dSourceLanguageObj = dSourceLanguageObj.
END.  /* label-loop */

{get TabVisualization cTabVisualization phObject} NO-ERROR.

IF cTabVisualization = "COMBO-BOX":U THEN
DO:
  CREATE ttTranslate.
  ASSIGN
    hDisplayWidget                 = {fn getDisplayWidget phObject}
    ttTranslate.dLanguageObj       = dLanguageObj
    ttTranslate.cObjectName        = pcObjectName
    ttTranslate.lGlobal            = NO
    ttTranslate.lDelete            = NO
    ttTranslate.cWidgetType        = "COMBO-BOX":U
    ttTranslate.cWidgetName        = hDisplayWidget:NAME
    ttTranslate.hWidgetHandle      = hDisplayWidget
    ttTranslate.iWidgetEntry       = 0
    ttTranslate.cOriginalLabel     = hDisplayWidget:SIDE-LABEL-HANDLE:SCREEN-VALUE
    ttTranslate.cTranslatedLabel   = "":U
    ttTranslate.cOriginalTooltip   = "":U
    ttTranslate.cTranslatedTooltip = "":U
    ttTranslate.dSourceLanguageObj = dSourceLanguageObj.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addNodes vTableWin 
PROCEDURE addNodes :
/*------------------------------------------------------------------------------
  Purpose:     Add treeview nodes to translation temp-table
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
define input parameter phContainer            as handle no-undo.

DEFINE VARIABLE cNodes                          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNodeLabel                      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNodeLabels                     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNodeText                       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop                           AS INTEGER    NO-UNDO.
DEFINE VARIABLE cTreeViewName                   AS CHARACTER  NO-UNDO.
define variable dSourceLanguageObj              as decimal no-undo.
define variable dLanguageObj                    as decimal no-undo.

ASSIGN cNodes = DYNAMIC-FUNCTION("getTranslatableNodes":U IN phContainer) NO-ERROR.

/* This error handling is now probably not necessary, since this procedure
   is only called when the window is a treeview. */
IF ERROR-STATUS:ERROR THEN
DO:
  ERROR-STATUS:ERROR = FALSE.
  RETURN.
END.

dSourceLanguageObj = DECIMAL(DYNAMIC-FUNCTION("getDataValue":U IN hSourceLanguage)).
dLanguageObj = DECIMAL(DYNAMIC-FUNCTION("getDataValue":U IN hLanguage)).

ASSIGN cTreeViewName = DYNAMIC-FUNCTION("getTreeLogicalName":U IN phContainer) NO-ERROR.
IF ERROR-STATUS:ERROR THEN
  ASSIGN cTreeViewName = "":U.

IF NUM-ENTRIES(cNodes,CHR(2)) >= 2 THEN
  cNodeLabels = ENTRY(2,cNodes,CHR(2)).

ASSIGN cNodes = ENTRY(1,cNodes,CHR(2)).

IF cNodes = "":U AND cNodeLabels = "":U THEN
  RETURN.

/* Create TEXT Label translation records */
label-loop:
DO iLoop = 1 TO NUM-ENTRIES(cNodes, CHR(1)):
  
  ASSIGN cNodeText = "":U.
  ASSIGN cNodeText = ENTRY(iLoop, cNodes, CHR(1)) NO-ERROR.
  IF cNodeText = "":U OR
     cNodeText = ? THEN
    NEXT label-loop.

  CREATE ttTranslate.
  ASSIGN
    ttTranslate.dLanguageObj = dLanguageObj
    ttTranslate.cObjectName = cTreeViewName
    ttTranslate.lGlobal = NO
    ttTranslate.lDelete = NO
    ttTranslate.cWidgetType = "Node":U
    ttTranslate.cWidgetName = "NODE_":U + cNodeText
    ttTranslate.hWidgetHandle = ?
    ttTranslate.iWidgetEntry = 0
    ttTranslate.cOriginalLabel = cNodeText
    ttTranslate.cTranslatedLabel = "":U
    ttTranslate.cOriginalTooltip = "":U
    ttTranslate.cTranslatedTooltip = "":U
    ttTranslate.dSourceLanguageObj = dSourceLanguageObj.
END.  /* label-loop */

/* Create All Node Label translation records  - Popup menus*/
popup-loop:
DO iLoop = 1 TO NUM-ENTRIES(cNodeLabels, CHR(1)):
  
  ASSIGN cNodeLabel = "":U.
  ASSIGN cNodeLabel = ENTRY(iLoop, cNodeLabels, CHR(1)) NO-ERROR.
  IF cNodeLabel = "":U OR
     cNodeLabel = ? THEN
    NEXT popup-loop.

  CREATE ttTranslate.
  ASSIGN
    ttTranslate.dLanguageObj = dLanguageObj
    ttTranslate.cObjectName = cTreeViewName
    ttTranslate.lGlobal = NO
    ttTranslate.lDelete = NO
    ttTranslate.cWidgetType = "TREE_POPUP":U
    ttTranslate.cWidgetName = "POPUP_":U + cNodeLabel
    ttTranslate.hWidgetHandle = ?
    ttTranslate.iWidgetEntry = 0
    ttTranslate.cOriginalLabel = cNodeLabel
    ttTranslate.cTranslatedLabel = "":U
    ttTranslate.cOriginalTooltip = "":U
    ttTranslate.cTranslatedTooltip = "":U  
    ttTranslate.dSourceLanguageObj = dSourceLanguageObj.
END.  /* popup-loop */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addWidgets vTableWin 
PROCEDURE addWidgets :
/*------------------------------------------------------------------------------
  Purpose:     Add widgets to translation temp-table
  Parameters:  input object procedure handle
               input object name
               input object frame handle
  Notes:       Recursive procedure to cope with SDF's
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER phObject                 AS HANDLE     NO-UNDO.
DEFINE INPUT PARAMETER pcObjectName             AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER phFrame                  AS HANDLE     NO-UNDO.

DEFINE VARIABLE hWidgetGroup                    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hNewObject                      AS HANDLE     NO-UNDO.
DEFINE VARIABLE cNewObjectName                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hWidget                         AS HANDLE     NO-UNDO.
DEFINE VARIABLE hLabel                          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hColumn                         AS HANDLE     NO-UNDO.
DEFINE VARIABLE cFieldName                      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRadioButtons                   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iRadioLoop                      AS INTEGER    NO-UNDO.
DEFINE VARIABLE iBrowseLoop                     AS INTEGER    NO-UNDO.
DEFINE VARIABLE hLiteralHandle                  AS HANDLE     NO-UNDO.
DEFINE VARIABLE cLiteralHandles                 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cBufferTableName                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cColumnTableName                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDelimiter                      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cListItems                      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAllFieldHandles                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iHandleCnt                      AS INTEGER    NO-UNDO.
DEFINE VARIABLE hSDFFrame                       AS HANDLE     NO-UNDO.
DEFINE VARIABLE cTargets                        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iTarget                         AS INTEGER    NO-UNDO.
DEFINE VARIABLE hTarget                         AS HANDLE     NO-UNDO.
DEFINE VARIABLE hChildFrame                     AS HANDLE     NO-UNDO.
DEFINE VARIABLE cTargetFrames                   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLookup                         AS INTEGER    NO-UNDO.
DEFINE VARIABLE cObjectType                     AS CHARACTER  NO-UNDO.
define variable dSourceLanguageObj              as decimal no-undo.
define variable dLanguageObj                    as decimal no-undo.

DEFINE BUFFER bttTranslate FOR ttTranslate.

/* for dynamic toolbars - use container object name  (NO - force gloabl rather) */
/* IF phFrame:NAME = "Panel-Frame":U THEN */
/*   ASSIGN pcObjectName = gcCallerName.  */

/* Do not allow the toolbar buttons to be translated - this is done 
   with the new Menu Item Translation tool */
IF CAN-QUERY(phObject,"FILE-NAME":U) AND 
   INDEX(phObject:FILE-NAME,"dyntool":U) > 0 THEN
  RETURN.

IF pcObjectName = ? THEN
    ASSIGN pcObjectName = DYNAMIC-FUNCTION("getLogicalObjectName" IN phObject) NO-ERROR.

dSourceLanguageObj = DECIMAL(DYNAMIC-FUNCTION("getDataValue":U IN hSourceLanguage)).
dLanguageObj = DECIMAL(DYNAMIC-FUNCTION("getDataValue":U IN hLanguage)).

/* Need to create a list of frame handles for target objects.  This list is checked 
   below when widget walking encounters a frame to see if the frame is an object
   (e.g. SmartObject on a SmartFrame or SDF on viewer).  It then invokes addWidget
   recursively with the object name so that the translation records are created with the
   correct object name.  When this procedure is run for the container being translated,
   the list of frame handles should not be built because addWidget should not be 
   recursively called for objects on the container (e.g. Smartviewer on SmartWindow). */  
{get ContainerTarget cTargets phObject} NO-ERROR.
/* Prevent list from being created for calling container */
IF phObject <> ghCallerHandle THEN
DO:
  DO iTarget = 1 TO NUM-ENTRIES(cTargets):
    hTarget = WIDGET-HANDLE(ENTRY(iTarget,cTargets)).
    {get ContainerHandle hChildFrame hTarget}.

    IF hChildFrame NE ? THEN
    cTargetFrames = cTargetFrames + ',':U + STRING(hChildFrame).
    ELSE cTargetFrames = cTargetFrames + ',':U + '?':U.
  END.
  cTargetFrames = LEFT-TRIM(cTargetFrames,',':U).
END.

ASSIGN
  hwidgetGroup    = phFrame:HANDLE
  hwidgetGroup    = hwidgetGroup:FIRST-CHILD
  hWidget         = hwidgetGroup:FIRST-CHILD
  hLiteralHandle  = hWidget.

/* First build list of LITERAL handles that are labels to other widgets */
ASSIGN cLiteralHandles = "":U.
literal-widget-walk:
REPEAT WHILE VALID-HANDLE (hLiteralHandle):
  IF LOOKUP(hLiteralHandle:TYPE, "button,fill-in,selection-list,editor,combo-box,radio-set,slider,toggle-box,text":U) = 0 THEN 
  DO:
    ASSIGN hLiteralHandle = hLiteralHandle:NEXT-SIBLING.
    NEXT literal-widget-walk.
  END.
  IF CAN-QUERY(hLiteralHandle, "SIDE-LABEL-HANDLE":U) AND hLiteralHandle:SIDE-LABEL-HANDLE <> ? THEN
    ASSIGN cLiteralHandles = IF cLiteralHandles = "":U
                                THEN STRING(hLiteralHandle:SIDE-LABEL-HANDLE)
                                ELSE cLiteralHandles + ",":U + STRING(hLiteralHandle:SIDE-LABEL-HANDLE).
  ASSIGN hLiteralHandle = hLiteralHandle:NEXT-SIBLING.
END.

widget-walk:
REPEAT WHILE VALID-HANDLE (hWidget):
  IF LOOKUP(hWidget:TYPE, "literal,button,fill-in,selection-list,editor,combo-box,radio-set,slider,toggle-box,text":U) > 0 THEN
  DO:
    /* Check that the literal and text widget is not a label for another widget */
    IF can-do('Literal,Text':u, hWidget:Type) and 
       LOOKUP(STRING(hWidget),cLiteralHandles) > 0 THEN 
    DO:
      ASSIGN hWidget = hWidget:NEXT-SIBLING.
      NEXT widget-walk.
    END.

    /* Check for VIEW-AS-TEXT fill-ins. Also make sure we exclude plain TEXT widgets. */
    IF hWidget:TYPE = "TEXT" THEN 
    DO:
      /* Plain TEXT widgets do not have a NAME set for Static Viewers */
      IF CAN-QUERY(hWidget, "NAME":U) AND 
         hWidget:NAME = ? THEN DO:
        ASSIGN hWidget = hWidget:NEXT-SIBLING.
        NEXT widget-walk.
      END.
      
      /* For DynViewers the TEXT widgets have a name assigned to them */
      IF CAN-QUERY(phObject,"FILE-NAME":U) AND INDEX(phObject:FILE-NAME,"rydynview":U) > 0 THEN 
      DO:
        IF CAN-QUERY(hWidget, "NAME":U) 
        AND hWidget:NAME BEGINS "TEXT":U THEN 
        DO:
          ASSIGN hWidget = hWidget:NEXT-SIBLING.
          NEXT widget-walk.
        END.
      END.
      
    END.

    ASSIGN
      cFieldName = (IF CAN-QUERY(hWidget, "TABLE":U) AND LENGTH(hWidget:TABLE) > 0 AND hWidget:TABLE <> "RowObject":U THEN (hWidget:TABLE + ".":U) ELSE "":U) + hWidget:NAME.
    
    /* Do not include any TEXT widgets */
    IF hWidget:TYPE = "LITERAL" AND
       (cFieldName = ? OR
        cFieldName = "":U) THEN 
    DO:
      IF CAN-QUERY(hWidget,"SCREEN-VALUE":U) AND hWidget:SCREEN-VALUE <> ? THEN 
      DO:
        ASSIGN hWidget = hWidget:NEXT-SIBLING.
        NEXT widget-walk.
      END.
    END.

    IF (cFieldName = ? OR cFieldName = "":U) AND hWidget:TYPE <> "LITERAL" THEN
    DO:
      ASSIGN hWidget = hWidget:NEXT-SIBLING.
      NEXT widget-walk.
    END.

    /* Avoid duplicates */
    IF CAN-FIND(FIRST ttTranslate
                WHERE ttTranslate.dSourceLanguageObj = dSourceLanguageObj
                  AND ttTranslate.dLanguageObj = dLanguageObj
                  AND ttTranslate.cObjectName = pcObjectName
                  AND ttTranslate.cWidgetType = hWidget:TYPE
                  AND ttTranslate.cWidgetName = cFieldName) THEN
    DO:
      ASSIGN hWidget = hWidget:NEXT-SIBLING.
      NEXT widget-walk.
    END.

    /* Only allow translations of list-item-pair data for widgets
     * on dynamic viewers.                                        */
    IF CAN-DO("COMBO-BOX,SELECTION-LIST":U, hWidget:TYPE) AND
       CAN-QUERY(hWidget, "LIST-ITEM-PAIRS":U) AND
       NUM-ENTRIES(pcObjectName, ":":U) <= 1 /* Not for SDFs */
    THEN then-blk: DO:
        ASSIGN cListItems = hWidget:LIST-ITEM-PAIRS
               cDelimiter = hWidget:DELIMITER.

        IF cListItems NE ? AND NUM-ENTRIES(cListItems, cDelimiter) GE 2 THEN
        DO iRadioLoop = 1 TO NUM-ENTRIES(cListItems, cDelimiter) BY 2:
          CREATE ttTranslate.
          ASSIGN
            ttTranslate.dLanguageObj        = dLanguageObj
            ttTranslate.cObjectName         = pcObjectName
            ttTranslate.lGlobal             = NO
            ttTranslate.lDelete             = NO
            ttTranslate.cWidgetType         = hWidget:TYPE
            ttTranslate.cWidgetName         = cFieldName
            ttTranslate.hWidgetHandle       = hWidget
            ttTranslate.iWidgetEntry        = (iRadioLoop + 1) / 2
            ttTranslate.cOriginalLabel      = ENTRY(iRadioLoop, cListItems, cDelimiter)
            ttTranslate.cTranslatedLabel    = "":U
            ttTranslate.cOriginalTooltip    = (IF CAN-QUERY(hWidget,"TOOLTIP":U) AND hWidget:TOOLTIP <> ? THEN hWidget:TOOLTIP ELSE "":U)
            ttTranslate.cTranslatedTooltip  = "":U
            ttTranslate.dSourceLanguageObj = dSourceLanguageObj.
        END.    /* loop through list items  */
    END.    /* combos and selection list AND updatable list item pairs. */
    
    IF hWidget:TYPE <> "RADIO-SET":U THEN
    DO:
      CREATE ttTranslate.
      ASSIGN
        ttTranslate.dLanguageObj = dLanguageObj
        ttTranslate.cObjectName = pcObjectName
        ttTranslate.lGlobal = (phFrame:NAME = "Panel-Frame":U)
        ttTranslate.lDelete = NO
        ttTranslate.cWidgetType = hWidget:TYPE
        ttTranslate.cWidgetName = cFieldName
        ttTranslate.hWidgetHandle = hWidget
        ttTranslate.iWidgetEntry = 0
        ttTranslate.cOriginalLabel = IF hWidget:TYPE = "TEXT":U
                                     AND CAN-QUERY(hWidget, "NAME":U)
                                     AND CAN-QUERY(hWidget, "SCREEN-VALUE":U)
                                     THEN hWidget:SCREEN-VALUE
                                     ELSE (IF CAN-QUERY(hWidget,"LABEL":U)
                                           AND hWidget:LABEL <> ?
                                           THEN hWidget:LABEL
                                           ELSE "":U)
        ttTranslate.cTranslatedLabel = "":U
        ttTranslate.cOriginalTooltip = (IF CAN-QUERY(hWidget,"TOOLTIP":U) AND hWidget:TOOLTIP <> ? THEN hWidget:TOOLTIP ELSE "":U)
        ttTranslate.cTranslatedTooltip = "":U
        ttTranslate.dSourceLanguageObj = dSourceLanguageObj.
      /* deal with SDF's where label is separate */
      IF INDEX(pcObjectName, ":":U) <> 0 AND (ttTranslate.cOriginalLabel = "":U OR
         cFieldName = "fiCombo":U OR cFieldName = "fiLookup":U) THEN
      DO:
        ASSIGN hLabel = ?.
        ASSIGN hLabel = DYNAMIC-FUNCTION("getLabelHandle":U IN phObject) NO-ERROR.
        IF VALID-HANDLE(hLabel) AND hLabel:SCREEN-VALUE <> ? AND hLabel:SCREEN-VALUE <> "":U THEN
          ttTranslate.cOriginalLabel = REPLACE(hLabel:SCREEN-VALUE,":":U,"":U).
      END.

    END. /* not a radio-set */
    ELSE  /* It is a radio-set */
    DO:
      ASSIGN cRadioButtons = hWidget:RADIO-BUTTONS.
      radio-loop:
      DO iRadioLoop = 1 TO NUM-ENTRIES(cRadioButtons) BY 2:

        CREATE ttTranslate.
        ASSIGN
          ttTranslate.dLanguageObj        = dLanguageObj
          ttTranslate.cObjectName         = pcObjectName
          ttTranslate.lGlobal             = NO
          ttTranslate.lDelete             = NO
          ttTranslate.cWidgetType         = hWidget:TYPE
          ttTranslate.cWidgetName         = cFieldName
          ttTranslate.hWidgetHandle       = hWidget
          ttTranslate.iWidgetEntry        = (iRadioLoop + 1) / 2
          ttTranslate.cOriginalLabel      = ENTRY(iRadioLoop, cRadioButtons)
          ttTranslate.cTranslatedLabel    = "":U
          ttTranslate.cOriginalTooltip    = (IF CAN-QUERY(hWidget,"TOOLTIP":U) AND hWidget:TOOLTIP <> ? THEN hWidget:TOOLTIP ELSE "":U)
          ttTranslate.cTranslatedTooltip  = "":U
          ttTranslate.dSourceLanguageObj = dSourceLanguageObj.
      END. /* radio-loop */
    END. /* radio-set */
  END.  /* valid widget type */
  ELSE IF INDEX(hWidget:TYPE,"browse":U) <> 0 THEN
  DO:
    ASSIGN
      hColumn = hWidget:FIRST-COLUMN.
    col-loop:
    DO iBrowseLoop = 1 TO hWidget:NUM-COLUMNS:
        /*
        Determine the buffer table name and the table name 
        If two buffers for the same table is used, the table prefix will be the same 
        This cause errors when creating the translation fields as a record will the same name already exist
        */
        ASSIGN
          cBufferTableName = hColumn:BUFFER-FIELD:BUFFER-HANDLE:NAME
          cColumnTableName = hColumn:TABLE
          NO-ERROR.
        ASSIGN
          cFieldName = (IF cBufferTableName <> ?
                        AND cBufferTableName <> "RowObject":U
                        AND LENGTH(cBufferTableName) > 0
                        THEN (cBufferTableName + ".":U)
                        ELSE
                        (IF cColumnTableName <> ?
                         AND cColumnTableName <> "RowObject":U
                         AND LENGTH(cColumnTableName) > 0
                         THEN (cColumnTableName + ".":U)
                         ELSE
                           "":U
                        )
                       )
                     + (IF (hColumn:NAME = ? OR hColumn:NAME = "":U)
                        AND hColumn:LABEL <> ?
                        THEN hColumn:LABEL
                        ELSE hColumn:NAME
                       ).
                       
      IF NOT VALID-HANDLE(hColumn) THEN LEAVE col-loop.

      IF cFieldName = ? OR cFieldName = "":U THEN
      DO:
        ASSIGN hColumn = hcolumn:NEXT-COLUMN NO-ERROR.
        NEXT col-loop.
      END.

      /* Avoid duplicates */
      IF CAN-FIND(FIRST ttTranslate
                  WHERE ttTranslate.dLanguageObj = 0
                    AND ttTranslate.cObjectName  = cObjectName
                    AND ttTranslate.cWidgetType  = hWidget:TYPE
                    AND ttTranslate.cWidgetName  = cFieldName) THEN
      DO:
        ASSIGN hColumn = hcolumn:NEXT-COLUMN NO-ERROR.
        NEXT col-loop.
      END.

      CREATE ttTranslate.
      ASSIGN
        ttTranslate.dLanguageObj        = dLanguageObj
        ttTranslate.cObjectName         = pcObjectName
        ttTranslate.lGlobal             = NO
        ttTranslate.lDelete             = NO
        ttTranslate.cWidgetType         = hWidget:TYPE
        ttTranslate.cWidgetName         = cFieldName
        ttTranslate.hWidgetHandle       = hWidget
        ttTranslate.iWidgetEntry        = 0
        ttTranslate.cOriginalLabel      = (IF CAN-QUERY(hColumn,"LABEL":U) AND hColumn:LABEL <> ? THEN hColumn:LABEL ELSE "":U)
        ttTranslate.cTranslatedLabel    = "":U
        ttTranslate.cOriginalTooltip    = (IF CAN-QUERY(hColumn,"TOOLTIP":U) AND hColumn:TOOLTIP <> ? THEN hColumn:TOOLTIP ELSE "":U)
        ttTranslate.cTranslatedTooltip  = "":U
        ttTranslate.dSourceLanguageObj = dSourceLanguageObj.        
        ASSIGN hColumn                        = hcolumn:NEXT-COLUMN NO-ERROR.
    END.
  END.
  ELSE IF hWidget:TYPE = "frame":U THEN
  DO:
    /* Check whether the frame is a frame for a target object (e.g. SmartObject on SmartFrame or
       SDF on viewer).  If so then set hNewObject to its object handle. */
    iLookup = LOOKUP(STRING(hWidget),cTargetFrames).
    IF iLookup > 0 THEN
      hNewObject = WIDGET-HANDLE(ENTRY(iLookup,cTargets)).
    ELSE hNewObject = ?.

    /* If the new object is a procedure then get its object name, try FieldName first for SDFs
       then object name for other SmartObjects (e.g. SmartObjects on SmartFrames) */
    IF VALID-HANDLE(hNewObject) AND hNewObject:TYPE = "procedure":U THEN
    DO:
      cFieldName = "":U.
      cFieldName = DYNAMIC-FUNCTION('getFieldName' IN hNewObject) NO-ERROR.

      IF cFieldName NE "":U THEN
        ASSIGN cNewObjectName = TRIM(pcObjectName) + ":":U + cFieldName. 
      ELSE
      DO:
        /* get object name */
        ASSIGN cNewObjectName = hNewObject:FILE-NAME.
        ASSIGN cNewObjectName = DYNAMIC-FUNCTION('getLogicalObjectName' IN hNewObject) NO-ERROR.
        IF cNewObjectName = "":U OR cNewObjectName = ? THEN
          ASSIGN cNewObjectname = hNewObject:FILE-NAME.

        /* strip off path if any */
        ASSIGN
          cNewObjectName = LC(TRIM(REPLACE(cNewObjectName,"~\":U,"/":U)))
          cNewObjectName = SUBSTRING(cNewObjectName,R-INDEX(cNewObjectName,"/":U) + 1).

      END.
    END.
    /* If the frame is not a procedure and a static frame in a SmartContainer */
    ELSE
      ASSIGN
        hNewObject      = phObject
        cNewObjectName  = pcObjectName.
    /* Skip child frames in ghCallerHandle since they may be separate objects */
    IF hNewObject <> ghCallerHandle THEN
        RUN addWidgets (INPUT hNewObject, INPUT cNewObjectName, INPUT hWidget). 
  END.

  ASSIGN hWidget = hWidget:NEXT-SIBLING.
END.  /* widget-walk */

  /* Make sure that we do not include TEXT widgets representing labels for a
     Dynamic Viewer's widgets - These labels are created as TEXT widgets with
     the following naming convention - LABEL_<field_name> */
  FOR EACH  ttTranslate
      WHERE ttTranslate.cWidgetType = "TEXT":U
      AND   ttTranslate.cWidgetName BEGINS "LABEL_":U
      EXCLUSIVE-LOCK:
    IF CAN-FIND(FIRST bttTranslate
                WHERE bttTranslate.dLanguageObj       = ttTranslate.dLanguageObj
                AND   bttTranslate.cObjectName        = ttTranslate.cObjectName
                AND   bttTranslate.dSourceLanguageObj = ttTranslate.dSourceLanguageObj
                AND   bttTranslate.cWidgetName        = REPLACE(ttTranslate.cWidgetName,"LABEL_":U,"":U)) THEN
      DELETE ttTranslate.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
             INPUT  'adm2/dyncombo.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_language.language_nameKeyFieldgsc_language.language_objFieldLabelLanguageFieldTooltipSelect the language to translate to, from the list.KeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(35)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_language NO-LOCK BY gsc_language.language_nameQueryTablesgsc_languageSDFFileNameSDFTemplateParentFieldParentFilterQueryDescSubstitute&1ComboDelimiterListItemPairsInnerLines5SortnoComboFlagAFlagValue0BuildSequence1SecurednoCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesUseCacheyesSuperProcedureDataSourceNameFieldNamelanguage_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hLanguage ).
       RUN repositionObject IN hLanguage ( 2.14 , 12.60 ) NO-ERROR.
       RUN resizeObject IN hLanguage ( 1.05 , 50.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dyncombo.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_language.language_nameKeyFieldgsc_language.language_objFieldLabelSource languageFieldTooltipSelect the source language from the list.KeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(256)DisplayDatatypeCHARACTERBaseQueryStringFOR EACH gsc_language NO-LOCK BY gsc_language.language_nameQueryTablesgsc_languageSDFFileNameSDFTemplateParentFieldParentFilterQueryDescSubstitute&1ComboDelimiterListItemPairsInnerLines5SortnoComboFlagFlagValueBuildSequence1SecurednoCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesUseCacheyesSuperProcedureDataSourceNameFieldNamesource_language_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hSourceLanguage ).
       RUN repositionObject IN hSourceLanguage ( 2.14 , 84.40 ) NO-ERROR.
       RUN resizeObject IN hSourceLanguage ( 1.05 , 50.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( hLanguage ,
             fiContainer:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( hSourceLanguage ,
             hLanguage , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE browseValueChanged vTableWin 
PROCEDURE browseValueChanged :
/*------------------------------------------------------------------------------
  Purpose:     Disable global setting for window titles as these cannot be global
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE hColumn                   AS HANDLE   NO-UNDO.
DEFINE VARIABLE iLoop                     AS INTEGER  NO-UNDO.

IF NOT ghBuffer:AVAILABLE THEN RETURN.

ASSIGN hColumn = ghBrowse:FIRST-COLUMN NO-ERROR.

column-loop:
DO iLoop = 1 TO ghBrowse:NUM-COLUMNS:

  IF hColumn:LABEL = "Global":U THEN
  DO:
    IF ghObjectField:BUFFER-VALUE = "":U              OR 
       ghObjectField:BUFFER-VALUE = "rydyntoolt.w":U  OR 
       ghTypeField:BUFFER-VALUE   = "title":U         OR
       ghTypeField:BUFFER-VALUE   = "tab":U           OR
       NUM-ENTRIES(ghObjectField:BUFFER-VALUE,":":U) = 2 /* SDF */ THEN
    DO:
      hColumn:READ-ONLY = TRUE.
    END.
    ELSE
    DO:
      hColumn:READ-ONLY = FALSE.
    END.
  END.

  IF hColumn:LABEL = "Translated Tooltip":U THEN
  DO:
    IF ghTypeField:BUFFER-VALUE = "title":U OR
       ghTypeField:BUFFER-VALUE = "tab":U THEN
    DO:
      hColumn:READ-ONLY = TRUE.
    END.
    ELSE
    DO:
      hColumn:READ-ONLY = FALSE.
    END.
  END.

  ASSIGN hColumn = hColumn:NEXT-COLUMN.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildBrowser vTableWin 
PROCEDURE buildBrowser :
/*------------------------------------------------------------------------------
  Purpose:     Construct dynamic browser onto viewer for translations
  Parameters:  input handle of lookup SDF
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE cQuery                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cField                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hField                    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hCurField                 AS HANDLE     NO-UNDO.
DEFINE VARIABLE iLoop                     AS INTEGER    NO-UNDO.
DEFINE VARIABLE cBrowseColHdls            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hLookup                   AS HANDLE     NO-UNDO.
DEFINE VARIABLE cValue                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLinkHandles              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cBrowseLabels             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hContainerSource          AS HANDLE     NO-UNDO.

/* populate temp-table */
ASSIGN
  ghTable   = TEMP-TABLE ttTranslate:HANDLE
  ghBuffer  = ghTable:DEFAULT-BUFFER-HANDLE. 

RUN buildTempTable (INPUT NO).

CREATE QUERY ghQuery.
ghQuery:ADD-BUFFER(ghBuffer).
ASSIGN cQuery = "FOR EACH ttTranslate NO-LOCK ":U
              + 'by ttTranslate.cLanguageName ':u
              + 'by ttTranslate.cObjectName ':u
              + 'by ttTranslate.cWidgetType ':u
              + 'by ttTranslate.cWidgetName ':u
              + 'by ttTranslate.iWidgetEntry':u.
ghQuery:QUERY-PREPARE(cQuery).

/* Create the dynamic browser here */

/* make the viewer as big as it can be to fit on tab page */
DEFINE VARIABLE hFrame                AS HANDLE  NO-UNDO.
DEFINE VARIABLE lPreviouslyHidden     AS LOGICAL NO-UNDO.
DEFINE VARIABLE dHeight               AS DECIMAL NO-UNDO.
DEFINE VARIABLE dWidth                AS DECIMAL NO-UNDO.

CREATE BROWSE ghBrowse
       ASSIGN FRAME            = FRAME {&FRAME-NAME}:handle
              ROW              = 3.5
              COL              = 1.5
              SEPARATORS       = TRUE
              ROW-MARKERS      = FALSE
              EXPANDABLE       = TRUE
              COLUMN-RESIZABLE = TRUE
              COLUMN-SCROLLING = TRUE
              ALLOW-COLUMN-SEARCHING = TRUE
              READ-ONLY        = NO
              QUERY            = ghQuery
        TRIGGERS:            
          ON 'row-leave':U
            PERSISTENT RUN rowLeave IN THIS-PROCEDURE.
          ON 'value-changed':U
            PERSISTENT RUN browseValueChanged IN THIS-PROCEDURE.
          ON 'start-search':U 
            PERSISTENT RUN startSearch IN THIS-PROCEDURE.
        end TRIGGERS.

/* Hide the browse while it is repopulated to avoid flashing */
ghBrowse:VISIBLE = NO.
ghBrowse:SENSITIVE = NO.

/* Add fields to browser */
field-loop:
DO iLoop = 1 TO ghBuffer:NUM-FIELDS:
  hCurField = ghBuffer:BUFFER-FIELD(iLoop).

  IF hCurField:DATA-TYPE = "DECIMAL" OR
     hCurField:DATA-TYPE = "HANDLE" THEN NEXT field-loop.

  hField = ghBrowse:ADD-LIKE-COLUMN(hCurField).

  IF INDEX(hCurField:NAME, "translated":U) <> 0 OR 
     INDEX(hCurField:NAME, "lglobal":U) <> 0 OR
     INDEX(hCurField:NAME, "delete":U) <> 0 THEN
    ASSIGN
      hField:READ-ONLY = FALSE.
  ELSE
    ASSIGN
      hField:READ-ONLY = TRUE.

  /* Build up the list of browse columns for use in rowDisplay */
  IF VALID-HANDLE(hField) THEN
    cBrowseColHdls = cBrowseColHdls + (IF cBrowseColHdls = "":U THEN "":U ELSE ",":U) 
                     + STRING(hField).
END.

ASSIGN
  ghObjectField = ghBuffer:BUFFER-FIELD("cObjectName":U)
  ghGlobalField = ghBuffer:BUFFER-FIELD("lGlobal":U)
  ghTypeField   = ghBuffer:BUFFER-FIELD("cWidgetType":U).

ghBrowse:NUM-LOCKED-COLUMNS = 0.

/* Now open the query */
ghQuery:QUERY-OPEN().
APPLY "VALUE-CHANGED":U TO ghBrowse.

/* And show the browse to the user */
FRAME {&FRAME-NAME}:VISIBLE = FALSE.
ghBrowse:VISIBLE = YES.
ghBrowse:SENSITIVE = YES.
FRAME {&FRAME-NAME}:VISIBLE = TRUE.

APPLY "ENTRY":U TO ghBrowse.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildTempTable vTableWin 
PROCEDURE buildTempTable :
/*------------------------------------------------------------------------------
  Purpose:     To build temp-table of widgets to translate for language
               selected (or all).
  Parameters:  input open query flag yes/no
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER plOpenQuery              AS LOGICAL    NO-UNDO.
    
    define variable lTreeview                    as logical no-undo.

        /* 1st empty current temp-table contents */
    EMPTY TEMP-TABLE ttTranslate.
    
    lTreeview = {fnarg InstanceOf 'DynTree' ghCallerHandle} no-error.
    if lTreeview eq ? then lTreeview = No.
    
    if lTreeview then
        run addNodes in target-procedure (ghCallerHandle).
    
    /* Always start at the window. */
    run addContainer in target-procedure (ghCallerHandle).
    
    /* Now got all translation widgets - get any existing translations */
    RUN afgetmtrnp IN gshTranslationManager (INPUT DECIMAL(DYNAMIC-FUNCTION("getDataValue":U IN hLanguage)) = 0,
                                             INPUT-OUTPUT TABLE ttTranslate).
    
        /* Re-open query if required */
    IF plOpenQuery THEN
    DO:
      ghQuery:QUERY-OPEN().
      APPLY "VALUE-CHANGED":U TO ghBrowse.
      APPLY "ENTRY":U TO ghBrowse.
    END.
    
        /* Reset panel buttons to no changes */
    IF glModified THEN
    DO:
      ASSIGN glModified = FALSE.
      PUBLISH 'updateState' ('updatecomplete').
    END.
    
    error-status:error = no.
    return.
END PROCEDURE.    /* buildTempTable */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE comboEntry vTableWin 
PROCEDURE comboEntry :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcScreenValue AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER phCombo       AS HANDLE     NO-UNDO.

  IF phCombo = hLanguage THEN
    ASSIGN gcSavedLanguage = pcScreenValue.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE comboValueChanged vTableWin 
PROCEDURE comboValueChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcKeyFieldValue AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcScreenValue   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER phCombo         AS HANDLE     NO-UNDO.

  IF phCombo = hLanguage THEN 
  DO:
    IF gcSavedLanguage <> pcKeyFieldValue AND glModified THEN
    DO:
      DEFINE VARIABLE cButton AS CHARACTER NO-UNDO.
      DEFINE VARIABLE cAnswer AS CHARACTER NO-UNDO.
      RUN askQuestion IN gshSessionManager (INPUT "You have unsaved translations that will be lost if you change the language, continue?",    /* messages */
                                            INPUT "&Yes,&No":U,     /* button list */
                                            INPUT "&No":U,         /* default */
                                            INPUT "&No":U,          /* cancel */
                                            INPUT "Unsaved Translations Exist":U, /* title */
                                            INPUT "":U,             /* datatype */
                                            INPUT "":U,             /* format */
                                            INPUT-OUTPUT cAnswer,   /* answer */
                                            OUTPUT cButton          /* button pressed */
                                            ).
                                            
      IF cButton = "&No":U OR cButton = "No":U THEN
      DO:
        DYNAMIC-FUNCTION("setDataValue":U IN hLanguage,gcSavedLanguage).
        RETURN NO-APPLY.
      END.
      ELSE
      DO:
        ASSIGN gcSavedLanguage = pcKeyFieldValue.
        RUN buildTempTable (INPUT YES).
      END.
    END.
    ELSE IF gcSavedLanguage <> pcKeyFieldValue THEN
    DO:
      ASSIGN gcSavedLanguage = pcKeyFieldValue.
      RUN buildTempTable (INPUT YES).
    END.

    FIND FIRST ttTranslate 
         WHERE ttTranslate.dLanguageObj = DECIMAL(DYNAMIC-FUNCTION("getDataValue":U IN hLanguage))
         AND  (ttTranslate.cTranslatedLabel <> "":U
         OR    ttTranslate.cTranslatedTooltip <> "":U)
         NO-LOCK NO-ERROR.
    IF AVAILABLE ttTranslate THEN DO:
      DYNAMIC-FUNCTION("setDataValue":U IN hSourceLanguage,ttTranslate.dSourceLanguageObj).
      RUN disableField IN hSourceLanguage.
    END.
    ELSE
      RUN enableField IN hSourceLanguage.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject vTableWin 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* tidy up dynamic object handles */
DELETE OBJECT ghBrowse NO-ERROR.
ASSIGN ghBrowse = ?.
DELETE OBJECT ghQuery NO-ERROR.
ASSIGN ghQuery = ?.
DELETE OBJECT ghTable NO-ERROR.
ASSIGN ghTable = ?.

RUN SUPER.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject vTableWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataSource AS HANDLE     NO-UNDO.
    define variable cCallername                as character no-undo.  

  /* save handle of calling container */
  ghContainerHandle = DYNAMIC-FUNCTION('getContainerSource' IN THIS-PROCEDURE).
  IF VALID-HANDLE(ghContainerHandle) THEN
    ghCallerHandle = DYNAMIC-FUNCTION('getContainerSource' IN ghContainerHandle).
  IF VALID-HANDLE(ghCallerHandle) THEN
    cCallerName = DYNAMIC-FUNCTION('getLogicalObjectName' IN ghCallerHandle) NO-ERROR.  

  {get ContainerHandle ghWindow ghContainerHandle}.
  {get ContainerHandle ghCallerWindow ghCallerHandle}.
  
  SUBSCRIBE TO "comboEntry":U IN THIS-PROCEDURE.
  
  ghWindow:TITLE = "Translate Window: " + ghCallerWindow:TITLE.
  
  RUN SUPER.
  
  {get DataSource hDataSource}.
  IF VALID-HANDLE(hDataSource) THEN
    {set OpenOnInit FALSE hDataSource}.

  RUN displayFields (?).
  RUN enableField IN hLanguage.
  
  RUN setDefaults.
  
  RUN buildBrowser.
  
  RUN valueChanged IN hLanguage.
  
  /* Subscribe to comboVC after setDefaults because we'll run through the translation
     twice otherwise. */  
  SUBSCRIBE TO "comboValueChanged":U IN THIS-PROCEDURE.  

  APPLY "ROW-LEAVE":U TO ghBrowse.
  
  /* Display current data values */
  DO WITH FRAME {&FRAME-NAME}:
    fiContainer:SCREEN-VALUE = cCallerName.
  END.
  
  RUN resizeObject (INPUT FRAME {&FRAME-NAME}:HEIGHT-CHARS,
                    INPUT FRAME {&FRAME-NAME}:WIDTH-CHARS).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject vTableWin 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters: 
           pd_height AS DECIMAL - the desired height (in rows)
           pd_width  AS DECIMAL - the desired width (in columns)
    Notes: Used internally. Calls to resizeObject are generated by the
           AppBuilder in adm-create-objects for objects which implement it.
           Having a resizeObject procedure is also the signal to the AppBuilder
           to allow the object to be resized at design time.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pdHeight       AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER pdWidth        AS DECIMAL NO-UNDO.

  DEFINE VARIABLE lPreviouslyHidden     AS LOGICAL NO-UNDO.
  DEFINE VARIABLE hWindow               AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hContainerSource      AS HANDLE  NO-UNDO.

  {get ContainerSource hContainerSource}.
  {get ContainerHandle hWindow hContainerSource}.

  ASSIGN
      lPreviouslyHidden              = FRAME {&FRAME-NAME}:HIDDEN
      FRAME {&FRAME-NAME}:HIDDEN     = TRUE
      FRAME {&FRAME-NAME}:SCROLLABLE = FALSE.

  IF FRAME {&FRAME-NAME}:HEIGHT-CHARS < pdHeight OR
     FRAME {&FRAME-NAME}:WIDTH-CHARS  < pdWidth  THEN
  DO:
    IF pdHeight > FRAME {&FRAME-NAME}:HEIGHT-CHARS THEN
      FRAME {&FRAME-NAME}:HEIGHT-CHARS = pdHeight.

    IF pdWidth > FRAME {&FRAME-NAME}:WIDTH-CHARS THEN
      FRAME {&FRAME-NAME}:WIDTH-CHARS = pdWidth.
  END.
  
  IF VALID-HANDLE(ghBrowse) THEN
    ASSIGN
        ghBrowse:HEIGHT-CHARS = pdHeight - ghBrowse:ROW + 1.00
        ghBrowse:WIDTH-CHARS  = pdWidth  - 1.12.

  ASSIGN    
      FRAME {&FRAME-NAME}:HEIGHT-CHARS = pdHeight
      FRAME {&FRAME-NAME}:WIDTH-CHARS  = pdWidth.

  APPLY "end-resize":U TO FRAME {&FRAME-NAME}.
  FRAME {&FRAME-NAME}:HIDDEN = lPreviouslyHidden NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowleave vTableWin 
PROCEDURE rowleave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE iLoop                     AS INTEGER    NO-UNDO.
DEFINE VARIABLE hCol                      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hField                    AS HANDLE     NO-UNDO.

IF ghBrowse:CURRENT-ROW-MODIFIED THEN DO:
  REPEAT iLoop = 1 TO ghBrowse:NUM-COLUMNS:
      hCol = ghBrowse:GET-BROWSE-COLUMN(iLoop).
      IF hCol:MODIFIED THEN
      DO:
          RUN valueChanged.
          hField = hCol:BUFFER-FIELD.
      /* if buff-field-hdl is unknown, this is a calculated field
            and cannot be updated */
          IF NOT ghBuffer:AVAILABLE THEN
            ghBuffer:FIND-FIRST() NO-ERROR.
          IF hField NE ? AND ghBuffer:AVAILABLE THEN
              hField:BUFFER-VALUE = hCol:SCREEN-VALUE.
      END.
  END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaults vTableWin 
PROCEDURE setDefaults :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dUserObj            AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dSrcLang            AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE hContainer          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE dCurrentLanguageObj AS DECIMAL    NO-UNDO.

  dUserObj = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                       INPUT "CurrentUserObj":U,
                                       INPUT NO)) NO-ERROR.
                                       
  RUN getUserSourceLanguage IN gshGenManager (INPUT dUserObj, OUTPUT dSrcLang).
  IF dSrcLang <> 0 AND dSrcLang <> ? THEN DO:
    DYNAMIC-FUNCTION("setDataValue":U IN hSourceLanguage, STRING(dSrcLang)).
  END.
  
  dCurrentLanguageObj = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                 INPUT "currentLanguageObj":U,
                                                 INPUT NO)) NO-ERROR.
  
  IF dCurrentLanguageObj <> 0 AND dCurrentLanguageObj <> ? THEN
    DYNAMIC-FUNCTION("setDataValue":U IN hLanguage, STRING(dCurrentLanguageObj)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startsearch vTableWin 
PROCEDURE startsearch :
/*------------------------------------------------------------------------------
  Purpose:     Implement column sorting
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hColumn AS HANDLE     NO-UNDO.
  DEFINE VARIABLE rRow    AS ROWID      NO-UNDO.
  DEFINE VARIABLE cSortBy AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQuery  AS CHARACTER  NO-UNDO.

  ASSIGN
      hColumn = ghBrowse:CURRENT-COLUMN
      rRow    = ghBuffer:ROWID.

  IF VALID-HANDLE( hColumn ) THEN
  DO:
      ASSIGN
          cSortBy = (IF hColumn:TABLE <> ? THEN
                        hColumn:TABLE + '.':U + hColumn:NAME
                        ELSE hColumn:NAME).
                        
      ASSIGN cQuery = "FOR EACH ":U + ghBuffer:NAME + " NO-LOCK BY ":U + cSortBy.
      ghQuery:QUERY-PREPARE(cQuery).
      ghQuery:QUERY-OPEN().

      IF ghQuery:NUM-RESULTS > 0 THEN
        DO:
          ghQuery:REPOSITION-TO-ROWID(rRow) NO-ERROR.
          ghBrowse:CURRENT-COLUMN = hColumn.
          APPLY 'VALUE-CHANGED':U TO ghBrowse.
        END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRecord vTableWin 
PROCEDURE updateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cButton AS CHARACTER  NO-UNDO.
    define variable dSourceLanguageObj             as decimal no-undo.
    
    dSourceLanguageObj = DECIMAL(DYNAMIC-FUNCTION("getDataValue":U IN hSourceLanguage)).

  /* save our data */
  APPLY "row-leave":U TO ghBrowse.

  /* Ensure that we set the correct Source Language */
  FOR EACH ttTranslate:
    ttTranslate.dSourceLanguageObj = dSourceLanguageObj.
  END.
  
  RUN updateTranslations IN gshTranslationManager (INPUT TABLE ttTranslate) NO-ERROR.
  IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
  DO:
    RUN showMessages IN gshSessionManager (INPUT  RETURN-VALUE,                       /* message to display */
                                           INPUT  "ERR":U,                            /* error type         */
                                           INPUT  "&OK":U,                            /* button list        */
                                           INPUT  "&OK":U,                            /* default button     */
                                           INPUT  "&OK":U,                            /* cancel button      */
                                           INPUT  "Error creating translations":U,    /* error window title */
                                           INPUT  YES,                                /* display if empty   */
                                           INPUT  TARGET-PROCEDURE,                   /* container handle   */
                                           OUTPUT cButton).                           /* button pressed     */
    RETURN "ADM-ERROR".
  END.
  ELSE
    {set DataModified FALSE}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valueChanged vTableWin 
PROCEDURE valueChanged :
/*------------------------------------------------------------------------------
  Purpose:     Procedure fired on value changed of any of the widgets on the viewer
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF NOT glModified THEN
  DO:
      ASSIGN glModified = TRUE.
      {set DataModified TRUE}.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

