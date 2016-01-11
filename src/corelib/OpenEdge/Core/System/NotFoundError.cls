/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : NotFoundError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Feb 22 12:56:33 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.System.NotFoundError.
using OpenEdge.Core.System.ApplicationError.
using Progress.Lang.Error.

class OpenEdge.Core.System.NotFoundError inherits ApplicationError: 
    constructor static NotFoundError():
        ApplicationError:AddError(
            get-class(NotFoundError),
            /* short message */
            'Not Found Error',
            /* message */
            '&1 not found in &2').       
    end constructor.
        
    constructor public NotFoundError(poErr as Error, pcArgs1 as char, pcArgs2 as char):
        super(poErr).
        
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
    end constructor.
    
    constructor public NotFoundError(pcArgs1 as char, pcArgs2 as char):
        define variable oUnknown as Error no-undo.
        
        this-object(oUnknown,pcArgs1, pcArgs2).
    end constructor.
        
end class.
