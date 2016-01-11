&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          temp-db          PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}
DEFINE VARIABLE h_APMT                     AS HANDLE          NO-UNDO.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _TEMP-TABLE 
/* ***********Included Temp-Table & Buffer definitions **************** */

{auditing/ttdefs/_audeventpolicytt.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS dTables 
/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
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

&Global-define DATA-LOGIC-PROCEDURE auditing/sdo/_audevpolicysdolog.p

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
&Scoped-define INTERNAL-TABLES ttAuditEventPolicy

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  _Audit-policy-guid _Event-id _Event-name _Event-type _Event-level~
 _Event-criteria _Event-description
&Scoped-define ENABLED-FIELDS-IN-ttAuditEventPolicy _Audit-policy-guid ~
_Event-id _Event-name _Event-type _Event-level _Event-criteria ~
_Event-description 
&Scoped-Define DATA-FIELDS  _Audit-policy-guid _Event-id _Event-name _Event-type _Event-level~
 _Event-criteria EventLevelDesc EventCriteriaDesc _Event-description
&Scoped-define DATA-FIELDS-IN-ttAuditEventPolicy _Audit-policy-guid ~
_Event-id _Event-name _Event-type _Event-level _Event-criteria ~
_Event-description 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "auditing/sdo/_audevpolicysdo.i"
&Scoped-Define DATA-TABLE-NO-UNDO NO-UNDO
&Scoped-define QUERY-STRING-Query-Main FOR EACH ttAuditEventPolicy NO-LOCK INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH ttAuditEventPolicy NO-LOCK INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main ttAuditEventPolicy
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main ttAuditEventPolicy


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTempTableHandle dTables 
FUNCTION getTempTableHandle RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      ttAuditEventPolicy SCROLLING.
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
      TABLE: ttAuditEventPolicy T "?" NO-UNDO temp-db ttAuditEventPolicy
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
     _TblList          = "Temp-Tables.ttAuditEventPolicy"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.ttAuditEventPolicy._Audit-policy-guid
"_Audit-policy-guid" "_Audit-policy-guid" ? ? "character" ? ? ? ? ? ? yes ? no 28 no ?
     _FldNameList[2]   > Temp-Tables.ttAuditEventPolicy._Event-id
"_Event-id" "_Event-id" ? ? "integer" ? ? ? ? ? ? yes ? no 7.8 no ?
     _FldNameList[3]   > Temp-Tables.ttAuditEventPolicy._Event-name
"_Event-name" "_Event-name" ? ? "character" ? ? ? ? ? ? yes ? no 35 no ?
     _FldNameList[4]   > Temp-Tables.ttAuditEventPolicy._Event-type
"_Event-type" "_Event-type" ? ? "character" ? ? ? ? ? ? yes ? no 15 no ?
     _FldNameList[5]   > Temp-Tables.ttAuditEventPolicy._Event-level
"_Event-level" "_Event-level" ? ? "integer" ? ? ? ? ? ? yes ? no 10.6 no ?
     _FldNameList[6]   > Temp-Tables.ttAuditEventPolicy._Event-criteria
"_Event-criteria" "_Event-criteria" ? ? "character" ? ? ? ? ? ? yes ? no 3000 no ?
     _FldNameList[7]   > "_<CALC>"
"IF (RowObject._Event-level = 0) THEN ('Off') ELSE ( IF (RowObject._Event-level = 1) THEN (IF (RowObject._Event-id < 10000) THEN ('On') ELSE ('Minimum')) ELSE  ('Full'))" "EventLevelDesc" "Event Level" "x(8)" "character" ? ? ? ? ? ? no ? no 8 no ?
     _FldNameList[8]   > "_<CALC>"
"IF (RowObject._Event-criteria <> '') THEN ('YES') ELSE ('NO')" "EventCriteriaDesc" "Criteria" "x(3)" "character" ? ? ? ? ? ? no ? no 6.4 no ?
     _FldNameList[9]   > Temp-Tables.ttAuditEventPolicy._Event-description
"_Event-description" "_Event-description" ? ? "character" ? ? ? ? ? ? yes ? no 50 no ?
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DATA.CALCULATE dTables  DATA.CALCULATE
PROCEDURE DATA.CALCULATE :
/*------------------------------------------------------------------------------
  Purpose:     Calculate all the Calculated Expressions found in the
               SmartDataObject.
  Parameters:  <none>
------------------------------------------------------------------------------*/
      ASSIGN 
         rowObject.EventCriteriaDesc = (IF (RowObject._Event-criteria <> '') THEN ('YES') ELSE ('NO'))
         rowObject.EventLevelDesc = (IF (RowObject._Event-level = 0) THEN ('Off') ELSE ( IF (RowObject._Event-level = 1) THEN (IF (RowObject._Event-id < 10000) THEN ('On') ELSE ('Minimum')) ELSE  ('Full')))
      .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTempTableHandle dTables 
FUNCTION getTempTableHandle RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of the ttAuditEventPolicy temp-table
    Notes:  
------------------------------------------------------------------------------*/

  RETURN TEMP-TABLE ttAuditEventPolicy:HANDLE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

