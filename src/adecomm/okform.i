/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* PROGRAM: okform.i
**
** This file is part of a trio: adestds.i okform.i okrun.i.  This file should
** be included at the end of a FORM statement to provide a standardized look
** for the OK CANCEL bar.  For more information on this, see the document
** design\ade\misc\sullivan.doc.
**
** PARAMETERS:
** &BOX      widget name of the rectangle to be used for the background box
** &STATUS   set to yes if a status line appears above the bottom row of buttons
** &OK       widget name of the ok button
** &CANCEL   widget name of the cancel button (optional)
** &OTHER    4GL for any intervening buttons (optional)
** &HELP     widget name of the help button (optional - e.g. for tty)
*/

/* stdui.i is required for this file */
/* this statement chucks core - reported as bug 93-04-30-27 
&IF DEFINED(ADESTDSI) = 0 &THEN
{ adecomm/adestds.i }
&ENDIF
*/

    /* if there is a status area, use a smaller vertical margin */
    &IF "{&STATUS}" = "yes" &THEN
    skip({&VM_WID}) 
    &ELSE
    skip({&VM_WIDG})
    &ENDIF

    /* if there is a Sullivan blue box, place it here.  The box will take
       up .25 PPU of vertical height.  If the box does not exist, then skip
       this height explicitly */
    &IF {&OKBOX} &THEN
    {&BOX} {&AT_OKBOX}
    skip(0)
    &ELSE
    skip({&IVM_OKBOX}) 
    &ENDIF

    /* place the OK, Cancel buttons, then any intervening buttons, followed by
       help */
    {&OK} {&AT_OKBTN}  
    &IF "{&CANCEL}" <> "" &THEN
      space({&HM_DBTN}) {&CANCEL} 
    &ENDIF
    {&OTHER}
    &IF "{&HELP}" <> "" &THEN
      space({&HM_DBTNG}) {&HELP} space({&HFM_OKBOX})
    &ENDIF

    /* if there is an ok box, skip to allow for it below the buttons */
    &IF {&OKBOX} &THEN
    skip({&IVM_OKBOX}) 
    &ENDIF

    /* skip a margin below the box or the buttons */
    skip({&VM_OKBOX})


