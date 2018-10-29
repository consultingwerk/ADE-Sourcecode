/* *************************************************************************************************************************
Copyright (c) 2016, 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : OperationErrorEventArgs
    Purpose     : Arguments for the data object handler's invocation
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-05-17
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Web.DataObject.DataObjectEventArgs.
using OpenEdge.Web.DataObject.DataObjectService.
using OpenEdge.Web.DataObject.MappedOperation.
using OpenEdge.Web.IWebRequest.

class OpenEdge.Web.DataObject.HandlerErrorEventArgs inherits DataObjectEventArgs:
    /* Constructor.
       
       @param Progress.Lang.Error The as-yet-unhandled exception
       @param IWebRequest The request that resulting in the exception
       @param IHttpResponse The current response object, if any
       @param Progress.Lang.Object The 'business entity' object, if any */
    constructor public HandlerErrorEventArgs(input poRequest  as IWebRequest,
                                             input poError as Progress.Lang.Error):    
        super(poRequest).
        
        Assert:NotNull(poError, 'Error').
        assign this-object:Error = poError.
    end constructor.

    /* Constructor.
       
       @param IWebRequest The request that resulting in the exception
       @param IHttpResponse The current response object, if any
       @param Progress.Lang.Object The 'business entity' object, if any */
    constructor public HandlerErrorEventArgs(input poRequest  as IWebRequest,
                                             input poResponse as IHttpResponse):
        super(poRequest).
        
        Assert:NotNull(poResponse, 'Response').        
        assign this-object:Response = poResponse.
    end constructor.
                                                                 
    /* Constructor.
       
       @param Progress.Lang.Error The as-yet-unhandled exception
       @param IWebRequest The request that resulting in the exception
       @param IHttpResponse The current response object, if any
       @param Progress.Lang.Object The 'business entity' object, if any */
    constructor public HandlerErrorEventArgs(input poError    as Progress.Lang.Error,
                                             input poRequest  as IWebRequest,
                                             input poResponse as IHttpResponse,
                                             input poEntity   as Progress.Lang.Object):
        this-object(poRequest, poError).
        
        Assert:NotNull(poResponse, 'Response').
        Assert:NotNull(poEntity, 'Business Entity').
        
        assign this-object:Response = poResponse
               this-object:BusinessEntity  = poEntity.
    end constructor.
    
    /* Add an operation to the args
       
       @param MappedOperation A n operation to add to the args */
    method public void SetOperation(input poOperation as MappedOperation):
        assign this-object:Operation = poOperation.
    end method.

    /* Add a service to the args
       
       @param DataObjectService An operation to add to the args */
    method public void SetService(input pService as DataObjectService):
        assign this-object:Service = pService.
    end method.
    
end class.