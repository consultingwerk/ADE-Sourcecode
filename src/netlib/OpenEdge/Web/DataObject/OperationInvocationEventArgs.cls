/* *************************************************************************************************************************
Copyright (c) 2016, 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : OperationInvocationEventArgs
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

class OpenEdge.Web.DataObject.OperationInvocationEventArgs inherits DataObjectEventArgs:
    /* Constructor.
       
       @param IWebRequest (Mandatory) The request being serviced 
       @param Progress.Lang.Object (mandatory) The entity/business logic servicing the request 
       @param IHttpResponse (mandatory) The response to this request */
    constructor public OperationInvocationEventArgs(input poRequest as IWebRequest,
                                                    input poResponse as IHttpResponse):
        super(poRequest).
        
        Assert:NotNull(poResponse, 'Web response').
        assign this-object:Response = poResponse.
    end constructor.
    
    /* Constructor.
       
       @param IWebRequest (Mandatory) The request being serviced 
       @param Progress.Lang.Object (mandatory) The entity/business logic servicing the request 
       @param IHttpResponse (mandatory) The response to this request */
    constructor public OperationInvocationEventArgs(input poRequest as IWebRequest,
                                                    input poEntity as Progress.Lang.Object,
                                                    input poResponse as IHttpResponse,
                                                    input pService as DataObjectService,
                                                    input poOperation as MappedOperation):
        this-object(poRequest, poEntity).
        
        Assert:NotNull(poResponse, 'Web response').
        assign this-object:Response  = poResponse
               this-object:Operation = poOperation
               this-object:Service   = pService
               .
    end constructor.

    /* Constructor.
       
       @param IWebRequest (Mandatory) The request being serviced 
       @param Progress.Lang.Object (mandatory) The entity/business logic servicing the request */
    constructor public OperationInvocationEventArgs(input poRequest as IWebRequest,
                                                    input poEntity as Progress.Lang.Object):
        super(poRequest).
        
        Assert:NotNull(poEntity , 'Business oEntity').
        
        assign this-object:BusinessEntity = poEntity.
    end constructor.
    
end class.