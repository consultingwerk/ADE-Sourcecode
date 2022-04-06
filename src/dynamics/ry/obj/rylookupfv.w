&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" sObject _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" sObject _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sObject 
/* Copyright © 2000-2006 by Progress Software Corporation.  All rights 
   reserved.  Prior versions of this work may contain portions 
   contributed by participants of Possenet.  */   
/*---------------------------------------------------------------------------------
  File: rylookupfv.w

  Description:  Lookup Filter Viewer

  Purpose:      Lookup Filter Viewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        7065   UserRef:    
                Date:   16/11/2000  Author:     Anthony Swindells

  Update Notes: Astra 2 dynamic lookups

  (v:010002)    Task:    90000166   UserRef:    
                Date:   25/07/2001  Author:     Mark Davies

  Update Notes: Add translation functionality for filter browser
    
  (v:100003)    Task:           0   UserRef:    
                Date:   10/25/2001  Author:     Mark Davies (MIP)

  Update Notes: Remove references to KeyFieldValue and SavedScreenValue

  (v:100004)    Task:           0   UserRef:    
                Date:   11/26/2001  Author:     Mark Davies (MIP)

  Update Notes: Fix for issue #3284 - The bottom border of the folder in Look up is missing

-------------------------------------------------------------------------------*/
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

&scop object-name       rylookupfv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartObject yes

{af/sup2/afglobals.i}

DEFINE VARIABLE glModified                  AS LOGICAL INITIAL NO.
DEFINE VARIABLE gcCallerName                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ghCallerHandle              AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghTable                     AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghBrowse                    AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghQuery                     AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghBuffer                    AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghSDF                       AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghGASource                  AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghMaintToolbar              AS HANDLE     NO-UNDO.
DEFINE VARIABLE glObjectVisible             AS LOGICAL    NO-UNDO.

{af/sup2/afttlkctrl.i}
{af/sup2/afttlkfilt.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS buClear buApply 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON buApply 
     LABEL "&Apply" 
     SIZE 15 BY 1.14 TOOLTIP "Apply Filter and Re-open lookup query"
     BGCOLOR 8 .

DEFINE BUTTON buClear 
     LABEL "&Clear" 
     SIZE 15 BY 1.14 TOOLTIP "Clear Filter Settings - must then press APPLY button to refresh query"
     BGCOLOR 8 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     buClear AT ROW 1 COL 71.8
     buApply AT ROW 1 COL 87.8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 103 BY 9.24.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartObject
   Allow: Basic
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
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
  CREATE WINDOW sObject ASSIGN
         HEIGHT             = 9.24
         WIDTH              = 103.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB sObject 
/* ************************* Included-Libraries *********************** */

{src/adm2/visual.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW sObject
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE FRAME-NAME                                               */
ASSIGN 
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

&Scoped-define SELF-NAME buApply
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buApply sObject
ON CHOOSE OF buApply IN FRAME frMain /* Apply */
DO:
  APPLY "entry":U TO SELF.

  /*1st validate fields in temp-table before applying */
  DEFINE VARIABLE lOk AS LOGICAL NO-UNDO.
  RUN validateFilter(OUTPUT lOk).
  IF NOT lOk THEN RETURN NO-APPLY.

  /* apply filter */
  IF VALID-HANDLE(ghGASource) THEN
    RUN applyFilters IN ghGASource (INPUT TABLE ttLookFilt).

  RUN processAction(INPUT "ctrl-page-up":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buClear
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buClear sObject
ON CHOOSE OF buClear IN FRAME frMain /* Clear */
DO:
  FOR EACH ttLookFilt:
    ASSIGN
      ttLookFilt.cFromValue = "":U
      ttLookFilt.cToValue = "":U
      .
  END.

  /* Now open the query */
  ghQuery:QUERY-OPEN().

  APPLY "ENTRY":U TO ghBrowse.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK sObject 


/* ***************************  Main Block  *************************** */

/* If testing in the UIB, initialize the SmartObject. */  
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
  RUN initializeObject.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildFilters sObject 
PROCEDURE buildFilters :
/*------------------------------------------------------------------------------
  Purpose:     Construct dynamic filter browser onto viewer plus related info
  Parameters:  input handle of lookup SDF
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER hSDF AS HANDLE NO-UNDO.

ASSIGN ghSDF = hSDF.

DEFINE VARIABLE hTH                       AS HANDLE     NO-UNDO.
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
DEFINE VARIABLE cObjectName               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFilterValue              AS CHARACTER  NO-UNDO.

{get ContainerSource hContainerSource}.

cLinkHandles = DYNAMIC-FUNCTION('linkHandles' IN THIS-PROCEDURE, 'GroupAssign-Source').
IF cLinkHandles <> "":U THEN
  ghGASource = WIDGET-HANDLE(ENTRY(1,cLinkHandles)).

hLookup = DYNAMIC-FUNCTION('getLookupHandle':U IN hSDF).
IF VALID-HANDLE(hLookup) THEN
  ASSIGN cValue = hLookup:SCREEN-VALUE.
ELSE
  ASSIGN cValue = "":U.

cFilterValue =  DYNAMIC-FUNCTION('getLookupFilterValue':U IN hSDF).

EMPTY TEMP-TABLE ttLookCtrl.
CREATE ttLookCtrl.
ASSIGN
  ttLookCtrl.cDisplayedField = DYNAMIC-FUNCTION('getDisplayedField':U IN hSDF)
  ttLookCtrl.cKeyField = DYNAMIC-FUNCTION('getKeyField':U IN hSDF)
  ttLookCtrl.cFieldLabel = DYNAMIC-FUNCTION('getFieldLabel':U IN hSDF)
  ttLookCtrl.cKeyFormat = DYNAMIC-FUNCTION('getKeyFormat':U IN hSDF)
  ttLookCtrl.cKeyDataType = DYNAMIC-FUNCTION('getKeyDataType':U IN hSDF)
  ttLookCtrl.cDisplayFormat = DYNAMIC-FUNCTION('getDisplayFormat':U IN hSDF)
  ttLookCtrl.cDisplayDataType = DYNAMIC-FUNCTION('getDisplayDataType':U IN hSDF)
  ttLookCtrl.cBrowseFields = DYNAMIC-FUNCTION('getBrowseFields':U IN hSDF)
  ttLookCtrl.cBrowseFieldDataTypes = DYNAMIC-FUNCTION('getBrowseFieldDataTypes':U IN hSDF)
  ttLookCtrl.cBrowseFieldFormats = DYNAMIC-FUNCTION('getBrowseFieldFormats':U IN hSDF)
  ttLookCtrl.iRowsToBatch = DYNAMIC-FUNCTION('getRowsToBatch':U IN hSDF)
  ttLookCtrl.cViewerLinkedFields = DYNAMIC-FUNCTION('getViewerLinkedFields':U IN hSDF)
  ttLookCtrl.cLinkedFieldDataTypes = DYNAMIC-FUNCTION('getLinkedFieldDataTypes':U IN hSDF)
  ttLookCtrl.cLinkedFieldFormats = DYNAMIC-FUNCTION('getLinkedFieldFormats':U IN hSDF)
  ttLookCtrl.cBaseQueryString = DYNAMIC-FUNCTION('getBaseQueryString':U IN hSDF)
  ttLookCtrl.cQueryTables = DYNAMIC-FUNCTION('getQueryTables':U IN hSDF)
  ttLookCtrl.cKeyValue = DYNAMIC-FUNCTION('getDataValue':U IN hSDF)
  ttLookCtrl.cColumnLabels = DYNAMIC-FUNCTION('getColumnLabels':U IN hSDF)
  ttLookCtrl.cColumnFormat = DYNAMIC-FUNCTION('getColumnFormat':U IN hSDF)
  ttLookCtrl.cDisplayValue = cValue
  ttLookCtrl.cRowIdent = DYNAMIC-FUNCTION('getRowIdent':U IN hSDF)
  ttLookCtrl.iFirstRowNum = 0
  ttLookCtrl.iLastRowNum = 0
  ttLookCtrl.cFirstResultRow = "":U
  ttLookCtrl.cLastResultRow = "":U
  .

/* build list of all fields */
ASSIGN
  ttLookCtrl.cAllFields = ttLookCtrl.cKeyField
  ttLookCtrl.cAllFieldTypes = ttLookCtrl.cKeyDataType
  ttLookCtrl.cAllFieldFormats = ttLookCtrl.cKeyFormat
  .
IF ttLookCtrl.cKeyField <> ttLookCtrl.cDisplayedField THEN
  ASSIGN
    ttLookCtrl.cAllFields = ttLookCtrl.cAllFields + ",":U + ttLookCtrl.cDisplayedField
    ttLookCtrl.cAllFieldTypes = ttLookCtrl.cAllFieldTypes + ",":U + ttLookCtrl.cDisplayDataType
    ttLookCtrl.cAllFieldFormats = ttLookCtrl.cAllFieldFormats + ",":U + ttLookCtrl.cDisplayFormat
    .
/* Changed Browse Field Format delimiter to '|' - need to check for old lookups
   where ',' is still used and carer for this */
IF NUM-ENTRIES(ttLookCtrl.cBrowseFieldFormats,"|":U) <> NUM-ENTRIES(ttLookCtrl.cBrowseFieldDataTypes) THEN 
  ASSIGN ttLookCtrl.cBrowseFieldFormats = REPLACE(ttLookCtrl.cBrowseFieldFormats,",":U,"|":U)
         ttLookCtrl.cColumnFormat       = IF ttLookCtrl.cColumnFormat <> "":U THEN ttLookCtrl.cBrowseFieldFormats ELSE REPLACE(ttLookCtrl.cColumnFormaT,",":U,"|":U).
IF NUM-ENTRIES(ttLookCtrl.cBrowseFieldFormats,"|":U) <> NUM-ENTRIES(ttLookCtrl.cBrowseFieldDataTypes) THEN DO:
  /* Now we need to assign default formats depending on data types */
  ttLookCtrl.cBrowseFieldFormats = FILL("|":U,NUM-ENTRIES(ttLookCtrl.cBrowseFieldDataTypes) - 1).
  DO iLoop = 1 TO NUM-ENTRIES(ttLookCtrl.cBrowseFields):
    CASE ENTRY(iLoop,ttLookCtrl.cBrowseFieldDataTypes):
      WHEN "DECIMAL":U THEN DO:
        IF SUBSTRING(ENTRY(iLoop,ttLookCtrl.cBrowseFields),LENGTH(ENTRY(iLoop,ttLookCtrl.cBrowseFields)) - 3,4) = "_obj":U THEN
          ENTRY(iLoop,ttLookCtrl.cBrowseFieldFormats,"|":U) = "->>>>>>>>>>>>>>>>>>>>9.999999":U.
        ELSE
          ENTRY(iLoop,ttLookCtrl.cBrowseFieldFormats,"|":U) = "->>>,>>>,>>>,>>>,>>>,>>>,>>9.99":U.
      END.
      WHEN "LOGICAL":U THEN
        ENTRY(iLoop,ttLookCtrl.cBrowseFieldFormats,"|":U) = "YES/NO":U.
      WHEN "INTEGER":U THEN
        ENTRY(iLoop,ttLookCtrl.cBrowseFieldFormats,"|":U) = "->>>,>>>,>>9":U.
      WHEN "DATE":U THEN
        ENTRY(iLoop,ttLookCtrl.cBrowseFieldFormats,"|":U) = "99/99/9999":U.
      OTHERWISE 
        ENTRY(iLoop,ttLookCtrl.cBrowseFieldFormats,"|":U) = "X(75)":U.
    END CASE.
  END.
  ttLookCtrl.cColumnFormat = IF ttLookCtrl.cColumnFormat <> "":U THEN ttLookCtrl.cBrowseFieldFormats ELSE "":U.
END.

DO iLoop = 1 TO NUM-ENTRIES(ttLookCtrl.cBrowseFields):
  IF LOOKUP(ENTRY(iLoop,ttLookCtrl.cBrowseFields),ttLookCtrl.cAllFields) = 0 THEN
    ASSIGN
      ttLookCtrl.cAllFields = ttLookCtrl.cAllFields + ",":U + ENTRY(iLoop,ttLookCtrl.cBrowseFields)
      ttLookCtrl.cAllFieldTypes = ttLookCtrl.cAllFieldTypes + ",":U + ENTRY(iLoop,ttLookCtrl.cBrowseFieldDataTypes)
      ttLookCtrl.cAllFieldFormats = ttLookCtrl.cAllFieldFormats + ",":U + ENTRY(iLoop,ttLookCtrl.cBrowseFieldFormats,"|":U)
      .
END.
DO iLoop = 1 TO NUM-ENTRIES(ttLookCtrl.cViewerLinkedFields):
  IF LOOKUP(ENTRY(iLoop,ttLookCtrl.cViewerLinkedFields),ttLookCtrl.cAllFields) = 0 THEN
    ASSIGN 
      ttLookCtrl.cAllFields = ttLookCtrl.cAllFields + ",":U + ENTRY(iLoop,ttLookCtrl.cViewerLinkedFields)
      ttLookCtrl.cAllFieldTypes = ttLookCtrl.cAllFieldTypes + ",":U + ENTRY(iLoop,ttLookCtrl.cLinkedFieldDataTypes)
      ttLookCtrl.cAllFieldFormats = ttLookCtrl.cAllFieldFormats + ",":U + ENTRY(iLoop,ttLookCtrl.cLinkedFieldFormats)
      .
END.

/*  get browse field labels */
RUN getBrowseLabels IN ghGASource (OUTPUT cBrowseLabels).

/* populate temp-table */
EMPTY TEMP-TABLE ttLookFilt.

DO iLoop = 1 TO NUM-ENTRIES(ttLookCtrl.cBrowseFields):
  /* Exclude extent fields */
  IF INDEX(ENTRY(iLoop, cBrowseLabels),"[":U) > 0 THEN
    NEXT.
  CREATE ttLookFilt.
  ASSIGN
    ttLookFilt.cFieldName = ENTRY(iLoop, ttLookCtrl.cBrowseFields)
    ttLookFilt.cFieldLabel = ENTRY(iLoop, cBrowseLabels)
    ttLookFilt.cFieldFormat = ENTRY(iLoop, ttLookCtrl.cBrowseFieldFormats,"|":U)
    ttLookFilt.cFieldDataType = ENTRY(iLoop, ttLookCtrl.cBrowseFieldDataTypes)
    ttLookFilt.cFromValue = "":U
    ttLookFilt.cToValue = "":U
    .
    IF ttLookCtrl.cColumnFormat <> "":U AND 
       NUM-ENTRIES(ttLookCtrl.cColumnFormat,"|":U) >= iLoop AND 
       ENTRY(iLoop,ttLookCtrl.cColumnFormat,"|":U) <> "":U  THEN
      ttLookFilt.cFieldFormat = ENTRY(iLoop,ttLookCtrl.cColumnFormat,"|":U).
    IF ttLookCtrl.cColumnFormat <> "":U AND 
       NUM-ENTRIES(ttLookCtrl.cColumnLabels) >= iLoop AND 
       ENTRY(iLoop,ttLookCtrl.cColumnLabels) <> "":U  THEN
      ttLookFilt.cFieldLabel = ENTRY(iLoop,ttLookCtrl.cColumnLabels).

    IF cFilterValue <> "":U AND
       cFilterValue <> ?    AND 
       ttLookFilt.cFieldName = cDisplayedField THEN
      ASSIGN ttLookFilt.cFromValue = cFilterValue
             ttLookFilt.cToValue = cFilterValue.
       
END.

ASSIGN
  ghTable  = TEMP-TABLE ttLookFilt:HANDLE
  ghBuffer = ghTable:DEFAULT-BUFFER-HANDLE
  . 

CREATE QUERY ghQuery.
ghQuery:ADD-BUFFER(ghBuffer).
ASSIGN cQuery = "FOR EACH ttLookFilt NO-LOCK":U.
ghQuery:QUERY-PREPARE(cQuery).

/* Create the dynamic browser here */

/* make the viewer as big as it can be to fit on tab page */
DEFINE VARIABLE hWindow               AS HANDLE  NO-UNDO.
DEFINE VARIABLE hFrame                AS HANDLE  NO-UNDO.
DEFINE VARIABLE lPreviouslyHidden     AS LOGICAL NO-UNDO.
DEFINE VARIABLE dHeight               AS DECIMAL NO-UNDO.
DEFINE VARIABLE dWidth                AS DECIMAL NO-UNDO.

{get ContainerHandle hWindow hContainerSource}.

FRAME {&FRAME-NAME}:HEIGHT-PIXELS = hWindow:HEIGHT-PIXELS - 70.
FRAME {&FRAME-NAME}:WIDTH-PIXELS = hWindow:WIDTH-PIXELS - 28.

CREATE BROWSE ghBrowse
       ASSIGN FRAME            = FRAME {&FRAME-NAME}:handle
              ROW              = 2.5
              COL              = 1.5
              WIDTH-CHARS      = FRAME {&FRAME-NAME}:WIDTH-CHARS - 2
              HEIGHT-PIXELS    = FRAME {&FRAME-NAME}:HEIGHT-PIXELS - 40
              SEPARATORS       = TRUE
              ROW-MARKERS      = FALSE
              EXPANDABLE       = TRUE
              COLUMN-RESIZABLE = TRUE
              COLUMN-SCROLLING = TRUE
              ALLOW-COLUMN-SEARCHING = TRUE
              READ-ONLY        = NO
              QUERY            = ghQuery
              name             = 'LookupFilterBrowser':u
        TRIGGERS:            
          ON 'row-leave':U
            PERSISTENT RUN rowLeave IN THIS-PROCEDURE.
          ON 'page-up':U
            PERSISTENT RUN pageUp IN THIS-PROCEDURE.
          ON 'page-down':U
            PERSISTENT RUN pageDown IN THIS-PROCEDURE.
        end TRIGGERS.

ASSIGN
  buApply:COL = FRAME {&FRAME-NAME}:WIDTH-CHARS - buApply:WIDTH-CHARS - 1
  buClear:COL = FRAME {&FRAME-NAME}:WIDTH-CHARS - buApply:WIDTH-CHARS - buClear:WIDTH-CHARS - 2
  .

/* Hide the browse while it is repopulated to avoid flashing */
ghBrowse:HIDDEN = YES.
ghBrowse:SENSITIVE = NO.

/* Add fields to browser */
DO iLoop = 1 TO 5:
  hCurField = ghBuffer:BUFFER-FIELD(iLoop).

  CASE iLoop:
    WHEN 1 THEN
      ASSIGN
        hCurField:FORMAT = "x(35)":U
        hCurField:LABEL = "Filter field":U
        .
    WHEN 2 THEN
      ASSIGN
        hCurField:FORMAT = "x(35)":U
        hCurField:LABEL = "From value":U
        .
    WHEN 3 THEN
      ASSIGN
        hCurField:FORMAT = "x(35)":U
        hCurField:LABEL = "To value":U
        .
    WHEN 4 THEN
      ASSIGN
        hCurField:FORMAT = "x(35)":U
        hCurField:LABEL = "Format":U
        .
    WHEN 5 THEN
      ASSIGN
        hCurField:FORMAT = "x(20)":U
        hCurField:LABEL = "Data type":U
        .
  END CASE.

  hField = ghBrowse:ADD-LIKE-COLUMN(hCurField).

  IF iLoop = 2 OR iLoop = 3 THEN
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

ghBrowse:NUM-LOCKED-COLUMNS = 1.

/* Now open the query */
ghQuery:QUERY-OPEN().

/* And show the browse to the user */
FRAME {&FRAME-NAME}:HIDDEN = YES.
ghBrowse:HIDDEN = NO.
ghBrowse:SENSITIVE = YES.

/* /* Reposition to current record in browse - if in data set */ */
/* IF ttLookCtrl.cRowIdent <> "":U AND                           */
/*    NOT ttLookCtrl.cRowIdent BEGINS "?":U THEN                 */
/*   RUN repositionBrowse (INPUT ttLookCtrl.cRowIdent).          */
/*                                                               */

RELEASE ttLookCtrl.

/* Translate Browse labels */
{get LogicalObjectName cObjectName}.
RUN translateBrowseColumns IN hSDF (INPUT cObjectName, 
                                    INPUT ghBrowse).

APPLY "ENTRY":U TO ghBrowse.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject sObject 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI sObject  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE hideObject sObject 
PROCEDURE hideObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.
  
  glObjectVisible = FALSE.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject sObject 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Code placed here will execute AFTER standard behavior.    */
  DEFINE VARIABLE cLinkHandles              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainerSource          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hToolbarSource            AS HANDLE     NO-UNDO.

  /* Get handle of container, then get toolbar source of contaner which will give
     us the containers toolbar.
     We then subscribe this procedure to toolbar events in the containers toolbar so
     that we can action an OK or CANCEL being pressed in the toolbar.
  */

  &IF DEFINED(UIB_IS_RUNNING) = 0 &THEN

    {get ContainerSource hContainerSource}.
    ghMaintToolbar = WIDGET-HANDLE(DYNAMIC-FUNCTION("LinkHandles":U IN hContainerSource, "tableio-source":U)).

/*     cLinkHandles = DYNAMIC-FUNCTION('linkHandles' IN hContainerSource, 'Toolbar-Source'). */
/*     hToolbarSource = WIDGET-HANDLE(ENTRY(1,cLinkHandles)).                                */
/*     SUBSCRIBE PROCEDURE THIS-PROCEDURE TO 'toolbar' IN hToolbarSource.                    */

    /* subscribe to procedure to build filters */
    SUBSCRIBE PROCEDURE THIS-PROCEDURE TO 'buildFilters' IN hContainerSource.

  &ENDIF

  RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PageDown sObject 
PROCEDURE PageDown :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pageUp sObject 
PROCEDURE pageUp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject sObject 
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
      lPreviouslyHidden                = FRAME {&FRAME-NAME}:HIDDEN
      FRAME {&FRAME-NAME}:SCROLLABLE   = FALSE
      FRAME {&FRAME-NAME}:HIDDEN       = TRUE
      FRAME {&FRAME-NAME}:HEIGHT-CHARS = pdHeight
      FRAME {&FRAME-NAME}:WIDTH-CHARS  = pdWidth  NO-ERROR.

  IF VALID-HANDLE(ghBrowse) THEN
    ASSIGN
        ghBrowse:WIDTH-CHARS   = FRAME {&FRAME-NAME}:WIDTH-CHARS   - 2
        ghBrowse:HEIGHT-PIXELS = FRAME {&FRAME-NAME}:HEIGHT-PIXELS - 40.

  ASSIGN
    buApply:COL = FRAME {&FRAME-NAME}:WIDTH-CHARS - buApply:WIDTH-CHARS - 1
    buClear:COL = FRAME {&FRAME-NAME}:WIDTH-CHARS - buApply:WIDTH-CHARS - buClear:WIDTH-CHARS - 2.

  APPLY "end-resize":U TO FRAME {&FRAME-NAME}.
  
  FRAME {&FRAME-NAME}:HIDDEN = lPreviouslyHidden NO-ERROR.

  IF VALID-HANDLE(ghMaintToolbar) AND glObjectVisible THEN
    RUN hideObject IN ghMaintToolbar.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowLeave sObject 
PROCEDURE rowLeave :
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
          hField = hCol:BUFFER-FIELD.
      /* if buff-field-hdl is unknown, this is a calculated field
            and cannot be updated */
          IF hField NE ? THEN
              hField:BUFFER-VALUE = hCol:SCREEN-VALUE.
      END.
  END.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sendTable sObject 
PROCEDURE sendTable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER TABLE FOR ttLookFilt.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateFilterData sObject 
PROCEDURE updateFilterData :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is called from rylookupbv.w's RepositionBrowse
               since in some cases we need to set a filter automatically and
               this also needs to update the filter browser
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER TABLE FOR ttLookFilt.
  
  ghQuery:QUERY-OPEN().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateFilter sObject 
PROCEDURE validateFilter :
/*------------------------------------------------------------------------------
  Purpose:     Validate filter settings
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER lOk AS LOGICAL NO-UNDO.

DEFINE VARIABLE cErrorMessage   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cButton         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE dDecimal        AS DECIMAL      NO-UNDO.
DEFINE VARIABLE tDateFrom       AS DATE         NO-UNDO.
DEFINE VARIABLE tDateTo         AS DATE         NO-UNDO.

ASSIGN lOk = YES.

filter-loop:
FOR EACH ttLookFilt:

  IF ttLookFilt.cFromValue <> "":U OR ttLookFilt.cToValue <> "":U THEN
  DO:
    CASE ttLookFilt.cFieldDataType:
      WHEN "decimal":U OR WHEN "integer":U THEN
      DO:
        ASSIGN 
            dDecimal = DECIMAL(ttLookFilt.cFromValue)
            dDecimal = DECIMAL(ttLookFilt.cToValue) NO-ERROR.

        IF  ERROR-STATUS:ERROR THEN
        DO:
          ASSIGN
              cErrorMessage = "Invalid data type for " + ttLookFilt.cFieldName + ".  Should be " + ttLookFilt.cFieldDataType + "."
              lOk           = NO.
        END.
        ELSE IF  ttLookFilt.cToValue <> "":U
        AND DECIMAL(ttLookFilt.cFromValue) > DECIMAL(ttLookFilt.cToValue) THEN
          ASSIGN
              cErrorMessage = {af/sup2/aferrortxt.i 'AF' '33' '?' '?' "'to value'" "'the from value'"}
              lOk           = NO.
      END.

      WHEN "date":U THEN
      DO:
        ASSIGN 
            tDateFrom = DATE(ttLookFilt.cFromValue)
            tDateTo   = DATE(ttLookFilt.cToValue) NO-ERROR.

        IF  ERROR-STATUS:ERROR
        OR  (tDateFrom = ? AND ttLookFilt.cFromValue <> "")
        OR  (tDateTo = ?   AND ttLookFilt.cToValue   <> "":U) THEN
        DO:
          ASSIGN
              cErrorMessage = "Invalid data type for " + ttLookFilt.cFieldName + ".  Should be " + ttLookFilt.cFieldDataType + "."
              lOk           = NO.

        END.
        ELSE IF  ttLookFilt.cToValue <> "":U
        AND DATE(ttLookFilt.cFromValue) > DATE(ttLookFilt.cToValue) THEN
          ASSIGN
              cErrorMessage = {af/sup2/aferrortxt.i 'AF' '33' '?' '?' "'to value'" "'the from value'"}
              lOk = NO.
      END.
      OTHERWISE
      DO: /* character, &c. */
        IF  ttLookFilt.cToValue <> "":U
        AND ttLookFilt.cFromValue > ttLookFilt.cToValue THEN
          ASSIGN
              cErrorMessage = {af/sup2/aferrortxt.i 'AF' '33' '?' '?' "'to value '" "'the from value'"}
              lOk           = NO.
      END.

    END CASE.
  END.

  IF NOT lOk THEN LEAVE filter-loop.

END.  /* filter-loop: Each filter setting */

IF NOT lOk THEN
DO:
  RUN showMessages IN gshSessionManager (INPUT  cErrorMessage,    /* messages */
                                         INPUT  "":U,             /* type */
                                         INPUT  "OK":U,           /* button list */
                                         INPUT  "OK":U,           /* default */
                                         INPUT  "OK":U,           /* cancel */
                                         INPUT  "":U,             /* title */
                                         INPUT  YES,              /* disp. empty */
                                         INPUT  ?,                /* container handle */
                                         OUTPUT cButton           /* button pressed */
                                        ).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewObject sObject 
PROCEDURE viewObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  IF VALID-HANDLE(ghBrowse) THEN
  DO:
    ghBrowse:REPOSITION-TO-ROW(1) NO-ERROR.
    APPLY "ENTRY":U TO ghBrowse.
  END.
  IF VALID-HANDLE(ghMaintToolbar) THEN
    RUN hideObject IN ghMaintToolbar.
  glObjectVisible = TRUE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

