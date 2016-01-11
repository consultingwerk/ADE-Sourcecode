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
  File: ryrepatset.i

  Description:  Temp table definition for  attributes

  Purpose:      Temp table definition for  setting attributes,used by storeAttributeValues.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   05/06/2002  Author:     Peter Judge

  Update Notes: Created from Template ryteminclu.i

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* object identifying preprocessor */
&glob   AstraInclude    yes

DEFINE TEMP-TABLE ttStoreAttribute      NO-UNDO
    FIELD tAttributeParent      AS CHARACTER
    FIELD tAttributeParentObj   AS DECIMAL
    FIELD tAttributeLabel       AS CHARACTER
    FIELD tConstantValue        AS LOGICAL      INITIAL NO
    FIELD tCharacterValue       AS CHARACTER
    FIELD tDecimalValue         AS DECIMAL
    FIELD tIntegerValue         AS INTEGER
    FIELD tDateValue            AS DATE
    FIELD tRawValue             AS RAW
    FIELD tLogicalValue         AS LOGICAL
    INDEX idxParent
        tAttributeParent
    INDEX idxObj
        tAttributeParentObj
    .

DEFINE TEMP-TABLE ttStoreUiEvent        NO-UNDO
    FIELD tEventParent          AS CHARACTER
    FIELD tEventParentObj       AS DECIMAL
    FIELD tEventName            AS CHARACTER
    FIELD tActionType           AS CHARACTER
    FIELD tActionTarget         AS CHARACTER    
    FIELD tEventAction          AS CHARACTER
    FIELD tEventParameter       AS CHARACTER
    FIELD tEventDisabled        AS LOGICAL
    FIELD tConstantValue        AS LOGICAL      INITIAL NO
    INDEX idxParent
        tEventParent
    INDEX idxObj
        tEventParentObj
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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


