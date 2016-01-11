/************************************************
Copyright (c)  2014,2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : HttpResponse
    Purpose     : Contains a response for an HttpRequest 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Dec 18 13:24:08 EST 2013
    Notes       : * Via http://www.w3.org/Protocols/rfc2616/rfc2616-sec6.html 
                  Response      = Status-Line               ; Section 6.1
                                       *(( general-header        ; Section 4.5
                                        | response-header        ; Section 6.2
                                        | entity-header ) CRLF)  ; Section 7.1
                                       CRLF
                                       [ message-Entity ]          ; Section 7.2
                http://www.w3.org/Protocols/rfc2616/rfc2616-sec6.html
                
                Status-Line = HTTP-Version SP Status-Code SP Reason-Phrase CRLF                                                
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Net.HTTP.HttpMessage.
using OpenEdge.Net.HTTP.IHttpResponse.

class OpenEdge.Net.HTTP.HttpResponse inherits HttpMessage
        implements IHttpResponse:
    
    /** The status of the HTTP response. Section 6.1 */
    define public property StatusCode as integer no-undo
        get.
        set(input piStatusCode as integer):
            Assert:IsZeroOrPositive(piStatusCode, 'Status Code').
            this-object:StatusCode = piStatusCode.
        end set.
    
    /** The status reason of the HTTP response. Section 6.1 */
    define public property StatusReason as character no-undo get. set.
    
    /** Constructor. */
    constructor public HttpResponse():
        super().
    end constructor.
    
end class.