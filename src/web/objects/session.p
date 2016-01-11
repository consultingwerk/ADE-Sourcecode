&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2001 by Progress Software Corporation ("PSC"),       *
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
*  pdigre@progress.com                                               *
*  mbaker@progress.com                                               *
*                                                                    *
**********************************************************************/
/*------------------------------------------------------------------------
    File        : session.p
    Purpose     : file-based session handling

    Syntax      :

    Description :

    Author(s)   : Per Digre, 
    Created     :
    Notes       :
    
    Changes     : mattB 5/23/01 updated for use with Dynamics
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

  DEFINE NEW GLOBAL SHARED VARIABLE web-utilities-hdl AS HANDLE    NO-UNDO.
  DEFINE NEW GLOBAL SHARED VARIABLE gscSessionId      AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cLogPath         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cSessionFile     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cGlobalFile      AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE SessionNames     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE SessionValues    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSessionCookie   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE SessionSave      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE GlobalNames      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE GlobalValues     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE GlobalSave       AS LOGICAL    NO-UNDO.
  
  DEFINE STREAM s1.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getGlobal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getGlobal Procedure 
FUNCTION getGlobal RETURNS CHARACTER
  ( INPUT cName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSession) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSession Procedure 
FUNCTION getSession RETURNS CHARACTER
  ( INPUT cName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSessionFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSessionFile Procedure 
FUNCTION getSessionFile RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSessionId) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSessionId Procedure 
FUNCTION getSessionId RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initGlobal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initGlobal Procedure 
FUNCTION initGlobal RETURNS LOGICAL PRIVATE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initSession) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initSession Procedure 
FUNCTION initSession RETURNS LOGICAL PRIVATE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-saveGlobal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD saveGlobal Procedure 
FUNCTION saveGlobal RETURNS LOGICAL PRIVATE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-saveSession) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD saveSession Procedure 
FUNCTION saveSession RETURNS LOGICAL PRIVATE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setGlobal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setGlobal Procedure 
FUNCTION setGlobal RETURNS LOGICAL
  ( INPUT cName AS CHARACTER,
    INPUT cValue AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSession) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSession Procedure 
FUNCTION setSession RETURNS LOGICAL
  ( INPUT cName  AS CHARACTER,
    INPUT cValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSessionId) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSessionId Procedure 
FUNCTION setSessionId RETURNS LOGICAL
  ( INPUT cSessionId AS CHARACTER)  FORWARD.

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
         HEIGHT             = 17.1
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
  RUN SUPER NO-ERROR.
  IF gscSessionId > "" THEN DO:
    saveGlobal().
    saveSession().
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-end-request) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE end-request Procedure 
PROCEDURE end-request :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN SUPER.
  IF gscSessionId > "" THEN DO:
    saveGlobal().
    saveSession().
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-endSession) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE endSession Procedure 
PROCEDURE endSession :
/*------------------------------------------------------------------------------
  Purpose:     removes all references to session data for the current session
  Parameters:  <none>
  Notes:       this procedure should only be run in the case where a user logs off
               or something similar since all data is cleared from the file system
               and removed from memory.
------------------------------------------------------------------------------*/

  ASSIGN
    SessionNames  = ?
    SessionValues = "".

  OS-DELETE VALUE(cSessionFile).
  setSessionId ("").

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
  gscSessionId   = "batch".  
  RUN SUPER NO-ERROR.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-init-request) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-request Procedure 
PROCEDURE init-request :
/*------------------------------------------------------------------------------
  Purpose:     initializes session variables and forces a re-read of
               session data
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE c1 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i1 AS INTEGER    NO-UNDO.
  
  gscSessionId = "".
  IF cSessionCookie > "" THEN DO:    /** Allow externally set cookies, like for ASP ***/
    ASSIGN
      c1 = DYNAMIC-FUNCTION("get-value":U IN web-utilities-hdl, ?)
      i1 = INDEX(c1,cSessionCookie).
    IF i1 > 0 THEN
      gscSessionId = DYNAMIC-FUNCTION("get-value" IN web-utilities-hdl,entry(1,substring(c1,i1))).
  END.
  IF gscSessionId = "" THEN
    gscSessionId = IF SESSION:SERVER-CONNECTION-ID > "" THEN ENCODE(SESSION:SERVER-CONNECTION-ID) ELSE "SYS":U.
  ASSIGN
    SessionNames = ?
    GlobalNames  = ?
    cSessionFile = cLogPath + "/":U + gscSessionId + ".tmp":U.
  IF OPSYS = "win32":U THEN
    cSessionFile = REPLACE(cSessionFile, "/":U, "~\":U).

  RUN SUPER.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-init-session) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-session Procedure 
PROCEDURE init-session :
/*------------------------------------------------------------------------------
  Purpose:     initialize some variables needed by the session manager
  Parameters:  <none>
  Notes:       this procedure is executed when the "init-session" published
               event occurs.
------------------------------------------------------------------------------*/
  RUN SUPER.
  /* if a logging directory has not been specified, then make it the session
     temporary directory */
     
  ASSIGN
    cSessionCookie = DYNAMIC-FUNCTION ("getAgentSetting":U IN web-utilities-hdl,
                          "Session":U, "":U, "Cookie":U)
    cLogPath = DYNAMIC-FUNCTION ("getAgentSetting":U IN web-utilities-hdl,
                          "Session":U, "":U, "StorePath":U)
    cGlobalFile = cLogPath + "/" + WEB-CONTEXT:CONFIG-NAME + ".tmp".
  IF OPSYS = "win32":U THEN
    cGlobalFile = REPLACE(cGlobalFile, "/", "~\").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getGlobal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getGlobal Procedure 
FUNCTION getGlobal RETURNS CHARACTER
  ( INPUT cName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  returns a chr(3) delimited list of values that have been specifed
            for the entire session.
    Notes:  
------------------------------------------------------------------------------*/
  
  IF GlobalNames = ? THEN 
    initGlobal().
  
  IF cName = ? THEN 
    RETURN GlobalNames.

  RETURN ENTRY(LOOKUP(cName,GlobalNames) + 1,CHR(3) + GlobalValues,CHR(3)).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSession) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSession Procedure 
FUNCTION getSession RETURNS CHARACTER
  ( INPUT cName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  returns a chr(3) delimited list of values that were set by set-session
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE LookupValues AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iNameCount   AS INTEGER   NO-UNDO.
  DEFINE VARIABLE j            AS INTEGER   NO-UNDO.

  IF SessionNames = ? THEN 
    initSession().
  
  IF cName = ? THEN 
    RETURN SessionNames.

  iNameCount = NUM-ENTRIES(cName).

  /* Append each value to a chr(3) delimited list */
  DO j = 1 TO iNameCount:
    LookUpValues =  LookupValues + ( IF j <> 1 THEN CHR(3) ELSE "" ) + ENTRY(LOOKUP(ENTRY(j, cName),SessionNames) + 1, CHR(3) + SessionValues,CHR(3)).
  END.
  
  RETURN LookupValues.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSessionFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSessionFile Procedure 
FUNCTION getSessionFile RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  returns the name of the file used to store information
            for the current session data
    Notes:  
------------------------------------------------------------------------------*/
  
  RETURN cSessionFile.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSessionId) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSessionId Procedure 
FUNCTION getSessionId RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  returns the session id that is currently in use
    Notes:  
------------------------------------------------------------------------------*/

  RETURN gscSessionId.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initGlobal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initGlobal Procedure 
FUNCTION initGlobal RETURNS LOGICAL PRIVATE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  imports the names and values of each global session setting
    Notes:  
------------------------------------------------------------------------------*/
  IF SEARCH(cGlobalFile) = ? THEN 
    ASSIGN 
      GlobalNames  = ""
      GlobalValues = "".
  ELSE DO:
    INPUT  STREAM s1 FROM VALUE(cGlobalFile).
    IMPORT STREAM s1 UNFORMATTED GlobalNames.
    IMPORT STREAM s1 UNFORMATTED GlobalValues.
    INPUT  STREAM s1 CLOSE.
  END.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initSession) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initSession Procedure 
FUNCTION initSession RETURNS LOGICAL PRIVATE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  imports session name/value pairs
    Notes:  
------------------------------------------------------------------------------*/


  IF SEARCH(cSessionFile) = ? THEN DO:
    ASSIGN 
      SessionNames  = ""
      SessionValues = "". 
  END.
  ELSE DO:
    INPUT  STREAM s1 FROM VALUE(cSessionFile).
    IMPORT STREAM s1 UNFORMATTED SessionNames.
    IMPORT STREAM s1 UNFORMATTED SessionValues.
    INPUT  STREAM s1 CLOSE.
  END.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-saveGlobal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION saveGlobal Procedure 
FUNCTION saveGlobal RETURNS LOGICAL PRIVATE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  saves global name/value pairs
    Notes:  
------------------------------------------------------------------------------*/

  IF GlobalNames > "" THEN DO:
    OUTPUT STREAM s1 TO VALUE(cGlobalFile).
    PUT    STREAM s1 UNFORMATTED GlobalNames SKIP.
    PUT    STREAM s1 UNFORMATTED GlobalValues SKIP.
    OUTPUT STREAM s1 CLOSE.
  END.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-saveSession) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION saveSession Procedure 
FUNCTION saveSession RETURNS LOGICAL PRIVATE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  writes session data out to disk
    Notes:  
------------------------------------------------------------------------------*/

  IF SessionNames > "" THEN DO:
    OUTPUT STREAM s1 TO VALUE(cSessionFile).
    PUT    STREAM s1 UNFORMATTED SessionNames skip.
    PUT    STREAM s1 UNFORMATTED SessionValues skip.
    OUTPUT STREAM s1 CLOSE.
  END.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setGlobal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setGlobal Procedure 
FUNCTION setGlobal RETURNS LOGICAL
  ( INPUT cName AS CHARACTER,
    INPUT cValue AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  assigns and saves a global session variable that will become
            available to all agents within this session
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE i1          AS INTEGER NO-UNDO.
  DEFINE VARIABLE iNameCount  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cWorkName   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cWorkValue  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE i3          AS INTEGER NO-UNDO.

  IF GlobalNames = ? THEN 
    initGlobal().
  
  iNameCount = NUM-ENTRIES(cName, ",").

  DO i3 = 1 TO iNameCount:
    ASSIGN 
      cWorkName       = ENTRY(i3,cName)
      cWorkValue      = ENTRY(i3, cValue, CHR(3))
      i1              = LOOKUP(cWorkName,GlobalNames)
      GlobalSave = TRUE.

    IF i1 = 0 THEN
      ASSIGN
        GlobalValues = GlobalValues + (IF GlobalNames > "" THEN CHR(3) ELSE "") + cWorkValue
        GlobalNames  = GlobalNames  + (IF GlobalNames > "" THEN "," ELSE "") + cWorkName.
    ELSE 
      ASSIGN
        ENTRY(i1,GlobalValues,CHR(3)) = cWorkValue.
  END.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSession) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSession Procedure 
FUNCTION setSession RETURNS LOGICAL
  ( INPUT cName  AS CHARACTER,
    INPUT cValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  assigns and saves a session variable
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE i1          AS INTEGER NO-UNDO.
  DEFINE VARIABLE iNameCount  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cWorkName   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cWorkValue  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE i3          AS INTEGER NO-UNDO.

  IF SessionNames = ? THEN 
    initSession().
  
  iNameCount = NUM-ENTRIES(cName, ",").

  DO i3 = 1 TO iNameCount:
    ASSIGN 
      cWorkName       = ENTRY(i3,cName)
      cWorkValue      = ENTRY(i3, cValue, CHR(3))
      i1              = LOOKUP(cWorkName,SessionNames)
      SessionSave = TRUE.

    IF i1 = 0 THEN
      ASSIGN
        SessionValues = SessionValues + (IF SessionNames > "" THEN CHR(3) ELSE "") + cWorkValue
        SessionNames  = SessionNames  + (IF SessionNames > "" THEN "," ELSE "") + cWorkName.
    ELSE 
      ASSIGN
        ENTRY(i1,SessionValues,CHR(3)) = cWorkValue.
  END.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSessionId) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSessionId Procedure 
FUNCTION setSessionId RETURNS LOGICAL
  ( INPUT cSessionId AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  override the standard sessionid as provided 
            by SESSION:SERVER-CONNECTION-ID
    Notes:  
------------------------------------------------------------------------------*/

  ASSIGN 
    gscSessionId = cSessionId.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

