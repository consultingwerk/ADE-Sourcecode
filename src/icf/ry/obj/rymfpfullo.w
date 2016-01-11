&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          rydb             PROGRESS
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
  File: rymfpfullo.w

  Description:  Wizard Folder Page SDO

  Purpose:      Wizard Folder Page SDO

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        6199   UserRef:    
                Date:   04/07/2000  Author:     Anthony Swindells

  Update Notes: Created from Template rysttasdoo.w
                Created from Template rymfpfullo.w

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

&scop object-name       rymfpfullo.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010001

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataObject yes

{af/sup2/afglobals.i}

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
&Scoped-define INTERNAL-TABLES rym_wizard_fold_page rym_wizard_fold

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  page_number page_label viewer_object_name viewer_data_source_names~
 viewer_update_target_names primary_viewer viewer_toolbar_parent_menu~
 link_viewer_to_sdo browser_object_name browser_toolbar_parent_menu~
 sdo_object_name query_sdo_name parent_sdo_object_name~
 custom_super_procedure static_object window_title_field wizard_fold_obj~
 page_layout sdo_foreign_fields
&Scoped-define ENABLED-FIELDS-IN-rym_wizard_fold_page page_number ~
page_label viewer_object_name viewer_data_source_names ~
viewer_update_target_names primary_viewer viewer_toolbar_parent_menu ~
link_viewer_to_sdo browser_object_name browser_toolbar_parent_menu ~
sdo_object_name query_sdo_name parent_sdo_object_name ~
custom_super_procedure static_object window_title_field wizard_fold_obj ~
page_layout sdo_foreign_fields 
&Scoped-Define DATA-FIELDS  product_code product_module_code object_name object_description page_number~
 page_label viewer_object_name viewer_data_source_names~
 viewer_update_target_names primary_viewer viewer_toolbar_parent_menu~
 link_viewer_to_sdo browser_object_name browser_toolbar_parent_menu~
 sdo_object_name query_sdo_name parent_sdo_object_name~
 custom_super_procedure static_object window_title_field wizard_fold_obj~
 page_layout sdo_foreign_fields wizard_fold_page_obj
&Scoped-define DATA-FIELDS-IN-rym_wizard_fold_page page_number page_label ~
viewer_object_name viewer_data_source_names viewer_update_target_names ~
primary_viewer viewer_toolbar_parent_menu link_viewer_to_sdo ~
browser_object_name browser_toolbar_parent_menu sdo_object_name ~
query_sdo_name parent_sdo_object_name custom_super_procedure static_object ~
window_title_field wizard_fold_obj page_layout sdo_foreign_fields ~
wizard_fold_page_obj 
&Scoped-define DATA-FIELDS-IN-rym_wizard_fold product_code ~
product_module_code object_name object_description 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "ry/obj/rymfpfullo.i"
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH rym_wizard_fold_page NO-LOCK, ~
      FIRST rym_wizard_fold WHERE rym_wizard_fold.wizard_fold_obj = rym_wizard_fold_page.wizard_fold_obj NO-LOCK ~
    BY rym_wizard_fold_page.wizard_fold_obj ~
       BY rym_wizard_fold_page.page_number INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main rym_wizard_fold_page ~
rym_wizard_fold
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main rym_wizard_fold_page
&Scoped-define SECOND-TABLE-IN-QUERY-Query-Main rym_wizard_fold


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      rym_wizard_fold_page, 
      rym_wizard_fold SCROLLING.
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
         HEIGHT             = 1.62
         WIDTH              = 46.6.
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
     _TblList          = "RYDB.rym_wizard_fold_page,RYDB.rym_wizard_fold WHERE RYDB.rym_wizard_fold_page ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST"
     _OrdList          = "RYDB.rym_wizard_fold_page.wizard_fold_obj|yes,RYDB.rym_wizard_fold_page.page_number|yes"
     _JoinCode[2]      = "RYDB.rym_wizard_fold.wizard_fold_obj = RYDB.rym_wizard_fold_page.wizard_fold_obj"
     _FldNameList[1]   > RYDB.rym_wizard_fold.product_code
"product_code" "product_code" ? ? "character" ? ? ? ? ? ? no ? no 13 yes
     _FldNameList[2]   > RYDB.rym_wizard_fold.product_module_code
"product_module_code" "product_module_code" ? ? "character" ? ? ? ? ? ? no ? no 20.6 yes
     _FldNameList[3]   > RYDB.rym_wizard_fold.object_name
"object_name" "object_name" ? ? "character" ? ? ? ? ? ? no ? no 35 yes
     _FldNameList[4]   > RYDB.rym_wizard_fold.object_description
"object_description" "object_description" ? ? "character" ? ? ? ? ? ? no ? no 35 yes
     _FldNameList[5]   > RYDB.rym_wizard_fold_page.page_number
"page_number" "page_number" ? ? "integer" ? ? ? ? ? ? yes ? no 13 yes
     _FldNameList[6]   > RYDB.rym_wizard_fold_page.page_label
"page_label" "page_label" ? ? "character" ? ? ? ? ? ? yes ? no 28 yes
     _FldNameList[7]   > RYDB.rym_wizard_fold_page.viewer_object_name
"viewer_object_name" "viewer_object_name" ? ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[8]   > RYDB.rym_wizard_fold_page.viewer_data_source_names
"viewer_data_source_names" "viewer_data_source_names" ? ? "character" ? ? ? ? ? ? yes ? no 500 yes
     _FldNameList[9]   > RYDB.rym_wizard_fold_page.viewer_update_target_names
"viewer_update_target_names" "viewer_update_target_names" ? ? "character" ? ? ? ? ? ? yes ? no 500 yes
     _FldNameList[10]   > RYDB.rym_wizard_fold_page.primary_viewer
"primary_viewer" "primary_viewer" ? ? "logical" ? ? ? ? ? ? yes ? no 13.8 yes
     _FldNameList[11]   > RYDB.rym_wizard_fold_page.viewer_toolbar_parent_menu
"viewer_toolbar_parent_menu" "viewer_toolbar_parent_menu" ? ? "character" ? ? ? ? ? ? yes ? no 28 yes
     _FldNameList[12]   > RYDB.rym_wizard_fold_page.link_viewer_to_sdo
"link_viewer_to_sdo" "link_viewer_to_sdo" "Link Viewer to Data Object" ? "logical" ? ? ? ? ? ? yes ? no 17.8 yes
     _FldNameList[13]   > RYDB.rym_wizard_fold_page.browser_object_name
"browser_object_name" "browser_object_name" ? ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[14]   > RYDB.rym_wizard_fold_page.browser_toolbar_parent_menu
"browser_toolbar_parent_menu" "browser_toolbar_parent_menu" ? ? "character" ? ? ? ? ? ? yes ? no 28.2 yes
     _FldNameList[15]   > RYDB.rym_wizard_fold_page.sdo_object_name
"sdo_object_name" "sdo_object_name" "Data Object Name" ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[16]   > RYDB.rym_wizard_fold_page.query_sdo_name
"query_sdo_name" "query_sdo_name" ? ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[17]   > RYDB.rym_wizard_fold_page.parent_sdo_object_name
"parent_sdo_object_name" "parent_sdo_object_name" ? ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[18]   > RYDB.rym_wizard_fold_page.custom_super_procedure
"custom_super_procedure" "custom_super_procedure" ? ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[19]   > RYDB.rym_wizard_fold_page.static_object
"static_object" "static_object" ? ? "logical" ? ? ? ? ? ? yes ? no 12.2 yes
     _FldNameList[20]   > RYDB.rym_wizard_fold_page.window_title_field
"window_title_field" "window_title_field" ? ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[21]   > RYDB.rym_wizard_fold_page.wizard_fold_obj
"wizard_fold_obj" "wizard_fold_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21.6 yes
     _FldNameList[22]   > RYDB.rym_wizard_fold_page.page_layout
"page_layout" "page_layout" ? ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[23]   > RYDB.rym_wizard_fold_page.sdo_foreign_fields
"sdo_foreign_fields" "sdo_foreign_fields" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[24]   > RYDB.rym_wizard_fold_page.wizard_fold_page_obj
"wizard_fold_page_obj" "wizard_fold_page_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 21.6 yes
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

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE endTransactionValidate dTables  _DB-REQUIRED
PROCEDURE endTransactionValidate :
/*------------------------------------------------------------------------------
  Purpose:     Ensure 1 and only 1 primary viewer per SDO
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE cMessageList                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cText                         AS CHARACTER  NO-UNDO.

DEFINE BUFFER bRowObjUpd FOR RowObjUpd.

FIND FIRST RowObjUpd
     WHERE LOOKUP(RowObjUpd.RowMod,"A,C,U,D":U) <> 0
     NO-ERROR.
IF NOT AVAILABLE RowObjUpd THEN
DO: /* should not happen */
  ERROR-STATUS:ERROR = NO.
  RETURN.
END.

DEFINE BUFFER brym_wizard_fold_page FOR rym_wizard_fold_page.

/* If delete primary viewer - set another one to be primary viewer */
IF RowObjUpd.RowMod = "D":U AND RowObjUpd.PRIMARY_viewer = YES THEN /* ensure at least 1 primary viewer after delete */
DO:
  fold-loop:
  FOR EACH brym_wizard_fold_page EXCLUSIVE-LOCK
     WHERE brym_wizard_fold_page.wizard_fold_obj = RowObjUpd.wizard_fold_obj
       AND brym_wizard_fold_page.sdo_object_name = RowObjUpd.sdo_object_name
       AND brym_wizard_fold_page.wizard_fold_page_obj <> RowObjUpd.wizard_fold_page_obj
       AND brym_wizard_fold_page.viewer_object_name <> "":U
        BY brym_wizard_fold_page.PAGE_number:
    ASSIGN brym_wizard_fold_page.PRIMARY_viewer = YES.

    LEAVE fold-loop.
  END.
END.
IF RowObjUpd.RowMod = "D":U THEN RETURN.

/* must be an add, copy or update */

/* see if before change record exists */
FIND FIRST bRowObjUpd
     WHERE bRowObjUpd.rownum = bRowObjUpd.rownum
       AND bRowObjUpd.rowmod = "":U
     NO-ERROR.

/* If changed sdo name in a modify, need to fix up old sdo name main viewer */
IF AVAILABLE bRowObjUpd AND
   RowObjUpd.RowMod = "U":U AND 
   bRowObjUpd.sdo_object_name <> RowObjUpd.sdo_object_name AND
   NOT CAN-FIND(FIRST brym_wizard_fold_page 
                WHERE brym_wizard_fold_page.wizard_fold_obj = RowObjUpd.wizard_fold_obj
                  AND brym_wizard_fold_page.sdo_object_name = bRowObjUpd.sdo_object_name
                  AND brym_wizard_fold_page.wizard_fold_page_obj <> RowObjUpd.wizard_fold_page_obj
                  AND brym_wizard_fold_page.viewer_object_name <> "":U
                  AND brym_wizard_fold_page.PRIMARY_viewer = YES) THEN
DO:
  fold-loop2:
  FOR EACH brym_wizard_fold_page EXCLUSIVE-LOCK
     WHERE brym_wizard_fold_page.wizard_fold_obj = RowObjUpd.wizard_fold_obj
       AND brym_wizard_fold_page.sdo_object_name = bRowObjUpd.sdo_object_name
       AND brym_wizard_fold_page.wizard_fold_page_obj <> RowObjUpd.wizard_fold_page_obj
       AND brym_wizard_fold_page.viewer_object_name <> "":U
        BY brym_wizard_fold_page.PAGE_number:
    ASSIGN brym_wizard_fold_page.PRIMARY_viewer = YES.

    LEAVE fold-loop2.
  END.
END.

IF RowObjUpd.PRIMARY_viewer = YES THEN
DO:

  FOR EACH brym_wizard_fold_page EXCLUSIVE-LOCK
     WHERE brym_wizard_fold_page.wizard_fold_obj = RowObjUpd.wizard_fold_obj
       AND brym_wizard_fold_page.sdo_object_name = RowObjUpd.sdo_object_name
       AND brym_wizard_fold_page.viewer_object_name <> "":U
       AND brym_wizard_fold_page.wizard_fold_page_obj <> RowObjUpd.wizard_fold_page_obj
       AND brym_wizard_fold_page.PRIMARY_viewer = YES:

    ASSIGN brym_wizard_fold_page.PRIMARY_viewer = NO.
  END.

END.
ELSE /* ensure at least 1 primary viewer */
DO:
  IF NOT CAN-FIND(FIRST brym_wizard_fold_page
                  WHERE brym_wizard_fold_page.wizard_fold_obj = RowObjUpd.wizard_fold_obj
                    AND brym_wizard_fold_page.sdo_object_name = RowObjUpd.sdo_object_name
                    AND brym_wizard_fold_page.viewer_object_name <> "":U
                    AND brym_wizard_fold_page.wizard_fold_page_obj <> RowObjUpd.wizard_fold_page_obj
                    AND brym_wizard_fold_page.PRIMARY_viewer = YES) THEN
  DO:
    IF LENGTH(rym_wizard_fold_page.viewer_object_name) > 0 THEN
      ASSIGN rym_wizard_fold_page.PRIMARY_viewer = YES. 
  END.
END.

/* pass back errors in return value and ensure error status not left raised */
ERROR-STATUS:ERROR = NO.
RETURN cMessageList.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE preTransactionValidate dTables  _DB-REQUIRED
PROCEDURE preTransactionValidate :
/*------------------------------------------------------------------------------
  Purpose:     To perform validation that requires access to the database but
               that can occur before the transaction has started.
  Parameters:  <none>
  Notes:       Batch up errors using a chr(3) delimiter and be sure not to leave
               the error status raised.
------------------------------------------------------------------------------*/

DEFINE VARIABLE cMessageList                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cText                         AS CHARACTER  NO-UNDO.

FOR EACH RowObjUpd WHERE LOOKUP(RowObjUpd.RowMod,"A,C,U":U) <> 0:

  /* ensure page number specified is unique */
  IF (RowObjUpd.RowMod = "U":U AND
      CAN-FIND(FIRST rym_wizard_fold_page
               WHERE rym_wizard_fold_page.page_number = RowObjUpd.page_number
                 AND rym_wizard_fold_page.wizard_fold_obj = RowObjUpd.wizard_fold_obj
                 AND ROWID(rym_wizard_fold_page) <> TO-ROWID(ENTRY(1,RowObjUpd.ROWIDent)))) OR
     (RowObjUpd.RowMod <> "U":U AND
      CAN-FIND(FIRST rym_wizard_fold_page
               WHERE rym_wizard_fold_page.page_number = RowObjUpd.page_number
                 AND rym_wizard_fold_page.wizard_fold_obj = RowObjUpd.wizard_fold_obj))  THEN
    ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
           {af/sup2/aferrortxt.i 'AF' '8' 'rym_wizard_fold_page' 'page_number' "'page number'" RowObjUpd.page_number "'. Please use a different page number'"}
           .

  /* ensure page layout is valid */
  IF RowObjUpd.PAGE_layout <> "":U AND RowObjUpd.PAGE_layout <> ? AND
     NOT CAN-FIND(FIRST ryc_layout
                  WHERE ryc_layout.layout_name = RowObjUpd.PAGE_layout) THEN
  DO:
    ASSIGN cText = ". The layout name: " + RowObjUpd.PAGE_layout + " does not exist.".
    ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
           {af/sup2/aferrortxt.i 'AF' '5' 'rym_wizard_fold_page' 'PAGE_layout' "'page layout'" cText}
           .
  END.

END.

/* pass back errors in return value and ensure error status not left raised */
ERROR-STATUS:ERROR = NO.
RETURN cMessageList.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowObjectValidate dTables 
PROCEDURE rowObjectValidate :
/*------------------------------------------------------------------------------
  Purpose:     This validation will occur client side as it does not require a 
               DB connection and the db-required flag has been disabled.
  Parameters:  <none>
  Notes:       Here we validate individual fields that are mandatory have been
               entered. Checks that require db reads will be done later in one
               of the transaction validation routines.
               This procedure should batch up the errors using a chr(3) delimiter
               so that all the errors can be dsplayed to the user in one go.
               Be sure not to leave the error status raised !!!
------------------------------------------------------------------------------*/

DEFINE VARIABLE cMessageList                  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iNumTargets                   AS INTEGER      NO-UNDO.


IF RowObject.page_number < 1 OR RowObject.page_number = ? THEN
  ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
                        {af/sup2/aferrortxt.i 'AF' '1' 'rym_wizard_fold_page' 'page_number' "'page number'"}
                        .

IF  (LENGTH(RowObject.page_label) = 0
OR  LENGTH(RowObject.page_label) = ?)
AND RowObject.page_number > 0 THEN
  ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
                        {af/sup2/aferrortxt.i 'AF' '1' 'rym_wizard_fold_page' 'page_label' "'page label'"}
                        .

IF RowObject.viewer_object_name = ? THEN
  ASSIGN RowObject.viewer_object_name = "":U.
IF RowObject.browser_object_name = ? THEN
  ASSIGN RowObject.browser_object_name = "":U.
IF RowObject.sdo_object_name = ? THEN
  ASSIGN RowObject.sdo_object_name = "":U.
IF RowObject.parent_sdo_object_name = ? THEN
  ASSIGN RowObject.parent_sdo_object_name = "":U.

IF  (LENGTH(RowObject.browser_object_name) <> 0 
AND LENGTH(RowObject.sdo_object_name) = 0) THEN
  ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
                        {af/sup2/aferrortxt.i 'AF' '1' 'rym_wizard_fold_page' 'sdo_object_name' "'sdo object name'" "'You must specify an SDO object name if a browser is specified'"}
                        .

IF  (LENGTH(RowObject.parent_sdo_object_name) <> 0 
AND LENGTH(RowObject.sdo_object_name) = 0) THEN
  ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
                        {af/sup2/aferrortxt.i 'AF' '1' 'rym_wizard_fold_page' 'parent_sdo_object_name' "'sdo object name'" "'You must specify an SDO object name if a parent sdo is specified'"}
                        .

IF  (LENGTH(RowObject.parent_sdo_object_name) <> 0 
AND LENGTH(RowObject.sdo_foreign_fields) = 0) THEN
  ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
                        {af/sup2/aferrortxt.i 'AF' '1' 'rym_wizard_fold_page' 'parent_sdo_object_name' "'sdo foreign fields'" "'You must specify foreign fields if a parent sdo is specified'"}
                        .

IF  RowObject.link_viewer_to_sdo = YES 
AND LENGTH(RowObject.viewer_object_name) = 0 THEN
  ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
                        {af/sup2/aferrortxt.i 'AF' '1' 'rym_wizard_fold_page' 'link_viewer_to_sdo' "'viewer object name'" "'You must specify a viewer if you wish to link the viewer to an sdo'"}
                        .

IF (LENGTH(RowObject.viewer_toolbar_parent_menu) <> 0  
AND LENGTH(RowObject.viewer_object_name) = 0) THEN
  ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
                        {af/sup2/aferrortxt.i 'AF' '1' 'rym_wizard_fold_page' 'viewer_toolbar_parent_menu' "'viewer object name'" "'You must specify a viewer if you specify a viewer toolbar parent menu'"}
                        .

IF (LENGTH(RowObject.browser_toolbar_parent_menu) <> 0  
AND LENGTH(RowObject.browser_object_name) = 0) THEN
  ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
                        {af/sup2/aferrortxt.i 'AF' '1' 'rym_wizard_fold_page' 'browser_toolbar_parent_menu' "'browser object name'" "'You must specify a browser if you specify a browser toolbar parent menu'"}
                        .

IF (LENGTH(RowObject.browser_toolbar_parent_menu) = 0  
AND LENGTH(RowObject.browser_object_name) <> 0) THEN
  ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
                        {af/sup2/aferrortxt.i 'AF' '1' 'rym_wizard_fold_page' 'browser_object_name' "'browser toolbar parent menu'" "'You must specify a browser toolbar parent menu if you specify a browser object name'"}
                        .

IF  (LENGTH(RowObject.viewer_object_name) = 0 
AND LENGTH(RowObject.browser_object_name) = 0)
OR  (LENGTH(RowObject.viewer_object_name) = ?
AND LENGTH(RowObject.browser_object_name) = ?)
OR  (LENGTH(RowObject.viewer_object_name) = 0 
AND LENGTH(RowObject.browser_object_name) = ?)
OR  (LENGTH(RowObject.viewer_object_name) = ? 
AND LENGTH(RowObject.browser_object_name) = 0) THEN
  ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
                        {af/sup2/aferrortxt.i 'AF' '1' 'rym_wizard_fold_page' 'viewer_object_name' "'viewer object name or browser object name'"}
                        .

IF LENGTH(RowObject.sdo_foreign_fields) > 0 AND
   NUM-ENTRIES(RowObject.sdo_foreign_fields) MOD 2 <> 0 THEN
    ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
                           {af/sup2/aferrortxt.i 'AF' '5' 'rym_wizard_fold_page' 'sdo_foreign_fields' "'sdo foreign fields'" "'The SDO Foreign Fields must be a comma delimited list of field pair, child, parent, etc.'"}
                           .

IF LENGTH(RowObject.custom_super_procedure) > 0 AND
   NUM-ENTRIES(RowObject.custom_super_procedure,".":U) < 2 THEN
    ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
                           {af/sup2/aferrortxt.i 'AF' '5' 'rym_wizard_fold_page' 'custom_super_procedure' "'custom super procedure'" "'The custom super procedure specified should contain a path and extension'"}
                           .
IF RowObject.PRIMARY_viewer = YES AND
   (RowObject.viewer_object_name = "":U OR RowObject.viewer_object_name = ?) THEN
    ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
                           {af/sup2/aferrortxt.i 'AF' '5' 'rym_wizard_fold_page' 'primary_viewer' "'primary viewer'" "'The primary viewer can only be set when there is a viewer on the page.'"}
                           .

/* If only one update target is specified, it must match one of the data source names */
IF NUM-ENTRIES(RowObject.viewer_update_target_names) = 1 AND 
  LOOKUP(RowObject.viewer_update_target_names, RowObject.viewer_data_source_names) = 0 THEN
    ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
                          {af/sup2/aferrortxt.i 'AF' '121' 'rym_wizard_fold_page' 'viewer_update_target_names'}
                          .

/* If more than one update target is specified, all data source names must be specified as update targets and
   match exactly */                                                                                                   
IF NUM-ENTRIES(RowObject.viewer_update_target_names) > 1 THEN
DO:
  IF NUM-ENTRIES(RowObject.viewer_update_target_names) < NUM-ENTRIES(RowObject.viewer_data_source_names) OR
     NUM-ENTRIES(RowObject.viewer_update_target_names) > NUM-ENTRIES(RowObject.viewer_data_source_names)  THEN
    ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
                          {af/sup2/aferrortxt.i 'AF' '120' 'rym_wizard_fold_page' 'viewer_update_target_names'}
                          .
  TargetLoop:
  DO iNumTargets = 1 TO NUM-ENTRIES(RowObject.viewer_update_target_names):
    IF LOOKUP(ENTRY(iNumTargets, RowObject.viewer_update_target_names), RowObject.viewer_data_source) = 0 THEN
    DO:
      ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
                            {af/sup2/aferrortxt.i 'AF' '121' 'rym_wizard_fold_page' 'viewer_update_target_names'}
                            .
      LEAVE TargetLoop.
    END.  /* if lookup */
  END.  /* targetloop */
END.  /* if num-entries > 1 */

ASSIGN
    ERROR-STATUS:ERROR = NO.
RETURN cMessageList.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

