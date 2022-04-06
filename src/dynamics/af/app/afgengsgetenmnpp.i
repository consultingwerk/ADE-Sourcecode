&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*---------------------------------------------------------------------------------
  File:         afgengsgetenmnpp.i

  Description:  Structured include for retrieving entity mnemonics.

  Purpose:      Structured include for retrieving entity mnemonics.

  Parameters:

  History:
  --------
  (v:010000)    Task:               UserRef:    
                Date:   07/22/2003  Author:     Bruce S Gruenbaum

  Update Notes: Move osm- modules to af- modules

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* object identifying preprocessor */
&glob   AstraInclude    yes

/* This parameter is defined by the procedure that includes this code.
 DEFINE OUTPUT PARAMETER TABLE FOR ttEntityMnemonic.
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
         HEIGHT             = 30.05
         WIDTH              = 82.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */
  FOR EACH gsc_entity_mnemonic NO-LOCK:
    CREATE ttentityMnemonic.
    BUFFER-COPY gsc_entity_mnemonic TO ttentityMnemonic.
    ASSIGN
      ttentityMnemonic.HasAudit
         = CAN-FIND(FIRST gst_audit
                          WHERE gst_audit.owning_entity_mnemonic = 
                                gsc_entity_mnemonic.entity_mnemonic)
           OR 
           CAN-FIND(FIRST gst_audit
                          WHERE gst_audit.owning_entity_mnemonic
                                = gsc_entity_mnemonic.entity_mnemonic_description)
      ttentityMnemonic.HasComment
         = CAN-FIND(FIRST gsm_comment
                     WHERE gsm_comment.owning_entity_mnemonic 
                           = gsc_entity_mnemonic.entity_mnemonic)
           OR 
           CAN-FIND(FIRST gsm_comment
                     WHERE gsm_comment.owning_entity_mnemonic 
                           = gsc_entity_mnemonic.entity_mnemonic_description)
      /* until we get the correct index */
     ttentityMnemonic.HasAutoComment = ttentityMnemonic.HasComment.
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


