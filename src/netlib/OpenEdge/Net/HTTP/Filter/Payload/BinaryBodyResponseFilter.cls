/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : BinaryBodyResponseFilter
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
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Payload.BinaryBodyResponseFilter implements IHttpMessageWriter: 
	define public property Message as IHttpMessage no-undo get. private set.
	
	define private variable moEntity as class Memptr no-undo.

	constructor public BinaryBodyResponseFilter(input poMessage as IHttpResponse):
		Assert:NotNull(poMessage, 'Http response').
		
		assign this-object:Message = poMessage.
	end constructor.
	
	method public void Open():	    	    
	end method.
	
	method public void Write(input poData as Object):
	    define variable lcData as longchar no-undo.
        define variable cCharset as character no-undo.
        define variable oData as class Memptr no-undo.
        
	    if type-of(poData, Memptr) then
	       assign moEntity = cast(poData, Memptr).
        else
        if type-of(poData, ByteBucket) then
            assign moEntity = cast(poData, ByteBucket):GetBytes().	           
        else            	       
            return error new AppError(
                            substitute('Unsupported object type: &1', poData:GetClass():TypeName)
                            , 0).
	end method.
	
	method public void Write(input-output pcData as longchar):
	    define variable mData as memptr no-undo.
	    
	    Assert:NotNullOrEmpty(pcData, 'Data').
        
        set-size(mData) = length(pcData, 'RAW') + 1.
        put-string(mData,1) = pcData.
        
        this-object:Write(mData).
        finally:
            set-size(mData) = 0.
        end finally.
	end method.

	method public void Write(input pmData as memptr):
	    Assert:IsPositive(get-size(pmData), 'Data size').
	    
        assign moEntity = new Memptr(pmData).
	end method.
	
    /** Write data to/from the message

        @param handle Data to write */
    method public void Write(input phData as handle):    
        /* no-op */
    end method.

    /** Write data to/from the message

        @param character Data to write */
    method public void Write(input-output pcData as character):
        define variable mData as memptr no-undo.
        
        Assert:NotNullOrEmpty(pcData, 'Data').
        
        set-size(mData) = length(pcData, 'RAW') + 1.
        put-string(mData,1) = pcData.
        
        this-object:Write(mData).
        finally:
            set-size(mData) = 0.
        end finally.
    end method.	
	
	method public void Flush():
	    this-object:Message:Entity = moEntity.
	end method.
	
	method public void Close():
	    Flush().
	end method.

end class.