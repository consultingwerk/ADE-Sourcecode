/* *************************************************************************************************************************
Copyright (c) 2016-2019 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
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

class OpenEdge.Web.DataObject.Writer.ArgumentValueWriter abstract 
            implements ISupportLogging:
    
    /* A reference to the Logger in use by an implementer */
    define public property Logger as ILogWriter no-undo 
        get(): 
            if not valid-object(this-object:Logger) then
                assign this-object:Logger = LoggerBuilder:GetLogger(this-object:GetClass()).
            
            return this-object:Logger.
        end get.
        set.
    
    /** (mandatory) The type that the entity this writer can write to. */
    define public property ArgumentType as class Progress.Lang.Class no-undo
        get.
        protected set(input pType as class Progress.Lang.Class):
            Assert:NotNull(pType, 'Argument type').
            
            assign ArgumentType = pType.
        end set.
    
    /** (mandatory) The message entity that's being written to. The values passed 
        in to the Write() methods will be parsed/processed and written to this entity. */  
    define public property Value as Progress.Lang.Object no-undo
        get.
        set(input poValue as Progress.Lang.Object):
            /* needs to match this type */
            if valid-object(poValue) then
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
        
        @param Object The target object to write to */
    constructor protected ArgumentValueWriter (input pValue as Progress.Lang.Object):
        Assert:NotNull(pValue, 'Argument value').
        
        assign this-object:ArgumentType = pValue:GetClass()
               this-object:Value        = pValue
               .
    end constructor.
    
    /** Constructor.
        
        @param Class  The type of the entity - pseudo-generics here. */
    constructor protected ArgumentValueWriter (input poType as class Progress.Lang.Class):
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
        Logger:Warn(substitute('Write (Object[]) method not implemented in &1', this-object:GetClass():TypeName)). 
    end method.
    
    /** Write data to/from the entity
        
        @param handle Data to write */
    method public void Write(input phData as handle):
        /* no-op */
        Logger:Warn(substitute('Write (handle) method not implemented in &1', this-object:GetClass():TypeName)).
    end method.
    
    method public void Write(input phData as handle extent):
        /* no-op */
        Logger:Warn(substitute('Write (handle[]) method not implemented in &1', this-object:GetClass():TypeName)).
    end method.
    
    method public void Write(input p0 as memptr ):
        /* no-op */
        Logger:Warn(substitute('Write (memptr) method not implemented in &1', this-object:GetClass():TypeName)).
    end method.
    
    method public void Write(input p0 as memptr extent):
        /* no-op */
        Logger:Warn(substitute('Write (memptr[]) method not implemented in &1', this-object:GetClass():TypeName)).
    end method.
    
    method public void Write(input p0 as longchar ):
        /* no-op */
        Logger:Warn(substitute('Write (longchar) method not implemented in &1', this-object:GetClass():TypeName)). 
    end method.
    
    method public void Write(input p0 as longchar extent):
        /* no-op */
        Logger:Warn(substitute('Write (longchar[]) method not implemented in &1', this-object:GetClass():TypeName)). 
    end method.
    
    method public void Write(input p0 as character ):
        /* no-op */
        Logger:Warn(substitute('Write (character) method not implemented in &1', this-object:GetClass():TypeName)). 
    end method.
    
    method public void Write(input p0 as character extent):
        /* no-op */
        Logger:Warn(substitute('Write (character[]) method not implemented in &1', this-object:GetClass():TypeName)). 
    end method.
    
    method public void Write(input p0 as raw):
        /* no-op */
        Logger:Warn(substitute('Write (raw) method not implemented in &1', this-object:GetClass():TypeName)). 
    end method.
    
    method public void Write(input p0 as raw extent):
        /* no-op */
        Logger:Warn(substitute('Write (raw[]) method not implemented in &1', this-object:GetClass():TypeName)). 
    end method.
    
    method public void Write(input p0 as int64):
        /* no-op */
        Logger:Warn(substitute('Write (int64[]) method not implemented in &1', this-object:GetClass():TypeName)). 
    end method.
    
    method public void Write(input p0 as int64 extent):
        /* no-op */
        Logger:Warn(substitute('Write (int64[]) method not implemented in &1', this-object:GetClass():TypeName)). 
    end method.
    
    method public void Write(input p0 as integer):
        /* no-op */
        Logger:Warn(substitute('Write (int[]) method not implemented in &1', this-object:GetClass():TypeName)). 
    end method.
    
    method public void Write(input p0 as integer extent):
        /* no-op */
        Logger:Warn(substitute('Write (int[]) method not implemented in &1', this-object:GetClass():TypeName)). 
    end method.
    
    method public void Write(input p0 as logical):
        /* no-op */
        Logger:Warn(substitute('Write (logical) method not implemented in &1', this-object:GetClass():TypeName)). 
    end method.
    
    method public void Write(input p0 as logical extent):
        /* no-op */
        Logger:Warn(substitute('Write (logical[]) method not implemented in &1', this-object:GetClass():TypeName)). 
    end method.
    
    method public void Write(input p0 as decimal):
        /* no-op */
        Logger:Warn(substitute('Write (decimal) method not implemented in &1', this-object:GetClass():TypeName)). 
    end method.
    
    method public void Write(input p0 as decimal extent):
        /* no-op */
        Logger:Warn(substitute('Write (decimal[]) method not implemented in &1', this-object:GetClass():TypeName)). 
    end method.
    
    method public void Write(input p0 as date):
        /* no-op */
        Logger:Warn(substitute('Write (date) method not implemented in &1', this-object:GetClass():TypeName)). 
    end method.
    
    method public void Write(input p0 as date extent):
        /* no-op */
        Logger:Warn(substitute('Write (date[]) method not implemented in &1', this-object:GetClass():TypeName)). 
    end method.
    
    method public void Write(input p0 as datetime):
        /* no-op */
        Logger:Warn(substitute('Write (datetime) method not implemented in &1', this-object:GetClass():TypeName)). 
    end method.
    
    method public void Write(input p0 as datetime extent):
        /* no-op */
        Logger:Warn(substitute('Write (datetime[]) method not implemented in &1', this-object:GetClass():TypeName)). 
    end method.
    
    method public void Write(input p0 as datetime-tz):
        /* no-op */
        Logger:Warn(substitute('Write (datetime-tz) method not implemented in &1', this-object:GetClass():TypeName)). 
    end method.
    
    method public void Write(input p0 as datetime-tz extent):
        /* no-op */
        Logger:Warn(substitute('Write (datetime-tz[]) method not implemented in &1', this-object:GetClass():TypeName)). 
    end method.
    
    method public void Write(input p0 as rowid):
        /* no-op */
        Logger:Warn(substitute('Write (rowid) method not implemented in &1', this-object:GetClass():TypeName)). 
    end method.
    
    method public void Write(input p0 as rowid extent):
        /* no-op */
        Logger:Warn(substitute('Write (rowid[]) method not implemented in &1', this-object:GetClass():TypeName)). 
    end method.
    
    method public void Write(input p0 as recid):
        /* no-op */
        Logger:Warn(substitute('Write (recid) method not implemented in &1', this-object:GetClass():TypeName)). 
    end method.
    
    method public void Write(input p0 as recid extent):
        /* no-op */
        Logger:Warn(substitute('Write (recid[]) method not implemented in &1', this-object:GetClass():TypeName)). 
    end method.
    
end class.