/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: adeuib/_attredt.w

  Description: Dialog box which presents translation attributes for editing
               Handles label, title, format, tooltip

  Input Parameters:
    h_self object handle 
    recid_column    if this is a browse column, recid of _BC else ?

  Output Parameters:
      <none>

  Author: Ross Hunter

  Created: 01/27/94 -  2:11 pm

  Modified: 10/08/98 GFS Added tooltip support
            06/99    SLK Added support for browser columns
                         Added support for Private Data
                         - for only those object where they are accessible 
                           via the AppBuilder
            06/99    SLK Removed support for Initial Value until analyzer
                         returns information
  
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

&GLOBAL-DEFINE WIN95-BTN  TRUE

DEFINE INPUT PARAMETER h_self       AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAMETER recid_column AS RECID         NO-UNDO.

{adeuib/uniwidg.i}              /* Universal widget definition          */
{adeuib/brwscols.i}             /* Browse column temp table definitions */
{adeuib/property.i}             /* Temp-Table containing attribute info */
{adeuib/uibhlp.i}               /* Help pre-processor directives        */
{adeuib/sharvars.i}             /* The shared variables                 */
{adecomm/adestds.i}

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h_label       AS WIDGET-HANDLE                NO-UNDO.
DEFINE VARIABLE h_label-lbl   AS WIDGET-HANDLE                NO-UNDO.
DEFINE VARIABLE h_label-atr   AS WIDGET-HANDLE                NO-UNDO.
DEFINE VARIABLE h_format      AS WIDGET-HANDLE                NO-UNDO.
DEFINE VARIABLE h_format-lbl  AS WIDGET-HANDLE                NO-UNDO.
DEFINE VARIABLE h_format-atr  AS WIDGET-HANDLE                NO-UNDO.
DEFINE VARIABLE h_help        AS WIDGET-HANDLE                NO-UNDO.
DEFINE VARIABLE h_help-lbl    AS WIDGET-HANDLE                NO-UNDO.
DEFINE VARIABLE h_help-atr    AS WIDGET-HANDLE                NO-UNDO.
DEFINE VARIABLE h_tt          AS WIDGET-HANDLE                NO-UNDO.
DEFINE VARIABLE h_tt-lbl      AS WIDGET-HANDLE                NO-UNDO.
DEFINE VARIABLE h_tt-atr      AS WIDGET-HANDLE                NO-UNDO.
DEFINE VARIABLE h_col1        AS WIDGET-HANDLE                NO-UNDO.
DEFINE VARIABLE h_col2        AS WIDGET-HANDLE                NO-UNDO.
DEFINE VARIABLE h_col3        AS WIDGET-HANDLE                NO-UNDO.
DEFINE VARIABLE adjust        AS DECIMAL                      NO-UNDO.
DEFINE VARIABLE cur-row       AS DECIMAL       INITIAL 2.7    NO-UNDO.
DEFINE RECTANGLE srect        EDGE-CHARS .2 FGC 1 BGC 1 SIZE 46 BY .1.
DEFINE RECTANGLE arect        EDGE-CHARS .2 FGC 1 BGC 1 SIZE 9  BY .1.

DEFINE VARIABLE cOldAttr      AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE lBrowseColumn AS LOGICAL INITIAL NO           NO-UNDO.
define variable wintitle as character no-undo init "String Attributes":C17.

/* Definitions of the field level widgets                               */
&SCOPED-DEFINE FRAME-NAME attr-dial

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME attr-dial
     "String:":L30 VIEW-AS TEXT
          SIZE 9 BY 1 AT ROW 1.52 COL 12
     "Attribute:":L10 VIEW-AS TEXT
          SIZE 11 BY 1 AT ROW 1.52 COL 60 
     srect AT ROW 7.52 COL 12
     arect AT ROW 2.52 COL 60
     ":" AT ROW 2.7 COLUMN 59
    WITH 
    &if DEFINED(IDE-IS-RUNNING) = 0  &then
    VIEW-AS DIALOG-BOX 
    TITLE wintitle
    &else
    no-box three-d
    &endif
    SIDE-LABELS 
    SIZE 75.49 BY 10.76.
         

ASSIGN FRAME attr-dial:HIDDEN       = TRUE
       srect:ROW IN FRAME attr-dial = 2.52.
       
CREATE WIDGET-POOL.



TRANS-BLK:
DO TRANSACTION:
  /* Create necessary widgets and initialize with current data                */
  FIND _U WHERE _U._HANDLE = h_self NO-ERROR.

  IF recid_column <> ? THEN
  DO:
     FIND _BC WHERE RECID(_BC) = recid_column NO-ERROR.
     IF AVAILABLE _BC THEN 
        ASSIGN lBrowseColumn = YES.
  END.
  ELSE
  DO:
     FIND _F WHERE RECID(_F) = _U._x-recid NO-ERROR.
     IF NOT AVAILABLE _F THEN FIND _C WHERE RECID(_C) = _U._x-recid.
  END. /* _U */

  /* *******************************************************************
   *  LABEL OR TITLE
   * *******************************************************************/
  IF CAN-DO("WINDOW,FRAME,DIALOG-BOX,BROWSE,BUTTON,FILL-IN,COMBO-BOX,TOGGLE-BOX,TEXT":U,
     _U._TYPE)
  THEN DO:
    CREATE TEXT h_label-lbl ASSIGN FRAME = FRAME attr-dial:HANDLE. 
    CREATE FILL-IN h_label
           ASSIGN FRAME             = FRAME attr-dial:HANDLE
                  ROW               = cur-row 
                  COLUMN            = 12
                  WIDTH             = 46
                  FORMAT            = "X(80)"
                  SIDE-LABEL-HANDLE = h_label-lbl
                  SCREEN-VALUE      = IF _U._TYPE EQ "BROWSE"
                                         AND lBrowseColumn THEN _BC._LABEL
                                      ELSE IF _U._TYPE NE "TEXT" THEN _U._LABEL
                                      ELSE _F._INITIAL-DATA
                  LABEL             = IF CAN-DO("WINDOW,FRAME,BROWSE,DIALOG-BOX":U,
                                        _U._TYPE) AND NOT lBrowseColumn 
                                      THEN "Title:":U
                                      ELSE IF _U._TYPE = "TEXT" THEN "Text:":U
                                      ELSE  "Label:":U.
             
    ASSIGN h_label-lbl:HEIGHT  = 1
           h_label-lbl:WIDTH   = FONT-TABLE:GET-TEXT-WIDTH-CHARS(
                                      h_label:LABEL + " ")
           h_label-lbl:ROW     = h_label:ROW
           h_label-lbl:COLUMN  = h_label:COLUMN - h_label-lbl:WIDTH
           h_label:SENSITIVE   = FALSE.
             
    CREATE FILL-IN h_label-atr
           ASSIGN FRAME             = FRAME attr-dial:HANDLE
                  ROW               = cur-row 
                  COLUMN            = 60
                  WIDTH             = 9
                  FORMAT            = "X(9)"
                  BGCOLOR           = std_fillin_bgcolor
                  FGCOLOR           = std_fillin_fgcolor
                  SCREEN-VALUE      = IF lBrowseColumn THEN _BC._LABEL-ATTR
                                      ELSE                   _U._LABEL-ATTR
            TRIGGERS:
              ON LEAVE DO:
                ASSIGN 
                   cOldAttr = IF lBrowseColumn THEN _BC._LABEL-ATTR
                              ELSE                   _U._LABEL-ATTR.

                IF cOldAttr NE SELF:SCREEN-VALUE THEN DO:
                     SELF:SCREEN-VALUE = LEFT-TRIM(SELF:SCREEN-VALUE).
                     RUN adeuib/_strattr.p (SELF:SCREEN-VALUE).
                     IF RETURN-VALUE NE "":U THEN RETURN NO-APPLY.
                     ELSE 
                     DO:
                       ASSIGN SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
                       IF lBrowseColumn THEN 
                          _BC._LABEL-ATTR    = SELF:SCREEN-VALUE.
                       ELSE
                       DO:
                          _U._LABEL-ATTR    = SELF:SCREEN-VALUE.
                          IF _U._TABLE NE ? THEN _U._LABEL-SOURCE = "E":U.
                       END.
                     END.
                END.
              END.
            END.

    ASSIGN h_label-atr:SENSITIVE = (_U._LABEL-SOURCE = "E":U) OR lBrowseColumn
           cur-row  = cur-row + 1.1.

  END.  /* Has a LABEL or TITLE */

  /* *******************************************************************
   *  FORMAT 
   * *******************************************************************/
  IF     CAN-DO("FILL-IN,COMBO-BOX":U,_U._TYPE)
     OR (CAN-DO("BROWSE":U,_U._TYPE) AND lBrowseColumn)
  THEN DO:
    CREATE TEXT h_format-lbl ASSIGN FRAME = FRAME attr-dial:HANDLE. 
    CREATE FILL-IN h_format
           ASSIGN FRAME             = FRAME attr-dial:HANDLE
                  ROW               = cur-row 
                  COLUMN            = 12
                  WIDTH             = 46
                  FORMAT            = "X(80)"
                  SIDE-LABEL-HANDLE = h_format-lbl
                  SCREEN-VALUE      = IF lBrowseColumn THEN _BC._FORMAT
                                      ELSE                   _F._FORMAT
                  LABEL             = "Format:".
             
    ASSIGN h_format-lbl:HEIGHT  = 1
           h_format-lbl:WIDTH   = FONT-TABLE:GET-TEXT-WIDTH-CHARS(
                                      h_format:LABEL + " ")
           h_format-lbl:ROW     = h_format:ROW
           h_format-lbl:COLUMN  = h_format:COLUMN - h_format-lbl:WIDTH
           h_format:SENSITIVE   = FALSE.

    CREATE TEXT h_col1
           ASSIGN FRAME             = FRAME attr-dial:HANDLE
                  ROW               = cur-row
                  COLUMN            = 59
                  WIDTH             = 1
                  HEIGHT            = 1
                  SCREEN-VALUE      = ":".
             
    CREATE FILL-IN h_format-atr
           ASSIGN FRAME             = FRAME attr-dial:HANDLE
                  ROW               = cur-row 
                  COLUMN            = 60
                  WIDTH             = 9
                  FORMAT            = "X(9)"
                  BGCOLOR           = std_fillin_bgcolor
                  FGCOLOR           = std_fillin_fgcolor
                  SCREEN-VALUE      = IF lBrowseColumn THEN 
                                         _BC._FORMAT-ATTR
                                      ELSE
                                         _F._FORMAT-ATTR
            TRIGGERS:
              ON LEAVE DO:
                ASSIGN 
                   cOldAttr = IF lBrowseColumn THEN _BC._FORMAT-ATTR
                              ELSE                   _F._FORMAT-ATTR.
                IF cOldAttr NE SELF:SCREEN-VALUE THEN DO:
                  SELF:SCREEN-VALUE = LEFT-TRIM(SELF:SCREEN-VALUE).
                  RUN adeuib/_strattr.p (SELF:SCREEN-VALUE).
                  IF RETURN-VALUE NE "":U THEN RETURN NO-APPLY.
                  ELSE DO:
                    ASSIGN SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
                    IF lBrowseColumn THEN 
                       _BC._FORMAT-ATTR   = SELF:SCREEN-VALUE.
                    ELSE
                    DO:
                       _F._FORMAT-ATTR   = SELF:SCREEN-VALUE.
                       IF _U._TABLE NE ? THEN _F._FORMAT-SOURCE = "E":U.
                    END.
                  END.
                END.
              END.
            END.

    IF lBrowseColumn THEN 
       ASSIGN h_format-atr:SENSITIVE = TRUE.
    ELSE 
       ASSIGN h_format-atr:SENSITIVE = _F._FORMAT-SOURCE = "E":U.
    ASSIGN cur-row  = cur-row + 1.1.

  END.  /* Has a FORMAT */


  /* *******************************************************************
   *  HELP 
   * *******************************************************************/
  IF CAN-DO(
   "BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,RADIO-SET,SELECTION-LIST,SLIDER,TOGGLE-BOX",
   _U._TYPE)
  THEN DO:
    CREATE TEXT h_help-lbl ASSIGN FRAME = FRAME attr-dial:HANDLE. 
    CREATE FILL-IN h_help
           ASSIGN FRAME             = FRAME attr-dial:HANDLE
                  ROW               = cur-row 
                  COLUMN            = 12
                  WIDTH             = 46
                  FORMAT            = "X(80)"
                  SIDE-LABEL-HANDLE = h_help-lbl
                  SCREEN-VALUE      = IF lBrowseColumn THEN _BC._HELP
                                      ELSE                   _U._HELP
                  LABEL             = "Help:".
             
    ASSIGN h_help-lbl:HEIGHT  = 1
           h_help-lbl:WIDTH   = FONT-TABLE:GET-TEXT-WIDTH-CHARS(
                                      h_help:LABEL + " ")
           h_help-lbl:ROW     = h_help:ROW
           h_help-lbl:COLUMN  = h_help:COLUMN - h_help-lbl:WIDTH
           h_help:SENSITIVE   = FALSE.

    CREATE TEXT h_col2
           ASSIGN FRAME             = FRAME attr-dial:HANDLE
                  ROW               = cur-row
                  COLUMN            = 59
                  WIDTH             = 1
                  HEIGHT            = 1
                  SCREEN-VALUE      = ":".
             
    CREATE FILL-IN h_help-atr
           ASSIGN FRAME             = FRAME attr-dial:HANDLE
                  ROW               = cur-row 
                  COLUMN            = 60
                  WIDTH             = 9
                  BGCOLOR           = std_fillin_bgcolor
                  FGCOLOR           = std_fillin_fgcolor
                  FORMAT            = "X(9)"
                  SCREEN-VALUE      = IF lBrowseColumn THEN _BC._HELP-ATTR
                                      ELSE                   _U._HELP-ATTR
            TRIGGERS:
              ON LEAVE DO:
                ASSIGN cOldAttr = IF lBrowseColumn THEN _BC._HELP-ATTR
                                  ELSE                   _U._HELP-ATTR.

                IF cOldAttr NE SELF:SCREEN-VALUE THEN DO:
                  SELF:SCREEN-VALUE = LEFT-TRIM(SELF:SCREEN-VALUE).
                  RUN adeuib/_strattr.p (SELF:SCREEN-VALUE).
                  IF RETURN-VALUE NE "":U THEN RETURN NO-APPLY.
                  ELSE DO:
                    ASSIGN SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
                    IF lBrowseColumn THEN
                       _BC._HELP-ATTR        = SELF:SCREEN-VALUE.
                    ELSE
                    DO:
                       _U._HELP-ATTR     = SELF:SCREEN-VALUE.
                       IF _U._TABLE NE ? THEN _U._HELP-SOURCE = "E":U.
                    END.
                  END.
                END.
              END.
            END.

    ASSIGN h_help-atr:SENSITIVE = (_U._HELP-SOURCE = "E":U) OR lBrowseColumn
           cur-row  = cur-row + 1.1.

  END.  /* Has HELP */

  /* *******************************************************************
   *  TOOLTIP 
   * *******************************************************************/
  IF CAN-DO(
   "BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,IMAGE,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,TEXT,TOGGLE-BOX",_U._TYPE) AND NOT lBrowseColumn
  THEN DO:
    CREATE TEXT h_tt-lbl ASSIGN FRAME = FRAME attr-dial:HANDLE. 
    CREATE FILL-IN h_tt
           ASSIGN FRAME             = FRAME attr-dial:HANDLE
                  ROW               = cur-row 
                  COLUMN            = 12
                  WIDTH             = 46
                  FORMAT            = "X(80)"
                  SIDE-LABEL-HANDLE = h_tt-lbl
                  SCREEN-VALUE      = (IF _U._TOOLTIP NE ? AND _U._TOOLTIP NE "" THEN _U._TOOLTIP ELSE "")
                  LABEL             = "Tooltip:".
             
    ASSIGN h_tt-lbl:HEIGHT  = 1
           h_tt-lbl:WIDTH   = FONT-TABLE:GET-TEXT-WIDTH-CHARS(
                                      h_tt:LABEL + " ")
           h_tt-lbl:ROW     = h_tt:ROW
           h_tt-lbl:COLUMN  = h_tt:COLUMN - h_tt-lbl:WIDTH
           h_tt:SENSITIVE   = FALSE.

    CREATE TEXT h_col3
           ASSIGN FRAME             = FRAME attr-dial:HANDLE
                  ROW               = cur-row
                  COLUMN            = 59
                  WIDTH             = 1
                  HEIGHT            = 1
                  SCREEN-VALUE      = ":".
             
    CREATE FILL-IN h_tt-atr
           ASSIGN FRAME             = FRAME attr-dial:HANDLE
                  ROW               = cur-row 
                  COLUMN            = 60
                  WIDTH             = 9
                  BGCOLOR           = std_fillin_bgcolor
                  FGCOLOR           = std_fillin_fgcolor
                  FORMAT            = "X(9)"
                  SCREEN-VALUE      = (IF _U._TOOLTIP-ATTR NE ? AND _U._TOOLTIP-ATTR NE "" THEN _U._TOOLTIP-ATTR ELSE "")
            TRIGGERS:
              ON LEAVE DO:
                IF _U._TOOLTIP-ATTR NE SELF:SCREEN-VALUE THEN DO:
                  SELF:SCREEN-VALUE = LEFT-TRIM(SELF:SCREEN-VALUE).
                  RUN adeuib/_strattr.p (SELF:SCREEN-VALUE).
                  IF RETURN-VALUE NE "":U THEN RETURN NO-APPLY.
                  ELSE DO:
                    ASSIGN SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE)
                           _U._TOOLTIP-ATTR  = SELF:SCREEN-VALUE.
                  END.
                END.
              END.
            END.

    ASSIGN h_tt-atr:SENSITIVE = TRUE
           cur-row  = cur-row + 1.1.

  END.  /* Has a TOOLTIP */

/* REMOVED - until CORE fixes analyzer code to return INITIAL strings attribute
 
  /* *******************************************************************
   *  INITIAL DATA 
   * *******************************************************************/
  IF CAN-DO("EDITOR,FILL-IN,RADIO-SET,SELECTION-LIST",_U._TYPE) 
  THEN DO:
    CREATE TEXT h_tt-lbl ASSIGN FRAME = FRAME attr-dial:HANDLE. 
    CREATE FILL-IN h_tt
           ASSIGN FRAME             = FRAME attr-dial:HANDLE
                  ROW               = cur-row 
                  COLUMN            = 12
                  WIDTH             = 46
                  FORMAT            = "X(80)"
                  SIDE-LABEL-HANDLE = h_tt-lbl
                  SCREEN-VALUE      = (IF _F._INITIAL-DATA NE ? AND _F._INITIAL-DATA NE "" THEN _F._INITIAL-DATA ELSE "")
                  LABEL             = "Initial Value:".
             
    ASSIGN h_tt-lbl:HEIGHT  = 1
           h_tt-lbl:WIDTH   = FONT-TABLE:GET-TEXT-WIDTH-CHARS(
                                      h_tt:LABEL + " ")
           h_tt-lbl:ROW     = h_tt:ROW
           h_tt-lbl:COLUMN  = h_tt:COLUMN - h_tt-lbl:WIDTH
           h_tt:SENSITIVE   = FALSE.

    CREATE TEXT h_col3
           ASSIGN FRAME             = FRAME attr-dial:HANDLE
                  ROW               = cur-row
                  COLUMN            = 59
                  WIDTH             = 1
                  HEIGHT            = 1
                  SCREEN-VALUE      = ":".
             
    CREATE FILL-IN h_tt-atr
           ASSIGN FRAME             = FRAME attr-dial:HANDLE
                  ROW               = cur-row 
                  COLUMN            = 60
                  WIDTH             = 9
                  BGCOLOR           = std_fillin_bgcolor
                  FGCOLOR           = std_fillin_fgcolor
                  FORMAT            = "X(9)"
                  SCREEN-VALUE      = (IF _F._INITIAL-DATA-ATTR NE ? AND _F._INITIAL-DATA-ATTR NE "" THEN _F._INITIAL-DATA-ATTR ELSE "")
            TRIGGERS:
              ON LEAVE DO:
                IF _F._INITIAL-DATA-ATTR NE SELF:SCREEN-VALUE THEN DO:
                  SELF:SCREEN-VALUE = LEFT-TRIM(SELF:SCREEN-VALUE).
                  RUN adeuib/_strattr.p (SELF:SCREEN-VALUE).
                  IF RETURN-VALUE NE "":U THEN RETURN NO-APPLY.
                  ELSE DO:
                    ASSIGN SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE)
                           _F._INITIAL-DATA-ATTR  = SELF:SCREEN-VALUE.
                  END.
                END.
              END.
            END.

    ASSIGN h_tt-atr:SENSITIVE = TRUE
           cur-row  = cur-row + 1.1.

  END.  /* Has a INITIAL-DATA */

REMOVE*/

  /* *******************************************************************
   *  PRIVATE DATA 
   * *******************************************************************/
  IF CAN-DO("WINDOW,FRAME,BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,IMAGE,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,TOGGLE-BOX",_U._TYPE) AND NOT lBrowseColumn
  THEN DO:
    CREATE TEXT h_tt-lbl ASSIGN FRAME = FRAME attr-dial:HANDLE. 
    CREATE EDITOR h_tt
           ASSIGN FRAME                = FRAME attr-dial:HANDLE
                  ROW                  = cur-row 
                  COLUMN               = 12
                  SCROLLBAR-VERTICAL   = TRUE
                  SCROLLBAR-HORIZONTAL = TRUE
                  RETURN-INSERTED      = TRUE
                  WIDTH                = 46
                  FONT                 = editor_font
                  INNER-LINES          = IF SESSION:HEIGHT-PIXELS > 500 THEN 4
                                                                        ELSE 2
                  SCREEN-VALUE         = (IF _U._PRIVATE-DATA NE ? AND _U._PRIVATE-DATA NE "" THEN _U._PRIVATE-DATA ELSE "")
                  SIDE-LABEL-HANDLE    = h_tt-lbl
                  LABEL                = "Private Data:"
                  BGCOLOR              = {&READ-ONLY_BGC}
                  SENSITIVE            = TRUE
    .
             
    ASSIGN h_tt-lbl:HEIGHT  = 1
           h_tt-lbl:WIDTH   = FONT-TABLE:GET-TEXT-WIDTH-CHARS(
                                      h_tt:LABEL + " ")
           h_tt-lbl:ROW     = h_tt:ROW
           h_tt-lbl:COLUMN  = h_tt:COLUMN - h_tt-lbl:WIDTH
           h_tt:SENSITIVE   = FALSE.

    CREATE TEXT h_col3
           ASSIGN FRAME             = FRAME attr-dial:HANDLE
                  ROW               = cur-row
                  COLUMN            = 59
                  WIDTH             = 1
                  HEIGHT            = 1
                  SCREEN-VALUE      = ":".
             
    CREATE FILL-IN h_tt-atr
           ASSIGN FRAME             = FRAME attr-dial:HANDLE
                  ROW               = cur-row 
                  COLUMN            = 60
                  WIDTH             = 9
                  BGCOLOR           = std_fillin_bgcolor
                  FGCOLOR           = std_fillin_fgcolor
                  FORMAT            = "X(9)"
                  SCREEN-VALUE      = (IF _U._PRIVATE-DATA-ATTR NE ? AND _U._PRIVATE-DATA-ATTR NE "" THEN _U._PRIVATE-DATA-ATTR ELSE "")
            TRIGGERS:
              ON LEAVE DO:
                IF _U._PRIVATE-DATA-ATTR NE SELF:SCREEN-VALUE THEN DO:
                  SELF:SCREEN-VALUE = LEFT-TRIM(SELF:SCREEN-VALUE).
                  RUN adeuib/_strattr.p (SELF:SCREEN-VALUE).
                  IF RETURN-VALUE NE "":U THEN RETURN NO-APPLY.
                  ELSE DO:
                    ASSIGN SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE)
                           _U._PRIVATE-DATA-ATTR  = SELF:SCREEN-VALUE.
                  END.
                END.
              END.
            END.

    ASSIGN h_tt-atr:SENSITIVE = TRUE
           cur-row  = cur-row + 4.1.

  END.  /* Has PRIVATE DATA */


{adecomm/okbar.i} 
ASSIGN FRAME attr-dial:DEFAULT-BUTTON = btn_OK:HANDLE IN FRAME attr-dial.
  

ON CHOOSE OF btn_help IN FRAME attr-dial OR HELP OF FRAME attr-dial DO:
  RUN adecomm/_adehelp.p ( "ab", "CONTEXT", {&String_Attrs_Dlg_Box}, ? ).
END.
 
  ASSIGN cur-row                  = cur-row + .5
         adjust                   = FRAME attr-dial:HEIGHT - cur-row - 2.25
         btn_ok:ROW               = btn_ok:ROW - adjust
         btn_cancel:ROW           = btn_cancel:ROW - adjust
         btn_help:ROW             = btn_help:ROW - adjust
         FRAME attr-dial:HEIGHT   = frame attr-dial:HEIGHT - adjust
     . 
  {adeuib/ide/dialoginit.i "FRAME attr-dial:handle"}
  &IF DEFINED(IDE-IS-RUNNING) <> 0 &THEN
  dialogService:View().  
   &ELSE
  FRAME attr-dial:HIDDEN   = FALSE.
   &ENDIF 
      
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
  ON WINDOW-CLOSE OF FRAME attr-dial APPLY "END-ERROR":U TO SELF.
 
  /* Now enable the interface and wait for the exit condition.            */
  /* (NOTE: handle ERROR and END-KEY so cleanup code will slways fire.    */
  MAIN-BLOCK:
  DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
     ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
   &scoped-define CANCEL-EVENT U2
   {adeuib/ide/dialogstart.i btn_ok btn_cancel wintitle}
   &if DEFINED(IDE-IS-RUNNING) = 0  &then
     WAIT-FOR GO OF FRAME {&FRAME-NAME}.
   &ELSE
     WAIT-FOR GO OF FRAME {&FRAME-NAME} or "{&CANCEL-EVENT}" of this-procedure.       
     if cancelDialog THEN UNDO, LEAVE.  
   &endif
    
  END.
END.  /*TRANS-BLK */
HIDE FRAME attr-dial.
DELETE WIDGET-POOL.
&UNDEFINE FRAME-NAME 
