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
  File: gsmsvfullo.w

  Description:  Session Service SmartDataObject

  Purpose:      Session Service SmartDataObject

                This SDO contains a calculated field called workaround that is only used
                in the Session Service SDV to work around a problem when only
                SmartDataFields display in a viewer.  The calculated field forces the fields to
                be enabled and the links to the toolbar to remain in place.  The calculated
                field has nothing in it.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        6180   UserRef:    
                Date:   28/06/2000  Author:     Anthony Swindells

  Update Notes: V9 Templates

  (v:010001)    Task:    90000037   UserRef:    posse
                Date:   18/04/2001  Author:     Tammy St Pierre

  Update Notes: Added note about work around calculated frield.

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

&scop object-name       gsmsvfullo.w
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


/* Db-Required definitions. */
&IF DEFINED(DB-REQUIRED) = 0 &THEN
    &GLOBAL-DEFINE DB-REQUIRED TRUE
&ENDIF
&GLOBAL-DEFINE DB-REQUIRED-START   &IF {&DB-REQUIRED} &THEN
&GLOBAL-DEFINE DB-REQUIRED-END     &ENDIF


&Scoped-define QUERY-NAME Query-Main

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES gsm_session_service gsm_session_type ~
gsc_logical_service gsm_physical_service

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  session_type_obj logical_service_obj physical_service_obj workaround
&Scoped-define ENABLED-FIELDS-IN-gsm_session_service session_type_obj ~
logical_service_obj physical_service_obj 
&Scoped-Define DATA-FIELDS  session_service_obj session_type_obj session_type_code logical_service_obj~
 logical_service_code physical_service_obj physical_service_code~
 logical_service_type_obj logical_service_type_code~
 physical_service_type_obj physical_service_type_code workaround
&Scoped-define DATA-FIELDS-IN-gsm_session_service session_service_obj ~
session_type_obj logical_service_obj physical_service_obj 
&Scoped-define DATA-FIELDS-IN-gsm_session_type session_type_code 
&Scoped-define DATA-FIELDS-IN-gsc_logical_service logical_service_code ~
logical_service_type_obj 
&Scoped-define DATA-FIELDS-IN-gsm_physical_service physical_service_code ~
physical_service_type_obj 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST   rowObject.logical_service_type_obj = gsc_logical_service.service_type_obj~
  rowObject.physical_service_type_obj = gsm_physical_service.service_type_obj
&Scoped-Define DATA-FIELD-DEFS "af/obj2/gsmsvfullo.i"
&Scoped-define QUERY-STRING-Query-Main FOR EACH gsm_session_service NO-LOCK, ~
      FIRST gsm_session_type WHERE ASDB.gsm_session_type.session_type_obj = ASDB.gsm_session_service.session_type_obj NO-LOCK, ~
      FIRST gsc_logical_service WHERE ASDB.gsc_logical_service.logical_service_obj = ASDB.gsm_session_service.logical_service_obj NO-LOCK, ~
      FIRST gsm_physical_service WHERE ASDB.gsm_physical_service.physical_service_obj = ASDB.gsm_session_service.physical_service_obj NO-LOCK ~
    BY gsm_session_service.session_type_obj ~
       BY gsm_session_service.logical_service_obj INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH gsm_session_service NO-LOCK, ~
      FIRST gsm_session_type WHERE ASDB.gsm_session_type.session_type_obj = ASDB.gsm_session_service.session_type_obj NO-LOCK, ~
      FIRST gsc_logical_service WHERE ASDB.gsc_logical_service.logical_service_obj = ASDB.gsm_session_service.logical_service_obj NO-LOCK, ~
      FIRST gsm_physical_service WHERE ASDB.gsm_physical_service.physical_service_obj = ASDB.gsm_session_service.physical_service_obj NO-LOCK ~
    BY gsm_session_service.session_type_obj ~
       BY gsm_session_service.logical_service_obj INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main gsm_session_service ~
gsm_session_type gsc_logical_service gsm_physical_service
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main gsm_session_service
&Scoped-define SECOND-TABLE-IN-QUERY-Query-Main gsm_session_type
&Scoped-define THIRD-TABLE-IN-QUERY-Query-Main gsc_logical_service
&Scoped-define FOURTH-TABLE-IN-QUERY-Query-Main gsm_physical_service


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD returnServiceTypeCode dTables  _DB-REQUIRED
FUNCTION returnServiceTypeCode RETURNS CHARACTER
  ( pdServiceTypeObj AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}


/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      gsm_session_service, 
      gsm_session_type
    FIELDS(gsm_session_type.session_type_code), 
      gsc_logical_service
    FIELDS(gsc_logical_service.logical_service_code
      gsc_logical_service.service_type_obj), 
      gsm_physical_service
    FIELDS(gsm_physical_service.physical_service_code
      gsm_physical_service.service_type_obj) SCROLLING.
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
     _TblList          = "ICFDB.gsm_session_service,ICFDB.gsm_session_type WHERE ICFDB.gsm_session_service ...,ICFDB.gsc_logical_service WHERE ICFDB.gsm_session_service ...,ICFDB.gsm_physical_service WHERE ICFDB.gsm_session_service ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST USED, FIRST USED, FIRST USED"
     _OrdList          = "asdb.gsm_session_service.session_type_obj|yes,asdb.gsm_session_service.logical_service_obj|yes"
     _JoinCode[2]      = "ASDB.gsm_session_type.session_type_obj = ASDB.gsm_session_service.session_type_obj"
     _JoinCode[3]      = "ASDB.gsc_logical_service.logical_service_obj = ASDB.gsm_session_service.logical_service_obj"
     _JoinCode[4]      = "ASDB.gsm_physical_service.physical_service_obj = ASDB.gsm_session_service.physical_service_obj"
     _FldNameList[1]   > ICFDB.gsm_session_service.session_service_obj
"session_service_obj" "session_service_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 21 yes
     _FldNameList[2]   > ICFDB.gsm_session_service.session_type_obj
"session_type_obj" "session_type_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21 yes
     _FldNameList[3]   > ICFDB.gsm_session_type.session_type_code
"session_type_code" "session_type_code" ? ? "character" ? ? ? ? ? ? no ? no 20 yes
     _FldNameList[4]   > ICFDB.gsm_session_service.logical_service_obj
"logical_service_obj" "logical_service_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21 yes
     _FldNameList[5]   > ICFDB.gsc_logical_service.logical_service_code
"logical_service_code" "logical_service_code" ? ? "character" ? ? ? ? ? ? no ? no 20.2 yes
     _FldNameList[6]   > ICFDB.gsm_session_service.physical_service_obj
"physical_service_obj" "physical_service_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21 yes
     _FldNameList[7]   > ICFDB.gsm_physical_service.physical_service_code
"physical_service_code" "physical_service_code" ? ? "character" ? ? ? ? ? ? no ? no 21.2 yes
     _FldNameList[8]   > ICFDB.gsc_logical_service.service_type_obj
"service_type_obj" "logical_service_type_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 29.4 yes
     _FldNameList[9]   > "_<CALC>"
"returnServiceTypeCode(RowObject.logical_service_type_obj)" "logical_service_type_code" "Logical Service Type" "x(20)" "character" ? ? ? ? ? ? no ? no 20 no
     _FldNameList[10]   > ICFDB.gsm_physical_service.service_type_obj
"service_type_obj" "physical_service_type_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 29.4 yes
     _FldNameList[11]   > "_<CALC>"
"returnServiceTypeCode(RowObject.physical_service_type_obj)" "physical_service_type_code" "Physical Service Type" "x(20)" "character" ? ? ? ? ? ? no ? no 21 no
     _FldNameList[12]   > "_<CALC>"
"'bug workaround'" "workaround" ? "x(8)" "character" ? ? ? ? ? ? yes ? no 8 no
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
         rowObject.logical_service_type_code = (returnServiceTypeCode(RowObject.logical_service_type_obj))
         rowObject.physical_service_type_code = (returnServiceTypeCode(RowObject.physical_service_type_obj))
         rowObject.workaround = ('bug workaround')
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
    CAN-FIND(FIRST gsm_session_service
      WHERE gsm_session_service.session_type_obj = rowObjUpd.session_type_obj
        AND gsm_session_service.logical_service_obj = rowObjUpd.logical_service_obj
      AND ROWID(gsm_session_service) <> TO-ROWID(ENTRY(1,RowObjUpd.RowIDent))))
  OR (RowObjUpd.RowMod <> 'U':U AND
    CAN-FIND(FIRST gsm_session_service
      WHERE gsm_session_service.session_type_obj = rowObjUpd.session_type_obj
        AND gsm_session_service.logical_service_obj = rowObjUpd.logical_service_obj))
  THEN
    ASSIGN
      cValueList   = STRING(RowObjUpd.session_type_obj) + ', ' + STRING(RowObjUpd.logical_service_obj)
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '8' 'gsm_session_service' '' "'session_type_obj, logical_service_obj, '" cValueList }.

  /* The logical service type and physical service type must match. */
  FIND gsc_logical_service 
    WHERE gsc_logical_service.logical_service_obj = RowObjUpd.logical_service_obj NO-LOCK NO-ERROR.
  IF AVAILABLE gsc_logical_service THEN DO:
    FIND gsm_physical_service 
      WHERE gsm_physical_service.physical_service_obj = RowObjUpd.physical_service_obj NO-LOCK NO-ERROR.
    IF AVAILABLE gsm_physical_service THEN DO:
      IF gsc_logical_service.service_type_obj NE gsm_physical_service.service_type_obj THEN
        ASSIGN 
          cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) +
                    {af/sup2/aferrortxt.i 'AF' '110' 'gsm_session_service' '' "'Logical Service Type'" "'Physical Service Type'"}.
    END.  /* if avail physical service */
  END.  /* if avail logical service */

END.  /* for each RowObjUpd */

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

  IF RowObject.session_type_obj = 0 OR RowObject.session_type_obj = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsm_session_service' 'session_type_obj' "'Session Type Obj'"}.

  IF RowObject.logical_service_obj = 0 OR RowObject.logical_service_obj = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsm_session_service' 'logical_service_obj' "'Logical Service Obj'"}.

  IF RowObject.physical_service_obj = 0 OR RowObject.physical_service_obj = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsm_session_service' 'physical_service_obj' "'Physical Service Obj'"}.

  ERROR-STATUS:ERROR = NO.
  RETURN cMessageList.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION returnServiceTypeCode dTables  _DB-REQUIRED
FUNCTION returnServiceTypeCode RETURNS CHARACTER
  ( pdServiceTypeObj AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the service type code for the service type obj being 
            passed in as a paramter
   Params:  pdServiceTypeObj AS DECIMAL  
    Notes:  This is invoked by the physical_service_type_code and 
            the logical_service_type_code calculated fields  
------------------------------------------------------------------------------*/
  FIND gsc_service_type WHERE gsc_service_type.service_type_obj = pdServiceTypeObj NO-LOCK NO-ERROR.
  IF AVAILABLE gsc_service_type THEN RETURN gsc_service_type.service_type_code.
  ELSE RETURN "":U.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

