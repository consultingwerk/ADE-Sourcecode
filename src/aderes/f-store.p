/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* f-store.p - Stores some stuff about the form in results' variables
      	       and do other fixup specific to running in results environment.

   1. Save the handles of the main frames.
   2. Store the handles for all the fields in each of
   	  the main frame, the add/update dialog and the qbe frame
   	  and which qbf-rcx array index each corresponds to.
   3. Store the row/col values for all the objects in the
      form layout into the qbf-rcp array based on how Progress
      did the default layout.
   4. Make the objects movable so user can do layout with drag and drop.

   Input Parameters:
      p_sufx   - frame suffix of the frame set (e.g., 1 or 2)
      p_name   - name of the main form frame
      p_h_main - handle of the main form frame
      p_h_dlg  - handle of the corresponding dlg frame
      p_h_qbe  - handle of the corresponding qbe frame
*/

{ aderes/s-define.i }
{ aderes/fbdefine.i } 

DEFINE INPUT PARAMETER p_sufx   AS INTEGER   NO-UNDO. 
DEFINE INPUT PARAMETER p_name   AS CHARACTER NO-UNDO. 
DEFINE INPUT PARAMETER p_h_main AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER p_h_dlg  AS HANDLE    NO-UNDO. /* this may be ? */
DEFINE INPUT PARAMETER p_h_qbe  AS HANDLE    NO-UNDO. 

DEFINE VARIABLE h_main AS HANDLE   NO-UNDO.
DEFINE VARIABLE h_dlg  AS HANDLE   NO-UNDO.
DEFINE VARIABLE h_qbe  AS HANDLE   NO-UNDO.
DEFINE VARIABLE ix     AS INTEGER  NO-UNDO.

/* Store the frame handle for the main frame. */
FIND FIRST qbf-section WHERE qbf-sfrm = p_name.
qbf-section.qbf-shdl = p_h_main.

/* Find the first field level object in each frame */
ASSIGN
  h_main = p_h_main:FIRST-CHILD  /* gives me the field group */
  h_main = h_main:FIRST-CHILD    /* gives me the first object */
  h_qbe  = p_h_qbe:FIRST-CHILD
  h_qbe  = h_qbe:FIRST-CHILD.
   
IF p_h_dlg <> ? THEN
  ASSIGN
    h_dlg  = p_h_dlg:FIRST-CHILD
    h_dlg  = h_dlg:FIRST-CHILD.

/* All the frames will have parallel objects in the same order. They
   will also be in the order in which they were generated so the 
   object order will match the qbf-fwid temp table entries that were
   created when the code was generated.  We can now store the object
   handles there.  If there are multiple frames, pick up at the temp
   table record we left off from last call.  (Fields from different frames
   may be interspersed in the array.)
*/
FIND FIRST qbf-fwid 
  WHERE qbf-fwid.qbf-fwfram = p_sufx AND qbf-fwid.qbf-fwmain = ?. 
qbf-fillht = 0.

DO WHILE h_main <> ?:
  IF h_main:TYPE <> "LITERAL":u AND h_main:TYPE <> "BUTTON" THEN DO:
    ASSIGN
      ix                  = qbf-fwid.qbf-fwix
      qbf-fwid.qbf-fwmain = h_main
      qbf-fwid.qbf-fwdlg  = h_dlg
      qbf-fwid.qbf-fwqbe  = h_qbe
      .

      /* Set the rows and columns by capturing the row and col of each label
         or the object itself, it the object has no side label.
         Also, make the objects movable (only in main frame).
      */
      h_main = h_main:SIDE-LABEL-HANDLE NO-ERROR.
      h_main = (IF h_main = ? THEN qbf-fwid.qbf-fwmain ELSE h_main).

    IF ENTRY({&F_ROW}, qbf-rcp[ix]) = "" OR 
      ENTRY({&F_ROW}, qbf-rcp[ix]) = "0" THEN 
      ASSIGN
        ENTRY({&F_COL}, qbf-rcp[ix]) = 
          STRING({aderes/numtoa.i &num="h_main:COL"})
        ENTRY({&F_ROW}, qbf-rcp[ix]) = 
          STRING({aderes/numtoa.i &num="h_main:ROW"}).
   
    ASSIGN
      h_main              = qbf-fwid.qbf-fwmain /* set to object, not label */
      h_main:SELECTABLE   = TRUE
      h_main:SENSITIVE    = TRUE
      h_main:MOVABLE      = TRUE
      h_main:PRIVATE-DATA = STRING(ix)
      .
      
    ON END-MOVE OF h_main PERSISTENT 
      RUN aderes/f-motion.p.
    ON ANY-PRINTABLE,BACKSPACE,DEL,SHIFT-BACKSPACE,CTRL-BACKSPACE,CTRL-DEL  
       OF h_main PERSISTENT 
      RUN aderes/_anykey.p.
    ON MOUSE-SELECT-DBLCLICK OF h_main PERSISTENT 
      RUN aderes/_dspfunc.p (?, "", "", "RunDirty":u, 
                             "y-format.p,":u + STRING(ix), ?, "").
   
    /* On Windows, the fill-in height of fixed font is not 1!.  Determine 
       the real height so we can set grid properly. 
     */
    IF qbf-fillht = 0 AND h_main:TYPE = "FILL-IN":u THEN
      qbf-fillht = h_main:HEIGHT.

    FIND NEXT qbf-fwid 
      WHERE qbf-fwid.qbf-fwfram = p_sufx AND qbf-fwid.qbf-fwmain = ? NO-ERROR. 
  END.

  h_main = h_main:NEXT-SIBLING.
  /* Main frame has more buttons than dialog frames, so we'll run out of
     objects there sooner.
  */
  IF h_qbe <> ? THEN
    h_qbe  = h_qbe:NEXT-SIBLING.
  IF h_dlg <> ? THEN
    h_dlg = h_dlg:NEXT-SIBLING.
END.

ASSIGN
  p_h_main:GRID-SNAP              = TRUE
  p_h_main:GRID-UNIT-HEIGHT-CHARS = qbf-fillht + {&ROW_GAP}
  p_h_main:GRID-UNIT-WIDTH-CHARS  = 1.

/* Make the frames scrollable so we have the freedom to resize them
   larger than then window and to change their virtual height.
   The scrollbars will only come up if they're needed as long as we keep 
   the height and the virtual height the same.
*/
ASSIGN
  p_h_main:SCROLLABLE = TRUE
  p_h_qbe:SCROLLABLE  = TRUE.
IF p_h_dlg <> ? THEN
  p_h_dlg:SCROLLABLE = TRUE.

/* f-store.p - end of file */ 

