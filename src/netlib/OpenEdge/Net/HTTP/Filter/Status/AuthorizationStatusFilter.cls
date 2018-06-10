/************************************************
Copyright (c) 2014-2017 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File       : AuthorizationStatusFilter
    Purpose    : Processes the 401/Unauthorized status code 
    Syntax     :
    Description:
    Author(s)  : pjudge
    Created    : Mon Feb 17 13:06:38 EST 2014
    Notes       : - The Message for this writer is the REQUEST since it 
                    will retrieve data from the request (Location header) and
                    write a new URI to the request.
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.IAdaptable.
using OpenEdge.Core.StringConstant.
using OpenEdge.Net.HTTP.AuthenticationMethodEnum.
using OpenEdge.Net.HTTP.IAuthenticatedRequest.
using OpenEdge.Net.HTTP.IHttpMessage.
using OpenEdge.Net.HTTP.IHttpMessageWriter.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.RequestBuilder.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Status.AuthorizationStatusFilter
                implements IHttpMessageWriter:
    
    /* contents of the WWW-Authenticate header */
    define private variable mcChallenge as character no-undo.
    
    /** (mandatory) The message that's being written to. The values passed in to the Write() methods
        will be parsed/processed and writted to this message. */  
    define public property Message as IHttpMessage no-undo get. private set.
    
    constructor public AuthorizationStatusFilter(input poMessage as IHttpRequest):
        Assert:NotNull(poMessage, 'Http request').
        assign this-object:Message = poMessage.
    end constructor.
    
    method public void Close():
        Flush().
    end method.
    
    method public void Flush():
        define variable authRequest as IAuthenticatedRequest no-undo.
        define variable cAuthMethod as character no-undo.
        
        /* While the HTTP spec (http://tools.ietf.org/html/rfc2616#section-10.4.2 ) states that "401 Unauthorized
            
               The request requires user authentication. The response MUST include a
               WWW-Authenticate header field (section 14.47) containing a challenge
               applicable to the requested resource. "
          
          Not all web servers send it (lookin' at you PASOE). Default to 'none' to prevent weird failures. */
        if mcChallenge eq ? then
            assign mcChallenge = '':u.
        
        /* The challenge type is the first SPACE-delimited entry */
        assign cAuthMethod = entry(1, mcChallenge, StringConstant:SPACE).
        
        /* Default to NONE if the server is not following the HTTP spec  */        
        if cAuthMethod eq '':u then
            assign cAuthMethod = string(AuthenticationMethodEnum:None).
            
        Assert:NotNullOrEmpty(cAuthMethod, 'Authentication method').
        
        // Figure out where to save this
        if type-of(this-object:Message, IAdaptable) then
            assign authRequest = cast(cast(this-object:Message, IAdaptable):GetAdapter(get-class(IAuthenticatedRequest)), 
                                      IAuthenticatedRequest). 
        
        if not valid-object(authRequest) 
           and type-of(this-object:Message, IAuthenticatedRequest) 
           then
            assign authRequest = cast(this-object:Message, IAuthenticatedRequest).
        
        /* If this is not yet some form of authenticated request, make it so */
        if not valid-object(authRequest) then
            assign this-object:Message = RequestBuilder:DecorateRequest(get-class(IAuthenticatedRequest), cast(this-object:Message, IHttpRequest))
                   authRequest         = cast(this-object:Message, IAuthenticatedRequest)
                   .
        /* The Request takes care of creating the correct value for the 
           header, based off the string we pass in. It knows how to translate
           'Basic' or 'Digest' into something useful */
        authRequest:SetChallenge(cAuthMethod, mcChallenge).
    end method.
    
    method public void Open():
        assign mcChallenge = '':u.
    end method.

    method public void Write(input-output pcData as longchar):
        Assert:NotNullOrEmpty(pcData, 'Challenge').
        
        assign mcChallenge = string(pcData).
    end method.

    method public void Write(input pmData as memptr):
        Assert:IsPositive(get-size(pmData), 'Data size').       
        assign mcChallenge = get-string(pmData, 1).
    end method.

    method public void Write(input poData as Object):
        Assert:IsType(poData, get-class(IHttpResponse)).
        
        /* the value of the Location header is the new host/path */
        if cast(poData, IHttpResponse):HasHeader('WWW-Authenticate':u) then
            assign mcChallenge = cast(poData, IHttpResponse):GetHeader('WWW-Authenticate':u):Value.
    end method.
    
    /** Write data to/from the message

        @param handle Data to write */
    method public void Write(input phData as handle):    
        /* no-op */
    end method.

    /** Write data to/from the message

        @param character Data to write */
    method public void Write(input-output pcData as character):    
        Assert:NotNullOrEmpty(pcData, 'Challenge').
        
        assign mcChallenge = pcData.
    end method.    

end class.