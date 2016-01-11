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

File: _saveidx.p

Description:
   Save any changes the user made in the index property window. 

Returns: "error" if the save is not complete for any reason, otherwise "".

Author: Laura Stern

Date Created: 07/14/92

Last Modified on:
08/26/94 by gfs     Added Recid index support.
 
Modified: 10/31/95 to correct problem with place holders being left on 400
                    and help with server bug.  D. McMann
          06/25/97 Added word index support D. McMann          
----------------------------------------------------------------------------*/


{as4dict/dictvar.i shared}
{as4dict/brwvar.i shared}
{as4dict/menu.i shared}
{as4dict/uivar.i shared}
{as4dict/IDX/idxvar.i shared}

Define var oldname  as char CASE-SENSITIVE   NO-UNDO.
Define var newname  as char CASE-SENSITIVE NO-UNDO.  
Define var oldaname as char                                      NO-UNDO.
Define var newaname as char                                    NO-UNDO.
Define var oldlib       as char                                         NO-UNDO.
Define var newlib    as char                                         NO-UNDO.
Define var active   as logical                                       NO-UNDO.
Define var answer   as logical 	       	      NO-UNDO.
Define var no_name  as logical 	       	      NO-UNDO.
Define var ins_name as char   	       	     NO-UNDO.
Define var nxtname  as char   	       	     NO-UNDO.
Define var fordb    as logical                                      NO-UNDO. /* foreign db? y/n */       
Define var fnlngth as integer                                    NO-UNDO.
Define var i as integer                                                 NO-UNDO.
Define var chgname as logical initial false           NO-UNDO.


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
run as4dict/_blnknam.p
   (INPUT b_Index._Index-Name:HANDLE in frame idxprops,
    INPUT "index", OUTPUT no_name).
if no_name then return "error".     

oldname = b_Index._Index-Name.
newname = input frame idxprops b_Index._Index-Name.


do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
   run adecomm/_setcurs.p ("WAIT").  

   /* Do old/new name check if new as4-file or library change save old for apply. */           

    ASSIGN   
        oldaname = b_Index._AS4-File
        newaname =   CAPS(input frame idxprops b_Index._AS4-File)
        oldlib = b_Index._AS4-Library
        newlib =    CAPS(input frame idxprops b_Index._AS4-Library).
        
   if (oldaname <> newaname and oldlib = newlib) OR
       (oldaname <> newaname and oldlib <> newlib) OR
       (oldaname = newaname and oldlib <> newlib) then  do:
     if b_Index._Wordidx = 0 THEN DO:
         dba_cmd = "CHKF".
        RUN as4dict/_dbaocmd.p 
	 (INPUT "LF", 
	  INPUT newaname,
      	  INPUT  newlib,
	  INPUT 0,
	  INPUT 0).

        if dba_return =   2 then DO :
            dba_cmd = "RESERVE".
            RUN as4dict/_dbaocmd.p 
	        (INPUT "LF", 
	        INPUT newaname,
               INPUT newlib,
	        INPUT 0,
	        INPUT 0).        
        end.
        else if dba_return = 1 then do:            
            message "A file object with AS4-File name already exists in this Library."
   	    view-as ALERT-BOX ERROR  buttons OK.
            return "error".
        end.     
        else if dba_return = 3 then do:
            message "Can not create file object because Library is unknown"
                view-as ALERT-BOX ERROR buttons OK.
            return "error".
        end.
        else do:
            message "Could not reserve file object with entered AS4-File name and Library."
                view-as ALERT-BOX ERROR buttons OK.
            return "error".
        end.       
        /* new index getting new name before commit. */                        
        IF b_Index._I-Misc1[1] = 0 THEN DO:
               dba_cmd = "UNRESERVE".
                RUN as4dict/_dbaocmd.p 
	         (INPUT "LF", 
	          INPUT oldaname,
      	          INPUT  oldlib,
	          INPUT 0,
	          INPUT 0).     
        END.
        /* existing index getting first new name */	                                                
        ELSE IF b_Index._I-res2[8] = ? OR b_Index._I-res2[8] = "" THEN DO:      
            assign fnlngth = LENGTH(oldaname).
            if fnlngth < 10 then  do:
                define var fillchar as character format "x" initial  " " NO-UNDO.
                assign b_Index._I-res2[8] = b_Index._AS4-File +  FILL(fillchar, 10 - fnlngth)  +   b_Index._AS4-Library.
            end.
            else assign b_Index._I-res2[8] = b_Index._AS4-File +   b_Index._AS4-Library.    
            /* old physical file key getting new name */ 
            IF b_Index._I-Res1[4] = 1 THEN DO:
                dba_cmd = "UNRESERVE".
                RUN as4dict/_dbaocmd.p 
	           (INPUT "LF", 
	            INPUT oldaname,
      	            INPUT  oldlib,
	            INPUT 0,
	            INPUT 0).     
              END.	             
        END.
        ELSE DO:
            /* If this is a new name for old index then get rid of old place holder */
               dba_cmd = "UNRESERVE".
                RUN as4dict/_dbaocmd.p 
	           (INPUT "LF", 
	            INPUT oldaname,
      	            INPUT  oldlib,
	            INPUT 0,
	            INPUT 0).     
        END.	
    END.
    ELSE DO:
      /* Check for the user index name to make sure it is unique */     
      dba_cmd = "CHKOBJ".
      RUN as4dict/_dbaocmd.p 
       (INPUT "*USRIDX", 
	 INPUT CAPS(input frame idxprops b_Index._AS4-File),
      	 INPUT  CAPS(input frame idxprops b_Index._AS4-Library),
	 INPUT 0,
	 INPUT 0).

      if dba_return = 1 THEN DO:
        message "The *USRIDX " + CAPS(input frame idxprops b_Index._AS4-File) +
        " already exists in library " CAPS(input frame idxprops b_Index._AS4-Library) + "."
               view-as ALERT-BOX ERROR buttons OK.               
        s_OK_Hit = no.
        return NO-APPLY.
      end.
      IF b_Index._I-res2[8] = ? OR b_Index._I-res2[8] = "" THEN DO:      
            assign fnlngth = LENGTH(oldaname).
            if fnlngth < 10 then  do:
                define var wfillchar as character format "x" initial  " " NO-UNDO.
                assign b_Index._I-res2[8] = b_Index._AS4-File +  FILL(wfillchar, 10 - fnlngth)
                                            +   b_Index._AS4-Library.
            end.
            else assign b_Index._I-res2[8] = b_Index._AS4-File +   b_Index._AS4-Library. 
      end.                          
    end.   
        assign b_Index._For-name = newlib + "/" + newaname.            
  
        for each as4dict.p__Idxfd where as4dict.p__Idxfd._File-number = b_Index._File-number
                                    and as4dict.p__Idxfd._Idx-num = b_Index._Idx-num:
           assign as4dict.p__Idxfd._AS4-File = newaname
                  as4dict.p__Idxfd._AS4-Library = newlib.
        end.                                                                  
    end.

    assign    
      b_Index._AS4-file = newaname
      b_Index._AS4-Library = newlib    
      b_Index._I-Res1[8] = 1   
      input frame idxprops b_Index._Index-name
      input frame idxprops b_Index._Desc
      input frame idxprops s_Idx_Primary.
      
  IF input frame idxprops word_size <> b_Index._I-res1[1] THEN
    ASSIGN b_Index._I-Res1[1] = input frame idxprops word_size.
         
   IF  input frame idxprops ActRec then do:
        IF b_Index._Active = "N"  AND SUBSTRING(b_Index._I-Misc2[4],9,1) <> "Y" then do:
            assign b_Index._I-Res1[5] = 1
                         b_Index._Active = "Y".                   
           dba_cmd =  "CHKF".
            RUN as4dict/_dbaocmd.p 
	 (INPUT "LF", 
	  INPUT b_Index._AS4-file,
      	  INPUT b_Index._AS4-Library,
	  INPUT 0,
	  INPUT 0).       
	    
            If dba_return = 2 THEN DO:
                dba_cmd = "RESERVE".
                RUN as4dict/_dbaocmd.p 
	 (INPUT "LF", 
	  INPUT b_Index._AS4-File,
      	  INPUT b_Index._AS4-Library,
	  INPUT 0,
	  INPUT 0).      	      
            END.         
            ELSE if dba_return = 1 and b_Index._I-Res1[7] = 1 then do:            
                message "A file object with AS4-File name already exists in this Library."
   	    view-as ALERT-BOX ERROR  buttons OK.
                return "error".
            END.     
            ELSE if dba_return = 3 then do:
                message "Can not create file object because Library is unknown"
                    view-as ALERT-BOX ERROR buttons OK.
                return "error".
            END.
            ELSE DO:       
                message "Could not reserve file object with entered AS4-File name and Library."
                    view-as ALERT-BOX ERROR buttons OK.
                return "error".
            END.                                           
        END.
        ELSE IF b_Index._Active = "N"  THEN
              assign b_Index._I-Res1[5] = 1
                            b_Index._Active = "Y".  	                               
    END.    
    ELSE DO:      
        IF b_Index._Active = "Y" THEN do:
            assign b_Index._Active = "N"
                          answer = FALSE.
           IF SUBSTRING(b_Index._I-Misc2[4],9,1) <> "Y" THEN DO: 
                MESSAGE "DB2/400 databases do not support inactiving indexes."
                                  "To simulate the PROGRESS behavior, you must delete" 
                                  "the logical file."  SKIP (1)
                                   "Do you want the logical file deleted?" SKIP (1)
                    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.        
                IF answer then
                    assign b_Index._I-Res1[7] = 1.
             END.       
        END.
    END.                    
    ASSIGN 
      active = input frame idxprops ActRec. /* formerly b_Index._Active */

     if s_Idx_Unique:sensitive in frame idxprops then
      assign
      	 b_Index._Unique = 
      	    (if input frame idxprops s_Idx_Unique then "Y" else "N").

  if s_Idx_Primary then  do:                            
         /* Make the index primary.  If it already was, so, it still is. */
        find as4dict.p__File where as4dict.p__File._File-number = s_TblForNo.   
        IF as4dict.p__File._Prime-index <> b_Index._Idx-num THEN DO:
            MESSAGE "Do you want the key to the physical file" SKIP
                              "changed to this primary index key?" SKIP
                              VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
            IF answer THEN DO:                                                                                  
                FIND as4dict.p__Index WHERE as4dict.p__Index._File-number = as4dict.p__File._file-number
                                                              AND as4dict.p__Index._Idx-num = as4dict.p__File._Fil-misc1[7].  

                /* If  _Fil-res1[7] = the index number than in this dba session, the index
                    was changed from primary and back again so just zero out _fil-res1[7]
                    because apply will not do anything since the before and after image
                    ends up the same */
                   
                 IF as4dict.p__File._Fil-res1[7] = b_Index._Idx-num THEN
                    ASSIGN as4dict.p__File._Fil-res1[7] = 0
                                    SUBSTRING(as4dict.p__Index._I-misc2[4],9,1) = "N"
                                    SUBSTRING(b_Index._I-misc2[4],9,1) = "Y"
                                    as4dict.p__File._Prime-index = b_Index._Idx-num    
 	                   as4dict.p__File._Fil-misc1[7] = b_Index._Idx-num.                         
                                                            
                  /* Else if _fil-res1[7] > 0 then the primary index has been changed multi times
                      during this session and the index has already been reserved and exists.
                      We do not want to check the name because it will be there and the user
                      will have to rename in order to change the physical key again */                                                  
                         
                 ELSE IF as4dict.p__file._Fil-res1[7] <= 0 THEN DO:                                             
                    dba_cmd = "CHKF".
                    RUN as4dict/_dbaocmd.p 
    	       (INPUT "LF", 
	        INPUT as4dict.p__Index._AS4-File,
      	        INPUT  as4dict.p__Index._AS4-Library,
	        INPUT 0,
	        INPUT 0).

                    IF dba_return =   2 then DO :
                        dba_cmd = "RESERVE".
                        RUN as4dict/_dbaocmd.p 
	           (INPUT "LF", 
	           INPUT as4dict.p__Index._AS4-File,
      	           INPUT as4dict.p__Index._AS4-Library,
	           INPUT 0,
	           INPUT 0).      
                      chgname = true.
                    END.        
	   /* Can't use the AS4-file name since it is not unique for library  get new one*/
                    ELSE  
                        RUN as4dict/IDX/_chgprme.p (OUTPUT chgname).  

                    IF chgname THEN  DO: 
 
	       /* Only assign if key of file has not been changed during this session.  Apply
	           needs to know the old index which was key to the file */                      
                        IF as4dict.p__File._Fil-Res1[7] <= 0 THEN
                            ASSIGN as4dict.p__File._Fil-Res1[7]  = as4dict.p__File._Fil-Misc1[7].
                        
                        ASSIGN  SUBSTRING(as4dict.p__Index._I-misc2[4],9,1) = "N"
                                          as4dict.p__Index._I-Res1[4] =  1 
                                          SUBSTRING(b_Index._I-misc2[4],9,1) = "Y"
                                          as4dict.p__File._Prime-index = b_Index._Idx-num    
 	                        as4dict.p__File._Fil-misc1[7] = b_Index._Idx-num.       
                    END.   	                                                
                    ELSE    
                        ASSIGN    SUBSTRING(b_Index._I-Misc2[4],9,1) =  "N".                     
                 END.
                 ELSE
                        ASSIGN  SUBSTRING(as4dict.p__Index._I-misc2[4],9,1) = "N"
                                          as4dict.p__Index._I-Res1[4] =  1 
                                          SUBSTRING(b_Index._I-misc2[4],9,1) = "Y"
                                          as4dict.p__File._Prime-index = b_Index._Idx-num    
 	                        as4dict.p__File._Fil-misc1[7] = b_Index._Idx-num.                        
                           
            END.  /* change physical file key */                                     
            as4dict.p__File._Prime-Index = b_Index._Idx-num.   
        END. /* prime key changed */                                      
    END. /*  if s_Idx_Primary */

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
      	 find FIRST as4dict.p__Index where as4dict.p__Index._File-number = s_TblForno AND
     	     	      	      	 as4dict.p__Index._Index-Name > ins_name 
      	    NO-ERROR.

      	 nxtname = (if AVAILABLE as4dict.p__Index then as4dict.p__Index._Index-name else "").
	 run as4dict/_newobj.p
	    (INPUT s_lst_Idxs:HANDLE in frame browse,
	     INPUT ins_name,
	     INPUT nxtname,
	     INPUT s_Idxs_Cached,
	     INPUT {&OBJ_IDX}).
      end.
      else do:
      	 /* Change name in place in browse window list. */
      	 {as4dict/repname.i
      	    &OldName = oldname
   	    &NewName = newname
   	    &Curr    = s_CurrIdx
      	    &Fill    = s_IdxFill
   	    &List    = s_lst_Idxs}
      end.
   end.
  find as4dict.p__File where as4dict.p__File._File-number = s_TblForNo.         
   IF as4dict.p__File._Fil-res1[7] < 0 then assign as4dict.p__File._Fil-res1[7] = 0. 
  ASSIGN as4dict.p__File._Fil-Res1[8] = 1
                   as4dict.p__File._Fil-Misc1[1] = as4dict.p__File._Fil-Misc1[1] + 1.  
   {as4dict/setdirty.i &Dirty = "true"}.
   display "Index Modified" @ s_Status with frame idxprops.  
   VALIDATE  b_Index NO-ERROR.
   run adecomm/_setcurs.p ("").   
   return "".
end.

run adecomm/_setcurs.p ("").
return "error".

