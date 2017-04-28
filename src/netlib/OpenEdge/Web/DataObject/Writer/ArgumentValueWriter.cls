/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
 /*------------------------------------------------------------------------
    File        : ArgumentValueWriter
    Purpose     : Abstract OperationArgument:ArgumentValue writer 
    Author(s)   : pjudge
    Created     : 2016-06-07
    Notes       : * The default behaviour of all the Write() methods is a NO-OP
                    which also writes a log message. The only exception to this
                    is the abstract Write(Progress.Lang.Object) method. 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Assertion.AssertObject.
using OpenEdge.Core.LogLevelEnum.
using OpenEdge.Core.Util.ISupportLogging.
using Progress.Lang.Object.

class OpenEdge.Web.DataObject.Writer.ArgumentValueWriter abstract
        implements ISupportLogging :
    
    define public event LogMessage signature void (input poSender as Progress.Lang.Object, 
                                                   input pcMessageGroup as character, 
                                                   input pcMessage as character, 
                                                   input poLogLevel as LogLevelEnum).                

    /** (mandatory) The type that the entity this writer can write to. */
    define public property ArgumentType as class Progress.Lang.Class no-undo get. private set.
    
    /** (mandatory) The message entity that's being written to. The values passed 
        in to the Write() methods will be parsed/processed and written to this entity. */  
    define public property Value as Progress.Lang.Object no-undo
        get.
        set(input poValue as Progress.Lang.Object):
            /* needs to match this type */
            AssertObject:IsType(poValue, this-object:ArgumentType).
            
            assign this-object:Value = poValue.
        end set.
        
    /** Constructor.
        
        @param Class  The type of the entity - pseudo-generics here.
        @param Object The 'real' entity being written */
    constructor protected ArgumentValueWriter (input poType as class Progress.Lang.Class,
                                               input poValue as Object):
        this-object(poType).
        
        Assert:NotNull(poValue, 'Value holder').
        assign this-object:Value = poValue.
    end method.

    /** Default constructor. */
    constructor protected ArgumentValueWriter (input poType as class Progress.Lang.Class):
        Assert:NotNull(poType, 'Entity type').
        
        assign ArgumentType = poType.
    end constructor.
    
    method public void Flush(  ):
    end method.

    /** Opens the writer for output. Open/Close allows us to write the same message multiple
        times without requiring a new writer each time. */
    method public void Open():
    end method.
    
    /**  Closes the writer. */
    method public void Close():
        this-object:Flush().
    end method.
    
    /** Write data to/from the entity  
    
        @param Object Data to write */
    method abstract public void Write(input poData as Object).

    /** Write data to/from the entity  
    
        @param Object[] Data to write */
    method public void Write(input poData as Object extent):
        LogMessage('Write(handle) is a no-op', LogLevelEnum:WARN).
    end method.

    /** Write data to/from the entity

        @param handle Data to write */
    method public void Write(input phData as handle):
        LogMessage('Write(handle) is a no-op', LogLevelEnum:WARN).
    end method.

    method public void Write(input phData as handle extent):
        LogMessage('Write(handle[]) is a no-op', LogLevelEnum:WARN).
    end method.

    method public void Write(input p0 as memptr ):
        /* no-op */
        LogMessage('Write(memptr) is a no-op', LogLevelEnum:WARN).
    end method.

    method public void Write(input p0 as memptr extent):
        LogMessage('Write(memptr[]) is a no-op', LogLevelEnum:WARN).
    end method.
    
    method public void Write(input p0 as longchar ):
        /* no-op */
        LogMessage('Write(longchar) is a no-op', LogLevelEnum:WARN).
    end method.

    method public void Write(input p0 as longchar extent):
        /* no-op */
        LogMessage('Write(longchar[]) is a no-op', LogLevelEnum:WARN).
    end method.
    
    method public void Write(input p0 as character ):
        /* no-op */        
        LogMessage('Write(character) is a no-op', LogLevelEnum:WARN).
    end method.

    method public void Write(input p0 as character extent):
        /* no-op */        
        LogMessage('Write(character[]) is a no-op', LogLevelEnum:WARN).
    end method.

    method public void Write(input p0 as raw):
        /* no-op */        
        LogMessage('Write(raw) is a no-op', LogLevelEnum:WARN).
    end method.

    method public void Write(input p0 as raw extent):
        /* no-op */        
        LogMessage('Write(raw[]) is a no-op', LogLevelEnum:WARN).
    end method.

    method public void Write(input p0 as int64):
        /* no-op */
        LogMessage('Write(int64) is a no-op', LogLevelEnum:WARN).
    end method.

    method public void Write(input p0 as int64 extent):
        /* no-op */
        LogMessage('Write(int64[]) is a no-op', LogLevelEnum:WARN).
    end method.

    method public void Write(input p0 as integer):
        /* no-op */
        LogMessage('Write(integer) is a no-op', LogLevelEnum:WARN).
    end method.

    method public void Write(input p0 as integer extent):
        /* no-op */
        LogMessage('Write(integer[]) is a no-op', LogLevelEnum:WARN).
    end method.

    method public void Write(input p0 as logical):
        /* no-op */
        LogMessage('Write(logical) is a no-op', LogLevelEnum:WARN).
    end method.

    method public void Write(input p0 as logical extent):
        /* no-op */
        LogMessage('Write(logical[]) is a no-op', LogLevelEnum:WARN).
    end method.
    
    method public void Write(input p0 as decimal):
        /* no-op */
        LogMessage('Write(decimal) is a no-op', LogLevelEnum:WARN).
    end method.

    method public void Write(input p0 as decimal extent):
        /* no-op */
        LogMessage('Write(decimal[]) is a no-op', LogLevelEnum:WARN).
    end method.

    method public void Write(input p0 as date):
        /* no-op */
        LogMessage('Write(date) is a no-op', LogLevelEnum:WARN).
    end method.

    method public void Write(input p0 as date extent):
        /* no-op */
        LogMessage('Write(date[]) is a no-op', LogLevelEnum:WARN).
    end method.

    method public void Write(input p0 as datetime):
        /* no-op */
        LogMessage('Write(datetime) is a no-op', LogLevelEnum:WARN).
    end method.

    method public void Write(input p0 as datetime extent):
        /* no-op */
        LogMessage('Write(datetime[]) is a no-op', LogLevelEnum:WARN).
    end method.

    method public void Write(input p0 as datetime-tz):
        /* no-op */
        LogMessage('Write(datetime-tz) is a no-op', LogLevelEnum:WARN).
    end method.
    
    method public void Write(input p0 as datetime-tz extent):
        /* no-op */
        LogMessage('Write(datetime-tz[]) is a no-op', LogLevelEnum:WARN).
    end method.

    method public void Write(input p0 as rowid):
        /* no-op */
        LogMessage('Write(rowid) is a no-op', LogLevelEnum:WARN).
    end method.

    method public void Write(input p0 as rowid extent):
        /* no-op */
        LogMessage('Write(rowid[]) is a no-op', LogLevelEnum:WARN).
    end method.

    method public void Write(input p0 as recid):
        /* no-op */
        LogMessage('Write(recid) is a no-op', LogLevelEnum:WARN).
    end method.
    
    method public void Write(input p0 as recid extent):
        /* no-op */
        LogMessage('Write(recid[]) is a no-op', LogLevelEnum:WARN).
    end method.
    
    /** Logs a message 
        
        @param character The message to log
        @param LogLevelEnum  The level this message should be logged at */
    method protected void LogMessage(input pcMessage as character,
                                     input poLogLevel as LogLevelEnum):
        this-object:LogMessage:Publish(this-object, 'COH-AVW':u,
                                       substitute('[&1] &2',
                                            this-object:GetClass():TypeName, 
                                            pcMessage),
                                       poLogLevel).
    end method.
    
end class.