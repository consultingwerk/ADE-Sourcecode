/*********************************************************************
* Copyright (C) 2000-2001 by Progress Software Corporation ("PSC"),  *
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

File: _cr_pal.p

Description:
  Create object palette items from the _palette_item temp-table.
   
Input Parameters:
  reinit       : re-initializing palette y/n
  
Output Parameters:
  <none>

Return-Value:
   
Author: Gerry Seidl

Date Created: 2/10/95

Modified:
  08/01/95 - remove widget-pool "_pal"
  10/18/96 - remove labels, will implement tooltips
  09/28/01 - IZ 2008 Tooltips now use Label from .cst file (if defined)
             instead of Name. Its more descriptive. (jep-icf)
---------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER reinit       AS LOGICAL NO-UNDO. 

{adecomm/adefext.i}    /* ADE Preprocessor - defines UIB_NAME */
{adeuib/uniwidg.i}     /* universal widgets                   */
{adeuib/sharvars.i}    /* Most common shared variables        */
{adeuib/windvars.i}    /* Window Creation Variables           */
{adeuib/custwidg.i}    /* Custom Widget Definitions           */
{adecomm/adestds.i}    /* ADE standards - defines adeicon/    */

DEFINE VARIABLE ldummy  AS LOGICAL NO-UNDO.

&IF DEFINED(ADEICONDIR) = 0 &THEN
 {adecomm/icondir.i}
&ENDIF

ASSIGN _h_object_win:HIDDEN = yes.
IF reinit THEN 
  RUN ReInitialize_Palette. /* delete previously created dynamic widgets */

RUN create_palette.

RETURN.

/* ReInitialize_Palette
 *   Deletes previously created dynamic objects so they can be 
 *   recreated. Dynamically created widgets on the palette's
 *   menu is deleted by adeuib/_cr_cmnu.p
 */
PROCEDURE ReInitialize_Palette:
  DEFINE VARIABLE h  AS HANDLE.
  DEFINE VARIABLE hp AS HANDLE.
  
  ASSIGN h = _h_object_win:FIRST-CHILD.
  DO WHILE VALID-HANDLE(h):
    ASSIGN hp = h:POPUP-MENU.
    IF VALID-HANDLE (hp) THEN DELETE WIDGET hp.
    DELETE WIDGET h.
    ASSIGN h = _h_object_win:FIRST-CHILD.
  END.
END PROCEDURE.

/* -------------------------------------------------------------
   create_palette
      Dynamically create a down image and an up-image for each of
      the widgets that we might draw.
      Triggers are added to these images.
   -------------------------------------------------------------  */ 
PROCEDURE create_palette:
  DEFINE VAR border-pixels   AS INTEGER NO-UNDO.
  DEFINE VAR h_wp_up         AS WIDGET  NO-UNDO.
  DEFINE VAR h_wp_text       AS WIDGET  NO-UNDO.
  DEFINE VAR h_lock          AS WIDGET  NO-UNDO.
  DEFINE VAR h_wp_down       AS WIDGET  NO-UNDO.
  DEFINE VAR h_widget_frame  AS WIDGET  NO-UNDO.
  DEFINE VAR nextX           AS INTEGER NO-UNDO INIT 0.
  DEFINE VAR nextY           AS INTEGER NO-UNDO INIT 0.
  DEFINE VAR image_file_lock AS CHAR    NO-UNDO.
  DEFINE VAR tool_tip        AS CHAR    NO-UNDO.

  &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN 
    ASSIGN image_file_lock =  {&ADEICON-DIR} + "lock.ico".
  &ELSE /* Not MSW */
    ASSIGN image_file_lock =  {&ADEICON-DIR} + "lock.xbm".
  &ENDIF

  &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
  /* WTW 7.1C Limitation: all MS Windows have a minimum width (because we
     cannot get rid of the icons on the title-bar). This deals with this.
     NOTE that the multiplier "9" is a guesstimate - not a known constant. */
    IF 2 * {&ImageSize} < ( 3 * (SESSION:PIXELS-PER-ROW - 4)) THEN 
     ASSIGN 
      /* Widen the window to avoid unmanaged holes and center the palette */
      /* and don't allow resizing to be smaller than this. */
      _h_object_win:WIDTH-PIXELS = ( 3 * (SESSION:PIXELS-PER-ROW - 4))
      border-pixels = (_h_object_win:WIDTH-PIXELS - 56) / 2
      _h_object_win:HEIGHT-P = _h_object_win:HEIGHT-P + (2 * border-pixels)
      _h_object_win:MIN-WIDTH-P  = _h_object_win:WIDTH-PIXELS
      _h_object_win:MAX-HEIGHT-P = _h_object_win:MAX-HEIGHT-P + 
                                    (2 * border-pixels)
      _h_object_win:VIRTUAL-HEIGHT-P = _h_object_win:MAX-HEIGHT-P + 
                                    (2 * border-pixels)
      .
  &ENDIF
  
  /* Layout all the widgets in the palette in 1 column */
  FOR EACH _palette_item USE-INDEX _order:
    /* jep-icf: Figure out what to use for tool tip. Label from the .cst file is preferable
       to just the name - its more descriptive. */
    ASSIGN tool_tip = _palette_item._NAME
           tool_tip = _palette_item._LABEL2 WHEN (_palette_item._LABEL2 <> "").
           
    /* Create a frame for each widget.  We need a seperate frame because
       we are going to attach a popup menu to each item, and we cannot
       attach popup-menus to images.  */
    CREATE FRAME h_widget_frame  
    ASSIGN
      PARENT       = _h_object_win
      THREE-D      = yes
      X            = border-pixels
      Y            = border-pixels
      WIDTH-P      = {&ImageSize}
      HEIGHT-P     = {&ImageSize}
      BOX          = NO
      SCROLLABLE   = NO
      HIDDEN       = NO
      VISIBLE      = YES   
      OVERLAY      = YES
      /* PRIVATE-DATA is used to set palette order when palette is resized */
      PRIVATE-DATA = STRING(_palette_item._order,">>9":U)  
      TRIGGERS:
        ON MOUSE-SELECT-DOWN PERSISTENT RUN tool_choose IN _h_uib (0, _palette_item._NAME, ?).
        ON MOUSE-EXTEND-DOWN PERSISTENT RUN tool_choose IN _h_uib (0, _palette_item._NAME, ?).
      END TRIGGERS.
    
    /* Down image */
    CREATE IMAGE h_wp_down  
    ASSIGN
      FRAME             = h_widget_frame
      WIDTH-P           = {&ImageSize}
      HEIGHT-P          = {&ImageSize}
      HIDDEN            = NO
      SENSITIVE         = YES
      TOOLTIP           = tool_tip
      CONVERT-3D-COLORS = YES
      TRIGGERS:
        /* Toggle the lock on the current selection, whatever that is. */
        ON MOUSE-SELECT-DOWN,
           MOUSE-EXTEND-DOWN PERSISTENT RUN tool_choose IN _h_uib (3, ?, ?).
      END TRIGGERS.
    
    /* Add the "lock" icon to the frame */
    CREATE IMAGE h_lock  
    ASSIGN
      FRAME             = h_widget_frame
      X                 = 3  /* Offset the lock, a little bit */
      Y                 = 3
      WIDTH-P           = 16
      HEIGHT-P          = 16
      HIDDEN            = YES    /* Don't show it until we enter Lock State */
      SENSITIVE         = YES 
      TOOLTIP           = tool_tip
      CONVERT-3D-COLORS = YES
      TRIGGERS:
        /* Toggle the lock state on the current selection */
        ON MOUSE-SELECT-DOWN, 
           MOUSE-EXTEND-DOWN PERSISTENT RUN tool_choose IN _h_uib (3, ?, ?).
      END TRIGGERS.
    ldummy = h_lock:LOAD-IMAGE (image_file_lock, 0, 0, 16, 16) NO-ERROR.
      
    /* Up image */
    CREATE BUTTON h_wp_up 
    ASSIGN
      NO-FOCUS          = YES
      FLAT-BUTTON       = YES
      FRAME             = h_widget_frame
      WIDTH-P           = {&ImageSize}
      HEIGHT-P          = {&ImageSize}
      HIDDEN            = NO
      SENSITIVE         = YES
      PRIVATE-DATA      = _palette_item._NAME + "," + STRING(h_lock:HANDLE)
      HELP              = _palette_item._NAME
      TOOLTIP           = tool_tip
      TRIGGERS:
        ON MOUSE-SELECT-DOWN PERSISTENT RUN tool_choose IN _h_uib (0, _palette_item._NAME, ?).
        ON MOUSE-EXTEND-DOWN PERSISTENT RUN tool_choose IN _h_uib (0, _palette_item._NAME, ?).
      END TRIGGERS.
    ASSIGN _palette_item._h_up_image = h_wp_up:HANDLE.
    
    /* Now load the images */
    ASSIGN ldummy = h_wp_down:LOAD-IMAGE (_palette_item._icon_down, 
                                          _palette_item._icon_down_x, 
                                          _palette_item._icon_down_y,
                                          {&ImageSize},
                                          {&ImageSize})
           ldummy = h_wp_up:LOAD-IMAGE  (_palette_item._icon_up,   
                                          _palette_item._icon_up_x, 
                                          _palette_item._icon_up_y, 
                                          {&ImageSize}, 
                                          {&ImageSize})
           NO-ERROR. /* Don't stop the UIB just because images couldn't load */
            
    /* Compute the position of the next palette item. */ 
    nextY = nextY + {&ImageSize}.
  END.
  RUN adeuib/_rsz_wp.p (INPUT yes).
END PROCEDURE.

