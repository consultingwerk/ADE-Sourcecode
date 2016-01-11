 /************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
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
using OpenEdge.Net.HTTP.AuthenticationMethodEnum.
using OpenEdge.Net.HTTP.Credentials.
using OpenEdge.Net.HTTP.Filter.Auth.AuthFilter.
using OpenEdge.Net.HTTP.Filter.FilterActionEnum.
using OpenEdge.Net.HTTP.HttpMessage.
using OpenEdge.Net.HTTP.HttpRequest.
using OpenEdge.Net.HTTP.Filter.Auth.DigestAuthenticationFilter.
using OpenEdge.Net.HTTP.ConcreteHttpRequest.

class OpenEdge.Net.HTTP.Filter.Auth.DigestAuthenticationFilter inherits AuthFilter:
    /* Incremented counter for Digest auth */
    define static private variable miNonceCount as integer no-undo.
    
	constructor public DigestAuthenticationFilter():
		super (input AuthenticationMethodEnum:Digest).
	end constructor.
	
    /** The worker/filter method that each filter type impements.       
        
        @param  HttpRequest The requeste being challenged/filtered
        @return FilterActionEnum Status of the fitler action. The caller decides
                                 what to do with this information. Filters will
                                 typically return Stop or OK */ 
    method override public FilterActionEnum ExecuteFilter(input poMessage as HttpMessage):
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
        define variable oRequest as HttpRequest no-undo.
        
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
        assign oRequest = cast(poMessage, HttpRequest) 
               cChallenge = entry(2, oRequest:AuthenticationChallenge, ' ')
               /* After the 'digest' token, the challenge is comma-delimited */
               iMax = num-entries(cChallenge)
               lServerSentQoP = false.
        
        do iLoop = 1 to iMax:
            assign cEntry = entry(iLoop, cChallenge).
                        
            case entry(1, cEntry, '='):
                when 'realm' then cRealm = trim(entry(2, cEntry, '='), '"').
                when 'domain' then cDomain = trim(entry(2, cEntry, '='), '"').
                when 'nonce' then cNonce = trim(entry(2, cEntry, '='), '"').
                when 'opaque' then cOpaque = trim(entry(2, cEntry, '='), '"').
                when 'stale' then lStale = logical(entry(2, cEntry, '=')).
                when 'algorithm' then cAlgorithm = entry(2, cEntry, '=').
                when 'qop' then 
                    assign cQualityOfProtection = trim(entry(2, cEntry, '='), '"')
                           lServerSentQoP = true.
            end case.
        end.
        
        Assert:NotNullOrEmpty(cRealm, 'Realm').
        
        assign oCredentials = GetCredentials(oRequest, cRealm).
        Assert:NotNull(oCredentials, 'Credentials').
        
        assign cClientNonce = GenerateClientNonce().
        
        case cAlgorithm:
            when 'MD5-sess' then
                assign rHash1 = md5-digest(substitute('&1:&2:&3',
                                    md5-digest(substitute('&1:&2:&3',
                                                    oCredentials:UserName,
                                                    oCredentials:Domain,
                                                    oCredentials:Password)),
                                    cNonce,
                                    cClientNonce)).
            when 'MD5' or when '' then
                assign rHash1 = md5-digest(substitute('&1:&2:&3',
                                                    oCredentials:UserName,
                                                    oCredentials:Domain,
                                                    oCredentials:Password)).
        end case.
        Assert:IsPositive(length(rHash1), 'First hash').
        
        case cQualityOfProtection:
            when '' then
                assign rHash2 =  md5-digest(substitute('&1:&2',
                                                oRequest:Method:Name,
                                                oRequest:URI:RelativeURI))
                       rResponse = md5-digest(substitute('&1:&2:&3',
                                                rHash1, cNonce, rHash2 )).
            when 'auth' then
                assign rHash2 =  md5-digest(substitute('&1:&2', 
                                                oRequest:Method:Name, oRequest:URI:RelativeURI))
                       rResponse = md5-digest(substitute('&1:&2:&3:&4:&5:&6',
                                                rHash1, cNonce, DigestAuthenticationFilter:miNonceCount, cClientNonce, cQualityOfProtection, rHash2)).
            when 'auth-int' then
            do:
                assign rHash2 =  md5-digest(substitute('&1:&2:&3',
                                                oRequest:Method:Name,
                                                oRequest:URI:RelativeURI,
                                                cast(oRequest, ConcreteHttpRequest):GetMessageBodyDigest()
                                                /*md5-digest(oRequest:MessageBody:GetBytes():Value)*/
                                                ))
                       rResponse = md5-digest(substitute('&1:&2:&3:&4:&5:&6',
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
        assign cCredentials = substitute('Digest username="&1"; realm="&2"; nonce="&3"; uri="&4"; response=&5"',
                                    oCredentials:UserName,
                                    oCredentials:Domain,
                                    cNonce,
                                    oRequest:URI:RelativeURI,                                    
                                    hex-encode(rResponse)    ) .
        
        if lServerSentQoP then
            assign put-long(rNonceCount,1) = DigestAuthenticationFilter:miNonceCount 
                   cCredentials = substitute('&1 ;cnonce="&2"; nc=&3',
                                        cClientNonce,
                                        hex-encode(rNonceCount)).
            
        poMessage:AddHeader('Authorization', cCredentials).
                    
        return FilterActionEnum:Stop.
	end method.
	
    method private character GenerateClientNonce():
        define variable cNonce as character no-undo.
        
        assign miNonceCount = miNonceCount + 1.
               cNonce = hex-encode(generate-uuid).
        
        return cNonce.
    end method.

end class.