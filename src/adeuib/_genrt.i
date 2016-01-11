/***********************************************************************
* Copyright (C) 2000,2008 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*----------------------------------------------------------------------------

File: _genrt.i

Description:
    This generates the RUN-TIME ATTRIBUTES section of a .w file.  It is only
    called by _gen4gl.p and was split out only for the purpose of making the
    code more manageable.

Author: D. Ross Hunter

Date Created: 1995
Modified:     1/98 SLK Added runtime code for SmartData's PRIVATE-DATA
          02/17/98 GFS Added COLUMN-RESIZABLE & COLUMN-MOVABLE for Browse.
          03/10/98 SLK Removed runtime code for SmartData's PRIVATE-DATA
          04/20/98 GFS Added ROW-RESIZABLE for Browse.
          07/11/98 HD  Added USER for User fields  (_U._DEFINED-BY = "User") 
          02/16/99 TSM Added check for "Temp-Tables" for field-level run-time
                       attributes so that the name of the widget 
                       (Temp-Tablename.FieldName) is written rather than ?  
          05/20/99 TSM Added VISIBLE for Browse column 
          06/08/99 TSM Added ALLOW-COLUMN-SCROLLING attribute for browse 
          06/10/99 TSM Added AUTO-RESIZE and COLUMN-READ-ONLY for Browse column 
          06/11/99 TSM Changed ALLOW-COLUMN-SCROLLING to COLUMN-SEARCHING 
          06/14/99 TSM Added support for SEPARATOR-FGCOLOR                
          06/22/99 SLK Added support for _U._PRIVATE-DATA-ATTR
          06/25/99 TSM Added support to write VISIBLE runtime attribute
                       for browse column calculated fields when they have
                       named fields (@ fieldname)
          12/18/02 DRH Added code submitted by Alan J Copeland of 
                       OPENLOGISTIX SYSTEMS LIMITED to make sure delimiters
                       are properly written and read to static objects for
                       RADIO-SETS, SELECTION-LISTS and COMBO-BOXes.  (IZ 8044)

---------------------------------------------------------------------------- */
/* ************************************************************************* */
/*                                                                           */
/*                           RUN-TIME ATTRIBUTES                             */
/*                                                                           */
/* ************************************************************************* */

/* First check to see if this section is necessary                           */
PUT STREAM P_4GL UNFORMATTED SKIP (2)
    "/* ***********  Runtime Attributes and AppBuilder Settings  *********** */"
    SKIP (1).
/* This line checks the compile time preprocessor variables to ensure
   that all the user defined lists are writen out. If the preprocessor value is
   "wrong", this line will catch it and someone who compiles this file will 
   see the bug.*/
&IF {&MaxUserLists} ne 6 &THEN
&MESSAGE [_gen4gl.p] *** FIX NOW *** User-List not being generated correctly (wood)
&ENDIF

DEFINE VARIABLE in_frame_clause AS CHARACTER                              NO-UNDO.
DEFINE VARIABLE var_defined     AS LOGICAL   INIT FALSE                   NO-UNDO.
DEFINE VARIABLE lFirstColRun    AS LOGICAL                                NO-UNDO.

DEFINE BUFFER   anchor_U FOR _U.

ASSIGN window_sect  = (NOT _U._DISPLAY   OR _U._LABEL-ATTR NE ""  OR
                      _P._RUN-PERSISTENT OR _U._User-List[1]      OR
                      _U._User-List[2]   OR _U._User-List[3]      OR
                      _U._User-List[4]   OR _U._User-List[5]      OR
                      _U._User-List[6]) AND _U._TYPE = "WINDOW":U
       frame_sect   = FALSE
       widget_sect  = FALSE
       frame_parent = FALSE
       multi-layout = (layout-var ne "")
       .

FRAME-SEARCH:
FOR EACH _U WHERE _U._WINDOW-HANDLE = _h_win AND
                  CAN-DO("WINDOW,FRAME,DIALOG-BOX":U,_U._TYPE) AND
                  _U._STATUS BEGINS u_status USE-INDEX _OUTPUT:
  /* A frame status of "EXPORT-FORM" means that the frame contains objects   */
  /* to be exported, but isn't to be exported itself.  Here we need to get   */
  /* into this FOR EACH using the BEGINS "EXPORT" to get to the field level  */
  /* objects, but we don't want the frame stuff unless _STATUS = "EXPORT"    */

  /* Frame run-time attributes. */
  IF CAN-DO ("FRAME,DIALOG-BOX":U,_U._TYPE) THEN DO:
    FIND _C WHERE RECID(_C) = _U._x-recid.
    FIND _L WHERE _L._u-recid = RECID(_U) AND _L._LO-NAME = "Master Layout".
    IF _U._STATUS eq u_status AND
       (_U._TYPE eq "DIALOG-BOX":U /* Always say DIALOGS are not scrollable */  OR
        _C._BOX-SELECTABLE   OR _C._DOWN               OR _C._EXPLICIT_POSITION OR
        _U._HIDDEN           OR _U._MANUAL-HIGHLIGHT   OR _U._SELECTABLE        OR
        _U._SELECTED         OR _U._MOVABLE            OR _U._POPUP-RECID NE ?  OR
        _C._SCROLLABLE       OR (NOT _U._SENSITIVE)    OR _U._SHARED            OR
        _C._SIZE-TO-FIT      OR
        _U._RESIZABLE        OR (NOT _L._NO-UNDERLINE) OR (NOT _U._DISPLAY)     OR
        _U._User-List[1]     OR _U._User-List[2]       OR _U._User-List[3]      OR
        _U._User-List[4]     OR _U._User-List[5]       OR _U._User-List[6]      OR 
        _U._PRIVATE-DATA NE "" OR _L._REMOVE-FROM-LAYOUT                        OR
        _P._frame-name-recid = RECID(_U) OR _C._TABBING ne "DEFAULT":U )
   THEN frame_sect = TRUE.
  END.
   
  /* Are any frames parented to other frames (or dialog-boxes)? */
  IF _U._TYPE eq "FRAME" THEN DO:
    IF wndw THEN DO:
       IF (_U._parent-recid NE _P._u-recid) THEN frame_parent = TRUE.
    END.
    ELSE
      /* Any frame in a Dialog must have a frame parent (either to the dialog
         itself, or another frame). */
      frame_parent = YES.
  END.

  frame_layer = _U._HANDLE:FIRST-CHILD.
  IF not widget_sect AND frame_layer NE ? THEN
  WIDGET-SEARCH:
  FOR EACH x_U WHERE x_U._WINDOW-HANDLE = _h_win 
                 AND x_U._PARENT        = frame_layer 
                 AND NOT CAN-DO("SmartObject,FRAME,QUERY,{&WT-CONTROL}":U,x_U._TYPE)
                 AND x_U._STATUS        = u_status:
    IF x_U._TYPE NE "BROWSE":U THEN DO:
      IF NOT x_U._NAME BEGINS "_LBL" THEN DO:
        FIND x_L WHERE x_L._u-recid = RECID(x_U) AND x_L._LO-NAME = "Master Layout".
        FIND _F WHERE RECID(_F) = x_U._x-recid.
        /* Is this widget special or unusual */
        IF _F._AUTO-INDENT     OR  _F._AUTO-RESIZE   OR  (NOT x_U._ENABLE)      OR
           x_U._HIDDEN         OR  x_U._MANUAL-HIGHLIGHT                        OR
           x_U._SELECTABLE     OR  x_U._SELECTED     OR  x_U._MOVABLE           OR
           x_U._POPUP-RECID NE ?                     OR  _F._READ-ONLY          OR
           _F._RETURN-INSERTED OR  x_U._RESIZABLE    OR  x_U._SHARED            OR
           x_U._User-List[1]   OR x_U._User-List[2]  OR x_U._User-List[3]       OR
           x_U._User-List[4]   OR x_U._User-List[5]  OR x_U._User-List[6]       OR
          (NOT x_U._DISPLAY)   OR _F._DISPOSITION = "LIKE":U                    OR
           _F._DICT-VIEW-AS    OR 
           x_U._PRIVATE-DATA NE "" OR                   x_L._REMOVE-FROM-LAYOUT OR
          (CAN-DO("FILL-IN,COMBO-BOX":U,x_U._TYPE) AND x_U._ALIGN NE "C") OR
          (NOT CAN-DO("FILL-IN,COMBO-BOX":U,x_U._TYPE) AND x_U._ALIGN NE "L") OR 
          (x_U._DBNAME = ? AND (x_U._HELP-SOURCE   = "D" OR 
                           _F._FORMAT-SOURCE = "D" OR x_U._LABEL-SOURCE = "D")) OR
          (x_U._DBNAME NE ? AND (x_U._HELP-SOURCE   = "E" OR 
                           _F._FORMAT-SOURCE = "E" OR x_U._LABEL-SOURCE = "E")) OR
          (CAN-DO("FILL-IN,COMBO-BOX":U,x_U._TYPE) AND NOT x_L._NO-LABELS AND
                                                                 _L._NO-LABELS) OR
          (x_U._DBNAME NE ? AND x_U._DROP-TARGET)                               
          /* AJC start */
          OR (_F._DELIMITER <> "":U and CAN-DO("SELECTION-LIST,RADIO-SET,COMBO-BOX":U,x_U._TYPE))
          /* AJC END */
          /* Assignment of help must be generated for local CLOB data fields */
          OR (x_U._HELP-SOURCE = "D":U AND _F._SOURCE-DATA-TYPE = "CLOB":U) 
       THEN DO:                         
          widget_sect = TRUE.
          LEAVE WIDGET-SEARCH.
        END.
      END.  /* IF not a label */
    END.  /* IF not a browse widget */
    
    ELSE DO:  /* If a browse widget */
      frame_sect = TRUE.  /* Since this browse exists, we must put out a frame 
                             section to restore tab order                       */
      FIND x_C WHERE RECID(x_C) = x_U._x-recid.
      FIND x_Q WHERE RECID(x_Q) = x_C._q-recid.
      FIND x_L WHERE x_L._u-recid = RECID(x_U) AND x_L._LO-NAME = "Master Layout".
      /* Is this widget special or unusual */
      IF (NOT x_U._ENABLE)   OR  x_U._HIDDEN       OR  x_U._MANUAL-HIGHLIGHT   OR
         x_U._SELECTABLE     OR  x_U._SELECTED     OR  x_U._MOVABLE            OR
         x_U._User-List[1]   OR  x_U._User-List[2] OR  x_U._User-List[3]       OR
         x_U._User-List[4]   OR  x_U._User-List[5] OR  x_U._User-List[6]       OR
         x_U._POPUP-RECID NE ?                     OR  x_U._RESIZABLE          OR
         x_U._SHARED         OR (NOT x_U._DISPLAY) OR  x_U._ALIGN NE "L"       OR
         x_C._NUM-LOCKED-COLUMNS > 0 OR                x_L._REMOVE-FROM-LAYOUT OR
         x_C._COLUMN-RESIZABLE                     OR  x_C._COLUMN-MOVABLE     OR
         x_C._MAX-DATA-GUESS <> 100  OR                x_U._PRIVATE-DATA NE "" OR
         x_C._ROW-RESIZABLE                        OR x_C._COLUMN-SEARCHING    OR  
         x_L._SEPARATOR-FGCOLOR NE ? OR               
         CAN-FIND(FIRST _BC WHERE _BC._x-recid = RECID(x_U) AND NOT _BC._VISIBLE) OR
         CAN-FIND(FIRST _BC WHERE _BC._x-recid = RECID(x_U) AND _AUTO-RESIZE)     OR
         CAN-FIND(FIRST _BC WHERE _BC._x-recid = RECID(x_U) AND _COLUMN-READ-ONLY) 
     THEN DO:
        IF CAN-FIND(FIRST _BC WHERE _BC._x-recid = RECID(x_U)) OR
           CAN-FIND(_TRG WHERE _TRG._wRECID = RECID(x_U) AND
                               _TRG._tEVENT = "OPEN_QUERY":U) OR
           x_U._POPUP-RECID NE ?
            THEN widget_sect = TRUE.
        LEAVE WIDGET-SEARCH.
      END.
    END.  /* IF a BROWSE */
  END.  /* WIDGET-SEARCH */
END.  /* FRAME-SEARCH */

/* We need a runtime settings section if we need to adjust set anything on
   any window, frame or widget.  We also need this section if we have 
   multiple layouts or frames owning frames. */
IF window_sect OR frame_sect OR widget_sect OR multi-layout OR frame_parent THEN DO:
  IF p_status NE "PREVIEW" THEN
    PUT STREAM P_4GL UNFORMATTED
      "&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES" SKIP.

  IF window_sect THEN DO:
    FIND _U WHERE _U._HANDLE = _h_win.
    FIND _C WHERE RECID(_C) = _U._x-recid.
    tmp_string = "  " 
                 + (IF _U._DISPLAY THEN "VISIBLE,"  ELSE "NOT-VISIBLE," )
                 + _U._LABEL-ATTR 
                 + (IF _P._RUN-PERSISTENT THEN ",RUN-PERSISTENT " ELSE " ")
                 + (IF _U._User-List[1] THEN "1 " ELSE "")
                 + (IF _U._User-List[2] THEN "2 " ELSE "")
                 + (IF _U._User-List[3] THEN "3 " ELSE "")
                 + (IF _U._User-List[4] THEN "4 " ELSE "")
                 + (IF _U._User-List[5] THEN "5 " ELSE "")
                 + (IF _U._User-List[6] THEN "6 " ELSE "")
                 . 
    IF LENGTH(tmp_string,"CHARACTER":U) < 72
    THEN tmp_string = tmp_string + FILL(" ", 72 - LENGTH(tmp_string,"CHARACTER":U)). 
    PUT STREAM P_4GL UNFORMATTED
               "/* SETTINGS FOR " _U._TYPE " " _U._NAME SKIP
               tmp_string "*/" SKIP.
  END.  /* If window section */
  
  /* If some frames are parented to other frames (or dialog-boxes), write the code.
     NOTE: if we are exporting, only write out the parenting if BOTH the frame
     and its parent are being exported.  */
  IF frame_parent THEN DO:
    first_pass = YES.
    FOR EACH _U WHERE _U._WINDOW-HANDLE = _h_win AND
                      _U._TYPE eq "FRAME" AND
                      _U._STATUS BEGINS u_status,
        EACH x_U WHERE RECID(x_U) = _U._parent-recid
                   AND x_U._TYPE ne "WINDOW"
                   AND x_U._STATUS eq _U._STATUS
      USE-INDEX _OUTPUT:
        IF first_pass THEN DO: /* This is the first time in. */
          PUT STREAM P_4GL UNFORMATTED SKIP
                     "/* REPARENT FRAME */" SKIP
                     "ASSIGN FRAME " _U._NAME ":FRAME = FRAME "
                     x_U._NAME ":HANDLE".
          first_pass = NO.
        END.  /* If first reparented frame */
        ELSE DO:    /* A subsequent frame in need of parenting */
          PUT STREAM P_4GL UNFORMATTED SKIP
                     "       FRAME " _U._NAME ":FRAME = FRAME "
                     x_U._NAME ":HANDLE".       
        END.
    END.  /* FOR EACH FRAME in nedd of reparenting */
    /* If first_pass is still set, then it is because NO frames were put out.
       Therefore we don't need the closing period. */
    IF NOT first_pass THEN PUT STREAM P_4GL UNFORMATTED "." SKIP (1).
  END.  /* If any frames need special parenting */
          
  /* Loop through frames (group by frames) */
  FOR EACH _U WHERE _U._WINDOW-HANDLE = _h_win AND
                    CAN-DO("WINDOW,FRAME,DIALOG-BOX":U,_U._TYPE) AND
                    _U._STATUS BEGINS u_status BY _U._NAME BY _U._TYPE:
  /* A frame status of "EXPORT-FORM" means that the frame contains objects   */
  /* to be exported, but isn't to be exported itself.  Here we need to get   */
  /* into this FOR EACH using the BEGINS "EXPORT" to get to the field level  */
  /* objects, but we don't want the frame stuff unless _STATUS = "EXPORT"    */
    tmp_string = "".
    /* Frame run-time attributes */
    IF CAN-DO ("FRAME,DIALOG-BOX":U,_U._TYPE) THEN DO:
      FIND _L WHERE _L._u-recid = RECID(_U) AND _L._LO-NAME = "Master Layout".
      FIND _C WHERE RECID(_C) = _U._x-recid.
      IF _U._STATUS = u_status AND frame_sect AND
        ( NOT _U._DISPLAY OR _C._EXPLICIT_POSITION OR NOT _L._NO-UNDERLINE OR
          _C._SIZE-TO-FIT  OR _C._TABBING ne "DEFAULT":U OR
          _U._User-List[1] OR _U._User-List[2] OR  _U._User-List[3] OR
          _U._User-List[4] OR _U._User-List[5] OR  _U._User-List[6] OR
          _P._frame-name-recid = RECID(_U)     OR  _C._tabbing NE "DEFAULT":U )
      THEN
        ASSIGN tmp_string = "   " 
                           + (IF NOT _U._DISPLAY THEN "NOT-VISIBLE " ELSE "")
                           + (IF _C._EXPLICIT_POSITION THEN "EXP-POSITION " ELSE "")
                           + (IF _P._frame-name-recid = RECID(_U) THEN "FRAME-NAME "
                                                                  ELSE "")
                           + (IF _U._SHARED  THEN "SHARED " ELSE "")
                           + (IF NOT _L._NO-UNDERLINE  THEN  "UNDERLINE " ELSE "")
                           + (IF _C._SIZE-TO-FIT  THEN  "Size-to-Fit " ELSE "")
                           + (IF _U._User-List[1] THEN "1 " ELSE "")
                           + (IF _U._User-List[2] THEN "2 " ELSE "")
                           + (IF _U._User-List[3] THEN "3 " ELSE "")
                           + (IF _U._User-List[4] THEN "4 " ELSE "")
                           + (IF _U._User-List[5] THEN "5 " ELSE "")
                           + (IF _U._User-List[6] THEN "6 " ELSE "")
                           + (IF _C._TABBING NE "DEFAULT":U THEN
                                          _C._tabbing + " " ELSE "")
                           .

      IF LENGTH(tmp_string,"CHARACTER":U) < 72
      THEN tmp_string = tmp_string + FILL(" ", 72 - LENGTH(tmp_string,"CHARACTER":U)).
      PUT STREAM P_4GL UNFORMATTED
                 "/* SETTINGS FOR " _U._TYPE " " _U._NAME SKIP
                 tmp_string "*/" SKIP.

      /* Generate the MOVE-BEFORE-TAB-ITEM and/or MOVE-AFTER-TAB-ITEM */
      /* method calls for any frames defined within another frame.    */
      RUN adeuib/_gentabs.p (RECID (_U), OUTPUT tmp_string).
      IF tmp_string <> "" THEN DO:
        IF NOT var_defined THEN DO:
          /* Only want to define this ugly variable once.  */
          /* It's defined in the runtime settings block to */
          /* prevent a user's access to it in the defin-   */
          /* itions block, where he might delete/change it.*/
          PUT STREAM P_4GL UNFORMATTED
                     CHR (10) + 
                     "DEFINE VARIABLE XXTABVALXX AS LOGICAL NO-UNDO." +
                     CHR (10) SKIP.
          var_defined = TRUE.
        END.
        PUT STREAM P_4GL UNFORMATTED tmp_string +
                   "/* END-ASSIGN-TABS */." + CHR (10) SKIP.
      END.
      
      FOR EACH x_U WHERE x_U._WINDOW-HANDLE = _h_win AND
                         x_U._TYPE = "BROWSE":U AND
                         x_U._PARENT-RECID = RECID(_U)
                    BY x_U._TAB-ORDER:
        DO PRESELECT EACH anchor_U WHERE
               anchor_U._WINDOW-HANDLE = _h_win AND
               anchor_U._PARENT-RECID = RECID(_U) AND
               LOOKUP(anchor_U._TYPE,"SmartObject,OCX":U) = 0
             BY anchor_U._TAB-ORDER:
          FIND LAST anchor_U WHERE anchor_U._TAB-ORDER > 0 AND
                                    anchor_U._TAB-ORDER < x_U._TAB-ORDER NO-ERROR.
          IF NOT AVAILABLE anchor_U THEN
            PUT STREAM P_4GL UNFORMATTED SKIP
              "/* BROWSE-TAB " + x_U._NAME + " 1 " + _U._NAME + " */" SKIP.
          ELSE
            PUT STREAM P_4GL UNFORMATTED SKIP
              "/* BROWSE-TAB " + x_U._NAME + " " + anchor_U._NAME + " " +
               _U._NAME + " */" SKIP.
        END.  /* Preselect anchor_U */
      END.  /* For each browse of the frame */

      IF _U._STATUS NE "EXPORT-FORM" AND
         (_U._STATUS = u_status AND frame_sect AND
           /* Always say DIALOGS are not scrollable.  Size-to-fit frames need to 
              have scrollable turned off (because they are created scrollable). */ 
           ( _U._TYPE eq "DIALOG-BOX":U  OR
             (_C._SIZE-TO-FIT AND NOT _C._SCROLLABLE)       OR
             _C._BOX-SELECTABLE    OR _C._DOWN              OR 
             _C._EXPLICIT_POSITION OR _U._HIDDEN            OR
             _U._MANUAL-HIGHLIGHT  OR _U._SELECTABLE        OR _U._SELECTED           OR
             _U._MOVABLE           OR _U._POPUP-RECID NE ?  OR _C._SCROLLABLE         OR
             (NOT _U._SENSITIVE)   OR _U._RESIZABLE
            ) OR  _L._REMOVE-FROM-LAYOUT OR  _U._PRIVATE-DATA NE "")
      THEN DO:
        PUT STREAM P_4GL UNFORMATTED "ASSIGN ".
        IF _C._BOX-SELECTABLE THEN PUT STREAM P_4GL UNFORMATTED SKIP
            "       FRAME " _U._NAME ":BOX-SELECTABLE   = TRUE".
        IF  (_U._TYPE eq "DIALOG-BOX":U) OR (_C._DOWN AND NOT _C._SCROLLABLE) OR
            (_C._SIZE-TO-FIT AND NOT _C._SCROLLABLE)
           THEN PUT STREAM P_4GL UNFORMATTED SKIP
            "       FRAME " _U._NAME ":SCROLLABLE       = FALSE".
        IF _C._EXPLICIT_POSITION AND _U._LAYOUT-UNIT
           THEN PUT STREAM P_4GL UNFORMATTED SKIP
            "       FRAME " _U._NAME ":ROW              = " _L._ROW SKIP
            "       FRAME " _U._NAME ":COLUMN           = " _L._COL.
        IF _C._EXPLICIT_POSITION AND NOT _U._LAYOUT-UNIT
           THEN PUT STREAM P_4GL UNFORMATTED SKIP
            "       FRAME " _U._NAME ":X               = "
            (INTEGER(_L._COL - 1) * (SESSION:PIXELS-PER-COLUMN * _L._COL-MULT)) 
            SKIP
            "       FRAME " _U._NAME ":Y                = "
            (INTEGER(_L._ROW - 1) * (SESSION:PIXELS-PER-ROW * _L._ROW-MULT)).
        IF _U._HIDDEN THEN PUT STREAM P_4GL UNFORMATTED SKIP
            "       FRAME " _U._NAME ":HIDDEN           = TRUE".
        IF _U._MANUAL-HIGHLIGHT THEN PUT STREAM P_4GL UNFORMATTED SKIP
            "       FRAME " _U._NAME ":MANUAL-HIGHLIGHT = TRUE".
        IF _U._SELECTABLE THEN PUT STREAM P_4GL UNFORMATTED SKIP
            "       FRAME " _U._NAME ":SELECTABLE       = TRUE".
        IF _U._SELECTED THEN PUT STREAM P_4GL UNFORMATTED SKIP
            "       FRAME " _U._NAME ":SELECTED         = TRUE".
        IF _U._MOVABLE THEN PUT STREAM P_4GL UNFORMATTED SKIP
            "       FRAME " _U._NAME ":MOVABLE          = TRUE".
        IF _U._POPUP-RECID NE ? THEN DO:
           FIND xx_U WHERE RECID(xx_U) = _U._POPUP-RECID.
           PUT STREAM P_4GL UNFORMATTED SKIP
            "       FRAME " _U._NAME ":POPUP-MENU       = MENU "
            xx_U._NAME ":HANDLE".
        END.
        IF _L._REMOVE-FROM-LAYOUT THEN PUT STREAM P_4GL UNFORMATTED SKIP
            "       FRAME " _U._NAME ":VISIBLE          = FALSE".
        IF _C._SCROLLABLE    THEN PUT STREAM P_4GL UNFORMATTED SKIP
            "       FRAME " _U._NAME ":HEIGHT           = " _L._HEIGHT SKIP
            "       FRAME " _U._NAME ":WIDTH            = " _L._WIDTH.
           
        IF NOT _U._SENSITIVE THEN PUT STREAM P_4GL UNFORMATTED SKIP
            "       FRAME " _U._NAME ":SENSITIVE        = FALSE".
        IF _U._RESIZABLE THEN PUT STREAM P_4GL UNFORMATTED SKIP
            "       FRAME " _U._NAME ":RESIZABLE        = TRUE".
        IF _U._PRIVATE-DATA NE "" THEN DO:
          tmp_string = "~"" + _U._PRIVATE-DATA + "~"".
          IF _U._PRIVATE-DATA-ATTR NE "" AND _U._PRIVATE-DATA-ATTR NE ? THEN
          tmp_string = tmp_string + ":":U + _U._PRIVATE-DATA-ATTR.
          PUT STREAM P_4GL UNFORMATTED SKIP
            "       FRAME " _U._NAME ":PRIVATE-DATA     = " SKIP
            "                " tmp_string.
        END.        
        PUT STREAM P_4GL UNFORMATTED "." SKIP (1).
      END.
    END.  /* Frame run-time attributes */

    /* Field level run-time attributes */
    IF widget_sect THEN DO:
      frame_layer = _U._HANDLE:FIRST-CHILD.
      FOR EACH x_U WHERE x_U._WINDOW-HANDLE = _h_win  
                     AND x_U._PARENT        = frame_layer  
                     AND x_U._STATUS        = u_status  
                     AND NOT CAN-DO("TEXT,SmartObject,FRAME,QUERY,{&WT-CONTROL}":U,x_U._TYPE)
                   BY x_U._NAME BY x_U._TYPE:
                   
        in_frame_clause = " IN FRAME ":U + _U._NAME.          
                   
        IF x_U._TYPE NE "BROWSE":U THEN DO:  /* If not a browse */
          FIND _F WHERE RECID(_F) EQ x_U._x-recid.
          FIND x_L WHERE x_L._u-recid = RECID(x_U) AND x_L._LO-NAME = "Master Layout".
          
          /* CLOB datafields are represented as LONGCHAR local editors on viewers.  When
             the data field data type is CLOB, the local field name must be used for 
             runtime attribute generation. */ 
          tmp_name = IF x_U._DBNAME eq ? OR _F._DISPOSITION = "LIKE":U THEN x_U._NAME
                     ELSE IF _F._SOURCE-DATA-TYPE = "CLOB":U THEN x_U._LOCAL-NAME
                     ELSE IF x_U._TABLE = "RowObject":U THEN x_U._TABLE + "." + x_U._NAME
                     ELSE IF x_U._DBNAME = "Temp-Tables":U THEN x_U._TABLE + "." + x_U._NAME
                     ELSE (db-tbl-name(LDBNAME(x_U._DBNAME) + "." + x_U._TABLE) + "." + x_U._NAME).
          IF tmp_name = ? AND LDBNAME(X_U._DBNAME) = ? THEN  /* IZ 3528 */
            tmp_name = X_U._TABLE + ".":U + X_U._NAME.
          

          /* Is this widget special or unusual */
          IF (not x_U._DISPLAY)                                               OR
             (NOT x_U._ENABLE) OR (x_U._SHARED AND x_U._DBNAME = ?)           OR 
             (CAN-DO("FILL-IN,COMBO-BOX":U,x_U._TYPE) AND x_U._ALIGN NE "C")  OR
             (NOT CAN-DO("FILL-IN,COMBO-BOX":U,x_U._TYPE) AND x_U._ALIGN NE "L") OR
             (x_U._DBNAME = ? AND (x_U._LABEL-SOURCE = "D" OR
                                    _F._FORMAT-SOURCE = "D" OR 
                                    x_U._HELP-SOURCE = "D"))                   OR
             (x_U._DBNAME NE ? AND (x_U._LABEL-SOURCE = "E" OR
                                    _F._FORMAT-SOURCE = "E" OR 
                                    x_U._HELP-SOURCE = "E"))                   OR
             (_F._DISPOSITION = "LIKE":U) OR _F._DICT-VIEW-AS                  OR
             (CAN-DO("FILL-IN,COMBO-BOX":U,x_U._TYPE) AND NOT x_L._NO-LABELS AND
                                                               _L._NO-LABELS) OR
             x_U._DEFINED-BY = "User" OR 
             x_U._User-List[1] OR x_U._User-List[2] OR x_U._User-List[3] OR
             x_U._User-List[4] OR x_U._User-List[5] OR x_U._User-List[6]
          THEN DO:
            ASSIGN 
              tmp_string = "   " 
                         + (IF x_U._DISPLAY eq NO THEN "NO-DISPLAY " ELSE "")
                         + (IF x_U._SHARED AND x_U._DBNAME = ? THEN "SHARED " ELSE "")
                         + (IF NOT x_U._ENABLE THEN  "NO-ENABLE " ELSE "")
                         + (IF (CAN-DO("FILL-IN,COMBO-BOX":U,x_U._TYPE) AND
                                                   x_U._ALIGN NE "C")  
                            OR (NOT CAN-DO("FILL-IN,COMBO-BOX":U,x_U._TYPE) AND
                                                    x_U._ALIGN NE "L") 
                            THEN "ALIGN-" + x_U._ALIGN + " " ELSE "")
                         + (IF x_U._DEFINED-BY = "User":U THEN "USER " ELSE "")
                         + (IF x_U._User-List[1] THEN "1 " ELSE "")
                         + (IF x_U._User-List[2] THEN "2 " ELSE "")
                         + (IF x_U._User-List[3] THEN "3 " ELSE "") 
                         + (IF x_U._User-List[4] THEN "4 " ELSE "")
                         + (IF x_U._User-List[5] THEN "5 " ELSE "")
                         + (IF x_U._User-List[6] THEN "6 " ELSE "")
                         + (IF _F._DISPOSITION EQ "LIKE":U THEN "LIKE = " +
                               x_U._DBNAME + "." + x_U._TABLE + "." + _F._LIKE-FIELD + " "
                               ELSE "").
            IF x_U._DBNAME = ? AND x_U._LABEL-SOURCE = "D" THEN
                   tmp_string = tmp_string + "DEF-LABEL ".
            IF x_U._DBNAME = ? AND _F._FORMAT-SOURCE = "D" THEN
                   tmp_string = tmp_string + "DEF-FORMAT ".
            IF x_U._DBNAME = ? AND x_U._HELP-SOURCE = "D" THEN
                   tmp_string = tmp_string + "DEF-HELP ".
            IF x_U._DBNAME NE ? AND x_U._LABEL-SOURCE = "E" THEN
                   tmp_string = tmp_string + "EXP-LABEL ".
            IF x_U._DBNAME NE ? AND _F._FORMAT-SOURCE = "E" THEN
                   tmp_string = tmp_string + "EXP-FORMAT ".
            IF x_U._DBNAME NE ? AND x_U._HELP-SOURCE = "E" THEN
                   tmp_string = tmp_string + "EXP-HELP ".
            IF x_U._DBNAME NE ? AND _F._DICT-VIEW-AS THEN
                   tmp_string = tmp_string + "VIEW-AS ".
            IF _F._DISPOSITION EQ "LIKE":U AND _F._SIZE-SOURCE = "E" THEN
                   tmp_string = tmp_string + "EXP-SIZE ".
            IF CAN-DO("FILL-IN,COMBO-BOX":U,x_U._TYPE) AND NOT x_L._NO-LABELS AND
               _L._NO-LABELS AND NOT x_U._LABEL = ? THEN
               /* Even though the frame has no-labels save the individual */
               /* labels incase the frame labels get turned back on.      */
                   tmp_string = tmp_string + "LABEL ~"" + x_U._LABEL +
                                             ":" + x_U._LABEL-ATTR + "~"".
            IF LENGTH(tmp_string,"CHARACTER":U) < 72
            THEN tmp_string = tmp_string + FILL(" ", 72 - LENGTH(tmp_string,"CHARACTER":U)). 
            PUT STREAM P_4GL UNFORMATTED
               "/* SETTINGS FOR " x_U._TYPE " " tmp_name in_frame_clause 
               SKIP tmp_string "*/" SKIP.
          END.
          
          IF _F._AUTO-INDENT     OR   _F._AUTO-RESIZE  OR
             x_U._HIDDEN         OR   x_U._MANUAL-HIGHLIGHT                         OR
             x_U._SELECTABLE     OR   x_U._SELECTED    OR   x_U._MOVABLE            OR
             x_U._POPUP-RECID NE ?                     OR   _F._READ-ONLY           OR
             _F._RETURN-INSERTED OR   x_U._RESIZABLE   OR   x_L._REMOVE-FROM-LAYOUT OR
             x_U._PRIVATE-DATA NE "" OR (x_U._DBNAME NE ? AND x_U._DROP-TARGET)     
             /* AJC start */
             OR (_F._DELIMITER <> ",":U and CAN-DO("SELECTION-LIST,RADIO-SET,COMBO-BOX":U,x_U._TYPE))
             /* AJC END */
             /* Assignment of help must be generated for local CLOB data fields */
             OR (x_U._HELP-SOURCE = "D":U AND _F._SOURCE-DATA-TYPE = "CLOB":U)
          THEN DO:
            PUT STREAM P_4GL UNFORMATTED "ASSIGN ".
            /* AJC start */
            IF _F._DELIMITER <> ",":U and CAN-DO("SELECTION-LIST,RADIO-SET,COMBO-BOX":U,x_U._TYPE) 
                THEN PUT STREAM P_4GL UNFORMATTED SKIP
                "       " tmp_name ":DELIMITER" in_frame_clause
                "      = "  + (IF _F._delimiter = ? THEN ","
                                      ELSE IF (ASC( _F._delimiter) LE 126 AND ASC( _F._delimiter) GE 32) THEN 
                                          chr(34) + _F._Delimiter + chr(34)
                                      ELSE "CHR(":U + STRING(ASC(_F._delimiter)) + ") ":U). /* AJC END */                                      
            
            IF _F._AUTO-INDENT THEN PUT STREAM P_4GL UNFORMATTED SKIP
                "       " tmp_name ":AUTO-INDENT" in_frame_clause
                                                          "      = TRUE".
            IF _F._AUTO-RESIZE THEN PUT STREAM P_4GL UNFORMATTED SKIP
                "       " tmp_name ":AUTO-RESIZE" in_frame_clause 
                                                          "      = TRUE".
            IF x_U._HIDDEN THEN PUT STREAM P_4GL UNFORMATTED SKIP
                "       " tmp_name ":HIDDEN" in_frame_clause
                                                          "           = TRUE".
            IF x_U._MANUAL-HIGHLIGHT THEN PUT STREAM P_4GL UNFORMATTED SKIP
                "       " tmp_name ":MANUAL-HIGHLIGHT" in_frame_clause
                                                          " = TRUE".
            IF _F._RETURN-INSERTED THEN PUT STREAM P_4GL UNFORMATTED SKIP
                "       " tmp_name ":RETURN-INSERTED" in_frame_clause 
                                                          "  = TRUE".
            IF x_L._REMOVE-FROM-LAYOUT THEN PUT STREAM P_4GL UNFORMATTED SKIP
                "       " tmp_name ":VISIBLE" in_frame_clause
                                                          "          = FALSE".
            IF x_U._SELECTABLE THEN PUT STREAM P_4GL UNFORMATTED SKIP
                "       " tmp_name ":SELECTABLE" in_frame_clause 
                                                          "       = TRUE".
            IF x_U._SELECTED THEN PUT STREAM P_4GL UNFORMATTED SKIP
                "       " tmp_name ":SELECTED" in_frame_clause 
                                                          "         = TRUE".
            IF x_U._MOVABLE THEN PUT STREAM P_4GL UNFORMATTED SKIP
                "       " tmp_name ":MOVABLE" in_frame_clause
                                                          "          = TRUE".
            IF x_U._POPUP-RECID NE ? THEN DO:
               FIND xx_U WHERE RECID(xx_U) = x_U._POPUP-RECID.
               PUT STREAM P_4GL UNFORMATTED SKIP
                "       " tmp_name ":POPUP-MENU" in_frame_clause
                                                    "       = MENU " xx_U._NAME
                ":HANDLE".
            END.
            IF _F._READ-ONLY THEN PUT STREAM P_4GL UNFORMATTED SKIP
                "       " tmp_name ":READ-ONLY" in_frame_clause 
                                                          "        = TRUE".
            IF x_U._RESIZABLE THEN PUT STREAM P_4GL UNFORMATTED SKIP
                "       " tmp_name ":RESIZABLE" in_frame_clause "        = TRUE".
            IF x_U._PRIVATE-DATA NE "" THEN DO:
              tmp_string = "~"" + x_U._PRIVATE-DATA + "~"".
              IF x_U._PRIVATE-DATA-ATTR NE "" AND x_U._PRIVATE-DATA-ATTR NE ? THEN
              tmp_string = tmp_string + ":":U + x_U._PRIVATE-DATA-ATTR.
              PUT STREAM P_4GL UNFORMATTED SKIP
                "       " tmp_name ":PRIVATE-DATA" in_frame_clause  "     = " SKIP
                "                " tmp_string.
            END.        
            IF (x_U._DBNAME NE ? AND x_U._DROP-TARGET) THEN PUT STREAM P_4GL UNFORMATTED SKIP
                "       " tmp_name ":DROP-TARGET" in_frame_clause     
                                                            "      = TRUE".
            /* Assignment of help must be generated for local CLOB data fields.  When the 
               table is RowObject (SDO data source), the RowObject buffer is used.  Otherwise
               the table and data field name are used. */
            IF x_U._HELP-SOURCE = "D":U AND _F._SOURCE-DATA-TYPE = "CLOB":U THEN
            DO:
              PUT STREAM P_4GL UNFORMATTED SKIP
                "       " tmp_name ":HELP" in_frame_clause "             = " SKIP.
              IF x_U._TABLE = "RowObject":U THEN 
                PUT STREAM P_4GL UNFORMATTED    
                  "                BUFFER RowObject:BUFFER-FIELD('" x_U._NAME "'):HELP". 
              ELSE 
                PUT STREAM P_4GL UNFORMATTED    
                  "                BUFFER " x_U._TABLE ":BUFFER-FIELD('" x_U._NAME "'):HELP".
            END.  /* if clob help */
            PUT STREAM P_4GL UNFORMATTED "." SKIP (1).
          END.
        END.  /* If not a BROWSE */
        
        ELSE DO:  /* A browse */  
          FIND x_C WHERE RECID(x_C) = x_U._x-recid.
          FIND x_Q WHERE RECID(x_Q) = x_C._q-recid.
          FIND x_L WHERE x_L._u-recid = RECID(x_U) AND x_L._LO-NAME = "Master Layout".
          /* Is this widget special or unusual */
          IF (NOT x_U._DISPLAY OR NOT x_U._ENABLE  OR x_U._ALIGN NE "L" OR
              x_U._User-List[1] OR x_U._User-List[2] OR x_U._User-List[3] OR
              x_U._User-List[4] OR x_U._User-List[5] OR x_U._User-List[6]) AND
             (CAN-FIND(FIRST _BC WHERE _BC._x-recid = RECID(x_U)) OR
              CAN-FIND(_TRG WHERE _TRG._wRECID = RECID(x_U) AND
                                  _TRG._tEVENT = "OPEN_QUERY":U) OR
              x_U._POPUP-RECID NE ?)
          THEN DO:
            ASSIGN 
              tmp_string = "   " 
                         + (IF NOT x_U._DISPLAY THEN "NO-DISPLAY " ELSE "")
                         + (IF NOT x_U._ENABLE THEN "NO-ENABLE " ELSE "")
                         + (IF x_U._ALIGN NE "L" THEN "ALIGN-" + x_U._ALIGN + " " ELSE "")
                         + (IF x_U._User-List[1] THEN "1 " ELSE "")
                         + (IF x_U._User-List[2] THEN "2 " ELSE "")
                         + (IF x_U._User-List[3] THEN "3 " ELSE "")
                         + (IF x_U._User-List[4] THEN "4 " ELSE "")
                         + (IF x_U._User-List[5] THEN "5 " ELSE "")
                         + (IF x_U._User-List[6] THEN "6 " ELSE "")
                         .
            IF LENGTH(tmp_string,"CHARACTER":U) < 72
            THEN tmp_string = tmp_string + FILL(" ", 72 - LENGTH(tmp_string,"CHARACTER":U)).  
            PUT STREAM P_4GL UNFORMATTED
                "/* SETTINGS FOR " x_U._TYPE " " x_U._NAME " IN FRAME " _U._NAME
                SKIP tmp_string "*/" SKIP.
          END.  /* If a comment is needed */
          IF (x_U._HIDDEN                 OR  x_U._MANUAL-HIGHLIGHT             OR
              x_U._SELECTABLE             OR  x_U._SELECTED                     OR  
              x_U._MOVABLE                OR  x_U._POPUP-RECID NE ?             OR   
              x_U._RESIZABLE              OR  x_C._MAX-DATA-GUESS <> 100        OR   
              x_C._NUM-LOCKED-COLUMNS > 0 OR  x_U._PRIVATE-DATA NE ""           OR
              x_C._COLUMN-RESIZABLE       OR  x_C._COLUMN-MOVABLE               OR
              x_L._REMOVE-FROM-LAYOUT     OR  x_C._ROW-RESIZABLE)               OR
              x_L._SEPARATOR-FGCOLOR NE ? OR
              x_C._COLUMN-SEARCHING       AND
                (CAN-FIND(FIRST _BC WHERE _BC._x-recid = RECID(x_U)) OR
                 CAN-FIND(_TRG WHERE _TRG._wRECID = RECID(x_U) AND
                                     _TRG._tEVENT = "OPEN_QUERY":U) OR
                 x_U._POPUP-RECID NE ?)

          THEN DO:
            PUT STREAM P_4GL UNFORMATTED "ASSIGN ".
            IF x_U._HIDDEN THEN PUT STREAM P_4GL UNFORMATTED SKIP
                "       " x_U._NAME ":HIDDEN  IN FRAME " _U._NAME
                                    "                = TRUE".
            IF x_U._MANUAL-HIGHLIGHT THEN PUT STREAM P_4GL UNFORMATTED SKIP
                "       " x_U._NAME ":MANUAL-HIGHLIGHT IN FRAME " _U._NAME
                                    "       = TRUE".
            IF x_U._SELECTABLE THEN PUT STREAM P_4GL UNFORMATTED SKIP
                "       " x_U._NAME ":SELECTABLE IN FRAME " _U._NAME
                                    "             = TRUE".
            IF x_U._SELECTED THEN PUT STREAM P_4GL UNFORMATTED SKIP
                "       " x_U._NAME ":SELECTED IN FRAME " _U._NAME
                                    "               = TRUE".
            IF x_U._MOVABLE THEN PUT STREAM P_4GL UNFORMATTED SKIP
                "       " x_U._NAME ":MOVABLE IN FRAME " _U._NAME
                                    "                = TRUE".
            IF x_U._POPUP-RECID NE ? THEN DO:
              FIND xx_U WHERE RECID(xx_U) = x_U._POPUP-RECID.
              PUT STREAM P_4GL UNFORMATTED SKIP
                "       " x_U._NAME ":POPUP-MENU IN FRAME " _U._NAME
                                   "             = MENU " xx_U._NAME ":HANDLE".
            END.
            IF x_L._REMOVE-FROM-LAYOUT THEN PUT STREAM P_4GL UNFORMATTED SKIP
                "       " x_U._NAME ":VISIBLE IN FRAME " _U._NAME
                                    "                = FALSE".
            IF x_U._RESIZABLE THEN PUT STREAM P_4GL UNFORMATTED SKIP
                "       " x_U._NAME ":RESIZABLE IN FRAME " _U._NAME
                                    "              = TRUE". 
            IF x_C._NUM-LOCKED-COLUMNS > 0 THEN PUT STREAM P_4GL UNFORMATTED SKIP 
                "       " x_U._NAME ":NUM-LOCKED-COLUMNS IN FRAME " _U._NAME 
                                    "     = " x_C._NUM-LOCKED-COLUMNS.
            IF x_C._MAX-DATA-GUESS <> 100 THEN PUT STREAM P_4GL UNFORMATTED SKIP
                "       " x_U._NAME ":MAX-DATA-GUESS IN FRAME " _U._NAME 
                                    "         = " x_C._MAX-DATA-GUESS. 
            IF x_U._PRIVATE-DATA NE "" THEN DO:
              tmp_string = "~"" + x_U._PRIVATE-DATA + "~"".
              IF x_U._PRIVATE-DATA-ATTR NE "" AND x_U._PRIVATE-DATA-ATTR NE ? THEN
              tmp_string = tmp_string + ":":U + x_U._PRIVATE-DATA-ATTR.
              PUT STREAM P_4GL UNFORMATTED SKIP
                "       " x_U._NAME ":PRIVATE-DATA IN FRAME " _U._NAME "           = " SKIP
                "                " tmp_string.
            END.    
            IF x_C._COLUMN-SEARCHING THEN
              PUT STREAM P_4GL UNFORMATTED SKIP
                "       " x_U._NAME ":ALLOW-COLUMN-SEARCHING IN FRAME " _U._NAME " = TRUE".    
            IF x_C._COLUMN-RESIZABLE THEN
              PUT STREAM P_4GL UNFORMATTED SKIP 
                "       " x_U._NAME ":COLUMN-RESIZABLE IN FRAME " _U._NAME "       = TRUE".
            IF x_C._COLUMN-MOVABLE THEN
              PUT STREAM P_4GL UNFORMATTED SKIP 
                "       " x_U._NAME ":COLUMN-MOVABLE IN FRAME " _U._NAME "         = TRUE".
            IF x_C._ROW-RESIZABLE THEN
              PUT STREAM P_4GL UNFORMATTED SKIP 
                "       " x_U._NAME ":ROW-RESIZABLE IN FRAME " _U._NAME "          = TRUE".
            IF x_L._SEPARATOR-FGCOLOR NE ? THEN
              PUT STREAM P_4GL UNFORMATTED SKIP
                "       " x_U._NAME ":SEPARATOR-FGCOLOR IN FRAME " _U._NAME "      = " x_L._SEPARATOR-FGCOLOR.
            PUT STREAM P_4GL UNFORMATTED "." SKIP (1).
          END.

          lFirstColRun = TRUE.
          FOR EACH _BC WHERE _BC._x-recid = RECID(x_U):
            IF NOT _BC._VISIBLE OR _BC._AUTO-RESIZE OR _BC._COLUMN-READ-ONLY THEN DO:
              IF lFirstColRun THEN PUT STREAM P_4GL UNFORMATTED "ASSIGN ".
              lFirstColRun = FALSE.
              IF NOT _BC._VISIBLE THEN DO:
                IF LOOKUP("@":U, _BC._DISP-NAME, " ":U) > 0 THEN
                  PUT STREAM P_4GL UNFORMATTED SKIP
                    "       " TRIM(ENTRY(2, _BC._DISP-NAME, "@":U)) + ":VISIBLE IN BROWSE " x_U._NAME " = FALSE". 
                ELSE 
                  PUT STREAM P_4GL UNFORMATTED SKIP
                    "       " _BC._TABLE + ".":U + _BC._NAME + ":VISIBLE IN BROWSE " x_U._NAME " = FALSE".
              END.  /* if not visible */
              IF _BC._AUTO-RESIZE THEN 
                PUT STREAM P_4GL UNFORMATTED SKIP
                  "       " _BC._TABLE + ".":U + _BC._NAME + ":AUTO-RESIZE IN BROWSE " x_U._NAME " = TRUE".
              IF _BC._COLUMN-READ-ONLY THEN 
                PUT STREAM P_4GL UNFORMATTED SKIP
                  "       " _BC._TABLE + ".":U + _BC._NAME + ":COLUMN-READ-ONLY IN BROWSE " x_U._NAME " = TRUE".
            END.  /* if not visible or auto-resize or col-read-only */  
          END.  /* for each _BC */ 
          IF NOT lFirstColRun THEN PUT STREAM P_4GL UNFORMATTED "." SKIP (1).
        END.  /* IF a BROWSE */
      END.  /* End of field level attributes */
      /* Now do text widgets */
      FOR EACH x_U WHERE x_U._WINDOW-HANDLE = _h_win AND
                         x_U._PARENT = frame_layer AND
                         x_U._STATUS = u_status AND
                         x_U._TYPE   = "TEXT" AND 
                         x_U._l-recid = ?,
           EACH _F WHERE RECID(_F) = x_U._x-recid,
           EACH x_L WHERE x_L._u-recid = RECID(x_U) AND x_L._LO-NAME = "Master Layout"
           BY x_L._ROW BY x_L._COL BY _F._INITIAL-DATA:

        IF x_U._ALIGN = "R" THEN DO:  /* For now only do right-alignment */
          /* Force dimensions to PPU's for this comment */
          ASSIGN l_dummy          = x_U._LAYOUT-UNIT
                 x_U._LAYOUT-UNIT = TRUE.
          ASSIGN q_label = REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
                          _F._INITIAL-DATA,"~~","~~~~"), "~"","~~~""), "~\","~~~\"),
                          "~{","~~~{"), "~;","~~~;").
          PUT STREAM P_4GL UNFORMATTED
               "/* SETTINGS FOR TEXT-LITERAL """ q_label """" SKIP.
          stmnt_strt = SEEK(P_4GL).
          RUN put_size (INPUT "          ", INPUT "R-T":U).
          RUN put_position (INPUT " ", INPUT "R-T":U).
          PUT STREAM P_4GL UNFORMATTED FILL(" ",72 - (SEEK(P_4GL) - stmnt_strt)) "*/"
                                       SKIP (1).
          /* Reset Layout-unit */
          x_U._LAYOUT-UNIT = l_dummy.
        END.         
      END.
    END.  /* If there is a widget section */
  END.  /* End of frame loop */

  /* Put out multi-layout case statement if necessary         */
  IF multi-layout THEN RUN adeuib/_genmult.p (INPUT layout-var).

  /* Set the HIDDEN bit on Windows.  We don't need to set it on DIALOG-BOXES because
     they aren't automatically realized when they are defined.  Setting HIDDEN = NO
     would force the visualization of the dialog-box, which would prevent parenting
     it in the Main-Code-Block. */
  FIND _U WHERE _U._HANDLE = _h_win.
  FIND _C WHERE _U._x-recid = RECID(_C).
  IF _U._TYPE eq "WINDOW" AND NOT _C._SUPPRESS-WINDOW
  THEN PUT STREAM P_4GL UNFORMATTED
     "IF SESSION:DISPLAY-TYPE = ~"GUI~":U AND VALID-HANDLE(" _U._NAME ")" SKIP
     "THEN " _U._NAME ":HIDDEN = " _U._HIDDEN "." SKIP (1). 

  IF p_status NE "PREVIEW" THEN
    PUT STREAM P_4GL UNFORMATTED SKIP "/* _RUN-TIME-ATTRIBUTES-END */" SKIP
       "&ANALYZE-RESUME".
       
  PUT STREAM P_4GL UNFORMATTED SKIP (1).
END.  /* If either frame_sect or widget_sect */








