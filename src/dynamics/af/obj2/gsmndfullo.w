&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}
DEFINE VARIABLE h_Astra                    AS HANDLE          NO-UNDO.
DEFINE VARIABLE h_Astra2                   AS HANDLE          NO-UNDO.
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


/* Temp-Table and Buffer definitions                                    */
/* Db-Required definitions. */
&IF DEFINED(DB-REQUIRED) = 0 &THEN
    &GLOBAL-DEFINE DB-REQUIRED TRUE
&ENDIF
&GLOBAL-DEFINE DB-REQUIRED-START   &IF {&DB-REQUIRED} &THEN
&GLOBAL-DEFINE DB-REQUIRED-END     &ENDIF


{&DB-REQUIRED-START}
 DEFINE BUFFER buff_gsm_node FOR gsm_node.
{&DB-REQUIRED-END}


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS dTables 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: rysttasdoo.w

  Description:  Template Astra 2 SmartDataObject Template

  Purpose:      Template Astra 2 SmartDataObject Template

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        6180   UserRef:    
                Date:   28/06/2000  Author:     Anthony Swindells

  Update Notes: V9 Templates

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

&scop object-name       gsmndfullo.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataObject yes

{af/sup2/afglobals.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Global-define DATA-LOGIC-PROCEDURE af/obj2/gsmndlogcp.p

&Scoped-define PROCEDURE-TYPE SmartDataObject
&Scoped-define DB-AWARE yes

&Scoped-define ADM-SUPPORTED-LINKS Data-Source,Data-Target,Navigation-Target,Update-Target,Commit-Target,Filter-Target


/* Note that Db-Required is defined before the buffer definitions for this object. */

&Scoped-define QUERY-NAME Query-Main

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES gsm_node

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  node_code node_description parent_node_obj node_label node_checked~
 data_source_type data_source primary_sdo logical_object run_attribute~
 fields_to_store node_text_label_expression label_text_substitution_fields~
 foreign_fields image_file_name selected_image_file_name cMenuStructureCode~
 child_field cSDODataSource data_type parent_field parent_node_filter~
 structured_node
&Scoped-define ENABLED-FIELDS-IN-gsm_node node_code node_description ~
parent_node_obj node_label node_checked data_source_type data_source ~
primary_sdo logical_object run_attribute fields_to_store ~
node_text_label_expression label_text_substitution_fields foreign_fields ~
image_file_name selected_image_file_name child_field data_type parent_field ~
parent_node_filter structured_node 
&Scoped-Define DATA-FIELDS  node_obj node_code node_description parent_node_obj node_label node_checked~
 data_source_type data_source primary_sdo logical_object run_attribute~
 fields_to_store node_text_label_expression label_text_substitution_fields~
 foreign_fields image_file_name selected_image_file_name cMenuStructureCode~
 child_field cSDODataSource data_type parent_field parent_node_filter~
 structured_node
&Scoped-define DATA-FIELDS-IN-gsm_node node_obj node_code node_description ~
parent_node_obj node_label node_checked data_source_type data_source ~
primary_sdo logical_object run_attribute fields_to_store ~
node_text_label_expression label_text_substitution_fields foreign_fields ~
image_file_name selected_image_file_name child_field data_type parent_field ~
parent_node_filter structured_node 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "af/obj2/gsmndfullo.i"
&Scoped-define QUERY-STRING-Query-Main FOR EACH gsm_node NO-LOCK ~
    BY gsm_node.node_code INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH gsm_node NO-LOCK ~
    BY gsm_node.node_code INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main gsm_node
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main gsm_node


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getParentNode dTables  _DB-REQUIRED
FUNCTION getParentNode RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}


/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      gsm_node SCROLLING.
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
   Temp-Tables and Buffers:
      TABLE: buff_gsm_node B "?" ? ICFDB gsm_node
   END-TABLES.
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
     _TblList          = "ICFDB.gsm_node"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "ICFDB.gsm_node.node_code|yes"
     _FldNameList[1]   > icfdb.gsm_node.node_obj
"node_obj" "node_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 21 yes
     _FldNameList[2]   > icfdb.gsm_node.node_code
"node_code" "node_code" ? ? "character" ? ? ? ? ? ? yes ? no 20 yes
     _FldNameList[3]   > icfdb.gsm_node.node_description
"node_description" "node_description" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[4]   > icfdb.gsm_node.parent_node_obj
"parent_node_obj" "parent_node_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21 yes
     _FldNameList[5]   > icfdb.gsm_node.node_label
"node_label" "node_label" ? ? "character" ? ? ? ? ? ? yes ? no 56 yes
     _FldNameList[6]   > icfdb.gsm_node.node_checked
"node_checked" "node_checked" ? ? "logical" ? ? ? ? ? ? yes ? no 1 yes
     _FldNameList[7]   > icfdb.gsm_node.data_source_type
"data_source_type" "data_source_type" ? ? "character" ? ? ? ? ? ? yes ? no 6 yes
     _FldNameList[8]   > icfdb.gsm_node.data_source
"data_source" "data_source" ? ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[9]   > icfdb.gsm_node.primary_sdo
"primary_sdo" "primary_sdo" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[10]   > icfdb.gsm_node.logical_object
"logical_object" "logical_object" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[11]   > icfdb.gsm_node.run_attribute
"run_attribute" "run_attribute" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[12]   > icfdb.gsm_node.fields_to_store
"fields_to_store" "fields_to_store" ? ? "character" ? ? ? ? ? ? yes ? no 140 yes
     _FldNameList[13]   > icfdb.gsm_node.node_text_label_expression
"node_text_label_expression" "node_text_label_expression" ? ? "character" ? ? ? ? ? ? yes ? no 140 yes
     _FldNameList[14]   > icfdb.gsm_node.label_text_substitution_fields
"label_text_substitution_fields" "label_text_substitution_fields" ? ? "character" ? ? ? ? ? ? yes ? no 140 yes
     _FldNameList[15]   > icfdb.gsm_node.foreign_fields
"foreign_fields" "foreign_fields" ? ? "character" ? ? ? ? ? ? yes ? no 140 yes
     _FldNameList[16]   > icfdb.gsm_node.image_file_name
"image_file_name" "image_file_name" ? ? "character" ? ? ? ? ? ? yes ? no 140 yes
     _FldNameList[17]   > icfdb.gsm_node.selected_image_file_name
"selected_image_file_name" "selected_image_file_name" ? ? "character" ? ? ? ? ? ? yes ? no 140 yes
     _FldNameList[18]   > "_<CALC>"
"RowObject.data_source" "cMenuStructureCode" "Menu Structure" "x(35)" "character" ? ? ? ? ? ? yes ? no 35 no
     _FldNameList[19]   > ICFDB.gsm_node.child_field
"child_field" "child_field" ? ? "character" ? ? ? ? ? ? yes ? no 35 no
     _FldNameList[20]   > "_<CALC>"
"RowObject.data_source" "cSDODataSource" "Data Source" "x(35)" "character" ? ? ? ? ? ? yes ? no 35 no
     _FldNameList[21]   > ICFDB.gsm_node.data_type
"data_type" "data_type" ? ? "character" ? ? ? ? ? ? yes ? no 10 no
     _FldNameList[22]   > ICFDB.gsm_node.parent_field
"parent_field" "parent_field" ? ? "character" ? ? ? ? ? ? yes ? no 35 no
     _FldNameList[23]   > ICFDB.gsm_node.parent_node_filter
"parent_node_filter" "parent_node_filter" ? ? "character" ? ? ? ? ? ? yes ? no 70 no
     _FldNameList[24]   > ICFDB.gsm_node.structured_node
"structured_node" "structured_node" ? ? "logical" ? ? ? ? ? ? yes ? no 15.2 no
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
         rowObject.cMenuStructureCode = (RowObject.data_source)
         rowObject.cSDODataSource = (RowObject.data_source)
      .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

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

/* ************************  Function Implementations ***************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getParentNode dTables  _DB-REQUIRED
FUNCTION getParentNode RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER buNode FOR gsm_node.
  
  FIND FIRST buNode
       WHERE buNode.node_obj = gsm_node.parent_node_obj
       NO-LOCK NO-ERROR.
  IF AVAILABLE buNode THEN
    RETURN buNode.node_code.
  ELSE
    RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

