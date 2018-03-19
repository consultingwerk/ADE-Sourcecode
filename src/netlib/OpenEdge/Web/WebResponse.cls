/************************************************
Copyright (c) 2015, 2017  by Progress Software Corporation. All rights reserved.
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
using OpenEdge.Net.HTTP.StatusCodeHelper.
using OpenEdge.Net.HTTP.StatusCodeEnum.

class OpenEdge.Web.WebResponse inherits OpenEdge.Net.HTTP.HttpResponse: 
        
    /* Default constructor. */
    constructor public WebResponse():
        this-object(200).
    end constructor.
    
    /* Constructor.
        
       @param integer A status code for the response    */
    constructor public WebResponse(input pStatusCode as integer):
        super().
        this-object:Initialize().
        
        assign this-object:StatusCode   = pStatusCode
               this-object:StatusReason = StatusCodeHelper:GetMessage(pStatusCode)
               this-object:Version      = 'HTTP/1.1':u.
               .
    end constructor.    

    /* Constructor.
        
       @param StatusCodeEnum A status code for the response    */
    constructor public WebResponse(input pStatusCode as StatusCodeEnum):
        this-object(integer(pStatusCode)).
    end constructor.    

    /** Adds header info to this message's collection of headers.
        
        @param character The header name
        @param character The complete header value  */
    method public void SetHeader(input pcName as character, input pcValue as character):
        this-object:SetHeader(HttpHeaderBuilder:Build(pcName):Value(pcValue):Header ).
    end method.
    
end class.