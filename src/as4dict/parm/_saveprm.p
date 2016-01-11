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

File: _saveparm.p

Description:
   Save any changes the user made in the parameter property window.

Returns: "error" if the save is not complete for any reason, otherwise "".

Author: Donna McMann
Date Created: 05/11/99
              
----------------------------------------------------------------------------*/


{as4dict/dictvar.i shared}
{as4dict/brwvar.i shared}
{as4dict/menu.i shared}
{as4dict/uivar.i shared}
{adecomm/cbvar.i shared}
{as4dict/parm/parmvar.i shared}
{as4dict/capab.i}


Define var oldname  as char CASE-SENSITIVE NO-UNDO.
Define var newname  as char CASE-SENSITIVE NO-UNDO.    
Define var newfname as char                                    NO-UNDO.
Define var oldorder as integer	       	   NO-UNDO.
Define var neworder as integer	       	   NO-UNDO.
Define var junk     as logical       	   NO-UNDO.
Define var no_name  as logical 	       	   NO-UNDO.
Define var remove   as logical 	       	   NO-UNDO.
Define var stat     as logical 	       	   NO-UNDO.
Define var num      as integer	       	   NO-UNDO.

current-window = s_win_Parm.

run as4dict/_blnknam.p
   (INPUT b_Parm._Field-name:HANDLE in frame parmprops,
    INPUT "parameter", OUTPUT no_name).
if no_name then return "error".

if RETURN-VALUE = "error" then return "error".

assign
   oldname  = b_Parm._Field-Name
   newname  = input frame parmprops b_Parm._Field-Name      
   oldorder = b_Parm._Order
   neworder = input frame parmprops b_Parm._Order.

do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
   run adecomm/_setcurs.p ("WAIT").
   
   /* Triggers, validation and gateway have already been saved.  We
      just need to move main property values into buffer.  For data types
      check if changed first. Progress, normally won't let you change
      data types.
   */
   if b_Parm._Data-type <> s_Parm_Protype then
      b_Parm._Data-type = s_Parm_Protype.
   if b_Parm._For-type <> s_Parm_Gatetype then
      b_Parm._For-type = s_Parm_Gatetype.
  
                                                                                                                                   
   assign
      b_Parm._Field-name = newname     
      input frame parmprops b_Parm._Format
      input frame parmprops b_Parm._Initial
      input frame parmprops b_Parm._Order
      input frame parmprops b_Parm._Desc.       
  
    IF s_Parm_Type:screen-value = "INPUT" THEN
      ASSIGN b_Parm._Fld-misc1[2] = 1.
    ELSE IF s_Parm_Type:screen-value = "OUTPUT" THEN
      ASSIGN b_Parm._Fld-misc1[2] = 3.
    ELSE
      ASSIGN b_Parm._Fld-misc1[2] = 2. 

  /* Set _Fil-Misc1[1] so that sync will know that file has changed if change does
       not require a DDS change */
    find as4dict.p__File where as4dict.p__File._File-number = s_ProcForNo.         
    ASSIGN  as4dict.p__File._Fil-Misc1[1] = as4dict.p__File._Fil-Misc1[1] + 1
                      as4dict.p__File._Fil-res1[8] = 1.         
    IF as4dict.p__File._Fil-res1[7] < 0 then assign as4dict.p__File._Fil-res1[7] = 0.    

    IF SUBSTRING(as4dict.p__File._Fil-misc2[5],1,1) <> "Y" THEN
       ASSIGN SUBSTRING(as4dict.p__File._fil-misc2[5],1,1) = "Y".                  
  
   /* Determine if we have to remove the field's entry in the browse list
      to reposition it based on a new name or order#.  If there's only
      one field we don't have to bother.
   */
   remove = no.
   num = s_lst_Parm:NUM-ITEMS in frame browse.
   if oldname <> newname AND      
      num > 1 then
      	 remove = yes.

   if remove then 
   do:
      stat = s_lst_Parm:delete(oldname) in frame browse.
      run as4dict/parm/_ptinlst.p (INPUT newname, INPUT neworder).
   end.
   else if oldname <> newname then
   do:
      /* Just change the name in place */
      {as4dict/repname.i
	 &OldName = oldname
	 &NewName = newname
	 &Curr    = s_CurrParm
	 &Fill    = s_ParmFill
	 &List    = s_lst_Parm}
   end.

   {as4dict/setdirty.i &Dirty = "true"}.          
   /* Must force release of record to DataServer but do not want to loose record so
        issue a validate with no-error.  */
   VALIDATE b_Parm NO-ERROR.
   display "Parameter Modified" @ s_Status with frame parmprops.
   run adecomm/_setcurs.p ("").
   return "".
end.

run adecomm/_setcurs.p ("").
return "error".




