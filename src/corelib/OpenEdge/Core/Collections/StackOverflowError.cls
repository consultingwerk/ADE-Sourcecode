/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : StackOverflowError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Jan 05 14:44:07 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Collections.StackOverflowError.
using OpenEdge.Core.System.ApplicationError.

class OpenEdge.Core.Collections.StackOverflowError serializable inherits ApplicationError: 
    constructor static StackOverflowError ():
        ApplicationError:AddError(
            get-class(StackOverflowError),
            /* short message */
            'Stack Overflow Error',
            /* message */
            'Stack overflow error').       
    end constructor.

    constructor public StackOverflowError():
        super().
    end constructor.

end class.
