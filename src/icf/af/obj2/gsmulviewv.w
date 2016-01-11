&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
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
/*---------------------------------------------------------------------------------
  File: gsmulviewv.w

  Description:  Security Allocation SmartViewer

  Purpose:      Lists security allocations from the user allocations table (gsm_user_allocation, GSMUL)
                for a given user, login company, and security type.

  Parameters:

  History:
  --------
  (v:010000)    Task:           0   UserRef:    POSSE
                Date:   28/03/2002  Author:     Phillip Magnay

  Update Notes: Created new object

  (v:010001)    Task:           0   UserRef:    
                Date:   02/11/2002  Author:     Mark Davies (MIP)

  Update Notes: Fix for issue #3869 - HIGH-CHARACTER preprocessor is wrong

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

&scop object-name       gsmulviewv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartObject YES

{af/sup2/afglobals.i}

DEFINE VARIABLE glModified                  AS LOGICAL INITIAL NO.  /* Data modified flag with UNDO */
DEFINE VARIABLE gcCallerName                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcErrorMessage              AS CHARACTER  NO-UNDO.  /* Error message text */
DEFINE VARIABLE gcAbort                     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ghCallerHandle              AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghBrowse                    AS HANDLE     NO-UNDO.  /* Handle to dynamic browser */
DEFINE VARIABLE ghQuery                     AS HANDLE     NO-UNDO.  /* Handle to query on temp table */
DEFINE VARIABLE ghTable                     AS HANDLE     NO-UNDO.  /* Handle to temp table */
DEFINE VARIABLE ghBuffer                    AS HANDLE     NO-UNDO.  /* Handle to temp table buffer */

/* Query parameter temp table */
{af/app/gsmulttqpm.i}

/* Filter temp table*/
{af/sup2/afttlkfilt.i}

/* Preprocessor types for security types */
{af/app/gsmuldefns.i}

/* PLIP definitions */
{af/sup2/afrun2.i &define-only = YES }

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiUserID fiLoginCompany coSecurityType ~
fiEntityMnemonic buSave buRefresh buCascade fiRowsToBatch 
&Scoped-Define DISPLAYED-OBJECTS fiUserID fiUserName fiLoginCompany ~
fiLoginCoName coSecurityType fiEntityMnemonic fiRowsToBatch fiNumRecs ~
ToComplete 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentPage sObject 
FUNCTION getCurrentPage RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD insertExpression sObject 
FUNCTION insertExpression RETURNS CHARACTER
    (pcWhere      AS CHAR,   
     pcExpression AS CHAR,     
     pcAndOr      AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD newQueryString sObject 
FUNCTION newQueryString RETURNS CHARACTER
      (pcQueryTables AS CHARACTER,
       pcColumns     AS CHARACTER,   
       pcValues      AS CHARACTER,    
       pcDataTypes   AS CHARACTER,    
       pcOperators   AS CHARACTER,
       pcQueryString AS CHARACTER,
       pcAndOr       AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD newWhereClause sObject 
FUNCTION newWhereClause RETURNS CHARACTER
    (pcBuffer     AS CHAR,   
     pcExpression AS char,  
     pcWhere      AS CHAR,
     pcAndOr      AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD whereClauseBuffer sObject 
FUNCTION whereClauseBuffer RETURNS CHARACTER
    (pcWhere AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON buCascade 
     LABEL "&Cascade" 
     SIZE 15 BY 1.05
     BGCOLOR 8 .

DEFINE BUTTON buRefresh 
     LABEL "&Refresh" 
     SIZE 15 BY 1.05
     BGCOLOR 8 .

DEFINE BUTTON buRestrictAll 
     LABEL "Restrict &All" 
     SIZE 15 BY 1.05
     BGCOLOR 8 .

DEFINE BUTTON buSave 
     LABEL "&Save" 
     SIZE 15 BY 1.05
     BGCOLOR 8 .

DEFINE BUTTON buUnrestrictAll 
     LABEL "&Unrestrict All" 
     SIZE 15 BY 1.05
     BGCOLOR 8 .

DEFINE VARIABLE coSecurityType AS CHARACTER FORMAT "X(256)":U INITIAL "1" 
     LABEL "Security Type" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Menu Structures","1",
                     "Menu Items","2",
                     "Access Tokens","3",
                     "Fields","4",
                     "Data Ranges","5",
                     "Data Records","6",
                     "Login Companies","7"
     DROP-DOWN-LIST
     SIZE 34.4 BY 1 NO-UNDO.

DEFINE VARIABLE fiEntityMnemonic AS CHARACTER FORMAT "X(256)":U 
     LABEL "Entity Mnemonic" 
     VIEW-AS FILL-IN 
     SIZE 28 BY 1 NO-UNDO.

DEFINE VARIABLE fiLoginCompany AS CHARACTER FORMAT "X(256)":U 
     LABEL "Login Company" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE fiLoginCoName AS CHARACTER FORMAT "X(35)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY 1 NO-UNDO.

DEFINE VARIABLE fiNumRecs AS INTEGER FORMAT "->>>>>>>9":U INITIAL 0 
     LABEL "Records Read" 
     VIEW-AS FILL-IN 
     SIZE 17.4 BY 1 TOOLTIP "Number of records read so far" NO-UNDO.

DEFINE VARIABLE fiRowsToBatch AS INTEGER FORMAT "->>>>>9":U INITIAL 100 
     LABEL "Rows to Batch" 
     VIEW-AS FILL-IN 
     SIZE 13.2 BY 1 TOOLTIP "Specify number of records to read in each batch" NO-UNDO.

DEFINE VARIABLE fiUserID AS CHARACTER FORMAT "X(256)":U 
     LABEL "User ID" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE fiUserName AS CHARACTER FORMAT "X(35)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY 1 NO-UNDO.

DEFINE VARIABLE ToComplete AS LOGICAL INITIAL no 
     LABEL "Query Complete" 
     VIEW-AS TOGGLE-BOX
     SIZE 21.4 BY .81 TOOLTIP "All records in query retrieved" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     fiUserID AT ROW 1 COL 17 COLON-ALIGNED
     fiUserName AT ROW 1 COL 39 COLON-ALIGNED NO-LABEL
     fiLoginCompany AT ROW 2.05 COL 17 COLON-ALIGNED
     fiLoginCoName AT ROW 2.05 COL 39 COLON-ALIGNED NO-LABEL
     coSecurityType AT ROW 3.38 COL 17 COLON-ALIGNED
     fiEntityMnemonic AT ROW 3.38 COL 75 COLON-ALIGNED
     buRestrictAll AT ROW 3.48 COL 113.8
     buSave AT ROW 3.48 COL 130.2
     buRefresh AT ROW 4.71 COL 97.4
     buUnrestrictAll AT ROW 4.71 COL 113.8
     buCascade AT ROW 4.71 COL 130.2
     fiRowsToBatch AT ROW 4.86 COL 17 COLON-ALIGNED
     fiNumRecs AT ROW 4.86 COL 47.6 COLON-ALIGNED
     ToComplete AT ROW 4.91 COL 69.4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 145.2 BY 14.86.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartObject
   Allow: Basic,Smart
   Container Links: 
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
         HEIGHT             = 14.86
         WIDTH              = 145.2.
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
   NOT-VISIBLE                                                          */
ASSIGN 
       FRAME frMain:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON buRestrictAll IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON buUnrestrictAll IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiLoginCoName IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiNumRecs IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiUserName IN FRAME frMain
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

&Scoped-define SELF-NAME buCascade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buCascade sObject
ON CHOOSE OF buCascade IN FRAME frMain /* Cascade */
DO:
    /* Save changes with user cascade option set to YES */
    RUN saveChanges (INPUT YES).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRefresh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRefresh sObject
ON CHOOSE OF buRefresh IN FRAME frMain /* Refresh */
DO:
    /* (Re)Build browser and data set*/
    RUN buildBrowser.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRestrictAll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRestrictAll sObject
ON CHOOSE OF buRestrictAll IN FRAME frMain /* Restrict All */
DO:
    /* Set logical restriction to YES for all records in current data set 
       ie. WARNING: only records currently in the browser, NOT the complete query result set */
    RUN setRestrictAll (INPUT YES).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSave sObject
ON CHOOSE OF buSave IN FRAME frMain /* Save */
DO: 
    /* Save changes with user cascade option set to NO */
    RUN saveChanges (INPUT NO).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buUnrestrictAll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buUnrestrictAll sObject
ON CHOOSE OF buUnrestrictAll IN FRAME frMain /* Unrestrict All */
DO:
    /* Set logical restriction to NO for all records in current data set 
       ie. WARNING: only records currently in the browser, NOT the complete query result set */
    RUN setRestrictAll (INPUT NO).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coSecurityType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coSecurityType sObject
ON VALUE-CHANGED OF coSecurityType IN FRAME frMain /* Security Type */
DO:  
    /* Delete browse if it exists */
    IF VALID-HANDLE(ghBrowse) THEN
        DELETE OBJECT ghBrowse.
    /* Enable/Disable UI objects according to chosen Security Type */
    ASSIGN
        {&SELF-NAME}
        /* Set Entity Mnemonic fillin value for given security type value
           from the corresponding entry in {&ENTITY-MNEMONIC-LIST} (see gsmuldefns.i) */
        fiEntityMnemonic:SCREEN-VALUE = ENTRY(INTEGER({&SELF-NAME}),{&ENTITY-MNEMONIC-LIST})
        fiEntityMnemonic:SENSITIVE    = (SELF:SCREEN-VALUE EQ '{&DATA-RECORDS}':U)
        buRestrictAll:SENSITIVE       = (SELF:SCREEN-VALUE NE '{&FIELDS}':U AND SELF:SCREEN-VALUE NE '{&DATA-RANGES}':U AND 
                                         VALID-HANDLE(ghBrowse))
        buUnrestrictall:SENSITIVE     = (SELF:SCREEN-VALUE NE '{&FIELDS}':U AND SELF:SCREEN-VALUE NE '{&DATA-RANGES}':U AND 
                                         VALID-HANDLE(ghBrowse))
        fiLoginCompany:SENSITIVE      = (SELF:SCREEN-VALUE NE '{&LOGIN-COMPANIES}':U)
        .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiLoginCompany
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiLoginCompany sObject
ON LEAVE OF fiLoginCompany IN FRAME frMain /* Login Company */
DO:
    /* Validate Login Company and retrieve Company Name */
    RUN validateLoginCompany.  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects sObject  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyFilters sObject 
PROCEDURE applyFilters :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to apply filters from filter window
  Parameters:  input temp table (ttLookFilt) containing records of filter criteria

  Notes:       Accepts filter criteria stored as records in a temp table. 
               Uses this data to set new query parameters in ttQueryParams
               in order to construct and launch a new query which includes
               the filter criteria.
               Fetches first batch of records from the new query and
               displays in the dynamic browser.
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER TABLE FOR ttLookFilt.

    DEFINE VARIABLE cFilterFields               AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cFilterValues               AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cFilterTypes                AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cFilterOperators            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE iLoop                       AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cBaseQueryString            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cErrorMessage               AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cHighChar                   AS CHARACTER  NO-UNDO.

    cHighChar = DYNAMIC-FUNCTION("getHighKey":U IN gshGenManager, SESSION:CPCOLL).

    /* Process each record in ttLookupFilt and construct delimited strings of field name, datatypes, operators, 
       and data values for filter 'from' and 'to' criteria in order to send as parameters to newQueryString function call below */
    filter-loop:
    FOR EACH ttLookFilt:
      IF ttLookFilt.cFromValue = "":U AND ttLookFilt.cToValue = "":U THEN NEXT filter-loop.

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
      END. /* IF ttLookFilt.cFromValue <> "":U */

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
      END. /* IF ttLookFilt.cToValue <> "":U */

    END. /* FOR EACH ttLookFilt */

    /* Initialise query batch position and save original query string */
    FIND FIRST ttQueryParams NO-ERROR.
    IF NOT AVAILABLE ttQueryParams THEN RETURN.
    ASSIGN
       ttQueryParams.iFirstRowNum    = 0
       ttQueryParams.iLastRowNum     = 0
       ttQueryParams.cFirstResultRow = "":U
       ttQueryParams.cLastResultRow  = "":U
       ttQueryParams.cRowIdent       = "":U
       cBaseQueryString              = ttQueryParams.cBaseQueryString
       .

    /* Construct a new Where clause which incorporates filter from and to values */
    ttQueryParams.cBaseQueryString 
        = DYNAMIC-FUNCTION('newQueryString':U IN THIS-PROCEDURE,
                            ttQueryParams.cQueryTables,
                            cFilterFields,
                            cFilterValues,
                            cFilterTypes,
                            cFilterOperators,
                            ttQueryParams.cBaseQueryString,
                            ?).    
    RELEASE ttQueryParams.

    /* Run new query and fetch initial batch of records via PLIP call */
    {af/sup2/afrun2.i      &PLIP  = 'af/app/gsmulplipp.p'
                           &IPROC = 'getQueryResultSet'
                           &onApp = 'yes'
                           &PLIST = "(INPUT fiUserID:SCREEN-VALUE IN FRAME {&FRAME-NAME},~
                                      INPUT fiLoginCompany:SCREEN-VALUE IN FRAME {&FRAME-NAME},~
                                      INPUT coSecurityType:SCREEN-VALUE IN FRAME {&FRAME-NAME},~
                                      INPUT fiEntityMnemonic:SCREEN-VALUE IN FRAME {&FRAME-NAME},~
                                      INPUT-OUTPUT TABLE ttQueryParams,~
                                      OUTPUT TABLE-HANDLE ghTable,~
                                      OUTPUT cErrorMessage)"
                           &Define-only = NO
                           &autokill = YES}

    /* If PLIP internal procedure call returns an error message, then show to user */
    IF cErrorMessage <> "":U THEN
    DO:
       RUN showMessages IN gshSessionManager (INPUT cErrorMEssage,
                                              INPUT "ERR":U,
                                              INPUT "OK":U,
                                              INPUT "OK":U,
                                              INPUT "OK":U,
                                              INPUT "Get Query Result Set Error",
                                              INPUT YES,
                                              INPUT ?,
                                              OUTPUT gcAbort).
       ERROR-STATUS:ERROR = NO.
       RETURN NO-APPLY.
    END.


    /* If handle to returned dynamic temp table is valid */
    IF VALID-HANDLE(ghTable) THEN
    DO:

        /* Refetch query parameters record AND Update query results information to UI*/
        FIND FIRST ttQueryParams NO-ERROR.
        IF NOT AVAILABLE ttQueryParams THEN RETURN.
        DO WITH FRAME {&FRAME-NAME}:
           ASSIGN
               toComplete:SCREEN-VALUE = STRING(ttQueryParams.iLastRowNum <> 0)
               fiNumRecs:SCREEN-VALUE  = ENTRY(1,ttQueryParams.cLastResultRow,";":U)
               .
        END.

        /* Restore original query string */
        ttQueryParams.cBaseQueryString = cBaseQueryString.

        /* Refresh latest batch of records in dynamic browser */
        ghBrowse:REFRESHABLE = NO.
        IF ttQueryParams.cLastResultRow <> "":U THEN
           ghBrowse:MAX-DATA-GUESS = INTEGER(ENTRY(1,ttQueryParams.cLastResultRow,";":U)).
        IF ghQuery:IS-OPEN THEN ghQuery:QUERY-CLOSE().
        ghQuery:QUERY-OPEN().
        ghBrowse:REFRESHABLE = YES.   

        /* Reposition focus to first record in dynamic browser */
        ghQuery:REPOSITION-TO-ROW(1) NO-ERROR.

    END. /* IF VALID-HANDLE(ghTable) */

    IF VALID-HANDLE(ghBrowse) THEN
       APPLY "entry":U TO ghBrowse.          

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE browseEnd sObject 
PROCEDURE browseEnd :
/*------------------------------------------------------------------------------
  Purpose:     Procedure for 'END' browser event
  Parameters:  <none>
  Notes:       Nothing implemented (yet!)
------------------------------------------------------------------------------*/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE browseHome sObject 
PROCEDURE browseHome :
/*------------------------------------------------------------------------------
  Purpose:     Procedure for 'HOME' browser event
  Parameters:  <none>
  Notes:       Nothing implemented (yet!)
------------------------------------------------------------------------------*/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE browseOffEnd sObject 
PROCEDURE browseOffEnd :
/*------------------------------------------------------------------------------
  Purpose:     Procedure for 'OFF-END' browser event
  Parameters:  <none>
  Notes:      Fetches next batch of records for the given query parameters
              set in ttQueryParams, appends to local temp table, and
              displays in dynamic browser.               
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cRowIdent      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cErrorMessage  AS CHARACTER NO-UNDO.

    /* Fetch current query parameters record */
    FIND FIRST ttQueryParams NO-ERROR.
    IF NOT AVAILABLE ttQueryParams THEN RETURN.

    /* If no more records then return */
    IF ttQueryParams.iLastRowNum > 0 THEN RETURN.    

    /* From the UI set number of records in next batch to fetch */
    DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
        fiRowsToBatch
        ttQueryParams.iRowsToBatch = fiRowsToBatch
        .
    END.

    /* Save last row of previous batch */
    IF NUM-ENTRIES(ttQueryParams.cLastResultRow,";":U) > 1 THEN
       ASSIGN cRowIdent = ENTRY(2, ttQueryParams.cLastResultRow,";":U). 

    /* Fetch next batch of records and append to temp-table */
    {af/sup2/afrun2.i      &PLIP  = 'af/app/gsmulplipp.p'
                           &IPROC = 'getQueryResultSet'
                           &onApp = 'yes'
                           &PLIST = "(INPUT fiUserID:SCREEN-VALUE IN FRAME {&FRAME-NAME},~
                                      INPUT fiLoginCompany:SCREEN-VALUE IN FRAME {&FRAME-NAME},~
                                      INPUT coSecurityType:SCREEN-VALUE IN FRAME {&FRAME-NAME},~
                                      INPUT fiEntityMnemonic:SCREEN-VALUE IN FRAME {&FRAME-NAME},~
                                      INPUT-OUTPUT TABLE ttQueryParams,~
                                      OUTPUT TABLE-HANDLE ghTable APPEND,~
                                      OUTPUT cErrorMessage)"
                           &Define-only = NO
                           &autokill = YES}

    /* If PLIP internal procedure call returns an error message, then show to user */
    IF cErrorMessage <> "":U THEN
    DO:
       RUN showMessages IN gshSessionManager (INPUT cErrorMEssage,
                                              INPUT "ERR":U,
                                              INPUT "OK":U,
                                              INPUT "OK":U,
                                              INPUT "OK":U,
                                              INPUT "Get Query Result Set Error",
                                              INPUT YES,
                                              INPUT ?,
                                              OUTPUT gcAbort).
       ERROR-STATUS:ERROR = NO.
       RETURN NO-APPLY.
    END.

    /* If handle to returned dynamic temp table is valid */
    IF VALID-HANDLE(ghTable) THEN
    DO:

        /* Refetch current query parameters record and update query results information to UI */
        FIND FIRST ttQueryParams.
        DO WITH FRAME {&FRAME-NAME}:
            ASSIGN
                toComplete:SCREEN-VALUE = STRING(ttQueryParams.iLastRowNum <> 0).
                fiNumRecs:SCREEN-VALUE  = ENTRY(1,ttQueryParams.cLastResultRow,";":U)
                .
        END.

        /* Refresh latest batch of records in dynamic browser */
        ghBrowse:REFRESHABLE = NO.
        IF ttQueryParams.cLastResultRow <> "":U THEN
           ghBrowse:MAX-DATA-GUESS = INTEGER(ENTRY(1,ttQueryParams.cLastResultRow,";":U)).        
        IF ghQuery:IS-OPEN THEN ghQuery:QUERY-CLOSE().
        ghQuery:QUERY-OPEN().
        ghBrowse:REFRESHABLE = YES.

        /* Reposition focus to current record in dynamic browser */
        IF cRowIdent <> "":U AND NOT cRowIdent BEGINS "?":U THEN
           RUN repositionBrowse (INPUT cRowIdent).

    END. /* IF VALID-HANDLE(ghTable) */

    IF VALID-HANDLE(ghBrowse) THEN
       APPLY 'entry':U TO ghBrowse.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE browseOffHome sObject 
PROCEDURE browseOffHome :
/*------------------------------------------------------------------------------
  Purpose:     Procedure for 'OFF-HOME' browser event
  Parameters:  <none>
  Notes:       Nothing implemented (yet!)
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildBrowser sObject 
PROCEDURE buildBrowser :
/*------------------------------------------------------------------------------
  Purpose:     Constructs a dynamic data browser on to viewer
  Parameters:  <none>
  Notes:       Query parameters are set according to Security Type chosen in UI.
               Fetches first batch of records in a dynamic temp table for the query
               defined by the parameters in ttQueryParams and other UI values.
               Creates a dynamic browser using the information from the dynamic temp table.
               Populates the dynamic browser using the batch of records in the dynamic temp table.
------------------------------------------------------------------------------*/

    DEFINE VARIABLE hTH                       AS HANDLE     NO-UNDO.
    DEFINE VARIABLE cRowIdent                 AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cQuery                    AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cField                    AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hField                    AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hCurField                 AS HANDLE     NO-UNDO.
    DEFINE VARIABLE iLoop                     AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cBrowseColHdls            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hLookup                   AS HANDLE     NO-UNDO.
    DEFINE VARIABLE cValue                    AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hWindow                   AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hContainerSource          AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hFrame                    AS HANDLE     NO-UNDO.
    DEFINE VARIABLE lPreviouslyHidden         AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE dHeight                   AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE dWidth                    AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE cErrorMessage             AS CHARACTER  NO-UNDO.

    /* Hour glass ON */
    SESSION:SET-WAIT-STATE("general":U).

    DO WITH FRAME {&FRAME-NAME}:

        /* Data Record security cannot be applied the tables of the other security types */
        IF coSecurityType:SCREEN-VALUE = "{&DATA-RECORDS}":U AND 
           CAN-DO({&entity-mnemonic-list},fiEntityMnemonic:SCREEN-VALUE) THEN
        DO:
            cErrorMessage = "Data Record security cannot be applied to the tables of the other security types".
            RUN showMessages IN gshSessionManager (INPUT cErrorMEssage,
                                                   INPUT "ERR":U,
                                                   INPUT "OK":U,
                                                   INPUT "OK":U,
                                                   INPUT "OK":U,
                                                   INPUT "Entity Mnemonic Input Error",
                                                   INPUT YES,
                                                   INPUT ?,
                                                   OUTPUT gcAbort).
            ERROR-STATUS:ERROR = NO.
            RETURN NO-APPLY.

        END.
        /* Initialise query parameters in ttQueryParams temp table */
        RUN setQueryParams(coSecurityType:SCREEN-VALUE).

        /* Fetch first batch of records in a dynamic temp-table */
        {af/sup2/afrun2.i      &PLIP  = 'af/app/gsmulplipp.p'
                               &IPROC = 'getQueryResultSet'
                               &onApp = 'yes'
                               &PLIST = "(INPUT fiUserID:SCREEN-VALUE,~
                                          INPUT fiLoginCompany:SCREEN-VALUE,~
                                          INPUT coSecurityType:SCREEN-VALUE,~
                                          INPUT fiEntityMnemonic:SCREEN-VALUE,~
                                          INPUT-OUTPUT TABLE ttQueryParams,~
                                          OUTPUT TABLE-HANDLE hTH,~
                                          OUTPUT cErrorMessage)"
                               &Define-only = NO
                               &autokill = YES}


        /* If PLIP internal procedure call returns an error message, then show to user */
        IF cErrorMessage <> "":U THEN
        DO:
           RUN showMessages IN gshSessionManager (INPUT cErrorMEssage,
                                                  INPUT "ERR":U,
                                                  INPUT "OK":U,
                                                  INPUT "OK":U,
                                                  INPUT "OK":U,
                                                  INPUT "Get Query Result Set Error",
                                                  INPUT YES,
                                                  INPUT ?,
                                                  OUTPUT gcAbort).
           ERROR-STATUS:ERROR = NO.
           RETURN NO-APPLY.
        END.

    END.

    /* If handle to returned dynamic temp table is valid */
    IF VALID-HANDLE(hTH) THEN
    DO:
        /* Refetch current query parameters record and update query results information to UI */
        FIND FIRST ttQueryParams NO-ERROR.
        DO WITH FRAME {&FRAME-NAME}:
          ASSIGN
             fiRowsToBatch:SCREEN-VALUE = STRING(ttQueryParams.iRowsToBatch)
             toComplete:SCREEN-VALUE    = STRING(ttQueryParams.iLastRowNum <> 0).
             fiNumRecs:SCREEN-VALUE     = ENTRY(1,ttQueryParams.cLastResultRow,";":U).
        END.

        /* Set handle to the dynamic temp-table and temp table buffer */
        ASSIGN 
            ghTable  = hTH    
            ghbuffer = ghTable:DEFAULT-BUFFER-HANDLE
            .

        /* Construct query for dynamic temp table */
        CREATE QUERY ghQuery.
        ghQuery:ADD-BUFFER(ghBuffer).
        ASSIGN cQuery = "FOR EACH ":U + ghBuffer:NAME + " NO-LOCK":U.
        ghQuery:QUERY-PREPARE(cQuery).

        /* Get dimensions of containing window */
        {get ContainerSource hContainerSource}.
        {get ContainerHandle hWindow hContainerSource}.
        ASSIGN
           FRAME {&FRAME-NAME}:HEIGHT-PIXELS  = hWindow:HEIGHT-PIXELS - 70
           FRAME {&FRAME-NAME}:WIDTH-PIXELS   = hWindow:WIDTH-PIXELS  - 28.  

        /* Create the dynamic browser and size it relative to the containing window */
        CREATE BROWSE ghBrowse
               ASSIGN FRAME            = FRAME {&FRAME-NAME}:handle
                      ROW              = 6.5
                      COL              = 1.5
                      WIDTH-CHARS      = FRAME {&FRAME-NAME}:WIDTH-CHARS   - 2
                      HEIGHT-PIXELS    = FRAME {&FRAME-NAME}:HEIGHT-PIXELS - 125
                      SEPARATORS       = TRUE
                      ROW-MARKERS      = FALSE
                      EXPANDABLE       = TRUE
                      COLUMN-RESIZABLE = TRUE
                      ALLOW-COLUMN-SEARCHING = TRUE
                      READ-ONLY        = FALSE
                      QUERY            = ghQuery
                /* Set procedures to handle browser events */
                TRIGGERS:   
                  ON END
                     PERSISTENT RUN browseEnd      IN THIS-PROCEDURE.
                  ON HOME
                     PERSISTENT RUN browseHome     IN THIS-PROCEDURE.
                  ON OFF-END
                     PERSISTENT RUN browseOffEnd   IN THIS-PROCEDURE.
                  ON OFF-HOME
                     PERSISTENT RUN browseOffHome  IN THIS-PROCEDURE.
                  ON START-SEARCH
                     PERSISTENT RUN startSearch    IN THIS-PROCEDURE.
                  ON ROW-DISPLAY
                     PERSISTENT RUN rowDisplay     IN THIS-PROCEDURE.
                  ON ROW-LEAVE
                     PERSISTENT RUN rowLeave       IN THIS-PROCEDURE.
                  ON ANY-PRINTABLE, 
                     MOUSE-SELECT-DBLCLICK ANYWHERE
                     PERSISTENT RUN setScreenValue IN THIS-PROCEDURE.
                END TRIGGERS.

        /* Hide the dynamic browser while it is being constructed */
        ASSIGN
           ghBrowse:VISIBLE   = NO
           ghBrowse:SENSITIVE = NO.

        /* Add fields to browser using structure of dynamic temp table */
        DO iLoop = 1 TO ghBuffer:NUM-FIELDS:
            hCurField = ghBuffer:BUFFER-FIELD(iLoop).

            /* Ignore rowNum and rowIdent fields */
            IF hCurField:NAME EQ "RowNum":U OR hCurField:NAME EQ "RowIdent":U THEN NEXT.

            hField = ghBrowse:ADD-LIKE-COLUMN(hCurField).

            /* Enable/disable columns in browser according to Security Type and column name */
            hField:READ-ONLY =
                NOT ((hField:NAME EQ 'restricted':U AND coSecurityType:SCREEN-VALUE IN FRAME {&FRAME-NAME} NE '{&DATA-RANGES}':U) 
                      OR hField:NAME EQ 'access_level':U OR hField:NAME EQ 'value_from':U OR hField:NAME EQ 'value_to':U).

            /* Build up the list of browse columns for use in rowDisplay */
            IF VALID-HANDLE(hField) THEN
                cBrowseColHdls = cBrowseColHdls 
                               + (IF cBrowseColHdls = "":U THEN "":U ELSE ",":U) 
                               + STRING(hField).
        END. /* DO iLoop = 1 TO ghBuffer:NUM-FIELDS */

        /* Lock first column of dynamic browser */
        ghBrowse:NUM-LOCKED-COLUMNS = 1.

        /* Open the query for the browser */
        ghQuery:QUERY-OPEN().

        /* Show the browser */
        ASSIGN
           ghBrowse:VISIBLE   = YES
           ghBrowse:SENSITIVE = YES.

        /* Reposition to first record in browser */
        IF NUM-ENTRIES(ttQueryParams.cFirstResultRow,";":U) > 1 THEN
           ASSIGN cRowIdent = ENTRY(2, ttQueryParams.cFirstResultRow,";":U). 
        RUN repositionBrowse (INPUT cRowIdent).
        RELEASE ttQueryParams.

        /* Initialise update objects */
        ASSIGN
           glModified          = FALSE
           buSave:SENSITIVE    = FALSE
           buCascade:SENSITIVE = FALSE
           buRestrictAll:SENSITIVE       = (coSecurityType:SCREEN-VALUE NE '{&FIELDS}':U AND 
                                            coSecurityType:SCREEN-VALUE NE '{&DATA-RANGES}':U AND 
                                            VALID-HANDLE(ghBrowse))
           buUnrestrictall:SENSITIVE     = (coSecurityType:SCREEN-VALUE NE '{&FIELDS}':U AND 
                                            coSecurityType:SCREEN-VALUE NE '{&DATA-RANGES}':U AND 
                                            VALID-HANDLE(ghBrowse))
           .

    END. /* IF VALID-HANDLE(hTH) */

    /* Hour glass OFF */
    SESSION:SET-WAIT-STATE("":U).

    /* Move focus to first updateable column of browser */
    IF VALID-HANDLE(ghBrowse) THEN
       APPLY "entry":U TO ghBrowse.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyobject sObject 
PROCEDURE destroyobject :
/*------------------------------------------------------------------------------
  Purpose:     Super override
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Clean up dynamic object handles */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getBrowseDetails sObject 
PROCEDURE getBrowseDetails :
/*------------------------------------------------------------------------------
  Purpose:     To return delimited lists of the fields and field attributes
               stored in the ttQueryParams record

  Parameters:  output comma-delimited string of fields in the query parameters
               output CHR(3)-delimited string of the respective labels of the fields in the query parameters
               output CHR(3)-delimited string of the respective formats of the fields in the query parameters
               output comma-delimited string of the data types of the fields in the query parameters

  Notes:        
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER pcBrowseFields                AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER pcBrowseFieldLabels           AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER pcBrowseFieldFormats          AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER pcBrowseFieldDataTypes        AS CHARACTER  NO-UNDO.

    /* Get current query parameters record */
    FIND FIRST ttQueryParams NO-ERROR.
    IF NOT AVAILABLE ttQueryParams THEN RETURN.

    /* Set output parameter values */
    ASSIGN
        pcBrowseFields               = ttQueryParams.cBrowseFields
        pcBrowseFieldLabels          = ttQueryParams.cBrowseFieldLabels
        pcBrowseFieldFormats         = ttQueryParams.cBrowseFieldFormats
        pcBrowseFieldDataTypes       = ttQueryParams.cBrowseFieldDataTypes
        .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject sObject 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  <none>
  Notes:       Sets subscriptions to some standard published events.
               Initialises some UI objects.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cLinkHandles              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainerSource          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hToolbarSource            AS HANDLE     NO-UNDO.

  /* Get handle of container, then get toolbar source of container to determine the containers toolbar.
     We then subscribe this procedure to toolbar events in the containers toolbar so
     that we can action an OK or CANCEL being pressed in the toolbar. */  

  /* Ignore if running in the AppBuilder */
  &IF DEFINED(UIB_IS_RUNNING) = 0 &THEN

    /* Get container handle */
    {get ContainerSource hContainerSource}.

    /* Get handle to toolbar of the container */
    cLinkHandles   = DYNAMIC-FUNCTION('linkHandles' IN hContainerSource, 'Toolbar-Source').
    hToolbarSource = WIDGET-HANDLE(ENTRY(1,cLinkHandles)). 

    IF VALID-HANDLE(hToolBarSource) THEN
    DO:
        /* Subscribe this procedure to 'toolbar' event published by the toolbar of the container */
        SUBSCRIBE PROCEDURE THIS-PROCEDURE  TO 'toolbar'     IN hToolbarSource.

        /* Subscribe this procedure to 'updateState' event published by this same procedure */
        SUBSCRIBE PROCEDURE THIS-PROCEDURE  TO 'upDateState' IN THIS-PROCEDURE.

        /* Subscrive the toolbar of the container to 'updateState' published by the toolbar of the container */
        SUBSCRIBE PROCEDURE  hToolbarSource TO 'updateState' IN THIS-PROCEDURE.


    END.

    /* Subscribe this procedure to the event which builds the browser */    
    IF VALID-HANDLE(hContainerSource) THEN
       SUBSCRIBE PROCEDURE THIS-PROCEDURE TO 'buildBrowser' IN hContainerSource.

  &ENDIF  

  RUN SUPER.

  /* Initialise UI objects */
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN        
         coSecurityType:SCREEN-VALUE = STRING(1)         
         fiRowsToBatch:SCREEN-VALUE  = STRING(100)
         buSave:SENSITIVE            = FALSE
         buCascade:SENSITIVE         = FALSE
         .      
      APPLY 'VALUE-CHANGED':U TO coSecurityType.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionBrowse sObject 
PROCEDURE repositionBrowse :
/*------------------------------------------------------------------------------
  Purpose:     To position the dynamic browser at specified record
  Parameters:  input string storing a rowIdent value
  Notes:      
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pcRowIdent               AS CHARACTER  NO-UNDO.

    DEFINE VARIABLE hRowQuery                       AS HANDLE     NO-UNDO.    
    DEFINE VARIABLE lOk                             AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE rRowid                          AS ROWID      NO-UNDO.

    /* Create query and assign the buffer of the dynamic temp table used in the browser query */
    CREATE QUERY hRowQuery.     
    lOK = hRowQuery:SET-BUFFERS(ghBuffer).

    /* Prepare query string to return records relating to the rowIdent parameter value - should only be one */
    IF lOK THEN
       lOK = hRowQuery:QUERY-PREPARE
               ('FOR EACH RowObject WHERE RowObject.RowIdent BEGINS "':U + pcRowIdent + '"':U).

    /* Open query and get first record */
    lOK = hRowQuery:QUERY-OPEN().
    IF lOK THEN
       lOK = hRowQuery:GET-FIRST().

    /* If record found the reposition the query of the dynamic browser to that record */
    IF ghBuffer:AVAILABLE THEN
    DO:
       rRowid  = ghBuffer:ROWID.
       lOK    = ghQuery:REPOSITION-TO-ROWID(rRowid) NO-ERROR. 
    END.

    /* Clean up local query object */
    DELETE WIDGET hRowQuery.
    ASSIGN hRowQuery = ?.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject sObject 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:    Resize the viewer
  Parameters: pd_height AS DECIMAL - the desired height (in rows)
              pd_width  AS DECIMAL - the desired width (in columns)
    Notes:    Used internally. Calls to resizeObject are generated by the
              AppBuilder in adm-create-objects for objects which implement it.
              Having a resizeObject procedure is also the signal to the AppBuilder
              to allow the object to be resized at design time.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pdHeight       AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER pdWidth        AS DECIMAL NO-UNDO.

  DEFINE VARIABLE lPreviouslyHidden     AS LOGICAL NO-UNDO.
  DEFINE VARIABLE hWindow               AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hContainerSource      AS HANDLE  NO-UNDO.

  /* Get container and window handles */
  {get ContainerSource hContainerSource}.
  {get ContainerHandle hWindow hContainerSource}.

  /* Save hidden state of current frame, then hide it */
  FRAME {&FRAME-NAME}:SCROLLABLE = FALSE.                                               
  lPreviouslyHidden = FRAME {&FRAME-NAME}:HIDDEN.                                                           
  FRAME {&FRAME-NAME}:HIDDEN = TRUE.

  /* Resize frame relative to containing window size */
  FRAME {&FRAME-NAME}:HEIGHT-PIXELS = hWindow:HEIGHT-PIXELS - 70.
  FRAME {&FRAME-NAME}:WIDTH-PIXELS  = hWindow:WIDTH-PIXELS  - 28.

  /* Resize dynamic browser (if exists) relative to current frame */
  IF VALID-HANDLE(ghBrowse) THEN
  DO:
    ghBrowse:WIDTH-CHARS   = FRAME {&FRAME-NAME}:WIDTH-CHARS   - 2.
    ghBrowse:HEIGHT-PIXELS = FRAME {&FRAME-NAME}:HEIGHT-PIXELS - 120.
  END.

  /* Restore original hidden state of current frame */
  APPLY "end-resize":U TO FRAME {&FRAME-NAME}.
  FRAME {&FRAME-NAME}:HIDDEN = lPreviouslyHidden NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowDisplay sObject 
PROCEDURE rowDisplay :
/*------------------------------------------------------------------------------
  Purpose:     Procedure for 'ROW-DISPLAY' browser event
  Parameters:  <none>
  Notes:       Sets the 'if null' values of the current record of the dynamic browser            
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cValueList AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cField                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hField                    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLoop                     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cValue                    AS CHARACTER  NO-UNDO.

  /* Get current query parameters record */
  FIND FIRST ttQueryParams NO-ERROR.
  IF NOT AVAILABLE ttQueryParams THEN RETURN.

  /* Set 'if null' values in the current record in the dynamic browser */
  IF ghBuffer:AVAILABLE AND (NUM-ENTRIES(ttQueryParams.cBrowseFieldValuesIfNull) EQ NUM-ENTRIES(ttQueryParams.cBrowseFields)) THEN
  DO:

        /* for each browse field defined in the query parameters record */
        DO iLoop = 1 TO NUM-ENTRIES(ttQueryParams.cBrowseFields):
           ASSIGN
              cField = ENTRY(iLoop,ttQueryParams.cBrowseFields)
              cField = ENTRY(2, cField, ".":U)
              hField = ghBuffer:BUFFER-FIELD(cField)
              .
           IF hField:DATA-TYPE EQ "CHARACTER":U AND (hField:BUFFER-VALUE EQ "":U OR hField:BUFFER-VALUE EQ ?) THEN
               hField:BUFFER-VALUE = ENTRY(iLoop,ttQueryParams.cBrowseFieldValuesIfNull).

        END.  /* iLoop = 1 TO NUM-ENTRIES(ttQueryParams.cBrowseFields) */

  END. /* ghbuffer available */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowLeave sObject 
PROCEDURE rowLeave :
/*------------------------------------------------------------------------------
  Purpose:     Procedure for 'ROW-LEAVE' browser event
  Parameters:  <none>
  Notes:       Assign screen value of current column to temp table buffer
               Assign logical restriction in the case of Data Ranges if
               from and to values have been modified.                             
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iLoop                AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hField               AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hColumn              AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRestrictedColumn    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hValueFromField      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hValueToField        AS HANDLE    NO-UNDO.


  /* if current record in browse has been modified */
  IF ghBrowse:CURRENT-ROW-MODIFIED THEN
  DO:
     /* for each column in the browse */
     REPEAT iLoop = 1 TO ghBrowse:NUM-COLUMNS:

        /* Get handle to column and corresponding temp table buffer field */
        hColumn = ghBrowse:GET-BROWSE-COLUMN(iLoop).
        hField  = hColumn:BUFFER-FIELD.

        /* If modified then assign column screen value to corresponding temp table buffer field */
        IF hColumn:MODIFIED AND VALID-HANDLE(hField)THEN
           hField:BUFFER-VALUE = hColumn:SCREEN-VALUE.

        /* Security Type equals Data Ranges */
        IF coSecurityType:SCREEN-VALUE IN FRAME {&FRAME-NAME} EQ '{&DATA-RANGES}':U THEN
        DO:

          /* Save handle of 'value_to' field and assign screen value to temp table buffer */
          IF hField:NAME EQ 'value_from':U THEN
              ASSIGN
                  hValueFromField = hField
                  .
          /* Save handle of 'value_from' field and assign screen value to temp table buffer */   
          IF hField:NAME EQ 'value_to':U THEN
              ASSIGN
                  hValueToField = hField
                  .

          /* Save handle of 'restricted' column of the browser */
          IF hField:NAME EQ 'restricted':U THEN
              ASSIGN
                  hRestrictedColumn = hColumn
                  .

        END. /* IF coSecurityType:SCREEN-VALUE IN FRAME {&FRAME-NAME} EQ '{&DATA-RANGES}':U */

     END. /* REPEAT */

      /* Assign restricted column to YES OR NO depending whether Security Type is Data Ranges and
         values exists in either the 'value_from' or 'value_to' columns */
     IF coSecurityType:SCREEN-VALUE IN FRAME {&FRAME-NAME} EQ '{&DATA-RANGES}':U 
     AND VALID-HANDLE(hValueFromField)
     AND VALID-HANDLE(hValueToField)
     AND VALID-HANDLE(hRestrictedColumn) THEN
         ASSIGN
            hRestrictedColumn:SCREEN-VALUE = STRING(NOT (hValueToField:BUFFER-VALUE EQ "":U AND hValueFromField:BUFFER-VALUE EQ "":U))
            hField                         = hRestrictedColumn:BUFFER-FIELD
            hField:BUFFER-VALUE            = hRestrictedColumn:SCREEN-VALUE.
            .

  END. /* IF ghBrowse:CURRENT-ROW-MODIFIED */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveChanges sObject 
PROCEDURE saveChanges :
/*------------------------------------------------------------------------------
  Purpose:     Save security allocations made in the dynamic browser
               to the database.
  Parameters:  input flag determining whether the security allocations of
               the current user should be cascaded to those users that have
               used this user as their profile user.
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER lCascade       AS LOGICAL      NO-UNDO.
  DEFINE VARIABLE cErrorMessage             AS CHARACTER  NO-UNDO.

  /* Ensure screen values in dynamic browse are assigned to temp table buffer */
  APPLY "ROW-LEAVE":U TO ghBrowse.

  /* Run a PLIP internal procedure to commit the security allocations stored in the temp table (ghTable) */
  {af/sup2/afrun2.i      &PLIP  = 'af/app/gsmulplipp.p'
                         &IPROC = 'commitQueryResultSet'
                         &onApp = 'yes'
                         &PLIST = "(INPUT fiUserID:SCREEN-VALUE IN FRAME {&FRAME-NAME},~
                                    INPUT lCascade,~
                                    INPUT fiLoginCompany:SCREEN-VALUE IN FRAME {&FRAME-NAME},~
                                    INPUT coSecurityType:SCREEN-VALUE IN FRAME {&FRAME-NAME},~
                                    INPUT fiEntityMnemonic:SCREEN-VALUE IN FRAME {&FRAME-NAME},~
                                    INPUT TABLE-HANDLE ghTable,~
                                    OUTPUT cErrorMessage)"
                         &Define-only = NO
                         &autokill = YES}

  /* If PLIP internal procedure call returns an error message, then show to user */
  IF cErrorMessage <> "":U THEN
  DO:
     RUN showMessages IN gshSessionManager (INPUT cErrorMEssage,
                                            INPUT "ERR":U,
                                            INPUT "OK":U,
                                            INPUT "OK":U,
                                            INPUT "OK":U,
                                            INPUT "Security Allocations Save Error",
                                            INPUT YES,
                                            INPUT ?,
                                            OUTPUT gcAbort).
     ERROR-STATUS:ERROR = NO.
     RETURN NO-APPLY.
  END.

  /* Reset update state */
  RUN updateState (INPUT 'updateComplete':U).
  glModified = FALSE.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setAccessTokensQuery sObject 
PROCEDURE setAccessTokensQuery :
/*------------------------------------------------------------------------------
  Purpose:     To set the query parameters in the case of Access Tokens security type
  Parameters:  <none>
  Notes:       This could be considered to be 'hard-coding'. It would be nice
               if this information could be stored in the repository.
               Maybe later.
               Could also possibly be moved to the server-side code.
------------------------------------------------------------------------------*/

    ASSIGN
      ttQueryParams.cQueryTables             = 'gsm_security_structure,gsm_token,gsc_product_module,ryc_smartobject,gsc_instance_attribute':U
      ttQueryParams.cBaseQueryString         = 'FOR EACH gsm_security_structure NO-LOCK
                                                   WHERE gsm_security_structure.owning_entity_mnemonic EQ "GSMTO",
                                                   FIRST gsm_token NO-LOCK
                                                   WHERE gsm_token.token_obj EQ gsm_security_structure.owning_obj,
                                                   FIRST gsc_product_module OUTER-JOIN NO-LOCK
                                                   WHERE gsc_product_module.product_module_obj EQ gsm_security_structure.product_module_obj,
                                                   FIRST ryc_smartobject OUTER-JOIN NO-LOCK
                                                   WHERE ryc_smartobject.smartobject_obj EQ gsm_security_structure.OBJECT_obj,
                                                   FIRST gsc_instance_attribute OUTER-JOIN NO-LOCK
                                                   WHERE gsc_instance_attribute.instance_attribute_obj EQ gsm_security_structure.instance_attribute_obj
                                                   BY gsm_token.token_code':U
      ttQueryParams.cKeyField                = 'gsm_token.token_code':U
      ttQueryParams.cKeyFieldLabel          = 'Token Code'
      ttQueryParams.cKeyFormat               = 'x(10)':U
      ttQueryParams.cKeyDataType             = 'CHARACTER':U
      ttQueryParams.cBrowseFields            = 'gsm_token.token_description,':U
                                             + 'gsc_product_module.product_module_code,':U
                                             + 'ryc_smartobject.object_description,':U
                                             + 'gsc_instance_attribute.attribute_code,':U
                                             + 'gsm_token.disabled,':U
                                             + 'gsm_token.system_owned':U
      ttQueryParams.cBrowseFieldLabels       = 'Token Description'   + CHR(3)
                                             + 'Product Module'      + CHR(3)
                                             + 'Object'              + CHR(3)
                                             + 'Instance Attribute'  + CHR(3)
                                             + 'Disabled'            + CHR(3)
                                             + 'System Owned'
      ttQueryParams.cBrowseFieldDataTypes    = 'CHARACTER,':U
                                             + 'CHARACTER,':U
                                             + 'CHARACTER,':U
                                             + 'CHARACTER,':U
                                             + 'LOGICAL,':U
                                             + 'LOGICAL':U
      ttQueryParams.cBrowseFieldFormats      = 'x(20)':U   + CHR(3)
                                             + 'x(20)':U   + CHR(3)
                                             + 'x(20)':U   + CHR(3)
                                             + 'x(20)':U   + CHR(3)
                                             + 'yes/no':U  + CHR(3)
                                             + 'yes/no':U
      ttQueryParams.cBrowseFieldValuesIfNull = '':U        + CHR(3)
                                             + 'All':U     + CHR(3)
                                             + 'All':U     + CHR(3)
                                             + 'All':U     + CHR(3)
                                             + '?':U       + CHR(3)
                                             + '?':U
      ttQueryParams.iRowsToBatch             = INTEGER(fiRowsToBatch:SCREEN-VALUE IN FRAME {&FRAME-NAME})
      ttQueryParams.iFirstRowNum             = 0
      ttQueryParams.iLastRowNum              = 0
      ttQueryParams.cFirstResultRow          = "":U
      ttQueryParams.cLastResultRow           = "":U
      .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setCompaniesQuery sObject 
PROCEDURE setCompaniesQuery :
/*------------------------------------------------------------------------------
  Purpose:     To set the query parameters in the case of Login Companies security type
  Parameters:  <none>
  Notes:       This could be considered to be 'hard-coding'. It would be nice
               if this information could be stored in the repository.
               Maybe later.
               Could also possibly be moved to the server-side code.               
------------------------------------------------------------------------------*/

    ASSIGN
      ttQueryParams.cQueryTables             = 'gsm_login_company':U
      ttQueryParams.cBaseQueryString         = 'FOR EACH gsm_login_company NO-LOCK
                                                      BY gsm_login_company.login_company_code':U
      ttQueryParams.cKeyField                = 'gsm_login_company.login_company_code':U
      ttQueryParams.cKeyFieldLabel           = 'Login Company Code'
      ttQueryParams.cKeyFormat               = 'x(10)':U
      ttQueryParams.cKeyDataType             = 'CHARACTER':U
      ttQueryParams.cBrowseFields            = 'gsm_login_company.login_company_code,':U
                                             + 'gsm_login_company.login_company_short_name,':U
                                             + 'gsm_login_company.login_company_name,':U
                                             + 'gsm_login_company.login_company_email,':U
                                             + 'gsm_login_company.login_company_disabled':U
      ttQueryParams.cBrowseFieldLabels       = 'Login Company'    + CHR(3)
                                             + 'Short Name'       + CHR(3)
                                             + 'Name'             + CHR(3)
                                             + 'Email'            + CHR(3)
                                             + 'Disabled'
      ttQueryParams.cBrowseFieldDataTypes    = 'CHARACTER,':U
                                             + 'CHARACTER,':U
                                             + 'CHARACTER,':U
                                             + 'CHARACTER,':U
                                             + 'LOGICAL':U
      ttQueryParams.cBrowseFieldFormats      = 'x(20)':U  + CHR(3)
                                             + 'x(20)':U  + CHR(3)
                                             + 'x(20)':U  + CHR(3)
                                             + 'x(20)':U + CHR(3)
                                             + 'yes/no':U
      ttQueryParams.cBrowseFieldValuesIfNull = '':U       + CHR(3)
                                             + '':U       + CHR(3)
                                             + '':U       + CHR(3)
                                             + '':U      + CHR(3)
                                             + '?':U
      ttQueryParams.iRowsToBatch             = INTEGER(fiRowsToBatch:SCREEN-VALUE IN FRAME {&FRAME-NAME})
      ttQueryParams.iFirstRowNum             = 0
      ttQueryParams.iLastRowNum              = 0
      ttQueryParams.cFirstResultRow          = "":U
      ttQueryParams.cLastResultRow           = "":U
      .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDataRangesQuery sObject 
PROCEDURE setDataRangesQuery :
/*------------------------------------------------------------------------------
  Purpose:     To set the query parameters in the case of Data Ranges security type
  Parameters:  <none>
  Notes:       This could be considered to be 'hard-coding'. It would be nice
               if this information could be stored in the repository.
               Maybe later.
               Could also possibly be moved to the server-side code.               
------------------------------------------------------------------------------*/

    ASSIGN
      ttQueryParams.cQueryTables             = 'gsm_security_structure,gsm_range,gsc_product_module,ryc_smartobject,gsc_instance_attribute':U
      ttQueryParams.cBaseQueryString         = 'FOR EACH gsm_security_structure NO-LOCK
                                                   WHERE gsm_security_structure.owning_entity_mnemonic EQ "GSMRA",
                                                   FIRST gsm_range NO-LOCK
                                                   WHERE gsm_range.range_obj EQ gsm_security_structure.owning_obj,
                                                   FIRST gsc_product_module OUTER-JOIN NO-LOCK
                                                   WHERE gsc_product_module.product_module_obj EQ gsm_security_structure.product_module_obj,
                                                   FIRST ryc_smartobject OUTER-JOIN NO-LOCK
                                                   WHERE ryc_smartobject.smartobject_obj EQ gsm_security_structure.OBJECT_obj,
                                                   FIRST gsc_instance_attribute OUTER-JOIN NO-LOCK
                                                   WHERE gsc_instance_attribute.instance_attribute_obj EQ gsm_security_structure.instance_attribute_obj
                                                   BY gsm_range.range_code':U
      ttQueryParams.cKeyField                = 'gsm_range.range_code':U
      ttQueryParams.cKeyFieldLabel           = 'Range Name'
      ttQueryParams.cKeyFormat               = 'x(10)':U
      ttQueryParams.cKeyDataType             = 'CHARACTER':U
      ttQueryParams.cBrowseFields            = 'gsm_range.range_description,':U
                                             + 'gsc_product_module.product_module_code,':U
                                             + 'ryc_smartobject.object_description,':U
                                             + 'gsc_instance_attribute.attribute_code,':U
                                             + 'gsm_range.disabled,':U
                                             + 'gsm_range.system_owned':U
      ttQueryParams.cBrowseFieldLabels       = 'Range Description'  + CHR(3)
                                             + 'Product Module'     + CHR(3)
                                             + 'Object'             + CHR(3)
                                             + 'Instance Attribute' + CHR(3)
                                             + 'Disabled'           + CHR(3)
                                             + 'System Owned'
      ttQueryParams.cBrowseFieldDataTypes    = 'CHARACTER,':U
                                             + 'CHARACTER,':U
                                             + 'CHARACTER,':U
                                             + 'CHARACTER,':U
                                             + 'LOGICAL,':U
                                             + 'LOGICAL':U
      ttQueryParams.cBrowseFieldFormats      = 'x(20)':U     + CHR(3)
                                             + 'x(20)':U     + CHR(3)
                                             + 'x(20)':U     + CHR(3)
                                             + 'x(20)':U     + CHR(3)
                                             + 'yes/no':U    + CHR(3)
                                             + 'yes/no':U
      ttQueryParams.cBrowseFieldValuesIfNull = '':U          + CHR(3)
                                             + 'All':U       + CHR(3)
                                             + 'All':U       + CHR(3)
                                             + 'All':U       + CHR(3)
                                             + '?':U         + CHR(3)
                                             + '?':U
      ttQueryParams.iRowsToBatch             = INTEGER(fiRowsToBatch:SCREEN-VALUE IN FRAME {&FRAME-NAME})
      ttQueryParams.iFirstRowNum             = 0
      ttQueryParams.iLastRowNum              = 0
      ttQueryParams.cFirstResultRow          = "":U
      ttQueryParams.cLastResultRow           = "":U
      .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDataRecordsQuery sObject 
PROCEDURE setDataRecordsQuery :
/*------------------------------------------------------------------------------
  Purpose:     To set the query parameters in the case of Data Records security type
  Parameters:  <none>
  Notes:       This could be considered to be 'hard-coding'. It would be nice
               if this information could be stored in the repository.
               Maybe later.
               Could also possibly be moved to the server-side code. 
               (In this case, most of it already is)              
------------------------------------------------------------------------------*/

    ASSIGN
      ttQueryParams.iRowsToBatch             = INTEGER(fiRowsToBatch:SCREEN-VALUE IN FRAME {&FRAME-NAME})
      ttQueryParams.iFirstRowNum             = 0
      ttQueryParams.iLastRowNum              = 0
      ttQueryParams.cFirstResultRow          = "":U
      ttQueryParams.cLastResultRow           = "":U
      .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setFieldsQuery sObject 
PROCEDURE setFieldsQuery :
/*------------------------------------------------------------------------------
  Purpose:     To set the query parameters in the case of Fields security type
  Parameters:  <none>
  Notes:       This could be considered to be 'hard-coding'. It would be nice
               if this information could be stored in the repository.
               Maybe later.
               Could also possibly be moved to the server-side code.               
------------------------------------------------------------------------------*/

    ASSIGN
      ttQueryParams.cQueryTables             = 'gsm_security_structure,gsm_field,gsc_product_module,ryc_smartobject,gsc_instance_attribute':U
      ttQueryParams.cBaseQueryString         = 'FOR EACH gsm_security_structure NO-LOCK
                                                   WHERE gsm_security_structure.owning_entity_mnemonic EQ "GSMFF",
                                                   FIRST gsm_field NO-LOCK
                                                   WHERE gsm_field.FIELD_obj EQ gsm_security_structure.owning_obj,
                                                   FIRST gsc_product_module OUTER-JOIN NO-LOCK
                                                   WHERE gsc_product_module.product_module_obj EQ gsm_security_structure.product_module_obj,
                                                   FIRST ryc_smartobject OUTER-JOIN NO-LOCK
                                                   WHERE ryc_smartobject.smartobject_obj EQ gsm_security_structure.OBJECT_obj,
                                                   FIRST gsc_instance_attribute OUTER-JOIN NO-LOCK
                                                   WHERE gsc_instance_attribute.instance_attribute_obj EQ gsm_security_structure.instance_attribute_obj
                                                   BY gsm_field.field_name':U
      ttQueryParams.cKeyField                = 'gsm_field.field_name':U
      ttQueryParams.cKeyFieldLabel           = 'Field Name'
      ttQueryParams.cKeyFormat               = 'x(10)':U
      ttQueryParams.cKeyDataType             = 'CHARACTER':U
      ttQueryParams.cBrowseFields            = 'gsm_field.field_description,':U
                                             + 'gsc_product_module.product_module_code,':U
                                             + 'ryc_smartobject.object_description,':U
                                             + 'gsc_instance_attribute.attribute_code,':U
                                             + 'gsm_field.disabled,':U
                                             + 'gsm_field.system_owned':U
      ttQueryParams.cBrowseFieldLabels       = 'Field Description'   + CHR(3)
                                             + 'Product Module'      + CHR(3)
                                             + 'Object'              + CHR(3)
                                             + 'Instance Attribute'  + CHR(3)
                                             + 'Disabled'            + CHR(3)
                                             + 'System Owned'
      ttQueryParams.cBrowseFieldDataTypes    = 'CHARACTER,':U
                                             + 'CHARACTER,':U
                                             + 'CHARACTER,':U
                                             + 'CHARACTER,':U
                                             + 'LOGICAL,':U
                                             + 'LOGICAL':U
      ttQueryParams.cBrowseFieldFormats      = 'x(20)':U        + CHR(3)
                                             + 'x(20)':U        + CHR(3)
                                             + 'x(20)':U        + CHR(3) 
                                             + 'x(20)':U        + CHR(3)
                                             + 'yes/no':U       + CHR(3)
                                             + 'yes/no':U
      ttQueryParams.cBrowseFieldValuesIfNull = '':U             + CHR(3)
                                             + 'All':U          + CHR(3)
                                             + 'All':U          + CHR(3)
                                             + 'All':U          + CHR(3)
                                             + '?':U            + CHR(3)
                                             + '?':U
      ttQueryParams.iRowsToBatch             = INTEGER(fiRowsToBatch:SCREEN-VALUE IN FRAME {&FRAME-NAME})
      ttQueryParams.iFirstRowNum             = 0
      ttQueryParams.iLastRowNum              = 0
      ttQueryParams.cFirstResultRow          = "":U
      ttQueryParams.cLastResultRow           = "":U
      .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setMenuItemsQuery sObject 
PROCEDURE setMenuItemsQuery :
/*------------------------------------------------------------------------------
  Purpose:     To set the query parameters in the case of Menu Items security type
  Parameters:  <none>
  Notes:       This could be considered to be 'hard-coding'. It would be nice
               if this information could be stored in the repository.
               Maybe later.
               Could also possibly be moved to the server-side code.               
------------------------------------------------------------------------------*/

    ASSIGN
      ttQueryParams.cQueryTables             = 'gsm_menu_item,gsm_menu_structure':U
      ttQueryParams.cBaseQueryString         = 'FOR EACH gsm_menu_item NO-LOCK,
                                                   FIRST gsm_menu_structure NO-LOCK
                                                   WHERE gsm_menu_structure.menu_structure_obj EQ gsm_menu_item.menu_structure_obj
                                                      BY gsm_menu_item.menu_item_label':U
      ttQueryParams.cKeyField                = 'gsm_menu_item.menu_item_label':U
      ttQueryParams.cKeyFieldLabel           = 'Menu Item Label'
      ttQueryParams.cKeyFormat               = 'x(10)':U
      ttQueryParams.cKeyDataType             = 'CHARACTER':U
      ttQueryParams.cBrowseFields            = 'gsm_menu_structure.menu_structure_description,':U
                                             + 'gsm_menu_item.menu_item_label,':U
                                             + 'gsm_menu_item.menu_item_description,':U
                                             + 'gsm_menu_item.disabled,':U
                                             + 'gsm_menu_item.system_owned':U
      ttQueryParams.cBrowseFieldLabels       = 'Menu Structure'   + CHR(3)
                                             + 'Item Label'       + CHR(3)
                                             + 'Item Description' + CHR(3)
                                             + 'Disabled'         + CHR(3)
                                             + 'System Owned'
      ttQueryParams.cBrowseFieldDataTypes    = 'CHARACTER,':U
                                             + 'CHARACTER,':U
                                             + 'CHARACTER,':U
                                             + 'LOGICAL,':U
                                             + 'LOGICAL':U
      ttQueryParams.cBrowseFieldFormats      = 'x(20)':U  + CHR(3)
                                             + 'x(20)':U  + CHR(3)
                                             + 'x(20)':U  + CHR(3)
                                             + 'yes/no':U + CHR(3)
                                             + 'yes/no':U
      ttQueryParams.cBrowseFieldValuesIfNull = '':U       + CHR(3)
                                             + '':U       + CHR(3)
                                             + '':U       + CHR(3)
                                             + '?':U      + CHR(3)
                                             + '?':U
      ttQueryParams.iRowsToBatch             = INTEGER(fiRowsToBatch:SCREEN-VALUE IN FRAME {&FRAME-NAME})
      ttQueryParams.iFirstRowNum             = 0
      ttQueryParams.iLastRowNum              = 0
      ttQueryParams.cFirstResultRow          = "":U
      ttQueryParams.cLastResultRow           = "":U
      .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setMenuStructuresQuery sObject 
PROCEDURE setMenuStructuresQuery :
/*------------------------------------------------------------------------------
  Purpose:     To set the query parameters in the case of Menu Structures security type
  Parameters:  <none>
  Notes:       This could be considered to be 'hard-coding'. It would be nice
               if this information could be stored in the repository.
               Maybe later.
               Could also possibly be moved to the server-side code.               
------------------------------------------------------------------------------*/

    ASSIGN
      ttQueryParams.cQueryTables             = 'gsm_menu_structure,gsc_product_module':U
      ttQueryParams.cBaseQueryString         = 'FOR EACH gsm_menu_structure NO-LOCK,
                                                   FIRST gsc_product_module OUTER-JOIN NO-LOCK
                                                   WHERE gsc_product_module.product_module_obj EQ gsm_menu_structure.product_module_obj
                                                      BY gsm_menu_structure.menu_structure_code':U
      ttQueryParams.cKeyField                = 'gsm_menu_structure.menu_structure_code':U
      ttQueryParams.cKeyFieldLabel           = 'Menu Structure Code'
      ttQueryParams.cKeyFormat               = 'x(10)':U
      ttQueryParams.cKeyDataType             = 'CHARACTER':U
      ttQueryParams.cBrowseFields            = 'gsm_menu_structure.menu_structure_code,':U
                                             + 'gsm_menu_structure.menu_structure_description,':U
                                             + 'gsc_product_module.product_module_code,':U
                                             + 'gsm_menu_structure.disabled,':U
                                             + 'gsm_menu_structure.system_owned':U
      ttQueryParams.cBrowseFieldLabels       = 'Menu Structure Code'   + CHR(3) 
                                             + 'Description'           + CHR(3)
                                             + 'Product Module'        + CHR(3)
                                             + 'Disabled'              + CHR(3)
                                             + 'System'
      ttQueryParams.cBrowseFieldDataTypes    = 'CHARACTER,':U
                                             + 'CHARACTER,':U
                                             + 'CHARACTER,':U
                                             + 'LOGICAL,':U
                                             + 'LOGICAL':U
      ttQueryParams.cBrowseFieldFormats      = 'x(20)':U  + CHR(3)
                                             + 'x(30)':U  + CHR(3)
                                             + 'x(20)':U  + CHR(3)
                                             + 'yes/no':U + CHR(3)
                                             + 'yes/no':U
      ttQueryParams.cBrowseFieldValuesIfNull = '':U       + CHR(3)
                                             + '':U       + CHR(3)
                                             + 'All':U    + CHR(3)
                                             + '?':U      + CHR(3)
                                             + '?':U
      ttQueryParams.iRowsToBatch             = INTEGER(fiRowsToBatch:SCREEN-VALUE IN FRAME {&FRAME-NAME})
      ttQueryParams.iFirstRowNum             = 0
      ttQueryParams.iLastRowNum              = 0
      ttQueryParams.cFirstResultRow          = "":U
      ttQueryParams.cLastResultRow           = "":U
      .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setQueryParams sObject 
PROCEDURE setQueryParams :
/*------------------------------------------------------------------------------
  Purpose:     To delegate to another internal procedure to set up the query
               parameters according to security type
  Parameters:  input string designating security type
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcSecurityType           AS CHARACTER        NO-UNDO.

  EMPTY TEMP-TABLE ttQueryParams.
  CREATE ttQueryParams.

  CASE pcSecurityType:
    WHEN '{&MENU-STRUCTURES}':U THEN
        RUN setMenuStructuresQuery.

    WHEN '{&MENU-ITEMS}':U THEN
        RUN setMenuItemsQuery.

    WHEN '{&ACCESS-TOKENS}':U THEN
        RUN setAccessTokensQuery.

    WHEN '{&FIELDS}':U THEN
        RUN setFieldsQuery.

    WHEN '{&DATA-RANGES}':U THEN
        RUN setDataRangesQuery.

    WHEN '{&DATA-RECORDS}':U THEN
        RUN setDataRecordsQuery.

    WHEN '{&LOGIN-COMPANIES}':U THEN
        RUN setCompaniesQuery.

  END CASE.

  RELEASE ttQueryParams.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setRestrictAll sObject 
PROCEDURE setRestrictAll :
/*------------------------------------------------------------------------------
  Purpose:     To set the logical restriction to YES or NO for all records
               in the current dynamic temp table.
  Parameters:  input flag designating to set the logical restriction to YES or NO
  Notes:       This procedure only processes the records in the current data set
               in the dynamic browser. This means that records in the database
               MAY not be processed.
               This should be rectified at a later date so that database records
               are processed, NOT temp table records.
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER    plRestriction         AS LOGICAL   NO-UNDO.

    DEFINE VARIABLE hField                          AS HANDLE    NO-UNDO.
    DEFINE VARIABLE cRowIdent                       AS CHARACTER NO-UNDO.

    /* Save current position in the browser */
    IF ghBuffer:AVAILABLE THEN
        ASSIGN
            hField    = ghBuffer:BUFFER-FIELD("RowIdent":U)
            cRowIdent = hField:BUFFER-VALUE()
            .

    /* for each record in the current query of the dynamic browser, set the restriction to the input parameter value */
    ghQuery:GET-FIRST().
    DO WHILE ghBuffer:AVAILABLE:
        hField = ghBuffer:BUFFER-FIELD('restricted':U). 
        IF VALID-HANDLE(hField) THEN
            hField:BUFFER-VALUE = plRestriction.
        ghQuery:GET-NEXT().
    END.

    /* Refresh the contents of the browser */
    ghBrowse:REFRESHABLE = NO.
    IF ghQuery:IS-OPEN THEN ghQuery:QUERY-CLOSE().
    ghQuery:QUERY-OPEN().
    ghBrowse:REFRESHABLE = YES.

    /* Reposition the dynamic browser to the record position saved above */
    IF cRowIdent <> "":U AND NOT cRowIdent BEGINS "?":U THEN
       RUN repositionBrowse (INPUT cRowIdent).

    /* Set the update status */
    IF NOT glModified THEN
    DO:
       glModified = TRUE.
       PUBLISH 'updateState':U ('update':U).
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setScreenValue sObject 
PROCEDURE setScreenValue :
/*------------------------------------------------------------------------------
  Purpose:     Sets screen values for columns in the browser for given UI events
               Also sets modified state
  Parameters:  <none>
  Notes:       For logical columns, the user may mouse-double-click to toggle YES and NO,
               or type 'Y' or 'N'.
               For character columns in the case where security type is Fields,
               specific screen values are set when the user types 'F','R', or 'H'.
               For character columns in the case where security type is Data Ranges,
               just the update state is set.
               This approach needs rework as there is a lot of specific hard-coding.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hCurrentField        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hCurrentColumn       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cDataType            AS CHARACTER NO-UNDO.

  /* If a record is available in browser */
  IF ghBuffer:AVAILABLE THEN
  DO:

     /* Get handle and data type of current column and handle of corresponding buffer field in the temp table */
     ASSIGN
        hCurrentColumn      = ghBrowse:CURRENT-COLUMN
        cDataType           = hCurrentColumn:DATA-TYPE
        hCurrentField       = hCurrentColumn:BUFFER-FIELD.

     /* If the current column in the browser is of a character data type */
     IF cDataType EQ "CHARACTER":U THEN
     DO:
         /* Upon value of Security Type */
         CASE coSecurityType:SCREEN-VALUE IN FRAME {&FRAME-NAME}:
             /* Field security type */
             WHEN '{&FIELDS}':U THEN
             DO:
                 /* Process 'F','R' and 'H' key presses */
                 CASE LAST-EVENT:FUNCTION:
                     WHEN 'F' THEN
                         hCurrentColumn:SCREEN-VALUE = "Full Access".
                     WHEN 'R' THEN
                         hCurrentColumn:SCREEN-VALUE = "Read Only".
                     WHEN 'H' THEN
                         hCurrentColumn:SCREEN-VALUE = "Hidden".
                 END CASE.

                 /* Assign screen value to temp table buffer */
                 hCurrentField:BUFFER-VALUE = hCurrentColumn:SCREEN-VALUE.

                 /* Set update state */
                 IF NOT glModified THEN
                 DO:
                     glModified = TRUE.
                     PUBLISH 'updateState':U ('update':U).
                 END.        
                 RETURN NO-APPLY.
             END. /* WHEN '{&FIELDS}':U */

             /* Security type is Data Ranges */
             WHEN '{&DATA-RANGES}':U THEN
             DO:
                 /* Assign screen value to temp table buffer */
                 hCurrentField:BUFFER-VALUE = hCurrentColumn:SCREEN-VALUE.

                 /* Set update state */
                 IF NOT glModified THEN
                 DO:
                     glModified = TRUE.
                     PUBLISH 'updateState':U ('update':U).
                 END.        
             END. /* WHEN '{&DATA-RANGES}':U */

         END CASE. /* CASE coSecurityType */
     END. /* IF cDataType EQ "CHARACTER":U */
     ELSE
     /* If the current column in the browser is of a logical data type */
     IF cDataType EQ "LOGICAL":U THEN
     DO:
         /* Toggle YES/NO screen value if mouse is double clicked */
         IF LAST-EVENT:FUNCTION EQ 'mouse-select-dblclick':U THEN
         DO:
             IF hCurrentColumn:SCREEN-VALUE EQ 'YES' THEN
                 ASSIGN
                    hCurrentColumn:SCREEN-VALUE = 'NO'.
             ELSE IF hCurrentColumn:SCREEN-VALUE EQ 'NO' THEN
                 ASSIGN
                    hCurrentColumn:SCREEN-VALUE = 'YES'.
         END. /* IF LAST-EVENT:FUNCTION EQ 'mouse-select-dblclick':U */
         ELSE
         /* Process 'Y' key press */
         IF LAST-EVENT:LABEL EQ 'Y' THEN
             hCurrentColumn:SCREEN-VALUE = 'YES'.
         ELSE
         /* Process 'N' key press */
         IF LAST-EVENT:LABEL EQ 'N' THEN
             hCurrentColumn:SCREEN-VALUE = 'NO'.

         /* Assign screen value to temp table buffer */
         hCurrentField:BUFFER-VALUE  = hCurrentColumn:SCREEN-VALUE.

         /* Set update state */
         IF NOT glModified AND ghBrowse:MODIFIED THEN
         DO:
              glModified = TRUE.
              PUBLISH 'updateState':U ('update':U).
         END.

         /* Return without processing the original browser event */
         RETURN NO-APPLY.

     END. /* IF cDataType EQ "LOGICAL":U */

  END. /* IF ghBuffer:AVAILABLE */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startSearch sObject 
PROCEDURE startSearch :
/*------------------------------------------------------------------------------
  Purpose:     Procedure for 'ROW-LEAVE' browser event
  Parameters:  <none>
  Notes:       Implements column sorting
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hColumn AS HANDLE     NO-UNDO.
  DEFINE VARIABLE rRow    AS ROWID      NO-UNDO.
  DEFINE VARIABLE cSortBy AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQuery  AS CHARACTER  NO-UNDO.

  /* Get handle to current column and save current position in browser */
  ASSIGN
      hColumn = ghBrowse:CURRENT-COLUMN
      rRow    = ghBuffer:ROWID.

  /* Handle to current column is valid */
  IF VALID-HANDLE(hColumn ) THEN
  DO:
      /* Construct sort string */
      ASSIGN
          cSortBy = (IF hColumn:TABLE <> ? THEN
                        hColumn:TABLE + '.':U + hColumn:NAME
                     ELSE hColumn:NAME)
          .
      /* Construct query string using sort string, then open query */
      ASSIGN cQuery = "FOR EACH ":U + ghBuffer:NAME + " NO-LOCK BY ":U + cSortBy.
      ghQuery:QUERY-PREPARE(cQuery).
      ghQuery:QUERY-OPEN().

      /* If new result set contains data, then reposition to the record in the browser saved in rRow */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE toolbar sObject 
PROCEDURE toolbar :
/*------------------------------------------------------------------------------
  Purpose:     Run from OK or CANCEL actions in container toolbar
  Parameters:  input string designating action to execute
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcAction                     AS CHARACTER  NO-UNDO.

  CASE pcAction:
     WHEN "OK" THEN
         /* Save changes with user cascade option set to NO */
         RUN saveChanges(INPUT NO).
     WHEN "Cancel" THEN
     DO:
        /* Close window */
        PUBLISH 'exitObject':U.
        RETURN.
     END.
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateState sObject 
PROCEDURE updateState :
/*------------------------------------------------------------------------------
  Purpose:     Enable / disable Save and Cascade buttons upon changes
               to the update state
  Parameters:  input string designating update state
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER cState       AS CHARACTER        NO-UNDO.

  ASSIGN
      buSave:SENSITIVE    IN FRAME {&FRAME-NAME} = (cState EQ 'update':U)
      buCascade:SENSITIVE IN FRAME {&FRAME-NAME} = (cState EQ 'update':U)
      .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateLoginCompany sObject 
PROCEDURE validateLoginCompany :
/*------------------------------------------------------------------------------
  Purpose:     To validate Login Company entered by User
  Parameters:  <none>
  Notes:       Allows Login Company to be blank
               Displays Company Name in fiLoginCoName if valid login company else "***Invalid Login Company***"
               Called upon leave of fiLoginCompany
               Makes an AppServer call
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cLoginCompanyName       AS CHARACTER    NO-UNDO.    
    DEFINE VARIABLE cErrorMessage       AS CHARACTER    NO-UNDO.

    /* Check only if Login Company has been modified */             
    IF fiLoginCompany:MODIFIED IN FRAME {&FRAME-NAME} THEN
    DO WITH FRAME {&FRAME-NAME}:

        /* If blank then OK and clear Login Company Name */
        IF fiLoginCompany:SCREEN-VALUE EQ "":U THEN
            fiLoginCoName:SCREEN-VALUE = "":U.            
        ELSE
        DO:
            /* Hour glass ON */
            SESSION:SET-WAIT-STATE("general":U).

            /* Fetch first batch of records in a dynamic temp-table */
            {af/sup2/afrun2.i      &PLIP  = 'af/app/gsmulplipp.p'
                                   &IPROC = 'getLoginCompanyName'
                                   &onApp = 'yes'
                                   &PLIST = "(INPUT  fiLoginCompany:SCREEN-VALUE,~
                                              OUTPUT cLoginCompanyName,~
                                              OUTPUT cErrorMessage)"~
                                   &Define-only = NO
                                   &autokill = YES}            
            /* Hour glass OFF */
            SESSION:SET-WAIT-STATE("":U).

            fiLoginCoName:SCREEN-VALUE = IF cErrorMessage <> "":U THEN "***Invalid Login Company***" ELSE cLoginCompanyName.
        END.
        fiLoginCompany:MODIFIED = NO.
    END.

    RETURN cErrorMessage.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateUser sObject 
PROCEDURE validateUser :
/*------------------------------------------------------------------------------
  Purpose:     To validate User ID entered by User
  Parameters:  <none>
  Notes:       Allows User ID to be blank
               Displays Full Name in fiUserName is valid user else "***Invalid User ID***"
               Called upon leave of fiUserID
               Makes an AppServer call
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cUserFullName       AS CHARACTER    NO-UNDO.  
    DEFINE VARIABLE cErrorMessage       AS CHARACTER    NO-UNDO.

    /* Check only if User ID has been modified */
    IF fiUserID:MODIFIED IN FRAME {&FRAME-NAME} THEN
    DO WITH FRAME {&FRAME-NAME}:

        /* If blank then OK and clear User Full Name */
        IF fiUserID:SCREEN-VALUE EQ "":U THEN
            fiUserName:SCREEN-VALUE = "":U.            
        ELSE        
        DO:
            /* Hour glass ON */
            SESSION:SET-WAIT-STATE("general":U).

            /* Call PLIP to validate User ID and retrieve Full Name */
            {af/sup2/afrun2.i      &PLIP  = 'af/app/gsmulplipp.p'
                                   &IPROC = 'getUserFullName'
                                   &onApp = 'yes'
                                   &PLIST = "(INPUT  fiUserID:SCREEN-VALUE,~
                                              OUTPUT cUserFullName,~
                                              OUTPUT cErrorMessage)"
                                   &Define-only = NO
                                   &autokill = YES}          
            /* Hour glass OFF */
            SESSION:SET-WAIT-STATE("":U).

            fiUserName:SCREEN-VALUE = IF cErrorMessage <> "":U THEN "***Invalid User ID***" ELSE cUserFullName.
        END.
        fiUserID:MODIFIED = NO.
    END.

    RETURN cErrorMessage.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewObject sObject 
PROCEDURE viewObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       Moves focus to the dynamic browser if it exists
------------------------------------------------------------------------------*/

  RUN SUPER.

  IF VALID-HANDLE(ghBrowse) THEN
    APPLY "entry":U TO ghBrowse.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentPage sObject 
FUNCTION getCurrentPage RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN 0.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION insertExpression sObject 
FUNCTION insertExpression RETURNS CHARACTER
    (pcWhere      AS CHAR,   
     pcExpression AS CHAR,     
     pcAndOr      AS CHAR):                         
  /*------------------------------------------------------------------------------
   Purpose:     Inserts an expression into ONE buffer's where-clause.
   Parameters:  
        pcWhere      - Complete where clause with or without the FOR keyword,
                       but without any comma before or after.
        pcExpression - New expression OR OF phrase (Existing OF phrase is replaced)
        pcAndOr      - Specifies what operator is used to add the new expression 
                       to existing ones.
                       - AND (default) 
                       - OR         
   Notes:       The new expression is embedded in parenthesis, but no parentheses
                are placed around the existing one.  
                Lock keywords must be unabbreviated or without -lock (i.e. SHARE
                or EXCLUSIVE.)   
                Any keyword in comments may cause problems.
                This is PRIVATE to query.p.   
  ------------------------------------------------------------------------------*/  
    DEFINE VARIABLE cTable        AS CHAR NO-UNDO.  
    DEFINE VARIABLE cRelTable     AS CHAR NO-UNDO.  
    DEFINE VARIABLE cJoinTable    AS CHAR NO-UNDO.  
    DEFINE VARIABLE cWhereOrAnd   AS CHAR NO-UNDO.  
    DEFINE VARIABLE iTblPos       AS INT  NO-UNDO.
    DEFINE VARIABLE iWherePos     AS INT  NO-UNDO.
    DEFINE VARIABLE lWhere        AS LOG  NO-UNDO.
    DEFINE VARIABLE iOfPos        AS INT  NO-UNDO.
    DEFINE VARIABLE iRelTblPos    AS INT  NO-UNDO.  
    DEFINE VARIABLE iInsertPos    AS INT  NO-UNDO.    

    DEFINE VARIABLE iUseIdxPos    AS INT  NO-UNDO.        
    DEFINE VARIABLE iOuterPos     AS INT  NO-UNDO.        
    DEFINE VARIABLE iLockPos      AS INT  NO-UNDO.      

    DEFINE VARIABLE iByPos        AS INT  NO-UNDO.        
    DEFINE VARIABLE iIdxRePos     AS INT  NO-UNDO.        

    ASSIGN 
      cTable        = whereClauseBuffer(pcWhere)
      iTblPos       = INDEX(pcWhere,cTable) + LENGTH(cTable,"CHARACTER":U)

      iWherePos     = INDEX(pcWhere," WHERE ":U) + 6    
      iByPos        = INDEX(pcWhere," BY ":U)    
      iUseIdxPos    = INDEX(pcWhere," USE-INDEX ":U)    
      iIdxRePos     = INDEX(pcWhere + " ":U," INDEXED-REPOSITION ":U)    
      iOuterPos     = INDEX(pcWhere + " ":U," OUTER-JOIN ":U)     
      iLockPos      = MAX(INDEX(pcWhere + " ":U," NO-LOCK ":U),
                          INDEX(pcWhere + " ":U," SHARE-LOCK ":U),
                          INDEX(pcWhere + " ":U," EXCLUSIVE-LOCK ":U),
                          INDEX(pcWhere + " ":U," SHARE ":U),
                          INDEX(pcWhere + " ":U," EXCLUSIVE ":U)
                          )    
      iInsertPos    = LENGTH(pcWhere) + 1 
                      /* We must insert before the leftmoust keyword,
                         unless the keyword is Before the WHERE keyword */ 
      iInsertPos    = MIN(
                        (IF iLockPos   > iWherePos THEN iLockPos   ELSE iInsertPos),
                        (IF iOuterPos  > iWherePos THEN iOuterPos  ELSE iInsertPos),
                        (IF iUseIdxPos > iWherePos THEN iUseIdxPos ELSE iInsertPos),
                        (IF iIdxRePos  > iWherePos THEN iIdxRePos  ELSE iInsertPos),
                        (IF iByPos     > iWherePos THEN iByPos     ELSE iInsertPos)
                         )                                                        
      lWhere        = INDEX(pcWhere," WHERE ":U) > 0 
      cWhereOrAnd   = (IF NOT lWhere          THEN " WHERE ":U 
                       ELSE IF pcAndOr = "":U OR pcAndOr = ? THEN " AND ":U 
                       ELSE " ":U + pcAndOr + " ":U) 
      iOfPos        = INDEX(pcWhere," OF ":U).

    IF LEFT-TRIM(pcExpression) BEGINS "OF ":U THEN 
    DO:   
      /* If there is an OF in both the join and existing query we replace the 
         table unless they are the same */      
      IF iOfPos > 0 THEN 
      DO:
        ASSIGN
          /* Find the table in the old join */               
          cRelTable  = ENTRY(1,LEFT-TRIM(SUBSTRING(pcWhere,iOfPos + 4))," ":U)      
          /* Find the table in the new join */       
          cJoinTable = SUBSTRING(LEFT-TRIM(pcExpression),3).

        IF cJoinTable <> cRelTable THEN
          ASSIGN 
           iRelTblPos = INDEX(pcWhere + " ":U," ":U + cRelTable + " ":U) 
                        + 1                            
           SUBSTRING(pcWhere,iRelTblPos,LENGTH(cRelTable)) = cJointable. 
      END. /* if iOfPos > 0 */ 
      ELSE 
        SUBSTRING(pcWhere,iTblPos,0) = " ":U + pcExpression.                                                                
    END. /* if left-trim(pcExpression) BEGINS "OF ":U */
    ELSE             
      SUBSTRING(pcWhere,iInsertPos,0) = cWhereOrAnd 
                                        + "(":U 
                                        + pcExpression 
                                        + ")":U. 

    RETURN RIGHT-TRIM(pcWhere).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION newQueryString sObject 
FUNCTION newQueryString RETURNS CHARACTER
      (pcQueryTables AS CHARACTER,
       pcColumns     AS CHARACTER,   
       pcValues      AS CHARACTER,    
       pcDataTypes   AS CHARACTER,    
       pcOperators   AS CHARACTER,
       pcQueryString AS CHARACTER,
       pcAndOr       AS CHARACTER):
    /*------------------------------------------------------------------------------   
       Purpose: Returns a new query string to the passed query. 
                The tables in the passed query must match getQueryTables().  
                Adds column/value pairs to the corresponding buffer's where-clause. 
                Each buffer's expression will always be embedded in parenthesis.
       Parameters: 
         pcQueryTables - Table names (Comma separated)
         pcColumns   - Column names (Comma separated) as table.fieldname                  

         pcValues    - corresponding Values (CHR(1) separated)
         pcDataTypes - corresponding data types (comma seperated)
         pcOperators - Operator - one for all columns
                                  - blank - defaults to (EQ)  
                                  - Use slash to define alternative string operator
                                    EQ/BEGINS etc..
                                - comma separated for each column/value
         pcQueryString - A complete querystring matching the queries tables.
                         MUST be qualifed correctly.
         pcAndOr       - AND or OR decides how the new expression is appended to 
                         the passed query (for each buffer!).                                               
       Notes:  This was taken from query.p but changed for lookups to work without an
               SDO.
    ------------------------------------------------------------------------------*/
      DEFINE VARIABLE cBufferList    AS CHAR      NO-UNDO.
      DEFINE VARIABLE cBuffer        AS CHARACTER NO-UNDO.

      /* We need the columns name and the parts */  
      DEFINE VARIABLE cColumn        AS CHARACTER NO-UNDO.
      DEFINE VARIABLE cColumnName    AS CHARACTER NO-UNDO.

      DEFINE VARIABLE iBuffer        AS INTEGER   NO-UNDO.
      DEFINE VARIABLE iColumn        AS INTEGER   NO-UNDO.

      DEFINE VARIABLE cUsedNums      AS CHAR      NO-UNDO.

      /* Used to builds the column/value string expression */
      DEFINE VARIABLE cBufWhere      AS CHARACTER NO-UNDO.
      DEFINE VARIABLE cDataType      AS CHAR      NO-UNDO.
      DEFINE VARIABLE cQuote         AS CHAR      NO-UNDO.    
      DEFINE VARIABLE cValue         AS CHAR      NO-UNDO.  
      DEFINE VARIABLE cOperator      AS CHARACTER NO-UNDO.
      DEFINE VARIABLE cStringOp      AS CHARACTER NO-UNDO.

      cBufferList = pcQueryTables.

      /* If unkown value is passed used the existing query string */
      IF pcQueryString = ? THEN RETURN ?.

      IF pcAndOr = "":U OR pcAndOr = ? THEN pcAndOr = "AND":U.   

      DO iBuffer = 1 TO NUM-ENTRIES(cBufferList):  
        ASSIGN
          cBufWhere      = "":U
          cBuffer        = ENTRY(iBuffer,cBufferList).

        ColumnLoop:    
        DO iColumn = 1 TO NUM-ENTRIES(pcColumns):

          IF CAN-DO(cUsedNums,STRING(iColumn)) THEN 
            NEXT ColumnLoop.      

          cColumn     = ENTRY(iColumn,pcColumns).

          /* Unqualified fields will use the first buffer in the query */
          IF INDEX(cColumn,".":U) = 0 THEN       
            cColumn = cBuffer + ".":U + cColumn.

          /* Wrong buffer? */
          IF NOT (cColumn BEGINS cBuffer + ".":U) THEN NEXT ColumnLoop.

          ASSIGN
            /* Get the operator for this valuelist. 
               Be forgiving and make sure we handle '',? and '/begins' as default */                                                  
            cOperator   = IF pcOperators = "":U 
                          OR pcOperators BEGINS "/":U 
                          OR pcOperators = ?                       
                          THEN "=":U 
                          ELSE IF NUM-ENTRIES(pcOperators) = 1 
                               THEN ENTRY(1,pcOperators,"/":U)                                                 
                               ELSE ENTRY(iColumn,pcOperators)

            /* Look for optional string operator if only one entry in operator */          
            cStringOp   = IF NUM-ENTRIES(pcOperators) = 1 
                          AND NUM-ENTRIES(pcOperators,"/":U) = 2  
                          THEN ENTRY(2,pcOperators,"/":U)                                                 
                          ELSE cOperator                    
            cColumnName = ENTRY(NUM-ENTRIES(cColumn,".":U),cColumn,".":U)              
            cDataType   = ENTRY(iColumn,pcDataTypes).

          IF cDataType <> ? THEN
          DO:
            ASSIGN          
              cValue     = ENTRY(iColumn,pcValues,CHR(1))                         
              cValue     = IF CAN-DO("INTEGER,DECIMAL":U,cDataType) AND cValue = "":U 
                           THEN "0":U 
                           ELSE IF cDataType = "DATE":U and cValue = "":U
                           THEN "?":U 
                           ELSE IF cValue = ? /*This could happen if only one value*/
                           THEN "?":U 
                           ELSE cValue
              cValue     = (IF cValue <> "":U 
                            THEN REPLACE(cValue,"'","~~~'")
                            ELSE " ":U) 
              cQuote     = (IF cDataType = "CHARACTER":U AND cValue = "?" 
                            THEN "":U 
                            ELSE "'":U)
              cBufWhere  = cBufWhere 
                           + (If cBufWhere = "":U 
                              THEN "":U 
                              ELSE " ":U + "AND":U + " ":U)
                           + cColumn 
                           + " ":U
                           + (IF cDataType = "CHARACTER":U  
                              THEN cStringOp
                              ELSE cOperator)
                           + " ":U
                           + cQuote  
                           + cValue
                           + cQuote
              cUsedNums  = cUsedNums
                           + (IF cUsedNums = "":U THEN "":U ELSE ",":U)
                           + STRING(iColumn).

          END. /* if cDatatype <> ? */          
        END. /* do iColumn = 1 to num-entries(pColumns) */    
        /* We have a new expression */ 
        IF cBufWhere <> "":U THEN
          ASSIGN 
            pcQueryString = DYNAMIC-FUNCTION("newWhereClause":U IN TARGET-PROCEDURE, INPUT cBuffer, INPUT cBufWhere, INPUT pcQueryString, INPUT pcAndOr).
      END. /* do iBuffer = 1 to hQuery:num-buffers */
      RETURN pcQueryString.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION newWhereClause sObject 
FUNCTION newWhereClause RETURNS CHARACTER
    (pcBuffer     AS CHAR,   
     pcExpression AS char,  
     pcWhere      AS CHAR,
     pcAndOr      AS CHAR):
  /*------------------------------------------------------------------------------
    Purpose:     Inserts a new expression to query's prepare string for a specified 
                 buffer.
    Parameters:  pcBuffer     - Which buffer.
                 pcExpression - The new expression. 
                 pcWhere      - The current query prepare string.
                 pcAndOr      - Specifies what operator is used to add the new
                                expression to existing expression(s)
                                - AND (default) 
                                - OR                                                
    Notes:       This is a utility function that doesn't use any properties.             
  ------------------------------------------------------------------------------*/
   DEFINE VARIABLE iComma      AS INT    NO-UNDO. 
   DEFINE VARIABLE iCount      AS INT    NO-UNDO.
   DEFINE VARIABLE iStart      AS INT    NO-UNDO.
   DEFINE VARIABLE iLength     AS INT    NO-UNDO.
   DEFINE VARIABLE iEnd        AS INT    NO-UNDO.
   DEFINE VARIABLE cWhere      AS CHAR   NO-UNDO.
   DEFINE VARIABLE cString     AS CHAR   NO-UNDO.
   DEFINE VARIABLE cFoundWhere AS CHAR   NO-UNDO.
   DEFINE VARIABLE cNextWhere  AS CHAR   NO-UNDO.
   DEFINE VARIABLE hQuery      AS HANDLE NO-UNDO.

    /* Astra2  - fix European decimal format issues with Astra object numbers in query string
       FYI: fixQueryString is a function in smartcustom.p
    */
    pcWhere = DYNAMIC-FUNCTION("fixQueryString":U IN TARGET-PROCEDURE, INPUT pcWhere). /* Astra2 */

   ASSIGN
     cString = pcWhere
     iStart  = 1.          

   DO WHILE TRUE:

     iComma  = INDEX(cString,","). 

     /* If a comma was found we split the string into cFoundWhere and cNextwhere */  
     IF iComma <> 0 THEN 
       ASSIGN
         cFoundWhere = cFoundWhere + SUBSTR(cString,1,iComma)
         cNextWhere  = SUBSTR(cString,iComma + 1)     
         iCount      = iCount + iComma.       
     ELSE 

       /* cFoundWhere is blank if this is the first time or if we have moved on 
          to the next buffers where clause
          If cFoundwhere is not blank the last comma that was used to split 
          the string into cFoundwhere and cNextwhere was not a join, 
          so we must set them together again.   
       */     
       cFoundWhere = IF cFoundWhere = "":U 
                     THEN cString
                     ELSE cFoundWhere + cNextwhere.

     /* We have a complete table whereclause if there are no more commas
        or the next whereclause starts with each,first or last */    
     IF iComma = 0 
     OR CAN-DO("EACH,FIRST,LAST":U,ENTRY(1,TRIM(cNextWhere)," ":U)) THEN
     DO:
       /* Remove comma or period before inserting the new expression */
       ASSIGN
         cFoundWhere = RIGHT-TRIM(cFoundWhere,",.":U) 
         iLength     = LENGTH(cFoundWhere).

       IF whereClauseBuffer(cFoundWhere) = pcBuffer  THEN
       DO:   
         SUBSTR(pcWhere,iStart,iLength) = insertExpression(cFoundWhere,
                                                           pcExpression,
                                                           pcAndOr).           
         LEAVE.
       END.
       ELSE
         /* We're moving on to the next whereclause so reset cFoundwhere */ 
         ASSIGN      
           cFoundWhere = "":U                     
           iStart      = iCount + 1.      

       /* No table found and we are at the end so we need to get out of here */  
       IF iComma = 0 THEN 
       DO:
         /* (Buffer is not in query) Is this a run time error ? */.
         LEAVE.    
       END.
     END. /* if iComma = 0 or can-do(EACH,FIRST,LAST */
     cString = cNextWhere.  
   END. /* do while true. */
   RETURN pcWhere.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION whereClauseBuffer sObject 
FUNCTION whereClauseBuffer RETURNS CHARACTER
    (pcWhere AS CHAR):
  /*------------------------------------------------------------------------------
    Purpose:     Returns the buffername of a where clause expression. 
                 This function avoids problems with leading or double blanks in 
                 where clauses.
    Parameters:
      pcWhere - Complete where clause for ONE table with or without the FOR 
                keyword. The buffername must be the second token in the
                where clause as in "EACH order OF Customer" or if "FOR" is
                specified the third token as in "FOR EACH order".

    Notes:       PRIVATE, used internally in query.p only.
  ------------------------------------------------------------------------------*/
    pcWhere = LEFT-TRIM(pcWhere).

    /* Remove double blanks */
    DO WHILE INDEX(pcWhere,"  ":U) > 0:
      pcWhere = REPLACE(pcWhere,"  ":U," ":U).
    END.

    RETURN (IF NUM-ENTRIES(pcWhere," ":U) > 1 
            THEN ENTRY(IF pcWhere BEGINS "FOR ":U THEN 3 ELSE 2,pcWhere," ":U)
            ELSE "":U).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

