/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : NamedFileWriter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-08-23
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Logging.LogLevelEnum.
using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.LogEvent.
using Progress.IO.FileOutputStream.
using OpenEdge.Logging.Writer.IFileWriter.
using OpenEdge.Core.StringConstant.

class OpenEdge.Logging.Writer.NamedFileWriter implements ILoggerFilter, IFileWriter:
    // The file we're writing to

    define private variable moFileOutputStream as FileOutputStream  no-undo.

    // (mandatory) The output location 

    define public property FileName as character no-undo
        get():
            if valid-object(moFileOutputStream) then
                return moFileOutputStream:FileName.
        end get.
        
    // TRUE if we are appending to an existing file

    define public property Append as logical no-undo get. private set. 
    
    /* Constructor
       
       @param FileOutputStream  A file for writing log entries into
       @param LoggerFilterList Formatting filters for this logger  */
    constructor public NamedFileWriter(input poFile as FileOutputStream):
        this-object().
        
        Assert:NotNull(poFile, 'Log file').
        assign moFileOutputStream = poFile
               this-object:Append = moFileOutputStream:Append
               .
    end constructor.
    
    /* Constructor
    
       @param character The file name to write into
       @param logical  TRUE if we are to append to this file */
    constructor public NamedFileWriter(input pcFileName as character,
                                       input plAppend as logical):
        this-object(new FileOutputStream(pcFileName, plAppend)).
    end constructor.
    
    /* Default constructor */
    constructor protected NamedFileWriter():
        super().
    end constructor.
    
    destructor NamedFileWriter():
        moFileOutputStream:Close().
    end destructor.
    
    /* Writes a log message
       
       @param LogMessage the message to be written */    
    /** Performs implementation-specific filtering for a logger type
        
        @param LogMessage The message to log. */
    method public void ExecuteFilter(input poEvent as LogEvent):
        define variable mLine as memptr no-undo.
        define variable iSize as integer no-undo.

        if moFileOutputStream:Closed then
            return.
            
        assign iSize = length(poEvent:Message:Message, 'raw':u) + 2.
        set-size(mLine) = iSize.
        put-string(mLine, 1) = poEvent:Message:Message + StringConstant:LF.
        
        moFileOutputStream:Write(mLine, 1, iSize - 1).
        
        // force a write 

        moFileOutputStream:Flush().
        finally:
            set-size(mLine) = 0.
        end finally.
    end method.
    
end class.
