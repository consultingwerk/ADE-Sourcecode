/***********************************************************************
* Copyright (C) 2000-2010,2013 by Progress Software Corporation. All   *
* rights reserved.  Prior versions of this work may contain portions   *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

/*----------------------------------------------------------------------------

File: _tblprop.p

Description:
   Display table properties for the current table in the edit window.

Author: Laura Stern

Date Created: 03/16/92
    Modified: 01/19/98 DLM Added display of s_Tbl_Area for _ianum
                           or N/A for dataserver tables.
              03/26/98 DLM Changed area number to area name for display
              04/20/98 DLM changed logic to find area based on storageobject
                           instead of _file ianum.
              04/22/98 DLM Changed how to know to display "NA" for area.  
              05/05/98 DLM Changed find for _area 98-05-05-054   
              06/05/98 DLM Changed find for _area again 98-06-05-015  
              07/10/98 DLM Added _Owner check on _File.     
              05/19/99 Mario B.  Adjust Width Field browser integration.
              08/16/00 DLM Added _db-recid to StorageObject find 20000815029
              10/01/02 DLM Changed check for SQL tables
              10/12/06 fernando Don't show DataServer button if Progress table
----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES

/* copied from prodict/users/uservar.i */
&GLOBAL-DEFINE PRO_DISPLAY_NAME OpenEdge

{adedict/dictvar.i shared}
{adedict/uivar.i shared}
{adedict/TBL/tblvar.i shared}
{adedict/capab.i}
/* include file contains function for area label */
{prodict/pro/arealabel.i}
/*----------------------------Mainline code----------------------------------*/
Define var name_editable    as logical     NO-UNDO.
Define var capab            as char        NO-UNDO.
Define var junk	            as logical     NO-UNDO.
Define var junk-i           as integer     NO-UNDO.
define var isDBMultiTenant  as logical     no-undo.
define variable isPartitionEnabled as logical no-undo.
define variable canEnablePartitionOptions as logical no-undo. 
define variable isType2    as logical no-undo.
find dictdb._File WHERE dictdb._File._File-name = "_File"
             AND dictdb._File._Owner = "PUB"
             NO-LOCK.
if NOT can-do(dictdb._File._Can-read, USERID("DICTDB")) then
do:
   message s_NoPrivMsg "see table definitions."
      view-as ALERT-BOX ERROR buttons Ok in window s_win_Browse.
   return.
end.

/* a default tenantrecord is created when the database is enabled for multi-tenancy */
isDBMultiTenant = can-find(first dictdb._tenant).
find dictdb._Database-feature where dictdb._Database-feature._DBFeature_Name = "Table Partitioning" no-lock no-error.
isPartitionEnabled = avail dictdb._Database-feature and dictdb._Database-feature._dbfeature_enabled="1".

/* Don't want Cancel if moving to next table - only when window opens */
if s_win_Tbl = ? then
   s_btn_Close:label in frame tblprops = "Cancel".

/* Open the window if necessary */
run adedict/_openwin.p
   (INPUT   	  "Table Properties",
    INPUT   	  frame tblprops:HANDLE,
    INPUT         {&OBJ_TBL},
    INPUT-OUTPUT  s_win_Tbl).

/* Run Graying because Adjust Width Browse can't co-exist with this code */
RUN adedict/_brwgray.p (INPUT NO).

/* Run time layout for button area.  This defines eff_frame_width.
   Since this is a shared frame we have to avoid doing this code more
   than once.
*/
if frame tblprops:private-data <> "alive" then
do:
   /* okrun.i widens frame by 1 for margin */
   assign
      frame tblprops:private-data = "alive"
      s_win_Tbl:width = s_win_Tbl:width + 1.  

   {adecomm/okrun.i  
      &FRAME = "frame tblprops" 
      &BOX   = "s_rect_Btns"
      &OK    = "s_btn_OK" 
      &HELP  = "s_btn_Help"
   }

   /* So Return doesn't hit default button in editor widget */
   b_File._Desc:RETURN-INSERT in frame tblprops = yes.

   /* runtime adjustment of "Optional" title band to the width of the frame */
   s_Optional:width-chars in frame tblprops = eff_frame_width - 
      	       	     	      	       	      ({&HFM_WID} * 2).
end.

/* Get the record for the selected table */
find b_File where RECID(b_File) = s_TblRecId.

/* Get gateway capabilities */
run adedict/_capab.p (INPUT {&CAPAB_TBL}, OUTPUT capab).

/* Figure out what the table type is */
s_Tbl_Type =
   (
   if b_File._Db-lang >= {&TBLTYP_SQL} then
      "{&PRO_DISPLAY_NAME}/SQL"
   else if b_File._File-Number >= {&TBLNUM_FASTTRK_START} AND
      	   b_File._File-Number <= {&TBLNUM_FASTTRK_END} then
      "FAST TRACK Schema"
   else if b_File._File-Number < 0 then  /* all other negative numbers */
      "{&PRO_DISPLAY_NAME} Schema"
   else if INDEX(capab, {&CAPAB_TBL_TYPE_MOD}) = 0 then
      /* Only concat on gateway name if user can't change the type */
      s_DbCache_Type[s_DbCache_ix] + " " /* gateway type */
   else ""
   ) + 
   (
   if b_File._For-Type = ? then
      ""
   else 
      b_File._For-Type
   ).

/* Count the number of indexes this table has */
s_Tbl_IdxCnt = 0.
for each dictdb._Index where _file-recid = recid(b_File) no-lock:
   s_Tbl_IdxCnt = s_Tbl_IdxCnt + 1.
end.


/* ORACLE and ODBC allows Indexes to be selected for RowID-support
   If the current _Db is of one of these types, we move the three
   standard-buttons to the left and make the ds-button visible.
   Otherwise, we move the three buttons to there centered position
   and make sure the DataServer button is invisible
*/
do with frame tblprops:

   assign
      junk   = can-do(odbtyp + ",ORACLE",s_DbCache_Type[s_DbCache_ix])
      junk-i = frame tblprops:width-pixels
             - frame tblprops:border-left-pixels
             - frame tblprops:border-right-pixels
             - s_btn_Tbl_Triggers:width-pixels
             - s_btn_Tbl_Validation:width-pixels
             - s_btn_Tbl_StringAttrs:width-pixels
             - ( if junk
                  then s_btn_Tbl_ds:width-pixels
                  else 0
               )
      junk-i = junk-i
             / ( if junk
                  then 5
                  else 4
               )
      s_btn_Tbl_Triggers:x      = junk-i
      s_btn_tbl_Validation:x    = junk-i 
                                + s_btn_Tbl_Triggers:x
                                + s_btn_Tbl_Triggers:width-pixels
      s_btn_tbl_StringAttrs:x   = junk-i 
                                + s_btn_Tbl_Validation:x
                                + s_btn_Tbl_Validation:width-pixels
      s_btn_tbl_ds:width-pixels = ( if junk
                                     then s_btn_Tbl_Triggers:width-pixels
                                     else 1
                                  )
      s_btn_tbl_ds:x            = ( if junk
                                     then junk-i 
                                      + s_btn_Tbl_StringAttrs:x
                                      + s_btn_Tbl_StringAttrs:width-pixels
                                     else 1
                                  ) 
      s_btn_Tbl_ds:hidden       = NOT junk.
  end.  /* do with frame tblprops */


/* Set the status line */
display "" @ s_Status with frame tblprops. /* clears from last time */

s_Tbl_ReadOnly = (s_DB_ReadOnly OR s_ReadOnly).
if NOT s_Tbl_ReadOnly then
do:
   if NOT can-do(_File._Can-write, USERID("DICTDB")) then
   do:
      display s_NoPrivMsg + " modify table definitions." @ s_Status
      	 with frame tblprops.
      s_Tbl_ReadOnly = true.
   end.
   else if b_File._Frozen then
   do:
      display "Note: This table is frozen and cannot be modified." @ s_Status
      	 with frame tblprops.
      s_Tbl_ReadOnly = true.
   end.
   ELSE IF b_File._Db-lang > {&TBLTYP_SQL} THEN DO:
      DISPLAY "Note: {&PRO_DISPLAY_NAME}/SQL92 table, cannot be modified." @ s_Status
           WITH FRAME tblprops.
       ASSIGN s_tbl_Readonly = TRUE.
   END.
end.

IF b_File._For-type <> ? then 
   ASSIGN s_Tbl_Area = "N/A".
ELSE if (b_file._File-Attributes[1] and b_File._File-Attributes[2] = false) then 
   ASSIGN s_Tbl_Area = "".
ELSE 
do:
    IF b_File._File-number <> ? THEN DO:
        FIND dictdb._StorageObject WHERE dictdb._StorageObject._Db-recid = b_File._Db-recid
                                   AND dictdb._StorageObject._Object-type = 1
                                   AND dictdb._StorageObject._Object-number = b_File._File-number
                                   and dictdb._StorageObject._Partitionid = 0 
                                   NO-LOCK NO-ERROR.
        IF AVAILABLE dictdb._StorageObject THEN     
        do:   
            if dictdb._StorageObject._Area-number <> 0 then           
                FIND dictdb._Area WHERE dictdb._Area._Area-number = dictdb._StorageObject._Area-number NO-LOCK.
        end.    
        ELSE if b_File._File-Attributes[3] = false then
            FIND dictdb._Area WHERE dictdb._Area._Area-number = 6 NO-LOCK. 
    END.
    ELSE do:
        if b_File._ianum <> 0 then 
            FIND dictdb._Area WHERE dictdb._Area._Area-number = b_File._ianum NO-LOCK.
    end.
    if AVAILABLE dictdb._Area then
    do:    
        assign isType2 = dictdb._Area._Area-clustersize = 8 or  dictdb._Area._Area-clustersize = 64 or  dictdb._Area._Area-clustersize = 512    
               s_Tbl_Area = dictdb._Area._Area-name.  
    end.
    else 
        assign s_Tbl_Area = "".       
end.
s_btn_File_Area:visible in frame tblprops = false.
s_lst_File_Area:visible in frame tblprops = false.

/*setAreaLabel(s_Tbl_Area:handle in frame tblprops,b_File._File-Attributes[1]).*/
setAreaState(b_File._File-Attributes[1],b_File._File-Attributes[2],no,no,b_File._File-Attributes[2]:handle in FRAME tblprops,s_tbl_Area:handle in FRAME tblprops,?,s_Tbl_Area).  
/*setAreaState(b_File._File-Attributes[3],b_File._File-Attributes[4],no,no,b_File._File-Attributes[4]:handle in FRAME tblprops,s_tbl_Area:handle in FRAME tblprops,?,s_Tbl_Area).  */

display  b_File._File-Name
	 b_File._File-Attributes[3]
         b_File._File-Attributes[1]
         b_File._File-Attributes[2]   
         s_Tbl_Area 
      	 s_optional
   	     s_Tbl_Type 
      	 b_File._Dump-Name
      	 b_File._Hidden
   	     b_File._Frozen
      	 b_File._For-Size    when INDEX(capab, {&CAPAB_TBL_SIZE}) > 0
      	 b_File._File-label
         b_File._Desc 
         b_File._Fil-misc2[6]
      	
      	 /* Oracle db link */
      	 IF INDEX(s_Tbl_Type,"ORACLE") = 0 then "n/a" ELSE IF 
          b_File._Fil-misc2[8] = ? THEN "<Local-Db>" ELSE
          b_File._Fil-misc2[8] @ b_File._Fil-misc2[8]
   
      	 /* owner */
      	 (if b_File._Db-lang >= {&TBLTYP_SQL} then
      	    ENTRY(1, b_File._Owner) 
      	  else if INDEX(capab, {&CAPAB_OWNER}) = 0 then
      	    "n/a"
      	  else      	    
      	    b_File._For-Owner
      	 ) @ b_File._For-Owner

      	 /* gateway name */
      	 (if INDEX(capab, {&CAPAB_FOR_NAME}) = 0 then
      	    "n/a"
      	  else
      	    b_File._For-Name
      	 ) @ b_File._For-Name
   with frame tblprops.
      	 
if s_Tbl_ReadOnly then
do:
   disable all except
	  s_btn_Tbl_Triggers 
	  s_btn_Tbl_Validation 
	  s_btn_Tbl_StringAttrs
	  s_btn_Close 
	  s_btn_Prev
	  s_btn_Next
	  s_btn_Help
	  with frame tblprops.
   enable s_btn_Tbl_Triggers 
	  s_btn_Tbl_Validation 
	  s_btn_Tbl_StringAttrs
	  s_btn_Close 
	  s_btn_Prev
	  s_btn_Next
	  s_btn_Help
	  with frame tblprops.
   apply "entry" to s_btn_Tbl_Triggers in frame tblprops.
end.
else do:
    /* these may have been enabled below in previous call to this   */
    disable b_File._File-Attributes[1] b_File._File-Attributes[2] b_File._File-Attributes[3]
           with frame tblprops. 
   /* User is not allowed to modify the name of a SQL table or a view.  Also 
      some gateways don't allow rename. */
   if b_File._Db-lang >= {&TBLTYP_SQL} OR
      CAN-FIND(FIRST dictdb._View-ref
	       where dictdb._View-ref._Ref-Table = b_File._File-Name) then
      name_editable = false.
   else if INDEX(capab, {&CAPAB_RENAME}) = 0 then
      name_editable = false.
   else do:
      name_editable = true.
      canEnablePartitionOptions = isType2 and b_File._File-Attributes[1] = false and b_File._File-Attributes[3] = false.
   end.
   /* Note: the order of enables will govern the TAB order. */
   enable  b_File._File-Name   when name_editable
          b_File._File-Attributes[1] when isDBMultiTenant    and canEnablePartitionOptions
          b_File._File-Attributes[3] when isPartitionEnabled and canEnablePartitionOptions
          b_File._Dump-Name
          b_File._Hidden
	   	  s_Tbl_Type          when INDEX(capab, {&CAPAB_TBL_TYPE_MOD}) > 0
      	  b_File._File-label
	      b_File._Desc
          b_File._Fil-misc2[6]
    	  b_File._For-Size    when INDEX(capab, {&CAPAB_CHANGE_TBL_SIZE}) > 0
    	  b_file._For-Name    when INDEX(capab, {&CAPAB_CHANGE_FOR_NAME}) > 0
    	  s_btn_Tbl_Triggers
    	  s_btn_Tbl_Validation
    	  s_btn_Tbl_StringAttrs
    	  s_btn_Tbl_ds WHEN NOT s_btn_Tbl_ds:hidden
      	  s_btn_OK
    	  s_btn_Save
    	  s_btn_Close
      	  s_btn_Prev
      	  s_btn_Next
      	  s_btn_Help
	  with frame tblprops.

   if name_editable then
      apply "entry" to b_File._File-Name in frame tblprops.
   else
      apply "entry" to b_File._Dump-Name in frame tblprops.
end.
 
 
 











