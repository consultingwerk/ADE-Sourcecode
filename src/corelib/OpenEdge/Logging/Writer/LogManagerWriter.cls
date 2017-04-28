/* *************************************************************************************************************************
Copyright (c) 2016-2017 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : LogManagerWriter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon May 23 09:39:34 EDT 2016
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Logging.LogLevelEnum.
using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.LogEvent.
using OpenEdge.Logging.Writer.IFileWriter.

class OpenEdge.Logging.Writer.LogManagerWriter implements ILoggerFilter, IFileWriter:
    define private property SubSys as character no-undo initial 'LogMgrWrtr':u get.
    
    // TRUE when we're on an appserver/webspeed broker or we haven't passed in a filename  
    define private variable mlDefaultLog as logical no-undo.
    
    // (mandatory) The output location: The location of the log-manager
    define public property FileName as character no-undo
        get():
            return log-manager:logfile-name.
        end get.    
        
    // TRUE if we are appending to an existing file
    define public property Append as logical no-undo get. private set. 
    
    /* Constructor */
    constructor public LogManagerWriter():
        super().
        
        // For the default log we always append
        assign mlDefaultLog       = true
               this-object:Append = true.
    end constructor.
    
    /* Default destructor */
    destructor LogManagerWriter():
        if not mlDefaultLog then
            log-manager:close-log().
    end destructor.
    
    /* Constructor
       
       @param character The name of the logfile to use
       @param logical TRUE if log entries should be appended to an existing log */
    constructor public LogManagerWriter(input pcFile as character,
                                        input plAppend as logical):
        this-object().
        
        case session:client-type:
            when 'APPSERVER':u or 
            when 'MULTI-SESSION-AGENT':u or
            when 'WEBSPEED':u then
            do:
                assign mlDefaultLog       = true
                       this-object:Append = true.
                if log-manager:logging-level ge integer(LogLevelEnum:INFO) then                       
                    log-manager:write-message(
                                 substitute('INFO: Current session client type &1 does not support named logs', session:client-type),
                                 SubSys).
                return.
            end.
            otherwise
            case true:
                when log-manager:logfile-name eq ? then
                do:
                    Assert:NotNullOrEmpty(pcFile, 'Log file name').
                    
                    assign log-manager:logfile-name = pcFile
                           this-object:Append       = plAppend
                           mlDefaultLog             = true.
                    if not plAppend then
                        log-manager:clear-log(). 
                end.
                otherwise
                do:
                    if     log-manager:logfile-name ne pcFile 
                       and pcFile ne '':u 
                       and log-manager:logging-level ge integer(LogLevelEnum:INFO) then                       
                        log-manager:write-message(
                                substitute('INFO: Log-manager is already in use. Cannot write to &1', pcFile), 
                                SubSys).
                    assign mlDefaultLog       = true
                           this-object:Append = true.
                end.    // existing 
            end case.
        end case.
    end constructor.
    
    /** Performs implementation-specific filtering for a logger type
        
        @param LogMessage The message to log. */
    method public void ExecuteFilter( input poEvent as LogEvent):
        if log-manager:logfile-name eq ? then
            return.
        log-manager:write-message(poEvent:Message:Message, SubSys).
    end method.
    
end class.
