/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : JsonBodyResponseFilter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jan 29 10:47:13 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.Memptr.
using OpenEdge.Net.HTTP.IHttpMessage.
using OpenEdge.Net.HTTP.IHttpMessageWriter.
using OpenEdge.Net.HTTP.IHttpResponse.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Payload.JsonBodyResponseFilter implements IHttpMessageWriter: 
	define public property Message as IHttpMessage no-undo get. private set.
	
	define private variable moParser as ObjectModelParser no-undo.
	define private variable moEntity as JsonConstruct no-undo.

	constructor public JsonBodyResponseFilter(input poMessage as IHttpResponse):
		Assert:NotNull(poMessage, 'Http response').
		
		assign this-object:Message = poMessage
		       moParser  = new ObjectModelParser().
	end constructor.
	
	method public void Open():	    	    
	end method.
	
	method public void Write(input poData as Object):
	    define variable oBody as class Memptr no-undo.
	    
	    Assert:NotNull(poData).
	    
	    if not type-of(poData, Memptr) and 
	       not type-of(poData, ByteBucket) then
            return error new AppError(
                            substitute('Unsupported object type: &1', poData:GetClass():TypeName)
                            , 0).
        
        assign oBody = dynamic-invoke(poData, 'GetBytes':u)
               moEntity = cast(moParser:Parse(oBody:Value) , JsonConstruct).
	end method.
	
	method public void Write(input-output pcData as longchar):
	    Assert:NotNullOrEmpty(pcData, 'Data').
	    
	    assign moEntity = cast(moParser:Parse(pcData), JsonConstruct).
	end method.

	method public void Write( input pmData as memptr):
	    Assert:IsPositive(get-size(pmData), 'Data size').
	    
        assign moEntity = cast(moParser:Parse(pmData), JsonConstruct).
	end method.
	
    /** Write data to/from the message

        @param handle Data to write */
    method public void Write(input phData as handle):    
        Assert:NotNull(phData, 'Data').
        
        assign moEntity = cast(moParser:Parse(phData), JsonConstruct).
    end method.

    /** Write data to/from the message

        @param character Data to write */
    method public void Write(input-output pcData as character):    
        Assert:NotNullOrEmpty(pcData, 'Data').
        
        assign moEntity = cast(moParser:Parse(pcData), JsonConstruct).
    end method.    
	
	method public void Flush():
	    this-object:Message:Entity = moEntity.
	end method.
	
	method public void Close():
	    Flush().
	end method.

end class.