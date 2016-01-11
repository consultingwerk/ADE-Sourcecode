/*************************************************************/
/* Copyright (c) 2012 by Progress Software Corporation.      */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    Purpose     : read and save design windows to  _uibmain 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
 
    Notes       :   
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.
using Progress.Lang.* from propath.
using adeuib.ide.request.irequest from propath.
using adeuib.ide.request._request from propath.

class adeuib.ide.request._request abstract implements irequest :  
    
    define static public property  DELIMITER  as char no-undo init "|" get. set.
    
    define public property Name       as character no-undo get. protected set.
    define public property DialogId   as integer  no-undo get. private set.
    define protected property UIBHandle as handle no-undo get. private set. 
    define protected property ContextHandle as handle no-undo get. private set. 
    
    function setOpenDialogHwnd returns logical   (piHwnd as integer) in ContextHandle .
    function removeHwnd returns logical (piHwnd as int) in ContextHandle.
    
  	constructor public _request (pcRequest as char ):
		super ().
		SetRequest(pcRequest ).
	end constructor.
    
    method final public logical Execute(hUib as handle,hCntxt as handle).
        UIBHandle = huib.
        ContextHandle = hCntxt.
        if DialogId <> 0  then
        do:
            setOpenDialogHwnd (DialogId).
        end.   
        return Execute().
        finally:
            if DialogId <> 0 then
                removeHwnd(DialogId).       
        end finally.  
    end method.   
    
    method abstract public logical Execute( ).
    
    method public character GetResponse():
        return "ok".
    end method.    
    
    method protected void SetRequest(pcRequest as char ):
        Name = entry(1,pcRequest,_request:DELIMITER).
        Name = replace(Name,"~\":U,"/":U). 
        if num-entries(pcRequest,_request:DELIMITER) > 1 then
        do:
            DialogId = int(entry(2,pcRequest,_request:DELIMITER)).
        end. 
    end.  
    
        
end class.