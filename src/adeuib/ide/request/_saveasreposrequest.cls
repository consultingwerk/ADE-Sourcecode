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

class adeuib.ide.request._saveasreposrequest  inherits  _designrequest: 
    define private variable SaveAsType as char no-undo. 
    
    constructor public _saveasreposrequest  ( pcRequest as char):
        super (pcRequest).
    end constructor.
    
	constructor public _saveasreposrequest  (  pcRequest as char,type as char ):
		this-object( pcRequest).
		SaveAsType = type.
	end constructor.

	method override protected void PerformRequest(  ):
         case SaveAsType:
             when "" then	    
		         run do_file_save_as in UIBHandle.
		     when "static" then
		         run choose_file_save_as_static in UIBHandle.
		     when "dynamic" then
                 run choose_file_save_as_dynamic in UIBHandle.    
	     end case.
	end method.
	
    method override protected logical ValidateState():
        return NewName <> Name.
    end method.
    
    method override protected void UpdateState():
        super:UpdateState().
        if NewName <> Name then
        do:
            UpdateDesignFileName().
        end.
    end. 
      
end class.