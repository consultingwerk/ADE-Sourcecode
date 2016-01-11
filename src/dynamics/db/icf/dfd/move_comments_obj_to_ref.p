/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*---------------------------------------------------------------------------------
  File: move_comments_obj_to_ref.p

  Description: Noddy move the value of the comment records' owning_obj field
  			   to the owning_reference field.

  DCU Information:
  	PatchStage: PostADOLoad
    Rerunnable: Yes
    NewDB: No
    ExistingDB: Yes
    UpdateMandatory: Yes

  History:
  --------
  (v:010000)    Task:           0   UserRef: 
                Date:   2005-08-29   Author: Peter Judge

  Update Notes: Created from scratch

-------------------------------------------------------------------------*/
define variable lError                  as logical                no-undo.
define variable cOwningReference        as character              no-undo.

define buffer gsmcm         for gsm_comment.    /* for update */
define buffer gsm_comment   for gsm_comment.    /* for search */

publish 'DCU_WriteLog' ('Start migration of comment owning_obj value to owning_reference ...').

for each gsm_comment no-lock:
    if gsm_comment.owning_obj eq 0 then
        next.
    
    publish 'DCU_WriteLog' ('Updating comment: ' + gsm_comment.comment_description + '~n'
                          + '	Owning entity: ' + gsm_comment.owning_entity_mnemonic + '~n'
                          + '	Owning obj: ' + string(gsm_comment.owning_obj) ).
    
    cOwningReference = string(gsm_comment.owning_obj).
    cOwningReference = replace(cOwningReference, session:numeric-separator, '').
    cOwningReference = replace(cOwningReference, session:numeric-decimal-point, '.').
    
    find gsmcm where
         rowid(gsmcm) = rowid(gsm_comment)
         exclusive-lock no-wait no-error.
    if locked gsmcm then
    do:
	    publish 'DCU_WriteLog' ('ERROR: Unable to lock comment for update.').
        lError = yes.
        next.
    end.        /* locked */
    
    /* It's extremely unlikely that we won't be able to find the record via
       ROWID() but still check for completeness' sake.
     */
    if not available gsmcm then
    do:
	    publish 'DCU_WriteLog' ('ERROR: Unable to find comment for update.').
        lError = yes.
        next.
    end.    /* not available  */
    
    assign gsmcm.owning_reference = cOwningReference
           gsmcm.owning_obj = 0
           no-error.
	if error-status:error or return-value ne '' then
	do:
	    publish 'DCU_WriteLog' ('ERROR: Unable to assign owning reference.').
	    lError = yes.
        next.
	end.    /* error updating session property default value */
 
    validate gsmcm no-error.
	if error-status:error or return-value ne '' then
	do:
	    publish 'DCU_WriteLog' ('ERROR: Validation failed.').
	    lError = yes.
        next.
	end.    /* error updating session property default value */
    
    publish 'DCU_WriteLog' ('Comment successfully updated.'). 
end.    /* each comment */

publish 'DCU_WriteLog' ('Migration of comment owning_obj value to owning_reference completed '
                        + (if lError then 'with errors!' else 'successfully.') ).

error-status:error = no.
return.
/* EOF */
