&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME WINDOW-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS WINDOW-1 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*


Procedure:    adetran/common/_meter.p
Author:       R. Ryan
Created:      1/95 
Updated:      9/95
		11/96 SLK Changed for FONT
Purpose:      Both tools use the meter persistent procedure to
              show progress whenever a file operation is taking
              place. This procedure is run persistent at the very
              beginning of vt/_main.p and pm/_pmmain.p (it's initial
              state is hidden). 'SetBar' is the most important
              procedure.  Regardless of the unit, the calling
              program sends three pieces of data:
              
                TotalUnits  The total
                ThisUnit    This increment
                ThisLabel   The label displayed above the bar                 

Notes:        *** This file has been edited outside of the AppBuilder.
              *** If you open and save in the AB, you may lose changes.

              _meter.w is nothing more than a free-floating frame
              that receives input from another program. When the
              meter is running in a 'Process Events' loop, the 
              cancel button can receive input.  If 'Cancel' is pressed'
              the user is asked, 'Are you sure?".  If the answer is yes
              then the calling process can evaluate the shared 
              variable, 'StopProcessing'.
                 
Procedures:   Key internal procedures include:

                SetBar      described above    
                SetWindow   Used to parent the frame
                HideMe      Hides the frame
                Realize     Displays the frame and inserts
                            a label into the frame title.
 
                
Called By:    pm/_extract.w     (creating an XREF)
              pm/_copykit.p     (creating a kit)
              pm/_res.w         (create resources)
              pm/_compdlg.w     (compiling .r code)
              pm/_newglos.w     (adding a MS glossary)
              pm/_ldgloss.p     (consolidation)
              pm/_ldtran.p      (consolidation)  
              common/_import.w  (importing a glossary from PM)
              common/_glsimpt.w (importing a glossary from VT)
*/
define input parameter CurWindow as widget-handle.

define shared var StopProcessing as logical no-undo.
define var Result as logical no-undo.
define var i as integer no-undo.
define var LastValue as int.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME MeterFrame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS LeftLine UpperLine RightLine FileStatus Box ~
HorzLine VertLine FilePct Bar BtnCancel BottomLine 
&Scoped-Define DISPLAYED-OBJECTS FileStatus FilePct 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR WINDOW-1 AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnCancel DEFAULT 
     LABEL "Cancel" 
     SIZE-PIXELS 86 BY 23 .

DEFINE VARIABLE FilePct AS DECIMAL FORMAT ">>>9%":U INITIAL 0 
      VIEW-AS TEXT 
     SIZE-PIXELS 26 BY 22 
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FileStatus AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE-PIXELS 300 BY 24 NO-UNDO.

DEFINE RECTANGLE Bar
     EDGE-PIXELS 0  
     SIZE-PIXELS 300 BY 24 
     BGCOLOR 1 FGCOLOR 1 .

DEFINE RECTANGLE Box
     EDGE-PIXELS 1 GRAPHIC-EDGE  
     SIZE-PIXELS 304 BY 28 
     BGCOLOR 8 .

DEFINE RECTANGLE HorzLine
     EDGE-PIXELS 1 GRAPHIC-EDGE  
     SIZE-PIXELS 300 BY 1 
     BGCOLOR 15 FGCOLOR 15 .

DEFINE RECTANGLE VertLine
     EDGE-PIXELS 1 GRAPHIC-EDGE  
     SIZE-PIXELS 1 BY 26 
     BGCOLOR 15 FGCOLOR 15 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME MeterFrame
     FileStatus AT Y 12 X 30 NO-LABEL
     FilePct AT Y 39 X 173 NO-LABEL
     BtnCancel AT Y 77 X 140
     Box AT Y 39 X 28
     HorzLine AT Y 39 X 30
     VertLine AT Y 39 X 30
     Bar AT Y 40 X 30
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         VIEW-AS DIALOG-BOX
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT X 0 Y 0
         SIZE-PIXELS 364 BY 139
         FONT 4
         TITLE "Working..."
         DEFAULT-BUTTON BtnCancel.

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: WINDOW
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* SUPPRESS Window definition (used by the UIB) 
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW WINDOW-1 ASSIGN
         HIDDEN             = YES
         TITLE              = "Window 1"
         X                  = 154
         Y                  = 159
         HEIGHT-P           = 140
         WIDTH-P            = 364
         MAX-HEIGHT-P       = 572
         MAX-WIDTH-P        = 609
         VIRTUAL-HEIGHT-P   = 572
         VIRTUAL-WIDTH-P    = 609
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
&ANALYZE-RESUME
ASSIGN WINDOW-1 = CURRENT-WINDOW.



/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW WINDOW-1
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME MeterFrame
   NOT-VISIBLE Default                                                  */

/* SETTINGS FOR FILL-IN FilePct IN FRAME MeterFrame
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FileStatus IN FRAME MeterFrame
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME MeterFrame
/* Query rebuild information for FRAME MeterFrame
     _Query            is NOT OPENED
*/  /* FRAME MeterFrame */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME BtnCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnCancel WINDOW-1
ON CHOOSE OF BtnCancel IN FRAME MeterFrame /* Cancel */
DO:
  message "Are you sure?" view-as alert-box question buttons yes-no
    title "Interrupt" update Result.
  if Result then DO:
    ASSIGN StopProcessing = true.
    RUN HideMe.
  END.
  else StopProcessing = False.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK WINDOW-1 


ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

IF FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-P > FRAME {&FRAME-NAME}:HEIGHT-P OR
   FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-P > FRAME {&FRAME-NAME}:WIDTH-P THEN
  ASSIGN FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-P = 
                FRAME {&FRAME-NAME}:HEIGHT-P
         FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-P  =
                FRAME {&FRAME-NAME}:WIDTH-P
         FRAME {&FRAME-NAME}:SCROLLABLE       = NO.
         
PAUSE 0 BEFORE-HIDE.

MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
   
   do with frame MeterFrame:
     assign      
       frame MeterFrame:parent = CurWindow
       frame MeterFrame:x = (CurWindow:width-p / 2) - (frame MeterFrame:width-p / 2 )
       frame MeterFrame:y = (CurWindow:height-p / 2) - (frame MeterFrame:height-p / 2)
       BtnCancel:x        = (frame MeterFrame:width-p / 2) - (BtnCancel:width-p / 2)
         
       Bar:width-p        = 1
       Box:bgc            = 8
       Box:fgc            = 7  
       Bar:height-p       = Box:height-p - 4
       Bar:x              = Box:x + 2
       Bar:y              = Box:y + 2
         
       HorzLine:bgc       = 15
       HorzLine:fgc       = 15
       HorzLine:width-p   = box:width-p
       HorzLine:height-p  = 1
       HorzLine:x         = box:x
       HorzLine:y         = box:y + (box:height-p - 1)
  
       VertLine:bgc       = 15
       VertLine:fgc       = 15
       VertLine:width-p   = 1
       VertLine:height-p  = box:height-p
       VertLine:x         = box:x + (box:width-p - 1)
       VertLine:y         = box:y

       FilePct:y          = Box:y + 4
       FilePct:height-p   = Box:height-p - 10
       .
   end. 
END.
{adecomm/_adetool.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HideMe WINDOW-1 
PROCEDURE HideMe :
do with frame MeterFrame:
  frame MeterFrame:hidden = true.
  assign
    Bar:width-p            = 1
    FilePct                = 1  
    FilePct:fgc            = ?
    FilePct:bgc            = 8.     
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Realize WINDOW-1 
PROCEDURE Realize :
def input parameter ptitle as char.

  assign
    frame MeterFrame:title  = ptitle
    FileStatus:screen-value = "":U  
    FilePct:hidden          = true  
    StopProcessing          = false.
        
  enable all with frame MeterFrame in window CurWindow.
   
  frame MeterFrame:hidden = false.
  apply "entry":u to BtnCancel in frame MeterFrame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetBar WINDOW-1 
PROCEDURE SetBar :
def input parameter TotalUnits as int.
  def input parameter ThisUnit as int.
  def input parameter ThisLabel as char.
  
  do with frame MeterFrame:  
    /*
    ** Note: after the percent calculation is made, it is passed
    ** to the Bar object in pixels and then multiplied by 3 (since
    ** Bar's width-pixels = 300.  2 pixels are subtracted to keep the 
    ** bar meter from extending past the bar's boundary. Simple and efficient
    */
    assign
      FileStatus:screen-value = ThisLabel 
      FilePct                 = (ThisUnit / TotalUnits) * 100
      FilePct                 = If FilePct < 1 then 1 else MIN(FilePct,9999)
      FilePct:hidden          = false.  
         
    if integer(FilePct) <> LastValue then do.
      assign                            
        Bar:width-p          = if FilePct <= 100 then integer(FilePct) * 3
                               else 100 /* 98 keeps from expanding over border pixels */
      /*  if FilePct > 4 then (integer(FilePct) * 3) - 4
                               else integer(FilePct) * 3 */
        FilePct:bgc          = if integer(FilePct) >= 55 then 1 else 8
        FilePct:fgc          = if integer(FilePct) >= 55 then 15 else ?
        LastValue            = integer(FilePct)
        FilePct:screen-value = string(FilePct).
    end.    
  end. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetWindow WINDOW-1 
PROCEDURE SetWindow :
def input parameter pWindow as widget-handle. 
  CurWindow = pWindow.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


