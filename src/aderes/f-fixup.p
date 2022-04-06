/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* f-fixup.p 
   This is code that will fixup a frame whose widgets have
   been layout out by Progress.  Progress puts widgets on successive
   rows and on Windows, this leaves no space between them and it looks
   gross.  Add .1 per row, shifting everything proportionally as we go down.

   This changes the actual widget positions on the screen.  The values
   stored in qbf-rcp still reflect the positions without this shift.

   This has to work from a "generated" .p, which means it should run
   outside the results environment.

   Input Parameter:
      hframe - widget handle of the frame we're fixing up.
*/

DEFINE INPUT PARAMETER hframe AS HANDLE NO-UNDO.

DEFINE VARIABLE wid      AS HANDLE   NO-UNDO.
DEFINE VARIABLE frstwid  AS HANDLE   NO-UNDO.
DEFINE VARIABLE maxrow   AS DECIMAL  NO-UNDO INIT 0.
DEFINE VARIABLE wrow     AS DECIMAL  NO-UNDO.
DEFINE VARIABLE maxwid   AS HANDLE   NO-UNDO.
DEFINE VARIABLE rowht    AS DECIMAL	 NO-UNDO.
DEFINE VARIABLE fillht   AS DECIMAL	 NO-UNDO.

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
  &GLOBAL-DEFINE ROW_GAP  .08  /* extra row spacing needed on Windows */
&ELSE
  &GLOBAL-DEFINE ROW_GAP  0 
&ENDIF

/* The frame shouldn't be on the screen yet so we can move the widgets
   and resize the frame at the end.
*/
ASSIGN
  wid = hframe:FIRST-CHILD  /* group */
  wid = wid:FIRST-CHILD     /* first widget */
  frstwid = wid.

/* determine the height of a fill-in for the font used and
   what what we want the row spacing to be.
*/
DO WHILE wid <> ?:
  IF wid:TYPE = "FILL-IN" THEN DO:
    fillht = wid:HEIGHT.
    rowht = fillht + {&ROW_GAP}.
    LEAVE.
  END.
  wid = wid:NEXT-SIBLING.
END.

wid = frstwid.
DO WHILE wid <> ?:
  wrow = wid:ROW.
  IF wrow > maxrow THEN 
    ASSIGN
      maxrow = wrow
      maxwid = wid.
  IF wrow > 1 THEN
    wid:ROW = (INTEGER((wrow - 1) / fillht) * rowht) + 1.
  wid = wid:NEXT-SIBLING.
END.

hframe:HEIGHT = maxwid:ROW + maxwid:HEIGHT + .5.
hframe:VIRTUAL-HEIGHT = hframe:HEIGHT.

/* f-fixup.p - end of file */

