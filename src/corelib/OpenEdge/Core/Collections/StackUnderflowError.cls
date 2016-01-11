/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : StackError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Jan 05 14:44:07 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Collections.StackUnderflowError.
using OpenEdge.Core.System.ApplicationError.

class OpenEdge.Core.Collections.StackUnderflowError serializable inherits ApplicationError: 
    constructor static StackUnderflowError():
        ApplicationError:AddError(
            get-class(StackUnderflowError),
            /* short message */
            'Stack Underflow Error',
            /* message */
            'Stack underflow error').       
    end constructor.

    constructor public StackUnderflowError():
        super().
    end constructor.
    
end class.
