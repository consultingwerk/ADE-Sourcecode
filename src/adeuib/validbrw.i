/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: validbrw.i

Description:
   Include file that validates that browse widget dimensions are greater than
   the minimuns needed for a proper compile.

Arguments:
   NON-LOCAL REFERENCES: u_status from _gen4gl.p.  
   Also uses the global widget records _h_win, _L, _LAYOUT, and _U. (_gen4gl 
   includes them in appropriate include files).  
   
Author: D. Ross Hunter

Date Created: June 3, 1993

Modified: July 19, 1994: Patrick Tullmann - Added code to change the dimension
                         of all browsers if any one is below its minimum.  Now
                         only displays one message if more than one layout is
                         below the minimum.
----------------------------------------------------------------------------*/
DEFINE VAR max-height     AS DECIMAL INITIAL 10000                    NO-UNDO.
DEFINE VAR max-width      AS DECIMAL INITIAL 10000                    NO-UNDO.
DEFINE VAR min-height     AS DECIMAL                                  NO-UNDO.
DEFINE VAR min-so-far     AS DECIMAL /* Height */                     NO-UNDO.
DEFINE VAR browse-recid   AS RECID                                    NO-UNDO. 
        /* Recid of the _L browser record */
DEFINE VAR set-min-width  AS LOGICAL                                  NO-UNDO.
DEFINE VAR set-min-height AS LOGICAL                                  NO-UNDO.
DEFINE VAR set-integral   AS LOGICAL                                  NO-UNDO.
DEFINE VAR txt-fnt        AS INTEGER                                  NO-UNDO.
DEFINE VAR txt-hgt        AS DECIMAL                                  NO-UNDO.
DEFINE VAR txt-wdt        AS DECIMAL                                  NO-UNDO.

DEFINE BUFFER par_U FOR _U.
DEFINE BUFFER par_L FOR _L.

/* Find all of the browsers in this window */
FOR EACH _U WHERE _U._WINDOW-HANDLE = _h_win AND
                  _U._TYPE          = "BROWSE":U AND
                  _U._STATUS        = u_status:
  FIND _C WHERE RECID(_C) = _U._x-recid.
  
  /* Make sure user column widths get into the _BC records */
  FOR EACH _BC WHERE _BC._x-recid = RECID(_U):
    IF VALID-HANDLE(_BC._COL-HANDLE) THEN
      ASSIGN _BC._WIDTH = _BC._COL-HANDLE:WIDTH WHEN _BC._COL-HANDLE:WIDTH > 0.1.
  END.  /* FOR EACH column */
  
  ASSIGN min-height     = 0
         set-min-width  = false
         set-min-height = false
         set-integral   = false.
         
  /* For each variation (layout) of the browser,
     check the minimum configuration. */
  FOR EACH _L WHERE _L._u-recid = RECID(_U):
    min-so-far = 0.
    FIND _LAYOUT WHERE _LAYOUT._LO-NAME = _L._LO-NAME.
    FIND par_U WHERE RECID(par_U) = _U._PARENT-RECID.
    FIND par_L WHERE par_L._u-recid = RECID(par_U) AND
                     par_L._LO-NAME = _L._LO-NAME.
    ASSIGN max-height = MIN(max-height,par_L._HEIGHT -
                                       IF NOT _LAYOUT._GUI-BASED AND
                                          NOT par_L._NO-BOX THEN 2 ELSE 0)
           max-width  = MIN(max-width ,par_L._WIDTH -
                                       IF NOT _LAYOUT._GUI-BASED AND
                                          NOT par_L._NO-BOX THEN 2 ELSE 0)
           txt-fnt    = IF _L._FONT = ? THEN par_L._FONT ELSE _L._FONT.

    IF txt-fnt = ? THEN
      ASSIGN txt-hgt = FONT-TABLE:GET-TEXT-HEIGHT-CHARS()
             txt-wdt = FONT-TABLE:GET-TEXT-WIDTH-CHARS("W":U).
    ELSE
      ASSIGN txt-hgt = FONT-TABLE:GET-TEXT-HEIGHT-CHARS(txt-fnt)
             txt-wdt = FONT-TABLE:GET-TEXT-WIDTH-CHARS("W":U,txt-fnt).
    
    /* Check that the browser meets minimum width requirements */
    IF _L._WIDTH < 3 * txt-wdt THEN set-min-width = TRUE.

    /* Generate min height for active, included browsers in TTY mode */
    IF NOT _LAYOUT._GUI-BASED AND _LAYOUT._ACTIVE AND
       NOT _L._REMOVE-FROM-LAYOUT THEN DO:
      ASSIGN set-integral = TRUE
             min-so-far   = 4. /* In TTY minimum of two lines 
                                  of data in a browser. */
      IF NOT _L._NO-LABELS THEN
         min-so-far = min-so-far + 2. /* labels add two to height */
    END.
    /* Generate min height for GUI active, included browsers */
    ELSE IF _LAYOUT._GUI-BASED AND _LAYOUT._ACTIVE AND
         NOT _L._REMOVE-FROM-LAYOUT THEN DO:
      min-so-far = 2.8 * txt-hgt + 0.6 .
      IF NOT _L._NO-LABELS THEN min-so-far = min-so-far + 
                                               txt-hgt + .1 .
      IF _C._TITLE THEN min-so-far = min-so-far + 0.9 .
    END.
    /* Set min-height */
    min-height = MAX(min-height, min-so-far).
  END.  /* For each _L */
  /* Have looked at all _Ls and have a min-height that will work for all. */
  
  /* Now review _L's again to make give error if one is smaller than min */
  FOR EACH _L WHERE _L._u-recid = RECID(_U):
    IF _L._HEIGHT < min-height THEN set-min-height = TRUE.
  END. /* FOR EACH layout of the browser */

  /* Since browsers cannot (yet) have different sizes across layouts, we 
     must change all of the browsers in all of the layouts to have the
     same height and/or width. */
 
  IF set-min-height THEN DO:
    IF _U._HANDLE:HEIGHT < min-height * _cur_row_mult - .1 THEN
      MESSAGE _U._NAME "must be at least" min-height "characters high." SKIP
              "Resizing..." VIEW-AS ALERT-BOX WARNING BUTTONS OK.

    /* Change the widget on screen */
    _U._HANDLE:HEIGHT  = min-height * _cur_row_mult.
  
    /* Resize the browser in ALL layouts */          
    browse-recid = RECID(_U).
    FOR EACH _L WHERE _L._u-recid = browse-recid:
      ASSIGN  _L._HEIGHT = min-height.
    END.
  END. /* END if adjusting height */

  IF set-min-width THEN DO:
    MESSAGE _U._NAME "must be at least 3 characters wide." SKIP
            "Resizing..." VIEW-AS ALERT-BOX WARNING BUTTONS OK.

    /* Change the widget on screen */          
    _U._HANDLE:WIDTH  = 3 * txt-wdt * _cur_col_mult.  
  
    /* Change all of the different layout's browsers */
    browse-recid = RECID(_U).
    FOR EACH _L WHERE _L._u-recid = browse-recid:          
      ASSIGN _L._WIDTH = 3 * txt-wdt.
    END.
  END. /* END if adjusting width */

  IF set-integral THEN DO:
    /* CHANGE all of the different layouts */
    browse-recid = RECID(_U).
    FIND FIRST _L WHERE _L._u-recid = browse-recid.
    /* It is necessary to truncate (instead of just converting to
       integer because when rounded up, it might not fit in the
       frame.                                                   */

    ASSIGN _L._WIDTH         = MIN(TRUNCATE(_L._WIDTH,0),TRUNCATE(max-width,0))
           _U._HANDLE:WIDTH  = _L._WIDTH * _cur_col_mult
           _L._HEIGHT        = MIN(TRUNCATE(_L._HEIGHT,0),TRUNCATE(max-height,0))
           _U._HANDLE:HEIGHT = _L._HEIGHT * _cur_row_mult. 
    FOR EACH _L WHERE _L._u-recid = browse-recid:
      ASSIGN _L._WIDTH        = TRUNCATE(_L._WIDTH,0)
             _L._HEIGHT       = TRUNCATE(_L._HEIGHT,0).
    END.
  END. /* END if making integral values */  
END. /* FOR EACH browser */


