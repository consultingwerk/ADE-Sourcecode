&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Attribute-Dlg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Attribute-Dlg 
/*********************************************************************
* Copyright (C) 2001 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
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

DEFINE TEMP-TABLE ttEnabledObject
   FIELD ObjectName AS CHAR 
   FIELD ToggleHandle AS HANDLE
  .
/* Local Variable Definitions ---                                       */
DEFINE VARIABLE attr-list                   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE orig-layout                 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDisableObjects            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE xdScrollToggleHeight        AS DECIMAL    NO-UNDO INIT 0.72.

/* Define the value of the "No Layout Options" supplied. */
&Scoped-define no-layout [default]
{adeuib/uibhlp.i}          /* Help File Preprocessor Directives         */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Attribute-Dlg

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS l_Enable l_View cDisabledObjects BUTTON-2 ~
BUTTON-3 fiChar RECT-2 RECT-3 
&Scoped-Define DISPLAYED-OBJECTS c_Logical_Object_Name l_Enable c_Layout ~
l_View cDisabledObjects fiChar 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createFrameBorder Attribute-Dlg 
FUNCTION createFrameBorder RETURNS LOGICAL
  ( phFrame AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createToggle Attribute-Dlg 
FUNCTION createToggle RETURNS HANDLE
  ( phFrame  AS HANDLE,
    pcLabel  AS CHAR,
    pdRow    AS DEC,
    pdCol    AS DEC)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD disableObjectFrame Attribute-Dlg 
FUNCTION disableObjectFrame RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD enableObjectFrame Attribute-Dlg 
FUNCTION enableObjectFrame RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initDisabledObjects Attribute-Dlg 
FUNCTION initDisabledObjects RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initEnabledObjects Attribute-Dlg 
FUNCTION initEnabledObjects RETURNS LOGICAL
  ( pcEnabledObjects AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD toggleObjects Attribute-Dlg 
FUNCTION toggleObjects RETURNS LOGICAL
  ( plON AS LOG  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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
     SIZE 27.8 BY 1 NO-UNDO.

DEFINE VARIABLE c_Logical_Object_Name AS CHARACTER FORMAT "X(256)":U 
     LABEL "Object Name" 
     VIEW-AS FILL-IN 
     SIZE 43.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiChar AS CHARACTER FORMAT "X(256)":U INITIAL "Objects To Disable With Data Fields" 
      VIEW-AS TEXT 
     SIZE 35 BY .62 NO-UNDO.

DEFINE VARIABLE cDisabledObjects AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "None", "(None)",
"All", "(All)",
"Some", ""
     SIZE 14.4 BY 2.57 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 60 BY .1.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 60 BY .1.

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
     c_Logical_Object_Name AT ROW 1.48 COL 4.4
     l_Enable AT ROW 3.91 COL 4.6
     c_Layout AT ROW 3.95 COL 32 COLON-ALIGNED
     l_View AT ROW 4.95 COL 4.6
     cDisabledObjects AT ROW 7 COL 4.4 NO-LABEL
     BUTTON-2 AT ROW 14.19 COL 30.4
     BUTTON-3 AT ROW 14.19 COL 46.8
     fiChar AT ROW 6.14 COL 2.4 COLON-ALIGNED NO-LABEL
     RECT-2 AT ROW 6.43 COL 1.8
     RECT-3 AT ROW 3.43 COL 1.8
     "Behavior During 'Initialize'" VIEW-AS TEXT
          SIZE 24.8 BY .62 AT ROW 3.1 COL 4.4
     SPACE(33.19) SKIP(12.03)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Viewer Instance Properties":L
         DEFAULT-BUTTON BUTTON-2.

DEFINE FRAME frDisabledObjects
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 4.8 ROW 9.76
         SIZE 56.2 BY 3.86.


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
/* REPARENT FRAME */
ASSIGN FRAME frDisabledObjects:FRAME = FRAME Attribute-Dlg:HANDLE.

/* SETTINGS FOR DIALOG-BOX Attribute-Dlg
   L-To-R                                                               */
ASSIGN 
       FRAME Attribute-Dlg:SCROLLABLE       = FALSE
       FRAME Attribute-Dlg:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX c_Layout IN FRAME Attribute-Dlg
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c_Logical_Object_Name IN FRAME Attribute-Dlg
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FRAME frDisabledObjects
   NOT-VISIBLE                                                          */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX Attribute-Dlg
/* Query rebuild information for DIALOG-BOX Attribute-Dlg
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX Attribute-Dlg */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frDisabledObjects
/* Query rebuild information for FRAME frDisabledObjects
     _Query            is NOT OPENED
*/  /* FRAME frDisabledObjects */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Attribute-Dlg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Attribute-Dlg Attribute-Dlg
ON GO OF FRAME Attribute-Dlg /* Viewer Instance Properties */
DO:     
  /* Reassign the attribute alues back in the SmartObject. */
  ASSIGN 
    l_Enable 
    l_View
    c_Logical_Object_Name
    c_Layout = c_Layout:SCREEN-VALUE WHEN c_Layout:SENSITIVE.
 
  DYNAMIC-FUNC("setDisableOnInit":U IN p_hSMO, NOT l_Enable) NO-ERROR.
  DYNAMIC-FUNC("setHideOnInit":U IN p_hSMO, NOT l_View) NO-ERROR.
  DYNAMIC-FUNC("setLogicalObjectName":U IN p_hSMO, c_Logical_Object_Name) NO-ERROR.
  
  IF gcDisableObjects = '':U THEN
  DO:
    FOR EACH ttEnabledObject:
      IF ttEnabledObject.toggleHandle:CHECKED THEN
         gcDisableObjects = gcDisableObjects 
                          + (IF gcDisableObjects = '':U THEN '':U ELSE ',':U)
                          + ttEnabledObject.ObjectName.
    END.
  END.
  /* Only store if different since the ? value is the value stored to get 
     a backward compatible defalt (this is not a big deal, but it may avoid 
     unnecessary storage in repository) */
  IF gcDisableObjects <> DYNAMIC-FUNCTION("getEnabledObjFldsToDisable":U IN p_hSMO) THEN   
     DYNAMIC-FUNCTION("setEnabledObjFldsToDisable":U IN p_hSMO, gcDisableObjects) NO-ERROR.   

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
ON HELP OF FRAME Attribute-Dlg /* Viewer Instance Properties */
DO:
   RUN adecomm/_adehelp.p 
      ("ICAB", "CONTEXT":U, {&Viewer_Instance_Properties_Dialog_Box},?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Attribute-Dlg Attribute-Dlg
ON WINDOW-CLOSE OF FRAME Attribute-Dlg /* Viewer Instance Properties */
DO:
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cDisabledObjects
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cDisabledObjects Attribute-Dlg
ON VALUE-CHANGED OF cDisabledObjects IN FRAME Attribute-Dlg
DO:
  ASSIGN cDisabledObjects.
  initDisabledObjects().
  gcDisableObjects = cDisabledObjects.
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
  createFrameborder(FRAME frDisabledObjects:HANDLE).
  /* avoid errors when objectframe is scrollable */
  FRAME frDisabledObjects:HIDDEN = FALSE NO-ERROR.
  FRAME frDisabledObjects:MOVE-AFTER(cDisabledObjects:HANDLE).
  RUN enable_UI.  
 
  /* Set the cursor */
  RUN adecomm/_setcurs.p ("":U).  
 
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.  
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cursorMove Attribute-Dlg 
PROCEDURE cursorMove :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phToggle AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER pcMove   AS CHARACTER  NO-UNDO.

  FIND ttEnabledObject WHERE ttEnabledObject.ToggleHandle  = phToggle NO-ERROR.
  
  IF AVAIL ttEnabledObject THEN
  DO:
    CASE pcMove:
      WHEN 'DOWN':U THEN
      DO:
       FIND NEXT ttEnabledObject NO-ERROR.
       IF NOT AVAIL ttEnabledObject THEN
          FIND FIRST ttEnabledObject NO-ERROR.
      END.
      WHEN 'UP':U THEN
      DO:
       FIND PREV ttEnabledObject NO-ERROR.
       IF NOT AVAIL ttEnabledObject THEN
          FIND LAST ttEnabledObject NO-ERROR.
      END.
    END.
    IF AVAIL ttEnabledObject THEN
      APPLY 'Entry' TO ttEnabledObject.ToggleHandle.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  HIDE FRAME frDisabledObjects.
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
  DISPLAY c_Logical_Object_Name l_Enable c_Layout l_View cDisabledObjects fiChar 
      WITH FRAME Attribute-Dlg.
  ENABLE l_Enable l_View cDisabledObjects BUTTON-2 BUTTON-3 fiChar RECT-2 
         RECT-3 
      WITH FRAME Attribute-Dlg.
  VIEW FRAME Attribute-Dlg.
  {&OPEN-BROWSERS-IN-QUERY-Attribute-Dlg}
  {&OPEN-BROWSERS-IN-QUERY-frDisabledObjects}
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
  DEFINE VARIABLE ldummy          AS LOGICAL NO-UNDO.
  DEFINE VARIABLE lUseRepository  AS LOGICAL NO-UNDO.
  DEFINE VARIABLE cSingleInstance AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEnabledObjects AS CHARACTER  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:   
    lUseRepository = DYNAMIC-FUNCTION("getUseRepository":U IN p_hSMO) NO-ERROR.
    cSingleInstance = DYNAMIC-FUNCTION("getUserProperty":U IN p_hSMO, "EditSingleInstance":U).

    /* Get the attributes used in this Instance Attribute dialog-box. */
    l_Enable = NOT DYNAMIC-FUNC("getDisableOnInit":U IN p_hSMO).
    l_View   = NOT DYNAMIC-FUNC("getHideOnInit":U IN p_hSMO).
    cEnabledObjects = DYNAMIC-FUNCTION("getEnabledObjFlds":U IN p_hSMO).   
    gcDisableObjects = DYNAMIC-FUNCTION("getEnabledObjFldsToDisable":U IN p_hSMO).   
    
    IF cEnabledObjects <> '':u THEN
      initEnabledObjects(cEnabledObjects).
    IF CAN-DO('(All),(None)':U,gcDisableObjects) THEN
      cDisabledObjects = gcDisableObjects.
    ELSE 
      gcDisableObjects = '':U.

    initDisabledObjects(). 
        
    /* Choose Layout. */
    /* V8: RUN get-attribute IN p_hSMO ("Layout-Options":U). */
    ASSIGN c_Layout = DYNAMIC-FUNC("getLayoutOptions":U IN p_hSMO) NO-ERROR.
    ASSIGN c_Layout = (IF c_Layout <> ? THEN c_Layout ELSE "":U).
    
    IF lUseRepository THEN
     /* determine logical object name */    
     c_Logical_Object_Name = DYNAMIC-FUNC("getLogicalObjectName":U IN p_hSMO) NO-ERROR.
    ELSE 
     /* use object name */    
     c_Logical_Object_Name = DYNAMIC-FUNC("getObjectName":U IN p_hSMO) NO-ERROR.


    ASSIGN 
      c_Layout:LIST-ITEMS  = c_Layout
      ldummy               = c_Layout:ADD-FIRST ("{&no-layout}":U)
      c_Layout:SENSITIVE   = c_Layout:NUM-ITEMS > 1
      c_Layout:INNER-LINES = MIN(10,MAX(3,c_Layout:NUM-ITEMS + 1)).
    /* Disable the logical object name if this is a single instance, i.e. 
       modifying an object's properties on a container using the Container
       Builder or the Page Layout tool. 
       We just show objectname if not useRepos, but have to disable as it is 
       not currently an instance property */
      c_Logical_Object_Name:SENSITIVE = cSingleInstance <> 'YES':U AND lUseRepository.

  
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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createFrameBorder Attribute-Dlg 
FUNCTION createFrameBorder RETURNS LOGICAL
  ( phFrame AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
   DEFINE VARIABLE hLeft AS HANDLE     NO-UNDO.
   DEFINE VARIABLE hTop AS HANDLE     NO-UNDO.
   DEFINE VARIABLE hBottom AS HANDLE     NO-UNDO.
   DEFINE VARIABLE hRight AS HANDLE     NO-UNDO.
   
   ASSIGN    
     phframe:Y        = phframe:Y + 2
     phframe:X        = phframe:X + 2.

   CREATE RECTANGLE hleft
       ASSIGN   
       FGCOLOR = 7
          HEIGHT-P = phFrame:HEIGHT-P + 4
          WIDTH-P = 2
          X =  phFrame:X - 2
       Y  = phFrame:y - 2
        FRAME =FRAME {&FRAME-NAME}:HANDLE
        HIDDEN =FALSE.

   CREATE RECTANGLE htOP
         ASSIGN   
         FGCOLOR = 7
            width-P = phFrame:width-P + 4
            HEIGHT-P = 2
            X  = phFrame:X - 2
            Y  = phFrame:y - 2
          FRAME =FRAME {&FRAME-NAME}:HANDLE

          HIDDEN =FALSE.
     CREATE RECTANGLE hbOTTOM
         ASSIGN   
         FGCOLOR = 15
            width-P = phFrame:width-P + 3
            HEIGHT-P = 1
            X  = phFrame:X - 2
            Y  = phFrame:y + phFrame:HEIGHT-P + 1
          FRAME =FRAME {&FRAME-NAME}:HANDLE

          HIDDEN =FALSE.
     CREATE RECTANGLE hRight
       ASSIGN   
       FGCOLOR = 15
          HEIGHT-P = phFrame:HEIGHT-P + 3
          X  = phFrame:X + phFrame:width-P + 1
          Y  = phFrame:y - 2
          WIDTH-P = 1
        FRAME =FRAME {&FRAME-NAME}:HANDLE

        HIDDEN =FALSE.
  RETURN true.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createToggle Attribute-Dlg 
FUNCTION createToggle RETURNS HANDLE
  ( phFrame  AS HANDLE,
    pcLabel  AS CHAR,
    pdRow    AS DEC,
    pdCol    AS DEC) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hToggle AS HANDLE     NO-UNDO.
  
  CREATE TOGGLE-BOX hToggle
    ASSIGN 
      FRAME     = phFrame
      LABEL     = pcLabel 
      HIDDEN    = FALSE
      HEIGHT    = xdScrollToggleHeight
    TRIGGERS: 
      ON 'cursor-down':U     
         PERSISTENT RUN cursorMove IN THIS-PROCEDURE (hToggle,'DOWN':U).
      ON 'cursor-right':U    
         PERSISTENT RUN cursorMove IN THIS-PROCEDURE (hToggle,'DOWN':U).
      ON 'cursor-up':U     
         PERSISTENT RUN cursorMove IN THIS-PROCEDURE (hToggle,'UP':U).
      ON 'cursor-left':U     
         PERSISTENT RUN cursorMove IN THIS-PROCEDURE (hToggle,'UP':U).
    END.
    ASSIGN
      hToggle:COL       = pdCol
      hToggle:ROW       = pdRow  NO-ERROR.
    
    RETURN hToggle.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION disableObjectFrame Attribute-Dlg 
FUNCTION disableObjectFrame RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  ASSIGN FRAME frDisabledObjects:SENSITIVE = FALSE.
  FOR EACH ttEnabledObject:
     ttEnabledObject.toggleHandle:SENSITIVE = FALSE.
  END.

  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION enableObjectFrame Attribute-Dlg 
FUNCTION enableObjectFrame RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  ASSIGN FRAME frDisabledObjects:SENSITIVE = TRUE.
  FOR EACH ttEnabledObject:
     ttEnabledObject.toggleHandle:SENSITIVE = TRUE.
  END.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initDisabledObjects Attribute-Dlg 
FUNCTION initDisabledObjects RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF cDisabledObjects = "":U THEN
     enableObjectFrame().
  ELSE DO:
    toggleObjects(cDisabledObjects = '(all)':U).
    disableObjectFrame().
  END.
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initEnabledObjects Attribute-Dlg 
FUNCTION initEnabledObjects RETURNS LOGICAL
  ( pcEnabledObjects AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE i AS INTEGER    NO-UNDO.
  
  DO i = 1 TO NUM-ENTRIES(pcEnabledObjects):
    CREATE ttEnabledObject.
    ttEnabledObject.ObjectName = ENTRY(i,pcEnabledObjects).
    ttEnabledObject.ToggleHandle = createToggle
                                  (FRAME frDisabledObjects:HANDLE,
                                   ENTRY(i,pcEnabledObjects),
                                   1 + (xdScrollToggleHeight * (i - 1)),
                                   DEC(1.25)).  
    ttEnabledObject.ToggleHandle:CHECKED = CAN-DO(gcDisableObjects, ttEnabledObject.ObjectName).
  END.

  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION toggleObjects Attribute-Dlg 
FUNCTION toggleObjects RETURNS LOGICAL
  ( plON AS LOG  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  FOR EACH ttEnabledObject:
    ASSIGN ToggleHandle:CHECKED = plOn.
  END.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

