&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Procedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Procedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: afcrplip2p.p

  Description:  ICF Crystal PLIP

  Purpose:      ICF Crystal Report Plip for DLL's

  Parameters:

  History:
  --------
  (v:010000)    Task:        7934   UserRef:    
                Date:   13/02/2001  Author:     Anthony Swindells

  Update Notes: ICF Crystal Printing

-------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afcrplip2p.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010000

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

{af/sup2/afglobals.i}

DEFINE TEMP-TABLE tt_datasource NO-UNDO
            FIELD tt_tag        AS CHARACTER
            FIELD tt_value      AS CHARACTER EXTENT {&max-crystal-fields}.

DEFINE VARIABLE cRegReportDesign  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRegReportEngine  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRegDataEngine    AS CHARACTER  NO-UNDO.

&scop crpe_dll p2smon.dll
&scop pixels-per-char 96

DEFINE VARIABLE giMaxPageWidth    AS INTEGER    NO-UNDO INITIAL 16000.

DEFINE VARIABLE ghDataObject      AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE ghWorkspace       AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE ghDatabase        AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE ghTables          AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE ghTable           AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE ghField           AS COM-HANDLE EXTENT {&max-crystal-fields} NO-UNDO.
DEFINE VARIABLE ghRecordSet       AS COM-HANDLE NO-UNDO.

DEFINE VARIABLE ghApplication     AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE ghReport          AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE ghSections        AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE ghSection         AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE ghRepOptions      AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE ghRepObjects      AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE ghRepObject       AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE ghRepDatabase     AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE ghRepTables       AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE ghRepTable        AS COM-HANDLE NO-UNDO.

DEFINE VARIABLE gcFieldNames      AS CHARACTER EXTENT {&max-crystal-fields} NO-UNDO.
DEFINE VARIABLE gcFieldLabels     AS CHARACTER EXTENT {&max-crystal-fields} NO-UNDO.
DEFINE VARIABLE gcFieldWidths     AS CHARACTER EXTENT {&max-crystal-fields} INITIAL ? NO-UNDO.
DEFINE VARIABLE gcFieldDataTypes  AS CHARACTER EXTENT {&max-crystal-fields} NO-UNDO.
DEFINE VARIABLE gcTitle           AS CHARACTER NO-UNDO.
DEFINE VARIABLE gcFilter          AS CHARACTER NO-UNDO.

PROCEDURE CreateReportOnRuntimeDS EXTERNAL "{&CRPE_DLL}":
  DEFINE INPUT  PARAMETER phDataObject     AS HANDLE TO LONG.
  DEFINE INPUT  PARAMETER pcReportFile     AS CHARACTER.
  DEFINE INPUT  PARAMETER pcFieldEfile     AS CHARACTER.
  DEFINE INPUT  PARAMETER pcOverwrite      AS LONG.
  DEFINE INPUT  PARAMETER pcOpenCrystal    AS LONG.
  DEFINE RETURN PARAMETER pcReturnStatus   AS LONG.
END.

PROCEDURE CreateFieldDefFile EXTERNAL "{&CRPE_DLL}":
  DEFINE INPUT  PARAMETER phDataObject     AS HANDLE TO LONG.
  DEFINE INPUT  PARAMETER pcFieldEfile     AS CHARACTER.
  DEFINE INPUT  PARAMETER pcOverwrite      AS LONG.
  DEFINE RETURN PARAMETER pcReturnStatus   AS LONG.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 21.05
         WIDTH              = 82.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

{ry/app/ryplipmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-killPlip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE killPlip Procedure 
PROCEDURE killPlip :
/*------------------------------------------------------------------------------
  Purpose:     entry point to instantly kill the plip if it should get lost in memory
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN mip-release-report IN THIS-PROCEDURE.
RUN mip-close-datasource IN THIS-PROCEDURE ("dummytable",YES).

{ry/app/ryplipkill.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mip-close-datasource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mip-close-datasource Procedure 
PROCEDURE mip-close-datasource :
/*------------------------------------------------------------------------------
  Purpose:     Closes a Microsoft Data Access Object DAO
  Parameters:  pcDataTable - a unique string to identify the data table to destroy
               plSaveData  - if set to yes, the datatable is not deleted
  Notes:       This procedure only closes an valid, already open DAO
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pcDataTable          AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER plSaveData           AS LOGICAL    NO-UNDO.

IF VALID-HANDLE(ghRecordSet) THEN ghRecordSet:Close.
IF VALID-HANDLE(ghTables) AND NOT plSaveData THEN ghTables:Delete(pcDataTable).
IF VALID-HANDLE(ghDatabase)  THEN ghDatabase:Close.
IF VALID-HANDLE(ghWorkspace)  THEN ghWorkspace:Close.

RUN mip-release-datasource IN THIS-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mip-create-fielddef) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mip-create-fielddef Procedure 
PROCEDURE mip-create-fielddef :
/*------------------------------------------------------------------------------
  Purpose:     Creates a field definition file if given a valid recordset
  Parameters:  ip_recordset - a valid DAO recordset
               ip_filename  - crystal reports file definition to create 
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER ip_recordset AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER ip_filename  AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_returnstatus AS INTEGER.

    RUN CreateFieldDefFile(INTEGER(ghRecordSet),
                          ip_filename,
                          1,
                          OUTPUT lv_returnstatus).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mip-create-report-on-runtime) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mip-create-report-on-runtime Procedure 
PROCEDURE mip-create-report-on-runtime :
/*------------------------------------------------------------------------------
  Purpose:     Creates a field definition and crystal report file if given a valid recordset
  Parameters:  ip_recordset - a valid DAO recordset
               ip_template  - crystal reports template to create 
               ip_filename  - crystal reports file definition to create 
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER ip_recordset AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER ip_template  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER ip_filename  AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_returnstatus AS INTEGER.

/*This function is supposed to create a definition file and a report, given a 
  valid recordset, except, Seagate forgot to tell us it doesn't work
  However it does create a field definition file and a empty crystal report that
  can then be made into a template*/

 RUN CreateReportOnRuntimeDS(INTEGER(ghRecordSet),
                           ip_template,
                           ip_filename,
                           1,
                           1,
                           OUTPUT lv_returnstatus).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mip-design-report) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mip-design-report Procedure 
PROCEDURE mip-design-report :
/*------------------------------------------------------------------------------
  Purpose:     View the populated report in Design mode
  Parameters:  ip_newreport - The filename of the report to print
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER ip_newreport AS CHARACTER    NO-UNDO.

    DEFINE VARIABLE cAbort                        AS CHARACTER    NO-UNDO.      
    DEFINE VARIABLE cInsert                       AS CHARACTER    NO-UNDO.      
    DEFINE VARIABLE cErrorMessage                 AS CHARACTER    NO-UNDO.      

    CREATE VALUE(cRegReportEngine) ghApplication NO-ERROR.
    IF ERROR-STATUS:ERROR OR NOT VALID-HANDLE(ghApplication) THEN DO:
      ASSIGN
        cInsert = "create of report engine failed in mip-design-report " + ERROR-STATUS:GET-MESSAGE(1)
        cErrorMessage = {af/sup2/aferrortxt.i 'AF' '15' '?' '?' cInsert}.
      RUN showMessages IN gshSessionManager (INPUT cErrorMessage,
                                             INPUT "ERR":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "Crystal Print Error",
                                             INPUT YES,
                                             INPUT ?,
                                             OUTPUT cAbort).
        RUN mip-close-datasource in THIS-PROCEDURE ("dummyclose":U,NO).
        RETURN ERROR "ADM-ERROR":U.
    END.

    ASSIGN
        ghReport      = ghApplication:OpenReport(ip_newreport)
        ghRepDatabase = ghReport:Database
        ghRepTables   = ghRepDatabase:Tables
        ghRepTable    = ghRepTables:Item(1).

    IF ERROR-STATUS:ERROR THEN DO:
        ASSIGN
          cInsert = "create of report failed in mip-design-report " + ERROR-STATUS:GET-MESSAGE(1)
          cErrorMessage = {af/sup2/aferrortxt.i 'AF' '15' '?' '?' cInsert}.
        RUN showMessages IN gshSessionManager (INPUT cErrorMessage,
                                               INPUT "ERR":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "Crystal Print Error",
                                               INPUT YES,
                                               INPUT ?,
                                               OUTPUT cAbort).

        RUN mip-close-datasource in THIS-PROCEDURE ("dummyclose":U,NO).

        RUN mip-release-report.
        RETURN ERROR "ADM-ERROR":U.
    END.

    ghRepTable:SetPrivateData(3, ghRecordSet).
    ghReport:Visible = TRUE.

/*    RUN mip-release-report.*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mip-edit-report) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mip-edit-report Procedure 
PROCEDURE mip-edit-report :
/*------------------------------------------------------------------------------
  Purpose:     An all-in-one print edit procedure for Crystal reports
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt_datasource.
    DEFINE INPUT PARAMETER ip_database  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER ip_datatable AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER ip_savedata  AS LOGICAL   NO-UNDO.
    DEFINE INPUT PARAMETER ip_template  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER ip_newreport AS CHARACTER NO-UNDO.

    RUN mip-release-report      IN THIS-PROCEDURE.
    RUN mip-close-datasource    IN THIS-PROCEDURE ( INPUT ip_datatable,  INPUT NO           ).
    RUN mip-open-datasource     IN THIS-PROCEDURE ( INPUT ip_database                       ).
    RUN mip-init-datasource     IN THIS-PROCEDURE ( TABLE tt_datasource, INPUT ip_datatable ).
    RUN mip-populate-datasource IN THIS-PROCEDURE ( TABLE tt_datasource, INPUT ip_datatable ).
    RUN mip-populate-report     IN THIS-PROCEDURE ( INPUT ip_template,   INPUT ip_newreport ).
    RUN mip-design-report       IN THIS-PROCEDURE ( INPUT ip_newreport                      ).
    RUN mip-close-datasource    IN THIS-PROCEDURE ( INPUT ip_datatable,  INPUT YES          ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mip-init-datasource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mip-init-datasource Procedure 
PROCEDURE mip-init-datasource :
/*------------------------------------------------------------------------------
  Purpose:     Creates a Microsoft Data Access Object DAO from a Progress temp-table
  Parameters:  tt_datasource - Temptable to populate from
               ip_datatable - a unique string to identify the DAO data table
  Notes:       This procedure creates table definitions for an already open DAO
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER TABLE FOR tt_datasource.
DEFINE INPUT PARAMETER ip_datatable AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_counter    AS INTEGER NO-UNDO.
DEFINE VARIABLE lv_dll_result AS INTEGER NO-UNDO.

DEFINE VARIABLE cAbort                        AS CHARACTER    NO-UNDO.      
DEFINE VARIABLE cInsert                       AS CHARACTER    NO-UNDO.      
DEFINE VARIABLE cErrorMessage                 AS CHARACTER    NO-UNDO.      

IF NOT CAN-FIND(FIRST tt_datasource) THEN DO:
    ASSIGN
      cInsert = "no data is available to process in mip-init-datasource " + ERROR-STATUS:GET-MESSAGE(1)
      cErrorMessage = {af/sup2/aferrortxt.i 'AF' '15' '?' '?' cInsert}.
    RUN showMessages IN gshSessionManager (INPUT cErrorMessage,
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Crystal Print Error",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cAbort).
    RUN mip-close-datasource in THIS-PROCEDURE(ip_datatable,NO).
    RETURN ERROR "ADM-ERROR":U.
END.

IF NOT VALID-HANDLE(ghDatabase) THEN DO:
    ASSIGN
      cInsert = "handle to data engine is invalid in mip-init-datasource " + ERROR-STATUS:GET-MESSAGE(1)
      cErrorMessage = {af/sup2/aferrortxt.i 'AF' '15' '?' '?' cInsert}.
    RUN showMessages IN gshSessionManager (INPUT cErrorMessage,
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Crystal Print Error",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cAbort).
    RUN mip-close-datasource in THIS-PROCEDURE(ip_datatable,NO).
    RETURN ERROR "ADM-ERROR":U.
END.

FOR EACH tt_datasource NO-LOCK
    WHERE tt_datasource.tt_tag BEGINS "F":U:
    CASE tt_datasource.tt_tag:
        WHEN "F0":U THEN
            ASSIGN
                gcTitle  = tt_datasource.tt_value[1]
                gcFilter = tt_datasource.tt_value[2].
        WHEN "F1":U THEN
        DO lv_counter = 1 TO {&max-crystal-fields}:
            gcFieldNames[lv_counter] = tt_datasource.tt_value[lv_counter].
        END.
        WHEN "F2":U THEN
        DO lv_counter = 1 TO {&max-crystal-fields}:
            gcFieldLabels[lv_counter] = tt_datasource.tt_value[lv_counter].
        END.
        WHEN "F3":U THEN
        DO lv_counter = 1 TO {&max-crystal-fields}:
            gcFieldWidths[lv_counter] = STRING( INTEGER(tt_datasource.tt_value[lv_counter]) * {&pixels-per-char} ).
        END.
        WHEN "F4":U THEN
        DO lv_counter = 1 TO {&max-crystal-fields}:
            CASE SUBSTRING(tt_datasource.tt_value[lv_counter],1,4): 
                WHEN "LOGI":U THEN gcFieldDataTypes[lv_counter] = "1".
                WHEN "INTE":U THEN gcFieldDataTypes[lv_counter] = "3".
                WHEN "DECI":U THEN gcFieldDataTypes[lv_counter] = "7".
                WHEN "DATE":U THEN gcFieldDataTypes[lv_counter] = "8".
                OTHERWISE gcFieldDataTypes[lv_counter] = "10".
            END CASE.
        END.
    END CASE.
END.

/*have to be two different assigns, because you do not want to influence the error-status
 * of the second assign*/

ASSIGN
  lv_dll_result = ghTables:Delete(ip_datatable)
  NO-ERROR.

ASSIGN
    ghTable = ghDatabase:CreateTableDef(ip_datatable,,,)
    NO-ERROR.

IF ERROR-STATUS:ERROR OR NOT VALID-HANDLE(ghTable) THEN DO:
    ASSIGN
      cInsert = "create of data table failed in mip-init-datasource " + ERROR-STATUS:GET-MESSAGE(1)
      cErrorMessage = {af/sup2/aferrortxt.i 'AF' '15' '?' '?' cInsert}.
    RUN showMessages IN gshSessionManager (INPUT cErrorMessage,
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Crystal Print Error",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cAbort).

    RUN mip-close-datasource in THIS-PROCEDURE(ip_datatable,NO).
    RETURN ERROR "ADM-ERROR":U.
END.

DO lv_counter = 1 TO {&max-crystal-fields}:
    IF gcFieldNames[lv_counter] = "":U THEN NEXT.
/*message "Creation:" SKIP(1)
 *         gcFieldNames[lv_counter] SKIP
 *         gcFieldDataTypes[lv_counter]  SKIP
 *         gcFieldWidths[lv_counter]     SKIP
 *         INTEGER(INTEGER(gcFieldWidths[lv_counter]) / {&pixels-per-char}).*/
    ASSIGN
        ghField[lv_counter] = ghTable:CreateField(gcFieldNames[lv_counter],gcFieldDataTypes[lv_counter], 255 /*INTEGER(INTEGER(gcFieldWidths[lv_counter]) / {&pixels-per-char})*/ ) 
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:

        ASSIGN
          cInsert = "create of data table failed in mip-init-datasource " + ERROR-STATUS:GET-MESSAGE(1)
          cErrorMessage = {af/sup2/aferrortxt.i 'AF' '15' '?' '?' cInsert}.
        RUN showMessages IN gshSessionManager (INPUT cErrorMessage,
                                               INPUT "ERR":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "Crystal Print Error",
                                               INPUT YES,
                                               INPUT ?,
                                               OUTPUT cAbort).
        RUN mip-close-datasource in THIS-PROCEDURE(ip_datatable,NO).
        RETURN ERROR "ADM-ERROR":U.
    END.
    ASSIGN
        lv_dll_result = ghTable:Fields:Append(ghField[lv_counter]) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        ASSIGN
          cInsert = "append of data table failed in mip-init-datasource " + ERROR-STATUS:GET-MESSAGE(1)
          cErrorMessage = {af/sup2/aferrortxt.i 'AF' '15' '?' '?' cInsert}.
        RUN showMessages IN gshSessionManager (INPUT cErrorMessage,
                                               INPUT "ERR":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "Crystal Print Error",
                                               INPUT YES,
                                               INPUT ?,
                                               OUTPUT cAbort).


    END.
END.    

IF ERROR-STATUS:ERROR THEN DO:
    ASSIGN
      cInsert = "create of fields failed in mip-init-datasource " + ERROR-STATUS:GET-MESSAGE(1)
      cErrorMessage = {af/sup2/aferrortxt.i 'AF' '15' '?' '?' cInsert}.
    RUN showMessages IN gshSessionManager (INPUT cErrorMessage,
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Crystal Print Error",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cAbort).

    RUN mip-close-datasource in THIS-PROCEDURE(ip_datatable,NO).
    RETURN ERROR "ADM-ERROR":U.
END.

ghDatabase:Tabledefs:Append(ghTable).
IF ERROR-STATUS:ERROR THEN DO:
    ASSIGN
      cInsert = "create of tables failed in mip-init-datasource " + ERROR-STATUS:GET-MESSAGE(1)
      cErrorMessage = {af/sup2/aferrortxt.i 'AF' '15' '?' '?' cInsert}.
    RUN showMessages IN gshSessionManager (INPUT cErrorMessage,
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Crystal Print Error",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cAbort).
    RUN mip-close-datasource in THIS-PROCEDURE(ip_datatable,NO).
    RETURN ERROR "ADM-ERROR":U.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mip-object-description) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mip-object-description Procedure 
PROCEDURE mip-object-description :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER op_description AS CHARACTER NO-UNDO.

ASSIGN op_description = "Crystal Reports PLIP".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mip-open-datasource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mip-open-datasource Procedure 
PROCEDURE mip-open-datasource :
/*------------------------------------------------------------------------------
  Purpose:     Open a Microsoft Data Access Object DAO
  Parameters:  ip_database = name of a valid database
  Notes:       This procedure only opens an valid DAO
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER ip_database AS CHARACTER NO-UNDO.


DEFINE VARIABLE cAbort                        AS CHARACTER    NO-UNDO.      
DEFINE VARIABLE cInsert                       AS CHARACTER    NO-UNDO.      
DEFINE VARIABLE cErrorMessage                 AS CHARACTER    NO-UNDO.      

CREATE VALUE(cRegDataEngine) ghDataObject NO-ERROR.
IF ERROR-STATUS:ERROR OR NOT VALID-HANDLE(ghDataObject) THEN DO:
    ASSIGN
      cInsert = "create of data engine failed in mip-open-datasource " + ERROR-STATUS:GET-MESSAGE(1)
      cErrorMessage = {af/sup2/aferrortxt.i 'AF' '15' '?' '?' cInsert}.
    RUN showMessages IN gshSessionManager (INPUT cErrorMessage,
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Crystal Print Error",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cAbort).
    RUN mip-close-datasource in THIS-PROCEDURE (ip_database,NO).
    RETURN ERROR "ADM-ERROR":U.
END.

ASSIGN
    ghDataObject:defaulttype = 1
    ghWorkspace = ghDataObject:CreateWorkspace("Workspace":U,"Admin":U,"",2)
    NO-ERROR.

IF ERROR-STATUS:ERROR OR NOT VALID-HANDLE(ghWorkspace) THEN DO:
    ASSIGN
      cInsert = "create of data engine workspace failed in mip-open-datasource " + ERROR-STATUS:GET-MESSAGE(1)
      cErrorMessage = {af/sup2/aferrortxt.i 'AF' '15' '?' '?' cInsert}.
    RUN showMessages IN gshSessionManager (INPUT cErrorMessage,
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Crystal Print Error",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cAbort).
    RUN mip-close-datasource in THIS-PROCEDURE (ip_database,NO).
    RETURN ERROR "ADM-ERROR":U.
END.

ASSIGN
    ghDatabase  = ghWorkspace:OpenDataBase(ip_database,ghWorkspace,,)
    NO-ERROR.

IF ERROR-STATUS:ERROR OR NOT VALID-HANDLE(ghDatabase) THEN DO:
    ASSIGN
      cInsert = "datasource open failed in mip-open-datasource " + ERROR-STATUS:GET-MESSAGE(1)
      cErrorMessage = {af/sup2/aferrortxt.i 'AF' '15' '?' '?' cInsert}.
    RUN showMessages IN gshSessionManager (INPUT cErrorMessage,
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Crystal Print Error",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cAbort).
    RUN mip-close-datasource in THIS-PROCEDURE (ip_database,NO).
    RETURN ERROR "ADM-ERROR":U.
END.

ASSIGN
    ghTables    = ghDatabase:TableDefs
    NO-ERROR.

IF ERROR-STATUS:ERROR OR NOT VALID-HANDLE(ghTables) THEN DO:
    ASSIGN
      cInsert = "datatable open failed in mip-open-datasource " + ERROR-STATUS:GET-MESSAGE(1)
      cErrorMessage = {af/sup2/aferrortxt.i 'AF' '15' '?' '?' cInsert}.
    RUN showMessages IN gshSessionManager (INPUT cErrorMessage,
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Crystal Print Error",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cAbort).
    RUN mip-close-datasource in THIS-PROCEDURE (ip_database,NO).
    RETURN ERROR "ADM-ERROR":U.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mip-populate-datasource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mip-populate-datasource Procedure 
PROCEDURE mip-populate-datasource :
/*------------------------------------------------------------------------------
  Purpose:     Populates a Microsoft Data Access Object DAO from a Progress temp-table
  Parameters:  tt_datasource - Temptable to populate from
               ip_datatable - a unique string to identify the DAO data table
  Notes:       This procedure only populates an already open DAO with Progress temp-table data
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER TABLE        FOR tt_datasource.
DEFINE INPUT PARAMETER ip_datatable AS CHARACTER NO-UNDO.

DEFINE VARIABLE lv_counter          AS INTEGER  NO-UNDO.
DEFINE VARIABLE lv_value_string     AS CHARACTER    NO-UNDO.

DEFINE VARIABLE cAbort                        AS CHARACTER    NO-UNDO.      
DEFINE VARIABLE cInsert                       AS CHARACTER    NO-UNDO.      
DEFINE VARIABLE cErrorMessage                 AS CHARACTER    NO-UNDO.      

ASSIGN
    ghRecordSet = ghDatabase:OpenRecordSet(ip_datatable,,,)
    NO-ERROR.

IF ERROR-STATUS:ERROR OR NOT VALID-HANDLE(ghRecordSet) THEN DO:
    ASSIGN
      cInsert = "create of recordset failed in mip-populate-datasource " + ERROR-STATUS:GET-MESSAGE(1)
      cErrorMessage = {af/sup2/aferrortxt.i 'AF' '15' '?' '?' cInsert}.
    RUN showMessages IN gshSessionManager (INPUT cErrorMessage,
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Crystal Print Error",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cAbort).
    RUN mip-close-datasource in THIS-PROCEDURE(ip_datatable,NO).
    RETURN ERROR "ADM-ERROR":U.
END.

FOR EACH tt_datasource NO-LOCK
    WHERE tt_datasource.tt_tag = "D":U:

    ghRecordSet:AddNew.
    DO lv_counter = 1 TO ghRecordSet:Fields:Count:

        ASSIGN
            lv_value_string = SUBSTRING(tt_datasource.tt_value[lv_counter],1,INTEGER(INTEGER(gcFieldWidths[lv_counter]) / {&pixels-per-char}))
            ghRecordSet:Fields(lv_counter - 1):Value = ( IF lv_value_string = "":U OR lv_value_string = ? THEN " ":U ELSE lv_value_string )
            NO-ERROR.

        IF ERROR-STATUS:ERROR THEN DO:

/*assign ghRecordSet:fields(lv_counter - 1):Value = "The full user name s".*/
/*message "Error Number: " error-status:get-number(1) SKIP
 *         "Field Name: " gcFieldNames[lv_counter] SKIP
 *         "Width: " gcFieldWidths[lv_counter] SKIP
 *         "Label: " gcFieldLabels[lv_counter] SKIP
 *         "Data Width: " LENGTH(tt_datasource.tt_value[lv_counter]) * {&pixels-per-char} SKIP
 *         "Other Data Width: " LENGTH(tt_datasource.tt_value[lv_counter - 1]) * {&pixels-per-char} SKIP
 *         "Other Data Width: " LENGTH(tt_datasource.tt_value[lv_counter + 1]) * {&pixels-per-char} SKIP
 *         "Actual Data: " SUBSTRING(tt_datasource.tt_value[lv_counter],1,INTEGER(INTEGER(gcFieldWidths[lv_counter]) / {&pixels-per-char})) SKIP
 *         "Field Written: " ghRecordSet:Fields(lv_counter - 1):Value.*/

            ASSIGN
              cInsert = "create of recordset field data failed in mip-populate-datasource " + ERROR-STATUS:GET-MESSAGE(1)
              cErrorMessage = {af/sup2/aferrortxt.i 'AF' '15' '?' '?' cInsert}.
            RUN showMessages IN gshSessionManager (INPUT cErrorMessage,
                                                   INPUT "ERR":U,
                                                   INPUT "OK":U,
                                                   INPUT "OK":U,
                                                   INPUT "OK":U,
                                                   INPUT "Crystal Print Error",
                                                   INPUT YES,
                                                   INPUT ?,
                                                   OUTPUT cAbort).
            RUN mip-close-datasource in THIS-PROCEDURE(ip_datatable,NO).
            RETURN ERROR "ADM-ERROR":U.
        END.
    END.
    ghRecordSet:Update(,).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mip-populate-report) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mip-populate-report Procedure 
PROCEDURE mip-populate-report :
/*------------------------------------------------------------------------------
  Purpose:     Populates a Crystal reports report from a DAO 
  Parameters:  ip_template  - The crystal reports template to use for printing
               ip_newreport - The filename of the report to print
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER ip_template            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER ip_newreport           AS CHARACTER NO-UNDO.

  DEFINE VARIABLE lv_returnstatus               AS INTEGER NO-UNDO.
  DEFINE VARIABLE lv_counter                    AS INTEGER NO-UNDO.
  DEFINE VARIABLE lv_left                       AS INTEGER NO-UNDO.
  DEFINE VARIABLE lv_toowide                    AS LOGICAL NO-UNDO.

  DEFINE VARIABLE lv_object_left                AS INTEGER NO-UNDO.
  DEFINE VARIABLE lv_object_width               AS INTEGER NO-UNDO.

  DEFINE VARIABLE lv_field_width                AS INTEGER NO-UNDO.

  DEFINE VARIABLE lv_section_width              AS INTEGER NO-UNDO.

  DEFINE VARIABLE cAbort                        AS CHARACTER    NO-UNDO.      
  DEFINE VARIABLE cInsert                       AS CHARACTER    NO-UNDO.      
  DEFINE VARIABLE cErrorMessage                 AS CHARACTER    NO-UNDO.      

  RUN mip-release-report IN THIS-PROCEDURE.

  CREATE VALUE(cRegReportDesign) ghApplication NO-ERROR.

  IF ERROR-STATUS:ERROR
  OR NOT VALID-HANDLE(ghApplication)
  THEN DO:
    ASSIGN
      cInsert = "create of report design failed in mip-populate-report " + ERROR-STATUS:GET-MESSAGE(1)
      cErrorMessage = {af/sup2/aferrortxt.i 'AF' '15' '?' '?' cInsert}.
    RUN showMessages IN gshSessionManager (INPUT cErrorMessage,
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Crystal Print Error",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cAbort).
    RUN mip-release-report in THIS-PROCEDURE.
    RETURN ERROR "ADM-ERROR":U.
  END.

  /* Master */
  ASSIGN
    ghReport                = ghApplication:OpenReport(ip_template,1)
    ghSections              = ghReport:Sections
    ghReport:ReportTitle    = gcTitle
    ghReport:ReportComments = gcFilter
    NO-ERROR.

  /* Section - Page Header */
  ASSIGN
    ghSection               = ghSections:Item(2) /* Page Header */
    ghRepObjects            = ghSection:ReportObjects
    lv_left                 = 100
    lv_toowide              = NO
    NO-ERROR.

  IF ERROR-STATUS:ERROR
  OR NOT VALID-HANDLE(ghApplication)
  THEN DO:
    ASSIGN
      cInsert = "open of label report objects failed in mip-populate-repor " + ERROR-STATUS:GET-MESSAGE(1)
      cErrorMessage = {af/sup2/aferrortxt.i 'AF' '15' '?' '?' cInsert}.
    RUN showMessages IN gshSessionManager (INPUT cErrorMessage,
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Crystal Print Error",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cAbort).
    RUN mip-release-report in THIS-PROCEDURE.
    RETURN ERROR "ADM-ERROR":U.
  END.

  ASSIGN
    lv_section_width = ghSection:width
    NO-ERROR.
  IF lv_section_width = ?
  OR lv_section_width = 0
  THEN
    ASSIGN
      lv_section_width = giMaxPageWidth.

  DO lv_counter = 1 to ghRepObjects:Count:

    ASSIGN
      lv_field_width  = INTEGER(gcFieldWidths[lv_counter]).

    IF gcFieldWidths[lv_counter] = ?
    OR lv_field_width = 0
    THEN
      ASSIGN
        lv_toowide = YES.

    IF NOT lv_toowide
    THEN DO:

      ASSIGN
        ghRepObject       = ghRepObjects:Item(lv_counter)
        lv_object_left    = INTEGER(lv_left)
        lv_object_width   = MIN( lv_field_width , ( lv_section_width - INTEGER(lv_left) ) )
        ghRepObject:left  = lv_object_left
        ghRepObject:width = lv_object_width
        lv_left           = lv_left + lv_object_width + {&pixels-per-char}
        NO-ERROR.

      IF ERROR-STATUS:ERROR
      OR NOT VALID-HANDLE(ghApplication)
      THEN DO:
        ASSIGN
          cInsert       = "column label # ":U + STRING(lv_counter)
                 + "~n" + " Width ":U         + gcFieldWidths[lv_counter]
                 + "~n" + " Left ":U          + STRING(lv_left)
                 + "~n" + " failed in mip-populate-report ":U
                 + "~n" + ERROR-STATUS:GET-MESSAGE(1)
          cErrorMessage = {af/sup2/aferrortxt.i 'AF' '15' '?' '?' cInsert}.
        RUN showMessages IN gshSessionManager (INPUT cErrorMessage,
                                               INPUT "ERR":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "Crystal Print Error",
                                               INPUT YES,
                                               INPUT ?,
                                               OUTPUT cAbort).

        RUN mip-release-report in THIS-PROCEDURE.
        RETURN ERROR "ADM-ERROR":U.
      END.

      ghRepObject:settext(SUBSTRING(gcFieldLabels[lv_counter],1,INTEGER(INTEGER(ghRepObject:width) / {&pixels-per-char}))).

      IF lv_left >= lv_section_width
      THEN
        lv_toowide = YES.

    END.    
    ELSE DO:

      ASSIGN
          ghRepObject = ghRepObjects:Item(lv_counter)
          ghRepObject:suppress = 1
          NO-ERROR.
      IF ERROR-STATUS:ERROR
      OR NOT VALID-HANDLE(ghApplication)
      THEN DO:
        ASSIGN
          cInsert = "oversize column label # " + STRING(lv_counter) + " failed in mip-populate-report " + ERROR-STATUS:GET-MESSAGE(1)
          cErrorMessage = {af/sup2/aferrortxt.i 'AF' '15' '?' '?' cInsert}.
        RUN showMessages IN gshSessionManager (INPUT cErrorMessage,
                                               INPUT "ERR":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "Crystal Print Error",
                                               INPUT YES,
                                               INPUT ?,
                                               OUTPUT cAbort).
        RUN mip-release-report in THIS-PROCEDURE.
        RETURN ERROR "ADM-ERROR":U.
      END.

    END.

  END.

  /* Section - Page Detail */
  ASSIGN
    ghSection     = ghSections:Item(3) /* Page Detail */
    ghRepObjects  = ghSection:ReportObjects
    lv_left       = 100
    lv_toowide    = NO
    NO-ERROR.

  IF ERROR-STATUS:ERROR
  OR NOT VALID-HANDLE(ghApplication)
  THEN DO:
    ASSIGN
      cInsert = "open of field report objects failed in mip-populate-report " + ERROR-STATUS:GET-MESSAGE(1)
      cErrorMessage = {af/sup2/aferrortxt.i 'AF' '15' '?' '?' cInsert}.
    RUN showMessages IN gshSessionManager (INPUT cErrorMessage,
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Crystal Print Error",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cAbort).


    RUN mip-release-report in THIS-PROCEDURE.
    RETURN ERROR "ADM-ERROR":U.
  END.

  ASSIGN
    lv_section_width = ghSection:width
    NO-ERROR.
  IF lv_section_width = ?
  OR lv_section_width = 0
  THEN
    ASSIGN
      lv_section_width = giMaxPageWidth.

  DO lv_counter = 1 to ghRepObjects:Count:

    ASSIGN
      lv_field_width  = INTEGER(gcFieldWidths[lv_counter]).

    IF gcFieldWidths[lv_counter] = ?
    OR lv_field_width = 0
    THEN lv_toowide = YES.

    IF NOT lv_toowide
    THEN DO:

      ASSIGN
        ghRepObject       = ghRepObjects:Item(lv_counter)
        lv_object_left    = INTEGER(lv_left)
        lv_object_width   = MIN( lv_field_width , ( lv_section_width - INTEGER(lv_left) ) )
        ghRepObject:left  = lv_object_left
        ghRepObject:width = lv_object_width
        lv_left           = lv_left + lv_object_width + {&pixels-per-char}
        NO-ERROR.

      IF ERROR-STATUS:ERROR
      OR NOT VALID-HANDLE(ghApplication)
      THEN DO:
          ASSIGN
            cInsert = "field-sizing # " + STRING(lv_counter) + " failed in mip-populate-report " + ERROR-STATUS:GET-MESSAGE(1)
            cErrorMessage = {af/sup2/aferrortxt.i 'AF' '15' '?' '?' cInsert}.
          RUN showMessages IN gshSessionManager (INPUT cErrorMessage,
                                                 INPUT "ERR":U,
                                                 INPUT "OK":U,
                                                 INPUT "OK":U,
                                                 INPUT "OK":U,
                                                 INPUT "Crystal Print Error",
                                                 INPUT YES,
                                                 INPUT ?,
                                                 OUTPUT cAbort).
          RUN mip-release-report in THIS-PROCEDURE.
          RETURN ERROR "ADM-ERROR":U.
      END.

      IF lv_left >= lv_section_width
      THEN
        ASSIGN
          lv_toowide = YES.

    END.
    ELSE DO:

      ASSIGN
        ghRepObject = ghRepObjects:Item(lv_counter)
        ghRepObject:suppress = 1
        NO-ERROR.
      IF ERROR-STATUS:ERROR
      OR NOT VALID-HANDLE(ghApplication) THEN DO:
        ASSIGN
          cInsert = "field-shrinking # " + STRING(lv_counter) + " failed in mip-populate-report " + ERROR-STATUS:GET-MESSAGE(1)
          cErrorMessage = {af/sup2/aferrortxt.i 'AF' '15' '?' '?' cInsert}.
        RUN showMessages IN gshSessionManager (INPUT cErrorMessage,
                                               INPUT "ERR":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "Crystal Print Error",
                                               INPUT YES,
                                               INPUT ?,
                                               OUTPUT cAbort).
        RUN mip-release-report in THIS-PROCEDURE.
        RETURN ERROR "ADM-ERROR":U.
      END.

    END.

  END.

  ghReport:Save(ip_newreport).

  RUN mip-release-report IN THIS-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mip-print-report) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mip-print-report Procedure 
PROCEDURE mip-print-report :
/*------------------------------------------------------------------------------
  Purpose:     An all-in-one print procedure for Crystal reports
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt_datasource.
    DEFINE INPUT PARAMETER ip_database  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER ip_datatable AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER ip_savedata  AS LOGICAL   NO-UNDO.
    DEFINE INPUT PARAMETER ip_template  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER ip_newreport AS CHARACTER NO-UNDO.

    DEFINE VARIABLE li-int AS INTEGER.

/*
  {af/sup/afdebug.i}
*/
/*
  MESSAGE
    SKIP "Template : " ip_template
    SKIP "Report   : " ip_newreport
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

  FOR EACH tt_datasource NO-LOCK:
    DO li-int = 1 TO 20:
      MESSAGE
        SKIP "Tag   : " tt_tag
        SKIP "Value : " STRING(li-int,"99") " " tt_value[li-int]
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
  END.
*/

    RUN mip-release-report      IN THIS-PROCEDURE.
    RUN mip-close-datasource    IN THIS-PROCEDURE ( INPUT ip_datatable,  INPUT NO           ).
    RUN mip-open-datasource     IN THIS-PROCEDURE ( INPUT ip_database                       ).
    RUN mip-init-datasource     IN THIS-PROCEDURE ( TABLE tt_datasource, INPUT ip_datatable ).
    RUN mip-populate-datasource IN THIS-PROCEDURE ( TABLE tt_datasource, INPUT ip_datatable ).
    RUN mip-populate-report     IN THIS-PROCEDURE ( INPUT ip_template,   INPUT ip_newreport ).
    RUN mip-view-report         IN THIS-PROCEDURE ( INPUT ip_newreport                      ).
    RUN mip-close-datasource    IN THIS-PROCEDURE ( INPUT ip_datatable,  INPUT YES          ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mip-release-datasource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mip-release-datasource Procedure 
PROCEDURE mip-release-datasource :
/*------------------------------------------------------------------------------
  Purpose:     Releases all com-handles used for the datasource
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE lv_counter      AS INTEGER NO-UNDO.

DO lv_counter = 1 TO {&max-crystal-fields}:
    IF VALID-HANDLE(ghField[lv_counter]) THEN RELEASE OBJECT ghField[lv_counter] NO-ERROR.
END.

IF VALID-HANDLE(ghRecordSet) THEN RELEASE OBJECT ghRecordSet NO-ERROR.
IF VALID-HANDLE(ghTable) THEN RELEASE OBJECT ghTable NO-ERROR.
IF VALID-HANDLE(ghTables) THEN RELEASE OBJECT ghTables NO-ERROR.
IF VALID-HANDLE(ghDatabase) THEN RELEASE OBJECT ghDatabase NO-ERROR.
IF VALID-HANDLE(ghWorkspace) THEN RELEASE OBJECT ghWorkspace NO-ERROR.
IF VALID-HANDLE(ghDataObject) THEN RELEASE OBJECT ghDataObject NO-ERROR.

ASSIGN
  ghRecordSet = ?
  ghTable = ?
  ghTables = ?
  ghDatabase = ?
  ghWorkspace = ?
  ghDataObject = ?
  .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mip-release-report) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mip-release-report Procedure 
PROCEDURE mip-release-report :
/*------------------------------------------------------------------------------
  Purpose:     Releases all com-handles used for crystal report
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE lv_loop     AS INTEGER  NO-UNDO.

    IF VALID-HANDLE( ghRepOptions  ) THEN RELEASE OBJECT ghRepOptions     NO-ERROR.
    IF VALID-HANDLE( ghRepTable    ) THEN RELEASE OBJECT ghRepTable       NO-ERROR.
    IF VALID-HANDLE( ghRepTables   ) THEN RELEASE OBJECT ghRepTables      NO-ERROR.
    IF VALID-HANDLE( ghRepDatabase ) THEN RELEASE OBJECT ghRepDatabase    NO-ERROR.
    IF VALID-HANDLE( ghRepObject   ) THEN RELEASE OBJECT ghRepObject      NO-ERROR.
    IF VALID-HANDLE( ghRepObjects  ) THEN RELEASE OBJECT ghRepObjects     NO-ERROR.
    IF VALID-HANDLE( ghSection     ) THEN RELEASE OBJECT ghSection        NO-ERROR.
    IF VALID-HANDLE( ghSections    ) THEN RELEASE OBJECT ghSections       NO-ERROR.
    IF VALID-HANDLE( ghReport      ) THEN RELEASE OBJECT ghReport         NO-ERROR.
    IF VALID-HANDLE( ghApplication ) THEN RELEASE OBJECT ghApplication    NO-ERROR.

    ASSIGN
      ghRepOptions = ?
      ghRepTable = ?
      ghRepTables = ?
      ghRepDatabase = ?
      ghRepObject = ?
      ghRepObjects = ?
      ghSection = ?
      ghSections = ?
      ghReport = ?
      ghApplication = ?
      .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mip-view-report) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mip-view-report Procedure 
PROCEDURE mip-view-report :
/*------------------------------------------------------------------------------
  Purpose:     View the populated report in Print Preview mode
  Parameters:  ip_newreport - The filename of the report to print
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER ip_newreport AS CHARACTER    NO-UNDO.


    DEFINE VARIABLE cAbort                        AS CHARACTER    NO-UNDO.      
    DEFINE VARIABLE cInsert                       AS CHARACTER    NO-UNDO.      
    DEFINE VARIABLE cErrorMessage                 AS CHARACTER    NO-UNDO.      

    CREATE VALUE(cRegReportEngine) ghApplication NO-ERROR.
    IF ERROR-STATUS:ERROR OR NOT VALID-HANDLE(ghApplication) THEN DO:
        ASSIGN
          cInsert = "create of report engine failed in mip-view-report " + ERROR-STATUS:GET-MESSAGE(1)
          cErrorMessage = {af/sup2/aferrortxt.i 'AF' '15' '?' '?' cInsert}.
        RUN showMessages IN gshSessionManager (INPUT cErrorMessage,
                                               INPUT "ERR":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "Crystal Print Error",
                                               INPUT YES,
                                               INPUT ?,
                                               OUTPUT cAbort).
        RUN mip-close-datasource in THIS-PROCEDURE ("dummyclose":U,NO).
        RETURN ERROR "ADM-ERROR":U.
    END.

    ASSIGN
        ghReport      = ghApplication:OpenReport(ip_newreport)
        ghRepDatabase = ghReport:Database
        ghRepTables   = ghRepDatabase:Tables
        ghRepTable    = ghRepTables:Item(1)
        ghRepOptions  = ghReport:PrintWindowOptions
        ghRepOptions:CanDrillDown          = YES
        ghRepOptions:HasCancelButton       = YES
        ghRepOptions:HasCloseButton        = YES
        ghRepOptions:HasExportButton       = YES
        ghRepOptions:HasGroupTree          = YES
        ghRepOptions:HasNavigationControls = YES
        ghRepOptions:HasPrintButton        = YES
        ghRepOptions:HasPrintSetupButton   = YES
        ghRepOptions:HasProgressControls   = YES
        ghRepOptions:HasRefreshButton      = NO
        ghRepOptions:HasSearchButton       = YES
        ghRepOptions:HasZoomControl        = YES.

    IF ERROR-STATUS:ERROR THEN DO:
        ASSIGN
          cInsert = "create of report failed in mip-view-report " + ERROR-STATUS:GET-MESSAGE(1)
          cErrorMessage = {af/sup2/aferrortxt.i 'AF' '15' '?' '?' cInsert}.
        RUN showMessages IN gshSessionManager (INPUT cErrorMessage,
                                               INPUT "ERR":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "Crystal Print Error",
                                               INPUT YES,
                                               INPUT ?,
                                               OUTPUT cAbort).
        RUN mip-close-datasource in THIS-PROCEDURE ("dummyclose":U,NO).

        RUN mip-release-report.
        RETURN ERROR "ADM-ERROR":U.
    END.

    ghRepTable:SetPrivateData(3, ghRecordSet).
    ghReport:Preview.

/*    RUN mip-release-report.*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-objectDescription) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE objectDescription Procedure 
PROCEDURE objectDescription :
/*------------------------------------------------------------------------------
  Purpose:     Pass out a description of the PLIP, used in Plip temp-table
  Parameters:  <none>
  Notes:       This should be changed manually for each plip
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER cDescription AS CHARACTER NO-UNDO.

ASSIGN cDescription = "Dynamics Crystal PLIP".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipSetup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipSetup Procedure 
PROCEDURE plipSetup :
/*------------------------------------------------------------------------------
  Purpose:    Run by main-block of PLIP at startup of PLIP
  Parameters: <none>
  Notes:       
------------------------------------------------------------------------------*/

  {ry/app/ryplipsetu.i}

  /* Get the values for Crystal Reports from the Repository */
  DEFINE VARIABLE cKeyReportDesign      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDefaultReportDesign  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyReportEngine      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDefaultReportEngine  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyDataEngine        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDefaultDataEngine    AS CHARACTER  NO-UNDO.

  ASSIGN
    cKeyReportDesign = "CrystalRuntime.Application"  cDefaultReportDesign = "CrystalRuntime.Application.7"
    cKeyReportEngine = "Crystal.CRPE.Application"    cDefaultReportEngine = "Crystal.CRPE.Application"
    cKeyDataEngine   = "DAO.DBEngine.35"             cDefaultDataEngine   = "DAO.DBEngine.35"
    .

  ASSIGN
    cRegReportDesign = cDefaultReportDesign
    cRegReportEngine = cDefaultReportEngine
    cRegDataEngine   = cDefaultDataEngine
    .

  /* cRegReportDesign */
  LOAD cKeyReportDesign BASE-KEY "HKEY_CLASSES_ROOT":U NO-ERROR.
  IF NOT ERROR-STATUS:ERROR
  THEN DO:
    USE cKeyReportDesign.
    GET-KEY-VALUE SECTION "CurVer":U KEY DEFAULT VALUE cRegReportDesign.
  END. /* then */
  UNLOAD cKeyReportDesign NO-ERROR.

  /* cRegReportEngine */
  LOAD cKeyReportEngine BASE-KEY "HKEY_CLASSES_ROOT":U NO-ERROR.
  IF NOT ERROR-STATUS:ERROR
  THEN DO:
    ASSIGN
      cRegReportEngine = cDefaultReportEngine.
  END. /* then */
  UNLOAD cKeyReportEngine NO-ERROR.

  /* cRegDataEngine */
  /* Find DAO.DBEngine.35 */
  LOAD cKeyDataEngine BASE-KEY "HKEY_CLASSES_ROOT":U NO-ERROR.
  IF NOT ERROR-STATUS:ERROR
  THEN DO:
    ASSIGN
      cRegDataEngine = cDefaultDataEngine.
  END. /* then */
  UNLOAD cKeyDataEngine NO-ERROR.

  /* Try and find DAO.DBEngine.36 if available
  LOAD "DAO.DBEngine.36":U BASE-KEY "HKEY_CLASSES_ROOT":U NO-ERROR.
  IF NOT ERROR-STATUS:ERROR
  THEN DO:
    ASSIGN
      cRegDataEngine = "DAO.DBEngine.36".
  END. /* then */
  UNLOAD "DAO.DBEngine.36":U NO-ERROR.
  */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipShutDown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutDown Procedure 
PROCEDURE plipShutDown :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will be run just before the calling program 
               terminates
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN mip-release-report IN THIS-PROCEDURE.
RUN mip-close-datasource IN THIS-PROCEDURE ("dummytable",YES).

{ry/app/ryplipshut.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

