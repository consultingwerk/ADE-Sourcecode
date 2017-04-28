/************************************************
Copyright (c)  2015-2016 by Progress Software Corporation. All rights reserved.
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
using OpenEdge.DataAdmin.Entity.
using OpenEdge.Net.HTTP.IHttpMessage.
using Progress.IO.OutputStream.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Payload.MessageWriter
        inherits OutputStream
        abstract: 
    
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
        LogMessage('Write(handle) is a no-op', 5).
    end method.

    method override public int64 Write( input p0 as memptr, input p1 as int64, input p2 as int64 ):
        /* no-op */        
        LogMessage('Write(memptr,int64,int64) is a no-op', 5).
    end method.
    
    method override public int64 Write( input p0 as memptr ):
        return super:Write(input p0).
    end method.
    
    method override public int64 Write( input p0 as longchar ):
        /* no-op */
        LogMessage('Write(longchar) is a no-op', 5).
    end method.
    
    method override public int64 Write( input p0 as character ):
        /* no-op */        
        LogMessage('Write(character) is a no-op', 5).
    end method.
    
    /** Logs a message 
        
        @param character A message subtype to use
        @param character The message to log
        @param integer  The level this message should be logged at */
    method protected void LogMessage(input pcMessage as character,
                                     input piLogLevel as integer):
        if log-manager:logfile-name eq ? then
            return.
        
        if log-manager:logging-level ge piLogLevel then
            log-manager:write-message(pcMessage, 'MSGWRITE':u).
    end method.
    
end class.