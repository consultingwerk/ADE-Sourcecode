/************************************************
Copyright (c)  2013, 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : InvalidValueSpecifiedError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Jul 08 10:06:54 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Core.System.InvalidValueSpecifiedError.
using Progress.Lang.Error.

class OpenEdge.Core.System.InvalidValueSpecifiedError inherits ApplicationError serializable: 
    
    constructor static InvalidValueSpecifiedError():
        ApplicationError:AddError(
            get-class(InvalidValueSpecifiedError),
            /* short message */
            'Invalid Value Specified Error',
            'Invalid &1 specified &2').
    end constructor.
    
    constructor protected InvalidValueSpecifiedError ():
        {&_proparse_ prolint-nowarn(varusage)}
        define variable oNullError as Error no-undo.
        super(oNullError).
    end constructor.
    
    constructor public InvalidValueSpecifiedError (pcArgs1 as char, pcArgs2 as char):
        super().
        
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
    end constructor.
    
    constructor public InvalidValueSpecifiedError (e as Error, pcArgs1 as char, pcArgs2 as char):
        super(e).
        
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
    end constructor.
    
    constructor public InvalidValueSpecifiedError (pcArgs1 as char):
        this-object().
        AddMessage(pcArgs1, 1).
    end constructor.
    
end class.
