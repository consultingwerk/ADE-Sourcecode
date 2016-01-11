&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************
* Copyright (C) 2000,2015 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                             *
*                                                                      *
************************************************************************/
/*--------------------------------------------------------------------

  File: webstart.p

  Description: Load all the standard super procedures needed as configured.
               This file should only have handle declarations, PERSISTENT
               RUN statements of the procedures to be "super'd", and the
               adding of the procedure handles to the super call stack of
               THIS-PROCEDURE.

  Input Parameters:
      <none>
  Output Parameters:
      <none>

--------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
{ src/web/method/webutils.i }

DEFINE NEW GLOBAL SHARED VARIABLE web-utilities-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE cSuperStack AS CHARACTER  NO-UNDO.
DEFINE TEMP-TABLE ttSuper
  FIELD ttProc   AS CHARACTER
  FIELD ttHandle AS HANDLE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getEnv) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getEnv Procedure
function getEnv returns character 
  (pcName as char) forward.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


&IF DEFINED(EXCLUDE-getSuperHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSuperHandle Procedure 
FUNCTION getSuperHandle RETURNS HANDLE
  (INPUT cSuper AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSuperStack) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSuperStack Procedure 
FUNCTION getSuperStack RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSuperStack) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSuperStack Procedure 
FUNCTION setSuperStack RETURNS CHARACTER
  ( INPUT cSupers AS CHARACTER )  FORWARD.

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
 
/* make sure that THIS-PROCEDURE is a valid handle */
web-utilities-hdl = this-procedure.

/* Start the WebSpeed standard utilities. */
cSuperStack = "web/objects/web-util.p".

/* State-aware support if not explicitly refused or is missing (for backward compatability). 
   NOTE: paswebstart used for PAS includes this procedure, in order to override a getEnv() 
         and will return "no" for "STATE_AWARE_ENABLED"  (multi-session-agent() in web-util 
         is not avail yet here)  */
IF getEnv("STATE_AWARE_ENABLED":U) <> "no":U THEN
  cSuperStack = "web/objects/stateaware.p," + cSuperStack.
    
/* Handles development propath modifications, this only functions
   in a development environment. */
IF getEnv("MULTI_DEV_PROPATH":U) > "" THEN
  cSuperStack = cSuperStack + ",web/objects/devpath.p".

/* Handles logging of individual web requests. */
IF getEnv("LOG_TYPES":U) > "" THEN
  cSuperStack = cSuperStack + ",web/objects/runlog.p".

/* Add DBTools. Has methods to handle all your DB needs */
IF getEnv("DATABASES":U) > "" THEN
  cSuperStack = cSuperStack + ",web/objects/dbtools.p".

/* File-based Session management. */
cSuperStack = cSuperStack + ",web/objects/session.p".

IF (SESSION:ICFPARAMETER > "") THEN
  /* Start the Dynamics environment. */
  cSuperStack = cSuperStack + ",ry/app/rywebspeed.p".

/* Handles customized SUPER functionality.  Adds Super functionality to
   init-session, init-request, end-request, if specified. */
IF getEnv("SUPER_PROC":U) > "" THEN
  cSuperStack = cSuperStack + "," + getEnv("SUPER_PROC":U).

setSuperStack(cSuperStack). /** Start super procedures **/
RUN init-config.   /** Set environment based configuration variables (allows override before init-session) **/
RUN init-session.  /** Init-session **/

/* set trigger to clean up the procedure */
ON "close":U OF THIS-PROCEDURE DO:
  setSuperStack(""). 
  if error-status:get-number(1) <> 6456 then
      run captureErrs.
  DELETE PROCEDURE THIS-PROCEDURE.
  ERROR-STATUS:ERROR = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-captureErrs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE captureErrs Procedure 
PROCEDURE captureErrs :
/*------------------------------------------------------------------------------
  Purpose:  Capture errors set by error-status and forward to server-log
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cErrList AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iErr     AS INTEGER    NO-UNDO.
  DO iErr = 1 TO ERROR-STATUS:NUM-MESSAGES:
    MESSAGE "ERROR:" ERROR-STATUS:GET-MESSAGE(iErr).
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF
&IF DEFINED(EXCLUDE-destroy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroy Procedure 
PROCEDURE destroy :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  APPLY "close":U TO THIS-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getEnv) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getEnv Procedure
function getEnv returns character 
  (pcName as char  ):
/*------------------------------------------------------------------------------
 Purpose: wrap call to os-getenv for override 
 Notes:
------------------------------------------------------------------------------*/
	return OS-GETENV(pcName).
    
end function.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ENDIF


&IF DEFINED(EXCLUDE-getSuperHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSuperHandle Procedure 
FUNCTION getSuperHandle RETURNS HANDLE
  (INPUT cSuper AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/
  FIND FIRST ttSuper WHERE ttSuper.ttProc = cSuper NO-ERROR.
  IF AVAILABLE ttSuper THEN
        RETURN ttSuper.ttHandle.
  ELSE
        RETURN ?.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSuperStack) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSuperStack Procedure 
FUNCTION getSuperStack RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/

  RETURN cSuperStack.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSuperStack) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSuperStack Procedure 
FUNCTION setSuperStack RETURNS CHARACTER
  ( INPUT cSupers AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Sets the order and starts the associated super procedures
    Notes: keeps this-procedure last in super stack if itself a super of web-utilities-hdl
------------------------------------------------------------------------------*/
    define variable i1         as integer    no-undo.

    assign cSuperStack = cSupers.
    
    /* Remove from web-utilities-hdl and clean up unwanted SUPERs */
    for each ttSuper:  
        web-utilities-hdl:remove-super-procedure(ttSuper.ttHandle).
        if lookup(ttSuper.ttProc,cSupers) = 0 then 
        do:
            if valid-handle(ttSuper.ttHandle) then 
            do:
                run destroy in ttSuper.ttHandle no-error.
                if error-status:get-number(1) <> 6456 then
                    run captureErrs.
            end.
            if valid-handle(ttSuper.ttHandle) then
                delete procedure ttSuper.ttHandle no-error.
            
            delete ttSuper.
        end.
    end.

    /* Start new SUPERs if necessary and add to web-utilities-hdl handle */
    do i1 = 1 to num-entries(cSupers):
        if entry(i1,cSupers) = "" then next.
        find first ttSuper where ttSuper.ttProc = ENTRY(i1,cSupers) no-error.
        if not avail ttSuper then 
        do:
            create ttSuper.
            assign ttSuper.ttProc = entry(i1,cSupers).
            run VALUE(ttSuper.ttProc) persistent set ttSuper.ttHandle.
        end.
        web-utilities-hdl:add-super-procedure(ttSuper.ttHandle,search-target).
    end.
   
    return "".   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

