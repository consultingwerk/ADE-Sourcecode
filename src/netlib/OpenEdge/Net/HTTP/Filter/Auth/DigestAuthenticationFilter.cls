/************************************************
Copyright (c) 2014, 2015, 2017-2018 by Progress Software Corporation. All rights reserved.
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
using OpenEdge.Core.StringConstant.
using OpenEdge.Core.Util.MathUtil.
using OpenEdge.Net.HTTP.Credentials.
using OpenEdge.Net.HTTP.Filter.Auth.AuthenticationRequestFilter.
using OpenEdge.Net.HTTP.HttpHeaderBuilder.
using OpenEdge.Net.HTTP.IAuthenticatedRequest.
using OpenEdge.Net.HTTP.IHttpRequest.

class OpenEdge.Net.HTTP.Filter.Auth.DigestAuthenticationFilter inherits AuthenticationRequestFilter: 
    // Holder for per-nonce counts
    define static private temp-table NonceCount no-undo
        field ParentFilter as int64
        field Nonce as character
        field Count as integer
        index idxPu as primary unique ParentFilter Nonce.
    
    /* Constructor
       
       @param IAuthenticatedRequest The request requiring Digest authentication */
    constructor public DigestAuthenticationFilter ( input poRequest as IAuthenticatedRequest ):
        super(input poRequest).
    end constructor.
    
    /* Destructor */
    destructor DigestAuthenticationFilter():
        define buffer nc for NonceCount.
        
        for each nc where nc.ParentFilter eq int64(this-object):
            delete nc.
        end.
    end destructor.

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
        define variable nonceCount as integer no-undo.
        define variable cCredentials as character no-undo.
        define variable lServerSentQoP as logical no-undo.
        define variable cChallenge as character no-undo.
        define variable oCredentials as Credentials no-undo.
        define variable oRequest as IHttpRequest no-undo.
        define variable pos as integer no-undo.
        define variable paramValue as character no-undo.
        
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
        
        // Init variables top ensure we have can write the response correctly
        assign cRealm               = ?
               cDomain              = ?
               cNonce               = ?
               cOpaque              = ?
               lStale               = ?
               cAlgorithm           = '':u
               cQualityOfProtection = '':u
               lServerSentQoP       = false
               
               /* cast for comfort */
               oRequest   = cast(this-object:Message, IHttpRequest)
               pos        = index(this-object:AuthenticatedRequest:AuthenticationChallenge, StringConstant:SPACE)
               cChallenge = substring(this-object:AuthenticatedRequest:AuthenticationChallenge, pos + 1)
               /* After the 'digest' token, the challenge is comma-delimited */
               iMax = num-entries(cChallenge)
               .
        do iLoop = 1 to iMax:
            assign cEntry     = entry(iLoop, cChallenge) 
                   pos        = index(cEntry, '=':u)
                   paramValue = trim(trim(substring(cEntry, pos + 1)), StringConstant:DOUBLE_QUOTE)
                   cEntry     = trim(substring(cEntry, 1, pos - 1))
                   .
            case cEntry:
                when 'realm':u      then assign cRealm     = paramValue.
                when 'domain':u     then assign cDomain    = paramValue.
                when 'nonce':u      then assign cNonce     = paramValue.
                when 'opaque':u     then assign cOpaque    = paramValue.
                when 'stale':u      then assign lStale     = logical(paramValue).
                when 'algorithm':u  then assign cAlgorithm = paramValue.
                when 'qop':u        then assign cQualityOfProtection = paramValue
                                                lServerSentQoP       = true.
            end case.
        end.
        
        // We must have a realm and a nonce
        Assert:NotNull(cRealm, 'Realm').
        Assert:NotNull(cNonce, 'Nonce').
        
        assign oCredentials = GetCredentials(cRealm).
        Assert:NotNull(oCredentials, 'Credentials').
        
        assign cClientNonce = hex-encode(generate-uuid)
               nonceCount   = NextNonceCount(cNonce)
               .
        case cAlgorithm:
            when 'MD5-sess':u then
                assign rHash1 = md5-digest(substitute('&1:&2:&3':u,
                                    hex-encode(md5-digest(substitute('&1:&2:&3':u,
                                                    oCredentials:UserName,
                                                    cRealm,
                                                    oCredentials:Password))),
                                    cNonce,
                                    cClientNonce)).
            when 'MD5':u or
            when '':u then
                assign rHash1 = md5-digest(substitute('&1:&2:&3':u,
                                                    oCredentials:UserName,
                                                    cRealm,
                                                    oCredentials:Password)).
        end case.
        Assert:IsPositive(length(rHash1), 'First hash').
        
        case cQualityOfProtection:
            when '':u then
                assign rHash2    = md5-digest(substitute('&1:&2':u,
                                                oRequest:Method,
                                                oRequest:URI:RelativeURI))
                       rResponse = md5-digest(substitute('&1:&2:&3':u,
                                                hex-encode(rHash1),
                                                cNonce,
                                                hex-encode(rHash2) )).
            when 'auth':u then
                assign rHash2    = md5-digest(substitute('&1:&2':u, 
                                                oRequest:Method,
                                                oRequest:URI:RelativeURI))
                       rResponse = md5-digest(substitute('&1:&2:&3:&4:&5:&6':u,
                                                hex-encode(rHash1), 
                                                cNonce, 
                                                MathUtil:IntToHex(nonceCount, 8), 
                                                cClientNonce, 
                                                cQualityOfProtection, 
                                                hex-encode(rHash2))).
            when 'auth-int':u then
            do:
                assign rHash2    = md5-digest(substitute('&1:&2:&3':u,
                                                oRequest:Method,
                                                oRequest:URI:RelativeURI,
                                                oRequest:ContentMD5  ))
                       rResponse = md5-digest(substitute('&1:&2:&3:&4:&5:&6':u,
                                                hex-encode(rHash1), 
                                                cNonce, 
                                                MathUtil:IntToHex(nonceCount, 8), 
                                                cClientNonce, 
                                                cQualityOfProtection, 
                                                hex-encode(rHash2))).
            end.
        end case.
        Assert:IsPositive(length(rHash2),    'Second hash').
        Assert:IsPositive(length(rResponse), 'Response hash').
        
        /*  credentials      = "Digest" digest-response
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
                               "c" | "d" | "e" | "f"           */
        assign cCredentials = substitute('Digest username="&1",realm="&2",nonce="&3",uri="&4",response="&5"':u,
                                    oCredentials:UserName,
                                    cRealm,
                                    cNonce,
                                    oRequest:URI:RelativeURI,
                                    hex-encode(rResponse)    ) .
        
        if cAlgorithm ne '':u then
            assign cCredentials = substitute('&1,algorithm=&2':u,
                                        cCredentials,
                                        cAlgorithm).
        
        if cOpaque ne ? then
            assign cCredentials = substitute('&1,opaque="&2"':u,
                                        cCredentials,
                                        cOpaque).
        
        if lServerSentQoP then
            assign cCredentials = substitute('&1,cnonce="&2",nc=&3,qop="&4"':u,
                                        cCredentials,
                                        cClientNonce,
                                        MathUtil:IntToHex(nonceCount, 8),
                                        cQualityOfProtection).
        
        oRequest:SetHeader(HttpHeaderBuilder:Build('Authorization':u):Value(cCredentials):Header).
    end method.
    
    /* Returns the next nonce-count for a given nonce.
       
       @param character The nonce for whcih to return acount
       @return integer The nonce count  */
    method private integer NextNonceCount(input pNonce as character):
        define buffer nc for NonceCount.
        
        if can-find(nc where 
                    nc.ParentFilter eq int64(this-object) and
                    nc.Nonce        eq pNonce) then
            find nc where
                 nc.ParentFilter eq int64(this-object) and
                 nc.Nonce        eq pNonce
                 .
        if not available nc then
        do:
            create nc.
            assign nc.ParentFilter = int64(this-object)
                   nc.Nonce        = pNonce
                   nc.Count        = 0.
        end.
        
        assign nc.Count = nc.Count + 1.
        
        return nc.Count.
    end method.
    
end class.