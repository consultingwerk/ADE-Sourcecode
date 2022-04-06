&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
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
/*---------------------------------------------------------------------------------
  File: afsesstyperetr.p

  Description:  Session Type Data Retrieval

  Purpose:      Session Type Data Retrieval

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   09/19/2003  Author:     Bruce S Gruenbaum

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

{af/sup2/afxmlcfgtt.i}
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttProperty.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttService.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttManager.

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afsesstyperetr.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

DEFINE VARIABLE ghSessTypeCache AS HANDLE     NO-UNDO.

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
         HEIGHT             = 10.71
         WIDTH              = 51.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEFINE VARIABLE cSessType     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iDBPriority   AS INTEGER    NO-UNDO.
DEFINE VARIABLE iCFGPriority  AS INTEGER    NO-UNDO.
DEFINE VARIABLE lOverwrite    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cOverrideInfo AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cError        AS CHARACTER  NO-UNDO.

/* We need to launch the config file cache if it has not been started */
RUN startProcedure IN THIS-PROCEDURE
  ("ONCE|af/app/afsesstypecachep.p":U,
   OUTPUT ghSessTypeCache).

IF RETURN-VALUE <> ? AND
   RETURN-VALUE <> "":U THEN
  RETURN ERROR RETURN-VALUE.

IF SESSION:REMOTE THEN
DO:
  cSessType = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                               "client_SessionType":U).
  IF cSessType = ? THEN
    cSessType = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                 "client_SessionType":U,
                                 NO).
END.
ELSE
  cSessType = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                               "ICFSESSTYPE":U).


/* Figure out the override info. This tells us where we need to get the
   information from. */
cOverrideInfo = DYNAMIC-FUNCTION("getSessionOverrideInfo":U IN ghSessTypeCache,
                                 cSessType).
IF cOverrideInfo = ? THEN
DO:
  ASSIGN
    cError = SUBSTITUTE("Session Type &1 not registered in repository":U, cSessType ).
  RETURN ERROR cError.
END.

/* If we don't need to get the stuff from the database at all, this is 
   a no-op. We can return at this point */
IF NOT CAN-DO(cOverrideInfo, "DB":U) THEN
  RETURN "":U.

/* Now we need to figure out the priority */
iDBPriority  = LOOKUP("DB":U, cOverrideInfo).
iCFGPriority = LOOKUP("CFG":U, cOverrideInfo).

/* If iCFGPriority is 0, we have to do away with everything that is already
   in these tables and replace them completely from the session's tables. */
IF iCFGPriority = 0 THEN
DO:
  /* Mark everything as needing to be deleted. */
  FOR EACH ttProperty:
    ttProperty.lDelete = YES.
  END.
  FOR EACH ttService:
    ttService.lDelete = YES.
  END.
  FOR EACH ttManager:
    IF ttManager.iOrder = 0 AND
       ttManager.cManagerName = "ConfigFileManager":U THEN
      NEXT.
    ttManager.lDelete = YES.
  END.
END.

IF iCFGPriority =  0 OR
   iDBPriority  <= iCFGPriority THEN
  lOverwrite = YES.
ELSE
  lOverwrite = NO.

RUN mergeSessTypeData IN ghSessTypeCache
  (cSessType,
   lOverwrite,
   INPUT BUFFER ttProperty:HANDLE,
   INPUT BUFFER ttService:HANDLE,
   INPUT BUFFER ttManager:HANDLE).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


