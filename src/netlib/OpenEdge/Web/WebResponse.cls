/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/  
/*------------------------------------------------------------------------
   File        : WebResponse
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : mbanks
   Created     : Wed Jun 03 13:27:12 EDT 2015
   Notes       : 
 ----------------------------------------------------------------------*/
using OpenEdge.Net.HTTP.HttpHeaderBuilder.

class OpenEdge.Web.WebResponse 
    inherits OpenEdge.Net.HTTP.HttpResponse: 
        
    /** Constructor. */
    constructor public WebResponse():
        super().
        this-object:Initialize().
        this-object:StatusCode = 200.
        this-object:StatusReason = "OK":u.
        this-object:Version = 'HTTP/1.1':u.
    end constructor.    

    /** Adds header info to this message's collection of headers.
        
        @param character The header name
        @param character The complete header value  */
    method public void SetHeader(input pcName as character, input pcValue as character):
        this-object:SetHeader(HttpHeaderBuilder:Build(pcName):Value(pcValue):Header ).
    end method.
    
end class.