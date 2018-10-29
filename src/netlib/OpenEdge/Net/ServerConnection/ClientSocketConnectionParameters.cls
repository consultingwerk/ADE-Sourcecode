/************************************************
Copyright (c) 2014, 2017-2018 by Progress Software Corporation. All rights reserved.
*************************************************/ 
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

using OpenEdge.Core.Assert.
using OpenEdge.Core.ServerConnection.FormatMaskEnum.
using OpenEdge.Core.ServerConnection.IConnectionParameters.
using OpenEdge.Core.String.
using OpenEdge.Core.StringConstant.
using OpenEdge.Net.URI.
using OpenEdge.Net.UriSchemeEnum.
using Progress.Lang.AppError.

class OpenEdge.Net.ServerConnection.ClientSocketConnectionParameters 
                implements IConnectionParameters:
    
    define public property FormatMask as FormatMaskEnum no-undo
       get():
           return FormatMaskEnum:Custom.
       end get.
    
    /* The URI to which to connect */
    define public property URI as URI no-undo 
       get.
       set(input poURI as URI):
           Assert:NotNull(poURI, 'Socket connection URI').
           assign this-object:URI = poURI.
       end set.
    
    /** Sets the -NoSessionReuse flag for SSL */
    define public property ReuseSession as logical no-undo get. set.
    
    /** Determines whether the client connection should verify the host
        certificate for SSL */
    define public property VerifyHost as logical no-undo get. set.
    
    /** (optional) An array of SSL protocols for this connection to use */
    define public property SslProtocols as character extent no-undo get. set.
    
    /** (optional) An array of SSL ciphers for this connection to use */
    define public property SslCiphers as character extent no-undo get. set.
    
    /** (optional) The Server name indicator for TLS. Server Name Indication (SNI)
        is an extension to the TLS computer networking protocol. 
        
        This value is set for the -servername connection property iff HTTPS is used */
    define public property ServerNameIndicator as character  no-undo get. set.
    
    /* Constructor
       
       @param URI The URI of the connection */
    constructor ClientSocketConnectionParameters(input poURI as URI):
        this-object().
        
        Assert:NotNull(poURI, 'URI').
        
        assign this-object:URI = poURI.
    end constructor.
    
    /* Constructor
       
       @param character The scheme (HTTP/HTTPS)
       @param character The host to which to connect  
       @param integer  The port to which to connect */
    constructor ClientSocketConnectionParameters(input pScheme as character,  
                                                 input pHost as character,
                                                 input pPort as integer):
        this-object().
        
        Assert:NotNullOrEmpty(pScheme, 'URI scheme').
        Assert:NotNullOrEmpty(pHost, 'Host name').
        Assert:IsPositive(pPort, 'Port').
        
        assign this-object:URI = new URI(pScheme, pHost, pPort).
    end constructor.
    
    /* Default constructor */
    constructor ClientSocketConnectionParameters():
        assign this-object:VerifyHost   = true
               this-object:ReuseSession = true
               .
    end constructor.
    
    method public character GetConnectionString():
        define variable cHost as character no-undo.
        define variable iPort as integer no-undo.
        
        Assert:NotNull(this-object:URI, 'URI').
        assign cHost = this-object:URI:Host
               iPort = this-object:URI:Port
               .
        /* double check for safety */
        Assert:NotNullOrEmpty(cHost, 'Host name').
        
        if iPort eq ? then
        case this-object:URI:Scheme:
            when string(UriSchemeEnum:http)  then assign iPort = 80.
            when string(UriSchemeEnum:https) then assign iPort = 443.
        end case.
        Assert:NotNullOrZero(iPort, 'Port').
        if iPort gt 65535 then
            return error new AppError(
                                substitute('Port is too large: &1', iPort),
                                0).
        
        return trim(substitute('-H &7 -S &8 &6 &1 &2 &3 &4 &5':u,
                            /*1*/ (if this-object:VerifyHost           eq true     then '':u else '-nohostverify':u),
                            /*2*/ (if this-object:ReuseSession         eq true     then '':u else '-nosessionreuse':u),
                            /*3*/ (if extent(this-object:SslProtocols) eq ?        then '':u else '-sslprotocols':u + StringConstant:SPACE + String:Join(this-object:SslProtocols, ',':u)),
                            /*4*/ (if extent(this-object:SslCiphers)   eq ?        then '':u else '-sslciphers':u   + StringConstant:SPACE + String:Join(this-object:SslCiphers, ',':u)),
                            /*5*/ (if String:IsNullOrEmpty(ServerNameIndicator)    then '':u else '-servername':u   + StringConstant:SPACE + this-object:ServerNameIndicator),
                            /*6*/ (if this-object:URI:Scheme eq string(UriSchemeEnum:https) then '-ssl':u else '':u),
                            /*7*/ cHost,
                            /*8*/ iPort     )).
    end method.
    
    method public character GetConnectionString( input pcFormatMask as character ):
        return GetConnectionString().
    end method.

    method public character GetConnectionString( input poFormatMask as FormatMaskEnum ):
        return GetConnectionString().
    end method.
    
end class.