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

File: _fldprop.p

Description:
   Set up the field properties window so the user can view or modify the 
   information on a field.  Since this window is non-modal, we just do the
   set up here.  All triggers must be global.

   All of this code is in an include file so that we can use it for fields
   and domains.

Author: Laura Stern

Date Created: 02/05/92                                                                                  
Modified 91/95 by D. McMann to work with PROGRESS/400 Data Dictionary
Modified 12/18/95 D. McMann to add 1 to _Fld-stoff for display.
         05/18/98 D. McMann changed to handle modifying all fields when
                            file has not been committed.

----------------------------------------------------------------------------*/


{as4dict/dictvar.i shared}
{as4dict/uivar.i shared}
{adecomm/cbvar.i shared}
{as4dict/FLD/fldvar.i shared}
{as4dict/FLD/uptfld.i }

 Define var ronote             as character NO-UNDO. /* virtual file note */
 Define var fldstoff1        like  b_Field._Fld-stoff NO-UNDO.


/*----------------------------Mainline code----------------------------------*/

/* Don't want Cancel if moving to next field - only when window opens */
if s_win_Fld = ? then
   s_btn_Close:label in frame fldprops = "Cancel".

/* Open the window if necessary */
run as4dict/_openwin.p
   (INPUT   	  "AS/400 Field Properties",
    INPUT   	  frame fldprops:HANDLE,
    INPUT         {&OBJ_FLD},
    INPUT-OUTPUT  s_win_Fld).

/* We haven't finished fiddling with frame yet so to set status line
   don't use display statement.
*/
s_Status:screen-value in frame fldprops = "". /* clears from last time */

find as4dict.p__File where as4dict.p__File._File-number = s_TblForNo.         

if NOT s_ReadOnly THEN DO:
    IF SUBSTRING(as4dict.p__File._Fil-misc2[4],8,1) = "Y" THEN DO:    
       if as4dict.p__file._For-flag = 1 then ronote = "Limited logical virtual table, can't modify".
       else if as4dict.p__file._For-flag = 2 then ronote = "Multi record virtual table, can't modify".
       else if as4dict.p__file._For-flag = 3 then ronote = "Joined logical virtual table, can't modify".
       else if as4dict.p__file._For-flag = 4 then ronote = "Program desc virtual table, can't modify".
       else if as4dict.p__file._For-flag = 5 then ronote = "Multi record pgm desc virtual, can't modify".
       else ronote = "Read only file, can't be modified via client".           
        s_Status:screen-value in frame fldprops =  ronote.
        ASSIGN s_Fld_ReadOnly = true.       
    END.   
    ELSE IF as4dict.p__File._Frozen = "Y" THEN DO:
        s_Status:screen-value in frame fldprops =
      	    "Note: This file is frozen and cannot be modified.".
        s_Fld_ReadOnly = true.
     END. 
     ELSE DO:
         dba_cmd = "CHKF".
        RUN as4dict/_dbaocmd.p 
	 (INPUT "PF", 
	  INPUT as4dict.p__File._AS4-File,
      	  INPUT as4dict.p__File._AS4-Library,
	  INPUT 0,
	  INPUT 0).     

        IF dba_return = 1 THEN DO:
            dba_cmd = "RESERVE".
            RUN as4dict/_dbaocmd.p 
	 (INPUT "PF", 
	  INPUT as4dict.p__File._AS4-File,
      	  INPUT as4dict.p__File._AS4-Library,
	  INPUT 0,
	  INPUT 0).     

                IF dba_return <> 1 THEN DO: 
      	 s_Status:screen-value in frame fldprops =
      	    "Note: Physical file locked, can't  modify fields".
                    ASSIGN s_Fld_ReadOnly = true.
                END.     
                ELSE s_fld_Readonly = false.
         END.     
         /* file could have been renamed and new file is wrong format */   
         ELSE IF dba_return = 11 AND
            (as4dict.p__File._Fil-Res2[8] <> ? OR as4dict.p__File._Fil-Res2[8] <> "")
            THEN DO:
           dba_cmd = "RESERVE".
            RUN as4dict/_dbaocmd.p 
	 (INPUT "PF", 
	  INPUT as4dict.p__File._AS4-File,
      	  INPUT as4dict.p__File._AS4-Library,
	  INPUT 0,
	  INPUT 0).     

                IF dba_return <> 1 THEN DO: 
      	 s_Status:screen-value in frame fldprops =
      	    "Note: Physical file locked, can't  modify fields".
                    ASSIGN s_Fld_ReadOnly = true.
                END.     
                ELSE s_fld_Readonly = false.
         END.                    
    /* chkf failed */
         ELSE DO:
            RUN as4dict/_dbamsgs.p.     
            s_Status:screen-value in frame fldprops =
      	    "Note: DBA error so field cannot be modified.".        
            s_fld_ReadOnly = true.
         END.     
    END.
END.  
ELSE s_Fld_ReadOnly = (s_ReadOnly OR s_DB_ReadOnly).        

 {as4dict/FLD/fdprop.i &Frame    = "frame fldprops"
      	       	       &ReadOnly = "s_Fld_ReadOnly"}






