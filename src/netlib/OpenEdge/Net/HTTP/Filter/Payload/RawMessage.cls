/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : RawMessage
    Purpose     : Holder for raw (byte) message data
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2021-09-14
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.ByteBucket.

@since(rel='12.5.0':u).
class OpenEdge.Net.HTTP.Filter.Payload.RawMessage:
    /* Contains the byte representation of the start line, per https://datatracker.ietf.org/doc/html/rfc7230#section-3.1 */
    define public property StartLine as ByteBucket no-undo
        get.
        set.
    
    /* Contains the byte representation of the headers for the request, per https://datatracker.ietf.org/doc/html/rfc7230#section-3.2.
       Should always be at least CRLF */
    define public property Headers as ByteBucket no-undo
        get.
        set.
    
    /* Optional byte representation of the message body, per https://datatracker.ietf.org/doc/html/rfc7230#section-3.3 */
    define public property Body as ByteBucket no-undo
        get.
        set.
    
    /* Default constructor */
    constructor public RawMessage():
        // there are always a request line and headers (if only a CRLF)
        assign this-object:StartLine = ByteBucket:Instance()
               this-object:Headers   = ByteBucket:Instance()
               .
    end constructor.
end class.