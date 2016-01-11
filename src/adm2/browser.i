&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    Library     : browser.i
    Purpose     : Basic SmartDataBrowser methods for the ADM

    Syntax      : {src/adm2/browser.i}

    Modified    : July 14, 2000 Version 9.1B
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF "{&ADMClass}":U = "":U &THEN
  &GLOB ADMClass browser
&ENDIF

/* Make sure that the template compiles successfully by itself 
   (Internal-Tables will be undefined); otherwise tell the rest of the compile
   whether this Browser is defined against a db query, in which case there's
   no RowObject. If there's a db query, we also add ForeignFields to the
   list of Instance Properties for this object. */
&IF DEFINED(INTERNAL-TABLES) EQ 0 &THEN
  &SCOP EXCLUDE-getRowObject YES
&ELSEIF "{&INTERNAL-TABLES}":U NE "RowObject":U &THEN
  &SCOP BrowserQueryObject Yes
  &SCOP EXCLUDE-getRowObject YES
&ENDIF

  /* These are no longer used, but kept for backwards compatibility 
     as typically datAvailable  overrides would use them */
  DEFINE VARIABLE glReposition AS LOGICAL   INIT ?.
  DEFINE VARIABLE cLastEvent   AS CHARACTER.

&IF "{&ADMClass}":U = "browser":U &THEN
 /* If this Browser has its own database query, then we must include
    the query properties (and later the class include). qryprop.i has
    conditional code to include brsprop.i in this case. */
 &IF DEFINED(BrowserQueryObject) NE 0 &THEN
  &SCOP QUERY-NAME {&BROWSE-NAME}
  {src/adm2/qryprop.i}
 &ELSE
  {src/adm2/brsprop.i}
 &ENDIF
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getRowObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRowObject Method-Library 
FUNCTION getRowObject RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Method-Library
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Method-Library ASSIGN
         HEIGHT             = 5.76
         WIDTH              = 55.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

  {src/adm2/datavis.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */

  DEFINE VARIABLE cViewCols     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cEnabled      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iCol          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iEntries      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cEntry        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cBaseQuery    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hQuery        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cColumns      AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE iTable        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hBuffer       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hColumn       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lResult       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cStripDisp    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cStripEnable  AS CHARACTER  NO-UNDO.

&IF DEFINED(BrowserQueryObject) NE 0 &THEN
  /* If this is a browser with its own db query, the query class must
     be included before the browser class so that its super procedure
     is above browser.p in the super procedure stack. */
  {src/adm2/query.i}
&ENDIF
 
  RUN start-super-proc("adm2/browser.p":U).

ON VALUE-CHANGED OF BROWSE {&BROWSE-NAME} ANYWHERE
  RUN valueChanged IN TARGET-PROCEDURE.

ON 'U10':U OF THIS-PROCEDURE
  RUN valueChanged IN TARGET-PROCEDURE.

hBuffer = BROWSE {&BROWSE-NAME}:HANDLE.
{set BrowseHandle hBuffer}.

/* Exclude DisplayFieldsStatic unless there is a local calculated field 
   (expression) @ localvar.
   Use a static display for these as the expression is difficult to evaluate 
   dynamically. Even a browse:refresh does not work until row-leave has fired, 
   so save in an updatable browse would not refresh */
    &IF INDEX("{&FIELDS-IN-QUERY-{&BROWSE-NAME}}":U,"@":U) = 0 &THEN
 &SCOPED-DEFINE EXCLUDE-DisplayFieldsStatic   
    &ENDIF  

/* Compile this only is for a static browse */
&IF "{&FIELDS-IN-QUERY-{&BROWSE-NAME}}":U <> "":U &THEN 
    
  cStripDisp = DYNAMIC-FUNCTION("stripCalcs":U, "{&FIELDS-IN-QUERY-{&BROWSE-NAME}}":U).
  iEntries = NUM-ENTRIES(cStripDisp, " ":U).
  DO iCol = 1 TO iEntries:
    cEntry = ENTRY(iCol, cStripDisp, " ":U).
    cViewCols = cViewCols + (IF cViewCols NE "":U THEN ",":U ELSE "":U) +
      SUBSTR(cEntry, R-INDEX(cEntry, ".":U) + 1).  /* Remove table (and db) */
  END.
  cStripEnable = DYNAMIC-FUNCTION("stripCalcs":U, "{&ENABLED-FIELDS-IN-QUERY-{&BROWSE-NAME}}":U).
  iEntries = NUM-ENTRIES(cStripEnable, " ":U).
  DO iCol = 1 TO iEntries:
    cEntry = ENTRY(iCol, cStripEnable, " ":U).
    cEnabled = cEnabled + (IF cEnabled NE "":U THEN ",":U ELSE "":U) +
      SUBSTR(cEntry, R-INDEX(cEntry, ".":U) + 1).  /* Remove table (and db) */
  END.
  
  {set DisplayedFields cViewCols}.
  {set EnabledFields cEnabled}.

 /* If there are any enabled fields, set the enabled prop to yes. 
    This is necessary because disableFields and enableFields and also logic 
    that runs these methods are depending of the properties matching 
    the objects true state and the browser is enabled as default from the
    4GL definition. */
  IF cEnabled NE "":U THEN
    {set FieldsEnabled yes}.
&ENDIF

&IF DEFINED(BrowserQueryObject) NE 0 &THEN
  /* If this browser was built against database table(s) then 
     set the QueryObject property which identifies it as using its own tables.*/
    {set QueryObject yes}.
    hQuery = QUERY {&BROWSE-NAME}:HANDLE.
    DO iTable = 1 TO hQuery:NUM-BUFFERS:
      hBuffer = hQuery:GET-BUFFER-HANDLE(iTable).
      DO iCol = 1 TO hBuffer:NUM-FIELDS:
        hColumn = hBuffer:BUFFER-FIELD(iCol).
        IF LOOKUP(hColumn:NAME, cColumns) = 0 THEN  /* Remove dup names. */
          cColumns = cColumns + (IF cColumns NE "":U THEN ",":U ELSE "":U) +
            hColumn:NAME.                 /* Build comma-separated list. */
      END.    /* END DO iCol */
    END.      /* END DO iTable */
    {set DataColumns cColumns}.

  /* Also initialize the "base" Open Query where clause from the 
     Query definition.  This will be used to open the query if 
     no other where clause is specified. */
  cBaseQuery = SUBSTR('{&OPEN-QUERY-{&BROWSE-NAME}}':U,
     INDEX('{&OPEN-QUERY-{&BROWSE-NAME}}':U,"FOR EACH":U)).

  /* Fix European decimal format issues with potential numbers in query string
    (fixQueryString is a function in smartcustom.p) */
  IF NOT hQuery:QUERY-PREPARE({fnarg fixQueryString cBaseQuery}) THEN /* Prepare for the first OPEN */
    MESSAGE "Query Prepare in Browser failed." VIEW-AS ALERT-BOX.
 
  /* Designate this object as a potential DataSource because it has a query. 
     Also make it a Navigation-Target */
  RUN modifyListProperty (THIS-PROCEDURE, 'ADD':U,
    "SupportedLinks":U, "Data-Source":U).
  RUN modifyListProperty (THIS-PROCEDURE, 'ADD':U,
    "SupportedLinks":U, "Navigation-Target":U).
  /* Since this is both the query and the browser object, subscribe
     to dataAvailable in this object to get those published events. */
  
  SUBSCRIBE TO 'dataAvailable':U IN THIS-PROCEDURE.
&ELSE
  /* This is still needed also for dynamic objects  */
  {set QueryObject no}.
  RUN modifyListProperty (THIS-PROCEDURE, 'ADD':U,
    "SupportedLinks":U, "Toolbar-Target":U).
  
  /* Subscribe to FilterActive when data links are established. This is used 
    to display filter tick, etc. when a filter is active. */
  RUN modifyListProperty(THIS-PROCEDURE, "ADD":U, 
                      "DataSourceEvents":U,"FilterActive":U).

  /* Subscribe to refreshBrowse. This is published from data sources */
  RUN modifyListProperty(THIS-PROCEDURE, "ADD":U, 
                      "DataSourceEvents":U,"RefreshBrowse":U).

  /* Subscribe to cancelNew. This is published from data sources
     on cancelRow for a new record  */
  RUN modifyListProperty(THIS-PROCEDURE, "ADD":U, 
                      "DataSourceEvents":U,"CancelNew":U).

&ENDIF

  /* _ADM-CODE-BLOCK-START _CUSTOM _INCLUDED-LIB-CUSTOM CUSTOM */
  {src/adm2/custom/browsercustom.i}
  /* _ADM-CODE-BLOCK-END */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-DisplayFieldsStatic) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DisplayFieldsStatic Method-Library 
PROCEDURE DisplayFieldsStatic :
/*------------------------------------------------------------------------------
  Purpose: Static Display statement compiled for refresh of locally calculated 
           columns.  
  Parameters:  <none>
  Notes:   This is conditionally compiled ONLY if there is a local calculated 
           field in the field list.
         - It creates a temporary rowobject and assigns all values to be able
           to display them using the generated static {&fields-in-} list, which
           also has the <calc expression> @ <some variable> .     
         - It is called from browser.p DisplayFields if a '<calc>' entry is 
           found in DisplayedFields. (it is NOT checking internal-entries as
           we do not intend to support this for normal static browsers).     
------------------------------------------------------------------------------*/
   DEFINE INPUT  PARAMETER pcColValues AS CHARACTER  NO-UNDO.
   
   DEFINE VARIABLE rRowid        AS ROWID      NO-UNDO.
   DEFINE VARIABLE iValue        AS INTEGER    NO-UNDO.
   DEFINE VARIABLE hBuffer       AS HANDLE     NO-UNDO.
   DEFINE VARIABLE hField        AS HANDLE     NO-UNDO.
   DEFINE VARIABLE hFrameField   AS HANDLE     NO-UNDO.
   DEFINE VARIABLE cFields       AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cFieldHandles AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cField        AS CHARACTER  NO-UNDO.

   {get FieldHandles cFieldHandles}.
   {get DisplayedFields cFields}.

   /* there should never be a RowObject record here, but just in case...
      lets keep track of it and reposition to it after */ 
   IF AVAIL RowObject THEN
     rRowid = ROWID(RowObject).

   CREATE RowObject.
   
   hBuffer = BUFFER RowObject:HANDLE.
   DO iValue = 2 TO NUM-ENTRIES(pcColValues,CHR(1)):
     cField = ENTRY(iValue - 1,cFields).
     IF cField <> '<Calc>':U THEN
     DO:
       ASSIGN 
         hFrameField = WIDGET-HANDLE(ENTRY(iValue - 1,cFieldHandles))
         hField = hBuffer:BUFFER-FIELD(cField)
         hField:BUFFER-VALUE = IF pcColValues NE ? 
                               THEN TRIM(ENTRY(iValue, pcColValues, CHR(1)))
                               ELSE IF hField:DATA-TYPE NE "LOGICAL":U 
                               THEN "":U
                               ELSE ?.
     END.
   END.

   DISPLAY {&FIELDS-IN-QUERY-{&BROWSE-NAME}} WITH BROWSE {&BROWSE-NAME}.
   
   DELETE RowObject.
   
   IF rRowid <> ? THEN
     FIND rowObject WHERE ROWID(RowObject) = rRowid NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getRowObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRowObject Method-Library 
FUNCTION getRowObject RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle to the Browser's temp-table definition.
    Notes:  Allow to examine the temp-table definition,
            the temp-table is not normally used at runtime.
            Used internally.
------------------------------------------------------------------------------*/

  RETURN BUFFER RowObject:HANDLE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

