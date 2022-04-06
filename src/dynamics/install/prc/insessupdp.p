&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
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
/*---------------------------------------------------------------------------------
  File: insessupdp.p

  Description:  Session Update

  Purpose:      Session Update

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/03/2002  Author:     Bruce S Gruenbaum

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       insessupdp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}
DEFINE STREAM sLogFile.

DEFINE VARIABLE ghStatusWin AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghDSAPI     AS HANDLE     NO-UNDO.
DEFINE VARIABLE glStreamOpen  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE gcLogFile     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcPhysSess   AS CHARACTER  NO-UNDO.


/* This temp-table is used to pass parameters into import deployment dataset */
DEFINE TEMP-TABLE ttImportParam NO-UNDO
  FIELD cParam             AS CHARACTER
  FIELD cValue             AS CHARACTER
  INDEX dx IS PRIMARY
    cParam
  .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-figureOutLogFileName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD figureOutLogFileName Procedure 
FUNCTION figureOutLogFileName RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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
         HEIGHT             = 20.24
         WIDTH              = 59.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/* Start the Dataset API procedure */
RUN startProcedure IN THIS-PROCEDURE ("ONCE|af/app/gscddxmlp.p":U, 
                                      OUTPUT ghDSAPI).

gcPhysSess = DYNAMIC-FUNCTION("getPhysicalSessionType":U IN THIS-PROCEDURE).
IF gcPhysSess = "GUI":U THEN
DO:
  RUN startProcedure IN THIS-PROCEDURE ("ONCE|install/obj/instatuswin.w":U, 
                                        OUTPUT ghStatusWin).
  RUN initializeObject IN ghStatusWin.
  SUBSCRIBE PROCEDURE ghStatusWin TO "setStatus":U IN THIS-PROCEDURE.
END.

SUBSCRIBE TO "setStatus":U    IN THIS-PROCEDURE
    RUN-PROCEDURE "DCU_WriteLog":U.
SUBSCRIBE TO "DCU_WriteLog":U ANYWHERE.

gcLogFile = figureOutLogFileName().

OUTPUT STREAM sLogFile TO VALUE(gcLogFile) APPEND UNBUFFERED.  
glStreamOpen = YES.

RUN applyUpdates.

glStreamOpen = NO.
OUTPUT STREAM sLogFile CLOSE.

IF VALID-HANDLE(ghStatusWin) THEN
  APPLY "CLOSE":U TO ghStatusWin.
APPLY "CLOSE":U TO ghDSAPI.

IF ERROR-STATUS:ERROR OR
   (RETURN-VALUE <> "":U AND
    RETURN-VALUE <> ?) THEN
  RETURN ERROR RETURN-VALUE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-applyUpdates) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyUpdates Procedure 
PROCEDURE applyUpdates :
/*------------------------------------------------------------------------------
  Purpose:     Loops through any outstanding updates in the framework database
               and applies them.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cStatus    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iTotalRecs AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iRecCount  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cLastDB    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLastVer   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFile      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessage   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lError     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hTT        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cRetVal    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cADO       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lFail      AS LOGICAL    NO-UNDO.
  define variable iDeltaVersion as integer no-undo.

  DEFINE BUFFER bttImportParam       FOR ttImportParam.
  DEFINE BUFFER bryt_dbupdate_status FOR ryt_dbupdate_status.

  DEFINE QUERY qUpdate               FOR bryt_dbupdate_status.

  /* Create the input parameter that decides the modified status
     for the import routine. Users can reset this after the load. */
  DO FOR bttImportParam:
    CREATE bttImportParam.
    ASSIGN
      bttImportParam.cParam = "SetModified":U
      bttImportParam.cValue = "YES":U
    .
  END.

  /* Open the query -- we're using a preselect to be able to find out
     how many rows there are */
  OPEN QUERY qUpdate
    PRESELECT EACH bryt_dbupdate_status NO-LOCK
      WHERE bryt_dbupdate_status.update_completed = NO 
        AND bryt_dbupdate_status.update_when > 6
        BY bryt_dbupdate_status.update_db_name
        BY bryt_dbupdate_status.delta_version
        BY bryt_dbupdate_status.update_when
        BY bryt_dbupdate_status.run_sequence.
        
   /* Get the first record in the query and number of rows */
  GET FIRST qUpdate NO-LOCK.
  iTotalRecs = NUM-RESULTS("qUpdate":U).

  /* Loop through all the records in the qUpdate query giving us all
     the ryt_dbupdate status records that we need to do the update */
  REPEAT WHILE NOT QUERY-OFF-END("qUpdate":U):

    ASSIGN
      cMessage  = "":U
      iRecCount = iRecCount + 1
      lError = NO
      cStatus   = SUBSTITUTE("&1 of &2: ":U, STRING(iRecCount), STRING(iTotalRecs))
    .

    /* findFile is in the config file manager. It figures out the path to the file 
       on disk. */
    cFile = DYNAMIC-FUNCTION("findFile":U IN THIS-PROCEDURE,
                             bryt_dbupdate_status.file_name).

    /* If the file name is unknown, we have an error. */
    IF SEARCH(cFile) = ? THEN
    DO:
      IF bryt_dbupdate_status.file_type = "p":U THEN
      DO:
        IF SUBSTRING(bryt_dbupdate_status.file_name,LENGTH(bryt_dbupdate_status.file_name) - 1) = ".p":U OR
           SUBSTRING(bryt_dbupdate_status.file_name,LENGTH(bryt_dbupdate_status.file_name) - 1) = ".w":U THEN
          cFile = DYNAMIC-FUNCTION("findFile":U IN THIS-PROCEDURE,
                                   SUBSTRING(bryt_dbupdate_status.file_name,1,LENGTH(bryt_dbupdate_status.file_name) - 1) + "r":u).
      END.

      IF SEARCH(cFile) = ? THEN
      DO:
        cMessage = SUBSTITUTE("File &1 not found":U, bryt_dbupdate_status.file_name).
        lError = YES.
      END.
    END.

    /* If there's no error, process this update */
    IF NOT lError THEN
    DO:
        if bryt_dbupdate_status.delta_version ne iDeltaVersion then
        do:
            publish 'setStatus':u from this-procedure ('Updating DB Version sequence for ' + bryt_dbupdate_status.update_db_name).
            run install/prc/inicfdbsqp.p (bryt_dbupdate_status.update_db_name,
                                          bryt_dbupdate_status.delta_version) no-error.
            if error-status:error or return-value ne '':u then
                publish 'setStatus':u from this-procedure ('Unable to update DB to patch level ' 
                                                            + string(bryt_dbupdate_status.delta_version, '999999':u)).
        end.    /* first DBname */
        
      CASE bryt_dbupdate_status.file_type:
        WHEN "p":U THEN      /* For procedure files, run them. */
        DO:
          cStatus = cStatus + "Running ":U + bryt_dbupdate_status.file_name + " from " + cFile.
          PUBLISH "setStatus":U FROM THIS-PROCEDURE (INPUT cStatus).
          RUN VALUE(cFile) NO-ERROR.

        END.
        WHEN "ado":U THEN  /* For ADO files, call the deployment API's Import routine */
        DO:
          cFile = REPLACE(cFile,"//":U,"/":U).      
          cADO  = REPLACE(bryt_dbupdate_status.file_name,"//":U,"/":U).
          cStatus = cStatus + "Loading ":U + cADO + " from " + cFile.
          PUBLISH "setStatus":U FROM THIS-PROCEDURE (INPUT cStatus).
          cFile   = SUBSTRING(cFile,1,LENGTH(cFile) - LENGTH(cADO) - 1).
          cRetVal = "":U.

          RUN importDeploymentDataset IN ghDSAPI
            (cADO,
             cFile,
             '',
             YES,
             YES,
             NO,
             INPUT TABLE ttImportParam,
             INPUT TABLE-HANDLE hTT,
             OUTPUT cRetVal) NO-ERROR.

        END.
      END.
    END.

    /* If we have any type of error come back from the call we just made, set the error
       flag */
    IF ERROR-STATUS:ERROR OR 
       (RETURN-VALUE <> ? AND
        RETURN-VALUE <> "":U) OR
       (cRetVal <> "":U AND
        cRetVal <> "?":U) THEN 
    DO:
      ERROR-STATUS:ERROR = NO.
      lError = YES.
      IF RETURN-VALUE <> ? AND
         RETURN-VALUE <> "":U THEN
        cMessage = RETURN-VALUE.
      IF cRetVal <> ? AND
         cRetVal <> "":U AND
         cMessage = "":U THEN
        cMessage = cRetVal.

    END.
    
    IF lError AND 
       bryt_dbupdate_status.update_mandatory THEN
        lFail = YES.
    
    /* Update the patch record to indicate we just ran this update */
    RUN updatePatchRecord (ROWID(bryt_dbupdate_status),
                           cMessage,
                           NOT lError,
                           NOT lFail). 

    IF lFail THEN
      RETURN ERROR cMessage.
    
    iDeltaVersion = bryt_dbupdate_status.delta_version.
    
    GET NEXT qUpdate NO-LOCK.
    PROCESS EVENTS.
  END.

  /* Now we need to clear the class cache for the object types */
  IF VALID-HANDLE(gshRepositoryManager) THEN
    RUN destroyClassCache IN gshRepositoryManager.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-DCU_WriteLog) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DCU_WriteLog Procedure 
PROCEDURE DCU_WriteLog :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcStatus AS CHARACTER  NO-UNDO.

  IF glStreamOpen THEN
  DO:
    pcStatus = "[":U + STRING(TODAY,"99/99/9999":U) + " ":U + STRING(TIME,"HH:MM:SS":U) + "]  ":U
            + pcStatus.
    PUT STREAM sLogFile UNFORMATTED
      pcStatus SKIP.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updatePatchRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updatePatchRecord Procedure 
PROCEDURE updatePatchRecord :
/*------------------------------------------------------------------------------
  Purpose:     Updates the database's ryt_dbupdate_status record.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER rRowid     AS ROWID      NO-UNDO.
  DEFINE INPUT  PARAMETER pcResult   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plSuccess  AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plComplete AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE oUserObj AS DECIMAL NO-UNDO.

  DEFINE BUFFER bryt_dbupdate_status FOR ryt_dbupdate_status.
  
  /* Get the user obj */
  oUserObj = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                              "currentUserObj":U,
                               YES)).

  /* Find the ryt_dbupdate_status record and update it */
  DO FOR bryt_dbupdate_status TRANSACTION:
    FIND bryt_dbupdate_status 
      WHERE ROWID(bryt_dbupdate_status) = rRowid.
    ASSIGN
      bryt_dbupdate_status.update_completed   = plComplete
      bryt_dbupdate_status.update_successful  = plSuccess
      bryt_dbupdate_status.return_result      = pcResult
      bryt_dbupdate_status.run_date           = TODAY
      bryt_dbupdate_status.run_time           = TIME
      bryt_dbupdate_status.run_by_user_obj    = oUserObj
    .
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-figureOutLogFileName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION figureOutLogFileName Procedure 
FUNCTION figureOutLogFileName RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Figures out the name of a log file to write the log to. 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFile AS CHARACTER  NO-UNDO.

  cFile = "dcu.log":U.

  cFile = SEARCH(cFile).

  IF cFile = ? THEN
    cFile = "dcu.log":U.

  RETURN cFile.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

