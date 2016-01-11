/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : JsonEntityWriter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jan 29 10:47:13 EST 2015
    Notes       : - Write() operations are destructive (they replace the existing
                    Entity).
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.Memptr.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Lang.AppError.
using Progress.Lang.Object.
using Progress.Json.ObjectModel.JsonObject.

class OpenEdge.Net.HTTP.Filter.Payload.JsonEntityWriter inherits MessageWriter:
    define private variable moParser as ObjectModelParser no-undo.
    
    constructor public JsonEntityWriter():
        super(get-class(JsonConstruct)).
    end constructor. 

	method override public void Open():	   
	    super:Open().
	     
	    assign moParser = new ObjectModelParser().
	end method.
	
    method override public void Close():
        super:Close().
        
        assign moParser = ?.
    end method.
	
    method override public int64 Write(input poData as Object):
        define variable oBody as class Memptr no-undo.
        
        Assert:NotNull(poData).
        
        if not type-of(poData, Memptr) and 
           not type-of(poData, ByteBucket) then
            return error new AppError(
                            substitute('Unsupported object type: &1', poData:GetClass():TypeName)
                            , 0).
        
        assign oBody = dynamic-invoke(poData, 'GetBytes':u).
        
        if oBody:Size eq 0 then
            assign this-object:Entity = new JsonObject().
        else
            assign this-object:Entity = cast(moParser:Parse(oBody:Value) , JsonConstruct).
        
        return oBody:Size.               
    end method.

	method override public int64 Write(input pcData as longchar):
	    define variable iBytesWritten as integer no-undo.
	    
	    assign iBytesWritten = length(pcData, 'raw':u).
	    
	    Assert:IsZeroOrPositive(iBytesWritten, 'Data').

        if iBytesWritten eq 0 then
            assign this-object:Entity = new JsonObject().
        else
    	    assign this-object:Entity = cast(moParser:Parse(pcData), JsonConstruct).
	    
	    return iBytesWritten.
	end method.

	method override public int64 Write( input pmData as memptr):
        define variable iBytesWritten as integer no-undo.

	    assign iBytesWritten = get-size(pmData).
	    Assert:IsZeroOrPositive(iBytesWritten, 'Data size').
	    
        if iBytesWritten eq 0 then
            assign this-object:Entity = new JsonObject().
        else
	       assign this-object:Entity = cast(moParser:Parse(pmData), JsonConstruct).
        
        return iBytesWritten.
	end method.
	
    /** Write data to/from the message

        @param handle Data to write */
    method override public int64 Write(input phData as handle):
        Assert:NotNull(phData, 'Data').
        
        assign this-object:Entity = cast(moParser:Parse(phData), JsonConstruct).
        
        return ?.
    end method.

    /** Write data to/from the message

        @param character Data to write */
    method override public int64 Write(input pcData as character):
        define variable iBytesWritten as integer no-undo.
        
        assign iBytesWritten = length(pcData, 'raw':u).
        
        Assert:IsZeroOrPositive(iBytesWritten, 'Data').

        if iBytesWritten eq 0 then
            assign this-object:Entity = new JsonObject().
        else
            assign this-object:Entity = cast(moParser:Parse(pcData), JsonConstruct).
        
        return iBytesWritten.
    end method.    
	
end class.