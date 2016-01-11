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
  File: afgenretin.i

  Description:  Object Generator Return Information TT

  Purpose:      Object Generator Return Information TT Definitions

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/03/2002  Author:     Peter Judge

  Update Notes: Created from Template ryteminclu.i

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* object identifying preprocessor */
&glob   AstraInclude    yes


DEFINE TEMP-TABLE ttInfoMaster    NO-UNDO
    FIELD tMPData             AS CHARACTER
    FIELD tMName              AS CHARACTER
    FIELD tMDescription       AS CHARACTER
    FIELD tMModule            AS CHARACTER
    FIELD tMClass             AS CHARACTER
    FIELD tMEntity            AS CHARACTER
    FIELD tMDBList            AS CHARACTER
    FIELD tMTableList         AS CHARACTER
    INDEX idxMSort
          tMPData
    .

DEFINE TEMP-TABLE ttInfoInstance NO-UNDO
    FIELD tIKey               AS CHARACTER
    FIELD tIPData             AS CHARACTER
    FIELD tIValue             AS CHARACTER
    INDEX idxISort
          tIKey
          tIPData
    .

DEFINE TEMP-TABLE ttErrorLog            NO-UNDO
    FIELD tSection          AS CHARACTER
    FIELD tAction           AS CHARACTER
    FIELD tResult           AS CHARACTER
    FIELD tErrorType        AS CHARACTER
    FIELD tMessageText      AS CHARACTER
    FIELD tExpandedMEssage  AS CHARACTER    
    FIELD tDateLogged       AS DATE
    FIELD tTimeLogged       AS INTEGER
    INDEX idxSort
          tDateLogged
          tTimeLogged
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
         HEIGHT             = 6.19
         WIDTH              = 50.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


