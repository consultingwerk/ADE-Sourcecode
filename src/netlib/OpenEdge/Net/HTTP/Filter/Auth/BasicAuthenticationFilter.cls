/************************************************
Copyright (c)  2014, 2015, 2017, 2018 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : BasicAuthenticationFilter
    Purpose     : Sets the credentials for the Basic challenge. These will be 
                  encoded per http://tools.ietf.org/html/rfc2617.
    Author(s)   : pjudge
    Created     : Mon Jul 07 13:30:12 EDT 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.StringConstant.
using OpenEdge.Net.HTTP.Credentials.
using OpenEdge.Net.HTTP.Filter.Auth.AuthenticationRequestFilter.
using OpenEdge.Net.HTTP.HttpHeaderBuilder.
using OpenEdge.Net.HTTP.IAuthenticatedRequest.
using Progress.Lang.AppError.

class OpenEdge.Net.HTTP.Filter.Auth.BasicAuthenticationFilter inherits AuthenticationRequestFilter:
     /** Constructor
       
        @param IAuthenticatedRequest The request being authenticated. */
    constructor public BasicAuthenticationFilter (input poRequest as IAuthenticatedRequest ):
        super (input poRequest).
    end constructor.

    /** Build the actual authentication. To be implemented by concrete classes. */
    method override protected void AddAuthentication():
        define variable cRealm as character no-undo.
        define variable cCredentials as character no-undo.
        define variable mCredentials as memptr no-undo.
        define variable oCredentials as Credentials no-undo.
        define variable ilength as integer no-undo.
        
        assign cRealm = entry(2, this-object:AuthenticatedRequest:AuthenticationChallenge, '=':u)
               cRealm = trim(cRealm, StringConstant:DOUBLE_QUOTE)
               .
        Assert:NotNull(cRealm, 'Realm').
        
        assign oCredentials = GetCredentials(cRealm).
        if not valid-object(oCredentials) then
            return error new AppError(substitute('Missing credentials for realm ~"&1~"', cRealm), 0).
        
        assign cCredentials = substitute('&1:&2':u,
                                oCredentials:UserName,
                                oCredentials:Password)
               iLength = length(cCredentials, 'RAW':u)
               .
        set-size(mCredentials) = iLength.   // do NOT add a byte for the null terminator
        put-string(mCredentials, 1, iLength ) = cCredentials.
        
        assign cCredentials = substitute('Basic &1':u, base64-encode(mCredentials)).
        /* add to the request */
        this-object:Message:SetHeader(
            HttpHeaderBuilder:Build('Authorization':u):Value(cCredentials):Header).
        
        finally:
            set-size(mCredentials) = 0.
        end finally.
    end method.
            
end class.