/* *************************************************************************************************************************
Copyright (c) 2016-2017 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
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
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.ISupportLogging.
using OpenEdge.Logging.LoggerBuilder.
using Progress.Lang.Object.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.

class OpenEdge.Web.DataObject.Writer.ArgumentValueWriter abstract implements ISupportLogging:
    
    // A reference to the Logger in use by an implementer
    define public property Logger as ILogWriter no-undo 
        get(): 
            if not valid-object(this-object:Logger) then
                assign this-object:Logger = LoggerBuilder:GetLogger(get-class(ArgumentValueWriter)).
            
            return this-object:Logger.
        end get.
        set.    
    
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

    /** Constructor.
        
        @param Class  The type of the entity - pseudo-generics here. */
    constructor protected ArgumentValueWriter (input poType as class Progress.Lang.Class):
        Assert:NotNull(poType, 'Entity type').
        
        assign ArgumentType = poType.
    end constructor.
    
    /** Clears or empties the target */
    method public void Clear():
    end method.
    
    /** Flushes(writes) the input to the target */
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
        /* no-op */
        Logger:Warn('Write (Object[])'). 
    end method.

    /** Write data to/from the entity

        @param handle Data to write */
    method public void Write(input phData as handle):
        /* no-op */
        Logger:Warn('Write (handle)').
    end method.

    method public void Write(input phData as handle extent):
        /* no-op */
        Logger:Warn('Write (handle[])').
    end method.

    method public void Write(input p0 as memptr ):
        /* no-op */
        Logger:Warn('Write (memptr)').
    end method.

    method public void Write(input p0 as memptr extent):
        /* no-op */
        Logger:Warn('Write (memptr[])').
    end method.
    
    method public void Write(input p0 as longchar ):
        /* no-op */
        Logger:Warn('Write (longchar)'). 
    end method.

    method public void Write(input p0 as longchar extent):
        /* no-op */
        Logger:Warn('Write (longchar[])'). 
    end method.
    
    method public void Write(input p0 as character ):
        /* no-op */
        Logger:Warn('Write (character'). 
    end method.

    method public void Write(input p0 as character extent):
        /* no-op */
        Logger:Warn('Write (character[])'). 
    end method.

    method public void Write(input p0 as raw):
        /* no-op */
        Logger:Warn('Write (raw)'). 
    end method.

    method public void Write(input p0 as raw extent):
        /* no-op */
        Logger:Warn('Write (raw[])'). 
    end method.

    method public void Write(input p0 as int64):
        /* no-op */
        Logger:Warn('Write (int64[])'). 
    end method.

    method public void Write(input p0 as int64 extent):
        /* no-op */
        Logger:Warn('Write (int64[])'). 
    end method.

    method public void Write(input p0 as integer):
        /* no-op */
        Logger:Warn('Write (int[])'). 
    end method.

    method public void Write(input p0 as integer extent):
        /* no-op */
        Logger:Warn('Write (int[])'). 
    end method.

    method public void Write(input p0 as logical):
        /* no-op */
        Logger:Warn('Write (logical)'). 
    end method.

    method public void Write(input p0 as logical extent):
        /* no-op */
        Logger:Warn('Write (logical[])'). 
    end method.
    
    method public void Write(input p0 as decimal):
        /* no-op */
        Logger:Warn('Write (decimal)'). 
    end method.

    method public void Write(input p0 as decimal extent):
        /* no-op */
        Logger:Warn('Write (decimal[])'). 
    end method.

    method public void Write(input p0 as date):
        /* no-op */
        Logger:Warn('Write (date)'). 
    end method.

    method public void Write(input p0 as date extent):
        /* no-op */
        Logger:Warn('Write (date[])'). 
    end method.

    method public void Write(input p0 as datetime):
        /* no-op */
        Logger:Warn('Write (datetime)'). 
    end method.

    method public void Write(input p0 as datetime extent):
        /* no-op */
        Logger:Warn('Write (datetime[])'). 
    end method.

    method public void Write(input p0 as datetime-tz):
        /* no-op */
        Logger:Warn('Write (datetime-tz)'). 
    end method.
    
    method public void Write(input p0 as datetime-tz extent):
        /* no-op */
        Logger:Warn('Write (datetime-tz[])'). 
    end method.

    method public void Write(input p0 as rowid):
        /* no-op */
        Logger:Warn('Write (rowid)'). 
    end method.

    method public void Write(input p0 as rowid extent):
        /* no-op */
        Logger:Warn('Write (rowid[])'). 
    end method.

    method public void Write(input p0 as recid):
        /* no-op */
        Logger:Warn('Write (recid)'). 
    end method.
    
    method public void Write(input p0 as recid extent):
        /* no-op */
        Logger:Warn('Write (recid[])'). 
    end method.
    
end class.