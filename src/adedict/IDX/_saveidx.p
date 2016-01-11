/*********************************************************************
* Copyright (C) 2000,2007 by Progress Software Corporation. All rights*
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _saveidx.p

Description:
   Save any changes the user made in the index property window. 

Returns: "error" if the save is not complete for any reason, otherwise "".

Author: Laura Stern

Date Created: 07/14/92

History:
    04/19/96    tomn        Added rowid support for multi-component indexes. 
    12/09/94    gfs         Added check and warning if user wants non-unique index
                            for RECID support.
    08/26/94    gfs         Added Recid index support.
    
    11/16/07    fernando    Support for _aud-audit-data* indexes deactivation

----------------------------------------------------------------------------*/


&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/brwvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared}
{adedict/IDX/idxvar2.i shared}
{adedict/IDX/idxvar.i shared}

Define var oldname   as char CASE-SENSITIVE NO-UNDO.
Define var newname   as char CASE-SENSITIVE NO-UNDO.
Define var active    as logical             NO-UNDO.
Define var answer    as logical 	          NO-UNDO.
Define var no_name   as logical 	          NO-UNDO.
Define var ins_name  as char                NO-UNDO.
Define var nxtname   as char   	          NO-UNDO.
Define var fordb     as logical             NO-UNDO. /* foreign db? y/n */
Define var warnmsg   as character           NO-UNDO.
Define var warnflg   as char                NO-UNDO.
Define var choice    as logical init no     NO-UNDO.
Define var l_ifldcnt as integer             NO-UNDO.

DEFINE BUFFER bfr_Index FOR _Index.

current-window = s_win_Idx.

IF s_dbCache_type[s_dbCache_ix] <> "PROGRESS" THEN fordb = yes.
ELSE fordb = no.

if input frame idxprops s_Idx_Primary AND
   b_Index._Wordidx <> 0 AND b_Index._Wordidx <> ? then
do:
   message "An index that is word-indexed" SKIP
           "cannot be the primary index."
   	    view-as ALERT-BOX ERROR  buttons OK.
   return "error".
end.

/* Check if name is blank and return if it is */
run adedict/_blnknam.p
   (INPUT b_Index._Index-Name:HANDLE in frame idxprops,
    INPUT "index", OUTPUT no_name).
if no_name then return "error".

assign
  oldname = b_Index._Index-Name
  newname = input frame idxprops b_Index._Index-Name.

do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
   run adecomm/_setcurs.p ("WAIT").  

   /* Do old/new name check in case name is "default".  If we try to 
      assign it Progress will complain. */
   if oldname <> newname then
      b_Index._Index-Name = newname.
 
   if b_Index._Desc:sensitive in frame idxprops then
      ASSIGN input frame idxprops b_Index._Desc.

   if s_Idx_Primary:sensitive in frame idxprops then
      ASSIGN input frame idxprops s_Idx_Primary.

   ASSIGN input frame idxprops ActRec.
      
  IF NOT fordb THEN ASSIGN 
      active = input frame idxprops ActRec. /* formerly b_Index._Active */

   if b_Index._Unique:sensitive in frame idxprops then
      assign
      	 input frame idxprops b_Index._Unique.

   if s_Idx_Primary then
   do:
      /* Make the index primary.  If it already was, so, it still is. */
      find _File where RECID(_File) = s_TblRecId.
      _File._Prime-Index = RECID(b_Index).
   end.
   
   if NOT active AND b_Index._Active AND NOT fordb then
   do:
      answer = yes.  /* set's yes as default button */
      message "If you make this index inactive, the only way to" SKIP
   	      "to reactivate it is to run proutil." SKIP(1) 
   	      "Are you sure you want to deactivate it?"
   	      view-as ALERT-BOX INFORMATION  buttons YES-NO UPDATE answer.
      if answer then
      	 ASSIGN b_Index._Active = no
      	        ActRec = no.
      else
      	 display ActRec with frame idxprops.  /* resets toggle */
   end.

   IF fordb and substring(b_index._I-Misc2[1],1,1) <> "r" AND 
        INPUT FRAME idxprops ActRec = TRUE THEN
   DO:
      /* user wants to make this a recid index */
      FIND _File OF b_Index.

      assign
        l_ifldcnt = 0
        warnflg   = "nnn"
        warnmsg   = "".

      for each _Index-field of b_Index, _Field of _Index-field:
        /* warn the user if there are concerns about doing this! */
        l_ifldcnt = l_ifldcnt + 1.  /* count index fields */

        IF    b_Index._I-misc2[1]   = "u"
          AND b_Index._Unique       = TRUE
          AND _Field._Mandatory     = TRUE
          AND SUBSTR(warnflg, 1, 1) = "n"  /* hasn't already been set by previous index field */
         THEN ASSIGN
               warnmsg = warnmsg +
                         "The precision or scale of index field allows values incorrect for ROWID-Index."
                         + chr(10)
               SUBSTR(warnflg, 1, 1) = "ynn".
        
        IF b_Index._Unique = FALSE
          AND SUBSTR(warnflg, 2, 1) = "n"  /* hasn't already been set by previous index field */
         THEN ASSIGN
               warnmsg = warnmsg +
                         "This index is not Unique - Your application has to take care of that."
                         + chr(10)
               SUBSTR(warnflg, 2, 1) = "y".

        IF _Field._Mandatory = FALSE
          AND SUBSTR(warnflg, 3, 1) = "n"  /* hasn't already been set by previous index field */
         THEN ASSIGN
               warnmsg = warnmsg +
                         "Index field is not Mandatory - Your application has to take care of that."
                         + chr(10)
               SUBSTR(warnflg, 3, 1) = "y".
      end.  /* for each */        

      ASSIGN
        warnmsg = warnmsg + "Are you sure you want to make this the index for ROWID support?"
        choice  = no.
      MESSAGE warnmsg VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE choice.

      IF choice THEN DO: /* Yes, user wants to do it! */
        FIND FIRST bfr_Index of _File WHERE bfr_Index._I-misc2[1] begins "r" 
          EXCLUSIVE-LOCK NO-ERROR. /* existing Recid index */

        IF s_dbCache_type[s_dbCache_ix] = "ORACLE"
          THEN ASSIGN
                b_Index._I-misc2[1] = "r" + b_Index._I-misc2[1]
                _File._Fil-misc1[4] = _Field._Fld-stoff.
                                   /*----- ODBC -----*/
          ELSE IF l_ifldcnt > 1 OR _Field._For-type <> "INTEGER"
            THEN ASSIGN
                  b_Index._I-misc2[1] = "r" + b_Index._I-misc2[1]
                  _File._Fil-misc1[2] = b_Index._idx-num  /* rowid info */
                  _File._Fil-misc1[1] = ?                 /* recid      */
                  _File._Fil-misc2[3] = ?.                /*  info      */
            ELSE ASSIGN
                  b_Index._I-misc2[1] = "r" + b_Index._I-misc2[1]
                  _File._Fil-misc1[2] = b_Index._idx-num                   /* rowid info */
                  _File._Fil-misc1[1] = _Field._Fld-stoff * -1             /* recid      */
                  _File._Fil-misc2[3] = ( IF    _Field._Fld-misc2[3] <> ?  /*  info      */
                                           THEN _Field._Fld-misc2[3] 
                                           ELSE _Field._For-name ).
        IF AVAILABLE bfr_Index
          THEN ASSIGN
                bfr_Index._I-misc2[1] = substring(bfr_Index._I-misc2[1], 2).
      END.

      ELSE DO: /* user said no, so set it back to off and stay in screen*/
        ASSIGN ActRec = no.
        DISPLAY ActRec WITH FRAME idxprops.
        RUN adecomm/_setcurs.p ("").
        RETURN "error".
      END.
   END.
   
   if oldname <> newname then
   do:
      /* If name was changed change the name in the browse list.
	 If there's more than one index, delete and re-insert to
	 make sure the new name is in alphabetical order.
      */
      if s_lst_Idxs:NUM-ITEMS in frame browse > 1 then
      do:
	 s_Res = s_lst_Idxs:delete(oldname) in frame browse.

      	 /* put name in non-case-sensitive variable for search */
      	 ins_name = newname.  
      	 find FIRST _Index where _Index._File-recid = s_TblRecId AND
     	     	      	      	 _Index._Index-Name > ins_name 
      	    NO-ERROR.

      	 nxtname = (if AVAILABLE _Index then _Index._Index-name else "").
	 run adedict/_newobj.p
	    (INPUT s_lst_Idxs:HANDLE in frame browse,
	     INPUT ins_name,
	     INPUT nxtname,
	     INPUT s_Idxs_Cached,
	     INPUT {&OBJ_IDX}).
      end.
      else do:
      	 /* Change name in place in browse window list. */
      	 {adedict/repname.i
      	    &OldName = oldname
   	    &NewName = newname
   	    &Curr    = s_CurrIdx
      	    &Fill    = s_IdxFill
   	    &List    = s_lst_Idxs}
      end.
   end.
   
   {adedict/setdirty.i &Dirty = "true"}.
   display "Index Modified" @ s_Status with frame idxprops.
   run adecomm/_setcurs.p ("").   
   return "".
end.

run adecomm/_setcurs.p ("").
return "error".

