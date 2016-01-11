/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*-----------------------------------------------------------------------------

  File: _uib_crt.p

  Description:
     Code to allow developers to create objects in the UIB.  Basically, this
     allows a developer to programatically create objects found in the Custom 
     Object files.
     The TYPES, ARGUEMENTS, CUSTOM TYPES etc are the same as those defined
     in the Custom Object files.
     
  Input Parameters:
     pi_parent  - The integer context (from _uibinfo.p) of the parent of the 
                  object to create.  If this is ? then the parent is assumed
                  to be the current frame [If their is no current frame, then
                  the current window is assumed.]
     pc_type    - The type of object to create (eg. "BUTTON")
     pc_custom  - The name of the custom object type (eg. "OK Button").
                  If this is ? then the "&Default" object is created
                  This is of the form:
                       "case:value"
                  Three special cases are considered:
                     "CUSTOM:Name "
                         -- the name of the custom object defined in Custom files
                         -- e.g. Custom: &Default
                     "SmartObject:object-file" 
                         -- the name of a SmartObject to load
                         -- e.g.  SmartObject: C:\DLC\gui\objects\p-nav.w
                     "SPECIAL: Attributes Values"
                         -- this is like temporarily creating a new Custom file
                         -- entry.  The attribute/Values are parses the same
                         -- way entries are made in the Custom file
                         -- NOTE that blank lines are ignored (so a CR can be
                         -- added after SPECIAL:
                         -- e.g.  SPECIAL:
                         --         BGCOLOR  7
                         --         FONT     2
                         --         NAME     test
     pd_ROW     - The ROW to create the object
     pd_COLUMN  - The COLUMN to create the object
     pd_HEIGHT  - The HEIGHT (if ?, then the default height will be used)
     pd_WIDTH   - The WIDTH (if ?, then the default width will be used)
                         
                 
  Output Parameters:
     pi_context - The integer context (i.e. recid) of the object created.
                  If the creation fails, then this will be ?.
                  
                  This value can be used as the object context for the
                  companion programs: 
                     adeuib/_accsect.p - create/modify/delete Code Sections
                     adeuib/_uibinfo.p - get information on an object
                     adeuib/_uib_del.p - delete the object
                 
    
  Return Values:
     This procedure RETURNS:
       "Error" if pi_context does not point to a valid object
       "Fail"  if the object was not created (and no "Error" condition was
               detected -- for example, you tried to create a BUTTON on a
               WINDOW.)
                     
  Author: Gerry Seidl
  
  Created: February 1995 
  
  Modified:
    11/20/95 wood - Return "Fail" if no object created.
  
-----------------------------------------------------------------------------*/
/* Define Parameters. */
DEFINE INPUT  PARAMETER  pi_parent    AS INTEGER NO-UNDO.
DEFINE INPUT  PARAMETER  pc_type      AS CHAR    NO-UNDO.
DEFINE INPUT  PARAMETER  pc_custom    AS CHAR    NO-UNDO.
DEFINE INPUT  PARAMETER  pd_ROW       AS DECIMAL NO-UNDO.
DEFINE INPUT  PARAMETER  pd_COLUMN    AS DECIMAL NO-UNDO.
DEFINE INPUT  PARAMETER  pd_HEIGHT    AS DECIMAL NO-UNDO.
DEFINE INPUT  PARAMETER  pd_WIDTH     AS DECIMAL NO-UNDO.
DEFINE OUTPUT PARAMETER  pi_context   AS INTEGER INITIAL ? NO-UNDO.

/* Include Files */
{adeuib/uniwidg.i}           /* Universal Widget TEMP-TABLE definition   */
{adeuib/sharvars.i}          /* Define _h_win, _frmx, _next_draw etc.    */
{adeuib/layout.i}            /* Layout temp-table definitions            */
{adeuib/custwidg.i}          /* Custom Object and Palette definitions    */

/* Local Variables */
DEFINE VARIABLE cust-recid        AS RECID INITIAL ? NO-UNDO.

DEFINE VARIABLE c_val             AS CHARACTER       NO-UNDO.
DEFINE VARIABLE o_cur_win_type    AS LOGICAL         NO-UNDO.
DEFINE VARIABLE o_h_win           AS WIDGET-HANDLE   NO-UNDO.
DEFINE VARIABLE o_h_frame         AS WIDGET-HANDLE   NO-UNDO.
DEFINE VARIABLE o_h_cur_widg      AS WIDGET-HANDLE   NO-UNDO.
DEFINE VARIABLE o_frmx            AS INTEGER         NO-UNDO.
DEFINE VARIABLE o_frmy            AS INTEGER         NO-UNDO.
DEFINE VARIABLE o_second_corner_x AS INTEGER         NO-UNDO.
DEFINE VARIABLE o_second_corner_y AS INTEGER         NO-UNDO.

/* Check the worst case that nothing was specified. */
IF pi_parent eq ? AND NOT VALID-HANDLE(_h_win)
THEN DO:
  RUN error-msg ( "No window is currently selected." ).
  RETURN "Error".
END.

/* Store off current values */
ASSIGN
  o_h_win      = _h_win
  o_h_frame    = _h_frame
  o_h_cur_widg = _h_cur_widg
  o_frmx       = _frmx
  o_frmy       = _frmy
  o_cur_win_type    = _cur_win_type
  o_second_corner_x = _second_corner_x
  o_second_corner_y = _second_corner_y.
  
/* Find _L for row/col mults */
IF pi_parent = ? THEN DO:
  IF VALID-HANDLE(_h_frame) THEN /* use current frame */
    FIND _U WHERE _U._HANDLE = _h_frame.
  ELSE  /* Use current window */
    FIND _U WHERE _U._HANDLE = _h_win. 
  FIND _L WHERE RECID(_L) = _U._lo-recid.
END.
ELSE DO:
  FIND _U WHERE RECID(_U) = pi_parent NO-ERROR.
  IF AVAILABLE (_U) THEN DO:
    FIND _L WHERE INT(_u-recid) = pi_parent.
    /* Set the "global" variables based on the parent. */
    ASSIGN _h_win        = _U._WINDOW-HANDLE
           _h_frame      = IF CAN-DO ("DIALOG-BOX,FRAME", _U._TYPE) 
                           THEN _U._HANDLE ELSE ?
           _cur_win_type = _L._WIN-TYPE
           .
  END.
  ELSE DO:
    RUN error-msg ( "Invalid parent specified." ).
    RETURN "Error".
  END.
END.
  
/* Assign object to draw */
FIND _palette_item WHERE _palette_item._name = pc_type NO-ERROR.
IF AVAILABLE (_palette_item) THEN ASSIGN _next_draw = pc_type.
ELSE 
FIND_SO:
DO:
  IF pc_custom BEGINS "SmartObject" THEN DO:
    FIND LAST _palette_item WHERE _palette_item._type = 3 NO-ERROR.
    IF AVAILABLE _palette_item THEN DO:
      ASSIGN _next_draw = _palette_item._name. /* Ok, if a SmartObject */
      LEAVE FIND_SO. /* no error */
    END.
  END.
  RUN error-msg ( "Object type not found." ).
  RETURN "Error".
END.

/* Setup drawing location and width/height */
IF pd_ROW > 0 THEN
  ASSIGN _frmy = (pd_ROW - 1) * SESSION:PIXELS-PER-ROW * _L._row-mult.
ELSE ASSIGN _frmy = 0.

IF pd_COLUMN > 0 THEN
  ASSIGN _frmx = (pd_COLUMN - 1) * SESSION:PIXELS-PER-COL * _L._col-mult.
ELSE ASSIGN _frmx = 0.
  
IF pd_HEIGHT > 0 THEN
  ASSIGN _second_corner_y = (((IF pd_ROW > 0 THEN pd_ROW ELSE 0) + pd_HEIGHT) - 1) *
    SESSION:PIXELS-PER-ROW * _L._row-mult.
ELSE ASSIGN _second_corner_y = ?.

IF pd_WIDTH > 0 THEN
  ASSIGN _second_corner_x = (((IF pd_COLUMN > 0 THEN pd_COLUMN ELSE 0) + pd_WIDTH) - 1) *
    SESSION:PIXELS-PER-COL * _L._col-mult.
ELSE ASSIGN _second_corner_x = ?.

/* See if there are custom attrs to process */
IF pc_custom NE ?                 AND
   INDEX(pc_custom, ":") > 0      AND 
   NUM-ENTRIES(pc_custom,":") > 1 THEN 
DO:
  c_val = TRIM(SUBSTRING(pc_custom,INDEX(pc_custom, ":":U) + 1,-1,"CHARACTER":U)).
  CASE TRIM(ENTRY(1,pc_custom,":")):
    WHEN "Custom":U THEN /* (e.g. "CUSTOM: &OK" ) */
      ASSIGN _custom_draw = c_val.
    WHEN "SmartObject":U THEN /* (e.g. "SMARTOBJECT: /usr/dlc/gui/objects/p-nav.r") */
      ASSIGN _object_draw = c_val.
    WHEN "Special":U THEN DO:
      CREATE _custom.
      ASSIGN _custom._type  = _next_draw
             _custom._name  = "uib_crt":U
             _custom._attr  = c_val
             _custom._order = 9999.
      ASSIGN cust-recid     = RECID(_custom)
             _custom_draw   = "uib_crt".
    END.  
    OTHERWISE 
      ASSIGN _custom_draw = ?
             _object_draw = ?. 
  END CASE.
END.
ELSE
  ASSIGN _custom_draw = ?
         _object_draw = ?. 
            
RUN DrawObj IN _h_uib. /* Run IP to draw object in the UIB */

/* Was there a failure creating a new current object. This will occur
   if _h_cur_widg is UNKNOWN, or has not changed from its previous value. */
IF NOT VALID-HANDLE(_h_cur_widg) OR _h_cur_widg eq o_h_cur_widg THEN DO:
  pi_context = ?.
  RETURN "Fail":U.
END.
  
/* Pass back the context of the created object */
FIND _U WHERE _U._HANDLE = _h_cur_widg.
ASSIGN pi_context = INT(RECID(_U)).

RUN Reload-Env. /* reset variables */

/* If we created a 'temporary' _custom record, delete it */
IF cust-recid NE ? THEN DO:
  FIND _custom WHERE RECID(_custom) = cust-recid.
  DELETE _custom.
END.

RETURN "".

/* error-msg -- standared error message. */
PROCEDURE error-msg :
  DEFINE INPUT PARAMETER msg AS CHAR NO-UNDO.
  MESSAGE "[{&FILE-NAME}]" SKIP msg VIEW-AS ALERT-BOX ERROR.
  RUN Reload-Env.
END PROCEDURE.

/* Set variables back to their original values */
PROCEDURE Reload-Env:
  ASSIGN
    _h_win   = o_h_win
    _h_frame = o_h_frame 
    _frmx    = o_frmx   
    _frmy    = o_frmy
    _cur_win_type    = o_cur_win_type
    _second_corner_x = o_second_corner_x
    _second_corner_y = o_second_corner_y.
END PROCEDURE.

