/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------
   _guipick.p - flexible 'pick' program - based on _usrpick.p
   
   This supports 6 pick flavors:
      1. Choose 1 with no instructions
      2. Choose 1 with instructions
      3. Choose n where order doesn't matter with no instructions
      4. Choose n where order doesn't matter with instructions
      5. Choose n where order matters w/ SKIP option (no instructions)
      6. Choose n where order matters but w/o SKIP option (no instructions)

   input:
   pik_column - column position of frame   (NOT USED)
   pik_count  - number of elements in list
   pik_down   - iterations of down frame   (NOT USED)
   pik_hide   - hide frame when done?      (NOT USED)
   pik_init   - initial value for cursor   (NOT USED)
   pik_list   - list of elements       
   pik_multi  - can pick multiple?     
   pik_number - number the elements?       (only with pik_multi)
   pik_row    - row position of frame             (NOT USED)
   pik_skip   - use 'skip number' option   (only with pik_number)
   pik_title  - title of frame             (spaces prepended and appended)
   pik_wide   - use wide list              (NOT SUPPORTED)
   pik_text   - instructional text or ?

   output:
   pik_chosen - list of chosen element ids (i.e., array indexes)
   pik_first  - first element out or ?     (same as pik_list[pik_chosen[1]])
   pik_return - number of elements chosen
   
History
    hutegger    94/04/04    fix multiple selection-problem by first
                            emptying the list and then reinitialize it 
    gfs         94/06/15    Fixed select/unselect problem.
                            94-06-09-051
-------------------------------------------------------------------------*/
{ prodict/user/userhue.i }
{ prodict/user/userpik.i }
{ prodict/user/uservar.i }

/* Frame variables */
define var slist1   as char    NO-UNDO
   view-as SELECTION-LIST SINGLE   inner-chars 41 inner-lines 10
                 SCROLLBAR-V.
define var slist2   as char    NO-UNDO
   view-as SELECTION-LIST MULTIPLE inner-chars 37 inner-lines 12 
                 SCROLLBAR-V NO-DRAG.
define var nextlbl  as char    format "x(7)" NO-UNDO init "Next #:".
/*define var nextnum  as integer format ">>9"  NO-UNDO init 1.*/

define button btn_skip  label "&>".
define button btn_skipd label "&<".

/* Control variables */
define var instruct    as logical         NO-UNDO.  /* display instructions? */
define var ix          as integer         NO-UNDO.  /* generic loop index */
define var widg        as widget-handle NO-UNDO.  /* either slist1 or slist2 */
define var stat        as logical       NO-UNDO.
define var canned      as logical       NO-UNDO init TRUE.
define var last_choice as char          NO-UNDO init "". 
define var item        as char          NO-UNDO. /* select list item */
define var num         as integer       NO-UNDO. /* # value in list entry */

/* This frame is for single or multi-select but without
   the ordering option.  So you just get a straight select list.
*/
FORM
   SKIP({&TFM_WID})
   pik_text at 2 FORMAT "x(400)" 
          VIEW-AS EDITOR INNER-LINES 1 INNER-CHARS 40 SCROLLBAR-VERTICAL
   slist1   at ROW {&TFM_ROW} COLUMN 2 
   {prodict/user/userbtns.i}
   with frame pick 
   NO-LABELS 
   DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel SCROLLABLE
   VIEW-AS DIALOG-BOX THREE-D title pik_title.   

/* This frame is for pick multiple with the ordering option -
   with or without skip option.
*/
FORM
   SKIP({&TFM_WID})
   slist2   at 2 FONT 0  /* fixed font so columns line up */
   {prodict/user/userbtns.i}
   &IF "{&WINDOW-SYSTEM}" begins "MS-WIN" &THEN
      nextlbl  at row 2 col 58 VIEW-AS TEXT SPACE(1) SKIP
      nextnum  at 58 format ">>9" SPACE(1)                SKIP
      btn_skipd at 58 SPACE(1) btn_skip
   &ELSE
      nextlbl  at row 2 col 45 VIEW-AS TEXT SPACE(1) SKIP
      nextnum  at 45 format ">>9" SPACE(1)               SKIP
      btn_skipd at 45 SPACE(1) btn_skip 
   &ENDIF
   with frame pick_ordered 
   NO-LABELS 
   DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
   VIEW-AS DIALOG-BOX title pik_title THREE-D.   

/*===============================Triggers=================================*/

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
/*----- HELP -----*/
on HELP of frame pick
   or CHOOSE of btn_Help in frame pick
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                                               INPUT pik_help,
                                               INPUT ?).
on HELP of frame pick_ordered
   or CHOOSE of btn_Help in frame pick_ordered
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                                               INPUT pik_help,
                                               INPUT ?).
&ENDIF


/*----- GO or OK (frame pick) -----*/
on GO of frame pick
do:
   if slist1:multiple AND slist1:screen-value in frame pick = ? then
   do:
      message "Select at least one item or press Cancel."
                    view-as alert-box error buttons ok.
      return NO-APPLY.
   end.
end.


/*----- GO or OK (frame pick_ordered)-----*/
on GO of frame pick_ordered
do:
   if slist2:screen-value in frame pick_ordered = ? then
   do:
      message "Select at least one item or press Cancel."
                    view-as alert-box error buttons ok.
      return NO-APPLY.
   end.
end.


/*----- CHOOSE of SKIP BUTTON -----*/
on choose of btn_skip in frame pick_ordered
do:
   nextnum = nextnum + 1.
   display nextnum with frame pick_ordered.
end.

/*----- CHOOSE of SKIPD BUTTON -----*/
on choose of btn_skipd in frame pick_ordered
do:
   def var i  as int no-undo.
   def var z  as int no-undo.
   def var zz as int no-undo.
   
   do i = 1 to NUM-ENTRIES(last_choice):
     z = int(substring(entry(i,last_choice),34,-1,"character":U)).
     if z > zz then zz = z.
   end.
   if nextnum > 1 and (slist2:SCREEN-VALUE = ? OR nextnum > zz + 1) then nextnum = nextnum - 1.
   display nextnum with frame pick_ordered.
end.


/*----- LEAVE of NEXTNUM -----*/
on leave of nextnum in frame pick_ordered
   /* just to make it easier to use when we need it. */
   nextnum = INTEGER(SELF:screen-value).


/*----- VALUE-CHANGED of LIST 2 -----*/
on value-changed of slist2 in frame pick_ordered
do:
   define var chosen  as char    NO-UNDO. /* list of selected items */
   define var newitem as char    NO-UNDO. /* new value for item clicked on */
   define var rmvnum  as integer NO-UNDO. /* # value of entry just deselected */
   define var oldcnt  as integer NO-UNDO. /* number selected last time */
   define var newcnt  as integer NO-UNDO. /* number selected now */

   assign
      chosen = SELF:screen-value
      oldcnt = NUM-ENTRIES(last_choice)
      newcnt = NUM-ENTRIES(chosen).
   if oldcnt = ? then oldcnt = 0.      
   if newcnt = ? then newcnt = 0.

   if newcnt > oldcnt then
      /* Item was added to choose - mark it with the next #.  To
               find which one was just selected, see which one doesn't have
               a number appended on the end yet.
      */
      add_number:
      do ix = 1 to newcnt:
         item = ENTRY(ix, chosen).
         num = INTEGER(TRIM(SUBSTR(item,34,-1,"character":U))).

         if num = 0 then
         do: 
            newitem = STRING(item, "x(33)") + STRING(nextnum, ">>9").
            stat = slist2:replace(newitem, item) in frame pick_ordered. 
   
            /* since replace un-selects the item we have to re-establish
               the selection. So add the new guy to the last choice
                     and then reset the widget value.
                  */
            if last_choice = "" OR last_choice = ? then /* gfs mod */
               chosen = newitem.
            else
                chosen = last_choice + "," + newitem.
            assign        /* first clear selected-list to fool deselect- */
              SELF:screen-value in frame pick_ordered = "" /* automatism */
              SELF:screen-value in frame pick_ordered = chosen.
   
            nextnum = nextnum + 1.
                  if pik_skip then
               display nextnum with frame pick_ordered.
                  leave add_number.
         end.
      end.
   else do:
      /* Item was removed from selection.  First we have to find the one
               that was just clicked on.  To do this, run through the old list
               and see which item is no longer in the current chosen list.
               When we find it, remove the number from the select list entry.
      */
      find_clicked:
      do ix = 1 to oldcnt:
         item = ENTRY(ix, last_choice).
               if chosen = ? OR NOT CAN-DO(chosen,item) then 
               do:
                  newitem = SUBSTR(item,1,33,"character":U).
                  stat = slist2:replace(newitem, item) in frame pick_ordered.
                  leave find_clicked.
               end.
      end.

      /* For all still-selected items whose number is higher than
               the one just de-selected, decrement the number.
      */      
      rmvnum = INTEGER(TRIM(SUBSTR(item,34,-1,"character":U))).
      do ix = 1 to newcnt:
         item = ENTRY(ix, chosen).
               num = INTEGER(TRIM(SUBSTR(item,34,-1,"character":U))).
               if num > rmvnum then
               do:
                  num = num - 1.
            newitem = SUBSTR(item,1,33,"character":U) + STRING(num, ">>9").
                  stat = slist2:replace(newitem, item) in frame pick_ordered.
            chosen = replace(chosen,item,newitem).
               end.
      end.
      /* Refresh the choose */
      if chosen <> ? then
               slist2:screen-value in frame pick_ordered = chosen.
      nextnum = nextnum - 1.
      if pik_skip then
               display nextnum with frame pick_ordered.
   end.

   last_choice = chosen.  /* remembers the choose as of now */
end.


/*----- WINDOW-CLOSE ---------*/
ON WINDOW-CLOSE of frame pick
   APPLY "END-ERROR" to frame pick.

ON WINDOW-CLOSE of frame pick_ordered
   APPLY "END-ERROR" to frame pick_ordered.


/*=======================Internal Procedures==============================*/

/*----------------------------------------------------------------------------
Description:
   Given a frame, with an editor widget at the top, figure out the size of
   the editor widget so that it retains its width but takes up as many
   lines as needed (based on embedded ~n characters as line breaks).
   Assume that the editor widget is hidden at the moment, and that if it
   takes up any space at all (i.e. if there's actually any text in it),
   then every other widget in the frame has to move down by however
   high the editor is.

Input Parameters:
   p_Editor   - Widget-handle of fill-in widget at top of frame
   p_Width    - Width to make the editor when the dust settles.
----------------------------------------------------------------------------*/
PROCEDURE AdjustEditor.

DEFINE INPUT parameter p_Editor   AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT parameter p_Width    AS DECIMAL NO-UNDO.

DEFINE VARIABLE framewid AS WIDGET-HANDLE.
DEFINE VARIABLE num-lines AS INTEGER.
DEFINE VARIABLE next-line-break AS INTEGER.
DEFINE VARIABLE playtext AS CHARACTER.
DEFINE VARIABLE fldgrp AS WIDGET-HANDLE.
DEFINE VARIABLE grndchld AS WIDGET-HANDLE.
DEFINE VARIABLE htincr AS DECIMAL.

/*The following variable is used to trick the editor widget into realizing
itself; we need to do this (without actually making the editor visible) in
order to be able to ask it what its new height is: if we ask it before it
gets realized, it returns 0.  Dumb, dumb, dumb*/
DEFINE VARIABLE reallyEgregiousHack AS INTEGER.

playtext = p_Editor:SCREEN-VALUE.


IF playtext = "" OR playtext = ? 
THEN RETURN. /*No work to do*/

ELSE DO:
   ASSIGN
      framewid = p_Editor:FRAME
      num-lines = 1 /*Minimum*/
      next-line-break = INDEX(playtext, "~n").

   DO WHILE (next-line-break <> 0):
      ASSIGN
         num-lines =  num-lines + 1
         playtext = SUBSTRING(playtext, next-line-break,-1,"character":U).
      IF (playtext = "~n")
      THEN next-line-break = 0. /*Strange case with ~n at end of text*/
      ELSE ASSIGN
          playtext = SUBSTRING(playtext,2,-1,"character":U)
          next-line-break = INDEX(playtext, "~n").
   END.

   IF num-lines > 7 THEN DO: /*Have to turn on scrolling*/
      p_Editor:width = p_Editor:width - 2. /*So scrollbars don't make it too
                                              wide for its frame..yucko*/
      p_Editor:inner-lines = 7.
      &IF "{&WINDOW-SYSTEM}" begins "MS-WIN" &THEN
        framewid:row = 4.  /*original centering no longer valuable; on Motif,
                             this would move the dialog over to the left edge
                               of the screen, so leave as-is*/
      &ENDIF
   END.
   ELSE p_Editor:inner-lines = num-lines.

   ASSIGN
      reallyEgregiousHack = p_Editor:length
      htincr = p_Editor:height + {&VM_WIDG}
      &IF "{&WINDOW-SYSTEM}" begins "MS-WIN" &THEN
                htincr = htincr + .75 /*Need this correction, for some reason*/
      &ENDIF
      framewid:height = framewid:height + htincr
      p_Editor:WIDTH = p_Width.
   
   /*Move every other widget in the frame down*/
   fldgrp = p_Editor:PARENT.
   grndchld = fldgrp:FIRST-CHILD.
   DO WHILE (grndchld <> ?):
      IF (grndchld <> p_Editor)
      THEN grndchld:row = grndchld:row + htincr.
      grndchld = grndchld:NEXT-SIBLING.
   END.
END.
RETURN.
END PROCEDURE.


/*============================Mainline code===============================*/

/* Configure the frame we will use based on the pick options. */
assign
   pik_number  = pik_number AND pik_multi
   instruct    = (pik_text <> ?) AND (pik_text <> "") AND NOT pik_number
   pik_skip    = pik_skip AND pik_number
   nextnum     = 1.

if pik_multi AND NOT pik_number then 
   slist1:MULTIPLE in frame pick = yes.

if pik_number AND NOT pik_skip then
   /* Use frame pick_ordered without the skip stuff */
   assign
      frame pick_ordered:width-chars = slist2:width-chars + 3
      nextlbl:visible in frame pick_ordered = no
      nextnum:visible in frame pick_ordered = no
      btn_skip:visible in frame pick_ordered = no
      btn_skipd:visible in frame pick_ordered = no.
   
/* Fill the select list */
widg = (if pik_number then slist2:HANDLE in frame pick_ordered
                                   else slist1:HANDLE in frame pick). 
do ix = 1 to pik_count:
   stat = widg:add-last(pik_list[ix]).
end.
if NOT pik_multi THEN
   slist1 = slist1:ENTRY(1) in frame pick.

/* Adjust the graphical rectangle and the ok and cancel buttons */
if pik_number then
do:
   {adecomm/okrun.i  
        &FRAME  = "FRAME pick_ordered" 
        &BOX    = "rect_Btns"
        &OK     = "btn_OK" 
        {&CAN_BTN}
        {&HLP_BTN}
   }
end.
else do:
   pik_text:read-only in frame pick = yes.
   IF instruct THEN DO:
       /*Uncover the editor and put the pik_text into it; move everything
         else down to make room.*/
       pik_text:screen-value in frame pick = pik_text.
       RUN AdjustEditor
           (INPUT pik_text:HANDLE in frame pick,
            INPUT slist1:WIDTH in frame pick).
   END.
   {adecomm/okrun.i  
        &FRAME  = "FRAME pick" 
        &BOX    = "rect_Btns"
        &OK     = "btn_OK" 
        {&CAN_BTN}
        {&HLP_BTN}
   }
end.

if pik_skip then
   display nextlbl nextnum with frame pick_ordered.

pik_return = 0.
do ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE:
   if pik_number then
      update slist2
             btn_skip when pik_skip
             btn_skipd when pik_skip
             btn_OK
             btn_Cancel
             {&HLP_BTN_NAME}
             with frame pick_ordered.
   else
      update slist1 pik_text
             btn_OK
             btn_Cancel
             {&HLP_BTN_NAME}
             with frame pick.

   /* Translate selected items (comma delimited list) into array of
      index values.  The items must be in the order they were chosen
      if the number option is used with skipped #s having corresponding 
      values of -1 stored in pik_chosen.  If the number option isn't used
      the 1st n array elements contain the index of the values chosen
      with these indices always in ascending order.
   */
   assign
      last_choice = widg:screen-value
      pik_chosen = -1. 
   do ix = 1 to NUM-ENTRIES(last_choice):
      item = ENTRY(ix, last_choice).
      if pik_number then
        num = INTEGER(TRIM(SUBSTR(item,34,-1,"character":U))).
      else 
        num = ix.
      pik_chosen[num] = widg:LOOKUP(item). /* index of this item */

      /* pik_return may be > than the number chosen if #s were skipped.
               It will be equal to the highest # assigned or the number of 
               items chosen if the number option isn't being used.
      */
      if num > pik_return then pik_return = num.
   end.
   canned = FALSE.
end.
pik_first = (IF pik_return > 0 AND pik_chosen[1] > 0
               then pik_list[pik_chosen[1]] else ?).

if canned then
   user_path = "".

if pik_number then
   hide frame pick_ordered no-pause.
else
   hide frame pick no-pause.
RETURN.






