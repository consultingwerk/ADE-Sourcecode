/*********************************************************************
* Copyright (C) 2008-2014,2020,2022 by Progress Software Corporation. All *
* rights reserved.  Prior versions of this work may contain portions *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _newidx.p

Description:
   Display and handle the add index dialog box and then add the index
   if the user presses OK.

Author: Laura Stern

Date Created: 04/22/92

BIG NOTE: Make sure ANY widget reference is qualified with IN or WITH FRAME idxnew!

          The shared idxprop frame is defined here and has the same objects as idxnew. 
          ANY widget reference that does not explicitly use IN or WITH idxnew will then reference idxprop. 
          This may lead to idxprop being realized here parented to the DD main window. 
          So when clicking on Index Properties after this it will display in main window and 
          hide the frame already there, which again leads to a STOP due to the _dcttran WAIT-FOR 
          now waiting for a hidden widget. (not 100% sure this is the wait-for that fails, 
          but some wait-for will fail if widgets have no frame reference)  
             
History:
        gfs        11/04/94        Fixed problem with sensitive on Asc/Desc
        DLM     03/26/98    Added area support
        DLM     04/20/98    Default _index now has an _index-field associated
                            with it.  Added code to delete fields when the first
                            index is added.
        DLM     06/08/98    Changed s_btn_Idx_Area and s_Lst_Idx_Area as being
                            hidden when adding an index to a dataserver.
                            98-05-20-038 
        DLM     07/14/98    Added _Owner to _file finds
    Mario B 12/28/98    Add s_In_Schema_Area enabling one time notification.
    DLM     05/15/00    Removed warning message if only Schema Area in DB
    DLM     01/30/03    Changed which procedure is called for builiding field
                        list so that a data type can be excluded from the list
                        This needed to be done for LOB support
    KSM        02/26/05    Added warning message for adding "Active" index while 
                        on-line
    fernando 10/03/07   Handle comma on the area name - OE00135682
    fernando 06/26/08 Removed encryption area from list 
    Kberlia  10/29/20 Added Argument in _pro_area_list.p to support default area. 
    tmasood  10/14/22 Removed reference of _isdata.i
----------------------------------------------------------------------------*/


&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/brwvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared}
{adecomm/cbvar.i shared}
{adedict/IDX/idxvar2.i shared}
{adedict/IDX/idxvar.i shared}
{adedict/capab.i}

/* General processing variables */
Define var num_flds   as integer NO-UNDO. /* # of index flds chosen */
Define var max_flds   as integer NO-UNDO. 
Define var capab      as char           NO-UNDO.
Define var all_cnt    as integer NO-UNDO.
Define var added      as logical NO-UNDO INIT no.
Define var numindexes as integer NO-UNDO.
Define var curr_type  as CHARACTER NO-UNDO.
define variable lNoArea as logical no-undo.
define variable LastArea as character no-undo.
define variable lAreaOk as logical no-undo.
define variable hTable  as handle  no-undo.

Define buffer x_File for dictdb._File.

/*=========================Internal Procedures===============================*/

/*-----------------------------------------------------------------
   Remove the selected field name from one list and add it
   to the other.

   Input Parameters:
      p_lst_Add  - Handle of selection list to add the name to.
      p_lst_Rmv  - Handle of selection list to remove name from.
      p_To_Index - True, if the field is being added to the index or
                                false if field is being removed from the index.
------------------------------------------------------------------*/


/* **********************  Internal Procedures  *********************** */
/** fill and display the area  
    @param plShow 
              - true - fill from db and show and select first 
              - false - blank (mt with no default or hp with local true)
              - ?     - "N/A" (foreign db).
*/
procedure FillArea:
    define input parameter plShow as logical no-undo.
    define variable cAreaList as character no-undo.
    define variable cEmpty    as character no-undo. 
    if plShow then 
    do:
       run prodict/pro/_pro_area_list(recid(x_File),{&INVALID_AREAS},s_Idx_Area:DELIMITER in frame newidx,"Index", output cAreaList).
       assign
          s_Idx_Area:list-items in frame newidx = cAreaList
          s_Idx_Area:screen-value in frame newidx = s_Idx_Area:entry(1) in frame newidx 
          numindexes = s_Idx_Area:num-items in frame newidx
          s_Idx_Area:inner-lines in frame newidx = min(numindexes,20).  
          s_Idx_Area:sensitive in frame newidx = true.
    end.
    else do:
        cEmpty = if plShow = false then " " else "N/A".
        assign 
            s_Idx_Area:list-items in frame newidx = cEmpty
            s_Idx_Area:screen-value in frame newidx = cEmpty 
            s_Idx_Area:sensitive in frame newidx = false. 
    end. 
end.    


PROCEDURE Transfer_Name:

Define INPUT parameter p_lst_Add  as widget-handle NO-UNDO.
Define INPUT parameter p_lst_Rmv  as widget-handle NO-UNDO.
Define INPUT parameter p_To_Index as logical       NO-UNDO.

Define var fldname as char    NO-UNDO.
Define var cnt            as integer NO-UNDO.
Define var pos     as integer NO-UNDO.
Define var nxtname as char    NO-UNDO.
Define var ix      as integer NO-UNDO.  /* loop index */

   /* Get the selected name from the "remove list". */
   fldname = p_lst_Rmv:screen-value.

   /* Remove this name from the "remove list" */
   run adecomm/_delitem.p (INPUT p_lst_Rmv, INPUT fldname, OUTPUT cnt).

   if p_To_Index then
   do:
      /* Add ascending/descending marker.  For Word indexes, this 
               isn't relevant 
      */
      fldname = (if input frame newidx s_Idx_Word 
                                then STRING("A", "x(3)")
                                else STRING(input frame newidx s_IdxFld_AscDesc, "x(3)"))
                      + fldname.
      
      /* Index field order is in the order they are added. */
      s_Res = p_lst_Add:ADD-LAST(fldname). 
   end.
   else do:
      /* Remove ascending/descending marker */
      fldname = SUBSTR(fldname, 4, 32).

      /* Insert field back in it's proper place.  Determine the position
               this field took in original field list.  Look from this point
               down in original list until we find an entry that is still in
               the left hand field list.  This is the entry we want to insert
               above.
      */
      pos = LOOKUP(fldname, s_lst_IdxFldChoice:private-data in frame newidx).
      do ix = pos + 1 to all_cnt:
               nxtname = ENTRY(ix, s_lst_IdxFldChoice:private-data in frame newidx).
               if p_lst_Add:LOOKUP(nxtname) <> 0
                  then leave.
      end.      
      if ix > all_cnt then
               s_Res = p_lst_Add:ADD-LAST(fldname). 
      else
               s_Res = p_lst_Add:INSERT(fldname, nxtname).
   end.

   /* Select the fldname value, making sure it's in view. */
   p_lst_Add:screen-value = fldname.
   run adecomm/_scroll.p (INPUT p_lst_Add, INPUT fldname).
end.


/*-----------------------------------------------------------------
   Move an entry down or up in the index fields list.

   Input Parameters:
      p_Incr - Amount to add to the list position to get the new
                     position (either 1 or - 1).
      p_Down - True if moving down, False if moving up.

------------------------------------------------------------------*/
PROCEDURE Move_Entry:

Define INPUT parameter p_Incr as integer       NO-UNDO.
Define INPUT parameter p_Down as logical       NO-UNDO.

Define var lst_flds as widget-handle NO-UNDO.
Define var pos      as integer              NO-UNDO.
Define var fldname  as char                NO-UNDO.

   lst_flds = s_lst_IdxFlds:HANDLE in frame newidx. /* for convenience */

   /* Get the selected name from the list. */
   fldname = lst_flds:screen-value.
   
   /* Get the position of the item to insert in front of.  If moving down
      this will be +1 - actually, we want to insert in front of the one 2
      slots down but that will be only one slot down once this one is 
      removed.  If moving up, this will be -1.        
   */
   pos = lst_flds:LOOKUP(fldname) + p_Incr.

   /* Delete the item */
   s_Res = lst_flds:DELETE(fldname).

   if p_Down AND pos > num_flds - 1 then /* - 1 'cause of item just deleted */
      s_Res = lst_Flds:ADD-LAST(fldname).
   else if NOT p_Down AND pos = 0 then
      s_Res = lst_Flds:ADD-FIRST(fldname).
   else
      s_Res = lst_Flds:INSERT(fldname, lst_Flds:ENTRY(pos)).

   /* Select the fldname value, making sure it's in view. */
   lst_Flds:screen-value = fldname.
   run adecomm/_scroll.p (INPUT lst_Flds, INPUT fldname).

   /* Move up and down buttons may need enabling/disabling */
   run Adjust_Move_Btns.
end.


/*-----------------------------------------------------------------
   Adjust the sensitive-ness of the "Move Up" and "Move Down" buttons.
   There must be at least 2 items in the list for these to make
   sense.  Also, if the last item is selected, disable Move Down.
   Similarly, if the first item is selected, disable Move Up.

------------------------------------------------------------------*/
PROCEDURE Adjust_Move_Btns:

Define var val as char NO-UNDO.
  
   val = s_lst_IdxFlds:screen-value in frame newidx.

   s_btn_IdxFldDwn:sensitive in frame newidx = 
      (if num_flds > 1 AND 
       val <> s_lst_IdxFlds:ENTRY(num_flds) in frame newidx then
       yes else no).         
   s_btn_IdxFldUp:sensitive in frame newidx = 
      (if num_flds > 1 AND 
       val <> s_lst_IdxFlds:ENTRY(1) in frame newidx then
       yes else no).         
end.


/*-----------------------------------------------------------------
   Add the currently selected field to the list of index fields.
------------------------------------------------------------------*/
PROCEDURE Add_Field:
   Define var val as char NO-UNDO.

   run Transfer_Name (INPUT s_lst_IdxFlds:HANDLE in frame newidx,
                                   INPUT s_lst_IdxFldChoice:HANDLE in frame newidx,
                                   INPUT true).

   num_flds = num_flds + 1.

   /* Now that we know there's at least one index field, user can
      remove fields or set the asc/desc flag */
   assign
      s_lst_IdxFlds:sensitive in frame newidx = yes
      s_btn_IdxFldRmv:sensitive in frame newidx = yes.

   if NOT input frame newidx s_Idx_Word then
      s_IdxFld_AscDesc:sensitive in frame newidx = yes.

   /* Move-Up and move-down buttons may need enabling/disabling */
   run Adjust_Move_Btns.

   /* Can only support up to max_flds fields in an index.  Also if there's
      no fields left to add, disable add button. */
   if ( num_flds = max_flds OR
        s_lst_IdxFldChoice:NUM-ITEMS in frame newidx = 0) then
      s_btn_IdxFldAdd:sensitive in frame newidx = no.
end.


/*--------------------------------------------------------------------
   Remove the currently selected field from the list of index fields.
---------------------------------------------------------------------*/
PROCEDURE Remove_Field:
   run Transfer_Name (INPUT s_lst_IdxFldChoice:HANDLE in frame newidx,
                                   INPUT s_lst_IdxFlds:HANDLE in frame newidx,
                                   INPUT false).

   num_flds = num_flds - 1.

   if num_flds = 0 then
      assign
               s_lst_IdxFlds:sensitive in frame newidx = no
               s_IdxFld_AscDesc:sensitive in frame newidx = no
               s_btn_IdxFldRmv:sensitive in frame newidx = no.

   /* Move up and down buttons may need enabling/disabling */
   run Adjust_Move_Btns.
   
   if num_flds < max_flds then
      /* Make sure add button is sensitive now. */
      s_btn_IdxFldAdd:sensitive in frame newidx = yes.
end.

procedure ValidateArea:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
     
    define output parameter pok as logical no-undo.
    ASSIGN pok = false.
    if s_idx_Area:screen-value IN FRAME newidx  = "" then
    do:
         message "You must specify an Area for the index"
                   view-as ALERT-BOX ERROR  buttons OK.
         return.    
    end. 
     
    IF NOT s_In_Schema_Area AND numindexes > 1 THEN 
    DO:
        IF s_Idx_Area:screen-value in FRAME newidx  = "Schema Area" THEN 
        DO:
            MESSAGE "Progress Software Corporation does not recommend" SKIP
                  "creating user indices in the Schema Area."  Skip(1)
                  "Should indices be created in this area?" SKIP (1)
                  VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE pok .
            IF pok THEN
                ASSIGN s_In_Schema_Area = TRUE.        
            ELSE DO:
                /* set to true to not ask again - output false */
                ASSIGN s_In_Schema_Area = TRUE.
                RETURN.
            END.
        END.
        ELSE
            ASSIGN pok = TRUE.
    END.
    ELSE IF NOT s_In_Schema_Area AND s_Idx_Area:screen-value in FRAME newidx  = "Schema Area" THEN 
    DO:
      MESSAGE "Progress Software Corporation does not recommend" SKIP
            "creating user indices in the Schema Area. " SKIP (1)
            "See the System Administration Guide on how to" SKIP
            "create other data areas." SKIP (1)
            VIEW-AS ALERT-BOX WARNING.
      ASSIGN s_In_Schema_Area = TRUE
             pok              = TRUE.
    END.  
    ELSE 
       ASSIGN pok = true.      

end procedure.

/*===============================Triggers====================================*/

/*-----WINDOW-CLOSE-----*/
on window-close of frame newidx
   apply "END-ERROR" to frame newidx.


/*----- HIT of OK BUTTON -----*/
on choose of s_btn_OK in frame newidx
   s_OK_Hit = yes.
   /* The GO trigger will fire after this. */


/*----- HIT of ADD (Index) BUTTON or GO -----*/
on GO of frame newidx        /* or Create - because it's auto-go */
/* The GO trigger should never change s_ok_hit to true since it is also fired on Create.*/ 
do:
   Define var fnum           as integer NO-UNDO.
   Define var flds           as char    NO-UNDO.
   Define var name           as char    NO-UNDO.
   Define var id             as recid   NO-UNDO.
   Define var primary         as logical NO-UNDO.
   Define var defname   as char    NO-UNDO.
   Define var wordidx   as logical NO-UNDO.
   Define var answer    as logical NO-UNDO.
   Define var no_name   as logical NO-UNDO.
   Define var ins_name  as char    NO-UNDO.
   Define var is_data   as logical NO-UNDO.
   Define var tmpfile   as char    NO-UNDO.
   Define var xnum_proc as char    NO-UNDO.
   DEFINE VARIABLE lOk  AS LOGICAL NO-UNDO.

   /* If On-Line and index is active */
   IF SESSION:SCHEMA-CHANGE <> "" AND
      SESSION:SCHEMA-CHANGE <> ?  AND
     INPUT FRAME newidx b_Index._Active THEN DO:
     MESSAGE "The Data Dictionary has detected that you are attempting to" SKIP
             "add an ACTIVE index while ON-LINE.  If some other user is"   SKIP
                 "locking the table you are attempting to update, when you"    SKIP
             "commit, your changes may be lost."                           SKIP(1)
             "Do you wish to continue?"
           VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO-CANCEL 
                           TITLE "ON-LINE Index Add" UPDATE lOk.
     IF (lOk = FALSE) THEN RETURN NO-APPLY.
     ELSE IF (lOk = ?) THEN APPLY "WINDOW-CLOSE" TO FRAME newidx.
   END.
   run adedict/_blnknam.p
      (INPUT b_Index._Index-name:HANDLE in frame newidx,
       INPUT "index", OUTPUT no_name).
   if no_name then do:
      s_OK_Hit = no.
      return NO-APPLY.
   end.
   
    
   if num_flds = 0 then
   do:
      message "You must specify at least one field" SKIP
                    "for the index."
               view-as ALERT-BOX ERROR  buttons OK.    
      s_OK_Hit = no.
      return NO-APPLY.
   end.
   
   if not lNoArea then
   do:
       run ValidateArea(output lAreaOk).
       if lAreaOk = no then
           return no-apply.    
   end.
   
   flds = s_lst_IdxFlds:LIST-ITEMS in frame newidx. /* Get all fields in list */

   wordidx = input frame newidx s_Idx_Word.
   if wordidx = yes then
   do:
      if num_flds > 1 then
      do:
         message "An index that is word-indexed" SKIP
                 "can only have one field component" SKIP
                 "(though that may be an array field)."
                  view-as ALERT-BOX ERROR  buttons OK.    
               s_OK_Hit = no.
         return NO-APPLY.
      end.

      /* Since we don't allow primary, unique or abbreviated to be on
               when Word indexed is chosen, or vice versa, we don't need to 
               check that.
      */

      name = SUBSTR(flds, 4, 32).  /* We know now there's only 1 fld */
      
      find dictdb._Field of x_file where dictdb._Field._Field-Name = name.
      if dictdb._Field._Data-Type <> "Character" then
      do:
              message "You can only specify word-indexed when" SKIP
                          "the index contains a character field."
                       view-as ALERT-BOX ERROR  buttons OK.    
                s_OK_Hit = no.
              return NO-APPLY.
      end.       
      assign frame newidx s_Idx_Local.
      if s_Idx_Local then
      do:
          message "You cannot specify a local word-index"  
              view-as ALERT-BOX ERROR  buttons OK.    
          s_OK_Hit = no.
          return NO-APPLY.
      end.
   end.
   else do: /* Word index was not specified */
      do fnum = 1 to num_flds:
             name = SUBSTR(ENTRY(fnum, flds), 4, 32).
             find dictdb._Field of x_file where dictdb._Field._Field-Name = name.
             if dictdb._Field._Extent > 0 then
             do:
                      message "Only a word index can contain an array field."
                   view-as ALERT-BOX ERROR  buttons OK.    
                      s_OK_Hit = no.
                return NO-APPLY.
             end.
      end.

      if input frame newidx s_Idx_Abbrev = yes then
      do:
               /* Get last field specified for the index */
               assign
                  name = s_lst_IdxFlds:ENTRY(num_flds) in frame newidx
            name = SUBSTR(name, 4, 32).
         find dictdb._Field of x_file where dictdb._Field._Field-Name = name.
               if dictdb._Field._Data-Type <> "Character" then
               do:
            message "Abbreviate is an index option that lets you" SKIP
                                 "conveniently search for a partial match based" SKIP
                                 "on the first few characters of a field (like" SKIP
                                 "using BEGINS) in the FIND ...USING statement." SKIP(1)
                                 "This option is only available on indexes that" SKIP
                                 "have a character field as their last index" SKIP
                                 "component."
                     view-as ALERT-BOX ERROR  buttons OK.    
                  s_OK_Hit = no.
            return NO-APPLY.
               end.     
      end.
                      
      if input frame newidx b_Index._Unique = yes AND
               input frame newidx b_Index._Active = yes then
      do:   
               /* Before putting up this horrible message, check to see if
                  there's data in the table.  If there's no data the user 
                  shouldn't need to worry.
               */
               create buffer hTable for table s_CurrTbl no-error.
               assign is_data = false.
               if valid-handle(hTable) then do ON STOP UNDO, LEAVE:
                  hTable:FIND-FIRST() no-error.
                  if hTable:AVAILABLE then
                    assign is_data = true. /* table is committed */
               end.
               /* don't need the dynamic buffer anymore */
               delete object hTable no-error.
               if is_data then
               do:
                  answer = yes.   /* set's yes as default button */
                  message 
                     "If {&PRO_DISPLAY_NAME} finds duplicate values while creating" SKIP
                     "this new unique index, it will UNDO the entire" SKIP
                     "transaction, causing you to lose any schema changes" SKIP
                     "made within the same transaction." SKIP(1)
                     "Recommendations:" SKIP(1)
                     "If you are sure there are no duplicate values OR" SKIP
                     "if you did not make any other schema changes within" SKIP
                     "this transaction, then select OK to add this new" SKIP
                     "unique index." SKIP(1)
                     "Otherwise, select Cancel.  You can then close the" SKIP
                     "dialog, commit the transaction (Edit/Commit from the menu)" SKIP
                     "and then add the index." SKIP(1)
                     "Another alternative is to change the index to inactive," SKIP
                     "and activate it later by running ~"proutil -C idxbuild ~"."
                     view-as ALERT-BOX WARNING buttons OK-CANCEL update answer.
                  if answer = false then
                  do:
                     s_OK_Hit = no.
                     return NO-APPLY.
                  end.
               end.
      end.
      if s_idx_Area:screen-value IN FRAME newidx  = "" then
      do:
          if not lNoArea then 
             message "Yo must specify an Area for the index"
                     view-as ALERT-BOX ERROR  buttons OK.
               s_OK_Hit = no.
               return no-apply.    
      end.
   end.

   do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
      run adecomm/_setcurs.p ("WAIT").
      assign
              b_Index._File-recid = s_TblRecId
              input frame newidx b_Index._Index-name
              input frame newidx b_Index._Unique
              input frame newidx b_Index._Active              
              input frame newidx s_Idx_Local
              input frame newidx b_Index._Desc.
          
      if (x_File._file-Attributes[1] and x_File._file-Attributes[2] = false) 
      OR (x_File._file-Attributes[3] and s_Idx_Local) then
          ASSIGN b_Index._ianum = 0.
      else IF s_idx_Area:screen-value in frame newidx = "N/A"  THEN
          ASSIGN b_Index._ianum = 6.
      ELSE DO:
          FIND dictdb._Area WHERE dictdb._Area._Area-name =  s_idx_Area:screen-value IN FRAME newidx NO-LOCK no-error.
          if not avail dictdb._Area  then
          do:
               message "Area does not exist"
               view-as ALERT-BOX ERROR  buttons OK.
               s_OK_Hit = no.
               return no-apply.    
          end.    
          ASSIGN b_Index._ianum = dictdb._Area._Area-number
                 s_idx_Area = INPUT FRAME newidx s_idx_Area.
      END.

      b_Index._Wordidx = (if wordidx then 1 else ?).
      if x_File._file-Attributes[3] then do:
              if s_Idx_Local then
              b_Index._index-attributes[1] = true.
      end.
      if INDEX(capab, {&CAPAB_GATE_IDXNUM}) > 0 then
      do:
               /* Call gateway specific routine to get index number */
               assign xnum_proc = "prodict/gate/_gatxnum.p".
               run VALUE(xnum_proc) 
                  (INPUT  s_TblRecId, 
                   OUTPUT b_Index._Idx-num).
      end.

      /* Create a record for each index field. */
      do fnum = 1 to num_flds:
               name = SUBSTR(ENTRY(fnum, flds), 4, 32).
               find dictdb._Field of x_File where dictdb._Field._Field-Name = name.

             create dictdb._Index-Field.
               assign
                  dictdb._Index-Field._Index-recid = RECID(b_Index)
                  dictdb._Index-Field._Field-recid = RECID(dictdb._Field)
                  dictdb._Index-Field._Index-seq   = fnum
                  dictdb._Index-Field._Abbreviate  = 
                     (if fnum = num_flds then input frame newidx s_Idx_Abbrev else no)
                  dictdb._Index-Field._Ascending =
                     (if SUBSTR(ENTRY(fnum, flds), 1, 1) = "A" then yes else no).
      end.

      /* We've got a confusing situation here.  Some facts.
               1. If the table that this index belongs to has not been committed
                  to the database then the default index will not have been
                  created yet. x_File.dft-pk (which indicates if there's a
                  default index) will be false.
               2. x_File._Prime-Index will be ? if the table hasn't been committed
                  and the user hasn't already created a primary index.  It could
                  also be ? for some gateways. I don't know what the exact
                  circumstances of this are but it means there's no primary index.
               3. If the table has been committed, there will only be a default
                  index if no other non-word-index has been created.  If there
                  is a default, _dft-pk will be true.
               4. If we are currently creating a non-word index, we want to
                  make it primary if there isn't another primary index already
                  (besides the default).
               
               So: Set primary to yes if we want to make this index the new
               primary index.
      */
      if x_File._Prime-Index = ? AND NOT wordidx then
               primary = yes.
      else if x_File._dft-pk AND NOT wordidx then
      do:
               /* Delete the default index */
               assign
                  id = x_File._Prime-Index  /* recid of default index */
                  primary = yes
                  x_File._dft-pk = false.

               find dictdb._Index where RECID(_Index) = id.
               defname = dictdb._Index._Index-Name.
               FOR EACH dictdb._Index-field WHERE dictdb._Index-field._Index-recid = RECID(dictdb._Index).
                 DELETE dictdb._Index-field.
               end.  
               delete dictdb._Index.
               
               /* Remove the default index from the list in the browse window.  
                  (we don't care about output parm - just use fnum variable) */
               run adecomm/_delitem.p (INPUT s_lst_Idxs:HANDLE in frame browse,
                                                  INPUT defname, OUTPUT fnum). 
      end.
      else
               primary = no.
      
      /* If there is no primary index, or the the user explicitly wants
               this index to be the primary one, set the primary index flag 
               in the _File record. 
      */
      if (primary OR input frame newidx s_Idx_Primary = yes) then
      do:
              x_File._Prime-Index = RECID(b_Index).
                s_Status = " - Made this the primary index".
      end.
      else 
               s_Status = "".
         
      /* Add entry to indexes list in alphabetical order */
      find FIRST dictdb._Index where dictdb._Index._File-recid = s_TblRecId AND
                                               dictdb._Index._Index-Name > b_Index._Index-Name 
         NO-ERROR.

      ins_name = (if AVAILABLE dictdb._Index then dictdb._Index._Index-name else "").
      run adedict/_newobj.p
         (INPUT s_lst_Idxs:HANDLE in frame browse,
          INPUT b_Index._Index-name,
          INPUT ins_name,
          INPUT s_Idxs_Cached,
          INPUT {&OBJ_IDX}).
   
      {adedict/setdirty.i &Dirty = "true"}.
      display "Index Created" + s_Status @ s_Status with frame newidx.
      added = yes.
      run adecomm/_setcurs.p ("").   
      return.
   end.

   /* Only get here if there's an error.  Leave box up and let the user
      fix the problem or Cancel. */
   run adecomm/_setcurs.p ("").   
   s_OK_Hit = no.
   return NO-APPLY.
end.

/*----- HIT of ADD >> (add field) BUTTON -----*/
on choose of s_btn_IdxFldAdd in frame newidx
   run Add_Field.


/*----- DEFAULT-ACTION (DBL-CLICK or RETURN) of FIELD CHOICE LIST -----*/
on default-action of s_lst_IdxFldChoice in frame newidx
   run Add_Field.


/*----- HIT of REMOVE >> (remove field) BUTTON -----*/
on choose of s_btn_IdxFldRmv in frame newidx 
   run Remove_Field.


/*----- HIT of MOVE DOWN BUTTON -----*/
on choose of s_btn_IdxFldDwn in frame newidx 
   run Move_Entry(1, TRUE).


/*----- HIT of MOVE UP BUTTON -----*/
on choose of s_btn_IdxFldUp in frame newidx 
   run Move_Entry(-1, FALSE).


/*----- DEFAULT-ACTION (DBL-CLICK or RETURN) of INDEX FIELD LIST -----*/
on default-action of s_lst_IdxFlds in frame newidx
   run Remove_Field.

/*----- VALUE-CHANGED of Local/Global Button -----*/
on value-changed of s_Idx_Local in frame newidx 
do:
   assign frame newidx s_Idx_Local.
   /* keep track of last choice before emptying */ 
   if s_Idx_Local  then 
      LastArea = s_Idx_Area:screen-value in frame newidx.
   run FillArea(not s_Idx_Local).
   /* Common courtesy - no loss of input when toggling an option that empties choice */
   if not s_Idx_Local and LastArea > "" then
       s_Idx_Area:screen-value in frame newidx = LastArea.
end.

/*----- VALUE-CHANGED of ASC/DESC RADIO SET -----*/
on value-changed of s_IdxFld_AscDesc in frame newidx  
do:
   Define var oldval as char NO-UNDO.
   Define var newval as char NO-UNDO.

   assign
      oldval = s_lst_IdxFlds:screen-value in frame newidx
      newval = STRING(TRIM(SELF:screen-value), "x(3)") + SUBSTR(oldval, 4, 32).

   s_Res = s_lst_IdxFlds:replace(newval, oldval) in frame newidx = no.
   s_lst_IdxFlds:screen-value in frame newidx = newval.  /* reset selection */
end.


/*----- VALUE-CHANGED of INDEX FIELDS LIST -----*/
on value-changed of s_lst_IdxFlds in frame newidx
do:
   /* Reflect ascending/descending value for this entry in radio set. */
   if NOT input frame newidx s_Idx_Word then
      s_IdxFld_AscDesc:screen-value in frame newidx = 
               substr(SELF:screen-value, 1, 1).

   /* Move up and down buttons may need enabling/disabling */
   run Adjust_Move_Btns.
end.


/*----- VALUE-CHANGED of WORD INDEX TOGGLE -----*/
on value-changed of s_Idx_Word in frame newidx
do:
   Define var ix             as integer NO-UNDO.
   Define var sel            as char    NO-UNDO.
   Define var olditem         as char    NO-UNDO.
   Define var newitem         as char    NO-UNDO.

   if SELF:screen-value = "yes" then 
   do:
      /* If user turns word indexing on, turn off primary, unique and
               abbreviated and disable ascending/descending. 
      */
      assign
         s_Idx_Primary:screen-value in frame newidx = "no"
         b_Index._Unique:screen-value in frame newidx = "no"
         s_Idx_Abbrev:screen-value in frame newidx = "no"
               s_IdxFld_AscDesc:screen-value in frame newidx = "A"
               s_IdxFld_AscDesc:sensitive in frame newidx = no.

      /* Also set all the Asc/Desc flags to "A" */
      sel = s_lst_IdxFlds:screen-value in frame newidx.
      do ix = 1 to s_lst_IdxFlds:num-items:
               olditem = s_lst_IdxFlds:entry(ix) in frame newidx.
               if SUBSTR(olditem, 1, 1) = "D" then
               do:
                  assign
                     newitem = olditem
                     SUBSTR(newitem, 1, 1) = "A"
                     s_Res = s_lst_IdxFlds:replace(newitem, olditem) in frame newidx.
                  if olditem = sel then
                     s_lst_IdxFlds:screen-value in frame newidx = newitem.
               end.
      end.
   end.
   else
      /* Enable Asc/Desc if there are any fields in the list */
      if s_lst_IdxFlds:num-items > 0 then 
               s_IdxFld_AscDesc:sensitive in frame newidx = yes.
end.


/*----- VALUE-CHANGED of PRIMARY TOGGLE -----*/
on value-changed of s_Idx_Primary in frame newidx
do:
   /* Primary and word indexed are incompatible */
   if SELF:screen-value = "yes" then do:
      s_Idx_Word:screen-value in frame newidx = "no".
      s_IdxFld_AscDesc:sensitive in frame newidx = yes.
   end.
end.


/*----- VALUE-CHANGED of UNIQUE TOGGLE -----*/
on value-changed of b_Index._Unique in frame newidx
do:
   /* Unique and word indexed are incompatible */
   if SELF:screen-value = "yes" then do:
      s_Idx_Word:screen-value in frame newidx = "no".
      s_IdxFld_AscDesc:sensitive in frame newidx = yes.
   end.
end.


/*----- VALUE-CHANGED of ABBREVIATED TOGGLE -----*/
on value-changed of s_Idx_Abbrev in frame newidx
do:
   /* Abbreviated and word indexed are incompatible */
   if SELF:screen-value = "yes" then do:
      s_Idx_Word:screen-value in frame newidx = "no".
      s_IdxFld_AscDesc:sensitive in frame newidx = yes.
   end.
end.


/*----- HELP -----*/
on HELP of frame newidx OR choose of s_btn_Help in frame newidx
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&Create_Index_Dlg_Box}, ?).


/*============================Mainline code==================================*/
Define var frstfld  as char    NO-UNDO init "".
Define var char_fld as logical NO-UNDO init yes.
Define var cmax     as char    NO-UNDO.
Define var access   as logical NO-UNDO.

/* Check permissions */
find dictdb._File WHERE dictdb._File._File-name =  "_Index"
             AND dictdb._File._Owner = "PUB" NO-LOCK.
if NOT can-do(dictdb._File._Can-create, USERID("DICTDB")) then
do:
   message s_NoPrivMsg "create indexes."
      view-as ALERT-BOX ERROR buttons Ok.
   return.
end.

find dictdb._File WHERE dictdb._File._FIle-name = "_Index-Field"
             AND dictdb._File._Owner = "PUB" NO-LOCK.
if NOT can-do(dictdb._File._Can-create, USERID("DICTDB")) then
do:
   message s_NoPrivMsg "create indexes."
      view-as ALERT-BOX ERROR buttons Ok.
   return.
end.

find dictdb._File where RECID(dictdb._File) = s_TblRecId.
if dictdb._File._Frozen then  
do:
   message "This table is frozen and cannot be modified."
      view-as ALERT-BOX ERROR buttons Ok.
   return.
end.

/* OE00135682 - use other delimiter in case area name has comma */
s_idx_Area:DELIMITER in frame newidx = CHR(1).

/* Set up for filling the list of all fields from the current table */
find x_File where RECID(x_file) = s_TblRecId.

if x_File._Db-lang >= {&TBLTYP_SQL} then
do:
   message "This is a {&PRO_DISPLAY_NAME}/SQL table." SKIP
                 "You must use the CREATE INDEX statement."
           view-as ALERT-BOX ERROR buttons OK.
   return.
end.

find FIRST dictdb._Field of x_File NO-ERROR.
if NOT AVAILABLE dictdb._Field then
do:
   message "You must first create fields for this" SKIP
                 "table before you can create an index."
      view-as ALERT-BOX ERROR  buttons OK.
   return.
end.

/* Get gateway capabilities */
run adedict/_capab.p (INPUT {&CAPAB_IDX}, OUTPUT capab).
if INDEX(capab, {&CAPAB_ADD}) = 0 then
do:
   message "You may not add an index definition for this database type."
      view-as ALERT-BOX ERROR buttons OK.
   return.
end.

/* Set dialog box title to show which table this index will belong to. */
frame newidx:title = "Create Index for Table " + s_CurrTbl.

/* Get the max # of components that can be in the index for this gateway */
run adedict/_capab.p (INPUT {&CAPAB_IDXMAX}, OUTPUT cmax).
max_flds = INTEGER(cmax).

/* Determine if the word indexed and abbreviated fields should be sensitive.
   They will be if there are any character fields in this table. */
find FIRST dictdb._Field of x_File where dictdb._Field._Data-Type = "Character" NO-ERROR.
if NOT AVAILABLE dictdb._Field then
   char_fld = no.

/* Run time layout for button area.  Since this is a shared frame we have 
   to avoid doing this code more than once.
*/
if frame newidx:private-data <> "alive" then
do:
   frame newidx:private-data = "alive".

   {adecomm/okrun.i  
      &FRAME = "frame newidx" 
      &BOX   = "s_rect_Btns"
      &OK    = "s_btn_OK" 
      &HELP  = "s_btn_Help"
   }

   /* So Return doesn't hit default button in editor widget. */
   b_Index._Desc:RETURN-INSERT in frame newidx = yes.
end.

/*
   Explicitly disable based on these conditions in case these were
   sensitive from the last time round.  Then conditionally enable (using
   ENABLE verb) below to make sure the TAB order comes out right.
*/
if NOT (char_fld AND INDEX(capab, {&CAPAB_WORD_INDEX}) > 0) then
   s_Idx_Word:sensitive in frame newidx = no.
if NOT char_fld then
   s_Idx_Abbrev:sensitive in frame newidx = no.

s_Status = "".
display s_Status with frame newidx. /* erases val from the last time */

s_btn_Done:label in frame newidx = "Cancel".
 
enable b_Index._Index-Name
       s_Idx_Local when x_file._file-attributes[3]
       s_idx_Area /* enabled for tab order - will be disabled if necessary below*/   
       b_Index._Desc
       s_Idx_Primary
       b_Index._Active
       b_Index._Unique
       s_Idx_Word     when char_fld AND INDEX(capab, {&CAPAB_WORD_INDEX}) > 0
       s_Idx_Abbrev   when char_fld
       s_lst_IdxFldChoice
       s_btn_IdxFldAdd
       s_btn_OK
       s_btn_Add
       s_btn_Done
       s_btn_Help
       with frame newidx.
       
s_Area_mttext:hidden in frame newidx = true.          
lNoArea = false.  
 s_Idx_Local = false.
/* no area */
IF x_File._For-type <> ? then
do:
    run FillArea(?).
    lNoArea = true.
end.      
else if (x_File._file-Attributes[1] and x_File._file-Attributes[2] = false) OR (x_File._file-Attributes[3]) THEN
do:
    run FillArea(false).
    /* default local to true if partitioned */  
    if x_File._file-Attributes[3] then do:
            s_Idx_Local = true.
    end.
    lNoArea = true.
end.
else do with frame newidx:
   if not x_File._File-Attributes[1] or x_File._File-Attributes[2] then
   do:
       if x_File._File-Attributes[2] then
       do:
           s_Area_mttext:screen-value in frame newidx = "(for default tenant)".
           s_Area_mttext:hidden in frame newidx = false.        
       end.
       run FillArea(true).
   end.
   else do:
       run FillArea(false).
       lNoArea = true. 
   end.       
end.

/* Since we will be enabling/disabling various widgets as the user adds/deletes
   fields from the index, and since we don't want to ENABLE all widgets up
   front (and then immediately disable them), we can't rely on enable to 
   set the TAB order properly.  Reset the tab position for all un-enabled
   widgets which may become sensitized as user users the frame.
*/
assign
/*   s_Res = s_lst_Idx_Area:move-after-tab-item
                     (s_btn_Idx_Area:handle in frame newidx) in frame newidx*/
   s_Res = s_btn_IdxFldRmv:move-after-tab-item 
                     (s_btn_IdxFldAdd:handle in frame newidx) in frame newidx
   s_Res = s_btn_IdxFldDwn:move-after-tab-item 
                     (s_btn_IdxFldRmv:handle in frame newidx) in frame newidx
   s_Res = s_btn_IdxFldUp:move-after-tab-item 
                     (s_btn_IdxFldDwn:handle in frame newidx) in frame newidx
   s_Res = s_lst_IdxFlds:move-after-tab-item 
                     (s_btn_IdxFldUp:handle in frame newidx) in frame newidx
   s_Res = s_IdxFld_AscDesc:move-after-tab-item 
                     (s_lst_IdxFlds:handle in frame newidx) in frame newidx
   .

/* Each add will be a subtransaction */
s_OK_Hit = no.
add_subtran:
repeat ON ERROR UNDO,LEAVE  ON ENDKEY UNDO,LEAVE  ON STOP UNDO, LEAVE:
   /* Do this up top here, to be sure we committed the last create */
   if s_OK_Hit then leave add_subtran.

   if added AND s_btn_Done:label in frame newidx <> "Close" then
      s_btn_Done:label in frame newidx = "Close".

   create b_Index.
   num_flds = 0.

   /* Have to display all fields, so on 2nd or 3rd add, any entered values
      will be cleared. */
   assign
      s_Idx_Primary = no
      b_Index._Active = yes
      b_Index._Unique = no
      s_Idx_Word = no
      s_IdxFld_AscDesc = "A"
      s_Idx_Abbrev = no.

   /* Clear and refill the field list in the appropriate sort order */
   s_lst_IdxFldChoice:LIST-ITEMS in frame newidx = "".
   s_lst_IdxFldChoice:private-data in frame newidx = "".
   run adedict/_getflst.p
      (INPUT   s_lst_IdxFldChoice:HANDLE in frame newidx,
       INPUT   s_TblRecId, 
       INPUT   ?,
       INPUT   (if s_Order_By = {&ORDER_ALPHA} then true else false),
       INPUT   "",
       INPUT   "BLOB,CLOB,XLOB",
       INPUT   0,
       INPUT   "",
       OUTPUT  access).
   if NOT access then undo add_subtran, leave add_subtran.

   assign
      /* Keep a comma separated list of the original contents of this list.
               Keep it in private data since if we put it in a regular variable
               we run out of variable space when the database is very big.  
               Private data is in different data space.
      */
      s_lst_IdxFldChoice:private-data in frame newidx = 
      s_lst_IdxFldChoice:LIST-ITEMS in frame newidx
      all_cnt = NUM-ENTRIES(s_lst_IdxFldChoice:private-data in frame newidx)
      s_lst_IdxFlds:LIST-ITEMS in frame newidx = "" /* clear the list */
   
      /* Reset sensitiveness of widgets */
      s_lst_IdxFlds:sensitive in frame newidx = false
      s_btn_IdxFldAdd:sensitive in frame newidx = true
      s_btn_IdxFldRmv:sensitive in frame newidx = false
      s_btn_IdxFldDwn:sensitive in frame newidx = false
      s_btn_IdxFldUp:sensitive in frame newidx = false.
   
   display "" @ b_Index._Index-Name /* blank instead of ? */          
               s_Idx_Local
                 s_Idx_Primary
                  b_Index._Active
                  b_Index._Unique
                  s_Idx_Word
                 s_Idx_Abbrev
                 s_lst_IdxFldChoice
                 s_lst_IdxFlds
                 s_IdxFld_AscDesc
                  b_Index._Desc
       with frame newidx.

   /* Set selection to first item in list of fields */
   s_lst_IdxFldChoice:screen-value in frame newidx =
   s_lst_IdxFldChoice:entry(1) in frame newidx.

   wait-for choose of s_btn_OK in frame newidx,
                            s_btn_Add in frame newidx OR
                  GO of frame newidx
                  FOCUS b_Index._Index-Name in frame newidx.
end.

/* Reset private data to free memory - it could be big */
s_lst_IdxFldChoice:private-data in frame newidx = "".

hide frame newidx.
return.
 






