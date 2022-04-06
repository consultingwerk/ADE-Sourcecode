&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Procedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: afgethctxp.p

  Description:  Get help context

  Purpose:      Get help context

  Parameters:   input container filename
                input object filename
                input widget name
                output help file
                output help context id (integer)
                output help context text

  History:
  --------
  (v:010000)    Task:        6145   UserRef:    
                Date:   25/06/2000  Author:     Anthony Swindells

  Update Notes: Code container toolbar actions

-------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afgethctxp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

    DEFINE INPUT PARAMETER  pcContainerFilename       AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER  pcObjectFilename          AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER  pcItemName                AS CHARACTER    NO-UNDO.
    DEFINE OUTPUT PARAMETER pcHelpFile                AS CHARACTER    NO-UNDO.
    DEFINE OUTPUT PARAMETER piHelpContext             AS INTEGER      NO-UNDO.
    DEFINE OUTPUT PARAMETER pcHelpText                AS CHARACTER    NO-UNDO.

{af/sup2/afglobals.i}

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
         HEIGHT             = 13.81
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

  DEFINE VARIABLE dCurrentLanguageObj AS DECIMAL INITIAL 0 NO-UNDO.

  ASSIGN dCurrentLanguageObj = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                       INPUT "currentLanguageObj":U,
                                       INPUT NO)) NO-ERROR.
 
  IF dCurrentLanguageObj <> 0 THEN
  DO:
    /* Specific language, container, object and widget */
    FIND FIRST gsm_help NO-LOCK
         WHERE gsm_help.LANGUAGE_obj = dCurrentLanguageObj
           AND gsm_help.help_container_filename = pcContainerFilename
           AND gsm_help.help_object_filename = pcObjectFilename
           AND gsm_help.help_fieldname = pcItemName
         NO-ERROR.
   
    /* Specific language, container and object */
    IF NOT AVAILABLE gsm_help THEN
        FIND FIRST gsm_help NO-LOCK
             WHERE gsm_help.LANGUAGE_obj = dCurrentLanguageObj
               AND gsm_help.help_container_filename = pcContainerFilename
               AND gsm_help.help_object_filename = pcObjectFilename
               AND gsm_help.help_fieldname = "":U
             NO-ERROR.
   
    /* Specific language and container */
    IF NOT AVAILABLE gsm_help THEN
        FIND FIRST gsm_help NO-LOCK
             WHERE gsm_help.LANGUAGE_obj = dCurrentLanguageObj
               AND gsm_help.help_container_filename = pcContainerFilename
               AND gsm_help.help_object_filename = "":U
               AND gsm_help.help_fieldname = "":U
             NO-ERROR.

    /* Specific language, system wide help */
    IF NOT AVAILABLE gsm_help THEN
        FIND FIRST gsm_help NO-LOCK
             WHERE gsm_help.LANGUAGE_obj = dCurrentLanguageObj
               AND gsm_help.help_container_filename = "":U
               AND gsm_help.help_object_filename = "":U
               AND gsm_help.help_fieldname = "":U
             NO-ERROR.
  END.

  IF dCurrentLanguageObj = 0 OR NOT AVAILABLE gsm_help 
  THEN DO:
    /* Any language, specific container, object and widget */
    FIND FIRST gsm_help NO-LOCK
         WHERE gsm_help.help_container_filename = pcContainerFilename
           AND gsm_help.help_object_filename = pcObjectFilename
           AND gsm_help.help_fieldname = pcItemName
         NO-ERROR.

    /* Any language, specific container and object */
    IF NOT AVAILABLE gsm_help THEN
        FIND FIRST gsm_help NO-LOCK
             WHERE gsm_help.help_container_filename = pcContainerFilename
               AND gsm_help.help_object_filename = pcObjectFilename
               AND gsm_help.help_fieldname = "":U
             NO-ERROR.

    /* Any language, specific container */
    IF NOT AVAILABLE gsm_help THEN
        FIND FIRST gsm_help NO-LOCK
             WHERE gsm_help.help_container_filename = pcContainerFilename
               AND gsm_help.help_object_filename = "":U
               AND gsm_help.help_fieldname = "":U
             NO-ERROR.

    /* Any language, system wide help */
    IF NOT AVAILABLE gsm_help THEN
        FIND FIRST gsm_help NO-LOCK
             WHERE gsm_help.help_container_filename = "":U
               AND gsm_help.help_object_filename = "":U
               AND gsm_help.help_fieldname = "":U
             NO-ERROR.
  END.

  /* Initialize help file to default help filename */
  FIND FIRST gsc_security_control NO-LOCK NO-ERROR.
  IF AVAILABLE gsc_security_control THEN
      IF gsc_security_control.default_help_filename = "":U
      OR gsc_security_control.default_help_filename = ? THEN
          ASSIGN pcHelpFile = "prohelp/icabeng.hlp":U.
      ELSE
          ASSIGN pcHelpFile = gsc_security_control.default_help_filename.

  /* Now check if we actually found specific help, and use that if applicable */
  IF AVAILABLE gsm_help 
  THEN DO:
      IF gsm_help.help_context <> "":U 
      THEN DO:
          ASSIGN piHelpContext = INTEGER(gsm_help.help_context) NO-ERROR.
          IF ERROR-STATUS:ERROR OR piHelpContext = ? THEN ASSIGN pcHelpText = gsm_help.help_context.
      END.

      IF gsm_help.help_filename <> "":U 
      THEN DO:
          ASSIGN pcHelpFile = gsm_help.help_filename.

          IF SEARCH(pcHelpFile) = ? THEN
              /* If we can't find the help file, AND 
               * If we're dealing with a .hlp, check if we can find a .chm, or vice versa */
              ASSIGN pcHelpFile = SUBSTRING(pcHelpFile, 1, IF R-INDEX(pcHelpFile, ".":U) = 0
                                           THEN LENGTH(pcHelpFile)
                                           ELSE R-INDEX(pcHelpFile, ".":U))
                  + IF R-INDEX(pcHelpFile, ".":U) <> 0
                    THEN (IF SUBSTRING(pcHelpFile, R-INDEX(pcHelpFile, ".":U) + 1) = "hlp":U
                          THEN "chm"
                          ELSE (IF SUBSTRING(pcHelpFile, R-INDEX(pcHelpFile, ".":U) + 1) = "chm":U
                                THEN "hlp"
                                ELSE SUBSTRING(pcHelpFile, R-INDEX(pcHelpFile, ".":U) + 1)))
                    ELSE "":U.

          /* If we still can't find the file, default to the default */
          IF SEARCH(pcHelpFile) = ?
          AND AVAILABLE gsc_security_control THEN
              IF gsc_security_control.default_help_filename = "":U
              OR gsc_security_control.default_help_filename = ? THEN
                  ASSIGN pcHelpFile = "prohelp/icabeng.hlp":U.
              ELSE
                  ASSIGN pcHelpFile = gsc_security_control.default_help_filename.
      END.
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


