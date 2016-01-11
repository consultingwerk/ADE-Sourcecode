/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : ResizeError
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jun 14 11:49:06 EDT 2012
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Core.Collections.ResizeError.
using Progress.Lang.Error.

class OpenEdge.Core.Collections.ResizeError serializable inherits ApplicationError:
    constructor static ResizeError ():
        ApplicationError:AddError(
            get-class(ResizeError),
            /* short message */
            'Collection Resize Error',
            /* message */
            'Cannot resize &1 &2 than its contents').       
    end constructor.
    
    constructor public ResizeError ():
    end constructor.
    
    constructor public ResizeError (input poErr as Error, input pcArgs1 as character, input pcArgs2 as character):
        super(poErr).
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
    end constructor.
    
    constructor public ResizeError (input pcArgs1 as character, input pcArgs2 as character):
        define variable oUnknown as Error no-undo.
        this-object(oUnknown,pcArgs1,pcArgs2).
    end constructor.

end class.