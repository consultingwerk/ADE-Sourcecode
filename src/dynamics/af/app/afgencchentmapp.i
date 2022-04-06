&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*---------------------------------------------------------------------------------
  File:         afgencchentmapp.i

  Description:  Cache entity mapping

  Purpose:      Cache entity mapping

  Parameters:

  History:
  --------
  (v:010000)    Task:               UserRef:    
                Date:   07/22/2003  Author:     Bruce S Gruenbaum


---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* object identifying preprocessor */
&glob   AstraInclude    yes

/* These are defined in the actual procedure.
DEFINE INPUT PARAMETER pcEntity AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcTable  AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR ttEntityMap.
*/

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
         HEIGHT             = 10.62
         WIDTH              = 46.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */
    DEFINE BUFFER bgsc_entity_mnemonic FOR gsc_entity_mnemonic.

    /* This table is just used for passing stuff back. */
    EMPTY TEMP-TABLE ttEntityMap.

    IF pcEntity <> "":U THEN
        FIND FIRST bgsc_entity_mnemonic NO-LOCK                
           WHERE bgsc_entity_mnemonic.entity_mnemonic = (IF pcEntity <> "":U THEN pcEntity ELSE bgsc_entity_mnemonic.entity_mnemonic) NO-ERROR.
    ELSE
        FIND FIRST bgsc_entity_mnemonic NO-LOCK
           WHERE bgsc_entity_mnemonic.entity_mnemonic_description = (IF pcTable <> "":U THEN pcTable ELSE bgsc_entity_mnemonic.entity_mnemonic) NO-ERROR.
    IF AVAILABLE bgsc_entity_mnemonic THEN
    DO:
         CREATE ttEntityMap.
         BUFFER-COPY bgsc_entity_mnemonic
                  TO ttEntityMap
              ASSIGN ttEntityMap.HasAudit   = CAN-FIND(FIRST gst_audit WHERE gst_audit.owning_entity_mnemonic = bgsc_entity_mnemonic.entity_mnemonic)
                                           OR CAN-FIND(FIRST gst_audit WHERE gst_audit.owning_entity_mnemonic = bgsc_entity_mnemonic.entity_mnemonic_description)
                     ttEntityMap.HasComment = CAN-FIND(FIRST gsm_comment WHERE gsm_comment.owning_entity_mnemonic = bgsc_entity_mnemonic.entity_mnemonic)
                                           OR CAN-FIND(FIRST gsm_comment WHERE gsm_comment.owning_entity_mnemonic = bgsc_entity_mnemonic.entity_mnemonic_description)
                     ttEntityMap.HasAutoComment = ttEntityMap.HasComment.
    END.    /* available entity mnemonic */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


