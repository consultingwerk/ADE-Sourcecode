/* *************************************************************************************************************************
Copyright (c) 2017-2018, 2020 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
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

using OpenEdge.Core.Assert.
using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Web.DataObject.DataObjectEventArgs.
using OpenEdge.Web.DataObject.DataObjectService.
using OpenEdge.Web.DataObject.HandleRequestEventArgs.
using OpenEdge.Web.DataObject.MappedOperation.
using OpenEdge.Web.DataObject.ServiceDiscoveryEventArgs.
using OpenEdge.Web.IWebRequest.

class OpenEdge.Web.DataObject.DataObjectError inherits ApplicationError: 
    /* (optional) The service affected by this error */
    define public property Service as DataObjectService no-undo get. set.
    
    /* (optional) The operation  affected by this error */
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
    
    /* Default constructor */
    constructor public DataObjectError():
    end constructor.
    
    /* Constructor
       
       @param DataObjectEventArgs The event args related to this error (typically from an event). */
    constructor public DataObjectError (input pOperationArgs as DataObjectEventArgs):
        this-object(cast(pOperationArgs, HandleRequestEventArgs)).
        
        Assert:NotNull(pOperationArgs, 'Operation args').
        
        assign this-object:Service        = pOperationArgs:Service
               this-object:Operation      = pOperationArgs:Operation
               this-object:Response       = pOperationArgs:Response
               this-object:BusinessEntity = pOperationArgs:BusinessEntity
               .
    end constructor.
    
    /* Constructor
       
       @param HandleRequestEventArgs The event args related to this error (typically from an event). */
    constructor public DataObjectError (input pRequestArgs as HandleRequestEventArgs):
        this-object().
        
        Assert:NotNull(pRequestArgs, 'Request args').
        
        assign this-object:Request = pRequestArgs:Request
               this-object:Error   = pRequestArgs:Error
               .
    end constructor.
    
    /* Constructor
       
       @param ServiceDiscoveryEventArgs The event args related to this error (typically from an event). */
    constructor public DataObjectError (input pDiscoveryArgs as ServiceDiscoveryEventArgs):
        this-object(cast(pDiscoveryArgs, HandleRequestEventArgs)).
        
        Assert:NotNull(pDiscoveryArgs, 'Operation args').
        
        assign this-object:Service = pDiscoveryArgs:Service.
    end constructor.
    
end class.