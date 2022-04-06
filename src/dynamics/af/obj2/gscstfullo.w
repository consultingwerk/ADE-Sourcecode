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


/* Temp-Table and Buffer definitions                                    */
/* Db-Required definitions. */
&IF DEFINED(DB-REQUIRED) = 0 &THEN
    &GLOBAL-DEFINE DB-REQUIRED TRUE
&ENDIF
&GLOBAL-DEFINE DB-REQUIRED-START   &IF {&DB-REQUIRED} &THEN
&GLOBAL-DEFINE DB-REQUIRED-END     &ENDIF


{&DB-REQUIRED-START}
 DEFINE BUFFER ryc_smartobject_buffer FOR ryc_smartobject.
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

&scop object-name       gscstfullo.w
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

&Scoped-define PROCEDURE-TYPE SmartDataObject
&Scoped-define DB-AWARE yes

&Scoped-define ADM-SUPPORTED-LINKS Data-Source,Data-Target,Navigation-Target,Update-Target,Commit-Target,Filter-Target


/* Note that Db-Required is defined before the buffer definitions for this object. */

&Scoped-define QUERY-NAME Query-Main

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES gsc_service_type ryc_smartobject ~
gsc_logical_service

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  service_type_code service_type_description management_object_obj~
 maintenance_object_obj default_logical_service_obj
&Scoped-define ENABLED-FIELDS-IN-gsc_service_type service_type_code ~
service_type_description management_object_obj maintenance_object_obj ~
default_logical_service_obj 
&Scoped-Define DATA-FIELDS  service_type_obj service_type_code service_type_description~
 management_object_obj object_filename mgnt_filename_display~
 maintenance_object_obj maint_object_filename default_logical_service_obj~
 logical_service_code logical_service_display
&Scoped-define DATA-FIELDS-IN-gsc_service_type service_type_obj ~
service_type_code service_type_description management_object_obj ~
maintenance_object_obj default_logical_service_obj 
&Scoped-define DATA-FIELDS-IN-ryc_smartobject object_filename 
&Scoped-define DATA-FIELDS-IN-gsc_logical_service logical_service_code 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "af/obj2/gscstfullo.i"
&Scoped-define QUERY-STRING-Query-Main FOR EACH gsc_service_type NO-LOCK, ~
      FIRST ryc_smartobject WHERE asdb.ryc_smartobject.smartobject_obj = asdb.gsc_service_type.management_object_obj OUTER-JOIN NO-LOCK, ~
      FIRST gsc_logical_service WHERE asdb.gsc_logical_service.logical_service_obj = asdb.gsc_service_type.default_logical_service_obj OUTER-JOIN NO-LOCK ~
    BY gsc_service_type.service_type_code INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH gsc_service_type NO-LOCK, ~
      FIRST ryc_smartobject WHERE asdb.ryc_smartobject.smartobject_obj = asdb.gsc_service_type.management_object_obj OUTER-JOIN NO-LOCK, ~
      FIRST gsc_logical_service WHERE asdb.gsc_logical_service.logical_service_obj = asdb.gsc_service_type.default_logical_service_obj OUTER-JOIN NO-LOCK ~
    BY gsc_service_type.service_type_code INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main gsc_service_type ryc_smartobject ~
gsc_logical_service
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main gsc_service_type
&Scoped-define SECOND-TABLE-IN-QUERY-Query-Main ryc_smartobject
&Scoped-define THIRD-TABLE-IN-QUERY-Query-Main gsc_logical_service


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD returnObjectFileName dTables  _DB-REQUIRED
FUNCTION returnObjectFileName RETURNS CHARACTER
  ( pdObjectObj AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}


/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      gsc_service_type, 
      ryc_smartobject, 
      gsc_logical_service SCROLLING.
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
      TABLE: ryc_smartobject_buffer B "?" ? ASDB ryc_smartobject
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
     _TblList          = "icfdb.gsc_service_type,icfdb.ryc_smartobject WHERE icfdb.gsc_service_type ...,icfdb.gsc_logical_service WHERE icfdb.gsc_service_type ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST OUTER, FIRST OUTER, FIRST OUTER"
     _OrdList          = "asdb.gsc_service_type.service_type_code|yes"
     _JoinCode[2]      = "asdb.ryc_smartobject.smartobject_obj = asdb.gsc_service_type.management_object_obj"
     _JoinCode[3]      = "asdb.gsc_logical_service.logical_service_obj = asdb.gsc_service_type.default_logical_service_obj"
     _FldNameList[1]   > icfdb.gsc_service_type.service_type_obj
"service_type_obj" "service_type_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 21 yes
     _FldNameList[2]   > icfdb.gsc_service_type.service_type_code
"service_type_code" "service_type_code" ? ? "character" ? ? ? ? ? ? yes ? no 20 yes
     _FldNameList[3]   > icfdb.gsc_service_type.service_type_description
"service_type_description" "service_type_description" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[4]   > icfdb.gsc_service_type.management_object_obj
"management_object_obj" "management_object_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21 yes
     _FldNameList[5]   > icfdb.ryc_smartobject.object_filename
"object_filename" "object_filename" ? ? "character" ? ? ? ? ? ? no ? no 35 yes
     _FldNameList[6]   > "_<CALC>"
"(IF management_object_obj = 0 THEN '<None>'
ELSE object_filename)" "mgnt_filename_display" "Management Object FileName" "x(35)" "character" ? ? ? ? ? ? no ? no 35 no
     _FldNameList[7]   > icfdb.gsc_service_type.maintenance_object_obj
"maintenance_object_obj" "maintenance_object_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21 yes
     _FldNameList[8]   > "_<CALC>"
"returnObjectFileName(RowObject.maintenance_object_obj)" "maint_object_filename" "Maintenance Object Filename" "x(35)" "character" ? ? ? ? ? ? no ? no 35 no
     _FldNameList[9]   > icfdb.gsc_service_type.default_logical_service_obj
"default_logical_service_obj" "default_logical_service_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21 yes
     _FldNameList[10]   > icfdb.gsc_logical_service.logical_service_code
"logical_service_code" "logical_service_code" ? ? "character" ? ? ? ? ? ? no ? no 20.2 yes
     _FldNameList[11]   > "_<CALC>"
"(IF default_logical_service_obj = 0 THEN '<None>'
ELSE logical_service_code)" "logical_service_display" "Default Logical Service" "x(35)" "character" ? ? ? ? ? ? no ? no 35 no
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
         rowObject.logical_service_display = ((IF default_logical_service_obj = 0 THEN '<None>'
ELSE logical_service_code))
         rowObject.maint_object_filename = (returnObjectFileName(RowObject.maintenance_object_obj))
         rowObject.mgnt_filename_display = ((IF management_object_obj = 0 THEN '<None>'
ELSE object_filename))
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
  IF (RowObjUpd.RowMod = 'U':U AND
    CAN-FIND(FIRST gsc_service_type
      WHERE gsc_service_type.service_type_code = rowObjUpd.service_type_code
      AND ROWID(gsc_service_type) <> TO-ROWID(ENTRY(1,RowObjUpd.RowIDent))))
  OR (RowObjUpd.RowMod <> 'U':U AND
    CAN-FIND(FIRST gsc_service_type
      WHERE gsc_service_type.service_type_code = rowObjUpd.service_type_code))
  THEN
    ASSIGN
      cValueList   = STRING(RowObjUpd.service_type_code)
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '8' 'gsc_service_type' '' "'service_type_code, '" cValueList }.
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

  IF LENGTH(RowObject.service_type_code) = 0 OR LENGTH(RowObject.service_type_code) = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsc_service_type' 'service_type_code' "'Service Type Code'"}.

  IF LENGTH(RowObject.service_type_description) = 0 OR LENGTH(RowObject.service_type_description) = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsc_service_type' 'service_type_description' "'Service Type Description'"}.

  IF RowObject.management_object_obj = 0 OR RowObject.management_object_obj = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsc_service_type' 'management_object_obj' "'Management Object Obj'"}.

  IF RowObject.maintenance_object_obj = 0 OR RowObject.maintenance_object_obj = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsc_service_type' 'maintenance_object_obj' "'Maintenance Object Obj'"}.

  ERROR-STATUS:ERROR = NO.
  RETURN cMessageList.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION returnObjectFileName dTables  _DB-REQUIRED
FUNCTION returnObjectFileName RETURNS CHARACTER
  ( pdObjectObj AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FIND FIRST ryc_smartobject WHERE ryc_smartobject.smartobject_obj = pdObjectObj NO-LOCK NO-ERROR.
  IF AVAILABLE ryc_smartobject THEN RETURN ryc_smartobject.object_filename.
  ELSE RETURN "<None>":U.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

