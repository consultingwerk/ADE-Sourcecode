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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "CreateWizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? af/sup/afwizdeltp.p */
/* New Program Wizard
Destroy on next read */
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
  File: afgengtlngtxtp.p

  Description:  getLanguageText AppServer Proxy

  Purpose:      getLanguageText AppServer Proxy

  Parameters:   INPUT  Category Type     CHARACTER
                INPUT  Category Group    CHARACTER
                INPUT  Category Subgroup CHARACTER
                INPUT  Text TLA          CHARACTER  <Optional> all if not passed in
                INPUT  Language obj      DECIMAL    <Optional> will default to login language
                INPUT  owning obj        DECIMAL    <Optional> may not be applicable
                INPUT  substitutions     CHARACTER  <Optional> if any required, pipe delimited
                OUTPUT Language Text     CHARACTER (pipe delimiter if multiple)
                OUTPUT Filename          CHARACTER (pipe delimiter if multiple)

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/16/2003  Author:     Bruce S Gruenbaum

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
  DEFINE INPUT  PARAMETER pcCategoryType      AS CHARACTER                   NO-UNDO.
  DEFINE INPUT  PARAMETER pcCategoryGroup     AS CHARACTER                   NO-UNDO.
  DEFINE INPUT  PARAMETER pcSubGroup          AS CHARACTER                   NO-UNDO.
  DEFINE INPUT  PARAMETER pcTextTla           AS CHARACTER                   NO-UNDO.
  DEFINE INPUT  PARAMETER pdLanguageObj       AS DECIMAL                     NO-UNDO.
  DEFINE INPUT  PARAMETER pdOwningObj         AS DECIMAL                     NO-UNDO.
  DEFINE INPUT  PARAMETER pcSubstitute        AS CHARACTER                   NO-UNDO.
  DEFINE OUTPUT PARAMETER pcLanguageText      AS CHARACTER                   NO-UNDO.
  DEFINE OUTPUT PARAMETER pcFileName          AS CHARACTER                   NO-UNDO.

/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afgengtlngtxtp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

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
         HEIGHT             = 20.38
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

RUN getLanguageText IN gshGenManager
     (INPUT pcCategoryType,
      INPUT pcCategoryGroup,
      INPUT pcSubGroup,
      INPUT pcTextTla,
      INPUT pdLanguageObj,
      INPUT pdOwningObj,
      INPUT pcSubstitute,
      OUTPUT pcLanguageText,
      OUTPUT pcFileName) NO-ERROR.
IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
  RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
    ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


