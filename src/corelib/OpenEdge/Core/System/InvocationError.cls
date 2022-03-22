/************************************************
Copyright (c)  2013, 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : InvocationError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Apr 12 15:06:24 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

using OpenEdge.Core.System.InvocationError. 
using OpenEdge.Core.System.ApplicationError.
using Progress.Lang.Error.

class OpenEdge.Core.System.InvocationError inherits ApplicationError serializable: 
    constructor static InvocationError():
        ApplicationError:AddError(
            get-class(InvocationError),
            /* short message */
            'Invocation Error',
            /* message */
            'Cannot invoke &1 on class &2').       
    end constructor.
    
    constructor public InvocationError(poErr as Error,
                                       pcArgs1 as char,
                                       pcArgs2 as char):
        super(poErr).
        
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
    end constructor.

    constructor public InvocationError(pcArgs1 as char,
                                       pcArgs2 as char):
        super().
        
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
    end constructor.
    
    constructor public InvocationError():
        {&_proparse_ prolint-nowarn(varusage)}
        define variable oUnknown as Error no-undo.
        super(oUnknown).
    end constructor.
    
end class.
