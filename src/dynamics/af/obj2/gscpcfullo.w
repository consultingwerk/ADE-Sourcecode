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

&scop object-name       gscpcfullo.w
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
&Scoped-define INTERNAL-TABLES gsc_profile_code gsc_profile_type

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  profile_code profile_type_obj profile_description profile_narrative
&Scoped-define ENABLED-FIELDS-IN-gsc_profile_code profile_code ~
profile_type_obj profile_description profile_narrative 
&Scoped-Define DATA-FIELDS  profile_code profile_code_obj profile_type_obj profile_type_code~
 profile_description profile_narrative
&Scoped-define DATA-FIELDS-IN-gsc_profile_code profile_code ~
profile_code_obj profile_type_obj profile_description profile_narrative 
&Scoped-define DATA-FIELDS-IN-gsc_profile_type profile_type_code 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "af/obj2/gscpcfullo.i"
&Scoped-define QUERY-STRING-Query-Main FOR EACH gsc_profile_code NO-LOCK, ~
      FIRST gsc_profile_type WHERE AFDB.gsc_profile_type.profile_type_obj = AFDB.gsc_profile_code.profile_type_obj NO-LOCK ~
    BY gsc_profile_code.profile_type_obj ~
       BY gsc_profile_code.profile_code INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH gsc_profile_code NO-LOCK, ~
      FIRST gsc_profile_type WHERE AFDB.gsc_profile_type.profile_type_obj = AFDB.gsc_profile_code.profile_type_obj NO-LOCK ~
    BY gsc_profile_code.profile_type_obj ~
       BY gsc_profile_code.profile_code INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main gsc_profile_code gsc_profile_type
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main gsc_profile_code
&Scoped-define SECOND-TABLE-IN-QUERY-Query-Main gsc_profile_type


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      gsc_profile_code, 
      gsc_profile_type
    FIELDS(gsc_profile_type.profile_type_code) SCROLLING.
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
     _TblList          = "ICFDB.gsc_profile_code,ICFDB.gsc_profile_type WHERE ICFDB.gsc_profile_code ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST USED"
     _OrdList          = "afdb.gsc_profile_code.profile_type_obj|yes,afdb.gsc_profile_code.profile_code|yes"
     _JoinCode[2]      = "AFDB.gsc_profile_type.profile_type_obj = AFDB.gsc_profile_code.profile_type_obj"
     _FldNameList[1]   > ICFDB.gsc_profile_code.profile_code
"profile_code" "profile_code" ? ? "character" ? ? ? ? ? ? yes ? no 11.4 yes
     _FldNameList[2]   > ICFDB.gsc_profile_code.profile_code_obj
"profile_code_obj" "profile_code_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 21 yes
     _FldNameList[3]   > ICFDB.gsc_profile_code.profile_type_obj
"profile_type_obj" "profile_type_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21 yes
     _FldNameList[4]   > ICFDB.gsc_profile_type.profile_type_code
"profile_type_code" "profile_type_code" ? ? "character" ? ? ? ? ? ? no ? no 20 yes
     _FldNameList[5]   > ICFDB.gsc_profile_code.profile_description
"profile_description" "profile_description" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[6]   > ICFDB.gsc_profile_code.profile_narrative
"profile_narrative" "profile_narrative" ? ? "character" ? ? ? ? ? ? yes ? no 1000 yes
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
    CAN-FIND(FIRST gsc_profile_code
      WHERE gsc_profile_code.profile_type_obj = rowObjUpd.profile_type_obj
        AND gsc_profile_code.profile_code = rowObjUpd.profile_code
        AND ROWID(gsc_profile_code) <> TO-ROWID(ENTRY(1,RowObjUpd.RowIDent))))
  OR (RowObjUpd.RowMod <> 'U':U AND
    CAN-FIND(FIRST gsc_profile_code
      WHERE gsc_profile_code.profile_type_obj = rowObjUpd.profile_type_obj
        AND gsc_profile_code.profile_code = rowObjUpd.profile_code))
  THEN
    ASSIGN
      cValueList   = STRING(RowObjUpd.profile_type_obj) + ', ' + STRING(RowObjUpd.profile_code) 
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '8' 'gsc_profile_code' '' "'profile_type_obj, profile_code, '" cValueList }. 
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

  IF RowObject.profile_type_obj = 0 OR RowObject.profile_type_obj = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsc_profile_code' 'profile_type_obj' "'Profile Type Obj'"}.

  IF LENGTH(RowObject.profile_code) = 0 OR LENGTH(RowObject.profile_code) = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) +
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsc_profile_code' 'profile_code' "'Profile Code'"}.

  IF LENGTH(RowObject.profile_description) = 0 OR LENGTH(RowObject.profile_description) = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsc_profile_code' 'profile_description' "'Profile Description'"}.

  ERROR-STATUS:ERROR = NO.
  RETURN cMessageList.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

