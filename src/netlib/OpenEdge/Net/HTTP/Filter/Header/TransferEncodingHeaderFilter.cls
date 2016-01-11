/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : TransferEncodingHeaderFilter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Feb 14 11:47:30 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.Filter.Header.HeaderFilter.
using OpenEdge.Net.HTTP.HttpMessage.
using OpenEdge.Net.HTTP.TransferEncodingEnum.

class OpenEdge.Net.HTTP.Filter.Header.TransferEncodingHeaderFilter inherits HeaderFilter:
	constructor public TransferEncodingHeaderFilter (input poMessage as HttpMessage):
		super (input 'Transfer-Encoding', input poMessage).
	end constructor.
	
	method override public logical AddHeader( input pcName as character, input pcValue as character):
	    define variable oTransferEncoding as TransferEncodingEnum no-undo.
	    
	    oTransferEncoding = TransferEncodingEnum:FromString(pcValue).
	    
        this-object:Message:TransferEncoding = oTransferEncoding. 
        return true.
	end method.
	
	method override public logical RemoveHeader(input pcName as character):
	    return true.
	end method.
	
end class.