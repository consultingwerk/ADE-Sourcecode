&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        :  afxmlreplctrl.i
    Purpose     :  Contains the function definition for replaceCtrlChar

    Syntax      :  See the function definition

    Description :  This file is needed because we do not want afxmlcfgp.p
                   to have any dependencies. The function is contained in
                   both afxmlcfgp.p and afxmlhlprp.p. afxmlhlprp.p may not
                   be available when afxmlcfgp.p needs it which is why
                   we put this function into an include file.

    Author(s)   :  Bruce S Gruenbaum
    Created     :  7/25/2001
    
    Notes       :  I hated having to do this, but it was more important 
                   that afxmlcfgp.p had no external references than that
                   the code be centralized. By keeping the code in an
                   include file we do not violate the laws about writing
                   re-usable code, even if it does slightly bloat the 
                   r-code.
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD replaceCtrlChar Include 
FUNCTION replaceCtrlChar RETURNS CHARACTER
  ( INPUT pcString AS CHARACTER,
    INPUT plRemove AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION replaceCtrlChar Include 
FUNCTION replaceCtrlChar RETURNS CHARACTER
  ( INPUT pcString AS CHARACTER,
    INPUT plRemove AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:     This procedure replaces control characters 1 to 8 in any string 
               with the character constant #CHR(x)# where x is the ASCII value 
               of the control character.
  Parameters: 
    pcString - The source string to replace the characters in
    plRemove - A logical variable which indicates if we are to remove or replace 
               the control characters. If set to yes, the control characters
               will be removed. If set to yes, they will be replaced.
               
    Notes:  Certain control characters cannot be written to XML files as the 
            XML parser does not support them. This procedure does not replace 
            all unsupported characters. It only replaces the ones that are 
            used by the framework (CHR(1) to CHR(8)). 

------------------------------------------------------------------------------*/

  DEFINE VARIABLE iCount     AS INTEGER    NO-UNDO.

  IF plRemove THEN
  DO iCount = 1 TO 8:
    pcString = REPLACE(pcString, CHR(iCount), "#CHR(":U + STRING(iCount) + ")#":U).
  END.
  ELSE
  DO iCount = 1 TO 8:
    pcString = REPLACE(pcString, "#CHR(":U + STRING(iCount) + ")#":U, CHR(iCount)).
  END.

  RETURN pcString.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

