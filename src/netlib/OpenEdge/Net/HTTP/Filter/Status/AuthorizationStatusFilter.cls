/************************************************
Copyright (c)  2014, 2015 by Progress Software Corporation. All rights reserved.
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
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Net.HTTP.IAuthenticatedRequest.
using OpenEdge.Net.HTTP.IHttpMessage.
using OpenEdge.Net.HTTP.IHttpMessageWriter.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.RequestBuilder.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Status.AuthorizationStatusFilter
                implements IHttpMessageWriter, ISupportInitialize:
                    
    /* This writer requires an Authenticated request; either we accept on or turn the 
       input request into one */
    define private variable moAuthRequest as IAuthenticatedRequest no-undo.
    
    /* contents of the WWW-Authenticate header */
    define private variable mcChallenge as character no-undo.
    
    /** (mandatory) The message that's being written to. The values passed in to the Write() methods
        will be parsed/processed and writted to this message. */  
    define public property Message as IHttpMessage no-undo get. private set.
    
    constructor public AuthorizationStatusFilter(input poMessage as IHttpRequest):
        Assert:NotNull(poMessage, 'Http request').
        assign this-object:Message = poMessage.
    end constructor.

    destructor AuthorizationStatusFilter():
        Destroy().
    end destructor.     

    method public void Initialize():
        assign moAuthRequest       = cast(RequestBuilder:DecorateRequest(get-class(IAuthenticatedRequest),
                                                                         cast(this-object:Message, IHttpRequest))
                                          , IAuthenticatedRequest)
               this-object:Message = moAuthRequest.
    end method.
    
    method public void Destroy():
    end method.

    method public void Close():
        Flush().
    end method.
    
    method public void Flush():
        define variable cAuthMethod as character no-undo.
        
        Assert:NotNullOrEmpty(mcChallenge, 'Challenge').
        
        /* The challenge type is the first SPACE-delimited entry */
        assign cAuthMethod = entry(1, mcChallenge, ' ':u).
        Assert:NotNullOrEmpty(cAuthMethod, 'Authentication method').
        
        /* The Request takes care of creating the correct value for the 
           header, based off the string we pass in. It knows how to translate
           'Basic' or 'Digest' into something useful */
        cast(this-object:Message, IAuthenticatedRequest):SetChallenge(
                cAuthMethod,
                mcChallenge).
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