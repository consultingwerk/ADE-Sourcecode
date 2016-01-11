&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          temp-db          PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}
DEFINE VARIABLE h_asbroker1                AS HANDLE          NO-UNDO.
DEFINE VARIABLE h_test                     AS HANDLE          NO-UNDO.

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttAppSrv-TT NO-UNDO LIKE ttAppSrv-TT.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS dTables 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File:             protools/dappsrv.w 

  Description:      Service Partition Management SDO. 
                    This SDO reads and writes data to the AppServ-TT table 
                    defined by appsrvtt.i.

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Notes            For this SDO to work properly, the container that it
                   is added to needs to make a call to setUserProperty
                   after the object has been created during the 
                   createObject of the container.

                   The property 'PartitionType' needs to be set to 
                   whatever partition type this SDO is going to serve.
 
                   This object supports three extra links:
                   1) tableChanged - The SDO is the source
                   2) cancelAll - The SDO is the target
                   3) writeBatch - The SDO is the target

  Created:         May 9, 2000 - Bruce Gruenbaum
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

DEFINE VARIABLE cPtnType AS CHARACTER  NO-UNDO.

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
&Scoped-define INTERNAL-TABLES ttAppSrv-TT

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  App-Service Configuration Host Info Partition PartitionType Security~
 Service ServerURL PtnTblRecid
&Scoped-define ENABLED-FIELDS-IN-ttAppSrv-TT App-Service Configuration Host ~
Info Partition PartitionType Security Service ServerURL PtnTblRecid 
&Scoped-Define DATA-FIELDS  App-Service Configuration Host Info Partition PartitionType Security~
 Service ServerURL PtnTblRecid
&Scoped-define DATA-FIELDS-IN-ttAppSrv-TT App-Service Configuration Host ~
Info Partition PartitionType Security Service ServerURL PtnTblRecid 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "protools/dappsrv.i"
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH ttAppSrv-TT NO-LOCK INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main ttAppSrv-TT
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main ttAppSrv-TT


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD deleteRow dTables  _DB-REQUIRED
FUNCTION deleteRow RETURNS LOGICAL
  ( INPUT pcRowIdent AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD submitRow dTables  _DB-REQUIRED
FUNCTION submitRow RETURNS LOGICAL
  ( INPUT pcRowIdent AS CHARACTER,
    INPUT pcValueList AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}


/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      ttAppSrv-TT SCROLLING.
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
      TABLE: ttAppSrv-TT T "?" NO-UNDO temp-db ttAppSrv-TT
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

{adecomm/appsrvtt.i}
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
     _TblList          = "Temp-Tables.ttAppSrv-TT"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.ttAppSrv-TT.App-Service
"App-Service" "App-Service" ? ? "character" ? ? ? ? ? ? yes ? no 255 no
     _FldNameList[2]   > Temp-Tables.ttAppSrv-TT.Configuration
"Configuration" "Configuration" ? ? "logical" ? ? ? ? ? ? yes ? no 12.4 no
     _FldNameList[3]   > Temp-Tables.ttAppSrv-TT.Host
"Host" "Host" ? ? "character" ? ? ? ? ? ? yes ? no 15 no
     _FldNameList[4]   > Temp-Tables.ttAppSrv-TT.Info
"Info" "Info" ? ? "character" ? ? ? ? ? ? yes ? no 255 no
     _FldNameList[5]   > Temp-Tables.ttAppSrv-TT.Partition
"Partition" "Partition" ? ? "character" ? ? ? ? ? ? yes ? no 25 no
     _FldNameList[6]   > Temp-Tables.ttAppSrv-TT.PartitionType
"PartitionType" "PartitionType" ? ? "character" ? ? ? ? ? ? yes ? no 13 no
     _FldNameList[7]   > Temp-Tables.ttAppSrv-TT.Security
"Security" "Security" ? ? "logical" ? ? ? ? ? ? yes ? no 29.6 no
     _FldNameList[8]   > Temp-Tables.ttAppSrv-TT.Service
"Service" "Service" ? ? "character" ? ? ? ? ? ? yes ? no 15 no
     _FldNameList[9]   > Temp-Tables.ttAppSrv-TT.ServerURL
"ServerURL" "ServerURL" ? ? "character" ? ? ? ? ? ? yes ? no 255 no
     _FldNameList[10]   > Temp-Tables.ttAppSrv-TT.PtnTblRecid
"PtnTblRecid" "PtnTblRecid" ? ? "recid" ? ? ? ? ? ? yes ? no 19.8 no
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignDBRow dTables  _DB-REQUIRED
PROCEDURE assignDBRow :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER phRowObjUpd AS HANDLE NO-UNDO.
  DEFINE VARIABLE iRow AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hRowMod AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lDifferent AS LOGICAL    NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT phRowObjUpd).

  IF NOT AVAILABLE(ttAppSrv-TT) THEN
    RETURN.

  iRow = INTEGER(getUserProperty("CurrRecid":U)).
  IF iRow <> ? THEN
  DO:
    FIND FIRST AppSrv-TT WHERE RECID(AppSrv-TT) = iRow NO-ERROR.
    BUFFER-COMPARE ttAppSrv-TT TO AppSrv-TT
       SAVE RESULT IN lDifferent.
    lDifferent = NOT lDifferent.
  END.
  ELSE
  DO:
    hRowMod = phRowObjUpd:BUFFER-FIELD('RowMod':U).
    IF hRowMod:BUFFER-VALUE = "A":U OR 
       hRowMod:BUFFER-VALUE = "C":U THEN
    DO:
      CREATE AppSrv-TT.
      ASSIGN 
        ttAppSrv-TT.PtnTblRecid = RECID(AppSrv-TT)
        lDifferent = YES.
    END.
  END.
  IF lDifferent THEN
  DO:
    BUFFER-COPY ttAppSrv-TT TO AppSrv-TT
      ASSIGN AppSrv-TT.PartitionType = cPtnType. 
    PUBLISH 'tableChanged':U. 
  END.

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
  Purpose:     Super Override - Used to populate the temp-table.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  /* Get the partition type that was set during createObject by the container */ 
  cPtnType = getUserProperty("PartitionType":U).

  /* Get the AppSrv-TT records that are required from the AppServ-TT global
     table */
  FOR EACH AppSrv-TT WHERE AppSrv-TT.PartitionType = cPtnType NO-LOCK:
    CREATE ttAppSrv-TT.
    BUFFER-COPY AppSrv-TT TO ttAppSrv-TT
      ASSIGN ttAppSrv-TT.PtnTblRecid = RECID(AppSrv-TT).
  END.

  RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE preTransactionValidate dTables  _DB-REQUIRED
PROCEDURE preTransactionValidate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Make sure that the partition name is not blank or unknown */
  IF RowObjUpd.Partition = "" OR
     RowObjUpd.Partition = ? THEN
    RETURN "The partition name may not be blank or unknown.".

  /* Make sure that we do not have a duplicate partition name */
  FIND AppSrv-TT 
    WHERE AppSrv-TT.Partition = RowObjUpd.Partition 
    NO-ERROR.
  IF AVAILABLE(AppSrv-TT) AND
     (RECID(AppSrv-TT) <> RowObjUpd.PtnTblRecid OR
      RowObjUpd.PtnTblRecid = ?) THEN
    RETURN "A partition already exists with the name '" + RowObjUpd.Partition
           + "'. Partition names must be unique.".

  /* Set the CurrRecid property which we use later to alter the record on the
     AppSrv-TT table */
  IF AVAILABLE(RowObjUpd) AND
     RowObjUpd.PtnTblRecid <> ? THEN
  DO:
    setUserProperty(INPUT "CurrRecid":U, INPUT STRING(INTEGER(RowObjUpd.PtnTblRecid))).
  END.
  ELSE
  DO:
    setUserProperty(INPUT "CurrRecid":U, INPUT "?":U).
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE writeBatch dTables 
PROCEDURE writeBatch :
/*------------------------------------------------------------------------------
  Purpose:     Writes the contents of the local temp-table back to AppServ-TT
               and notifies that the contents have changed.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*  DEFINE VARIABLE lChanged   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lAns       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hContainer AS HANDLE     NO-UNDO.

  /* Go through all the local records */
  FOR EACH ttAppSrv-TT:
    lAns = NO.
    FIND AppSrv-TT NO-LOCK  /* Find the matching global record */
      WHERE AppSrv-TT.Partition = ttAppSrv-TT.Partition
      NO-ERROR.
    IF NOT AVAILABLE(AppSrv-TT) THEN /* If a global record does not exist, create it */
    DO:
      CREATE AppSrv-TT.
      lAns = YES.  /* Set the lAns flag to note that AppServ-TT must be updated */
    END.
    ELSE
    DO:
      BUFFER-COMPARE ttAppSrv-TT /* Compare for changes */
        USING 
            App-Service
            Configuration
            Host 
            Info 
            Partition 
            PartitionType
            Security 
            Service 
            ServerURL
        TO AppSrv-TT
        /* Buffer-compare returns NO if the records do not match */
        SAVE RESULT IN lAns.
      lAns = NOT lAns. /* If there have been changes set lAns to yes */
    END.
    /* If we have noted that we need to update AppServ-TT, copy the record here */
    IF lAns THEN
    DO:
      BUFFER-COPY ttAppSrv-TT TO AppSrv-TT
        ASSIGN AppSrv-TT.PartitionType = cPtnType. /* If a new record is created, we need to set the partition type. */
      lChanged = YES. /* This flag indicates *ANY* change to AppServ-TT */
    END.
  END.
  
  /* If the user has deleted a partition we need to get rid of it in AppServ-TT
     here. */
  FOR EACH AppSrv-TT 
    WHERE AppSrv-TT.PartitionType = cPtnType:
    IF NOT CAN-FIND(ttAppSrv-TT WHERE ttAppSrv-TT.Partition = AppSrv-TT.Partition) THEN
    DO:
      DELETE AppSrv-TT.
      lChanged = YES.
    END.
  END.
  
  /* If any changes have been made to AppServ-TT, notify all subscribers */
  IF lChanged THEN
    PUBLISH 'tableChanged':U. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION deleteRow dTables  _DB-REQUIRED
FUNCTION deleteRow RETURNS LOGICAL
  ( INPUT pcRowIdent AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iRow AS INTEGER    NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  SUPER( INPUT pcRowIdent ).

  iRow = INTEGER(getUserProperty("CurrRecid":U)).
  IF iRow <> ? THEN
  DO TRANSACTION:
    FIND FIRST AppSrv-TT WHERE RECID(AppSrv-TT) = iRow NO-ERROR.
    IF AVAILABLE(AppSrv-TT) THEN
    DO:
      DELETE AppSrv-TT.
      PUBLISH 'tableChanged':U. 
    END.
  END.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION submitRow dTables  _DB-REQUIRED
FUNCTION submitRow RETURNS LOGICAL
  ( INPUT pcRowIdent AS CHARACTER,
    INPUT pcValueList AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Notes:       
------------------------------------------------------------------------------*/

  /* If the rows have all been deleted, we don't want submitRow to run
     when the window is closed. */
  IF NOT AVAILABLE(RowObject) THEN 
    RETURN FALSE.
  
  RETURN SUPER( INPUT pcRowIdent, INPUT pcValueList ).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

