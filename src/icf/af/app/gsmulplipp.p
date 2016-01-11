&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
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
  File: gsmulplipp.p

  Description:  Security Allocations PLIP

  Purpose:      Security Allocations PLIP

  Parameters:

  History:
  --------
  (v:010000)    Task:    90000011   UserRef:    POSSE
                Date:   31/03/2001  Author:     Anthony Swindells

  Update Notes: Security Allocations

  (v:010001)    Task:    90000163   UserRef:    
                Date:   30/07/2001  Author:     Anthony Swindells

  Update Notes: Entity Table Normalization

      Modified: 10/15/2001        Mark Davies (MIP)
                In procedure setDataRecordsQueryParams a reference was made
                to a record in table gsc_entity_display_field which was not
                available. This was incorrect, removed all these references.
---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       gsmulplipp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

/* Astra global variables */
{af/sup2/afglobals.i}

/* Query parameter temp table */
{af/app/gsmulttqpm.i}

/* Preprocessor types for security types */
{af/app/gsmuldefns.i}

/* Error handling definitions */
{af/sup2/afcheckerr.i &define-only = YES}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-createTT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createTT Procedure 
FUNCTION createTT RETURNS HANDLE PRIVATE
  ( INPUT pcSecurityType AS CHARACTER,
    INPUT pcFieldHdlList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBufferHandleList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBufferHandleList Procedure 
FUNCTION getBufferHandleList RETURNS CHARACTER
  ( INPUT-OUTPUT phQuery      AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCompanyObj) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCompanyObj Procedure 
FUNCTION getCompanyObj RETURNS DECIMAL PRIVATE
  ( INPUT pcLoginCompany    AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldHandleList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFieldHandleList Procedure 
FUNCTION getFieldHandleList RETURNS CHARACTER
   (INPUT pcBufferHdlList        AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldRestriction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFieldRestriction Procedure 
FUNCTION getFieldRestriction RETURNS CHARACTER PRIVATE
  ( INPUT pdUserObj             AS DECIMAL,
    INPUT pdOrganisationObj     AS DECIMAL,
    INPUT pcEntityMnemonic      AS CHARACTER,
    INPUT pdOwningObj           AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLogicalRestriction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLogicalRestriction Procedure 
FUNCTION getLogicalRestriction RETURNS LOGICAL PRIVATE
  ( INPUT pdUserObj            AS DECIMAL,
    INPUT pdOrganisationObj    AS DECIMAL,
    INPUT pcEntityMnemonic     AS CHARACTER,
    INPUT pdOwningObj          AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOwningObj) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getOwningObj Procedure 
FUNCTION getOwningObj RETURNS DECIMAL
  ( INPUT phTTBuffer         AS HANDLE,
    INPUT pcEntityMnemonic   AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUserObj) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUserObj Procedure 
FUNCTION getUserObj RETURNS DECIMAL PRIVATE
  ( INPUT pcUserID AS CHARACTER)  FORWARD.

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
         HEIGHT             = 20.76
         WIDTH              = 74.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm/method/attribut.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */

{ry/app/ryplipmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-assignFieldValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignFieldValue Procedure 
PROCEDURE assignFieldValue :
/*------------------------------------------------------------------------------
  Purpose:     Assigns the temp table field value from the corresponding buffer
               field object
  Parameters:  input comma-separated list of field handles
               input handle to temp table field
               input handle to buffer field object
  Notes:       
------------------------------------------------------------------------------*/

   DEFINE INPUT         PARAMETER pcFieldHdlList           AS CHARACTER NO-UNDO.
   DEFINE INPUT         PARAMETER phSourceField            AS HANDLE    NO-UNDO.
   DEFINE INPUT         PARAMETER phDestinationField       AS HANDLE    NO-UNDO.

   DEFINE VARIABLE iPos                                    AS INTEGER   NO-UNDO.
   DEFINE VARIABLE cIfNullValue                            AS CHARACTER NO-UNDO.

   FIND FIRST ttQueryParams NO-ERROR.

   IF phSourceField:BUFFER-VALUE NE ? AND STRING(phSourceField:BUFFER-VALUE) NE "":U AND STRING(phSourceField:BUFFER-VALUE) NE "?":U THEN
   DO:
      IF phDestinationField:DATA-TYPE <> "CHARACTER":U THEN
        phDestinationField:BUFFER-VALUE = phSourceField:BUFFER-VALUE.
      ELSE
        phDestinationField:BUFFER-VALUE = SUBSTRING(phSourceField:BUFFER-VALUE,1,70). /* prevent stack from blowing */
   END.
   ELSE
   DO:
       iPos = LOOKUP(STRING(phSourceField),pcFieldHdlList).
       IF NUM-ENTRIES(ttQueryParams.cBrowseFieldValuesIfNull, CHR(3)) GE iPos THEN
       DO:

           cIfNullValue = ENTRY(iPos,ttQueryParams.cBrowseFieldValuesIfNull,CHR(3)).

           CASE phDestinationField:DATA-TYPE:
               WHEN "CHARACTER":U THEN
                   phDestinationField:BUFFER-VALUE = cIfNullValue.
               OTHERWISE
                   phDestinationField:BUFFER-VALUE = phSourceField:BUFFER-VALUE.

           END CASE.

       END.
   END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cascadeUsers) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cascadeUsers Procedure 
PROCEDURE cascadeUsers PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     If the given user is a profile user, then for each other user record
               which has been created from this profile user, propagate the security
               allocations to these user as well.
  Parameters:  input string for a given User ID 
               input string for a given Login Company
               input string for a given Security Type
               input string for a given Entity Mnemonic
               input handle to a temp table storing the security allocations
               output string for any error messages
  Notes:       Private to this PLIP.
               Makes a recursive call to commitQueryResultSet in this procedure.
               Take care with variable scope!
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pcUserID           AS CHARACTER          NO-UNDO.
  DEFINE INPUT  PARAMETER pcLoginCompany     AS CHARACTER          NO-UNDO.
  DEFINE INPUT  PARAMETER pcSecurityType     AS CHARACTER          NO-UNDO.
  DEFINE INPUT  PARAMETER pcEntityMnemonic   AS CHARACTER          NO-UNDO.
  DEFINE INPUT  PARAMETER phTable            AS HANDLE             NO-UNDO.

  DEFINE OUTPUT PARAMETER ocErrorText        AS CHARACTER          NO-UNDO.

  DEFINE BUFFER b_gsm_user                   FOR gsm_user.

  DEFINE VARIABLE hQuery                     AS HANDLE             NO-UNDO.
  DEFINE VARIABLE hTTBuffer                  AS HANDLE             NO-UNDO.
  DEFINE VARIABLE hField                     AS HANDLE             NO-UNDO.
  DEFINE VARIABLE cQuery                     AS CHARACTER          NO-UNDO.
  DEFINE VARIABLE cError                     AS CHARACTER          NO-UNDO.

  /* Get user record using User ID parameter */
  FIND FIRST gsm_user NO-LOCK
       WHERE gsm_user.USER_login_name EQ pcUserID
       NO-ERROR.
  /* If user record found and the user is a profile user */
  IF AVAILABLE gsm_user AND gsm_user.profile_user THEN
  DO:
      /* construct and open query on b_gsm_user for users created from this profile user */
      CREATE QUERY hQuery.
      hTTBuffer = BUFFER b_gsm_user:HANDLE.    
      hQuery:ADD-BUFFER(hTTBuffer).
      ASSIGN cQuery = "FOR EACH b_gsm_user NO-LOCK
                          WHERE b_gsm_user.created_from_profile_user_obj EQ " + STRING(gsm_user.user_obj).
      hQuery:QUERY-PREPARE(cQuery).
      hQuery:QUERY-OPEN() NO-ERROR.

      /* process each user created from this profile user */
      hQuery:GET-FIRST().
      DO WHILE hTTBuffer:AVAILABLE:      
          /* Get user_login_name field of this user */
          hField = hTTBuffer:BUFFER-FIELD('user_login_name':U).
          /* Make recursive call to commitQueryResultSet using this user value of user_login_name (User ID) */
          RUN commitQueryResultSet (INPUT  hField:BUFFER-VALUE(),
                                    INPUT  YES,
                                    INPUT  pcLoginCompany,
                                    INPUT  pcSecurityType,
                                    INPUT  pcEntityMnemonic,
                                    INPUT  TABLE-HANDLE phTable,
                                    OUTPUT cError).                                              
          IF cError NE "":U THEN
             ocErrorText = ocErrorText 
                         + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) 
                         + cError.
          hQuery:GET-NEXT().
      END. /* WHILE hTTBuffer AVAILABLE */

  END. /* AVAILABLE gsm_user AND gsm_user.profile_user */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-commitQueryResultSet) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE commitQueryResultSet Procedure 
PROCEDURE commitQueryResultSet :
/*------------------------------------------------------------------------------
  Purpose:     Commits given security allocations
  Parameters:  input string for a given User ID 
               input string for a given Login Company
               input string for a given Security Type
               input string for a given Entity Mnemonic
               input handle to a temp table storing the security allocations
               output string for any error messages
  Notes:       Public procedure of PLIP
               Determines the _obj value for the given User and Login Company
               Constructs amd opens a query on the given temp table
               Iterates through the given temp table and delegates committing
               to the database to one of setLogicalRestriction, SetFieldRestrictiion
               or SetRangeRestriction according to Security Type
               If given cascade flag has been set to YES for a given User, then run CascadeUsers 
------------------------------------------------------------------------------*/

    DEFINE INPUT        PARAMETER              pcUserID                AS CHARACTER     NO-UNDO. /* Entered User Login ID */ 
    DEFINE INPUT        PARAMETER              plCascade               AS LOGICAL       NO-UNDO. /* flag to Cascade for Profile users */
    DEFINE INPUT        PARAMETER              pcLoginCompany          AS CHARACTER     NO-UNDO. /* Entered login company code */
    DEFINE INPUT        PARAMETER              pcSecurityType          AS CHARACTER     NO-UNDO. /* Type of security structure */
    DEFINE INPUT        PARAMETER              pcEntityMnemonic        AS CHARACTER     NO-UNDO. /* Five letter entity mnemonic */
    DEFINE INPUT        PARAMETER TABLE-HANDLE phTable.                                          /* table handle for Data dynamic temp-table */

    DEFINE OUTPUT       PARAMETER              ocErrorText             AS CHARACTER     NO-UNDO. /* Error messages string */


    DEFINE VARIABLE hTTBuffer          AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hQuery             AS HANDLE       NO-UNDO.
    DEFINE VARIABLE cQuery             AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE dUserObj           AS DECIMAL      NO-UNDO.
    DEFINE VARIABLE dCompanyObj        AS DECIMAL      NO-UNDO.
    DEFINE VARIABLE cError             AS CHARACTER    NO-UNDO.


    /* Retrieve User record if given a UserID parameter value */
    dUserObj = getUserObj(pcUserID).
    IF dUserObj = -1.00 THEN
    DO:
        ocErrorText   = ocErrorText 
                      + (IF NUM-ENTRIES(ocErrorText,CHR(3)) > 0 THEN CHR(3) ELSE '':U)                   
                      + {af/sup2/aferrortxt.i 'AF' '11' '?' '?' '"user object value"' pcUserID}.
        RETURN.
    END.

    /* Retrieve Organisation record if given a Login Company parameter value */
    dCompanyObj = getCompanyObj(pcLoginCompany).
    IF dCompanyObj = -1.00 THEN
    DO:
        ocErrorText   = ocErrorText 
                      + (IF NUM-ENTRIES(ocErrorText,CHR(3)) > 0 THEN CHR(3) ELSE '':U)                   
                      + {af/sup2/aferrortxt.i 'AF' '11' '?' '?' '"login company object value"' pcLoginCompany}.
        RETURN.
    END.

    /* Get Entity Mnemonic record */
    IF NOT CAN-FIND(FIRST gsc_entity_mnemonic
                    WHERE gsc_entity_mnemonic.entity_mnemonic = pcEntityMnemonic) THEN
    DO:
        ocErrorText = ocErrorText
                    + (IF NUM-ENTRIES(ocErrorText,CHR(3)) > 0 THEN CHR(3) ELSE '':U)                   
                    + {af/sup2/aferrortxt.i 'AF' '11' 'gsm_entity_mnemonic' 'entity_mnemonic' '"Entity Mnemonic"' pcEntityMnemonic}.
        RETURN.
    END.

    /* Get default buffer handle of temp-table parameter */
    hTTBuffer = phTable:DEFAULT-BUFFER-HANDLE.

    /* Construct and open query on temp table */
    CREATE QUERY hQuery.
    hQuery:ADD-BUFFER(hTTBuffer).
    ASSIGN cQuery = "FOR EACH ":U + hTTBuffer:NAME + " NO-LOCK":U.
    hQuery:QUERY-PREPARE(cQuery).
    hQuery:QUERY-OPEN() NO-ERROR.

    /* Process each record in the temp table */
    hQuery:GET-FIRST().
    DO WHILE hTTBuffer:AVAILABLE:

        /* Depending on Security Type parameter value */
        CASE pcSecurityType:

            WHEN    "{&MENU-STRUCTURES}":U 
            OR WHEN "{&MENU-ITEMS}":U 
            OR WHEN "{&ACCESS-TOKENS}":U 
            OR WHEN "{&DATA-RECORDS}":U
            OR WHEN "{&LOGIN-COMPANIES}":U
            THEN
                RUN setLogicalRestriction
                    (INPUT  dUserObj,
                     INPUT  dCompanyObj,
                     INPUT  hTTBuffer,
                     INPUT  pcEntityMnemonic,
                     OUTPUT cError ).

            WHEN "{&FIELDS}":U THEN
                RUN setFieldRestriction
                    (INPUT  dUserObj,
                     INPUT  dCompanyObj,
                     INPUT  hTTBuffer,
                     INPUT  pcEntityMnemonic,
                     OUTPUT cError ).

            WHEN "{&DATA-RANGES}":U THEN
                RUN setRangeRestriction
                    (INPUT  dUserObj,
                     INPUT  dCompanyObj,
                     INPUT  hTTBuffer,
                     INPUT  pcEntityMnemonic,
                     OUTPUT cError ).

        END CASE. /* CASE pcSecurityType */

        IF cError NE "":U THEN
            ocErrorText   = ocErrorText 
                          + (IF NUM-ENTRIES(ocErrorText,CHR(3)) > 0 THEN CHR(3) ELSE '':U)                   
                          + {af/sup2/aferrortxt.i 'AF' cError}.

        hQuery:GET-NEXT().
    END. /* WHILE hTTBuffer:AVAILABLE */

    /* close the query */
    hQuery:QUERY-CLOSE().

    /* Cascade to users created from this user if a profile user */
    IF pcUserID NE "":U AND plCascade THEN
    DO:
        RUN cascadeUsers
            (INPUT  pcUserID,
             INPUT  pcLoginCompany,
             INPUT  pcSecurityType,
             INPUT  pcEntityMnemonic,
             INPUT  phTable,
             OUTPUT cError).
        IF cError NE "":U THEN
            ocErrorText   = ocErrorText 
                          + (IF NUM-ENTRIES(ocErrorText,CHR(3)) > 0 THEN CHR(3) ELSE '':U)                   
                          + {af/sup2/aferrortxt.i 'AF' cError}.
    END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLoginCompanyName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLoginCompanyName Procedure 
PROCEDURE getLoginCompanyName :
/*------------------------------------------------------------------------------
  Purpose:     To validate a Login Company code and return Login Company Name
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pcLoginCompany               AS CHARACTER    NO-UNDO.
    DEFINE OUTPUT PARAMETER ocLoginCompanyName           AS CHARACTER    NO-UNDO.
    DEFINE OUTPUT PARAMETER ocErrorText                  AS CHARACTER    NO-UNDO.

    /* Find login company record key by input login company code */
    FIND FIRST gsm_login_company NO-LOCK
         WHERE gsm_login_company.login_company_code EQ pcLoginCompany
         NO-ERROR.
    IF NOT AVAILABLE gsm_login_company THEN
    DO:
       /* Return an error message */
       ocErrorText   = ocErrorText 
                     + (IF NUM-ENTRIES(ocErrorText,CHR(3)) > 0 THEN CHR(3) ELSE '':U)                   
                     + {af/sup2/aferrortxt.i 'AF' '11' '?' '?' '"login company"' pcLoginCompany}.
    END.
    ELSE
       /* Return Login Company name */
       ocLoginCompanyName = gsm_login_company.login_company_name.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryResultSet) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getQueryResultSet Procedure 
PROCEDURE getQueryResultSet :
/*------------------------------------------------------------------------------
  Purpose:     Returns a batch of security allocation records in a dynamic temp table 
               found via a query which is defined by query parameters in ttQueryParams.               
  Parameters:  input string for a given User ID
               input string for a given Login Company
               input string for a given Security Type
               input string for a given Entity Mnemonic
               input-output temp table containing query parameters
               output handle to a temp table containing a result set from the query
               output string for error messages
  Notes:       Creates the dynamic temp table from the information in the ttQueryParams record
               Some fields are hard-coded in createTT.
               Iterates through the result set of the query to allocate values to fields
               in the dynamic temp table
------------------------------------------------------------------------------*/

DEFINE INPUT        PARAMETER              pcUserID                AS CHARACTER     NO-UNDO. 
DEFINE INPUT        PARAMETER              pcLoginCompany          AS CHARACTER     NO-UNDO. 
DEFINE INPUT        PARAMETER              pcSecurityType          AS CHARACTER     NO-UNDO. 
DEFINE INPUT        PARAMETER              pcEntityMnemonic        AS CHARACTER     NO-UNDO. 

DEFINE INPUT-OUTPUT PARAMETER TABLE FOR    ttQueryParams.                                    

DEFINE OUTPUT       PARAMETER TABLE-HANDLE ohttResultsSet.                                   
DEFINE OUTPUT       PARAMETER              ocMessageList           AS CHARACTER     NO-UNDO. 


DEFINE VARIABLE hTT                         AS HANDLE     NO-UNDO.
DEFINE VARIABLE hQuery                      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hBuffer                     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hField                      AS HANDLE     NO-UNDO.
DEFINE VARIABLE iStartRow                   AS INTEGER    NO-UNDO.
DEFINE VARIABLE cStartRowId                 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop                       AS INTEGER    NO-UNDO.
DEFINE VARIABLE dcUserObj                   AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dcCompanyObj                AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cBufferHdlList              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFieldHdlList               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cBuffer                     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cField                      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hTTBuff                     AS HANDLE     NO-UNDO.
DEFINE VARIABLE rRowIDs                     AS ROWID EXTENT 10 NO-UNDO.
DEFINE VARIABLE lOffEnd                     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lOk                         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lRestricted                 AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cFieldRestriction           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRangeValueFrom             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRangeValueTo               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop2                      AS INTEGER    NO-UNDO.
DEFINE VARIABLE hFromField                  AS HANDLE     NO-UNDO.
DEFINE VARIABLE cBrowseFields               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iRow                        AS INTEGER    NO-UNDO.
DEFINE VARIABLE cRowid                      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cErrorMessage               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cUserName                   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCompanyName                AS CHARACTER  NO-UNDO.


/* Initialise this batch */
ASSIGN
  ohttResultsSet = ?
  .

/* Get query parameters record*/
FIND FIRST ttQueryParams NO-ERROR.
IF NOT AVAILABLE ttQueryParams THEN 
DO:    
    ocMessageList = ocMessageList 
                  + (IF NUM-ENTRIES(ocMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U)                   
                  + {af/sup2/aferrortxt.i 'AF' '29' 'ttQueryParams' '?' '"query parameter temp table record'"}. 
    RETURN.
END.

/* See if appending to an existing result set */ 
IF ttQueryParams.cLastResultRow <> "":U THEN
  ASSIGN
    iStartRow = INTEGER(ENTRY(1,ttQueryParams.cLastResultRow,";":U))
    cStartRowId = ENTRY(2,ttQueryParams.cLastResultRow,";":U).
ELSE
  ASSIGN
    iStartRow = 0
    cStartRowId = "":U
    .

/* Validate User ID parameter */
IF pcUserID NE "":U THEN
DO:
 RUN getUserFullName
     (INPUT  pcUserID,
      OUTPUT cUserName,
      OUTPUT cErrorMessage).
 IF cErrorMessage NE "":U THEN
 DO:
    ocMessageList = ocMessageList 
                  + (IF NUM-ENTRIES(ocMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U)                   
                  + cErrorMessage.
    RETURN.
 END.
END.

/* Validate Login Company parameter */
IF pcLoginCompany NE "":U THEN
DO:
 RUN getLoginCompanyName
     (INPUT  pcLoginCompany,
      OUTPUT cCompanyName,
      OUTPUT cErrorMessage).
 IF cErrorMessage NE "":U THEN
 DO:
    ocMessageList = ocMessageList 
                  + (IF NUM-ENTRIES(ocMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U)                   
                  + cErrorMessage.
    RETURN.
 END.
END.

/* Retrieve User record if given a UserID parameter value */
dcUserObj = getUserObj(pcUserID).
IF dcUserObj = -1.00 THEN
DO:
    ocMessageList = ocMessageList 
                  + (IF NUM-ENTRIES(ocMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U)                   
                  + {af/sup2/aferrortxt.i 'AF' '11' '?' '?' '"user object value"' pcUserID}.
   RETURN.
END.

/* Retrieve Organisation record if given a Login Company parameter value */
dcCompanyObj = getCompanyObj(pcLoginCompany).
IF dcCompanyObj = -1.00 THEN
DO:
    ocMessageList = ocMessageList 
                  + (IF NUM-ENTRIES(ocMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U)                   
                  + {af/sup2/aferrortxt.i 'AF' '11' '?' '?' '"login company object value"' pcLoginCompany}.
    RETURN.
END.

/* If Security Type is Data Records and the query is being run for the first time,
   set query parameters calling SetDataRecordsQueryParams procedure */
IF pcSecurityType = "{&DATA-RECORDS}":U AND ttQueryParams.iFirstRowNum = 0 THEN
DO:
   RUN setDataRecordsQueryParams 
       (INPUT  pcEntityMnemonic,
        OUTPUT cErrorMessage).    
   IF cErrorMessage NE "":U THEN
   DO:
       ocMessageList = ocMessageList 
                     + (IF NUM-ENTRIES(ocMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U)                   
                     + cErrorMessage.
       RETURN.
   END.
    /* Re-Get query parameters record*/
    FIND FIRST ttQueryParams NO-ERROR.
END.

/* Create query */
CREATE QUERY hQuery NO-ERROR.

/* Get buffer handle list */
cBufferHdlList = getBufferHandleList(INPUT-OUTPUT hQuery).

/* Get field handle list */
cFieldHdlList = getFieldHandleList(cBufferHdlList).

/* Create dynamic temp table */
hTT = createTT(pcSecurityType, cFieldHdlList).

/* Get the handle to the buffer for the temp-table */
hTTBuff = hTT:DEFAULT-BUFFER-HANDLE.

/* Remove decimals with commas for Europe */
ttQueryParams.cBaseQueryString = DYNAMIC-FUNCTION("fixQueryString":U IN gshSessionManager, INPUT ttQueryParams.cBaseQueryString).

/* Prepare a query using the string the user provided */
hQuery:QUERY-PREPARE(ttQueryParams.cBaseQueryString).

/* Open the query */
hQuery:QUERY-OPEN().

/* Position to desired record */
IF ttQueryParams.iFirstRowNum = 0 OR cStartRowId = "":U THEN
DO:
    /* Get the first result in the result set and indicate query started */
    hQuery:GET-FIRST() NO-ERROR.
END.
ELSE
DO: 
    /* Restart from after the last record read */
    ASSIGN rRowIDs = ?.       /* Fill in this array with all the rowids. */
    DO iLoop = 1 TO NUM-ENTRIES(cStartRowId):
    rRowIDs[iLoop] = TO-ROWID(ENTRY(iLoop, cStartRowId)).
    END.        /* END DO iCnt */
    lOffEnd = hQuery:QUERY-OFF-END. 
    lOk = hQuery:REPOSITION-TO-ROWID(rRowIDs) NO-ERROR.
    IF lOk OR (lOffEnd AND NOT ERROR-STATUS:ERROR) THEN 
    DO:
    hQuery:GET-NEXT() NO-ERROR. /* get row repositioned to */
    hQuery:GET-NEXT() NO-ERROR. /* get next record */
    END.
END.

/* Iterate for as many rows as the user has chosen, or until the query is off-end */
REPEAT iRow = (iStartRow + 1) TO (ttQueryParams.iRowsToBatch + iStartRow) WHILE NOT hQuery:QUERY-OFF-END:

  /* For a given Security Type parameter value, check security restrictions allocations */  
  ASSIGN
      lRestricted = NO
      .
  CASE pcSecurityType:
      WHEN '{&MENU-STRUCTURES}':U THEN
      DO:
          /* Get the handle to the buffer for gsm_menu_structure from the buffer handle list */
          hBuffer = WIDGET-HANDLE(ENTRY(LOOKUP('gsm_menu_structure':U,ttQueryParams.cQueryTables),cBufferHdlList)).
          /* Get the handle to the menu_structure_obj field of the gsm_menu_structure buffer */
          hField  = hBuffer:BUFFER-FIELD('menu_structure_obj':U).          
          /* Determine whether the menu structure - uniquely key by the menu_structure_obj field -
            is restricted for a given value of User ID and Login Company */
          lRestricted = getLogicalRestriction
                           (INPUT dcUserObj,
                            INPUT dcCompanyObj,
                            INPUT pcEntityMnemonic,
                            INPUT hField:BUFFER-VALUE()).                            
      END.
      WHEN '{&MENU-ITEMS}':U THEN
      DO:
          /* Get the handle to the buffer for gsm_menu_item from the buffer handle list */
          hBuffer = WIDGET-HANDLE(ENTRY(LOOKUP('gsm_menu_item':U,ttQueryParams.cQueryTables),cBufferHdlList)).
          /* Get the handle to the menu_item_obj field of the gsm_menu_item buffer */
          hField  = hBuffer:BUFFER-FIELD('menu_item_obj':U).    
          /* Determine whether the menu item - uniquely key by the menu_item_obj field -
            is restricted for a given value of User ID and Login Company */
          lRestricted = getLogicalRestriction
                           (INPUT dcUserObj,
                            INPUT dcCompanyObj,
                            INPUT pcEntityMnemonic,
                            INPUT hField:BUFFER-VALUE()).                            
      END.
      WHEN '{&ACCESS-TOKENS}':U THEN
      DO:
          /* Get the handle to the buffer for gsm_security_structure from the buffer handle list */
          hBuffer = WIDGET-HANDLE(ENTRY(LOOKUP('gsm_security_structure':U,ttQueryParams.cQueryTables),cBufferHdlList)).
          /* Get the handle to the security_structure_obj field of the gsm_security_structure buffer */
          hField  = hBuffer:BUFFER-FIELD('security_structure_obj':U).         
          /* Determine whether the security structure for an access token - uniquely key by the security_structure_obj field -
            is restricted for a given value of User ID and Login Company */
          lRestricted = getLogicalRestriction
                           (INPUT dcUserObj,
                            INPUT dcCompanyObj,
                            INPUT pcEntityMnemonic,
                            INPUT hField:BUFFER-VALUE()).                            
      END.
      WHEN '{&FIELDS}':U THEN
      DO:
          /* Get the handle to the buffer for gsm_security_structure from the buffer handle list */
          hBuffer = WIDGET-HANDLE(ENTRY(LOOKUP('gsm_security_structure':U,ttQueryParams.cQueryTables),cBufferHdlList)).
          /* Get the handle to the security_structure_obj field of the gsm_security_structure buffer */
          hField  = hBuffer:BUFFER-FIELD('security_structure_obj':U).         
          /* Determine whether the security structure of an input field - uniquely key by the security_structure_obj field -
            is restricted for a given value of User ID and Login Company */
          cFieldRestriction = getFieldRestriction
                                 (INPUT dcUserObj,
                                  INPUT dcCompanyObj,
                                  INPUT pcEntityMnemonic,
                                  INPUT hField:BUFFER-VALUE()).                            
      END.
      WHEN '{&DATA-RANGES}':U THEN
      DO:
          /* Get the handle to the buffer for gsm_security_structure from the buffer handle list */
          hBuffer = WIDGET-HANDLE(ENTRY(LOOKUP('gsm_security_structure':U,ttQueryParams.cQueryTables),cBufferHdlList)).
          /* Get the handle to the security_structure_obj field of the gsm_security_structure buffer */
          hField  = hBuffer:BUFFER-FIELD('security_structure_obj':U).          
          /* Determine whether the security structure for a data range - uniquely key by the security_structure_obj field -
            is restricted for a given value of User ID and Login Company */
          RUN getRangeRestriction
              (INPUT dcUserObj,
               INPUT dcCompanyObj,
               INPUT pcEntityMnemonic,
               INPUT  hField:BUFFER-VALUE(),
               OUTPUT lRestricted,
               OUTPUT cRangeValueFrom,
               OUTPUT cRangeValueTo).
      END.
      WHEN '{&DATA-RECORDS}':U THEN
      DO:         
          /* Get the handle to the buffer for database table from the buffer handle list */
          hBuffer = WIDGET-HANDLE(ENTRY(1,cBufferHdlList)).
          /* Get the handle to the _obj field of the buffer */
          IF gsc_entity_mnemonic.table_has_object_field AND gsc_entity_mnemonic.entity_object_field <> "" THEN
              hField = hBuffer:BUFFER-FIELD(gsc_entity_mnemonic.entity_object_field).
          ELSE IF gsc_entity_mnemonic.table_has_object_field THEN
              hField = hBuffer:BUFFER-FIELD(hBuffer:BUFFER-NAME + "_obj":U).
          ELSE
              hField = ?.
          /* Determine whether the database record - uniquely key by the _obj field -
             is restricted for a given value of User ID and Login Company */
          IF VALID-HANDLE(hField) THEN
              lRestricted = getLogicalRestriction
                               (INPUT dcUserObj,
                                INPUT dcCompanyObj,
                                INPUT gsc_entity_mnemonic.entity_mnemonic,
                                INPUT hField:BUFFER-VALUE()).                            
      END.
      WHEN '{&LOGIN-COMPANIES}':U THEN
      DO:         
          /* Get the handle to the buffer for gsc_login_company from the buffer handle list */
          hBuffer = WIDGET-HANDLE(ENTRY(1,cBufferHdlList)).
          /* Get the handle to the login_company_obj field of the gsm_login_company buffer */
          hField  = hBuffer:BUFFER-FIELD(1).       
          /* Determine whether the login company - uniquely key by the login_company_obj field -
            is restricted for a given value of User ID and Login Company */
          lRestricted = getLogicalRestriction
                           (INPUT dcUserObj,
                            INPUT dcCompanyObj,
                            INPUT pcEntityMnemonic,
                            INPUT hField:BUFFER-VALUE()).                            
      END.
  END CASE. /* CASE pcSecurityType */

  /* Create a temp-table record */
  hTTBuff:BUFFER-CREATE().

  /* Iterate through the fields in the temp table */  
  DO iLoop = 1 TO hTTBuff:NUM-FIELDS:

    /* Get the handle to the current field */
    hField = hTTBuff:BUFFER-FIELD(iLoop).

    /* If this is the rowNum field, assign the row counter */
    IF iLoop = 1 THEN
       hField:BUFFER-VALUE = iRow.
    ELSE 
    /* If this is the rowIdent field, assign a comma-separated list of rowids for each buffer in the buffer handle list */
    IF iLoop = 2 THEN 
    DO:
      hField:BUFFER-VALUE = "":U.
      /* for each entry in the buffer handle list */
      DO iLoop2 = 1 TO NUM-ENTRIES(cBufferHdlList):
         /* Get the buffer handle */
         ASSIGN hBuffer = WIDGET-HANDLE(ENTRY(iLoop2, cBufferHdlList)).
         /* Get string of rowid of the buffer */
         IF VALID-HANDLE(hbuffer) THEN
            cRowid = STRING(hBuffer:ROWID).
         ELSE
            cRowid = "?":U.
         /* Add rowid string to list */
         ASSIGN
            hField:BUFFER-VALUE = hField:BUFFER-VALUE +
                                  (IF iLoop2 = 1 THEN "":U ELSE ",":U) +
                                  (IF cRowid = ? THEN "?":U ELSE cRowId).
      END.

      /* If first row, store first row details */
      IF ttQueryParams.iFirstRowNum = 0 AND iRow = 1 THEN
         ASSIGN 
            ttQueryParams.iFirstRowNum = 1
            ttQueryParams.cFirstResultRow = "1;":U + hField:BUFFER-VALUE
            .

      /* Store last result row details as we go */
      ASSIGN
         ttQueryParams.cLastResultRow = STRING(iRow) + ";":U + (IF hField:BUFFER-VALUE = ? THEN "?":U ELSE hField:BUFFER-VALUE)
         .
    END.  /* iloop = 2 */
    ELSE
    /* Set the value of the temp-table field to the value of the database buffer field */
    DO:
       /* If the field name is 'restricted' and the Security Type is correct, 
          then assign buffer value to lRestricion calculated above */
       IF  hField:NAME = 'restricted':U 
       AND (   pcSecurityType = '{&MENU-STRUCTURES}':U 
            OR pcSecurityType = '{&MENU-ITEMS}':U 
            OR pcSecurityType = '{&ACCESS-TOKENS}':U
            OR pcSecurityType = '{&DATA-RANGES}':U
            OR pcSecurityType = '{&DATA-RECORDS}':U 
            OR pcSecurityType = '{&LOGIN-COMPANIES}':U) 
       THEN
           hField:BUFFER-VALUE = lRestricted.
       ELSE
       /* If the field name is 'access_level' and the Security Type is correct (Fields),
          then assign buffer value to cFieldRestriction calculated above */
       IF hField:NAME = 'access_level':U AND pcSecurityType = '{&FIELDS}':U THEN
          hField:BUFFER-VALUE = cFieldRestriction.
       ELSE
       /* If the field name is 'value_from' and the Security Type is correct (Data Ranges),
          then assign buffer value to cRangeValueFrom calculated above */
       IF hField:NAME = 'value_from' AND pcSecurityType = '{&DATA-RANGES}':U THEN
          hField:BUFFER-VALUE = cRangeValueFrom.
       ELSE
       /* If the field name is 'value_to' and the Security Type is correct (Data Ranges),
          then assign buffer value to cRangeValueTo calculated above */
       IF hField:NAME = 'value_to' AND pcSecurityType = '{&DATA-RANGES}':U THEN
          hField:BUFFER-VALUE = cRangeValueTo.
       ELSE
       DO:

          ASSIGN
              /* Otherwise get the handle of the corresponding field in the cFieldHdlList list */
              hFromField = WIDGET-HANDLE(ENTRY(iLoop - 2,cFieldHdlList))
              .
          /* Set the value of the temp-table field to the value of the database buffer field */
          RUN assignFieldValue
              (INPUT cFieldHdlList, 
               INPUT hFromField, 
               INPUT hField).

       END.
    END. /* ELSE */

  END. /* DO iLoop = 1 TO hTTBuff:NUM-FIELDS: */

  /* Release the temp-table record */
  hTTBuff:BUFFER-RELEASE().
  /* Get the next result in the query */
  hQuery:GET-NEXT().

END. /* REPEAT */

/* See if reached last record and set last rowNum if we have */
IF hQuery:QUERY-OFF-END THEN
   ASSIGN
      ttQueryParams.iLastRowNum = iRow. 
ELSE
/* More to records come, set last rowNUM to 0 */ 
   ASSIGN
      ttQueryParams.iLastRowNum = 0.   

/* Cleanup */
DELETE OBJECT hQuery NO-ERROR.
ASSIGN hQuery = ?.

/* For each entry in the buffer handle list */
buffer-loop2:
DO iLoop = 1 TO NUM-ENTRIES(cBufferHdlList):
    hBuffer = WIDGET-HANDLE(ENTRY(iLoop,cBufferHdlList)).
    DELETE OBJECT hBuffer NO-ERROR.
    ASSIGN hBuffer = ?.
END. /* buffer-loop2 */

/* Assign the output parameter temp table handle */
ASSIGN
    ohttResultsSet = hTT
    .

/* Delete temp-table object */
DELETE OBJECT hTT.
hTT = ?.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRangeRestriction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRangeRestriction Procedure 
PROCEDURE getRangeRestriction PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Returns a data range security restriction for a given combination
               of user obj, company obj, entity mnemonic string, and security
               structure obj (owning obj).              
  Parameters:  input decimal for the user obj
               input decimal for the company obj
               input string for the entity mnemonic
               input decimal for the security structure (owning) obj
  Notes:       Uses strong buffer scoping               
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pdUserObj          AS DECIMAL      NO-UNDO.
  DEFINE INPUT  PARAMETER pdOrganisationObj  AS DECIMAL      NO-UNDO.
  DEFINE INPUT  PARAMETER pcEntityMnemonic   AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER pdOwningObj        AS DECIMAL      NO-UNDO.

  DEFINE OUTPUT PARAMETER plRangeRestriction AS LOGICAL      NO-UNDO.
  DEFINE OUTPUT PARAMETER pcRangeValueFrom   AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcRangeValueTo     AS CHARACTER    NO-UNDO.

  DEFINE BUFFER b_gsm_user_allocation      FOR gsm_user_allocation.

  /* Initialise range restriction */
  plRangeRestriction = NO.
  user-allocation-block:
  DO FOR b_gsm_user_allocation:
      /* Attempt match for all input parameter values - pdUserObj, pdOrganisationObj, pcEntityMenmonic, pdOwningObj 
         ie. security restriction applied to a user within a login company */
      FIND FIRST b_gsm_user_allocation NO-LOCK
           WHERE b_gsm_user_allocation.user_obj               = pdUserObj
             AND b_gsm_user_allocation.login_organisation_obj = pdOrganisationObj
             AND b_gsm_user_allocation.owning_entity_mnemonic = pcEntityMnemonic
             AND b_gsm_user_allocation.owning_obj             = pdOwningObj
           NO-ERROR.
      IF NOT AVAILABLE b_gsm_user_allocation THEN
         /* Attempt match for where organisation obj is 0 ie. security restriciton applied to a user for all login companies */ 
         FIND FIRST b_gsm_user_allocation NO-LOCK
              WHERE b_gsm_user_allocation.USER_obj               = pdUserObj
                AND b_gsm_user_allocation.login_organisation_obj = 0
                AND b_gsm_user_allocation.owning_entity_mnemonic = pcEntityMnemonic
                AND b_gsm_user_allocation.owning_obj             = pdOwningObj
              NO-ERROR.
      IF NOT AVAILABLE b_gsm_user_allocation THEN
         /* Attempt match for where user obj is 0 ie. security restriciton applied to all users within a login company */ 
         FIND FIRST b_gsm_user_allocation NO-LOCK
              WHERE gsm_user_allocation.USER_obj               = 0
                AND gsm_user_allocation.login_organisation_obj = pdOrganisationObj
                AND gsm_user_allocation.owning_entity_mnemonic = pcEntityMnemonic
                AND gsm_user_allocation.owning_obj             = pdOwningObj
              NO-ERROR.
      IF NOT AVAILABLE b_gsm_user_allocation THEN
         /* Attempt match for where organisation obj is 0 and user Obj is 0
            ie. security restriciton applied to a user for all login companies */ 
         FIND FIRST b_gsm_user_allocation NO-LOCK
              WHERE b_gsm_user_allocation.USER_obj               = 0
                AND b_gsm_user_allocation.login_organisation_obj = 0
                AND b_gsm_user_allocation.owning_entity_mnemonic = pcEntityMnemonic
                AND b_gsm_user_allocation.owning_obj             = pdUserObj
              NO-ERROR.
      IF NOT AVAILABLE b_gsm_user_allocation THEN
          /* No security restriction */
          ASSIGN
             plRangeRestriction = NO
             .
      ELSE
          /* Security restriction - return data range values */
          ASSIGN
             plRangeRestriction = YES
             pcRangeValueFrom   = b_gsm_user_allocation.USER_allocation_value1
             pcRangeValueTo     = b_gsm_user_allocation.USER_allocation_value2
             .
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUserFullName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getUserFullName Procedure 
PROCEDURE getUserFullName :
/*------------------------------------------------------------------------------
  Purpose:     To validate a User ID and return User Full Name
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pcUserID                     AS CHARACTER    NO-UNDO.
    DEFINE OUTPUT PARAMETER ocUserFullName               AS CHARACTER    NO-UNDO.
    DEFINE OUTPUT PARAMETER ocErrorText                  AS CHARACTER    NO-UNDO.

    /* Find user record with key of User ID */
    FIND FIRST gsm_user NO-LOCK
         WHERE gsm_user.user_login_name EQ pcUserID
         NO-ERROR.
    IF NOT AVAILABLE gsm_user THEN
    DO:
       /* Return an error message */
       ocErrorText   = ocErrorText 
                     + (IF NUM-ENTRIES(ocErrorText,CHR(3)) > 0 THEN CHR(3) ELSE '':U)                   
                     + {af/sup2/aferrortxt.i 'AF' '11' '?' '?' '"user login name"' pcUserID}.
    END.
    ELSE
       /* Return User Full Name */
       ocUserFullName = gsm_user.user_full_name.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

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

ASSIGN cDescription = "Security Allocations PLIP".

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

&IF DEFINED(EXCLUDE-setDataRecordsQueryParams) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDataRecordsQueryParams Procedure 
PROCEDURE setDataRecordsQueryParams PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Sets query parameters in the ttQueryParams record
               when security type is Data Records
  Parameters:  output string for error messages
  Notes:       Attempts to use information stored in the relevant record in
               gsm_entity_mnemonic db table 
               Requires some metaschema information which is provided by
               creating a buffer object for the db table described by the
               gsm_entity_mnemonic.entity_mnemonic_description
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pcEntityMnemonic    AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER ocError             AS CHARACTER  NO-UNDO.

    DEFINE VARIABLE hBuffer                     AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hField                      AS HANDLE     NO-UNDO.
    DEFINE VARIABLE iLoop                       AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cBrowseFields               AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cFormat                     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cLabel                      AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE iNumber                     AS INTEGER    NO-UNDO.

    /* Get query parameters record*/
    FIND FIRST ttQueryParams NO-ERROR.
    IF NOT AVAILABLE ttQueryParams THEN 
    DO:
        ocError = ocError 
                + (IF NUM-ENTRIES(ocError,CHR(3)) > 0 THEN CHR(3) ELSE '':U) 
                  + {af/sup2/aferrortxt.i 'AF' '29' 'ttQueryParams' '?' '"query parameter temp table record'"}. 
        RETURN.
    END.

    /* Get Entity Mnemonic record using the mnemonic stored in ttQueryParams.cQueryTables */
    FIND FIRST gsc_entity_mnemonic NO-LOCK
         WHERE gsc_entity_mnemonic.entity_mnemonic = pcEntityMnemonic
         NO-ERROR.
    IF NOT AVAILABLE gsc_entity_mnemonic THEN
    DO:
        ocError = ocError 
                + (IF NUM-ENTRIES(ocError,CHR(3)) > 0 THEN CHR(3) ELSE '':U)                   
                + {af/sup2/aferrortxt.i 'AF' '11' 'gsm_entity_mnemonic' 'entity_mnemonic' '"Entity Mnemonic"' pcEntityMnemonic}.
        RETURN.
    END.

    /* Set key field in query parameters from Entity Mnemonic record is not blank */
    IF gsc_entity_mnemonic.entity_key_field NE "":U THEN
        ASSIGN
            ttQueryParams.cKeyField                   = gsc_entity_mnemonic.entity_key_field
            .

    /* Create a buffer object for the table described by the Entity Mnemonic record
       - used for extracting metaschema information for the table */
    CREATE BUFFER hBuffer FOR TABLE gsc_entity_mnemonic.entity_mnemonic_description NO-ERROR.
    IF ERROR-STATUS:ERROR THEN
    DO:
        ocError = ocError 
                + (IF NUM-ENTRIES(ocError,CHR(3)) > 0 THEN CHR(3) ELSE '':U)                   
                + {af/sup2/aferrortxt.i 'AF' '11' 'gsm_entity_mnemonic' 'entity_mnemonic' '"Entity Mnemonic"' pcEntityMnemonic}.
        ERROR-STATUS:ERROR = NO.
        RETURN.
    END.

    /* If display fields exist for the table's entity mnemonic record,
       then build lists of fields and respective labels, formats, data types for query parameters */
    IF CAN-FIND(FIRST gsc_entity_display_field
                WHERE gsc_entity_display_field.entity_mnemonic = gsc_entity_mnemonic.entity_mnemonic) THEN
    DO:
      FOR EACH gsc_entity_display_field NO-LOCK
         WHERE gsc_entity_display_field.entity_mnemonic = gsc_entity_mnemonic.entity_mnemonic
            BY gsc_entity_display_field.DISPLAY_field_order
            BY gsc_entity_display_field.DISPLAY_field_name:
        ASSIGN
          hField = hBuffer:BUFFER-FIELD(gsc_entity_display_field.DISPLAY_field_name)
          cLabel = (IF gsc_entity_display_field.DISPLAY_field_column_label <> "":U THEN
                     gsc_entity_display_field.DISPLAY_field_column_label ELSE IF
                      gsc_entity_display_field.DISPLAY_field_label <> "":U THEN
                     gsc_entity_display_field.DISPLAY_field_label  ELSE IF
                      LENGTH(hField:COLUMN-LABEL) > 0 THEN
                     hField:COLUMN-LABEL ELSE hField:LABEL)   
          cBrowseFields                          = cBrowseFields
                                                + (IF cBrowseFields    EQ "":U THEN "":U ELSE ",":U)
                                                + gsc_entity_mnemonic.entity_mnemonic_description
                                                + ".":U
                                                + gsc_entity_display_field.DISPLAY_field_name
          ttQueryParams.cBrowseFieldDataTypes    = ttQueryParams.cBrowseFieldDataTypes
                                                + (IF ttQueryParams.cBrowseFieldDataTypes    EQ "":U THEN "":U ELSE ",":U)
                                                + hField:DATA-TYPE
          ttQueryParams.cBrowseFieldValuesIfNull = ttQueryParams.cBrowseFieldValuesIfNull
                                                + (IF ttQueryParams.cBrowseFieldValuesIfNull EQ "":U THEN "":U ELSE CHR(3))
                                                + hField:INITIAL
          ttQueryParams.cBrowseFieldLabels       = ttQueryParams.cBrowseFieldLabels
                                                + (IF ttQueryParams.cBrowseFieldLabels EQ "":U THEN "":U ELSE CHR(3))
                                                + cLabel
           .
      
        IF hField:DATA-TYPE NE "CHARACTER":U THEN
           ttQueryParams.cBrowseFieldFormats      = ttQueryParams.cBrowseFieldFormats
                                                  + (IF ttQueryParams.cBrowseFieldFormats EQ "":U THEN "":U ELSE CHR(3))
                                                  + (IF gsc_entity_display_field.DISPLAY_field_format <> "":U THEN
                                                        gsc_entity_display_field.DISPLAY_field_format ELSE
                                                        hField:FORMAT).
        ELSE
        DO:
          cFormat = (IF gsc_entity_display_field.DISPLAY_field_format <> "":U THEN
                        gsc_entity_display_field.DISPLAY_field_format ELSE
                        hField:FORMAT).
          ASSIGN
            iNumber = INTEGER(SUBSTRING(cFormat,
                               INDEX(cFormat,"(":U) + 1,
                               INDEX(cFormat,")":U) - INDEX( cFormat,"(":U) - 1))
                      NO-ERROR.
          IF iNumber > 70 THEN
            SUBSTRING(cFormat,
                      INDEX(cFormat,"(":U) + 1,
                      INDEX(cFormat,")":U) - INDEX(cFormat,"(":U) - 1
                      )
                      = "70":U.
          ttQueryParams.cBrowseFieldFormats       = ttQueryParams.cBrowseFieldFormats
                                                  + (IF ttQueryParams.cBrowseFieldFormats EQ "":U THEN "":U ELSE CHR(3))
                                                  +  cFormat.
        END.
      END.
      
      ASSIGN
        ttQueryParams.cBrowseFields             = cBrowseFields
        .
    END. /* display fields exist */
    ELSE
    /* If no display fields setup, then iterate through the fields in the created buffer object,
       then build lists of fields and respective labels, formats, data types for query parameters */      
    DO iLoop = 1 TO hBuffer:NUM-FIELDS:
        ASSIGN 
          hField = hBuffer:BUFFER-FIELD(iLoop)
          cLabel = IF LENGTH(hField:COLUMN-LABEL) > 0 THEN
                      hField:COLUMN-LABEL ELSE hField:LABEL   
          .
        /* Ignore any field that ends in "_obj" */
        IF hField:NAME MATCHES "*_OBJ":U THEN NEXT.
        ASSIGN
            ttQueryParams.cBrowseFields               = ttQueryParams.cBrowseFields
                                                      + (IF ttQueryParams.cBrowseFields            EQ "":U THEN "":U ELSE ",":U)
                                                      + hField:BUFFER-NAME + ".":U + hField:NAME
            ttQueryParams.cBrowseFieldLabels          = ttQueryParams.cBrowseFieldLabels
                                                      + (IF ttQueryParams.cBrowseFieldLabels       EQ "":U THEN "":U ELSE CHR(3))
                                                      + cLabel
            ttQueryParams.cBrowseFieldDataTypes       = ttQueryParams.cBrowseFieldDataTypes
                                                      + (IF ttQueryParams.cBrowseFieldDataTypes    EQ "":U THEN "":U ELSE ",":U)
                                                      + hField:DATA-TYPE
            ttQueryParams.cBrowseFieldValuesIfNull    = ttQueryParams.cBrowseFieldValuesIfNull
                                                      + (IF ttQueryParams.cBrowseFieldValuesIfNull EQ "":U THEN "":U ELSE CHR(3))
                                                      + hField:INITIAL
            .

        IF hField:DATA-TYPE NE "CHARACTER":U THEN
           ttQueryParams.cBrowseFieldFormats      = ttQueryParams.cBrowseFieldFormats
                                                  + (IF ttQueryParams.cBrowseFieldFormats EQ "":U THEN "":U ELSE CHR(3))
                                                  + hField:FORMAT.
        ELSE
        DO:
          cFormat = hField:FORMAT.
          ASSIGN
            iNumber = INTEGER(SUBSTRING(cFormat,
                               INDEX(cFormat,"(":U) + 1,
                               INDEX(cFormat,")":U) - INDEX( cFormat,"(":U) - 1))
                      NO-ERROR.
          IF iNumber > 70 THEN
            SUBSTRING(cFormat,
                      INDEX(cFormat,"(":U) + 1,
                      INDEX(cFormat,")":U) - INDEX(cFormat,"(":U) - 1
                      )
                      = "70":U.
          ttQueryParams.cBrowseFieldFormats       = ttQueryParams.cBrowseFieldFormats
                                                  + (IF ttQueryParams.cBrowseFieldFormats EQ "":U THEN "":U ELSE CHR(3))
                                                  +  cFormat.
        END.
    END.

    /* Re-assign cQueryTables to the table name stored on the entity mnemonic record, then set query string */
    ASSIGN
        ttQueryParams.cQueryTables     = gsc_entity_mnemonic.entity_mnemonic_description
        ttQueryParams.cBaseQueryString = "FOR EACH ":U + ttQueryParams.cQueryTables + " NO-LOCK":U
        .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldRestriction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setFieldRestriction Procedure 
PROCEDURE setFieldRestriction :
/*------------------------------------------------------------------------------
  Purpose:     Sets a field security restriction for a given
               user, login company, and data range.
  Parameters:  input decimal for a given user obj
               input decimal for a given login company obj
               input handle to a buffer object referring to the current record
                  in the temp table containing the security restrictions
               input string for the entity mnemonic
               output string for error messages
  Notes:       Uses a transaction block with string record scope
------------------------------------------------------------------------------*/

  DEFINE INPUT   PARAMETER pdUserObj           AS DECIMAL      NO-UNDO.
  DEFINE INPUT   PARAMETER pdOrganisationObj   AS DECIMAL      NO-UNDO.
  DEFINE INPUT   PARAMETER phTTBuffer          AS HANDLE       NO-UNDO.
  DEFINE INPUT   PARAMETER pcEntityMnemonic    AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT  PARAMETER ocErrorText         AS CHARACTER    NO-UNDO.

  DEFINE BUFFER b_gsm_user_allocation          FOR gsm_user_allocation.

  DEFINE VARIABLE hField                       AS HANDLE       NO-UNDO.
  DEFINE VARIABLE dOwningObj                   AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE cAccessLevel                 AS CHARACTER    NO-UNDO.

  /* Get the owning obj of the security structure referring to the field */
  dOwningObj = getOwningObj(phTTBuffer, pcEntityMnemonic).

  /* Get access level to the field */
  hField = phTTBuffer:BUFFER-FIELD('access_level':U).                    
  cAccessLevel = hField:BUFFER-VALUE().

  trans-block:
  DO FOR b_gsm_user_allocation TRANSACTION ON ERROR UNDO trans-block, LEAVE trans-block:
      /* Attempt to find and exclusively lock existing security allocation for the given user, 
         login company, entity mnemonic, and security structure (owning obj) */
      FIND b_gsm_user_allocation EXCLUSIVE-LOCK
          WHERE b_gsm_user_allocation.USER_obj               = pdUserObj
            AND b_gsm_user_allocation.login_organisation_obj = pdOrganisationObj
            AND b_gsm_user_allocation.owning_entity_mnemonic = pcEntityMnemonic
            AND b_gsm_user_allocation.owning_obj             = dOwningObj
          NO-ERROR.
      IF cAccessLevel NE "Full Access":U THEN
      DO:
          /* If applying a security restriction and a security allocation not yet exists */
          IF NOT AVAILABLE b_gsm_user_allocation THEN
          DO:
              /* Create a security allocation record and assign the key fields */
              CREATE b_gsm_user_allocation NO-ERROR.
              ASSIGN
                  b_gsm_user_allocation.USER_obj               = pdUserObj
                  b_gsm_user_allocation.login_organisation_obj = pdOrganisationObj
                  b_gsm_user_allocation.owning_entity_mnemonic = pcEntityMnemonic
                  b_gsm_user_allocation.owning_obj             = dOwningObj
                  .
          END.
          /* Whether new or existing security allocation, store the new access level value */
          ASSIGN
              b_gsm_user_allocation.USER_allocation_value1 = cAccessLevel.
          /* Commit changes to the databases, fire triggers, and return any errors */
          VALIDATE b_gsm_user_allocation NO-ERROR.
          {af/sup2/afcheckerr.i &no-return = YES}    
          ocErrorText = cMessageList.
          IF ocErrorText <> "":U THEN UNDO trans-block, LEAVE trans-block.
      END.
      ELSE
      /* If removing a security restriction and a security allocation record exists, then delete it */
      IF cAccessLevel EQ "Full Access":U AND AVAILABLE b_gsm_user_allocation THEN
          DELETE b_gsm_user_allocation NO-ERROR.
  END. /* trans-block */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLogicalRestriction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setLogicalRestriction Procedure 
PROCEDURE setLogicalRestriction :
/*------------------------------------------------------------------------------
  Purpose:     Sets a security restriction for a given
               user, login company, and data range.
  Parameters:  input decimal for a given user obj
               input decimal for a given login company obj
               input handle to a buffer object referring to the current record
                  in the temp table containing the security restrictions
               input string for the entity mnemonic
               output string for error messages
  Notes:       Uses a transaction block with string record scope
------------------------------------------------------------------------------*/

  DEFINE INPUT   PARAMETER pdUserObj           AS DECIMAL      NO-UNDO.
  DEFINE INPUT   PARAMETER pdOrganisationObj   AS DECIMAL      NO-UNDO.
  DEFINE INPUT   PARAMETER phTTBuffer          AS HANDLE       NO-UNDO.
  DEFINE INPUT   PARAMETER pcEntityMnemonic    AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT  PARAMETER ocErrorText         AS CHARACTER    NO-UNDO.

  DEFINE BUFFER b_gsm_user_allocation          FOR gsm_user_allocation.

  DEFINE VARIABLE hField                       AS HANDLE       NO-UNDO.
  DEFINE VARIABLE dOwningObj                   AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE lRestricted                  AS LOGICAL      NO-UNDO.

  /* Get the owning obj of the entity to which the security restriction is being applied */
  dOwningObj = getOwningObj(phTTBuffer, pcEntityMnemonic).  

  /* Get restriciton flag */
  hField = phTTBuffer:BUFFER-FIELD('restricted':U).                    
  lRestricted = hField:BUFFER-VALUE().

  trans-block:
  DO FOR b_gsm_user_allocation TRANSACTION ON ERROR UNDO trans-block, LEAVE trans-block:
      /* Attempt to find and exclusively lock existing security allocation for the given user, 
         login company, entity mnemonic, and security structure (owning obj) */
      FIND b_gsm_user_allocation EXCLUSIVE-LOCK
          WHERE b_gsm_user_allocation.USER_obj               = pdUserObj
            AND b_gsm_user_allocation.login_organisation_obj = pdOrganisationObj
            AND b_gsm_user_allocation.owning_entity_mnemonic = pcEntityMnemonic
            AND b_gsm_user_allocation.owning_obj             = dOwningObj
          NO-ERROR.
      IF lRestricted AND NOT AVAILABLE b_gsm_user_allocation THEN
      DO:
          /* If applying a security restriction and a security allocation not yet exists
             then create a security allocation record and assign the key fields */
          CREATE b_gsm_user_allocation NO-ERROR.
          ASSIGN
              b_gsm_user_allocation.USER_obj               = pdUserObj
              b_gsm_user_allocation.login_organisation_obj = pdOrganisationObj
              b_gsm_user_allocation.owning_entity_mnemonic = pcEntityMnemonic
              b_gsm_user_allocation.owning_obj             = dOwningObj
              b_gsm_user_allocation.USER_allocation_value1 = "NO":U
              .
          /* Commit changes to the databases, fire triggers, and return any errors */
          VALIDATE b_gsm_user_allocation NO-ERROR.
          {af/sup2/afcheckerr.i &no-return = YES}    
          ocErrorText = cMessageList.
          IF ocErrorText <> "":U THEN UNDO trans-block, LEAVE trans-block.
      END.
      ELSE
      /* If removing a security restriction and a security allocation record exists, then delete it */
      IF NOT lRestricted AND AVAILABLE b_gsm_user_allocation THEN
          DELETE b_gsm_user_allocation NO-ERROR.
  END. /* trans-block */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRangeRestriction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setRangeRestriction Procedure 
PROCEDURE setRangeRestriction :
/*------------------------------------------------------------------------------
  Purpose:     Sets a data range security restriction for a given
               user, login company, and data range.
  Parameters:  input decimal for a given user obj
               input decimal for a given login company obj
               input handle to a buffer object referring to the current record
                  in the temp table containing the security restrictions
               input string for the entity mnemonic
               output string for error messages
  Notes:       Uses a transaction block with string record scope
------------------------------------------------------------------------------*/

  DEFINE INPUT   PARAMETER pdUserObj           AS DECIMAL      NO-UNDO.
  DEFINE INPUT   PARAMETER pdOrganisationObj   AS DECIMAL      NO-UNDO.
  DEFINE INPUT   PARAMETER phTTBuffer          AS HANDLE       NO-UNDO.
  DEFINE INPUT   PARAMETER pcEntityMnemonic    AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT  PARAMETER ocErrorText         AS CHARACTER    NO-UNDO.

  DEFINE BUFFER b_gsm_user_allocation          FOR gsm_user_allocation.

  DEFINE VARIABLE hField                       AS HANDLE       NO-UNDO.
  DEFINE VARIABLE dOwningObj                   AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE lRestricted                  AS LOGICAL      NO-UNDO.
  DEFINE VARIABLE cValueFrom                   AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cValueTo                     AS CHARACTER    NO-UNDO.


  /* Get the owning obj of the security structure referring to the data range */
  dOwningObj = getOwningObj(phTTBuffer, pcEntityMnemonic).

  /* Get restricted (logical) value */
  hField      = phTTBuffer:BUFFER-FIELD('restricted':U).                    
  lRestricted = hField:BUFFER-VALUE().
  /* Get lower bound of range */
  hField      = phTTBuffer:BUFFER-FIELD('value_from':U).                    
  cValueFrom  = hField:BUFFER-VALUE().
  /* Get upper bound of range */
  hField      = phTTBuffer:BUFFER-FIELD('value_to':U).                    
  cValueTo    = hField:BUFFER-VALUE().

  trans-block:
  DO FOR b_gsm_user_allocation TRANSACTION ON ERROR UNDO trans-block, LEAVE trans-block:
      /* Attempt to find and exclusively lock existing security allocation for the given user, 
         login company, entity mnemonic, and security structure (owning obj) */
      FIND b_gsm_user_allocation EXCLUSIVE-LOCK
          WHERE b_gsm_user_allocation.USER_obj               = pdUserObj
            AND b_gsm_user_allocation.login_organisation_obj = pdOrganisationObj
            AND b_gsm_user_allocation.owning_entity_mnemonic = pcEntityMnemonic
            AND b_gsm_user_allocation.owning_obj             = dOwningObj
          NO-ERROR.
      IF lRestricted THEN
      DO:
          /* If applying a security restriction and a security allocation not yet exists */
          IF NOT AVAILABLE b_gsm_user_allocation THEN
          DO:
              /* Create a security allocation record and assign the key fields */
              CREATE b_gsm_user_allocation NO-ERROR.
              ASSIGN
                  b_gsm_user_allocation.USER_obj               = pdUserObj
                  b_gsm_user_allocation.login_organisation_obj = pdOrganisationObj
                  b_gsm_user_allocation.owning_entity_mnemonic = pcEntityMnemonic
                  b_gsm_user_allocation.owning_obj             = dOwningObj
                  .
          END.
          /* Whether new or existing security allocation, store the new range values */
          ASSIGN
              b_gsm_user_allocation.USER_allocation_value1 = cValueFrom
              b_gsm_user_allocation.USER_allocation_value2 = cValueTo
              .
          /* Commit changes to the databases, fire triggers, and return any errors */
          VALIDATE b_gsm_user_allocation NO-ERROR.
          {af/sup2/afcheckerr.i &no-return = YES}    
          ocErrorText = cMessageList.
          IF ocErrorText <> "":U THEN UNDO trans-block, LEAVE trans-block.
      END.
      ELSE
      /* If removing a security restriction and a security allocation record exists, then delete it */
      IF NOT lRestricted AND AVAILABLE b_gsm_user_allocation THEN
          DELETE b_gsm_user_allocation NO-ERROR.
  END. /* trans-block */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-createTT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createTT Procedure 
FUNCTION createTT RETURNS HANDLE PRIVATE
  ( INPUT pcSecurityType AS CHARACTER,
    INPUT pcFieldHdlList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Creates a dynamic temp table and returns a handle to it
    Notes:  The structure of the dynamic temp table includes a rowNum and a rowIdent field
            fields from the field handle list parameter, and hard-coded fields
            dictated by security type
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hTT       AS HANDLE       NO-UNDO.
  DEFINE VARIABLE iLoop     AS INTEGER      NO-UNDO.
  DEFINE VARIABLE hField    AS HANDLE       NO-UNDO.

  /* Create the dynamic temp-table */
  CREATE TEMP-TABLE hTT.

  /* Add fields - static ones first */
  hTT:ADD-NEW-FIELD("RowNum":U,"INTEGER":U).      /* Row number for sequencing */
  hTT:ADD-NEW-FIELD("RowIdent":U,"CHARACTER":U).  /* string of Rowid of correspding record, comma delimited for multiple tables */


  /* Add selected fields */
  DO iLoop = 1 TO NUM-ENTRIES(pcFieldHdlList):
     hField = WIDGET-HANDLE(ENTRY(iLoop,pcFieldHdlList)).
     hTT:ADD-LIKE-FIELD(hField:NAME,hField).
  END.

  /* For a given Security Type parameter value, add field(s) to the temp table */
  /* to store security specific information */
  CASE pcSecurityType:
    WHEN '{&MENU-STRUCTURES}':U THEN
    DO:
        hTT:ADD-NEW-FIELD("restricted":U,"LOGICAL":U,0,"YES/NO","NO","Restricted?","Restricted?").
    END.
    WHEN '{&MENU-ITEMS}':U THEN
    DO:
        hTT:ADD-NEW-FIELD("restricted":U,"LOGICAL":U,0,"YES/NO","NO","Restricted?","Restricted?").
    END.
    WHEN '{&ACCESS-TOKENS}':U THEN
    DO:
        hTT:ADD-NEW-FIELD("restricted":U,"LOGICAL":U,0,"YES/NO","NO","Restricted?","Restricted?").
    END.
    WHEN '{&FIELDS}':U THEN
    DO:
        hTT:ADD-NEW-FIELD("access_level":U,"CHARACTER":U,0,"x(15)","","Access Level","Access Level").
    END.
    WHEN '{&DATA-RANGES}':U THEN
    DO:
        hTT:ADD-NEW-FIELD("restricted":U,"LOGICAL":U,0,"YES/NO","NO","Restricted?","Restricted?").
        hTT:ADD-NEW-FIELD("value_from":U,"CHARACTER":U,0,"x(10)","","Value From","Value From").
        hTT:ADD-NEW-FIELD("value_to":U,"CHARACTER":U,0,"x(10)","","Value To","Value To").
    END.
    WHEN '{&DATA-RECORDS}':U THEN
    DO:        
        hTT:ADD-NEW-FIELD("restricted":U,"LOGICAL":U,0,"YES/NO","NO","Restricted?","Restricted?").        
    END.
    WHEN '{&LOGIN-COMPANIES}':U THEN
    DO:
        hTT:ADD-NEW-FIELD("restricted":U,"LOGICAL":U,0,"YES/NO","NO","Restricted?","Restricted?").        
    END.        
  END CASE.

  /* Add indexes to the temp-table */
  hTT:ADD-NEW-INDEX("idxRowNum":U,FALSE,FALSE).
  hTT:ADD-INDEX-FIELD("idxRowNum":U,"RowNum":U,"asc":U).
  hTT:ADD-NEW-INDEX("idxRowIdent":U,FALSE,FALSE).
  hTT:ADD-INDEX-FIELD("idxRowIdent":U,"RowIdent":U,"asc":U).

  /* Prepare the temp-table with the name the user chose */
  hTT:TEMP-TABLE-PREPARE("RowObject":U).

  RETURN hTT.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBufferHandleList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBufferHandleList Procedure 
FUNCTION getBufferHandleList RETURNS CHARACTER
  ( INPUT-OUTPUT phQuery      AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a comma-separated list of buffer handles used in the dynamic query
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hBuffer         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLoop           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cBufferHdlList  AS CHARACTER  NO-UNDO.

  FIND FIRST ttQueryParams NO-ERROR.
  IF NOT AVAILABLE ttQueryParams THEN
      RETURN "":U.

  /* for each entry in ttQueryParams.cQueryTables */
  buffer-loop:
  DO iLoop = 1 TO NUM-ENTRIES(ttQueryParams.cQueryTables):
      CREATE BUFFER hBuffer FOR TABLE ENTRY(iLoop,ttQueryParams.cQueryTables) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN NEXT buffer-loop.
      cBufferHdlList = cBufferHdlList + (IF cBufferHdlList <> "":U THEN ",":U ELSE "":U) + STRING(hBuffer).
      phQuery:ADD-BUFFER(hBuffer) NO-ERROR.
  END. /* buffer-loop */

  RETURN cBufferHdlList.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCompanyObj) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCompanyObj Procedure 
FUNCTION getCompanyObj RETURNS DECIMAL PRIVATE
  ( INPUT pcLoginCompany    AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the _obj value for a given Login Company record  
    Notes:  Returns 0.00 if given a blank login company value
            Returns -1.00 if the login company is not found
------------------------------------------------------------------------------*/

  IF pcLoginCompany NE "":U THEN
  DO:
    FIND FIRST gsm_login_company NO-LOCK
         WHERE gsm_login_company.login_company_code = pcLoginCompany
         NO-ERROR.
    IF NOT AVAILABLE gsm_login_company THEN
       RETURN -1.00.       
  END.
  ELSE
      RETURN 0.00.

  RETURN gsm_login_company.login_company_obj.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldHandleList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldHandleList Procedure 
FUNCTION getFieldHandleList RETURNS CHARACTER
   (INPUT pcBufferHdlList        AS CHARACTER):
/*------------------------------------------------------------------------------
  Purpose:  Returns a comma-separated list of field handles used in the dynamic query
    Notes:  Assumes all fields are in table.field format
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hBuffer         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLoop           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cFieldHdlList   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBuffer         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cField          AS CHARACTER  NO-UNDO.

  FIND FIRST ttQueryParams NO-ERROR.
  IF NOT AVAILABLE ttQueryParams THEN
      RETURN "":U.

  /* for each entry in ttQueryParams.cBrowseFields */
  DO iLoop = 1 TO NUM-ENTRIES(ttQueryParams.cBrowseFields):
      cBuffer = ENTRY(iLoop,ttQueryParams.cBrowseFields).
      cField  = ENTRY(2,cBuffer,".":U).
      cBuffer = ENTRY(1,cBuffer,".":U).
      hBuffer = WIDGET-HANDLE(ENTRY(LOOKUP(cBuffer,ttQueryParams.cQueryTables),pcBufferHdlList)).
      hField  = hBuffer:BUFFER-FIELD(cField).
      hField:LABEL  = ENTRY(iLoop,ttQueryParams.cBrowseFieldLabels,CHR(3)).
      hField:FORMAT = ENTRY(iLoop,ttQueryParams.cBrowseFieldFormats,CHR(3)).
      cFieldHdlList = cFieldHdlList + (IF cFieldHdlList <> "":U THEN ",":U ELSE "":U) + STRING(hField).
  END. /* iLoop */

  RETURN cFieldHdlList.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldRestriction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldRestriction Procedure 
FUNCTION getFieldRestriction RETURNS CHARACTER PRIVATE
  ( INPUT pdUserObj             AS DECIMAL,
    INPUT pdOrganisationObj     AS DECIMAL,
    INPUT pcEntityMnemonic      AS CHARACTER,
    INPUT pdOwningObj           AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns a field security restriction for a given combination
               of user obj, company obj, entity mnemonic string, and security
               structure obj (owning obj).              
  Notes:       
------------------------------------------------------------------------------*/

  /* Attempt match for all input parameter values - pdUserObj, pdOrganisationObj, pcEntityMenmonic, pdOwningObj 
     ie. security restriction applied to a user within a login company */
  FIND FIRST gsm_user_allocation NO-LOCK
       WHERE gsm_user_allocation.user_obj               = pdUserObj
         AND gsm_user_allocation.login_organisation_obj = pdOrganisationObj
         AND gsm_user_allocation.owning_entity_mnemonic = pcEntityMnemonic
         AND gsm_user_allocation.owning_obj             = pdOwningObj
       NO-ERROR.
  IF NOT AVAILABLE gsm_user_allocation THEN
     /* Attempt match for where organisation obj is 0 ie. security restriciton applied to a user for all login companies */ 
     FIND FIRST gsm_user_allocation NO-LOCK
          WHERE gsm_user_allocation.USER_obj               = pdUserObj
            AND gsm_user_allocation.login_organisation_obj = 0
            AND gsm_user_allocation.owning_entity_mnemonic = pcEntityMnemonic
            AND gsm_user_allocation.owning_obj             = pdOwningObj
          NO-ERROR.
  IF NOT AVAILABLE gsm_user_allocation THEN
     /* Attempt match for where user obj is 0 ie. security restriciton applied to all users within a login company */ 
     FIND FIRST gsm_user_allocation NO-LOCK
          WHERE gsm_user_allocation.USER_obj               = 0
            AND gsm_user_allocation.login_organisation_obj = pdOrganisationObj
            AND gsm_user_allocation.owning_entity_mnemonic = pcEntityMnemonic
            AND gsm_user_allocation.owning_obj             = pdOwningObj
          NO-ERROR.
  IF NOT AVAILABLE gsm_user_allocation THEN
     /* Attempt match for where organisation obj is 0 and user Obj is 0
        ie. security restriciton applied to a user for all login companies */ 
     FIND FIRST gsm_user_allocation NO-LOCK
          WHERE gsm_user_allocation.USER_obj               = 0
            AND gsm_user_allocation.login_organisation_obj = 0
            AND gsm_user_allocation.owning_entity_mnemonic = pcEntityMnemonic
            AND gsm_user_allocation.owning_obj             = pdOwningObj
          NO-ERROR.

  /* If no security allocation record, return full access, else return access level value */
  RETURN (IF AVAILABLE gsm_user_allocation THEN gsm_user_allocation.USER_allocation_value1 ELSE "Full Access").   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLogicalRestriction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLogicalRestriction Procedure 
FUNCTION getLogicalRestriction RETURNS LOGICAL PRIVATE
  ( INPUT pdUserObj            AS DECIMAL,
    INPUT pdOrganisationObj    AS DECIMAL,
    INPUT pcEntityMnemonic     AS CHARACTER,
    INPUT pdOwningObj          AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns a security restriction for a given combination
               of user obj, company obj, entity mnemonic string, and security
               structure obj (owning obj).              
  Notes:       Returns a logical indicating a security restriction exists or not
------------------------------------------------------------------------------*/

  RETURN 
     /* Attempt match for all input parameter values - pdUserObj, pdOrganisationObj, pcEntityMenmonic, pdOwningObj 
        ie. security restriction applied to a user within a login company */
     (CAN-FIND(FIRST gsm_user_allocation
               WHERE gsm_user_allocation.user_obj               = pdUserObj
                 AND gsm_user_allocation.login_organisation_obj = pdOrganisationObj
                 AND gsm_user_allocation.owning_entity_mnemonic = pcEntityMnemonic
                 AND gsm_user_allocation.owning_obj             = pdOwningObj
              )      
      OR 
      /* Attempt match for where organisation obj is 0 ie. security restriciton applied to a user for all login companies */ 
      CAN-FIND(FIRST gsm_user_allocation
               WHERE gsm_user_allocation.USER_obj               = pdUserObj
                 AND gsm_user_allocation.login_organisation_obj = 0
                 AND gsm_user_allocation.owning_entity_mnemonic = pcEntityMnemonic
                 AND gsm_user_allocation.owning_obj             = pdOwningObj
              )
      OR
      /* Attempt match for where user obj is 0 ie. security restriciton applied to all users within a login company */ 
      CAN-FIND(FIRST gsm_user_allocation
               WHERE gsm_user_allocation.USER_obj               = 0
                 AND gsm_user_allocation.login_organisation_obj = pdOrganisationObj
                 AND gsm_user_allocation.owning_entity_mnemonic = pcEntityMnemonic
                 AND gsm_user_allocation.owning_obj             = pdOwningObj
              )
      OR
      /* Attempt match for where organisation obj is 0 and user Obj is 0
         ie. security restriciton applied to a user for all login companies */ 
      CAN-FIND(FIRST gsm_user_allocation
               WHERE gsm_user_allocation.USER_obj               = 0
                 AND gsm_user_allocation.login_organisation_obj = 0
                 AND gsm_user_allocation.owning_entity_mnemonic = pcEntityMnemonic
                 AND gsm_user_allocation.owning_obj             = pdOwningObj
              )
     ).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOwningObj) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getOwningObj Procedure 
FUNCTION getOwningObj RETURNS DECIMAL
  ( INPUT phTTBuffer         AS HANDLE,
    INPUT pcEntityMnemonic   AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns an _obj value for a given entity mnemonic and record
            identified by phTTBuffer.rowIdent.
    Notes:  If given entity mnemonic is not found, return -1.00
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hBuffer    AS HANDLE      NO-UNDO.
  DEFINE VARIABLE hField     AS HANDLE      NO-UNDO.

  /* Get entity mnemonic record - should have been validated in commitQueryResultSet */
  FIND FIRST gsc_entity_mnemonic NO-LOCK
       WHERE gsc_entity_mnemonic.entity_mnemonic EQ pcEntityMnemonic
       NO-ERROR.
  IF NOT AVAILABLE gsc_entity_mnemonic THEN
      RETURN -1.00.

  /* Get handle to rowIdent field in the temp table */
  hField = phTTBuffer:BUFFER-FIELD('rowIdent':U).

  /* Create a buffer object for the db table described by gsc_entity_mnemonic.entity_mnemonic_description */
  CREATE BUFFER hBuffer FOR TABLE gsc_entity_mnemonic.entity_mnemonic_description.
  /* Populate the buffer object with a record with ROWID equal to the rowIdent from the record in the temp table */
  hBuffer:FIND-BY-ROWID(TO-ROWID(ENTRY(1,hField:BUFFER-VALUE()))).  
  /* Get handle to the _obj field of the db buffer */
  hField = hBuffer:BUFFER-FIELD(gsc_entity_mnemonic.entity_object_field).

  RETURN (hField:BUFFER-VALUE()).  /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUserObj) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUserObj Procedure 
FUNCTION getUserObj RETURNS DECIMAL PRIVATE
  ( INPUT pcUserID AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the _obj value for a given Login Company record  
    Notes:  Returns 0.00 if given a blank login company value
            Returns -1.00 if the login company is not found
------------------------------------------------------------------------------*/

  IF pcUserID NE "":U THEN
  DO:
    FIND FIRST gsm_user NO-LOCK
         WHERE gsm_user.USER_login_name = pcUserID
         NO-ERROR.
    IF NOT AVAILABLE gsm_user THEN
       RETURN -1.00.       
  END.
  ELSE
      RETURN 0.00.

  RETURN gsm_user.user_obj.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

