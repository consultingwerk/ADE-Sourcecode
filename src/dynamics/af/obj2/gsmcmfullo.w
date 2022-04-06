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

  (v:010003)    Task:                UserRef:    
                Date:   APR/11/2002  Author:     Mauricio J. dos Santos (MJS) 
                                                 mdsantos@progress.com
  Update Notes: Adapted for WebSpeed by changing SESSION:PARAM = "REMOTE" 
                to SESSION:CLIENT-TYPE = "WEBSPEED" in initializeObject.

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Global-define DATA-LOGIC-PROCEDURE af/obj2/gsmcmlogcp.p

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
 print_option_tlas expiry_date comment_description owning_reference~
 last_updated_by_user last_updated_date owning_obj
&Scoped-define ENABLED-FIELDS-IN-gsm_comment owning_entity_mnemonic ~
category_obj comment_text auto_display print_option_tlas expiry_date ~
comment_description owning_reference last_updated_by_user last_updated_date ~
owning_obj 
&Scoped-Define DATA-FIELDS  comment_obj owning_entity_mnemonic category_obj category_description~
 comment_text auto_display print_option_tlas expiry_date comment_description~
 owning_reference last_updated_by_user last_updated_date owning_obj
&Scoped-define DATA-FIELDS-IN-gsm_comment comment_obj ~
owning_entity_mnemonic category_obj comment_text auto_display ~
print_option_tlas expiry_date comment_description owning_reference ~
last_updated_by_user last_updated_date owning_obj 
&Scoped-define DATA-FIELDS-IN-gsm_category category_description 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "af/obj2/gsmcmfullo.i"
&Scoped-define QUERY-STRING-Query-Main FOR EACH gsm_comment NO-LOCK, ~
      FIRST gsm_category WHERE gsm_category.category_obj = gsm_comment.category_obj NO-LOCK ~
    BY gsm_comment.comment_obj INDEXED-REPOSITION
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
         HEIGHT             = 1.1
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
"owning_entity_mnemonic" "owning_entity_mnemonic" ? ? "character" ? ? ? ? ? ? yes ? no 16 yes
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
     _FldNameList[11]   > icfdb.gsm_comment.last_updated_by_user
"last_updated_by_user" "last_updated_by_user" ? ? "character" ? ? ? ? ? ? yes ? no 20.6 yes
     _FldNameList[12]   > icfdb.gsm_comment.last_updated_date
"last_updated_date" "last_updated_date" ? ? "date" ? ? ? ? ? ? yes ? no 18 yes
     _FldNameList[13]   > icfdb.gsm_comment.owning_obj
"owning_obj" "owning_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 33.6 no
     _Design-Parent    is WINDOW dTables @ ( 1.05 , 2.6 )
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

