/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* f-format.p - Do special processing for applying property changes to
      	        forms without having to regenerate the .p.
 
   Returns ""  	   = ok 
      	   "regen" = apply U1 so form code is regenerated after all 
      	   "error" = attributes need to be fixed by user (error is displayed
      	       	     here)
*/
 
{ aderes/y-define.i }
{ aderes/s-define.i }
{ aderes/s-system.i }
{ aderes/fbdefine.i }
 
DEFINE VARIABLE ix     AS INTEGER  NO-UNDO. /* generic index */
DEFINE VARIABLE len    AS INTEGER  NO-UNDO. /* format length */
DEFINE VARIABLE ht     AS DECIMAL  NO-UNDO. /* orig frame height */
DEFINE VARIABLE newht  AS DECIMAL  NO-UNDO. /* new main frame ht */
DEFINE VARIABLE dlght  AS DECIMAL  NO-UNDO. /* new dlg frame ht */
DEFINE VARIABLE newbtm AS DECIMAL  NO-UNDO. /* new bottom of fld space */
DEFINE VARIABLE curbtm AS DECIMAL  NO-UNDO. /* current btm of fld space */
DEFINE VARIABLE brow   AS DECIMAL  NO-UNDO. /* row for buttons */
DEFINE VARIABLE frow   AS DECIMAL  NO-UNDO. /* field row */
DEFINE VARIABLE siz    AS DECIMAL  NO-UNDO. /* for setting field width */
DEFINE VARIABLE hmain  AS HANDLE   NO-UNDO. /* main frame handle */
DEFINE VARIABLE hdlg   AS HANDLE   NO-UNDO. /* dlg frame handle */
DEFINE VARIABLE hqbe   AS HANDLE   NO-UNDO. /* qbe dlg frame handle */
DEFINE VARIABLE fwid   AS HANDLE   NO-UNDO. /* a temp fill-in widget */
DEFINE VARIABLE rowht  AS DECIMAL  NO-UNDO. /* height of a fill row */
 
/*=========================Internal Procedures===========================*/
 
/* PROCEDURE Move_Buttons */
{ aderes/fmovbtn.i } 
 
PROCEDURE Resize_Frame:
  ASSIGN
    hmain:HEIGHT          = {aderes/statchk.i &ht = newht &row = hmain:ROW}
    hmain:VIRTUAL-HEIGHT  = newht
    hqbe:HEIGHT           = MINIMUM(dlght, SESSION:HEIGHT)
    hqbe:VIRTUAL-HEIGHT   = dlght.
    
  IF hdlg <> ? THEN
    ASSIGN
      hdlg:HEIGHT         = MINIMUM(dlght, SESSION:HEIGHT)
      hdlg:VIRTUAL-HEIGHT = dlght.
END.
 
/*--------------------------------------------------------------
   Apply all the attributes except FORMAT since that's a little
   different for qbe vs. non-qbe widgets.  So it's just label,
   row and column.  ix is index into rcx arrays.
---------------------------------------------------------------*/
PROCEDURE Apply_Attributes:
  DEFINE INPUT PARAMETER p_hdl AS HANDLE NO-UNDO. /* field widget hdl */
 
  DEFINE VARIABLE oldwid AS DECIMAL	  NO-UNDO. /* old label width*/
  DEFINE VARIABLE newwid AS DECIMAL	  NO-UNDO. /* new label width*/
  DEFINE VARIABLE oldlbl AS CHARACTER NO-UNDO. /* label before change */
  DEFINE VARIABLE hlbl   AS HANDLE    NO-UNDO. /* side label handle */
  DEFINE VARIABLE suplbl AS LOGICAL   NO-UNDO. /* support label? */
  DEFINE VARIABLE lcol   AS DECIMAL   NO-UNDO. /* col of label or filin */
  DEFINE VARIABLE fcol   AS DECIMAL   NO-UNDO. /* column of fillin */
  DEFINE VARIABLE lbl    AS CHARACTER NO-UNDO. /* new label */
  DEFINE VARIABLE fudge  AS INTEGER   NO-UNDO INITIAL
    &IF "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u 
        &THEN 0 &ELSE 1 &ENDIF .
        
  ASSIGN   
    frow   = DECIMAL({aderes/strtoe.i &str="ENTRY({&F_ROW},qbf-rcp[ix])"})
    /* adjust for extra gap on Windows */
    frow   = (INTEGER((frow - 1) / qbf-fillht) * rowht) + 1
    lcol   = DECIMAL({aderes/strtoe.i &str="ENTRY({&F_COL},qbf-rcp[ix])"})
    oldlbl = p_hdl:LABEL
    hlbl   = ?
    hlbl   = p_hdl:SIDE-LABEL-HANDLE NO-ERROR.
 
  /* certain widget types (e.g.toggle boxes) don't have side labels or
     fill-in may have been NO-LABEL 
  */ 
  ASSIGN
    lbl = qbf-rcl[ix]
    {&FB_FIX_LABEL}.
  IF hlbl <> ? THEN DO: 
    IF LENGTH(lbl,"CHARACTER":u) > 0 THEN DO: 
      ASSIGN
        oldwid = hlbl:WIDTH
        newwid = FONT-TABLE:GET-TEXT-WIDTH(lbl + ": ":u, 0).
 
      /* If the label gets bigger, move it over first.  Progress expands
         labels to the left so the colon remains in the same place. If
         we try to reset the label and there isn't enough space on the left,
         internally, the label width is truncated to indicate only what's
         visible and no matter how much we move it around afterward, we will
         never see the whole string.
       */
      IF newwid > oldwid THEN
        hlbl:COL = hlbl:COL + (newwid - oldwid).
      IF hlbl:TYPE = "TEXT":u THEN
        /* Labels we created are text. If progress created them they're
           type literal and we can't set their format and don't have to.
           This must come before setting of label value.
        */
        ASSIGN
          hlbl:WIDTH  = newwid
          hlbl:FORMAT = SUBSTITUTE ("X(&1)", ROUND(newwid, 0)).
          p_hdl:LABEL = lbl + (IF hlbl:TYPE = "TEXT":u THEN ": ":u ELSE "").
    END.
    ELSE DO: /* hlbl exists but user wants null label */
      /* Make label invisible AND detach from widget.
         This is the ONLY way to make the colon not appear when the
         widget is displayed with UPDATE. Unfortunately, Progress
         won't let us delete hlbl if it's static so I guess it will 
         float in space forever!
      */
      ASSIGN
        p_hdl:LABEL             = "" /* don't really need but do it anyway */
        hlbl:HIDDEN             = yes
        p_hdl:SIDE-LABEL-HANDLE = ?
        hlbl                    = ?.
    END.
  END.
  ELSE DO: /* there is no label handle */
    /* If labels are supported for this widget type, sublbl will be
       yes or no depending on if widget was no-label etc. If not
       supported, suplbl will be unknown.
    */
    suplbl = p_hdl:LABELS NO-ERROR.
    IF LENGTH(lbl,"CHARACTER":u) > 0 AND suplbl <> ? THEN DO:
      /* user wants a label so create one */
      newwid = FONT-TABLE:GET-TEXT-WIDTH(lbl + ": ":u, 0).
      
      CREATE TEXT hlbl
        ASSIGN
          FRAME        = p_hdl:FRAME
          FORMAT       = SUBSTITUTE("X(&1)":u, ROUND(newwid, 0))
          WIDTH        = newwid
          HEIGHT       = p_hdl:HEIGHT
          SCREEN-VALUE = lbl + ": ":u /* must come after set of width */
          HIDDEN       = no.
      p_hdl:SIDE-LABEL-HANDLE = hlbl.
    END.
  END.
 
  /* Make sure widget will fit in the frame - only for main frame - dialogs
     will then use this info.
  */
  fcol = (IF hlbl = ? THEN lcol ELSE lcol + hlbl:WIDTH).
  IF p_hdl = qbf-fwid.qbf-fwmain THEN DO:
    siz              = 0.
    fwid:FORMAT      = qbf-rcf[ix]. /* set format on temp widget */
    fwid:WIDTH       = fwid:WIDTH NO-ERROR. /* avoids error about > 320 */
    fwid:AUTO-RESIZE = YES. /* setting width keeps turning this off so reset */
      
    /* fudge is to deal with frame border on different systems */
    IF (fcol + fwid:WIDTH) > (hmain:VIRTUAL-WIDTH - fudge) THEN
      siz = hmain:VIRTUAL-WIDTH - fudge - fcol.
 
    /* Unless we set width explicitly, format should determine width */
    IF siz = 0 THEN 
      p_hdl:AUTO-RESIZE = yes. 
  END.
 
  IF hlbl <> ? THEN 
    ASSIGN
      hlbl:ROW = frow
      hlbl:COL = lcol.

  p_hdl:ROW = frow.
  IF siz = 0 THEN 
    p_hdl:COL = fcol. 
  ELSE if siz > p_hdl:WIDTH THEN
    ASSIGN
      p_hdl:COL = fcol
      p_hdl:WIDTH = siz.
  ELSE
    ASSIGN
      p_hdl:WIDTH = siz
      p_hdl:COL = fcol.
END.
 
/*==========================Mainline Code================================*/

/* Get the frame handle for each of the three form frame types. */
FIND FIRST qbf-fwid.
ASSIGN
  hmain = qbf-fwid.qbf-fwmain:FRAME
  hqbe  = qbf-fwid.qbf-fwqbe:FRAME.
IF qbf-fwid.qbf-fwdlg <> ? THEN
  hdlg = qbf-fwid.qbf-fwdlg:FRAME.
 
/* Find the new bottom edge of the field widget at the highest 
   row (based on new values not applied yet).
   Also determine the current bottom value before the apply.
 
   Along the way, see if any of the rows (and columns) were set to
   0.  If so, we need to regen everything so Progress can do it's
   layout thing.
*/
rowht = qbf-fillht + {&ROW_GAP}.

FOR EACH qbf-fwid:
  ASSIGN
    curbtm = MAX(curbtm, qbf-fwid.qbf-fwmain:ROW + qbf-fwid.qbf-fwmain:HEIGHT)
    ix     = qbf-fwid.qbf-fwix
    frow   = DECIMAL({aderes/strtoe.i &str="ENTRY({&F_ROW},qbf-rcp[ix])"})
    .
 
  IF frow = 0 THEN
    RETURN "regen":u.
 
  /* make sure we do transformation for any extra row gap */
  newbtm = MAXIMUM(newbtm, (INTEGER((frow - 1) / qbf-fillht) * rowht) + 1 + 
      	       	     	qbf-fwid.qbf-fwmain:HEIGHT).
END.
 
/* If new row height is bigger than current frame, make the frame
   bigger now - so we can adjust widget positions without errors.
   Frame height for dialogs is smaller because there is only 1 button
   row instead of 2.  Actually it's the difference between 2 regular
   buttons and 1 default button.  
   Since we're dealing in character units, even though it's fractional,
   it's not very accurate - sometimes we lose pixels.  Add .2 just
   to make sure.
*/
ASSIGN
  ht    = hmain:VIRTUAL-HEIGHT  /* current frame size */
  brow  = newbtm + .5 + {&ROW_GAP}  /* where 1st button row belongs */
  newht = newbtm + (ht - curbtm) + .2 /* desired frame height */
  dlght = newbtm + (hqbe:VIRTUAL-HEIGHT - curbtm) + .2
  . 

IF newht > ht THEN 
  RUN Resize_Frame.
 
/* For Windows, the width of the fill-in is kind of indeterminate.
   To determine accurate values, create a temporary widget and query 
   its size after setting the format.  
   It doesn't hurt to do this on all platforms.
*/
CREATE FILL-IN fwid
  ASSIGN
    VISIBLE = no
    FONT    = 0.
 
/* Now apply the attributes to each field level widget. */
FOR EACH qbf-fwid:
  ix = qbf-fwid.qbf-fwix.
 
  /* Apply must come first in this case so we can check for width overflow
     before setting format.
  */
  RUN Apply_Attributes (qbf-fwid.qbf-fwmain). /* sets row, col & label */
  qbf-fwid.qbf-fwmain:FORMAT = qbf-rcf[ix].
  IF siz = 0 THEN
    siz = qbf-fwid.qbf-fwmain:WIDTH.
 
  RUN Apply_Attributes (qbf-fwid.qbf-fwqbe).
  ASSIGN len = {aderes/s-size.i &type=qbf-rct[ix] 
                                &format=qbf-rcf[ix]} NO-ERROR.
  ASSIGN
    qbf-fwid.qbf-fwqbe:SCREEN-VALUE = ""
    qbf-fwid.qbf-fwqbe:FORMAT       = SUBSTITUTE("x(&1)":u, len + 12).
 
  IF qbf-fwid.qbf-fwdlg <> ? THEN DO:
    RUN Apply_Attributes (qbf-fwid.qbf-fwdlg).

    ASSIGN
      /* must be unknown here, not "" since this is not necessarily a char
         string and "" may be invalid with the given format.
      */
      qbf-fwid.qbf-fwdlg:SCREEN-VALUE = ? 
      qbf-fwid.qbf-fwdlg:FORMAT       = qbf-rcf[ix].
  END.
END.
DELETE WIDGET fwid. /* don't need temp widget anymore */

/* Move the buttons up or down to accomodate new widget positions. */
FIND FIRST qbf-fwid.
RUN Move_Buttons (qbf-fwid.qbf-fwmain, brow).
RUN Move_Buttons (qbf-fwid.qbf-fwqbe, brow).
IF qbf-fwid.qbf-fwdlg <> ? THEN
  RUN Move_Buttons (qbf-fwid.qbf-fwdlg, brow).
 
/* Now if the desired frame height is smaller than the existing size,
   resize frame smaller.  We can do that now that all the widgets have 
   been moved.
*/
IF newht < ht THEN 
  RUN Resize_Frame.

RETURN "".
 
/* f-format.p - end of file */

