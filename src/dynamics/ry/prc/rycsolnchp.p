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
  File: rycsolnchp.p

  Description:  Launch Dynamic Object Procedure

  Purpose:      Launch Dynamic Object Procedure

  Parameters:   INPUT Name of object to launch (no path or extension)
                INPUT Run Object Persistent
                INPUT Clear the cache
                INPUT Destroy the ADM

  History:
  --------
  (v:010000)    Task:        7287   UserRef:    
                Date:   14/12/2000  Author:     Anthony Swindells

  Update Notes: 

  (v:010001)    Task:    90000010   UserRef:    
                Date:   03/20/2002  Author:     Dynamics Admin User

  Update Notes: 

-------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rycsolnchp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

DEFINE NEW GLOBAL SHARED VARIABLE h_ade_tool    AS HANDLE    NO-UNDO.

/* Astra object identifying preprocessor */
&glob   AstraProcedure    yes

{af/sup2/afglobals.i}

DEFINE INPUT PARAMETER pcRunObject      AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER plRunPersistent  AS LOGICAL    NO-UNDO.
DEFINE INPUT PARAMETER plClearCache     AS LOGICAL    NO-UNDO.

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
         HEIGHT             = 6.33
         WIDTH              = 43.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

IF NOT VALID-HANDLE(gshSessionManager)
THEN DO:
  MESSAGE
    "Please correct, Session Manager is not running. Ensure the Progress Dynamics Application is running"
  VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END. /* NOT VALID-HANDLE(gshRepositoryManager) */

IF NOT VALID-HANDLE(gshRepositoryManager)
THEN DO:
  MESSAGE
    "Please correct, Repository Manager is not running. Ensure the Progress Dynamics Application is running"
  VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END. /* NOT VALID-HANDLE(gshRepositoryManager) */

IF pcRunObject = "":U
THEN DO:
  MESSAGE
    "No object name has been specified to run."
  VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END. /* pcRunObject = "":U */

IF plClearCache
THEN 
  RUN clearClientCache IN gshRepositoryManager.

RUN runObject.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-runObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runObject Procedure 
PROCEDURE runObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lMultiInstance          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cChildDataKey           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRunAttribute           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainerWindow        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContainerSource        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hObject                 AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRunContainer           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cRunContainerType       AS CHARACTER  NO-UNDO.

  ASSIGN
    lMultiInstance    = NO
    cChildDataKey     = "":U
    cRunAttribute     = "":U
    hContainerWindow  = ?
    hContainerSource  = ?
    hObject           = ?
    hContainerWindow  = ?
    cRunContainerType = "":U
    .

  IF VALID-HANDLE(gshSessionManager)
  THEN
    RUN launchContainer IN gshSessionManager 
                        (INPUT  pcRunObject          /* object filename if physical/logical names unknown */
                        ,INPUT  "":U                 /* physical object name (with path and extension) if known */
                        ,INPUT  pcRunObject          /* logical object name if applicable and known */
                        ,INPUT  (NOT lMultiInstance) /* run once only flag YES/NO */
                        ,INPUT  "":U                 /* instance attributes to pass to container */
                        ,INPUT  cChildDataKey        /* child data key if applicable */
                        ,INPUT  cRunAttribute        /* run attribute if required to post into container run */
                        ,INPUT  "":U                 /* container mode, e.g. modify, view, add or copy */
                        ,INPUT  hContainerWindow     /* parent (caller) window handle if known (container window handle) */
                        ,INPUT  hContainerSource     /* parent (caller) procedure handle if known (container procedure handle) */
                        ,INPUT  hObject              /* parent (caller) object handle if known (handle at end of toolbar link, e.g. browser) */
                        ,OUTPUT hRunContainer        /* procedure handle of object run/running */
                        ,OUTPUT cRunContainerType    /* procedure type (e.g ADM1, Astra1, ADM2, ICF, "") */
                        ).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

