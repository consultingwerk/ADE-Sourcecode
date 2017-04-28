/************************************************
Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : ILogWriter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Jun 07 16:09:44 EDT 2016
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.Core.LogLevelEnum.
using OpenEdge.Core.Util.ISupportLogging.

interface OpenEdge.Core.Util.ILogWriter:  
    
    method public void SubscribeTo(input poEmitter as ISupportLogging).
    method public void UnsubscribeFrom(input poEmitter as ISupportLogging).
    
    method public void LogMessageHandler(input poSender as Progress.Lang.Object,
                                         input pcMessageGroup as character,
                                         input pcMessage as character,
                                         input poLogLevel as LogLevelEnum).                                      
end interface.