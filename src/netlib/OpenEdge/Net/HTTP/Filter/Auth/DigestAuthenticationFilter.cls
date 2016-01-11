/************************************************
Copyright (c)  2014, 2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : DigestAuthenticationFilter
    Purpose     : Sets the credentials for the Digest challenge. These will be 
                  encoded per http://tools.ietf.org/html/rfc2617.
    Author(s)   : pjudge
    Created     : Mon Jul 07 13:30:12 EDT 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Net.HTTP.Credentials.
using OpenEdge.Net.HTTP.Filter.Auth.DigestAuthenticationFilter.
using OpenEdge.Net.HTTP.IAuthenticatedRequest.
using OpenEdge.Net.HTTP.Filter.Auth.AuthenticationRequestFilter.
using OpenEdge.Net.HTTP.HttpHeaderBuilder.

class OpenEdge.Net.HTTP.Filter.Auth.DigestAuthenticationFilter inherits AuthenticationRequestFilter: 
    /* Incremented counter for Digest auth */
    define static private variable miNonceCount as integer no-undo.
    
    constructor public DigestAuthenticationFilter ( input poRequest as IAuthenticatedRequest ):
        super (input poRequest).
    end constructor.

    /** Build the actual authentication. To be implemented by concrete classes. */
    method override protected void AddAuthentication():
        define variable cDomain as character no-undo.
        define variable cRealm as character no-undo.
        define variable cURI as character no-undo.
        define variable cNonce as character no-undo.
        define variable cClientNonce as character no-undo.
        define variable cOpaque as character no-undo.
        define variable lStale as logical no-undo.
        define variable cAlgorithm as character no-undo.
        define variable cQualityOfProtection as character no-undo.
        define variable iMax as integer no-undo.
        define variable iLoop as integer no-undo.
        define variable cEntry as character no-undo.
        define variable rHash1 as raw no-undo.
        define variable rHash2 as raw no-undo.
        define variable rResponse as raw no-undo.
        define variable rNonceCount as raw no-undo.
        define variable cCredentials as character no-undo.
        define variable lServerSentQoP as logical no-undo.
        define variable cChallenge as character no-undo.
        define variable oCredentials as Credentials no-undo.
        define variable oRequest as IAuthenticatedRequest no-undo.
        
        /* challenge        =  "Digest" digest-challenge

      digest-challenge  = 1#( realm | [ domain ] | nonce |
                          [ opaque ] |[ stale ] | [ algorithm ] |
                          [ qop-options ] | [auth-param] )


      domain            = "domain" "=" <"> URI ( 1*SP URI ) <">
      URI               = absoluteURI | abs_path
      nonce             = "nonce" "=" nonce-value
      nonce-value       = quoted-string
      opaque            = "opaque" "=" quoted-string
      stale             = "stale" "=" ( "true" | "false" )
      algorithm         = "algorithm" "=" ( "MD5" | "MD5-sess" |
                           token )
      qop-options       = "qop" "=" <"> 1#qop-value <">
      qop-value         = "auth" | "auth-int" | token
      */

        
        /* cast for comfort */
        assign oRequest = cast(this-object:Message, IAuthenticatedRequest)
               cChallenge = entry(2, oRequest:AuthenticationChallenge, ' ')
               /* After the 'digest' token, the challenge is comma-delimited */
               iMax = num-entries(cChallenge)
               lServerSentQoP = false.
        
        do iLoop = 1 to iMax:
            assign cEntry = entry(iLoop, cChallenge).
                        
            case entry(1, cEntry, '=':u):
                when 'realm':u then cRealm = trim(entry(2, cEntry, '=':u), '"':u).
                when 'domain':u then cDomain = trim(entry(2, cEntry, '=':u), '"':u).
                when 'nonce':u then cNonce = trim(entry(2, cEntry, '=':u), '"':u).
                when 'opaque':u then cOpaque = trim(entry(2, cEntry, '=':u), '"':u).
                when 'stale':u then lStale = logical(entry(2, cEntry, '=':u)).
                when 'algorithm':u then cAlgorithm = entry(2, cEntry, '=':u).
                when 'qop':u then 
                    assign cQualityOfProtection = trim(entry(2, cEntry, '=':u), '"':u)
                           lServerSentQoP = true.
            end case.
        end.
        
        Assert:NotNull(cRealm, 'Realm').
        
        assign oCredentials = GetCredentials(cRealm).
        Assert:NotNull(oCredentials, 'Credentials').
        
        assign cClientNonce = GenerateClientNonce().
        
        case cAlgorithm:
            when 'MD5-sess':u then
                assign rHash1 = md5-digest(substitute('&1:&2:&3':u,
                                    md5-digest(substitute('&1:&2:&3':u,
                                                    oCredentials:UserName,
                                                    cRealm,
                                                    oCredentials:Password)),
                                    cNonce,
                                    cClientNonce)).
            when 'MD5':u or when '':u then
                assign rHash1 = md5-digest(substitute('&1:&2:&3':u,
                                                    oCredentials:UserName,
                                                    cRealm,
                                                    oCredentials:Password)).
        end case.
        Assert:IsPositive(length(rHash1), 'First hash').
        
        case cQualityOfProtection:
            when '':u then
                assign rHash2 =  md5-digest(substitute('&1:&2':u,
                                                oRequest:Method,
                                                oRequest:URI:RelativeURI))
                       rResponse = md5-digest(substitute('&1:&2:&3':u,
                                                rHash1, cNonce, rHash2 )).
            when 'auth':u then
                assign rHash2 =  md5-digest(substitute('&1:&2':u, 
                                                oRequest:Method, oRequest:URI:RelativeURI))
                       rResponse = md5-digest(substitute('&1:&2:&3:&4:&5:&6':u,
                                                rHash1, cNonce, DigestAuthenticationFilter:miNonceCount, cClientNonce, cQualityOfProtection, rHash2)).
            when 'auth-int':u then
            do:
                assign rHash2 =  md5-digest(substitute('&1:&2:&3':u,
                                                oRequest:Method,
                                                oRequest:URI:RelativeURI,
                                                oRequest:ContentMD5
                                                ))
                       rResponse = md5-digest(substitute('&1:&2:&3:&4:&5:&6':u,
                                                rHash1, cNonce, DigestAuthenticationFilter:miNonceCount, cClientNonce, cQualityOfProtection, rHash2 )).
            end.
        end case.
        Assert:IsPositive(length(rHash2),    'Second hash').
        Assert:IsPositive(length(rResponse), 'Response hash').
        
        /*
        credentials      = "Digest" digest-response
       digest-response  = 1#( username | realm | nonce | digest-uri
                       | response | [ algorithm ] | [cnonce] |
                       [opaque] | [message-qop] |
                           [nonce-count]  | [auth-param] )

       username         = "username" "=" username-value
       username-value   = quoted-string
       digest-uri       = "uri" "=" digest-uri-value
       digest-uri-value = request-uri   ; As specified by HTTP/1.1
       message-qop      = "qop" "=" qop-value
       cnonce           = "cnonce" "=" cnonce-value
       cnonce-value     = nonce-value
       nonce-count      = "nc" "=" nc-value
       nc-value         = 8LHEX
       response         = "response" "=" request-digest
       request-digest = <"> 32LHEX <">
       LHEX             =  "0" | "1" | "2" | "3" |
                           "4" | "5" | "6" | "7" |
                           "8" | "9" | "a" | "b" |
                           "c" | "d" | "e" | "f"
                           */
        assign cCredentials = substitute('Digest username="&1"; realm="&2"; nonce="&3"; uri="&4"; response=&5"':u,
                                    oCredentials:UserName,
                                    cRealm,
                                    cNonce,
                                    oRequest:URI:RelativeURI,                                    
                                    hex-encode(rResponse)    ) .
        
        if lServerSentQoP then
            assign put-long(rNonceCount,1) = DigestAuthenticationFilter:miNonceCount 
                   cCredentials = substitute('&1 ;cnonce="&2"; nc=&3':u,
                                        cClientNonce,
                                        hex-encode(rNonceCount)).
            
        oRequest:SetHeader(
            HttpHeaderBuilder:Build('Authorization':u):Value(cCredentials):Header).
    end method.
    
    method private character GenerateClientNonce():
        define variable cNonce as character no-undo.
        
        assign miNonceCount = miNonceCount + 1.
               cNonce = hex-encode(generate-uuid).
        
        return cNonce.
    end method.
  
end class.