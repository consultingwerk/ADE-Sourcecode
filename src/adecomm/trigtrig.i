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

