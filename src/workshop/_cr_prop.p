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

                          * * * *  NOTE * * * * 
      For the UIB, this is a generated file. Starting up Workshop,
      I decided to manually maintain it because we support so few
      attributes and it is easier to have it all here. Also, the UIB
      uses this temp-table to define the property sheet layouts, and
      that was not necessary for Workshop.
      
INPUT Parameters:
      (None)

Author: Wm.T.Wood [based on adeuib/_cr_prop.p by D. Ross Hunter]

Date Created: 2/2/97

------------------------------------------------------------------- */

{ workshop/property.i }

CREATE _PROP.
ASSIGN _PROP._NAME      = "COLUMN"
       _PROP._DATA-TYPE = "D"
       _PROP._WIDGETS   = "WINDOW,DIALOG-BOX,FRAME,BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,IMAGE,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,TOGGLE-BOX,TEXT,VBX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "DATA-TYPE"
       _PROP._DATA-TYPE = "C"
       _PROP._WIDGETS   = "COMBO-BOX,FILL-IN,RADIO-SET".

CREATE _PROP.
ASSIGN _PROP._NAME      = "DB-FIELD"
       _PROP._DATA-TYPE = "L"
       _PROP._WIDGETS   = "COMBO-BOX,EDITOR,FILL-IN,RADIO-SET,SELECTION-LIST,SLIDER,TOGGLE-BOX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "DISPLAY"
       _PROP._DATA-TYPE = "L"
       _PROP._WIDGETS   = "COMBO-BOX,EDITOR,FILL-IN,RADIO-SET,SELECTION-LIST,SLIDER,TOGGLE-BOX".


CREATE _PROP.
ASSIGN _PROP._NAME      = "ENABLE"
       _PROP._DATA-TYPE = "L"
       _PROP._WIDGETS   = "BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,IMAGE,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,TOGGLE-BOX".


CREATE _PROP.
ASSIGN _PROP._NAME      = "FORMAT"
       _PROP._DATA-TYPE = "C"
       _PROP._WIDGETS   = "COMBO-BOX,FILL-IN".

CREATE _PROP.
ASSIGN _PROP._NAME      = "HEIGHT"
       _PROP._DATA-TYPE = "D"
       _PROP._WIDGETS   = "WINDOW,DIALOG-BOX,FRAME,BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,IMAGE,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,TOGGLE-BOX,TEXT,VBX".


CREATE _PROP.
ASSIGN _PROP._NAME      = "HELP"
       _PROP._DATA-TYPE = "C"
       _PROP._WIDGETS   = "BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,RADIO-SET,SELECTION-LIST,SLIDER,TOGGLE-BOX,VBX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "HIDDEN"
       _PROP._DATA-TYPE = "L"
       _PROP._WIDGETS   = "WINDOW,DIALOG-BOX,FRAME,BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,IMAGE,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,TOGGLE-BOX,VBX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "INITIAL-VALUE"
       _PROP._DATA-TYPE = "C"
       _PROP._WIDGETS   = "COMBO-BOX,EDITOR,FILL-IN,RADIO-SET,SELECTION-LIST,SLIDER,TOGGLE-BOX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "LIST-ITEMS"
       _PROP._DATA-TYPE = "C"
       _PROP._WIDGETS   = "COMBO-BOX,RADIO-SET,SELECTION-LIST".


CREATE _PROP.
ASSIGN _PROP._NAME      = "MULTIPLE"
       _PROP._DATA-TYPE = "L"
       _PROP._WIDGETS   = "BROWSE,SELECTION-LIST".

CREATE _PROP.
ASSIGN _PROP._NAME      = "NAME"
       _PROP._DATA-TYPE = "C"
       _PROP._WIDGETS   = "WINDOW,DIALOG-BOX,FRAME,BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,IMAGE,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,TOGGLE-BOX,VBX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "PRIVATE-DATA"
       _PROP._DATA-TYPE = "C"
       _PROP._WIDGETS   = "WINDOW,DIALOG-BOX,FRAME,BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,IMAGE,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,TOGGLE-BOX,VBX".

CREATE _PROP.
ASSIGN _PROP._NAME      = "ROW"
       _PROP._DATA-TYPE = "D"
       _PROP._WIDGETS   = "WINDOW,DIALOG-BOX,FRAME,BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,IMAGE,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,TOGGLE-BOX,TEXT,VBX".


CREATE _PROP.
ASSIGN _PROP._NAME      = "SORT"
       _PROP._DATA-TYPE = "L"
       _PROP._WIDGETS   = "COMBO-BOX,SELECTION-LIST".

CREATE _PROP.
ASSIGN _PROP._NAME      = "WIDTH"
       _PROP._DATA-TYPE = "D"
       _PROP._WIDGETS   = "WINDOW,DIALOG-BOX,FRAME,BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,IMAGE,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,TOGGLE-BOX,TEXT,VBX".


CREATE _PROP.
ASSIGN _PROP._NAME      = "WORD-WRAP"
       _PROP._DATA-TYPE = "L"
       _PROP._WIDGETS   = "EDITOR".
