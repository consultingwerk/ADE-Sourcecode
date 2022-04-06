&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
/* Procedure Description
"SmartTreeView

This is the SmartTreeView component."
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sObject 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: treeview.w

  Description: 

  Author:
  Created: 04/05/2001
  Modified: 03/25/2002      Mark Davies (MIP)
            Moved getTreeDataTable from treeview.p to here to avoid the 
            same table being used for all running TreeViews.
            
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

 

&Scoped-Define HORIZONTAL 0
&Scoped-Define VERTICAL 1

&Scoped-Define LOGPIXELSX 88    /* API CONSTANTS */
&Scoped-Define LOGPIXELSY 90

/* not needed as the destroyObject override does call deleteProperties */ 
&SCOPED-DEFINE exclude-adm-clone-props

DEFINE VARIABLE ghTreeData AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartTreeView
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS TVController-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME frTreeView

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTreeDataTable sObject 
FUNCTION getTreeDataTable RETURNS HANDLE
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD pixelsToTwips sObject 
FUNCTION pixelsToTwips RETURNS INTEGER
  ( INPUT piPixels AS INTEGER,
    INPUT piDirection AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for OCX Containers                            */
DEFINE VARIABLE hImageList AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chhImageList AS COMPONENT-HANDLE NO-UNDO.
DEFINE VARIABLE hTreeView AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chhTreeView AS COMPONENT-HANDLE NO-UNDO.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frTreeView
     SPACE(23.01) SKIP(4.53)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartTreeView
   Allow: Basic
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW sObject ASSIGN
         HEIGHT             = 5.86
         WIDTH              = 27.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB sObject 
/* ************************* Included-Libraries *********************** */

{src/adm2/treeview.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW sObject
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frTreeView
   FRAME-NAME Size-to-Fit                                               */
ASSIGN 
       FRAME frTreeView:SCROLLABLE       = FALSE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frTreeView
/* Query rebuild information for FRAME frTreeView
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frTreeView */
&ANALYZE-RESUME

 


/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

CREATE CONTROL-FRAME hTreeView ASSIGN
       FRAME           = FRAME frTreeView:HANDLE
       ROW             = 1
       COLUMN          = 1
       HEIGHT          = 4.52
       WIDTH           = 23
       HELP            = "Choose an item to work with."
       HIDDEN          = no
       SENSITIVE       = yes.

CREATE CONTROL-FRAME hImageList ASSIGN
       FRAME           = FRAME frTreeView:HANDLE
       ROW             = 1
       COLUMN          = 1
       HEIGHT          = 1.91
       WIDTH           = 8
       HIDDEN          = yes
       SENSITIVE       = yes.

PROCEDURE adm-create-controls:
      hTreeView:NAME = "hTreeView":U .
/* hTreeView OCXINFO:CREATE-CONTROL from: {C74190B6-8589-11D1-B16A-00C0F0283628} type: TreeView */
      hImageList:NAME = "hImageList":U .
/* hImageList OCXINFO:CREATE-CONTROL from: {2C247F23-8591-11D1-B16A-00C0F0283628} type: ImageList */
      hImageList:MOVE-AFTER(hTreeView).

END PROCEDURE.

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME hTreeView
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL hTreeView sObject
ON ENTRY OF hTreeView /* TreeView */
DO:
  PUBLISH "tvEvent":U ("ENTRY":U,"").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL hTreeView sObject
ON LEAVE OF hTreeView /* TreeView */
DO:
  PUBLISH "tvEvent":U ("LEAVE":U,"").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL hTreeView sObject OCX.AfterLabelEdit
PROCEDURE hTreeView.TreeView.AfterLabelEdit .
/*------------------------------------------------------------------------------
  Purpose:     Fired after editing the label
  Parameters:  piCancel     Set to any non zero to cancel label edit 
               pcNewString  New label entered into node
------------------------------------------------------------------------------*/
DEFINE INPUT-OUTPUT PARAMETER piCancel    AS INTEGER NO-UNDO.
DEFINE INPUT        PARAMETER pcNewString AS CHARACTER NO-UNDO.

PUBLISH "tvLabelEdit":U (INPUT  pcNewString,
                         OUTPUT piCancel ).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL hTreeView sObject OCX.Collapse
PROCEDURE hTreeView.TreeView.Collapse .
/*------------------------------------------------------------------------------
  Purpose:     Fired when node is collapsed
  Parameters:  phNode  Com-handle of node
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phNode AS COM-HANDLE NO-UNDO.

PUBLISH "tvNodeEvent":U (INPUT "COLLAPSE":U,
                         phNode:KEY).

RELEASE OBJECT phNode NO-ERROR.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL hTreeView sObject OCX.Expand
PROCEDURE hTreeView.TreeView.Expand .
/*------------------------------------------------------------------------------
  Purpose:     Fired when node is expanded
  Parameters:  phNode  Expanded node 
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phNode AS COM-HANDLE NO-UNDO.

PUBLISH "tvNodeEvent":U (INPUT "EXPAND":U,
                         INPUT phNode:KEY).

RELEASE OBJECT phNode NO-ERROR.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL hTreeView sObject OCX.KeyUp
PROCEDURE hTreeView.TreeView.KeyUp .
/*------------------------------------------------------------------------------
  Purpose:     Fired when the key is depressed and then released
               Publishes the TreeviewEvent event.
  Parameters:  piKeyCode   KeyCode representing key pressed
               piShift     0 - Shift key is not depressed
                           1 - Shift key is depressed
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT-OUTPUT PARAMETER piKeyCode AS INTEGER NO-UNDO.
DEFINE INPUT        PARAMETER piShift   AS INTEGER NO-UNDO.


PUBLISH "tvEvent":U (INPUT "KeyUp":U,
                     INPUT STRING(piKeyCode) + "," + STRING(piShift) ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL hTreeView sObject OCX.MouseDown
PROCEDURE hTreeView.TreeView.MouseDown .
/*------------------------------------------------------------------------------
  Purpose:     A bug with the FullRowSelect requires the capturing on this 
               event when the blank area next to the node is selected
  Parameters:  Required for OCX.
    Button
    Shift
    x
    y
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p-Button AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER p-Shift  AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER p-x      AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER p-y      AS INTEGER NO-UNDO.

DEFINE VARIABLE iX              AS INTEGER    NO-UNDO. 
DEFINE VARIABLE iY              AS INTEGER    NO-UNDO. 
DEFINE VARIABLE chItem          AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE lFullRowSelect  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE iIndent         AS INTEGER    NO-UNDO.
DEFINE VARIABLE iLoop           AS INTEGER    NO-UNDO.
DEFINE VARIABLE iMax            AS INTEGER    NO-UNDO.

ASSIGN lFullRowSelect = DYNAMIC-FUNC("getFullRowSelect")
       iIndent        = DYNAMIC-FUNC("getIndentation":U)
       iMax           = FRAME frtreeview:WIDTH-PIXELS
       iIndent        = IF iindent = 0 THEN 1 ELSE iIndent.

/* If the FullRowSelect property is set, the user may have clicked on the
     blank area beside the node. This causes the hitTest method to fail, but the
     node is selected. therefore, we must find the node by looping trhough the
     x-coordinates by the increment value */

IF lFullRowSelect THEN 
DO:
  ASSIGN iX = DYNAMIC-FUNCTION("PixelsToTwips":U, p-x, 0)
         iY = DYNAMIC-FUNCTION("PixelsToTwips":U, ABS(p-y), 1)
         NO-ERROR.
  chItem =  chhTreeView:TreeView:HitTest(ix, iy) NO-ERROR.
  IF NOT VALID-HANDLE(chItem) THEN
  Item-Loop:
  DO WHILE iLoop < iMax:
    ASSIGN iX = DYNAMIC-FUNCTION("PixelsToTwips":U, iLoop, 0)
           iY = DYNAMIC-FUNCTION("PixelsToTwips":U, ABS(p-y), 1)
          NO-ERROR.
    chItem =  chhTreeView:TreeView:HitTest(ix, iy) NO-ERROR.
    IF VALID-HANDLE(chItem) THEN
    DO:
      PUBLISH "tvNodeEvent":U (INPUT "CLICK":U, 
                              INPUT chItem:KEY ).
      LEAVE Item-Loop.
    END.
    iLoop = iLoop + iIndent.
  END.
  
  RELEASE OBJECT chItem NO-ERROR.       
  chitem = ?.
END. /* END FullRowSelect */

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL hTreeView sObject OCX.MouseUp
PROCEDURE hTreeView.TreeView.MouseUp .
/*------------------------------------------------------------------------------
  Purpose:     Fired when mouse up event occurs. Used to capture the clicking of
               the right mouse button.
  Parameters:  piButton  Button clicked (0 - left, 1 - right)
               piShift   Shift button   (0 - no shift, 1 - shift)
               pdx       X coordinate (pixels)
               pdy       Y coordinate (pixels)
  Notes:       Used for sending events when right mouse click is done.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER piButton AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER piShift  AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER pdx      AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER pdy      AS INTEGER NO-UNDO.

DEFINE VARIABLE iX              AS INTEGER    NO-UNDO. 
DEFINE VARIABLE iY              AS INTEGER    NO-UNDO. 
DEFINE VARIABLE cItem           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE chItem          AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE lFullRowSelect  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE iIndent         AS INTEGER    NO-UNDO.
DEFINE VARIABLE iLoop           AS INTEGER    NO-UNDO.
DEFINE VARIABLE iMax            AS INTEGER    NO-UNDO.

ASSIGN lFullRowSelect = DYNAMIC-FUNC("getFullRowSelect")
       iIndent        = DYNAMIC-FUNC("getIndentation":U)
       iMax           = FRAME frtreeview:WIDTH-PIXELS 
       iIndent        = IF iIndent = 0 THEN 1 ELSE iIndent.

IF piButton = 2 THEN DO:   
  ASSIGN iX = DYNAMIC-FUNCTION("PixelsToTwips":U, pdx, 0)
         iY = DYNAMIC-FUNCTION("PixelsToTwips":U, ABS(pdy), 1)
         NO-ERROR.

  chItem =  chhTreeView:TreeView:HitTest(ix, iy) NO-ERROR.
  IF VALID-HANDLE(chItem) THEN
     PUBLISH "tvNodeEvent":U (INPUT "RIGHTCLICK":U, 
                             INPUT chItem:KEY ).
  /* If the FullRowSelect property is set, the user may have clicked on the
     blank area beside the node. This causes the hitTest method to fail, but the
     node is selected. Therefore, we must find the node by looping trhough the
     x-coordinates by the increment value */
  ELSE IF lFullRowSelect THEN
  Item-Loop:
  DO WHILE iLoop < iMax:
    ASSIGN iX = DYNAMIC-FUNCTION("PixelsToTwips":U, iLoop, 0)
           iY = DYNAMIC-FUNCTION("PixelsToTwips":U, ABS(pdy), 1)
          NO-ERROR.
    chItem =  chhTreeView:TreeView:HitTest(ix, iy) NO-ERROR.
    IF VALID-HANDLE(chItem) THEN
    DO:
      PUBLISH "tvNodeEvent":U (INPUT "RIGHTCLICK":U, 
                              INPUT chItem:KEY ).
      chhTreeView:TreeView:SelectedItem = chitem.
      LEAVE Item-Loop.
    END.
    iLoop = iLoop + iIndent.
  END.
  ELSE
      PUBLISH "tvNodeEvent":U (INPUT "RIGHTCLICK":U, 
                              INPUT ? ).
  DEFINE VARIABLE iReturn AS INTEGER    NO-UNDO.
  RUN SendMessageA(SELF:HWND, 517, 0, 0,OUTPUT ireturn).
  
  
  RELEASE OBJECT chItem NO-ERROR.
  chitem = ?.
  
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL hTreeView sObject OCX.NodeCheck
PROCEDURE hTreeView.TreeView.NodeCheck .
/*------------------------------------------------------------------------------
  Purpose:     Fired when checkboxes are used and a node is checked/unchecked
  Parameters:  phNode  
  Notes:       Treeviewevent procedure is sent either CHECK-ON if node is checked
               or CHECK-OFF if node is unchecked.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phNode AS COM-HANDLE NO-UNDO.

PUBLISH "tvNodeEvent":U (INPUT "CHECK-":U + IF phNode:CHECKED THEN "ON":U ELSE "OFF":U,
                         INPUT phNode:KEY).

RELEASE OBJECT phNode NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL hTreeView sObject OCX.NodeClick
PROCEDURE hTreeView.TreeView.NodeClick .
/*------------------------------------------------------------------------------
 Fires when the user clicks on the node with a mouse or uses the keyboard to
 change focus to a particular node.     
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phNode AS COM-HANDLE NO-UNDO.

PUBLISH 'tvNodeSelected':U (phNode:KEY).
PUBLISH "tvNodeEvent":U (INPUT "CLICK":U, 
                         INPUT phNode:KEY).

RELEASE OBJECT phNode NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL hTreeView sObject OCX.OLEDragDrop
PROCEDURE hTreeView.TreeView.OLEDragDrop .
/*------------------------------------------------------------------------------
  Purpose:     Fired when node is dropped during drag/drop operation
  Parameters:  phData    Data Object
               piEffect  (0 - drop target cannot accept the data)
                         (1 - Drop results in a copy of data from the source to the target)                         
                         (2 - Drop results in data being moved from drag source to drop source. 
                            The drag source should remove the data from itself after the move.)
               piButton  The state of a mouse button when it is depressed. 
                         (0 - Left button, 1 - right button, 2 - middle button)
               piShift   The state of the shift, ctrl, and alt keys when they are depressed             
               pdx       X coordinate (pixels)
               pdy       Y coordinate (pixels)
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT-OUTPUT PARAMETER phData   AS COM-HANDLE  NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER piEffect AS INTEGER     NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER piButton AS INTEGER     NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER piShift  AS INTEGER     NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pdx      AS DECIMAL     NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pdy      AS DECIMAL     NO-UNDO.


DEFINE VARIABLE istate  AS INTEGER    NO-UNDO. 
DEFINE VARIABLE cDrop   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iX      AS INTEGER    NO-UNDO. 
DEFINE VARIABLE iY      AS INTEGER    NO-UNDO. 
DEFINE VARIABLE chItem  AS COM-HANDLE NO-UNDO.

ASSIGN iX = DYNAMIC-FUNCTION("PixelsToTwips":U, INT(pdx), 0)
       iY = DYNAMIC-FUNCTION("PixelsToTwips":U, INT(ABS(pdy)), 1)
       NO-ERROR.

chItem =  chhTreeView:TreeView:HitTest(ix, iy) NO-ERROR.
IF NOT VALID-HANDLE(chItem)  THEN
  RETURN NO-APPLY.

PUBLISH "tvOLEDrag":U (INPUT "DROP",
                       INPUT chitem:KEY,
                       INPUT piShift,
                       INPUT-OUTPUT piEffect,
                       INPUT-OUTPUT istate).
                          
RELEASE OBJECT chitem NO-ERROR.
chitem = ?.                          

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL hTreeView sObject OCX.OLEDragOver
PROCEDURE hTreeView.TreeView.OLEDragOver .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  phData    Data Object
               piEffect  (0 - drop target cannot accept the data)
                         (1 - Drop results in a copy of data from the source to the target)                         
                         (2 - Drop results in data being moved from drag source to drop source. 
                            The drag source should remove the data from itself after the move.)
               piButton  The state of a mouse button when it is depressed. 
                         (0 - Left button, 1 - right button, 2 - middle button)
               piShift   The state of the shift, ctrl, and alt keys when they are depressed             
               pdx       X coordinate (pixels)
               pdy       Y coordinate (pixels)
               piState   Transition state of the control being dragged in relation to a target
                         (0 - Source component is being dragged within the range of a target.) 
                         (1 - Source component is being dragged out of the range of a target) 
                         (2 - Source component has moved from one position in the target to another) 
------------------------------------------------------------------------------*/
DEFINE INPUT-OUTPUT PARAMETER phData   AS COM-HANDLE NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER piEffect AS INTEGER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER piButton AS INTEGER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER piShift  AS INTEGER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pdx      AS DECIMAL    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pdy      AS DECIMAL    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER piState  AS INTEGER    NO-UNDO.

DEFINE VARIABLE cItemKey    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE chItem      AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE iX          AS INTEGER    NO-UNDO. 
DEFINE VARIABLE iY          AS INTEGER    NO-UNDO. 

ASSIGN iX = DYNAMIC-FUNCTION("PixelsToTwips":U, INT(pdx), 0)
       iY = DYNAMIC-FUNCTION("PixelsToTwips":U, INT(ABS(pdy)), 1)
       NO-ERROR.

chItem =  chhTreeView:TreeView:HitTest(ix, iy) NO-ERROR.
IF NOT VALID-HANDLE(chItem) THEN
  RETURN NO-APPLY.
  
PUBLISH "tvOLEDrag":U (INPUT "OVER":U,
                       INPUT chitem:KEY,
                       INPUT piShift,
                       INPUT-OUTPUT piEffect,
                       INPUT-OUTPUT piState).
                          
RELEASE OBJECT chItem NO-ERROR.                          
chItem = ?.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL hTreeView sObject OCX.OLEStartDrag
PROCEDURE hTreeView.TreeView.OLEStartDrag .
/*------------------------------------------------------------------------------
  Purpose:     Fired When the drag/drop begins
  Parameters:  phData    Data Object
               p-AllowedEffect  
                    (0 - drop target cannot accept the data)
                    (1 - Drop results in a copy of data from the source to the target)                         
                    (2 - Drop results in data being moved from drag source to drop source. 
                         The drag source should remove the data from itself after the move.
------------------------------------------------------------------------------*/

DEFINE INPUT-OUTPUT PARAMETER phData           AS COM-HANDLE NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER piAllowedEffects AS INTEGER    NO-UNDO.

DEFINE VARIABLE istate      AS INTEGER    NO-UNDO. 
DEFINE VARIABLE chItem      AS COM-HANDLE NO-UNDO.

chItem = chhTreeView:TreeView:SELECTEDItem NO-ERROR.
PUBLISH "tvOLEDrag":U (INPUT "START":U,
                       INPUT chItem:KEY,
                       ?,
                       INPUT-OUTPUT piAllowedEffects,
                       INPUT-OUTPUT istate).

RELEASE OBJECT chItem NO-ERROR.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK sObject 


/* ***************************  Main Block  *************************** */

/* If testing in the UIB, initialize the SmartObject. */  
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN    
  RUN initializeObject.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE control_load sObject  _CONTROL-LOAD
PROCEDURE control_load :
/*------------------------------------------------------------------------------
  Purpose:     Load the OCXs    
  Parameters:  <none>
  Notes:       Here we load, initialize and make visible the 
               OCXs in the interface.                        
------------------------------------------------------------------------------*/

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN
DEFINE VARIABLE UIB_S    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE OCXFile  AS CHARACTER  NO-UNDO.

OCXFile = SEARCH( "dyntreeview.wrx":U ).
IF OCXFile = ? THEN
  OCXFile = SEARCH(SUBSTRING(THIS-PROCEDURE:FILE-NAME, 1,
                     R-INDEX(THIS-PROCEDURE:FILE-NAME, ".":U), "CHARACTER":U) + "wrx":U).

IF OCXFile <> ? THEN
DO:
  ASSIGN
    chhImageList = hImageList:COM-HANDLE
    UIB_S = chhImageList:LoadControls( OCXFile, "hImageList":U)
    chhTreeView = hTreeView:COM-HANDLE
    UIB_S = chhTreeView:LoadControls( OCXFile, "hTreeView":U)
  .
  RUN initialize-controls IN THIS-PROCEDURE NO-ERROR.
END.
ELSE MESSAGE "dyntreeview.wrx":U SKIP(1)
             "The binary control file could not be found. The controls cannot be loaded."
             VIEW-AS ALERT-BOX TITLE "Controls Not Loaded".

&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject sObject 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
   IF VALID-HANDLE(chhTreeview) THEN
     chhTreeView:TreeView:Nodes:CLEAR().
   IF VALID-HANDLE(chhImageList) THEN
     chhImageList:ImageList:ListImages:CLEAR().
  RUN SUPER.

  {fn deleteProperties}.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI sObject  _DEFAULT-DISABLE
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
  HIDE FRAME frTreeView.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTreeDataTable sObject 
FUNCTION getTreeDataTable RETURNS HANDLE
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Creates a dynamic temp table, if it doesn't already exist
    Notes:  
------------------------------------------------------------------------------*/
IF VALID-HANDLE(ghTreeData) THEN
   RETURN ghTreeData.

CREATE TEMP-TABLE ghTreeData.
ghTreeData:ADD-NEW-FIELD('node_key':U,        'CHARACTER':U).
ghTreeData:ADD-NEW-FIELD('parent_node_key':U, 'CHARACTER':U).
ghTreeData:ADD-NEW-FIELD('node_obj':U,        'DECIMAL':U).
ghTreeData:ADD-NEW-FIELD('node_label':U,      'CHARACTER':U).
ghTreeData:ADD-NEW-FIELD('private_data':U,    'CHARACTER':U).
ghTreeData:ADD-NEW-FIELD('record_ref':U,      'CHARACTER':U).
ghTreeData:ADD-NEW-FIELD('key_fields':U,      'CHARACTER':U).
ghTreeData:ADD-NEW-FIELD('record_rowid':U,    'ROWID':U).
ghTreeData:ADD-NEW-FIELD('node_checked':U,    'LOGICAL':U, 0, ?, FALSE).
ghTreeData:ADD-NEW-FIELD('node_expanded':U,   'LOGICAL':U, 0, ?, FALSE).
ghTreeData:ADD-NEW-FIELD('image':U,           'CHARACTER':U).
ghTreeData:ADD-NEW-FIELD('selected_image':U,  'CHARACTER':U).
ghTreeData:ADD-NEW-FIELD('node_insert':U,     'INTEGER':U).
ghTreeData:ADD-NEW-FIELD('node_sort':U,       'LOGICAL':U,0,?,FALSE).
ghTreeData:ADD-NEW-FIELD('sdo_handle':U,      'HANDLE':U).
ghTreeData:ADD-NEW-FIELD('foreign_fields':U,  'CHARACTER':U).
ghTreeData:ADD-NEW-FIELD('foreign_values':U,  'CHARACTER':U).
ghTreeData:ADD-NEW-FIELD('node_type':U,       'CHARACTER':U).
ghTreeData:ADD-NEW-FIELD('rowident':U,       'CHARACTER':U).

/* Add Indices */
/* Node Handle - Primary - Unique */
ghTreeData:ADD-NEW-INDEX('puNodeKey':U, TRUE, TRUE).
ghTreeData:ADD-INDEX-FIELD('puNodeKey':U, 'node_key':U).

/* Parent Node Handle */
ghTreeData:ADD-NEW-INDEX('ParentNodeKey':U, FALSE, FALSE).
ghTreeData:ADD-INDEX-FIELD('ParentNodeKey':U, 'node_key':U).
ghTreeData:ADD-INDEX-FIELD('ParentNodeKey':U, 'parent_node_key':U).

/* Reference To Record's Data Loaded - Unique Identifier of the record (obj) */
ghTreeData:ADD-NEW-INDEX('record_ref':U, FALSE, FALSE).
ghTreeData:ADD-INDEX-FIELD('record_ref':U, 'record_ref':U).

/* The RowId of the record's data loaded into this node */
ghTreeData:ADD-NEW-INDEX('record_rowid':U, FALSE, FALSE).
ghTreeData:ADD-INDEX-FIELD('record_rowid':U, 'record_rowid':U).

ghTreeData:temp-table-prepare("tTreeData":U).

RETURN ghTreeData.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION pixelsToTwips sObject 
FUNCTION pixelsToTwips RETURNS INTEGER
  ( INPUT piPixels AS INTEGER,
    INPUT piDirection AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose: Convert Pixels to TWIPS
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iDC            AS INTEGER.
  DEFINE VARIABLE iPixelsPerInch AS INTEGER.
  DEFINE VARIABLE iTwips         AS INTEGER.
  
  &Scoped-Define TWIPS_PER_INCH 1440
  
  run GetDC(0, output iDC).
  
  if piDirection = {&HORIZONTAL}
     then run GetDeviceCaps(iDC, {&LOGPIXELSX}, output iPixelsPerInch).
     else run GetDeviceCaps(iDC, {&LOGPIXELSY}, output iPixelsPerInch).
     
  run ReleaseDC(0, iDC, output iDC).
  
  iTwips = (piPixels / iPixelsPerInch) * {&TWIPS_PER_INCH}.
     
  RETURN iTwips.   /* Function return value. */


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

