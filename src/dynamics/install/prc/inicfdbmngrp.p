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
  File: inicfdbmngr.p

  Description:  Install Manager for ICFDB database utils

  Purpose:      Install Manager for ICFDB database utils

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   08/20/2003  Author:     Bruce S Gruenbaum

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       inicfdbmngrp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{install/inc/indcuglob.i}

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
         HEIGHT             = 27.19
         WIDTH              = 56.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-obtainICFSeqVals) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtainICFSeqVals Procedure 
PROCEDURE obtainICFSeqVals :
/*------------------------------------------------------------------------------
  Purpose:     Obtains the sequence values for the ICFDB database
               and populates the UI with the data.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcInput AS CHARACTER  NO-UNDO. /* not used */

DEFINE VARIABLE iSite AS INTEGER    NO-UNDO.
DEFINE VARIABLE iObj1 AS INTEGER    NO-UNDO.
DEFINE VARIABLE iObj2 AS INTEGER    NO-UNDO.
DEFINE VARIABLE iSess AS INTEGER    NO-UNDO.

RUN install/prc/inicfdbgetseqp.p
  (OUTPUT iSite,
   OUTPUT iObj1,
   OUTPUT iObj2,
   OUTPUT iSess).

DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                 "icfdb_site":U,
                 STRING(iSite)).
DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                 "icfdb_seq1":U,
                 STRING(iObj1)).
DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                 "icfdb_seq2":U,
                 STRING(iObj2)).
DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                 "icfdb_sess":U,
                 STRING(iSess)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSiteNumber) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSiteNumber Procedure 
PROCEDURE setSiteNumber :
/*------------------------------------------------------------------------------
  Purpose:     Sets the site number and sequence numbers in the database.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phSourceProc AS HANDLE     NO-UNDO.

DEFINE VARIABLE iSite AS INTEGER    NO-UNDO.
DEFINE VARIABLE iObj1 AS INTEGER    NO-UNDO.
DEFINE VARIABLE iObj2 AS INTEGER    NO-UNDO.
DEFINE VARIABLE iSess AS INTEGER    NO-UNDO.


iSite = INTEGER(DYNAMIC-FUNCTION("getFieldValue":U IN phSourceProc,
                         "ICFDB":U,
                         "icfdb_site":U)).
iObj1 = INTEGER(DYNAMIC-FUNCTION("getFieldValue":U IN phSourceProc,
                         "ICFDB":U,
                         "icfdb_seq1":U)).
iObj2 = INTEGER(DYNAMIC-FUNCTION("getFieldValue":U IN phSourceProc,
                         "ICFDB":U,
                         "icfdb_seq2":U)).
iSess = INTEGER(DYNAMIC-FUNCTION("getFieldValue":U IN phSourceProc,
                         "ICFDB":U,
                         "icfdb_sess":U)).

RUN install/prc/inicfdbsetseqp.p
  (INPUT iSite,
   INPUT iObj1,
   INPUT iObj2,
   INPUT iSess).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateSiteNumber) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateSiteNumber Procedure 
PROCEDURE validateSiteNumber :
/*------------------------------------------------------------------------------
  Purpose:     Validates that a site number is not zero.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcWidget AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hWidget   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSite     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iRetVal   AS INTEGER    NO-UNDO.

  hWidget = DYNAMIC-FUNCTION("getWidgetHandle":U IN ghUIManager,
                             pcWidget).

  IF NOT VALID-HANDLE(hWidget) THEN
    RETURN.

  cSite = hWidget:SCREEN-VALUE.

  IF cSite = "":U OR cSite = ? OR INTEGER(cSite) = 0 THEN
  DO:
    DYNAMIC-FUNCTION("messageBox":U IN ghUIManager,
                     "MSG_site_number":U, 
                     hWidget:LABEL,
                     "MB_OK,MB_ICONWARNING,MB_TASKMODAL":U).
    RETURN ERROR.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

