/* *************************************************************************************************************************
Copyright (c) 2016-2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
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

using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Web.DataObject.DataObjectService.
using OpenEdge.Web.DataObject.HandleRequestEventArgs.
using OpenEdge.Web.DataObject.MappedOperation.
using OpenEdge.Web.IWebRequest.

class OpenEdge.Web.DataObject.DataObjectEventArgs inherits HandleRequestEventArgs:
    /* (mandatory) The service for which to instantiate the entity */
    define public property Service as DataObjectService no-undo
        get.
        protected set.
    
    /* (mandatory) The operation for which to instantiate the entity */
    define public property Operation as MappedOperation no-undo
        get.
        protected set.
    
    /* (mandatory but mutable) The response to the request */
    define public property Response as IHttpResponse no-undo get. set.
    
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
    
    /* Constructor.
       
       @param IWebRequest The request that resulting in the exception */
    constructor public DataObjectEventArgs(input poRequest as IWebRequest):
        super(poRequest).
    end constructor.

end class.