&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
/* Procedure Description
"Super Procedure for Security - Actions - Allocation Viewer"
*/
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
  File: secacselbvsupr.p

  Description:  Security - Actions - Allocation Viewer

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   05/12/2003  Author:     

  Update Notes: Created from Template viewv

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

&scop object-name       secenqsuprp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

DEFINE VARIABLE ghBrowse    AS HANDLE     NO-UNDO. /* Handle to Non Secured Data Browse */
DEFINE VARIABLE ghQuery     AS HANDLE     NO-UNDO. /* Handle to Non Secured Data Query */
DEFINE VARIABLE ghTable     AS HANDLE     NO-UNDO. /* Handle to Non Secured Data Table */
DEFINE VARIABLE ghBuffer    AS HANDLE     NO-UNDO. /* Handle to Non Secured Data Table Buffer */

DEFINE VARIABLE gdLastSetWidth    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE gdLastSetHeight   AS DECIMAL    NO-UNDO.
DEFINE VARIABLE gdUserObj         AS DECIMAL    NO-UNDO.
DEFINE VARIABLE gdCompanyObj      AS DECIMAL    NO-UNDO.

DEFINE VARIABLE ghFilterViewer    AS HANDLE     NO-UNDO.
DEFINE VARIABLE gcFilterData      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ghSecTypeCol      AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghRangeFromCol    AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghRangeToCol      AS HANDLE     NO-UNDO.

DEFINE VARIABLE gcEntity          AS CHARACTER  NO-UNDO.

/* PLIP definitions */
{dynlaunch.i &define-only = YES}
{launch.i    &define-only = YES}

DEFINE TEMP-TABLE ttFilterData NO-UNDO
  FIELD cFieldLabel AS CHARACTER FORMAT "X(35)":U
  FIELD cFromValue  AS CHARACTER FORMAT "X(35)":U
  FIELD cToValue    AS CHARACTER FORMAT "X(35)":U
  FIELD cFormat     AS CHARACTER FORMAT "X(15)":U
  FIELD cDataType   AS CHARACTER FORMAT "X(10)":U
  FIELD cTableName  AS CHARACTER
  FIELD cFieldName  AS CHARACTER
  FIELD iFieldOrder AS INTEGER
  INDEX idx1        AS PRIMARY iFieldOrder
  INDEX idx2        AS UNIQUE cTableName cFieldName.


{af/app/afsecttdef.i}

DEFINE TEMP-TABLE ttDeletedAllocations NO-UNDO
  FIELD dOwningObj AS DECIMAL
  INDEX idx1       AS PRIMARY UNIQUE dOwningObj.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-setDataModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataModified Procedure 
FUNCTION setDataModified RETURNS LOGICAL
  ( plModified AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: Basic,Browse,DB-Fields
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 22
         WIDTH              = 58.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/customsuper.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    /* RUN initializeObject. */  /* Commented out by migration progress */
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-applyFilters) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyFilters Procedure 
PROCEDURE applyFilters :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER TABLE FOR ttFilterData.

  DEFINE VARIABLE cFilterFields               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterValues               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterTypes                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterOperators            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop                       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cBaseQueryString            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cErrorMessage               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEntityMnemonic             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUserID                     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLoginCompany               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cHighChar                   AS CHARACTER  NO-UNDO.

  ASSIGN cHighChar = DYNAMIC-FUNCTION("getHighKey":U IN gshGenManager, SESSION:CPCOLL).

  /* Process each record in ttLookupFilt and construct delimited strings of field name, datatypes, operators,                 *
   * and data values for filter 'from' and 'to' criteria in order to send as parameters to newQueryString function call below */
  filter-loop:
  FOR EACH ttFilterData:

      IF ttFilterData.cFromValue = "":U AND ttFilterData.cToValue = "":U THEN 
          NEXT filter-loop.

      IF ttFilterData.cFromValue <> "":U THEN
          ASSIGN iLoop            = iLoop + 1
                 cFilterFields    = cFilterFields + (IF iLoop = 1 THEN "":U ELSE ",":U) 
                                  + (IF ttFilterData.cTableName <> "":U THEN ttFilterData.cTableName + ".":U ELSE "":U) + ttFilterData.cFieldName
                 cFilterTypes     = cFilterTypes + (IF iLoop = 1 THEN "":U ELSE ",":U) 
                                  + ttFilterData.cDataType
                 cFilterOperators = cFilterOperators + (IF iLoop = 1 THEN "":U ELSE ",":U) 
                                  + ">=":U
                 cFilterValues    = cFilterValues + (IF iLoop = 1 THEN "":U ELSE CHR(1)) 
                                  + ttFilterData.cFromValue.

      IF ttFilterData.cToValue <> "":U THEN
          ASSIGN iLoop = iLoop + 1
                 cFilterFields    = cFilterFields + (IF iLoop = 1 THEN "":U ELSE ",":U) 
                                  + (IF ttFilterData.cTableName <> "":U THEN ttFilterData.cTableName + ".":U ELSE "":U) + ttFilterData.cFieldName
                 cFilterTypes     = cFilterTypes + (IF iLoop = 1 THEN "":U ELSE ",":U) 
                                  + ttFilterData.cDataType
                 cFilterOperators = cFilterOperators + (IF iLoop = 1 THEN "":U ELSE ",":U) 
                                  + "<=":U
                 cFilterValues    = cFilterValues + (IF iLoop = 1 THEN "":U ELSE CHR(1)) 
                                  + ttFilterData.cToValue
                                  + (IF ttFilterData.cDataType = "Character":U
                                     THEN cHighChar
                                     ELSE "":U).
  END.

  IF cFilterFields <> "":U THEN
      ASSIGN gcFilterData = cFilterFields + CHR(4) + cFilterValues + CHR(4) + cFilterTypes  + CHR(4) + cFilterOperators.
  ELSE 
      ASSIGN gcFilterData = "":U.

  SESSION:SET-WAIT-STATE("GENERAL":U).
  {
   dynlaunch.i &PLIP     = "'af/app/securenqry.p'"
               &iProc    = "'getData'"
               &OnApp    = YES
               &AutoKill = YES   
               
               &mode1 = INPUT  &parm1 = gcEntity     &dataType1 = CHARACTER
               &mode2 = INPUT  &parm2 = gdUserObj    &dataType2 = DECIMAL
               &mode3 = INPUT  &parm3 = gdCompanyObj &dataType3 = DECIMAL
               &mode4 = INPUT  &parm4 = gcFilterData &dataType4 = CHARACTER
               &mode5 = OUTPUT &parm5 = ghTable      &dataType5 = TABLE-HANDLE
  }
  IF ghQuery:IS-OPEN THEN ghQuery:QUERY-CLOSE().
  ghQuery:QUERY-OPEN().
  SESSION:SET-WAIT-STATE("":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createBrowse) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createBrowse Procedure 
PROCEDURE createBrowse :
/*------------------------------------------------------------------------------
  Purpose:     Create the browse for the Non Secured Data 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hFrame      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hButton     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLoop       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hCurField   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFieldChars AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iFieldChars AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hSortColumn AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSortBy     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQuery      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldList  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hWidget     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iFieldCnt   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lFormatGreaterThan30 AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE lStructureSecurity AS LOGICAL    NO-UNDO.

  /* Construct query for dynamic temp table */
  CREATE QUERY ghQuery.
  ghQuery:ADD-BUFFER(ghBuffer).

  {get ContainerHandle hFrame}.
  CREATE BROWSE ghBrowse
     ASSIGN FRAME            = hFrame
            VISIBLE          = NO
            SENSITIVE        = NO
            ROW              = 2
            COL              = 1
            WIDTH-CHARS      = hFrame:WIDTH-CHARS - 2
            HEIGHT-CHARS     = hFrame:HEIGHT-CHARS - 6.5
            SEPARATORS       = TRUE
            ROW-MARKERS      = FALSE
            EXPANDABLE       = TRUE
            COLUMN-RESIZABLE = TRUE
            READ-ONLY        = FALSE
            QUERY            = ghQuery
            ALLOW-COLUMN-SEARCHING = TRUE
      TRIGGERS:
          ON START-SEARCH  PERSISTENT RUN startSearch IN TARGET-PROCEDURE.
          ON VALUE-CHANGED PERSISTENT RUN dispFields  IN TARGET-PROCEDURE.
      END TRIGGERS.

  /* Move the Excel button */
  ASSIGN hWidget     = DYNAMIC-FUNCTION("internalWidgetHandle" IN TARGET-PROCEDURE,"buExcel":U, "ALL":U)
         hWidget:ROW = ghBrowse:ROW + ghBrowse:HEIGHT + 0.24
         hWidget:COL = (ghBrowse:COL + ghBrowse:WIDTH) - hWidget:WIDTH
         cFieldList  = "":U.

  do-blk:
  DO iLoop = 1 TO ghBuffer:NUM-FIELDS:

      ASSIGN hCurField = ghBuffer:BUFFER-FIELD(iLoop).

      /* Do not include any _obj fields in browser */
      IF INDEX(hCurField:NAME,"_obj":U) > 0 
      AND SUBSTRING(hCurField:NAME,LENGTH(hCurField:NAME) - 3,4) = "_obj":U THEN
          NEXT do-blk.

      ASSIGN cFieldList = IF cFieldList = "":U 
                          THEN hCurField:NAME 
                          ELSE cFieldList + ",":U + hCurField:NAME.
  END.

  /* Check if we are allocating structures */
  IF LOOKUP("cProdMod":U,cFieldList) > 0 THEN
      ASSIGN cFieldList          = REPLACE(cFieldList,",cProdMod":U,"":U)
             ENTRY(2,cFieldList) = "cProdMod,":U + ENTRY(2,cFieldList)
             lStructureSecurity  = YES.

  IF LOOKUP("cObject":U,cFieldList) > 0 THEN
      ASSIGN cFieldList          = REPLACE(cFieldList,",cObject":U,"":U)
             ENTRY(3,cFieldList) = "cObject,":U + ENTRY(3,cFieldList)
             lStructureSecurity  = YES.

  IF LOOKUP("cInstanceAttr":U,cFieldList) > 0 THEN
      ASSIGN cFieldList          = REPLACE(cFieldList,",cInstanceAttr":U,"":U)
             ENTRY(4,cFieldList) = "cInstanceAttr,":U + ENTRY(4,cFieldList)
             lStructureSecurity  = YES.
  
  /* We want the secured and how secured fields visible in the browse viewport */
  IF lStructureSecurity = NO 
  THEN DO:
      ASSIGN cFieldList          = REPLACE(cFieldList,",lSecured":U,"":U)
             ENTRY(3,cFieldList) = "lSecured,":U + ENTRY(3,cFieldList)
             cFieldList          = REPLACE(cFieldList,",cHowSecured":U,"":U)
             ENTRY(4,cFieldList) = "cHowSecured,":U + ENTRY(4,cFieldList).
  END.
  ELSE DO:
      ASSIGN cFieldList          = REPLACE(cFieldList,",lSecured":U,"":U)
             ENTRY(5,cFieldList) = "lSecured,":U + ENTRY(5,cFieldList)
             iFieldCnt           = 6.

      IF LOOKUP("cValue1":U,cFieldList) > 0 THEN
          ASSIGN cFieldList                  = REPLACE(cFieldList,",cValue1":U,"":U)
                 ENTRY(iFieldCnt,cFieldList) = "cValue1,":U + ENTRY(iFieldCnt,cFieldList)
                 iFieldCnt                   = iFieldCnt + 1.

      IF LOOKUP("cValue2":U,cFieldList) > 0 THEN
          ASSIGN cFieldList                  = REPLACE(cFieldList,",cValue2":U,"":U)
                 ENTRY(iFieldCnt,cFieldList) = "cValue2,":U + ENTRY(iFieldCnt,cFieldList)
                 iFieldCnt                   = iFieldCnt + 1.

      ASSIGN cFieldList          = REPLACE(cFieldList,",cHowSecured":U,"":U)
             ENTRY(iFieldCnt,cFieldList) = "cHowSecured,":U + ENTRY(iFieldCnt,cFieldList).
  END.

  /* Add fields to browser using structure of dynamic temp table */
  DO iLoop = 1 TO NUM-ENTRIES(cFieldList):
      ASSIGN hCurField = ghBuffer:BUFFER-FIELD(ENTRY(iLoop,cFieldList)).
      IF hSortColumn = ?
      OR NOT VALID-HANDLE(hSortColumn) THEN
          ASSIGN hSortColumn = hCurField.

      ASSIGN hCurField:VALIDATE-EXPRESSION = "".

      /* Check that Character format is never bigger than x(30) */
      IF hCurField:DATA-TYPE = "CHARACTER":U
      THEN DO:
          ASSIGN cFieldChars = TRIM(hCurField:FORMAT,"x(":U)
                 cFieldChars = RIGHT-TRIM(cFieldChars,")":U)
                 iFieldChars = INTEGER(cFieldChars) NO-ERROR.

          IF NOT ERROR-STATUS:ERROR
          AND iFieldChars > 30 THEN
              ASSIGN lFormatGreaterThan30 = YES.
          ELSE
              ASSIGN lFormatGreaterThan30 = NO.

          ERROR-STATUS:ERROR = FALSE.
      END.

      ASSIGN hField = ghBrowse:ADD-LIKE-COLUMN(hCurField).

      IF CAN-DO("cProdMod,cObject,cInstanceAttr":U, hField:NAME) THEN
          ASSIGN hField:WIDTH = 17.
      ELSE DO:
          IF lFormatGreaterThan30 THEN
              ASSIGN hField:WIDTH = 30.
      END.
  END.

  /* Lock first column of dynamic browser */
  ASSIGN ghBrowse:NUM-LOCKED-COLUMNS = 1. 

  /* Set query initial sort on col 1 */
  IF VALID-HANDLE(hSortColumn) THEN
      ASSIGN cSortBy = (IF hSortColumn:TABLE <> ? 
                        THEN hSortColumn:TABLE + '.':U + hSortColumn:NAME
                        ELSE hSortColumn:NAME).

  /* Build query string */
  ASSIGN cQuery = "FOR EACH ":U + ghBuffer:NAME + " NO-LOCK":U.
  IF cSortBy <> "":U THEN
      ASSIGN cQuery = cQuery + " BY " + cSortBy.
  ghQuery:QUERY-PREPARE(cQuery).

  /* Open the query for the browser */
  ghQuery:QUERY-OPEN().

  /* Show the browser */
  ASSIGN ghBrowse:SENSITIVE = YES
         ghBrowse:VISIBLE   = YES.

  IF VALID-HANDLE(ghBrowse) 
  THEN DO:
      APPLY "ENTRY":U TO ghBrowse.
      ghBrowse:SELECT-ROW(1) NO-ERROR.
      APPLY "value-changed":U TO ghBrowse.
  END.

  ASSIGN ERROR-STATUS:ERROR = NO.
  RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF VALID-HANDLE(ghBrowse) THEN DELETE OBJECT ghBrowse.
  IF VALID-HANDLE(ghQuery)  THEN DELETE OBJECT ghQuery.
  IF VALID-HANDLE(ghTable)  THEN DELETE OBJECT ghTable.

  RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dispFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dispFields Procedure 
PROCEDURE dispFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hWidget AS HANDLE     NO-UNDO.

IF ghBuffer:AVAILABLE 
THEN DO:
    ASSIGN /* Show how the object is secured using the seInfo selection list */
           hWidget               = widgetHandle("seInfo":U)
           hWidget:DELIMITER     = CHR(4)
           hWidget:LIST-ITEMS    = ghBuffer:BUFFER-FIELD("cHowSecured":U):BUFFER-VALUE.

    assignWidgetValue("toSecured":U, ghBuffer:BUFFER-FIELD("lSecured":U):BUFFER-VALUE).

    /* If we have a from and to value, display them */
    ASSIGN hWidget = ghBuffer:BUFFER-FIELD("cValue1":U) NO-ERROR.
    IF VALID-HANDLE(hWidget) THEN
        assignWidgetValue("fiFrom":U, hWidget:BUFFER-VALUE).

    ASSIGN hWidget = ghBuffer:BUFFER-FIELD("cValue2":U) NO-ERROR.
    IF VALID-HANDLE(hWidget) THEN
        assignWidgetValue("fiTo":U, hWidget:BUFFER-VALUE).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableWidgets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableWidgets Procedure 
PROCEDURE enableWidgets :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcFla AS CHARACTER  NO-UNDO.

DEFINE VARIABLE hWidget AS HANDLE     NO-UNDO.

/* We always view the secured toggle and "How Secured" selection list */
viewWidget("toSecured,seInfo,fiLabel,text-1,raShowSecured,buExcel":U).
enableWidget("seInfo,raShowSecured,buExcel":U).
disableWidget("toSecured").

CASE pcFla:
    WHEN "GSMFF":U 
    THEN DO:
        viewWidget("fiFrom":U).
        ASSIGN hWidget       = widgetHandle("fiFrom":U)
               hWidget:LABEL = "Security type".
    END.

    WHEN "GSMRA":U 
    THEN DO:
        viewWidget("fiFrom,fiTo":U).
        ASSIGN hWidget       = widgetHandle("fiFrom":U)
               hWidget:LABEL = "From value"
               hWidget       = widgetHandle("fiTo":U)
               hWidget:LABEL = "To value".
    END.
END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-excelDump) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE excelDump Procedure 
PROCEDURE excelDump :
/*------------------------------------------------------------------------------
  Purpose:     Dump the contents of the security browser to Excel
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hContainerHandle AS HANDLE NO-UNDO.

IF NOT VALID-HANDLE(ghBrowse) THEN
    RETURN.

{get containerSource hContainerHandle}.

RUN transferToExcel IN TARGET-PROCEDURE (INPUT ghBrowse, INPUT hContainerHandle).

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-filterChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE filterChanged Procedure 
PROCEDURE filterChanged :
/*------------------------------------------------------------------------------
  Purpose:     Fires when the filter radio-set changes.  The user can display:
               - All security Object.
               - Secured security Objects.
               - Non secured security objects.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE lRevokeModel        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cSecurityModel      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cChoice             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lSecuredFlagToCheck AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cQueryString        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cQueryStart         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cQueryEnd           AS CHARACTER  NO-UNDO.

ASSIGN cSecurityModel = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager, INPUT "securityModel":U, INPUT YES)
       lRevokeModel   = cSecurityModel <> "Grant":U
       cChoice        = formattedWidgetValue("raShowSecured":U).

CASE cChoice:
    WHEN "All":U    THEN ASSIGN lSecuredFlagToCheck = ?.
    WHEN "Sec":U    THEN ASSIGN lSecuredFlagToCheck = lRevokeModel.
    WHEN "NonSec":U THEN ASSIGN lSecuredFlagToCheck = NOT lRevokeModel.
END CASE.

IF NOT VALID-HANDLE(ghQuery) THEN
    RETURN.

/* Our query is always going to have a FOR EACH ... NO-LOCK and a BY .... *
 * We won't have any where clauses as filtering is resolved on the db     *
 * and a full temp-table always returned.                                 *
 * We always want to add our where clause between the NO-LOCK and BY      */
ASSIGN cQueryString = ghQuery:PREPARE-STRING
       cQueryStart  = SUBSTRING(cQueryString,1,INDEX(cQueryString,"NO-LOCK") + 6)
       cQueryEnd    = SUBSTRING(cQueryString, INDEX(cQueryString,"BY")).

IF lSecuredFlagToCheck = ? THEN
    ASSIGN cQueryString = cQueryStart + " ":U + cQueryEnd.
ELSE
    ASSIGN cQueryString = cQueryStart + " WHERE lSecured = " + QUOTER(lSecuredFlagToCheck) + " ":U + cQueryEnd.

/* We have our new query prepared, open it */
ghQuery:QUERY-CLOSE.
ghQuery:QUERY-PREPARE(cQueryString).
ghQuery:QUERY-OPEN.

/* Select the first line in the browse */
IF VALID-HANDLE(ghBrowse) 
THEN DO:
    APPLY "ENTRY":U TO ghBrowse.
    ghBrowse:SELECT-ROW(1) NO-ERROR.
    APPLY "value-changed":U TO ghBrowse.
END.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSecurityModel   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainerSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFrame           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hHeaderViewer    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lRevokeModel     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hWidget          AS HANDLE     NO-UNDO.

  {set hideOnInit TRUE}.

  ASSIGN ghFilterViewer = WIDGET-HANDLE(DYNAMIC-FUNCTION("linkHandles":U IN TARGET-PROCEDURE, INPUT "SecFilter-target":U))
         hHeaderViewer  = WIDGET-HANDLE(DYNAMIC-FUNCTION("linkHandles":U IN TARGET-PROCEDURE, INPUT "Security-source":U)).

  IF VALID-HANDLE(hHeaderViewer) THEN
      RUN hideRowsToBatch IN hHeaderViewer NO-ERROR.

  RUN SUPER.

  /* Make sure the toggle box label is set correctly */
  ASSIGN cSecurityModel        = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager, INPUT "securityModel":U, INPUT YES)
         lRevokeModel          = cSecurityModel <> "Grant":U
         hWidget               = widgetHandle("toSecured":U)
         hWidget:RADIO-BUTTONS = IF lRevokeModel
                                 THEN "Access revoked,Yes,Not secured,No":U
                                 ELSE "No access,Yes,Access granted,No":U
         hWidget               = widgetHandle("raShowSecured":U)
         hWidget:RADIO-BUTTONS = IF lRevokeModel
                                 THEN "All,All,Secured only,Sec,Unsecured only,Nonsec":U
                                 ELSE "All,All,Access granted,Sec,Secured items,Nonsec":U.

  /* The browse gets initialised in procedure refreshQueryDetail, which is run from the filter viewer */

  /* Make sure the frame is sized correctly */
  {get ContainerHandle hFrame}.
  IF VALID-HANDLE(hFrame) 
  THEN DO:
      IF gdLastSetHeight = 0
      OR gdLastSetWidth  = 0 THEN
          ASSIGN gdLastSetHeight = hFrame:HEIGHT-CHARS
                 gdLastSetWidth  = hFrame:WIDTH-CHARS.

      RUN resizeObject IN TARGET-PROCEDURE (INPUT gdLastSetHeight, INPUT gdLastSetWidth).
  END.

  /* Now disable all the fields, they will be enabled correctly when the user *
   * presses 'Refresh' on the filter viewer.                                  */
  hideWidget("text-1,raShowSecured,toSecured,fiLabel,seInfo,fiFrom,fiTo,buExcel":U).
  
  RUN viewObject IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-refreshQueryDetail) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshQueryDetail Procedure 
PROCEDURE refreshQueryDetail :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is run when the user presses "Refresh" on the filter
               viewer.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdUserObj       AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdCompanyObj    AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pcEntity        AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcEntityName    AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER plDataSecurity  AS LOGICAL    NO-UNDO.
  DEFINE INPUT PARAMETER piRowsToBatch   AS INTEGER    NO-UNDO.

  DEFINE VARIABLE hContainerSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFolderHandle    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cButton          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessageList     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hFrame           AS HANDLE     NO-UNDO.

  IF pcEntity = "":U 
  OR pcEntity = ? THEN
      RETURN.

  IF VALID-HANDLE(ghBrowse) THEN DELETE OBJECT ghBrowse.
  IF VALID-HANDLE(ghQuery)  THEN DELETE OBJECT ghQuery.
  IF VALID-HANDLE(ghTable)  THEN DELETE OBJECT ghTable.
  IF VALID-HANDLE(ghBuffer) THEN DELETE OBJECT ghBuffer.

  ASSIGN gdUserObj    = pdUserObj
         gdCompanyObj = pdCompanyObj 
         gcEntity     = pcEntity.

  /* Hour glass ON */
  SESSION:SET-WAIT-STATE("general":U).
  ERROR-STATUS:ERROR = FALSE.

  /* Go and fetch the data */
  {
   dynlaunch.i &PLIP     = "'af/app/securenqry.p'"
               &iProc    = "'getData'"
               &OnApp    = YES
               &AutoKill = YES   
               
               &mode1 = INPUT  &parm1 = gcEntity     &dataType1 = CHARACTER
               &mode2 = INPUT  &parm2 = gdUserObj    &dataType2 = DECIMAL
               &mode3 = INPUT  &parm3 = gdCompanyObj &dataType3 = DECIMAL
               &mode4 = INPUT  &parm4 = gcFilterData &dataType4 = CHARACTER
               &mode5 = OUTPUT &parm5 = ghTable      &dataType5 = TABLE-HANDLE
  }
  IF ERROR-STATUS:ERROR 
  OR RETURN-VALUE <> "":U 
  THEN DO:
      ASSIGN cMessageList = RETURN-VALUE.
      IF cMessageList <> "":U THEN
          RUN showMessages IN gshSessionManager (INPUT cMessageList,
                                                 INPUT "ERR":U,
                                                 INPUT "OK":U,
                                                 INPUT "OK":U,
                                                 INPUT "OK":U,
                                                 INPUT "Error",
                                                 INPUT YES,
                                                 INPUT ?,
                                                 OUTPUT cButton).
      RETURN.
  END.

  IF VALID-HANDLE(ghTable) THEN
    ASSIGN ghBuffer = ghTable:DEFAULT-BUFFER-HANDLE.

  RUN createBrowse IN TARGET-PROCEDURE. 

  IF VALID-HANDLE(ghFilterViewer) THEN
    RUN buildFilter IN ghFilterViewer (INPUT ghBuffer).
  
  {get ContainerSource hContainerSource}.
  {get PageSource hFolderHandle hContainerSource}.

  /* Enable second Tab Page */
  RUN enableFolderPage IN hFolderHandle (INPUT 2).

  /* Enable/disable fields as appropriate */
  RUN enableWidgets IN TARGET-PROCEDURE (INPUT pcEntity).

  /* Make sure our secured/non secured radio set has been applied */
  RUN filterChanged IN TARGET-PROCEDURE.

  /* And make sure everything fits nicely */
  {get ContainerHandle hFrame}.
  RUN resizeObject IN TARGET-PROCEDURE (INPUT hFrame:HEIGHT, INPUT hFrame:WIDTH).

  /* Hour glass OFF */
  SESSION:SET-WAIT-STATE("":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-repositionObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionObject Procedure 
PROCEDURE repositionObject :
/*------------------------------------------------------------------------------
  Purpose:     Override procedure to add NO-ERROR to assignment of COL and ROW
               due to unexplained errors.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdRow AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pdCol AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE hContainer  AS HANDLE     NO-UNDO.

  {get ContainerHandle hContainer}.
  
  IF VALID-HANDLE(hContainer) THEN
      ASSIGN hContainer:ROW = pdRow
             hContainer:COL = pdCol 
             NO-ERROR.

  ASSIGN ERROR-STATUS:ERROR = NO.
  RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resizeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject Procedure 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pdHeight AS DECIMAL NO-UNDO.
DEFINE INPUT PARAMETER pdWidth  AS DECIMAL NO-UNDO.

DEFINE VARIABLE hFrame AS HANDLE NO-UNDO.
      
ASSIGN gdLastSetWidth  = pdWidth
       gdLastSetHeight = pdHeight.

{get ContainerHandle hFrame}.
IF NOT VALID-HANDLE(hFrame) THEN
    RETURN.
                   
IF pdWidth  <= 0 
OR pdHeight <= 0 THEN 
    RETURN.

IF pdWidth  < hFrame:WIDTH 
OR pdHeight < hFrame:HEIGHT 
THEN DO:
    /* Move All Widgets and then the frame */
    RUN resizeWidgets IN TARGET-PROCEDURE (INPUT pdHeight, INPUT pdWidth).
    ASSIGN hFrame:SCROLLABLE     = TRUE
           hFrame:WIDTH          = pdWidth
           hFrame:HEIGHT         = pdHeight
           hFrame:VIRTUAL-WIDTH  = pdWidth
           hFrame:VIRTUAL-HEIGHT = pdHeight
           hFrame:SCROLLABLE     = FALSE.
END.
ELSE DO:
    /* Move the frame and then the widgets */
    ASSIGN hFrame:SCROLLABLE     = TRUE
           hFrame:WIDTH          = pdWidth
           hFrame:HEIGHT         = pdHeight
           hFrame:VIRTUAL-WIDTH  = pdWidth
           hFrame:VIRTUAL-HEIGHT = pdHeight
           hFrame:SCROLLABLE     = FALSE
           pdHeight              = hFrame:HEIGHT
           pdWidth               = hFrame:WIDTH.

    RUN resizeWidgets IN TARGET-PROCEDURE (INPUT pdHeight, INPUT pdWidth).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resizeWidgets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeWidgets Procedure 
PROCEDURE resizeWidgets :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will move all the widgets on the frame to where
               they need to be
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdHeight AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdWidth  AS DECIMAL    NO-UNDO.
  
  DEFINE VARIABLE dHeightDiff   AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE hWidget       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hStoreSelHndl AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hLabel        AS HANDLE     NO-UNDO.

  /* Move the selection list */
  ASSIGN hWidget = DYNAMIC-FUNCTION("internalWidgetHandle" IN TARGET-PROCEDURE,"seInfo":U, "ALL":U).
  IF VALID-HANDLE(hWidget) THEN
      ASSIGN dHeightDiff   = (pdHeight - 2.5) - hWidget:ROW
             hWidget:ROW   = hWidget:ROW + dHeightDiff
             hWidget:WIDTH = IF NOT CAN-DO("GSMRA,GSMFF":U, gcEntity)
                             THEN pdWidth / 2
                             ELSE hWidget:WIDTH
             hStoreSelHndl = hWidget.

  /* Move the selection list label */
  ASSIGN hWidget = DYNAMIC-FUNCTION("internalWidgetHandle" IN TARGET-PROCEDURE,"fiLabel":U, "ALL":U).
  IF VALID-HANDLE(hWidget) THEN 
      ASSIGN hWidget:ROW   = hWidget:ROW + dHeightDiff
             hWidget:WIDTH = IF NOT CAN-DO("GSMRA,GSMFF":U, gcEntity)
                             THEN pdWidth / 2
                             ELSE hWidget:WIDTH.

  /* Move the toggle box */
  ASSIGN hWidget = DYNAMIC-FUNCTION("internalWidgetHandle" IN TARGET-PROCEDURE,"toSecured":U, "ALL":U).
  IF VALID-HANDLE(hWidget) THEN 
      ASSIGN hWidget:ROW = hWidget:ROW + dHeightDiff.

  /* Move the browse */
  IF VALID-HANDLE(ghBrowse) 
  THEN DO:
      ASSIGN ghBrowse:WIDTH-CHARS  = pdWidth  - 2
             ghBrowse:HEIGHT-CHARS = pdHeight - 6.5
             /* Move the Excel button */
             hWidget     = DYNAMIC-FUNCTION("internalWidgetHandle" IN TARGET-PROCEDURE,"buExcel":U, "ALL":U)
             hWidget:ROW = ghBrowse:ROW + ghBrowse:HEIGHT + 0.24
             hWidget:COL = (ghBrowse:COL + ghBrowse:WIDTH) - hWidget:WIDTH.

      /* Move the from value field */
      ASSIGN hWidget = DYNAMIC-FUNCTION("internalWidgetHandle" IN TARGET-PROCEDURE,"fiFrom":U, "ALL":U).
      IF VALID-HANDLE(hWidget) 
      THEN DO:
          ASSIGN hWidget:ROW = hWidget:ROW + dHeightDiff
                 hWidget:COL = pdWidth - hWidget:WIDTH - 1

                 hLabel              = hWidget:SIDE-LABEL-HANDLE
                 hLabel:ROW          = hLabel:ROW + dHeightDiff
                 hLabel:SCREEN-VALUE = REPLACE(TRIM(hLabel:SCREEN-VALUE), ":":U, "":U) + ": ":U
                 hLabel:WIDTH-PIXELS = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(hLabel:SCREEN-VALUE + ": ":U, hLabel:FONT)
                 hLabel:X            = hWidget:X - hLabel:WIDTH-PIXELS.
      END.

      /* Move the to value field */
      ASSIGN hWidget = DYNAMIC-FUNCTION("internalWidgetHandle" IN TARGET-PROCEDURE,"fiTo":U, "ALL":U).
      IF VALID-HANDLE(hWidget) 
      THEN DO:
          ASSIGN hWidget:ROW = hWidget:ROW + dHeightDiff
                 hWidget:COL = pdWidth - hWidget:WIDTH - 1

                 hLabel              = hWidget:SIDE-LABEL-HANDLE
                 hLabel:ROW          = hLabel:ROW + dHeightDiff
                 hLabel:SCREEN-VALUE = REPLACE(TRIM(hLabel:SCREEN-VALUE), ":":U, "":U) + ": ":U
                 hLabel:WIDTH-PIXELS = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(hLabel:SCREEN-VALUE + ": ":U, hLabel:FONT)
                 hLabel:X            = hWidget:X - hLabel:WIDTH-PIXELS.
      END.
  END.
  ELSE DO:
      /* Move the from value field, but only the row */
      ASSIGN hWidget = DYNAMIC-FUNCTION("internalWidgetHandle" IN TARGET-PROCEDURE,"fiFrom":U, "ALL":U).
      IF VALID-HANDLE(hWidget) THEN
          ASSIGN hWidget:ROW = hWidget:ROW + dHeightDiff
                 hLabel              = hWidget:SIDE-LABEL-HANDLE
                 hLabel:ROW          = hLabel:ROW + dHeightDiff.

      /* Move the to value field, but only the row */
      ASSIGN hWidget = DYNAMIC-FUNCTION("internalWidgetHandle" IN TARGET-PROCEDURE,"fiTo":U, "ALL":U).
      IF VALID-HANDLE(hWidget) THEN
          ASSIGN hWidget:ROW = hWidget:ROW + dHeightDiff
                 hLabel              = hWidget:SIDE-LABEL-HANDLE
                 hLabel:ROW          = hLabel:ROW + dHeightDiff.
  END.

  ASSIGN ERROR-STATUS:ERROR = NO.
  RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-startSearch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startSearch Procedure 
PROCEDURE startSearch :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hColumn AS HANDLE     NO-UNDO.
  DEFINE VARIABLE rRow    AS ROWID      NO-UNDO.
  DEFINE VARIABLE cSortBy AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQuery  AS CHARACTER  NO-UNDO.

  SESSION:SET-WAIT-STATE("GENERAL":U).

  /* Get handle to current column and save current position in browser */
  ASSIGN hColumn = ghBrowse:CURRENT-COLUMN
         rRow    = ghBuffer:ROWID.

  /* Handle to current column is valid */
  IF VALID-HANDLE(hColumn) 
  THEN DO:
      /* Construct sort string */
      ASSIGN cSortBy = (IF hColumn:TABLE <> ? 
                        THEN hColumn:TABLE + '.':U + hColumn:NAME
                        ELSE hColumn:NAME).

      /* Construct query string using sort string, then open query */
      ASSIGN cQuery = "FOR EACH ":U + ghBuffer:NAME + " NO-LOCK BY ":U + cSortBy.

      IF ghQuery:IS-OPEN THEN ghQuery:QUERY-CLOSE().
      ghQuery:QUERY-PREPARE(cQuery).
      ghQuery:QUERY-OPEN().

      /* If new result set contains data, then reposition to the record in the browser saved in rRow */
      IF ghQuery:NUM-RESULTS > 0 
      THEN DO:
          ghQuery:REPOSITION-TO-ROWID(rRow) NO-ERROR.
          ghBrowse:CURRENT-COLUMN = hColumn.
          APPLY 'VALUE-CHANGED':U TO ghBrowse.
      END.
  END.
  SESSION:SET-WAIT-STATE("":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-transferToExcel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE transferToExcel Procedure 
PROCEDURE transferToExcel :
/*------------------------------------------------------------------------------
  Purpose:  Transfers the contents of a browser to Excel

  Parameters:  INPUT phBrowse          - The handle of the browse that needs to
                                         be exported to Excel
               INPUT phContainerSource - The handle of the container the browse
                                         is on (needed for the container's title)

  Notes:  The browse is used to export the data to Excel seeing that there might
          be calculated fields in the browse that you would not be able to pick
          up from the query associated with the browse.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phBrowse           AS HANDLE     NO-UNDO.
  DEFINE INPUT PARAMETER phContainerSource  AS HANDLE     NO-UNDO.

  DEFINE VARIABLE chWorkSheet       AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE chWorkbook        AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE chExcel           AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE cButton           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabel            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRange            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lExcelInstalled   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSensitive        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iSelectedRow      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCurrentRow       AS INTEGER    NO-UNDO INITIAL 1.
  DEFINE VARIABLE iReposRow         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iColumn           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iRow              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hContainerHandle  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cTitle            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iNumColumns       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cStoreColumns     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hColumn           AS HANDLE     NO-UNDO.

  SESSION:SET-WAIT-STATE("GENERAL":U).

  /* Only allow export to MS Excel if at least Office97 exists */
  LOAD "Excel.Application":U BASE-KEY "HKEY_CLASSES_ROOT":U NO-ERROR. /* Open Registry key */
  lExcelInstalled = NOT ERROR-STATUS:ERROR.
  UNLOAD "Excel.Application":U NO-ERROR.

  /* If Excel is not installed, inform the user and exit */
  IF NOT lExcelInstalled 
  THEN DO:
      SESSION:SET-WAIT-STATE("":U).
      ASSIGN cErrorMessage = "Excel not installed or running version prior to Office 97".

      RUN showMessages IN gshSessionManager (INPUT cErrorMessage,
                                             INPUT "INF":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "Excel Tranfer Error",
                                             INPUT YES,
                                             INPUT ?,
                                             OUTPUT cButton).
      RETURN.
  END.

  /* Start Excel up */
  CREATE "Excel.Application" chExcel NO-ERROR.

  {get ContainerSource hContainerHandle phContainerSource}.
  {get windowName cTitle hContainerHandle}.

  ASSIGN 
      lSensitive            = phBrowse:SENSITIVE
      phBrowse:SENSITIVE    = FALSE
      chExcel:VISIBLE       = FALSE
      chExcel:WindowState   = -4140 /* Minimized */      
      chExcel:DisplayAlerts = FALSE
      chWorkbook            = chExcel:Workbooks:ADD()  /* Create a new Workbook                        */
      chWorkSheet           = chExcel:Sheets:ITEM(1)   /* Get the active Worksheet                     */
      chWorkSheet:NAME      = "Browser Details"        /* Set the worksheet name                       */
      iSelectedRow          = phBrowse:QUERY:CURRENT-RESULT-ROW
      iReposRow             = phBrowse:FOCUSED-ROW.
  
  /* Insert the title contents into the sheet if required */
  ASSIGN
      cRange                              = "A":U + STRING(iCurrentRow)
      chWorkSheet:Range(cRange):VALUE     = cTitle
      chWorkSheet:Range(cRange):FONT:Bold = TRUE
      iCurrentRow                         = iCurrentRow + 2.

  /* Insert column headings */
  ASSIGN iNumColumns = IF phBrowse:NUM-COLUMNS > 26
                       THEN 26
                       ELSE phBrowse:NUM-COLUMNS.

  DO iColumn = 1 TO iNumColumns:
    ASSIGN
        cRange                              = CHR(ASC("A":U) + iColumn - 1) + STRING(iCurrentRow)
        cLabel                              = TRIM(phBrowse:GET-BROWSE-COLUMN(iColumn):LABEL)
        cLabel                              = (IF INDEX(cLabel, "!":U) <> 0 THEN REPLACE(cLabel, "!":U, CHR(10)) ELSE cLabel)
        chWorkSheet:Range(cRange):VALUE     = cLabel
        chWorkSheet:Range(cRange):FONT:Bold = TRUE
        cStoreColumns                       = cStoreColumns + STRING(phBrowse:GET-BROWSE-COLUMN(iColumn)) + CHR(4).
  END.
  
  
  ASSIGN cStoreColumns = RIGHT-TRIM(cStoreColumns, CHR(4)) NO-ERROR.

  /* Position the browse to the first row */
  phBrowse:SELECT-ROW(1).
  
  /* add block for error */
  ProcessRecords:
  DO on error undo,leave:  
    /* Step through the rows in the browse */
    DO iRow = 1 TO phBrowse:QUERY:NUM-RESULTS:
      iCurrentRow = iCurrentRow + 1.
  
      DO iColumn = 1 TO iNumColumns:
          ASSIGN cRange                          = CHR(ASC("A":U) + iColumn - 1) + STRING(iCurrentRow)
                 hColumn                         = WIDGET-HANDLE(ENTRY(iColumn, cStoreColumns, CHR(4)))
                 chWorkSheet:Range(cRange):VALUE = hColumn:SCREEN-VALUE no-error.
      END.
      /* this looop is very slow (navigates visible rows) and the user might 
         press cancel in Excel. Avoid ugly errors */
      if error-status:error then 
        leave ProcessRecords.
      phBrowse:SELECT-NEXT-ROW().
    END.
    
    ASSIGN cRange    = "A3:":U + STRING((CHR(ASC("A":U) + (iNumColumns - 1)) + "3":U)).
    chWorkSheet:Range(cRange):COLUMNS:BorderAround(1,-4138,-4105,-4105).
  
    ASSIGN cRange    = "A3:":U + STRING((CHR(ASC("A":U) + (iNumColumns - 1)) + STRING(iCurrentRow))).
    chWorkSheet:Range(cRange):COLUMNS:BorderAround(1,-4138,-4105,-4105).
    chWorkSheet:Range(cRange):COLUMNS:AutoFit.
  
    ASSIGN chExcel:WindowState   = -4143 /* Maximized */
           chExcel:VISIBLE       = TRUE
           chExcel:DisplayAlerts = TRUE.
  END. /* do on error */
  
  /* Make sure that the COM objects are released properly */
  IF VALID-HANDLE(chWorkSheet)  THEN RELEASE OBJECT chWorkSheet.
  IF VALID-HANDLE(chWorkbook)   THEN RELEASE OBJECT chWorkbook.
  IF VALID-HANDLE(chExcel)      THEN RELEASE OBJECT chExcel.

  ASSIGN
      phBrowse:SENSITIVE   = lSensitive
      chWorkSheet          = ?
      chWorkbook           = ?
      chExcel              = ?.
  /* Put the browse and the query back to the way they were */
  phBrowse:SET-REPOSITIONED-ROW(iReposRow).
  phBrowse:QUERY:REPOSITION-TO-ROW(iSelectedRow).

  SESSION:SET-WAIT-STATE("":U).

  ERROR-STATUS:ERROR = NO.
  RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-viewObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewObject Procedure 
PROCEDURE viewObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hFrame           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContainerSource AS HANDLE     NO-UNDO.

  RUN SUPER.

  {get ContainerHandle hFrame}.
  IF VALID-HANDLE(hFrame) 
  THEN DO:
      IF gdLastSetHeight = 0
      OR gdLastSetWidth  = 0 THEN
          ASSIGN gdLastSetHeight = hFrame:HEIGHT-CHARS
                 gdLastSetWidth  = hFrame:WIDTH-CHARS.

      RUN resizeObject IN TARGET-PROCEDURE (INPUT gdLastSetHeight, INPUT gdLastSetWidth).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-setDataModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataModified Procedure 
FUNCTION setDataModified RETURNS LOGICAL
  ( plModified AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Override this procedure, otherwise we will be prompted to save the
            data on leave.
    Notes:  
------------------------------------------------------------------------------*/
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

