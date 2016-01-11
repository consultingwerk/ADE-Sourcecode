&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame

/* User Field definitions                                              */
DEFINE VARIABLe xyz as char.
DEFINE VARIABLe zzz as char.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
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

File: adeweb/_htmlcol.w

Description: Pick colors for HTML .    
             To be able to edit the custom color without disturbing the colors
             in use this procedure uses a temporarily created ini file.  
              
Input Parameters:
      pMode = "PAGE" or "TABLE"        
           
Input-Output Parameters:
      pRed          Red Value     (COLOR-TABLE:GET-RED-VALUE(n))
      pGreen        Green value   (COLOR-TABLE:GET-GREEN-VALUE(n))
      pBlue         Blue Value    (COLOR-TABLE:GET-BLUE-VALUE(n))
      pDefaultRed   Red value for the default color
      pDefaultGreen Green value for the default color
      pDefaultBlue  Blue  value for the default color


Author : Haavard Danielsen 
Created: June 98

Note:    The procedure creates its own Color-table, but copies the values 
         from the 15 first colors in the current.  It also needs to copy 
         the font-table so font definitions are valid.  All fonts become 
         default, even if they are PUT-KEYed to the new .ini file and 
         loaded again.       
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBulder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
{ adeuib/uibhlp.i }
/* Parameters Definitions ---                                           */
  &IF DEFINED(UIB_is_Running) = 0 &THEN
DEFINE INPUT        PARAMETER pMode  AS CHAR NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pRed   AS INT  NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pGreen AS INT  NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pBlue  AS INT  NO-UNDO.
DEFINE INPUT        PARAMETER pRedDefault   AS INT  NO-UNDO.
DEFINE INPUT        PARAMETER pGreenDefault AS INT  NO-UNDO.
DEFINE INPUT        PARAMETER pBlueDefault  AS INT  NO-UNDO.
  &ELSE
DEFINE VAR pMode  AS CHAR init "page" NO-UNDO.
DEFINE VAR pRed   AS INT  NO-UNDO.
DEFINE VAR pGreen AS INT  NO-UNDO.
DEFINE VAR pBlue  AS INT  NO-UNDO.
DEFINE VAR pRedDefault   AS INT INIT 123 NO-UNDO.
DEFINE VAR pGreenDefault AS INT INIT 0 NO-UNDO.
DEFINE VAR pBlueDefault  AS INT INIT 15 NO-UNDO.
pred = random(1,255).  
pgreen = random(1,224).  
pblue = random(1,233).  
  &ENDIF
/* Local Variable Definitions ---                                       */

DEFINE VARIABLE hWindow       AS HANDLE NO-UNDO.
DEFINE VARIABLE gNumFonts     AS INT NO-UNDO.
DEFINE VARIABLE gNumColors    AS INT NO-UNDO.
DEFINE VARIABLE gSelected     AS Handle NO-UNDO.
DEFINE VARIABLE gFirstRectHdl AS Handle NO-UNDO.
DEFINE VARIABLE gLastRectHdl  AS Handle NO-UNDO.
DEFINE VARIABLE gSelectHdl    AS Handle NO-UNDO.
DEFINE VARIABLE gCustBtnHdl   AS Handle NO-UNDO.

DEFINE VARIABLE iHelpContext  AS INT    NO-UNDO.

DEFINE VARIABLE gTempIni      AS CHAR   NO-UNDO.

DEFINE VARIABLE xRectWidth  AS DEC   INIT 12   NO-UNDO.
DEFINE VARIABLE xRectHeight AS DEC   INIT 0.7    NO-UNDO.
DEFINE VARIABLE xNumRows    AS INT   INIT 23   NO-UNDO.
DEFINE VARIABLE xMargin     AS DEC   INIT 0.20 NO-UNDO.
DEFINE VARIABLE xCol        AS DEC   INIT 3    NO-UNDO.
DEFINE VARIABLE xRow        AS DEC   INIT 1.64 NO-UNDO.
            
DEFINE TEMP-TABLE tFont 
  FIELD Num       AS INT
  FIELD FontValue AS CHAR.
  
DEFINE TEMP-TABLE tColor 
 FIELD Hdl    AS HANDLE
 FIELD Num    AS INT 
 FIELD Red    AS INT 
 FIELD Green  AS INT 
 FIELD Blue   AS INT
 FIELD TextHdl AS HANDLE
 FIELD Custom As LOGICAL
 INDEX Tsort AS PRIMARY 
            Custom 
            Green DESCENDING            
            Red DESCENDING 
            Blue DESCENDING
 INDEX TCol Green            
            Red 
            Blue 
 INDEX Hdl Hdl.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BtnOK BtnCancel BtnHelp 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD ColorText Dialog-Frame 
FUNCTION ColorText RETURNS CHARACTER
  (pRed   AS INT,
   PGreen AS INT,
   pBlue  AS INT) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD MoveBackWard Dialog-Frame 
FUNCTION MoveBackWard RETURNS LOGICAL
  ( ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD MoveForward Dialog-Frame 
FUNCTION MoveForward RETURNS LOGICAL
  ( ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnCancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON BtnHelp 
     LABEL "&Help" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON BtnOK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     BtnOK AT ROW 1.52 COL 32
     BtnCancel AT ROW 2.67 COL 32
     BtnHelp AT ROW 4.76 COL 32
     SPACE(1.19) SKIP(9.76)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "<insert dialog title>"
         DEFAULT-BUTTON BtnOK CANCEL-BUTTON BtnCancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
   User-Fields:
           DEFINE VARIABLe xyz as char.
           DEFINE VARIABLe zzz as char.
   END-USER-FIELDS.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   NOT-VISIBLE                                                          */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON TAB OF FRAME Dialog-Frame /* <insert dialog title> */
DO:
  MoveForward().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* <insert dialog title> */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnHelp Dialog-Frame
ON CHOOSE OF BtnHelp IN FRAME Dialog-Frame /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  
  RUN adecomm/_adehelp.p ("AB":U, "CONTEXT":U, iHelpcontext, ?). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

Run ReadDefaults.

RUN adecomm/_tmpfile.p ("tmp", ".ws", OUTPUT gTempIni).

CASE pMode :
 
 WHEN "TABLE":U THEN
  ASSIGN 
    iHelpContext = {&Select_Table_Background_Color}     
    FRAME {&FRAME-NAME}:TITLE = "Select Table Background Color".
 WHEN "PAGE":U THEN
  ASSIGN 
    iHelpContext = {&Select_Page_Background_Color}     
    FRAME {&FRAME-NAME}:TITLE = "Select Page Background Color".
     
END.

LOAD gTempIni NEW BASE-KEY "ini":U.
USE gTempIni.

Run SetDefaults.
 
LOAD gTempIni BASE-KEY "ini":U. 
USE gTempIni.
 
CREATE WINDOW hWindow
  ASSIGN Hidden = TRUE.

CURRENT-WINDOW = hWindow.

/* Parent the dialog-box to the dummy-WINDOW   */
FRAME {&FRAME-NAME}:PARENT  = hWINDOW.

ON CURSOR-DOWN, CURSOR-RIGHT OF FRAME {&FRAME-NAME} ANYWHERE DO:
  MoveForward().
END.
ON CURSOR-UP, CURSOR-LEFT OF FRAME {&FRAME-NAME} ANYWHERE DO:
  MoveBackWard().
END.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN initObject.
 
  /*
   Note: No VIEW frame .. statement in enable_UI! 
   assigning attribute with no-error instead.
   This is a work around for RECTANGLE does not fit error on some resolutions. */
  
  RUN enable_UI.
  ASSIGN frame {&FRAME-NAME}:VISIBLE = TRUE NO-ERROR.   
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
  
  FIND tColor WHERE tColor.Hdl = gSelected No-ERROR.
  IF AVAIL tColor THEN
    ASSIGN 
      pRed   = tColor.Red
      pGreen = tColor.Green
      pBlue  = tColor.Blue.

END.
RUN disable_UI.

USE "".

OS-DELETE  VALUE(gTempINI).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CreateColorRect Dialog-Frame 
PROCEDURE CreateColorRect :
/*------------------------------------------------------------------------------
  Purpose:    Create rectangle and text for a selectable color  
  Parameters: pBgCol - the color number
              pRow   - The Row to put the rectangle
              pCol   - The Col to put the rectangle.
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER pBGCol  AS INT  NO-UNDO.
  DEF INPUT PARAMETER pRow    AS DEC  NO-UNDO.
  DEF INPUT PARAMETER pCol    AS DEC  NO-UNDO.
  
  DEFINE BUFFER tDefault  FOR tColor.
  
  DEF VAR Hdl AS HANDLE NO-UNDO.
  
  FIND tColor WHERE tColor.NUM = pBgCol No-ERROR.
  
  CREATE RECTANGLE Hdl
    ASSIGN 
      FRAME        = FRAME {&FRAME-NAME}:HANDLE
      Col          = pCol
      Row          = pRow
      BGCOLOR      = pBgcol
      HEIGHT       = xRectHeight
      WIDTH        = xRectWidth
      SENSITIVE    = YES
      EDGE-PIXELS  = 1
      FILLED       = YES      
  TRIGGERS:
    ON MOUSE-SELECT-DOWN     PERSISTENT RUN SetSelected(Hdl).  
    ON MOUSE-SELECT-DBLCLICK PERSISTENT RUN CustomColor(Hdl).  
  END.
  
  ASSIGN tColor.Hdl = Hdl.
  
  IF NOT VALID-HANDLE(gFirstRectHdl) THEN
    ASSIGN gFirstRectHdl = Hdl. 
    
  ASSIGN gLastRectHdl = HDL.       
  
  CREATE TEXT tColor.textHdl
    ASSIGN 
      FRAME        = FRAME {&FRAME-NAME}:HANDLE
      Col          = tColor.Hdl:COL + Hdl:WIDTH + 0.5  
      Row          = tColor.Hdl:ROW
      HEIGHT       = xRectHeight
      WIDTH        = xRectWidth
      SENSITIVE    = YES
      FORMAT       = "X(20)":U
      SCREEN-VALUE = ColorText(tColor.Red,tColor.Green,tcolor.BLUE) 
  TRIGGERS:
    ON MOUSE-SELECT-DOWN     PERSISTENT RUN SetSelected(Hdl).  
    ON MOUSE-SELECT-DBLCLICK PERSISTENT RUN CustomColor(Hdl).  
  END.
       
  IF TColor.Custom THEN 
  DO:
    CREATE Button gCustBtnHdl
     ASSIGN
      FRAME        = FRAME {&FRAME-NAME}:HANDLE
      WIDTH        = 3
      Col          = tColor.TextHdl:COL 
                     + tColor.textHdl:Width
                     - gCustBtnHdl:WIDTH                   
      Row          = tColor.Hdl:ROW
      HEIGHT       = xRectHeight
      SENSITIVE    = YES
      HIDDEN       = TRUE
      LABEL        = "..."
    TRIGGERS:
      ON CHOOSE PERSISTENT RUN CustomColor(Hdl).  
    END.
    gCustBtnHdl:MOVE-TO-TOP().
  END.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CustomColor Dialog-Frame 
PROCEDURE CustomColor :
/*------------------------------------------------------------------------------
  Purpose:    Run the system dialog to pick a custom color. 
  Parameters: pHdl - Handle of the RECTANGLE.
  Notes:      Called persistently from double click of the dynamic rectangles 
              or text.   
------------------------------------------------------------------------------*/
   DEF INPUT PARAMETER pHdl As HANDLE. 
   
   FIND tColor WHERE tColor.Hdl = pHdl NO-ERROR.
   IF tColor.custom THEN
   DO:
     SYSTEM-DIALOG COLOR tColor.num.
     ASSIGN 
      tColor.Red   = COLOR-TABLE:GET-RED-VALUE(tColor.NUM) 
      tColor.Green = COLOR-TABLE:GET-GREEN-VALUE(tColor.NUM) 
      tColor.Blue  = COLOR-TABLE:GET-BLUE-VALUE(tColor.NUM). 
     ASSIGN
      tColor.TexTHdl:SCREEN-VALUE = ColorText(Red,Green,BLUE). 
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame  _DEFAULT-DISABLE
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
  HIDE FRAME Dialog-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame  _DEFAULT-ENABLE
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
  ENABLE BtnOK BtnCancel BtnHelp 
      WITH FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initObject Dialog-Frame 
PROCEDURE initObject :
/*------------------------------------------------------------------------------
  Purpose:   Loop thru the colors and call the function to create 
             the rectangle and text dynamicly.
             Find the color that corresponds to the input parameters of 
             the procedure or find the first color and set that to selected.      
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR NextRow AS DEC   NO-UNDO.
  DEF VAR NextCol AS DEC   NO-UNDO.
  DEF VAR MaxRow  AS DEC   NO-UNDO.
  DEF VAR MaxCol  AS DEC   NO-UNDO.
  DEF VAR NumRow  AS INT   NO-UNDO.
   
  ASSIGN 
    NextCol = xCol
    NextRow = xRow.
 
  /* Set the color for the default color */
  COLOR-TABLE:SET-RED-VALUE(0,pRedDefault). 
  COLOR-TABLE:SET-GREEN-VALUE(0,pGreenDefault). 
  COLOR-TABLE:SET-BLUE-VALUE(0,pBlueDefault). 
 
  FOR EACH TColor:
    RUN CreateColorRect (tColor.Num,NextRow,NextCol).
    
    ASSIGN 
      NextRow = NextRow + xRectHeight + xMargin
      NumRow  = NumRow + 1.
       
    IF Numrow = xNumRows THEN
      ASSIGN 
        NextRow = xRow
        NextCol = NextCol + xRectWidth
        NumRow  = 0.
        
    ASSIGN    
      MaxRow = NextRow
      MaxCol = MaxCol.
  END. /* for each tcolor */

  IF MaxRow > Frame {&FRAME-NAME}:HEIGHT THEN
    Frame {&FRAME-NAME}:HEIGHT =  MaXRow 
                                  + Frame {&FRAME-NAME}:BORDER-BOTTOM-CHARS.
       
  FIND TColor WHERE tColor.Red   = pRed 
              AND   tColor.Green = pGreen  
              AND   tColor.Blue  = pBlue NO-ERROR.  
  
  IF NOT AVAIL tColor THEN 
  DO:
    FIND FIRST tColor WHERE tColor.Custom = TRUE.
    ASSIGN 
      tColor.Red   = pRed
      tColor.Green = pGreen
      tColor.Blue  = pBlue.
       
    COLOR-TABLE:SET-RED-VALUE(tColor.Num,tColor.Red). 
    COLOR-TABLE:SET-GREEN-VALUE(tColor.Num,tColor.Green). 
    COLOR-TABLE:SET-BLUE-VALUE(tColor.Num,tColor.blue). 
   
    tColor.TexTHdl:SCREEN-VALUE = ColorText(Red,Green,BLUE). 
  END.                   
  
  RUN SetSelected(tColor.Hdl).    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ReadDefaults Dialog-Frame 
PROCEDURE ReadDefaults :
/*------------------------------------------------------------------------------
  Purpose:    Read the default fonts and colors and create temp-table 
              tFonts and tColor.
  Parameters: 
  Notes:         
------------------------------------------------------------------------------*/


DEF VAR i AS INTEGER NO-UNDO.
  
  DO i = 0 to FONT-TABLE:NUM-ENTRIES - 1:
    CREATE tFont.
    ASSIGN 
      tFont.Num  = i
      gNumFonts  = gNumFonts + 1.
    GET-KEY-VALUE SECTION "FONTS" 
                  KEY "FONT" + STRING(i) 
                  VALUE tFont.FOntVAlue.
  END.
  /* Default */
  Create TColor.
  ASSIGN
    tColor.Num = 0 
    Red        = ?
    Green      = ?
    Blue       = ?.
 
  DO i = 0 to MIN(COLOR-TABLE:NUM-ENTRIES - 1,15):
    CREATE tColor.
    ASSIGN  
      tColor.Num   = i + 1 /* The entries in the new color-table: starts on 1 ! */
      gNumColors   = gNumColors + 1 
      Red   = COLOR-TABLE:GET-RED-VALUE(i)
      Green = COLOR-TABLE:GET-GREEN-VALUE(i)
      Blue  = COLOR-TABLE:GET-BLUE-VALUE(i).
  END.
     
  /* Custom Color */  
  Create TColor.
  ASSIGN
   gNumColors = gNumColors + 1 
   tColor.Num = gNumColors 
   tColor.Custom = TRUE
   Red        = 1
   Green      = 1
   Blue       = 1.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetDefaults Dialog-Frame 
PROCEDURE SetDefaults :
/*------------------------------------------------------------------------------
  Purpose:     Create FONTs and COLORs from the temp-tables that were 
               created in ReadDefaults.
                    
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR i   AS INTEGER NO-UNDO.
  
  ASSIGN FONT-TABLE:NUM-ENTRIES = gNumFonts.
  FOR EACH tFont:
    PUT-KEY-VALUE SECTION "FONTS":U 
                  KEY "FONT":U + STRING(tFont.Num) 
                  VALUE tFont.FOntVAlue.
  END.
  
  ASSIGN COLOR-TABLE:NUM-ENTRIES = gNumColors + 1.
  FOR EACH TColor: 
    COLOR-TABLE:SET-DYNAMIC(tColor.Num,TRUE).
    COLOR-TABLE:SET-RED-VALUE(tColor.Num,Red).
    COLOR-TABLE:SET-GREEN-VALUE(tColor.Num,Green).
    COLOR-TABLE:SET-BLUE-VALUE(tColor.Num,Blue).
  END.     

   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetSelected Dialog-Frame 
PROCEDURE SetSelected :
/*------------------------------------------------------------------------------
  Purpose:    Set a color as selected by creating a white rectangle 
              around the rectangle and the text.  
  Parameters: pHdl - Selected rectangles handle.
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER pHdl As HANDLE NO-UNDO. 
       
  DEF VAR Hdl AS HANDLe. 
  
  IF VALID-HANDLE(gSelected) THEN 
  DO:
     FIND tColor WHERE tColor.Hdl = gSelected NO-ERROR.
     IF VALID-HANDLe(pHDL) THEN ASSIGN TColor.TextHdl:BgColor = ?. 
     IF tColor.Custom THEN gCustBtnHdl:HIDDEN = TRUE.
  END.
     
  IF VALID-HANDLE(pHDL) THEN
  DO:
    FIND tColor WHERE tColor.Hdl = phdl NO-ERROR.
    IF tColor.Custom THEN 
    DO:
      gCustBtnHdl:HIDDEN = FALSE.
      IF LAST-EVENT:EVENT-TYPE = "KEYPRESS":U THEN
        APPLY "ENTRY":U TO gCustBtnHdl.
    END.
    ASSIGN
       gSelected = pHdl. 
    
    IF NOT VALID-HANDLE(gSelectHdl) THEN
    DO: 
      CREATE RECTANGLE gSelectHdl
        ASSIGN 
          FRAME        = FRAME {&FRAME-NAME}:HANDLE
          BGCOLOR      = 16
          HEIGHT-P     = pHDL:HEIGHT-P + 6
          WIDTH-P      = (pHDL:WIDTH-P + 6) * 2  
          SENSITIVE    = NO
          EDGE-PIXELS  = 1
          FILLED       = YES.
      gSelectHdl:MOVE-TO-BOTTOM().
    END.
 
    ASSIGN
     TColor.TextHdl:BgColor = 16
     gSelectHdl:HIDDEN = FALSE
     gSelectHdl:y      = pHDL:Y - 3
     gSelectHDL:X      = pHDL:X - 3
     NO-ERROR.   
  END.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION ColorText Dialog-Frame 
FUNCTION ColorText RETURNS CHARACTER
  (pRed   AS INT,
   PGreen AS INT,
   pBlue  AS INT):
/*------------------------------------------------------------------------------
  Purpose: Return the name of a colors Red,Green,Blue values.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VAR ColorText AS CHAR NO-UNDO.
  
  ColorText = IF pRed = 0   AND pGreen = 0   AND pBlue = 0   THEN "Black"
              ELSE 
              IF pRed = 0   AND pGreen = 0   AND pBlue = 128 THEN "Navy"
              ELSE 
              IF pRed = 0   AND pGreen = 0   AND pBlue = 255 THEN "Blue"
              ELSE 
              IF pRed = 0   AND pGreen = 255 AND pBlue = 255 THEN "Aqua"
              ELSE 
              IF pRed = 255 AND pGreen = 0   AND pBlue = 0   THEN "Red"
              ELSE 
              IF pRed = 0   AND pGreen = 255 AND pBlue = 0   THEN "Lime"
              ELSE 
              IF pRed = 128 AND pGreen = 128 AND pBlue = 0   THEN "Olive"
              ELSE 
              IF pRed = 192 AND pGreen = 192 AND pBlue = 192 THEN "Grey"
              ELSE "":U.
              
  IF ColorText = "" THEN
    ASSIGN ColorText =             
              IF pRed = 0   AND pGreen = 128 AND pBlue = 0   THEN "Green"
              ELSE 
              IF pRed = 128 AND pGreen = 0   AND pBlue = 128 THEN "Purple"
              ELSE 
              IF pRed = 128 AND pGreen = 128 AND pBlue = 128 THEN "Dark Grey"
              ELSE 
              IF pRed = 0   AND pGreen = 128 AND pBlue = 128 THEN "Teal"
              ELSE 
              IF pRed = 128 AND pGreen = 0   AND pBlue = 0   THEN "Maroon"
              ELSE 
              IF pRed = 255 AND pGreen = 0   AND pBlue = 255 THEN "Fuchsia"
              ELSE 
              IF pRed = 255 AND pGreen = 255 AND pBlue = 0   THEN "Yellow"
              ELSE 
              IF pRed = 255 AND pGreen = 255 AND pBlue = 255 THEN "White"
              ELSE 
              IF pRed = ? THEN "Default"
              ELSE "Custom".
              
  RETURN ColorText.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION MoveBackWard Dialog-Frame 
FUNCTION MoveBackWard RETURNS LOGICAL
  ( ):
/*------------------------------------------------------------------------------
  Purpose: Select the previous color.  
    Notes: Called from various triggers. 
           It's finding the prev-sibling in the widget tree 
------------------------------------------------------------------------------*/

  DEF VAR HDL      AS HANDLE NO-UNDO.
 
  ASSIGN
    HDL  = GSelected:PREV-SIBLING.
       
  IF NOT VALID-HANDLE(HDL) OR Hdl = gSelectHdl THEN   
  DO:
    Run SetSelected(gLastRectHdl).
  END.
  ELSE
  IF Hdl:TYPE = "RECTANGLE":U THEN  
    RUN SetSelected(Hdl).
  
  RETURN TRUE.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION MoveForward Dialog-Frame 
FUNCTION MoveForward RETURNS LOGICAL
  ( ):
/*------------------------------------------------------------------------------
  Purpose: Select the next color.  
    Notes: Called from various triggers.
           It's finding the next-sibling in the widget tree 
           If this is not a rectangle we must start form the first again. 
------------------------------------------------------------------------------*/
  DEF VAR HDL      AS HANDLE NO-UNDO.
  
  ASSIGN
    HDL      = GSelected:NEXT-SIBLING.
               
  IF Hdl:TYPE = "RECTANGLE":U THEN  
    RUN SetSelected(Hdl).
  ELSE 
    RUN SetSelected(gFirstRectHdl).
  
  RETURN TRUE.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

