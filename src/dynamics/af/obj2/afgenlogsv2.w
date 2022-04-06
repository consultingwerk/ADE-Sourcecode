&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" sObject _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" sObject _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sObject 
/*---------------------------------------------------------------------------------
  File: afgenlogsv.w

  Description:  Object Generator Logging Viewer

  Purpose:      Object Generator Logging Viewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/03/2002  Author:     Peter Judge

  Update Notes: Created from Template rysttsimpv.w

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afgenlogsv2.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*--------------------------------------------------------------------------
  GET-FILE Definitions.
--------------------------------------------------------------------------*/
{ adeedit/dsysgetf.i }
/*--------------------------------------------------------------------------
  GET-FILE Procedures.
--------------------------------------------------------------------------*/
{ adeedit/psysgetf.i }

/*  object identifying preprocessor */
&glob   astra2-staticSmartObject yes

{ src/adm2/globals.i }
{ af/app/afgenretin.i }

DEFINE VARIABLE ghContainerSource                   AS HANDLE                   NO-UNDO.

&SCOPED-DEFINE HORIZONTAL 0
&SCOPED-DEFINE VERTICAL 1

&SCOPED-DEFINE LOGPIXELSX 88    /* API CONSTANTS */
&SCOPED-DEFINE LOGPIXELSY 90

DEFINE TEMP-TABLE ttSection     NO-UNDO
    FIELD tSectionName      AS CHARACTER
    FIELD tSectionOrder     AS INTEGER
    INDEX idxSectionOrder   AS PRIMARY UNIQUE
        tSectionOrder
    .

DEFINE TEMP-TABLE ttAction  NO-UNDO
    FIELD tSectionOrder     AS INTEGER
    FIELD tActionName       AS CHARACTER
    FIELD tActionOrder      AS INTEGER
    INDEX idxSection
        tSectionOrder
    INDEX idxActionOrder    AS PRIMARY UNIQUE
        tActionOrder
    .

DEFINE TEMP-TABLE ttResult      NO-UNDO
    FIELD tActionOrder      AS INTEGER
    FIELD tResultName       AS CHARACTER
    FIELD tResultOrder      AS INTEGER
    FIELD tResultText       AS CHARACTER
    FIELD tResultType       AS CHARACTER    /* ERROR or INFORMATION */
    INDEX idxAction
        tActionOrder
    INDEX idxResultOrder    AS PRIMARY UNIQUE
        tResultOrder
    .

DEFINE STREAM sOutput.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartTreeView
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frTreeview

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS edMessageView buExport fiExportFileName ~
buExportFileName 
&Scoped-Define DISPLAYED-OBJECTS edMessageView fiExportFileName 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD loadImage sObject 
FUNCTION loadImage RETURNS INTEGER
  ( INPUT pcImageFile AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD PixelsToTwips sObject 
FUNCTION PixelsToTwips RETURNS INTEGER
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

/* Definitions of the field level widgets                               */
DEFINE BUTTON buExport 
     LABEL "Export Log" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buExportFileName 
     IMAGE-UP FILE "ry/img/view.gif":U
     LABEL "..." 
     SIZE 4.4 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE edMessageView AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 38 BY 11.33 NO-UNDO.

DEFINE VARIABLE fiExportFileName AS CHARACTER FORMAT "X(70)":U 
     LABEL "Export filename" 
     VIEW-AS FILL-IN 
     SIZE 70 BY 1 TOOLTIP "The export file name." NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frTreeview
     edMessageView AT ROW 1.29 COL 35 NO-LABEL
     buExport AT ROW 12.81 COL 90.2
     fiExportFileName AT ROW 12.95 COL 17.4 COLON-ALIGNED
     buExportFileName AT ROW 13 COL 85.4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartTreeView
   Compile into: af/obj2
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
         HEIGHT             = 13
         WIDTH              = 104.2.
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
/* SETTINGS FOR FRAME frTreeview
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME frTreeview:SCROLLABLE       = FALSE
       FRAME frTreeview:HIDDEN           = TRUE.

ASSIGN 
       edMessageView:RETURN-INSERTED IN FRAME frTreeview  = TRUE
       edMessageView:READ-ONLY IN FRAME frTreeview        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frTreeview
/* Query rebuild information for FRAME frTreeview
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frTreeview */
&ANALYZE-RESUME

 


/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

CREATE CONTROL-FRAME hImageList ASSIGN
       FRAME           = FRAME frTreeview:HANDLE
       ROW             = 1
       COLUMN          = 1
       HEIGHT          = 1.91
       WIDTH           = 8
       HIDDEN          = yes
       SENSITIVE       = yes.

CREATE CONTROL-FRAME hTreeView ASSIGN
       FRAME           = FRAME frTreeview:HANDLE
       ROW             = 1
       COLUMN          = 1.4
       HEIGHT          = 8.76
       WIDTH           = 30.8
       HELP            = "Choose an item to work with."
       HIDDEN          = no
       SENSITIVE       = yes.

PROCEDURE adm-create-controls:
      hImageList:NAME = "hImageList":U .
/* hImageList OCXINFO:CREATE-CONTROL from: {2C247F23-8591-11D1-B16A-00C0F0283628} type: ImageList */
      hTreeView:NAME = "hTreeView":U .
/* hTreeView OCXINFO:CREATE-CONTROL from: {C74190B6-8589-11D1-B16A-00C0F0283628} type: TreeView */
      hImageList:MOVE-BEFORE(edMessageView:HANDLE IN FRAME frTreeview).
      hTreeView:MOVE-AFTER(hImageList).

END PROCEDURE.

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME buExport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buExport sObject
ON CHOOSE OF buExport IN FRAME frTreeview /* Export Log */
DO:

  RUN exportLogToFile.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buExportFileName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buExportFileName sObject
ON CHOOSE OF buExportFileName IN FRAME frTreeview /* ... */
DO:

  DEFINE VARIABLE cFindFileName       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lReturnStatus       AS LOGICAL    NO-UNDO INIT FALSE.

  DO WITH FRAME {&FRAME-NAME}:

    ASSIGN
      fiExportFileName.

    ASSIGN
      cFindFileName = fiExportFileName.

    RUN SysGetFile
       (INPUT "Files" /* p_Title */
       ,INPUT NO      /* p_Save_As */
       ,INPUT 1       /* p_Initial_Filter */
       ,INPUT-OUTPUT cFindFileName
       ,OUTPUT lReturnStatus
       ).

    IF lReturnStatus
    THEN
      ASSIGN
        fiExportFileName = cFindFileName
        .

    ASSIGN
      fiExportFileName:SCREEN-VALUE = fiExportFileName
      .

  END. /* FRAME {&FRAME-NAME} */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiExportFileName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiExportFileName sObject
ON LEAVE OF fiExportFileName IN FRAME frTreeview /* Export filename */
DO:

  ASSIGN
    fiExportFileName:SCREEN-VALUE = RIGHT-TRIM(REPLACE(LC(fiExportFileName:SCREEN-VALUE),"~\":U,"/":U),"/":U).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
/*
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

*/

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
/*
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

*/
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
    DEFINE INPUT PARAMETER phNode       AS COM-HANDLE                   NO-UNDO.

    RUN treeNodeClick ( INPUT phNode ).


    RELEASE OBJECT phNode NO-ERROR.

    RETURN.
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

OCXFile = SEARCH( "afgenlogsv2.wrx":U ).
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
ELSE MESSAGE "afgenlogsv2.wrx":U SKIP(1)
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
  HIDE FRAME frTreeview.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE errorInGeneration sObject 
PROCEDURE errorInGeneration :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER plError AS LOGICAL    NO-UNDO.

  IF CAN-FIND(FIRST ttErrorLog 
                WHERE ttErrorLog.tErrorType = "ERROR":U NO-LOCK) THEN
    plError = TRUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exportLogToFile sObject 
PROCEDURE exportLogToFile :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lFileOverwrite          AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE cLevelSection           AS CHARACTER  NO-UNDO FORMAT "X(3)".
  DEFINE VARIABLE cLevelSectionMessage    AS CHARACTER  NO-UNDO FORMAT "X(3)".
  DEFINE VARIABLE cLevelAction            AS CHARACTER  NO-UNDO FORMAT "X(3)".
  DEFINE VARIABLE cLevelActionMessage     AS CHARACTER  NO-UNDO FORMAT "X(3)".
  DEFINE VARIABLE cLevelResult            AS CHARACTER  NO-UNDO FORMAT "X(3)".
  DEFINE VARIABLE cLevelResultMessage     AS CHARACTER  NO-UNDO FORMAT "X(3)".
  DEFINE VARIABLE cDateFormat             AS CHARACTER  NO-UNDO EXTENT 3.
  DEFINE VARIABLE cDateFormatString       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop                   AS INTEGER    NO-UNDO.

  DEFINE BUFFER lbSection                 FOR ttSection.
  DEFINE BUFFER lbAction                  FOR ttAction.
  DEFINE BUFFER lbResult                  FOR ttResult.

  ASSIGN cDateFormat[1] = SUBSTRING(SESSION:DATE-FORMAT,1,1)
         cDateFormat[2] = SUBSTRING(SESSION:DATE-FORMAT,2,1)
         cDateFormat[3] = SUBSTRING(SESSION:DATE-FORMAT,3,1).
  DO iLoop = 1 TO 3:
    IF cDateFormat[iLoop] = "m":U OR
       cDateFormat[iLoop] = "d":U THEN
      cDateFormat[iLoop] = "99":U.
    ELSE
      cDateFormat[iLoop] = "9999":U.
  END.

  ASSIGN cDateFormatString = cDateFormat[1] + "/":U + cDateFormat[2] + "/":U + cDateFormat[3].

  DO WITH FRAME {&FRAME-NAME}:

    ASSIGN
      fiExportFileName.

  END. /* FRAME {&FRAME-NAME} */

  IF NOT CAN-FIND(FIRST ttSection)
  THEN DO:
    MESSAGE
      "No log entries available to export"
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RETURN.
  END.

  ASSIGN
    lFileOverwrite = YES.

  IF fiExportFileName = "":U
  THEN DO:
    MESSAGE
      "Please specify a valid export filename. (":U + fiExportFileName + ")":U
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    ASSIGN
      lFileOverwrite = NO.
  END.

  IF SEARCH(fiExportFileName)  <> ?
  AND SEARCH(fiExportFileName) <> "":U
  THEN
    MESSAGE
      "The export file already exist"
      SKIP(1)
      "Overwrite existing file ?"
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
      UPDATE lFileOverwrite.

  IF NOT lFileOverwrite
  THEN DO:
    MESSAGE
      "Export to log file cancelled"
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
  END. /* NOT lFileOverwrite */
  ELSE DO:

    OUTPUT STREAM sOutput TO VALUE(fiExportFileName).

    FOR EACH ttSection NO-LOCK
      USE-INDEX idxSectionOrder
      :

      FIND lbSection NO-LOCK
        WHERE lbSection.tSectionOrder = ttSection.tSectionOrder
        NO-ERROR.
      FIND NEXT lbSection NO-LOCK
        USE-INDEX idxSectionOrder
        NO-ERROR.
      IF NOT AVAILABLE lbSection
      THEN ASSIGN cLevelSection = "   ":U.
      ELSE ASSIGN cLevelSection = "|  ":U.

      PUT STREAM sOutput UNFORMATTED
        "+--":U
        ttSection.tSectionName
        SKIP
        .

      IF CAN-FIND(FIRST ttErrorLog
                  WHERE ttErrorLog.tSection = ttSection.tSectionName
                  AND   ttErrorLog.tAction  = "":U
                  AND   ttErrorLog.tResult  = "":U)
      THEN
        PUT STREAM sOutput UNFORMATTED
          cLevelSection
          "|  ":U
          SKIP
          .

      FOR EACH ttErrorLog NO-LOCK
        WHERE ttErrorLog.tSection = ttSection.tSectionName
        AND   ttErrorLog.tAction  = "":U
        AND   ttErrorLog.tResult  = "":U
        :

        PUT STREAM sOutput UNFORMATTED
          cLevelSection
          "+--":U
          REPLACE(ttErrorLog.tMessageText,CHR(10),CHR(10) + cLevelSection + "|  ":U)
          SKIP
          cLevelSection
          "+--":U
          "Type : " ttErrorLog.tErrorType
          " / ":U
          "Date : " STRING(ttErrorLog.tDateLogged,cDateFormatString)
          " / ":U
          "Time : " STRING(ttErrorLog.tTimeLogged,"HH:MM:SS":U)
          SKIP
          .

      END. /* ttErrorLog */

      IF CAN-FIND(FIRST ttAction
                  WHERE ttAction.tSectionOrder = ttSection.tSectionOrder)
      THEN
        PUT STREAM sOutput UNFORMATTED
          cLevelSection
          "|  ":U
          SKIP
          .
      ELSE
        PUT STREAM sOutput UNFORMATTED
          cLevelSection
          "   ":U
          SKIP
          .

      FOR EACH ttAction NO-LOCK
        WHERE ttAction.tSectionOrder = ttSection.tSectionOrder
        USE-INDEX idxActionOrder
        :

        FIND lbAction NO-LOCK
          WHERE lbAction.tSectionOrder = ttAction.tSectionOrder
          AND   lbAction.tActionOrder  = ttAction.tActionOrder
          NO-ERROR.
        FIND NEXT lbAction NO-LOCK
          USE-INDEX idxActionOrder
          NO-ERROR.
        IF NOT AVAILABLE lbAction
        THEN ASSIGN cLevelAction = "   ":U.
        ELSE ASSIGN cLevelAction = "|  ":U.

        PUT STREAM sOutput UNFORMATTED
          cLevelSection
          "+--":U
          ttAction.tActionName
          SKIP
          .

        IF CAN-FIND(FIRST ttErrorLog
                    WHERE ttErrorLog.tSection = ttSection.tSectionName
                    AND   ttErrorLog.tAction  = ttAction.tActionName
                    AND   ttErrorLog.tResult  = "":U)
        THEN
          PUT STREAM sOutput UNFORMATTED
            cLevelSection
            cLevelAction
            "|  ":U
            SKIP
            .

        FOR EACH ttErrorLog NO-LOCK
          WHERE ttErrorLog.tSection = ttSection.tSectionName
          AND   ttErrorLog.tAction  = ttAction.tActionName
          AND   ttErrorLog.tResult  = "":U
          :

          PUT STREAM sOutput UNFORMATTED
            cLevelSection
            cLevelAction
            "+--":U
            REPLACE(ttErrorLog.tMessageText,CHR(10),CHR(10) + cLevelSection + cLevelAction + "|  ":U)
            SKIP
            cLevelSection
            cLevelAction
            "+--":U
            "Type : " ttErrorLog.tErrorType
            " / ":U
            "Date : " STRING(ttErrorLog.tDateLogged,cDateFormatString)
            " / ":U
            "Time : " STRING(ttErrorLog.tTimeLogged,"HH:MM:SS":U)
            SKIP
            .

        END. /* ttErrorLog */

      IF CAN-FIND(FIRST ttResult
                  WHERE ttResult.tActionOrder = ttAction.tActionOrder)
      THEN
        PUT STREAM sOutput UNFORMATTED
          cLevelSection
          cLevelAction
          "|  ":U
          SKIP
          .
      ELSE
        PUT STREAM sOutput UNFORMATTED
          cLevelSection
          cLevelAction
          "   ":U
          SKIP
          .

        FOR EACH ttResult NO-LOCK
          WHERE ttResult.tActionOrder = ttAction.tActionOrder
          USE-INDEX idxResultOrder
          :

          FIND lbResult NO-LOCK
            WHERE lbResult.tActionOrder = ttResult.tActionOrder
            AND   lbResult.tResultOrder = ttResult.tResultOrder
            NO-ERROR.
          FIND NEXT lbResult NO-LOCK
            USE-INDEX idxResultOrder
            NO-ERROR.
          IF NOT AVAILABLE lbResult
          THEN ASSIGN cLevelResult = "   ":U.
          ELSE ASSIGN cLevelResult = "|  ":U.

          PUT STREAM sOutput UNFORMATTED
            cLevelSection
            cLevelAction
            "+--":U
            ttResult.tResultName
            ttResult.tResultText
            ttResult.tResultType
            SKIP
            .

          IF CAN-FIND(FIRST ttErrorLog
                      WHERE ttErrorLog.tSection = ttSection.tSectionName
                      AND   ttErrorLog.tAction  = ttAction.tActionName
                      AND   ttErrorLog.tResult  = ttResult.tResultName)
          THEN
            PUT STREAM sOutput UNFORMATTED
              cLevelSection
              cLevelAction
              cLevelResult
              "|  ":U
              SKIP
              .

          FOR EACH ttErrorLog NO-LOCK
            WHERE ttErrorLog.tSection = ttSection.tSectionName
            AND   ttErrorLog.tAction  = ttAction.tActionName
            AND   ttErrorLog.tResult  = ttResult.tResultName
            :

            PUT STREAM sOutput UNFORMATTED
              cLevelSection
              cLevelAction
              cLevelResult
              "+--":U
              REPLACE(ttErrorLog.tMessageText,CHR(10),CHR(10) + cLevelSection + cLevelAction + cLevelResult + "|  ":U)
              SKIP
              cLevelSection
              cLevelAction
              cLevelResult
              "+--":U
              "Type : " ttErrorLog.tErrorType
              " / ":U
              "Date : " STRING(ttErrorLog.tDateLogged,cDateFormatString)
              " / ":U
              "Time : " STRING(ttErrorLog.tTimeLogged,"HH:MM:SS":U)
              SKIP
              .

          END. /* ttErrorLog */

          PUT STREAM sOutput UNFORMATTED
            cLevelSection
            cLevelAction
            cLevelResult
            .
          IF NOT AVAILABLE lbResult
          THEN
            PUT STREAM sOutput UNFORMATTED
              "   ":U
              .
          ELSE
            PUT STREAM sOutput UNFORMATTED
              "|  ":U
              .

          PUT STREAM sOutput UNFORMATTED
            SKIP
            .

        END. /* ttResult */

      END. /* ttAction */

    END. /* ttSection */

    OUTPUT STREAM sOutput CLOSE.

    MESSAGE
      "Export to log file successful."
      VIEW-AS ALERT-BOX INFO BUTTONS OK.

  END. /* lFileOverwrite */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject sObject 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VARIABLE chTreeview  AS COM-HANDLE NO-UNDO.
  
  RUN SUPER.

  SUBSCRIBE "listenForLogMessages":U IN ghContainerSource.
  SUBSCRIBE "errorInGeneration":U IN ghContainerSource.

  DO WITH FRAME {&FRAME-NAME}:

    ASSIGN
      fiExportFileName = RIGHT-TRIM(REPLACE(SESSION:TEMP-DIRECTORY,"~\":U,"~/":U),"~/":U)
                       + "~/":U
                       + "OG_"
                       + REPLACE(REPLACE(STRING(TODAY),"~\":U,"":U),"~/":U,"":U)
                       + "_":U
                       + REPLACE(STRING(TIME,"HH:MM:SS":U),":":U,"":U)
                       + ".log"
                       .

    ASSIGN
      fiExportFileName:SCREEN-VALUE = fiExportFileName.

  END.

  ASSIGN chTreeview   = hTreeview:COM-HANDLE
         chTreeview   = chTreeview:CONTROLS:ITEM(1)  
         NO-ERROR. 

  IF VALID-HANDLE(chTreeView) THEN
    ASSIGN chTreeView:LineStyle = 1.

  RELEASE OBJECT chTreeview NO-ERROR. 
  
  
  RETURN.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkStateHandler sObject 
PROCEDURE linkStateHandler :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcState  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER phObject AS HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER pcLink   AS CHARACTER NO-UNDO.

    RUN SUPER( INPUT pcState, INPUT phObject, INPUT pcLink).

    /* Set the handle of the container source immediately upon making the link */
    IF pcLink = "ContainerSource":U AND pcState = "Add":U THEN
        ASSIGN ghContainerSource = phObject.

    RETURN.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE listenForLogMessages sObject 
PROCEDURE listenForLogMessages :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE chTreeview          AS COM-HANDLE                   NO-UNDO.

    /* Clear out the TT for the new run. */
    EMPTY TEMP-TABLE ttErrorLog.
    EMPTY TEMP-TABLE ttSection.
    EMPTY TEMP-TABLE ttAction.
    EMPTY TEMP-TABLE ttResult.

    /* Clear the tree view. */
    ASSIGN chTreeview = chhTreeview:CONTROLS:ITEM(1) NO-ERROR. 

    chTreeView:Nodes:CLEAR().
    
    ASSIGN edMessageView:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "":U.

    RELEASE OBJECT chTreeview NO-ERROR. 

    /* Listen for incoming error messages. */
    SUBSCRIBE "logObjectGeneratorMessage":U ANYWHERE.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE logObjectGeneratorMessage sObject 
PROCEDURE logObjectGeneratorMessage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER prErrorLog       AS RAW                      NO-UNDO.   

  DEFINE VARIABLE chNode                  AS COM-HANDLE               NO-UNDO.
  DEFINE VARIABLE chTreeview              AS COM-HANDLE               NO-UNDO.
  DEFINE VARIABLE iImageIndexUp           AS INTEGER                  NO-UNDO.
  DEFINE VARIABLE iImageIndexDown         AS INTEGER                  NO-UNDO.
  DEFINE VARIABLE iImageIndexCollapsed    AS INTEGER                  NO-UNDO.
  DEFINE VARIABLE iImageIndexExpanded     AS INTEGER                  NO-UNDO.
  DEFINE VARIABLE iImageIndexInformation  AS INTEGER                  NO-UNDO.
  DEFINE VARIABLE iImageIndexError        AS INTEGER                  NO-UNDO.
  DEFINE VARIABLE cParentKey              AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE cChildKey               AS CHARACTER                NO-UNDO.

  DEFINE BUFFER ttErrorLog                FOR ttErrorLog.

  DEFINE BUFFER lbSection                 FOR ttSection.
  DEFINE BUFFER lbAction                  FOR ttAction.
  DEFINE BUFFER lbResult                  FOR ttResult.

  CREATE ttErrorLog.
  RAW-TRANSFER FIELD prErrorLog TO BUFFER ttErrorLog NO-ERROR.

  /* If images have been defined, load them into the ImageList and get the index. */
  ASSIGN
    iImageIndexCollapsed    = DYNAMIC-FUNCTION("loadImage" IN TARGET-PROCEDURE, "ry/img/treefile.ico":U)
    iImageIndexExpanded     = DYNAMIC-FUNCTION("loadImage" IN TARGET-PROCEDURE, "ry/img/treefils.ico":U)
    iImageIndexInformation  = DYNAMIC-FUNCTION("loadImage" IN TARGET-PROCEDURE, "ry/img/error24.ico":U)
    iImageIndexError        = DYNAMIC-FUNCTION("loadImage" IN TARGET-PROCEDURE, "ry/img/error24.ico":U)
    .

  IF ttErrorLog.tErrorType EQ "ERROR":U
  THEN
    ASSIGN
      iImageIndexUp   = iImageIndexError       /* ERROR Image          */
      iImageIndexDown = iImageIndexError
      .
  ELSE
  IF ttErrorLog.tErrorType EQ "INFORMATION":U
  THEN
    ASSIGN
      iImageIndexUp   = iImageIndexInformation /* INFORMATION Image    */
      iImageIndexDown = iImageIndexInformation
      .
  ELSE
    ASSIGN
      iImageIndexUp   = iImageIndexCollapsed  /* Normal Image         */
      iImageIndexDown = iImageIndexExpanded   /* Selected Image       */
      .

  /* Get the handle to the TreeView itself. */
  ASSIGN
    chTreeview = chhTreeview:CONTROLS:ITEM(1) NO-ERROR.

  /* Treeview settings */
  chTreeview:sorted() = FALSE.

  FIND FIRST ttSection
    WHERE ttSection.tSectionName = ttErrorLog.tSection
    NO-ERROR.
  IF NOT AVAILABLE ttSection
  THEN DO:

    FIND LAST lbSection NO-ERROR.

    CREATE ttSection.
    ASSIGN
      ttSection.tSectionName  = ttErrorLog.tSection
      ttSection.tSectionOrder = (IF AVAILABLE lbSection THEN lbSection.tSectionOrder + 1 ELSE 1)
      cParentKey              = ?
      cChildKey               = "SECTION-":U + STRING(ttSection.tSectionOrder)
      .
    ASSIGN
      chNode = chTreeview:Nodes:ADD(cParentKey              /* Parent Key (optional) */
                                   ,4                       /* Insert relative to parent key 0-first 1-last 2-next 3-previous 4-child */
                                   ,cChildKey               /* Key - Must be unique */
                                   ,ttSection.tSectionName  /* Label Text           */
                                   ,iImageIndexUp           /* Normal Image         */
                                   ,iImageIndexDown         /* Selected Image       */
                                   ).
    IF ttErrorLog.tAction EQ ttErrorLog.tSection
    OR ttErrorLog.tAction EQ "":U
    THEN DO:

      ASSIGN
        chNode:Tag = STRING(ROWID(ttErrorLog)).

      /* If there's an error, expand all parent nodes */
      IF ttErrorLog.tErrorType EQ "ERROR":U
      OR ttErrorLog.tErrorType EQ "INFORMATION":U
      THEN DO:
        chNode:EnsureVisible().
        chNode:SELECTED = TRUE.
        RUN treeNodeClick ( INPUT chNode ).
      END.    /* ERROR */

    END.
    ELSE
      ASSIGN
        chNode:Tag = "":U.

  END.    /* n/a section */

  /* Action not the same as the saection. */
  IF  ttErrorLog.tAction NE ttErrorLog.tSection
  AND ttErrorLog.tAction NE "":U
  THEN DO:

    FIND FIRST ttAction
      WHERE ttAction.tActionName   = ttErrorLog.tAction
      AND   ttAction.tSectionOrder = ttSection.tSectionOrder
      NO-ERROR.
    IF NOT AVAILABLE ttAction
    THEN DO:

      FIND LAST lbAction NO-ERROR.

      CREATE ttAction.
      ASSIGN
        ttAction.tActionName   = ttErrorLog.tAction
        ttAction.tActionOrder  = (IF AVAILABLE lbAction THEN lbAction.tActionOrder + 1 ELSE 1)
        ttAction.tSectionOrder = ttSection.tSectionOrder
        cParentKey              = "SECTION-":U + STRING(ttAction.tSectionOrder)
        cChildKey               = "ACTION-":U + STRING(ttAction.tActionOrder)
        .
      ASSIGN
        chNode = chTreeview:Nodes:ADD(cParentKey            /* Parent Key (optional) */
                                     ,4                     /* Insert relative to parent key 0-first 1-last 2-next 3-previous 4-child */
                                     ,cChildKey             /* Key - Must be unique */ 
                                     ,ttAction.tActionName  /* Label Text           */
                                     ,iImageIndexUp         /* Normal Image         */
                                     ,iImageIndexDown       /* Selected Image       */
                                     ).
      IF ttErrorLog.tResult EQ ttErrorLog.tAction
      OR ttErrorLog.tResult EQ "":U
      THEN DO:
        ASSIGN
          chNode:Tag = STRING(ROWID(ttErrorLog)).

        /* If there's an error, expand all parent nodes */
        IF ttErrorLog.tErrorType EQ "ERROR":U
        OR ttErrorLog.tErrorType EQ "INFORMATION":U
        THEN DO:
          chNode:EnsureVisible().
          chNode:SELECTED = TRUE.
          RUN treeNodeClick ( INPUT chNode ).
        END.    /* ERROR */

      END.
      ELSE
        ASSIGN
          chNode:Tag = "":U. 

    END.    /* n/a Action */

  END.    /* action differs from section */

  IF  ttErrorLog.tResult NE ttErrorLog.tAction
  AND ttErrorLog.tResult NE "":U
  THEN DO:

    FIND LAST lbResult NO-ERROR.

    CREATE ttResult.
    ASSIGN
      ttResult.tResultName  = ttErrorLog.tResult
      ttResult.tResultOrder = (IF AVAILABLE lbResult THEN lbResult.tResultOrder + 1 ELSE 1)
      ttResult.tActionOrder = ttAction.tActionOrder
      cParentKey            = "ACTION-":U + STRING(ttResult.tActionOrder)
      cChildKey             = "RESULT-":U + STRING(ttResult.tResultOrder)
      .
    ASSIGN
      chNode = chTreeview:Nodes:ADD(cParentKey               /* Parent Key (optional) */
                               ,4                            /* Insert relative to parent key 0-first 1-last 2-next 3-previous 4-child */
                               ,cChildKey                    /* Key - Must be unique */ 
                               ,ttResult.tResultName         /* Label Text           */
                               ,iImageIndexUp           /* Normal Image         */
                               ,iImageIndexDown         /* Selected Image       */
                               ).

    ASSIGN
      chNode:Tag = STRING(ROWID(ttErrorLog)).

    /* If there's an error, expand all parent nodes */
    IF ttErrorLog.tErrorType EQ "ERROR":U
    OR ttErrorLog.tErrorType EQ "INFORMATION":U
    THEN DO:
      chNode:EnsureVisible().
      chNode:SELECTED = TRUE.
      RUN treeNodeClick ( INPUT chNode ).
    END.    /* ERROR */

  END.    /* action is not the same as the message text */

  /* Release com-handles */
  RELEASE OBJECT chNode     NO-ERROR.
  RELEASE OBJECT chTreeview NO-ERROR.

  RETURN.

END PROCEDURE.  /* logObjectGeneratorMessage */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject sObject 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pdHeight             AS DECIMAL          NO-UNDO.
  DEFINE INPUT PARAMETER pdWidth              AS DECIMAL          NO-UNDO.

  DEFINE VARIABLE iCurrentPage                AS INTEGER          NO-UNDO.
  DEFINE VARIABLE lHidden                     AS LOGICAL          NO-UNDO.  

  DEFINE VARIABLE hLabelHandle                AS HANDLE           NO-UNDO.

  ASSIGN
    lHidden                                   = FRAME {&FRAME-NAME}:HIDDEN
    FRAME {&FRAME-NAME}:HIDDEN                = YES
    FRAME {&FRAME-NAME}:SCROLLABLE            = YES
    FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-CHARS  = SESSION:HEIGHT-CHARS
    FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-CHARS   = SESSION:WIDTH-CHARS
    FRAME {&FRAME-NAME}:HEIGHT-CHARS          = pdHeight
    FRAME {&FRAME-NAME}:WIDTH-CHARS           = pdWidth
    .

  DO WITH FRAME {&FRAME-NAME}:

    ASSIGN
      hTreeview:ROW               = 1
      hTreeview:COLUMN            = 1
      hTreeview:HEIGHT-CHARS      = FRAME {&FRAME-NAME}:HEIGHT-CHARS - 2
      hTreeview:WIDTH-CHARS       = FRAME {&FRAME-NAME}:WIDTH-CHARS * 0.40
      edMessageView:ROW           = 1
      edMessageView:COLUMN        = hTreeview:COLUMN + hTreeview:WIDTH-CHARS + 0.3
      edMessageView:HEIGHT-CHARS  = FRAME {&FRAME-NAME}:HEIGHT-CHARS - 2
      edMessageView:WIDTH-CHARS   = FRAME {&FRAME-NAME}:WIDTH-CHARS - edMessageView:COLUMN - 0.3
      .

    ASSIGN
      hLabelHandle = fiExportFileName:SIDE-LABEL-HANDLE.

    ASSIGN
      buExport:ROW          = FRAME {&FRAME-NAME}:HEIGHT-CHARS - 0.5
      hLabelHandle:ROW      = FRAME {&FRAME-NAME}:HEIGHT-CHARS - 0.5
      fiExportFileName:ROW  = FRAME {&FRAME-NAME}:HEIGHT-CHARS - 0.5
      buExportFileName:ROW  = FRAME {&FRAME-NAME}:HEIGHT-CHARS - 0.5
      .

  END.    /* with frame ... */

  ASSIGN
    FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-CHARS = FRAME {&FRAME-NAME}:HEIGHT-CHARS
    FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-CHARS  = FRAME {&FRAME-NAME}:WIDTH-CHARS
    FRAME {&FRAME-NAME}:SCROLLABLE           = NO
    FRAME {&FRAME-NAME}:HIDDEN               = lHidden
    .

  {get CurrentPage iCurrentPage ghContainerSource}.

  IF iCurrentPage NE 7
  THEN
    RUN hideObject.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE treeNodeClick sObject 
PROCEDURE treeNodeClick :
/*------------------------------------------------------------------------------
  Purpose:     Procedure run when a node is clicked.
  Parameters:  <none>
  Notes:       * the Node com-handle must be cleaned up by the caller.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER phNode           AS COM-HANDLE               NO-UNDO.

  DEFINE VARIABLE rErrorLog       AS ROWID                            NO-UNDO.

  IF phNode:Tag NE "":U
  THEN
  DO WITH FRAME {&FRAME-NAME}:

    ASSIGN
      rErrorLog = TO-ROWID(phNode:tag).

    FIND FIRST ttErrorLog
      WHERE ROWID(ttErrorLog) = rErrorLog
      NO-ERROR.
    IF AVAILABLE ttErrorLog
    THEN DO:

      ASSIGN
        edMessageView:SCREEN-VALUE = "":U.

      edMessageView:INSERT-STRING( "Message:~n":U
                                 + FILL("=":U, 14)
                                 + "~n":U
                                 + ttErrorLog.tMessageText
                                 + "~n~n":U
                                 + "Information:~n":U
                                 + FILL("=":U, 18)
                                 + "~n":U
                                 + "Type: ":U    + ttErrorLog.tErrorType + "~n":U
                                 + "Logged at: " + STRING(ttErrorLog.tTimeLogged, "HH:MM:SS":U)
                                 + " ":U         + STRING(ttErrorLog.tDateLogged) + "~n":U ).
/*
      edMessageView:INSERT-STRING( "Message:~n":U
                                 + FILL("=":U, 14) + "~n":U
                                 + ttErrorLog.tMessageText + "~n~n":U
                                 + "Full Message:~n":U
                                 + FILL("=":U, 13) + "~n":U
                                 + ttErrorLog.tExpandedMessage + "~n~n":U
                                 + "Error Information:~n":U
                                 + FILL("=":U, 18) + "~n":U
                                 + "Type: ":U + ttErrorLog.tErrorType + "~n":U
                                 + "Logged at: " + STRING(ttErrorLog.tTimeLogged, "HH:MM:SS":U)
                                 + " ":U + STRING(ttErrorLog.tDateLogged) + "~n":U ).
*/
    END.    /* avali error log */

  END.    /* with frame ... */

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION loadImage sObject 
FUNCTION loadImage RETURNS INTEGER
  ( INPUT pcImageFile AS CHARACTER ) :
/*------------------------------------------------------------------------------
 Purpose:  Takes the file referenced in pcImageFile, checks to see if it is already in
           the ImageList and if not, loads it. If this is successful then its index in 
           the ImageList is returned. If the file is already in the ImageList, its index is returned.
 
           If the load fails, 0 is returned.
 
 Note:    The filename must specify the relative path and filename with the extension.
 
          Since the imagelist does not contain any images, the ImageList property is assigned 
          to the Treeview only once, after an image is added.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE chImage      AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE chNewImage   AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE chTreeview   AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE hTreeview    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iImageIndex  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE chImageList  AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE hImageList   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cExtension   AS CHARACTER  NO-UNDO.

  FILE-INFO:FILE-NAME = pcImageFile.

  IF FILE-INFO:FULL-PATHNAME <> ? THEN
  DO:
    /* Find out if the image has already been loaded. If it has we need to 
     * find its index. */
     /* Get the handle to the TreeView itself. */
  ASSIGN chTreeview   = chhTreeview:CONTROLS:ITEM(1)  
         NO-ERROR. 
    
  ASSIGN chImageList   = chhImageList:CONTROLS:ITEM(1)  
         NO-ERROR. 

  chImage = chImageList:ListImages:ITEM(pcImageFile) NO-ERROR.

    IF NOT VALID-HANDLE(chImage) THEN
    DO:
      /* Ensure that the image type is one that is supported by the LOAD-PICTURE statement */

      ASSIGN cExtension = ENTRY(NUM-ENTRIES(pcImageFile, ".":U),pcImageFile, ".":U) NO-ERROR.

      IF LOOKUP(cExtension,"BMP,WMF,EMF,ICO,CUR,DIB":U) = 0 
      OR LOOKUP(cExtension,"BMP,WMF,EMF,ICO,CUR,DIB":U) = ? THEN
          RETURN 0.

      chImage = LOAD-PICTURE(FILE-INFO:FULL-PATHNAME).

      IF VALID-HANDLE(chImage) THEN
      DO:
        ASSIGN chNewImage  = chImageList:ListImages:ADD(chImageList:ListImages:COUNT + 1, pcImageFile, chImage)
               iImageIndex = chNewImage:INDEX.
        /* assign the imagelist to the treeview */
        IF chImageList:ListImages:COUNT = 1 THEN DO:
            chTreeview:ImageList = chImageList.
        END.
      END.
    END.
    ELSE
      iImageIndex = chImage:INDEX.

   RELEASE OBJECT chImage     NO-ERROR.
   RELEASE OBJECT chNewImage  NO-ERROR.
   RELEASE OBJECT chtreeview  NO-ERROR.
   RELEASE OBJECT chImageList NO-ERROR.
   
   RETURN iImageIndex.
  END.

  RETURN 0.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION PixelsToTwips sObject 
FUNCTION PixelsToTwips RETURNS INTEGER
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

