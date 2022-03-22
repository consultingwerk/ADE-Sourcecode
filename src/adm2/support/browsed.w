&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
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

  History:
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

/* Define the value of the "No Layout Options" supplied. */
&Scoped-define no-layout [default]

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Attribute-Dlg

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS l_Enable l_View l_ScrollRemote ~
l_FetchOnReposToEnd lUseSortIndicator 
&Scoped-Define DISPLAYED-OBJECTS l_Enable c_Layout l_View l_ScrollRemote ~
l_FetchOnReposToEnd lUseSortIndicator 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE VARIABLE c_Layout AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Layout" 
     VIEW-AS COMBO-BOX 
     DROP-DOWN-LIST
     SIZE 28 BY 1 NO-UNDO.

DEFINE VARIABLE lUseSortIndicator AS LOGICAL INITIAL no 
     LABEL "Show sort indicator" 
     CONTEXT-HELP-ID 0
     VIEW-AS TOGGLE-BOX
     SIZE 22.4 BY .81 NO-UNDO.

DEFINE VARIABLE l_Enable AS LOGICAL INITIAL no 
     LABEL "&Enable" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY 1.1 NO-UNDO.

DEFINE VARIABLE l_FetchOnReposToEnd AS LOGICAL INITIAL no 
     LABEL "&Fetch data to fill browse on reposition to end of batch" 
     VIEW-AS TOGGLE-BOX
     SIZE 58 BY .86 NO-UNDO.

DEFINE VARIABLE l_ScrollRemote AS LOGICAL INITIAL no 
     LABEL "&Scroll remote results list" 
     VIEW-AS TOGGLE-BOX
     SIZE 31 BY .81 NO-UNDO.

DEFINE VARIABLE l_View AS LOGICAL INITIAL no 
     LABEL "&View" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .86 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Attribute-Dlg
     l_Enable AT ROW 1.57 COL 5
     c_Layout AT ROW 1.57 COL 22.4
     l_View AT ROW 2.62 COL 5
     l_ScrollRemote AT ROW 3.62 COL 5
     l_FetchOnReposToEnd AT ROW 4.67 COL 5
     lUseSortIndicator AT ROW 5.67 COL 5 WIDGET-ID 2
     SPACE(35.60) SKIP(0.32)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "SmartDataBrowser Properties":L.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Attribute-Dlg
   FRAME-NAME L-To-R                                                    */
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
ON GO OF FRAME Attribute-Dlg /* SmartDataBrowser Properties */
DO:     
  /* Reassign the attribute alues back in the SmartObject. */
  ASSIGN l_Enable l_View l_ScrollRemote l_FetchOnReposToEnd
         c_Layout = c_Layout:SCREEN-VALUE WHEN c_Layout:SENSITIVE
         
         .
         
  DYNAMIC-FUNC("setDisableOnInit":U IN p_hSMO, INPUT NOT l_Enable) NO-ERROR.
  DYNAMIC-FUNC("setHideOnInit":U IN p_hSMO, INPUT NOT l_View) NO-ERROR.
  DYNAMIC-FUNC("setScrollRemote":U IN p_hSMO, INPUT l_ScrollRemote) NO-ERROR.
  DYNAMIC-FUNC("setFetchOnReposToEnd":U IN p_hSMO,l_FetchOnReposToEnd) NO-ERROR.
  DYNAMIC-FUNC("setUseSortIndicator":U IN p_hSMO,lUseSortIndicator) NO-ERROR.

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
ON WINDOW-CLOSE OF FRAME Attribute-Dlg /* SmartDataBrowser Properties */
DO:
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lUseSortIndicator
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lUseSortIndicator Attribute-Dlg
ON VALUE-CHANGED OF lUseSortIndicator IN FRAME Attribute-Dlg /* Show sort indicator */
DO:
  ASSIGN lUseSortIndicator.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l_FetchOnReposToEnd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l_FetchOnReposToEnd Attribute-Dlg
ON VALUE-CHANGED OF l_FetchOnReposToEnd IN FRAME Attribute-Dlg /* Fetch data to fill browse on reposition to end of batch */
DO:
  ASSIGN l_ScrollRemote.
  
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
{ adecomm/okbar.i  &TOOL = "AB"
                   &CONTEXT = {&BrowserSmartObject_Attributes_Dlg_Box} }

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
  DISPLAY l_Enable c_Layout l_View l_ScrollRemote l_FetchOnReposToEnd 
          lUseSortIndicator 
      WITH FRAME Attribute-Dlg.
  ENABLE l_Enable l_View l_ScrollRemote l_FetchOnReposToEnd lUseSortIndicator 
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
    /* Get the attributes used in this Instance Attribute dialog-box. */
    l_Enable = NOT DYNAMIC-FUNC("getDisableOnInit":U IN p_hSMO).
    l_View   = NOT DYNAMIC-FUNC("getHideOnInit":U IN p_hSMO).
    l_ScrollRemote = DYNAMIC-FUNC("getScrollRemote":U IN p_hSMO).
    l_FetchOnReposToEnd = DYNAMIC-FUNC("getFetchOnReposToEnd":U IN p_hSMO).
    lUseSortIndicator   = DYNAMIC-FUNC("getUseSortIndicator":U IN p_hSMO).
    /* Choose Layout. */
    /* V8: RUN get-attribute IN p_hSMO ("Layout-Options":U). */
    ASSIGN c_Layout = DYNAMIC-FUNC("getLayoutOptions":U IN p_hSMO) NO-ERROR.
    ASSIGN c_Layout = (IF c_Layout <> ? THEN c_Layout ELSE "").
    
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

