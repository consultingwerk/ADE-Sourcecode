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
  File: rylookupbv.w

  Description:  Lookup Browser Viewer

  Purpose:      Lookup Browser Viewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        7065   UserRef:    
                Date:   16/11/2000  Author:     Anthony Swindells

  Update Notes: Astra 2 dynamic lookups

  (v:010002)    Task:        7507   UserRef:    
                Date:   09/01/2001  Author:     Chris Koster

  Update Notes: The change for the previous version was to implement a hook for calculated
                columns in the lookup's browser.

                This version was purely to add the note which I forgot to add in the previous
                version

  (v:010007)    Task:        8143   UserRef:    
                Date:   14/03/2001  Author:     Chris Koster

  Update Notes: If a user double-clicks on the viewer, message the lookup's query string

    Modified    : 10/25/2001         Mark Davies (MIP)
                  1. If the key field was an integer value and user left the
                     field, the value is not auto completed and did not launch
                     the browser. This was a result of defaulting to a 'BEGINS'
                     function in the query for all data types.
                  2. Remove references to KeyFieldValue and SavedScreenValue

  (v:010008)    Task:           0   UserRef:    
                Date:   10/30/2001  Author:     Mark Davies (MIP)

  Update Notes: When launching an SDO for maintenance purpose, make sure that the SDO is concatenated with its extension if it is specified in the object_extenstion field.

  (v:010009)    Task:           0   UserRef:    
                Date:   11/17/2001  Author:     Mark Davies (MIP)

  Update Notes: Enable calculated columns.

  (v:010010)    Task:           0   UserRef:    
                Date:   11/26/2001  Author:     Mark Davies (MIP)

  Update Notes: Fix for issue #3284 - The bottom border of the folder in Look up is missing

  (v:010011)    Task:           0   UserRef:    
                Date:   01/10/2002  Author:     Mark Davies (MIP)

  Update Notes: Filtering was not set correctly when initializing SDO for maintenance.

  (v:010012)    Task:           0   UserRef:    
                Date:   01/21/2002  Author:     Mark Davies (MIP)

  Update Notes: Fix for issue #3391 - Dynamic Lookup Maintenance functionality gives errors

  (v:010013)    Task:           0   UserRef:    
                Date:   02/11/2002  Author:     Mark Davies (MIP)

  Update Notes: Fix for issue #3869 - HIGH-CHARACTER preprocessor is wrong
                Replace HIGH-CHARACTER preprocessor value with value retreived
                from function getHighKey in general manager.

  (v:010014)    Task:           0   UserRef:    
                Date:   03/06/2002  Author:     Mark Davies (MIP)

  Update Notes: Fix for issue #3717 - Dynamic Lookup Browser inherits dictionary validation

  (v:010015)    Task:           0   UserRef:    
                Date:   08/23/2002  Author:     Mark Davies (MIP)

  Update Notes: Fix for issue #5848 - Errors launching Dyn Lookup Maintenance Container

----------------------------------------------------------------------*/
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

&scop object-name       rylookupbv.w
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
DEFINE VARIABLE ghBrowse                    AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghQuery                     AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghTable                     AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghBuffer                    AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghSDF                       AS HANDLE     NO-UNDO.
DEFINE VARIABLE glSelectionMade             AS LOGICAL    NO-UNDO.
DEFINE VARIABLE gcToolbarSource             AS CHARACTER  NO-UNDO.

DEFINE VARIABLE gcMaintenanceObject         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ghMaintToolbar              AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghSDOHandle                 AS HANDLE     NO-UNDO.
DEFINE VARIABLE grLastSelectedRowId         AS ROWID      NO-UNDO.
DEFINE VARIABLE gcCurrentMode               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ghGATarget                  AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghFolderHandle              AS HANDLE     NO-UNDO.

/*Calculate Columns*/
DEFINE VARIABLE gcCalcColumnHandles AS CHARACTER NO-UNDO.
DEFINE VARIABLE ghViewerHandle      AS HANDLE    NO-UNDO.
DEFINE VARIABLE gcNonCalcColumns    AS CHARACTER NO-UNDO.
DEFINE VARIABLE ghMaintObject       AS HANDLE    NO-UNDO.

DEFINE VARIABLE glUseNewAPI       AS LOGICAL     NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS fiRowsToBatch 
&Scoped-Define DISPLAYED-OBJECTS fiRowsToBatch fiNumRecs ToComplete 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD evaluateOuterJoins sObject 
FUNCTION evaluateOuterJoins RETURNS CHARACTER
  (pcQueryString  AS CHARACTER,
   pcFilterFields AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE fiNumRecs AS INTEGER FORMAT "->>>>>>>9":U INITIAL 0 
     LABEL "Records Read" 
     VIEW-AS FILL-IN 
     SIZE 15.2 BY 1 TOOLTIP "Number of records read so far" NO-UNDO.

DEFINE VARIABLE fiRowsToBatch AS INTEGER FORMAT "->>>>>9":U INITIAL 0 
     LABEL "Records to retrieve" 
     VIEW-AS FILL-IN 
     SIZE 13.2 BY 1 TOOLTIP "Specify number of records to read in each batch" NO-UNDO.

DEFINE VARIABLE ToComplete AS LOGICAL INITIAL no 
     LABEL "Query Complete" 
     VIEW-AS TOGGLE-BOX
     SIZE 27.2 BY .81 TOOLTIP "All records in query retrieved" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     fiRowsToBatch AT ROW 1.1 COL 18.2 COLON-ALIGNED
     fiNumRecs AT ROW 1.1 COL 46.8 COLON-ALIGNED
     ToComplete AT ROW 1.19 COL 66.2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 115.8 BY 11.38.


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
         HEIGHT             = 11.38
         WIDTH              = 115.8.
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

/* SETTINGS FOR FILL-IN fiNumRecs IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX ToComplete IN FRAME frMain
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME frMain
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL frMain sObject
ON MOUSE-SELECT-DBLCLICK OF FRAME frMain
DO:
  IF DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE, INPUT "_debug_tools_on":U) = "YES":U THEN
  DO:
    FIND FIRST ttLookCtrl NO-LOCK.
    MESSAGE ttLookCtrl.cBaseQueryString.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK sObject 


/* ***************************  Main Block  *************************** */
glUseNewAPI = NOT (DYNAMIC-FUNCTION('getSessionParam':U IN TARGET-PROCEDURE,
                                    'keep_old_field_api':U) = 'YES':U).

/* If testing in the UIB, initialize the SmartObject. */  
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
  RUN initializeObject.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addRecord sObject 
PROCEDURE addRecord :
/*------------------------------------------------------------------------------
  Purpose:     Launch the maintenance object when selecting Add
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  RUN toolbar (INPUT "Add":U).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyEntry sObject 
PROCEDURE applyEntry :
/*------------------------------------------------------------------------------
  Purpose:     Super Override to give browser focus if called with ?    
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcField AS CHARACTER NO-UNDO.
  IF pcfield = ? AND VALID-HANDLE(ghBrowse) THEN 
    APPLY 'ENTRY':U TO ghBrowse.
  ELSE 
    RUN SUPER(pcField).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyFilters sObject 
PROCEDURE applyFilters :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to appy filters from filter window
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER TABLE FOR ttLookFilt.

DEFINE VARIABLE cFilterFields               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFilterValues               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFilterTypes                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFilterOperators            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop                       AS INTEGER    NO-UNDO.
DEFINE VARIABLE cParentFilterQuery          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cHighChar                   AS CHARACTER  NO-UNDO.

cHighChar = DYNAMIC-FUNCTION("getHighKey":U IN gshGenManager, SESSION:CPCOLL).
filter-loop:
FOR EACH ttLookFilt:
  IF ttLookFilt.cFromValue = "":U AND
     ttLookFilt.cToValue = "":U  THEN NEXT filter-loop.

  IF ttLookFilt.cFromValue <> "":U THEN
  DO:
    ASSIGN
      iLoop = iLoop + 1
      cFilterFields = cFilterFields +
                      (IF iLoop = 1 THEN "":U ELSE ",":U) +
                      ttLookFilt.cFieldName
      cFilterTypes = cFilterTypes +
                      (IF iLoop = 1 THEN "":U ELSE ",":U) +
                      ttLookFilt.cFieldDataType
      cFilterOperators = cFilterOperators +
                      (IF iLoop = 1 THEN "":U ELSE ",":U) +
                      ">=":U
      cFilterValues = cFilterValues +
                      (IF iLoop = 1 THEN "":U ELSE CHR(1)) +
                      ttLookFilt.cFromValue
      .
  END.
  IF ttLookFilt.cToValue <> "":U THEN
  DO:
    ASSIGN
      iLoop = iLoop + 1
      cFilterFields = cFilterFields +
                      (IF iLoop = 1 THEN "":U ELSE ",":U) +
                      ttLookFilt.cFieldName
      cFilterTypes = cFilterTypes +
                      (IF iLoop = 1 THEN "":U ELSE ",":U) +
                      ttLookFilt.cFieldDataType
      cFilterOperators = cFilterOperators +
                      (IF iLoop = 1 THEN "":U ELSE ",":U) +
                      "<=":U
      cFilterValues = cFilterValues +
                      (IF iLoop = 1 THEN "":U ELSE CHR(1)) +
                      ttLookFilt.cToValue
      .
      IF ttLookFilt.cFieldDataType = "Character":U THEN cFilterValues = cFilterValues + cHighChar.
  END.

END.

/* /* no filters set */           */
/* IF cFilterFields = "":U THEN   */
/* DO:                            */
/*   APPLY "entry":U TO ghBrowse. */
/*   RETURN.                      */
/* END.                           */
/*                                */
/* get rid of batch position and change filter criteria */
FIND FIRST ttLookCtrl.
ASSIGN
  ttLookCtrl.iFirstRowNum = 0
  ttLookCtrl.iLastRowNum = 0
  ttLookCtrl.cFirstResultRow = "":U
  ttLookCtrl.cLastResultRow = "":U
  ttLookCtrl.cRowIdent = "":U
  .

/* Set up query with filtered where clause */
ttLookCtrl.cBaseQueryString = DYNAMIC-FUNCTION('newQueryString':U IN ghSDF,
                             cFilterFields,
                             cFilterValues,
                             cFilterTypes,
                             cFilterOperators,
                             ?,
                             ?).

/* See if criteria was specified on OUTER-JOINed tables and ammend the query string if necessary */
IF INDEX(ttLookCtrl.cBaseQueryString, "OUTER-JOIN":U) <> 0 THEN
  ttLookCtrl.cBaseQueryString = DYNAMIC-FUNCTION("evaluateOuterJoins":U, INPUT ttLookCtrl.cBaseQueryString, cFilterFields).

/* Set Parent-Child filter */
RUN returnParentFieldValues IN ghSDF (OUTPUT cParentFilterQuery).

IF cParentFilterQuery <> "":U THEN DO:
  IF NUM-ENTRIES(cParentFilterQuery,"|":U) > 1 AND 
     NUM-ENTRIES(ttLookCtrl.cQueryTables) > 1 THEN DO:
    DO iLoop = 1 TO NUM-ENTRIES(cParentFilterQuery,"|":U):
      IF TRIM(ENTRY(iLoop,cParentFilterQuery,"|":U)) <> "":U THEN
        ttLookCtrl.cBaseQueryString = DYNAMIC-FUNCTION("newWhereClause" IN ghSDF,
                                     ENTRY(iLoop,ttLookCtrl.cQueryTables),
                                     ENTRY(iLoop,cParentFilterQuery,"|":U),
                                     ttLookCtrl.cBaseQueryString,
                                     "AND":U).
    END.
  END.
  ELSE
      ttLookCtrl.cBaseQueryString = DYNAMIC-FUNCTION("newWhereClause" IN ghSDF,
                                   ENTRY(NUM-ENTRIES(ttLookCtrl.cQueryTables),ttLookCtrl.cQueryTables),
                                   cParentFilterQuery,
                                   ttLookCtrl.cBaseQueryString,
                                   "AND":U).
END.

RELEASE ttLookCtrl.

/* get records into temp-table */
RUN af/app/afgettempp.p  ON gshAstraAppserver (INPUT-OUTPUT TABLE ttLookCtrl,
                                               OUTPUT TABLE-HANDLE ghTable).
FIND FIRST ttLookCtrl.

DO WITH FRAME {&FRAME-NAME}:
  toComplete:SCREEN-VALUE = STRING(ttLookCtrl.iLastRowNum <> 0).
  fiNumRecs:SCREEN-VALUE = ENTRY(1,ttLookCtrl.cLastResultRow,";":U).
END.

/* refresh query */
ghBrowse:REFRESHABLE = NO.

IF ttLookCtrl.cLastResultRow <> "":U THEN
  ghBrowse:MAX-DATA-GUESS = INTEGER(ENTRY(1,ttLookCtrl.cLastResultRow,";":U)).

IF ghQuery:IS-OPEN THEN ghQuery:QUERY-CLOSE().
ghQuery:QUERY-OPEN().
ghBrowse:REFRESHABLE = YES.

ghQuery:REPOSITION-TO-ROW(1) NO-ERROR.
APPLY "entry":U TO ghBrowse.

RUN refreshLookup.
RUN setToolbarState.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE browseEnd sObject 
PROCEDURE browseEnd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE browseHome sObject 
PROCEDURE browseHome :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE browseOffEnd sObject 
PROCEDURE browseOffEnd :
/*------------------------------------------------------------------------------
  Purpose:     If no reached end of result set, get more records
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND FIRST ttLookCtrl.
IF ttLookCtrl.iLastRowNum > 0 THEN RETURN.    /* No more records */

DO WITH FRAME {&FRAME-NAME}:
  ASSIGN
    fiRowsToBatch
    ttLookCtrl.iRowsToBatch = fiRowsToBatch
    .
END.

DEFINE VARIABLE cRowIdent AS CHARACTER NO-UNDO.
IF NUM-ENTRIES(ttLookCtrl.cLastResultRow,";":U) > 1 THEN
  ASSIGN cRowIdent = ENTRY(2, ttLookCtrl.cLastResultRow,";":U). 

/* get more records and append to temp-table */
RUN af/app/afgettempp.p  ON gshAstraAppserver (INPUT-OUTPUT TABLE ttLookCtrl,
                                               OUTPUT TABLE-HANDLE ghTable APPEND).
FIND FIRST ttLookCtrl.

DO WITH FRAME {&FRAME-NAME}:
  toComplete:SCREEN-VALUE = STRING(ttLookCtrl.iLastRowNum <> 0).
  fiNumRecs:SCREEN-VALUE = ENTRY(1,ttLookCtrl.cLastResultRow,";":U).
END.

/* refresh query */
ghBrowse:REFRESHABLE = NO.

IF ttLookCtrl.cLastResultRow <> "":U THEN
  ghBrowse:MAX-DATA-GUESS = INTEGER(ENTRY(1,ttLookCtrl.cLastResultRow,";":U)).

IF ghQuery:IS-OPEN THEN ghQuery:QUERY-CLOSE().
ghQuery:QUERY-OPEN().
ghBrowse:REFRESHABLE = YES.

/* Reposition to current record in browse */
IF cRowIdent <> "":U AND 
   NOT cRowIdent BEGINS "?":U THEN
  RUN repositionBrowse (INPUT cRowIdent).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE browseOffHome sObject 
PROCEDURE browseOffHome :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildBrowser sObject 
PROCEDURE buildBrowser :
/*------------------------------------------------------------------------------
  Purpose:     Construct dynamic data browser onto viewer
  Parameters:  input handle of lookup SDF
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER hSDF AS HANDLE NO-UNDO.

SESSION:SET-WAIT-STATE("general":U).

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
DEFINE VARIABLE cFilterValue              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectName               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cParentFilterQuery        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLinkHandles              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFieldName                AS CHARACTER  NO-UNDO.

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
  ttLookCtrl.cDisplayValue = cValue
  ttLookCtrl.cRowIdent = DYNAMIC-FUNCTION('getRowIdent':U IN hSDF)
  ttLookCtrl.iFirstRowNum = 0
  ttLookCtrl.iLastRowNum = 0
  ttLookCtrl.cFirstResultRow = "":U
  ttLookCtrl.cLastResultRow = "":U
  ttLookCtrl.cColumnLabels  = DYNAMIC-FUNCTION('getColumnLabels':U IN hSDF)
  ttLookCtrl.cColumnFormat  = DYNAMIC-FUNCTION('getColumnFormat':U IN hSDF)
  ttLookCtrl.cPhysicalTableNames = DYNAMIC-FUNCTION('getPhysicalTableNames':U IN hSDF)
  ttLookCtrl.cTempTableNames = DYNAMIC-FUNCTION('getTempTables':U IN hSDF)
  .

/* Set filter on entered value */
IF glUseNewAPI THEN
DO:
  IF cFilterValue > "":U THEN
     ttLookCtrl.cBaseQueryString = {fnarg buildSearchQuery cFilterValue hSDF}.
  ELSE 
     ttLookCtrl.cBaseQueryString = {fn buildQuery hSDF}.
END.
ELSE DO:
  IF cFilterValue > "":U THEN
  DO:
    CASE ttLookCtrl.cDisplayDataType:
      WHEN "CHARACTER":U THEN
        /* Set up where clause for key field equal to current value of key field */
        ttLookCtrl.cBaseQueryString = DYNAMIC-FUNCTION('newQueryString':U IN hSDF,
                                                       ttLookCtrl.cDisplayedField,
                                                       cFilterValue,
                                                       ttLookCtrl.cDisplayDataType,
                                                       "BEGINS":U,
                                                       ?,
                                                       ?).
      WHEN "LOGICAL":U THEN /* Don't think there will be one like this - just incase */
        /* Set up where clause for key field equal to current value of key field */
        ttLookCtrl.cBaseQueryString = DYNAMIC-FUNCTION('newQueryString':U IN hSDF,
                                     ttLookCtrl.cDisplayedField,
                                     cFilterValue,
                                     cDisplayDataType,
                                     "=":U,
                                     ?,
                                     ?).
      OTHERWISE DO:
        /* Set up where clause for key field equal to current value of key field */
        ttLookCtrl.cBaseQueryString = DYNAMIC-FUNCTION('newQueryString':U IN hSDF,
                                     ttLookCtrl.cDisplayedField,
                                     cFilterValue,
                                     cDisplayDataType,
                                     ">=":U,
                                     ?,
                                     ?).
        ttLookCtrl.cBaseQueryString = DYNAMIC-FUNCTION("newWhereClause" IN hSDF,
                                     (IF LOOKUP(ENTRY(1,ttLookCtrl.cDisplayedField,".":U),cQueryTables) > 0 THEN ENTRY(LOOKUP(ENTRY(1,ttLookCtrl.cDisplayedField,".":U),cQueryTables),cQueryTables) ELSE ENTRY(NUM-ENTRIES(cQueryTables),cQueryTables)),
                                     (ttLookCtrl.cDisplayedField + " <= '" + cFilterValue + "'"),
                                     ttLookCtrl.cBaseQueryString,
                                     "AND":U).
      END.
    END CASE.
  END.
  
  /* Set Parent-Child filter */
  RUN returnParentFieldValues IN hSDF (OUTPUT cParentFilterQuery).
  IF cParentFilterQuery <> "":U THEN DO:
    IF NUM-ENTRIES(cParentFilterQuery,"|":U) > 1 AND 
       NUM-ENTRIES(ttLookCtrl.cQueryTables) > 1 THEN DO:
      DO iLoop = 1 TO NUM-ENTRIES(cParentFilterQuery,"|":U):
        IF TRIM(ENTRY(iLoop,cParentFilterQuery,"|":U)) <> "":U THEN
          ttLookCtrl.cBaseQueryString = DYNAMIC-FUNCTION("newWhereClause" IN hSDF,
                                       ENTRY(iLoop,ttLookCtrl.cQueryTables),
                                       ENTRY(iLoop,cParentFilterQuery,"|":U),
                                       ttLookCtrl.cBaseQueryString,
                                       "AND":U).
      END.
    END.
    ELSE
        ttLookCtrl.cBaseQueryString = DYNAMIC-FUNCTION("newWhereClause" IN hSDF,
                                     ENTRY(NUM-ENTRIES(ttLookCtrl.cQueryTables),ttLookCtrl.cQueryTables),
                                     cParentFilterQuery,
                                     ttLookCtrl.cBaseQueryString,
                                     "AND":U).
  END. /* filtervalue > '' */
END. /*else (NOT glUseNewAPI ) */

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
         ttLookCtrl.cColumnFormat       = IF ttLookCtrl.cColumnFormat <> "":U THEN ttLookCtrl.cBrowseFieldFormats ELSE "":U.
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

RELEASE ttLookCtrl.

/* populate dynamic temp-table with 1st batch of records */
RUN af/app/afgettempp.p  ON gshAstraAppserver (INPUT-OUTPUT TABLE ttLookCtrl,
                                               OUTPUT TABLE-HANDLE hTH).
FIND FIRST ttLookCtrl.
ASSIGN ghTable = hTH.

DO WITH FRAME {&FRAME-NAME}:
  DISPLAY
    ttLookCtrl.iRowsToBatch @ fiRowsToBatch.
  toComplete:SCREEN-VALUE = STRING(ttLookCtrl.iLastRowNum <> 0).
  fiNumRecs:SCREEN-VALUE = ENTRY(1,ttLookCtrl.cLastResultRow,";":U).
END.

/* get buffer of temp-table */
ghbuffer = ghTable:DEFAULT-BUFFER-HANDLE.
/* CREATE BUFFER ghBuffer FOR TABLE ghTable BUFFER-NAME "RowObject":U. */

CREATE QUERY ghQuery.
ghQuery:ADD-BUFFER(ghBuffer).
ASSIGN cQuery = "FOR EACH ":U + ghBuffer:NAME + " NO-LOCK":U.
ghQuery:QUERY-PREPARE(cQuery).

/* Create the dynamic browser here */

/* make the viewer as big as it can be to fit on tab page */
DEFINE VARIABLE hWindow               AS HANDLE  NO-UNDO.
DEFINE VARIABLE hContainerSource      AS HANDLE  NO-UNDO.
DEFINE VARIABLE hFrame                AS HANDLE  NO-UNDO.
DEFINE VARIABLE lPreviouslyHidden     AS LOGICAL NO-UNDO.
DEFINE VARIABLE dHeight               AS DECIMAL NO-UNDO.
DEFINE VARIABLE dWidth                AS DECIMAL NO-UNDO.

{get ContainerSource      hContainerSource}.
{get ContainerHandle hWindow hContainerSource}.

FRAME {&FRAME-NAME}:HEIGHT-PIXELS = hWindow:HEIGHT-PIXELS - 70.
FRAME {&FRAME-NAME}:WIDTH-PIXELS = hWindow:WIDTH-PIXELS - 28.

{get FieldName cFieldName hSDF}.
/* The browser is created in a widget pool created in initializeLookup.
   This is to work around 20031119-043.  The widget pool is deleted
   when the lookup is destroyed. */
CREATE BROWSE ghBrowse IN WIDGET-POOL cFieldName + STRING(hSDF)
       ASSIGN FRAME            = FRAME {&FRAME-NAME}:HANDLE
              ROW              = 2.5
              COL              = 1.5
              WIDTH-CHARS      = FRAME {&FRAME-NAME}:WIDTH-CHARS - 2
              HEIGHT-PIXELS    = FRAME {&FRAME-NAME}:HEIGHT-PIXELS - 40
              SEPARATORS       = TRUE
              ROW-MARKERS      = FALSE
              EXPANDABLE       = TRUE
              COLUMN-RESIZABLE = TRUE
              ALLOW-COLUMN-SEARCHING = TRUE
              QUERY            = ghQuery
              name             = 'LookupDataBrowser':u
        TRIGGERS:            
          ON 'mouse-select-dblclick':U 
            PERSISTENT RUN toolbar IN THIS-PROCEDURE (INPUT "select":U).
          ON 'return':U 
            PERSISTENT RUN toolbar IN THIS-PROCEDURE (INPUT "select":U).
          ON 'end':U 
            PERSISTENT RUN browseEnd IN THIS-PROCEDURE.
          ON 'home':U 
            PERSISTENT RUN browseHome IN THIS-PROCEDURE.
          ON 'off-end':U 
            PERSISTENT RUN browseOffEnd IN THIS-PROCEDURE.
          ON 'off-home':U 
            PERSISTENT RUN browseOffHome IN THIS-PROCEDURE.
          ON 'start-search':U 
            PERSISTENT RUN startSearch IN THIS-PROCEDURE.
          ON 'ROW-DISPLAY':U 
            PERSISTENT RUN refreshLookup IN THIS-PROCEDURE.
        END TRIGGERS.

/* Hide the browse while it is repopulated to avoid flashing */
ghBrowse:HIDDEN = YES.
ghBrowse:SENSITIVE = NO.

/* Add field to browser */
DO iLoop = 1 TO NUM-ENTRIES(ttLookCtrl.cBrowseFields):
  cField = ENTRY(iLoop,ttLookCtrl.cBrowseFields).
  hCurField = ghBuffer:BUFFER-FIELD(ENTRY(1,cField,".":U) + "_":U + ENTRY(2,cField,".":U)).
  IF VALID-HANDLE(hCurField) THEN DO:
    gcNonCalcColumns = IF gcNonCalcColumns = "":U THEN hCurField:NAME ELSE gcNonCalcColumns + ",":U + hCurField:NAME.
    IF ttLookCtrl.cColumnFormat <> "":U AND
       ttLookCtrl.cColumnFormat <> ?    AND 
       NUM-ENTRIES(ttLookCtrl.cColumnFormat,"|":U) >= iLoop AND
       ENTRY(iLoop,ttLookCtrl.cColumnFormat,"|":U) <> "":U THEN
      hCurField:FORMAT = ENTRY(iLoop,ttLookCtrl.cColumnFormat,"|":U) NO-ERROR.
  END.
  
  hCurField:VALIDATE-EXPRESSION = "":U.
  hField = ghBrowse:ADD-LIKE-COLUMN(hCurField).
  /* Build up the list of browse columns for use in rowDisplay */
  IF VALID-HANDLE(hField) THEN DO:
    cBrowseColHdls = cBrowseColHdls + (IF cBrowseColHdls = "":U THEN "":U ELSE ",":U) 
                     + STRING(hField).
    IF ttLookCtrl.cColumnLabels <> "":U AND
       ttLookCtrl.cColumnLabels <> ?    AND 
       NUM-ENTRIES(ttLookCtrl.cColumnLabels) >= iLoop AND
       ENTRY(iLoop,ttLookCtrl.cColumnLabels) <> "":U THEN
      hField:LABEL = ENTRY(iLoop,ttLookCtrl.cColumnLabels).
  END.

END.

ghBrowse:NUM-LOCKED-COLUMNS = 1.

/* Hooks for Calculated Columns */
{get ContainerSource ghViewerHandle ghSDF}.
PUBLISH "getBrowseCalcColumns":U FROM ghViewerHandle (INPUT ghBrowse, INPUT ghSDF, OUTPUT gcCalcColumnHandles).
/* End of Calculated Column Hooks */

/* Now open the query */
ghQuery:QUERY-OPEN().

/* And show the browse to the user */
ghBrowse:HIDDEN = NO.
ghBrowse:SENSITIVE = YES.

/* /* Reposition to current record in browse - if in data set */ */
/* IF ttLookCtrl.cRowIdent <> "":U AND                           */
/*    NOT ttLookCtrl.cRowIdent BEGINS "?":U THEN                 */
/*   RUN repositionBrowse (INPUT ttLookCtrl.cRowIdent).          */
/*                                                               */

/* Reposition always just to 1st row as we cannot always reposistion to actual
   row for large data sets
*/
DEFINE VARIABLE cRowIdent AS CHARACTER NO-UNDO.
IF NUM-ENTRIES(ttLookCtrl.cFirstResultRow,";":U) > 1 THEN
  ASSIGN cRowIdent = ENTRY(2, ttLookCtrl.cFirstResultRow,";":U). 
RUN repositionBrowse (INPUT cRowIdent).

RELEASE ttLookCtrl.

/* Translate Column Labels */
{get LogicalObjectName cObjectName}.
RUN translateBrowseColumns IN hSDF (INPUT cObjectName, 
                                    INPUT ghBrowse).
SESSION:SET-WAIT-STATE("":U).

cLinkHandles = DYNAMIC-FUNCTION('linkHandles' IN THIS-PROCEDURE, 'GroupAssign-Target').
IF cLinkHandles <> "":U THEN
  ghGATarget = WIDGET-HANDLE(ENTRY(1,cLinkHandles)).

gcMaintenanceObject = DYNAMIC-FUNCTION('getMaintenanceObject':U IN hSDF).

IF gcMaintenanceObject <> "":U THEN
  RUN setToolbarState.
ELSE DO:  
  IF VALID-HANDLE(ghMaintToolbar) THEN
    RUN destroyObject IN ghMaintToolbar.
  ghMaintToolbar = ?.
END.

/* Set the handle of the target procedure as BrowseObject in the SDF */
{set BrowseObject TARGET-PROCEDURE hSDF}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyRecord sObject 
PROCEDURE copyRecord :
/*------------------------------------------------------------------------------
  Purpose:     Launch the maintenance object when selecting Copy
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  RUN toolbar (INPUT "Copy":U).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataAvailable sObject 
PROCEDURE dataAvailable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcRelative  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cKeyField   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValueList  AS CHARACTER  NO-UNDO.

  IF NOT VALID-HANDLE(ghSDOHandle) THEN
    RETURN.
  
  /* Reposition Lookup Browse to Record Selected In SDO */
  IF pcRelative = "NEXT":U OR
     pcRelative = "PREV":U OR
     pcRelative = "FIRST":U OR
     pcRelative = "LAST":U THEN DO:
    FIND FIRST ttLookCtrl NO-ERROR.
    IF AVAILABLE ttLookCtrl THEN
      cKeyField = ENTRY(2,ttLookCtrl.cKeyField,".":U).
    IF cKeyField <> "":U THEN
      cValueList = DYNAMIC-FUNCTION("colValues":U IN ghSDOHandle, cKeyField).
    IF cValueList = ? OR
       cValueList = "":U THEN
      grLastSelectedRowId = ?.
    ELSE
      grLastSelectedRowId = TO-ROWID(ENTRY(2,ENTRY(1,cValueList,CHR(1)))).
    IF grLastSelectedRowId <> ? THEN
      RUN repositionBrowse (INPUT STRING(grLastSelectedRowId)).
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyobject sObject 
PROCEDURE destroyobject :
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

PUBLISH "lookupExited":U FROM ghViewerHandle (INPUT ghSDF, INPUT glSelectionMade).


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableMaintenance sObject 
PROCEDURE enableMaintenance :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will extract the launch object information and
               launch the objects as required.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cLaunchSDO        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectName       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSDOHandle        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSDOAttributes    AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE hContainer        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFilterToValue    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWhere            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cHighChar         AS CHARACTER  NO-UNDO.

  cHighChar = DYNAMIC-FUNCTION("getHighKey":U IN gshGenManager, SESSION:CPCOLL).
  
  
  IF VALID-HANDLE(ghSDOHandle) THEN
    RETURN.
    
  {get ContainerSource hContainer}.
  
  IF NOT VALID-HANDLE(hContainer) OR
     NOT VALID-HANDLE(ghMaintToolbar) THEN
    RETURN.
  cLaunchSDO = DYNAMIC-FUNCTION('getMaintenanceSDO':U IN ghSDF).
  
  RUN startDataObject IN gshRepositoryManager (INPUT cLaunchSDO, OUTPUT hSDOHandle).

  IF RETURN-VALUE <> "":U THEN
    RETURN.

  IF VALID-HANDLE(hSDOHandle) THEN DO:
    DYNAMIC-FUNCTION("setRebuildOnRepos":U IN hSDOHandle, FALSE).
    DYNAMIC-FUNCTION("setRowsToBatch":U IN hSDOHandle, 1).
    DYNAMIC-FUNCTION("setObjectName":U IN hSDOHandle, cObjectName).
  END.
    
  IF VALID-HANDLE(hSDOHandle) THEN DO:
    ghSDOHandle = hSDOHandle.
    RUN addLink ( hContainer , 'PrimarySDO':U , hSDOHandle).
    IF VALID-HANDLE(ghMaintToolbar) THEN DO:
      RUN addLink ( ghMaintToolbar , 'Navigation':U , hSDOHandle).
      RUN addLink ( THIS-PROCEDURE, 'Toolbar':U , ghMaintToolbar).
    END.
    RUN initializeObject IN hSDOHandle.
    /* Set the SDO's query to be the same as the lookup's
       query with filter values */
    IF VALID-HANDLE(ghGATarget) THEN DO:
      RUN sendTable IN ghGATarget (OUTPUT TABLE ttLookFilt).
      FOR EACH ttLookFilt
          WHERE ttLookFilt.cFromValue <> "":U:
        IF ttLookFilt.cFieldDataType = "Character":U THEN 
          cFilterToValue = ttLookFilt.cToValue + cHighChar.
        ELSE
          cFilterToValue = ttLookFilt.cToValue.

        /* Set From Filter Value */
        DYNAMIC-FUNCTION("addQueryWhere":U IN hSDOHandle,INPUT ttLookFilt.cFieldName + " >= '" + ttLookFilt.cFromValue + "'", "":U, "AND":U).
        ASSIGN cWhere = ttLookFilt.cFieldName + " >= '" + ttLookFilt.cFromValue + "'" + CHR(3) + CHR(3) + "AND":U.
        {set manualAddQueryWhere cWhere hSDOHandle}.
        /* Set To Filter Value */
        DYNAMIC-FUNCTION("addQueryWhere":U IN hSDOHandle,INPUT ttLookFilt.cFieldName + " <= '" + cFilterToValue + "'", "":U, "AND":U).
        ASSIGN cWhere = ttLookFilt.cFieldName + " <= '" + cFilterToValue + "'" + CHR(3) + CHR(3) + "AND":U.
        {set manualAddQueryWhere cWhere hSDOHandle}.
      END.
      DYNAMIC-FUNCTION("openQuery":U IN hSDOHandle).
    END.
    SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "dataAvailable":U IN hSDOHandle.
    /*
    SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "updateState":U IN hSDOHandle.
    */
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getBrowseLabels sObject 
PROCEDURE getBrowseLabels :
/*------------------------------------------------------------------------------
  Purpose:     To return a comma list of browse labels for the filter window
  Parameters:  output browse labels
  Notes:       
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER pcLabels                AS CHARACTER  NO-UNDO.

DEFINE VARIABLE iLoop         AS INTEGER    NO-UNDO.
DEFINE VARIABLE hColumn       AS HANDLE     NO-UNDO.
DEFINE VARIABLE cLabel        AS CHARACTER  NO-UNDO.

IF NOT VALID-HANDLE(ghBrowse) THEN RETURN.
DO iLoop = 1 TO ghBrowse:NUM-COLUMNS:
  ASSIGN
    hColumn = ghBrowse:GET-BROWSE-COLUMN(iLoop).
  IF LOOKUP(hColumn:NAME,gcNonCalcColumns) > 0 THEN
    ASSIGN 
      cLabel =  hColumn:LABEL
      pcLabels = pcLabels +
                 (IF iLoop = 1 THEN "":U ELSE ",":U) +
                 (IF cLabel <> ? THEN cLabel ELSE "":U).
END.

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
    {get ContainerToolbarSource hToolbarSource  hContainerSource}.
    ghMaintToolbar = WIDGET-HANDLE(DYNAMIC-FUNCTION("LinkHandles":U IN hContainerSource, "tableio-source":U)).
    ghFolderHandle = WIDGET-HANDLE(DYNAMIC-FUNCTION("LinkHandles":U IN hContainerSource, "Page-Source":U)).
    
    IF VALID-HANDLE(ghMaintToolbar) THEN DO:
      RUN hideObject IN ghMaintToolbar.
      DYNAMIC-FUNCTION("setToolbarAutoSize":U IN ghMaintToolbar, FALSE).
      DYNAMIC-FUNCTION("setHideOnInit":U IN ghMaintToolbar, TRUE).
      SUBSCRIBE PROCEDURE THIS-PROCEDURE TO 'toolbar' IN ghMaintToolbar.
      SUBSCRIBE PROCEDURE THIS-PROCEDURE TO 'addRecord' IN ghMaintToolbar.
      SUBSCRIBE PROCEDURE THIS-PROCEDURE TO 'copyRecord' IN ghMaintToolbar.
    END.
    
    SUBSCRIBE PROCEDURE THIS-PROCEDURE TO 'toolbar' IN hToolbarSource.                    
    /* subscribe to procedure to build browser */
    SUBSCRIBE PROCEDURE THIS-PROCEDURE TO 'buildBrowser' IN hContainerSource.

  &ENDIF

  RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE moveToSDORecord sObject 
PROCEDURE moveToSDORecord :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will check the current selected record in the query, 
               and reposition the running SDO to that record.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRowIdent       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE rSelectedRowId  AS ROWID      NO-UNDO.
  DEFINE VARIABLE cField          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hField          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cValue          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cValueList      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWhere          AS CHARACTER  NO-UNDO.
  

  IF NOT VALID-HANDLE(ghSDOHandle) OR 
     gcCurrentMode = "add":U THEN
    RETURN.
    
  IF ghBuffer:AVAILABLE THEN DO: /* Return record selected */
    FIND FIRST ttLookCtrl NO-ERROR.
    IF AVAILABLE ttLookCtrl THEN
    DO:
      ASSIGN cValueList = "":U.
      DO iLoop = 1 TO NUM-ENTRIES(ttLookCtrl.cAllFields):
        ASSIGN
          cField = ENTRY(iLoop,ttLookCtrl.cAllFields)
          cField = REPLACE(cField,".":U,"_":U)
          hField = ghBuffer:BUFFER-FIELD(cField)
          cValue = STRING(hField:BUFFER-VALUE)
          cValueList = cValueList +
                       (IF iLoop = 1 THEN "":U ELSE CHR(1)) +
                       (IF cValue = ? THEN "":U ELSE cValue)
          .
      END.  /* all fields loop */
      ASSIGN hRowIdent  = ghBuffer:BUFFER-FIELD('RowIdent':U).
      rSelectedRowid = TO-ROWID(ENTRY(1,hRowIdent:BUFFER-VALUE)).
    END. /* available ttlookctrl */
  END. /* ghbuffer available */
  
  grLastSelectedRowId = rSelectedRowid.
  
  IF rSelectedRowid <> ? THEN
    DYNAMIC-FUNCTION("fetchRowIdent":U IN ghSDOhandle, STRING(rSelectedRowid),"":U) NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshLookup sObject 
PROCEDURE refreshLookup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValueList AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cField                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hField                    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLoop                     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cValue                    AS CHARACTER  NO-UNDO.

  IF TRIM(gcCalcColumnHandles) <> "":U AND
     TRIM(gcCalcColumnHandles) <> ?    AND
     ghBuffer:AVAILABLE               THEN
    DO: /* Return record selected */

      FIND FIRST ttLookCtrl NO-ERROR.
      IF AVAILABLE ttLookCtrl THEN
      DO:
        ASSIGN cValueList = "":U.
        DO iLoop = 1 TO NUM-ENTRIES(ttLookCtrl.cAllFields):
          ASSIGN
            cField = ENTRY(iLoop,ttLookCtrl.cAllFields)
            cField = REPLACE(cField,".":U,"_":U)
            hField = ghBuffer:BUFFER-FIELD(cField)
            cValue = STRING(hField:BUFFER-VALUE)
            cValueList = cValueList +
                         (IF iLoop = 1 THEN "":U ELSE CHR(1)) +
                         (IF cValue = ? THEN "":U ELSE cValue)
            .
        END.  /* all fields loop */

        PUBLISH "getBrowseCalcValues":U FROM ghViewerHandle (INPUT ttLookCtrl.cAllFields,
                                                             INPUT cValueList,
                                                             INPUT ghSDF,
                                                             INPUT gcCalcColumnHandles).
      END. /* available ttlookctrl */
    END. /* ghbuffer available */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionBrowse sObject 
PROCEDURE repositionBrowse :
/*------------------------------------------------------------------------------
  Purpose:     To position browser at specified record
  Parameters:  input comma list of database query rowids
  Notes:       Needs to cope with fetching rows if not in query and not at
               end of query
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pcRowIdent               AS CHARACTER  NO-UNDO.

DEFINE VARIABLE lOk                             AS LOGICAL    NO-UNDO.
DEFINE VARIABLE rRowid                          AS ROWID      NO-UNDO.
DEFINE VARIABLE hRowNum                         AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowIdent                       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowQuery                       AS HANDLE     NO-UNDO.
DEFINE VARIABLE iRowNum                         AS HANDLE     NO-UNDO.
DEFINE VARIABLE cRowIdent                       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cKeyField                       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cValueList                      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLinkHandles                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hFilter                         AS HANDLE     NO-UNDO.

FIND FIRST ttLookCtrl.

CREATE QUERY hRowQuery.     /* Get a query to do the "FIND" */
lOK = hRowQuery:SET-BUFFERS(ghBuffer).

IF lOK THEN
  lOK = hRowQuery:QUERY-PREPARE
     ('FOR EACH RowObject WHERE RowObject.RowIdent BEGINS "':U 
       + pcRowIdent + '"':U).

lOK = hRowQuery:QUERY-OPEN().
IF lOK THEN
  lOK = hRowQuery:GET-FIRST().

/* IF NOT ghBuffer:AVAILABLE AND ttLookCtrl.iLastRowNum = 0 THEN /* more records */     */
/* REPEAT WHILE NOT ghBuffer:AVAILABLE AND ttLookCtrl.iLastRowNum = 0:                  */
/*   /* get more records and append to temp-table */                                    */
/*   RUN af/app/afgettempp.p ON gshAstraAppserver (INPUT-OUTPUT TABLE ttLookCtrl,       */
/*                                                 OUTPUT TABLE-HANDLE ghTable APPEND). */
/*   FIND FIRST ttLookCtrl.                                                             */
/*                                                                                      */
/*   /* reset max data guess */                                                         */
/*   IF ttLookCtrl.cLastResultRow <> "":U THEN                                          */
/*     ghBrowse:MAX-DATA-GUESS = INTEGER(ENTRY(1,ttLookCtrl.cLastResultRow,";":U)).     */
/*                                                                                      */
/*   IF hRowQuery:IS-OPEN THEN hRowQuery:QUERY-CLOSE().                                 */
/*   lOK = hRowQuery:QUERY-OPEN().                                                      */
/*   IF lOK THEN                                                                        */
/*     lOK = hRowQuery:GET-FIRST().                                                     */
/* END.                                                                                 */

IF ghBuffer:AVAILABLE THEN
DO:
  ASSIGN rRowid     = ghBuffer:ROWID
         hRowNum    = ghBuffer:BUFFER-FIELD('RowNum':U)
         hRowIdent  = ghBuffer:BUFFER-FIELD('RowIdent':U)
         iRowNum = hRowNum:BUFFER-VALUE
         cRowIdent = hRowIdent:BUFFER-VALUE
         .
  lOK = ghQuery:REPOSITION-TO-ROWID(rRowid) NO-ERROR.

END.
ELSE DO:
  IF VALID-HANDLE(ghSDOHandle) THEN DO:
    FIND FIRST ttLookFilt
         WHERE ttLookFilt.cFieldName = ttLookCtrl.cKeyField
         NO-LOCK NO-ERROR.
    
    cKeyField = ENTRY(2,ttLookCtrl.cKeyField,".":U).
    IF cKeyField <> "":U THEN 
      cValueList = DYNAMIC-FUNCTION("colValues":U IN ghSDOHandle, cKeyField).
    
    IF AVAILABLE ttLookFilt THEN DO:
      cLinkHandles = DYNAMIC-FUNCTION('linkHandles' IN THIS-PROCEDURE, 'GroupAssign-Target').
      IF cLinkHandles <> "":U THEN
        hFilter = WIDGET-HANDLE(ENTRY(1,cLinkHandles)).
      
      ASSIGN ttLookFilt.cFromValue = ENTRY(2,cValueList,CHR(1))
             ttLookFilt.cToValue   = ttLookFilt.cFromValue.
      RUN updateFilterData IN hFilter (INPUT TABLE ttLookFilt).
    END.
  
    RUN applyFilters (INPUT TABLE ttLookFilt).
    ghBuffer:FIND-FIRST('FOR EACH RowObject WHERE RowObject.RowIdent BEGINS "':U + pcRowIdent + '"':U) NO-ERROR.
    IF ghBuffer:AVAILABLE THEN
      ASSIGN rRowid     = ghBuffer:ROWID
             hRowNum    = ghBuffer:BUFFER-FIELD('RowNum':U)
             hRowIdent  = ghBuffer:BUFFER-FIELD('RowIdent':U)
             iRowNum = hRowNum:BUFFER-VALUE
             cRowIdent = hRowIdent:BUFFER-VALUE
             .
    lOK = ghQuery:REPOSITION-TO-ROWID(rRowid) NO-ERROR.
  END.
END.

DELETE WIDGET hRowQuery.

ASSIGN hRowQuery = ?.

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
  DEFINE VARIABLE dToolBarHeight        AS DECIMAL NO-UNDO.
  DEFINE VARIABLE dFolderWidth          AS DECIMAL NO-UNDO.
  DEFINE VARIABLE dRow                  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dColumn               AS DECIMAL    NO-UNDO.
  
  
  IF VALID-HANDLE(ghFolderHandle) THEN DO:
    dFolderWidth = DYNAMIC-FUNCTION("getWidth":U IN ghFolderHandle).
    IF VALID-HANDLE(ghFolderHandle) AND 
       LOOKUP("getTopLeft":U, ghFolderHandle:INTERNAL-ENTRIES) > 0 THEN
      RUN getTopLeft IN ghFolderHandle (OUTPUT dRow, OUTPUT dColumn) NO-ERROR.
  END.
  
  dToolBarHeight = 0.
  IF VALID-HANDLE(ghMaintToolbar) THEN DO:
    IF gcMaintenanceObject <> "":U THEN DO:
      dToolBarHeight = (DYNAMIC-FUNCTION("getHeight" IN ghMaintToolbar)) + (5 / SESSION:PIXELS-PER-ROW).
    END.
  END.

  {get ContainerSource hContainerSource}.
  {get ContainerHandle hWindow hContainerSource}.

  ASSIGN
      lPreviouslyHidden                = FRAME {&FRAME-NAME}:HIDDEN
      FRAME {&FRAME-NAME}:SCROLLABLE   = FALSE
      FRAME {&FRAME-NAME}:HIDDEN       = TRUE
      FRAME {&FRAME-NAME}:HEIGHT-CHARS = pdHeight - dToolBarHeight
      FRAME {&FRAME-NAME}:WIDTH-CHARS  = pdWidth NO-ERROR.

  IF VALID-HANDLE(ghBrowse) THEN
  DO:
    ASSIGN
        ghBrowse:WIDTH-CHARS   = FRAME {&FRAME-NAME}:WIDTH-CHARS   - 2
        ghBrowse:HEIGHT-PIXELS = FRAME {&FRAME-NAME}:HEIGHT-PIXELS - 40.

    RUN refreshLookup.
  END.

  APPLY "end-resize":U TO FRAME {&FRAME-NAME}.
  
  FRAME {&FRAME-NAME}:HIDDEN = lPreviouslyHidden NO-ERROR.
  
  RUN resizeReposToolbar.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeReposToolbar sObject 
PROCEDURE resizeReposToolbar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lPreviouslyHidden     AS LOGICAL NO-UNDO.
  DEFINE VARIABLE hWindow               AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hContainerSource      AS HANDLE  NO-UNDO.
  DEFINE VARIABLE dToolBarHeight        AS DECIMAL NO-UNDO.
  DEFINE VARIABLE dFolderWidth          AS DECIMAL NO-UNDO.
  DEFINE VARIABLE dRow                  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dColumn               AS DECIMAL    NO-UNDO.
  
  
  IF VALID-HANDLE(ghFolderHandle) THEN DO:
    dFolderWidth = DYNAMIC-FUNCTION("getWidth":U IN ghFolderHandle).
    IF VALID-HANDLE(ghFolderHandle) AND 
       LOOKUP("getTopLeft":U, ghFolderHandle:INTERNAL-ENTRIES) > 0 THEN
      RUN getTopLeft IN ghFolderHandle (OUTPUT dRow, OUTPUT dColumn) NO-ERROR.
  END.
  
  dToolBarHeight = 0.
  IF VALID-HANDLE(ghMaintToolbar) THEN DO:
    IF gcMaintenanceObject <> "":U THEN DO:
      dToolBarHeight = (DYNAMIC-FUNCTION("getHeight" IN ghMaintToolbar)) * SESSION:PIXELS-PER-ROW + 5.
    END.
  END.
    
  IF VALID-HANDLE(ghMaintToolbar) AND 
     gcMaintenanceObject <> "":U THEN DO:
    RUN hideObject IN ghMaintToolbar.
    RUN resizeObject     IN ghMaintToolbar (dToolBarHeight, dFolderWidth - 1).
    RUN repositionObject IN ghMaintToolbar (ghBrowse:ROW + ghBrowse:HEIGHT-CHARS + 3.48, 2.48) NO-ERROR.
    RUN viewObject IN ghMaintToolbar.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setToolbarState sObject 
PROCEDURE setToolbarState :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  

  IF NOT VALID-HANDLE(ghMaintToolbar) THEN
    RETURN.
  
  IF NOT VALID-HANDLE(ghQuery) THEN
    RETURN.
  /* First Disable All The Buttons */
  DYNAMIC-FUNCTION("sensitizeActions":U IN ghMaintToolbar ,"Add2,Copy2,Modify,View", FALSE).
  IF ghQuery:NUM-RESULTS = 0 OR
     ghQuery:NUM-RESULTS = ? THEN /* Only Enable Add */
    DYNAMIC-FUNCTION("sensitizeActions":U IN ghMaintToolbar ,"Add2", TRUE).
  ELSE
    DYNAMIC-FUNCTION("sensitizeActions":U IN ghMaintToolbar ,"Add2,Copy2,Modify,View", TRUE).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startSearch sObject 
PROCEDURE startSearch :
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
                        ELSE hColumn:NAME)
          .
      ASSIGN cQuery = "FOR EACH ":U + ghBuffer:NAME + " NO-LOCK BY ":U + cSortBy.
      ghQuery:QUERY-PREPARE(cQuery).
      ghQuery:QUERY-OPEN().

      IF ghQuery:NUM-RESULTS > 0 THEN
        DO:
          ghQuery:REPOSITION-TO-ROWID(rRow) NO-ERROR.
          ghBrowse:CURRENT-COLUMN = hColumn.
          APPLY 'VALUE-CHANGED':U TO ghBrowse.
        END.
      RUN refreshLookup.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE toolbar sObject 
PROCEDURE toolbar :
/*------------------------------------------------------------------------------
  Purpose:     Run from OK or CANCEL actions in container toolbar
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcAction                     AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE lContinue                           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cField                              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hField                              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowIdent                           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cValue                              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop                               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cValueList                          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainerSource                    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hWindowHandle                       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cProcedureType                      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hNavigationSource                   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTableIOTarget                      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iExtentLoop                         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hWindow                             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lAutoCommit                         AS LOGICAL    NO-UNDO.

  glSelectionMade = FALSE.
  CASE pcAction:
      WHEN "add" OR WHEN "modify" OR WHEN "copy" OR WHEN "view" THEN
      DO:
        gcCurrentMode = pcAction.
        IF gcMaintenanceObject = "":U THEN
          RETURN.
        RUN enableMaintenance.
        IF NOT VALID-HANDLE(ghSDOHandle) THEN
          RETURN.
        /* Before we launch the window - lets move to the current selected 
           record in the SDO */
        IF pcAction <> "add":U THEN
          RUN moveToSDORecord.

        {get ContainerSource hContainerSource}.
        {get ContainerHandle hWindowHandle hContainerSource}.        
        
        SESSION:SET-WAIT-STATE("GENERAL":U).
        
        IF VALID-HANDLE(gshSessionManager) THEN
        RUN launchContainer IN gshSessionManager (                                                    
            INPUT gcMaintenanceObject , /* pcObjectFileName       */
            INPUT "",                   /* pcPhysicalName         */
            INPUT "",                   /* pcLogicalName          */
            INPUT TRUE,                 /* plOnceOnly             */
            INPUT "",                   /* pcInstanceAttributes   */
            INPUT "",                   /* pcChildDataKey         */
            INPUT "",                   /* pcRunAttribute         */
            INPUT pcAction,             /* container mode         */
            INPUT hWindowHandle,        /* phParentWindow         */
            INPUT hContainerSource,     /* phParentProcedure      */
            INPUT hContainerSource,     /* phObjectProcedure      */
            OUTPUT ghMaintObject,       /* phProcedureHandle      */
            OUTPUT cProcedureType       /* pcProcedureType        */       
        ).
        /* If the maintenance object (Folder) is still running then make 
           sure it is always on top */
        IF VALID-HANDLE(ghMaintObject) THEN
        DO:
          hWindow = DYNAMIC-FUNCTION("getContainerHandle":U IN ghMaintObject) NO-ERROR.
          IF VALID-HANDLE(hWindow) THEN
            hWindow:ALWAYS-ON-TOP = TRUE.
        END.
        IF VALID-HANDLE(ghSDOHandle) THEN DO:
          hNavigationSource = WIDGET-HANDLE(ENTRY(2,DYNAMIC-FUNCTION("linkHandles":U IN ghSDOHandle, "Navigation-Source":U))).
          IF VALID-HANDLE(hNavigationSource) THEN DO:
            hTableIOTarget = WIDGET-HANDLE(ENTRY(1,DYNAMIC-FUNCTION("linkHandles":U IN hNavigationSource, "TableIO-Target":U))).
            SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "updateState" IN hTableIOTarget.
          END. 
        END.
        SESSION:SET-WAIT-STATE("":U).
      END.
      WHEN "select" THEN
      DO WITH FRAME {&FRAME-NAME}: 

        IF ghBuffer:AVAILABLE THEN
        DO: /* Return record selected */
          FIND FIRST ttLookCtrl NO-ERROR.
          IF AVAILABLE ttLookCtrl THEN
          DO:
            ASSIGN cValueList = "":U.
            DO iLoop = 1 TO NUM-ENTRIES(ttLookCtrl.cAllFields):
              ASSIGN
                cField = ENTRY(iLoop,ttLookCtrl.cAllFields)
                cField = REPLACE(cField,".":U,"_":U)
                hField = ghBuffer:BUFFER-FIELD(cField).
              IF hField:EXTENT = 0 THEN
                ASSIGN cValue = STRING(hField:BUFFER-VALUE)
                       cValueList = cValueList +
                                    (IF iLoop = 1 THEN "":U ELSE CHR(1)) +
                                    (IF cValue = ? THEN "":U ELSE cValue).
              ELSE DO:
                DO iExtentLoop = 1 TO hField:EXTENT:
                  ASSIGN cValue = STRING(hField:BUFFER-VALUE[iExtentLoop])
                         cValueList = cValueList +
                                      (IF iExtentLoop = 1 AND iLoop <> 1 THEN CHR(1) ELSE IF iExtentLoop = 1 AND iLoop <> 1 THEN "":U ELSE CHR(2)) +
                                      (IF cValue = ? THEN "":U ELSE cValue).

                END.
              END.
            END.  /* all fields loop */
            ASSIGN hRowIdent  = ghBuffer:BUFFER-FIELD('RowIdent':U).
            RUN RowSelected IN ghSDF (INPUT ttLookCtrl.cAllFields,
                                      INPUT cValueList,
                                      INPUT hRowIdent:BUFFER-VALUE).
          END. /* available ttlookctrl */
        END. /* ghbuffer available */
        glSelectionMade = TRUE.
        PUBLISH 'exitObject'.
        RETURN.
      END.
      WHEN "cancel" THEN
      DO:
        PUBLISH 'exitObject'.
        RETURN.
      END.
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateState sObject 
PROCEDURE updateState :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcState AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cKeyField   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValueList  AS CHARACTER  NO-UNDO.

  IF pcState = "updateComplete":U THEN DO:
    RUN applyFilters (INPUT TABLE ttLookFilt).
    IF gcCurrentMode = "add":U OR
       gcCurrentMode = "copy":U THEN DO:
      IF VALID-HANDLE(ghSDOHandle) THEN DO:
        FIND FIRST ttLookCtrl NO-ERROR.
        IF AVAILABLE ttLookCtrl THEN
          cKeyField = ENTRY(2,ttLookCtrl.cKeyField,".":U).
        IF cKeyField <> "":U THEN
          cValueList = DYNAMIC-FUNCTION("colValues":U IN ghSDOHandle, cKeyField).
        IF cValueList = ? OR
           cValueList = "":U THEN
          grLastSelectedRowId = ?.
        ELSE
          grLastSelectedRowId = TO-ROWID(ENTRY(2,ENTRY(1,cValueList,CHR(1)))).
      END.
    END.
    RUN repositionBrowse (INPUT STRING(grLastSelectedRowId)).
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
.
  IF VALID-HANDLE(ghBrowse) THEN
    APPLY "entry":U TO ghBrowse.
  RUN resizeReposToolbar.
  IF gcMaintenanceObject <> "":U AND 
     VALID-HANDLE(ghMaintToolbar) THEN DO:
    RUN viewObject IN ghMaintToolbar.
    RUN setToolbarState.
  END.
  ELSE IF VALID-HANDLE(ghMaintToolbar) THEN
    RUN hideObject IN ghMaintToolbar.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION evaluateOuterJoins sObject 
FUNCTION evaluateOuterJoins RETURNS CHARACTER
  (pcQueryString  AS CHARACTER,
   pcFilterFields AS CHARACTER):
/*------------------------------------------------------------------------------
  Purpose:  Replace OUTER-JOINs in a query with '' if filter criteria is specified
            on fields of the OUTER-JOINed buffers

    Notes:  This request is now simply passed on to the session manager.  We needed
            to centralize it as it's called from so many places.  Afsdofiltw.w, 
            rylookupbv.w and data.p.
------------------------------------------------------------------------------*/

IF VALID-HANDLE(gshSessionManager) THEN
    RETURN DYNAMIC-FUNCTION("filterEvaluateOuterJoins":U IN gshSessionManager, INPUT pcQueryString, INPUT pcFilterFields).
ELSE
    RETURN pcQueryString.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

