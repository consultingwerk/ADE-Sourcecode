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
using Progress.Lang.*.
using adeuib.ide.request._request  from propath.
using adeuib.ide.request.irequest from propath.

class adeuib.ide.request._requestmanager  :  
    
    define  public property  CANCEL_OBJ as char no-undo init "Cancel":U get.
    define  public property  ERROR_OBJ as char no-undo init "Error":U get.
    
      
    define private variable fContextHandle as handle no-undo.
    define private variable fUIBHandle as handle no-undo.
     
 	constructor public _requestmanager (hcontext as handle,hUib as handle ):
		super ().
		fUIBHandle = hUib.
		fContextHandle = hcontext.
	end constructor.
    
    method public char Execute(req as irequest):
        if req:Execute(fUIBHandle,fContextHandle) then
            return req:GetResponse( ).   
        else 
            return CANCEL_OBJ.        
        catch e as Progress.Lang.Error :
        	return GetErrorResponse(e). 
        end catch.
    end.    
    
    method protected character GetErrorResponse(e as Progress.Lang.Error ):
        define variable cMsg as character no-undo.
        cMsg = e:GetMessage(1).
        if cMsg = "" and type-of(e,Progress.Lang.AppError) then
                cMsg = cast(e,Progress.Lang.AppError):ReturnValue.
            
        return ERROR_OBJ + _request:DELIMITER + cMsg.
    end.
        
    
end class.