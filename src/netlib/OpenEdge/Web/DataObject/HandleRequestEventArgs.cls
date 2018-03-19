/* *************************************************************************************************************************
Copyright (c) 2017 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : HandleRequestEventArgs
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2017-09-01
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.EventArgs.
using OpenEdge.Web.IWebRequest.
using OpenEdge.Web.DataObject.DataObjectService.

class OpenEdge.Web.DataObject.HandleRequestEventArgs inherits EventArgs:
    /* (mandatory) The request being serviced */
    define public property Request as IWebRequest no-undo get. private set.
    
    /* (optional) An error that results from the handling of this event.
       Will typically cancel the operation and will cause the exception handling code
       to execute */
    define public property Error as Progress.Lang.Error no-undo get. set.
    
    /* Indicates whether the operation should be cancelled */    
    define public property Cancel as logical no-undo get. set.
    
     /* (optional) The status code to return for an operation.
        
        Zero = use the event args Response for the entire response
        > 0  = use the PASOE built-in (static) pages      */
    define public property ReturnStatusCode as integer no-undo get. set.
    
    /* Constructor.
       
       @param IWebRequest The request that resulting in the exception */
    constructor public HandleRequestEventArgs(input poRequest as IWebRequest):
        super().
        
        Assert:NotNull(poRequest, 'Request').        
        assign this-object:Request          = poRequest
               this-object:Cancel           = false
               this-object:ReturnStatusCode = 0
               .
    end constructor.
    
end class.