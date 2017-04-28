/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : ISupportLogging
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Mar 28 16:03:27 EDT 2016
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.Core.LogLevelEnum.

interface OpenEdge.Core.Util.ISupportLogging:
    
    define public event LogMessage signature void (input poSender as Progress.Lang.Object,
                                                   input pcMessageGroup as character,
                                                   input pcMessage as character,
                                                   input poLogLevel as LogLevelEnum).

/**	
	//define public property LogService as ILogService no-undo get.
    method public void LogMessage(input pcMessageGroup as character,
                                  input pcMessage as character,
                                  input poLogLevel as LogLevelEnum).
                                  

    
    method public void LogFatal(input pcMessageGroup as character,
                                input pcMessage as character).
    
    method public void LogError(input pcMessageGroup as character,
                                input pcMessage as character).
    
    method public void LogWarning(input pcMessageGroup as character,
                                  input pcMessage as character).
    
    method public void LogInfo(input pcMessageGroup as character,
                                input pcMessage as character).
    
    method public void LogTrace(input pcMessageGroup as character,
                                input pcMessage as character).


**/  
end interface.