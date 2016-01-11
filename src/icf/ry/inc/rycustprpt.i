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
  File: rycustprpt.i

  Description:  Include file for Temp-Table definitions

  Purpose:      Include file for Temp-Table definitions for Custom ADM property files

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    MIP
                Date:   11/05/2002  Author:     Mark Davies (MIP)

  Update Notes: Created from Template ryteminclu.i

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* object identifying preprocessor */
&glob   AstraInclude    yes


DEFINE TEMP-TABLE ttClassDef NO-UNDO RCODE-INFORMATION
  FIELD cFileName        AS CHARACTER FORMAT "X(40)" LABEL "Class File Name"
  FIELD cClassName       AS CHARACTER FORMAT "X(40)" LABEL "Repository Class"
  FIELD cExtendsFrom     AS CHARACTER FORMAT "X(40)" LABEL "Extends From Class"
  FIELD cPath            AS CHARACTER FORMAT "X(60)" LABEL "Full Path"
  FIELD cRootDir         AS CHARACTER FORMAT "X(40)" LABEL "Root Dir"
  FIELD dClassObj        AS DECIMAL                  LABEL "NODISPLAY"
  FIELD lCreate          AS LOGICAL                  LABEL "NODISPLAY"
  INDEX pudx IS UNIQUE PRIMARY
    cFileName
  .
DEFINE TEMP-TABLE ttAttribute NO-UNDO RCODE-INFORMATION
  FIELD cFileName         AS CHARACTER LABEL "NODISPLAY"
  FIELD cAttrName         AS CHARACTER FORMAT "X(35)":U  LABEL "Attribute Name"
  FIELD lLoad             AS LOGICAL   FORMAT "YES/NO":U LABEL "Load"
  FIELD cDataType         AS CHARACTER FORMAT "X(15)":U  LABEL "Data Type"
  FIELD iExtent           AS INTEGER   FORMAT ">>>>>9":U LABEL "Extent"
  FIELD cFormat           AS CHARACTER FORMAT "X(20)":U  LABEL "Format"
  FIELD cInitial          AS CHARACTER FORMAT "X(35)":U  LABEL "Initial Value"
  FIELD lRuntimeOnly      AS LOGICAL   FORMAT "YES/NO":U LABEL "Runtime Only"
  FIELD lDerivedValue     AS LOGICAL   FORMAT "YES/NO":U LABEL "Derived Value"
  FIELD lPrivate          AS LOGICAL   FORMAT "YES/NO":U LABEL "Private"
  FIELD lSystemOwned      AS LOGICAL   FORMAT "YES/NO":U LABEL "System Owned"
  FIELD lDesignOnly       AS LOGICAL   FORMAT "YES/NO":U LABEL "Design Only"
  FIELD cConstantLevel    AS CHARACTER FORMAT "X(20)":U  LABEL "NODISPLAY":U
  FIELD cOverrideType     AS CHARACTER FORMAT "X(10)":U  LABEL "NODISPLAY":U
  FIELD lExistInDB        AS LOGICAL   FORMAT "YES/NO":U LABEL "Exists In Repository" 
  INDEX idx1              IS UNIQUE PRIMARY cFileName cAttrName
  INDEX idx2              cFileName.

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
         HEIGHT             = 8.95
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


