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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "CreateWizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? af/sup/afwizdeltp.p */
/* MIP New Program Wizard
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
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: afobjsecop.p

  Description:  Turn on/off object security for all obje

  Purpose:      To enable or disable object security for all objects. This is really required
                because the take-on programs do not turn on object security, so this noddy
                must be run to fix this.

  Parameters:   ip_action = "ON" or "OFF"

  History:
  --------
  (v:010000)    Task:         357   UserRef:    sm
                Date:   28/04/1999  Author:     Anthony Swindells

  Update Notes: Created from Template aftemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER ip_action AS CHARACTER NO-UNDO.

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afobjsecop.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

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
         HEIGHT             = 7.19
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

RUN change-object-security.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-change-object-security) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE change-object-security Procedure 
PROCEDURE change-object-security :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF ip_action = "OFF":U THEN
  FOR EACH ryc_smartobject NO-LOCK
     WHERE ryc_smartobject.security_smartobject_obj > 0:
    RUN disable-security (INPUT ROWID(ryc_smartobject)).
  END.

IF ip_action = "ON":U THEN
  FOR EACH ryc_smartobject NO-LOCK
     WHERE ryc_smartobject.security_smartobject_obj = 0:
    RUN enable-security (INPUT ROWID(ryc_smartobject)).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disable-security) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable-security Procedure 
PROCEDURE disable-security :
/*------------------------------------------------------------------------------
  Purpose:      Disable object security    
  Parameters:   rowid of object
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER ip_rowid AS ROWID NO-UNDO.

DEFINE BUFFER lb_ryc_smartobject FOR ryc_smartobject.

DO FOR lb_ryc_smartobject TRANSACTION ON ERROR UNDO, RETURN:
    FIND lb_ryc_smartobject EXCLUSIVE-LOCK
         WHERE ROWID(lb_ryc_smartobject) = ip_rowid
         NO-ERROR.
    IF AVAILABLE lb_ryc_smartobject THEN
        ASSIGN lb_ryc_smartobject.security_smartobject_obj = 0.
END.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enable-security) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable-security Procedure 
PROCEDURE enable-security :
/*------------------------------------------------------------------------------
  Purpose:      Enable object security    
  Parameters:   rowid of object
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER ip_rowid AS ROWID NO-UNDO.

DEFINE BUFFER lb_ryc_smartobject FOR ryc_smartobject.

DO FOR lb_ryc_smartobject TRANSACTION ON ERROR UNDO, RETURN:
    FIND lb_ryc_smartobject EXCLUSIVE-LOCK
         WHERE ROWID(lb_ryc_smartobject) = ip_rowid
         NO-ERROR.
    IF AVAILABLE lb_ryc_smartobject THEN
        ASSIGN lb_ryc_smartobject.security_smartobject_obj = lb_ryc_smartobject.smartobject_obj.
END.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

