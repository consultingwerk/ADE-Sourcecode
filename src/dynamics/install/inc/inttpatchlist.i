&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
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
/*---------------------------------------------------------------------------------
  File: inttpatchlist.i

  Description:  Patch List temp table include

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/02/2002  Author:     Bruce S Gruenbaum

  Update Notes: Created from Template ryteminclu.i

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* object identifying preprocessor */
&glob   AstraInclude    yes

DEFINE TEMP-TABLE ttPatchList NO-UNDO
  FIELD iSeq             AS INTEGER
  FIELD cPatchDB         AS CHARACTER
  FIELD cPatchLevel      AS CHARACTER
  FIELD cStage           AS CHARACTER
  FIELD iUpdateWhen      AS INTEGER
  FIELD cFileType        AS CHARACTER
  FIELD cFileName        AS CHARACTER
  FIELD cDescription     AS CHARACTER
  FIELD lRerunnable      AS LOGICAL
  FIELD lNewDB           AS LOGICAL
  FIELD lExistingDB      AS LOGICAL
  FIELD lUpdateMandatory AS LOGICAL
  FIELD lApplied         AS LOGICAL
  INDEX pudx IS PRIMARY UNIQUE
    iSeq
  INDEX dxPatchDBLevelWhenSeq
    cPatchDB
    cPatchLevel
    iUpdateWhen
    iSeq
  .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
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
         HEIGHT             = 21
         WIDTH              = 58.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


