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

File: seqtrig.i

Description:
   Triggers for add or modify Sequence.  This is in an include file so
   that we can have the same code that works on different frames, one for
   the add case and one for the modify case.

Argument:
   {&frame} - then name of the frame that we're working with.  This will be
      	      of the form "frame x".

Author: Laura Stern

Date Created: 02/21/92 
     History: 10/19/99 Added Leave of Limit trigger  DLM

----------------------------------------------------------------------------*/
/*----- LEAVE OF Limit-------*/
ON 'LEAVE':U OF s_Seq_Limit IN FRAME seqprops
DO:
  IF integer(s_Seq_Limit:SCREEN-VALUE) < -2147483648 OR
     INTEGER(s_Seq_Limit:SCREEN-VALUE) > 2147483646 THEN DO: 
      MESSAGE "Limit value must be between " SKIP
              "-2147483648 and 2147483646" SKIP
        VIEW-AS ALERT-BOX ERROR.
      ASSIGN s_Valid = NO.
      RETURN NO-APPLY.
   END.   
END.

/*----- LEAVE of INCREMENT -----*/
on leave of b_Sequence._Seq-Incr in frame newseq,
      	    b_Sequence._Seq-Incr in frame seqprops
do:
   Define var incr as integer NO-UNDO.

   incr = input {&frame} b_Sequence._Seq-Incr.
   if incr = 0 then
   do:
      if NOT s_Adding then current-window = s_win_Seq.
      message "Increment can be negative or positive but not 0."
      	       view-as ALERT-BOX ERROR
      	       buttons OK.
      s_Valid = no.
      return NO-APPLY.
   end.

   if incr < 0 then 
   do:
      /* this check avoids flashing */
      if s_Seq_Limit:label in {&frame} <> "Lower Limit" then
      	 s_Seq_Limit:label in {&frame} = "&Lower Limit".
   end.
   else do: 
      if s_Seq_Limit:label in {&frame} <> "Upper Limit" then 
      	 s_Seq_Limit:label in {&Frame} = "&Upper Limit".
   end.
end.








