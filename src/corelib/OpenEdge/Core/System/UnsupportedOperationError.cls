/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : UnsupportedOperationError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Sep 02 13:46:49 EDT 2009
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Core.System.ErrorSeverityEnum.
using OpenEdge.Core.System.UnsupportedOperationError.
using Progress.Lang.Error.

class OpenEdge.Core.System.UnsupportedOperationError inherits ApplicationError serializable: 
    constructor static UnsupportedOperationError():
        ApplicationError:AddError(
            get-class(UnsupportedOperationError),
            /* short message */
            'Unsupported Operation Error',
            /* message */
            '&1 is not supported for &2').       
    end constructor.
    
    constructor public UnsupportedOperationError (pcArgs1 as char, pcArgs2 as char):
        this-object(?,pcArgs1,pcArgs2).       
    end constructor.

    constructor public UnsupportedOperationError (poErr as Error, pcArgs1 as char, pcArgs2 as char):
        super(poErr).
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
    end constructor.
    
end class.
