/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : ArgumentError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 13 12:43:45 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.System.ArgumentError.
using OpenEdge.Core.System.ApplicationError.
using Progress.Lang.Error.

class OpenEdge.Core.System.ArgumentError inherits ApplicationError serializable: 

    constructor static ArgumentError ():
        ApplicationError:AddError(
            get-class(ArgumentError),
            /* short message */
            'Argument Error',
            /* message */
            '&1 (name &2)').       
    end constructor.
    
    constructor public ArgumentError(pcArgs1 as char, pcArgs2 as char):
        this-object(?, pcArgs1, pcArgs2).
    end constructor.
    
    constructor public ArgumentError(poInnerError as Error, pcArgs1 as char, pcArgs2 as char):
        super(poInnerError).
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
    end constructor.

end class.
