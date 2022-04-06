/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* std_ul.i :  standard settings for _U and _L records.  These apply to     */
/*             all field-level widgets and SmartObjects                     */
/* Inputs   : SECTION - define which section to use.  The valid sections    */
/*                      are:                                                */
/*                      DRAW-SETUP - use to setup a new _U/_F in _drwXXXX.p */
/*                      These sections are used in the _undXXXX.p           */
/*                      HANDLES    - sets the _U.handle variables and also  */
/*                                   sets _h_cur_widg                       */
/*                      GEOMETRY   - get the geometry from the _U._HANDLE   */
    &IF "{&SECTION}" = "DRAW-SETUP" &THEN 
       _L._WIN-TYPE          = parent_L._WIN-TYPE
       _U._parent-recid      = RECID(parent_U)           
       _U._ALIGN             = IF CAN-DO("FILL-IN,COMBO-BOX",_U._TYPE)
                                THEN "C" /* Colon-Align */  ELSE "L"   /* LEFT-ALIGN */
       _L._COL               = 1.0 + (_frmx / SESSION:PIXELS-PER-COL / _cur_col_mult)
       _L._ROW               = 1.0 + (_frmy / SESSION:PIXELS-PER-ROW / _cur_row_mult)              
       _U._MANUAL-HIGHLIGHT  = FALSE
       _U._MOVABLE           = FALSE
       _U._RESIZABLE         = FALSE
       _U._SELECTABLE        = FALSE 
       _U._SELECTED          = FALSE
       _U._SENSITIVE         = TRUE
       _U._lo-recid          = RECID(_L)
       _L._u-recid           = RECID(_U)
       _L._LO-NAME           = cur-lo
       _L._COL-MULT          = parent_L._COL-MULT
       _L._ROW-MULT          = parent_L._ROW-MULT
    &ELSEIF "{&SECTION}" = "HANDLES" &THEN 
       _h_cur_widg           = _U._HANDLE
       _U._PARENT            = _U._HANDLE:PARENT
       _U._WINDOW-HANDLE     = parent_U._WINDOW-HANDLE
    &ELSEIF "{&SECTION}" = "GEOMETRY" &THEN
       _L._COL               = IF _L._WIN-TYPE THEN
                                  ((_U._HANDLE:COLUMN - 1) / _cur_col_mult) + 1.0 ELSE
                               INTEGER(((_U._HANDLE:COLUMN - 1) / _cur_col_mult) + 1.0)
       _L._HEIGHT            = IF _L._WIN-TYPE THEN
                                  _U._HANDLE:HEIGHT-CHARS / _cur_row_mult ELSE
                                INTEGER(_U._HANDLE:HEIGHT-CHARS / _cur_row_mult)
       _L._ROW               = IF _L._WIN-TYPE THEN
                                  ((_U._HANDLE:ROW - 1) / _cur_row_mult) + 1.0 ELSE
                                INTEGER(((_U._HANDLE:ROW - 1) / _cur_row_mult) + 1.0)
       _L._WIDTH             = IF _L._WIN-TYPE THEN
                                  _U._HANDLE:WIDTH-CHARS / _cur_col_mult ELSE
                               INTEGER(_U._HANDLE:WIDTH-CHARS / _cur_col_mult)
    &ENDIF 
       
