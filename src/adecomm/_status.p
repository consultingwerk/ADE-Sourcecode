/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: 

Description:
  Create a status bar for a window.

INPUT Parameters
  wWindow	- The window to parent the status bar to
  cLen		- A character list of how many and how long a status
        	  box should be.
		  "30,10" will create a status bar with two status
		  boxes 30 and 10 characters long.
  lTopLine      - Logical for determining if top line should be shown.
  iFont         - Font number for status message text.  If ?, system font is used 

INPUT-OUTPUT Parameters

OUTPUT Parameters
  wFrameOut 	- The status frame.
  iFieldsOut	- The number of fields that where actually created.

Author: Greg O'Connor

Date Created: 08/10/93 

Modification History:

12/6/96 gfs  Removed hardcoded BGCOLOR=8 and make frame three-d. This all was 
             done so that a change to the 3D color in Windows95 would show 
             through
5/20/94 ryan Added support for topline and font size

----------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER wWindow   AS WIDGET    NO-UNDO.
DEFINE INPUT  PARAMETER cLen      AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER lTopLine  AS LOGICAL   NO-UNDO.
DEFINE INPUT  PARAMETER iFont     AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER wFrameOut AS WIDGET    NO-UNDO.
DEFINE OUTPUT PARAMETER iFieldOut AS INTEGER   NO-UNDO.


DEFINE VARIABLE wFrame2    AS WIDGET NO-UNDO.
DEFINE VARIABLE wRectFrame AS WIDGET NO-UNDO.
DEFINE VARIABLE wRect1     AS WIDGET NO-UNDO.
DEFINE VARIABLE wRectTop   AS WIDGET NO-UNDO.
DEFINE VARIABLE wRectLeft  AS WIDGET NO-UNDO.
DEFINE VARIABLE wText      AS WIDGET NO-UNDO.
DEFINE VARIABLE cText      AS CHARACTER INITIAL "12345678901234567890" NO-UNDO. 
DEFINE VARIABLE cTopColor  AS INTEGER INIT 15 NO-UNDO.
DEFINE VARIABLE iFontSize  AS INTEGER INIT 0 NO-UNDO.
DEFINE VARIABLE i          AS INTEGER NO-UNDO.
DEFINE VARIABLE iFormat    AS INTEGER NO-UNDO.
DEFINE VARIABLE iTotal     AS INTEGER NO-UNDO INIT 0.
DEFINE VARIABLE iFields    AS INTEGER NO-UNDO INIT 0.
DEFINE VARIABLE cTextHandleList  AS CHARACTER NO-UNDO.

&SCOPED-DEFINE topBottom 3
&SCOPED-DEFINE rightLeft 6

ASSIGN
  cTopColor = IF lTopLine THEN 15 ELSE 8
  iFontSize = IF iFont = ? THEN 1 ELSE iFont.

CREATE FRAME wFrame2
  ASSIGN
    BOX        = FALSE
    OVERLAY    = TRUE
    PARENT     = wWindow
    X          = 0
    Y          = 0
    THREE-D    = YES
    SCROLLABLE = NO
   /*
    The min size a frame can be is the size of a fillin which is bigger than 
    the size of text because of decoration. If the status bar and the margin
    fit in the the fillin space the use it. Otherwise compute the hieght based
    on the size plus top and bottom margin + a pixel or two so the rectanges are
    not over written by passing a screen value to the text widgets at run time
    */
    HEIGHT-PIXELS  = (IF ((SESSION:PIXELS-PER-ROW -
                           FONT-TABLE:GET-TEXT-HEIGHT-PIXELS(iFontSize)) > 
	                      {&topBottom}) 
                       THEN SESSION:PIXELS-PER-ROW + 1
                       ELSE FONT-TABLE:GET-TEXT-HEIGHT-PIXELS(iFontSize) +
                           ({&topBottom} * 2) + 3)
    WIDTH-PIXELS   = wWindow:WIDTH-PIXELS.
wFrame2:Y = wWindow:HEIGHT-PIXELS - wFrame2:HEIGHT-PIXELS.

CREATE RECTANGLE wRectFrame
  ASSIGN
    X             = 0
    Y             = iTotal
    WIDTH-PIXELS  = wFrame2:WIDTH-PIXELS 
    HEIGHT-PIXELS = wFrame2:HEIGHT-PIXELS
    FRAME         = wFrame2
    fgcolor       = 8
    filled        = false
    .

CREATE RECTANGLE wRect1 /* Black top line */
  ASSIGN
    WIDTH-PIXELS  = wFrame2:WIDTH-PIXELS 
    HEIGHT-PIXELS = 1 
    FRAME         = wFrame2
    bgcolor       = cTopColor
    fgcolor       = cTopColor
    filled        = FALSE
    X             = 0
    Y             = 0
    .

iTotal = 0.

DO i = 1 TO NUM-ENTRIES (cLen):
  iFormat = INTEGER (ENTRY (i, cLen)).

  IF ((iFormat * (FONT-TABLE:GET-TEXT-WIDTH-PIXELS(cTEXT,iFontSize) / 20)) + iTotal) >
      wFrame2:WIDTH-PIXELS THEN
	NEXT.

  iFields = iFields + 1.

  /* Create the Text as if it is in the default font.  This will size the text
     as if it had a format "X(iFormat)".  Note that we really want to size it
     based on the font we are going to be using (but this will cause some 
     compatibility problems with old code.  So we will size it the old way, and
     then change to the new font and make sure we use all the usable space. 
     (wood 6/95) */ 
  CREATE TEXT wText
    ASSIGN
      FRAME         = wFrame2
      FORMAT        = SUBSTITUTE("x(&1)",ENTRY (i, cLen))
      HEIGHT-PIXELS = wFrame2:HEIGHT-PIXELS - (({&topbottom} + 1) * 2)
      bgcolor       = wRectFrame:bgcolor
      /* Make sure not to cover the rectangles. */
      X             = iTotal + {&rightLeft} + 2 
      Y             = {&topBottom} + 1           
      .
   /* Fix the size of the text widget, then change the font and format so the
      text fills the space allocated. */
  ASSIGN wText:AUTO-RESIZE = no
         wText:FORMAT      = "X(256)"
         wText:FONT        = iFontSize
         .
	
  cTextHandleList = IF NUM-ENTRIES (cTextHandleList) = 0 
    THEN STRING (wText:HANDLE) 
    ELSE cTextHandleList + "," + STRING (wText:HANDLE).
	
  CREATE RECTANGLE wRect1 /* White (bottom and left line) */
    ASSIGN
      WIDTH-PIXELS  = wText:WIDTH-PIXELS  + ({&rightLeft} * 2)
      HEIGHT-PIXELS = wFrame2:HEIGHT-PIXELS - ({&topBottom} * 2) 
      FRAME         = wFrame2
      bgcolor       = 15
      fgcolor       = 15
      filled        = FALSE
      X             = iTotal + {&rightLeft}
      Y             = wText:Y - 1
      .	
	
  CREATE RECTANGLE wRectTop /* top black line */
    ASSIGN
      Y             = wRect1:Y
      X             = iTotal + {&rightLeft}
      WIDTH-PIXELS  = wRect1:WIDTH-PIXELS
      HEIGHT-PIXELS = 1
      FRAME         = wFrame2
      bgcolor       = 0
      fgcolor       = 0
      filled        = FALSE
		.
	
  CREATE RECTANGLE wRectLeft /*left black line */
    ASSIGN
      X             = iTotal + {&rightLeft}
      Y             = wRect1:Y
      WIDTH-PIXELS  = 1
      HEIGHT-PIXELS = wRect1:HEIGHT-PIXELS
      FRAME         = wFrame2
      bgcolor       = 0
      fgcolor       = 0
      filled        = FALSE
      .

  iTotal =  wRect1:X + wRect1:WIDTH-PIXELS /* + {&topBottom} + 1*/.
END.
ASSIGN
  wFrameOut = wFrame2
  wRect1:WIDTH-PIXELS   = wFrame2:WIDTH-PIXELS - (wRect1:X + {&rightLeft})
  wRectTop:WIDTH-PIXELS = wRect1:WIDTH-PIXELS
  NO-ERROR.

ASSIGN
  wFrame2:PRIVATE-DATA = cTextHandleList
  iFieldOut = iFields
  .

RETURN.

