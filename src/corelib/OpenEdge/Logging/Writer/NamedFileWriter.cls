/* *************************************************************************************************************************
Copyright (c) 2016-2019, 2021 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : NamedFileWriter
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2016-08-23
    Notes       : * Using OUTPUT TO and EXPORT because of OCTA-9310
                  * This writer always uses LF as a line terminator, regardless
                    of OS/platform
                  * If the APPEND=FALSE option is set (via constructor), the folder
                    and an empty file are created in the constructor.
                  * If APPEND=TRUE, the logfile is only created when the filter
                    executes.
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.File.
using OpenEdge.Core.StringConstant.
using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.LogEvent.
using OpenEdge.Logging.Writer.IFileWriter.
using Progress.IO.FileOutputStream.
using Progress.Lang.AppError.

class OpenEdge.Logging.Writer.NamedFileWriter implements ILoggerFilter, IFileWriter:
    // stream for the output
    define private stream sFileOutput.
    
    /* The file we're writing to */
    var private File mLogFile.
    
    /* (mandatory) The output location */
    define public property FileName as character no-undo
        get.
        private set.
    
    /* TRUE if we are appending to an existing file */
    define public property Append as logical no-undo
        get.
        private set.
    
    /* Constructor
       
       @param FileOutputStream  A file for writing log entries into
       @param LoggerFilterList Formatting filters for this logger  */
    constructor public NamedFileWriter(input poFile as FileOutputStream):
        // this will throw an error if poFile is not valid
        this-object(poFile:FileName, poFile:Append).
    end constructor.
    
    /* Constructor
       
       @param character The file name to write into
       @param logical  TRUE if we are to append to this file */
    constructor public NamedFileWriter(input pcFileName as character,
                                       input plAppend as logical):
        this-object().
        
        Assert:NotNullOrEmpty(pcFileName, 'Log file name').
        if plAppend eq ? then
            assign plAppend = true.
        
        assign this-object:Append   = plAppend
               this-object:mLogFile = new File(pcFileName)
               this-object:FileName = mLogFile:Name
               .
        if not this-object:Append then
        do:
            // create folder(s) for this logfile, if it doesn't exist already
            if not this-object:mLogFile:FolderExists
            and not this-object:mLogFile:CreateFolder()
            then
                undo, throw new AppError(substitute('Unable to create folder &1', mLogFile:Folder), 0).
            
            output stream sFileOutput to value(this-object:FileName).
            output stream sFileOutput close.
        end.
    end constructor.
    
    /* Default constructor */
    constructor protected NamedFileWriter():
        super().
    end constructor.
    
    /** Performs implementation-specific filtering for a logger type
        
        @param LogEvent The event to log. */
    method public void ExecuteFilter(input poEvent as LogEvent):
        define variable mData as memptr no-undo.
        define variable msgLen as integer no-undo.
        
        // make sure that at least a folder exists to write into
        // don't check first, just try to create
        if not mLogFile:FolderExists
        and not mLogFile:CreateFolder()
        then
            undo, throw new AppError(substitute('Unable to create folder &1', mLogFile:Folder), 0).
        
        // can we write to the file?
        if not mLogFile:CanWriteToFile() then
            undo, throw new AppError(substitute('Unable to write to log &1', mLogFile:Name), 0).
        
        // We use a MEMPTR to preserve trailing blanks etc, that are removed by the PUT UNFORMATTED
        assign msgLen = length(poEvent:Message:Message, 'raw':u) + 1.
        set-size(mData) = msgLen.
        put-string(mData, 1, msgLen) = poEvent:Message:Message + StringConstant:LF.
        
        // always write-append here; the Append property applies to the opening of the output stream
        output stream sFileOutput to value(this-object:FileName) append.
            export stream sFileOutput mData.
        output stream sFileOutput close.
        
        finally:
            // covers 0 and ?. negative values will have barfed earlier
            if not msgLen eq 0 then
                set-size(mData) = 0.
        end finally.
    end method.
    
end class.
