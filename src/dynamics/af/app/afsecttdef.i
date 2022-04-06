&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*---------------------------------------------------------------------------------
  File: afsecttdef.i

  Description:  template structured include

  Purpose:      template structured include

  Parameters:

  History:
  --------
  (v:010000)    Task:          29   UserRef:    
                Date:   18/12/1997  Author:     Mark Davies

  Update Notes: Created include file to hold security allocation temp-table.

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* object identifying preprocessor */
&glob   AstraInclude    yes


DEFINE TEMP-TABLE ttUpdatedAllocations NO-UNDO
    FIELD lDeleteAll             AS LOGICAL
    FIELD lDelete                AS LOGICAL
    FIELD lUpdateValue1AndValue2 AS LOGICAL
    FIELD owning_entity_mnemonic AS CHARACTER
    FIELD owning_obj             AS DECIMAL
    FIELD user_allocation_value1 AS CHARACTER
    FIELD user_allocation_value2 AS CHARACTER
    INDEX index1 
          owning_entity_mnemonic
          lDeleteAll.

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
         HEIGHT             = 12.43
         WIDTH              = 57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


