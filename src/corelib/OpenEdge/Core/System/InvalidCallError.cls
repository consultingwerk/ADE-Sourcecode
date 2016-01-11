/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : InvalidCallError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 13 12:38:37 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.System.InvalidCallError.
using OpenEdge.Core.System.ApplicationError.

class OpenEdge.Core.System.InvalidCallError inherits ApplicationError:
    
    constructor static InvalidCallError():
        ApplicationError:AddError(
            get-class(InvalidCallError),
            /* short message */
            'Invalid Call Error',
            /* message */
            'Invalid &1 call: &2').       
    end constructor.
    
    constructor public InvalidCallError(pcArgs1 as char, pcArgs2 as char):
        super().
        
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
    end constructor.
    
end class.
