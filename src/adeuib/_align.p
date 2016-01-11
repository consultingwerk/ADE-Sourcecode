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
/*----------------------------------------------------------------------------

File: _align.p

Description:
    _Align the internally selected objects.  Note that we only align objects
    with the same parent.  Note also that we never align dialog-boxes (these
    are a special case because they are SELECTABLE but they parent to
    themselves.).
    
Input Parameters:
    h_align : Horizontal alignment "LEFT", "CENTER", "RIGHT", "COLON", "C-l-to-r"
                               and "E-l-to-r"
    v_align : Vertical alignment "TOP", "CENTER", "BOTTOM", "C-t-to-b" and "E-t-to-b"

Output Parameters:
   <None>

Author: Wm.T.Wood

Date Created: February 3, 1993

Change History:

11-May-93 D. Lee	Consistency changes for error messages.
----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER h_align   AS CHAR                             NO-UNDO.
DEFINE INPUT PARAMETER v_align   AS CHAR                             NO-UNDO.

{adeuib/_undo.i}     /* UNDO support definitions                            */
{adeuib/uniwidg.i}   /* Universal widget definition                         */
{adeuib/layout.i}    /* Layout temp-table definition                        */
{adeuib/std_dlg.i}   /* Define SKP and other things for dialog-boxes and    */
                     /* alert-boxes                                         */

/* --------------- Local Variables -----------------------*/
DEFINE VAR acnt            AS INTEGER              NO-UNDO.
DEFINE VAR cnt             AS INTEGER              NO-UNDO.
DEFINE VAR min-x           AS INTEGER              NO-UNDO.
DEFINE VAR max-x1          AS INTEGER              NO-UNDO.
DEFINE VAR col-x           AS INTEGER              NO-UNDO.
DEFINE VAR mid-x           AS INTEGER              NO-UNDO.
DEFINE VAR min-y           AS INTEGER              NO-UNDO.
DEFINE VAR max-y1          AS INTEGER              NO-UNDO.
DEFINE VAR mid-y           AS INTEGER              NO-UNDO.
DEFINE VAR max-lbl         AS INTEGER              NO-UNDO.
DEFINE VAR lbl-offset      AS INTEGER              NO-UNDO.
DEFINE VAR h               AS WIDGET               NO-UNDO.
DEFINE VAR h_lbl           AS WIDGET               NO-UNDO.
DEFINE VAR i               AS INTEGER              NO-UNDO.
DEFINE VAR last-pos        AS DECIMAL              NO-UNDO.
DEFINE VAR p_recid         AS RECID                NO-UNDO.
DEFINE VAR row_mult        AS DECIMAL              NO-UNDO.
DEFINE VAR recid-string    AS CHARACTER            NO-UNDO.
DEFINE VAR spacing         AS DECIMAL              NO-UNDO.
DEFINE VAR test            AS INTEGER              NO-UNDO.
DEFINE VAR tot-hgt         AS INTEGER              NO-UNDO.
DEFINE VAR tot-wdth        AS INTEGER              NO-UNDO.

DEFINE BUFFER sync_L FOR _L.

/* Determine that only widgets with a common parent to align.*/
FIND FIRST _U WHERE _U._SELECTEDib NO-ERROR.
IF NOT AVAILABLE _U THEN DO:
  MESSAGE "There are no objects selected.  There is nothing to align."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.
ELSE DO:
  /* Initialize the test variables using the first widget*/
  ASSIGN h       = _U._HANDLE
         min-x   = h:X /* just initializing - don't worry about labels */
         col-x   = h:X 
         max-x1  = h:X + h:WIDTH-PIXELS
         min-y   = h:Y
         max-y1  = h:Y + h:HEIGHT-PIXELS
         max-lbl = 0. /* Maximum label offset */
  /* Now see if we have more than one parent */
  p_recid = _U._parent-recid.
  FIND FIRST _U WHERE _U._SELECTEDib AND _U._parent-recid <> p_recid NO-ERROR.
  IF AVAILABLE _U THEN DO:
    MESSAGE "There are selected objects with different parents." {&SKP}
            "Alignment only works on objects with the same parent."
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN.
  END.
END.

/* Setup to UNDO the align */
CREATE _action.
ASSIGN _undo-start-seq-num = _undo-seq-num
       _action._seq-num    = _undo-seq-num
       _action._operation  = "StartAlign"
       _undo-seq-num       = _undo-seq-num + 1.

/* Get the parent record and compute the row_mult from it */
FIND _U WHERE RECID(_U) = p_recid.
FIND _L WHERE RECID(_L) = _U._lo-recid.
row_mult = _L._ROW-MULT.

/* Update the window-saved field */
RUN adeuib/_winsave.p(_U._WINDOW-HANDLE, FALSE).

IF h_align NE "C-l-to-r" AND v_align NE "C-t-to-b" THEN DO:
  /* Go through all the selected widgets and store the current values */
  /* COMMENTS----------------------------------------------------------------
      (1) The max value of x and y is really the max + 1
          [We take x + width which is really 1 past the edge.]
          However, we are consistent, so we are really ok.]
      (2) When we align to COLON, we are really aligning to the start of
          the fill-in or combo-box.
      (3) Dialog-boxes parent to themselves, so we ignore them.
      ----------------------------------------------------------------------*/
  FOR EACH _U WHERE (_U._SELECTEDib AND RECID(_U) <> p_recid):
    ASSIGN h        = _U._HANDLE
           cnt      = cnt + 1
           tot-wdth = tot-wdth + h:WIDTH-PIXELS
           tot-hgt  = tot-hgt  + h:HEIGHT-PIXELS.
    /* Note we need to get catch fill-ins in order to compute the lable size */
    IF NOT CAN-DO("FILL-IN,COMBO-BOX",_U._TYPE) THEN test = h:X.
    ELSE ASSIGN h_lbl    = h:SIDE-LABEL-HANDLE
                test     = IF h_lbl:VISIBLE AND h_lbl:X > 0 THEN h_lbl:X ELSE h:X
                tot-wdth = tot-wdth + IF h_lbl:VISIBLE AND h_lbl:X > 0
                                      THEN h:X - h_lbl:X ELSE 0.
    /* Text is the minimum (AT X...) position.  If test < h:X then there is
       a label.  Save the maximum label offset. */
    IF test           < min-x     THEN min-x   = test.
    IF (h:X - test)   > max-lbl   THEN max-lbl = (h:X - test).
    IF h:X            < col-x     THEN col-x  = h:X.
    IF h:X + h:WIDTH-P  > max-x1  THEN max-x1 = h:X + h:WIDTH-P.
    IF h:Y            < min-y     THEN min-y  = h:Y.
    IF h:Y + h:HEIGHT-P > max-y1  THEN max-y1 = h:Y + h:HEIGHT-P.
  END.  /* For each selected thing of the parent */

  /* compute the mid-point target values (if necessary) mid = min + max / 2 */
  IF h_align = "CENTER"        THEN mid-x = (min-x + max-x1) / 2.
  ELSE if v_align = "CENTER"   THEN mid-y = (min-y + max-y1) / 2.
  ELSE if h_align = "E-l-to-r" THEN /* Spacing is in PPU's */
    spacing = ((max-x1 - min-x) - tot-wdth) / ((cnt - 1) * SESSION:PIXELS-PER-COLUMN).
  ELSE if v_align = "E-t-to-b" THEN /* Spacing is in PPU's */
    spacing = ((max-y1 - min-y) - tot-hgt) / ((cnt - 1) * SESSION:PIXELS-PER-ROW).

  /* If we are aligning columns, then make sure that the colon-x position is not
     less than the maximum label offset. */
  IF col-x < max-lbl THEN col-x = max-lbl.
END.  /* If not centering  in the frame */

IF (h_align = "E-l-to-r" OR v_align = "E-t-to-b") AND cnt < 3 THEN RETURN.

/* Now align the widgets. */
FOR EACH _U WHERE (_U._SELECTEDib AND RECID(_U) <> p_recid) BY
  IF h_align = "E-l-to-r" THEN _U._HANDLE:X ELSE _U._HANDLE:Y:
  FIND _L WHERE RECID(_L) = _U._lo-recid.
                       
  ASSIGN recid-string = ""
         acnt         = acnt + 1.
  IF _L._LO-NAME = "Master Layout" THEN DO:
    FOR EACH sync_L WHERE sync_L._u-recid =  _L._u-recid AND
                          sync_L._lo-name NE _L._lo-name AND
                          NOT sync_L._CUSTOM-POSITION:
      recid-string    = recid-string + STRING(RECID(sync_L)) + ",".
    END.  /* For each alternative layout */
  END.  /* Only do anything if the master has been changed */

  /* Remember where we were moving from */
  CREATE _action.
  ASSIGN _action._seq-num       = _undo-seq-num
         _action._operation     = "Align"
         _action._u-recid       = RECID(_U)
         _action._window-handle = _U._WINDOW-HANDLE
         _action._data          = STRING(_L._COL) + "|":U + STRING(_L._ROW)
         _action._other_Ls      = recid-string
         _undo-seq-num          = _undo-seq-num + 1.

  h = _U._HANDLE.
  IF h_align <> ? THEN DO:
    CASE h_align:
      WHEN "COLON" THEN h:X = col-x.
      WHEN "RIGHT" 
           THEN h:X = max-x1 - h:WIDTH-P. /* max-x1 includes extra pixel */
      WHEN "LEFT" OR WHEN "CENTER" OR WHEN "C-l-to-r" OR WHEN "E-l-to-r" THEN DO:
        /* We are aligning the left or mid-point. Therefore we need to
            know the width of the widget including the label. */
        IF NOT CAN-DO("FILL-IN,COMBO-BOX",_U._TYPE) THEN lbl-offset = 0.
        ELSE ASSIGN h_lbl      = h:SIDE-LABEL-HANDLE
                    lbl-offset = IF h_lbl:VISIBLE AND h_lbl:X > 0
                                 THEN (h:X - h_lbl:X) ELSE 0.
        IF h_align = "CENTER" THEN
          h:X = mid-x - ((h:WIDTH-PIXELS + lbl-offset) / 2) + lbl-offset.
        ELSE IF h_align = "LEFT" THEN
          h:X = min-x + lbl-offset.
        ELSE IF h_align = "C-l-to-r" THEN
          ASSIGN h:X = ((_U._PARENT:WIDTH-PIXELS - h:WIDTH-PIXELS - lbl-offset) / 2) +
                            lbl-offset
                 _U._ALIGN = "L":U.
        ELSE DO:  /* Must be "E-l-to-r" */
          IF acnt = 1 THEN last-pos = h:COLUMN + h:WIDTH.
          ELSE IF acnt NE cnt THEN
            ASSIGN h:COLUMN      = last-pos + spacing + (lbl-offset / SESSION:PIXELS-PER-COLUMN)
                   last-pos = h:COLUMN + h:WIDTH
                   _U._ALIGN = "L":U.
        END.  /* Else do: --- E-l-to-r */
      END. /* WHEN "LEFT" OR "CENTER" */
    END CASE.
    /* Now record values into universal widget record */
    ASSIGN _L._COL = h:COLUMN.
  END. /* When h_align ne ? */
  ELSE DO:
    CASE v_align:
      WHEN "TOP"      THEN h:Y = min-y.
      WHEN "BOTTOM"   THEN h:Y = max-y1 - h:HEIGHT-PIXELS.
                                        /* max-y1 includes xtra pixel        */
      WHEN "CENTER"   THEN h:Y = mid-y - (h:HEIGHT-PIXELS / 2).
      WHEN "C-t-to-b" THEN
                    h:Y = (_U._PARENT:HEIGHT-PIXELS - h:HEIGHT-PIXELS) / 2.
      WHEN "E-t-to-b" THEN DO:
        IF acnt = 1 THEN last-pos = h:ROW + h:HEIGHT.
        ELSE IF acnt NE cnt THEN
           ASSIGN h:ROW    = last-pos + spacing
                  last-pos = h:ROW + h:HEIGHT.
      END.  /* When E-t-to-b */
    END CASE.
    /* Now record values into universal widget record */
    ASSIGN  _L._ROW = ((h:ROW - 1.0) * row_mult) + 1.0.
  END.
  /* Move any labels on fill-ins. */
  IF CAN-DO("FILL-IN,COMBO-BOX",_U._TYPE) THEN RUN adeuib/_showlbl.p (h).
  IF recid-string ne "" THEN DO i = 1 TO NUM-ENTRIES(recid-string) - 1:
    FIND sync_L WHERE RECID(sync_L) = INTEGER(ENTRY(i,recid-string)).
    ASSIGN sync_L._ROW = _L._ROW
           sync_L._COL = _L._COL.
  END.  /* Only do anything if the master has been changed */
END.

/* Note the end of the UNDO operation */
CREATE _action.
ASSIGN _action._seq-num = _undo-seq-num
       _action._operation = "EndAlign"
       _undo-seq-num = _undo-seq-num + 1
       _action._data = STRING(_undo-start-seq-num)
       _undo-start-seq-num = ?.
ASSIGN _undo-menu-item:LABEL     = "&Undo Align"
       _undo-menu-item:SENSITIVE = TRUE.

