/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File       : AuthorizationStatusFilter
    Purpose    : Processes the 401/Unauthorized status code 
    Syntax     :
    Description:
    Author(s)  : pjudge
    Created    : Mon Feb 17 13:06:38 EST 2014
    Notes      : * https://tools.ietf.org/html/rfc2617#page-6 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Net.HTTP.AuthenticationMethodEnum.
using OpenEdge.Net.HTTP.Filter.Status.StatusCodeFilter.
using OpenEdge.Net.HTTP.HttpClient.
using OpenEdge.Net.HTTP.HttpResponse.
using OpenEdge.Net.HTTP.StatusActionEnum.
using OpenEdge.Net.HTTP.StatusCodeEnum.

class OpenEdge.Net.HTTP.Filter.Status.AuthorizationStatusFilter inherits StatusCodeFilter: 
    define private variable miNonceCount as integer no-undo.
    
    constructor public AuthorizationStatusFilter(input poClient as HttpClient):
        define variable oTypes as StatusCodeEnum extent 1 no-undo.
        
		super(poClient).
		
		assign oTypes[1] = StatusCodeEnum:Unauthorized
		       this-object:StatusCode = oTypes.
    end constructor.
	
    /** Adds basic authorisation headers to the original request for resubmission   
       
        @param HttpResponse The response whose status code is being evaulated
        @return StatusActionEnum  Action required from this evaluation */ 
    method override public StatusActionEnum EvaluateStatus(input poResponse as HttpResponse):
        define variable cHeaderValue as character no-undo.
        define variable oAuthMethod as AuthenticationMethodEnum no-undo.
        define variable cCredentials as character no-undo.
        
        assign cHeaderValue = poResponse:GetHeaderEntry('WWW-Authenticate').
        Assert:NotNullOrEmpty(cHeaderValue, 'WWW-Authenticate Header').
        
        oAuthMethod = AuthenticationMethodEnum:FromString(entry(1, cHeaderValue, ' ')).
        Assert:NotNull(oAuthMethod, 'Authentication method').
        
        case oAuthMethod:
            when AuthenticationMethodEnum:Basic then
                assign cCredentials = GenerateBasicResponse(poResponse, cHeaderValue).
            when AuthenticationMethodEnum:Digest then
                assign cCredentials = GenerateDigestResponse(poResponse, cHeaderValue).
        end case.   /* auth method */
        
        /* Add credentials as a header. */
        Assert:NotNullOrEmpty(cCredentials, 'Credentials').        
        poResponse:Request:AddHeader('Authorization', cCredentials).
        
        return StatusActionEnum:Retry.
    end method.
    
    
    /* Process a particular set of status codes.  
       
        @param HttpResponse The response whose status code is being evaulated
        @return StatusActionEnum  Action required from this evaluation */ 
    method private character GenerateBasicResponse (input poResponse as HttpResponse,
                                                    input pcAuthenticateHeader as character):
        define variable hCredentials as handle no-undo.
        define variable cRealm as character no-undo.
        define variable cCredentials as character no-undo.
        define variable mCredentials as memptr no-undo.
        
        /* get realm from header */
        assign cRealm = entry(2, pcAuthenticateHeader, '=')
               cRealm = trim(cRealm, '"').
        Assert:NotNullOrEmpty(cRealm, 'Realm').
        
        /* get credentials for realm */
        assign hCredentials = this-object:Client:GetCredentials(cRealm).
        Assert:NotNull(hCredentials, 'Credentials').
        
        assign cCredentials = substitute('&1:&2',
                                hCredentials:user-id,
                                hCredentials:primary-passphrase).
        set-size(mCredentials) = length(cCredentials, 'RAW') + 1.
        put-string(mCredentials, 1) = cCredentials.                                     
        
        assign cCredentials = 'Basic ' + string(base64-encode(mCredentials)).
        
        return cCredentials.
        finally:
            set-size(mCredentials) = 0.
        end finally.
    end method.

    /** Adds digest authorisation headers to the original request for resubmission 
        
        @param HttpResponse The response being processed
        @param character the value/contents of the WWW-Authenticate header 
        @return character The credentials generated */
    method private character GenerateDigestResponse (input poResponse as HttpResponse,
                                                     input pcAuthenticateHeader as character):
        define variable cRealm as character no-undo.
        define variable cDomain as character no-undo.
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
        define variable hCredentials as handle no-undo.
        define variable cCredentials as character no-undo.
        define variable lServerSentQoP as logical no-undo.
        
        
        /*
          challenge        =  "Digest" digest-challenge

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
        assign pcAuthenticateHeader = entry(2, pcAuthenticateHeader, ' ')
               /* After the 'digest' token, the challenge is comma-delimited */
               iMax = num-entries(pcAuthenticateHeader)
               lServerSentQoP = false.
        
        do iLoop = 1 to iMax:
            assign cEntry = entry(iLoop, pcAuthenticateHeader).
                        
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
        /* get credentials for realm */
        assign hCredentials = this-object:Client:GetCredentials(cRealm).
        Assert:NotNull(hCredentials, 'Credentials').
        
        assign cClientNonce = GenerateClientNonce().
        
        case cAlgorithm:
            when 'MD5-sess' then
                assign rHash1 = md5-digest(substitute('&1:&2:&3',
                                    md5-digest(substitute('&1:&2:&3',
                                                    hCredentials:user-id,
                                                    cRealm,
                                                    hCredentials:primary-passphrase )),
                                    cNonce,
                                    cClientNonce)).
            when 'MD5' or when '' then
                assign rHash1 = md5-digest(substitute('&1:&2:&3',
                                                    hCredentials:user-id,
                                                    cRealm,
                                                    hCredentials:primary-passphrase )).
        end case.
        Assert:IsPositive(length(rHash1), 'First hash').
        
        case cQualityOfProtection:
            when '' then
                assign rHash2 =  md5-digest(substitute('&1:&2',
                                                poResponse:Request:Method:Name,
                                                poResponse:Request:URI:RelativeURI))
                       rResponse = md5-digest(substitute('&1:&2:&3',
                                                rHash1, cNonce, rHash2 )).
            when 'auth' then
                assign rHash2 =  md5-digest(substitute('&1:&2', 
                                                poResponse:Request:Method:Name, poResponse:Request:URI:RelativeURI))
                       rResponse = md5-digest(substitute('&1:&2:&3:&4:&5:&6',
                                                rHash1, cNonce, miNonceCount, cClientNonce, cQualityOfProtection, rHash2)).
            when 'auth-int' then
            do:
                assign rHash2 =  md5-digest(substitute('&1:&2:&3',
                                                poResponse:Request:Method:Name,
                                                poResponse:Request:URI:RelativeURI,
                                                md5-digest(poResponse:Request:MessageBody:GetBytes():Value)))
                       rResponse = md5-digest(substitute('&1:&2:&3:&4:&5:&6',
                                                rHash1, cNonce, miNonceCount, cClientNonce, cQualityOfProtection, rHash2 )).
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
                                    hCredentials:user-id,
                                    cRealm,
                                    cNonce,
                                    poResponse:Request:URI:RelativeURI,                                    
                                    hex-encode(rResponse)    ) .
        
        if lServerSentQoP then
            assign put-long(rNonceCount,1) = miNonceCount 
                   cCredentials = substitute('&1 ;cnonce="&2"; nc=&3',
                                        cClientNonce,
                                        hex-encode(rNonceCount)).
        
        return cCredentials.        
    end method.
    
    method protected character GenerateClientNonce():
        define variable cNonce as character no-undo.
        
        assign miNonceCount = miNonceCount + 1.
               cNonce = hex-encode(generate-uuid).
        
        return cNonce.
    end method. 
    
end class.