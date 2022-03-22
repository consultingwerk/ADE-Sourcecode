/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: trigtrig.i

Description:
   The standard editing triggers to support the trigger editor in the
   dictionary and the UIB section editor.

   This requires that trigdlg.i be included first which defines the
   standard button widgets such as btn_cut and h_Editor.  But this
   must come after the frame definition.

Arguments:
   &Frame - e.g., "Frame trigedit"

Author: Laura Stern

Date Created: 05/12/93
----------------------------------------------------------------------------*/

/*----- CHOOSE of BUTTON CUT-----*/
on choose of btn_cut in {&Frame}
do:
   apply "entry" to h_Editor.
   run EditCut (h_Editor).
end.

/*----- CHOOSE of BUTTON COPY -----*/
on choose of btn_copy in {&Frame}
do:
   apply "entry" to h_Editor.
   run EditCopy (h_Editor).
end.


/*----- CHOOSE of BUTTON PASTE -----*/
on choose of btn_paste in {&Frame}
do:
   apply "entry" to h_Editor.
   run EditPaste (h_Editor).
end.


/*----- CHOOSE of BUTTON FIND -----*/
on choose of btn_find in {&Frame}
   run FindText (h_Editor).


/*----- CHOOSE of BUTTON FIND NEXT -----*/
on choose of btn_next in {&Frame}
   run FindNext (h_Editor, Find_Criteria).


/*----- CHOOSE of BUTTON FIND PREVIOUS -----*/
on choose of btn_prev in {&Frame}
   run FindPrev (h_Editor, Find_Criteria).


/*----- CHOOSE of BUTTON REPLACE -----*/
on choose of btn_replace in {&Frame}
   run ReplaceText (h_Editor).

