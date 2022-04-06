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
  File: afrunoncep.p

  Description:  Run persistent if not already running

  Purpose:      To run a procedure persistently if not already running, else it just returns the
                handle of the already running instance.

  Parameters:   INPUT procedure name to run persistently (including relative path)
                OUTPUT handle of procedure run if possible

  History:
  --------
  (v:010000)    Task:        5653   UserRef:    
                Date:   11/05/2000  Author:     Anthony Swindells

  Update Notes: Created from Template aftemprocp.p

  (v:010001)    Task:        7704   UserRef:    
                Date:   24/01/2001  Author:     Peter Judge

  Update Notes: AF2/ Add new AstraGen Manager

--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afrunoncep.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010001


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

DEFINE INPUT PARAMETER  pcProcedureName         AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER phHandle                AS HANDLE     NO-UNDO.

DEFINE VARIABLE ghHandle                 AS HANDLE               NO-UNDO.

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
         HEIGHT             = 6.67
         WIDTH              = 59.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
ASSIGN ghHandle = SESSION:LAST-PROCEDURE.

ProcedureWalk:
DO WHILE VALID-HANDLE(ghHandle):
    IF ghHandle:FILE-NAME = pcProcedureName THEN
        LEAVE ProcedureWalk.
    ASSIGN ghHandle = ghHandle:PREV-SIBLING.
END.    /* ProcedureWalk */

IF VALID-HANDLE(ghHandle)               AND
   ghHandle:FILE-NAME = pcProcedureName THEN
    ASSIGN phHandle = ghHandle.
ELSE
    IF SEARCH(pcProcedureName)                           <> ? OR
       SEARCH(ENTRY(1, pcProcedureName, ".":U) + ".r":U) <> ? THEN
        RUN VALUE(pcProcedureName) PERSISTENT SET phHandle.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


