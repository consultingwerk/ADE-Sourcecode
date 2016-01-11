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
/*----------------------------------------------------------------------------

  File: y-menu.p - menubar and main loop 

  Description: 

  Input Parameters:

  Output Parameters:      <none>

  Author: Greg O'Connor

  Created: 08/15/93 - 12:17 pm

-----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/j-define.i }
{ aderes/i-define.i }
{ aderes/r-define.i }
{ aderes/l-define.i }
{ aderes/e-define.i }
{ aderes/a-define.i }
{ aderes/fbdefine.i } 
{ aderes/s-output.i }
{ aderes/s-menu.i NEW }
{ adecomm/adestds.i }
{ aderes/_fdefs.i }
{ aderes/y-define.i }
{ aderes/reshlp.i }
{ adeshar/_mnudefs.i}
{ aderes/timectrl.i }

&IF DEFINED(timestartup) &THEN
    { adeshar/mpdecl.i &TIMER="foo" }
    { adeshar/mp.i &MP-MACRO="stotal" &TIMER="foo" 
		   &INFOSTR="+y-menu" }
&ENDIF

DEFINE VARIABLE qbf-l     AS LOGICAL   NO-UNDO. /* general purpose scrap */
DEFINE VARIABLE qbf-wait  AS LOGICAL   NO-UNDO. /* need to do wait-for */
DEFINE VARIABLE qbf-d     AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-i     AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE iFields   AS INTEGER   NO-UNDO.
DEFINE VARIABLE lRet      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE winTitle  AS CHARACTER NO-UNDO.                    
DEFINE VARIABLE menuFile  AS CHARACTER NO-UNDO.
DEFINE VARIABLE newfile   AS CHARACTER NO-UNDO.
DEFINE VARIABLE fWidth    AS INTEGER   NO-UNDO.
DEFINE VARIABLE old_hit   AS DECIMAL   NO-UNDO. /* height before resize */
DEFINE VARIABLE old_wid   AS DECIMAL   NO-UNDO. /* width before resize */
DEFINE VARIABLE fhdl      AS HANDLE    NO-UNDO. /* for macro */
DEFINE VARIABLE logohdl   AS HANDLE    NO-UNDO. /* logo frame handle */
DEFINE VARIABLE currhdl   AS HANDLE    NO-UNDO. /* current widget */
DEFINE VARIABLE nexthdl   AS HANDLE    NO-UNDO. /* next widget */
DEFINE VARIABLE winResize AS LOGICAL   NO-UNDO. /* window resizing */

ASSIGN
  lGlbToolbar = TRUE
  lGlbStatus  = TRUE.
  
&GLOBAL-DEFINE TOP_BOTTOM_BORDERS (fhdl:BORDER-TOP-PIXELS +   ~
				   fhdl:BORDER-BOTTOM-PIXELS)
&GLOBAL-DEFINE SIDE_BORDERS (fhdl:BORDER-LEFT-PIXELS + ~
			     fhdl:BORDER-RIGHT-PIXELS)
&GLOBAL-DEFINE STATUS_HT (IF lGlbStatus THEN wGlbStatus:HEIGHT-PIXELS ELSE 0)
&GLOBAL-DEFINE TOOLBAR_HT ~
   (IF lGlbToolbar THEN FRAME fToolbar:HEIGHT-PIXELS ELSE 0) 

/*--------------------------------------------------------------------------*/

ON HELP ANYWHERE DO:
  CASE qbf-module:
    WHEN "b":u THEN qbf-i = {&PROGRESS_RESULTS_Window_Browse}.
    WHEN "r":u THEN qbf-i = {&PROGRESS_RESULTS_Window_Report}.
    WHEN "f":u THEN qbf-i = {&PROGRESS_RESULTS_Window_Form}.
    WHEN "l":u THEN qbf-i = {&PROGRESS_RESULTS_Window_Label}.
    WHEN "e":u THEN qbf-i = {&PROGRESS_RESULTS_Window_Export}.
	OTHERWISE qbf-i = {&PROGRESS_RESULTS_Window}. 
  END CASE.

  RUN adecomm/_adehelp.p ("res":u,"CONTEXT":u,qbf-i,?).
END.

ON WINDOW-CLOSE OF qbf-win DO:
  RUN adecomm/_setcurs.p ("WAIT":u). 
  RUN aderes/_dspfunc.p  (?,{&rfExit},{&resId},"Exit":u,"",?,"").
  RUN adecomm/_setcurs.p (""). 
  
  RETURN NO-APPLY. /* avoid annoying beep */
END.

ON WINDOW-RESIZED OF qbf-win DO:
  DEFINE VARIABLE wid           AS DECIMAL NO-UNDO.
  DEFINE VARIABLE hit           AS DECIMAL NO-UNDO.
  DEFINE VARIABLE win_wid       AS DECIMAL NO-UNDO.
  DEFINE VARIABLE win_hit       AS DECIMAL NO-UNDO.
  DEFINE VARIABLE h_growing     AS LOGICAL NO-UNDO.
  DEFINE VARIABLE v_growing     AS LOGICAL NO-UNDO.
  DEFINE VARIABLE hdl           AS HANDLE  NO-UNDO.
  DEFINE VARIABLE max_x         AS INTEGER NO-UNDO.

  /* for layout frame - may be different from others because of box/no-box. */
  DEFINE VARIABLE vert_borders  AS DECIMAL NO-UNDO. 
  DEFINE VARIABLE side_borders  AS DECIMAL NO-UNDO. 

  ASSIGN 
    win_wid      = qbf-win:WIDTH-PIXELS
    win_hit      = qbf-win:HEIGHT-PIXELS
    
    /* Some frames don't shrink below the default size */
    wid          = MAXIMUM(win_wid,def-wid-pix)
    hit          = MAXIMUM(qbf-win:HEIGHT-PIXELS,def-hit-pix) -
		   {&TOOLBAR_HT} - {&STATUS_HT}
    fhdl         = FRAME fLayout:HANDLE
    vert_borders = {&TOP_BOTTOM_BORDERS} /* for frame layout */
    side_borders = {&SIDE_BORDERS}       /* for frame layout */
    h_growing    = (win_wid > old_wid)
    v_growing    = (qbf-win:HEIGHT-PIXELS > old_hit)
    .

  IF lGlbStatus THEN 
    ASSIGN
      wGlbStatus:Y                    = win_hit - wGlbStatus:HEIGHT-PIXELS
      wGlbStatus:WIDTH-PIXELS         = wid.

  win_hit = win_hit - {&TOOLBAR_HT} - {&STATUS_HT}. 

  /* Do the report, label and export stuff all the time even if we aren't 
     in those views.  That way when we switch views everything will be all 
     set.  Have to do things in the right order.  Can't ever size a frame 
     smaller when there are still big widgets in them or vice-versa.
  */
  fhdl = FRAME fHeader:HANDLE. /* for border macros */
  IF h_growing THEN DO:
    /* width growing */
    ASSIGN
      FRAME fLayout:WIDTH-PIXELS             = win_wid
      FRAME fLabel:WIDTH-PIXELS              = wid
      FRAME fHeader:WIDTH-PIXELS             = wid
      hdr-text:WIDTH-PIXELS IN FRAME fHeader = wid - {&SIDE_BORDERS}
      fDesign:WIDTH-PIXELS IN FRAME fLayout  = FRAME fLayout:VIRTUAL-WIDTH-P
					     - {&SIDE_BORDERS} - 2
      .
    IF lGlbToolbar THEN
      ASSIGN
        FRAME fToolbar:WIDTH-PIXELS              = wid
        crit-box:WIDTH-PIXELS IN FRAME fToolbar  = wid
          - crit-box:X IN FRAME fToolbar - 2 /* for rect */
        bcg-rect1:WIDTH-PIXELS IN FRAME fToolbar = wid 
        .
  END.
  ELSE DO: 
    /* width shrinking */
    ASSIGN
      fDesign:WIDTH-PIXELS IN FRAME fLayout  = FRAME fLayout:VIRTUAL-WIDTH-P
					     - {&SIDE_BORDERS} - 2
      hdr-text:WIDTH-PIXELS IN FRAME fHeader = wid - {&SIDE_BORDERS}
      FRAME fLayout:WIDTH-PIXELS             = win_wid
      FRAME fLabel:WIDTH-PIXELS              = wid
      FRAME fHeader:WIDTH-PIXELS             = wid
      .
    IF lGlbToolbar THEN
      ASSIGN
        crit-box:WIDTH-PIXELS IN FRAME fToolbar  = wid
          - crit-box:X IN FRAME fToolbar - 2 /* for rectangle */
        bcg-rect1:WIDTH-PIXELS IN FRAME fToolbar = wid 
        FRAME fToolbar:WIDTH-PIXELS              = wid
        .
  END.
      
  IF v_growing THEN
    /* height growing */
    ASSIGN
      FRAME fLayout:HEIGHT-PIXELS            = win_hit
      FRAME fLabel:HEIGHT-PIXELS             = hit 
					     - FRAME fHeader:HEIGHT-PIXELS
      fDesign:HEIGHT-PIXELS IN FRAME fLayout = FRAME fLayout:VIRTUAL-HEIGHT-P
					     - {&TOP_BOTTOM_BORDERS} - 2
    .
  ELSE
    /* height shrinking */
    ASSIGN
      fDesign:HEIGHT-PIXELS IN FRAME fLayout = FRAME fLayout:VIRTUAL-HEIGHT-P
					     - {&TOP_BOTTOM_BORDERS} - 2
      FRAME fLayout:HEIGHT-PIXELS            = win_hit
      FRAME fLabel:HEIGHT-PIXELS             = hit - FRAME fHeader:HEIGHT-PIXELS
      .

  IF CAN-DO("b,f":u, qbf-module) THEN DO:
    /* If there's a vertical change make sure we're making use of any new
       space we have OR we may need to shrink frames to not overlap the
       status bar.
    */
    IF win_hit <> old_hit THEN
      FOR EACH qbf-section WHERE qbf-section.qbf-shdl <> ?:
	RUN aderes/_fbresiz.p (qbf-section.qbf-shdl:ROW, qbf-section.qbf-shdl).
      END.

    /* If there's a horizontal change only do something if the change 
       involves a width outside the default size  - otherwise frame sizes 
       won't change anyway.
    */
    IF win_wid <> old_wid AND 
       NOT (old_wid <= def-wid-pix AND win_wid <= def-wid-pix) THEN DO:
      IF qbf-module = "b":u THEN DO:
	/* Progress doesn't allow us to resize the browse widget on the fly!
	   We have to regen the .p.  A check we could do before regen is:
	   If the browse widget isn't wide enough to fill the frame already
	   and we're growing - no need to widen it more or if it is smaller
	   than the shrunk window size, no need to shorten it more.
    
	   BUT (it took me hours to figure this out so I'm explaining here)
	   When created the browse widget is given a width sized to the frame
	    - otherwise if there are alot of fields it won't fit in the
	   frame.  If we made the frame scrollable at compile time, we 
	   could leave off the width but then the frame may get scrollbars 
	   but not the widget and that's lousy.  There's no way to get the 
	   amount of space the data really takes up or if there are scrollbars.
	   So we don't really know if the browse is narrower than the frame 
	   - it always just fits as far as the width values go.
	*/
	winResize = TRUE. 
	APPLY "U1":u TO qbf-widxit.
      END.
      ELSE DO: /* form */
	/* For horizontal sizing, we can expand the frame but we can only
	   shrink it to eliminate empty space.  All the widgets must fit.
	   Actually we could shrink the frame arbitrarily and get scrollbars.
	   But then if we switch views or save and try to regen from there,
	   it won't work because we'd set the frame to be some width which
	   wouldn't be wide enough for the widgets.  We'd get errors that
	   the widgets don't fit.  The only way to avoid this is to make
	   the frame scrollable at compile time but we can't do this 
	   because then Progress thinks there is no limit to the virtual
	   space and no longer wraps the fields based on the width during
	   layout (This would be OK only if all rows and columns were 
	   explicit but they aren't always - i.e., new fields.)  
	   This way, we'll store the width so when we do regen we will
	   make the frame big enough to fit the widgets.
	*/
	IF NOT h_growing THEN DO:
	  /* First find out the max x in all frames */
	  max_x = 0.
	  FOR EACH qbf-fwid:
	    ASSIGN
	      hdl = qbf-fwid.qbf-fwmain
	      max_x = MAX(max_x, hdl:X + hdl:WIDTH-PIXELS).
	  END.
	END.
	
	FOR EACH qbf-section WHERE qbf-section.qbf-shdl <> ?:
	  FIND FIRST qbf-frame WHERE 
	     qbf-frame.qbf-ftbl = qbf-section.qbf-stbl NO-ERROR.
	  IF h_growing AND wid > qbf-section.qbf-shdl:WIDTH-PIXELS THEN DO:
	    IF NOT AVAILABLE qbf-frame THEN DO:
	      CREATE qbf-frame.
	      qbf-frame.qbf-ftbl = qbf-section.qbf-stbl.
	    END.
	    ASSIGN
	      /* store width value in characters */
	      qbf-frame.qbf-fwdt = MAXIMUM(qbf-win:WIDTH,def-win-wid)
	      qbf-section.qbf-shdl:WIDTH-PIXELS = wid.

	    /* have to expand dialogs too */
	    RUN set_dialog_width (qbf-section.qbf-shdl, wid, FALSE).
	  END.
	  ELSE IF NOT h_growing THEN DO:
	    ASSIGN
	      hdl                      = qbf-section.qbf-shdl
	      fhdl                     = hdl
	      hdl:WIDTH-PIXELS         = MAXIMUM(max_x + {&SIDE_BORDERS},wid)
	      hdl:VIRTUAL-WIDTH-PIXELS = hdl:WIDTH-PIXELS.
	    /* have to expand dialogs too */
	    RUN set_dialog_width (hdl, hdl:WIDTH-PIXELS, TRUE).

	    /* update stored frame width */
	    IF AVAILABLE qbf-frame AND qbf-frame.qbf-fwdt <> 0 THEN
	      qbf-frame.qbf-fwdt = hdl:WIDTH.
	  END.
	END. /* end FOR EACH qbf-section */
      END. /* end width change */
    END. /* end can-do "b,f" */
  END.

  ASSIGN
    old_hit = qbf-win:HEIGHT-PIXELS
    old_wid = qbf-win:WIDTH-PIXELS.
END. /* ON WINDOW-RESIZED OF qbf-win */

/*------------------------- Mainline Code ----------------------------------*/

RUN adecomm/_status.p (qbf-win,"48,18,22":u,TRUE,4,OUTPUT wGlbStatus, 
		       OUTPUT iFields).

CREATE MENU _menuBar ASSIGN POPUP-ONLY = FALSE.

ASSIGN
  /* Set CURRENT-WINDOW here, so mods to FRAME fToolbar don't affect logo
     screen (bug 98-09-01-043) */
  CURRENT-WINDOW               = qbf-win
  def-wid-pix                  = qbf-win:WIDTH-PIXELS 
  def-hit-pix                  = qbf-win:HEIGHT-PIXELS 
  old_hit                      = def-hit-pix 
  old_wid                      = def-wid-pix 
 
  FRAME fHeader:THREE-D        = SESSION:THREE-D 
  FRAME fLabel:THREE-D         = SESSION:THREE-D 
  FRAME fToolbar:THREE-D       = SESSION:THREE-D 
  FRAME fToolbar:BGCOLOR       = 8 
  FRAME fToolbar:WIDTH-PIXELS  = def-wid-pix  
  FRAME fToolbar:HEIGHT-PIXELS = {&mnuIconSize} + 6
             			       + crit-box:HEIGHT-PIXELS IN FRAME fToolbar 
  bcg-rect1:WIDTH-PIXELS IN FRAME fToolbar  = FRAME fToolbar:WIDTH-PIXELS  
  bcg-rect1:HEIGHT-PIXELS IN FRAME fToolbar = FRAME fToolbar:HEIGHT-PIXELS  
  crit-box:BGCOLOR IN FRAME fToolbar        = 15
  crit-box:Y IN FRAME fToolbar              = {&mnuIconSize} + 2
  currhdl                                   = crit-box:SIDE-LABEL-HANDLE
  currhdl:Y                                 = crit-box:Y IN FRAME fToolbar.
  
ASSIGN
  crit-box:FORMAT IN FRAME fToolbar         = "x(256)":u NO-ERROR.
  
ASSIGN
  crit-box:X IN FRAME fToolbar              = currhdl:X + currhdl:WIDTH-PIXELS + 5
  crit-box:WIDTH-PIXELS IN FRAME fToolbar   = FRAME fToolbar:WIDTH-PIXELS 
                               - crit-box:X IN FRAME fToolbar - 2
  fhdl                                      = FRAME fLayout:HANDLE
  FRAME fLayout:THREE-D                     = SESSION:THREE-D
  FRAME fLayout:WIDTH-PIXELS                = def-wid-pix
  FRAME fLayout:FONT                        = 0
  fDesign:READ-ONLY IN FRAME fLayout        = TRUE
  fDesign:SENSITIVE IN FRAME fLayout        = TRUE
  winTitle                                  = qbf-win:TITLE
  qbf-win:MENUBAR                           = _menuBar
  .

&IF DEFINED(timestartup) &THEN
  { adeshar/mp.i &MP-MACRO="stotal" &TIMER="foo" &INFOSTR="+minit" }
&ENDIF

RUN adeshar/_minit.p ({&resId},
		     USERID("DICTDB":u),
		     _adminMenuFile,
		     "aderes/_mstate.p":u,
		     "aderes/_mset.p":u,
		     _sfCheckSecurity,
		     _menuBar,
		     FRAME fToolbar:HANDLE,
		     wGlbStatus,
		     ?,
		     "",
		     TRUE,
		     OUTPUT lRet).

&IF DEFINED(timestartup) &THEN
  { adeshar/mp.i &MP-MACRO="stotal" &TIMER="foo" &INFOSTR="-minit" }
&ENDIF

/*
 * If we are in an initial startup then write out the default layout into
 * the fast loading menu file. This has to be done here, after the menu
 * and toolbar has been created and populated.
 */
IF _newConfig = TRUE THEN DO:
  _adminMenuFile = qbf-fastload + "mt.p":u.

  RUN aderes/_awrite.p (2).
  RUN aderes/_amwrite.p (2).
  RUN aderes/_afwrite.p (2).
END.

/*
 * Another situation that has to be handled is: There is an ASCII config 
 * file, but all of the rcode is gone. Most of the stuff has been handled.
 * That is, most of the rcode has been recreated, except for the
 * UI file. Do that now.
 */

IF _uiDirty = TRUE THEN 
  RUN aderes/_amwrite.p (2).

ASSIGN
  qbf-widxit = qbf-win
  qbf-dirty  = FALSE
  qbf-redraw = TRUE
  .

IF qbf-dir-ent# = 0 THEN DO:

  /*
   * Set the initial query directory properly.
   *
   *   1. Own directory if there are queries in it.
   *   2. If not 1 then public directory (regardless of count),
   *   with permission
   *   3. If not 2 then own directory.
   */

  RUN adeshar/_mgetfs.p ({&resId}, {&rfReadPublicDir}, OUTPUT _rPublic).
  RUN adeshar/_mgetfs.p ({&resId}, {&rfWritePublicDir}, OUTPUT _wPublic).
  RUN adeshar/_mgetfs.p ({&resId}, {&rfReadOtherDir}, OUTPUT _rOther).
  RUN adeshar/_mgetfs.p ({&resId}, {&rfWriteOtherDir}, OUTPUT _wOther).

  qbf-qdfile = qbf-qdhome.

  RUN aderes/i-read.p (INPUT-OUTPUT qbf-qdfile).

  IF qbf-dir-ent# = 0 THEN DO:
    RUN adeshar/_mgetfs.p ({&resId}, {&rfReadPublicDir}, OUTPUT qbf-l).

    IF qbf-l THEN DO:
      qbf-qdfile = qbf-qdpubl.

      RUN aderes/i-read.p (INPUT-OUTPUT qbf-qdfile).

      /* If the public file isn't there then usr's query directory file */
      IF qbf-qdfile = ? THEN qbf-qdfile = qbf-qdhome.
    END.
    ELSE qbf-qdfile = qbf-qdhome.
  END.
END.

&IF DEFINED(timestartup) &THEN
  { adeshar/mp.i &MP-MACRO="total" &TIMER="foo"
		 &INFOSTR="Done with startup timer." }
&ENDIF

logohdl = qbf-wlogo:FIRST-CHILD. /* logo frame */

IF VALID-HANDLE(logohdl) THEN  /* may not be there if user had his own logo */
  DELETE WIDGET logohdl.

IF VALID-HANDLE(qbf-wlogo) THEN 
  DELETE WIDGET qbf-wlogo.

RUN adecomm/_setcurs.p (""). /* end startup phase */
ASSIGN
 SESSION:IMMEDIATE-DISPLAY     = FALSE
 SESSION:MULTITASKING-INTERVAL = 0
 qbf-win:VISIBLE               = TRUE
 
 /* You can only do this after the window is visible */
 qbf-win:MAX-WIDTH             = qbf-win:FULL-WIDTH
 qbf-win:MAX-HEIGHT            = qbf-win:FULL-HEIGHT
 .

main_loop:  
DO WHILE TRUE ON ERROR UNDO,RETRY ON ENDKEY UNDO,RETRY:
  RUN adecomm/_setcurs.p ("WAIT":u).
  RUN aderes/s-level.p.
  
  winTitle = qbf-product.
  CURRENT-WINDOW:TITLE = IF qbf-name > "" THEN  
			   winTitle + " - [":u + qbf-name + "]":u
			 ELSE winTitle.

  IF qbf-module <> ? THEN
  RUN adecomm/_statdsp.p (wGlbStatus, 2,
    ENTRY(INDEX("elrfb":u,qbf-module),"Export,Label,Report,Form,Browse") + 
    " View" + (IF qbf-dirty THEN " (mod)" ELSE "")).
    
  IF qbf-redraw THEN DO:
    RUN redraw_canvas.
    qbf-redraw = FALSE.
  END.

  ASSIGN
    CURRENT-WINDOW:HIDDEN = FALSE
    lExit                 = FALSE.
  RUN adecomm/_statdsp.p (wGlbStatus,1,"").

  IF NOT qbf-use-rowids THEN
    qbf-rowids = "". /* clear current rowids used in form/browse */

  qbf-wait = YES.
  IF CAN-DO("b,f":u, qbf-module) THEN DO:
    RUN aderes/s-write.p (qbf-tempdir + ".p":u,"r":u +
			 (IF winResize AND qbf-module = "b":u 
			  THEN "r":u ELSE "")).
    winResize = FALSE.
    
    IF NOT (RETURN-VALUE = "ok":u OR RETURN-VALUE = "") THEN DO:
      RUN reset_return_value. /* otherwise we may be in infinite loop */
      NEXT main_loop.
    END.

    COMPILE VALUE(qbf-tempdir + ".p":u) NO-ERROR. /* dma */

    IF qbf-module = "f":u THEN DO:
      IF NOT COMPILER:ERROR THEN
	 COMPILE VALUE(qbf-tempdir + "q1.p":u) NO-ERROR.

      IF qbf-detail > 0 AND NOT COMPILER:ERROR THEN
	 COMPILE VALUE(qbf-tempdir + "q2.p":u) NO-ERROR.
    END.

    IF COMPILER:ERROR THEN DO:
      /* show compiler error messages -dma */
      ASSIGN
	qbf-d      = ""
	qbf-redraw = TRUE.
	
      DO qbf-i = 1 to ERROR-STATUS:NUM-MESSAGES:
	qbf-d = (IF qbf-d = "" THEN "" ELSE qbf-d + CHR(10))
	      + ERROR-STATUS:GET-MESSAGE(qbf-i). 
      END.
      qbf-d = "Could not switch to " +
	ENTRY(INDEX("elrfb":u,qbf-module),"Export,Label,Report,Form,Browse") 
	+ " View because of these errors:" + CHR(10) + CHR(10) + qbf-d.

      MESSAGE qbf-d VIEW-AS ALERT-BOX ERROR BUTTONS OK.

      qbf-module = "r":u.
      RUN adecomm/_statdsp.p (wGlbStatus,1,"Switching to Report View").
      
      /* This calls _mstate to reset the menus for report view */
      RUN adeshar/_machk.p ({&resId},OUTPUT qbf-l).
      NEXT main_loop.
    END.
    ELSE
      /* compile is ok so we'll wait in generated code, not here */
      qbf-wait = NO.
  END.
  RUN adecomm/_setcurs.p ("").

  IF qbf-wait THEN 
    WAIT-FOR U1 OF qbf-widxit.
  ELSE
    RUN VALUE(qbf-tempdir + ".p":u). /* run form or browse code */

  IF lExit = ? THEN LEAVE.
END. /* main_loop */

RETURN.

/*--------------------------------------------------------------------------*/

/* You can't reset return-value directly so we have to do this thing.*/
PROCEDURE reset_return_value:
  RETURN "".
END.

/*--------------------------------------------------------------------------*/

PROCEDURE redraw_canvas:
  HIDE MESSAGE NO-PAUSE.

  RUN adeshar/_mcheckm.p ({&resId}, OUTPUT lRet).

  SESSION:IMMEDIATE-DISPLAY = yes.

  FIND FIRST qbf-esys. /* WHERE qbf-esys.qbf-live NO-ERROR. */
  FIND FIRST qbf-rsys WHERE qbf-rsys.qbf-live NO-ERROR. 
  FIND FIRST qbf-lsys. /* WHERE qbf-lsys.qbf-live NO-ERROR. */

  HIDE FRAME fHeader  NO-PAUSE. 
  HIDE FRAME fLabel   NO-PAUSE. 
  HIDE FRAME fLayout  NO-PAUSE. 

  IF lGlbToolBar THEN
    ASSIGN
      FRAME fLayout:HEIGHT-PIXELS = CURRENT-WINDOW:HEIGHT-PIXELS
				  - FRAME fToolbar:HEIGHT-PIXELS 
				  - {&STATUS_HT}
      FRAME fLayout:Y             = FRAME fToolbar:HEIGHT-PIXELS 
    .
  ELSE
    ASSIGN
      FRAME fLayout:Y             = 0
      FRAME fLayout:HEIGHT-PIXELS = CURRENT-WINDOW:HEIGHT-PIXELS
				  - {&STATUS_HT}
    .

  ASSIGN
    fhdl               = FRAME fLayout:HANDLE
    wGlbStatus:VISIBLE = lGlbStatus
  .
 
  IF lGlbToolBar THEN DO:
    RUN aderes/_updcrit.p. 
    crit-box:SENSITIVE IN FRAME fToolbar = qbf-module <> ?.
    VIEW FRAME fToolbar.
  END.
  ELSE DO:
    DISABLE ALL WITH FRAME fToolbar.
    HIDE FRAME fToolbar NO-PAUSE.
  END.

  newfile = 
    &IF "{&WINDOW-SYSTEM}":u = "OSF/Motif":u &THEN
      SUBSTRING(qbf-qcfile,R-INDEX(qbf-qcfile,"/":u) + 1,-1,"CHARACTER":u).
    &ELSE 
      SUBSTRING(qbf-qcfile,R-INDEX(qbf-qcfile,"~\":u) + 1,-1,"CHARACTER":u).
    &ENDIF

  RUN adecomm/_statdsp.p (wGlbStatus,3,CAPS(newfile)).
  
  IF qbf-module = ? THEN DO:
    HIDE FRAME fLayout  NO-PAUSE.
    HIDE FRAME fHeader  NO-PAUSE.
    HIDE FRAME fLabel   NO-PAUSE.

    RUN adecomm/_statdsp.p (wGlbStatus,2,"").
    SESSION:IMMEDIATE-DISPLAY = no.
    RETURN.
  END.

  /* clear FRAME fLayout - dma */
  IF CAN-DO("e,r":u, qbf-module) THEN DO:
    ASSIGN
      currhdl = FRAME fLayout:HANDLE
      currhdl = currhdl:FIRST-CHILD  /* field group */
      currhdl = currhdl:FIRST-CHILD  /* first widget */
      .
  
    /* walk the widget tree, deleting any text widgets */  
    DO WHILE currhdl <> ?:
      nexthdl = currhdl:NEXT-SIBLING. /* next text widget */
      IF fDesign:HANDLE IN FRAME fLayout <> currhdl THEN    
	DELETE WIDGET currhdl.
	
      currhdl = nexthdl.
    END.
  END.
  
  CASE qbf-module:
    WHEN "r":u THEN RUN aderes/_rdraw.p (FRAME fLayout:HANDLE).
    WHEN "l":u THEN RUN aderes/_ldraw.p.
    WHEN "e":u THEN RUN aderes/_edraw.p (OUTPUT fDesign, OUTPUT fWidth).
  END CASE.

  IF CAN-DO("e,r":u, qbf-module) THEN DO:
    HIDE FRAME fHeader NO-PAUSE.
    HIDE FRAME fLabel NO-PAUSE.
    
    IF qbf-module = "e":u THEN DO:
      ASSIGN
        fDesign:VISIBLE IN FRAME fLayout      = FALSE
	/*SESSION:IMMEDIATE-DISPLAY             = FALSE*/
	fDesign:WIDTH IN FRAME fLayout        = 5
	fDesign:HEIGHT IN FRAME fLayout       = 5
	qbf-i                                 = qbf-win:HEIGHT-PIXELS 
					      - {&STATUS_HT} - {&TOOLBAR_HT}
	FRAME fLayout:VIRTUAL-WIDTH           = MAXIMUM(qbf-win:WIDTH,fWidth)        
	FRAME fLayout:VIRTUAL-HEIGHT          = FONT-TABLE:GET-TEXT-HEIGHT(0)
					      * NUM-ENTRIES(fDesign,CHR(10))
	fDesign:SCREEN-VALUE IN FRAME fLayout = fDesign
	.

      IF FRAME fLayout:VIRTUAL-HEIGHT-PIXELS < qbf-i THEN
	FRAME fLayout:VIRTUAL-HEIGHT-PIXELS = qbf-i.

      ASSIGN
	FRAME fLayout:HEIGHT-PIXELS            = qbf-i
	fDesign:WIDTH-PIXELS IN FRAME fLayout  = 
	  FRAME fLayout:VIRTUAL-WIDTH-P - {&SIDE_BORDERS} - 2
	fDesign:HEIGHT-PIXELS IN FRAME fLayout = 
	  FRAME fLayout:VIRTUAL-HEIGHT-P - {&TOP_BOTTOM_BORDERS} - 2
	/*SESSION:IMMEDIATE-DISPLAY              = TRUE*/
        fDesign:VISIBLE IN FRAME fLayout       = TRUE
        .
    END.
      
    VIEW FRAME fLayout.
  END.
   
  ELSE IF qbf-module = "l":u THEN DO:
    HIDE FRAME fLayout NO-PAUSE.
    ENABLE ALL WITH FRAME fLabel.
    ENABLE ALL WITH FRAME fHeader.
    VIEW FRAME fHeader.
    VIEW FRAME fLabel.
  END.

  ELSE DO:
    HIDE FRAME fLayout NO-PAUSE.
    HIDE FRAME fHeader NO-PAUSE.
    HIDE FRAME fLabel NO-PAUSE.
  END.

  SESSION:IMMEDIATE-DISPLAY = no.
END PROCEDURE.

/*--------------------------------------------------------------------------*/

/* Given a handle to the main frame, get the corresponding dialog
   handles and change the dialog widths to match the main frame.
*/
PROCEDURE set_dialog_width:
  DEFINE INPUT PARAMETER hdl_main AS HANDLE   NO-UNDO.
  DEFINE INPUT PARAMETER new_wid  AS DECIMAL  NO-UNDO.
  DEFINE INPUT PARAMETER virt     AS LOGICAL  NO-UNDO.

  DEFINE VARIABLE b-hdl AS HANDLE   NO-UNDO. /* button handle */
  DEFINE VARIABLE hdl   AS HANDLE   NO-UNDO.
  DEFINE VARIABLE fudge AS INTEGER  NO-UNDO.

  fudge = 
    &IF "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u &THEN 
      2 * SESSION:PIXELS-PER-COLUMN.
    &ELSE 
      0.
    &ENDIF

  /* Get the first fill-in widget so we can get a qbf-fwid record
     so we can get a widget from the dialogs so we can get that 
     widget's parent (the dialog frame).  Whew!
  */
  ASSIGN
    hdl = hdl_main:FIRST-CHILD /* group */
    hdl = hdl:FIRST-CHILD. /* widget */
  DO WHILE hdl <> ?:
    IF hdl:TYPE = "FILL-IN":u THEN LEAVE.
    hdl = hdl:NEXT-SIBLING.
  END.
  FIND FIRST qbf-fwid WHERE qbf-fwid.qbf-fwmain = hdl.
  
  /* query-by-example dialog box */ 
  ASSIGN
    hdl = qbf-fwid.qbf-fwqbe:FRAME
    hdl:WIDTH-PIXELS = new_wid + fudge.
  IF virt THEN     
    hdl:VIRTUAL-WIDTH-PIXELS = new_wid + fudge.

  /* find and move help button if window resized */
  ASSIGN
    b-hdl = hdl:FIRST-CHILD   /* group */
    b-hdl = b-hdl:LAST-CHILD. /* last widget */
  DO WHILE b-hdl <> ?:
    IF b-hdl:TYPE = "BUTTON":u AND b-hdl:LABEL = "&Help" THEN LEAVE.
    b-hdl = b-hdl:PREV-SIBLING.
  END.
  IF b-hdl <> ? THEN 
    b-hdl:COL = hdl:WIDTH - b-hdl:WIDTH - 1.

  /* add-copy-update dialog box */ 
  hdl = qbf-fwid.qbf-fwdlg.
  IF hdl <> ? THEN DO:
    ASSIGN
      hdl = hdl:FRAME
      hdl:WIDTH-PIXELS = new_wid + fudge.
    IF virt THEN 
      hdl:VIRTUAL-WIDTH-PIXELS = new_wid + fudge.
  END.
END.

/* y-menu.p - end of file */

