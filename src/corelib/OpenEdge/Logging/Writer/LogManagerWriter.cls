/* *************************************************************************************************************************
Copyright (c) 2016-2017, 2019, 2021 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
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

using OpenEdge.Core.File.
using OpenEdge.Core.Session.
using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.LogEvent.
using OpenEdge.Logging.LogLevelEnum.
using OpenEdge.Logging.Writer.IFileWriter.
using Progress.Lang.AppError.

class OpenEdge.Logging.Writer.LogManagerWriter implements ILoggerFilter, IFileWriter:
    /* The subsystem used for WRITE-MESSAGE ( msg-exp[ , subsys-expr]) */
    define private property SubSys as character no-undo initial 'LogMgrWrtr':u get.
    
    // This flag indicates whether this class opened the LOG-MANAGER log and whether it should
    // close it.
    // FALSE when we're on an appserver/webspeed broker or we haven't passed in a filename
    define private variable mCloseLog as logical no-undo.
    
    /* (mandatory) The output location: The location of the log-manager */
    define public property FileName as character no-undo
        get():
            return log-manager:logfile-name.
        end get.
    
    /* TRUE if we are appending to an existing file */
    define public property Append as logical no-undo
        get.
        private set.
    
    /* Constructor. */
    constructor public LogManagerWriter():
        super().
        
        // For the default log we always append
        assign mCloseLog          = false
               this-object:Append = true.
    end constructor.
    
    /* Default destructor */
    destructor LogManagerWriter():
        if mCloseLog then
        do:
            log-manager:close-log().
            assign log-manager:logfile-name = ?.
        end.
    end destructor.
    
    /* Constructor
       
       @param character The name of the logfile to use
       @param logical TRUE if log entries should be appended to an existing log */
    constructor public LogManagerWriter(input pcFile as character,
                                        input plAppend as logical):
        var File logfile.
        this-object().
        
        case session:client-type:
            when 'APPSERVER':u or
            when 'MULTI-SESSION-AGENT':u or
            when 'WEBSPEED':u then
            do:
                assign mCloseLog          = false
                       this-object:Append = true
                       .
                // If the config specifies a file name, write a note that we will be using the default log-manager log
                if     log-manager:logging-level ge integer(LogLevelEnum:INFO)
                   and ( not (pcFile eq ? or pcFile eq '':u)
                         and search(log-manager:logfile-name) ne search(pcFile) )
                then
                    log-manager:write-message(substitute('INFO: Current session client type &1 does not support named logs',
                                                          session:client-type),
                                              SubSys).
                return.
            end.
            otherwise
            do:
                if log-manager:logfile-name eq ? then
                do:
                    // The File() constructor raises an error if the filename is invalid or empty
                    assign logfile = new File(pcFile).
                    
                    // make sure that at least a folder exists to write into
                    // don't check first, just try to create
                    if not logfile:FolderExists
                    and not logfile:CreateFolder()
                    then
                        undo, throw new AppError(substitute('Unable to create folder &1', logfile:Folder), 0).
                    
                    // can we write to the file?
                    if not logfile:CanWriteToFile() then
                        undo, throw new AppError(substitute('Unable to write to log &1', logfile:Name), 0).
                    
                    assign log-manager:logfile-name = logfile:Name
                           this-object:Append       = plAppend
                           // we are in control of this file
                           mCloseLog                = true
                           .
                    if not plAppend then
                        log-manager:clear-log().
                end.
                else
                do:
                    if not pcFile eq '':u
                    and not pcFile eq ?
                    // using SEARCH() ensures that the slashes and file-name generally are correct
                    and search(log-manager:logfile-name) ne search(pcFile)
                    then
                        log-manager:write-message(
                                substitute('INFO: Log-manager is already in use. Cannot write to &1', pcFile),
                                SubSys).
                    
                    // this class did not open the log-manager log, so should not close it
                    assign mCloseLog          = false
                           this-object:Append = true.
                end.    // existing
            end.
        end case.
    end constructor.
    
    /** Performs implementation-specific filtering for a logger type
        
        @param LogMessage The message to log. */
    method public void ExecuteFilter(input poEvent as LogEvent):
        if log-manager:logfile-name eq ? then
            return.
        log-manager:write-message(poEvent:Message:Message, SubSys).
    end method.
    
end class.
