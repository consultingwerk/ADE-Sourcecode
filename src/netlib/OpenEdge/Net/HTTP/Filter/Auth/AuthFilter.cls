/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : AuthFilter
    Purpose     : Request filter for adding authentication
    Author(s)   : pjudge
    Created     : Fri Feb 14 11:43:22 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Net.HTTP.AuthenticationMethodEnum.
using OpenEdge.Net.HTTP.AuthenticationRequestEventArgs.
using OpenEdge.Net.HTTP.Credentials.
using OpenEdge.Net.HTTP.Filter.FilterActionEnum.
using OpenEdge.Net.HTTP.Filter.IFilterEvents.
using OpenEdge.Net.HTTP.Filter.Message.IMessageFilter.
using OpenEdge.Net.HTTP.HttpMessage.
using OpenEdge.Net.HTTP.HttpRequest.
using Progress.Lang.Object.
using OpenEdge.Net.HTTP.Filter.Auth.IAuthFilterEventHandler.
using OpenEdge.Core.String.

class OpenEdge.Net.HTTP.Filter.Auth.AuthFilter 
            abstract 
            implements IFilterEvents, IMessageFilter:
    
    /** The HttpRequest does not know where the Domain and username */
    define public event HttpCredentialRequest signature void (
                                    input poSender as Object,
                                    input poEventArgs as AuthenticationRequestEventArgs).
    
    /** the AuthenticationMethod that this filter applies to */
    define public property AuthenticationMethod as AuthenticationMethodEnum no-undo get. private set.
    
    /** Returns the type(class or interface) that an a potential listener must
        implement or inherit in order to handle events from this filter. */
	define public property FilterEventListenerType as class Progress.Lang.Class no-undo 
    	get():
    		return get-class(IAuthFilterEventHandler).
    	end get.
        	
    constructor protected AuthFilter(input poAuthenticationMethod as AuthenticationMethodEnum ):
        Assert:NotNull(poAuthenticationMethod, 'Authentication Method').
        assign this-object:AuthenticationMethod = poAuthenticationMethod.
    end constructor.
    
    /** Indicates whether this filter applies to the current message. 
        
        @param HttpMessage The message to check
        @return logical True if the current filter can be used. */
    method public logical CanFilter(input poMessage as HttpMessage):
        define variable lCanFilter as logical no-undo.
        define variable oEntity as Object no-undo.
        
        lCanFilter = type-of(poMessage, HttpRequest).
        
        if lCanFilter then
            assign lCanFilter = this-object:AuthenticationMethod:Equals(
                                    cast(poMessage, HttpRequest):AuthenticationMethod).
        
        return lCanFilter.
    end method.
    
    /** Performs implementation-specific filtering for a message.
        
        @param HttpMessage The message to filter
        @return FilterActionEnum Status of the fitler action. The caller decides
                                 what to do with this information. Filters will
                                 typically return Stop or OK. */
    method abstract public FilterActionEnum ExecuteFilter(input poMessage as HttpMessage).
        
    /** Subscribes a listener to events from the implementing filter.
        
        @param Object The prospective listener. */
    method public void SubscribeListener(input poListener as Object):
        Assert:IsType(poListener, FilterEventListenerType).
        
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
    
    /** Publishes the HttpCredentialRequest event 
       
        @param AuthenticationRequestEventArgs The event args being modified/used 
                          in this event. */
    method protected void OnHttpCredentialRequest(input poAuthRequestArgs as AuthenticationRequestEventArgs):
        Assert:NotNull(poAuthRequestArgs, 'Authentication Request Event Args').
        
        this-object:HttpCredentialRequest:Publish(
                    this-object,
                    poAuthRequestArgs).
    end method.
    
    /** Returns credentials to be used by this filter. Can be retrieved from
        the Request or requested via an event
        
        @param  HttpRequest The requeste being challenged/filtered
        @param character The domain for which to get the credentials
        @return Credentials A set of credentials (may not be correct, of course) */
    method protected Credentials GetCredentials(input poRequest as HttpRequest,
                                                input pcDomain as character):
        define variable oCredentials as Credentials no-undo.
        define variable oAuthRequestArgs as AuthenticationRequestEventArgs no-undo.
        
        /* First try to get existing credentials */
        assign oCredentials = poRequest:Credentials.
        if valid-object(oCredentials) and 
           oCredentials:Domain eq pcDomain then
            return oCredentials.
        
        /* Publish the HttpAuthenticationRequest event to get username, etc 
           values from a client (we don't know what the username is, for instance) */
        assign oAuthRequestArgs                    = new AuthenticationRequestEventArgs(poRequest)
               oAuthRequestArgs:Credentials        = new Credentials()
               oAuthRequestArgs:Credentials:Domain = pcDomain.
        
        OnHttpCredentialRequest(oAuthRequestArgs).
        
        /* now we're done with getting the user/domain values ... */
        if oAuthRequestArgs:Cancel then
            return oCredentials.  /* will be ? here */
        
        /* Make sure that the we are authenticating for the requested domain */
        assign oCredentials = oAuthRequestArgs:Credentials.
        
        /* validate that the credentials weren't messed with in transit */
        Assert:NotNull(oCredentials, 'Credentials').
        Assert:Equals(pcDomain, oCredentials:Domain).
        
        return oCredentials.
    end method.
    
end class.