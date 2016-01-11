/*************************************************************/
/* Copyright (c) 2012 by Progress Software Corporation.      */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/ 
 /*------------------------------------------------------------------------
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

class adeuib.ide.request._registerinrepository  inherits  _designrequest: 
    constructor public _registerinrepository  ( pcRequest as char ):
        super (pcRequest).
    end constructor.

	method override protected void PerformRequest(  ):
        run choose_reg_in_repos in UIBHandle.
	end method.
	
    method override protected logical ValidateState():
        return isRepositoryObject.
    end method.
end class.