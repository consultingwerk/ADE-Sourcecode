/************************************************
Copyright (c) 2014, 2017-2018, 2020-2023 by Progress Software Corporation. All rights reserved.
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
using OpenEdge.Core.EncodedString.
using OpenEdge.Core.ServerConnection.FormatMaskEnum.
using OpenEdge.Core.ServerConnection.IConnectionParameters.
using OpenEdge.Core.String.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.ISupportLogging.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Net.URI.
using OpenEdge.Net.UriSchemeEnum.
using OpenEdge.Security.ICredentials.
using Progress.Lang.AppError.

class OpenEdge.Net.ServerConnection.ClientSocketConnectionParameters
                implements IConnectionParameters,
                           ISupportLogging:

    /* The timeout for the socket CONNECT, in milliseconds */   
    define public property ConnectTimeout as integer no-undo        
        get.        
        set(input pTimeout as integer):            
            Assert:IsZeroOrPositive(pTimeout, 'Connect timeout').
            this-object:ConnectTimeout = pTimeout.
        end set.

    define public property FormatMask as FormatMaskEnum no-undo
       get():
           return FormatMaskEnum:Custom.
       end get.
    
    /* The URI to which to connect */
    define public property URI as URI no-undo
       get.
       set.
   
    /* A reference to the Logger in use by an implementer */
    define public property Logger as ILogWriter no-undo
    get():
        if not valid-object(this-object:Logger) then
            assign this-object:Logger = LoggerBuilder:GetLogger(this-object:GetClass()).
        return this-object:Logger.
    end get.
    set.

    /** Contains credentials for client authentication */
    define public property ClientCredentials as ICredentials no-undo get. set.

    /** Sets the -NoSessionReuse flag for SSL */
    define public property ReuseSession as logical no-undo get. set.

    /** Determines whether the client connection should verify the host
        certificate for SSL */
    define public property VerifyHost as logical no-undo get. set.

    /** (optional) An array of SSL protocols for this connection to use */
    define public property SslProtocols as character extent no-undo get. set.

    /** (optional) An array of SSL ciphers for this connection to use */
    define public property SslCiphers as character extent no-undo get. set.

    /** (optional) An array of TLS supported groups for this connection to use */
    define public property TlsSupportedGroups as character extent no-undo get. set.

    /** (optional) The Server name indicator for TLS. Server Name Indication (SNI)
        is an extension to the TLS computer networking protocol.

        This value is set for the -servername connection property iff HTTPS is used */
    define public property ServerNameIndicator as character  no-undo get. set.

    /* Indicates whether the server is expected to server disconnects (as opposed to the client disconnecting).
       Default is FALSE (historical behaviour); which raises errors. TRUE means that no errors are raiseed on server
       disconnects */
    define public property AllowServerDisconnect as logical no-undo initial false
        get.
        set.

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
    
    /* Returns a string for the ABL socket CONNECT() method, based on the
       various properties of this object.
       SSL options are added regardless of whether the URI scheme is HTTPS: this is
       to support secure tunnelling to servers via proxy.
       
       @return character The connection string */
    method public character GetConnectionString():
        define variable cConnect as character no-undo.
        define variable cKeyPwd  as character no-undo.
        define variable cHost    as character no-undo.
        define variable iPort    as integer   no-undo.
        
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
            return error new AppError(substitute('Port is too large (exceeds 65535): &1', iPort), 0).
        
        /* start the connection string with basics: host and port */
        assign cConnect = trim(substitute('-H &1 -S &2', cHost, iPort)).
    
        if this-object:URI:Scheme eq string(UriSchemeEnum:https) then
            assign cConnect = trim(substitute('&1 -ssl':u, cConnect)).

        if this-object:VerifyHost eq false then
            assign cConnect = trim(substitute('&1 -nohostverify':u, cConnect)).

        if this-object:ReuseSession eq false then
            assign cConnect = trim(substitute('&1 -nosessionreuse':u, cConnect)).

        if extent(this-object:SslProtocols) ne ? then
            assign cConnect = trim(substitute('&1 -sslprotocols &2':u, cConnect, String:Join(this-object:SslProtocols, ',':u))).

        if extent(this-object:SslCiphers) ne ? then
            assign cConnect = trim(substitute('&1 -sslciphers &2':u, cConnect, String:Join(this-object:SslCiphers, ',':u))).

        /**
         * The supported groups list (key exchange algorithms) that the client sends to the server in its Client Hello request message.
         * List is a colon-separated list of group names in order of preference. For example: -tlssupportedgroups P-521:P-384:P-256.
         *
         * The following cases may apply when using the TLS Supported Groups (-tlssupportedgroups) connection option:
         *
         *   1. If no value supplied for TLS Supported Groups connection parameter, the default OpenSSL supported "supported groups"
         *      list will be sent to the server. This may vary for different OpenSSL versions. As of the 12.7 OpenSSL version,
         *      the default is x25519, secp256r1, x448, secp521r1, secp384r1.
         *
         *   2. When some specific value is supplied to configure the supported groups, as per the OpenSSL standards, the same value
         *      will be sent by the client to the server. We don't have any utility to list down all the supported "supported groups"
         *      for OpenSSL as of now. We can refer to OpenSSL manual for that:
         *      https://www.openssl.org/docs/manmaster/man3/SSL_CTX_set1_groups.html
         */
        if extent(this-object:TlsSupportedGroups) ne ? then
            assign cConnect = trim(substitute('&1 -tlssupportedgroups &2':u, cConnect, String:Join(this-object:TlsSupportedGroups, ':':u))).

        if not String:IsNullOrEmpty(ServerNameIndicator) then
            assign cConnect = trim(substitute('&1 -servername &2':u, cConnect, this-object:ServerNameIndicator)).
        
        if valid-object(ClientCredentials) then do:
            if type-of(ClientCredentials:Secret, EncodedString) then
                assign cKeyPwd = cast(ClientCredentials:Secret, EncodedString):Value.
            else
            do:
                this-object:Logger:warn(substitute("Unencoded password for option -sslKeyPwd provided for connection to HOST[&1]:[&2]", cHost, iPort)).
                assign cKeyPwd = string(ClientCredentials:Secret).
            end.
            /* add the SSL parameters to the connection string, which are case-sensitive! */
            assign cConnect = trim(substitute('&1 -sslAuth ssl -sslKeyFile &2 -sslKeyPwd &3':u,
                                              cConnect, string(ClientCredentials:Identity), cKeyPwd)).
        end.

        if this-object:ConnectTimeout > 0 then
            assign cConnect = trim(substitute('&1 -clientConnectTimeout &2':u, cConnect, this-object:ConnectTimeout)).

        return trim(cConnect).
    end method.

    method public character GetConnectionString( input pcFormatMask as character ):
        return GetConnectionString().
    end method.

    method public character GetConnectionString( input poFormatMask as FormatMaskEnum ):
        return GetConnectionString().
    end method.

end class.