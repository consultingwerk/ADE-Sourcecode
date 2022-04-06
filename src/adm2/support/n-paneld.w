&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI
/* Procedure Description
"The Dialog-Box for navigation SmartPanels

This dialog-box is used to set the navigation SmartPanel-specific properties during design time."
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME SP-attr-dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS SP-attr-dialog 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: n-paneld.w

  Description: ADM 2 Dialog for getting setable properties of a navigation
               SmartPanel.

  Input Parameters:
      Handle of the calling SmartPanel.

  Output Parameters:
      <none>

  Author: 

  Modified:  March 23, 1998
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

&GLOBAL-DEFINE WIN95-BTN  YES

DEFINE INPUT PARAMETER p_hSMO AS HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE attr-list AS CHARACTER NO-UNDO.
DEFINE VARIABLE attr-name AS CHARACTER NO-UNDO.
DEFINE VARIABLE attr-value AS CHARACTER NO-UNDO.
DEFINE VARIABLE attr-entry AS CHARACTER NO-UNDO.
DEFINE VARIABLE i AS INTEGER NO-UNDO.
DEFINE VARIABLE entries AS INTEGER NO-UNDO.
DEFINE VARIABLE v-type AS CHARACTER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME SP-attr-dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS v-show v-edge-pixels v-rtl c_SDOList ~
lDeactivateTargetOnHide v-divider1 
&Scoped-Define DISPLAYED-OBJECTS v-show v-edge-pixels v-rtl c_SDOList ~
lDeactivateTargetOnHide v-divider1 v-divider2 v-divider-3 v-divider-4 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE VARIABLE c_SDOList AS CHARACTER FORMAT "X(256)":U 
     LABEL "SmartDataObject" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE v-divider-3 AS CHARACTER FORMAT "X(35)":U INITIAL " Data Object Name (if multiple)" 
      VIEW-AS TEXT 
     SIZE 54.6 BY .57
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE v-divider-4 AS CHARACTER FORMAT "X(50)":U INITIAL "Deactivation of link to hidden target" 
      VIEW-AS TEXT 
     SIZE 54.4 BY .57
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE v-divider1 AS CHARACTER FORMAT "X(75)":U INITIAL " Border" 
      VIEW-AS TEXT 
     SIZE 54 BY .57
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE v-divider2 AS CHARACTER FORMAT "X(25)":U INITIAL " Internationalization" 
      VIEW-AS TEXT 
     SIZE 54 BY .57
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE v-edge-pixels AS INTEGER FORMAT ">>9":U INITIAL 2 
     LABEL "&Edge Pixels" 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE lDeactivateTargetOnHide AS LOGICAL 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "When another target is viewed", no,
"Immediately on hide of target", yes
     SIZE 53 BY 1.62 NO-UNDO.

DEFINE VARIABLE v-rtl AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "'First' on &Left", "First-On-Left",
"'First' on &Right", "First-On-Right"
     SIZE 23 BY 1.62 NO-UNDO.

DEFINE VARIABLE v-show AS LOGICAL INITIAL yes 
     LABEL "&Show Border" 
     VIEW-AS TOGGLE-BOX
     SIZE 17.8 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME SP-attr-dialog
     v-show AT ROW 2.43 COL 3.8
     v-edge-pixels AT ROW 3.67 COL 14 COLON-ALIGNED
     v-rtl AT ROW 6.1 COL 3.6 NO-LABEL
     c_SDOList AT ROW 9.19 COL 19 COLON-ALIGNED
     lDeactivateTargetOnHide AT ROW 11.91 COL 3.6 NO-LABEL
     v-divider1 AT ROW 1.62 COL 2.6 NO-LABEL
     v-divider2 AT ROW 5.19 COL 2.4 NO-LABEL
     v-divider-3 AT ROW 8.05 COL 1.8 NO-LABEL
     v-divider-4 AT ROW 10.81 COL 2 NO-LABEL
     SPACE(0.39) SKIP(2.15)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Navigation SmartPanel Properties".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX SP-attr-dialog
                                                                        */
ASSIGN 
       FRAME SP-attr-dialog:SCROLLABLE       = FALSE
       FRAME SP-attr-dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN v-divider-3 IN FRAME SP-attr-dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN v-divider-4 IN FRAME SP-attr-dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN v-divider1 IN FRAME SP-attr-dialog
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN v-divider2 IN FRAME SP-attr-dialog
   NO-ENABLE ALIGN-L                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME SP-attr-dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SP-attr-dialog SP-attr-dialog
ON WINDOW-CLOSE OF FRAME SP-attr-dialog /* Navigation SmartPanel Properties */
DO:
 APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c_SDOList
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c_SDOList SP-attr-dialog
ON VALUE-CHANGED OF c_SDOList IN FRAME SP-attr-dialog /* SmartDataObject */
DO:
  ASSIGN c_SDOList.
  /* Assign the handle of the SDO they chose */
/*   IF c_SDOList NE "":U THEN            */
/*       hSDO = WIDGET-HANDLE(c_SDOList). */
/*                                        */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-edge-pixels
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-edge-pixels SP-attr-dialog
ON LEAVE OF v-edge-pixels IN FRAME SP-attr-dialog /* Edge Pixels */
DO:
  RUN set-state.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-show
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-show SP-attr-dialog
ON VALUE-CHANGED OF v-show IN FRAME SP-attr-dialog /* Show Border */
DO:
  IF v-show:CHECKED = NO THEN DO:
     v-edge-pixels:SCREEN-VALUE = STRING (0).
     v-edge-pixels:SENSITIVE = NO.
  END.
  ELSE DO:
     v-edge-pixels:SENSITIVE = YES.
     IF v-edge-pixels:SCREEN-VALUE = STRING (0) THEN
        v-edge-pixels:SCREEN-VALUE = STRING (2).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK SP-attr-dialog 


/* ****************** Standard Buttons and ADM Help ******************* */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Define Context ID's for HELP files */
{ src/adm2/support/admhlp.i }    

/* Attach the standard OK/Cancel/Help button bar. */
{ adecomm/okbar.i  &TOOL = "AB"
                   &CONTEXT = {&SmartNavPanel_Attributes_Dlg_Box} }

/* ***************************  Main Block  *************************** */

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
   
  RUN get-SmO-attributes.

  RUN enable_UI.

  /* Set the cursor */
  RUN adecomm/_setcurs.p ("":U).
  
  RUN set-state.

  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
  
  ASSIGN v-rtl
         v-edge-pixels
         lDeactivateTargetOnHide.
  
  {set PanelType v-type p_hSMO}.
  {set EdgePixels v-edge-pixels p_hSMO}.
  {set RightToLeft v-rtl p_hSMO} NO-ERROR.
  {set DeactivateTargetOnHide lDeactivateTargetOnHide p_hSMO}.
  IF c_SDOList NE "<none>":U THEN
      {set NavigationTargetName c_SDOList p_hSMO}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI SP-attr-dialog  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME SP-attr-dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI SP-attr-dialog  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY v-show v-edge-pixels v-rtl c_SDOList lDeactivateTargetOnHide 
          v-divider1 v-divider2 v-divider-3 v-divider-4 
      WITH FRAME SP-attr-dialog.
  ENABLE v-show v-edge-pixels v-rtl c_SDOList lDeactivateTargetOnHide 
         v-divider1 
      WITH FRAME SP-attr-dialog.
  VIEW FRAME SP-attr-dialog.
  {&OPEN-BROWSERS-IN-QUERY-SP-attr-dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-SmO-attributes SP-attr-dialog 
PROCEDURE get-SmO-attributes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cSDO            AS CHAR   NO-UNDO.
    DEFINE VARIABLE cContext        AS CHAR   NO-UNDO.
    DEFINE VARIABLE hNavTarget      AS HANDLE NO-UNDO.
    DEFINE VARIABLE cObjectNames    AS CHAR   NO-UNDO.
    DEFINE VARIABLE cListItems      AS CHAR   NO-UNDO.
    DEFINE VARIABLE cObjectName     AS CHAR   NO-UNDO.
     
    attr-list = dynamic-function("instancePropertyList":U IN p_hSMO, 
     '':U).
   entries = NUM-ENTRIES (attr-list, CHR(3)).
   DO i = 1 TO entries:
      ASSIGN attr-entry = ENTRY (i, attr-list, CHR(3))
             attr-name  = TRIM (ENTRY(1, attr-entry, CHR(4)))
             attr-value = TRIM (ENTRY(2, attr-entry, CHR(4))).
 
      CASE attr-name:
        WHEN "PanelType":U THEN
           v-type = attr-value.
        WHEN "RightToLeft":U THEN
           v-rtl = attr-value.
        WHEN "EdgePixels":U THEN
           v-edge-pixels = INTEGER (attr-value).
        WHEN "NavigationTargetName":U THEN
            c_SDOList = IF attr-value = "":U THEN "<none>":U ELSE attr-value.
        WHEN "DeactivateTargetOnHide":U THEN
           lDeactivateTargetOnHide = can-do('yes,true':U,attr-value).
      END CASE.
   END.

    /* New code for 9.1B to support an SBO as a Naviogation-Target.
       If this is the case, the DataObjectNames property will come back with
       a list of all the SDO names, and the developer can pick one as the
       intended Navigation-target for this panel. */
    /* Get the handle of the associated SmartDataObject, if any. */
    RUN adeuib/_uibinfo (?, "HANDLE ":U + STRING(p_hSMO), 
                         "LINK NAVIGATION-TARGET":U, 
                          OUTPUT cContext). 
                          /* Returns the Context ID of our Data-Source */
    /* If the user hasn't defined the Nav link yet, this will be unknown. */
    IF NUM-ENTRIES(cContext) < 2 AND cContext NE "":U AND cContext NE ? THEN
    DO:
      RUN adeuib/_uibinfo (INT(cContext), ?, "PROCEDURE-HANDLE":U,
         OUTPUT cSDO).
      
      hNavTarget = WIDGET-HANDLE(cSDO).
      cObjectNames = DYNAMIC-FUNCTION('getDataObjectNames' IN hNavTarget)
           NO-ERROR.     /* Fn won't exist if this isn't an SBO. */
      IF cObjectNames = "":U THEN   /* Blank means the prop exists but isn't set.*/
      DO:
        RUN initializeObject IN hNavTarget.
        cObjectNames = DYNAMIC-FUNCTION('getDataObjectNames' IN hNavTarget)
          NO-ERROR.

      END.    /* END DO IF NO Targets yet */
    END.        /* END DO IF cContext defined */

    /* This would be if the target has no such property (is not an SBO). */     
    IF cObjectNames = ? THEN    
        cObjectNames = "":U.

    cListItems = '<none>':U + (IF cObjectNames NE "":U THEN ",":U ELSE "":U)
        + cObjectNames.
     
    ASSIGN c_SDOList:LIST-ITEMS IN FRAME {&FRAME-NAME} = cListItems
           c_SDOList:INNER-LINES = MAX(5,NUM-ENTRIES(cListItems) / 2)
           c_SDOList:SCREEN-VALUE = c_SDOList.

     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-state SP-attr-dialog 
PROCEDURE set-state :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:
  
    IF v-type = "NAV-LABEL":U THEN
      v-rtl:SENSITIVE = NO.
   
    IF v-edge-pixels:SCREEN-VALUE = STRING (0) THEN DO:
       v-show:CHECKED = NO.
       v-edge-pixels:SENSITIVE = NO.
    END.
        
    IF c_SDOList:NUM-ITEMS = 1 THEN   /* "<none>" is the only entry */
       c_SDOList:SENSITIVE = NO.      /*  so don't enable it. */
    ELSE 
       /* we currently only support this for SDOs  */
       lDeactivateTargetOnHide:SENSITIVE = NO. 
  END.
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

