&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}
DEFINE VARIABLE h_Astra                    AS HANDLE          NO-UNDO.
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS dTables 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File:  

  Description: from DATA.W - Template For SmartData objects in the ADM

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Modified:     February 24, 1999
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

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
&Scoped-define INTERNAL-TABLES ryc_layout

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  layout_name layout_type layout_code layout_filename layout_narrative~
 sample_image_filename system_owned
&Scoped-define ENABLED-FIELDS-IN-ryc_layout layout_name layout_type ~
layout_code layout_filename layout_narrative sample_image_filename ~
system_owned 
&Scoped-Define DATA-FIELDS  layout_name layout_type layout_code layout_filename layout_narrative~
 sample_image_filename system_owned layout_obj
&Scoped-define DATA-FIELDS-IN-ryc_layout layout_name layout_type ~
layout_code layout_filename layout_narrative sample_image_filename ~
system_owned layout_obj 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "ry/obj/ryclafullo.i"
&Scoped-define QUERY-STRING-Query-Main FOR EACH ryc_layout NO-LOCK ~
    BY ryc_layout.layout_name INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH ryc_layout NO-LOCK ~
    BY ryc_layout.layout_name INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main ryc_layout
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main ryc_layout


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      ryc_layout SCROLLING.
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
     _TblList          = "ICFDB.ryc_layout"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "RYDB.ryc_layout.layout_name|yes"
     _FldNameList[1]   > ICFDB.ryc_layout.layout_name
"layout_name" "layout_name" ? ? "character" ? ? ? ? ? ? yes ? no 28 yes
     _FldNameList[2]   > ICFDB.ryc_layout.layout_type
"layout_type" "layout_type" ? ? "character" ? ? ? ? ? ? yes ? no 11.8 yes
     _FldNameList[3]   > ICFDB.ryc_layout.layout_code
"layout_code" "layout_code" ? ? "character" ? ? ? ? ? ? yes ? no 12 yes
     _FldNameList[4]   > ICFDB.ryc_layout.layout_filename
"layout_filename" "layout_filename" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[5]   > ICFDB.ryc_layout.layout_narrative
"layout_narrative" "layout_narrative" ? ? "character" ? ? ? ? ? ? yes ? no 500 yes
     _FldNameList[6]   > ICFDB.ryc_layout.sample_image_filename
"sample_image_filename" "sample_image_filename" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[7]   > ICFDB.ryc_layout.system_owned
"system_owned" "system_owned" ? ? "logical" ? ? ? ? ? ? yes ? no 14.2 yes
     _FldNameList[8]   > ICFDB.ryc_layout.layout_obj
"layout_obj" "layout_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 21.6 yes
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
  Purpose:     To perform validation that requires access to the database but
               that can occur before the transaction has started.
  Parameters:  <none>
  Notes:       Batch up errors using a chr(3) delimiter and be sure not to leave
               the error status raised.
------------------------------------------------------------------------------*/

DEFINE VARIABLE cMessageList                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cText                         AS CHARACTER  NO-UNDO.

FOR EACH RowObjUpd WHERE LOOKUP(RowObjUpd.RowMod,"A,C,U":U) <> 0:

  /* ensure object name specified is unique */
  IF (RowObjUpd.RowMod = "U":U AND
      CAN-FIND(FIRST ryc_layout
               WHERE ryc_layout.layout_name = RowObjUpd.layout_name
                 AND ROWID(ryc_layout) <> TO-ROWID(RowObjUpd.ROWIDent))) OR 
     (RowObjUpd.RowMod <> "U":U AND
      CAN-FIND(FIRST ryc_layout
               WHERE ryc_layout.layout_name = RowObjUpd.layout_name))  THEN
    ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
           {af/sup2/aferrortxt.i 'AF' '8' 'ryc_layout' 'layout_name' "'layout name'" RowObjUpd.layout_name "'. Please use a different layout name'"}
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

IF LENGTH(RowObject.layout_name) = 0 THEN
    ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
                          {af/sup2/aferrortxt.i 'AF' '1' 'ryc_layout' 'layout_name' "'layout name'"}.

IF LENGTH(RowObject.layout_narrative) = 0 THEN
    ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
                          {af/sup2/aferrortxt.i 'AF' '1' 'ryc_layout' 'layout_narrative' "'layout narrative'"}.

IF LENGTH(RowObject.layout_type) = 0 THEN
    ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
                          {af/sup2/aferrortxt.i 'AF' '1' 'ryc_layout' 'layout_type' "'layout type'"}.

IF LENGTH(RowObject.layout_code) = 0 THEN
    ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
                          {af/sup2/aferrortxt.i 'AF' '1' 'ryc_layout' 'layout_code' "'layout code'"}.

RETURN cMessageList.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

