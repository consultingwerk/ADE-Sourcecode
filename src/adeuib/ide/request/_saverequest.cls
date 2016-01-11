/*************************************************************/
/* Copyright (c) 2012 by Progress Software Corporation.      */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/ 
 /*------------------------------------------------------------------------
    File        : _saverequest
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Tue Aug 21 00:48:20 EDT 2012
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using adeuib.ide.request._designrequest.

routine-level on error undo, throw.

class adeuib.ide.request._saverequest inherits  _designrequest: 
    function getDesignHwnd returns integer   (pcFile as char) in ContextHandle. 
    function getDesignWindow returns handle (piHwnd as integer) in ContextHandle.  
    
	constructor public _saverequest (prequest as char ):
		super ( prequest ).
	end constructor.

	method override protected void PerformRequest(  ):
	    define variable hWin as handle no-undo.
	    define variable ihwnd as integer no-undo.
        /* save all does not set focus, so we cannot rely on current wondow in uib */
        ihwnd = getDesignHwnd(Name).
        hwin = getDesignWindow(ihwnd).
		run ide_file_save in UIBHandle (hwin).
	end method.
	
	method override protected logical ValidateState():
        return NewName <> ?.
    end method.
    
    method override protected void UpdateState():
        super:UpdateState().
        if NewName <> ? and NewName <> Name then
        do:
            CreateNewLinkFile().
        end.
    end.  
    
end class.