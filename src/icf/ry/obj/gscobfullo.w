&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          asdb             PROGRESS
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
  File: gscobfullo.w

  Description:  Object SDO

  Purpose:      Object SDO

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        6517   UserRef:    
                Date:   03/10/2000  Author:     Jenny Bond

  Update Notes: Created from Template rysttasdoo.w.

  (v:010001)    Task:        6962   UserRef:    
                Date:   14/11/2000  Author:     Jenny Bond

  Update Notes: Procedures to read/update objects

--------------------------------------------------------------------------------*/
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

&scop object-name       gscobfullo.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010100

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
&Scoped-define INTERNAL-TABLES gsc_object

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  container_object disabled generic_object logical_object object_description~
 object_filename object_obj object_path object_type_obj physical_object_obj~
 product_module_obj required_db_list runnable_from_menu run_persistent~
 run_when security_object_obj toolbar_image_filename toolbar_multi_media_obj~
 tooltip_text
&Scoped-define ENABLED-FIELDS-IN-gsc_object container_object disabled ~
generic_object logical_object object_description object_filename object_obj ~
object_path object_type_obj physical_object_obj product_module_obj ~
required_db_list runnable_from_menu run_persistent run_when ~
security_object_obj toolbar_image_filename toolbar_multi_media_obj ~
tooltip_text 
&Scoped-Define DATA-FIELDS  container_object disabled generic_object logical_object object_description~
 object_filename object_obj object_path object_type_obj physical_object_obj~
 product_module_obj required_db_list runnable_from_menu run_persistent~
 run_when security_object_obj toolbar_image_filename toolbar_multi_media_obj~
 tooltip_text
&Scoped-define DATA-FIELDS-IN-gsc_object container_object disabled ~
generic_object logical_object object_description object_filename object_obj ~
object_path object_type_obj physical_object_obj product_module_obj ~
required_db_list runnable_from_menu run_persistent run_when ~
security_object_obj toolbar_image_filename toolbar_multi_media_obj ~
tooltip_text 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE Astra
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "ry/obj/gscobfullo.i"
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH gsc_object NO-LOCK INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main gsc_object
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main gsc_object


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      gsc_object SCROLLING.
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
   Partition: Astra
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
         WIDTH              = 65.4.
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
     _TblList          = "asdb.gsc_object"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > asdb.gsc_object.container_object
"container_object" "container_object" ? ? "logical" ? ? ? ? ? ? yes ? no 15.8 yes
     _FldNameList[2]   > asdb.gsc_object.disabled
"disabled" "disabled" ? ? "logical" ? ? ? ? ? ? yes ? no 8.2 yes
     _FldNameList[3]   > asdb.gsc_object.generic_object
"generic_object" "generic_object" ? ? "logical" ? ? ? ? ? ? yes ? no 14.2 yes
     _FldNameList[4]   > asdb.gsc_object.logical_object
"logical_object" "logical_object" ? ? "logical" ? ? ? ? ? ? yes ? no 13.6 yes
     _FldNameList[5]   > asdb.gsc_object.object_description
"object_description" "object_description" ? ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[6]   > asdb.gsc_object.object_filename
"object_filename" "object_filename" ? ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[7]   > asdb.gsc_object.object_obj
"object_obj" "object_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21.6 yes
     _FldNameList[8]   > asdb.gsc_object.object_path
"object_path" "object_path" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[9]   > asdb.gsc_object.object_type_obj
"object_type_obj" "object_type_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21.6 yes
     _FldNameList[10]   > asdb.gsc_object.physical_object_obj
"physical_object_obj" "physical_object_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21.6 yes
     _FldNameList[11]   > asdb.gsc_object.product_module_obj
"product_module_obj" "product_module_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21.6 yes
     _FldNameList[12]   > asdb.gsc_object.required_db_list
"required_db_list" "required_db_list" ? ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[13]   > asdb.gsc_object.runnable_from_menu
"runnable_from_menu" "runnable_from_menu" ? ? "logical" ? ? ? ? ? ? yes ? no 20.4 yes
     _FldNameList[14]   > asdb.gsc_object.run_persistent
"run_persistent" "run_persistent" ? ? "logical" ? ? ? ? ? ? yes ? no 13.8 yes
     _FldNameList[15]   > asdb.gsc_object.run_when
"run_when" "run_when" ? ? "character" ? ? ? ? ? ? yes ? no 10.4 yes
     _FldNameList[16]   > asdb.gsc_object.security_object_obj
"security_object_obj" "security_object_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21.6 yes
     _FldNameList[17]   > asdb.gsc_object.toolbar_image_filename
"toolbar_image_filename" "toolbar_image_filename" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[18]   > asdb.gsc_object.toolbar_multi_media_obj
"toolbar_multi_media_obj" "toolbar_multi_media_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 22.4 yes
     _FldNameList[19]   > asdb.gsc_object.tooltip_text
"tooltip_text" "tooltip_text" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE postTransactionValidate dTables 
PROCEDURE postTransactionValidate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ERROR-STATUS:ERROR = NO.
RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE preTransactionValidate dTables  _DB-REQUIRED
PROCEDURE preTransactionValidate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cMessageList                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cText                         AS CHARACTER  NO-UNDO.

FOR EACH RowObjUpd WHERE LOOKUP(RowObjUpd.RowMod,"A,C,U":U) <> 0:

    IF LENGTH(RowObjUpd.object_filename) = 0 THEN
      ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
                            {af/sup2/aferrortxt.i 'AF' '1' 'gsc_object' 'object_filename' "'object file name'"}
                            .
    IF LENGTH(RowObjUpd.object_description) = 0 THEN
      ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
                            {af/sup2/aferrortxt.i 'AF' '1' 'gsc_object' 'object_description' "'object description'"}
                            .
    /* ensure object file name specified is unique */
    IF (RowObjUpd.RowMod = "U":U
    AND CAN-FIND(FIRST gsc_object
        WHERE gsc_object.object_filename = RowObjUpd.object_filename
        AND   ROWID(gsc_object) <> TO-ROWID(ENTRY(1, RowObjUpd.ROWIDent))))
    OR    (RowObjUpd.RowMod <> "U":U
    AND CAN-FIND(FIRST gsc_object
        WHERE gsc_object.object_filename = RowObjUpd.object_filename))  THEN
        ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
               {af/sup2/aferrortxt.i 'AF' '8' 'gsc_object' 'object_filename' "'object file name'" RowObjUpd.object_filename "'. Please use a different object name'"}
               .
    /* ensure object type is valid */
    IF NOT CAN-FIND(FIRST gsc_object_type
        WHERE gsc_object_type.object_type_obj = RowObjUpd.object_type_obj) THEN DO:
            ASSIGN
                cText = ". The product module object: " + STRING(rowObjUpd.product_module_obj) + " does not exist.".  
            ASSIGN
                cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
                {af/sup2/aferrortxt.i 'AF' '5' 'gsc_object' 'product_module_obj' "'product module obj'" cText}
                .
    END.
    /* ensure product module is valid */
    IF NOT CAN-FIND(FIRST gsc_product_module
        WHERE gsc_product_module.product_module_obj = RowObjUpd.product_module_obj) THEN DO:
        ASSIGN
            cText = ". The product module object " + STRING(rowObjUpd.product_module_obj) + " does not exist.".  
        ASSIGN
            cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
            {af/sup2/aferrortxt.i 'AF' '5' 'gsc_object' 'product_module_obj' "'product module obj'" cText}
            .
    END.
    /* ensure security object is valid */
    IF  RowObjUpd.security_object_obj > 0
    AND NOT CAN-FIND(FIRST gsc_object
        WHERE gsc_object.object_obj = RowObjUpd.security_object_obj) THEN DO:
        ASSIGN
            cText = ". The security object " + STRING(RowObjUpd.security_object_obj) + " does not exist.".  
        ASSIGN
            cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
            {af/sup2/aferrortxt.i 'AF' '5' 'gsc_object' 'security_object_obj' "'security object obj'" cText}
            .
    END.
    /* ensure security object is valid */
    IF  RowObjUpd.physical_object_obj > 0
    AND NOT CAN-FIND(FIRST gsc_object
        WHERE gsc_object.object_obj = RowObjUpd.physical_object_obj) THEN DO:
        ASSIGN
            cText = ". The physical object " + STRING(RowObjUpd.physical_object_obj) + " does not exist.".  
        ASSIGN
            cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
            {af/sup2/aferrortxt.i 'AF' '5' 'gsc_object' 'physical_object_obj' "'physical object obj'" cText}
            .
    END.
    /* If logical object, must have physical object */
    IF  rowobjUpd.logical_object
    AND RowObjUpd.physical_object_obj = 0 THEN DO:
        ASSIGN
            cText = ". Please enter a physical object for this logical object".  
        ASSIGN
            cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
            {af/sup2/aferrortxt.i 'AF' '5' 'gsc_object' 'physical_object_obj' "'physical object obj'" cText}
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
DEFINE VARIABLE cMessageList            AS CHARACTER    NO-UNDO.

IF RowObject.product_module_obj = 0 THEN
    ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
                        {af/sup2/aferrortxt.i 'AF' '1' 'gsc_object' 'product_module_obj' "'product module code'"}
                        .
IF RowObject.object_type_obj = 0 THEN
    ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
                        {af/sup2/aferrortxt.i 'AF' '1' 'gsc_object' 'object_type_obj' "'object type code'"}
                        .
IF LENGTH(RowObject.object_filename) = 0 THEN
  ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
                        {af/sup2/aferrortxt.i 'AF' '1' 'gsc_object' 'object_filename' "'object file name'"}
                        .
IF LENGTH(RowObject.object_description) = 0 THEN
  ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
                        {af/sup2/aferrortxt.i 'AF' '1' 'gsc_object' 'object_description' "'object description'"}
                        .
RETURN cMessageList.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

