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
  File: gsmcmfullo.w

  Description:  Template Astra 2 SmartDataObject Templat

  Purpose:      Template Astra 2 SmartDataObject Template

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        6180   UserRef:    
                Date:   28/06/2000  Author:     Anthony Swindells

  Update Notes: V9 Templates

  (v:010001)    Task:   101000035   UserRef:    
                Date:   09/28/2001  Author:     Johan Meyer

  Update Notes: Change use the information in entity_key_field for tables that do not have object numbers.

  (v:010002)    Task:           0   UserRef:    
                Date:   01/15/2002  Author:     Mark Davies (MIP)

  Update Notes: Fix for issue #3665 - Comments added to some table records can be saved but cannot be displayed
                The entity key field was not trimmed when the field was anything other than a string value.

------------------------------------------------------------------*/
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

&scop object-name       gsmcmfullo.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataObject yes

{af/sup2/afglobals.i}

&glob DATA-LOGIC-PROCEDURE       af/obj2/gsmcmlogcp.p

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
&Scoped-define INTERNAL-TABLES gsm_comment gsm_category

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  owning_entity_mnemonic category_obj comment_text auto_display~
 print_option_tlas expiry_date comment_description owning_reference
&Scoped-define ENABLED-FIELDS-IN-gsm_comment owning_entity_mnemonic ~
category_obj comment_text auto_display print_option_tlas expiry_date ~
comment_description owning_reference 
&Scoped-Define DATA-FIELDS  comment_obj owning_entity_mnemonic category_obj category_description~
 comment_text auto_display print_option_tlas expiry_date comment_description~
 owning_reference
&Scoped-define DATA-FIELDS-IN-gsm_comment comment_obj ~
owning_entity_mnemonic category_obj comment_text auto_display ~
print_option_tlas expiry_date comment_description owning_reference 
&Scoped-define DATA-FIELDS-IN-gsm_category category_description 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "af/obj2/gsmcmfullo.i"
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH gsm_comment NO-LOCK, ~
      FIRST gsm_category WHERE gsm_category.category_obj = gsm_comment.category_obj NO-LOCK ~
    BY gsm_comment.comment_obj INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main gsm_comment gsm_category
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main gsm_comment
&Scoped-define SECOND-TABLE-IN-QUERY-Query-Main gsm_category


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD deleteRow dTables  _DB-REQUIRED
FUNCTION deleteRow RETURNS LOGICAL
  ( INPUT pcRowIdent AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD submitRow dTables  _DB-REQUIRED
FUNCTION submitRow RETURNS LOGICAL
  ( INPUT pcRowIdent AS CHARACTER,
    INPUT pcValueList AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}


/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      gsm_comment, 
      gsm_category
    FIELDS(gsm_category.category_description) SCROLLING.
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
         HEIGHT             = 1.67
         WIDTH              = 62.2.
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
     _TblList          = "icfdb.gsm_comment,icfdb.gsm_category WHERE icfdb.gsm_comment ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST USED, FIRST OUTER USED"
     _OrdList          = "icfdb.gsm_comment.comment_obj|yes"
     _JoinCode[2]      = "icfdb.gsm_category.category_obj = icfdb.gsm_comment.category_obj"
     _FldNameList[1]   > icfdb.gsm_comment.comment_obj
"comment_obj" "comment_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 21 yes
     _FldNameList[2]   > icfdb.gsm_comment.owning_entity_mnemonic
"owning_entity_mnemonic" "owning_entity_mnemonic" "Entity Mnemonic" ? "character" ? ? ? ? ? ? yes ? no 16 yes
     _FldNameList[3]   > icfdb.gsm_comment.category_obj
"category_obj" "category_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21 yes
     _FldNameList[4]   > icfdb.gsm_category.category_description
"category_description" "category_description" ? ? "character" ? ? ? ? ? ? no ? no 70 yes
     _FldNameList[5]   > icfdb.gsm_comment.comment_text
"comment_text" "comment_text" ? ? "character" ? ? ? ? ? ? yes ? no 6000 yes
     _FldNameList[6]   > icfdb.gsm_comment.auto_display
"auto_display" "auto_display" ? ? "logical" ? ? ? ? ? ? yes ? no 1 yes
     _FldNameList[7]   > icfdb.gsm_comment.print_option_tlas
"print_option_tlas" "print_option_tlas" ? ? "character" ? ? ? ? ? ? yes ? no 140 yes
     _FldNameList[8]   > icfdb.gsm_comment.expiry_date
"expiry_date" "expiry_date" ? ? "date" ? ? ? ? ? ? yes ? no 4 yes
     _FldNameList[9]   > icfdb.gsm_comment.comment_description
"comment_description" "comment_description" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[10]   > icfdb.gsm_comment.owning_reference
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

  DEFINE VARIABLE hDataSource           AS WIDGET-HANDLE NO-UNDO.
  DEFINE VARIABLE cValueList            AS CHARACTER     NO-UNDO.
  DEFINE VARIABLE cOwningEntityMnemonic AS CHARACTER     NO-UNDO.
  DEFINE VARIABLE cUpdatableTable       AS CHARACTER     NO-UNDO.
  DEFINE VARIABLE cObjField             AS CHARACTER     NO-UNDO.
  DEFINE VARIABLE cForeignFields        AS CHARACTER     NO-UNDO.
  DEFINE VARIABLE cWhere                AS CHARACTER     NO-UNDO.
  DEFINE VARIABLE cEntityFields         AS CHARACTER     NO-UNDO.
  DEFINE VARIABLE cEntityValues         AS CHARACTER     NO-UNDO.
  DEFINE VARIABLE cKeyValue             AS CHARACTER     NO-UNDO.
  DEFINE VARIABLE iLoop                 AS INTEGER       NO-UNDO.
  DEFINE VARIABLE lHasObjFld            AS LOGICAL       NO-UNDO.
  DEFINE VARIABLE hContainerSource      AS HANDLE        NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  /* Ensure that rowObjectValidate is always run. */
  DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager
                                      ,INPUT "ServerSubmitValidation":U
                                      ,INPUT YES
                                      ,INPUT NO
                                      ).
  {set ServerSubmitValidation YES}.
  {get ContainerSource hContainerSource}.
  
  hDataSource = WIDGET-HANDLE(DYNAMIC-FUNCTION("getRunAttribute":U IN hContainerSource)).
  
  /* Check to see that we are running client side and only then set the Owning Entity Mnemonic user property, etc. */
  IF NOT (SESSION:REMOTE = TRUE OR SESSION:PARAM  = "REMOTE":U)
  THEN DO:
    IF VALID-HANDLE(hDataSource)
    THEN
      ASSIGN
        cValueList = DYNAMIC-FUNCTION("getUpdatableTableInfo":U IN gshGenManager, INPUT hDataSource).
    
    IF LENGTH(TRIM(cValueList)) > 0
    THEN DO:

      ASSIGN
        cOwningEntityMnemonic = ENTRY(1, cValueList, CHR(4))
        cUpdatableTable       = ENTRY(2, cValueList, CHR(4)).

      RUN getEntityDetail IN gshGenMAnager (INPUT cOwningEntityMnemonic, OUTPUT cEntityFields, OUTPUT cEntityValues).

      IF ENTRY(LOOKUP("table_has_object_field",cEntityFields,CHR(1)),cEntityValues,CHR(1)) = "YES":U THEN
        ASSIGN
          cObjField = ENTRY(LOOKUP("entity_object_field",cEntityFields,CHR(1)),cEntityValues,CHR(1))
          lHasObjFld = TRUE.
      ELSE
        ASSIGN
          cObjField = ENTRY(LOOKUP("entity_key_field",cEntityFields,CHR(1)),cEntityValues,CHR(1)).

      DO iLoop = 1 TO NUM-ENTRIES(cObjField):
        IF lHasObjFld THEN
          ASSIGN
            cKeyValue = cKeyValue + CHR(1) WHEN cKeyValue <> "":U
            cKeyValue = cKeyValue + TRIM(STRING(DECIMAL((DYNAMIC-FUNCTION("columnStringValue":u IN hDataSource, ENTRY(iLoop,cObjField)))))).
        ELSE
        ASSIGN
          cKeyValue = cKeyValue + CHR(2) WHEN cKeyValue <> "":U
          cKeyValue = cKeyValue + TRIM(DYNAMIC-FUNCTION("columnStringValue":u IN hDataSource, ENTRY(iLoop,cObjField))).
      END.
      ASSIGN
        cWhere = "gsm_comment.owning_entity_mnemonic = '":U + cOwningEntityMnemonic + "' AND ":U + 
                 "gsm_comment.owning_reference = '":U + TRIM(cKeyValue) + "'  ".

      
      DYNAMIC-FUNCTION("setUserProperty":U, "OwningEntityMnemonic":U, cOwningEntityMnemonic).
      DYNAMIC-FUNCTION("setUserProperty":U, "OwningReference":U, cKeyValue).
    END.

    /* Applying the filter for Owning Entity Mnemonics */
    IF LENGTH(TRIM(cWhere)) <> 0
    THEN DO:      
      DYNAMIC-FUNCTION("addQueryWhere":U, INPUT cWhere, "":U, "AND":U).
      ASSIGN
        cWhere = cWhere +  CHR(3) + CHR(3) + "AND":U.
      {set manualAddQueryWhere cWhere}.
    END.

  END.  /* client side */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  /* Running a manual openQuery as there is no foreignFields to be set as their is no one-to-one match */
  {fn openQuery}.

  {get DataSource hDataSource}.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION deleteRow dTables  _DB-REQUIRED
FUNCTION deleteRow RETURNS LOGICAL
  ( INPUT pcRowIdent AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  DEFINE VARIABLE hDataSource   AS WIDGET-HANDLE  NO-UNDO.
  DEFINE VARIABLE lCommentOK    AS LOGICAL        NO-UNDO.

  {get DataSource hDataSource}.
  lCommentOK = SUPER( INPUT pcRowIdent ) NO-ERROR.

  IF lCommentOK
  AND VALID-HANDLE(hDataSource)
  THEN DO:
    RUN refreshRow IN hDataSource.
  END.

  /* RETURN SUPER( INPUT pcRowIdent ). */
  RETURN lCommentOK.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION submitRow dTables  _DB-REQUIRED
FUNCTION submitRow RETURNS LOGICAL
  ( INPUT pcRowIdent AS CHARACTER,
    INPUT pcValueList AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  DEFINE VARIABLE hDataSource   AS WIDGET-HANDLE  NO-UNDO.
  DEFINE VARIABLE lCommentNew   AS LOGICAL        NO-UNDO.
  DEFINE VARIABLE lCommentOK    AS LOGICAL        NO-UNDO.

  {get DataSource hDataSource}.
  lCommentNew   = DYNAMIC-FUNCTION('getNewRow':U).
  lCommentOK    = SUPER( INPUT pcRowIdent, INPUT pcValueList ) NO-ERROR.

  IF  lCommentNew
  AND lCommentOK
  AND VALID-HANDLE(hDataSource)
  THEN DO:
    RUN refreshRow IN hDataSource.
  END.

/* RETURN SUPER( INPUT pcRowIdent, INPUT pcValueList ). */
  RETURN lCommentOK.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

