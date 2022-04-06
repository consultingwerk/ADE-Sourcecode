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
  File: afgetgansp.p

  Description:  Get Global and Security Control TTs

  Purpose:      Get Global and Security Control TTs

  Parameters:   output global control temp-table
                output security control temp-table

  History:
  --------
  (v:010000)    Task:        6120   UserRef:    
                Date:   22/06/2000  Author:     Anthony Swindells

  Update Notes: Reduce Appserver Requests in Managers / login

  (v:010001)    Task:    90000031   UserRef:    
                Date:   22/03/2001  Author:     Anthony Swindells

  Update Notes: removal of Astra 1

--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afgetgansp.p
&scop object-version    010001


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes


{af/sup2/afglobals.i}     /* Astra global shared variables */

{af/app/afttglobalctrl.i}
{af/app/afttsecurityctrl.i}

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

DEFINE OUTPUT PARAMETER TABLE FOR ttGlobalControl.
DEFINE OUTPUT PARAMETER TABLE FOR ttSecurityControl.

DEFINE VARIABLE tEffectiveDate AS DATE NO-UNDO.

EMPTY TEMP-TABLE ttGlobalControl.  

FIND FIRST gsc_global_control NO-LOCK NO-ERROR.

IF AVAILABLE gsc_global_control THEN
DO:
  CREATE ttGlobalControl.
  BUFFER-COPY gsc_global_control TO ttGlobalControl.  
END.

EMPTY TEMP-TABLE ttSecurityControl.  

FIND FIRST gsc_security_control NO-LOCK NO-ERROR.
IF AVAILABLE gsc_security_control THEN
DO:
  CREATE ttSecurityControl.
  BUFFER-COPY gsc_security_control TO ttSecurityControl.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


