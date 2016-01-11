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
    Notes      :  
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Net.HTTP.AuthenticationMethodEnum.
using OpenEdge.Net.HTTP.AuthenticationRequestEventArgs.
using OpenEdge.Net.HTTP.Filter.FilterActionEnum.
using OpenEdge.Net.HTTP.Filter.Message.IMessageFilter.
using OpenEdge.Net.HTTP.HttpMessage.
using OpenEdge.Net.HTTP.HttpRequest.
using OpenEdge.Net.HTTP.StatusCodeEnum.
using OpenEdge.Net.HTTP.HttpResponse.

class OpenEdge.Net.HTTP.Filter.Status.AuthorizationStatusFilter implements IMessageFilter:
    constructor public AuthorizationStatusFilter():
    end constructor.
    
    /** Indicates whether this filter applies to the current message. 
        
        @param HttpMessage The message to check
        @return logical True if the current filter can be used. */
    method public logical CanFilter(input poMessage as HttpMessage):
        define variable lCanFilter as logical no-undo.
        
        lCanFilter = type-of(poMessage, HttpResponse) and
                     cast(poMessage, HttpResponse):StatusCode:Equals(StatusCodeEnum:Unauthorized).
        
        return lCanFilter.
    end method.
    
    /** Performs implementation-specific filtering for a message.
        
        @param HttpMessage The message to filter
        @return FilterActionEnum Status of the fitler action. The caller decides
                                 what to do with this information. Filters will
                                 typically return Stop or OK. */
    method public FilterActionEnum ExecuteFilter(input poMessage as HttpMessage):
        define variable cChallenge as character no-undo.
        define variable oAuthMethod as AuthenticationMethodEnum no-undo.
        define variable oAuthRequestArgs as AuthenticationRequestEventArgs no-undo.
        define variable oRequest as HttpRequest no-undo.
        
        assign cChallenge = poMessage:GetHeaderEntry('WWW-Authenticate')
               oRequest = cast(poMessage, HttpResponse):Request.
        Assert:NotNullOrEmpty(cChallenge, 'WWW-Authenticate Header').
        
        assign oAuthMethod = AuthenticationMethodEnum:FromString(entry(1, cChallenge, ' ')).
        Assert:NotNull(oAuthMethod, 'Authentication method').
        
        /* The Request takes care of creating the correct value for the 
           header, based off the string we pass in. It knows how to translate
           'Basic' or 'Digest' into something useful */
        oRequest:SetChallenge(
                oAuthMethod,
                oRequest:Credentials,
                cChallenge).
        
        /* try again, with the (hopefully) correct credentials */
        return FilterActionEnum:Retry.
    end method.
    
end class.