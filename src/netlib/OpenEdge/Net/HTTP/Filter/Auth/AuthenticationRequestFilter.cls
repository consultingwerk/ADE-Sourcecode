/************************************************
Copyright (c) 2015, 2017 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : AuthenticationRequestFilter
    Purpose     : Filter for handling authentication credential requests.
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Jan 30 11:27:01 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Collections.ObjectStack.
using OpenEdge.Core.IAdaptable.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Net.HTTP.AuthenticationRequestEventArgs.
using OpenEdge.Net.HTTP.Credentials.
using OpenEdge.Net.HTTP.Filter.Auth.IAuthFilterEventHandler.
using OpenEdge.Net.HTTP.Filter.IFilterEvents.
using OpenEdge.Net.HTTP.IAuthenticatedRequest.
using OpenEdge.Net.HTTP.IHttpMessage.
using OpenEdge.Net.HTTP.IHttpMessageWriter.
using OpenEdge.Net.HTTP.IHttpRequest.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Auth.AuthenticationRequestFilter 
        implements IHttpMessageWriter, IFilterEvents, ISupportInitialize
        abstract:
    
    /* A collection of objects that can listen to callbacks */
    define private variable moListeners as ObjectStack no-undo.
    
    /** The HttpRequest does not know where the Domain and username */
    define public event HttpCredentialRequest signature void (
                                    input poSender as Object,
                                    input poEventArgs as AuthenticationRequestEventArgs).
    
    /** Returns the type(class or interface) that an a potential listener must
        implement or inherit in order to handle events from this filter. */
    define public property FilterEventListenerType as class Progress.Lang.Class no-undo 
        get():
            return get-class(IAuthFilterEventHandler).
        end get.
    
    /** The request being authenticated. We know it's derived from an IAuthenticatedRequest (via adapter or inheritance) */
    define public property Message as IHttpMessage no-undo get. private set.
    
    /** The request being authenticated. A helper property */
    define protected property AuthenticatedRequest as IAuthenticatedRequest no-undo get. private set.
    
    /** Constructor
        
        @param IAuthenticatedRequest The request being authenticated. */
    constructor public AuthenticationRequestFilter(input poRequest as IAuthenticatedRequest):
        Assert:NotNull(poRequest, 'Request').
        
        assign this-object:AuthenticatedRequest = poRequest.
        
        if type-of(poRequest, IAdaptable) then
            assign this-object:Message = cast(cast(poRequest, IAdaptable):GetAdapter(get-class(IHttpRequest)), IHttpRequest).
        else
        if type-of(poRequest, IHttpRequest) then
            assign this-object:Message = cast(poRequest, IHttpRequest).
    end method.
    
    destructor AuthenticationRequestFilter():
        Destroy().
    end destructor.
    
    method public void Close():
        /* no-op */
    end method.

    method public void Flush():
        AddAuthentication().
    end method.
    
    /** Build the actual authentication. To be implemented by concrete classes. */
    method abstract protected void AddAuthentication().
    
    method public void Open():
        /* no-op */
    end method.
    
    method public void Write(input-output pcData as longchar):
        /* no-op */
    end method.

    method public void Write(input pmData as memptr):
        /* no-op */
    end method.

    method public void Write(input poData as Object):
        /* no-op */
    end method.
    
    /** Write data to/from the message

        @param handle Data to write */
    method public void Write(input phData as handle):    
        /* no-op */
    end method.

    /** Write data to/from the message

        @param character Data to write */
    method public void Write(input-output pcData as character):    
        /* no-op */
    end method.    
    
    /** Publishes the HttpCredentialRequest event 
       
        @param AuthenticationRequestEventArgs The event args being modified/used 
                          in this event. */
    method protected void OnHttpCredentialRequest(input poAuthRequestArgs as AuthenticationRequestEventArgs):
        Assert:NotNull(poAuthRequestArgs, 'Authentication Request Event Args').

        this-object:HttpCredentialRequest:Publish(this-object, poAuthRequestArgs).
    end method.
    
    /** Returns credentials to be used by this filter. Can be retrieved from
        the Request or requested via an event
        
        @param character The domain for which to get the credentials
        @return Credentials A set of credentials (may not be correct, of course) */
    method protected Credentials GetCredentials(input pcRealm as character):
        define variable oAuthRequestArgs as AuthenticationRequestEventArgs no-undo.
        
        /* blank realms allowed */
        Assert:NotNull(pcRealm, 'Realm').
        
        /* First try to get credentials off the request */
        if valid-object(this-object:AuthenticatedRequest:Credentials) then
            return this-object:AuthenticatedRequest:Credentials.
        
        /* Last, publish the HttpAuthenticationRequest event to get the credentials from 
           an external listener(s). */  
        assign oAuthRequestArgs = new AuthenticationRequestEventArgs(cast(this-object:Message, IHttpRequest), pcRealm).
        
        OnHttpCredentialRequest(oAuthRequestArgs).
        
        /* now we're done with getting the user/domain values ... */
        if oAuthRequestArgs:Cancel then
            return ?.  
        
        return oAuthRequestArgs:Credentials.
    end method.
    
    /** Subscribes a listener to events from the implementing filter.
        
        @param Object The prospective listener. */
    method public void SubscribeListener(input poListener as Object):
        Assert:IsType(poListener, FilterEventListenerType).
        
        moListeners:Push(poListener).
        this-object:HttpCredentialRequest
                    :Subscribe(cast(poListener, IAuthFilterEventHandler):AuthFilter_HttpCredentialRequestHandler).
    end method.
    
    /** Unsubscribes a listener to events from the implementing filter.
        
        @param Object The prospective listener. */
    method public void UnsubscribeListener(input poListener as Object):
        Assert:IsType(poListener, FilterEventListenerType).
        
        this-object:HttpCredentialRequest
                    :Unsubscribe(cast(poListener, IAuthFilterEventHandler):AuthFilter_HttpCredentialRequestHandler).
    end method.
    
    /** unsubsribes listeners from a writer, so that they can be GC'ed if needed */
    method private void RemoveListeners():
        do while moListeners:Size gt 0:
            UnsubscribeListener(moListeners:Pop()).
        end.
    end method.
    
    method public void Initialize():
        assign moListeners = new ObjectStack().
    end method.
    
    method public void Destroy(  ):
        RemoveListeners().
        assign moListeners = ?.
    end method.
    
end class.