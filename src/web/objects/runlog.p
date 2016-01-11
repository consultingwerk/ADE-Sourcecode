&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000-2003 by Progress Software Corporation ("PSC"),  *
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
*   pdigre@progress.com                                              *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
    File        : runlog.p 
    Purpose     : handles logging of procedures

    Syntax      :

    Description :

    Author(s)   : mbaker@progress.com
    Created     : 5/24/2001
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Name of the program we're about to run */
DEFINE NEW GLOBAL SHARED VARIABLE web-utilities-hdl AS HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE AppProgram        AS CHARACTER NO-UNDO FORMAT "x(40)".
DEFINE NEW GLOBAL SHARED VARIABLE REQUEST_METHOD    AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gscSessionId      AS CHARACTER NO-UNDO.

DEFINE VARIABLE cRunLog   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLogTypes AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLogPath  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lNoCache  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE iEtime    AS INTEGER    NO-UNDO.

DEFINE STREAM logger.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getLogFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLogFile Procedure 
FUNCTION getLogFile RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-logNote) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD logNote Procedure 
FUNCTION logNote RETURNS LOGICAL
  ( INPUT pcLogType AS CHARACTER,
    INPUT pcLogText AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-logWrite) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD logWrite Procedure 
FUNCTION logWrite RETURNS LOGICAL
  ()  FORWARD.

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-end-batch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE end-batch Procedure 
PROCEDURE end-batch :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  logNote("BATCH":U, "End batch: " + 
             STRING(YEAR(TODAY),"9999":U) + "/" +
             STRING(MONTH(TODAY),"99":U) + "/" +
             STRING(DAY(TODAY),"99":U) + " " +
             STRING(TIME,"HH:MM:SS":U) + "~n").
  logWrite().
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-end-request) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE end-request Procedure 
PROCEDURE end-request :
/*------------------------------------------------------------------------------
  Purpose:     Write a log note indicating the end of a web request.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN SUPER.
  logNote("RUN":U, "End webrequest: " +              
             STRING(YEAR(TODAY),"9999":U) + "/" +
             STRING(MONTH(TODAY),"99":U) + "/" +
             STRING(DAY(TODAY),"99":U) + " " +
             STRING(TIME,"HH:MM:SS":U) + "~n").
  logWrite().
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-init-batch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-batch Procedure 
PROCEDURE init-batch :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  ASSIGN
    iEtime = ETIME(TRUE) 
    iEtime = 0.

  IF CAN-DO(cLogTypes,"BATCH") AND cLogPath NE "" THEN  
    cRunLog = " ~n":U + 
             STRING(YEAR(TODAY),"9999":U) + "/" +
             STRING(MONTH(TODAY),"99":U) + "/" +
             STRING(DAY(TODAY),"99":U) + " " +
             STRING(TIME,"HH:MM:SS":U) + " " + 
             " BATCH ~n".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-init-config) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-config Procedure 
PROCEDURE init-config :
/*------------------------------------------------------------------------------
  Purpose:     Initial configuration for logging
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE c1         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE c2         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i1         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lRetVal    AS LOGICAL    NO-UNDO.
  
  /* Logging.  Not just a canadian thing anymore
  */ 
  ASSIGN 
    c1      = REPLACE(OS-GETENV("LOG_TYPES":U),";",",")
    c1      = (IF c1 EQ "" OR c1 = ? THEN "*" ELSE c1)
    lRetVal = DYNAMIC-FUNCTION("setAgentSetting" IN web-utilities-hdl,
                "Logging":U,"","LogTypes":U,c1).

  ASSIGN 
    c1                  = OS-GETENV("LOG_PATH":U)
    FILE-INFO:FILE-NAME = c1 NO-ERROR.
  IF FILE-INFO:FULL-PATHNAME         EQ ? OR 
    INDEX(FILE-INFO:FILE-TYPE,"D":U) LT 1 THEN
    ASSIGN c1 = SESSION:TEMP-DIR.
  lRetVal = DYNAMIC-FUNCTION("setAgentSetting" IN web-utilities-hdl,
              "Logging":U,"","LogDir":U, REPLACE (c1,"~\","~/")).

  RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-init-request) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-request Procedure 
PROCEDURE init-request :
/*------------------------------------------------------------------------------
  Purpose:     On the initialization of a web request we'll want to write out
               to the log file what was actually requested.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  ASSIGN
    iEtime = ETIME(TRUE) 
    iEtime = 0.

  RUN SUPER.

  IF CAN-DO(cLogTypes,"RUN") AND cLogPath NE "" THEN  
    cRunLog = " ~n":U + 
             STRING(YEAR(TODAY),"9999":U) + "/" +
             STRING(MONTH(TODAY),"99":U) + "/" +
             STRING(DAY(TODAY),"99":U) + " " +
             STRING(TIME,"HH:MM:SS":U) + " ":U + 
             " Program ("       +
             ENTRY(1,appProgram,".":U)       + 
             ", METHOD = ":U                 +
             REQUEST_METHOD                  + ") ":U + 
             WEB-CONTEXT:EXCLUSIVE-ID        + "~n".
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-init-session) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-session Procedure 
PROCEDURE init-session :
/*------------------------------------------------------------------------------
  Purpose:     initialize session level variables
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   /** setup Runlogging dir/logname **/
   ASSIGN 
     cLogTypes = DYNAMIC-FUNCTION ("getAgentSetting":U IN web-utilities-hdl,"Logging":U, "":U, "LogTypes":U)
     cLogPath  = DYNAMIC-FUNCTION ("getAgentSetting":U IN web-utilities-hdl,"Logging":U, "":U, "LogDir":U)
     lNoCache  = CAN-DO(cLogtypes,'NoCache').
   RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getLogFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLogFile Procedure 
FUNCTION getLogFile RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE cLogName   AS CHARACTER NO-UNDO.

  ASSIGN 
    cLogName   = cLogPath + "/" + gscSessionId + ".log":U.

  IF OPSYS = "win32":U THEN
    RETURN REPLACE(cLogName, "/", "~\").
  ELSE
    RETURN cLogName.   /* Function return value. */


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-logNote) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION logNote Procedure 
FUNCTION logNote RETURNS LOGICAL
  ( INPUT pcLogType AS CHARACTER,
    INPUT pcLogText AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Builds a log string for run time events into individual logs.
    Notes:  In order for everything to work right a session id must be 
            available.  In most cases this means that the messager session id 
            is turned on, the user does not have cookies blocked, and run 
            logging is turned on.
            It will save to disk only when it has reached a certain length or 
            when the web-request is done.
------------------------------------------------------------------------------*/
  IF pcLogText GT "" AND cLogPath NE "" AND CAN-DO(cLogTypes,pcLogType) THEN 
  DO:   
    ASSIGN 
      cRunLog     = cRunLog
                  + STRING(ENTRY(1,ENTRY(NUM-ENTRIES(PROGRAM-NAME(2),"/":U),PROGRAM-NAME(2),"/":U),".":U),"x(17)":U) 
                  + " ":U + (IF TRANSACTION THEN "TR ":U ELSE "   ":U)  
                  + STRING(ETIME MOD 10000000,">>>>>>9":U)
                  + " ":U + STRING((ETIME - iETIME) MOD 10000000,">>>>>>9":U)
                  + " ":U + pcLogText + "~n":U
      iETIME = ETIME.
     
    IF LENGTH(cRunLog) > 8000 OR lNoCache THEN logWrite().
  END.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-logWrite) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION logWrite Procedure 
FUNCTION logWrite RETURNS LOGICAL
  () :
/*------------------------------------------------------------------------------
  Purpose:  writes log information out to disk
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFile AS CHARACTER NO-UNDO.

  IF cRunLog GE "" THEN DO:
    cFile = getLogFile().    
    IF cFile > "" THEN DO:
      OUTPUT STREAM logger TO VALUE(cFile) APPEND KEEP-MESSAGES.
      PUT STREAM logger UNFORMATTED cRunLog.
      OUTPUT STREAM logger CLOSE.
    END.
  END.
  ASSIGN cRunLog = "".
  RETURN TRUE.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

