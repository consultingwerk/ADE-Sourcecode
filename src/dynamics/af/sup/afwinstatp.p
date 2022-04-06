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
  File: afwinstatp.p

  Description:  Window state procedure

  Purpose:      This procedure allows windows to be minimised or maximised as required. It
                will never do anything to the calling procedure. It can optionally start at a
                certain procedure and only min/max windows called from that.

  Parameters:   ip_caller_handle        Handle of calling procedure
                ip_action               MIN or NRM or HID or VEW
                im_start_handle         Handle of window to start from

  History:
  --------
  (v:010000)    Task:         415   UserRef:    Astra
                Date:   10/07/1998  Author:     Anthony Swindells

  Update Notes: Created from Template aftemprocp.p

  (v:010001)    Task:        6145   UserRef:    
                Date:   24/06/2000  Author:     Anthony Swindells

  Update Notes: code hide and view

  (v:010002)    Task:        6560   UserRef:    
                Date:   23/08/2000  Author:     Jenny Bond

  Update Notes: When suspend, then view again, extra windows are viewed.  Only a problem
                in the development environment.

-------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afwinstatp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010002


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

DEFINE INPUT PARAMETER  ip_caller_handle                AS HANDLE       NO-UNDO.
DEFINE INPUT PARAMETER  ip_action                       AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER  ip_start_handle                 AS HANDLE       NO-UNDO.

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
         HEIGHT             = 6.52
         WIDTH              = 47.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

  IF NOT VALID-HANDLE(ip_start_handle) THEN
      RUN search-windows(SESSION).
  ELSE
      RUN search-windows(ip_start_handle).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-search-windows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE search-windows Procedure 
PROCEDURE search-windows :
/*------------------------------------------------------------------------------
  Purpose:     Recursive search windows and perform action on them
  Parameters:  ip_handle to start from
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER ip_handle  AS HANDLE NO-UNDO.

  DEFINE VARIABLE lv_handle AS HANDLE NO-UNDO.

  ASSIGN
    lv_handle = ip_handle:FIRST-CHILD.

  DO WHILE VALID-HANDLE(lv_handle):
    IF lv_handle:TYPE = "WINDOW":U AND
       lv_handle <> ip_caller_handle THEN
      CASE ip_action:
        WHEN "MIN":U THEN
          ASSIGN lv_handle:WINDOW-STATE = WINDOW-MINIMIZED.

        WHEN "NRM":U THEN
          ASSIGN lv_handle:WINDOW-STATE = WINDOW-NORMAL.

        WHEN "HID":U THEN DO:
             IF NOT lv_handle:HIDDEN THEN
                ASSIGN lv_handle:HIDDEN = TRUE.
        END.

        WHEN "VEW":U THEN
        DO:
          IF LV_HANDLE:TITLE <> ? THEN
            ASSIGN lv_handle:HIDDEN = FALSE.
        END.

      END CASE.
  /*  IF lv_handle:TYPE = "WINDOW":U THEN RUN search-windows (INPUT lv_handle).*/
    ASSIGN lv_handle = lv_handle:NEXT-SIBLING.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

