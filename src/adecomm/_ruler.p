/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _ruler.p

Description:
  Build a ruler frame and retrun the frame handle

INPUT Parameters
  The window to parent the ruler frame to.

INPUT-OUTPUT Parameters

OUTPUT Parameters
  The ruler frame 

Author: Greg O'Connor

Date Created: 08/10/93 

Modification History:

----------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER wWindow   AS WIDGET NO-UNDO.
DEFINE OUTPUT PARAMETER wFrameOut AS WIDGET NO-UNDO.

DEFINE VARIABLE wFrame1    AS WIDGET NO-UNDO.
DEFINE VARIABLE wFrame2    AS WIDGET NO-UNDO.
DEFINE VARIABLE wRectFrame AS WIDGET NO-UNDO.
DEFINE VARIABLE wRect1     AS WIDGET NO-UNDO.
DEFINE VARIABLE wRectTop   AS WIDGET NO-UNDO.
DEFINE VARIABLE wRectLeft  AS WIDGET NO-UNDO.
DEFINE VARIABLE wText      AS WIDGET NO-UNDO.
DEFINE VARIABLE wTextSave  AS WIDGET NO-UNDO.
DEFINE VARIABLE wTextNum   AS WIDGET NO-UNDO.
DEFINE VARIABLE wFillin    AS WIDGET NO-UNDO.
DEFINE VARIABLE cTest      AS CHARACTER NO-UNDO.
DEFINE VARIABLE i          AS INTEGER NO-UNDO.
DEFINE VARIABLE iSave      AS INTEGER NO-UNDO.
DEFINE VARIABLE iLen       AS INTEGER NO-UNDO.
DEFINE VARIABLE iTotal     AS INTEGER NO-UNDO INIT 0.
DEFINE VARIABLE iFields    AS INTEGER NO-UNDO INIT 0.
DEFINE VARIABLE cTextHandleList  AS CHARACTER NO-UNDO.

&SCOPED-DEFINE topBottom 3
&SCOPED-DEFINE rightLeft 4
&SCOPED-DEFINE smallFont 5

IF (wWindow:TYPE <> "WINDOW") THEN
  IF (wWindow:TYPE <> "FRAME") THEN
	DO:
	  message '_ruler argument one must be of TYPE window' skip
	          'or frame. Argument one is TYPE' wWindow:TYPE '.'
			  view-as alert-box error buttons Ok.
	  RETURN.
	END.
   	
CREATE FRAME wFrame1
  ASSIGN
    BOX     = FALSE
    OVERLAY = TRUE
    PARENT  = IF (wWindow:TYPE = "WINDOW") THEN wWindow ELSE wWindow:PARENT
    X       = 0
    Y       = 0
    HEIGHT-CHARS   = 2
    WIDTH-PIXELS   = 2 /* wWindow:WIDTH-PIXELS*/.

cTest = "a".
CREATE TEXT wTextSave
  ASSIGN
    FRAME         = wFrame1
    FORMAT        ="x(1)"
    AUTO-RESIZE   = TRUE
    X             = 0 
    Y             = 0
    VISIBLE       = FALSE
	FONT          = 0
    SCREEN-VALUE   = cTest.

cTest = "a".
CREATE FILL-IN wFillin
  ASSIGN
    FRAME         = wFrame1
    FORMAT        ="x(1)"
    AUTO-RESIZE   = TRUE
    X             = 0 
    Y             = 0
    VISIBLE       = FALSE
    SCREEN-VALUE   = cTest.

IF (wWindow:TYPE = "WINDOW") THEN
DO:
	CREATE FRAME wFrame2
	  ASSIGN
	    BOX     = FALSE
	    OVERLAY = TRUE
	    PARENT  = wWindow
	    X       = 0
	    Y       = 0
		/*
		** The min size a frame can be is the size of a fillin which is bigger than 
		** the size of text becuase of decoration. If the ruler and the margin
		** fit in the the fillin space the use it. 
		*/
	    HEIGHT-PIXELS  = (IF ((wFillin:HEIGHT-PIXELS - wTextSave:HEIGHT-PIXELS) > 
		                     {&topBottom}) THEN wFillin:HEIGHT-PIXELS + 1
						 ELSE
	                        wTextSave:HEIGHT-PIXELS + ({&topBottom} * 2) + 2
						 )
	    WIDTH-PIXELS   = wWindow:WIDTH-PIXELS.
	
	view wFrame2.

	CREATE RECTANGLE wRectFrame
	  ASSIGN
	    X             = 0
	    Y             = 0
	    WIDTH-PIXELS  = wFrame2:WIDTH-PIXELS 
	    HEIGHT-PIXELS = wFrame2:HEIGHT-PIXELS
	    FRAME         = wFrame2
	    bgcolor       = 8
	    fgcolor       = 8
	    filled        = TRUE
		.
END.
ELSE IF (wWindow:TYPE = "FRAME") THEN
DO:

	CREATE RECTANGLE wRectFrame
	  ASSIGN
	    X             = 0
	    Y             = 0
		/*
		** The min size a frame can be is the size of a fillin which is bigger than 
		** the size of text becuase of decoration. If the ruler and the margin
		** fit in the the fillin space the use it. 
		*/
	    HEIGHT-PIXELS  = (IF ((wFillin:HEIGHT-PIXELS - wTextSave:HEIGHT-PIXELS) > 
		                     {&topBottom}) THEN wFillin:HEIGHT-PIXELS + 1
						 ELSE
	                        wTextSave:HEIGHT-PIXELS + ({&topBottom} * 2) + 2
						 )
	    WIDTH-PIXELS   = wWindow:virtual-WIDTH-PIXELS
	    FRAME         = wWindow
	    bgcolor       = 8
	    fgcolor       = 8
	    filled        = TRUE
		.
END.


CREATE TEXT wTextNum
  ASSIGN
    FRAME         = wRectFrame:FRAME
    FORMAT        ="x(1)"
    AUTO-RESIZE   = TRUE
    Y             = 0
    X             = 0
	FONT          = {&SmallFont}
    SCREEN-VALUE  = cTest
	VISIBLE       = FALSE
	.

CREATE RECTANGLE wRect1 /* White middle middle line */
  ASSIGN
	WIDTH-PIXELS  = wRectFrame:WIDTH-PIXELS  - {&rightLeft}
    HEIGHT-PIXELS = 1 
    FRAME         = wRectFrame:FRAME
    bgcolor       = 0
    fgcolor       = 0
    filled        = FALSE
    X             = {&rightleft}
	Y             = wRectFrame:HEIGHT-PIXELS / 2 - 1
	.

CREATE RECTANGLE wRect1 /* Black middle bottom line */
  ASSIGN
	WIDTH-PIXELS  = wRectFrame:WIDTH-PIXELS  - {&rightLeft}
    HEIGHT-PIXELS = 1 
    FRAME         = wRectFrame:FRAME
    bgcolor       = 15
    fgcolor       = 15
    filled        = FALSE
    X             = {&rightleft}
	Y             = wRectFrame:HEIGHT-PIXELS / 2 - 2
	.

CREATE RECTANGLE wRect1 /* Grey middle top line */
  ASSIGN
	WIDTH-PIXELS  = wRectFrame:WIDTH-PIXELS  - {&rightLeft}
    HEIGHT-PIXELS = 1 
    FRAME         = wRectFrame:FRAME
    bgcolor       = 7
    fgcolor       = 7
    filled        = FALSE
    X             = {&rightleft}
	Y             = wRectFrame:HEIGHT-PIXELS / 2 
	.

CREATE RECTANGLE wRect1 /* black top line */
  ASSIGN
	WIDTH-PIXELS  = wRectFrame:WIDTH-PIXELS 
    HEIGHT-PIXELS = 1 
    FRAME         = wRectFrame:FRAME
    bgcolor       = 0
    fgcolor       = 0
    filled        = FALSE
    X             = 0
	Y             = 0
	.

CREATE RECTANGLE wRect1 /* White top line */
  ASSIGN
	WIDTH-PIXELS  = wRectFrame:WIDTH-PIXELS 
    HEIGHT-PIXELS = 1 
    FRAME         = wRectFrame:FRAME
    bgcolor       = 15
    fgcolor       = 15
    filled        = FALSE
    X             = 0
	Y             = 1
	.

CREATE RECTANGLE wRect1 /* Grey bottom line */
  ASSIGN
	WIDTH-PIXELS  = wRectFrame:WIDTH-PIXELS 
    HEIGHT-PIXELS = 1 
    FRAME         = wRectFrame:FRAME
    bgcolor       = 7
    fgcolor       = 7
    filled        = FALSE
    X             = 0
    Y             = wRectFrame:HEIGHT-PIXELS - 1
	.

ASSIGN
  iTotal = {&rightLeft}
  iSave  = wTextNum:height-pixels
  .

DO i = 0 TO wRectFrame:WIDTH-PIXELS / wTextSave:WIDTH-PIXELS:

	IF (i MOD 10) = 0 THEN
 	DO:
	  ASSIGN
  	    iLen          = wRectFrame:HEIGHT-PIXELS / 2.
	  CREATE TEXT wTextNum
	    ASSIGN
	      FRAME         = wRectFrame:FRAME
	      FORMAT        ="x(1)"
	      AUTO-RESIZE   = TRUE 
 	      Y             = MAX (iLen - iSave - 1, 0)
	      X             = {&rightLeft} + i * wTextSave:WIDTH-PIXELS + 1
          bgcolor       = 8
	   	  FONT          = {&smallFont}
	      SCREEN-VALUE   = STRING (i / 10)
		.
	    ASSIGN
		  wTextNum:HEIGHT-PIXELS = wTextNum:HEIGHT-PIXELS - 6
		  wTextNum:Y             = wTextNum:Y + 2
		  .
	END.
	ELSE IF (i MOD 5) <> 0 THEN
	  iLen          = wRectFrame:HEIGHT-PIXELS / 6 - 1.
	ELSE
	  iLen          = wRectFrame:HEIGHT-PIXELS / 3 - 1.

    iTotal = {&rightLeft} + i * wTextSave:WIDTH-PIXELS + 1.
	IF (iTotal > wRectFrame:WIDTH-PIXELS) THEN
	  NEXT.

	CREATE RECTANGLE wRectTop /* top line */
	  ASSIGN
	    Y             = IF (i MOD 10) = 0 THEN
   	   					  wRectFrame:HEIGHT-PIXELS / 2 - 5
						ELSE
   	   					  wRectFrame:HEIGHT-PIXELS / 2 
	    X             = {&rightLeft} + i * wTextSave:WIDTH-PIXELS
	    WIDTH-PIXELS  = 1
	    HEIGHT-PIXELS = iLen
	    FRAME         = wRectFrame:FRAME
	    bgcolor       = 0
	    fgcolor       = 0
	    filled        = FALSE
		.
	
	CREATE RECTANGLE wRect1 /* White (bottom and left line) */
	  ASSIGN
	    HEIGHT-PIXELS = iLen
	    Y             = wRectTop:Y

	    HEIGHT-PIXELS  = IF (i MOD 10) = 0 THEN
   	   					  wRectFrame:HEIGHT-PIXELS / 2 - 4
						ELSE
   	   					  iLen 
	    Y             = wRectFrame:HEIGHT-PIXELS / 2 
	    X             = wRectTop:X + 1
	    WIDTH-PIXELS  = 1
	    FRAME         = wRectFrame:FRAME
	    bgcolor       = 15
	    fgcolor       = 15
	    filled        = FALSE
		.
	
END.

  wFrameOut = wRectFrame:FRAME.

RETURN.
