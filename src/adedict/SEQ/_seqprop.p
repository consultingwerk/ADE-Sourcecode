/**********************************************************************
* Copyright (C) 2000-2011 by Progress Software Corporation. All rights*
* reserved.  Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                            *
*                                                                     *
**********************************************************************/

/*----------------------------------------------------------------------------

File: _seqprop.p

Description:
   Display the sequence properties for editing.

Author: Laura Stern

Date Created: 02/21/92 
    Modified: 07/14/98 D. McMann Added _Owner to _file finds.
              05/25/06 fernando  Support for 64-bit sequences    
----------------------------------------------------------------------------*/


&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/uivar.i shared}
{adedict/SEQ/seqvar.i shared}
{adedict/capab.i}

Define var capab  AS CHAR NO-UNDO.
DEFINE VAR l       AS LOGICAL   NO-UNDO.
DEFINE VAR cTemp   AS CHARACTER NO-UNDO.
/* 11.0  doesn't care as it canot change an existing sequence... 
define variable lMultitenantdb as logical no-undo.
*/

/*----------------------------Mainline code----------------------------------*/

/* Get the sequence type */
s_Seq_Type = s_DbCache_Type[s_DbCache_ix].  

find dictdb._File WHERE dictdb._File._File-name = "_Sequence"
             AND dictdb._File._Owner = "PUB" NO-LOCK.
             
if NOT can-do(dictdb._File._Can-read, USERID("DICTDB")) then
do:
   message s_NoPrivMsg "see sequence definitions."
      view-as ALERT-BOX ERROR buttons Ok in window s_win_Browse.
   return.
end.
/* 11.0 doesn not care about this (see commented out code below)
lMultitenantdb = can-find(first dictdb._tenant). 
*/
/* Get gateway capabilities */
run adedict/_capab.p (INPUT {&CAPAB_SEQ}, OUTPUT capab).


if LENGTH(capab) = 0 then
do:
   message "Sequences are not supported for this database type."
      view-as ALERT-BOX ERROR buttons OK.
   return.
end.

/* check if this db supports 64-bit sequences. Just care about s_Large_Seq really.
*/
/* dbs running with pre-10.01B servers will have no knowledge of large key entries
   support, so don't need to display message (in which case s_Large_Seq = ?)
*/
IF s_Large_Seq = NO THEN
   ASSIGN s_Large_Seq_info = "** 64-bit sequences support not enabled".
ELSE /* if YES or ? */
   ASSIGN s_Large_Seq_info = "".

/* Don't want Cancel if moving to next seq - only when window opens */
if s_win_Seq = ? then
   s_btn_Close:label in frame seqprops = "Cancel".

/* Open the window if necessary */
run adedict/_openwin.p
   (INPUT   	  "Sequence Properties",
    INPUT   	  frame seqprops:HANDLE,
    INPUT         {&OBJ_SEQ},
    INPUT-OUTPUT  s_win_Seq).

/* Run time layout for button area. Since this is a shared frame we 
   have to avoid doing this code more than once.
*/
if frame seqprops:private-data <> "alive" then
do:
   /* okrun.i widens frame by 1 for margin */
   assign
      s_win_Seq:width = s_win_Seq:width + 1
      frame seqprops:private-data = "alive".

   {adecomm/okrun.i  
      &FRAME = "frame seqprops" 
      &BOX   = "s_rect_Btns"
      &OK    = "s_btn_OK" 
      &HELP  = "s_btn_Help"
   }
end.

/* Find the _Sequence record to edit. */
find b_Sequence where b_Sequence._Seq-Name = s_CurrSeq AND 
     b_Sequence._Db-recid = s_DbRecId.

/* Set the limit value to the upper or lower limit depending on if increment
   is positive or negative. */
if b_Sequence._Seq-Incr > 0 then
   assign
      s_Seq_Limit = b_Sequence._Seq-Max
      s_Seq_Limit:label in frame seqprops = "&Upper Limit".
else
   assign
      s_Seq_Limit = b_Sequence._Seq-Min
      s_Seq_Limit:label in frame seqprops = "&Lower Limit".

/* adjust the format if 64-bit sequences support is not turned on, or not
   available (s_large_seq will be ? in that case)
*/
IF s_Large_Seq NE YES THEN DO:
    /* don't resize the fill-in */
    IF s_Seq_Limit:AUTO-RESIZE IN FRAME seqprops THEN
       ASSIGN s_Seq_Limit:AUTO-RESIZE IN FRAME seqprops = NO
              b_Sequence._Seq-Ini:AUTO-RESIZE IN FRAME seqprops = NO
              b_Sequence._Seq-Incr:AUTO-RESIZE IN FRAME seqprops = NO.

    ASSIGN s_Seq_Limit:FORMAT IN FRAME seqprops = "->,>>>,>>>,>>9"
           b_Sequence._Seq-Ini:FORMAT IN FRAME seqprops = "->,>>>,>>>,>>9" 
           b_Sequence._Seq-Incr:FORMAT IN FRAME seqprops = "->,>>>,>>>,>>9".
END.

/* find current value for non multi-tenant Progress db only*/
IF not b_Sequence._Seq-Attributes[1] and INDEX(capab,{&CAPAB_FOR_NAME}) = 0 THEN DO:
   /* if the sequence was just created and not saved yet, the above statement will fail */
   s_Seq_Current_Value = TRIM(STRING(DYNAMIC-CURRENT-VALUE(s_CurrSeq, s_CurrDb),"->,>>>,>>>,>>>,>>>,>>>,>>9")) NO-ERROR.
   IF ERROR-STATUS:ERROR THEN
       s_Seq_Current_Value = "".
END.
ELSE if b_Sequence._Seq-Attributes[1] then
    s_Seq_Current_Value = "<one value per tenant>".
ELSE
    s_Seq_Current_Value = "n/a".

/* Set status line */
display "" @ s_Status s_Large_Seq_info with frame seqprops. /* clears from last time */

s_Seq_ReadOnly = (s_ReadOnly OR s_DB_ReadOnly).
if NOT s_Seq_ReadOnly then
   if NOT can-do(_File._Can-write, USERID("DICTDB")) then
   do:
      display s_NoPrivMsg + " modify sequence definitions." @ s_Status
      	 with frame seqprops.
      s_Seq_ReadOnly = true.
   end.

IF b_Sequence._Seq-misc[6] = ? THEN b_Sequence._Seq-misc[6] = "n/a" .
IF b_Sequence._Seq-misc[7] = ? THEN b_Sequence._Seq-misc[7] = "n/a" .

display b_Sequence._Seq-Name  
        b_Sequence._Seq-Attributes[1]
        b_Sequence._Seq-Init    
        b_Sequence._Seq-Incr
        s_Seq_Limit
        b_Sequence._Cycle-Ok
        b_Sequence._Seq-misc[6]
        b_Sequence._Seq-misc[7] 
        s_Seq_Current_Value
        (IF INDEX(capab,{&CAPAB_OWNER})    = 0 
          then "n/a" else b_Sequence._Seq-misc[2]) @ b_Sequence._Seq-misc[2]
        (IF INDEX(capab,{&CAPAB_FOR_NAME}) = 0 
          then "n/a" else b_Sequence._Seq-misc[1]) @ b_Sequence._Seq-misc[1]
	IF INDEX(s_Seq_Type,"ORACLE") = 0 then "n/a" ELSE IF 
             b_Sequence._Seq-misc[8] = ? THEN "<Local-Db>" ELSE
             b_Sequence._Seq-misc[8] @ b_Sequence._Seq-misc[8]
        
        with frame seqprops.

/* Note: the order of enables will govern the TAB order. */
if s_Seq_ReadOnly then
do:
   disable all except
	  s_btn_Close
	  s_btn_Prev
	  s_btn_Next
	  s_btn_Help
	  with frame seqprops.
   enable s_btn_Close
	  s_btn_Prev
	  s_btn_Next
	  s_btn_Help
	  with frame seqprops.
   apply "entry" to s_btn_Close in frame seqprops.
end.
else do:
   /* This code was added (and worked) before it was decided that v11.0 will not allow making 
      existing sequences multi-tenant 
   disable b_Sequence._Seq-Attributes[1] when not lMultitenantdb 
      or b_Sequence._Seq-Attributes[1]
      with frame seqprops.
   */
   enable b_Sequence._Seq-Name WHEN  INDEX(capab,{&CAPAB_RENAME}) <> 0
/* This line was added (and worked) before it was decided that v11.0 will not allow 
   making existing sequences multi-tenant 
          b_Sequence._Seq-Attributes[1] when lMultitenantdb and not b_Sequence._Seq-Attributes[1]*/
          b_Sequence._Seq-Init WHEN  INDEX(capab,{&CAPAB_MODIFY}) <> 0
          b_Sequence._Seq-Incr WHEN  INDEX(capab,{&CAPAB_MODIFY}) <> 0
	  s_Seq_Limit          WHEN  INDEX(capab,{&CAPAB_MODIFY}) <> 0
	  b_Sequence._Cycle-Ok WHEN  INDEX(capab,{&CAPAB_MODIFY}) <> 0
	  s_btn_OK             WHEN (INDEX(capab,{&CAPAB_MODIFY}) <> 0
	                         OR  INDEX(capab,{&CAPAB_RENAME}) <> 0)	      	  
	  s_btn_Save           WHEN (INDEX(capab,{&CAPAB_MODIFY}) <> 0
	                         OR  INDEX(capab,{&CAPAB_RENAME}) <> 0)	      	  
          s_btn_Close
      	  s_btn_Prev 	      
      	  s_btn_Next
      	  s_btn_Help
	  with frame seqprops.

   apply "entry" to b_Sequence._Seq-Name in frame seqprops.
end.









