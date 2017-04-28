/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : DataObjectEventArgs
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon May 23 15:12:37 EDT 2016
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.EventArgs.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Web.DataObject.MappedOperation.
using OpenEdge.Web.IWebRequest.

class OpenEdge.Web.DataObject.DataObjectEventArgs inherits EventArgs: 
    /* (mandatory) The operation for which to instantiate the entity */
    define public property Operation as MappedOperation no-undo get. protected set.

    /* (mandatory) The request being serviced */
    define public property Request as IWebRequest no-undo get. private set.
    
    /* (mandatory but mutable) The response to the request */
    define public property Response as IHttpResponse no-undo get. set.
    
    /* (optional) An error that results from the handling of this event.
       Will typically cancel the operation and will cause the exception handling code
       to execute */
    define public property Error as Progress.Lang.Error no-undo get. set.
    
    /* (optional) The entity (business logic) servicing the request */
    define public property BusinessEntity as Progress.Lang.Object no-undo get. set.
    
    /* (mandatory and mutable) The message body of the incoming request. Typically 
       will be transformed from bytes into something useful; may also have an envelope 
       removed. Defaults to the request body. */
    define public property RequestBody as Progress.Lang.Object no-undo
        get():
            if not valid-object(this-object:RequestBody) and
               valid-object(this-object:Request) then
                return this-object:Request:Entity.
                
            return this-object:RequestBody.
        end get.
        set.
    
    define public property Cancel as logical no-undo get. set.
    
     /* (optional) The status code to return for this error.
          Zero = use the event args Response for the entire response
          > 0  = use the PASOE built-in (static) pages      */
    define public property ReturnStatusCode as integer no-undo get. set.
    
    /* Constructor.
       
       @param IWebRequest The request that resulting in the exception */
    constructor protected DataObjectEventArgs(input poRequest as IWebRequest):
        super().
        
        Assert:NotNull(poRequest, 'Request').        
        assign this-object:Request = poRequest
               this-object:Cancel = false.
    end constructor.

end class.