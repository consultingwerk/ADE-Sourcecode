/*------------------------------------------------------------------------
    File        : ClientSocketConnectionParameters
    Purpose     : Connection parameters for a client socket connection
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Nov 25 09:51:13 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.URI.
using OpenEdge.Net.UriSchemeEnum.
using OpenEdge.Core.ServerConnection.IConnectionParameters.
using OpenEdge.Core.ServerConnection.FormatMaskEnum.
using OpenEdge.Core.Assert.
using Progress.Lang.AppError.
using OpenEdge.Core.String.

class OpenEdge.Net.ServerConnection.ClientSocketConnectionParameters 
                implements IConnectionParameters:
    
    define public property FormatMask as FormatMaskEnum no-undo
       get():
           return FormatMaskEnum:Custom.
       end get.
    
    define public property URI as URI no-undo 
       get.
       set(input poURI as URI):
           Assert:NotNull(poURI, 'Socket connection URI').
           assign this-object:URI = poURI.
       end set.
    
    /** Determines whether the client connection should verify the host
        certificate for SSL */
    define public property VerifyHost as logical no-undo get. set.
    
    /** (optional) A comma-delimited list of SSL protocols for this connection to use */
    define public property SslProtocols as character extent no-undo get. set.

    /** (optional) A comma-delimited list of SSL ciphers for this connection to use */
    define public property SslCiphers as character extent no-undo get. set.
    
    constructor ClientSocketConnectionParameters(input poURI as URI):
        this-object().
        
        assign this-object:URI = poURI.
    end constructor.

    constructor ClientSocketConnectionParameters():
        assign this-object:VerifyHost   = true.
    end constructor.
    
    method public character GetConnectionString():
        define variable cHost as character no-undo.
        define variable iPort as integer no-undo.
        define variable cSSL as character no-undo.
        
        assign cHost = this-object:URI:Host
               iPort = this-object:URI:Port
               cSSL  =  '':u.
        
        /* double check for safety */
        Assert:NotNullOrEmpty(cHost, 'Host name').
        
        if iPort eq ? then
        case this-object:URI:Scheme:
            when UriSchemeEnum:Http:Name  then assign iPort = 80.
            when UriSchemeEnum:Https:Name then assign iPort = 443.
        end case.
        Assert:NotNullOrZero(iPort, 'Port').
        if iPort gt 65535 then
            return error new AppError(
                                substitute('Port is too large: &1', iPort),
                                0).
        
        /* SSL connections only ... */
        if this-object:URI:Scheme eq UriSchemeEnum:Https:Name then
            assign cSSL = substitute('-ssl &1 &2 &3 &4 &5':u,
                            (if this-object:VerifyHost   eq false then '-nohostverify':u else '':u),
                            (if extent(this-object:SslProtocols) eq ? then '':u else '-sslprotocols':u),
                            String:Join(this-object:SslProtocols, ',':u),
                            (if extent(this-object:SslCiphers) eq ? then '':u else '-sslciphers':u),
                            String:Join(this-object:SslCiphers, ',':u)).
        
        return substitute('-H &1 -S &2 &3':u, 
                               cHost, 
                               iPort,
                               cSSL).
    end method.

    method public character GetConnectionString( input pcFormatMask as character ):
        return GetConnectionString().
    end method.

    method public character GetConnectionString( input poFormatMask as FormatMaskEnum ):
        return GetConnectionString().
    end method.
    
end class.