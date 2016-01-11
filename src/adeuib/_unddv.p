/*********************************************************************
* Copyright (C) 2006 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _unddv.p

Description: Undelete a "DataView" widget.

Input Parameters:  uRecId - RecID of object of interest.

Output Parameters: <None>

Author: Marcelo Ferrante
Date Created: 02/2006
----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER uRecId AS RECID NO-UNDO.

{adeuib/uniwidg.i}
{adeuib/custwidg.i}  /* Define Palette-Items (and their images) */

DEFINE VARIABLE ldummy       AS LOGICAL NO-UNDO.
DEFINE VARIABLE h            AS WIDGET  NO-UNDO.
DEFINE VARIABLE hParentFrame AS HANDLE  NO-UNDO.

FIND _U WHERE RECID(_U) EQ uRecId.

CREATE FRAME hParentFrame ASSIGN
          PARENT     = _U._WINDOW-HANDLE
          HEIGHT-P   = {&ImageSize} - 2
          WIDTH-P    = {&ImageSize} - 2
          ROW        = 1
          COLUMN     = 1
          OVERLAY    = YES
          BOX        = NO
          BGCOLOR    = 8
          SCROLLABLE = NO
          HIDDEN     = NO
          SENSITIVE  = FALSE /*SENSITIVE=FALSE so WINDOW triggers will apply*/
      .

CREATE IMAGE h ASSIGN
      FRAME             = hParentFrame
      X                 = 0
      Y                 = 0
      HEIGHT-P          = {&ImageSize} - 2 
      WIDTH-P           = {&ImageSize} - 2
      CONVERT-3D-COLORS = TRUE
      HIDDEN            = FALSE      VISIBLE           = TRUE
      SELECTABLE        = FALSE 
      SENSITIVE         = FALSE.
      
/* The image name is stored in _palette_item for many known types.
   Otherwise, just use a default icon */
FIND _palette_item WHERE _palette_item._name eq "DataView":U NO-ERROR.
IF AVAILABLE _palette_item
THEN ldummy = h:LOAD-IMAGE (_palette_item._icon_up,
                            _palette_item._icon_up_x + 1,
                            _palette_item._icon_up_y + 1,
                            {&ImageSize} - 2,
                            {&ImageSize} - 2).
ELSE ldummy = h:LOAD-IMAGE ("adeicon/smartobj", 1, 1,
                            {&ImageSize} - 2, {&ImageSize} - 2).

RETURN.
