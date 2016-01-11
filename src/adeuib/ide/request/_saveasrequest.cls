/*************************************************************/
/* Copyright (c) 2012 by Progress Software Corporation.      */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/ 
 /*------------------------------------------------------------------------
    Purpose     : saveas with file name passed from client
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Tue Aug 21 00:48:20 EDT 2012
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using adeuib.ide.request._request.
using adeuib.ide.request._designrequest.

routine-level on error undo, throw.

class adeuib.ide.request._saveasrequest  inherits  _designrequest: 
    define private variable IsCancelled  as logical no-undo.
    
    constructor public _saveasrequest  ( pcRequest as char):
        super (pcRequest).
    end constructor.
    
    method override protected void SetRequest(pcRequest as char ):
        Name = entry(1,pcRequest,_request:DELIMITER).
        NewName = entry(2,pcRequest,_request:DELIMITER).
    end.  
    
	method override protected void PerformRequest(  ):
        run save_as_file in UIBHandle(Name,NewName,output IsCancelled).
 	end method.
	
    method override protected logical ValidateState():
        return not IsCancelled.
    end method.
    
    method override protected void UpdateState():
        super:UpdateState().
        if NewName <> Name then
        do:
            UpdateDesignFileName().
        end.
    end.  
end class.