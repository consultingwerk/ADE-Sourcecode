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

FILE: _cr_prop.p

Description:
      Procedure that is called at the initialization of the UIB to
      create and initialize all of the property Temp-Table Records.

INPUT Parameters:
      (None)

Author: D. Ross Hunter 

Date Generated: 10/05/00

Note: This procedure is generated via the Property Sheet Generator and 
      the abAttribute table of the ab database. 
      DO NOT CHANGE THIS FILE WITHOUT UPDATING THE AB DATABASE AND 
      USING THE PROPERTY SHEET GENERATOR TO GENERATE THIS CODE 

------------------------------------------------------------------- */

{adeuib/property.i}

CREATE _PROP.
ASSIGN _PROP._NAME      = "3-D"
       _PROP._SQ        = 1
       _PROP._DISP-SEQ  = 215
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = no
       _PROP._GEOM      = yes
       _PROP._WIDGETS   = "WINDOW,DIALOG-BOX,FRAME".

CREATE _PROP.
ASSIGN _PROP._NAME      = "ALIGN"
       _PROP._SQ        = 29
       _PROP._DISP-SEQ  = 205
       _PROP._CLASS     = 4
       _PROP._DATA-TYPE = "C"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = no
       _PROP._GEOM      = yes
       _PROP._WIDGETS   = "BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,IMAGE,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,TOGGLE-BOX,TEXT".

CREATE _PROP.
ASSIGN _PROP._NAME      = "Always-On-Top"
       _PROP._SQ        = 30
       _PROP._DISP-SEQ  = 720
       _PROP._CLASS     = 9
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = yes
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "WINDOW".

CREATE _PROP.
ASSIGN _PROP._NAME      = "AUTO-COMPLETION"
       _PROP._SQ        = 31
       _PROP._DISP-SEQ  = 230
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "COMBO-BOX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "AUTO-END-KEY"
       _PROP._SQ        = 32
       _PROP._DISP-SEQ  = 235
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "BUTTON".

CREATE _PROP.
ASSIGN _PROP._NAME      = "AUTO-GO"
       _PROP._SQ        = 33
       _PROP._DISP-SEQ  = 240
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "BUTTON".

CREATE _PROP.
ASSIGN _PROP._NAME      = "AUTO-INDENT"
       _PROP._SQ        = 34
       _PROP._DISP-SEQ  = 245
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "EDITOR".

CREATE _PROP.
ASSIGN _PROP._NAME      = "AUTO-RESIZE"
       _PROP._SQ        = 35
       _PROP._DISP-SEQ  = 250
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "BUTTON,EDITOR,FILL-IN,SELECTION-LIST,SLIDER,TOGGLE-BOX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "AUTO-RETURN"
       _PROP._SQ        = 36
       _PROP._DISP-SEQ  = 255
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "FILL-IN".

CREATE _PROP.
ASSIGN _PROP._NAME      = "BGCOLOR"
       _PROP._SQ        = 2
       _PROP._DISP-SEQ  = 845
       _PROP._CLASS     = ?
       _PROP._DATA-TYPE = "I"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "WINDOW,DIALOG-BOX,FRAME,BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,IMAGE,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,TOGGLE-BOX,TEXT,OCX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "BLANK"
       _PROP._SQ        = 37
       _PROP._DISP-SEQ  = 260
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "FILL-IN".

CREATE _PROP.
ASSIGN _PROP._NAME      = "BOX-SELECTABLE"
       _PROP._SQ        = 38
       _PROP._DISP-SEQ  = 665
       _PROP._CLASS     = 9
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "DIALOG-BOX,FRAME".

CREATE _PROP.
ASSIGN _PROP._NAME      = "CANCEL-BTN"
       _PROP._SQ        = 39
       _PROP._DISP-SEQ  = 265
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "BUTTON".

CREATE _PROP.
ASSIGN _PROP._NAME      = "COL-MULT"
       _PROP._SQ        = 3
       _PROP._DISP-SEQ  = 840
       _PROP._CLASS     = ?
       _PROP._DATA-TYPE = "D"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = no
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "".

CREATE _PROP.
ASSIGN _PROP._NAME      = "COLOR"
       _PROP._SQ        = 40
       _PROP._DISP-SEQ  = 135
       _PROP._CLASS     = 5
       _PROP._DATA-TYPE = "I"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = no
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "WINDOW,DIALOG-BOX,FRAME,BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,IMAGE,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,TOGGLE-BOX,TEXT,OCX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "COLUMN"
       _PROP._SQ        = 4
       _PROP._DISP-SEQ  = 170
       _PROP._CLASS     = 2
       _PROP._DATA-TYPE = "D"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = no
       _PROP._GEOM      = yes
       _PROP._WIDGETS   = "WINDOW,DIALOG-BOX,FRAME,BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,IMAGE,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,TOGGLE-BOX,TEXT,OCX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "COLUMN-MOVABLE"
       _PROP._SQ        = 41
       _PROP._DISP-SEQ  = 670
       _PROP._CLASS     = 9
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "BROWSE".

CREATE _PROP.
ASSIGN _PROP._NAME      = "COLUMN-RESIZABLE"
       _PROP._SQ        = 42
       _PROP._DISP-SEQ  = 675
       _PROP._CLASS     = 9
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "BROWSE".

CREATE _PROP.
ASSIGN _PROP._NAME      = "COLUMN-SCROLLING"
       _PROP._SQ        = 43
       _PROP._DISP-SEQ  = 270
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "BROWSE".

CREATE _PROP.
ASSIGN _PROP._NAME      = "COLUMN-SEARCHING"
       _PROP._SQ        = 44
       _PROP._DISP-SEQ  = 680
       _PROP._CLASS     = 9
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "BROWSE".

CREATE _PROP.
ASSIGN _PROP._NAME      = "CONTEXT-HELP"
       _PROP._SQ        = 45
       _PROP._DISP-SEQ  = 125
       _PROP._CLASS     = 2
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "WINDOW,DIALOG-BOX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "CONTEXT-HELP-FILE"
       _PROP._SQ        = 46
       _PROP._DISP-SEQ  = 130
       _PROP._CLASS     = 2
       _PROP._DATA-TYPE = "C"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "WINDOW,DIALOG-BOX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "CONTEXT-HELP-ID"
       _PROP._SQ        = 47
       _PROP._DISP-SEQ  = 120
       _PROP._CLASS     = 2
       _PROP._DATA-TYPE = "I"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,RADIO-SET,SELECTION-LIST,SLIDER,TOGGLE-BOX,OCX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "Control-Box"
       _PROP._SQ        = 48
       _PROP._DISP-SEQ  = 220
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "WINDOW".

CREATE _PROP.
ASSIGN _PROP._NAME      = "CONVERT-3D-COLORS"
       _PROP._SQ        = 5
       _PROP._DISP-SEQ  = 275
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "BUTTON,IMAGE".

CREATE _PROP.
ASSIGN _PROP._NAME      = "CUSTOM-POSITION"
       _PROP._SQ        = 6
       _PROP._DISP-SEQ  = 870
       _PROP._CLASS     = 2
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = no
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "".

CREATE _PROP.
ASSIGN _PROP._NAME      = "CUSTOM-SIZE"
       _PROP._SQ        = 7
       _PROP._DISP-SEQ  = 875
       _PROP._CLASS     = 2
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = no
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "".

CREATE _PROP.
ASSIGN _PROP._NAME      = "DATA-TYPE"
       _PROP._SQ        = 49
       _PROP._DISP-SEQ  = 30
       _PROP._CLASS     = 3
       _PROP._DATA-TYPE = "C"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "COMBO-BOX,FILL-IN,RADIO-SET".

CREATE _PROP.
ASSIGN _PROP._NAME      = "DB-FIELD"
       _PROP._SQ        = 50
       _PROP._DISP-SEQ  = 155
       _PROP._CLASS     = 5
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = no
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "COMBO-BOX,EDITOR,FILL-IN,RADIO-SET,SELECTION-LIST,SLIDER,TOGGLE-BOX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "DEBLANK"
       _PROP._SQ        = 51
       _PROP._DISP-SEQ  = 280
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "FILL-IN".

CREATE _PROP.
ASSIGN _PROP._NAME      = "DEFAULT-BTN"
       _PROP._SQ        = 52
       _PROP._DISP-SEQ  = 285
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "BUTTON".

CREATE _PROP.
ASSIGN _PROP._NAME      = "DEFAULT-STYLE"
       _PROP._SQ        = 53
       _PROP._DISP-SEQ  = 290
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "BUTTON".

CREATE _PROP.
ASSIGN _PROP._NAME      = "DISABLE-AUTO-ZAP"
       _PROP._SQ        = 54
       _PROP._DISP-SEQ  = 295
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "FILL-IN".

CREATE _PROP.
ASSIGN _PROP._NAME      = "DISPLAY"
       _PROP._SQ        = 55
       _PROP._DISP-SEQ  = 300
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "COMBO-BOX,EDITOR,FILL-IN,RADIO-SET,SELECTION-LIST,SLIDER,TOGGLE-BOX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "DOWN"
       _PROP._SQ        = 56
       _PROP._DISP-SEQ  = 305
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "FRAME".

CREATE _PROP.
ASSIGN _PROP._NAME      = "DRAG-ENABLED"
       _PROP._SQ        = 57
       _PROP._DISP-SEQ  = 310
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "SELECTION-LIST".

CREATE _PROP.
ASSIGN _PROP._NAME      = "Drop-Target"
       _PROP._SQ        = 58
       _PROP._DISP-SEQ  = 225
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "WINDOW,DIALOG-BOX,FRAME,BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,RADIO-SET,SELECTION-LIST,SLIDER,TOGGLE-BOX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "EDGE-PIXELS"
       _PROP._SQ        = 8
       _PROP._DISP-SEQ  = 45
       _PROP._CLASS     = 2
       _PROP._DATA-TYPE = "I"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "RECTANGLE".

CREATE _PROP.
ASSIGN _PROP._NAME      = "ENABLE"
       _PROP._SQ        = 59
       _PROP._DISP-SEQ  = 315
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,IMAGE,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,TOGGLE-BOX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "EXPAND"
       _PROP._SQ        = 60
       _PROP._DISP-SEQ  = 330
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "RADIO-SET".

CREATE _PROP.
ASSIGN _PROP._NAME      = "EXPANDABLE"
       _PROP._SQ        = 61
       _PROP._DISP-SEQ  = 325
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "BROWSE".

CREATE _PROP.
ASSIGN _PROP._NAME      = "EXPLICIT-POSITION"
       _PROP._SQ        = 62
       _PROP._DISP-SEQ  = 335
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = no
       _PROP._GEOM      = yes
       _PROP._WIDGETS   = "WINDOW,DIALOG-BOX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "FGCOLOR"
       _PROP._SQ        = 9
       _PROP._DISP-SEQ  = 835
       _PROP._CLASS     = ?
       _PROP._DATA-TYPE = "I"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "WINDOW,DIALOG-BOX,FRAME,BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,IMAGE,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,TOGGLE-BOX,TEXT,OCX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "FILLED"
       _PROP._SQ        = 10
       _PROP._DISP-SEQ  = 340
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "RECTANGLE".

CREATE _PROP.
ASSIGN _PROP._NAME      = "FLAT"
       _PROP._SQ        = 63
       _PROP._DISP-SEQ  = 320
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "BUTTON".

CREATE _PROP.
ASSIGN _PROP._NAME      = "FONT"
       _PROP._SQ        = 11
       _PROP._DISP-SEQ  = 140
       _PROP._CLASS     = 5
       _PROP._DATA-TYPE = "I"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "WINDOW,DIALOG-BOX,FRAME,BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,RADIO-SET,SELECTION-LIST,SLIDER,TOGGLE-BOX,TEXT".

CREATE _PROP.
ASSIGN _PROP._NAME      = "FORMAT"
       _PROP._SQ        = 64
       _PROP._DISP-SEQ  = 35
       _PROP._CLASS     = 2
       _PROP._DATA-TYPE = "C"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "COMBO-BOX,FILL-IN".

CREATE _PROP.
ASSIGN _PROP._NAME      = "FORMAT-ATTR"
       _PROP._SQ        = 65
       _PROP._DISP-SEQ  = 785
       _PROP._CLASS     = ?
       _PROP._DATA-TYPE = "C"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = no
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "".

CREATE _PROP.
ASSIGN _PROP._NAME      = "FORMAT-SOURCE"
       _PROP._SQ        = 66
       _PROP._DISP-SEQ  = 795
       _PROP._CLASS     = ?
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = no
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "COMBO-BOX,FILL-IN".

CREATE _PROP.
ASSIGN _PROP._NAME      = "FRAME-NAME"
       _PROP._SQ        = 67
       _PROP._DISP-SEQ  = 740
       _PROP._CLASS     = ?
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = yes
       _PROP._CUSTOM    = no
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "FRAME".

CREATE _PROP.
ASSIGN _PROP._NAME      = "FREQUENCY"
       _PROP._SQ        = 68
       _PROP._DISP-SEQ  = 80
       _PROP._CLASS     = 2
       _PROP._DATA-TYPE = "I"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "SLIDER".

CREATE _PROP.
ASSIGN _PROP._NAME      = "GRAPHIC-EDGE"
       _PROP._SQ        = 12
       _PROP._DISP-SEQ  = 345
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "RECTANGLE".

CREATE _PROP.
ASSIGN _PROP._NAME      = "HEIGHT"
       _PROP._SQ        = 13
       _PROP._DISP-SEQ  = 185
       _PROP._CLASS     = 2
       _PROP._DATA-TYPE = "D"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = yes
       _PROP._WIDGETS   = "WINDOW,DIALOG-BOX,FRAME,BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,IMAGE,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,TOGGLE-BOX,TEXT,OCX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "HEIGHT-P"
       _PROP._SQ        = 69
       _PROP._DISP-SEQ  = 855
       _PROP._CLASS     = 2
       _PROP._DATA-TYPE = "I"
       _PROP._SIZE      = "?"
       _PROP._ADV       = yes
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = yes
       _PROP._WIDGETS   = "WINDOW,DIALOG-BOX,FRAME,BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,IMAGE,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,TOGGLE-BOX,TEXT,OCX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "HELP"
       _PROP._SQ        = 70
       _PROP._DISP-SEQ  = 600
       _PROP._CLASS     = 2
       _PROP._DATA-TYPE = "C"
       _PROP._SIZE      = "?"
       _PROP._ADV       = yes
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,RADIO-SET,SELECTION-LIST,SLIDER,TOGGLE-BOX,OCX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "HELP-ATTR"
       _PROP._SQ        = 71
       _PROP._DISP-SEQ  = 760
       _PROP._CLASS     = ?
       _PROP._DATA-TYPE = "C"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = no
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "".

CREATE _PROP.
ASSIGN _PROP._NAME      = "HELP-SOURCE"
       _PROP._SQ        = 72
       _PROP._DISP-SEQ  = 755
       _PROP._CLASS     = ?
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = no
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "COMBO-BOX,EDITOR,FILL-IN,RADIO-SET,SELECTION-LIST,SLIDER,TOGGLE-BOX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "HIDDEN"
       _PROP._SQ        = 73
       _PROP._DISP-SEQ  = 350
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = yes
       _PROP._WIDGETS   = "WINDOW,DIALOG-BOX,FRAME,BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,IMAGE,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,TOGGLE-BOX,OCX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "HORIZONTAL"
       _PROP._SQ        = 74
       _PROP._DISP-SEQ  = 355
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "RADIO-SET,SLIDER".

CREATE _PROP.
ASSIGN _PROP._NAME      = "ICON"
       _PROP._SQ        = 75
       _PROP._DISP-SEQ  = 85
       _PROP._CLASS     = 6
       _PROP._DATA-TYPE = "C"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = no
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "WINDOW".

CREATE _PROP.
ASSIGN _PROP._NAME      = "IMAGE-DOWN"
       _PROP._SQ        = 76
       _PROP._DISP-SEQ  = 100
       _PROP._CLASS     = 6
       _PROP._DATA-TYPE = "C"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "BUTTON".

CREATE _PROP.
ASSIGN _PROP._NAME      = "IMAGE-FILE"
       _PROP._SQ        = 77
       _PROP._DISP-SEQ  = 95
       _PROP._CLASS     = 6
       _PROP._DATA-TYPE = "C"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "BUTTON,IMAGE".

CREATE _PROP.
ASSIGN _PROP._NAME      = "IMAGE-INSENSITIVE"
       _PROP._SQ        = 78
       _PROP._DISP-SEQ  = 105
       _PROP._CLASS     = 6
       _PROP._DATA-TYPE = "C"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "BUTTON".

CREATE _PROP.
ASSIGN _PROP._NAME      = "INITIAL-VALUE"
       _PROP._SQ        = 79
       _PROP._DISP-SEQ  = 630
       _PROP._CLASS     = 2
       _PROP._DATA-TYPE = "C"
       _PROP._SIZE      = "?"
       _PROP._ADV       = yes
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "COMBO-BOX,EDITOR,FILL-IN,RADIO-SET,SELECTION-LIST,SLIDER,TOGGLE-BOX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "INNER-LINES"
       _PROP._SQ        = 80
       _PROP._DISP-SEQ  = 25
       _PROP._CLASS     = 2
       _PROP._DATA-TYPE = "I"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = yes
       _PROP._WIDGETS   = "COMBO-BOX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "KEEP-FRAME-Z-ORDER"
       _PROP._SQ        = 81
       _PROP._DISP-SEQ  = 360
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = no
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "WINDOW".

CREATE _PROP.
ASSIGN _PROP._NAME      = "KEEP-TAB-ORDER"
       _PROP._SQ        = 82
       _PROP._DISP-SEQ  = 370
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "DIALOG-BOX,FRAME".

CREATE _PROP.
ASSIGN _PROP._NAME      = "LABEL"
       _PROP._SQ        = 83
       _PROP._DISP-SEQ  = 10
       _PROP._CLASS     = 2
       _PROP._DATA-TYPE = "C"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "WINDOW,DIALOG-BOX,FRAME,BROWSE,BUTTON,COMBO-BOX,FILL-IN,TOGGLE-BOX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "LABEL-ATTR"
       _PROP._SQ        = 84
       _PROP._DISP-SEQ  = 745
       _PROP._CLASS     = ?
       _PROP._DATA-TYPE = "C"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = no
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "".

CREATE _PROP.
ASSIGN _PROP._NAME      = "LABEL-SOURCE"
       _PROP._SQ        = 85
       _PROP._DISP-SEQ  = 750
       _PROP._CLASS     = ?
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = no
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "COMBO-BOX,FILL-IN,TOGGLE-BOX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "LARGE"
       _PROP._SQ        = 86
       _PROP._DISP-SEQ  = 375
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "EDITOR".

CREATE _PROP.
ASSIGN _PROP._NAME      = "LARGE-TO-SMALL"
       _PROP._SQ        = 87
       _PROP._DISP-SEQ  = 380
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "SLIDER".

CREATE _PROP.
ASSIGN _PROP._NAME      = "LAYOUT-UNIT"
       _PROP._SQ        = 88
       _PROP._DISP-SEQ  = 735
       _PROP._CLASS     = 4
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = yes
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = yes
       _PROP._WIDGETS   = "WINDOW,DIALOG-BOX,FRAME,BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,IMAGE,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,TOGGLE-BOX,TEXT,OCX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "LIST-ITEMS"
       _PROP._SQ        = 89
       _PROP._DISP-SEQ  = 20
       _PROP._CLASS     = 8
       _PROP._DATA-TYPE = "C"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "COMBO-BOX,RADIO-SET,SELECTION-LIST".

CREATE _PROP.
ASSIGN _PROP._NAME      = "LOCK-COLUMNS"
       _PROP._SQ        = 90
       _PROP._DISP-SEQ  = 65
       _PROP._CLASS     = 2
       _PROP._DATA-TYPE = "I"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "BROWSE".

CREATE _PROP.
ASSIGN _PROP._NAME      = "MANUAL-HIGHLIGHT"
       _PROP._SQ        = 91
       _PROP._DISP-SEQ  = 685
       _PROP._CLASS     = 9
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "FRAME,BUTTON,COMBO-BOX,EDITOR,FILL-IN,IMAGE,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,TOGGLE-BOX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "MAX-BUTTON"
       _PROP._SQ        = 92
       _PROP._DISP-SEQ  = 365
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "WINDOW".

CREATE _PROP.
ASSIGN _PROP._NAME      = "MAX-CHARS"
       _PROP._SQ        = 93
       _PROP._DISP-SEQ  = 55
       _PROP._CLASS     = 2
       _PROP._DATA-TYPE = "I"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "COMBO-BOX,EDITOR".

CREATE _PROP.
ASSIGN _PROP._NAME      = "MAX-DATA-GUESS"
       _PROP._SQ        = 94
       _PROP._DISP-SEQ  = 75
       _PROP._CLASS     = 2
       _PROP._DATA-TYPE = "I"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "BROWSE".

CREATE _PROP.
ASSIGN _PROP._NAME      = "MAX-VALUE"
       _PROP._SQ        = 95
       _PROP._DISP-SEQ  = 60
       _PROP._CLASS     = 2
       _PROP._DATA-TYPE = "I"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "SLIDER".

CREATE _PROP.
ASSIGN _PROP._NAME      = "MENU-BAR"
       _PROP._SQ        = 96
       _PROP._DISP-SEQ  = 160
       _PROP._CLASS     = 5
       _PROP._DATA-TYPE = "R"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = no
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "WINDOW".

CREATE _PROP.
ASSIGN _PROP._NAME      = "MENU-KEY"
       _PROP._SQ        = 97
       _PROP._DISP-SEQ  = 730
       _PROP._CLASS     = 2
       _PROP._DATA-TYPE = "C"
       _PROP._SIZE      = "?"
       _PROP._ADV       = yes
       _PROP._CUSTOM    = no
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "WINDOW,DIALOG-BOX,FRAME,BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,RADIO-SET,SELECTION-LIST,SLIDER,TOGGLE-BOX,OCX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "MESSAGE-AREA"
       _PROP._SQ        = 98
       _PROP._DISP-SEQ  = 385
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = no
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "WINDOW".

CREATE _PROP.
ASSIGN _PROP._NAME      = "MESSAGE-AREA-FONT"
       _PROP._SQ        = 99
       _PROP._DISP-SEQ  = 830
       _PROP._CLASS     = 4
       _PROP._DATA-TYPE = "I"
       _PROP._SIZE      = "?"
       _PROP._ADV       = yes
       _PROP._CUSTOM    = no
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "WINDOW".

CREATE _PROP.
ASSIGN _PROP._NAME      = "MIN-BUTTON"
       _PROP._SQ        = 100
       _PROP._DISP-SEQ  = 390
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "WINDOW".

CREATE _PROP.
ASSIGN _PROP._NAME      = "MIN-HEIGHT"
       _PROP._SQ        = 101
       _PROP._DISP-SEQ  = 765
       _PROP._CLASS     = 2
       _PROP._DATA-TYPE = "D"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = no
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "".

CREATE _PROP.
ASSIGN _PROP._NAME      = "MIN-HEIGHT-P"
       _PROP._SQ        = 102
       _PROP._DISP-SEQ  = 770
       _PROP._CLASS     = 2
       _PROP._DATA-TYPE = "I"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = no
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "".

CREATE _PROP.
ASSIGN _PROP._NAME      = "MIN-VALUE"
       _PROP._SQ        = 103
       _PROP._DISP-SEQ  = 50
       _PROP._CLASS     = 2
       _PROP._DATA-TYPE = "I"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "SLIDER".

CREATE _PROP.
ASSIGN _PROP._NAME      = "MIN-WIDTH"
       _PROP._SQ        = 104
       _PROP._DISP-SEQ  = 775
       _PROP._CLASS     = 2
       _PROP._DATA-TYPE = "D"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = no
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "".

CREATE _PROP.
ASSIGN _PROP._NAME      = "MIN-WIDTH-P"
       _PROP._SQ        = 105
       _PROP._DISP-SEQ  = 780
       _PROP._CLASS     = 2
       _PROP._DATA-TYPE = "I"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = no
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "".

CREATE _PROP.
ASSIGN _PROP._NAME      = "MOUSE-POINTER"
       _PROP._SQ        = 106
       _PROP._DISP-SEQ  = 800
       _PROP._CLASS     = 4
       _PROP._DATA-TYPE = "I"
       _PROP._SIZE      = "?"
       _PROP._ADV       = yes
       _PROP._CUSTOM    = no
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "WINDOW,DIALOG-BOX,FRAME,BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,RADIO-SET,SELECTION-LIST,SLIDER,TOGGLE-BOX,OCX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "MOVABLE"
       _PROP._SQ        = 107
       _PROP._DISP-SEQ  = 690
       _PROP._CLASS     = 9
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "FRAME,BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,IMAGE,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,TOGGLE-BOX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "MULTIPLE"
       _PROP._SQ        = 108
       _PROP._DISP-SEQ  = 400
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "BROWSE,SELECTION-LIST".

CREATE _PROP.
ASSIGN _PROP._NAME      = "NAME"
       _PROP._SQ        = 109
       _PROP._DISP-SEQ  = 5
       _PROP._CLASS     = 2
       _PROP._DATA-TYPE = "C"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "WINDOW,DIALOG-BOX,FRAME,BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,IMAGE,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,TOGGLE-BOX,OCX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "NATIVE"
       _PROP._SQ        = 110
       _PROP._DISP-SEQ  = 405
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "FILL-IN".

CREATE _PROP.
ASSIGN _PROP._NAME      = "NO-ASSIGN"
       _PROP._SQ        = 111
       _PROP._DISP-SEQ  = 410
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "BROWSE".

CREATE _PROP.
ASSIGN _PROP._NAME      = "NO-AUTO-VALIDATE"
       _PROP._SQ        = 112
       _PROP._DISP-SEQ  = 415
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "DIALOG-BOX,FRAME,BROWSE".

CREATE _PROP.
ASSIGN _PROP._NAME      = "NO-BOX"
       _PROP._SQ        = 14
       _PROP._DISP-SEQ  = 420
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "FRAME,BROWSE,EDITOR".

CREATE _PROP.
ASSIGN _PROP._NAME      = "NO-CURRENT-VALUE"
       _PROP._SQ        = 113
       _PROP._DISP-SEQ  = 395
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "SLIDER".

CREATE _PROP.
ASSIGN _PROP._NAME      = "NO-FOCUS"
       _PROP._SQ        = 15
       _PROP._DISP-SEQ  = 425
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "BUTTON".

CREATE _PROP.
ASSIGN _PROP._NAME      = "NO-HELP"
       _PROP._SQ        = 114
       _PROP._DISP-SEQ  = 430
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "DIALOG-BOX,FRAME".

CREATE _PROP.
ASSIGN _PROP._NAME      = "NO-HIDE"
       _PROP._SQ        = 115
       _PROP._DISP-SEQ  = 435
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "FRAME".

CREATE _PROP.
ASSIGN _PROP._NAME      = "NO-LABEL"
       _PROP._SQ        = 116
       _PROP._DISP-SEQ  = 880
       _PROP._CLASS     = ?
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "COMBO-BOX,FILL-IN".

CREATE _PROP.
ASSIGN _PROP._NAME      = "NO-LABELS"
       _PROP._SQ        = 16
       _PROP._DISP-SEQ  = 440
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "DIALOG-BOX,FRAME,BROWSE".

CREATE _PROP.
ASSIGN _PROP._NAME      = "NO-ROW-MARKERS"
       _PROP._SQ        = 117
       _PROP._DISP-SEQ  = 445
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "BROWSE".

CREATE _PROP.
ASSIGN _PROP._NAME      = "NO-TAB-STOP"
       _PROP._SQ        = 118
       _PROP._DISP-SEQ  = 450
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,RADIO-SET,SELECTION-LIST,SLIDER,TOGGLE-BOX,OCX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "NO-UNDERLINE"
       _PROP._SQ        = 17
       _PROP._DISP-SEQ  = 455
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "FRAME".

CREATE _PROP.
ASSIGN _PROP._NAME      = "NO-UNDO"
       _PROP._SQ        = 119
       _PROP._DISP-SEQ  = 460
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "COMBO-BOX,EDITOR,FILL-IN,RADIO-SET,SELECTION-LIST,SLIDER,TOGGLE-BOX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "NO-VALIDATE"
       _PROP._SQ        = 120
       _PROP._DISP-SEQ  = 465
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "DIALOG-BOX,FRAME,BROWSE".

CREATE _PROP.
ASSIGN _PROP._NAME      = "OPEN-QUERY"
       _PROP._SQ        = 121
       _PROP._DISP-SEQ  = 470
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "DIALOG-BOX,FRAME,BROWSE".

CREATE _PROP.
ASSIGN _PROP._NAME      = "OVERLAY"
       _PROP._SQ        = 122
       _PROP._DISP-SEQ  = 475
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "FRAME".

CREATE _PROP.
ASSIGN _PROP._NAME      = "PAGE-BOTTOM"
       _PROP._SQ        = 123
       _PROP._DISP-SEQ  = 695
       _PROP._CLASS     = 9
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "FRAME".

CREATE _PROP.
ASSIGN _PROP._NAME      = "PAGE-TOP"
       _PROP._SQ        = 124
       _PROP._DISP-SEQ  = 700
       _PROP._CLASS     = 9
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "FRAME".

CREATE _PROP.
ASSIGN _PROP._NAME      = "POP-UP"
       _PROP._SQ        = 125
       _PROP._DISP-SEQ  = 145
       _PROP._CLASS     = 5
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = no
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "WINDOW,DIALOG-BOX,FRAME,BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,RADIO-SET,SELECTION-LIST,SLIDER,TOGGLE-BOX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "PRIVATE-DATA"
       _PROP._SQ        = 126
       _PROP._DISP-SEQ  = 635
       _PROP._CLASS     = 7
       _PROP._DATA-TYPE = "C"
       _PROP._SIZE      = "?"
       _PROP._ADV       = yes
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "WINDOW,DIALOG-BOX,FRAME,BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,IMAGE,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,TOGGLE-BOX,OCX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "QUERY"
       _PROP._SQ        = 127
       _PROP._DISP-SEQ  = 15
       _PROP._CLASS     = ?
       _PROP._DATA-TYPE = "C"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = no
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "DIALOG-BOX,FRAME,BROWSE".

CREATE _PROP.
ASSIGN _PROP._NAME      = "READ-ONLY"
       _PROP._SQ        = 128
       _PROP._DISP-SEQ  = 480
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "EDITOR,FILL-IN".

CREATE _PROP.
ASSIGN _PROP._NAME      = "REMOVE-FROM-LAYOUT"
       _PROP._SQ        = 18
       _PROP._DISP-SEQ  = 485
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = no
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "FRAME,BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,IMAGE,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,TOGGLE-BOX,OCX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "RESIZABLE"
       _PROP._SQ        = 129
       _PROP._DISP-SEQ  = 705
       _PROP._CLASS     = 9
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "FRAME,BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,IMAGE,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,TOGGLE-BOX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "RESIZE"
       _PROP._SQ        = 130
       _PROP._DISP-SEQ  = 490
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = no
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "WINDOW".

CREATE _PROP.
ASSIGN _PROP._NAME      = "RETAIN"
       _PROP._SQ        = 131
       _PROP._DISP-SEQ  = 115
       _PROP._CLASS     = 2
       _PROP._DATA-TYPE = "I"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "FRAME".

CREATE _PROP.
ASSIGN _PROP._NAME      = "RETAIN-SHAPE"
       _PROP._SQ        = 132
       _PROP._DISP-SEQ  = 495
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "IMAGE".

CREATE _PROP.
ASSIGN _PROP._NAME      = "RETURN-INSERTED"
       _PROP._SQ        = 133
       _PROP._DISP-SEQ  = 500
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "EDITOR".

CREATE _PROP.
ASSIGN _PROP._NAME      = "ROW"
       _PROP._SQ        = 19
       _PROP._DISP-SEQ  = 175
       _PROP._CLASS     = 2
       _PROP._DATA-TYPE = "D"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = no
       _PROP._GEOM      = yes
       _PROP._WIDGETS   = "WINDOW,DIALOG-BOX,FRAME,BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,IMAGE,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,TOGGLE-BOX,TEXT,OCX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "ROW-HEIGHT"
       _PROP._SQ        = 134
       _PROP._DISP-SEQ  = 190
       _PROP._CLASS     = 2
       _PROP._DATA-TYPE = "D"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "BROWSE".

CREATE _PROP.
ASSIGN _PROP._NAME      = "ROW-HEIGHT-P"
       _PROP._SQ        = 135
       _PROP._DISP-SEQ  = 860
       _PROP._CLASS     = 2
       _PROP._DATA-TYPE = "I"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "BROWSE".

CREATE _PROP.
ASSIGN _PROP._NAME      = "ROW-MULT"
       _PROP._SQ        = 20
       _PROP._DISP-SEQ  = 825
       _PROP._CLASS     = ?
       _PROP._DATA-TYPE = "D"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = no
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "".

CREATE _PROP.
ASSIGN _PROP._NAME      = "ROW-RESIZABLE"
       _PROP._SQ        = 136
       _PROP._DISP-SEQ  = 710
       _PROP._CLASS     = 9
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "BROWSE".

CREATE _PROP.
ASSIGN _PROP._NAME      = "RUN-PERSISTENT"
       _PROP._SQ        = 137
       _PROP._DISP-SEQ  = 505
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = no
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "".

CREATE _PROP.
ASSIGN _PROP._NAME      = "SCREEN-LINES"
       _PROP._SQ        = 138
       _PROP._DISP-SEQ  = 810
       _PROP._CLASS     = ?
       _PROP._DATA-TYPE = "D"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = no
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "".

CREATE _PROP.
ASSIGN _PROP._NAME      = "SCROLL-BARS"
       _PROP._SQ        = 139
       _PROP._DISP-SEQ  = 510
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = no
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "WINDOW".

CREATE _PROP.
ASSIGN _PROP._NAME      = "SCROLLABLE"
       _PROP._SQ        = 140
       _PROP._DISP-SEQ  = 515
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "FRAME".

CREATE _PROP.
ASSIGN _PROP._NAME      = "SCROLLBAR-H"
       _PROP._SQ        = 141
       _PROP._DISP-SEQ  = 520
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "EDITOR,SELECTION-LIST".

CREATE _PROP.
ASSIGN _PROP._NAME      = "SCROLLBAR-V"
       _PROP._SQ        = 142
       _PROP._DISP-SEQ  = 525
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "BROWSE,EDITOR,SELECTION-LIST".

CREATE _PROP.
ASSIGN _PROP._NAME      = "SELECTABLE"
       _PROP._SQ        = 143
       _PROP._DISP-SEQ  = 715
       _PROP._CLASS     = 9
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "FRAME,BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,IMAGE,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,TOGGLE-BOX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "SENSITIVE"
       _PROP._SQ        = 144
       _PROP._DISP-SEQ  = 530
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "WINDOW,DIALOG-BOX,FRAME,OCX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "SEPARATOR-FGCOLOR"
       _PROP._SQ        = 21
       _PROP._DISP-SEQ  = 850
       _PROP._CLASS     = ?
       _PROP._DATA-TYPE = "I"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "BROWSE".

CREATE _PROP.
ASSIGN _PROP._NAME      = "SEPARATORS"
       _PROP._SQ        = 22
       _PROP._DISP-SEQ  = 545
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "BROWSE".

CREATE _PROP.
ASSIGN _PROP._NAME      = "SHARED"
       _PROP._SQ        = 145
       _PROP._DISP-SEQ  = 550
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = no
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "FRAME,COMBO-BOX,EDITOR,FILL-IN,RADIO-SET,SELECTION-LIST,SLIDER,TOGGLE-BOX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "SHOW-IN-TASKBAR"
       _PROP._SQ        = 146
       _PROP._DISP-SEQ  = 535
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "WINDOW".

CREATE _PROP.
ASSIGN _PROP._NAME      = "SIDE-LABELS"
       _PROP._SQ        = 147
       _PROP._DISP-SEQ  = 555
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "FRAME".

CREATE _PROP.
ASSIGN _PROP._NAME      = "SIZE-TO-FIT"
       _PROP._SQ        = 148
       _PROP._DISP-SEQ  = 560
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = yes
       _PROP._WIDGETS   = "FRAME".

CREATE _PROP.
ASSIGN _PROP._NAME      = "SMALL-ICON"
       _PROP._SQ        = 149
       _PROP._DISP-SEQ  = 90
       _PROP._CLASS     = 6
       _PROP._DATA-TYPE = "C"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = no
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "WINDOW".

CREATE _PROP.
ASSIGN _PROP._NAME      = "SMALL-TITLE"
       _PROP._SQ        = 150
       _PROP._DISP-SEQ  = 540
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "WINDOW".

CREATE _PROP.
ASSIGN _PROP._NAME      = "SORT"
       _PROP._SQ        = 151
       _PROP._DISP-SEQ  = 565
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "COMBO-BOX,SELECTION-LIST".

CREATE _PROP.
ASSIGN _PROP._NAME      = "STATUS-AREA"
       _PROP._SQ        = 152
       _PROP._DISP-SEQ  = 570
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = no
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "WINDOW".

CREATE _PROP.
ASSIGN _PROP._NAME      = "STATUS-AREA-FONT"
       _PROP._SQ        = 153
       _PROP._DISP-SEQ  = 805
       _PROP._CLASS     = 4
       _PROP._DATA-TYPE = "I"
       _PROP._SIZE      = "?"
       _PROP._ADV       = yes
       _PROP._CUSTOM    = no
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "WINDOW".

CREATE _PROP.
ASSIGN _PROP._NAME      = "STRETCH-TO-FIT"
       _PROP._SQ        = 154
       _PROP._DISP-SEQ  = 575
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "IMAGE".

CREATE _PROP.
ASSIGN _PROP._NAME      = "SUBTYPE"
       _PROP._SQ        = 155
       _PROP._DISP-SEQ  = 40
       _PROP._CLASS     = ?
       _PROP._DATA-TYPE = "C"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "COMBO-BOX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "SUPPRESS-WINDOW"
       _PROP._SQ        = 156
       _PROP._DISP-SEQ  = 580
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = no
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "WINDOW".

CREATE _PROP.
ASSIGN _PROP._NAME      = "TIC-MARKS"
       _PROP._SQ        = 157
       _PROP._DISP-SEQ  = 70
       _PROP._CLASS     = 4
       _PROP._DATA-TYPE = "C"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "SLIDER".

CREATE _PROP.
ASSIGN _PROP._NAME      = "TITLE"
       _PROP._SQ        = 158
       _PROP._DISP-SEQ  = 865
       _PROP._CLASS     = 3
       _PROP._DATA-TYPE = "C"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "WINDOW,DIALOG-BOX,FRAME,BROWSE".

CREATE _PROP.
ASSIGN _PROP._NAME      = "TITLE-BAR"
       _PROP._SQ        = 159
       _PROP._DISP-SEQ  = 585
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "FRAME,BROWSE".

CREATE _PROP.
ASSIGN _PROP._NAME      = "TITLE-BGCOLOR"
       _PROP._SQ        = 23
       _PROP._DISP-SEQ  = 815
       _PROP._CLASS     = ?
       _PROP._DATA-TYPE = "I"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "FRAME".

CREATE _PROP.
ASSIGN _PROP._NAME      = "TITLE-COLOR"
       _PROP._SQ        = 160
       _PROP._DISP-SEQ  = 165
       _PROP._CLASS     = 5
       _PROP._DATA-TYPE = "I"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = no
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "FRAME".

CREATE _PROP.
ASSIGN _PROP._NAME      = "TITLE-FGCOLOR"
       _PROP._SQ        = 24
       _PROP._DISP-SEQ  = 820
       _PROP._CLASS     = ?
       _PROP._DATA-TYPE = "I"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "FRAME".

CREATE _PROP.
ASSIGN _PROP._NAME      = "TOGGLES"
       _PROP._SQ        = 161
       _PROP._DISP-SEQ  = 210
       _PROP._CLASS     = 5
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = yes
       _PROP._CUSTOM    = no
       _PROP._GEOM      = yes
       _PROP._WIDGETS   = "WINDOW,DIALOG-BOX,FRAME,BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,IMAGE,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,TOGGLE-BOX,OCX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "TOOLTIP"
       _PROP._SQ        = 162
       _PROP._DISP-SEQ  = 110
       _PROP._CLASS     = 2
       _PROP._DATA-TYPE = "C"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,IMAGE,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,TOGGLE-BOX,TEXT".

CREATE _PROP.
ASSIGN _PROP._NAME      = "TOP-ONLY"
       _PROP._SQ        = 163
       _PROP._DISP-SEQ  = 725
       _PROP._CLASS     = 9
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = yes
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "WINDOW,FRAME".

CREATE _PROP.
ASSIGN _PROP._NAME      = "TRANS-ATTRS"
       _PROP._SQ        = 164
       _PROP._DISP-SEQ  = 150
       _PROP._CLASS     = 5
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = no
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "WINDOW,DIALOG-BOX,FRAME,BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,IMAGE,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,TOGGLE-BOX,TEXT".

CREATE _PROP.
ASSIGN _PROP._NAME      = "TRANSPARENT"
       _PROP._SQ        = 165
       _PROP._DISP-SEQ  = 590
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "IMAGE".

CREATE _PROP.
ASSIGN _PROP._NAME      = "UNIQUE-MATCH"
       _PROP._SQ        = 166
       _PROP._DISP-SEQ  = 595
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "COMBO-BOX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "USE-DICT-EXPS"
       _PROP._SQ        = 167
       _PROP._DISP-SEQ  = 605
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "DIALOG-BOX,FRAME".

CREATE _PROP.
ASSIGN _PROP._NAME      = "VIEW"
       _PROP._SQ        = 168
       _PROP._DISP-SEQ  = 610
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "WINDOW,DIALOG-BOX,FRAME".

CREATE _PROP.
ASSIGN _PROP._NAME      = "VIEW-AS-TEXT"
       _PROP._SQ        = 169
       _PROP._DISP-SEQ  = 620
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "FILL-IN".

CREATE _PROP.
ASSIGN _PROP._NAME      = "VIRTUAL-HEIGHT"
       _PROP._SQ        = 25
       _PROP._DISP-SEQ  = 200
       _PROP._CLASS     = 2
       _PROP._DATA-TYPE = "D"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = yes
       _PROP._WIDGETS   = "WINDOW,FRAME".

CREATE _PROP.
ASSIGN _PROP._NAME      = "VIRTUAL-HEIGHT-P"
       _PROP._SQ        = 170
       _PROP._DISP-SEQ  = 655
       _PROP._CLASS     = 2
       _PROP._DATA-TYPE = "I"
       _PROP._SIZE      = "?"
       _PROP._ADV       = yes
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = yes
       _PROP._WIDGETS   = "WINDOW,FRAME".

CREATE _PROP.
ASSIGN _PROP._NAME      = "VIRTUAL-WIDTH"
       _PROP._SQ        = 26
       _PROP._DISP-SEQ  = 195
       _PROP._CLASS     = 2
       _PROP._DATA-TYPE = "D"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = yes
       _PROP._WIDGETS   = "WINDOW,FRAME".

CREATE _PROP.
ASSIGN _PROP._NAME      = "VIRTUAL-WIDTH-P"
       _PROP._SQ        = 171
       _PROP._DISP-SEQ  = 660
       _PROP._CLASS     = 2
       _PROP._DATA-TYPE = "I"
       _PROP._SIZE      = "?"
       _PROP._ADV       = yes
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = yes
       _PROP._WIDGETS   = "WINDOW,FRAME".

CREATE _PROP.
ASSIGN _PROP._NAME      = "VISIBLE"
       _PROP._SQ        = 172
       _PROP._DISP-SEQ  = 615
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "".

CREATE _PROP.
ASSIGN _PROP._NAME      = "WIDTH"
       _PROP._SQ        = 27
       _PROP._DISP-SEQ  = 180
       _PROP._CLASS     = 2
       _PROP._DATA-TYPE = "D"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = yes
       _PROP._WIDGETS   = "WINDOW,DIALOG-BOX,FRAME,BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,IMAGE,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,TOGGLE-BOX,TEXT,OCX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "WIDTH-P"
       _PROP._SQ        = 173
       _PROP._DISP-SEQ  = 650
       _PROP._CLASS     = 2
       _PROP._DATA-TYPE = "I"
       _PROP._SIZE      = "?"
       _PROP._ADV       = yes
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = yes
       _PROP._WIDGETS   = "WINDOW,DIALOG-BOX,FRAME,BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,IMAGE,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,TOGGLE-BOX,TEXT,OCX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "WIN-TYPE"
       _PROP._SQ        = 28
       _PROP._DISP-SEQ  = 790
       _PROP._CLASS     = ?
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = yes
       _PROP._CUSTOM    = no
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "WINDOW,DIALOG-BOX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "WORD-WRAP"
       _PROP._SQ        = 174
       _PROP._DISP-SEQ  = 625
       _PROP._CLASS     = 1
       _PROP._DATA-TYPE = "L"
       _PROP._SIZE      = "?"
       _PROP._ADV       = no
       _PROP._CUSTOM    = yes
       _PROP._GEOM      = no
       _PROP._WIDGETS   = "EDITOR".

CREATE _PROP.
ASSIGN _PROP._NAME      = "X"
       _PROP._SQ        = 175
       _PROP._DISP-SEQ  = 640
       _PROP._CLASS     = 2
       _PROP._DATA-TYPE = "I"
       _PROP._SIZE      = "?"
       _PROP._ADV       = yes
       _PROP._CUSTOM    = no
       _PROP._GEOM      = yes
       _PROP._WIDGETS   = "WINDOW,DIALOG-BOX,FRAME,BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,IMAGE,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,TOGGLE-BOX,TEXT,OCX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "Y"
       _PROP._SQ        = 176
       _PROP._DISP-SEQ  = 645
       _PROP._CLASS     = 2
       _PROP._DATA-TYPE = "I"
       _PROP._SIZE      = "?"
       _PROP._ADV       = yes
       _PROP._CUSTOM    = no
       _PROP._GEOM      = yes
       _PROP._WIDGETS   = "WINDOW,DIALOG-BOX,FRAME,BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,IMAGE,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,TOGGLE-BOX,TEXT,OCX".

