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

&scop object-name       gsmsyfullo.w
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
&Scoped-define INTERNAL-TABLES gsm_session_type_property gsm_session_type ~
gsc_session_property

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  session_type_obj session_property_obj property_value
&Scoped-define ENABLED-FIELDS-IN-gsm_session_type_property session_type_obj ~
session_property_obj property_value 
&Scoped-Define DATA-FIELDS  session_type_property_obj session_type_obj session_type_code~
 session_property_obj session_property_name property_value
&Scoped-define DATA-FIELDS-IN-gsm_session_type_property ~
session_type_property_obj session_type_obj session_property_obj ~
property_value 
&Scoped-define DATA-FIELDS-IN-gsm_session_type session_type_code 
&Scoped-define DATA-FIELDS-IN-gsc_session_property session_property_name 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "af/obj2/gsmsyfullo.i"
&Scoped-define QUERY-STRING-Query-Main FOR EACH gsm_session_type_property NO-LOCK, ~
      FIRST gsm_session_type WHERE gsm_session_type.session_type_obj = gsm_session_type_property.session_type_obj NO-LOCK, ~
      FIRST gsc_session_property WHERE gsc_session_property.session_property_obj = gsm_session_type_property.session_property_obj NO-LOCK ~
    BY icfdb.gsm_session_type_property.session_property_obj ~
       BY icfdb.gsm_session_type_property.session_type_obj INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH gsm_session_type_property NO-LOCK, ~
      FIRST gsm_session_type WHERE gsm_session_type.session_type_obj = gsm_session_type_property.session_type_obj NO-LOCK, ~
      FIRST gsc_session_property WHERE gsc_session_property.session_property_obj = gsm_session_type_property.session_property_obj NO-LOCK ~
    BY icfdb.gsm_session_type_property.session_property_obj ~
       BY icfdb.gsm_session_type_property.session_type_obj INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main gsm_session_type_property ~
gsm_session_type gsc_session_property
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main gsm_session_type_property
&Scoped-define SECOND-TABLE-IN-QUERY-Query-Main gsm_session_type
&Scoped-define THIRD-TABLE-IN-QUERY-Query-Main gsc_session_property


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      gsm_session_type_property, 
      gsm_session_type
    FIELDS(gsm_session_type.session_type_code), 
      gsc_session_property
    FIELDS(gsc_session_property.session_property_name) SCROLLING.
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
     _TblList          = "icfdb.gsm_session_type_property,icfdb.gsm_session_type WHERE icfdb.gsm_session_type_property ...,icfdb.gsc_session_property WHERE icfdb.gsm_session_type_property ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST USED, FIRST USED"
     _OrdList          = "icfdb.icfdb.gsm_session_type_property.session_property_obj|yes,icfdb.icfdb.gsm_session_type_property.session_type_obj|yes"
     _JoinCode[2]      = "icfdb.gsm_session_type.session_type_obj = icfdb.gsm_session_type_property.session_type_obj"
     _JoinCode[3]      = "icfdb.gsc_session_property.session_property_obj = icfdb.gsm_session_type_property.session_property_obj"
     _FldNameList[1]   > icfdb.gsm_session_type_property.session_type_property_obj
"session_type_property_obj" "session_type_property_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 21 yes
     _FldNameList[2]   > icfdb.gsm_session_type_property.session_type_obj
"session_type_obj" "session_type_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21 yes
     _FldNameList[3]   > icfdb.gsm_session_type.session_type_code
"session_type_code" "session_type_code" ? ? "character" ? ? ? ? ? ? no ? no 20 yes
     _FldNameList[4]   > icfdb.gsm_session_type_property.session_property_obj
"session_property_obj" "session_property_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21 yes
     _FldNameList[5]   > icfdb.gsc_session_property.session_property_name
"session_property_name" "session_property_name" ? ? "character" ? ? ? ? ? ? no ? no 56 yes
     _FldNameList[6]   > icfdb.gsm_session_type_property.property_value
"property_value" "property_value" ? ? "character" ? ? ? ? ? ? yes ? no 140 yes
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject dTables 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hHandle AS HANDLE     NO-UNDO.
  
  /* Code placed here will execute PRIOR to standard behavior. */
  hHandle = {fnarg linkHandles 'Test-Source':U}.

  {set DataQueryBrowsed NO}.
  IF VALID-HANDLE(hHandle) AND NOT {fn getObjectInitialized hHandle} THEN
    RUN initializeObject IN hHandle NO-ERROR.
  
  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
     
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
    CAN-FIND(FIRST gsm_session_type_property
      WHERE gsm_session_type_property.session_property_obj = rowObjUpd.session_property_obj
        AND gsm_session_type_property.session_type_obj = rowObjUpd.session_type_obj
      AND ROWID(gsm_session_type_property) <> TO-ROWID(ENTRY(1,RowObjUpd.RowIDent))))
  OR (RowObjUpd.RowMod <> 'U':U AND
    CAN-FIND(FIRST gsm_session_type_property
      WHERE gsm_session_type_property.session_property_obj = rowObjUpd.session_property_obj
        AND gsm_session_type_property.session_type_obj = rowObjUpd.session_type_obj))
  THEN
    ASSIGN
      cValueList   = STRING(RowObjUpd.session_property_obj) + ', ' + STRING(RowObjUpd.session_type_obj)
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '8' 'gsm_session_type_property' '' "'session_property_obj, session_type_obj, '" cValueList }.
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

  IF RowObject.session_property_obj = 0 OR RowObject.session_property_obj = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsm_session_type_property' 'session_property_obj' "'Session Property Obj'"}.

  IF RowObject.session_type_obj = 0 OR RowObject.session_type_obj = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsm_session_type_property' 'session_type_obj' "'Session Type Obj'"}.

  ERROR-STATUS:ERROR = NO.
  RETURN cMessageList.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

