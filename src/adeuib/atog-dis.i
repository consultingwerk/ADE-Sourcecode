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

FILE: atog-dis.i

Description:
      Toggle initialization and trigger code to be included in _advprop.w.

Author: D. Ross Hunter 

Date Generated: 10/05/00

Note: This procedure is generated via the Property Sheet Generator and 
      the abAttribute table of the ab database. 
      DO NOT CHANGE THIS FILE WITHOUT UPDATING THE AB DATABASE AND 
      USING THE PROPERTY SHEET GENERATOR TO GENERATE THIS CODE 

------------------------------------------------------------------- */

  WHEN "Always-On-Top" THEN DO:
    CREATE TOGGLE-BOX h_Always-On-Top
        ASSIGN FRAME         = FRAME adv-dial:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN tog-col-1
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE IF togcnt <= tog-rows * 3 THEN tog-col-3
                               ELSE tog-col-4
               LABEL         = "Always-On-Top"
               CHECKED       = _C._ALWAYS-ON-TOP
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED DO:
            _C._ALWAYS-ON-TOP = SELF:CHECKED.
            IF _C._ALWAYS-ON-TOP THEN 
              ASSIGN
                _C._TOP-ONLY       = FALSE
                h_top-only:CHECKED = FALSE.
          END.
        END TRIGGERS.
  END.

  WHEN "BOX-SELECTABLE" THEN DO:
    CREATE TOGGLE-BOX h_BOX-SELECTABLE
        ASSIGN FRAME         = FRAME adv-dial:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN tog-col-1
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE IF togcnt <= tog-rows * 3 THEN tog-col-3
                               ELSE tog-col-4
               LABEL         = "Box-Selectable"
               CHECKED       = _C._BOX-SELECTABLE
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED DO:
            _C._BOX-SELECTABLE = SELF:CHECKED.
          END.
        END TRIGGERS.
  END.

  WHEN "COLUMN-MOVABLE" THEN DO:
    CREATE TOGGLE-BOX h_COLUMN-MOVABLE
        ASSIGN FRAME         = FRAME adv-dial:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN tog-col-1
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE IF togcnt <= tog-rows * 3 THEN tog-col-3
                               ELSE tog-col-4
               LABEL         = "Column Movable"
               CHECKED       = _C._COLUMN-MOVABLE
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED DO:
            _C._COLUMN-MOVABLE = SELF:CHECKED.
          END.
        END TRIGGERS.
  END.

  WHEN "COLUMN-RESIZABLE" THEN DO:
    CREATE TOGGLE-BOX h_COLUMN-RESIZABLE
        ASSIGN FRAME         = FRAME adv-dial:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN tog-col-1
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE IF togcnt <= tog-rows * 3 THEN tog-col-3
                               ELSE tog-col-4
               LABEL         = "Column Resizable"
               CHECKED       = _C._COLUMN-RESIZABLE
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED DO:
            _C._COLUMN-RESIZABLE = SELF:CHECKED.
          END.
        END TRIGGERS.
  END.

  WHEN "COLUMN-SEARCHING" THEN DO:
    CREATE TOGGLE-BOX h_COLUMN-SEARCHING
        ASSIGN FRAME         = FRAME adv-dial:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN tog-col-1
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE IF togcnt <= tog-rows * 3 THEN tog-col-3
                               ELSE tog-col-4
               LABEL         = "Column Searching"
               CHECKED       = _C._COLUMN-SEARCHING
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED DO:
            _C._COLUMN-SEARCHING = SELF:CHECKED.
          END.
        END TRIGGERS.
  END.

  WHEN "MANUAL-HIGHLIGHT" THEN DO:
    CREATE TOGGLE-BOX h_MANUAL-HIGHLIGHT
        ASSIGN FRAME         = FRAME adv-dial:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN tog-col-1
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE IF togcnt <= tog-rows * 3 THEN tog-col-3
                               ELSE tog-col-4
               LABEL         = "Manual-Highlight"
               CHECKED       = _U._MANUAL-HIGHLIGHT
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED DO:
            _U._MANUAL-HIGHLIGHT = SELF:CHECKED.
          END.
        END TRIGGERS.
  END.

  WHEN "MOVABLE" THEN DO:
    CREATE TOGGLE-BOX h_MOVABLE
        ASSIGN FRAME         = FRAME adv-dial:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN tog-col-1
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE IF togcnt <= tog-rows * 3 THEN tog-col-3
                               ELSE tog-col-4
               LABEL         = "Movable"
               CHECKED       = _U._MOVABLE
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED DO:
            _U._MOVABLE = SELF:CHECKED.
          END.
        END TRIGGERS.
  END.

  WHEN "PAGE-BOTTOM" THEN DO:
    CREATE TOGGLE-BOX h_PAGE-BOTTOM
        ASSIGN FRAME         = FRAME adv-dial:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN tog-col-1
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE IF togcnt <= tog-rows * 3 THEN tog-col-3
                               ELSE tog-col-4
               LABEL         = "Page-Bottom"
               CHECKED       = _C._PAGE-BOTTOM
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED DO:
            _C._PAGE-BOTTOM = SELF:CHECKED.
            IF _C._PAGE-BOTTOM THEN
              ASSIGN _C._DOWN           = FALSE
                     _C._PAGE-TOP       = FALSE
                     h_PAGE-TOP:CHECKED = FALSE.
          END.
        END TRIGGERS.
  END.

  WHEN "PAGE-TOP" THEN DO:
    CREATE TOGGLE-BOX h_PAGE-TOP
        ASSIGN FRAME         = FRAME adv-dial:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN tog-col-1
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE IF togcnt <= tog-rows * 3 THEN tog-col-3
                               ELSE tog-col-4
               LABEL         = "Page-Top"
               CHECKED       = _C._PAGE-TOP
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED DO:
            _C._PAGE-TOP = SELF:CHECKED.
            IF _C._PAGE-TOP THEN
              ASSIGN _C._PAGE-BOTTOM       = FALSE
                     h_PAGE-BOTTOM:CHECKED = FALSE
                     _C._DOWN              = FALSE.
          END.
        END TRIGGERS.
  END.

  WHEN "RESIZABLE" THEN DO:
    CREATE TOGGLE-BOX h_RESIZABLE
        ASSIGN FRAME         = FRAME adv-dial:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN tog-col-1
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE IF togcnt <= tog-rows * 3 THEN tog-col-3
                               ELSE tog-col-4
               LABEL         = "Resizable"
               CHECKED       = _U._RESIZABLE
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED DO:
            _U._RESIZABLE = SELF:CHECKED.
          END.
        END TRIGGERS.
  END.

  WHEN "ROW-RESIZABLE" THEN DO:
    CREATE TOGGLE-BOX h_ROW-RESIZABLE
        ASSIGN FRAME         = FRAME adv-dial:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN tog-col-1
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE IF togcnt <= tog-rows * 3 THEN tog-col-3
                               ELSE tog-col-4
               LABEL         = "Row Resizable"
               CHECKED       = _C._ROW-RESIZABLE
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED DO:
            _C._ROW-RESIZABLE = SELF:CHECKED.
          END.
        END TRIGGERS.
  END.

  WHEN "SELECTABLE" THEN DO:
    CREATE TOGGLE-BOX h_SELECTABLE
        ASSIGN FRAME         = FRAME adv-dial:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN tog-col-1
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE IF togcnt <= tog-rows * 3 THEN tog-col-3
                               ELSE tog-col-4
               LABEL         = "Selectable"
               CHECKED       = _U._SELECTABLE
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED DO:
            _U._SELECTABLE = SELF:CHECKED.
          END.
        END TRIGGERS.
  END.

  WHEN "TOP-ONLY" THEN DO:
    CREATE TOGGLE-BOX h_TOP-ONLY
        ASSIGN FRAME         = FRAME adv-dial:HANDLE
               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc
               COLUMN        = IF togcnt <= tog-rows THEN tog-col-1
                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2
                               ELSE IF togcnt <= tog-rows * 3 THEN tog-col-3
                               ELSE tog-col-4
               LABEL         = "Top-Only"
               CHECKED       = _C._TOP-ONLY
               SENSITIVE     = TRUE
        TRIGGERS:
          ON VALUE-CHANGED DO:
            _C._TOP-ONLY = SELF:CHECKED.
            IF _C._TOP-ONLY AND _U._TYPE = "WINDOW":U THEN
            ASSIGN
              _C._ALWAYS-ON-TOP       = FALSE
              h_always-on-top:CHECKED = FALSE.

          END.
        END TRIGGERS.
  END.

