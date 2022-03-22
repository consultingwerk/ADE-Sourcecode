/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _rdbrow.p

Description:
    Procedure to read in static browse information.

Note:
    Prior to Version 7.3A (1/6/94), this file was called _rdbrwsr.p.
    
Input Parameters:
   <None>

Output Parameters:
   <None>

Author: D. Ross Hunter

Date Created: 1992

Data Last Modified: 1/31/94 by RPR (New Browser widget support) 
                   11/20/96 by gfs added tooltip from qs
                   02/12/98 by gfs added no-tab-stop and drop-target
                   02/25/98 by gfs added validate,scrollbar-v,expandable
                                   and row-height for browse
                   10/13/98 by gfs added tooltip translation attr
                   06/07/99 by tsm added context-help-id attribute
                   06/16/99 by tsm added no-auto-validate attribute
---------------------------------------------------------------------------- */
{adeuib/uniwidg.i}      /* Universal Widget TEMP-TABLE definition            */
{adeuib/triggers.i}     /* Trigger TEMP-TABLE definition                     */
{adeuib/sharvars.i}     /* Shared variables                                  */
{adeuib/analyze.i &TYPE = "BROWSE"}    /* Analyzer Information               */

DEFINE SHARED STREAM  _P_QS2.
DEFINE SHARED VARIABLE _inp_line   AS  CHAR         EXTENT 100     NO-UNDO.
DEFINE VARIABLE current-file-pos   AS INTEGER                      NO-UNDO.
DEFINE VARIABLE eof_flag           AS LOGICAL       INITIAL FALSE  NO-UNDO.
DEFINE VARIABLE h_self             AS WIDGET-HANDLE                NO-UNDO.
DEFINE VARIABLE n_cells            AS INTEGER                      NO-UNDO.
DEFINE VARIABLE n_down             AS INTEGER                      NO-UNDO.
DEFINE VARIABLE dummy              AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE i                  AS INTEGER                      NO-UNDO.

/* Process the BW data record */
{adeuib/readinit.i &p_type="BROWSE"
                   &p_basetype="BROWSE" }
                   
FIND _P WHERE _P._WINDOW-HANDLE = _h_win.
IF _P._DATA-OBJECT = "<_CONVERTED_>" THEN DO:
  RUN adeuib/_get-sdo.w (INPUT _U._NAME, INPUT 'SmartBrowser':U, OUTPUT _P._DATA-OBJECT).
  /* If it is not a valid SDO, set it back to converted flag for future consideration */
  IF _P._DATA-OBJECT = "" THEN DO:
    _P._DATA-OBJECT = "<_CONVERTED_>".
    DELETE _U.
    DELETE _L.
    DELETE _C.
    DELETE _Q.
    FOR EACH _TT WHERE _TT._p-recid = RECID(_P):
      DELETE _TT.
    END.
    DELETE _P.
    FIND _U WHERE _U._HANDLE = _h_win.
    RUN adeuib/_delet_u.p (RECID(_U), TRUE).
    RETURN "_ABORT":U.
  END.  /* If _get-sdo was canceled */
END.

IF NOT parent_L._WIN-TYPE THEN    /* parent_L is the Master layout of the parent */
  ASSIGN _L._WIN-TYPE = NO.       /* We will create non-master _L's later        */

                 
ASSIGN                   
    n_cells                     = INTEGER({&ABW_num-of-cells})
    n_down                      = INTEGER({&ABW_down})
   _C._DOWN                     = IF n_down = 1 THEN NO ELSE YES
   _L._TITLE-FGCOLOR            = INTEGER({&ABW_title-colr-fg})
   _L._TITLE-BGCOLOR            = INTEGER({&ABW_title-colr-bg})
   _C._MULTIPLE                 = {&ABW_multiple} = "y"
   _L._SEPARATORS               = {&ABW_separators} = "y"
   _C._COLUMN-SCROLLING         = {&ABW_column-scroll} = "y"
   _Q._OpenQury                 = True
   _C._TITLE                    = IF {&ABW_title} = ? THEN false ELSE True
   _L._NO-BOX                   = {&ABW_no-box} = "y"
   _U._SHARED                   = {&ABW_shared} = "y"
   _L._NO-LABELS                = {&ABW_no-labels} = "y"
   _U._WINDOW-HANDLE            = _h_win
   _L._WIN-TYPE                 = _cur_win_type
   _L._ROW-MULT                 = _cur_row_mult
   _L._COL-MULT                 = _cur_col_mult
   _U._LABEL                    = {&ABW_title}
   _U._LABEL-ATTR               = IF {&ABW_title-sa} = ? THEN "" ELSE {&ABW_title-sa}
   _U._TYPE                     = "BROWSE":U
   _C._NO-ASSIGN                = {&ABW_no-assign} = "y"
   _C._NO-AUTO-VALIDATE         = {&ABW_no-auto-validate} = "y"
   _C._NO-ROW-MARKERS           = {&ABW_no-row-markers} = "y"
   _U._TOOLTIP                  = {&ABW_TOOLTIP}
   _U._TOOLTIP-ATTR             = {&ABW_TOOLTIP-ATTR}
   _U._NO-TAB-STOP              = {&ABW_no-tab-stop} = "y"
   _U._DROP-TARGET              = {&ABW_drop-target} = "y"
   _C._VALIDATE                 = {&ABW_validate} = "y"
   _U._SCROLLBAR-V              = {&ABW_scrollbar-v} = "y"
   _C._FIT-LAST-COLUMN          = {&ABW_expandable} = "y"
   _C._NO-EMPTY-SPACE           = {&ABW_no-empty_space} = "y"
   _C._ROW-HEIGHT               = DECIMAL({&ABW_RowHeight-val})
   _U._CONTEXT-HELP-ID          = INTEGER({&ABW_context-help-id})
   _U._WIDGET-ID                = INTEGER({&ABW_widget-id}).


/* Fit last column and no-empty-space are mutually exclusive */
IF _C._FIT-LAST-COLUMN THEN _C._NO-EMPTY-SPACE = NO.

CREATE EDITOR _U._HANDLE
  ASSIGN SCROLLBAR-HORIZONTAL = FALSE
         WORD-WRAP            = FALSE
         READ-ONLY            = TRUE
         FRAME                = _h_frame
         {adeuib/std_attr.i &MODE = "READ"
                            &NO-FRAME = YES
                            &NO-FONT = YES }
      TRIGGERS:
        {adeuib/std_trig.i}
      END TRIGGERS.

/* Size is NOT setable on alternate layouts for browsers. NOTE that the _L record
   for the browser is always "Master Layout" at this point, but the parent will be
   the correct layout when we are pasting. */
IF parent_U._LAYOUT-NAME  NE "Master Layout" THEN _U._HANDLE:RESIZABLE = FALSE.    

/* Assign Handles that we now know */
ASSIGN { adeuib/std_uf.i &SECTION = "HANDLES" } .

IF _U._LAYOUT-UNIT THEN 
  ASSIGN _U._HANDLE:COL       = 1 + (_L._COL - 1) * _cur_col_mult
         _U._HANDLE:ROW       = 1 + (_L._ROW - 1) * _cur_row_mult
         _U._HANDLE:WIDTH     = _L._WIDTH * _cur_col_mult
         _U._HANDLE:HEIGHT    = _L._HEIGHT * _cur_row_mult.
ELSE
  ASSIGN _U._HANDLE:X         = _X
         _U._HANDLE:Y         = _Y
         _U._HANDLE:WIDTH-P   = _WIDTH-P
         _U._HANDLE:HEIGHT-P  = _HEIGHT-P.

/* Create multiple layout records if necessary */
{adeuib/crt_mult.i}
/* Now get the _L for the current layout instead of the master layout */
FIND _L WHERE RECID(_L) = _U._lo-recid.


/* Place object within frame boundary. */
{adeuib/onframe.i
   &_whFrameHandle = "_h_frame"
   &_whObjHandle   = "_U._HANDLE"
   &_lvHidden      = FALSE}

ASSIGN h_self                  = _U._HANDLE
       _C._BACKGROUND          = ?
       _L._COL                 = IF _L._WIN-TYPE THEN 
                                   ((h_self:COL - 1) / _cur_col_mult) + 1
                                 ELSE INTEGER(((h_self:COL - 1) / _cur_col_mult) + 1)
       _L._HEIGHT              = IF _L._WIN-TYPE THEN
                                   h_self:HEIGHT-CHARS / _cur_row_mult
                                 ELSE INTEGER(h_self:HEIGHT-CHARS / _cur_row_mult)
       _U._SELECTEDib          = h_self:SELECTED  /* internal copy selected */
       _U._PARENT              = h_self:PARENT
       _U._PARENT-RECID        = RECID(parent_U)
       _L._ROW                 = IF _L._WIN-TYPE THEN
                                   ((h_self:ROW - 1) / _cur_row_mult) + 1
                                 ELSE INTEGER(((h_self:ROW - 1) / _cur_row_mult) + 1)
       _L._WIDTH               = IF _L._WIN-TYPE THEN
                                   h_self:WIDTH-CHARS / _cur_col_mult
                                 ELSE INTEGER(h_self:WIDTH-CHARS / _cur_col_mult)
       _U._WINDOW-HANDLE       = _h_win
       _h_cur_widg             = h_self.

/*
 message "fg" _L._fgcolor "bg" _L._bgcolor "font" _L._font skip
"title" _C._title "down" _C._down "seps" _L._separators skip
"mult" _C._multiple "title" {&ABW_title} "no-labels" _L._NO-LABELS skip
"shared" _U._shared "no-box" _L._no-box view-as alert-box.
*/


/* Process fill-in fields of this browse  */
DO WHILE i < n_cells:
  i = i + 1.
  IMPORT STREAM _P_QS2 _inp_line. /* skip over cell header */
  IMPORT STREAM _P_QS2 _inp_line.  /* read the cell detail */
END.




