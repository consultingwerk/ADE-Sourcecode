&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Include _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Include _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
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
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: afloadicon.i

  Description:  Load ICF icons

  Purpose:      Load ICF icons

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:         543   UserRef:    
                Date:   16/08/1998  Author:     Anthony Swindells

  Update Notes: Created from Template afteminclu.i

  (v:010001)    Task:        5438   UserRef:    
                Date:   12/04/2000  Author:     Jenny Bond

  Update Notes: Implement system icon and product logo

--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afloadicon.i
&scop object-version    000000


/* MIP object identifying preprocessor */
&glob   mip-structured-include  yes

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
         HEIGHT             = 5.19
         WIDTH              = 42.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */
DEFINE VARIABLE lv_system_icon          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lv_small_system_icon    AS CHARACTER  NO-UNDO.

FIND FIRST gsc_security_control NO-LOCK NO-ERROR.
ASSIGN
    lv_system_icon       = IF  AVAILABLE gsc_security_control AND gsc_security_control.system_icon_filename <> "":U THEN
                            gsc_security_control.system_icon_filename ELSE ""
    lv_small_system_icon = IF  AVAILABLE gsc_security_control AND gsc_security_control.small_icon_filename <> "":U THEN
                            gsc_security_control.small_icon_filename ELSE ""
  .

IF  lv_system_icon <> "":U AND SEARCH(lv_system_icon) <> ? THEN DO:
    IF NOT {&WINDOW-NAME}:LOAD-ICON(lv_system_icon) THEN
        MESSAGE "Unable to load icon: " + lv_system_icon
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
END.
ELSE
    IF NOT {&WINDOW-NAME}:LOAD-ICON("adeicon/icfdev.ico":U) THEN
        MESSAGE "Unable to load icon: adeicon/icfdev.ico"
                VIEW-AS ALERT-BOX WARNING BUTTONS OK.

IF  lv_small_system_icon <> "":U AND SEARCH(lv_small_system_icon) <> ? THEN DO:
    IF NOT {&WINDOW-NAME}:LOAD-SMALL-ICON(lv_small_system_icon) THEN
        MESSAGE "Unable to load icon: " + lv_small_system_icon
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
END.
ELSE
    IF NOT {&WINDOW-NAME}:LOAD-SMALL-ICON("adeicon/icfdev.ico":U) THEN
        MESSAGE "Unable to load small icon: adeicon/icfdev.ico"
                VIEW-AS ALERT-BOX WARNING BUTTONS OK.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


