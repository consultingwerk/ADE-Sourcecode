&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "CreateWizard" Include _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? af/sup/afwizdeltp.p */
/* New Program Wizard
Destroy on next read */
/* _UIB-CODE-BLOCK-END */
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
  File: afsetuppath.i

  Description:  Sets up initial propath

  Purpose:      This code sets up the initial propath needed to start a Dynamics session and
                should be included at the top of all startup procedures such as as_startup,
                icfcfg.w, icfstart.p and so on.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   06/20/2002  Author:     Bruce Gruenbaum

  Update Notes: Created from Template ryteminclu.i

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* object identifying preprocessor */
&glob   AstraInclude    yes

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
         HEIGHT             = 9.62
         WIDTH              = 46.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

RUN setupStartPaths.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setupStartPaths Include 
PROCEDURE setupStartPaths :
/*------------------------------------------------------------------------------
  Purpose:     Obtains the value of the ICFPATH variable off the command line
               and uses it to set the initial propath so that afxmlcfgp.p can
               be found.
  Parameters:  <none>
  Notes:       This procedure is here just to get started. We don't care about
               the rest of the propath at this stage. We're only interested in 
               the stuff we need to get to the Config XML file and its 
               processor. The XML file defines the PROPATH to be used for 
               the session and we'll set that once the XML file has been 
               parsed.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cPropath   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParam     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cICFParam  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCount2    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cPathValue AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPath      AS CHARACTER  NO-UNDO.

  /* Obtain the value of ICFPARAM */
  cICFParam = SESSION:ICFPARAM.

  /* Loop through all the entries on the string until we find ICFPATH=. If 
     we don't find it the session uses the standard path from the registry
     or wherever. */
  DO iCount = 1 TO NUM-ENTRIES(cICFParam):
    cParam = ENTRY(iCount, cICFParam).

    /* We found the ICFPATH variable */
    IF SUBSTRING(cParam,1,8) = "ICFPATH=":U THEN
    DO:
      /* Get the value of ICFPATH */
      cPathValue = SUBSTRING(cParam,9).

      /* Loop through all the entries in ICFPATH and add it and tag on the
         ICF directory to it and add that. This ensures that we get the 
         dynamics code that we need to start the configuration file manager.
         That's all we're interested in. */
      DO iCount2 = 1 TO NUM-ENTRIES(cPathValue, ";":U):
        cPath = cPath + (IF cPath = "":U THEN "":U ELSE ",":U)
              + ENTRY(iCount2, cPathValue,";":U) + ",":U
              +  ENTRY(iCount2, cPathValue,";":U) + "/icf":U.
      END.

      /* Set the propath */
      PROPATH = cPath.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

