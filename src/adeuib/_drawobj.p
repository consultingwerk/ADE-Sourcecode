/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _drawobj.p

Description:
   The procedure to draw a widget of type _next_draw,
   from (_frmx,_frmy) to (_second_corner_x, _second_corner_y)
 
   It is basically a case statement based on _next_draw. 
         _next_draw    Meaning                                          
         ----------    --------------------   
          ?            Normal box-picking  
          BROWSE       Draw a browse          
          BUTTON       Draw a button   
          etc   Draw an etc.   
 
Input Parameters:
   goback2pntr: If FALSE, then we are not going back to pointer mode after
                drawing.  That means we need to reset the characteristics
                of the new widget to avoid marking it.

Output Parameters:
   <None>
   
   RETURN-VALUE is set to "NO DRAW" if the user cancelled the draw or if an
   error is found.

Author:  Wm.T.Wood

Date Created: 6/28/93

Date Modified: 
  rryan 12/7/93   Added combo box functionality)
  wood  2/16/95   Add SmartObject support
  gfs   2/17/95   Add db-fields hook
  wood  3/15/95   Add VBX control container
  jep   1/19/99   Code changes for bug fix 98-12-28-020.
  tsm   4/7/99    Added support for various Intl Numeric formats (in addition
                  to American and European) by using session set-numeric-format
                  method to set format back to user's setting after setting it
                  to American
----------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER goback2pntr      AS LOGICAL NO-UNDO.

&GLOBAL-DEFINE start_draw_cursor "CROSS":U
&GLOBAL-DEFINE min_box_size      8

&Global-define SKP &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN SKIP &ELSE &ENDIF

{adeuib/uniwidg.i}           /* Universal Widget TEMP-TABLE definition   */
{adeuib/sharvars.i}          /* Define _h_win, _frmx, _next_draw etc.    */
{adeuib/layout.i}            /* Layout temp-table definitions            */  
{adeuib/custwidg.i}          /* Custom Object and Palette definitions    */
{src/adm2/globals.i}
{adecomm/oeideservice.i}
/* INTERNAL PROCEDURES                                                   */

  DEFINE VAR f_bar_pos    AS INTEGER NO-UNDO.
  DEFINE VAR f_iter_pos   AS INTEGER NO-UNDO.
  DEFINE VAR itemp        AS INTEGER NO-UNDO.
  DEFINE VAR h-unit       AS INTEGER NO-UNDO.
  DEFINE VAR clck         AS LOGICAL NO-UNDO.
  DEFINE VAR drawn        AS LOGICAL NO-UNDO.
  DEFINE VAR ldummy       AS LOGICAL NO-UNDO.
  DEFINE VAR tfile        AS CHAR    NO-UNDO.
  DEFINE VAR v-unit       AS INTEGER NO-UNDO.
  DEFINE VAR y-move       AS INTEGER NO-UNDO.
  
  DEFINE BUFFER f_U FOR _U.
  DEFINE BUFFER f_L FOR _L.

  /* Emergency Exit - other core errors can cause _h_win or _h_frame to not
     be set.  This should never happen.  The user, however, will not notice if
     we just exit quietly.  We will be in big trouble if we try to draw anything.
     NOTE: Frames, Queries and SmartObjects can be drawn in a window, even if there 
     is no current _h_frame.*/
  IF (_h_win eq ?) THEN RETURN "NO DRAW":U.
  IF (_h_frame eq ?) THEN DO:

    IF _next_draw = "{&WT-CONTROL}":U THEN RETURN "NO DRAW":U.
    IF NOT (_next_draw EQ "FRAME":U OR _next_draw EQ "QUERY":U OR _object_draw NE ?) 
      THEN RETURN "NO DRAW":U.
  END.
 
  /* Emergency Check - if the start position is unknown, correct it.  
     This should never happen unless the window system looses events, 
     i.e. the MOUSE-SELECT-DOWN prior to a BOX-SELECT (but it does happen). */
  IF _frmx eq ? THEN _frmx = 0.
  IF _frmy eq ? THEN _frmy = 0.

  /* Don't do anything if we are trying to draw something inappropriate   */
  /* OR we are in in normal box-picking.                                  */
  IF (NOT _cur_win_type) AND CAN-DO("IMAGE,{&WT-CONTROL}":U, _next_draw) THEN DO:

    MESSAGE "Character mode windows cannot contain" _next_draw "objects."
     VIEW-AS ALERT-BOX WARNING BUTTONS OK.
    RUN choose-pointer.
    RETURN. 
  END.
    /* Special Exit Case: The user started to box draw, but decided not to
       make anything */
  IF _second_corner_x <> ? AND
       ABS(_second_corner_x - _frmx) < {&min_box_size} AND
       ABS(_second_corner_y - _frmy) < {&min_box_size} THEN 
          RETURN "NO DRAW":U.

    /* Truncate the coordinates to lower grid value. */
  IF (_h_frame <> ?) AND (_h_frame:GRID-SNAP) THEN
      ASSIGN h-unit = _h_frame:GRID-UNIT-WIDTH-PIXELS 
            _frmx  = h-unit * TRUNCATE (_frmx / h-unit,0)
            v-unit = _h_frame:GRID-UNIT-HEIGHT-PIXELS 
            _frmy  = v-unit * TRUNCATE (_frmy / v-unit,0).

    /* Fix unknown _second_corners */
  IF _second_corner_x = ? THEN
      ASSIGN _second_corner_x = _frmx
             _second_corner_y = _frmy.
  ELSE DO:  
      /* On a box-select it is possible to get a x,y position < 0 
         (if you drag from the lower-right to the top-left) */             
      if _frmx < 0 THEN _frmx = 0.
      if _frmy < 0 THEN _frmy = 0.
      /* Snap positions to grid */
      IF (_h_frame <> ?) THEN 
      DO:
        IF _h_frame:GRID-SNAP THEN 
            ASSIGN
              _second_corner_x = 
                MAX (_frmx,
                    (h-unit * 
                     TRUNCATE ((_second_corner_x + h-unit - 1) / h-unit, 0)) 
                    - 1)
              _second_corner_y =
                MAX (_frmy ,
                     (v-unit * 
                      TRUNCATE ((_second_corner_y + v-unit - 1) / v-unit, 0))
                     - 1).
        /* Check for the second corner occuring outside the normal frame */
        /* borders. Trucate the coordinates to lower grid value. */
        itemp = _h_frame:WIDTH-PIXELS - _h_frame:BORDER-LEFT-PIXELS -
                                        _h_frame:BORDER-RIGHT-PIXELS - 1.
        IF _second_corner_X > itemp THEN _second_corner_X = itemp.
        itemp = _h_frame:HEIGHT-PIXELS - _h_frame:BORDER-TOP-PIXELS -
                                         _h_frame:BORDER-BOTTOM-PIXELS - 1.
        IF _second_corner_Y > itemp THEN _second_corner_Y = itemp.
      END.
  END. /* else */

  /* if drawing a field-level widget in a frame with column labels then 
     handle special restrictions. */
  IF VALID-HANDLE(_h_frame) THEN 
  DO:
      FIND f_U WHERE f_U._HANDLE = _h_frame.
      FIND _C WHERE RECID(_C) = f_U._x-recid.
      FIND f_L WHERE RECID(f_L) = f_U._lo-recid.
      
      /* Check for displayed COLUMN-LABELS. */
      IF NOT f_L._NO-LABELS AND NOT _C._SIDE-LABELS THEN
        RUN column-adjustments.
      
  END.  /* Not drawing a frame. */
       
  /* Remove the cursor from the current window.  This is because some
     drawing routine bring up a dialog-box parented to the ACTIVE-WINDOW.
  */
  IF _h_win:TYPE eq "WINDOW":U AND _h_win:LOAD-MOUSE-POINTER ("":U) THEN. 
            
  /* Now draw - First look for a  VBX Controls, then SmartObject. */
  IF _next_draw eq "{&WT-CONTROL}":U THEN 
      RUN adeuib/_drwcont.p.
  ELSE IF _object_draw ne ? THEN 
      RUN adeuib/_drwsmar.p.
  ELSE DO: 
      /* Draw a standard object (check for "Default" customizations) */
      IF _custom_draw eq ? AND
          CAN-FIND (_custom WHERE _custom._type eq _next_draw AND
                                  _custom._name eq "&Default":U)
      THEN _custom_draw = "&Default":U.
      CASE _next_draw:
        WHEN "BROWSE":U         THEN RUN draw_browse in _h_uib. /*  adeuib/_drwbrow.p.*/
        WHEN "BUTTON":U         THEN RUN adeuib/_drwbutt.p.
        WHEN "COMBO-BOX":U      THEN RUN adeuib/_drwcomb.p (_C._SIDE-LABELS).
        WHEN "EDITOR":U         THEN RUN adeuib/_drwedit.p.
        WHEN "FILL-IN":U        THEN RUN adeuib/_drwfill.p (_C._SIDE-LABELS).
        WHEN "FRAME":U          THEN RUN adeuib/_drwfram.p (YES). /* Use a box */
        WHEN "IMAGE":U          THEN RUN adeuib/_drwimag.p.
        WHEN "QUERY":U          THEN RUN draw_query in _h_uib. /*adeuib/_drwqry.p. */
        WHEN "RADIO-SET":U      THEN RUN adeuib/_drwradi.p.
        WHEN "RECTANGLE":U      THEN RUN adeuib/_drwrect.p.
        WHEN "SELECTION-LIST":U THEN RUN adeuib/_drwsele.p.
        WHEN "SLIDER":U         THEN RUN adeuib/_drwslid.p.
        WHEN "TEXT":U           THEN RUN adeuib/_drwtext.p.
        WHEN "TOGGLE-BOX":U     THEN RUN adeuib/_drwtogg.p.
        WHEN "DB-FIELDS":U      THEN DO:
          FIND _P WHERE _P._WINDOW-HANDLE = _h_win NO-ERROR.
          IF _DynamicsIsRunning AND 
             AVAILABLE _P AND
             DYNAMIC-FUNCTION("ClassIsA" IN gshRepositoryManager, _P.object_type_code, "DynView":U) THEN
          DO:
            RUN adeuib/_drwdfld.p (INPUT '':U).
            drawn = YES.
          END.  /* if dynamic viewer and icf running */
          ELSE DO:
              /* Get a list of fields, and import them into the UIB */
              run adeuib/_drwflds.p(INPUT "", INPUT-OUTPUT drawn, OUTPUT tfile).
              /* signal that the call to draw will be done from ide 
                 and all of the post procedures and handling will be called 
                 from the ide_draw_fields call back   */
              if return-value = "IDE DRAW" then
                  return return-value.
              IF drawn THEN  
                  run draw_fields_from_file in _h_uib (tfile). 
          END.  /* else do */
        END.
        OTHERWISE 
          MESSAGE "Cannot draw object of type:" _next_draw
            VIEW-AS ALERT-BOX ERROR.
      END CASE.  
  END. 
    
  /* TRUE is passed unconditionally for all other than "DB-FIELDS" since 
     the call to winsave was done unconditionally before this was refactored
     for ide (correct for the choices that cannot be cancelled) */
  run post_drawobj in _h_uib (if _next_draw = "DB-FIELDS":U then drawn else true). 
 
  /* Return and reset return-value */
  RETURN. 
  

/***************************** Internal Procedures ***************************/  
 
/* Drawing a field level widget into a down frame is a problem  
   There are a series of adjustments that need to be made for  
   column labels.  This routine does those adjustments. */
PROCEDURE column-adjustments:
  ASSIGN f_bar_pos  = _C._FRAME-BAR:Y
         f_iter_pos = _C._ITERATION-POS
         clck       = FALSE.
  IF ABS(_second_corner_y - _frmy) < 4 THEN DO:  
    /* The user just clicked.  The second corner is on top of the
       first.  However, guess the minimum height of widgets in order
       to adjust the iteration size (frame-bar position).  We will
       change _second_corner_y later to correct for this */
    clck = TRUE.
    CASE _next_draw:
      WHEN "BROWSE":U          THEN
        _second_corner_y = _frmy + 2 * SESSION:PIXELS-PER-ROW.
      WHEN "BUTTON":U          THEN
        _second_corner_y = _frmy + 1.2 * SESSION:PIXELS-PER-ROW.
      WHEN "COMBO-BOX":U       THEN
        _second_corner_y = _frmy + 1 * SESSION:PIXELS-PER-ROW.
      WHEN "EDITOR":U          THEN
        _second_corner_y = _frmy + 2 * SESSION:PIXELS-PER-ROW.
      WHEN "FILL-IN":U         THEN
        _second_corner_y = _frmy + 1 * SESSION:PIXELS-PER-ROW.
      WHEN "IMAGE":U           THEN
        _second_corner_y = _frmy + 2.7 * SESSION:PIXELS-PER-ROW.
      WHEN "RADIO-SET":U       THEN
        _second_corner_y = _frmy + 2 * SESSION:PIXELS-PER-ROW.
      WHEN "RECTANGLE":U       THEN
        _second_corner_y = _frmy + 1 * SESSION:PIXELS-PER-ROW.
      WHEN "SELECTION-LIST":U  THEN
        _second_corner_y = _frmy + 2 * SESSION:PIXELS-PER-ROW.
      WHEN "SLIDER":U          THEN
        _second_corner_y = _frmy + 1.5 * SESSION:PIXELS-PER-ROW.
      WHEN "TEXT":U            THEN
        _second_corner_y = _frmy + .7 * SESSION:PIXELS-PER-ROW.
      WHEN "TOGGLE-BOX":U      THEN
        _second_corner_y = _frmy + .9 * SESSION:PIXELS-PER-ROW.
    END CASE.
  END. /* If a click */
 
  IF _frmy < f_bar_pos + 3 THEN       /* Can't draw in header  */
    ASSIGN y-move           = f_bar_pos + 3 - _frmy
           _frmy            = _frmy + y-move
           _second_corner_y = _second_corner_y + y-move.
  IF _second_corner_y > f_iter_pos THEN f_iter_pos = _second_corner_y.

  IF _next_draw = "FILL-IN" THEN DO: /* Make sure header is big enough */
                                     /* for the label                  */
    IF f_bar_pos < (_frmy - f_bar_pos - 3) + 
                      SESSION:PIXELS-PER-ROW * _cur_row_mult
    THEN y-move = _frmy - 2 * f_bar_pos - 3 +
                  SESSION:PIXELS-PER-ROW * _cur_row_mult.
    IF f_iter_pos + y-move > _h_frame:HEIGHT-P THEN DO:
      MESSAGE "Unable to fit the label of the Fill-in"  SKIP
              "into the frame header.  Resize the frame to be taller and" SKIP
              "try again." VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      RETURN "NO DRAW":U.
    END.

    IF y-move > 0 THEN DO:
      ASSIGN f_iter_pos        = f_iter_pos + y-move
             _C._ITERATION-POS = f_iter_pos
             _frmy            = _frmy + y-move
             _second_corner_y = _second_corner_y + y-move.
      RUN adeuib/_exphdr.p (y-move).
    END.  /* If have to expand header for a fill-in */
  END.  /* If bottom of the object goes below the iteration line */  
  
  /* Reset the second_corner of the draw box if the user just clicked */    
  IF clck THEN 
    _second_corner_y = _frmy.   
  
END PROCEDURE.  /* Handle column label restrictions */

/* _drawobj.p - end of file */
