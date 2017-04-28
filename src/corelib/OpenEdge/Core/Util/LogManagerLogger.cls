/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : LogManagerLogger
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon May 23 09:39:34 EDT 2016
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.LogLevelEnum.
using OpenEdge.Core.Util.ILogWriter.
using OpenEdge.Core.Util.ISupportLogging.

class OpenEdge.Core.Util.LogManagerLogger implements ILogWriter:
    
    constructor public LogManagerLogger():
    end constructor.

    constructor public LogManagerLogger(input poEmitter as ISupportLogging):
        this-object().
        
        SubscribeTo(poEmitter).
    end constructor.
    
    method public void SubscribeTo(input poEmitter as ISupportLogging):
        Assert:NotNull(poEmitter, 'Logging emitter').
        
        poEmitter:LogMessage:Subscribe(this-object:LogMessageHandler).
    end method. 

    method public void UnsubscribeFrom(input poEmitter as ISupportLogging):
        Assert:NotNull(poEmitter, 'Logging emitter').
        
        poEmitter:LogMessage:Unsubscribe(this-object:LogMessageHandler).
    end method. 
    
    method public void LogMessageHandler(input poSender as Progress.Lang.Object,
                                         input pcMessageGroup as character,
                                         input pcMessage as character,
                                         input poLogLevel as LogLevelEnum):                                           
        if log-manager:logfile-name eq ? then
            return.
        
        if log-manager:logging-level ge integer(poLogLevel) then
            log-manager:write-message(substitute('&1: &2', string(poLogLevel), pcMessage), pcMessageGroup).
    end method.
    
end class.