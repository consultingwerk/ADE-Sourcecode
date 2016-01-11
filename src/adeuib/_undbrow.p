/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _undbrow.p

Description: Undelete a BROWSE widget.  This is currently simulated using an
  EDITOR widget in the UIB for TTY mode.  Note that we create a _C record
  instead of a _F record for the editor as the BROWSE is a container widget.

Input Parameters:  uRecId - RecID of object of interest.

Output Parameters: <None>

Author: Ravi-Chandar Ramalingam

Date Created: 27 April 1993

Modified: 09/01/99  jep  Calculated fields with specified data-types are now
                         handled correctly in all cases. Fix for 19990413-002.
          08/04/99  tsm  Dynamic browse creation couldn't handle a blank 
                         label as the last item, added code to change a 
                         _LABEL NULL value to " " so the blank can be handled.
----------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER uRecId AS RECID NO-UNDO.
   
{adeuib/uniwidg.i}
{adeuib/layout.i}
{adeuib/triggers.i}
{adeuib/brwscols.i}
{adeuib/sharvars.i}
{adecomm/adefext.i}

DEFINE BUFFER parent_U FOR _U.
DEFINE BUFFER parent_L FOR _L.

DEFINE VARIABLE col-list      AS CHARACTER                            NO-UNDO.
DEFINE VARIABLE col-handle    AS WIDGET-HANDLE                        NO-UNDO.
DEFINE VARIABLE formt-list    AS CHARACTER                            NO-UNDO.
DEFINE VARIABLE DT-list       AS CHARACTER                            NO-UNDO.
DEFINE VARIABLE explicit-nrm  AS LOGICAL        INITIAL FALSE         NO-UNDO.
DEFINE VARIABLE height-hdl    AS WIDGET-HANDLE                        NO-UNDO.
DEFINE VARIABLE minbrw-height AS DECIMAL                              NO-UNDO.
DEFINE VARIABLE lpreV9        AS LOGICAL                              NO-UNDO.

FIND _U       WHERE RECID(_U)       eq uRecId.
FIND _L       WHERE RECID(_L)       eq _U._lo-recid.
FIND _C       WHERE RECID(_C)       eq _U._x-recid.
FIND parent_U WHERE RECID(parent_U) eq _U._parent-recid.
FIND parent_L WHERE RECID(parent_L) eq parent_U._lo-recid.

ASSIGN _L._WIN-TYPE = parent_L._WIN-TYPE
       _h_frame     = parent_U._HANDLE.

IF _L._WIN-TYPE THEN DO:  /* GUI case --- create and run a persistent proc  */
  /* Generate a persistent procedure that contains triggers and methods     */
  /* necessary for design time manipulations                                */

  FOR EACH _BC WHERE _BC._x-recid = RECID(_U):
    /* Handle calculated fields with unspecified data-types as character fields.
       For non-calculated fields and calculated fields where the data-type is specified,
       use data specified by user as much as possible.
       
       Calculated fields in SDO's and some previous V8 UIB versions of
       regular calculated fields have specified data-types, labels, and formats.
       - jep
    */
    IF _BC._DBNAME = "_<CALC>" AND _BC._DATA-TYPE = ? THEN DO:
      ASSIGN col-list   = col-list + CHR(3) + IF _BC._LABEL NE "" THEN _BC._LABEL ELSE "Calc Fld"
             formt-list = formt-list + CHR(3) + IF _BC._FORMAT NE "" THEN _BC._FORMAT ELSE "X(8)"
             DT-List    = DT-list + CHR(3) + "1".
    END.  /* If a calcualted field with no data-type. */
    ELSE                    /* When label is blank (NULL), we need to use " " instead so that 
                               the last CHR(3) doesn't get stripped off when we TRIM below. - tsm */
      ASSIGN col-list     = col-list + CHR(3) + IF _BC._LABEL NE "" THEN _BC._LABEL ELSE (IF _BC._DBNAME = "_<CALC>" THEN "Calc Fld" ELSE " ")
             formt-list   = formt-list + CHR(3) + IF _BC._FORMAT NE "" THEN STRING(_BC._FORMAT) ELSE "99999999" /* 9's used as format for all data-types. -jep */
             explicit-nrm = IF _BC._ENABLED THEN YES ELSE explicit-nrm
             DT-list      = DT-list + CHR(3) +
                            IF _BC._DATA-TYPE BEGINS "C"           THEN "1"
                            ELSE IF _BC._DATA-TYPE = "DATETIME"    THEN "34"
                            ELSE IF _BC._DATA-TYPE = "DATETIME-TZ" THEN "40"
                            ELSE IF _BC._DATA-TYPE BEGINS "DA"     THEN "2"
                            ELSE IF _BC._DATA-TYPE BEGINS "L"      THEN "3"
                            ELSE IF _BC._DATA-TYPE BEGINS "I"      THEN "4"
                            ELSE IF _BC._DATA-TYPE BEGINS "DE"     THEN "5"
                            ELSE IF _BC._FORMAT BEGINS "X" or
                                    _BC._FORMAT BEGINS "x"         THEN "1"
                            ELSE "5".
  END.  /* FOR EACH _BC */

  /* We may be reading in a pre-Version 9 (pre-dynamic browse) file where the
     browse height is too small, to avoid errors when creating the design
     time dynamic browse we create a browse without setting its height and 
     width.  We then set the width and check the minimum height and if the 
     browse height is less than the minimum height we change the height to
     the minimum height and let the user know that we are resizing it.
     We are actually doing this with a browse that is not the design time 
     browse and we delete this browse when we are done checking.  This was 
     done this way with the additional browse to avoid flashing that would 
     occur if we were to set the height and width of the browse after it was
     realized. */
  FIND _P WHERE _P._WINDOW-HANDLE = _U._WINDOW-HANDLE.
  IF _P._file-version BEGINS "UIB_v7" OR _P._file-version BEGINS "UIB_v8" THEN
      lpreV9 = TRUE.
  IF SOURCE-PROCEDURE:FILE-NAME = "adeuib/_rdqury.p" AND lpreV9 and 
     col-list NE ? and formt-list NE ? and DT-list NE ? THEN DO: /* we only want to do this when
                                                                            reading in a preV9 file  */
    CREATE BROWSE height-hdl IN WIDGET-POOL "{&AB_Pool}"
      ASSIGN FRAME = _h_frame                                  
             {adeuib/std_attr.i &NO-FRAME = YES &NO-FONT = YES}
             BROWSE-COLUMN-LABELS     = TRIM(col-list,CHR(3))
             BROWSE-COLUMN-FORMATS    = TRIM(formt-list, CHR(3))
             BROWSE-COLUMN-DATA-TYPES = TRIM(DT-list,CHR(3))
             ROW-MARKERS              = explicit-nrm AND NOT _C._NO-ROW-MARKERS
             ROW-RESIZABLE            = TRUE
             FIT-LAST-COLUMN          = _C._FIT-LAST-COLUMN
             NO-EMPTY-SPACE           = _C._NO-EMPTY-SPACE
             SEPARATORS               = _L._SEPARATORS
             TITLE                    = IF _C._TITLE THEN _U._LABEL ELSE ?
             VISIBLE                  = TRUE
             SENSITIVE                = TRUE
             COLUMN-MOVABLE           = TRUE
             COLUMN-RESIZABLE         = TRUE.

    IF _L._FONT    NE ? THEN height-hdl:FONT    = _L._FONT.

    col-handle = height-hdl:FIRST-COLUMN.
    FOR EACH _BC WHERE _BC._x-recid = RECID(_U) BY _SEQUENCE:
      ON END-RESIZE OF col-handle PERSISTENT RUN adeuib/_adjcols.p (height-hdl).
    /* _col-handle is indexed 
        - split assign to avoid bad state if assign of widget attributes 
          fails due to bad width  - PSC00300460 */
      assign _BC._COL-HANDLE  = col-handle.
      
      assign _BC._WIDTH       = IF _BC._WIDTH EQ 0 THEN col-handle:WIDTH
                                  ELSE _BC._WIDTH
             _BC._DEF-WIDTH   = IF _BC._DEF-WIDTH EQ 0 THEN col-handle:WIDTH
                                  ELSE _BC._DEF-WIDTH
             col-handle:WIDTH = _BC._WIDTH
             col-handle       = col-handle:NEXT-COLUMN.
      IF _BC._LABEL-BGCOLOR NE ? THEN
        _BC._COL-HANDLE:LABEL-BGCOLOR = _BC._LABEL-BGCOLOR.
      IF _BC._LABEL-FGCOLOR NE ? THEN
        _BC._COL-HANDLE:LABEL-FGCOLOR = _BC._LABEL-FGCOLOR.
      IF _BC._LABEL-FONT NE ? THEN
        _BC._COL-HANDLE:LABEL-FONT = _BC._LABEL-FONT.

    END.

    ASSIGN height-hdl:WIDTH = _L._WIDTH * _cur_col_mult
           minbrw-height    = height-hdl:MIN-HEIGHT-CHARS.

    ASSIGN height-hdl:HEIGHT = _L._HEIGHT * _cur_row_mult NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        IF (_L._HEIGHT * _cur_row_mult) < minbrw-height THEN DO:
          MESSAGE _U._NAME "must be at least" minbrw-height
              "characters high.  Resizing..." VIEW-AS ALERT-BOX WARNING BUTTONS OK.
          _L._HEIGHT = minbrw-height / _cur_row_mult.
        END.  /* if height less than min height */
    END.  /* if error */

    DELETE OBJECT height-hdl.
  END.  /* if called from _rdqury */

 IF col-list NE ? and formt-list NE ? and DT-list NE ? THEN DO:
  CREATE BROWSE _U._HANDLE IN WIDGET-POOL "{&AB_Pool}"
    ASSIGN FRAME = _h_frame
           {adeuib/std_attr.i &NO-FRAME = YES &NO-FONT = YES &SIZE-CHAR = YES}
           BROWSE-COLUMN-LABELS     = TRIM(col-list,CHR(3))
           BROWSE-COLUMN-FORMATS    = TRIM(formt-list, CHR(3))
           BROWSE-COLUMN-DATA-TYPES = TRIM(DT-list,CHR(3))
           ROW-MARKERS              = explicit-nrm AND NOT _C._NO-ROW-MARKERS
           ROW-RESIZABLE            = TRUE
           FIT-LAST-COLUMN          = _C._FIT-LAST-COLUMN
           NO-EMPTY-SPACE           = _C._NO-EMPTY-SPACE
           SEPARATORS               = _L._SEPARATORS
           TITLE                    = IF _C._TITLE THEN _U._LABEL ELSE ?
           VISIBLE                  = TRUE
           SENSITIVE                = TRUE
           COLUMN-MOVABLE           = TRUE
           COLUMN-RESIZABLE         = TRUE
       TRIGGERS:
         {adeuib/std_trig.i}
         ON END-ROW-RESIZE PERSISTENT RUN setBrowseRow  IN _h_uib.
       END.

  ASSIGN _U._HANDLE:HEIGHT = _L._HEIGHT * _cur_row_mult.
  IF _C._ROW-HEIGHT NE 0.0 AND _C._ROW-HEIGHT NE ? 
    THEN _U._HANDLE:ROW-HEIGHT = _C._ROW-HEIGHT.
  IF _L._BGCOLOR NE ? THEN _U._HANDLE:BGCOLOR = _L._BGCOLOR.
  IF _L._FGCOLOR NE ? THEN _U._HANDLE:FGCOLOR = _L._FGCOLOR.
  IF _L._SEPARATOR-FGCOLOR NE ? THEN _U._HANDLE:SEPARATOR-FGCOLOR = _L._SEPARATOR-FGCOLOR.
  IF _L._FONT    NE ? THEN _U._HANDLE:FONT    = _L._FONT.
  
  col-handle = _U._HANDLE:FIRST-COLUMN.
  FOR EACH _BC WHERE _BC._x-recid = RECID(_U) BY _SEQUENCE: 
    ON END-RESIZE OF col-handle PERSISTENT RUN adeuib/_adjcols.p (_U._HANDLE).
  /* _col-handle is indexed 
        - split assign to avoid bad state if assign of widget attributes 
          fails due to bad width  - PSC00300460 */
    assign _BC._COL-HANDLE  = col-handle.
    assign _BC._WIDTH       = IF _BC._WIDTH EQ 0 THEN col-handle:WIDTH
                                ELSE _BC._WIDTH
           _BC._DEF-WIDTH   = IF _BC._DEF-WIDTH EQ 0 THEN col-handle:WIDTH
                                ELSE _BC._DEF-WIDTH
           col-handle:WIDTH = _BC._WIDTH
           col-handle       = col-handle:NEXT-COLUMN.
    IF _BC._LABEL-BGCOLOR NE ? THEN 
      _BC._COL-HANDLE:LABEL-BGCOLOR = _BC._LABEL-BGCOLOR.
    IF _BC._LABEL-FGCOLOR NE ? THEN 
      _BC._COL-HANDLE:LABEL-FGCOLOR = _BC._LABEL-FGCOLOR.
    IF _BC._LABEL-FONT NE ? THEN 
      _BC._COL-HANDLE:LABEL-FONT = _BC._LABEL-FONT.
  END.
 END.
END.  /* GUI Case */

ELSE DO:  /* TTY Case -- make an edit widget */
  CREATE EDITOR _U._HANDLE IN WIDGET-POOL "{&AB_Pool}"
      ASSIGN SCROLLBAR-HORIZONTAL = FALSE /* No scrollbar until fixed       */
             WORD-WRAP            = FALSE /* No word wrap */
             READ-ONLY            = TRUE  /* User can't edit in design mode */
             FRAME                = parent_U._HANDLE 
             {adeuib/std_attr.i &SIZE-CHAR = YES
                                &NO-FRAME  = YES
                                &NO-FONT   = YES }       
        TRIGGERS:
             {adeuib/std_trig.i}
        END TRIGGERS.
END.  /* TTY Case */

/* Assign Handles that we now know */
ASSIGN { adeuib/std_uf.i &SECTION = "HANDLES" } .
         
/* Place object within frame boundary. */
{adeuib/onframe.i
   &_whFrameHandle = "parent_U._HANDLE"
   &_whObjHandle   = "_U._HANDLE"
   &_lvHIDDEN      = _L._REMOVE-FROM-LAYOUT}

IF NOT _L._WIN-TYPE THEN DO:  /* Do this for the TTY version only */
  /* Make sure the Universal Widget Record is "correct" by reading the actually
     instantiated values. */
  ASSIGN  {adeuib/std_uf.i &SECTION = "GEOMETRY"} .

  /* Simulate the browse widget contents */
  RUN adeuib/_simbrow.p (uRecId).
END.  /* For TTY only */

/* Restore any triggers that were marked deleted */
/* Note: we don't use rstrtrg.i because we have already defined triggers.i */
FOR EACH _TRG WHERE _TRG._wRECID = uRECID:
  ASSIGN _TRG._STATUS = "NORMAL".
END.




