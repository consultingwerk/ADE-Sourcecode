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
  File: afbldwindp.p

  Description:  Build drop-down window list

  Purpose:      Build drop-down window list

  Parameters:

  History:
  --------
  (v:010000)    Task:          29   UserRef:    
                Date:   18/12/1997  Author:     Anthony Swindells

  Update Notes: Move osm- modules to af- modules

  (v:010000)    Task:           6   UserRef:    
                Date:   04/04/1997  Author:     Alec Tucker

  Update Notes: Work on new MIP Templates

  (v:010001)    Task:          47   UserRef:    XFTR
                Date:   16/01/1998  Author:     Alec Tucker

  Update Notes: Applied noddy afnodxftrp.p

  (v:010002)    Task:          51   UserRef:    AS0
                Date:   05/02/1998  Author:     Anthony Swindells

  Update Notes: Added new XFTR to enforce addition of version notes for the current object version on open of an object.

  (v:010003)    Task:         101   UserRef:    
                Date:   20/03/1998  Author:     Anthony Swindells

  Update Notes: Register MIP application framework directory changes

  (v:010004)    Task:         152   UserRef:    
                Date:   09/04/1998  Author:     Anthony Swindells

  Update Notes: Numbers on window drop down list

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afbldwindp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010004



DEFINE INPUT PARAMETER ip_calling_procedure_hdl AS HANDLE NO-UNDO.
DEFINE INPUT PARAMETER ip_parent_menu_hdl AS HANDLE NO-UNDO.
DEFINE INPUT PARAMETER ip_parent_window_hdl AS HANDLE NO-UNDO.

DEFINE VARIABLE lv_hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE lv_next_hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE lv_loop AS INTEGER NO-UNDO INITIAL 0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure



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
         HEIGHT             = 1.99
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */


  /* delete existing window menu-items */

  ASSIGN lv_hdl = ip_parent_menu_hdl:FIRST-CHILD.
  DO WHILE lv_hdl <> ?:
    lv_next_hdl = lv_hdl:NEXT-SIBLING.
    IF lv_hdl:DYNAMIC THEN DELETE WIDGET lv_hdl.
    lv_hdl = lv_next_hdl.
  END.

  RUN build-window-list-menu (SESSION).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE build-window-list-menu Procedure 
PROCEDURE build-window-list-menu :
/*------------------------------------------------------------------------------
  Purpose:     +
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER ip_handle  AS HANDLE NO-UNDO.

  DEFINE VARIABLE lv_handle AS HANDLE NO-UNDO.
  DEFINE VARIABLE lv_menu_item_hdl AS HANDLE NO-UNDO.
  DEFINE VARIABLE lv_enabled AS LOGICAL INITIAL yes.    

  ASSIGN
    lv_handle = ip_handle:FIRST-CHILD.
  DO WHILE VALID-HANDLE(lv_handle):
    IF lv_handle:TYPE = "WINDOW" AND
       lv_handle:VISIBLE AND
       LENGTH(TRIM(lv_handle:TITLE)) > 1 AND
       lv_handle <> ip_parent_window_hdl THEN DO:
      RUN is-window-enabled(INPUT lv_handle, OUTPUT lv_enabled).
      ASSIGN lv_loop = lv_loop + 1.
      CREATE MENU-ITEM lv_menu_item_hdl
      ASSIGN  
        LABEL = "&":U + TRIM(STRING(lv_loop)) + " ":U + lv_handle:TITLE
        PARENT = ip_parent_menu_hdl
        PRIVATE-DATA = STRING(lv_handle)
        SENSITIVE = lv_enabled
      TRIGGERS:
        ON "CHOOSE" PERSISTENT RUN give-window-focus IN ip_calling_procedure_hdl.
      END.                
    END.
    IF lv_handle:TYPE = "WINDOW":U THEN RUN build-window-list-menu (INPUT lv_handle).
    ASSIGN lv_handle = lv_handle:NEXT-SIBLING.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE is-window-enabled Procedure 
PROCEDURE is-window-enabled :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER ip_hdl AS HANDLE NO-UNDO.
  DEFINE OUTPUT PARAMETER op_enabled AS LOGICAL.

  DEFINE VARIABLE lv_enabled AS LOGICAL.
  /* recursive proc */

  IF ip_hdl  = ? THEN
  DO:
    lv_enabled = NO.
    RETURN.
  END.

    /* (010000/2) - Start */
        IF NOT ip_hdl:SENSITIVE THEN
        DO:
            ASSIGN
                lv_enabled = NO.
            RETURN.
        END.
    /* (010000/2) - Stop  */

  ip_hdl = ip_hdl:FIRST-CHILD.

  DO WHILE ip_hdl <> ?:
    IF ip_hdl:SENSITIVE THEN 
    DO:
      op_enabled = YES.
      RETURN.
    END. 

    RUN is-window-enabled (INPUT ip_hdl, OUTPUT lv_enabled).
    IF lv_enabled THEN DO:
      op_enabled = YES.
      RETURN.
    END.
    ip_hdl = ip_hdl:NEXT-SIBLING.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


