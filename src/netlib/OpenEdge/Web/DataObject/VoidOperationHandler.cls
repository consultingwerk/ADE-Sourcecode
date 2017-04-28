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
using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Core.LogLevelEnum.
using OpenEdge.Core.Memptr.
using OpenEdge.Core.Util.ISupportLogging.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using OpenEdge.Net.HTTP.Filter.Writer.BodyWriterBuilder.
using OpenEdge.Net.HTTP.Filter.Writer.EntityWriterBuilder.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.MethodEnum.
using OpenEdge.Net.HTTP.StatusCodeEnum.
using OpenEdge.Core.Util.LogManagerLogger.
using OpenEdge.Web.DataObject.IOperationHandler.
using OpenEdge.Web.DataObject.MappedOperation.
using OpenEdge.Web.IWebRequest.
using OpenEdge.Web.SendExceptionError.
using Progress.Lang.AppError.
using OpenEdge.Core.Util.ILogWriter.

class OpenEdge.Web.DataObject.VoidOperationHandler implements ISupportLogging, IOperationHandler, ISupportInitialize:
    define public event LogMessage  signature void (input poSender as Progress.Lang.Object, input pcMessageGroup as character, input pcMessage as character, input poLogLevel as LogLevelEnum).
        
    define private variable moLogger as ILogWriter no-undo.
    
    constructor public VoidOperationHandler():
        assign moLogger = new LogManagerLogger()
               .
    end constructor.
    
    constructor public VoidOperationHandler(input poLogger as ILogWriter):
        this-object().
        
        Assert:NotNull(poLogger, 'Logger').
        assign moLogger = poLogger.
    end constructor.

    destructor public VoidOperationHandler():
        Destroy().
    end destructor.  
    
    method public void Initialize():
        moLogger:SubscribeTo(this-object).
    end method.
    
    method public void Destroy():
        moLogger:UnsubscribeFrom(this-object).
    end method.
    
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
        
        return poOperation:StatusCode.
    end method.
    
    /** Logs a message 
        
        @param character The message to log
        @param integer  The level this message should be logged at */
    method private void LogMessage(input pcMessage as character,
                                   input poLogLevel as LogLevelEnum):
        this-object:LogMessage:Publish(this-object,
                                       'DOH-VOID':u,
                                       pcMessage,
                                       poLogLevel).                                       
    end method.

end class.