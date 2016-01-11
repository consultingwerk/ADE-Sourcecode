/*****************************************************************
* Copyright (C) 2000-2014 by Progress Software Corporation.      *
* All rights reserved.  Prior versions of this work may contain  *
* portions contributed by participants of Possenet.              *
*                                                                *
******************************************************************/

/*----------------------------------------------------------------------------

File: _idxprop.p

Description:
   Set up the index properties window so the user can view or modify the 
   information on an index.  Since this window is non-modal, we just do the
   set up here.  All triggers must be global.

Author: Laura Stern

Date Created: 04/29/92

Last modified on:

08/26/94 by gfs       Added Recid index support.
03/26/98 by D. McMann Added Area support.
04/20/98 by D. McMann Change how we get area name, must use storageobject.
05/14/98 by D. McMann 98-05-13-028 _Idx-num not assigned until committed must
                      use _ianum instead.
08/16/00 D. McMann  Added _db-recid to StorageObject find 20000815029
06/08/06 fernando   Support for large key entries
08/21/06 fernando   Fix can-write check on _Index (20051216-011).
11/16/07 fernando   Support for _aud-audit-data* indexes deactivation
----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES

{adedict/dictvar.i shared}
{adedict/brwvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared}
{adedict/IDX/idxvar2.i shared}
{adedict/IDX/idxvar.i shared}

{adedict/capab.i}
/* include file contains function for area label */
{prodict/pro/arealabel.i}

Define var err 	     as logical NO-UNDO.
Define var capab     as char    NO-UNDO.
Define var frstfld   as char	NO-UNDO init "".
Define var lst_item  as char	NO-UNDO.
Define var name_mod  as logical NO-UNDO. /* name modifiable */
DEFINE VAR idx_mod   as LOGICAL NO-UNDO INIT YES.
DEFINE VAR canAudDeact   as LOGICAL NO-UNDO.
define var CanLocIdx     as logical no-undo.


/*============================Mainline code==================================*/
find dictdb._File WHERE dictdb._file._File-name = "_Index"
             AND dictdb._File._Owner = "PUB" NO-LOCK.
if NOT can-do(dictdb._File._Can-read, USERID("DICTDB")) then
do:
   message s_NoPrivMsg "see index definitions."
      view-as ALERT-BOX ERROR buttons Ok in window s_win_Browse.
   return.
end.
if NOT can-do(dictdb._File._Can-write, USERID("DICTDB")) then
   ASSIGN idx_mod = NO.

find dictdb._File WHERE dictdb._File._File-name = "_Index-Field"
             AND dictdb._File._Owner = "PUB" NO-LOCK.
if NOT can-do(dictdb._File._Can-read, USERID("DICTDB")) then
do:
   message s_NoPrivMsg "see index definitions."
      view-as ALERT-BOX ERROR buttons Ok in window s_win_Browse.
   return.
end.
if NOT can-do(dictdb._File._Can-write, USERID("DICTDB")) then
   ASSIGN idx_mod = NO.

/* Don't want Cancel if moving to next index - only when window opens */
if s_win_Idx = ? then
   s_btn_Close:label in frame idxprops = "Cancel".


/* Open the window if necessary */
run adedict/_openwin.p
   (INPUT   	  "Index Properties",
    INPUT   	  frame idxprops:HANDLE,
    INPUT         {&OBJ_IDX},
    INPUT-OUTPUT  s_win_Idx).

/* Run time layout for button area. Since this is a shared frame we 
   have to avoid doing this code more than once.
*/
if frame idxprops:private-data <> "alive" then
do:
   /* okrun.i widens frame by 1 for margin */
   assign
      s_win_Idx:width = s_win_Idx:width + 1
      frame idxprops:private-data = "alive".

   {adecomm/okrun.i  
      &FRAME = "frame idxprops" 
      &BOX   = "s_rect_Btns"
      &OK    = "s_btn_OK" 
      &HELP  = "s_btn_Help"
   }

   /* So Return doesn't hit default button in editor widget */
   b_Index._Desc:RETURN-INSERT in frame idxprops = yes.
end.

/* First clear the select list in case it had stuff in it from the last time. */
s_lst_IdxFlds:LIST-ITEMS = "".

find dictdb._File where RECID(dictdb._File) = s_TblRecId.
find b_Index of _File where b_Index._Index-Name = s_CurrIdx.
if dictdb._File._Prime-Index = RECID(b_Index) then
   s_Idx_Primary = yes.
else
   s_Idx_Primary = no.
   
CanLocIdx = _File._File-Attributes[3]. 
s_Idx_Word = (if b_Index._Wordidx = 0 OR b_Index._Wordidx = ? then no else yes).
s_Idx_Local = b_Index._index-attributes[1].
IF dictdb._File._For-type <> ? then
do:
    run FillArea("N/A":U).
end.
/* could possibly have shown N/A for this also, but we don't do that for the table or field */     
else if (dictdb._File._file-Attributes[1] and dictdb._File._file-Attributes[2] = false) then
do:
    run FillArea(" ").
end.
else do:
  IF b_Index._Idx-num <> ? THEN 
  DO:
    /* first - can have one per collation (not sure if it applies to the default ?)*/  
    FIND first dictdb._StorageObject WHERE dictdb._StorageObject._Db-recid = _File._Db-recid
                                     AND dictdb._StorageObject._Object-type = 2
                                     AND dictdb._StorageObject._Object-number = b_Index._Idx-num
                                     AND dictdb._StorageObject._partitionid = 0
                                     NO-LOCK NO-ERROR.
    IF AVAILABLE dictdb._StorageObject THEN  
    do:                                            
        if dictdb._StorageObject._Area-number <> 0 then
            FIND dictdb._Area WHERE dictdb._Area._Area-number = dictdb._StorageObject._Area-number NO-LOCK no-error.
    end.    
    ELSE
        FIND dictdb._Area WHERE dictdb._Area._Area-number = 6 NO-LOCK.  
  END.
  ELSE 
      FIND dictdb._Area WHERE dictdb._Area._Area-number = b_Index._ianum NO-LOCK no-error.
  
  if avail dictdb._Area  then
  do:
      s_Idx_Area = dictdb._Area._Area-name.
      run FillArea(s_Idx_Area).
  end.
  else
      run FillArea(" ":U).
END.  

find LAST dictdb._Index-Field of b_Index NO-ERROR.
if AVAILABLE dictdb._Index-Field then /* the default index has no fields */
   s_Idx_Abbrev = dictdb._Index-Field._Abbreviate.

IF s_dbCache_type[s_dbCache_ix] <> "PROGRESS" THEN 
DO: /* Foreign DB */
   ASSIGN ActRec:LABEL = "R&OWID".
   IF  b_Index._I-MISC2[1] begins "u"
    OR b_Index._I-MISC2[1]    =   "a"
    THEN ASSIGN
       ActRec:SENSITIVE = true
       ActRec           = false.
   ELSE IF b_Index._I-MISC2[1] begins "ru"
    OR     b_Index._I-MISC2[1]    =   "ra"
    THEN ASSIGN 
       ActRec:SENSITIVE = false
       ActRec           = true.
    ELSE ASSIGN
       ActRec:SENSITIVE = false
       ActRec           = false.
END.
ELSE ASSIGN ActRec:LABEL = "Ac&tive"
            ActRec       = b_Index._Active.
        
IF dictdb._File._For-type = ? AND NOT is-pre-101b-db THEN 
DO:
    /* for Progress db's, check if large key entries is not enabled, and display
       information. We only have to do this for 10.1B and later dbs
    */
    FIND DICTDB._Database-feature WHERE _DBFeature_Name = "Large Keys" NO-LOCK NO-ERROR.
    IF AVAILABLE DICTDB._Database-feature THEN DO:
        IF DICTDB._Database-feature._DBFeature_Enabled EQ "1" THEN
            s_msg = "".
        ELSE
            s_msg = "** Large key entries support not enabled".

        RELEASE DICTDB._Database-feature.
    END.
    ELSE
        s_msg = "".
END.

/* we will allow some of the indexes on the _aud-audit-data tables to be
   deactivated. The primary index and the _audit-time index cannot be
   deactivated.
*/
IF (NOT s_Idx_Primary) AND (dictdb._file._file-name BEGINS "_aud-audit-data") AND
   (b_Index._Index-Name NE "_audit-time") THEN
   ASSIGN canAudDeact = YES.

/* Set status line */
display "" @ s_Status s_msg ActRec with frame idxprops. /* clears from last time */

s_Idx_ReadOnly = (s_DB_ReadOnly OR s_ReadOnly).

find dictdb._File where RECID(dictdb._File) = s_TblRecId.

if NOT s_Idx_ReadOnly then
do:
   if NOT idx_mod then
   do:
      display s_NoPrivMsg + " modify index definitions." @ s_Status
      	 with frame idxprops.
      s_Idx_ReadOnly = true.
   end.
   if dictdb._File._Frozen then
   do:
       IF NOT canAudDeact THEN DO:
          s_Status:screen-value in frame idxprops =
    	"Note: This file is frozen and cannot be modified.".
          s_Idx_ReadOnly = true.
       END.
   end.
   else IF dictdb._File._Db-lang > {&TBLTYP_SQL} THEN 
   DO:
      s_Status:screen-value in frame idxprops =
   	 "Note: {&PRO_DISPLAY_NAME}/SQL92 table cannot be modified.".
      s_Idx_ReadOnly = true.
   END.
end.

/* Setup field list and it's labels */
s_txt_List_Labels[1] = STRING(" ", "x(53)") + "A(sc)/".
s_txt_List_Labels[2] = STRING("Index Field", "x(33)") +
                       STRING("Data Type", "x(20)") +
                       "D(esc)".

/* Fill up the list of index fields */
for each b_idx-list.
   delete b_idx-list.
end.

for each dictdb._Index-Field of b_Index:
   find dictdb._Field where RECID(dictdb._Field) = dictdb._Index-Field._Field-recid.
   create b_idx-list.
   assign b_idx-list.fld-nam = dictdb._Field._Field-name
          b_idx-list.fld-typ = dictdb._field._Data-type
          b_idx-list.asc-desc = if dictdb._Index-Field._Ascending then "A"
                             else "D"
          b_idx-list.comp-seq = dictdb._Index-field._Index-seq.
 
   if frstfld = "" then
      frstfld = lst_item.
end.

s_lst_IdxFlds:screen-value = frstfld.  /* set selection to the first fld */

if dictdb._File._File-Attributes[1] and dictdb._File._File-Attributes[2] then 
    assign
        s_Area_mttext:screen-value in frame idxprops = "(for default tenant)"
        s_Area_mttext:hidden in frame idxprops = false.     
else
    s_Area_mttext:hidden in frame idxprops = true.     


open query q-idx-list for each b_idx-list no-lock.

display b_Index._Index-Name       
	    s_Idx_Local
    	b_Index._Desc
   	    s_Idx_Primary
    	ActRec
    	b_Index._Unique
    	s_Idx_Word
   	    s_Idx_Abbrev
        b-idx-list 
       
   with frame idxprops.

if s_Idx_ReadOnly OR canAudDeact then
do:
   disable all EXCEPT	
      b-idx-list
	  s_btn_Close 
	  s_btn_Prev
	  s_btn_Next
	  s_btn_Help
	  with frame idxprops.

   ActRec:sensitive in frame idxprops = no.

   enable  
      b-idx-list
	  s_btn_Close 
	  s_btn_Prev
	  s_btn_Next
	  s_btn_Help
	  with frame idxprops.

   IF canAudDeact THEN DO:
      IF     
          &IF "{&WINDOW-SYSTEM}" begins "MS-WIN"
            &THEN ActRec:Label = "Ac&tive"
            &ELSE ActRec:Label = "Active"
          &ENDIF
        AND b_Index._Active /*AND INDEX(capab, {&CAPAB_INACTIVATE}) > 0*/
        THEN do:
         /* ActRec:sensitive in frame idxprops = YES.*/
          enable ActRec
                 s_btn_OK
	             s_btn_Save
               with frame idxprops.
      END.
   END.

   apply "entry" to s_btn_Close in frame idxprops.
end.
else do:
   /* Get gateway capabilities */
   run adedict/_capab.p (INPUT {&CAPAB_IDX}, OUTPUT capab).

   /* Note: In Progress, you change the primary index by setting this one to
      be primary but you can't make a primary index be not-primary.  You
      can make an index inactive but not active - that is done via proutil. 
      In some gateways, making inactive and changing primary aren't allowed
      at all.

      Explicitly disable based on these conditions in case these were
      sensitive from the last index, and then conditionally enable (using
      ENABLE verb) below to make sure the TAB order comes out right.
   */
   if b_Index._Index-Name = "default" then
      assign
      	 b_Index._Index-Name:sensitive in frame idxprops = no
      	 name_mod = false.
   else
      name_mod = true.

   if s_Idx_Primary OR INDEX(capab, {&CAPAB_CHANGE_PRIMARY}) = 0 then
      s_Idx_Primary:sensitive in frame idxprops = no.
      
   if (NOT b_Index._Active OR INDEX(capab, {&CAPAB_INACTIVATE}) = 0)
      AND 
        &IF "{&WINDOW-SYSTEM}" begins "MS-WIN"
          &THEN ActRec:Label = "Ac&tive"
          &ELSE ActRec:Label = "Active"
        &ENDIF
      THEN ActRec:sensitive in frame idxprops = no.
   
   if INDEX(capab, {&CAPAB_CHANGE_UNIQ}) = 0 then
      b_Index._Unique:sensitive in frame idxprops = no.   
   s_Idx_Local:sensitive in frame idxprops = no.
   enable b_Index._Index-Name when name_mod      	 
	      s_Idx_Local when _file._file-attributes[3] and s_Idx_Local = false
      	  b_Index._Desc
      	  s_Idx_Primary   when NOT s_Idx_Primary AND
      	       	     	       INDEX(capab, {&CAPAB_CHANGE_PRIMARY}) > 0
      	  b_Index._Unique when INDEX(capab, {&CAPAB_CHANGE_UNIQ}) > 0 	 
          b-idx-list
      	  s_btn_OK
	      s_btn_Save
	      s_btn_Close
	      s_btn_Prev
	      s_btn_Next
      	  s_btn_Help
      with frame idxprops.

IF     
    &IF "{&WINDOW-SYSTEM}" begins "MS-WIN"
      &THEN ActRec:Label = "Ac&tive"
      &ELSE ActRec:Label = "Active"
    &ENDIF
  AND b_Index._Active AND INDEX(capab, {&CAPAB_INACTIVATE}) > 0
  THEN enable ActRec with frame idxprops.

  if name_mod then apply "entry" to b_Index._Index-Name in frame idxprops.
              else apply "entry" to b_Index._Desc in frame idxprops.
  end.


return.

    
/* Note - overkill - there is currently no state that allows an area to be changed here */
procedure FillArea:
    define input parameter pcArea as char  no-undo.
     /*  define variable cAreaList as character no-undo.*/
    define variable cDisp     as character no-undo. 
    /*
    if plShow then 
    do:
       
       run prodict/pro/_pro_area_list(recid(dictdb._File),{&INVALID_AREAS},s_Idx_Area:DELIMITER in frame idxprops, output cAreaList).
       assign
          s_Idx_Area:list-items in frame idxprops = cAreaList
          s_Idx_Area:screen-value in frame idxprops = s_Idx_Area   
          numindexes = s_Idx_Area:num-items in frame idxprops
          s_Idx_Area:inner-lines in frame idxprops = min(numindexes,20).  
    end.
    else do:
    */    
        /* false blank unknown N/A */
/*        cEmpty = if plShow = false then " ":U else "N/A":U.*/
        assign 
            s_Idx_Area:list-items in frame idxprops = pcArea 
            s_Idx_Area:screen-value in frame idxprops = pcArea. 
/*    end.*/
end.





