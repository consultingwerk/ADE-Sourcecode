/**********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights*
* reserved.  Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                            *
*                                                                     *
**********************************************************************/

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
    Modified: 05/25/06 fernando   Support for large sequences

----------------------------------------------------------------------------*/

/*----- LEAVE of INCREMENT -----*/
on leave of b_Sequence._Seq-Incr in frame newseq,
      	    b_Sequence._Seq-Incr in frame seqprops
do:
   Define var incr as int64 NO-UNDO.
   Define var incr_i as INT NO-UNDO.

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

   /* s_Large_Seq can be ? for pre-10.1B dbs */
   IF s_Large_Seq NE YES THEN DO:
       /* try to cast it to an int, and display the message generated
          by the client
       */
       ASSIGN incr_i = incr NO-ERROR.

       IF ERROR-STATUS:ERROR THEN DO:
           MESSAGE ERROR-STATUS:GET-MESSAGE(1)
               VIEW-AS ALERT-BOX ERROR BUTTONS OK.
           RETURN NO-APPLY.
       END.
   END.
end.

ON LEAVE OF b_Sequence._Seq-Init in frame newseq,
      	    b_Sequence._Seq-Init in frame seqprops
DO:
   Define var incr as INT NO-UNDO.

   /* s_Large_Seq can be ? for pre-10.1B dbs */
   IF s_Large_Seq NE YES THEN DO:
   
       /* try to cast it to an int, and display the message generated
          by the client
       */
       incr = input {&frame} b_Sequence._Seq-Init NO-ERROR.

       IF ERROR-STATUS:ERROR THEN DO:
           MESSAGE ERROR-STATUS:GET-MESSAGE(1)
               VIEW-AS ALERT-BOX ERROR BUTTONS OK.
           RETURN NO-APPLY.
       END.
   END.
END.

ON LEAVE OF s_Seq_Limit in frame newseq,
      	    s_Seq_Limit in frame seqprops
DO:
   Define var incr as INT NO-UNDO.

   /* s_Large_Seq can be ? for pre-10.1B dbs */
   IF s_Large_Seq NE YES THEN DO:
       /* try to cast it to an int, and display the message generated
          by the client
       */
       ASSIGN incr = input {&frame} s_Seq_Limit NO-ERROR.
    
       IF ERROR-STATUS:ERROR THEN DO:
           MESSAGE ERROR-STATUS:GET-MESSAGE(1)
               VIEW-AS ALERT-BOX ERROR BUTTONS OK.
           RETURN NO-APPLY.
       END.
   END.
END.
