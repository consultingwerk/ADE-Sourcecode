&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
/* Procedure Description
"Super Procedure for Dynamic SmartDataViewer"
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------

  File: ryprofviewvsupr.p

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 04/21/03 - 11:00 am

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{src/adm2/globals.i}

DEFINE VARIABLE cNameList     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cValueList    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE raRunOnServer AS LOGICAL    NO-UNDO.
DEFINE VARIABLE fiDescription AS CHARACTER  NO-UNDO.
DEFINE VARIABLE fiFileName    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE fiDirectory   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE fiTraceFilter AS CHARACTER  NO-UNDO.
DEFINE VARIABLE fiTracing     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE toEnabled     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE toListings    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE toCoverage    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE raProfiling   AS LOGICAL    NO-UNDO.

DEFINE VARIABLE cCont AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hProc AS HANDLE     NO-UNDO EXTENT 60.
DEFINE VARIABLE cProc AS CHARACTER  NO-UNDO EXTENT 60.
DEFINE VARIABLE cType AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i     AS INTEGER    NO-UNDO.

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
   Allow: Basic,Browse,DB-Fields
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 18.52
         WIDTH              = 50.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/customsuper.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-buClose) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buClose Procedure 
PROCEDURE buClose :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF i > 0 AND VALID-HANDLE(hProc[i]) THEN DO:
        APPLY 'CLOSE' TO hProc[i].
        i = i - 1.
        IF i = 0 THEN 
            assignWidgetValue("cCont","").
        ELSE 
            assignWidgetValue("cCont",cProc[i]).
        {set DataModified NO}.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buLaunch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buLaunch Procedure 
PROCEDURE buLaunch :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    cCont = widgetValue("cCont").
    IF cCont = "" THEN RETURN.
    SESSION:SET-WAIT-STATE("GENERAL").
    ASSIGN
      i = i + 1
      cProc[i] = cCont.
    IF SEARCH(cCont) <> ? THEN
        RUN VALUE(cCont) PERSISTENT SET hProc[i].
    ELSE
        RUN launchContainer IN gshSessionManager (cCont,"","",NO,"","","","",?,?,?,OUTPUT hProc[i],OUTPUT cType).
    IF NOT VALID-HANDLE(hProc[i]) THEN i = i - 1.
    SESSION:SET-WAIT-STATE("").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN SUPER.

  IF NOT VALID-HANDLE(gshAstraAppserver) OR gshAstraAppServer = SESSION THEN
      disableWidget("raRunOnServer").

  RUN refreshValues IN TARGET-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newCoverage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE newCoverage Procedure 
PROCEDURE newCoverage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  SESSION:SET-WAIT-STATE("GENERAL").
  RUN setProfilerAttrs IN gshSessionManager 
      (INPUT raRunOnServer,
       INPUT "COVERAGE=" + widgetValue("toCoverage")).
  SESSION:SET-WAIT-STATE("").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newDescription) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE newDescription Procedure 
PROCEDURE newDescription :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  SESSION:SET-WAIT-STATE("GENERAL").
  fiDescription = widgetValue("fiDescription").
  RUN validateDescription IN TARGET-PROCEDURE.
  RUN setProfilerAttrs IN gshSessionManager 
      (INPUT raRunOnServer,
       INPUT "DESCRIPTION=" + fiDescription).
  SESSION:SET-WAIT-STATE("").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newDirectory) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE newDirectory Procedure 
PROCEDURE newDirectory :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  SESSION:SET-WAIT-STATE("GENERAL").
  fiDirectory = widgetValue("fiDirectory").
  RUN validateDirectory IN TARGET-PROCEDURE.
  RUN setProfilerAttrs IN gshSessionManager 
      (INPUT raRunOnServer,
       INPUT "DIRECTORY=" + fiDirectory).
  SESSION:SET-WAIT-STATE("").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newEnabled) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE newEnabled Procedure 
PROCEDURE newEnabled :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  SESSION:SET-WAIT-STATE("GENERAL").
  RUN setProfilerAttrs IN gshSessionManager 
      (INPUT raRunOnServer,
       INPUT "ENABLED=" + widgetValue("toEnabled")).
  SESSION:SET-WAIT-STATE("").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newFileName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE newFileName Procedure 
PROCEDURE newFileName :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  SESSION:SET-WAIT-STATE("GENERAL").
  fiFileName = widgetValue("fiFileName").
  RUN validateFileName IN TARGET-PROCEDURE.
  RUN setProfilerAttrs IN gshSessionManager 
      (INPUT raRunOnServer,
       INPUT "FILE-NAME=" + fiFileName).
  SESSION:SET-WAIT-STATE("").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newListings) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE newListings Procedure 
PROCEDURE newListings :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  SESSION:SET-WAIT-STATE("GENERAL").
  RUN setProfilerAttrs IN gshSessionManager 
      (INPUT raRunOnServer,
       INPUT "LISTINGS=" + widgetValue("toListings")).
  SESSION:SET-WAIT-STATE("").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newProfiling) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE newProfiling Procedure 
PROCEDURE newProfiling :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  SESSION:SET-WAIT-STATE("GENERAL").
  IF widgetValue("raProfiling") = "YES" THEN
      RUN startProfiling IN gshSessionManager (INPUT raRunOnServer).
  ELSE
      RUN stopProfiling IN gshSessionManager (INPUT raRunOnServer).
  SESSION:SET-WAIT-STATE("").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newTraceFilter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE newTraceFilter Procedure 
PROCEDURE newTraceFilter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  SESSION:SET-WAIT-STATE("GENERAL").
  fiTraceFilter = widgetValue("fiTraceFilter").
  RUN validateTraceFilter IN TARGET-PROCEDURE.
  RUN setProfilerAttrs IN gshSessionManager 
      (INPUT raRunOnServer,
       INPUT "TRACE-FILTER=" + fiTraceFilter).
  SESSION:SET-WAIT-STATE("").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newTracing) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE newTracing Procedure 
PROCEDURE newTracing :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  SESSION:SET-WAIT-STATE("GENERAL").
  fiTracing = widgetValue("fiTracing").
  RUN setProfilerAttrs IN gshSessionManager 
      (INPUT raRunOnServer,
       INPUT "TRACING=" + fiTracing).
  SESSION:SET-WAIT-STATE("").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-refreshValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshValues Procedure 
PROCEDURE refreshValues :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  raRunOnServer = widgetValue("raRunOnServer") = "YES".
  RUN getProfilerAttrs IN gshSessionManager (INPUT raRunOnServer,
                                            OUTPUT fiDescription,
                                            OUTPUT fiFileName,
                                            OUTPUT fiDirectory,
                                            OUTPUT fiTraceFilter,
                                            OUTPUT fiTracing,
                                            OUTPUT toEnabled,
                                            OUTPUT toListings,
                                            OUTPUT toCoverage,
                                            OUTPUT raProfiling).

  RUN validateDescription IN TARGET-PROCEDURE.
  RUN validateFileName    IN TARGET-PROCEDURE.
  RUN validateDirectory   IN TARGET-PROCEDURE.
  RUN validateTraceFilter IN TARGET-PROCEDURE.

  ASSIGN
    cNameList = "fiDescription,fiFileName,fiDirectory,fiTraceFilter,fiTracing,toEnabled,toListings,toCoverage,raProfiling"
    cValueList = fiDescription + "|" 
               + fiFileName + "|"
               + fiDirectory + "|"
               + fiTraceFilter + "|"
               + fiTracing + "|"
               + (IF toEnabled   THEN "YES" ELSE "NO") + "|"
               + (IF toListings  THEN "YES" ELSE "NO") + "|"
               + (IF toCoverage  THEN "YES" ELSE "NO") + "|"
               + (IF raProfiling THEN "YES" ELSE "NO").
   assignWidgetValueList(cNameList,cValueList,?).
   {set DataModified NO}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateDescription) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateDescription Procedure 
PROCEDURE validateDescription :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF fiDescription = ? OR fiDescription = "" THEN DO:
      fiDescription = IF raRunOnServer THEN "server" ELSE "client".
      assignWidgetValue("fiDescription",fiDescription).
      {set DataModified NO}.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateDirectory) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateDirectory Procedure 
PROCEDURE validateDirectory :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF fiDirectory = ? OR fiDirectory = "" THEN DO:
      fiDirectory = "profiler\temp".
      assignWidgetValue("fiDirectory",fiDirectory).
      {set DataModified NO}.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateFileName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateFileName Procedure 
PROCEDURE validateFileName :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF fiFileName = ? OR fiFileName = "" THEN DO:
      fiFileName = IF raRunOnServer THEN "server.out" ELSE "client.out".
      assignWidgetValue("fiFileName",fiFileName).
      {set DataModified NO}.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateTraceFilter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateTraceFilter Procedure 
PROCEDURE validateTraceFilter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF fiTraceFilter = ? THEN DO:
      fiTraceFilter = "".
      assignWidgetValue("fiTraceFilter",fiTraceFilter).
      {set DataModified NO}.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

