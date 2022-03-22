/************************************************
Copyright (c) 2015-2018, 2021 by Progress Software Corporation. All rights reserved.
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
using OpenEdge.Logging.LogLevelEnum.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriterErrorEventArgs.
using Progress.IO.FileInputStream.
using Progress.IO.MemoryOutputStream.
using Progress.IO.OutputStream.
using Progress.Lang.Object.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.

class OpenEdge.Net.HTTP.Filter.Payload.MessageWriter abstract inherits OutputStream
            implements ISupportLogging:
    /* An event raised when a writer encounters an error.

       @param Progress.Lang.Object The type/class raising the event
       @param MessageWriterErrorEventArgs A set of arguments relating to the error */
    define static public event WriteError signature void (input pSender as Progress.Lang.Object,
                                                          input pArgs as MessageWriterErrorEventArgs).

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
    end constructor.

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
        return 0.
    end method.

    method override public int64 Write( input p0 as memptr, input p1 as int64, input p2 as int64 ):
        /* no-op */
        Logger:Warn('Write(memptr,int64,int64) is a no-op').
        return 0.
    end method.

    method override public int64 Write( input p0 as memptr ):
        return super:Write(input p0).
    end method.

    method override public int64 Write( input p0 as longchar ):
        /* no-op */
        Logger:Warn('Write(longchar) is a no-op').
        return 0.
    end method.

    method override public int64 Write( input p0 as character ):
        /* no-op */
        Logger:Warn('Write(character) is a no-op').
        return 0.
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

        // workaround for issue PSC00352961/OCTA-3517
        set-size(mData) = file-info:file-size.

        pStream:Read(mData).
        
        return this-object:Write(mData).
        finally:
            set-size(mData) = 0.
        end finally.
    end method.
    
    /** Reads the contents of a MemptrOutputStream and writes the bytes
       
        @param MemptrOutputStream A valid memory stream
        @return int64 The number of bytes written.  */
    method protected int64 WriteMemoryStream(input pStream as MemoryOutputStream):
        define variable mData as memptr no-undo.
        
        Assert:NotNull(pStream, 'Memory output stream').
        
        if pStream:BytesWritten eq 0 then
            return 0.
        
        if pStream:Length gt pStream:BytesWritten then
        do on error undo, throw:
            // this makes a deep copy of the data, but only gives us the bytes actually written
            assign mData = get-bytes(pStream:Data, 1, pStream:BytesWritten).
            return this-object:Write(mData).
            finally:
                set-size(mData) = 0.
            end finally.
        end.
        else
            return this-object:Write(pStream:Data).
    end method.
    
    /* Process a write error
       1) publishes the WriteError event
       2) Calls the WriteErrorHandler in this object
        
       Processes the event args from those calls using Write(args:OutputData). This is to
       determine the number of bytes written.
       
       @param MessageWriterErrorEventArgs (required) The event args for the WriteError event */
    method protected void OnWriteError(input pArgs as MessageWriterErrorEventArgs):
        Assert:NotNull(pArgs, 'Write error event args').
        
        // Let external subscribers process this error first
        MessageWriter:WriteError:Publish(this-object, pArgs).
        
        // Now let this writer instance process the result of the event.
        // If there are no overrides, then this will throw the causal error.
        WriteErrorHandler(this-object, pArgs).
        
        // Try to write the returned value again.
        assign pArgs:BytesWritten = this-object:Write(pArgs:OutputData).
    end method.
    
    /* Event handler for WriteError. This isn't abstract because we don't want to
       require every Entity- and BodyWriter to have to implement this method.

       Default behaviour is to throw the error. Individual writers should override this
       method if they want to implement specific behaviour.

       @param Progress.Lang.Object The type/class raising the event
       @param MessageWriterErrorEventArgs A set of arguments relating to the error */
    method protected void WriteErrorHandler(input pSender as Progress.Lang.Object,
                                            input pArgs as MessageWriterErrorEventArgs):
        // process the event response
        // i)   if there's no OutputData then throw the error.
        // ii)  if it is of this writer's type, assign to the Entity
        if not valid-object(pArgs:OutputData)
        and not pArgs:AllowNullOutput
        then
            return error pArgs:Error.
    end method.
    
end class.