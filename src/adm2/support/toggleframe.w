&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE xdLineHeight  AS DECIMAL    NO-UNDO INIT 0.72.
DEFINE VARIABLE xdScrollMargin   AS DECIMAL    NO-UNDO INIT 0.25.

/* props only to be accesses by get and set */
DEFINE VARIABLE ghScrollFrame AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghParent AS HANDLE     NO-UNDO.
DEFINE VARIABLE glSingleOnly AS LOGICAL NO-UNDO.
DEFINE VARIABLE gcFirstLabel  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSecondLabel AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gdTextWidth   AS DECIMAL    NO-UNDO INIT 20.
DEFINE VARIABLE ghBeforeTab AS HANDLE     NO-UNDO.

DEFINE TEMP-TABLE ttItem 
  FIELD itemROW AS dec
  FIELD ItemName AS CHAR 
  FIELD txtHdl AS  HANDLE
  FIELD tog1Hdl AS  HANDLE
  FIELD tog2Hdl AS  HANDLE
  INDEX sequence itemrow.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME toggleframe

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addItem C-Win 
FUNCTION addItem RETURNS LOGICAL
  (pcName    AS char,
   plToggle1 AS LOG,
   plToggle2 AS LOG) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createFrameBorder C-Win 
FUNCTION createFrameBorder RETURNS LOGICAL
  (phFrame AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD deleteItems C-Win 
FUNCTION deleteItems RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBeforeTab C-Win 
FUNCTION getBeforeTab RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFirstItems C-Win 
FUNCTION getFirstItems RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFirstLabel C-Win 
FUNCTION getFirstLabel RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFrame C-Win 
FUNCTION getFrame RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSecondItems C-Win 
FUNCTION getSecondItems RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSecondLabel C-Win 
FUNCTION getSecondLabel RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTextWidth C-Win 
FUNCTION getTextWidth RETURNS DECIMAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD set3D C-Win 
FUNCTION set3D RETURNS LOGICAL
  ( pl3D AS log )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBeforeTab C-Win 
FUNCTION setBeforeTab RETURNS LOGICAL
  ( phBefore AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCol C-Win 
FUNCTION setCol RETURNS LOGICAL
  ( pdCol AS DECIMAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFirstLabel C-Win 
FUNCTION setFirstLabel RETURNS LOGICAL
  ( pcLabel AS CHAR  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFrame C-Win 
FUNCTION setFrame RETURNS LOGICAL
  ( phFrame AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setHeight C-Win 
FUNCTION setHeight RETURNS LOGICAL
  ( pdHeight AS DECIMAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRow C-Win 
FUNCTION setRow RETURNS LOGICAL
  ( pdRow AS DECIMAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSecondLabel C-Win 
FUNCTION setSecondLabel RETURNS LOGICAL
  ( pcLabel AS CHAR  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSecondSingleOnly C-Win 
FUNCTION setSecondSingleOnly RETURNS LOGICAL
  ( plSingle AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTextWidth C-Win 
FUNCTION setTextWidth RETURNS LOGICAL
  ( pdWidth AS DECIMAL  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setWidth C-Win 
FUNCTION setWidth RETURNS LOGICAL
  ( pdWidth AS DECIMAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD viewHideItems C-Win 
FUNCTION viewHideItems RETURNS LOGICAL
  ( plView AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD viewItems C-Win 
FUNCTION viewItems RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME toggleframe
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 54.2 BY 3.86
         BGCOLOR 15  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* SUPPRESS Window definition (used by the UIB) 
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert window title>"
         HEIGHT             = 3.86
         WIDTH              = 54
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 16
         VIRTUAL-WIDTH      = 80
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
                                                                        */
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME
ASSIGN C-Win = CURRENT-WINDOW.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB C-Win 
/* ************************* Included-Libraries *********************** */

{src/adm2/visual.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME toggleframe
   NOT-VISIBLE FRAME-NAME                                               */
ASSIGN 
       FRAME toggleframe:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME toggleframe
/* Query rebuild information for FRAME toggleframe
     _Query            is NOT OPENED
*/  /* FRAME toggleframe */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject C-Win 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN DISABLE_ui.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
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
  HIDE FRAME toggleframe.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
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
  {&OPEN-BROWSERS-IN-QUERY-toggleframe}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject C-Win 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FRAME {&FRAME-NAME}:SCROLLABLE = false.
  FRAME {&FRAME-NAME}:FRAME = ghparent.
  FRAME {&FRAME-NAME}:HIDDEN = FALSE.

  IF VALID-HANDLE(getBeforeTab()) THEN
    FRAME {&FRAME-NAME}:MOVE-AFTER-TAB-ITEM(getBeforeTab()).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valueOneChanged C-Win 
PROCEDURE valueOneChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcname AS CHARACTER  NO-UNDO.
     
    FIND ttItem WHERE ttItem.itemNAME = pcname.
    IF SELF:CHECKED = FALSE THEN
      ttItem.tog2hdl:CHECKED =  FALSE.

    ttItem.tog2hdl:SENSITIVE = SELF:CHECKED.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valueTwoChanged C-Win 
PROCEDURE valueTwoChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcname AS CHARACTER  NO-UNDO.
    
    IF glSingleOnly  AND SELF:CHECKED THEN
    FOR EACH ttItem WHERE ttItem.ITEMNAME <> pcname:
      ttItem.tog2hdl:CHECKED   = FALSE.
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addItem C-Win 
FUNCTION addItem RETURNS LOGICAL
  (pcName    AS char,
   plToggle1 AS LOG,
   plToggle2 AS LOG):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hImage AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cImage AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCol AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dRow AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE hFRame AS HANDLE     NO-UNDO. 
  DEFINE BUFFER bItem FOR ttItem.
  
  hFrame = getFrame().
  IF NOT VALID-HANDLE(ghScrollFrame) THEN
  DO:
    CREATE FRAME ghScrollFrame
      ASSIGN Y = 2
             X = 2
            FRAME = hFrame  
            WIDTH-P = hFrame:WIDTH-P - 4
            HEIGHT-P = hFrame:HEIGHT-P - 4
            BGCOLOR = hFrame:bgcolor
           BOX  = FALSE
            HIDDEN = FALSE.
/*      ghScrollFrame:MOVE-TO-BOTTOM(). */
  END.

  FIND LAST bItem NO-ERROR.
  dRow = (IF NOT AVAIL bItem then 1.1
          ELSE bItem.ItemRow + xdLineHeight).
  dcol = 1.
 
  CREATE ttItem.
  ASSIGN 
      ttItem.itemNAME     = pcName.

  CREATE TEXT ttItem.txtHdl
    ASSIGN 
      FRAME  = ghScrollFrame
      FORMAT = 'X(80)'
      SCREEN-VALUE = pcName
      WIDTH  = getTextWidth()
      HEIGHT = xdLineHeight
      SELECTABLE = TRUE
      HIDDEN = TRUE.

   CREATE TOGGLE-BOX ttItem.tog1Hdl
     ASSIGN 
       FRAME        = ghScrollFrame
       SENSITIVE    = FALSE
       LABEL        = getFirstLabel()
       /* WIDTH        = 2.5*/
       HIDDEN       = TRUE         
       SENSITIVE    = TRUE 
       CHECKED      = plToggle1 
     TRIGGERS:
       ON VALUE-CHANGED 
         PERSISTENT RUN valueOneChanged IN THIS-PROCEDURE (pcName).
     END.

    CREATE TOGGLE-BOX ttItem.tog2Hdl
      ASSIGN 
        FRAME        = ghScrollFrame
        SENSITIVE    = FALSE 
        LABEL        = getSecondLabel() 
         /* WIDTH        = 2.5*/
        HIDDEN       = TRUE 
        SENSITIVE    = ttItem.tog1Hdl:checked 
        CHECKED      = plToggle2
      TRIGGERS:
       ON VALUE-CHANGED 
         PERSISTENT RUN valueTwoChanged IN THIS-PROCEDURE (pcName).
      END.                  
         

    ASSIGN
      ttItem.ItemRow      = dRow
      ttItem.TxtHdl:ROW   = dRow
      ttItem.tog1Hdl:ROW  = dRow
      ttItem.tog2Hdl:ROW  = dRow
      ttItem.TxtHdl:COL   = dCol + xdScrollMargin
      ttItem.tog1Hdl:COL  = dCol + ttItem.txtHdl:COL + ttItem.txtHdl:WIDTH - 1
      ttItem.tog2Hdl:COL  =  dCol + ttItem.tog1Hdl:COL + ttItem.tog1Hdl:WIDTH - 1
      NO-ERROR.
    
  RETURN true.    

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createFrameBorder C-Win 
FUNCTION createFrameBorder RETURNS LOGICAL
  (phFrame AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose: Create a border for the frame to make it appear as a widget 
    Notes: Use editor to ensure correct style on both XP and Classic 
------------------------------------------------------------------------------*/
   DEFINE VARIABLE hBorder AS HANDLE     NO-UNDO.
   CREATE EDITOR hBorder 
     ASSIGN
      WIDTH = phFrame:width
      HEIGHT = phFrame:height
      X = 0
      Y = 0 
     FRAME = phFrame
     HIDDEN =FALSE.

     /*
   DEFINE VARIABLE hTop AS HANDLE     NO-UNDO.
   DEFINE VARIABLE hBottom1 AS HANDLE     NO-UNDO.
   DEFINE VARIABLE hBottom2 AS HANDLE     NO-UNDO.
   DEFINE VARIABLE hRight1 AS HANDLE     NO-UNDO.
   DEFINE VARIABLE hRight2  AS HANDLE     NO-UNDO.

   CREATE RECTANGLE hleft
     ASSIGN   
       FGCOLOR = {fn getColor3DShadow}
       HEIGHT-P = phFrame:HEIGHT-P 
       WIDTH-P = 2
       X = 0
       Y = 0 
       FRAME = phFrame
       HIDDEN =FALSE.

   CREATE RECTANGLE htOP
     ASSIGN   
       FGCOLOR = {fn getColor3DShadow}
       width-P = phFrame:width-P
       HEIGHT-P = 2
       X  = 0
       Y  = 0
       FRAME = phFrame 
       HIDDEN =FALSE.

   CREATE RECTANGLE hbOTTOM1
     ASSIGN   
       FGCOLOR = {fn getColor3DFace}
       width-P = phFrame:WIDTH-P - 2
       HEIGHT-P = 1
       X  = 1
       Y  = phFrame:HEIGHT-P - 2
       FRAME = phFrame 
       HIDDEN =FALSE.

   CREATE RECTANGLE hbOTTOM2
     ASSIGN   
       FGCOLOR = {fn getColor3DHighlight}
       width-P = phFrame:WIDTH-P
       HEIGHT-P = 1
       X  = 0
       Y  = phFrame:HEIGHT-P - 1
       FRAME = phFrame 
       HIDDEN =FALSE.

   CREATE RECTANGLE hRight1
     ASSIGN   
       FGCOLOR = {fn getColor3DFace}
       HEIGHT-P = phFrame:HEIGHT-P - 2
       X  = phFrame:width-P - 2
       Y  = 1
       WIDTH-P = 1
       FRAME = phFrame 
       HIDDEN =FALSE.
   
   CREATE RECTANGLE hRight2
     ASSIGN   
       FGCOLOR = {fn getColor3DHighlight}
       HEIGHT-P = phFrame:HEIGHT-P
       X  = phFrame:width-P - 1
       Y  = 0
       WIDTH-P = 1
       FRAME = phFrame 
       HIDDEN =FALSE.
   */
  RETURN true. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION deleteItems C-Win 
FUNCTION deleteItems RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  FOR EACH ttItem:
    DELETE OBJECT ttItem.txtHdl.
    DELETE OBJECT ttItem.tog1Hdl.
    DELETE OBJECT ttItem.tog2Hdl.
    DELETE ttItem.
  END.
  IF VALID-HANDLE(ghScrollFrame) THEN
  DO:
    /* this seems to be only way to avoid scrollbars when selecting another 
       object with fewer items.  
       scollable, virtual-height works here, but scrollbars reappear as 
       soon as a single item is created again if the scrollbar had been 
       used to scroll down or focus is in a part that need scrollbar*/
    DELETE OBJECT ghscrollframe.
  END.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBeforeTab C-Win 
FUNCTION getBeforeTab RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN ghBeforeTab. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFirstItems C-Win 
FUNCTION getFirstItems RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cList AS CHARACTER  NO-UNDO.
  FOR EACH ttItem:
    IF ttItem.tog1hdl:CHECKED = TRUE THEN 
      cList = cList 
            + (IF cList = '' THEN '' ELSE ',') 
            + ttItem.itemname. 
  END.
  RETURN cList.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFirstLabel C-Win 
FUNCTION getFirstLabel RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN gcFirstlabel.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFrame C-Win 
FUNCTION getFrame RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN FRAME {&frame-name}:handle. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSecondItems C-Win 
FUNCTION getSecondItems RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cList AS CHARACTER  NO-UNDO.
  FOR EACH ttItem:
    IF ttItem.tog2hdl:CHECKED = TRUE THEN 
      cList = cList 
            + (IF cList = '' THEN '' ELSE ',') 
            + ttItem.itemname. 
  END.
  RETURN cList.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSecondLabel C-Win 
FUNCTION getSecondLabel RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN gcSecondlabel.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTextWidth C-Win 
FUNCTION getTextWidth RETURNS DECIMAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN gdTextWidth.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION set3D C-Win 
FUNCTION set3D RETURNS LOGICAL
  ( pl3D AS log ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF pl3d THEN
    createFrameBorder(getFrame()). 
  RETURN true.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBeforeTab C-Win 
FUNCTION setBeforeTab RETURNS LOGICAL
  ( phBefore AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  ghBeforeTab = phBefore.
  RETURN true.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCol C-Win 
FUNCTION setCol RETURNS LOGICAL
  ( pdCol AS DECIMAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  getFrame():Col = pdCol.
  RETURN true.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFirstLabel C-Win 
FUNCTION setFirstLabel RETURNS LOGICAL
  ( pcLabel AS CHAR  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  gcFirstlabel = pclabel.
  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFrame C-Win 
FUNCTION setFrame RETURNS LOGICAL
  ( phFrame AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  ghParent = phFrame.
  RETURN TRUE .   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setHeight C-Win 
FUNCTION setHeight RETURNS LOGICAL
  ( pdHeight AS DECIMAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes: must be called  before stuff is added 
------------------------------------------------------------------------------*/
  getFrame():SCROLLABLE = FALSE.
  getFrame():Height = pdHeight.



  RETURN true.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRow C-Win 
FUNCTION setRow RETURNS LOGICAL
  ( pdRow AS DECIMAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  getFrame():ROW = pdRow.
  RETURN true.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSecondLabel C-Win 
FUNCTION setSecondLabel RETURNS LOGICAL
  ( pcLabel AS CHAR  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  gcSecondlabel = pclabel.
  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSecondSingleOnly C-Win 
FUNCTION setSecondSingleOnly RETURNS LOGICAL
  ( plSingle AS LOG ) :
/*------------------------------------------------------------------------------
  Purpose: define that only one check box can be selected for this toggle  
    Notes: Only works for 2 currently... 2nd toggle. 
------------------------------------------------------------------------------*/
  glSingleOnly = plSingle.

  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTextWidth C-Win 
FUNCTION setTextWidth RETURNS LOGICAL
  ( pdWidth AS DECIMAL  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  gdTextWidth = pdwidth.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setWidth C-Win 
FUNCTION setWidth RETURNS LOGICAL
  ( pdWidth AS DECIMAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes: must be called  before stuff is added 
------------------------------------------------------------------------------*/
  getFrame():SCROLLABLE = FALSE.
  getFrame():width = pdWidth.
  RETURN true.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION viewHideItems C-Win 
FUNCTION viewHideItems RETURNS LOGICAL
  ( plView AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  FOR EACH ttItem:
    ASSIGN
      ttItem.txtHdl:HIDDEN = NOT plView
      ttItem.tog1Hdl:HIDDEN = NOT plView
      ttItem.tog2Hdl:HIDDEN = NOT plView
      NO-ERROR.
  END.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION viewItems C-Win 
FUNCTION viewItems RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  viewHideItems(TRUE).
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

