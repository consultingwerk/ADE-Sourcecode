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

&scop object-name       gsmssfullo.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataObject yes

{af/sup2/afglobals.i}

DEFINE VARIABLE gcOEM                                   AS CHARACTER                NO-UNDO.
DEFINE VARIABLE hHandle AS HANDLE     NO-UNDO.

DEFINE VARIABLE gdProductModuleObj AS DECIMAL    NO-UNDO.
DEFINE VARIABLE gdObjectObj        AS DECIMAL    NO-UNDO.
DEFINE VARIABLE gdAttributeObj     AS DECIMAL    NO-UNDO.
DEFINE VARIABLE gdOwningObj        AS DECIMAL    NO-UNDO.
DEFINE VARIABLE gdRowNum           AS INTEGER    NO-UNDO.
DEFINE VARIABLE gcEntity           AS CHARACTER  NO-UNDO.

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
&Scoped-define INTERNAL-TABLES gsm_security_structure gsc_product_module ~
ryc_smartobject gsc_instance_attribute

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  owning_entity_mnemonic owning_obj product_module_obj object_obj~
 instance_attribute_obj disabled
&Scoped-define ENABLED-FIELDS-IN-gsm_security_structure ~
owning_entity_mnemonic owning_obj product_module_obj object_obj ~
instance_attribute_obj disabled 
&Scoped-Define DATA-FIELDS  security_structure_obj owning_entity_mnemonic owning_obj product_module_obj~
 product_module_code product_module_display object_obj object_filename~
 object_filename_display instance_attribute_obj attribute_code~
 attribute_code_display disabled
&Scoped-define DATA-FIELDS-IN-gsm_security_structure security_structure_obj ~
owning_entity_mnemonic owning_obj product_module_obj object_obj ~
instance_attribute_obj disabled 
&Scoped-define DATA-FIELDS-IN-gsc_product_module product_module_code 
&Scoped-define DATA-FIELDS-IN-ryc_smartobject object_filename 
&Scoped-define DATA-FIELDS-IN-gsc_instance_attribute attribute_code 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "af/obj2/gsmssfullo.i"
&Scoped-define QUERY-STRING-Query-Main FOR EACH gsm_security_structure NO-LOCK, ~
      FIRST gsc_product_module WHERE asdb.gsc_product_module.product_module_obj = afdb.gsm_security_structure.product_module_obj OUTER-JOIN NO-LOCK, ~
      FIRST ryc_smartobject WHERE asdb.ryc_smartobject.smartobject_obj = afdb.gsm_security_structure.object_obj OUTER-JOIN NO-LOCK, ~
      FIRST gsc_instance_attribute WHERE asdb.gsc_instance_attribute.instance_attribute_obj = afdb.gsm_security_structure.instance_attribute_obj OUTER-JOIN NO-LOCK ~
    BY gsm_security_structure.owning_entity_mnemonic ~
       BY gsm_security_structure.owning_obj ~
        BY gsm_security_structure.product_module_obj ~
         BY gsm_security_structure.object_obj ~
          BY gsm_security_structure.instance_attribute_obj INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH gsm_security_structure NO-LOCK, ~
      FIRST gsc_product_module WHERE asdb.gsc_product_module.product_module_obj = afdb.gsm_security_structure.product_module_obj OUTER-JOIN NO-LOCK, ~
      FIRST ryc_smartobject WHERE asdb.ryc_smartobject.smartobject_obj = afdb.gsm_security_structure.object_obj OUTER-JOIN NO-LOCK, ~
      FIRST gsc_instance_attribute WHERE asdb.gsc_instance_attribute.instance_attribute_obj = afdb.gsm_security_structure.instance_attribute_obj OUTER-JOIN NO-LOCK ~
    BY gsm_security_structure.owning_entity_mnemonic ~
       BY gsm_security_structure.owning_obj ~
        BY gsm_security_structure.product_module_obj ~
         BY gsm_security_structure.object_obj ~
          BY gsm_security_structure.instance_attribute_obj INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main gsm_security_structure ~
gsc_product_module ryc_smartobject gsc_instance_attribute
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main gsm_security_structure
&Scoped-define SECOND-TABLE-IN-QUERY-Query-Main gsc_product_module
&Scoped-define THIRD-TABLE-IN-QUERY-Query-Main ryc_smartobject
&Scoped-define FOURTH-TABLE-IN-QUERY-Query-Main gsc_instance_attribute


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      gsm_security_structure, 
      gsc_product_module
    FIELDS(gsc_product_module.product_module_code), 
      ryc_smartobject
    FIELDS(ryc_smartobject.object_filename), 
      gsc_instance_attribute
    FIELDS(gsc_instance_attribute.attribute_code) SCROLLING.
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
         HEIGHT             = 1.71
         WIDTH              = 47.
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
     _TblList          = "icfdb.gsm_security_structure,icfdb.gsc_product_module WHERE icfdb.gsm_security_structure ...,icfdb.ryc_smartobject WHERE icfdb.gsm_security_structure ...,icfdb.gsc_instance_attribute WHERE icfdb.gsm_security_structure ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST OUTER USED, FIRST OUTER USED, FIRST OUTER USED"
     _OrdList          = "afdb.gsm_security_structure.owning_entity_mnemonic|yes,afdb.gsm_security_structure.owning_obj|yes,afdb.gsm_security_structure.product_module_obj|yes,afdb.gsm_security_structure.object_obj|yes,afdb.gsm_security_structure.instance_attribute_obj|yes"
     _JoinCode[2]      = "asdb.gsc_product_module.product_module_obj = afdb.gsm_security_structure.product_module_obj"
     _JoinCode[3]      = "asdb.ryc_smartobject.smartobject_obj = afdb.gsm_security_structure.object_obj"
     _JoinCode[4]      = "asdb.gsc_instance_attribute.instance_attribute_obj = afdb.gsm_security_structure.instance_attribute_obj"
     _FldNameList[1]   > icfdb.gsm_security_structure.security_structure_obj
"security_structure_obj" "security_structure_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 21 yes
     _FldNameList[2]   > icfdb.gsm_security_structure.owning_entity_mnemonic
"owning_entity_mnemonic" "owning_entity_mnemonic" ? ? "character" ? ? ? ? ? ? yes ? no 10 yes
     _FldNameList[3]   > icfdb.gsm_security_structure.owning_obj
"owning_obj" "owning_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21 yes
     _FldNameList[4]   > icfdb.gsm_security_structure.product_module_obj
"product_module_obj" "product_module_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21 yes
     _FldNameList[5]   > icfdb.gsc_product_module.product_module_code
"product_module_code" "product_module_code" ? ? "character" ? ? ? ? ? ? no ? no 20 yes
     _FldNameList[6]   > "_<CALC>"
"(IF product_module_obj = 0 THEN '<All>'
ELSE product_module_code)" "product_module_display" "Product Module Code" "x(10)" "character" ? ? ? ? ? ? no ? no 20.6 no
     _FldNameList[7]   > icfdb.gsm_security_structure.object_obj
"object_obj" "object_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21 yes
     _FldNameList[8]   > icfdb.ryc_smartobject.object_filename
"object_filename" "object_filename" ? ? "character" ? ? ? ? ? ? no ? no 35 yes
     _FldNameList[9]   > "_<CALC>"
"(IF object_obj = 0 THEN '<All>'
ELSE object_filename)" "object_filename_display" "Object Filename" "x(35)" "character" ? ? ? ? ? ? no ? no 35 no
     _FldNameList[10]   > icfdb.gsm_security_structure.instance_attribute_obj
"instance_attribute_obj" "instance_attribute_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21 yes
     _FldNameList[11]   > icfdb.gsc_instance_attribute.attribute_code
"attribute_code" "attribute_code" ? ? "character" ? ? ? ? ? ? no ? no 70 yes
     _FldNameList[12]   > "_<CALC>"
"(IF instance_attribute_obj = 0 THEN '<All>'
ELSE attribute_code)" "attribute_code_display" "Attribute Code" "x(35)" "character" ? ? ? ? ? ? no ? no 35 no
     _FldNameList[13]   > icfdb.gsm_security_structure.disabled
"disabled" "disabled" ? ? "logical" ? ? ? ? ? ? yes ? no 1 yes
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
         rowObject.attribute_code_display = ((IF instance_attribute_obj = 0 THEN '<All>'
ELSE attribute_code))
         rowObject.object_filename_display = ((IF object_obj = 0 THEN '<All>'
ELSE object_filename))
         rowObject.product_module_display = ((IF product_module_obj = 0 THEN '<All>'
ELSE product_module_code))
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject dTables 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       gsm_security_structure records can be defined for gsm_field,
               gsm_token, and gsn_range records.  The foreign fields and where
               clause need to be set appropriately based on the what we are 
               defining gsm_security_structure records for (DataSource).
------------------------------------------------------------------------------*/
DEFINE VARIABLE hDataSource    AS HANDLE       NO-UNDO.
DEFINE VARIABLE cForeignFields AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cObjField      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cValueList     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cWhere         AS CHARACTER    NO-UNDO.

  {get DataSource hDataSource}.

  IF VALID-HANDLE(hDataSource) THEN 
  DO:

    /* Get Table FLA and name of the primary key for the Data Source table */
    ASSIGN cValueList = DYNAMIC-FUNCTION('getTableInfo':U IN hDataSource).

    IF LENGTH(TRIM(cValueList)) > 0 THEN
    DO:
      ASSIGN gcOEM            = ENTRY(1, cValueList, CHR(3))
             cObjField        = ENTRY(2, cValueList, CHR(3))
             cForeignFields   = "gsm_security_structure.owning_obj,":U + cObjField
             cWhere           = "gsm_security_structure.owning_entity_mnemonic = '":U
                                 + gcOEM + "'":U.
      {set ForeignFields cForeignFields}.
    END.    /* there is data */

    IF cWhere <> "":U THEN
    DO:
      DYNAMIC-FUNCTION("addQueryWhere":U, INPUT cWhere, ?, "AND":U).
      {set manualAddQueryWhere cWhere}.
    END.    /* new WHERE clause is only included when there are valid attributes */

  END.  /* if valid hDataSource */

  RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE preTransactionValidate dTables  _DB-REQUIRED
PROCEDURE preTransactionValidate :
/*------------------------------------------------------------------------------
  Purpose:     Procedure used to validate RowObjUpd records server-side
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE cMessageList    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cValueList      AS CHARACTER    NO-UNDO.

  FOR EACH RowObjUpd WHERE CAN-DO('A,C,U':U,RowObjUpd.RowMod):

      IF RowObjUpd.product_module_obj     = ? THEN RowObjUpd.product_module_obj = 0.
      IF RowObjUpd.object_obj             = ? THEN RowObjUpd.object_obj = 0.
      IF RowObjUpd.instance_attribute_obj = ? THEN RowObjUpd.instance_attribute_obj = 0. 

      IF (RowObjUpd.RowMod = 'U':U AND
        CAN-FIND(FIRST gsm_security_structure
          WHERE gsm_security_structure.owning_entity_mnemonic = rowObjUpd.owning_entity_mnemonic
            AND gsm_security_structure.owning_obj = rowObjUpd.owning_obj
            AND gsm_security_structure.product_module_obj = rowObjUpd.product_module_obj
            AND gsm_security_structure.object_obj = rowObjUpd.object_obj
            AND gsm_security_structure.instance_attribute_obj = rowObjUpd.instance_attribute_obj
            AND ROWID(gsm_security_structure) <> TO-ROWID(ENTRY(1,RowObjUpd.RowIDent))))
      OR (RowObjUpd.RowMod <> 'U':U AND
        CAN-FIND(FIRST gsm_security_structure
          WHERE gsm_security_structure.owning_entity_mnemonic = rowObjUpd.owning_entity_mnemonic
            AND gsm_security_structure.owning_obj = rowObjUpd.owning_obj
            AND gsm_security_structure.product_module_obj = rowObjUpd.product_module_obj
            AND gsm_security_structure.object_obj = rowObjUpd.object_obj
            AND gsm_security_structure.instance_attribute_obj = rowObjUpd.instance_attribute_obj)) THEN
          ASSIGN cValueList   = STRING(RowObjUpd.owning_entity_mnemonic) + ', ' + STRING(RowObjUpd.owning_obj) + ', ' + STRING(RowObjUpd.product_module_obj) + ', ' + STRING(RowObjUpd.object_obj) + ', ' + STRING(RowObjUpd.instance_attribute_obj)
                 cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                                {af/sup2/aferrortxt.i 'AF' '8' 'gsm_security_structure' '' "'owning_entity_mnemonic, owning_obj, product_module_obj, object_obj, instance_attribute_obj, '" cValueList }.
  END.

  ERROR-STATUS:ERROR = NO.
  RETURN cMessageList.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowObjectValidate dTables 
PROCEDURE rowObjectValidate :
/*------------------------------------------------------------------------------
  Purpose:     Procedure used to validate RowObject record client-side
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cMessageList    AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cValueList      AS CHARACTER    NO-UNDO.

  IF LENGTH(RowObject.owning_entity_mnemonic) = 0 OR LENGTH(RowObject.owning_entity_mnemonic) = ? AND gcOEM <> '':U THEN
    ASSIGN RowObject.owning_entity_mnemonic = gcOEM.

  ERROR-STATUS:ERROR = NO.
  RETURN cMessageList.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

