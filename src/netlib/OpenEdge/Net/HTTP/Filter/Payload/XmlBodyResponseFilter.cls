/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : XmlBodyResponseFilter
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
using OpenEdge.Core.String.
using OpenEdge.Core.WidgetHandle.
using OpenEdge.Net.HTTP.IHttpMessage.
using OpenEdge.Net.HTTP.IHttpMessageWriter.
using OpenEdge.Net.HTTP.IHttpResponse.
using Progress.Lang.AppError.
using Progress.Lang.Object.
using OpenEdge.Core.DataTypeEnum.

class OpenEdge.Net.HTTP.Filter.Payload.XmlBodyResponseFilter implements IHttpMessageWriter: 
	define public property Message as IHttpMessage no-undo get. private set.
	
	define private variable moEntity as WidgetHandle no-undo.

	constructor public XmlBodyResponseFilter(input poMessage as IHttpResponse):
		Assert:NotNull(poMessage, 'Http response').
		
		assign this-object:Message = poMessage.
	end constructor.
	
	method public void Open():	    	    
	end method.
	
	method public void Write(input poData as Object):
        define variable hDocument as handle no-undo.
        define variable oData as class Memptr no-undo.
        
	    if not type-of(poData, Memptr) and 
	       not type-of(poData, ByteBucket) then
            return error new AppError(
                            substitute('Unsupported object type: &1', poData:GetClass():TypeName)
                            , 0).
                
        assign oData = dynamic-invoke(poData, 'GetBytes':u).
                        
        create x-document hDocument.
        hDocument:load('memptr':u, oData:Value, false).
                
        assign moEntity = new WidgetHandle(hDocument).
	end method.
	
	method public void Write(input-output pcData as longchar):
	    define variable hDocument as handle no-undo.
	    
	    Assert:NotNullOrEmpty(pcData, 'Data').

        create x-document hDocument.
        hDocument:load('longchar':u, pcData, false).

	    assign moEntity = new WidgetHandle(hDocument).
	end method.

	method public void Write( input pmData as memptr):
	    define variable hDocument as handle no-undo.
	    Assert:IsPositive(get-size(pmData), 'Data size').

        create x-document hDocument.
        hDocument:load('memptr':u, pmData, false).
        
        assign moEntity = new WidgetHandle(hDocument).
	end method.
	
    /** Write data to/from the message

        @param handle Data to write */
    method public void Write(input phData as handle):    
        Assert:IsType(phData, DataTypeEnum:XmlDocument).
        
        assign moEntity = new WidgetHandle(phData).
    end method.

    /** Write data to/from the message

        @param character Data to write */
    method public void Write(input-output pcData as character):    
        define variable lcData as longchar no-undo.
        
        assign lcData = pcData.
        this-object:Write(input-output lcData).
        assign pcData = string(lcData).
    end method.    
    
	
	method public void Flush():
	    this-object:Message:Entity = moEntity.
	end method.
	
	method public void Close():
	    Flush().
	end method.

end class.