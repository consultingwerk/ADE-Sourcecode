&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          temp-db          PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _TEMP-TABLE 
/* ***********Included Temp-Table & Buffer definitions **************** */
{auditing/ttdefs/_audfilepolicytt.i}

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

&Global-define DATA-LOGIC-PROCEDURE auditing/sdo/_audfilepolicysdolog.p

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
&Scoped-define INTERNAL-TABLES ttAuditFilePolicy

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  _Audit-policy-guid _File-name _Owner _Audit-create-level _Create-event-id~
 _Audit-create-criteria _Audit-update-level _Update-event-id~
 _Audit-update-criteria _Audit-delete-level _Delete-event-id~
 _Audit-delete-criteria _Audit-read-level _Audit-read-criteria
&Scoped-define ENABLED-FIELDS-IN-ttAuditFilePolicy _Audit-policy-guid ~
_File-name _Owner _Audit-create-level _Create-event-id ~
_Audit-create-criteria _Audit-update-level _Update-event-id ~
_Audit-update-criteria _Audit-delete-level _Delete-event-id ~
_Audit-delete-criteria _Audit-read-level _Audit-read-criteria 
&Scoped-Define DATA-FIELDS  _Audit-policy-guid _File-name _Owner _Audit-create-level _Create-event-id~
 _Audit-create-criteria _Audit-update-level _Update-event-id~
 _Audit-update-criteria _Audit-delete-level _Delete-event-id~
 _Audit-delete-criteria _Audit-read-level _Audit-read-criteria~
 CreateLevelDesc UpdateLevelDesc DeleteLevelDesc ReadLevelDesc
&Scoped-define DATA-FIELDS-IN-ttAuditFilePolicy _Audit-policy-guid ~
_File-name _Owner _Audit-create-level _Create-event-id ~
_Audit-create-criteria _Audit-update-level _Update-event-id ~
_Audit-update-criteria _Audit-delete-level _Delete-event-id ~
_Audit-delete-criteria _Audit-read-level _Audit-read-criteria 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "auditing/sdo/_audfilepolicysdo.i"
&Scoped-Define DATA-TABLE-NO-UNDO NO-UNDO
&Scoped-define QUERY-STRING-Query-Main FOR EACH ttAuditFilePolicy NO-LOCK ~
    BY ttAuditFilePolicy._File-name ~
       BY ttAuditFilePolicy._Owner INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH ttAuditFilePolicy NO-LOCK ~
    BY ttAuditFilePolicy._File-name ~
       BY ttAuditFilePolicy._Owner INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main ttAuditFilePolicy
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main ttAuditFilePolicy


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLevelString dTables 
FUNCTION getLevelString RETURNS CHARACTER
  ( INPUT iLevel AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
      ttAuditFilePolicy SCROLLING.
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
      TABLE: ttAuditFilePolicy T "?" NO-UNDO temp-db ttAuditFilePolicy
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
     _TblList          = "Temp-Tables.ttAuditFilePolicy"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "Temp-Tables.ttAuditFilePolicy._File-name|yes,Temp-Tables.ttAuditFilePolicy._Owner|yes"
     _FldNameList[1]   > Temp-Tables.ttAuditFilePolicy._Audit-policy-guid
"_Audit-policy-guid" "_Audit-policy-guid" ? ? "character" ? ? ? ? ? ? yes ? no 28 no ?
     _FldNameList[2]   > Temp-Tables.ttAuditFilePolicy._File-name
"_File-name" "_File-name" "Table name" ? "character" ? ? ? ? ? ? yes ? no 32 no "Table name"
     _FldNameList[3]   > Temp-Tables.ttAuditFilePolicy._Owner
"_Owner" "_Owner" ? ? "character" ? ? ? ? ? ? yes ? no 32 no ?
     _FldNameList[4]   > Temp-Tables.ttAuditFilePolicy._Audit-create-level
"_Audit-create-level" "_Audit-create-level" ? ? "integer" ? ? ? ? ? ? yes ? no 16.4 no ?
     _FldNameList[5]   > Temp-Tables.ttAuditFilePolicy._Create-event-id
"_Create-event-id" "_Create-event-id" ? ? "integer" ? ? ? ? ? ? yes ? no 14.4 no ?
     _FldNameList[6]   > Temp-Tables.ttAuditFilePolicy._Audit-create-criteria
"_Audit-create-criteria" "_Audit-create-criteria" ? ? "character" ? ? ? ? ? ? yes ? no 3000 no ?
     _FldNameList[7]   > Temp-Tables.ttAuditFilePolicy._Audit-update-level
"_Audit-update-level" "_Audit-update-level" ? ? "integer" ? ? ? ? ? ? yes ? no 17 no ?
     _FldNameList[8]   > Temp-Tables.ttAuditFilePolicy._Update-event-id
"_Update-event-id" "_Update-event-id" ? ? "integer" ? ? ? ? ? ? yes ? no 15.2 no ?
     _FldNameList[9]   > Temp-Tables.ttAuditFilePolicy._Audit-update-criteria
"_Audit-update-criteria" "_Audit-update-criteria" ? ? "character" ? ? ? ? ? ? yes ? no 3000 no ?
     _FldNameList[10]   > Temp-Tables.ttAuditFilePolicy._Audit-delete-level
"_Audit-delete-level" "_Audit-delete-level" ? ? "integer" ? ? ? ? ? ? yes ? no 16.2 no ?
     _FldNameList[11]   > Temp-Tables.ttAuditFilePolicy._Delete-event-id
"_Delete-event-id" "_Delete-event-id" ? ? "integer" ? ? ? ? ? ? yes ? no 14.4 no ?
     _FldNameList[12]   > Temp-Tables.ttAuditFilePolicy._Audit-delete-criteria
"_Audit-delete-criteria" "_Audit-delete-criteria" ? ? "character" ? ? ? ? ? ? yes ? no 3000 no ?
     _FldNameList[13]   > Temp-Tables.ttAuditFilePolicy._Audit-read-level
"_Audit-read-level" "_Audit-read-level" ? ? "integer" ? ? ? ? ? ? yes ? no 14.6 no ?
     _FldNameList[14]   > Temp-Tables.ttAuditFilePolicy._Audit-read-criteria
"_Audit-read-criteria" "_Audit-read-criteria" ? ? "character" ? ? ? ? ? ? yes ? no 3000 no ?
     _FldNameList[15]   > "_<CALC>"
"getLevelString(RowObject._Audit-create-level)" "CreateLevelDesc" "Create" "x(20)" "character" ? ? ? ? ? ? no ? no 20 no ?
     _FldNameList[16]   > "_<CALC>"
"getLevelString(RowObject._Audit-update-level)" "UpdateLevelDesc" "Update" "x(20)" "character" ? ? ? ? ? ? no ? no 20 no ?
     _FldNameList[17]   > "_<CALC>"
"getLevelString(RowObject._Audit-delete-level)" "DeleteLevelDesc" "Delete" "x(20)" "character" ? ? ? ? ? ? no ? no 20 no ?
     _FldNameList[18]   > "_<CALC>"
"IF (RowObject._Audit-read-level = 0) THEN ('Off') ELSE ( IF (RowObject._Audit-read-level = 1) THEN ('Minimum') ELSE ('Standard'))" "ReadLevelDesc" "Read" "x(8)" "character" ? ? ? ? ? ? no ? no 8 no ?
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
         rowObject.CreateLevelDesc = (getLevelString(RowObject._Audit-create-level))
         rowObject.DeleteLevelDesc = (getLevelString(RowObject._Audit-delete-level))
         rowObject.ReadLevelDesc = (IF (RowObject._Audit-read-level = 0) THEN ('Off') ELSE ( IF (RowObject._Audit-read-level = 1) THEN ('Minimum') ELSE ('Standard')))
         rowObject.UpdateLevelDesc = (getLevelString(RowObject._Audit-update-level))
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLevelString dTables 
FUNCTION getLevelString RETURNS CHARACTER
  ( INPUT iLevel AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the string for the event level passed in
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.

  CASE iLevel:
      WHEN 0 THEN
          cValue = "Off".
      WHEN 1 THEN
          cValue = 'Mininum'.
      WHEN 2 THEN
          cValue = 'Standard (1 rec/fld)'.
      WHEN 3 THEN
          cValue = 'Full (1 rec/fld)'.
      WHEN 12 THEN
          cValue = 'Standard'.
      WHEN 13 THEN
          cValue = 'Full'.
  END CASE.

  RETURN cValue.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTempTableHandle dTables 
FUNCTION getTempTableHandle RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of the ttAuditFilePolicy temp-table
    Notes:  
------------------------------------------------------------------------------*/
RETURN TEMP-TABLE ttAuditFilePolicy:HANDLE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

