/* *************************************************************************************************************************
Copyright (c) 2016, 2018, 2020 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : HandlerErrorEventArgs
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
    /* (required) The Error that caused the OperationError event to fire */
    define public property OperationError as class Progress.Lang.Error no-undo
        get.
        set(input pError as Progress.Lang.Error):
            Assert:NotNull(pError, 'Error').
            assign this-object:OperationError = pError.
        end set.
    
    /* Constructor.
       
       @param IWebRequest The request that resulting in the exception
       @param Progress.Lang.Error The operation error that caused the event */
    constructor public HandlerErrorEventArgs(input poRequest  as IWebRequest,
                                             input poError as Progress.Lang.Error):
        super(poRequest).
        
        assign this-object:OperationError = poError.
    end constructor.
    
    /* Constructor.
       
       @param IWebRequest The request that resulting in the exception
       @param IHttpResponse The current response object, if any
       @param Progress.Lang.Error The operation error that caused the event */
    constructor public HandlerErrorEventArgs(input poRequest  as IWebRequest,
                                             input poResponse as IHttpResponse,
                                             input poError as Progress.Lang.Error):
        this-object(poRequest, poError).
        
        Assert:NotNull(poResponse, 'Response').
        assign this-object:Response = poResponse.
    end constructor.
    
    /* Constructor.
       
       @param Progress.Lang.Error The operation error that caused the event
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
        
        assign this-object:Response        = poResponse
               this-object:BusinessEntity  = poEntity.
    end constructor.
    
    /* Add an operation to the args
       
       @param MappedOperation An operation to add to the args */
    method public void SetOperation(input poOperation as MappedOperation):
        assign this-object:Operation = poOperation.
    end method.
    
    /* Add a service to the args
       
       @param DataObjectService A service to add to the args */
    method public void SetService(input pService as DataObjectService):
        assign this-object:Service = pService.
    end method.
    
end class.