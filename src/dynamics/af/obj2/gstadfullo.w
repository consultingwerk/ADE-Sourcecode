&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}
DEFINE VARIABLE h_Astra                    AS HANDLE          NO-UNDO.
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" dTables _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" dTables _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "SmartDataObjectWizard" dTables _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* SmartDataObject Wizard
Welcome to the SmartDataObject Wizard! During the next few steps, the wizard will lead you through creating a SmartDataObject. You will define the query that you will use to retrieve data from your database(s) and define a set of field values to make available to visualization objects. Press Next to proceed.
adm2/support/_wizqry.w,adm2/support/_wizfld.w 
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS dTables 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: gstadfullo.w

  Description:  Template Astra 2 SmartDataObject Templat

  Purpose:      Template Astra 2 SmartDataObject Template

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:   101000035   UserRef:    
                Date:   09/28/2001  Author:     Johan Meyer

  Update Notes: Change use the information in entity_key_field for tables that do not have object numbers.

  (v:010001)    Task:                UserRef:    
                Date:   APR/11/2002  Author:     Mauricio J. dos Santos (MJS) 
                                                 mdsantos@progress.com
  Update Notes: Adapted for WebSpeed by changing SESSION:PARAM = "REMOTE" 
                to SESSION:CLIENT-TYPE = "WEBSPEED" in initializeObject.

--------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

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

&scop object-name       gstadfullo.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataObject yes

{af/sup2/afglobals.i}

&glob DATA-LOGIC-PROCEDURE       af/obj2/gstadlogcp.p

DEFINE VARIABLE ghDataSource     AS HANDLE      NO-UNDO.
DEFINE VARIABLE glHasObjectField AS LOGICAL     NO-UNDO.
DEFINE VARIABLE gcStoreWhereClause AS CHARACTER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataObject
&Scoped-define DB-AWARE yes

&Scoped-define ADM-SUPPORTED-LINKS Data-Source,Data-Target,Navigation-Target,Update-Target,Commit-Target,Filter-Target


/* Db-Required definitions. */
&IF DEFINED(DB-REQUIRED) = 0 &THEN
    &GLOBAL-DEFINE DB-REQUIRED TRUE
&ENDIF
&GLOBAL-DEFINE DB-REQUIRED-START   &IF {&DB-REQUIRED} &THEN
&GLOBAL-DEFINE DB-REQUIRED-END     &ENDIF


&Scoped-define QUERY-NAME Query-Main

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES gst_audit gsc_entity_mnemonic gsm_user

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  owning_entity_mnemonic owning_obj audit_date audit_time audit_user_obj~
 program_name program_procedure audit_action old_detail~
 entity_mnemonic_description user_login_name audit_time_str~
 entity_object_field entity_key_field owning_reference
&Scoped-define ENABLED-FIELDS-IN-gst_audit owning_entity_mnemonic ~
owning_obj audit_date audit_time audit_user_obj program_name ~
program_procedure audit_action old_detail owning_reference 
&Scoped-define ENABLED-FIELDS-IN-gsc_entity_mnemonic ~
entity_mnemonic_description entity_object_field entity_key_field 
&Scoped-define ENABLED-FIELDS-IN-gsm_user user_login_name 
&Scoped-Define DATA-FIELDS  audit_obj owning_entity_mnemonic owning_obj audit_date audit_time~
 audit_user_obj program_name program_procedure audit_action old_detail~
 entity_mnemonic_description user_login_name audit_time_str~
 entity_object_field entity_key_field owning_reference
&Scoped-define DATA-FIELDS-IN-gst_audit audit_obj owning_entity_mnemonic ~
owning_obj audit_date audit_time audit_user_obj program_name ~
program_procedure audit_action old_detail owning_reference 
&Scoped-define DATA-FIELDS-IN-gsc_entity_mnemonic ~
entity_mnemonic_description entity_object_field entity_key_field 
&Scoped-define DATA-FIELDS-IN-gsm_user user_login_name 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "af/obj2/gstadfullo.i"
&Scoped-define QUERY-STRING-Query-Main FOR EACH gst_audit NO-LOCK, ~
      FIRST gsc_entity_mnemonic WHERE gsc_entity_mnemonic.entity_mnemonic = gst_audit.owning_entity_mnemonic NO-LOCK, ~
      FIRST gsm_user WHERE gsm_user.user_obj = gst_audit.audit_user_obj NO-LOCK ~
    BY gst_audit.audit_obj INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH gst_audit NO-LOCK, ~
      FIRST gsc_entity_mnemonic WHERE gsc_entity_mnemonic.entity_mnemonic = gst_audit.owning_entity_mnemonic NO-LOCK, ~
      FIRST gsm_user WHERE gsm_user.user_obj = gst_audit.audit_user_obj NO-LOCK ~
    BY gst_audit.audit_obj INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main gst_audit gsc_entity_mnemonic ~
gsm_user
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main gst_audit
&Scoped-define SECOND-TABLE-IN-QUERY-Query-Main gsc_entity_mnemonic
&Scoped-define THIRD-TABLE-IN-QUERY-Query-Main gsm_user


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isQueryGoingToWork dTables 
FUNCTION isQueryGoingToWork RETURNS LOGICAL
  (pcWhere  AS CHARACTER,
   pcBuffer AS cHARACTER,
   pcAndOr  AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD joinEntity dTables 
FUNCTION joinEntity RETURNS LOGICAL
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      gst_audit, 
      gsc_entity_mnemonic
    FIELDS(gsc_entity_mnemonic.entity_mnemonic_description
      gsc_entity_mnemonic.entity_object_field
      gsc_entity_mnemonic.entity_key_field), 
      gsm_user
    FIELDS(gsm_user.user_login_name) SCROLLING.
&ANALYZE-RESUME
{&DB-REQUIRED-END}


/* ************************  Frame Definitions  *********************** */


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataObject
   Allow: Query
   Frames: 0
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE APPSERVER DB-AWARE
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
  CREATE WINDOW dTables ASSIGN
         HEIGHT             = 1.43
         WIDTH              = 57.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB dTables 
/* ************************* Included-Libraries *********************** */

{src/adm2/data.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW dTables
  VISIBLE,,RUN-PERSISTENT                                               */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK QUERY Query-Main
/* Query rebuild information for SmartDataObject Query-Main
     _TblList          = "icfdb.gst_audit,icfdb.gsc_entity_mnemonic WHERE icfdb.gst_audit ...,icfdb.gsm_user WHERE icfdb.gst_audit ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST USED, FIRST USED"
     _OrdList          = "icfdb.gst_audit.audit_obj|yes"
     _JoinCode[2]      = "gsc_entity_mnemonic.entity_mnemonic = gst_audit.owning_entity_mnemonic"
     _JoinCode[3]      = "gsm_user.user_obj = gst_audit.audit_user_obj"
     _FldNameList[1]   > icfdb.gst_audit.audit_obj
"audit_obj" "audit_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 21 yes
     _FldNameList[2]   > icfdb.gst_audit.owning_entity_mnemonic
"owning_entity_mnemonic" "owning_entity_mnemonic" ? ? "character" ? ? ? ? ? ? yes ? no 16 yes
     _FldNameList[3]   > icfdb.gst_audit.owning_obj
"owning_obj" "owning_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21 yes
     _FldNameList[4]   > icfdb.gst_audit.audit_date
"audit_date" "audit_date" ? ? "date" ? ? ? ? ? ? yes ? no 4 yes
     _FldNameList[5]   > icfdb.gst_audit.audit_time
"audit_time" "audit_time" ? ? "integer" ? ? ? ? ? ? yes ? no 4 yes
     _FldNameList[6]   > icfdb.gst_audit.audit_user_obj
"audit_user_obj" "audit_user_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21 yes
     _FldNameList[7]   > icfdb.gst_audit.program_name
"program_name" "program_name" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[8]   > icfdb.gst_audit.program_procedure
"program_procedure" "program_procedure" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[9]   > icfdb.gst_audit.audit_action
"audit_action" "audit_action" ? ? "character" ? ? ? ? ? ? yes ? no 6 yes
     _FldNameList[10]   > icfdb.gst_audit.old_detail
"old_detail" "old_detail" ? ? "character" ? ? ? ? ? ? yes ? no 20000 yes
     _FldNameList[11]   > icfdb.gsc_entity_mnemonic.entity_mnemonic_description
"entity_mnemonic_description" "entity_mnemonic_description" ? ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[12]   > icfdb.gsm_user.user_login_name
"user_login_name" "user_login_name" ? ? "character" ? ? ? ? ? ? yes ? no 16.4 yes
     _FldNameList[13]   > "_<CALC>"
"STRING(RowObject.audit_time,'HH:MM:SS')" "audit_time_str" "Audit Time" "x(8)" "character" ? ? ? ? ? ? yes ? no 8 no
     _FldNameList[14]   > icfdb.gsc_entity_mnemonic.entity_object_field
"entity_object_field" "entity_object_field" ? ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[15]   > icfdb.gsc_entity_mnemonic.entity_key_field
"entity_key_field" "entity_key_field" ? ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[16]   > icfdb.gst_audit.owning_reference
"owning_reference" "owning_reference" ? ? "character" ? ? ? ? ? ? yes ? no 3000 yes
     _Design-Parent    is WINDOW dTables @ ( 1.14 , 2.6 )
*/  /* QUERY Query-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK dTables 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DATA.CALCULATE dTables  DATA.CALCULATE _DB-REQUIRED
PROCEDURE DATA.CALCULATE :
/*------------------------------------------------------------------------------
  Purpose:     Calculate all the Calculated Expressions found in the
               SmartDataObject.
  Parameters:  <none>
------------------------------------------------------------------------------*/
      ASSIGN 
         rowObject.audit_time_str = (STRING(RowObject.audit_time,'HH:MM:SS'))
      .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataAvailable dTables 
PROCEDURE dataAvailable :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcRelative AS CHARACTER NO-UNDO.


  {get AsDivision cAsDivision}.

  IF ((pcRelative <> 'SAME':U) AND (pcRelative <> 'DIFFERENT':U)) AND cAsDivision <> 'SERVER':U  AND VALID-HANDLE(ghDataSource)
     OR ((pcRelative = 'DIFFERENT':U) AND (SOURCE-PROCEDURE = ghDataSource)) THEN
  DO:
    joinEntity().
    {fn openQuery}.
  END.
  ELSE 
    RUN SUPER(pcRelative).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI dTables  _DEFAULT-DISABLE
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
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject dTables 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE cValueList            AS CHARACTER     NO-UNDO.
  DEFINE VARIABLE cUpdatableTable       AS CHARACTER     NO-UNDO.
  DEFINE VARIABLE cEntityFields         AS CHARACTER     NO-UNDO.
  DEFINE VARIABLE cEntityValues         AS CHARACTER     NO-UNDO.
  DEFINE VARIABLE lInitialized          AS LOGICAL       NO-UNDO.
  DEFINE VARIABLE cAsDivision           AS CHARACTER     NO-UNDO.
  DEFINE VARIABLE hContainerSource      AS HANDLE        NO-UNDO.
  DEFINE VARIABLE cAttrValue            AS CHARACTER     NO-UNDO.
  
  {get DataSource ghDatasource}.
  IF NOT VALID-HANDLE(ghDataSource) THEN 
  DO:
    {get ContainerSource hContainerSource}.
    {get runAttribute cAttrValue hContainerSource}.
    ghDataSource = WIDGET-HANDLE(cAttrValue).
  END.

  IF VALID-HANDLE(ghDatasource) THEN
  DO:
      JoinEntity().
      
      SUBSCRIBE TO "DataAvailable":U IN ghDatasource.
      {get ObjectInitialized lInitialized}.
      IF lInitialized THEN
        RETURN.
      
      {set ServerSubmitValidation YES}.
      
      cUpdatableTable = ENTRY(1,{fn getEnabledTables ghDataSource}) NO-ERROR.
      RUN getEntityDetail IN gshGenMAnager (INPUT cUpdatableTable, OUTPUT cEntityFields, OUTPUT cEntityValues).
    
      ASSIGN glHasObjectField = (ENTRY(LOOKUP("table_has_object_field",cEntityFields,CHR(1)),cEntityValues,CHR(1)) = "YES":U) NO-ERROR.
      
      {get AsDivision cAsDivision}.
      
      IF cAsDivision <> 'SERVER':U THEN
        joinEntity().
  END.

  RUN SUPER.

  /* Runing a manual openQuery as there is no foreignFields to be set as their is no one-to-one match */

  IF cAsDivision <> 'SERVER':U AND VALID-HANDLE(ghDataSource) THEN
    {fn openQuery}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isQueryGoingToWork dTables 
FUNCTION isQueryGoingToWork RETURNS LOGICAL
  (pcWhere  AS CHARACTER,
   pcBuffer AS cHARACTER,
   pcAndOr  AS CHARACTER):
/*------------------------------------------------------------------------------
   Purpose:    Due to the order in which things are instantiated, updating the 
               SDO query is only going to work later.  This function will let us
               know if our new WHERE clause is going to validate or not.
 
   Parameters: 
     pcWhere     - Expression to add (may also be an "OF" phrase)  
     pcBuffer    - optional buffer specification
     pcAndOr     - Specifies the operator that is used to add the new
                   expression to existing expression(s)
                   - AND (default) 
                   - OR         
   Notes:      
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cQueryString AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cBuffer      AS CHARACTER  NO-UNDO.

  {get QueryString cQueryString}.      

  IF cQueryString = "":U 
  OR cQueryString = ? 
  THEN DO:
      {get QueryWhere cQueryString}.    
      IF cQueryString = "":U 
      OR cQueryString = ? THEN
          {get OpenQuery cQueryString}.
  END.

  /* Unless buffer is defined, use the first buffer reference in the expression*/

  IF pcBuffer <> ?
  THEN DO:
      cBuffer = {fnarg resolveBuffer pcBuffer}.

      IF cBuffer = "":U 
      OR cBuffer = ? THEN
          RETURN FALSE.
  END.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION joinEntity dTables 
FUNCTION joinEntity RETURNS LOGICAL
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cOwningEntityMnemonic AS CHARACTER     NO-UNDO.
  DEFINE VARIABLE cKeyFields            AS CHARACTER     NO-UNDO.
  DEFINE VARIABLE cTable                AS CHARACTER     NO-UNDO.
  DEFINE VARIABLE cWhere                AS CHARACTER     NO-UNDO.
  DEFINE VARIABLE cKeyValue             AS CHARACTER     NO-UNDO.
  DEFINE VARIABLE iLoop                 AS INTEGER       NO-UNDO.
  
  {get KeyFields cKeyFields ghDataSource}.
  {get KeyTableId cOwningEntityMnemonic ghDataSource}.
  
  IF cOwningEntityMnemonic = ? THEN
    cOwningEntityMnemonic = "":U.

  ASSIGN cKeyValue = DYNAMIC-FUNCTION("colValues":U IN ghDataSource, cKeyFields)
         cKeyValue = SUBSTRING(cKeyValue,INDEX(cKeyValue,CHR(1)) + 1) /* Strip out the rowIdent part */
         cKeyValue = REPLACE(cKeyValue,CHR(1),CHR(2))
         NO-ERROR.
  
  ASSIGN
     cWhere = "gst_audit.owning_entity_mnemonic = '":U + cOwningEntityMnemonic + "' AND ":U + 
              "gst_audit.owning_reference = '":U + TRIM(cKeyValue) + "'  ".

  DYNAMIC-FUNCTION("setUserProperty":U, "OwningEntityMnemonic":U, cOwningEntityMnemonic).
  DYNAMIC-FUNCTION("setUserProperty":U, "OwningReference":U, cKeyValue).
  
  /* Applying the filter for Owning Entity Mnemonics */
  IF cWhere > '':U
  AND gcStoreWhereClause <> cWhere
  AND DYNAMIC-FUNCTION("isQueryGoingToWork":U, cWhere, "gst_audit":U, "AND":U) = YES THEN
  DO:
    ASSIGN gcStoreWhereClause = cWhere.
    DYNAMIC-FUNCTION("setQueryWhere":U,"":U).
    DYNAMIC-FUNCTION("addQueryWhere":U, INPUT cWhere, "":U, "AND":U).
    ASSIGN
      cWhere = cWhere +  CHR(3) + CHR(3) + "AND":U.
    {set manualAddQueryWhere cWhere}.
  END.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

