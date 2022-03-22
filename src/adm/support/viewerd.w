&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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

  File: viewerd.w 

  Description: Dialog for getting settable attributes for a SmartViewer.

  Input Parameters:
     p_hSMO -- Procedure Handle of calling SmartBrowser.

  Output Parameters:
      <none>

  History:
    wood 5/15/96 Add KEY-NAME support
                 Change Layout of Dialog
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

/* Define the value of the "don't use foriegn keys" option. */
&Scoped-define no-key [none - use external tables]

/* Define the value of the "No Layout Options" supplied. */
&Scoped-define no-layout [default]

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Attribute-Dlg

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c_Lock l_Enable l_View c_create 
&Scoped-Define DISPLAYED-OBJECTS c_Key c_Lock l_Enable c_Layout l_View ~
c_create 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE VARIABLE c_Key AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Key" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 32 BY 1 NO-UNDO.

DEFINE VARIABLE c_Layout AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Layout" 
     VIEW-AS COMBO-BOX 
     LIST-ITEMS "","" 
     SIZE 28 BY 1 NO-UNDO.

DEFINE VARIABLE c_create AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Yes", "Yes",
"No", "No",
"Default Behavior", "?"
     SIZE 39 BY .91 NO-UNDO.

DEFINE VARIABLE c_Lock AS CHARACTER INITIAL "NO-LOCK" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "&No-Lock", "NO-LOCK":U,
"&Share-Lock", "SHARE-LOCK":U,
"E&xclusive-Lock", "EXCLUSIVE-LOCK":U
     SIZE 20 BY 2.67
     BGCOLOR 8  NO-UNDO.

DEFINE VARIABLE l_Enable AS LOGICAL INITIAL no 
     LABEL "Dispatch '&Enable'" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY 1.1 NO-UNDO.

DEFINE VARIABLE l_View AS LOGICAL INITIAL no 
     LABEL "Dispatch '&View'" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .86 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Attribute-Dlg
     c_Key AT ROW 2.1 COL 3.2
     c_Lock AT ROW 2.1 COL 42 NO-LABEL
     l_Enable AT ROW 5.86 COL 4
     c_Layout AT ROW 5.86 COL 25.6
     l_View AT ROW 6.91 COL 4
     c_create AT ROW 8.81 COL 4 NO-LABEL
     " Find Record Using Key" VIEW-AS TEXT
          SIZE 39 BY .62 AT ROW 1.29 COL 2
          BGCOLOR 1 FGCOLOR 15 
     " Record Retrieval" VIEW-AS TEXT
          SIZE 20 BY .62 AT ROW 1.29 COL 42
          BGCOLOR 1 FGCOLOR 15 
     "  Behavior During 'Initialize'" VIEW-AS TEXT
          SIZE 60 BY .62 AT ROW 5.05 COL 2
          BGCOLOR 1 FGCOLOR 15 
     "  Create new record immediately on 'Add'?" VIEW-AS TEXT
          SIZE 60 BY .62 AT ROW 8 COL 2
          BGCOLOR 1 FGCOLOR 15 
     SPACE(1.56) SKIP(1.37)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "SmartViewer Attributes":L.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Attribute-Dlg
   L-To-R                                                               */
ASSIGN 
       FRAME Attribute-Dlg:SCROLLABLE       = FALSE
       FRAME Attribute-Dlg:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX c_Key IN FRAME Attribute-Dlg
   NO-ENABLE ALIGN-L                                                    */
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
ON GO OF FRAME Attribute-Dlg /* SmartViewer Attributes */
DO:     
  /* Reassign the attribute alues back in the SmartObject. */
  ASSIGN l_Enable l_View c_Create c_Lock 
         c_Layout = c_Layout:SCREEN-VALUE WHEN c_Layout:SENSITIVE
         c_Key    = c_Key:SCREEN-VALUE    WHEN c_Key:SENSITIVE
         .
         
  attr-list = "Disable-on-Init = ":U + STRING(NOT l_Enable) 
            + ",Hide-on-Init =":U + STRING(NOT l_View)
            + ",Initial-Lock =":U + c_Lock
            + ",Create-On-Add =":U + IF c_Create = ? THEN "?":U ELSE c_Create.
            .
            
  /* Check the name of the key and layout. Don't bother assigning them if
     they weren't sensitive. */
  IF c_Key:SENSITIVE 
  THEN ASSIGN c_Key = "" WHEN c_Key eq "{&no-key}":U
              attr-list = attr-list + ",Key-Name =":U + c_Key.
              
  RUN set-attribute-list IN p_hSMO (INPUT attr-list).
  
  /* Only set the layout if it has changed.  Remember that LAYOUT is an
     attribute whose changes must be explicitly applied. */
  IF c_Layout:SENSITIVE AND c_Layout ne orig-layout THEN DO:
    IF c_Layout eq "{&no-layout}":U THEN c_Layout = "":U.
    RUN set-attribute-list IN p_hSMO (INPUT "Layout = ":U + c_Layout).
    RUN dispatch IN p_hSMO ('apply-layout':U).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Attribute-Dlg Attribute-Dlg
ON WINDOW-CLOSE OF FRAME Attribute-Dlg /* SmartViewer Attributes */
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
{ src/adm/support/admhlp.i }    

/* Attach the standard OK/Cancel/Help button bar. */
{ adecomm/okbar.i  &TOOL = "AB"
                   &CONTEXT = {&SmartViewer_Attributes_Dlg_Box} }

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Attribute-Dlg _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Attribute-Dlg _DEFAULT-ENABLE
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
  DISPLAY c_Key c_Lock l_Enable c_Layout l_View c_create 
      WITH FRAME Attribute-Dlg.
  ENABLE c_Lock l_Enable l_View c_create 
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
    RUN get-attribute IN p_hSMO ("Disable-on-Init":U).
    l_Enable = IF RETURN-VALUE eq "YES":U THEN no ELSE yes.
    RUN get-attribute IN p_hSMO ("Hide-on-Init":U).
    l_View = (RETURN-VALUE ne "YES":U).
    RUN get-attribute IN p_hSMO ("Initial-Lock":U).
    c_Lock = IF RETURN-VALUE eq ? THEN "NO-LOCK":U ELSE RETURN-VALUE.
    RUN get-attribute IN p_hSMO ("Create-On-Add":U).
    c_Create = RETURN-VALUE.

    /* Choose Layout. */
    RUN get-attribute IN p_hSMO ("Layout-Options":U).
    ASSIGN 
      c_Layout:LIST-ITEMS  = IF RETURN-VALUE ne ? THEN RETURN-VALUE ELSE "" 
      ldummy               = c_Layout:ADD-FIRST ("{&no-layout}":U)
      c_Layout:SENSITIVE   = c_Layout:NUM-ITEMS > 1
      c_Layout:INNER-LINES = MIN(10,MAX(3,c_Layout:NUM-ITEMS + 1)).
    RUN get-attribute IN p_hSMO ("Layout":U).
    ASSIGN c_Layout    = IF RETURN-VALUE eq ? OR RETURN-VALUE eq "":U OR
                            RETURN-VALUE eq "?":U /* Compatibility with ADM1.0 */
                         THEN "{&no-layout}":U 
                         ELSE RETURN-VALUE
           orig-layout = c_layout.

    /* Check accepted keys (and the key to use). */
    RUN get-attribute IN p_hSMO ("Keys-Accepted":U).
    ASSIGN 
      c_key:LIST-ITEMS  = IF RETURN-VALUE ne ? THEN RETURN-VALUE ELSE "" 
      ldummy            = c_key:ADD-FIRST ("{&no-key}":U)
      c_key:SENSITIVE   = c_key:NUM-ITEMS > 1
      c_key:INNER-LINES = MIN(10,MAX(3,c_key:NUM-ITEMS + 1)).
    RUN get-attribute IN p_hSMO ("Key-Name":U).
    c_key = IF RETURN-VALUE eq ? OR RETURN-VALUE eq "":U THEN "{&no-key}":U 
            ELSE RETURN-VALUE. 
  END. /* DO WITH FRAME... */
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


