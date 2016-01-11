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
/* -------------------------------------------------------------------

FILE: tog-disp.i

Description:
      Toggle initialization code to be included in _prpobj.p.

Author: D. Ross Hunter 

Date Generated: 04/07/04

Note: This procedure is generated via the Property Sheet Generator and 
      the abAttribute table of the ab database. 
      DO NOT CHANGE THIS FILE WITHOUT UPDATING THE AB DATABASE AND 
      USING THE PROPERTY SHEET GENERATOR TO GENERATE THIS CODE 

------------------------------------------------------------------- */

  WHEN "3-D" THEN DO:
    CREATE TOGGLE-BOX h_3-D
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "3-D"
               CHECKED       = _L._3-D
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN 3-D_proc.
        END TRIGGERS.
  END.

  WHEN "AUTO-COMPLETION" THEN DO:
    CREATE TOGGLE-BOX h_AUTO-COMPLETION
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Auto-Completion"
               CHECKED       = _F._AUTO-COMPLETION
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN AUTO-COMPLETION_proc.
        END TRIGGERS.
  END.

  WHEN "AUTO-END-KEY" THEN DO:
    CREATE TOGGLE-BOX h_AUTO-END-KEY
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Auto-End-Key"
               CHECKED       = _F._AUTO-ENDKEY
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN AUTO-END-KEY_proc.
        END TRIGGERS.
  END.

  WHEN "AUTO-GO" THEN DO:
    CREATE TOGGLE-BOX h_AUTO-GO
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Auto-Go"
               CHECKED       = _F._AUTO-GO
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN AUTO-GO_proc.
        END TRIGGERS.
  END.

  WHEN "AUTO-INDENT" THEN DO:
    CREATE TOGGLE-BOX h_AUTO-INDENT
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Auto-Indent"
               CHECKED       = _F._AUTO-INDENT
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN AUTO-INDENT_proc.
        END TRIGGERS.
  END.

  WHEN "AUTO-RESIZE" THEN DO:
    CREATE TOGGLE-BOX h_AUTO-RESIZE
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Auto-Resize"
               CHECKED       = _F._AUTO-RESIZE
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN AUTO-RESIZE_proc.
        END TRIGGERS.
  END.

  WHEN "AUTO-RETURN" THEN DO:
    CREATE TOGGLE-BOX h_AUTO-RETURN
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Auto-Return"
               CHECKED       = _F._AUTO-RETURN
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN AUTO-RETURN_proc.
        END TRIGGERS.
  END.

  WHEN "BLANK" THEN DO:
    CREATE TOGGLE-BOX h_BLANK
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Blank"
               CHECKED       = _F._BLANK
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN BLANK_proc.
        END TRIGGERS.
  END.

  WHEN "CANCEL-BTN" THEN DO:
    FIND x_U WHERE RECID(x_U) = _U._PARENT-RECID.
    FIND _C  WHERE RECID(_C)  = x_U._x-recid.

    CREATE TOGGLE-BOX h_CANCEL-BTN
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Cancel Button"
               CHECKED       = (_C._cancel-btn-recid = RECID(_U))
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN CANCEL-BTN_proc.
        END TRIGGERS.
  END.

  WHEN "COLUMN-SCROLLING" THEN DO:
    CREATE TOGGLE-BOX h_COLUMN-SCROLLING
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Column-Scrolling"
               CHECKED       = _C._COLUMN-SCROLLING
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN COLUMN-SCROLLING_proc.
        END TRIGGERS.
  END.

  WHEN "Control-Box" THEN DO:
    CREATE TOGGLE-BOX h_Control-Box
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Control-Box"
               CHECKED       = _C._CONTROL-BOX
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN Control-Box_proc.
        END TRIGGERS.
  END.

  WHEN "CONVERT-3D-COLORS" THEN DO:
    CREATE TOGGLE-BOX h_CONVERT-3D-COLORS
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Convert-3D-Colors"
               CHECKED       = _L._CONVERT-3D-COLORS
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN CONVERT-3D-COLORS_proc.
        END TRIGGERS.
  END.

  WHEN "DEBLANK" THEN DO:
    CREATE TOGGLE-BOX h_DEBLANK
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Deblank"
               CHECKED       = _F._DEBLANK
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN DEBLANK_proc.
        END TRIGGERS.
  END.

  WHEN "DEFAULT-BTN" THEN DO:
    FIND x_U WHERE RECID(x_U) = _U._PARENT-RECID.
    FIND _C  WHERE RECID(_C)  = x_U._x-recid.

    CREATE TOGGLE-BOX h_DEFAULT-BTN
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Default Button"
               CHECKED       = (_C._default-btn-recid = RECID(_U))
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN DEFAULT-BTN_proc.
        END TRIGGERS.
  END.

  WHEN "DEFAULT-STYLE" THEN DO:
    CREATE TOGGLE-BOX h_DEFAULT-STYLE
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Default Style"
               CHECKED       = _F._DEFAULT
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN DEFAULT-STYLE_proc.
        END TRIGGERS.
  END.

  WHEN "DISABLE-AUTO-ZAP" THEN DO:
    CREATE TOGGLE-BOX h_DISABLE-AUTO-ZAP
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Disable-Auto-Zap"
               CHECKED       = _F._DISABLE-AUTO-ZAP
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN DISABLE-AUTO-ZAP_proc.
        END TRIGGERS.
  END.

  WHEN "DISPLAY" THEN DO:
    CREATE TOGGLE-BOX h_DISPLAY
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Display"
               CHECKED       = _U._DISPLAY
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN DISPLAY_proc.
        END TRIGGERS.
  END.

  WHEN "DOWN" THEN DO:
    CREATE TOGGLE-BOX h_DOWN
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Down"
               CHECKED       = _C._DOWN
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN DOWN_proc.
        END TRIGGERS.
  END.

  WHEN "DRAG-ENABLED" THEN DO:
    CREATE TOGGLE-BOX h_DRAG-ENABLED
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Drag-Enabled"
               CHECKED       = _F._DRAG-ENABLED
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN DRAG-ENABLED_proc.
        END TRIGGERS.
  END.

  WHEN "Drop-Target" THEN DO:
    CREATE TOGGLE-BOX h_Drop-Target
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Drop-Target"
               CHECKED       = _U._DROP-TARGET
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN Drop-Target_proc.
        END TRIGGERS.
  END.

  WHEN "ENABLE" THEN DO:
    CREATE TOGGLE-BOX h_ENABLE
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Enable"
               CHECKED       = _U._ENABLE
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN ENABLE_proc.
        END TRIGGERS.
  END.

  WHEN "EXPAND" THEN DO:
    CREATE TOGGLE-BOX h_EXPAND
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Expand"
               CHECKED       = _F._EXPAND
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN EXPAND_proc.
        END TRIGGERS.
  END.

  WHEN "EXPLICIT-POSITION" THEN DO:
    CREATE TOGGLE-BOX h_EXPLICIT-POSITION
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Explicit Position"
               CHECKED       = _C._EXPLICIT_POSITION
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN EXPLICIT-POSITION_proc.
        END TRIGGERS.
  END.

  WHEN "FILLED" THEN DO:
    CREATE TOGGLE-BOX h_FILLED
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Filled"
               CHECKED       = _L._FILLED
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN FILLED_proc.
        END TRIGGERS.
  END.

  WHEN "FIT-LAST-COLUMN" THEN DO:
    CREATE TOGGLE-BOX h_FIT-LAST-COLUMN
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Fit-Last-Column"
               CHECKED       = _C._FIT-LAST-COLUMN
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN FIT-LAST-COLUMN_proc.
        END TRIGGERS.
  END.

  WHEN "FLAT" THEN DO:
    CREATE TOGGLE-BOX h_FLAT
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Flat"
               CHECKED       = _F._FLAT
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN FLAT_proc.
        END TRIGGERS.
  END.

  WHEN "GRAPHIC-EDGE" THEN DO:
    CREATE TOGGLE-BOX h_GRAPHIC-EDGE
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Graphic-Edge"
               CHECKED       = _L._GRAPHIC-EDGE
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN GRAPHIC-EDGE_proc.
        END TRIGGERS.
  END.

  WHEN "HIDDEN" THEN DO:
    CREATE TOGGLE-BOX h_HIDDEN
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Hidden"
               CHECKED       = _U._HIDDEN
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN HIDDEN_proc.
        END TRIGGERS.
  END.

  WHEN "HORIZONTAL" THEN DO:
    CREATE TOGGLE-BOX h_HORIZONTAL
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Horizontal"
               CHECKED       = _F._HORIZONTAL
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN HORIZONTAL_proc.
        END TRIGGERS.
  END.

  WHEN "KEEP-FRAME-Z-ORDER" THEN DO:
    CREATE TOGGLE-BOX h_KEEP-FRAME-Z-ORDER
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Keep-Frame-Z-Order"
               CHECKED       = _C._KEEP-FRAME-Z-ORDER
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN KEEP-FRAME-Z-ORDER_proc.
        END TRIGGERS.
  END.

  WHEN "KEEP-TAB-ORDER" THEN DO:
    CREATE TOGGLE-BOX h_KEEP-TAB-ORDER
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Keep-Tab-Order"
               CHECKED       = _C._KEEP-TAB-ORDER
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN KEEP-TAB-ORDER_proc.
        END TRIGGERS.
  END.

  WHEN "LARGE" THEN DO:
    CREATE TOGGLE-BOX h_LARGE
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Large"
               CHECKED       = _F._LARGE
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN LARGE_proc.
        END TRIGGERS.
  END.

  WHEN "LARGE-TO-SMALL" THEN DO:
    CREATE TOGGLE-BOX h_LARGE-TO-SMALL
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Large-To-Small"
               CHECKED       = _F._LARGE-TO-SMALL
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN LARGE-TO-SMALL_proc.
        END TRIGGERS.
  END.

  WHEN "MAX-BUTTON" THEN DO:
    CREATE TOGGLE-BOX h_MAX-BUTTON
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Max-Button"
               CHECKED       = _C._MAX-BUTTON
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN MAX-BUTTON_proc.
        END TRIGGERS.
  END.

  WHEN "MESSAGE-AREA" THEN DO:
    CREATE TOGGLE-BOX h_MESSAGE-AREA
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Message-Area"
               CHECKED       = _C._MESSAGE-AREA
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN MESSAGE-AREA_proc.
        END TRIGGERS.
  END.

  WHEN "MIN-BUTTON" THEN DO:
    CREATE TOGGLE-BOX h_MIN-BUTTON
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Min-Button"
               CHECKED       = _C._MIN-BUTTON
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN MIN-BUTTON_proc.
        END TRIGGERS.
  END.

  WHEN "MULTIPLE" THEN DO:
    CREATE TOGGLE-BOX h_MULTIPLE
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Multiple-Selection"
               CHECKED       = IF AVAILABLE _F THEN _F._MULTIPLE ELSE _C._MULTIPLE
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN MULTIPLE_proc.
        END TRIGGERS.
  END.

  WHEN "NATIVE" THEN DO:
    CREATE TOGGLE-BOX h_NATIVE
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Native"
               CHECKED       = _F._NATIVE
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN NATIVE_proc.
        END TRIGGERS.
  END.

  WHEN "NO-ASSIGN" THEN DO:
    CREATE TOGGLE-BOX h_NO-ASSIGN
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "No-Assign"
               CHECKED       = _C._NO-ASSIGN
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN NO-ASSIGN_proc.
        END TRIGGERS.
  END.

  WHEN "NO-AUTO-VALIDATE" THEN DO:
    CREATE TOGGLE-BOX h_NO-AUTO-VALIDATE
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "No-Auto-Validate"
               CHECKED       = _C._NO-AUTO-VALIDATE
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN NO-AUTO-VALIDATE_proc.
        END TRIGGERS.
  END.

  WHEN "NO-BOX" THEN DO:
    CREATE TOGGLE-BOX h_NO-BOX
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "No-Box"
               CHECKED       = _L._NO-BOX
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN NO-BOX_proc.
        END TRIGGERS.
  END.

  WHEN "NO-CURRENT-VALUE" THEN DO:
    CREATE TOGGLE-BOX h_NO-CURRENT-VALUE
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "No-Current-Value"
               CHECKED       = _F._NO-CURRENT-VALUE
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN NO-CURRENT-VALUE_proc.
        END TRIGGERS.
  END.

  WHEN "NO-EMPTY-SPACE" THEN DO:
    CREATE TOGGLE-BOX h_NO-EMPTY-SPACE
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "No-Empty-Space"
               CHECKED       = _C._NO-EMPTY-SPACE
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN NO-EMPTY-SPACE_proc.
        END TRIGGERS.
  END.

  WHEN "NO-FOCUS" THEN DO:
    CREATE TOGGLE-BOX h_NO-FOCUS
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "No-Focus"
               CHECKED       = _L._NO-FOCUS
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN NO-FOCUS_proc.
        END TRIGGERS.
  END.

  WHEN "NO-HELP" THEN DO:
    CREATE TOGGLE-BOX h_NO-HELP
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "No-Help"
               CHECKED       = _C._NO-HELP
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN NO-HELP_proc.
        END TRIGGERS.
  END.

  WHEN "NO-HIDE" THEN DO:
    CREATE TOGGLE-BOX h_NO-HIDE
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "No-Hide"
               CHECKED       = NOT _C._HIDE
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN NO-HIDE_proc.
        END TRIGGERS.
  END.

  WHEN "NO-LABELS" THEN DO:
    CREATE TOGGLE-BOX h_NO-LABELS
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "No-Labels"
               CHECKED       = _L._NO-LABELS
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN NO-LABELS_proc.
        END TRIGGERS.
  END.

  WHEN "NO-ROW-MARKERS" THEN DO:
    CREATE TOGGLE-BOX h_NO-ROW-MARKERS
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "No-Row-Markers"
               CHECKED       = _C._NO-ROW-MARKERS
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN NO-ROW-MARKERS_proc.
        END TRIGGERS.
  END.

  WHEN "NO-TAB-STOP" THEN DO:
    CREATE TOGGLE-BOX h_NO-TAB-STOP
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "No-Tab-Stop"
               CHECKED       = _U._NO-TAB-STOP
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN NO-TAB-STOP_proc.
        END TRIGGERS.
  END.

  WHEN "NO-UNDERLINE" THEN DO:
    CREATE TOGGLE-BOX h_NO-UNDERLINE
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "No-Underline"
               CHECKED       = _L._NO-UNDERLINE
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN NO-UNDERLINE_proc.
        END TRIGGERS.
  END.

  WHEN "NO-UNDO" THEN DO:
    CREATE TOGGLE-BOX h_NO-UNDO
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "No-Undo"
               CHECKED       = NOT _F._UNDO
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN NO-UNDO_proc.
        END TRIGGERS.
  END.

  WHEN "NO-VALIDATE" THEN DO:
    CREATE TOGGLE-BOX h_NO-VALIDATE
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "No-Validate"
               CHECKED       = NOT _C._VALIDATE
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN NO-VALIDATE_proc.
        END TRIGGERS.
  END.

  WHEN "OPEN-QUERY" THEN DO:
    CREATE TOGGLE-BOX h_OPEN-QUERY
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Open the Query"
               CHECKED       = _Q._OpenQury
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN OPEN-QUERY_proc.
        END TRIGGERS.
  END.

  WHEN "OVERLAY" THEN DO:
    CREATE TOGGLE-BOX h_OVERLAY
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Overlay"
               CHECKED       = _C._OVERLAY
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN OVERLAY_proc.
        END TRIGGERS.
  END.

  WHEN "PASSWORD-FIELD" THEN DO:
    CREATE TOGGLE-BOX h_PASSWORD-FIELD
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Password-Field"
               CHECKED       = _F._PASSWORD-FIELD
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN PASSWORD-FIELD_proc.
        END TRIGGERS.
  END.

  WHEN "READ-ONLY" THEN DO:
    CREATE TOGGLE-BOX h_READ-ONLY
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Read-Only"
               CHECKED       = _F._READ-ONLY
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN READ-ONLY_proc.
        END TRIGGERS.
  END.

  WHEN "REMOVE-FROM-LAYOUT" THEN DO:
    CREATE TOGGLE-BOX h_REMOVE-FROM-LAYOUT
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Remove from Layout"
               CHECKED       = _L._REMOVE-FROM-LAYOUT
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN REMOVE-FROM-LAYOUT_proc.
        END TRIGGERS.
  END.

  WHEN "RESIZE" THEN DO:
    CREATE TOGGLE-BOX h_RESIZE
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Resize"
               CHECKED       = _U._RESIZABLE
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN RESIZE_proc.
        END TRIGGERS.
  END.

  WHEN "RETAIN-SHAPE" THEN DO:
    CREATE TOGGLE-BOX h_RETAIN-SHAPE
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Retain-Shape"
               CHECKED       = _F._RETAIN-SHAPE
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN RETAIN-SHAPE_proc.
        END TRIGGERS.
  END.

  WHEN "RETURN-INSERTED" THEN DO:
    CREATE TOGGLE-BOX h_RETURN-INSERTED
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Return-Inserted"
               CHECKED       = _F._RETURN-INSERTED
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN RETURN-INSERTED_proc.
        END TRIGGERS.
  END.

  WHEN "SCROLL-BARS" THEN DO:
    CREATE TOGGLE-BOX h_SCROLL-BARS
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Scroll-Bars"
               CHECKED       = _C._SCROLL-BARS
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN SCROLL-BARS_proc.
        END TRIGGERS.
  END.

  WHEN "SCROLLABLE" THEN DO:
    CREATE TOGGLE-BOX h_SCROLLABLE
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Scrollable"
               CHECKED       = _C._SCROLLABLE
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN SCROLLABLE_proc.
        END TRIGGERS.
  END.

  WHEN "SCROLLBAR-H" THEN DO:
    CREATE TOGGLE-BOX h_SCROLLBAR-H
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Scrollbar-Horizontal"
               CHECKED       = _F._SCROLLBAR-H
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN SCROLLBAR-H_proc.
        END TRIGGERS.
  END.

  WHEN "SCROLLBAR-V" THEN DO:
    CREATE TOGGLE-BOX h_SCROLLBAR-V
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Scrollbar-Vertical"
               CHECKED       = _U._SCROLLBAR-V
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN SCROLLBAR-V_proc.
        END TRIGGERS.
  END.

  WHEN "SENSITIVE" THEN DO:
    CREATE TOGGLE-BOX h_SENSITIVE
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Sensitive"
               CHECKED       = _U._SENSITIVE
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN SENSITIVE_proc.
        END TRIGGERS.
  END.

  WHEN "SEPARATORS" THEN DO:
    CREATE TOGGLE-BOX h_SEPARATORS
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Separators"
               CHECKED       = _L._SEPARATORS
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN SEPARATORS_proc.
        END TRIGGERS.
  END.

  WHEN "SHARED" THEN DO:
    CREATE TOGGLE-BOX h_SHARED
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Shared"
               CHECKED       = _U._SHARED
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN SHARED_proc.
        END TRIGGERS.
  END.

  WHEN "SHOW-IN-TASKBAR" THEN DO:
    CREATE TOGGLE-BOX h_SHOW-IN-TASKBAR
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Show-in-Taskbar"
               CHECKED       = _C._SHOW-IN-TASKBAR
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN SHOW-IN-TASKBAR_proc.
        END TRIGGERS.
  END.

  WHEN "SHOW-POPUP" THEN DO:
    CREATE TOGGLE-BOX h_SHOW-POPUP
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Show-popup"
               CHECKED       = _U._SHOW-POPUP
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN SHOW-POPUP_proc.
        END TRIGGERS.
  END.

  WHEN "SIDE-LABELS" THEN DO:
    CREATE TOGGLE-BOX h_SIDE-LABELS
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Side-Labels"
               CHECKED       = _C._SIDE-LABELS
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN SIDE-LABELS_proc.
        END TRIGGERS.
  END.

  WHEN "SIZE-TO-FIT" THEN DO:
    CREATE TOGGLE-BOX h_SIZE-TO-FIT
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Size to fit"
               CHECKED       = _C._size-to-fit
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN SIZE-TO-FIT_proc.
        END TRIGGERS.
  END.

  WHEN "SMALL-TITLE" THEN DO:
    CREATE TOGGLE-BOX h_SMALL-TITLE
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Small-Title"
               CHECKED       = _C._SMALL-TITLE
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN SMALL-TITLE_proc.
        END TRIGGERS.
  END.

  WHEN "SORT" THEN DO:
    CREATE TOGGLE-BOX h_SORT
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Sort"
               CHECKED       = _F._SORT
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN SORT_proc.
        END TRIGGERS.
  END.

  WHEN "STATUS-AREA" THEN DO:
    CREATE TOGGLE-BOX h_STATUS-AREA
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Status-Area"
               CHECKED       = _C._STATUS-AREA
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN STATUS-AREA_proc.
        END TRIGGERS.
  END.

  WHEN "STRETCH-TO-FIT" THEN DO:
    CREATE TOGGLE-BOX h_STRETCH-TO-FIT
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Stretch-to-Fit"
               CHECKED       = _F._STRETCH-TO-FIT
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN STRETCH-TO-FIT_proc.
        END TRIGGERS.
  END.

  WHEN "SUPPRESS-WINDOW" THEN DO:
    CREATE TOGGLE-BOX h_SUPPRESS-WINDOW
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Suppress Window"
               CHECKED       = _C._SUPPRESS-WINDOW
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN SUPPRESS-WINDOW_proc.
        END TRIGGERS.
  END.

  WHEN "TITLE-BAR" THEN DO:
    CREATE TOGGLE-BOX h_TITLE-BAR
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Title Bar"
               CHECKED       = _C._TITLE
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN TITLE-BAR_proc.
        END TRIGGERS.
  END.

  WHEN "TRANSPARENT" THEN DO:
    CREATE TOGGLE-BOX h_TRANSPARENT
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Transparent"
               CHECKED       = _F._TRANSPARENT
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN TRANSPARENT_proc.
        END TRIGGERS.
  END.

  WHEN "UNIQUE-MATCH" THEN DO:
    CREATE TOGGLE-BOX h_UNIQUE-MATCH
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Unique-Match"
               CHECKED       = _F._UNIQUE-MATCH
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN UNIQUE-MATCH_proc.
        END TRIGGERS.
  END.

  WHEN "USE-DICT-EXPS" THEN DO:
    CREATE TOGGLE-BOX h_USE-DICT-EXPS
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Use-Dict-Exps"
               CHECKED       = _C._USE-DICT-EXPS
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN USE-DICT-EXPS_proc.
        END TRIGGERS.
  END.

  WHEN "VIEW" THEN DO:
    CREATE TOGGLE-BOX h_VIEW
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "View"
               CHECKED       = _U._DISPLAY
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN VIEW_proc.
        END TRIGGERS.
  END.

  WHEN "VIEW-AS-TEXT" THEN DO:
    CREATE TOGGLE-BOX h_VIEW-AS-TEXT
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "View-As-Text"
               CHECKED       = (_U._SUBTYPE = "TEXT":U)
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN VIEW-AS-TEXT_proc.
        END TRIGGERS.
  END.

  WHEN "VISIBLE" THEN DO:
    CREATE TOGGLE-BOX h_VISIBLE
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Visible"
               CHECKED       = _U._DISPLAY
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN VISIBLE_proc.
        END TRIGGERS.
  END.

  WHEN "WORD-WRAP" THEN DO:
    CREATE TOGGLE-BOX h_WORD-WRAP
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN 4.5
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE tog-col-3
               LABEL         = "Word-Wrap"
               CHECKED       = _F._WORD-WRAP
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT RUN WORD-WRAP_proc.
        END TRIGGERS.
  END.

