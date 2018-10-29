/* *************************************************************************************************************************
Copyright (c) 2016, 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : IOperationHandler
    Purpose     : Interface for running an operation of a given operation
                  target type  
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue May 24 12:03:08 EDT 2016
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Web.DataObject.DataObjectService.
using OpenEdge.Web.DataObject.MappedOperation.
using OpenEdge.Web.IWebRequest.

interface OpenEdge.Web.DataObject.IOperationHandler:
    /* Executes the operation.  
       
       @param IWebRequest The request that resulting in the exception
       @param P.L.Object The message body of the incoming request. Typically 
                         will be transformed from bytes into something useful; may also have an envelope removed. 
       @param IHttpResponse The current response object, if any
       @param DataObjectService The service being run
       @param MappedOperation The mapped operation
       @param P.L.Object The business entity (business logic service)  
       @return integer A non-null status code use to deal with errors */
    method public integer Execute(input poRequest  as IWebRequest,
                                  input poMessageBody as Progress.Lang.Object,
                                  input poResponse as IHttpResponse,
                                  input pService as DataObjectService,
                                  input poOperation as MappedOperation,
                                  input poBusinessEntity as Progress.Lang.Object).
    
end interface.