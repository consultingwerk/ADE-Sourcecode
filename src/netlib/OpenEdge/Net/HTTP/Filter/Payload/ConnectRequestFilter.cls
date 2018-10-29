/************************************************
Copyright (c) 2018 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : ConnectRequestFilter
    Purpose     : Writes data for a CONNECT request into another data structure,
                  as passed into the Write() methods.
    Author(s)   : pjudge
    Created     : 2018-07-16
    Notes       : * From https://tools.ietf.org/html/rfc7231#section-4.3.6
                    A client sending a CONNECT request MUST send the authority form of
                    request-target (Section 5.3 of [RFC7230]); i.e., the request-target
                    consists of only the host name and port number of the tunnel
                    destination, separated by a colon.  For example,
                        CONNECT server.example.com:80 HTTP/1.1
                        Host: server.example.com:80
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.StringConstant.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.UriSchemeEnum.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Payload.ConnectRequestFilter inherits MessageWriter:
    /* Default constructor */
    constructor public ConnectRequestFilter():
        super(get-class(ByteBucket)).
    end constructor.
    
    /* Write*/
    method override public int64 Write(input pData as Object):
        define variable req as IHttpRequest no-undo.
        define variable prevSize as int64 no-undo.
        define variable requestURI as character no-undo.
        define variable host as character no-undo.
        define variable port as integer no-undo.
        
        Assert:IsType(pData, get-class(IHttpRequest)).
        
        assign prevSize = cast(this-object:Entity, ByteBucket):Size
               req      = cast(pData, IHttpRequest)
               .
        Assert:NotNull(req:URI, 'Request URI').
        assign host = req:URI:Host
               port = req:URI:Port
               .
        // double check for safety
        Assert:NotNullOrEmpty(host, 'Host name').
        // default the port value, if not specified
        if port eq ? then
        case req:URI:Scheme:
            when string(UriSchemeEnum:http)  then assign port = 80.
            when string(UriSchemeEnum:https) then assign port = 443.
        end case.
        Assert:NotNullOrZero(port, 'Port').
        
        if port gt 65535 then
            return error new AppError(substitute('Port is too large: &1 (max allowed: 65535)', port), 0).
        
        assign requestURI = substitute('&1:&2':u, host, port).
        
        // CONNECT
        cast(this-object:Entity, ByteBucket):PutString(
                    substitute('CONNECT &1 &2&3':u,
                                requestURI,
                                req:Version,
                                StringConstant:CRLF)).
        
        // HEADERS
        cast(this-object:Entity, ByteBucket):PutString(substitute('Host: &1&2':u, requestURI, StringConstant:CRLF)).
        cast(this-object:Entity, ByteBucket):PutString(substitute('&1&2':u, req:GetHeader('User-Agent':u):ToString(), StringConstant:CRLF)).
        cast(this-object:Entity, ByteBucket):PutString(substitute('Connection: keep-alive&1':u, StringConstant:CRLF)).
        
        /* ALWAYS add a trailing CRLF to indicate end of headers. */
        cast(this-object:Entity, ByteBucket):PutString(StringConstant:CRLF).
        
        // Only return what we write here
        return (cast(this-object:Entity, ByteBucket):Size - prevSize).
    end method.
    
end class.