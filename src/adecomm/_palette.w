&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME hWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS hWin 
/***********************************************************************
* Copyright (C) 2005,2007 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*----------------------------------------------------------------------

  File: _palette.w

  Description: 
      Create a palette in a window.  This is a persistent file.

  Input Parameters:
    <none>

  Output Parameters:
    <none>

  Author: Wm. T. Wood

  Created: April 1994

  Modified:
      gfs          - rewrote to make it object-oriented and added many features
      ryan Fall 94 - added some additional methods for Tranman II
      gfs          - added display order to temp-table and methods
      gfs          - removed support for labels - added tooltips 
      gfs 1/22/98  - added SMALL-TITLE to palette window
      gfs 1/23/98  - use TOP-ONLY attr. 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
{adecomm/oeideservice.i}
{ adecomm/_adetool.i }

/* Parameters Definitions ---                                           */

/* Size of each palette item */
&Scoped-define palette_size 24
&Scoped-define palette_font 4

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE max-label-width-p AS INTEGER NO-UNDO.
DEFINE VARIABLE num-items         AS INTEGER NO-UNDO.
DEFINE VARIABLE toponly           AS LOGICAL NO-UNDO INITIAL no.
DEFINE VARIABLE phParent          AS HANDLE  NO-UNDO. /* hdl of parent proc */
DEFINE VARIABLE pcItems           AS CHAR    NO-UNDO. /* list items for palette */
DEFINE VARIABLE mHandle           AS WIDGET  NO-UNDO. /* handle for menu-item */
DEFINE VARIABLE m_Exit            AS WIDGET  NO-UNDO.
DEFINE VARIABLE hFrame            AS WIDGET  NO-UNDO. 
DEFINE VARIABLE items-row         AS INT     NO-UNDO.   
DEFINE VARIABLE palette-size      AS INT     NO-UNDO INITIAL 24.
DEFINE VARIABLE palette-font      AS INT     NO-UNDO INITIAL 4.
DEFINE VARIABLE help_file         AS CHAR    NO-UNDO.
DEFINE VARIABLE help_loc          AS HANDLE  NO-UNDO. /* proc hdl of help proc */

/* Temp-table */
DEFINE TEMP-TABLE tt
  FIELD h_btn   AS WIDGET-HANDLE
  FIELD h_lbl-1 AS WIDGET-HANDLE
  FIELD flabel  AS CHARACTER
  FIELD order   AS INTEGER
  .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW
&Scoped-define DB-AWARE no


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR hWin AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU m_File 
       MENU-ITEM m_No_Menu      LABEL "No Menu &Bar"  
       MENU-ITEM m_Top-Only_Window LABEL "&Top-Only Window"
              TOGGLE-BOX.

DEFINE MENU MENU-BAR-hWin MENUBAR
       SUB-MENU  m_File         LABEL "&File"         .

DEFINE MENU POPUP-MENU-hWin 
       MENU-ITEM m_Menu_Bar     LABEL "&Menu Bar"     .


/* Definitions of the field level widgets                               */

/* ************************  Frame Definitions  *********************** */


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: WINDOW
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW hWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Palette"
         HEIGHT             = 1.57
         WIDTH              = 20.8
         MAX-HEIGHT         = 2
         MAX-WIDTH          = 40
         VIRTUAL-HEIGHT     = 2
         VIRTUAL-WIDTH      = 40
         SMALL-TITLE        = yes
         SHOW-IN-TASKBAR    = yes
         CONTROL-BOX        = yes
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         POPUP-MENU         = MENU POPUP-MENU-hWin:HANDLE
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU MENU-BAR-hWin:HANDLE
       {&WINDOW-NAME}:POPUP-MENU = MENU POPUP-MENU-hWin:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW hWin
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(hWin)
THEN hWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME hWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL hWin hWin
ON END-ERROR OF hWin /* Palette */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE
DO:
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL hWin hWin
ON WINDOW-CLOSE OF hWin /* Palette */
DO:
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   /*RETURN NO-APPLY.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL hWin hWin
ON WINDOW-RESIZED OF hWin /* Palette */
DO:
  RUN redraw.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Menu_Bar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Menu_Bar hWin
ON CHOOSE OF MENU-ITEM m_Menu_Bar /* Menu Bar */
DO:
  /* Turn the menu-bar back on.  */
  {&WINDOW-NAME}:MENU-BAR                          = MENU menu-bar-hwin:HANDLE.
  /* Detach popup menu */
  {&WINDOW-NAME}:POPUP-MENU                        = ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_No_Menu
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_No_Menu hWin
ON CHOOSE OF MENU-ITEM m_No_Menu /* No Menu Bar */
DO:
  /* Hide the menu-bar */
  {&WINDOW-NAME}:MENU-BAR = ?.
  /* Reattach the popup menu */
  {&WINDOW-NAME}:POPUP-MENU = MENU POPUP-MENU-hWin:HANDLE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Top-Only_Window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Top-Only_Window hWin
ON VALUE-CHANGED OF MENU-ITEM m_Top-Only_Window /* Top-Only Window */
DO:
  ASSIGN hWin:TOP-ONLY = SELF:CHECKED.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK hWin 


/* ***************************  Main Block  *************************** */
/* Set current window                                           .       */
ASSIGN THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME} 
       /*CURRENT-WINDOW                = {&WINDOW-NAME}*/ .

ON CLOSE OF THIS-PROCEDURE 
   RUN destroy.

ON HELP OF hWin DO:
    IF help_file <> "" AND VALID-HANDLE(help_loc) THEN /* we have help defined */
        RUN value(help_file) IN help_loc.
    ELSE MESSAGE "No help has been defined for this palette" VIEW-AS ALERT-BOX
            INFORMATION BUTTONS OK.
END.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

/**
 * TODO EAG This code needs to be reviewed when support for embedding 4GL 
 * windows is added to core.
 */
  IF OEIDEIsRunning THEN
  DO:
    DEFINE VARIABLE iLevel          AS INTEGER NO-UNDO INITIAL 1. 
    DEFINE VARIABLE lABRunning      AS LOGICAL NO-UNDO INITIAL NO.

    /* Check if AppBuilder is running. */
    REPEAT WHILE PROGRAM-NAME(iLevel) <> ?.
      IF PROGRAM-NAME(iLevel) = "adeuib/_uibmain.p" THEN lABRunning = TRUE.
      ASSIGN iLevel = iLevel + 1.
    END.
    IF lABRunning THEN
      RUN displayWindow IN hOEIDEService ("com.openedge.pdt.oestudio.views.OEAppBuilderView", "DesignView_" + getProjectName(), hWin).
  END.   
  RUN enable_UI.
  IF NOT SESSION:WINDOW-SYSTEM BEGINS "MS-WIN" THEN 
  ASSIGN MENU-ITEM m_Top-Only_Window:SENSITIVE = no.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Add-F1-Help hWin 
PROCEDURE Add-F1-Help :
/* -----------------------------------------------------------
  Purpose:     Allows definition of a help file to be invoked
               on the HELP key.
  Parameters:  help_file (CHAR)
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER hfile AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER hloc  AS HANDLE    NO-UNDO.

  ASSIGN help_file = hfile
         help_loc  = hloc.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Add-Function hWin 
PROCEDURE Add-Function :
/* -----------------------------------------------------------
  Purpose:     Add an item to the palette
  Parameters:  pcFile (char)    
               pcImage (char)
               pcFname (char)
               perrun (log)
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcFile  AS CHARACTER. /* File name to run */
  DEFINE INPUT PARAMETER pcImage AS CHARACTER. /* Image name */
  DEFINE INPUT PARAMETER pcFname AS CHARACTER. /* Function name */
  DEFINE INPUT PARAMETER perrun  AS LOGICAL.   /* Run Persistent? */
  DEFINE INPUT PARAMETER order   AS INTEGER.   /* order of item */

  DEFINE VARIABLE fh AS WIDGET.
  DEFINE VARIABLE rc AS LOG.

  fh = hFrame.
  CREATE tt.
  ASSIGN tt.flabel = pcFname
         tt.order  = order.

  /* Make a button. */
  CREATE BUTTON tt.h_btn ASSIGN
      LABEL     = pcFname
      FONT      = palette-font
      WIDTH-P   = palette-size
      HEIGHT-P  = palette-size
      FRAME     = fh
      NO-FOCUS  = YES
      FLAT-BUTTON = YES
      TOOLTIP   = pcFname
      SENSITIVE = yes
      HIDDEN    = no
  .

  /* Some get the button file name for the item.. */
  rc = tt.h_btn:LOAD-IMAGE-UP (pcImage) NO-ERROR.

  /* Attach Triggers */  
  IF perrun THEN
    ON CHOOSE OF tt.h_btn PERSISTENT 
      RUN run-persistent IN THIS-PROCEDURE (INPUT pcFile, INPUT no, INPUT "").
  ELSE
    ON CHOOSE OF tt.h_btn PERSISTENT 
      RUN VALUE(pcFile).
  num-items = num-items + 1.
  RUN redraw.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Add-Menu-Item hWin 
PROCEDURE Add-Menu-Item :
/* -----------------------------------------------------------
  Purpose:     Add menu-item to palette
  Parameters:  mName (char)
               accel (char)
               pName (char)
               pLoc  (char)
               pHdl  (handle)
  Notes:       
-------------------------------------------------------------*/
DEFINE INPUT PARAMETER mName AS CHAR   NO-UNDO. /* menu-item name */  
DEFINE INPUT PARAMETER accel AS CHAR   NO-UNDO. /* accelerator key sequence */
DEFINE INPUT PARAMETER pName AS CHAR   NO-UNDO. /* program to run */
DEFINE INPUT PARAMETER pLoc  AS CHAR   NO-UNDO. /* Loc to run: "EXTERNAL" or "HANDLE"*/
DEFINE INPUT PARAMETER pHdl  AS HANDLE NO-UNDO. /* Handle to run in */

    CREATE MENU-ITEM mHandle
        ASSIGN parent = MENU m_File:HANDLE
               label  = mName
               accelerator = (IF accel <> "" THEN accel ELSE ""). 
    IF pLoc = "EXTERNAL" AND pName <> "" THEN
        ON CHOOSE OF mHandle PERSISTENT RUN VALUE (pName). 
    ELSE IF pLoc = "HANDLE" AND pName <> "" THEN
        ON CHOOSE OF mHandle PERSISTENT RUN VALUE (pName) IN pHdl.             
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AdjustForTB hWin 
PROCEDURE AdjustForTB :
/*------------------------------------------------------------------------------
  Purpose:     Adjusts window position if the palette is behind the taskbar
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF SESSION:WINDOW-SYSTEM BEGINS "MS-WIN":U THEN DO: 
    /* special adjustment for Win95 TaskBar */
    DEFINE VARIABLE TBOrientation AS CHARACTER NO-UNDO.
    DEFINE VARIABLE TBHeight      AS INTEGER   NO-UNDO.
    DEFINE VARIABLE TBWidth       AS INTEGER   NO-UNDO.
    DEFINE VARIABLE AutoHide      AS LOGICAL   NO-UNDO.

    RUN adeshar/_taskbar.p (OUTPUT TBOrientation, OUTPUT TBHeight,
                            OUTPUT TBWIdth,       OUTPUT AutoHide).
    IF NOT AutoHide THEN DO:
      IF TBOrientation = "LEFT":U AND hWin:X <= TBWidth THEN
        ASSIGN hWin:X = TBWidth.
      IF TBOrientation = "LEFT":U AND hWin:X <= TBWidth THEN
        ASSIGN hWin:X   = TBWidth.
      IF TBOrientation = "TOP":U THEN DO:
        IF hWin:Y <= TBHeight THEN hWin:Y = TBHeight.
        IF hWin:Y <= TBHeight   THEN hWin:Y   = TBHeight.
      END.
      IF TBOrientation = "BOTTOM" AND hWin:Y + hWin:HEIGHT-P > SESSION:HEIGHT-P - TBHeight THEN
        hWin:Y = hWin:Y - ((hWin:Y + hWin:HEIGHT-P) - (SESSION:HEIGHT-P - TBHeight)).
      IF TBOrientation = "RIGHT" AND hWin:X + hWin:WIDTH-P > SESSION:WIDTH-P - TBWidth THEN
        hWin:X = hWin:X - ((hWin:X + hWin:WIDTH-P) - (SESSION:WIDTH-P - TBWidth)).
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Build-Menubar hWin 
PROCEDURE Build-Menubar :
/* -----------------------------------------------------------
  Purpose:     Add RULE and Exit to the end of the menubar.
  Parameters:  <none>
  Notes:       This assumes that the other menu-items have 
               already been added via the Add-Menu-Item fcn.
-------------------------------------------------------------*/
  DEFINE VARIABLE RuleLine AS WIDGET.
  CREATE MENU-ITEM RuleLine
      ASSIGN SUBTYPE = "RULE":U
             PARENT  = MENU m_File:HANDLE.

  CREATE MENU-ITEM m_Exit
      ASSIGN parent = MENU m_File:HANDLE
             label  = "E&xit"
             TRIGGERS:
                 ON CHOOSE PERSISTENT RUN destroy IN THIS-PROCEDURE.  
             END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Delete-Function hWin 
PROCEDURE Delete-Function :
/* -----------------------------------------------------------
  Purpose:     Delete an item from the palette
  Parameters:  dlabel (char)
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER dlabel AS CHARACTER. /* feature to delete*/
  FIND tt WHERE tt.flabel = dlabel NO-ERROR.
  IF AVAILABLE (tt) THEN DO:
      DELETE WIDGET tt.h_btn.
      DELETE tt.
  END.
  ASSIGN num-items = num-items - 1.
  RUN redraw.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Destroy hWin 
PROCEDURE Destroy :
/* --------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
   -------------------------------------------------------------------- */
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U THEN DELETE WIDGET hWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
  IF VALID-HANDLE(phParent) THEN APPLY "CLOSE" TO phParent.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Enable_UI hWin  _DEFAULT-ENABLE
PROCEDURE Enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Get-Items-Per-Row hWin 
PROCEDURE Get-Items-Per-Row :
/* -----------------------------------------------------------
  Purpose:     To get the number of items per row in the
               palette.
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER items-per-row AS INTEGER NO-UNDO.
  DEFINE VARIABLE item-width-p          AS INTEGER NO-UNDO.

  ASSIGN item-width-p  = palette-size
         items-per-row = 
        TRUNCATE (({&WINDOW-NAME}:WIDTH-P / item-width-p) + 0.33 , 0).  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Get-Location hWin 
PROCEDURE Get-Location :
/* -----------------------------------------------------------
  Purpose:     To query location of PRO*Tools palette
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER px AS INTEGER NO-UNDO.
  DEFINE OUTPUT PARAMETER py AS INTEGER NO-UNDO.

  ASSIGN px = hWin:x
         py = hWin:y.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Realize hWin 
PROCEDURE Realize :
/* -----------------------------------------------------------
  Purpose:     create a visualization of a palette
  Parameters:  px (int)             x location
               py (int)             y location
               items-per-row (int)  
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER px AS INTEGER            NO-UNDO.
  DEFINE INPUT PARAMETER py AS INTEGER            NO-UNDO.
  DEFINE INPUT PARAMETER items-per-row AS INTEGER NO-UNDO.

  DEF VAR ch AS CHAR         NO-UNDO.
  DEF VAR iX AS INTEGER      NO-UNDO.
  DEF VAR iY AS INTEGER      NO-UNDO.
  DEF VAR o  AS INTEGER      NO-UNDO.

  DEF VAR i  AS INTEGER      NO-UNDO.

  DEF VAR lResult AS LOGICAL NO-UNDO.

  DEF VAR cItem  AS CHAR     NO-UNDO.
  DEF VAR cFile  AS CHAR     NO-UNDO.
  DEF VAR pHdl   AS HANDLE   NO-UNDO.
  DEF VAR pName  AS LOGICAL  NO-UNDO.

  DEF VAR h      AS WIDGET   NO-UNDO.

  IF px <> ? AND py <> ? THEN 
      RUN Set-Location (INPUT px, INPUT py).

  /* Create a frame to store the graph (in the current window). */
  CREATE FRAME hFrame ASSIGN 
    BOX = NO  
    WIDTH = 1
    HEIGHT = 1 
    THREE-D = YES  
    .  

  /* Walk the members of the Palette and show them.*/     
  num-items = NUM-ENTRIES(pcItems, chr(10)).
  DO i = 1 to num-items:
    ASSIGN cItem = ENTRY(i, pcItems, chr(10))
           cFile = ENTRY(3, cItem)     /* icon file */
           ch    = ENTRY(4,cItem)      /* Label */ 
           o     = INT(ENTRY(7,cItem)) /* order */
           .
    /* Store palette items in a temp-table */
    CREATE tt.
    ASSIGN tt.flabel = ch
           tt.order  = o.

    /* Make a button. */
    CREATE BUTTON tt.h_btn ASSIGN
          LABEL       = ch
          FONT        = palette-font
          X           = iX
          Y           = iY
          WIDTH-P     =  palette-size
          HEIGHT-P    = palette-size
          AUTO-RESIZE = NO
&IF "{&OPSYS}" = "WIN32"               AND
    "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
          TOOLTIP     = ch
          NO-FOCUS    = YES
          FLAT-BUTTON = YES
&ENDIF
          .
    /* Make sure the frame will hold the buttons, and show them. */
    ASSIGN h = tt.h_btn
           hFrame:WIDTH-P  = MAX(hFrame:WIDTH-P, h:X + h:WIDTH-P)
           hFrame:HEIGHT-P = MAX(hFrame:HEIGHT-P, h:Y + h:HEIGHT-P)
           h:FRAME = hFrame   
           h:SENSITIVE = YES
           h:HIDDEN = NO
           iX = iX + h:WIDTH-P
           .
    /* Some get the button file name for the item.. */
    lResult = h:LOAD-IMAGE-UP (cFile) NO-ERROR.

    /* Attach Triggers */
    cFile = ENTRY(2, cItem).  /* File name to run */
    IF cFile ne "" THEN DO:
      ASSIGN pName = IF ENTRY(6, cItem) = "yes" then yes else no. /* pass Name of function selected? y/n */
      /* Base run on the type: RUN, FLO, PERSISTENT or HANDLE */
      CASE SUBSTRING(cItem,1,3, "CHARACTER":U):
        WHEN "FLO" THEN
          ON CHOOSE OF tt.h_btn PERSISTENT RUN run-flo IN THIS-PROCEDURE (cFile).
        WHEN "PER" THEN
          ON CHOOSE OF tt.h_btn PERSISTENT RUN run-persistent IN THIS-PROCEDURE (INPUT cFile, INPUT pName, INPUT ch) . 
        WHEN "HAN" THEN DO:  
          ASSIGN pHdl  = WIDGET-HANDLE(ENTRY(5, cItem)).  /* Handle of procedure */
          IF pName THEN       
            ON CHOOSE OF tt.h_btn PERSISTENT RUN VALUE(cfile) IN pHdl (INPUT ch).
          ELSE
            ON CHOOSE OF tt.h_btn PERSISTENT RUN VALUE(cfile) IN pHdl.
        END.
        OTHERWISE  /* Run regularly */
          IF pName THEN
            ON CHOOSE OF tt.h_btn PERSISTENT RUN VALUE (cFile) (INPUT ch).
          ELSE
            ON CHOOSE OF tt.h_btn PERSISTENT RUN VALUE (cFile).
      END CASE.
    END.

    /* Start a new row, (maybe). */
    IF iX >= items-per-row * h:WIDTH-P 
    THEN ASSIGN iX = 0 iY = h:Y + h:HEIGHT-P.

  END. /* DO WHILE valid next object */

  /* Set the window size to the frame size. */
  ASSIGN hWin:WIDTH        = hFrame:WIDTH
         hWin:HEIGHT       = hFRAME:HEIGHT 
         hFrame:PARENT     = hWin
         items-row         = 0
         .
  
  /* Adjust position of palette window if off the screen. */
  IF hWin:X + hWin:WIDTH-P > SESSION:WIDTH-P THEN 
  hWin:X = MAX(0,SESSION:WIDTH-P - hWin:WIDTH-P).
  ELSE IF hWin:X < 0 THEN hWin:X = 0.
  IF hWin:Y + hWin:HEIGHT-P > SESSION:HEIGHT-P THEN
    hWin:Y = MAX(0,SESSION:HEIGHT-P - hWin:HEIGHT-P).
  ELSE IF hWin:Y < 0 THEN hWin:Y = 0.

  /* Adjust for Windows 95 taskbar if necessary */
  RUN AdjustForTB.

  /* Make the palette window visible */
  ASSIGN hWin:HIDDEN   = no
         hFrame:HIDDEN = no. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Redraw hWin 
PROCEDURE Redraw :
/* -----------------------------------------------------------
  Purpose:     Resize the palette incrementally in terms of 
               the contained palette-items.
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE VAR border-pixels AS INTEGER NO-UNDO.
  DEFINE VAR item-width-p  AS INTEGER NO-UNDO.
  DEFINE VAR item-height-p AS INTEGER NO-UNDO.
  DEFINE VAR i             AS INTEGER NO-UNDO.
  DEFINE VAR items_per_row AS INTEGER NO-UNDO.
  DEFINE VAR iRow          AS INTEGER NO-UNDO.
  DEFINE VAR iCol          AS INTEGER NO-UNDO.
  DEFINE VAR num_rows      AS INTEGER NO-UNDO.

  ASSIGN item-width-p  = palette-size
         item-height-p = palette-size
         .

  /* Get the window size in items_per_row.  Round this to a nice number.
     NOTE: Add a little to the width in case the user is close the next integer
     number of rows.  */
  /*items_per_row = TRUNCATE (({&WINDOW-NAME}:WIDTH-P / item-width-p) + 0.33 , 0).  
   */
    if items-row > 0 then do:
        items_per_row = items-row.
        items-row = 0.
    end.
    else items_per_row = MAX(1,TRUNCATE (({&WINDOW-NAME}:WIDTH-P / item-width-p) + 0.33 , 0)).
  /* How many rows do we now need? */
  num_rows = num-items / items_per_row.
  /* Note: this division could truncate inappropriately, so add 1 if we need to */
  IF num_rows * items_per_row < num-items THEN num_rows = num_rows + 1.

  &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
  /* WTW: all MS WIndows have a minimum width (because we cannot get rid of
     the icons on the title-bar). This deals with this.
     NOTE that the multiplier "9" is a guesstimate - not a known constant. 
     */
  IF item-width-p * items_per_row < ( 9 * SESSION:PIXELS-PER-COLUMN)
  THEN border-pixels = (( 9 * SESSION:PIXELS-PER-COLUMN) - 
                       (item-width-p * items_per_row)) / 2.
  &ENDIF

  /* Hide the window, "Maximize" it and the contained frame,
     then reposition the contained buttons. */
  ASSIGN 
       {&WINDOW-NAME}:HIDDEN = YES
       /*hframe = {&WINDOW-NAME}:FIRST-CHILD*/
       hframe:SCROLLABLE = YES
       hframe:VIRTUAL-WIDTH-P  = MAX (hframe:VIRTUAL-WIDTH-P, 
                                      border-pixels + (items_per_row * item-width-p))
       hframe:VIRTUAL-HEIGHT-P = MAX (hframe:VIRTUAL-HEIGHT-P, 
                                      border-pixels + (num_rows * item-height-p))
       .

/* Walk through the temp-tables of items in the palette.  */
ASSIGN i = 0.
FOR EACH tt BY order:
  ASSIGN i    = i + 1
         iRow = TRUNCATE((i - 1) / items_per_row, 0)  /* 0 based */
         iCol = i - (items_per_row * iRow) - 1        /* 0 based */
         tt.h_btn:X = border-pixels +
                      (iCol * item-width-p) +
                      (item-width-p - palette-size) / 2
         tt.h_btn:Y = border-pixels + (iRow * item-height-p)
         . 
END. 

  /* Show the window. Set the window size "correctly". */
  ASSIGN
       {&WINDOW-NAME}:MAX-HEIGHT-P = MIN(SESSION:HEIGHT-P, 
                                         num-items * item-height-p + (2 * border-pixels))
       {&WINDOW-NAME}:MAX-WIDTH-P  = MIN(SESSION:WIDTH-P, 
                                         num-items * item-width-p + (2 * border-pixels))
       {&WINDOW-NAME}:WIDTH-P  = (items_per_row * item-width-p) + (2 * border-pixels)
       {&WINDOW-NAME}:HEIGHT-P = (num_rows * item-height-p) + (2 * border-pixels)
       hframe:SCROLLABLE = NO
       hframe:WIDTH-P = {&WINDOW-NAME}:WIDTH-P
       hframe:HEIGHT-P = {&WINDOW-NAME}:HEIGHT-P
       .
       
  /* If the window is MAXIMIZED, set the maximum height of the window to the actual height.
     This avoids a bug where the window is HIDDEN and VIEWED.  Under Windows, this would
     cause the window to change sizes. */
  IF {&WINDOW-NAME}:WINDOW-STATE = WINDOW-MAXIMIZED THEN DO:
    {&WINDOW-NAME}:MAX-HEIGHT = {&WINDOW-NAME}:HEIGHT. 
  END.

  /* View the window */
  {&WINDOW-NAME}:HIDDEN = NO.
  IF {&WINDOW-NAME}:MOVE-TO-TOP() THEN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Run-Persistent hWin 
PROCEDURE Run-Persistent :
/* -----------------------------------------------------------
  Purpose:     runs a file persistently   
  Parameters:  pcFile - name of thing to run
               pName  - pass Name? y/n
               fName  - function name 
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcFile AS CHAR NO-UNDO.
  DEFINE INPUT PARAMETER pName  AS LOG  NO-UNDO.
  DEFINE INPUT PARAMETER fName  AS CHAR NO-UNDO.
  DEFINE VARIABLE hProc         AS HANDLE     NO-UNDO.

  IF SEARCH(pcFile) eq ? AND 
    SEARCH(SUBSTRING(pcFile,1,(LENGTH(pcFile,"CHARACTER":u) - 2),
                     "CHARACTER":u) + ".r") EQ ?
  THEN MESSAGE pcFile "not found." VIEW-AS ALERT-BOX ERROR.
  ELSE
  DO ON STOP UNDO, LEAVE:
    IF pName THEN
        RUN VALUE(pcFile) PERSISTENT SET hProc (INPUT fName).
    ELSE
        RUN VALUE(pcFile) PERSISTENT SET hProc.
    RUN initializeObject IN hProc NO-ERROR.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Set-Button-Size hWin 
PROCEDURE Set-Button-Size :
/* -----------------------------------------------------------
  Purpose:     Set button size
  Parameters:  bSize (int)
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER bSize AS INT NO-UNDO.

  IF bSize > 0 THEN ASSIGN palette-size = bSize.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Set-Hide-Palette hWin 
PROCEDURE Set-Hide-Palette :
/* -----------------------------------------------------------
  Purpose:     Hides the palette so that it doesn't have to be recreated 
               each time it is invoked.
  Parameters:  pResult
  Notes:       Created by R. Ryan 11/1/94
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pResult AS LOGICAL NO-UNDO.
  {&window-name}:HIDDEN = pResult.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Set-Items hWin 
PROCEDURE Set-Items :
/* -----------------------------------------------------------
  Purpose:     Set items on the palette
  Parameters:  item-list (char)
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER item-list AS CHAR NO-UNDO.
  ASSIGN pcItems = item-list.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Set-Label-Font hWin 
PROCEDURE Set-Label-Font :
/* -----------------------------------------------------------
  Purpose:     Set font of labels in the palette
  Parameters:  lFont (int)
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER lFont AS INTEGER NO-UNDO.

  IF lFont >= 0 THEN ASSIGN palette-font = lFont.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Set-Location hWin 
PROCEDURE Set-Location :
/* -----------------------------------------------------------
  Purpose:     To set location of PRO*Tools palette
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER px AS INTEGER NO-UNDO.
  DEFINE INPUT PARAMETER py AS INTEGER NO-UNDO.

  ASSIGN
      hWin:x = px
      hWin:y = py.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Set-Menu hWin 
PROCEDURE Set-Menu :
/* -----------------------------------------------------------
  Purpose:     Sets menubar on or off in the palette
  Parameters:  switch (log)
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER switch AS LOGICAL NO-UNDO.

  RUN Build-Menubar.
  IF switch THEN DO: /* switch menu on */
      ASSIGN {&WINDOW-NAME}:MENU-BAR   = MENU menu-bar-hwin:HANDLE
             {&WINDOW-NAME}:POPUP-MENU = ?.
  END.
  ELSE 
    ASSIGN {&WINDOW-NAME}:MENU-BAR   = ?
           {&WINDOW-NAME}:POPUP-MENU = MENU POPUP-MENU-hWin:HANDLE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Set-Parent hWin 
PROCEDURE Set-Parent :
/* -----------------------------------------------------------
  Purpose:     Sets the parent of the palette
  Parameters:  hdl (proc handle)
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER hdl AS HANDLE NO-UNDO.
  ASSIGN phParent = hdl.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Set-Popup hWin 
PROCEDURE Set-Popup :
/* -----------------------------------------------------------
  Purpose:     Sets/Eliminates the popup menu from the right mouse button
  Parameters:  Result (logical)
  Notes:       Created by R. Ryan 11/1/94
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pResult AS LOGICAL NO-UNDO.
  IF pResult THEN 
    ASSIGN hWin:popup-menu = MENU POPUP-MENU-hWin:HANDLE. 
  ELSE 
    ASSIGN hWin:popup-menu = ?. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Set-Title hWin 
PROCEDURE Set-Title :
/* -----------------------------------------------------------
  Purpose:     Set TITLE of palette window
  Parameters:  pcTitle (char)
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcTitle AS CHARACTER INITIAL ?.
  IF pcTitle NE ? THEN {&WINDOW-NAME}:TITLE = pcTitle.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Set-Top-Only hWin 
PROCEDURE Set-Top-Only :
/* -----------------------------------------------------------
  Purpose:     Set top-only property
  Parameters:  Result (logical)
  Notes:       Created by R. Ryan 11/1/94
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pResult AS LOGICAL NO-UNDO.
  DEFINE VARIABLE rc AS INTEGER NO-UNDO.
  IF pResult THEN DO:
    ASSIGN 
      MENU-ITEM m_top-only_Window:CHECKED IN MENU m_File = True
      toponly                                            = True.

    RUN adecomm/_topmost.p (INPUT hWin:hWnd, INPUT yes, OUTPUT rc).
  END.

  ELSE ASSIGN  
    MENU-ITEM m_top-only_Window:CHECKED IN MENU m_File = False
    toponly                                            = False.       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Set-Window-Icon hWin 
PROCEDURE Set-Window-Icon :
/* -----------------------------------------------------------
  Purpose:     Specify icon for palette window
  Parameters:  iName (char)
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER iName AS CHAR    NO-UNDO.
  DEFINE VARIABLE log          AS LOGICAL NO-UNDO.

  ASSIGN FILE-INFO:FILE-NAME = iName NO-ERROR.
  IF ( FILE-INFO:FULL-PATHNAME NE ? ) THEN DO:
    ASSIGN log = hWin:LOAD-ICON(FILE-INFO:FULL-PATHNAME).
  END.
  ELSE 
      MESSAGE "Could not load palette image." VIEW-AS 
          ALERT-BOX WARNING BUTTONS OK.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Swap_Order hWin 
PROCEDURE Swap_Order :
/* -----------------------------------------------------------
  Purpose:     swaps the order of two items and redraws palette
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcFname1 AS CHARACTER NO-UNDO. /* Function name1 */
  DEFINE INPUT PARAMETER pcFname2 AS CHARACTER NO-UNDO. /* Function name2 */
  DEFINE VARIABLE torder          AS INTEGER   NO-UNDO.
  DEFINE BUFFER tt1 FOR tt.
  DEFINE BUFFER tt2 FOR tt.

  FIND tt1 WHERE tt1.flabel = pcFname1 NO-ERROR.
  IF AVAILABLE (tt1) THEN DO:
      FIND tt2 WHERE tt2.flabel = pcFname2 NO-ERROR.
      IF AVAILABLE (tt2) THEN DO:
          ASSIGN torder    = tt1.order
                 tt1.order = tt2.order
                 tt2.order = torder.  
      END.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Update-Function hWin 
PROCEDURE Update-Function :
/* ---------------------------------------------------------------
  Purpose:     Updates a function currently defined in the palette
  Parameters:  pcFile (char)    
               pcImage (char)
               pcFname (char)
               perrun (log)  
               oldname (char)
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcFile  AS CHARACTER NO-UNDO. /* File name to run */
  DEFINE INPUT PARAMETER pcImage AS CHARACTER NO-UNDO. /* Image name */
  DEFINE INPUT PARAMETER pcFname AS CHARACTER NO-UNDO. /* Function name */
  DEFINE INPUT PARAMETER perrun  AS LOGICAL   NO-UNDO. /* Run Persistent? */
  DEFINE INPUT PARAMETER oldname AS CHARACTER NO-UNDO. /* original name */

  DEFINE VARIABLE fh AS WIDGET.
  DEFINE VARIABLE rc AS LOG.

  fh = hFrame.
  FIND tt WHERE tt.flabel = oldname NO-ERROR.
  IF AVAILABLE (tt) THEN DO:

      ASSIGN tt.flabel               = pcFname  
             tt.h_btn:LABEL          = pcFname
&IF "{&OPSYS}" = "WIN32"               AND
    "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
             tt.h_btn:TOOLTIP        = pcFname
&ENDIF
      .

      /* Some get the button file name for the item.. */
      rc = tt.h_btn:LOAD-IMAGE-UP (pcImage) NO-ERROR.

      /* Attach Triggers */  
      IF perrun THEN
          ON CHOOSE OF tt.h_btn PERSISTENT 
            RUN run-persistent IN THIS-PROCEDURE (INPUT pcFile, INPUT no, INPUT "").
      ELSE
          ON CHOOSE OF tt.h_btn PERSISTENT RUN VALUE(pcFile).
      RUN redraw.
  END.
  ELSE MESSAGE "Could not update Applet: " oldname VIEW-AS ALERT-BOX ERROR BUTTONS OK.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

