/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : VoidOperationHandler
    Purpose     : Delegate for mapped file operations for the DOH
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri May 20 12:15:00 EDT 2016
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.ISupportLogging.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Web.DataObject.IOperationHandler.
using OpenEdge.Web.DataObject.MappedOperation.
using OpenEdge.Web.IWebRequest.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Web.DataObject.VoidOperationHandler.

class OpenEdge.Web.DataObject.VoidOperationHandler implements ISupportLogging, IOperationHandler:
    // A reference to the Logger in use by an implementer
    define public property Logger as ILogWriter no-undo get. set.
    
    constructor public VoidOperationHandler():
        assign Logger = LoggerBuilder:GetLogger(get-class(VoidOperationHandler)).
    end constructor.
    
    /* Executes the operation.  
       
       @param IWebRequest The request that resulting in the exception
       @param P.L.Object The message body of the incoming request. Typically 
                         will be transformed from bytes into something useful; may also have an envelope removed. 
       @param IHttpResponse The current response object, if any
       @param MappedOperation The mapped operation
       @param P.L.Object The business entity (business logic service)  
       @return integer A non-null status code use to deal with errors */
    method public integer Execute(input poRequest  as IWebRequest,
                                  input poMessageBody as Progress.Lang.Object,
                                  input poResponse as IHttpResponse,
                                  input poOperation as MappedOperation,
                                  input poBusinessEntity as Progress.Lang.Object).
        Assert:NotNull(poRequest,   'Web request').
        Assert:NotNull(poResponse,  'Web response').
        Assert:NotNull(poOperation, 'Mapped operation').
        
        Logger:Trace(substitute('Void operation for &1 &2 ; service=&3',
                        poOperation:Method:ToString(), poOperation:ServiceURI, poOperation:ServiceName)).
        
        return poOperation:StatusCode.
    end method.
    
end class.