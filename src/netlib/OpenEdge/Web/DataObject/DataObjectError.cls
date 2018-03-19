/* *************************************************************************************************************************
Copyright (c) 2017 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
 /*------------------------------------------------------------------------
    File        : DataObjectError
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2017-04-11
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Web.DataObject.MappedOperation.
using OpenEdge.Web.IWebRequest.
using OpenEdge.Web.DataObject.DataObjectEventArgs.
using OpenEdge.Core.Assert.


class OpenEdge.Web.DataObject.DataObjectError inherits ApplicationError: 
    /* (mandatory) The operation for which to instantiate the entity */
    define public property Operation as MappedOperation no-undo get. set.

    /* (mandatory) The request being serviced */
    define public property Request as IWebRequest no-undo get. set.
    
    /* (mandatory but mutable) The response to the request */
    define public property Response as IHttpResponse no-undo get. set.
    
    /* (optional) An error that results from the handling of this event.
       Will typically cancel the operation and will cause the exception handling code
       to execute */
    define public property Error as Progress.Lang.Error no-undo get. set.
    
    /* (optional) The entity (business logic) servicing the request */
    define public property BusinessEntity as Progress.Lang.Object no-undo get. set.
    
    /* Default Constructor */    
    constructor public DataObjectError ():
    end constructor.

    constructor public DataObjectError (input pOperationArgs as DataObjectEventArgs):
        this-object().
        
        Assert:NotNull(pOperationArgs, 'Operation args').
        
        assign this-object:Operation      = pOperationArgs:Operation
               this-object:Request        = pOperationArgs:Request
               this-object:Response       = pOperationArgs:Response
               this-object:Error          = pOperationArgs:Error
               this-object:BusinessEntity = pOperationArgs:BusinessEntity
               .
    end constructor. 
    
end class.