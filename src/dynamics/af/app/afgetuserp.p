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
  File: afgetuserp.p

  Description:  Get user information

  Purpose:      Get user information

  Parameters:   Input user obj
                input user login name
                output user temp-table

  History:
  --------
  (v:010000)    Task:        5958   UserRef:    
                Date:   08/06/2000  Author:     Anthony Swindells

  Update Notes: Add Error Handling to Session Manager

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afgetuserp.p
&scop object-version    000000


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes


{af/sup2/afglobals.i}     /* Astra global shared variables */

DEFINE TEMP-TABLE ttUser NO-UNDO LIKE gsm_user.

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
         HEIGHT             = 4.48
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE INPUT PARAMETER  pdUserObj                       AS DECIMAL      NO-UNDO.
DEFINE INPUT PARAMETER  pcLoginName                     AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR ttUser.

IF NOT TRANSACTION THEN
    EMPTY TEMP-TABLE ttUser.  
ELSE
    FOR EACH ttUser: DELETE ttUser. END.

IF  pdUserObj   = 0
AND pcLoginName = "":U 
THEN DO:
    FOR EACH gsm_user NO-LOCK:
        CREATE ttUser.
        BUFFER-COPY gsm_user TO ttUser.

        /* For security reasons, don't pass the user obj or password */

        ASSIGN ttUser.user_obj      = ?
               ttUser.user_password = "":U.
    END.
END.
ELSE DO:
    IF pdUserObj <> 0 THEN
        FIND FIRST gsm_user NO-LOCK
             WHERE gsm_user.USER_obj = pdUserObj
             NO-ERROR.
    ELSE
        FIND FIRST gsm_user NO-LOCK
             WHERE gsm_user.USER_login_name = pcLoginName
             NO-ERROR.

    IF AVAILABLE gsm_user 
    THEN DO:
        BUFFER-COPY gsm_user TO ttUser.

        /* For security reasons, don't pass the user obj or password */

        IF pdUserObj = 0 THEN
            ASSIGN ttUser.user_obj = ?.
        ASSIGN ttUser.user_password = "":U.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


