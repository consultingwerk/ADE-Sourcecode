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
  File: gscerfullo.w

  Description:  Template Astra 2 SmartDataObject Templat

  Purpose:      Template Astra 2 SmartDataObject Template

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        6180   UserRef:    
                Date:   28/06/2000  Author:     Anthony Swindells

  Update Notes: V9 Templates

  (v:010001)    Task:           0   UserRef:    
                Date:   05/06/2002  Author:     Mark Davies (MIP)

  Update Notes: Added validation for source_language field.

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

&scop object-name       gscerfullo.w
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
&Scoped-define INTERNAL-TABLES gsc_error gsc_language

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  error_group error_number language_obj error_summary_description~
 error_full_description update_error_log error_type source_language
&Scoped-define ENABLED-FIELDS-IN-gsc_error error_group error_number ~
language_obj error_summary_description error_full_description ~
update_error_log error_type source_language 
&Scoped-Define DATA-FIELDS  error_group error_number language_obj language_code~
 error_summary_description error_full_description error_obj update_error_log~
 error_type source_language
&Scoped-define DATA-FIELDS-IN-gsc_error error_group error_number ~
language_obj error_summary_description error_full_description error_obj ~
update_error_log error_type source_language 
&Scoped-define DATA-FIELDS-IN-gsc_language language_code 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "af/obj2/gscerfullo.i"
&Scoped-define QUERY-STRING-Query-Main FOR EACH gsc_error NO-LOCK, ~
      FIRST gsc_language WHERE afdb.gsc_language.language_obj = asdb.gsc_error.language_obj NO-LOCK ~
    BY gsc_error.error_group ~
       BY gsc_error.error_number ~
        BY gsc_error.language_obj INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH gsc_error NO-LOCK, ~
      FIRST gsc_language WHERE afdb.gsc_language.language_obj = asdb.gsc_error.language_obj NO-LOCK ~
    BY gsc_error.error_group ~
       BY gsc_error.error_number ~
        BY gsc_error.language_obj INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main gsc_error gsc_language
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main gsc_error
&Scoped-define SECOND-TABLE-IN-QUERY-Query-Main gsc_language


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD checkMandatory dTables 
FUNCTION checkMandatory RETURNS CHARACTER
  ( INPUT phBuffer    AS HANDLE,
    INPUT pcFieldList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      gsc_error, 
      gsc_language
    FIELDS(gsc_language.language_code) SCROLLING.
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
     _TblList          = "ICFDB.gsc_error,ICFDB.gsc_language WHERE ICFDB.gsc_error ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST USED"
     _OrdList          = "asdb.gsc_error.error_group|yes,asdb.gsc_error.error_number|yes,asdb.gsc_error.language_obj|yes"
     _JoinCode[2]      = "afdb.gsc_language.language_obj = asdb.gsc_error.language_obj"
     _FldNameList[1]   > ICFDB.gsc_error.error_group
"error_group" "error_group" ? ? "character" ? ? ? ? ? ? yes ? no 6 yes
     _FldNameList[2]   > ICFDB.gsc_error.error_number
"error_number" "error_number" ? ? "integer" ? ? ? ? ? ? yes ? no 4 yes
     _FldNameList[3]   > ICFDB.gsc_error.language_obj
"language_obj" "language_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21 yes
     _FldNameList[4]   > ICFDB.gsc_language.language_code
"language_code" "language_code" ? ? "character" ? ? ? ? ? ? no ? no 20 yes
     _FldNameList[5]   > ICFDB.gsc_error.error_summary_description
"error_summary_description" "error_summary_description" ? ? "character" ? ? ? ? ? ? yes ? no 140 yes
     _FldNameList[6]   > ICFDB.gsc_error.error_full_description
"error_full_description" "error_full_description" ? ? "character" ? ? ? ? ? ? yes ? no 6000 yes
     _FldNameList[7]   > ICFDB.gsc_error.error_obj
"error_obj" "error_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 21 yes
     _FldNameList[8]   > ICFDB.gsc_error.update_error_log
"update_error_log" "update_error_log" ? ? "logical" ? ? ? ? ? ? yes ? no 1 yes
     _FldNameList[9]   > ICFDB.gsc_error.error_type
"error_type" "error_type" ? ? "character" ? ? ? ? ? ? yes ? no 6 yes
     _FldNameList[10]   > ICFDB.gsc_error.source_language
"source_language" "source_language" ? ? "logical" ? ? ? ? ? ? yes ? no 17 yes
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE postTransactionValidate dTables  _DB-REQUIRED
PROCEDURE postTransactionValidate :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE BUFFER gsc_error        FOR gsc_error.
  
  /* Code placed here will execute PRIOR to standard behavior. */
  
  RUN SUPER.
  
  /* Code placed here will execute AFTER standard behavior.    */
  
  /*Update all messages that have the same group, and number with the
    error-type, to keep the error-type cosistent across languages.
    Even on Add, Coz they might add a message for a new Language that
    already exists in another lang.*/
  FOR EACH RowObjUpd WHERE CAN-DO('A,C,U':U,RowObjUpd.RowMod):
    FOR EACH gsc_error EXCLUSIVE-LOCK
      WHERE gsc_error.error_group  = RowObjUpd.error_group 
        AND gsc_error.error_number = RowObjUpd.error_number
        AND gsc_error.error_obj   <> RowObjUpd.error_obj: 
        
        ASSIGN gsc_error.error_type  = RowObjUpd.error_type NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN RETURN RETURN-VALUE.
        
    END.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

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
DEFINE VARIABLE cMandatoryFieldList      AS CHARACTER
    /* Provide a list of the mandatory fields */
    INITIAL "error_group,error_number,language_obj,error_summary_description,error_full_description,error_type":U
    NO-UNDO.
DEFINE VARIABLE cErrorString    AS CHARACTER    NO-UNDO.

FOR EACH RowObjUpd WHERE CAN-DO('A,C,U':U,RowObjUpd.RowMod): 
  /* Forece at least one message record to be the source language */
  IF RowObjUpd.source_language = FALSE AND 
     NOT CAN-FIND(FIRST gsc_error
                  WHERE gsc_error.error_group     = rowObjUpd.error_group
                  AND   gsc_error.error_number    = rowObjUpd.error_number 
                  AND   gsc_error.error_obj      <> rowObjUpd.error_obj
                  AND   gsc_error.source_language = TRUE) THEN
    cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                  {af/sup2/aferrortxt.i 'AF' '36' 'gsc_error' 'source_language' "'this record|at least one record of for this error group and error number must be flagged as the source language'" }.
  IF (RowObjUpd.RowMod = 'U':U AND
    CAN-FIND(FIRST gsc_error
      WHERE gsc_error.error_group  = rowObjUpd.error_group
        AND gsc_error.error_number = rowObjUpd.error_number
        AND gsc_error.language_obj = rowObjUpd.language_obj
      AND ROWID(gsc_error) <> TO-ROWID(ENTRY(1,RowObjUpd.RowIDent))))
  OR (RowObjUpd.RowMod <> 'U':U AND
    CAN-FIND(FIRST gsc_error
      WHERE gsc_error.error_group = rowObjUpd.error_group
        AND gsc_error.error_number = rowObjUpd.error_number
        AND gsc_error.language_obj = rowObjUpd.language_obj))
  THEN
    ASSIGN
      cValueList   = STRING(RowObjUpd.error_group) + ', ' + STRING(RowObjUpd.error_number) + ', ' + STRING(RowObjUpd.language_obj)
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '8' 'gsc_error' '' "'error_group, error_number, language_obj, '" cValueList }.

  /* Check all the mandatory fields to make sure that their values have been specified. */
  cErrorString = checkMandatory(INPUT BUFFER RowObjUpd:HANDLE,cMandatoryFieldList).
  IF cErrorString <> "":U THEN
    cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                   cErrorString.

  /* Confirm that the error_type is one of the valid values */
  IF NOT CAN-DO("INF,MES,ERR,WAR,QUE":U,rowObjUpd.error_type) THEN
    cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                   {af/sup2/aferrortxt.i 'AF' '5' 'gsc_error' 'error_type' "'Error Type'"}.
  
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

  IF LENGTH(RowObject.error_group) = 0 OR LENGTH(RowObject.error_group) = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsc_error' 'error_group' "'Error Group'"}.

  IF LENGTH(RowObject.error_summary_description) = 0 OR LENGTH(RowObject.error_summary_description) = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsc_error' 'error_summary_description' "'Error Summary Description'"}.

  IF RowObject.language_obj = 0 OR RowObject.language_obj = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsc_error' 'language_obj' "'Language Obj'"}.

  IF RowObject.error_number = 0 OR RowObject.error_number = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsc_error' 'error_number' "'Error Number'"}.

  IF LENGTH(RowObject.error_type) = 0 OR LENGTH(RowObject.error_type) = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsc_error' 'error_type' "'Error Type'"}.
  
  ERROR-STATUS:ERROR = NO.
  RETURN cMessageList.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION checkMandatory dTables 
FUNCTION checkMandatory RETURNS CHARACTER
  ( INPUT phBuffer    AS HANDLE,
    INPUT pcFieldList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Validates that the fields in the field list that is supplied have 
            had their mandatory values filled in.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRetVal       AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE hBufferField  AS HANDLE       NO-UNDO.
  DEFINE VARIABLE iCount        AS INTEGER      NO-UNDO.
  DEFINE VARIABLE lInvalid      AS LOGICAL      NO-UNDO.


  /* Cycle through all the fields in the field list */
  do-blk:
  DO iCount = 1 TO NUM-ENTRIES(pcFieldList):
    /* Obtain the handle to the buffer field in the field list */
    ASSIGN 
      hBufferField = phBuffer:BUFFER-FIELD(ENTRY(iCount,pcFieldList)) NO-ERROR.

    /* If the buffer field no longer exists on the table, skip it */
    IF ERROR-STATUS:ERROR OR 
       hBufferField = ? THEN
    DO:
      ERROR-STATUS:ERROR = NO.
      NEXT do-blk.
    END.

    /* Determine if the value is invalid based on the data type */
    lInvalid = NO.
    CASE hBufferField:DATA-TYPE:
      WHEN "CHARACTER" THEN
        lInvalid = (hBufferField:BUFFER-VALUE = "":U OR hBufferField:BUFFER-VALUE = ?).
      WHEN "INTEGER" OR
      WHEN "DECIMAL" THEN
        lInvalid = (hBufferField:BUFFER-VALUE = 0 OR hBufferField:BUFFER-VALUE = ?).
      WHEN "DATE" THEN
        lInvalid = hBufferField:BUFFER-VALUE = ?.
    END CASE.

    /* If it is invalid tag the error message onto the return value. */
    IF lInvalid THEN
        cRetVal = cRetVal + (IF NUM-ENTRIES(cRetVal,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                  {af/sup2/aferrortxt.i 'AF' '1' 'phBuffer:TABLE' 'hBufferField:NAME' "hBufferField:LABEL"}.
  END.

  RETURN cRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

