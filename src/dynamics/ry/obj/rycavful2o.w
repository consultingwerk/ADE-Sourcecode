&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
/* Procedure Description
"Astra 2 Static SmartDataObject Template with wizard.

Use this template to create a new Astra 2 SmartDataObject with the assistance of the SmartDataObject Wizard. When completed, this object can be drawn onto any 'smart' container such as a SmartWindow, SmartDialog or SmartFrame. Non-smart objects, such as web objects, can also access a SmartDataObject by running it persistently and calling its methods."
*/
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS dTables 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: rycavful2o.w

  Description:  Attribute Value Full SDO

  Purpose:      Attribute Value Full SDO

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        7754   UserRef:    
                Date:   29/01/2001  Author:     Anthony Swindells

  Update Notes: Attribute Groups Maintenance

  (v:010002)    Task:        7754   UserRef:    
                Date:   29/01/2001  Author:     Anthony Swindells

  Update Notes: Attribute Value Maintenance

-------------------------------------------------------------------*/
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

&scop object-name       rycavful2o.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataObject yes

{af/sup2/afglobals.i}
{af/app/afdatatypi.i}

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
&Scoped-define INTERNAL-TABLES ryc_attribute_value gsc_object_type ~
ryc_smartobject ryc_object_instance ryc_attribute ryc_attribute_group

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  constant_value attribute_label container_smartobject_obj~
 object_instance_obj object_type_obj primary_smartobject_obj smartobject_obj~
 character_value date_value decimal_value integer_value logical_value~
 raw_value
&Scoped-define ENABLED-FIELDS-IN-ryc_attribute_value constant_value ~
attribute_label container_smartobject_obj object_instance_obj ~
object_type_obj primary_smartobject_obj smartobject_obj character_value ~
date_value decimal_value integer_value logical_value raw_value 
&Scoped-Define DATA-FIELDS  object_type_code instance_object_filename object_filename constant_value~
 attribute_group_name attribute_label AttributeValue~
 container_smartobject_obj object_instance_obj object_type_obj~
 primary_smartobject_obj smartobject_obj attribute_value_obj layout_position~
 character_value date_value decimal_value integer_value logical_value~
 raw_value lContainer data_type cContainedObject
&Scoped-define DATA-FIELDS-IN-ryc_attribute_value constant_value ~
attribute_label container_smartobject_obj object_instance_obj ~
object_type_obj primary_smartobject_obj smartobject_obj attribute_value_obj ~
character_value date_value decimal_value integer_value logical_value ~
raw_value 
&Scoped-define DATA-FIELDS-IN-gsc_object_type object_type_code 
&Scoped-define DATA-FIELDS-IN-ryc_smartobject object_filename 
&Scoped-define DATA-FIELDS-IN-ryc_object_instance layout_position 
&Scoped-define DATA-FIELDS-IN-ryc_attribute data_type 
&Scoped-define DATA-FIELDS-IN-ryc_attribute_group attribute_group_name 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "ry/obj/rycavful2o.i"
&Scoped-define QUERY-STRING-Query-Main FOR EACH ryc_attribute_value NO-LOCK, ~
      FIRST gsc_object_type WHERE gsc_object_type.object_type_obj = ryc_attribute_value.object_type_obj NO-LOCK, ~
      FIRST ryc_smartobject WHERE TRUE /* Join to ryc_attribute_value incomplete */ NO-LOCK, ~
      FIRST ryc_object_instance WHERE ryc_smartobject.smartobject_obj = ryc_attribute_value.primary_smartobject_obj OUTER-JOIN NO-LOCK, ~
      FIRST ryc_attribute WHERE ryc_object_instance.container_smartobject_obj = ryc_attribute_value.container_smartobject_obj ~
  AND  ryc_object_instance.object_instance_obj = ryc_attribute_value.object_instance_obj OUTER-JOIN NO-LOCK, ~
      FIRST ryc_attribute_group WHERE ryc_attribute_group.attribute_group_obj = ryc_attribute.attribute_group_obj NO-LOCK ~
    BY ryc_attribute_value.attribute_group_obj ~
       BY ryc_attribute_value.attribute_type_tla ~
        BY ryc_attribute_value.attribute_label INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH ryc_attribute_value NO-LOCK, ~
      FIRST gsc_object_type WHERE gsc_object_type.object_type_obj = ryc_attribute_value.object_type_obj NO-LOCK, ~
      FIRST ryc_smartobject WHERE TRUE /* Join to ryc_attribute_value incomplete */ NO-LOCK, ~
      FIRST ryc_object_instance WHERE ryc_smartobject.smartobject_obj = ryc_attribute_value.primary_smartobject_obj OUTER-JOIN NO-LOCK, ~
      FIRST ryc_attribute WHERE ryc_object_instance.container_smartobject_obj = ryc_attribute_value.container_smartobject_obj ~
  AND  ryc_object_instance.object_instance_obj = ryc_attribute_value.object_instance_obj OUTER-JOIN NO-LOCK, ~
      FIRST ryc_attribute_group WHERE ryc_attribute_group.attribute_group_obj = ryc_attribute.attribute_group_obj NO-LOCK ~
    BY ryc_attribute_value.attribute_group_obj ~
       BY ryc_attribute_value.attribute_type_tla ~
        BY ryc_attribute_value.attribute_label INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main ryc_attribute_value ~
gsc_object_type ryc_smartobject ryc_object_instance ryc_attribute ~
ryc_attribute_group
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main ryc_attribute_value
&Scoped-define SECOND-TABLE-IN-QUERY-Query-Main gsc_object_type
&Scoped-define THIRD-TABLE-IN-QUERY-Query-Main ryc_smartobject
&Scoped-define FOURTH-TABLE-IN-QUERY-Query-Main ryc_object_instance
&Scoped-define FIFTH-TABLE-IN-QUERY-Query-Main ryc_attribute
&Scoped-define SIXTH-TABLE-IN-QUERY-Query-Main ryc_attribute_group


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD containedObjectName dTables  _DB-REQUIRED
FUNCTION containedObjectName RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD containerObject dTables 
FUNCTION containerObject RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAttributeValue dTables  _DB-REQUIRED
FUNCTION getAttributeValue RETURNS CHARACTER
  ( pcDataType AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInstanceFileName dTables  _DB-REQUIRED
FUNCTION getInstanceFileName RETURNS CHARACTER
  ( INPUT pdObjectInstanceObj AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}


/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      ryc_attribute_value, 
      gsc_object_type, 
      ryc_smartobject, 
      ryc_object_instance, 
      ryc_attribute, 
      ryc_attribute_group SCROLLING.
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
         WIDTH              = 59.6.
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
     _TblList          = "ICFDB.ryc_attribute_value,ICFDB.gsc_object_type WHERE ICFDB.ryc_attribute_value ...,ICFDB.ryc_smartobject WHERE ICFDB.ryc_attribute_value ...,ICFDB.ryc_object_instance WHERE ICFDB.ryc_attribute_value ...,ICFDB.ryc_attribute WHERE ICFDB.ryc_attribute_value ...,ICFDB.ryc_attribute_group WHERE ICFDB.ryc_attribute ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST, FIRST, FIRST OUTER, FIRST OUTER, FIRST"
     _OrdList          = "ICFDB.ryc_attribute_value.attribute_group_obj|yes,ICFDB.ryc_attribute_value.attribute_type_tla|yes,ICFDB.ryc_attribute_value.attribute_label|yes"
     _JoinCode[2]      = "ICFDB.gsc_object_type.object_type_obj = ICFDB.ryc_attribute_value.object_type_obj"
     _JoinCode[4]      = "ICFDB.ryc_smartobject.smartobject_obj = ICFDB.ryc_attribute_value.primary_smartobject_obj"
     _JoinCode[5]      = "ICFDB.ryc_object_instance.container_smartobject_obj = ICFDB.ryc_attribute_value.container_smartobject_obj
  AND  ICFDB.ryc_object_instance.object_instance_obj = ICFDB.ryc_attribute_value.object_instance_obj"
     _JoinCode[6]      = "ryc_attribute_group.attribute_group_obj = ryc_attribute.attribute_group_obj"
     _FldNameList[1]   > ICFDB.gsc_object_type.object_type_code
"object_type_code" "object_type_code" ? ? "character" ? ? ? ? ? ? no ? no 17.2 yes
     _FldNameList[2]   > "_<CALC>"
"getInstanceFileName(RowObject.object_instance_obj)" "instance_object_filename" "Instance Filename" "x(20)" "character" ? ? ? ? ? ? no ? no 20 no
     _FldNameList[3]   > ICFDB.ryc_smartobject.object_filename
"object_filename" "object_filename" ? ? "character" ? ? ? ? ? ? no ? no 70 yes
     _FldNameList[4]   > ICFDB.ryc_attribute_value.constant_value
"constant_value" "constant_value" ? ? "logical" ? ? ? ? ? ? yes ? no 14.4 yes
     _FldNameList[5]   > ICFDB.ryc_attribute_group.attribute_group_name
"attribute_group_name" "attribute_group_name" ? ? "character" ? ? ? ? ? ? no ? no 28 yes
     _FldNameList[6]   > ICFDB.ryc_attribute_value.attribute_label
"attribute_label" "attribute_label" ? ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[7]   > "_<CALC>"
"getAttributeValue(RowObject.data_type)" "AttributeValue" "Attribute Value" "x(70)" "character" ? ? ? ? ? ? no ? no 70 no
     _FldNameList[8]   > ICFDB.ryc_attribute_value.container_smartobject_obj
"container_smartobject_obj" "container_smartobject_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 25 yes
     _FldNameList[9]   > ICFDB.ryc_attribute_value.object_instance_obj
"object_instance_obj" "object_instance_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21.6 yes
     _FldNameList[10]   > ICFDB.ryc_attribute_value.object_type_obj
"object_type_obj" "object_type_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21.6 yes
     _FldNameList[11]   > ICFDB.ryc_attribute_value.primary_smartobject_obj
"primary_smartobject_obj" "primary_smartobject_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 22.8 yes
     _FldNameList[12]   > ICFDB.ryc_attribute_value.smartobject_obj
"smartobject_obj" "smartobject_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21.6 yes
     _FldNameList[13]   > ICFDB.ryc_attribute_value.attribute_value_obj
"attribute_value_obj" "attribute_value_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 21.6 yes
     _FldNameList[14]   > ICFDB.ryc_object_instance.layout_position
"layout_position" "layout_position" ? ? "character" ? ? ? ? ? ? no ? no 15 yes
     _FldNameList[15]   > ICFDB.ryc_attribute_value.character_value
"character_value" "character_value" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[16]   > ICFDB.ryc_attribute_value.date_value
"date_value" "date_value" ? ? "date" ? ? ? ? ? ? yes ? no 11.6 yes
     _FldNameList[17]   > ICFDB.ryc_attribute_value.decimal_value
"decimal_value" "decimal_value" ? ? "decimal" ? ? ? ? ? ? yes ? no 19.8 yes
     _FldNameList[18]   > ICFDB.ryc_attribute_value.integer_value
"integer_value" "integer_value" ? ? "integer" ? ? ? ? ? ? yes ? no 12.6 yes
     _FldNameList[19]   > ICFDB.ryc_attribute_value.logical_value
"logical_value" "logical_value" ? ? "logical" ? ? ? ? ? ? yes ? no 12.8 yes
     _FldNameList[20]   > ICFDB.ryc_attribute_value.raw_value
"raw_value" "raw_value" ? ? "raw" ? ? ? ? ? ? yes ? no 10.4 yes
     _FldNameList[21]   > "_<CALC>"
"containerObject()" "lContainer" "Container" "YES/NO" "Logical" ? ? ? ? ? ? no ? no 9 no
     _FldNameList[22]   > ICFDB.ryc_attribute.data_type
"data_type" "data_type" ? ? "integer" ? ? ? ? ? ? no ? no 10 yes
     _FldNameList[23]   > "_<CALC>"
"containedObjectName()" "cContainedObject" "Contained Object" "x(70)" "character" ? ? ? ? ? ? no ? no 70 no
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
         rowObject.AttributeValue = (getAttributeValue(RowObject.data_type))
         rowObject.cContainedObject = (containedObjectName())
         rowObject.instance_object_filename = (getInstanceFileName(RowObject.object_instance_obj))
         rowObject.lContainer = (containerObject())
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cFields         AS CHARACTER    NO-UNDO INITIAL "":U.
    DEFINE VARIABLE cEntityMnemonic AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE hDataSource     AS HANDLE       NO-UNDO.

    /* Code placed here will execute PRIOR to standard behavior. */

    {get DataSource hDataSource}.

    IF VALID-HANDLE(hDataSource) THEN DO:
        cEntityMnemonic = DYNAMIC-FUNCTION("getUserProperty":U IN hDataSource, INPUT "owningEntityMnemonic").

        CASE cEntityMnemonic:
            WHEN "GSCOT":U THEN
                ASSIGN 
                    cFields = "ryc_attribute_value.object_type_obj,object_type_obj".

            WHEN "RYCAT":U THEN
                ASSIGN
                    cFields = "ryc_attribute_value.attribute_group,attribute_group" + CHR(3) + 
                              "ryc_attribute_value.attribute_label,attribute_label" + CHR(3) +
                              "ryc_attribute_value.attribute_type_tla,attribute_type_tla".
            WHEN "RYCSO":U THEN
                ASSIGN
                    cFields = "ryc_attribute_value.smartobject_obj,smartobject_obj".
        END CASE.

        IF  cFields <> "" THEN
            {set ForeignFields cFields}.
    END.

    RUN SUPER.

    /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE noTreeFilter dTables 
PROCEDURE noTreeFilter :
/*------------------------------------------------------------------------------
  Purpose:     This will ensure any filtering isn't added when used in the ROM
               tool.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

  /* ensure unique */
  IF (RowObjUpd.RowMod = "U":U AND
      CAN-FIND(FIRST ryc_attribute_value
               WHERE ryc_attribute_value.object_type_obj = RowObjUpd.object_type_obj
                 AND ryc_attribute_value.smartobject_obj = RowObjUpd.smartobject_obj
                 AND ryc_attribute_value.object_instance_obj = RowObjUpd.object_instance_obj
                 AND ryc_attribute_value.attribute_label = RowObjUpd.attribute_label
                 AND ryc_attribute_value.container_smartobject_obj = RowObjUpd.container_smartobject_obj
                 AND ROWID(ryc_attribute_value) <> TO-ROWID(ENTRY(1,RowObjUpd.ROWIDent)))) OR
     (RowObjUpd.RowMod <> "U":U AND
      CAN-FIND(FIRST ryc_attribute_value
               WHERE ryc_attribute_value.object_type_obj = RowObjUpd.object_type_obj
                 AND ryc_attribute_value.smartobject_obj = RowObjUpd.smartobject_obj
                 AND ryc_attribute_value.object_instance_obj = RowObjUpd.object_instance_obj
                 AND ryc_attribute_value.attribute_label = RowObjUpd.attribute_label
                 AND ryc_attribute_value.container_smartobject_obj = RowObjUpd.container_smartobject_obj))  THEN
    ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
           {af/sup2/aferrortxt.i 'AF' '8' 'ryc_attribute_value' 'attribute_label' "'attribute label'" RowObjUpd.attribute_label "'. Please use a different attribute label as value already exists for this label'"}
           .

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

DEFINE VARIABLE cMessageList                  AS CHARACTER  NO-UNDO.


RETURN cMessageList.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION containedObjectName dTables  _DB-REQUIRED
FUNCTION containedObjectName RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the object name of the container object
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE BUFFER bryc_smartobject FOR ryc_smartobject.

  IF AVAILABLE RowObject AND
     RowObject.container_smartobject_obj <> 0 AND 
     RowObject.smartobject_obj <> 0 THEN
  DO FOR bryc_smartobject:
    FIND FIRST bryc_smartobject NO-LOCK
         WHERE bryc_smartobject.smartobject_obj = RowObject.smartobject_obj
         NO-ERROR.
    IF AVAILABLE bryc_smartobject THEN
      RETURN bryc_smartobject.OBJECT_filename.
    ELSE 
      RETURN "":U.
  END.
  ELSE RETURN "".   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION containerObject dTables 
FUNCTION containerObject RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Is this an attribute for a container
    Notes:  
------------------------------------------------------------------------------*/

  IF AVAILABLE RowObject AND RowObject.container_smartobject_obj > 0 THEN
    RETURN YES.
  ELSE
    RETURN NO.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAttributeValue dTables  _DB-REQUIRED
FUNCTION getAttributeValue RETURNS CHARACTER
  ( pcDataType AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cAttributeValue AS CHARACTER  NO-UNDO.

  CASE pcDataType:
    WHEN {&DECIMAL-DATA-TYPE}   THEN cAttributeValue = STRING(ryc_attribute_value.decimal_value) NO-ERROR.
    WHEN {&INTEGER-DATA-TYPE}   THEN cAttributeValue = STRING(ryc_attribute_value.integer_value) NO-ERROR.
    WHEN {&DATE-DATA-TYPE}      THEN cAttributeValue = STRING(ryc_attribute_value.date_value)    NO-ERROR.
    WHEN {&RAW-DATA-TYPE}       THEN cAttributeValue = "":U.
    WHEN {&LOGICAL-DATA-TYPE}   THEN cAttributeValue = STRING(ryc_attribute_value.logical_value) NO-ERROR.
    WHEN {&CHARACTER-DATA-TYPE} THEN cAttributeValue = ryc_attribute_value.character_value       NO-ERROR.
  END CASE.
  
  RETURN cAttributeValue.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInstanceFileName dTables  _DB-REQUIRED
FUNCTION getInstanceFileName RETURNS CHARACTER
  ( INPUT pdObjectInstanceObj AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE BUFFER b_ryc_object_instance FOR ryc_object_instance.
  DEFINE BUFFER b_ryc_smartobject     FOR ryc_smartobject.

  IF AVAIL rowObject AND pdObjectInstanceObj NE 0 THEN
  DO:
      FIND FIRST b_ryc_object_instance NO-LOCK
           WHERE b_ryc_object_instance.OBJECT_instance_obj = pdObjectInstanceObj
           NO-ERROR.
      IF AVAILABLE b_ryc_object_instance THEN
          FIND FIRST b_ryc_smartobject NO-LOCK
               WHERE b_ryc_smartobject.smartobject_obj = b_ryc_object_instance.smartobject_obj
               NO-ERROR.
  END.

  RETURN (IF AVAILABLE b_ryc_smartobject THEN b_ryc_smartobject.OBJECT_filename ELSE "").

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

