&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          temp-db          PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}
DEFINE VARIABLE h_asbroker1                AS HANDLE          NO-UNDO.
DEFINE VARIABLE h_asbroker2                AS HANDLE          NO-UNDO.
DEFINE VARIABLE h_ashd1                    AS HANDLE          NO-UNDO.
DEFINE VARIABLE h_ashd2                    AS HANDLE          NO-UNDO.

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE routerRef NO-UNDO LIKE routerRef.


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
&Scoped-define INTERNAL-TABLES routerRef

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  externalref internalref
&Scoped-define ENABLED-FIELDS-IN-routerRef externalref internalref 
&Scoped-Define DATA-FIELDS  externalref internalref
&Scoped-define DATA-FIELDS-IN-routerRef externalref internalref 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "src/adm2/support/drouter.i"
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH routerRef NO-LOCK INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main routerRef
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main routerRef


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      routerRef SCROLLING.
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
      TABLE: routerRef T "?" NO-UNDO TEMP-DB routerRef
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
     _TblList          = "Temp-Tables.routerRef"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.routerRef.externalref
"externalref" "externalref" ? "x(256)" "character" ? ? ? ? ? ? yes ? no 256 no
     _FldNameList[2]   > Temp-Tables.routerRef.internalref
"internalref" "internalref" ? "X(256)" "character" ? ? ? ? ? ? yes ? no 256 no
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createReferences dTables  _DB-REQUIRED
PROCEDURE createReferences :
/*------------------------------------------------------------------------------
  Purpose:     This procedure creates routerref temp-table records based on the
               setting of ExternalRef and InternalRef property values
  Parameters:  pcExternalRef  AS CHARACTER
               pcInternalRef  AS CHARACTER
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcExternalRef AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcInternalRef AS CHARACTER NO-UNDO.

DEFINE VARIABLE cSub     AS CHARACTER NO-UNDO.
DEFINE VARIABLE iNumDest AS INTEGER   NO-UNDO.

  DO iNumDest = 1 TO NUM-ENTRIES(pcExternalRef, CHR(1)):
    CREATE routerref.
    ASSIGN
      routerref.externalref = ENTRY(iNumDest, pcExternalRef, CHR(1))
      routerref.internalref = ENTRY(iNumDest, pcInternalRef, CHR(1)).

  END.  /* do iNumDest */
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnReferences dTables  _DB-REQUIRED
PROCEDURE returnReferences :
/*------------------------------------------------------------------------------
  Purpose:     This procedure returns lists External and Internal References
  Parameters:  pcExternalRef AS CHARACTER
               pcInternalRef AS CHARACTER
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pcExternalRef AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcInternalRef AS CHARACTER NO-UNDO.

  FOR EACH routerref:
    ASSIGN 
      pcExternalRef = pcExternalRef + 
                       (IF pcExternalRef = "":U THEN "":U ELSE CHR(1)) +
                       routerref.externalref
      pcInternalRef = pcInternalRef + 
                       (IF pcInternalRef = "":U THEN "":U ELSE CHR(1)) +
                       routerref.internalref.
  END.  /* for each destination */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RowObjectValidate dTables  _DB-REQUIRED
PROCEDURE RowObjectValidate :
/*------------------------------------------------------------------------------
  Purpose:     This validation procedure ensures that an external reference is 
               entered and that an internal reference is entered with a message
               that it can be "." 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF RowObject.externalref = "":U THEN
    RETURN "An external reference must be entered.".
  
  IF RowObject.internalref = "":U THEN
    RETURN "An internal reference must be entered.  Enter '.' for the current directory.".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

