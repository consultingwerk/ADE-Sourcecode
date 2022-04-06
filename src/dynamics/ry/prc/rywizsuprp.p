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
  File: rywizsuprp.p

  Description:  Wizards Super Procedure

  Purpose:      Wizards Super Procedure

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        6415   UserRef:    
                Date:   04/08/2000  Author:     Anthony Swindells

  Update Notes: Remove DB dependancy from wizards - only require DB if forward generating.

  (v:010001)    Task:        7618   UserRef:    
                Date:   18/01/2001  Author:     Anthony Swindells

  Update Notes: Enhance wizard forward engineer program to support header/detail folders plus
                non sdo folders

  (v:010002)    Task:    90000164   UserRef:    
                Date:   19/07/2001  Author:     Mark Davies

  Update Notes: Add new TreeView type for SmartTreeViwe wizards.

------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rywizsuprp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010002

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

{af/sup2/afglobals.i}
{af/sup2/afcheckerr.i &define-only = YES}

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
         HEIGHT             = 7.43
         WIDTH              = 43.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */

{ry/app/ryplipmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-generateObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateObject Procedure 
PROCEDURE generateObject :
/*------------------------------------------------------------------------------
  Purpose:     Run from generate published event from a menu option.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pcType                     AS CHARACTER NO-UNDO.

/* get data source */
DEFINE VARIABLE hDataSource                       AS HANDLE     NO-UNDO.
DEFINE VARIABLE cObjectName                       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cError                            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cButton                           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAnswer                           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTitle                            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cProcName                         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lDelete                           AS LOGICAL    NO-UNDO.

IF NOT CONNECTED("ICFDB":U) THEN
DO:
  RUN showMessages IN gshSessionManager (INPUT "Repository database must be connected to generate objects. Run application with a DB connection to use this option.",
                                         INPUT "ERR":U,
                                         INPUT "OK":U,
                                         INPUT "OK":U,
                                         INPUT "OK":U,
                                         INPUT "No Databases Connected",
                                         INPUT YES,
                                         INPUT ?,
                                         OUTPUT cButton).
  RETURN.  
END.

CASE pcType:
  WHEN "menc":U THEN
    ASSIGN
      cTitle = "Generate Menu Controller"
      cProcName = "generateMenuController":U.
  WHEN "objc":U THEN
    ASSIGN
      cTitle = "Generate Object Controller"
      cProcName = "generateObjectController":U.
  WHEN "fold":U THEN
    ASSIGN
      cTitle = "Generate Folder Window"
      cProcName = "generateFolderWindow":U.
  WHEN "brow":U THEN
    ASSIGN
      cTitle = "Generate Browser"
      cProcName = "generateBrowser":U.
  WHEN "view":U THEN
    ASSIGN
      cTitle = "Generate Viewer"
      cProcName = "generateViewer":U.
  WHEN "TreeView":U THEN
    ASSIGN
      cTitle = "Generate TreeViewer"
      cProcName = "generateTreeView":U.
  OTHERWISE
  DO:
    RUN showMessages IN gshSessionManager (INPUT "Unsupported object type: " + pcType + ", supported types are menc,objc,fold,brow,view,TreeView",
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Wizard Generation Failure",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cButton).
    RETURN.  
  END.
END CASE.

hDataSource = DYNAMIC-FUNCTION('getdatasource' IN TARGET-PROCEDURE) NO-ERROR.

IF VALID-HANDLE(hDataSource) THEN
  cObjectName = DYNAMIC-FUNCTION('colvalues' IN hDataSource, INPUT 'object_name') NO-ERROR.

IF cObjectName = ? OR cObjectName = "":U OR NUM-ENTRIES(cObjectName,CHR(1)) < 2 THEN RETURN.
ASSIGN cObjectName = ENTRY(2,cObjectName,CHR(1)).

RUN askQuestion IN gshSessionManager (INPUT "Generate dynamic object: " + cObjectName, /* messages */
                                      INPUT "&Yes,&No":U,     /* button list */
                                      INPUT "&Yes":U,         /* default */
                                      INPUT "&No":U,          /* cancel */
                                      INPUT cTitle,           /* title */
                                      INPUT "":U,             /* datatype */
                                      INPUT "":U,             /* format */
                                      INPUT-OUTPUT cAnswer,   /* answer */
                                      OUTPUT cButton          /* button pressed */
                                      ).
IF cButton = "&No":U THEN RETURN.

RUN askQuestion IN gshSessionManager (INPUT "Delete existing object first: " + cObjectName, /* messages */
                                      INPUT "&Yes,&No":U,     /* button list */
                                      INPUT "&No":U,          /* default */
                                      INPUT "&No":U,          /* cancel */
                                      INPUT cTitle,           /* title */
                                      INPUT "":U,             /* datatype */
                                      INPUT "":U,             /* format */
                                      INPUT-OUTPUT cAnswer,   /* answer */
                                      OUTPUT cButton          /* button pressed */
                                      ).

SESSION:SET-WAIT-STATE('general').

ASSIGN cError = "":U.

IF cButton = "&Yes":U THEN
  ASSIGN lDelete = YES.
ELSE
  ASSIGN lDelete = NO.

{af/sup2/afrun2.i &PLIP = 'ry/app/rywizogenp.p'
                  &IProc = cProcName
                  &PList = "(INPUT cObjectName, INPUT lDelete, OUTPUT cError)"
                  &OnApp = 'no'
                  &Autokill = YES}

SESSION:SET-WAIT-STATE('').

IF cError <> "":U THEN
DO:
  RUN showMessages IN gshSessionManager (INPUT cError,
                                         INPUT "ERR":U,
                                         INPUT "OK":U,
                                         INPUT "OK":U,
                                         INPUT "OK":U,
                                         INPUT "Wizard Generation Failure",
                                         INPUT YES,
                                         INPUT ?,
                                         OUTPUT cButton).
END.
ELSE
DO:
  /* refresh browser */
  RUN refreshRow IN hDataSource.
END.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-InitializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InitializeObject Procedure 
PROCEDURE InitializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Run when added as a super procedure of the wizard browsers.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN SUPER.

/* subscribe to any events published from the containers toolbar */
DEFINE VARIABLE hContainerSource                      AS HANDLE NO-UNDO.
DEFINE VARIABLE hToolbarSource                        AS HANDLE NO-UNDO.

hContainerSource = DYNAMIC-FUNCTION('getContainerSource' IN TARGET-PROCEDURE) NO-ERROR.
IF VALID-HANDLE(hContainerSource) THEN
  hToolbarSource = DYNAMIC-FUNCTION('linkHandles' IN hContainerSource, 'toolbar-source').

SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "generate":U IN hToolbarSource
  RUN-PROCEDURE "generateObject" NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-killPlip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE killPlip Procedure 
PROCEDURE killPlip :
/*------------------------------------------------------------------------------
  Purpose:     entry point to instantly kill the plip if it should get lost in memory
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipkill.i}

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

ASSIGN cDescription = "Wizard Super Procedure".

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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipShutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown Procedure 
PROCEDURE plipShutdown :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will be run just before the calling program 
               terminates
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipshut.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

