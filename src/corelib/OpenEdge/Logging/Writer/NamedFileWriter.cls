/* *************************************************************************************************************************
Copyright (c) 2016-2019 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
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
    // stream for the output
    define private stream sFileOutput.
    
    /* The file we're writing to */
    define private variable moFileOutputStream as FileOutputStream  no-undo.
    
    /* (mandatory) The output location */
    define public property FileName as character no-undo
        get():
            if valid-object(moFileOutputStream) then
                return moFileOutputStream:FileName.
        end get.
        
    /* TRUE if we are appending to an existing file */
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
        if not this-object:Append then
        do:
            output stream sFileOutput to value(moFileOutputStream:FileName).
            output stream sFileOutput close.
        end.
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
    
    /** Performs implementation-specific filtering for a logger type
        
        @param LogEvent The event to log. */
    method public void ExecuteFilter(input poEvent as LogEvent):
        define variable mData as memptr no-undo.
        define variable msgLen as integer no-undo.
        
        if moFileOutputStream:Closed then
            return.
        
        // We use a MEMPTR to preserve trailing blanks etc, that are removed by the PUT UNFORMATTED
        assign msgLen = length(poEvent:Message:Message, 'raw':u) + 1.
        set-size(mData) = msgLen.
        put-string(mData, 1, msgLen) = poEvent:Message:Message + StringConstant:LF.
        
        // always write-append here; the Append property applies to the opening of the output stream
        output stream sFileOutput to value(moFileOutputStream:FileName) append.
            export stream sFileOutput mData.
        output stream sFileOutput close.
        
        finally:
            // covers 0 and ?. negative values will have barfed earlier 
            if not msgLen eq 0 then
                set-size(mData) = 0.
        end finally.
    end method.
    
end class.
