/* *************************************************************************************************************************
Copyright (c) 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : AuthorizeOperationEventArgs
    Purpose     : Event args for authorizing an operation
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2018-11-14
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Security.Principal.
using OpenEdge.Web.DataObject.DataObjectEventArgs.
using OpenEdge.Web.DataObject.DataObjectService.
using OpenEdge.Web.DataObject.MappedOperation.
using OpenEdge.Web.IWebRequest.

class OpenEdge.Web.DataObject.AuthorizeOperationEventArgs inherits DataObjectEventArgs:
    /* (mandatory) The user being authorized. May be unknown (if anonymous or asserted) */
    define public property User as Principal no-undo
        get.
        private set.
    
    /* Constructor.
       
       @param IWebRequest (Mandatory) The request being serviced 
       @param DataObjectService The service 
       @param MappedOperation The current operation
       @param Principal A user principal    */
    constructor public AuthorizeOperationEventArgs(input pRequest as IWebRequest,
                                                   input pService as DataObjectService,
                                                   input pOperation as MappedOperation,
                                                   input pUser as Principal ):
        super(pRequest).
        
        Assert:NotNull(pService, 'Service').
        Assert:NotNull(pOperation, 'Operation').
        
        assign this-object:User      = pUser
               this-object:Operation = pOperation
               this-object:Service   = pService
               .
    end constructor.
    
end class.