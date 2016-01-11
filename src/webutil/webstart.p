&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000-2002 by Progress Software Corporation ("PSC"),  *
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
* Contributors:  Per Digre/PSC, Chad Thompson/Bravepoint             *
*                                                                    *
*********************************************************************/
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
web-utilities-hdl = THIS-PROCEDURE.

/* Start the WebSpeed standard utilities. */
cSuperStack = "web/objects/web-util.p".

/* State-aware support if not explicitly refused or is missing (for backward
   compatability). */
IF OS-GETENV("STATE_AWARE_ENABLED":U) <> "no":U THEN
  cSuperStack = "web/objects/stateaware.p," + cSuperStack.

/* Handles development propath modifications, this only functions
   in a development environment. */
IF OS-GETENV("MULTI_DEV_PROPATH":U) > "" THEN
  cSuperStack = cSuperStack + ",web/objects/devpath.p".

/* Handles logging of individual web requests. */
IF OS-GETENV("LOG_TYPES":U) > "" THEN
  cSuperStack = cSuperStack + ",web/objects/runlog.p".

/* Add DBTools. Has methods to handle all your DB needs */
IF OS-GETENV("DATABASES":U) > "" THEN
  cSuperStack = cSuperStack + ",web/objects/dbtools.p".

/* File-based Session management. */
  cSuperStack = cSuperStack + ",web/objects/session.p".

IF (SESSION:ICFPARAMETER > "") THEN
  /* Start the Dynamics environment. */
  cSuperStack = cSuperStack + ",ry/app/rywebspeed.p".

/* Handles customized SUPER functionality.  Adds Super functionality to
   init-session, init-request, end-request, if specified. */
IF OS-GETENV("SUPER_PROC":U) > "" THEN
  cSuperStack = cSuperStack + "," + OS-GETENV("SUPER_PROC":U).

setSuperStack(cSuperStack). /** Start super procedures **/
RUN init-config.   /** Set environment based configuration variables (allows override before init-session) **/
RUN init-session.  /** Init-session **/

/* set trigger to clean up the procedure */
ON "close":U OF THIS-PROCEDURE DO:
  setSuperStack("").
  RUN captureErrs.
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
    Notes:
------------------------------------------------------------------------------*/
  DEFINE VARIABLE i1         AS INTEGER    NO-UNDO.

  ASSIGN cSuperStack = cSupers.

  /* Remove from web-utilities-hdl and clean up unwanted SUPERs */
  FOR EACH ttSuper:
    web-utilities-hdl:REMOVE-SUPER-PROCEDURE(ttSuper.ttHandle).
    IF NOT CAN-DO(cSupers, ttSuper.ttProc) THEN DO:
      IF VALID-HANDLE(ttSuper.ttHandle) THEN DO:
        RUN destroy IN ttSuper.ttHandle NO-ERROR.
        RUN captureErrs.
      END.
      IF VALID-HANDLE(ttSuper.ttHandle) THEN
        DELETE PROCEDURE ttSuper.ttHandle NO-ERROR.
      DELETE ttSuper.
    END.
  END.

  /* Start new SUPERs if necessary and add to web-utilities-hdl handle */
  DO i1 = 1 TO NUM-ENTRIES(cSupers):
    IF ENTRY(i1,cSupers) = "" THEN NEXT.
    FIND FIRST ttSuper WHERE ttSuper.ttProc = ENTRY(i1,cSupers) NO-ERROR.
    IF NOT AVAIL ttSuper THEN DO:
      CREATE ttSuper.
      ASSIGN ttSuper.ttProc = ENTRY(i1,cSupers).
      RUN VALUE(ttSuper.ttProc) PERSISTENT SET ttSuper.ttHandle.
    END.
    web-utilities-hdl:ADD-SUPER-PROCEDURE(ttSuper.ttHandle,SEARCH-TARGET).
  END.

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

