/* *************************************************************************************************************************
Copyright (c) 2016-2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : HandlerLoadEntityEventArgs
    Purpose     : Arguments for the data object business logic invocation
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-05-17
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Web.DataObject.DataObjectEventArgs.
using OpenEdge.Web.DataObject.DataObjectService.
using OpenEdge.Web.DataObject.MappedOperation.
using OpenEdge.Web.IWebRequest.

class OpenEdge.Web.DataObject.HandlerLoadEntityEventArgs inherits DataObjectEventArgs:
    /* (optional) The entity (business logic) servicing the request 
       Set by the published to indicate what's required or by a subscriber/handler to indicate the defined 
       type (for an interface, for instance). */
    define public property EntityType as class Progress.Lang.Class no-undo get. set.
    
    /* Constructor.
       
       @param IWebRequest (Mandatory) The request being serviced
       @param MappedOperation (mandatory) the operation for which to start the entity */
    constructor public HandlerLoadEntityEventArgs(input poRequest as IWebRequest,
                                                  input pService as DataObjectService,
                                                  input poOperation as MappedOperation):
        super(poRequest).
        
        Assert:NotNull(pService, 'Service').
        Assert:NotNull(poOperation, 'Mapped operation').
        
        assign this-object:Service    = pService
               this-object:Operation  = poOperation
               this-object:EntityType = poOperation:EntityType
               .
    end constructor.
    
end class.