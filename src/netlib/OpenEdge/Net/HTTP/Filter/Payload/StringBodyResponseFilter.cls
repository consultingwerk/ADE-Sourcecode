/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : StringBodyResponseFilter
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
using OpenEdge.Net.HTTP.IHttpMessage.
using OpenEdge.Net.HTTP.IHttpMessageWriter.
using OpenEdge.Net.HTTP.IHttpResponse.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Payload.StringBodyResponseFilter implements IHttpMessageWriter: 
	define public property Message as IHttpMessage no-undo get. private set.
	
	define private variable moEntity as String no-undo.

	constructor public StringBodyResponseFilter(input poMessage as IHttpResponse):
		Assert:NotNull(poMessage, 'Http response').
		
		assign this-object:Message = poMessage.
	end constructor.
	
	method public void Open():	    	    
	end method.
	
	method public void Write(input poData as Object):
	    define variable lcData as longchar no-undo.
        define variable cCharset as character no-undo.
        define variable oData as class Memptr no-undo.
        
	    if not type-of(poData, Memptr) and 
	       not type-of(poData, ByteBucket) then
            return error new AppError(
                            substitute('Unsupported object type: &1', poData:GetClass():TypeName)
                            , 0).
                
        assign cCharset = this-object:Message:CharacterEncoding.
        if cCharset eq '':u then
            cCharset = 'UTF-8':u.
        
        fix-codepage(lcData) = cCharset.
        
        if Message:ContentLength gt 0 then
        do:
            assign oData = dynamic-invoke(poData, 'GetBytes').
            if session:debug-alert then
                copy-lob from oData:Value to file session:temp-directory + 'body.txt':u.
            copy-lob from oData:Value 
                        for Message:ContentLength /* - 1 */
                     to lcData.
        end.
        
        assign moEntity = new String(lcData).
	end method.
	
	method public void Write(input-output pcData as longchar):
	    define variable cCharset as character no-undo.
	    
	    Assert:NotNullOrEmpty(pcData, 'Data').

        assign cCharset = this-object:Message:CharacterEncoding.
        if cCharset eq '':u then
            cCharset = 'UTF-8':u.
        
        if is-codepage-fixed(pcData) then
            Assert:Equals(cCharset, get-codepage(pcData)).            
	    
	    assign moEntity = new String(pcData).
	end method.

	method public void Write( input pmData as memptr):
        define variable lcData as longchar no-undo.
        define variable cCharset as character no-undo.
	    
	    Assert:IsPositive(get-size(pmData), 'Data size').

        assign cCharset = this-object:Message:CharacterEncoding.
        if cCharset eq '':u then
            cCharset = 'UTF-8':u.
	    
        fix-codepage(lcData) = cCharset.
        
        if Message:ContentLength gt 0 then
        do:
            if session:debug-alert then
                copy-lob from pmData to file session:temp-directory + 'body.txt':u.
            copy-lob from pmData 
                        for Message:ContentLength /* - 1 */
                     to lcData.
        end.
        
        assign moEntity = new String(lcData).	    
	end method.
	
    /** Write data to/from the message

        @param handle Data to write */
    method public void Write(input phData as handle):    
        /* no-op */
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