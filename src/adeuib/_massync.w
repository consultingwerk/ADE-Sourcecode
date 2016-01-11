&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v7r10 GUI
&ANALYZE-RESUME

&Scoped-define WINDOW-NAME    massync
&Scoped-define FRAME-NAME     massync
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS massync 
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
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Ross Hunter

  Created: 03/08/94 -  3:30 pm
  
  Modified:
    06/15/99  tsm  Added support for separator-fgcolor

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE VARIABLE tol AS DECIMAL INITIAL .03                         NO-UNDO.

&GLOBAL-DEFINE WIN95-BTN YES

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER u-recid AS RECID                            NO-UNDO.
DEFINE INPUT PARAMETER cur_lo  AS CHARACTER                        NO-UNDO.

/* Local Variable Definitions ---                                       */
{adeuib/uniwidg.i}
{adecomm/adestds.i}
{adeuib/uibhlp.i}
{adeuib/layout.i}

DEFINE TEMP-TABLE _DIFFER                                          NO-UNDO
      FIELD _PROP    AS CHAR FORMAT "X(18)"
      FIELD _M_Value AS CHAR FORMAT "X(32)"
      FIELD _SYNC    AS CHAR FORMAT "X"
      FIELD _C_Value AS CHAR FORMAT "X(32)"
   INDEX _PROP IS PRIMARY _PROP.

DEFINE VARIABLE stupid  AS LOGICAL                                 NO-UNDO.
DEFINE VARIABLE halflap AS INTEGER                                 NO-UNDO.
DEFINE VARIABLE overlap AS INTEGER                                 NO-UNDO.
DEFINE BUFFER m_L FOR _L.
   
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



/* ********************  Preprocessor Definitions  ******************** */

/* Name of first Frame and/or Browse (alphabetically)                   */
&Scoped-define FRAME-NAME  massync
&Scoped-define BROWSE-NAME BROWSE-1

/* Custom List Definitions                                              */
&Scoped-define LIST-1 
&Scoped-define LIST-2 
&Scoped-define LIST-3 

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 _DIFFER._PROP ~
_DIFFER._M_value _DIFFER._SYNC _DIFFER._C_Value 
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 PRESELECT EACH _DIFFER.
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 _DIFFER
&Scoped-define TABLES-IN-QUERY-BROWSE-1 _DIFFER 

/* Definitions for DIALOG-BOX massync                                   */
&Scoped-define FIELDS-IN-QUERY-massync 
&Scoped-define OPEN-BROWSERS-IN-QUERY-massync ~
    ~{&OPEN-QUERY-BROWSE-1}

/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Custom    IMAGE-UP FILE "adeicon/pvback".
DEFINE BUTTON Btn_Space     LABEL " ".
DEFINE BUTTON Btn_Master    IMAGE-UP FILE "adeicon/pvforw".
DEFINE VAR    mas-to-cust-1 AS CHAR INITIAL "Alternate Reverts"  NO-UNDO.
DEFINE VAR    mas-to-cust-2 AS CHAR INITIAL "to Master Value  "  NO-UNDO.
DEFINE VAR    cust-to-mas-1 AS CHAR INITIAL "Master Updates to"  NO-UNDO.
DEFINE VAR    cust-to-mas-2 AS CHAR INITIAL "Alternate Value  "  NO-UNDO.

/* Query definitions                                                    */
DEFINE QUERY BROWSE-1 FOR _DIFFER SCROLLING.

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1 QUERY BROWSE-1 DISPLAY 
      _DIFFER._PROP COLUMN-LABEL "Attribute"
      _DIFFER._M_value COLUMN-LABEL "Master Layout":C
      _DIFFER._SYNC COLUMN-LABEL ""
      _DIFFER._C_Value COLUMN-LABEL "":C
    WITH NO-BOX SIZE 89 BY 9
         &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN SEPARATORS. &ENDIF .
 

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME massync
     BROWSE-1      AT ROW 1.52 COL 2
     cust-to-mas-1 AT ROW 10.5 COL 30 VIEW-AS TEXT NO-LABEL FORMAT "X(18)"
     cust-to-mas-2 AT ROW 11.5 COL 30 VIEW-AS TEXT NO-LABEL FORMAT "X(17)"
     Btn_Master    AT ROW 10.5 COL 48
     Btn_Space     AT ROW 10.5 COL 53.5
     Btn_Custom    AT ROW 10.5 COL 59
     mas-to-cust-1 AT ROW 10.5 COL 61 VIEW-AS TEXT NO-LABEL FORMAT "X(18)"
     mas-to-cust-2 AT ROW 11.5 COL 61 VIEW-AS TEXT NO-LABEL FORMAT "X(17)"
    WITH VIEW-AS DIALOG-BOX SIDE-LABELS THREE-D 
         SIZE 92.16 BY 11
         TITLE "Sync With Master".
{adecomm/okbar.i}

 
FIND _U WHERE RECID(_U) = u-recid.
IF _U._TYPE = "SLIDER":U THEN
  FIND _F WHERE RECID(_F) = _U._x-recid.
  
FIND _L WHERE _L._u-recid = RECID(_U) AND _L._LO-NAME = cur_lo.
FIND m_L WHERE m_L._u-recid = RECID(_U) AND m_L._LO-NAME = "Master Layout".


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX massync
   UNDERLINE                                                            */
ASSIGN BROWSE-1:MAX-DATA-GUESS IN FRAME massync     = 21
       Btn_Custom:PRIVATE-DATA IN FRAME massync     = "Btn_Custom"
       Btn_Master:PRIVATE-DATA IN FRAME massync     = "Btn_Master"
       Btn_Space:WIDTH    = Btn_Master:WIDTH    
       Btn_Space:HEIGHT   = Btn_Master:HEIGHT    
       Btn_Space:COLUMN   = (Btn_Master:COLUMN + Btn_Custom:COLUMN) / 2
       Btn_Space:ROW      = BROWSE-1:ROW + BROWSE-1:HEIGHT + .5
       Btn_Master:ROW     = Btn_Space:ROW
       Btn_Custom:ROW     = Btn_Space:ROW.
       
&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
  ASSIGN Btn_Master:COLUMN = Btn_Master:COLUMN - 1.7
         Btn_Space:COLUMN  = Btn_Space:COLUMN - 1.7
         Btn_Custom:COLUMN = Btn_Custom:COLUMN - 1.7.
&ENDIF

ASSIGN overlap = Btn_Master:X + Btn_Master:WIDTH-PIXELS - Btn_Space:X
       halflap = INTEGER((overlap - 1) / 2).
IF overlap > 0 THEN
  ASSIGN Btn_Master:WIDTH-PIXELS  = Btn_Master:WIDTH-PIXELS - overlap
         Btn_Master:HEIGHT-PIXELS = Btn_Master:HEIGHT-PIXELS - overlap
         Btn_Master:Y             = Btn_Master:Y - halflap
         Btn_Space:WIDTH-PIXELS   = Btn_Master:WIDTH-PIXELS - 2
         Btn_Space:HEIGHT-PIXELS  = Btn_Master:HEIGHT-PIXELS - 2
         Btn_Space:Y              = Btn_Master:Y + 1
         Btn_Custom:WIDTH-PIXELS  = Btn_Master:WIDTH-PIXELS
         Btn_Custom:HEIGHT-PIXELS = Btn_Master:HEIGHT-PIXELS
         Btn_Custom:Y             = Btn_Master:Y
         stupid                   = Btn_Master:LOAD-IMAGE-UP("adeicon/pvback":U,
                                                             halflap,
                                                             halflap,
                                                             Btn_Master:WIDTH-PIXELS,
                                                             Btn_Master:HEIGHT-PIXELS)
         stupid                   = Btn_Custom:LOAD-IMAGE-UP("adeicon/pvforw":U,
                                                             halflap,
                                                             halflap,
                                                             Btn_Master:WIDTH-PIXELS,
                                                             Btn_Master:HEIGHT-PIXELS).


ASSIGN cust-to-mas-1:ROW IN FRAME massync = Btn_custom:ROW IN FRAME massync
       cust-to-mas-1:COLUMN IN FRAME massync = Btn_Master:COLUMN -
                                     FONT-TABLE:GET-TEXT-WIDTH(cust-to-mas-1) - 1
       cust-to-mas-2:ROW IN FRAME massync = cust-to-mas-1:ROW + cust-to-mas-1:HEIGHT
       cust-to-mas-2:COLUMN IN FRAME massync = cust-to-mas-1:COLUMN + 1
       mas-to-cust-1:ROW IN FRAME massync = cust-to-mas-1:ROW
       mas-to-cust-1:COLUMN IN FRAME massync = Btn_Custom:COLUMN + Btn_Custom:WIDTH + 1
       mas-to-cust-2:ROW IN FRAME massync = cust-to-mas-2:ROW IN FRAME massync
       mas-to-cust-2:COLUMN IN FRAME massync = mas-to-cust-1:COLUMN IN FRAME massync
                                               + 1.    

DISPLAY cust-to-mas-1 cust-to-mas-2 mas-to-cust-1 mas-to-cust-2 WITH FRAME massync.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(FRAME massync:HANDLE) THEN
  FRAME massync:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME



/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "temp.DIFFER"
     _OrdList          = ""
     _FldNameList[1]   = _DIFFER._PROP
     _FldNameList[2]   = _DIFFER._M_value
     _FldNameList[3]   = _DIFFER._SYNC
     _FldNameList[4]   = _DIFFER._C_Value
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

ON MOUSE-SELECT-DBLCLICK OF BROWSE-1 IN FRAME massync DO:
  CASE _DIFFER._SYNC:
    WHEN " " THEN _DIFFER._SYNC = ">".
    WHEN ">" THEN _DIFFER._SYNC = "<".
    WHEN "<" THEN _DIFFER._SYNC = " ".
  END CASE.
  DISPLAY _DIFFER._SYNC WITH BROWSE BROWSE-1.
END.

ON CHOOSE OF btn_master IN FRAME {&FRAME-NAME} DO:
  DEFINE VAR t-rec AS RECID                                       NO-UNDO.
  
  t-rec = RECID(_DIFFER).
  FIND _DIFFER WHERE RECID(_DIFFER) = t-rec.
  IF _DIFFER._PROP NE "" THEN DO:
    _DIFFER._SYNC = "<".
    DISPLAY _DIFFER._SYNC WITH BROWSE BROWSE-1.
  END.
  ELSE BELL.
END.

ON CHOOSE OF btn_custom IN FRAME {&FRAME-NAME} DO:
  DEFINE VAR t-rec AS RECID                                       NO-UNDO.
  
  t-rec = RECID(_DIFFER).
  FIND _DIFFER WHERE RECID(_DIFFER) = t-rec.
  IF _DIFFER._PROP NE "" THEN DO:
    _DIFFER._SYNC = ">".
    DISPLAY _DIFFER._SYNC WITH BROWSE BROWSE-1.
  END.
  ELSE BELL.
END.

ON CHOOSE OF btn_Space IN FRAME {&FRAME-NAME} DO:
  DEFINE VAR t-rec AS RECID                                       NO-UNDO.
  
  t-rec = RECID(_DIFFER).
  FIND _DIFFER WHERE RECID(_DIFFER) = t-rec.
  IF _DIFFER._PROP NE "" THEN DO:
    _DIFFER._SYNC = " ".
    DISPLAY _DIFFER._SYNC WITH BROWSE BROWSE-1.
  END.
  ELSE BELL.
END.

ON CHOOSE OF btn_help IN FRAME {&FRAME-NAME} OR HELP OF FRAME {&FRAME-NAME}
  RUN adecomm/_adehelp.p ( "AB", "CONTEXT", {&Sync_with_Master_Dlg_Box}, ? ).

ON CHOOSE OF btn_OK IN FRAME {&FRAME-NAME} DO:
  FOR EACH _DIFFER WHERE _DIFFER._SYNC NE "":
    CASE _DIFFER._PROP:
      WHEN  "3-D" THEN DO:
        IF _DIFFER._SYNC = "<" THEN m_L._3-D = _L._3-D.
                               ELSE  _L._3-D = m_L._3-D.
      END.

      WHEN  "Background Color" THEN DO:
        IF _DIFFER._SYNC = "<" THEN m_L._BGCOLOR = IF _L._WIN-TYPE THEN _L._BGCOLOR
                                                                   ELSE ?.
                               ELSE  _L._BGCOLOR = IF m_L._WIN-TYPE THEN m_L._BGCOLOR
                                                                   ELSE ?.
      END.

      WHEN  "Column" THEN DO:
        IF _DIFFER._SYNC = "<" THEN m_L._COL = _L._COL.
                               ELSE  _L._COL = m_L._COL.
      END.

      WHEN  "Edge Pixels" THEN DO:
        IF _DIFFER._SYNC = "<" THEN m_L._EDGE-PIXELS = _L._EDGE-PIXELS.
                               ELSE  _L._EDGE-PIXELS = m_L._EDGE-PIXELS.
      END.

      WHEN  "Foreground Color" THEN DO:
        IF _DIFFER._SYNC = "<" THEN m_L._FGCOLOR = IF _L._WIN-TYPE THEN _L._FGCOLOR
                                                                   ELSE ?.
                               ELSE  _L._FGCOLOR = IF m_L._WIN-TYPE THEN m_L._FGCOLOR
                                                                   ELSE ?.
      END.

      WHEN  "Filled" THEN DO:
        IF _DIFFER._SYNC = "<" THEN m_L._FILLED = _L._FILLED.
                               ELSE  _L._FILLED = m_L._FILLED.
      END.

      WHEN  "Font" THEN DO:
        IF _DIFFER._SYNC = "<" THEN m_L._FONT = IF _L._WIN-TYPE THEN _L._FONT
                                                                ELSE ?.
                               ELSE  _L._FONT = IF m_L._WIN-TYPE THEN m_L._FONT
                                                                ELSE ?.
      END.

      WHEN  "Graphic Edge" THEN DO:
        IF _DIFFER._SYNC = "<" THEN m_L._GRAPHIC-EDGE = _L._GRAPHIC-EDGE.
                               ELSE  _L._GRAPHIC-EDGE = m_L._GRAPHIC-EDGE.
      END.

      WHEN  "Height" THEN DO:
        IF _DIFFER._SYNC = "<" THEN DO:
          IF m_L._WIN-TYPE OR 
            CAN-DO("WINDOW,DIALOG-BOX,FRAME,RECTANGLE,RADIO-SET,SELECTION-LIST,EDITOR",
                   _U._TYPE) THEN
            m_L._HEIGHT = _L._HEIGHT.
          ELSE IF _U._TYPE = "SLIDER":U AND NOT _F._HORIZONTAL THEN
            m_L._HEIGHT = _L._HEIGHT.
          ELSE
            MESSAGE "The height of a character mode" _U._TYPE "may not be changed."
               VIEW-AS ALERT-BOX INFORMATION.
        END.
        ELSE DO:
          IF _L._WIN-TYPE OR 
            CAN-DO("WINDOW,DIALOG-BOX,FRAME,RECTANGLE,RADIO-SET,SELECTION-LIST,EDITOR",
                   _U._TYPE) THEN
            _L._HEIGHT = m_L._HEIGHT.
          ELSE IF _U._TYPE = "SLIDER":U AND NOT _F._HORIZONTAL THEN
            _L._HEIGHT = m_L._HEIGHT.
          ELSE
            MESSAGE "The height of a character mode" _U._TYPE "may not be changed."
               VIEW-AS ALERT-BOX INFORMATION.
        END.
      END.

      WHEN  "No Box" THEN DO:
        IF _DIFFER._SYNC = "<" THEN m_L._NO-BOX = _L._NO-BOX.
                               ELSE  _L._NO-BOX = m_L._NO-BOX.
      END.

      WHEN  "No Labels" THEN DO:
        IF _DIFFER._SYNC = "<" THEN m_L._NO-LABELS = _L._NO-LABELS.
                               ELSE  _L._NO-LABELS = m_L._NO-LABELS.
      END.

      WHEN  "No Underline" THEN DO:
        IF _DIFFER._SYNC = "<" THEN m_L._NO-UNDERLINE = _L._NO-UNDERLINE.
                               ELSE  _L._NO-UNDERLINE = m_L._NO-UNDERLINE.
      END.

      WHEN  "Remove From Layout" THEN DO:
        IF _DIFFER._SYNC = "<" THEN m_L._REMOVE-FROM-LAYOUT = _L._REMOVE-FROM-LAYOUT.
                               ELSE  _L._REMOVE-FROM-LAYOUT = m_L._REMOVE-FROM-LAYOUT.
        _U._HANDLE:HIDDEN = _L._REMOVE-FROM-LAYOUT.
      END.

      WHEN  "Row" THEN DO:
        IF _DIFFER._SYNC = "<" THEN m_L._ROW = _L._ROW.
                               ELSE  _L._ROW = m_L._ROW.
      END.

      WHEN  "Separators" THEN DO:
        IF _DIFFER._SYNC = "<" THEN m_L._SEPARATORS = _L._SEPARATORS.
                               ELSE  _L._SEPARATORS = m_L._SEPARATORS.
      END.
      
      WHEN  "Separator Foreground Color" THEN DO:
        IF _DIFFER._SYNC = "<" THEN m_L._SEPARATOR-FGCOLOR = IF _L._WIN-TYPE THEN _L._SEPARATOR-FGCOLOR
                                                                             ELSE ?.
                               ELSE  _L._SEPARATOR-FGCOLOR = IF m_L._WIN-TYPE THEN m_L._SEPARATOR-FGCOLOR
                                                                             ELSE ?.
      END.

      WHEN  "Title Background" THEN DO:
        IF _DIFFER._SYNC = "<" THEN m_L._TITLE-BGCOLOR = IF _L._WIN-TYPE THEN
                                                         _L._TITLE-BGCOLOR ELSE ?.
                               ELSE  _L._TITLE-BGCOLOR = IF m_L._WIN-TYPE THEN
                                                         m_L._TITLE-BGCOLOR ELSE ?.
      END.

      WHEN  "Title Foreground" THEN DO:
        IF _DIFFER._SYNC = "<" THEN m_L._TITLE-FGCOLOR = IF _L._WIN-TYPE THEN
                                                         _L._TITLE-FGCOLOR ELSE ?.
                               ELSE  _L._TITLE-FGCOLOR = IF m_L._WIN-TYPE THEN
                                                         m_L._TITLE-FGCOLOR ELSE ?.
      END.

      WHEN  "Virtual Height" THEN DO:
        IF _DIFFER._SYNC = "<" THEN m_L._VIRTUAL-HEIGHT = _L._VIRTUAL-HEIGHT.
                               ELSE  _L._VIRTUAL-HEIGHT = m_L._VIRTUAL-HEIGHT.
      END.

      WHEN  "Virtual Width" THEN DO:
        IF _DIFFER._SYNC = "<" THEN m_L._VIRTUAL-WIDTH = _L._VIRTUAL-WIDTH.
                               ELSE  _L._VIRTUAL-WIDTH = m_L._VIRTUAL-WIDTH.
      END.

      WHEN  "Width" THEN DO:
        IF _DIFFER._SYNC = "<" THEN m_L._WIDTH = _L._WIDTH.
                               ELSE  _L._WIDTH = m_L._WIDTH.
      END.
    END CASE.
  END.  /* For each _DIFFER where _SYNC <> " " */
  IF m_L._ROW = _L._ROW AND m_L._COL = _L._COL THEN _L._CUSTOM-POSITION = FALSE.
  IF m_L._WIDTH = _L._WIDTH AND m_L._HEIGHT = _L._HEIGHT AND
     m_L._VIRTUAL-WIDTH = _L._VIRTUAL-WIDTH AND
     m_L._VIRTUAL-HEIGHT = _L._VIRTUAL-HEIGHT THEN
    _L._CUSTOM-POSITION = FALSE.
  APPLY "GO" TO FRAME {&FRAME-NAME}.
END.  /* On Choose of btn_OK */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK massync 


/* ***************************  Main Block  *************************** */

/* Restore the current-window if it is an icon.                         */
/* Otherwise the dialog box will be hidden                              */
IF CURRENT-WINDOW:WINDOW-STATE = WINDOW-MINIMIZED 
THEN CURRENT-WINDOW:WINDOW-STATE = WINDOW-NORMAL.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
   
  ASSIGN
    _DIFFER._C_Value:LABEL IN BROWSE BROWSE-1 = cur_lo.
    
  IF _L._3-D NE m_L._3-D THEN DO:
    CREATE _DIFFER.
    ASSIGN _DIFFER._PROP    = "3-D"
           _DIFFER._M_Value = FILL(" ", 15) + IF m_L._3-D = ? THEN " ?"
                                              ELSE IF m_L._3-D THEN "Yes" ELSE "No"
           _DIFFER._C_Value = FILL(" ", 15) + IF _L._3-D = ? THEN " ?"
                                              ELSE IF _L._3-D  THEN "Yes" ELSE "No".
  END.

  IF _L._BGCOLOR NE m_L._BGCOLOR THEN DO:
    IF NOT _L._WIN-TYPE THEN _L._BGCOLOR = m_L._BGCOLOR.
    ELSE DO:
      CREATE _DIFFER.
      ASSIGN _DIFFER._PROP    = "Background Color"
             _DIFFER._M_Value = FILL(" ", 16) + IF m_L._BGCOLOR = ? OR NOT m_L._WIN-TYPE
                                                THEN "?"
                                                ELSE STRING(m_L._BGCOLOR)
             _DIFFER._C_Value = FILL(" ", 16) + IF _L._BGCOLOR = ? OR NOT _L._WIN-TYPE
                                                THEN "?"
                                                ELSE STRING(_L._BGCOLOR).
    END.
  END.

  IF _L._COL NE m_L._COL THEN DO:
    IF _L._COL < m_L._COL + tol AND _L._COL > m_L._COL - tol THEN
      _L._COL = m_L._COL.
    ELSE DO:
      CREATE _DIFFER.
      ASSIGN _DIFFER._PROP    = "Column"
             _DIFFER._M_Value = FILL(" ", 14) + IF m_L._COL = ? THEN "  ?"
                                                ELSE STRING(m_L._COL,">>>.99")
             _DIFFER._C_Value = FILL(" ", 14) + IF _L._COL = ? THEN "  ?"
                                                ELSE STRING(_L._COL,">>>.99").
    END.
  END.

  IF _L._CONVERT-3D-COLORS NE m_L._CONVERT-3D-COLORS THEN DO:
    CREATE _DIFFER.
    ASSIGN _DIFFER._PROP    = "CONVERT-3D-COLORS"
           _DIFFER._M_Value = FILL(" ", 15) + IF m_L._CONVERT-3D-COLORS = ? THEN " ?"
                                              ELSE IF m_L._CONVERT-3D-COLORS THEN "Yes" ELSE "No"
           _DIFFER._C_Value = FILL(" ", 15) + IF _L._CONVERT-3D-COLORS = ? THEN " ?"
                                              ELSE IF _L._CONVERT-3D-COLORS  THEN "Yes" ELSE "No".
  END.

  IF _L._EDGE-PIXELS NE m_L._EDGE-PIXELS THEN DO:
    CREATE _DIFFER.
    ASSIGN _DIFFER._PROP    = "Edge Pixels"
           _DIFFER._M_Value = FILL(" ", 16) + IF m_L._EDGE-PIXELS = ? THEN "?"
                                              ELSE STRING(m_L._EDGE-PIXELS,">>>9")
           _DIFFER._C_Value = FILL(" ", 16) + IF _L._EDGE-PIXELS = ? THEN "?"
                                              ELSE STRING(_L._EDGE-PIXELS,">>>9").
  END.

  IF _L._FGCOLOR NE m_L._FGCOLOR THEN DO:
    IF NOT _L._WIN-TYPE THEN _L._FGCOLOR = m_L._FGCOLOR.
    ELSE DO:
      CREATE _DIFFER.
      ASSIGN _DIFFER._PROP    = "Foreground Color"
             _DIFFER._M_Value = FILL(" ", 16) + IF m_L._FGCOLOR = ? OR NOT m_L._WIN-TYPE
                                                THEN "?"
                                                ELSE STRING(m_L._FGCOLOR)
             _DIFFER._C_Value = FILL(" ", 16) + IF _L._FGCOLOR = ?  OR NOT _L._WIN-TYPE
                                                THEN "?"
                                                ELSE STRING(_L._FGCOLOR).
    END.
  END.

  IF _L._FILLED NE m_L._FILLED THEN DO:
    CREATE _DIFFER.
    ASSIGN _DIFFER._PROP    = "Filled"
           _DIFFER._M_Value = FILL(" ", 15) + IF m_L._FILLED = ? THEN " ?"
                                              ELSE IF m_L._FILLED THEN "Yes" ELSE "No"
           _DIFFER._C_Value = FILL(" ", 15) + IF _L._FILLED = ? THEN " ?"
                                              ELSE IF _L._FILLED  THEN "Yes" ELSE "No".
  END.

  IF _L._FONT NE m_L._FONT THEN DO:
    IF NOT _L._WIN-TYPE THEN _L._FONT = m_L._FONT.
    ELSE DO:
      CREATE _DIFFER.
      ASSIGN _DIFFER._PROP    = "Font"
             _DIFFER._M_Value = FILL(" ", 16) + IF m_L._FONT = ?  OR NOT m_L._WIN-TYPE
                                                THEN "?"
                                                ELSE STRING(m_L._Font)
             _DIFFER._C_Value = FILL(" ", 16) + IF _L._FONT = ?  OR NOT _L._WIN-TYPE
                                                THEN "?"
                                                ELSE STRING(_L._Font).
    END.
  END.

  IF _L._GRAPHIC-EDGE NE m_L._GRAPHIC-EDGE THEN DO:
    CREATE _DIFFER.
    ASSIGN _DIFFER._PROP    = "Graphic Edge"
           _DIFFER._M_Value = FILL(" ", 15) + IF m_L._GRAPHIC-EDGE = ? THEN " ?"
                                              ELSE IF m_L._GRAPHIC-EDGE THEN "Yes"
                                                                        ELSE "No"
           _DIFFER._C_Value = FILL(" ", 15) + IF _L._GRAPHIC-EDGE = ? THEN " ?"
                                              ELSE IF _L._GRAPHIC-EDGE  THEN "Yes"
                                                                        ELSE "No".
  END.

  IF _L._HEIGHT NE m_L._HEIGHT THEN DO:
    IF (_L._HEIGHT < m_L._HEIGHT + tol AND _L._HEIGHT > m_L._HEIGHT - tol) OR
        _U._TYPE = "BROWSE" THEN _L._HEIGHT = m_L._HEIGHT.
    ELSE DO:
      CREATE _DIFFER.
      ASSIGN _DIFFER._PROP    = "Height"
             _DIFFER._M_Value = FILL(" ", 14) + IF m_L._HEIGHT = ? THEN "  ?"
                                                ELSE STRING(m_L._HEIGHT,">>>.99")
             _DIFFER._C_Value = FILL(" ", 14) + IF _L._HEIGHT = ? THEN "  ?"
                                                ELSE STRING(_L._HEIGHT,">>>.99").
    END.
  END.

  IF _L._NO-BOX NE m_L._NO-BOX THEN DO:
    CREATE _DIFFER.
    ASSIGN _DIFFER._PROP    = "No Box"
           _DIFFER._M_Value = FILL(" ", 15) + IF m_L._NO-BOX = ? THEN " ?"
                                              ELSE IF m_L._NO-BOX THEN "Yes" ELSE "No"
           _DIFFER._C_Value = FILL(" ", 15) + IF _L._NO-BOX = ? THEN " ?"
                                              ELSE IF _L._NO-BOX  THEN "Yes" ELSE "No".
  END.

  IF _L._NO-FOCUS NE m_L._NO-FOCUS THEN DO:
    CREATE _DIFFER.
    ASSIGN _DIFFER._PROP    = "No Focus"
           _DIFFER._M_Value = FILL(" ", 15) + IF m_L._NO-FOCUS = ? THEN " ?"
                                              ELSE IF m_L._NO-FOCUS THEN "Yes" ELSE "No"
           _DIFFER._C_Value = FILL(" ", 15) + IF _L._NO-FOCUS = ? THEN " ?"
                                              ELSE IF _L._NO-FOCUS  THEN "Yes" ELSE "No".
  END.

  IF _L._NO-LABELS NE m_L._NO-LABELS THEN DO:
    IF CAN-DO("SLIDER,EDITOR,RADIO-SET",_U._TYPE) THEN
      ASSIGN m_L._NO-LABELS = yes
             _L._NO-LABELS  = yes.
    ELSE DO:
      CREATE _DIFFER.
      ASSIGN _DIFFER._PROP    = "No Labels"
             _DIFFER._M_Value = FILL(" ", 15) + IF m_L._NO-LABELS = ? THEN " ?"
                                                ELSE IF m_L._NO-LABELS 
                                                  THEN "Yes" ELSE "No"
             _DIFFER._C_Value = FILL(" ", 15) + IF _L._NO-LABELS = ? THEN " ?"
                                                ELSE IF _L._NO-LABELS 
                                                  THEN "Yes" ELSE "No".
    END.
  END.

  IF _L._NO-UNDERLINE NE m_L._NO-UNDERLINE THEN DO:
    IF _U._TYPE = "BROWSE" THEN ASSIGN _L._NO-UNDERLINE = m_L._NO-UNDERLINE.
    ELSE DO:
      CREATE _DIFFER.
      ASSIGN _DIFFER._PROP    = "No Underline"
             _DIFFER._M_Value = FILL(" ", 15) + IF m_L._NO-UNDERLINE = ? THEN " ?"
                                               ELSE IF m_L._NO-UNDERLINE THEN "Yes"
                                                                         ELSE "No"
             _DIFFER._C_Value = FILL(" ", 15) + IF _L._NO-UNDERLINE = ?  THEN " ?"
                                               ELSE IF _L._NO-UNDERLINE  THEN "Yes"
                                                                         ELSE "No".
    END.
  END.

  IF _L._REMOVE-FROM-LAYOUT NE m_L._REMOVE-FROM-LAYOUT THEN DO:
    CREATE _DIFFER.
    ASSIGN _DIFFER._PROP    = "Remove From Layout"
           _DIFFER._M_Value = FILL(" ", 15) + IF m_L._REMOVE-FROM-LAYOUT = ?  THEN " ?"
                                              ELSE IF m_L._REMOVE-FROM-LAYOUT THEN "Yes"
                                                                              ELSE "No"
           _DIFFER._C_Value = FILL(" ", 15) + IF _L._REMOVE-FROM-LAYOUT = ?   THEN " ?"
                                              ELSE IF _L._REMOVE-FROM-LAYOUT  THEN "Yes"
                                                                              ELSE "No".
  END.

  IF _L._ROW NE m_L._ROW THEN DO:
    IF _L._ROW < m_L._ROW + tol AND _L._ROW > m_L._ROW - tol THEN
      _L._ROW = m_L._ROW.
    ELSE DO:
      CREATE _DIFFER.
      ASSIGN _DIFFER._PROP    = "Row"
             _DIFFER._M_Value = FILL(" ", 14) + IF m_L._ROW = ? THEN "  ?"
                                                ELSE STRING(m_L._ROW,">>>.99")
             _DIFFER._C_Value = FILL(" ", 14) + IF _L._ROW = ? THEN "  ?"
                                                ELSE STRING(_L._ROW,">>>.99").
    END.
  END.

  IF _L._SEPARATORS NE m_L._SEPARATORS THEN DO:
    CREATE _DIFFER.
    ASSIGN _DIFFER._PROP    = "Separators"
           _DIFFER._M_Value = FILL(" ", 15) + IF m_L._SEPARATORS = ? THEN " ?"
                                              ELSE IF m_L._SEPARATORS THEN "Yes" ELSE "No"
           _DIFFER._C_Value = FILL(" ", 15) + IF _L._SEPARATORS = ? THEN " ?"
                                              ELSE IF _L._SEPARATORS  THEN "Yes" ELSE "No".
  END.

  IF _L._SEPARATOR-FGCOLOR NE m_L._SEPARATOR-FGCOLOR THEN DO:
    IF NOT _L._WIN-TYPE THEN _L._SEPARATOR-FGCOLOR = m_L._SEPARATOR-FGCOLOR.
    ELSE DO:
      CREATE _DIFFER.
      ASSIGN _DIFFER._PROP    = "Separator Foreground Color"
             _DIFFER._M_Value = FILL(" ", 16) + IF m_L._SEPARATOR-FGCOLOR = ? OR NOT m_L._WIN-TYPE
                                                THEN "?"
                                                ELSE STRING(m_L._SEPARATOR-FGCOLOR)
             _DIFFER._C_Value = FILL(" ", 16) + IF _L._SEPARATOR-FGCOLOR = ?  OR NOT _L._WIN-TYPE
                                                THEN "?"
                                                ELSE STRING(_L._SEPARATOR-FGCOLOR).
    END.
  END.

  IF _L._TITLE-BGCOLOR NE m_L._TITLE-BGCOLOR THEN DO:
    IF NOT _L._WIN-TYPE THEN _L._TITLE-BGCOLOR = m_L._TITLE-BGCOLOR.
    ELSE DO:
      CREATE _DIFFER.
      ASSIGN _DIFFER._PROP    = "Title Background"
             _DIFFER._M_Value = FILL(" ", 16) + IF m_L._TITLE-BGCOLOR = ?  OR
                                                NOT m_L._WIN-TYPE THEN " ?"
                                                ELSE STRING(m_L._TITLE-BGCOLOR)
             _DIFFER._C_Value = FILL(" ", 16) + IF _L._TITLE-BGCOLOR = ?  OR
                                                NOT _L._WIN-TYPE THEN " ?"
                                                ELSE STRING(_L._TITLE-BGCOLOR).
    END.
  END.

  IF _L._TITLE-FGCOLOR NE m_L._TITLE-FGCOLOR THEN DO:
    IF NOT _L._WIN-TYPE THEN _L._TITLE-FGCOLOR = m_L._TITLE-FGCOLOR.
    ELSE DO:
      CREATE _DIFFER.
      ASSIGN _DIFFER._PROP    = "Title Foreground"
             _DIFFER._M_Value = FILL(" ", 16) + IF m_L._TITLE-FGCOLOR = ?  OR
                                                NOT m_L._WIN-TYPE THEN " ?"
                                                ELSE STRING(m_L._TITLE-FGCOLOR)
             _DIFFER._C_Value = FILL(" ", 16) + IF _L._TITLE-FGCOLOR = ?  OR
                                                NOT _L._WIN-TYPE THEN " ?"
                                                ELSE STRING(_L._TITLE-FGCOLOR).
    END.
  END.

  IF _L._VIRTUAL-HEIGHT NE m_L._VIRTUAL-HEIGHT THEN DO:
    IF _L._VIRTUAL-HEIGHT < m_L._VIRTUAL-HEIGHT + tol AND
       _L._VIRTUAL-HEIGHT > m_L._VIRTUAL-HEIGHT - tol THEN
                           _L._VIRTUAL-HEIGHT = m_L._VIRTUAL-HEIGHT.
    ELSE DO:
      CREATE _DIFFER.
      ASSIGN _DIFFER._PROP    = "Virtual Height"
             _DIFFER._M_Value = FILL(" ", 14) + IF m_L._VIRTUAL-HEIGHT = ? THEN " ?"
                                                ELSE STRING(m_L._VIRTUAL-HEIGHT,">>>.99")
             _DIFFER._C_Value = FILL(" ", 14) + IF _L._VIRTUAL-HEIGHT = ? THEN " ?"
                                                ELSE STRING(_L._VIRTUAL-HEIGHT,">>>.99").
    END.
  END.

  IF _L._VIRTUAL-WIDTH NE m_L._VIRTUAL-WIDTH THEN DO:
    IF _L._VIRTUAL-WIDTH < m_L._VIRTUAL-WIDTH + tol AND
       _L._VIRTUAL-WIDTH > m_L._VIRTUAL-WIDTH - tol THEN
                          _L._VIRTUAL-WIDTH = m_L._VIRTUAL-WIDTH.
    ELSE DO:
      CREATE _DIFFER.
      ASSIGN _DIFFER._PROP    = "Virtual Width"
             _DIFFER._M_Value = FILL(" ", 14) + IF m_L._VIRTUAL-WIDTH = ? THEN " ?"
                                                ELSE STRING(m_L._VIRTUAL-WIDTH,">>>.99")
             _DIFFER._C_Value = FILL(" ", 14) + IF _L._VIRTUAL-WIDTH = ? THEN " ?"
                                                ELSE STRING(_L._VIRTUAL-WIDTH,">>>.99").
    END.
  END.

  IF _L._WIDTH NE m_L._WIDTH THEN DO:
    IF (_L._WIDTH < m_L._WIDTH + tol AND _L._WIDTH > m_L._WIDTH - tol) OR
      _U._TYPE = "BROWSE" THEN _L._WIDTH = m_L._WIDTH.
    ELSE DO:
      CREATE _DIFFER.
      ASSIGN _DIFFER._PROP    = "Width"
             _DIFFER._M_Value = FILL(" ", 14) + IF m_L._WIDTH = ? THEN " ?"
                                                ELSE STRING(m_L._WIDTH,">>>.99")
             _DIFFER._C_Value = FILL(" ", 14) + IF _L._WIDTH = ? THEN " ?"
                                                ELSE STRING(_L._WIDTH,">>>.99").
    END.
  END.


  RUN enable_UI.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI massync _DEFAULT-DISABLE
PROCEDURE disable_UI :
/* --------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
   -------------------------------------------------------------------- */
  /* Hide all frames. */
  HIDE FRAME massync.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI massync _DEFAULT-ENABLE
PROCEDURE enable_UI :
/* --------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
   -------------------------------------------------------------------- */
  ENABLE BROWSE-1 Btn_Master Btn_Space Btn_Custom 
      WITH FRAME massync.
  {&OPEN-BROWSERS-IN-QUERY-massync}
  
  IF NUM-RESULTS("BROWSE-1") > 1 THEN  stupid = BROWSE-1:select-row(2).
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE BROWSE-NAME 
&UNDEFINE FRAME-NAME 
&UNDEFINE WINDOW-NAME
