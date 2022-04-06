&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Include _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: afsrvtype.i

  Description:  Service Type Manager Standard Include

  Purpose:      Service Type Manager Standard Include
                Contains the required function call definitions to make a service type manager
                work correctly.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   17/08/2001  Author:     

  Update Notes: Created from Template ryteminclu.i

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* Astra 2 object identifying preprocessor */
&glob   AstraInclude    yes

/* Include the global variables that all ICF products need */
{af/sup2/afglobals.i}

/* Define the temp-table for the service type */
DEFINE TEMP-TABLE ttService NO-UNDO
  FIELD cServiceName      AS CHARACTER FORMAT "X(30)"
  FIELD cPhysicalService  AS CHARACTER FORMAT "X(30)"
  FIELD cConnectParams    AS CHARACTER FORMAT "X(60)"
  FIELD cServiceHandle    AS CHARACTER
  FIELD lDefaultService   AS LOGICAL
  FIELD lConnectAtStartup AS LOGICAL INITIAL YES
  {&ServiceTypeFields}
  INDEX pudx IS PRIMARY UNIQUE
    cServiceName
  INDEX dxPhysServ
    cPhysicalService
  {&ServiceTypeIndexes}
  .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSTTableBuffer Include 
FUNCTION getSTTableBuffer RETURNS HANDLE
  ( /* No Parameters */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD requiresHandle Include 
FUNCTION requiresHandle RETURNS LOGICAL
  ( /* No Parameters */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD servicesServiceType Include 
FUNCTION servicesServiceType RETURNS CHARACTER
  ( /* No Parameters */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 10.48
         WIDTH              = 44.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

RUN start-super-proc ("af/app/afservicetype.p":U).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE start-super-proc Include 
PROCEDURE start-super-proc :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to start a super proc if it's not already running, 
               and to add it as a super proc in any case.
  Parameters:  Procedure name to make super.
  Notes:       This procedure has been copied from ADM2's smart.i include as
               smart.i has other code that we do not want as a part of this.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcProcName AS CHARACTER NO-UNDO.
  DEFINE VARIABLE        hProc      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE        lConfigMan AS LOGICAL   NO-UNDO.

  lConfigMan = DYNAMIC-FUNCTION("isConfigManRunning":U IN THIS-PROCEDURE) NO-ERROR.
  IF lConfigMan = ? THEN
    lConfigMan = NO.

  IF lConfigMan THEN
  DO:
    RUN startProcedure IN THIS-PROCEDURE ("ONCE|":U + pcProcName, OUTPUT hProc) NO-ERROR.
  END.
  ELSE
  DO:
    hProc = SESSION:FIRST-PROCEDURE.
    DO WHILE VALID-HANDLE(hProc) AND hProc:FILE-NAME NE pcProcName:
      hProc = hProc:NEXT-SIBLING.
    END.
    IF NOT VALID-HANDLE(hProc) THEN
      RUN VALUE(pcProcName) PERSISTENT SET hProc.
  END.

  THIS-PROCEDURE:ADD-SUPER-PROCEDURE(hProc, SEARCH-TARGET).
  
  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSTTableBuffer Include 
FUNCTION getSTTableBuffer RETURNS HANDLE
  ( /* No Parameters */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle to the Service Type table's buffer in 
            this procedure.
    Notes:  
------------------------------------------------------------------------------*/

  RETURN BUFFER ttService:HANDLE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION requiresHandle Include 
FUNCTION requiresHandle RETURNS LOGICAL
  ( /* No Parameters */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Tells the connection manager whether this connection type requires
            a handle for its connection.
    Notes:  
------------------------------------------------------------------------------*/

  RETURN {&RequiresHandle}.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION servicesServiceType Include 
FUNCTION servicesServiceType RETURNS CHARACTER
  ( /* No Parameters */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Indicates the type of service.
    Notes:  
------------------------------------------------------------------------------*/

  RETURN "{&ServiceType}":U.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

