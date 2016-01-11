 /************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
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
using OpenEdge.Net.HTTP.AuthenticationMethodEnum.
using OpenEdge.Net.HTTP.Credentials.
using OpenEdge.Net.HTTP.Filter.Auth.AuthFilter.
using OpenEdge.Net.HTTP.Filter.FilterActionEnum.
using OpenEdge.Net.HTTP.HttpMessage.
using OpenEdge.Net.HTTP.HttpRequest.

class OpenEdge.Net.HTTP.Filter.Auth.BasicAuthenticationFilter inherits AuthFilter:
		
	constructor public BasicAuthenticationFilter():
		super (input AuthenticationMethodEnum:Basic).
	end constructor.

    /** The worker/filter method that each filter type impements.       
        
        @param  HttpRequest The requeste being challenged/filtered
        @return FilterActionEnum Status of the fitler action. The caller decides
                                 what to do with this information. Filters will
                                 typically return Stop or OK */ 
    method override public FilterActionEnum ExecuteFilter(input poMessage as HttpMessage):
        define variable cRealm as character no-undo.
        define variable cCredentials as character no-undo.
        define variable mCredentials as memptr no-undo.
        define variable mShortCredentials as memptr no-undo.
        define variable oCredentials as Credentials no-undo.
        define variable ilength as integer no-undo.
        define variable oRequest as HttpRequest no-undo.
        
        /* cast for comfort */
        assign oRequest = cast(poMessage, HttpRequest) 
               cRealm = entry(2, oRequest:AuthenticationChallenge, '=')
               cRealm = trim(cRealm, '"').
        Assert:NotNullOrEmpty(cRealm, 'Realm').
        
        assign oCredentials = GetCredentials(oRequest, cRealm).
        Assert:NotNull(oCredentials, 'Credentials').
        
        assign cCredentials = substitute('&1:&2',
                                oCredentials:UserName,
                                oCredentials:Password)
               iLength = length(cCredentials, 'RAW').

        set-size(mCredentials) = iLength + 1. /* for the null terminator */
        put-string(mCredentials, 1) = cCredentials.
        /* jiggery-pokery with lengths because there's a null at the end of the 
           memptr, which we do not want */
        set-size(mShortCredentials) = iLength.
        put-bytes(mShortCredentials, 1) = get-bytes(mCredentials, 1, iLength). 
        
        assign cCredentials = 'Basic ' + string(base64-encode(mShortCredentials)).
        /* add to the request */
        poMessage:AddHeader('Authorization', cCredentials).
        
        return FilterActionEnum:Stop.
        finally:
            set-size(mShortCredentials) = 0.
            set-size(mCredentials) = 0.
        end finally.
	end method.

end class.