/************************************************
Copyright (c) 2015-2018 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : MessageWriter
    Purpose     : Writes content into an object, like
                  a JsonObject or String or Memptr or ByteBucket
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jun 25 15:41:58 EDT 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Assertion.AssertObject.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.ISupportLogging.
using OpenEdge.Logging.LoggerBuilder.
using Progress.IO.OutputStream.
using Progress.Lang.Object.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using OpenEdge.Logging.LogLevelEnum.
using Progress.IO.FileInputStream.

class OpenEdge.Net.HTTP.Filter.Payload.MessageWriter abstract inherits OutputStream
            implements ISupportLogging:
    
    // A reference to the Logger in use by an implementer
    define public property Logger as ILogWriter no-undo 
        get():
            if not valid-object(this-object:Logger) then
                assign this-object:Logger = LoggerBuilder:GetLogger(this-object:GetClass()).
            
            return this-object:Logger.
        end get.
        set.
    
    /** (mandatory) The type that the entity this writer can write to. */
    define public property EntityType as class Progress.Lang.Class no-undo get. private set.
    
    /** (mandatory) The message entity that's being written to. The values passed 
        in to the Write() methods will be parsed/processed and written to this entity. */  
    define public property Entity as Object no-undo
            get.
            set(input poEntity as Object):
                /* needs to match this type */
                AssertObject:IsType(poEntity, EntityType).
                
                assign this-object:Entity = poEntity.
            end set.
    
    /** Constructor.
        
        @param Class  The type of the entity - pseudo-generics here.
        @param Object The 'real' entity being written */
    constructor protected MessageWriter (input poType as class Progress.Lang.Class,
                                        input poEntity as Object):
        this-object(poType).
        
        Assert:NotNull(poEntity, 'Entity').
        assign Entity = poEntity.
    end method.

    /** Default constructor. */
    constructor protected MessageWriter (input poType as class Progress.Lang.Class):
            
        Assert:NotNull(poType, 'Entity type').
        assign EntityType = poType.
    end constructor.
    
    /** Opens the writer for output. Open/Close allows us to write the same message multiple
        times without requiring a new writer each time. */
    method public void Open():
    end method.
    
    /**  Closes the writer. */
    method override public void Close():
        this-object:Flush().
        
        super:Close().
    end method.
    
    /** Write data to/from the entity  
    
        @param Object Data to write */
    method abstract public int64 Write(input poData as Object).

    /** Write data to/from the entity

        @param handle Data to write */
    method override public int64 Write(input phData as handle):
        Logger:Warn('Write(handle) is a no-op').
    end method.

    method override public int64 Write( input p0 as memptr, input p1 as int64, input p2 as int64 ):
        /* no-op */        
        Logger:Warn('Write(memptr,int64,int64) is a no-op').
    end method.
    
    method override public int64 Write( input p0 as memptr ):
        return super:Write(input p0).
    end method.
    
    method override public int64 Write( input p0 as longchar ):
        /* no-op */
        Logger:Warn('Write(longchar) is a no-op').
    end method.
    
    method override public int64 Write( input p0 as character ):
        /* no-op */        
        Logger:Warn('Write(character) is a no-op').
    end method.
    
    /** Logs a message 
        
        @param character The message to log
        @param LogLevelEnum  The level this message should be logged at */
    @deprecated(since="11.7.0", use="this-object:Logger:<LogLevel>" ).
    method protected void LogMessage(input pcMessage as character,
                                     input poLogLevel as LogLevelEnum):
        if valid-object(poLogLevel) then
            LogMessage(pcMessage, integer(poLogLevel)).
        else
            Logger:Warn(pcMessage).
    end method.
    
    /** Logs a message.
        
        @param character The message to log
        @param integer  The level this message should be logged at */
    @deprecated(since="11.7.0", use="this-object:Logger:<LogLevel>" ).
    method protected void LogMessage(input pcMessage as character,
                                     input piLogLevel as integer):
        case piLogLevel:
            when integer(LogLevelEnum:FATAL) then Logger:Fatal(pcMessage).
            when integer(LogLevelEnum:ERROR) then Logger:Error(pcMessage).
            when integer(LogLevelEnum:WARN ) then Logger:Warn(pcMessage).
            when integer(LogLevelEnum:INFO ) then Logger:Info(pcMessage).
            when integer(LogLevelEnum:DEBUG) then Logger:Debug(pcMessage).
            when integer(LogLevelEnum:TRACE) then Logger:Trace(pcMessage).
            otherwise 
                Logger:Warn(pcMessage).
        end case.
    end method.
    
    /** Reads the contents of a file and writes the bytes as memptr
           
        @param FileInputStream A valid file stream
        @return int64 The number of bytes read. */
    method protected int64 WriteFileStream(input pStream as FileInputStream):
        define variable mData as memptr no-undo.
        
        Assert:NotNull(pStream, 'File input stream').
        
        assign file-info:file-name = pStream:FileName.
        
        // workaround for issue PSC00352961
        set-size(mData) = file-info:file-size.
        
        pStream:Read(mData).
        
        return this-object:Write(mData).
        finally:
            set-size(mData) = 0.
        end finally.
    end method.
    
end class.