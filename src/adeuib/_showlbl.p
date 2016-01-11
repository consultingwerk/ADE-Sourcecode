/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _showlbl.p

Description:
    Display the label of a widget just where Progress would.  This is used
    to reposition and show the label of fill-ins within the UIB.

Input Parameters:
   h_self          - The handle of the widget which has to be a fill-in.
    
Output Parameters:
   <none>
   
Author: Wm.T.Wood, Ross Hunter

Date Created: October 19, 1992 

----------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER h_self           AS WIDGET            NO-UNDO.

{adeuib/uniwidg.i}
{adeuib/layout.i}
{adeuib/sharvars.i}
{adecomm/oeideservice.i}

DEFINE VAR      h               AS WIDGET       NO-UNDO.
DEFINE VAR      h_lbl           AS WIDGET       NO-UNDO.
DEFINE VAR      fnt             AS INTEGER      NO-UNDO.
DEFINE VAR      f_bar_pos       AS INTEGER      NO-UNDO.
DEFINE VAR      f_iter_pos      AS INTEGER      NO-UNDO.
DEFINE VAR      f_side_labels   AS LOGICAL      NO-UNDO.
DEFINE VAR      i               AS INTEGER      NO-UNDO.
/* Note we care about the case of labels */
DEFINE VAR      lbl             AS CHAR         NO-UNDO  CASE-SENSITIVE.
DEFINE VAR      lbl_height      AS INTEGER      NO-UNDO.
DEFINE VAR      new_x           AS INTEGER      NO-UNDO.
DEFINE VAR      new_y           AS INTEGER      NO-UNDO.
DEFINE VAR      lbl_width       AS INTEGER      NO-UNDO.
DEFINE VAR      offset          AS INTEGER      NO-UNDO.
DEFINE VAR      tmp_hdl         AS WIDGET       NO-UNDO.

DEFINE BUFFER   label_U         FOR _U.
DEFINE BUFFER   frame_U         FOR _U.
DEFINE BUFFER   frame_L         FOR _L.

/* Define a SKIP for alert-boxes that only exists under Motif */
&Global-define SKP &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN SKIP &ELSE &ENDIF

/* h_self should be on _h_frame.  If it is not, then reset _h_frame and
   the associated frame variables */
FIND frame_U WHERE frame_U._HANDLE = h_self:FRAME.
FIND frame_L WHERE RECID(frame_L)  = frame_U._lo-recid.
FIND _C WHERE RECID(_C)  = frame_U._x-recid.
ASSIGN _h_frame      = frame_U._HANDLE
       _h_win        = frame_U._WINDOW-HANDLE 
       f_bar_pos     = IF frame_U._TYPE eq "DIALOG-BOX":U THEN 0 ELSE _C._FRAME-BAR:Y
       f_iter_pos    = _C._ITERATION-POS
       f_side_labels = _C._SIDE-LABELS.


/* Find the Universal widget record of the target and the label   */
FIND _U WHERE _U._HANDLE = h_self.
FIND _L WHERE RECID(_L)  = _U._lo-recid.
FIND _F WHERE RECID(_F) =  _U._x-recid.
FIND label_U WHERE RECID(label_U) = _U._l-recid NO-ERROR.

IF NOT AVAILABLE LABEL_U THEN
   RETURN.

/* Get the label handle */
h_lbl   = label_U._HANDLE.

IF NOT VALID-HANDLE(h_lbl) THEN
   RETURN.

/* Place object within frame boundary. */
{adeuib/onframe.i
   &_whFrameHandle = "_h_frame"
   &_whObjHandle   = "h_self"
   &_lvHidden      = yes}
   
   
/* Either we display the label at the proper spot, or we make it invisible */
IF frame_L._NO-LABELS OR _L._NO-LABELS OR _L._REMOVE-FROM-LAYOUT THEN DO:
  ASSIGN h_lbl:HIDDEN        = TRUE
         h_lbl:X             = 0
         h_lbl:Y             = 0
         h_lbl:WIDTH-PIXELS  = 1
         i                   = 1.
  /* Be sure to get rid of stacked labels if any */
  DO WHILE _F._STACK-LBL-HDL[i] NE ? AND i <= {&MaxTBL}:
    ASSIGN _F._STACK-LBL-HDL[i]:HIDDEN  = yes
           i                            = i + 1.
  END.
  /* Notify user that colon positioning is invalid for NO-LABEL column < 3 */
  IF _U._ALIGN eq "C" AND h_self:COL < 3 THEN DO:
      if OEIDE_CanShowMessage() then 
         run ShowOkMessage in hOEIDEService(
            _U._TYPE + " "
            + _U._NAME + "cannot be colon-positioned this"
            + " close to the left edge of the frame. The " 
            + LC(_U._TYPE)
            + " will be left-aligned instead.",
            "information",
            ?).
    else  
        MESSAGE _U._TYPE " "
            _U._NAME "cannot be colon-positioned this" {&SKP}
            "close to the left edge of the frame. The" LC(_U._TYPE)
            "will be" {&SKP}
            "left-aligned instead."
            view-as alert-box warning buttons OK.
    _U._ALIGN = "L".
  END.
END.
ELSE DO:  /* Must display the label */
  /* Modify the label to account for label string attributes and label src - 
     NOTE: the special case of column-labels for integer fill-ins. */
  IF (_U._LABEL-SOURCE = "D") AND (_U._TABLE EQ ?) THEN lbl = _U._NAME.
  ELSE IF _U._LABEL-ATTR EQ "" OR _U._LABEL-ATTR EQ "U" THEN lbl = _U._LABEL.
  ELSE RUN adeuib/_strfmt.p (INPUT _U._LABEL,
                             INPUT _U._LABEL-ATTR,
                             INPUT ((f_side_labels EQ no)   AND 
                                    CAN-DO("FILL-IN,COMBO-BOX",_U._TYPE)  AND
                                    (_F._DATA-TYPE = "INTEGER")),
                             OUTPUT lbl).
  /* Get the font for the label. This is the frame font. 
     IT IS NEVER THE WINDOW FONT BECAUSE THE WINDOW FONT IS NOT KNOWN BY
     THE COMPILER -- THIS IS A MAJOR SHORTCOMING OF NOT BEING ABLE TO DEFINE
     A WINDOW IN THE 4GL. */
  ASSIGN fnt            = _h_frame:FONT  
         h_lbl:HIDDEN   = yes     
         i              = 1.
  /* Be sure to get rid of stacked labels if any */
  DO WHILE _F._STACK-LBL-HDL[i] NE ? AND i <= {&MaxTBL}:
    ASSIGN _F._STACK-LBL-HDL[i]:HIDDEN  = yes
           i                            = i + 1.
  END.
  /* The label offset = the label length + a colon + space (if side-labels). */
  /* Remove single &'s for windows labels: && goes to & and & is nil. */
  IF f_side_labels eq no
  THEN offset = FONT-TABLE:GET-TEXT-WIDTH-PIXELS (lbl, fnt).
  ELSE offset = FONT-TABLE:GET-TEXT-WIDTH-PIXELS (
            &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN"
            &THEN REPLACE(REPLACE(REPLACE(lbl,"&&",CHR(10)),"&",""),CHR(10),"&")
            &ELSE lbl &ENDIF 
            + ": ", 
            fnt).
  
  /* Test Case that the label does not fit on the frame  with this label.  In
     which case we set the fill-in to no-label */
  IF f_side_labels AND (h_self:width-pixels + offset > _ivParentWidth) THEN DO:
      if OEIDE_CanShowMessage() then 
           ShowOkMessageInIDE(
                  "The Label """ + lbl + """ does not fit in the frame."  
                 + "The fill-in~'s attribute has been set to NO-LABEL.",
                 "warning",
                 ?).
      else 
           MESSAGE "The Label """ + lbl + """ does not fit in the frame." {&SKP}
                   "The fill-in~'s attribute has been set to NO-LABEL."
                   view-as alert-box WARNING buttons OK.
 
    ASSIGN h_lbl:HIDDEN        = yes
	   h_lbl:SCREEN-VALUE  = ""
	   h_lbl:X             = 0
	   h_lbl:Y             = 0
	   h_lbl:WIDTH-PIXELS  = 1
           _L._NO-LABELS       = TRUE
           _U._ALIGN           = "L".
  END.
  ELSE DO:
    /* Position the label at the new_x screen-value = fill-in:X - offset. */
    IF f_side_labels THEN DO:
      ASSIGN new_x       = h_self:X - offset.
      /* Is this a valid new column?   If not, put the label at x = 1. */
      IF new_x >= 0 THEN h_lbl:X = new_x.
      ELSE ASSIGN h_lbl:x  = 0
	          h_self:x = offset.

      /* The label is really narrower than "offset" (by the width of a space) */
	/* ksu 02/22/94 LENGTH use raw mode */
      h_lbl:WIDTH-PIXELS = offset - FONT-TABLE:GET-TEXT-WIDTH-P(" ",fnt).  

      /* Simulate the placement of SIDE-LABELS by the Progress 4GL */
      IF lbl <> ? THEN
      ASSIGN h_lbl:Y            = h_self:Y
	     h_lbl:FORMAT       = "X(" + STRING(INTEGER(LENGTH(lbl, "raw":U) + 1 )) + ")"
	     h_lbl:SCREEN-VALUE = lbl + ":".
      /* The height of a label equals the natural height of TEXT plus fill-in 
         decoration.   Decoration can be computed as 1.0 PPU - TEXT-HEIGHT(?).
         NOTE that we don't need to add in decoration for labels on TEXT  */
      lbl_height =  FONT-TABLE:GET-TEXT-HEIGHT-P(fnt).
      IF _U._SUBTYPE ne "TEXT":U AND _L._WIN-TYPE
      THEN lbl_height = lbl_height + SESSION:PIXELS-PER-ROW - 
                        FONT-TABLE:GET-TEXT-HEIGHT-P().      
      /* Watchout for Small Frames */
      IF h_lbl:Y + lbl_height > _ivParentHeight
        THEN lbl_height = _ivParentHeight - h_lbl:Y.
      ASSIGN h_lbl:HEIGHT-PIXELS = lbl_height
             h_lbl:HIDDEN       = _L._NO-LABELS OR _L._REMOVE-FROM-LAYOUT.
    END.  /* IF side-labels */

    ELSE DO: /* Columns-labels */
      /* First determine offset for column labels */
      IF NUM-ENTRIES(lbl,"!") > 1 THEN DO:
        offset = 0.
        DO i = 1 TO NUM-ENTRIES(lbl,"!"):
          offset = MAX(FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
                       ENTRY(i,lbl,"!"),fnt),offset).
        END.
      END.  /* More than 1 stacked label */
      FIND frame_U WHERE RECID(frame_U) = _U._PARENT-RECID NO-ERROR.
      IF NOT AVAILABLE frame_U THEN
        FIND frame_U WHERE frame_U._HANDLE = _h_frame.
      FIND _C WHERE RECID(_C) = frame_U._x-recid.
      ASSIGN new_x = IF CAN-DO("DECIMAL,INTEGER,RECID",_F._DATA-TYPE)
                       THEN h_self:X + h_self:WIDTH-P - offset
                       ELSE h_self:X.
      IF new_x < 0 THEN
        ASSIGN h_self:X = h_self:X - new_x
               new_x    = 0.
      IF new_x + offset > _ivParentWidth THEN
        ASSIGN h_self:X = h_self:X - (new_x + offset - _ivParentWidth)
               new_x    = _ivParentWidth - offset.
      ASSIGN h_lbl:X  = MAX(new_x, 0).
      IF f_iter_pos = ? THEN f_iter_pos = h_self:Y + h_self:HEIGHT-PIXELS.
 
      IF NUM-ENTRIES(lbl,"!") < 2 THEN DO:  /* NOT a stack of LABELS */
       ASSIGN new_y              = _C._FRAME-BAR:Y - f_iter_pos + h_self:Y - 1
	      h_lbl:Y            = MAX(new_y,0)
	      h_lbl:FORMAT       = 
                   "X(" + STRING(INTEGER(LENGTH(lbl, "raw":U)) + 1) + ")"
	      h_lbl:SCREEN-VALUE = lbl
              h_lbl:WIDTH-P      = offset
              h_lbl:HEIGHT-P     = FONT-TABLE:GET-TEXT-HEIGHT-P(fnt)
	      h_lbl:HIDDEN       = _L._NO-LABELS OR _L._REMOVE-FROM-LAYOUT.
      END.  /* NOT A STACK */
      ELSE DO:      /* GENERATE A STACK OF LABELS                          */
        h_lbl:HIDDEN = yes.
        DO i = 1 TO MIN(NUM-ENTRIES(lbl,"!"), {&MaxTBL}):
          IF _F._STACK-LBL-HDL[i] = ? THEN DO:    /* Does exist yet        */
            CREATE TEXT tmp_hdl
                   ASSIGN FRAME       = _h_frame
                          BGCOLOR     = ?  /* Must be unknown! If blank ...*/
                          FGCOLOR     = ?  /* ...they will inherit frame...*/
                          FONT        = ?  /* ...value explicitly          */
                          HIDDEN      = yes
                          AUTO-RESIZE = TRUE.
            _F._STACK-LBL-HDL[i] = tmp_hdl.
          END.  /* If label widget doesn't already exist.                  */
          ASSIGN tmp_hdl              = _F._STACK-LBL-HDL[i]
                 new_y                = _C._FRAME-BAR:Y - f_iter_pos +
                                        h_self:Y -
                                           (NUM-ENTRIES(lbl,"!") - i) *
                                            SESSION:PIXELS-PER-ROW  - 1  
                 tmp_hdl:AUTO-RESIZE  = FALSE
                 tmp_hdl:X            =
                                IF CAN-DO("DECIMAL,INTEGER,RECID",_F._DATA-TYPE)
                                THEN new_x + (offset -
                                           FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
                                           ENTRY(i,lbl,"!"),fnt))
                                ELSE new_x
                 tmp_hdl:X            = MAX(tmp_hdl:X, 0)
                 tmp_hdl:Y            = MAX(new_y,0)
                 tmp_hdl:FORMAT       =  
                      "X(" + STRING(INTEGER(LENGTH(ENTRY(i,lbl,"!"), "raw":U)) + 1) + ")"
                 tmp_hdl:SCREEN-VALUE = ENTRY(i,lbl,"!")
                 tmp_hdl:HIDDEN       = _L._NO-LABELS OR _L._REMOVE-FROM-LAYOUT.
        END.  /* DO i = 1 to num of labels */
      END.  /*  Generate a stack of labels */
    END. /* If column labels */
  END.  /* It will fit */

  IF NUM-ENTRIES(lbl,"!") > 1 AND NOT f_side_labels THEN
    ASSIGN h_lbl:SCREEN-VALUE = ?.      

  /* "move" our internal copy */
  ASSIGN _L._COL     = ((h_self:COL - 1) / _L._COL-MULT) + 1
	 _L._ROW     = ((h_self:ROW - 1) / _L._ROW-MULT) + 1
	 _L._WIDTH   = h_self:WIDTH-CHARS / _L._COL-MULT.
         
  IF NUM-ENTRIES(lbl,"!") = 1 AND NOT f_side_labels AND NOT _L._REMOVE-FROM-LAYOUT THEN
    ASSIGN h_lbl:HIDDEN       = no
           h_lbl:SCREEN-VALUE = lbl.      
  
  /*********************************
  MESSAGE
  "hidden :" h_lbl:hidden skip
  "labels :" frame_L._NO-LABELS skip
  "f width:" _h_frame:width-pixels skip
  "_ivParentWidth:" _ivParentWidth skip
  "new_x:" new_x skip
  "x:" h_lbl:x skip
  "y:" h_lbl:y skip
  "self y:" h_self:y skip
  "self x:" h_self:x skip
  "self width:" h_self:width-pixels skip
  "offset:" offset skip
  "width:" h_lbl:width-pixels skip
  "format:" h_lbl:format skip
  "value"   h_lbl:screen-value skip
  view-as alert-box error buttons Ok.
  **********************************/
END.
 
/* Show the fill-in itself.  Note that we have to reselect the object
   if it has been hidden. */
IF h_self:HIDDEN THEN DO:
  h_self:HIDDEN = _L._REMOVE-FROM-LAYOUT. 
  IF NOT h_self:HIDDEN AND _U._SELECTEDib THEN h_self:SELECTED = yes.
END.

