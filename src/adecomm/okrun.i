/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* PROGRAM: okrun.i
**
** This file is part of a trio: adestds.i okform.i okrun.i.  This file should
** be included to provide the runtime layout for the OK CANCEL bar.  For more 
** information on this, see the document design\ade\misc\sullivan.doc.
**
** PARAMETERS:
** &FRAME    widget name of the frame containing the okform.i
** &BOX      widget name of the rectangle to be used for the background box
** &OK       widget name of the ok button
** &CANCEL   widget name of the cancel button (only need for tty w/ no help btn)
** &OTHER    widget name any intervening buttons (optional)
** &HELP     widget name of the help button
** &FORCEDEF force defines of local variables
*/

/* stdui.i is required for this file */
&IF DEFINED(ADESTDSI) = 0 &THEN
  { adecomm/adestds.i } 
&ENDIF

&IF DEFINED(OKRUN_VARS) = 0 OR "{&FORCEDEF}" = "yes" &THEN
  DEFINE VARIABLE eff_frame_width AS DECIMAL.  /* effective frame width */
  DEFINE VARIABLE vwidget         AS HANDLE.   /* general widget handle */
  &GLOBAL OKRUN_VARS ""
&ENDIF

/* Increase the compile defined frame width by 1 PPU. */
{&FRAME}:WIDTH-CHARS = {&FRAME}:WIDTH-CHARS + {&HFM_WID}. 
eff_frame_width = {&FRAME}:WIDTH-CHARS - 
                  {&FRAME}:BORDER-LEFT-CHARS - 
                  {&FRAME}:BORDER-RIGHT-CHARS.

/* adjust the size of the box */
&IF {&OKBOX} &THEN
  /* adjust the ok box to the width of the frame for Windows */
  vwidget              = {&BOX}:HANDLE IN {&FRAME}.
  vwidget:HEIGHT-CHARS = {&OK}:HEIGHT-CHARS IN {&FRAME} + ({&IVM_OKBOX} * 2).
  vwidget:WIDTH-CHARS  = eff_frame_width - ({&HFM_OKBOX} * 2).
&ENDIF

&IF "{&HELP}" <> "" &THEN
  /* runtime adjust the help button to the right of the frame */
  vwidget        = {&HELP}:HANDLE IN {&FRAME}.
  vwidget:column = eff_frame_width - vwidget:WIDTH-CHARS - {&HFM_OKBOX}.
&ENDIF
&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
  /* Starting in 8.0B, handle TTY this way (jep 2/8/96):
        - Hide HELP button.
        - If only OK or OK-CANCEL, then center them.
        - If OTHER button, then leave all buttons flush left.
  */
    &IF "{&HELP}" <> "" &THEN
      {&HELP}:VISIBLE IN {&FRAME} = NO.
    &ENDIF
    &IF "{&OTHER}" = "" &THEN
      &IF "{&CANCEL}" <> "" &THEN
        {&OK}:COLUMN IN {&Frame}     = (eff_frame_width -
                                       {&OK}:WIDTH-CHARS IN {&FRAME} - 
                                       {&CANCEL}:WIDTH-CHARS IN {&FRAME} - 
                                       {&HM_DBTNG}) / 2.
        {&CANCEL}:COLUMN IN {&FRAME} = {&OK}:COLUMN IN {&FRAME} + 
  	                             {&OK}:WIDTH-CHARS IN {&FRAME} + 
  	                             {&HM_DBTNG}.
      &ELSE
        {&OK}:COLUMN IN {&FRAME}     = (eff_frame_width -
                                       {&OK}:WIDTH-CHARS IN {&FRAME}) / 2.
      &ENDIF
    &ENDIF
&ENDIF

&IF "{&USE-3D}" = "" &THEN
IF NOT {&FRAME}:VISIBLE AND {&FRAME}:THREE-D NE SESSION:THREE-D THEN
  ASSIGN {&FRAME}:THREE-D = IF SESSION:THREE-D THEN TRUE ELSE FALSE.
&ELSEIF "{&USE-3D}" = "YES" &THEN  
  /* Add THREE-D to the static frame definition.  This is preferred to
     setting a run-time value. */
  DEFINE {&FRAME} WITH THREE-D.
&ENDIF

ASSIGN std_fillin_bgcolor = IF SESSION:THREE-D THEN ? ELSE 8.

/*
 * This last section is for RESULTS. We need it as a workaround to insure
 * that the watch cursor, turned on by the Menu Subsystem, gets turned off.
 * This shouldn't affect any other application.
 */
&IF DEFINED(TURN-OFF-CURSOR) &THEN
  RUN adecomm/_setcurs.p ("").
&ENDIF

/* okrun.i - end of file */

