&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Attribute-Dlg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Attribute-Dlg 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: visuald.w 

  Description: Instance Properties Dialog for Visual SmartObjects.

  Input Parameters:
     p_hSMO -- Procedure Handle of calling SmartObject.

  Output Parameters:
      <none>

  History: Modified A D Swindells 27/07/2000. 
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&GLOBAL-DEFINE WIN95-BTN YES

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p_hSMO AS HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE attr-list   AS CHARACTER NO-UNDO.
DEFINE VARIABLE orig-layout AS CHARACTER NO-UNDO.
DEFINE VARIABLE gcEditSingleInstance        AS CHARACTER            NO-UNDO.

/* Define the value of the "No Layout Options" supplied. */
&Scoped-define no-layout [default]

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Attribute-Dlg

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS l_Enable l_View c_Logical_Object_Name ~
BUTTON-2 BUTTON-3 
&Scoped-Define DISPLAYED-OBJECTS l_Enable c_Layout l_View ~
c_Logical_Object_Name 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-2 AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.14.

DEFINE BUTTON BUTTON-3 AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE c_Layout AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Layout" 
     VIEW-AS COMBO-BOX 
     DROP-DOWN-LIST
     SIZE 28 BY 1 NO-UNDO.

DEFINE VARIABLE c_Logical_Object_Name AS CHARACTER FORMAT "X(256)":U 
     LABEL "Logical Object Name" 
     VIEW-AS FILL-IN 
     SIZE 28 BY 1 NO-UNDO.

DEFINE VARIABLE l_Enable AS LOGICAL INITIAL no 
     LABEL "&Enable" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY 1.1 NO-UNDO.

DEFINE VARIABLE l_View AS LOGICAL INITIAL no 
     LABEL "&View" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .86 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Attribute-Dlg
     l_Enable AT ROW 2.29 COL 5
     c_Layout AT ROW 2.29 COL 15.8
     l_View AT ROW 3.33 COL 5
     c_Logical_Object_Name AT ROW 4.57 COL 27.4 COLON-ALIGNED
     BUTTON-2 AT ROW 7.19 COL 32
     BUTTON-3 AT ROW 7.19 COL 48
     "  Behavior During 'Initialize'" VIEW-AS TEXT
          SIZE 60 BY .62 AT ROW 1.48 COL 3
     SPACE(0.59) SKIP(6.46)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Visual SmartObject Properties":L
         DEFAULT-BUTTON BUTTON-2.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Compile into: gui\adm2\support
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Attribute-Dlg
   L-To-R                                                               */
ASSIGN 
       FRAME Attribute-Dlg:SCROLLABLE       = FALSE
       FRAME Attribute-Dlg:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX c_Layout IN FRAME Attribute-Dlg
   NO-ENABLE ALIGN-L                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX Attribute-Dlg
/* Query rebuild information for DIALOG-BOX Attribute-Dlg
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX Attribute-Dlg */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Attribute-Dlg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Attribute-Dlg Attribute-Dlg
ON GO OF FRAME Attribute-Dlg /* Visual SmartObject Properties */
DO:     
  /* Reassign the attribute alues back in the SmartObject. */
  ASSIGN l_Enable l_View c_Logical_Object_Name
         c_Layout = c_Layout:SCREEN-VALUE WHEN c_Layout:SENSITIVE
         .
         
  DYNAMIC-FUNC("setDisableOnInit":U IN p_hSMO, INPUT NOT l_Enable) NO-ERROR.
  DYNAMIC-FUNC("setHideOnInit":U IN p_hSMO, INPUT NOT l_View) NO-ERROR.
  DYNAMIC-FUNC("setLogicalObjectName":U IN p_hSMO, INPUT c_Logical_Object_Name) NO-ERROR.

  /* Only set the layout if it has changed.  Remember that LAYOUT is an
     attribute whose changes must be explicitly applied. */
  IF c_Layout:SENSITIVE AND c_Layout ne orig-layout THEN DO:
    IF c_Layout eq "{&no-layout}":U THEN c_Layout = "":U.
    DYNAMIC-FUNC("setObjectLayout":U IN p_hSMO, INPUT c_Layout) NO-ERROR.
    RUN applyLayout IN p_hSMO.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Attribute-Dlg Attribute-Dlg
ON WINDOW-CLOSE OF FRAME Attribute-Dlg /* Visual SmartObject Properties */
DO:
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Attribute-Dlg 


/* **************** Standard Buttons and Help Setup ******************* */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Define Context ID's for HELP files */
{ src/adm2/support/admhlp.i }    

/* Attach the standard OK/Cancel/Help button bar. */
/* { adecomm/okbar.i  &TOOL = "AB"                                         */
/*                    &CONTEXT = {&VisualSmartObject_Attributes_Dlg_Box} } */

/* ***************************  Main Block  *************************** */

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  /* Get the values of the attributes in the SmartObject that can be 
     changed in this dialog-box. */
  RUN get-SmO-attributes.
  /* Enable the interface. */         
  RUN enable_UI.  

  /* Disable the logical object name if this is a single instance, i.e. 
   * modifying an object's properties on a container using the Container
   * Builder or the Page Layout tool.                                    */
  IF gcEditSingleInstance EQ "YES":U THEN
      ASSIGN c_Logical_Object_Name:SENSITIVE = NO.

  /* Set the cursor */
  RUN adecomm/_setcurs.p ("":U).  
 
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.  
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Attribute-Dlg  _DEFAULT-DISABLE
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
  HIDE FRAME Attribute-Dlg.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Attribute-Dlg  _DEFAULT-ENABLE
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
  DISPLAY l_Enable c_Layout l_View c_Logical_Object_Name 
      WITH FRAME Attribute-Dlg.
  ENABLE l_Enable l_View c_Logical_Object_Name BUTTON-2 BUTTON-3 
      WITH FRAME Attribute-Dlg.
  VIEW FRAME Attribute-Dlg.
  {&OPEN-BROWSERS-IN-QUERY-Attribute-Dlg}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-SmO-attributes Attribute-Dlg 
PROCEDURE get-SmO-attributes :
/*------------------------------------------------------------------------------
  Purpose:     Ask the "parent" SmartObject for the attributes that can be 
               changed in this dialog.  Save some of the initial-values.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR ldummy AS LOGICAL NO-UNDO.
   
  DO WITH FRAME {&FRAME-NAME}:   
    ASSIGN gcEditSingleInstance = DYNAMIC-FUNCTION("getUserProperty":U IN p_hSMO, "EditSingleInstance":U).

    /* Get the attributes used in this Instance Attribute dialog-box. */
    l_Enable = NOT DYNAMIC-FUNC("getDisableOnInit":U IN p_hSMO).
    l_View   = NOT DYNAMIC-FUNC("getHideOnInit":U IN p_hSMO).
    
    /* Choose Layout. */
    /* V8: RUN get-attribute IN p_hSMO ("Layout-Options":U). */
    ASSIGN c_Layout = DYNAMIC-FUNC("getLayoutOptions":U IN p_hSMO) NO-ERROR.
    ASSIGN c_Layout = (IF c_Layout <> ? THEN c_Layout ELSE "").
    
    /* determine logical object name */    
    ASSIGN c_Logical_Object_Name = DYNAMIC-FUNC("getLogicalObjectName":U IN p_hSMO) NO-ERROR.

    ASSIGN 
      c_Layout:LIST-ITEMS  = c_Layout
      ldummy               = c_Layout:ADD-FIRST ("{&no-layout}":U)
      c_Layout:SENSITIVE   = c_Layout:NUM-ITEMS > 1
      c_Layout:INNER-LINES = MIN(10,MAX(3,c_Layout:NUM-ITEMS + 1)).

    /* V8: RUN get-attribute IN p_hSMO ("Layout":U). */
    ASSIGN c_Layout = DYNAMIC-FUNC("getObjectLayout":U IN p_hSMO) NO-ERROR.
    ASSIGN c_Layout    = IF c_Layout = ? OR c_Layout = "":U OR
                            c_Layout = "?":U /* Compatibility with ADM1.0 */
                         THEN "{&no-layout}":U 
                         ELSE c_Layout
           orig-layout = c_Layout.
  END. /* DO WITH FRAME... */
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

