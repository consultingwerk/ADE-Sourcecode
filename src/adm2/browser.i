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

  /* Used by dataAvailable, brschnge.i*/
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
         HEIGHT             = 15.52
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

&IF "{&ENABLED-FIELDS-IN-QUERY-{&BROWSE-NAME}}":U NE "":U &THEN
  ON VALUE-CHANGED OF BROWSE {&BROWSE-NAME} ANYWHERE
    APPLY 'U10':U TO THIS-PROCEDURE.

  ON 'U10':U OF THIS-PROCEDURE
  DO:
    /* Ignore the event if it wasn't a browse field. */
    IF LOOKUP("RowObject.":U + FOCUS:NAME, 
      "{&FIELDS-IN-QUERY-{&BROWSE-NAME}}":U, " ":U) NE 0
    THEN DO:
      {get FieldsEnabled lResult}.
      IF lResult THEN                /* Only if browse enabled for input. */
      DO:
        {get DataModified lResult}.
        IF NOT lResult THEN          /* Don't send the event more than once. */
          {set DataModified yes}.
      END.    /* END DO IF lResult */
    END.      /* END DO IF LOOKUP */
  END.        /* END DO ON ANY */
&ENDIF

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

  hBuffer = BROWSE {&BROWSE-NAME}:HANDLE.
  {set BrowseHandle hBuffer}.

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
    that runs these methods are totally depending of the properties matching 
    the objects true state and the browser is enabled as default from the
    4GL definition. */
  IF cEnabled NE "":U THEN
    {set FieldsEnabled yes}.

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
  IF NOT hQuery:QUERY-PREPARE({fn fixQueryString cBaseQuery}) THEN /* Prepare for the first OPEN */
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
  {set QueryObject no}.
  RUN modifyListProperty (THIS-PROCEDURE, 'ADD':U,
    "SupportedLinks":U, "Toolbar-Target":U).

&ENDIF

  /* _ADM-CODE-BLOCK-START _CUSTOM _INCLUDED-LIB-CUSTOM CUSTOM */
  {src/adm2/custom/browsercustom.i}
  /* _ADM-CODE-BLOCK-END */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-dataAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataAvailable Method-Library 
PROCEDURE dataAvailable :
/*------------------------------------------------------------------------------
  Purpose:     SmartDataBrowser version of dataAvailable.
               Repositions itself in response to a query reposition in its 
               DataSource.
  Parameters:  pcRelative AS CHARACTER
               Possible values are:
               FIRST    - Repositions to the first row in the browse
               LAST     - Repositions to the last row in the browse
               PREV     - Repositions to the prev row in the browse
               NEXT     - Repositions to the next row in the browse
               REPOSITIONED - A navigation has taken place, but the query has 
                              been repositioned so the browse is already 
                              on the correct record 
               DIFFERENT- Returns or invokes next up on the chain 
                         (If database based browse query.p will publish 
                          dataavail, is not important for SDO browsing)
                                          
  Notes:       This procedure is here rather than in browser.p because it
               must sometimes use query.p, and sometimes datavis.p, as its
               super procedure, depending on whether the SmartDataBrowser has 
               its own database query.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcRelative AS CHARACTER NO-UNDO.

  DEFINE VARIABLE hBrowse           AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hDataSource       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lSelfQuery        AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lSourceQuery      AS LOGICAL   NO-UNDO INIT ?.
  DEFINE VARIABLE cRowIdent         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFields           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hSource           AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cDisplayed        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cColumns          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lInitialized      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hToolbarSource    AS HANDLE     NO-UNDO.
  /* Do nothing if source sdo is not initialized - used when runing
     tableout procedure in sdo to disable standard behaviour of linked objects
     whilst we scroll through the sdo query*/
  {get DataSource hSource}.

  IF VALID-HANDLE(hSource) THEN
  DO:
    {get objectinitialized lInitialized hSource}.
    IF NOT lInitialized THEN RETURN.
  END.

  {get ToolbarSource hToolbarSource}.
  IF VALID-HANDLE(hToolbarSOurce) THEN
      RUN resetToolbar IN hToolbarSource.
  /* if we got this message from "ourselves", because someone selected
     a row in the browser, which ran dataAvailable in the DataSource,
     then ignore it when it comes back. */
  IF glReposition THEN 
  DO:
    glReposition = no.
    RETURN.  
  END.
 

  /* If a Relative flag of FIRST/NEXT/LAST/PREV comes from a master query,
     and we are a dependent detail query OF that master, then treat these
     as just being DIFFERENT rows, and signal our super proc (query.p)
     to re-open the query, rather than doing a reposition. */
  {get QueryObject lSelfQuery}.
  {get QueryObject lSourceQuery SOURCE-PROCEDURE} NO-ERROR.
  
   /* If this is a browse with its own query, we have to differentiate 
     between events coming from this browser through the VALUE-CHANGED trigger, 
     which we want to respond to, and the event published by our super procedure,
     query.p, which we need to ignore to avoid an infinite loop. So brschnge.i
     sends a special parameter of VALUE-CHANGED for that trigger,which we 
     convert to DIFFERENT. Otherwise we ignore DIFFERENT if it comes from 
     "ourself" or when we browse an SDO. We also ignore 'RESET' from an SDO. */

  IF NOT lSelfQuery OR (lSelfQuery AND THIS-PROCEDURE = SOURCE-PROCEDURE) THEN
  DO:
    IF pcRelative = 'DIFFERENT':U THEN
    DO:
     /* Before the SBO was introduced the browse always received 'FIRST'
        at start up, so glRepositon was always changed from its initial ? value.
        But the SBO publishes dataAvailable 'DIFFERENT' at start up. We need 
        to change it from its inital value also in that case, so the browse can 
        respond correctly if 'end' or 'home' is pressed before 'value-changed'*/ 
      IF glReposition = ? THEN glReposition = NO.
      {get DataSource hDataSource}.
      cRowIdent = ENTRY(1,{fnarg colValues '':U hDataSource},CHR(1)).
      {set RowIdent cRowIdent}.   
      RETURN.
    END. /* pcRelative = different */
    ELSE IF LOOKUP(pcRelative,"SAME,RESET":U) > 0 THEN
    DO:
       /* this is necessary because BROWSER:REFRESH does not refresh */
       /* the current row */
       RUN displayRecord IN TARGET-PROCEDURE. 
       RUN refreshBrowse IN TARGET-PROCEDURE.
    END.
  END.
  /* If the browser has its own db query and no Foreign Fields, and this
     request didn't come from itself, then this is a request from an SDO
     being used for update to refresh the browse row with new values. */
  IF lSelfQuery AND SOURCE-PROCEDURE NE THIS-PROCEDURE THEN 
  DO:
    {get ForeignFields cFields}.
    IF cFields = "":U AND VALID-HANDLE(hSource) THEN
    DO:
      {get DisplayedFields cDisplayed}.
      cColumns    =
       dynamic-function ("colValues":U IN hSource, cDisplayed) NO-ERROR.
      RUN displayFields IN TARGET-PROCEDURE (cColumns). 
      RETURN.
    END.  /* END DO IF VALID-HANDLE */
  END.    /* END DO IF SelfQuery and no FF */

  /* IF this browser has a db query and the source of the event also does
     (i.e., is not a Nav Panel) and we didn't get the event from ourself...*/
  IF lSelfQuery AND lSourceQuery AND SOURCE-PROCEDURE NE THIS-PROCEDURE 
    AND LOOKUP(pcRelative, "FIRST,NEXT,PREV,LAST":U) NE 0 THEN 
      pcRelative = "DIFFERENT":U.
  /* NOTE: On a FIRST/LAST from a Nav Panel, the VALUE-CHANGED trigger fires,
     which causes an additional unwanted dataAvailable from brschnge.i.
     SO set a flag to signal to brschnge.i to ignore the trigger. */
  IF (pcRelative = "FIRST":U OR pcRelative = "LAST":U) THEN
      glReposition = 
        IF glReposition = ? THEN no ELSE yes.
  
  {get BrowseHandle hBrowse}.
  
  CASE pcRelative:
    WHEN "FIRST":U THEN 
    DO:
      IF VALID-HANDLE(FOCUS) AND
        FOCUS:PARENT = hBrowse THEN
          APPLY "CTRL-HOME":U TO hBrowse.            
      ELSE DO:
        /* If the browser is using an SDO's query then we want to set
           glReposition to yes to avoid having brshome.i run fetchFirst
           again in the SDO during initialization */
        IF NOT lSelfQuery AND SOURCE-PROCEDURE NE THIS-PROCEDURE THEN
          glReposition = yes.
        /* If the user really chose the HOME key then cLastEvent is set 
           to "HOME" and we don't want to apply home again here */
        IF cLastEvent NE "HOME":U THEN APPLY "HOME":U TO hBrowse.
        cLastEvent = "":U.
      END.  /* else do */
      glReposition = no. /* Should be set to no in value-changed trigger,but.. */
    END.    
    WHEN "NEXT":U  THEN hBrowse:SELECT-NEXT-ROW() NO-ERROR.           
    WHEN "PREV":U  THEN hBrowse:SELECT-PREV-ROW() NO-ERROR.
    WHEN "LAST":U  THEN 
    DO:
      IF VALID-HANDLE(FOCUS) AND
        FOCUS:PARENT = hBrowse THEN
        APPLY "CTRL-END":U TO hBrowse.
      ELSE DO:
        /* If the user really chose the END key then cLastEvent is set
           to "END" and we don't want to apply end again here */
        IF cLastEvent NE "END":U THEN APPLY "END":U TO hBrowse.
        cLastEvent = "":U.
      END.  /* else do */
      glReposition = no. /* Should be set to no in value-changed trigger,but.. */
    END.    
    WHEN "REPOSITIONED":U THEN /* NOTHING..  We did navigate, but a REPOSITION has 
                                already synced the browse */ .
  END CASE.
  
  IF NOT lSelfQuery 
  AND LOOKUP(pcRelative,'REPOSITIONED,FIRST,NEXT,PREV,LAST':U) NE 0 THEN 
  DO:
    RUN SUPER(pcRelative).  
   /* colValues will return ALL rowids for an SBO when no fields is passed, 
      but getRowident will filter away the abundant ones.. */
    {get DataSource hDataSource}.
    cRowIdent = ENTRY(1,{fnarg colValues '':U hdataSource},CHR(1)).
    {set RowIdent cRowIdent}.  
  END.
  RETURN.
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

