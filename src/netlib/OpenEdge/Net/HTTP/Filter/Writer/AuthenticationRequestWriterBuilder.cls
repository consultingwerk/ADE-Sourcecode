/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : AuthenticationRequestWriterBuilder
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Jan 30 09:57:53 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Net.HTTP.AuthenticationMethodEnum.
using OpenEdge.Net.HTTP.BuilderRegistry.
using OpenEdge.Net.HTTP.Filter.Auth.BasicAuthenticationFilter.
using OpenEdge.Net.HTTP.Filter.Auth.DigestAuthenticationFilter.
using OpenEdge.Net.HTTP.Filter.Auth.IAuthFilterEventHandler.
using OpenEdge.Net.HTTP.Filter.Auth.NoAuthenticationFilter.
using OpenEdge.Net.HTTP.Filter.IFilterEvents.
using OpenEdge.Net.HTTP.Filter.Writer.AuthenticationRequestWriterBuilder.
using OpenEdge.Net.HTTP.IAuthenticatedRequest.
using OpenEdge.Net.HTTP.IHttpMessageWriter.

class OpenEdge.Net.HTTP.Filter.Writer.AuthenticationRequestWriterBuilder:
    /** Registry for mapping build types to their implementations */
    define static public property Registry as BuilderRegistry no-undo
        get():
            define variable oRegistry as BuilderRegistry no-undo.
            if not valid-object(AuthenticationRequestWriterBuilder:Registry) then
            do:
                assign oRegistry = new BuilderRegistry(get-class(IHttpMessageWriter)).
                AuthenticationRequestWriterBuilder:InitializeRegistry(oRegistry).                
                assign AuthenticationRequestWriterBuilder:Registry = oRegistry.
            end.
            return AuthenticationRequestWriterBuilder:Registry.
        end get.
        private set.
    
    /** Adds initial values into the registry 
    
        @param BuilderRegistry The registry to populate */
    method static private void InitializeRegistry(input poRegistry as BuilderRegistry):    
        poRegistry:Put(string(AuthenticationMethodEnum:Basic), 
                       get-class(BasicAuthenticationFilter)).
        
        poRegistry:Put(string(AuthenticationMethodEnum:Digest), 
                       get-class(DigestAuthenticationFilter)).
        
        poRegistry:Put(string(AuthenticationMethodEnum:None), 
                       get-class(NoAuthenticationFilter)).
    end method.
    
    /** Returns a writer for the authentication method 
        
        @param IAuthenticatedRequest The message being processed. 
        @return IHttpMessageWriter The message writer to use */
    method static public IHttpMessageWriter Build(input poRequest as IAuthenticatedRequest):
        define variable oWriter as IHttpMessageWriter no-undo.
        define variable oWriterType as class Progress.Lang.Class no-undo.
        
        Assert:NotNull(poRequest, 'Request').
        
        assign oWriterType = AuthenticationRequestWriterBuilder:Registry:Get(poRequest:AuthenticationMethod).
        if valid-object(oWriterType) 
        then do: 
          /* double-check we have the correct type */
          Assert:IsType(oWriterType, get-class(IHttpMessageWriter)).
          oWriter = dynamic-new string(oWriterType:TypeName) (input poRequest).
          if type-of(oWriter, ISupportInitialize) 
          then
            cast(oWriter, ISupportInitialize):Initialize().
          return oWriter.
        end.           
    end method.
    
    /** Returns a writer fot the  authenticated request
        
        @param IAuthenticatedRequest The message being processed. 
        @param IAuthFilterEventHandler[] An array of listeners
        @return IHttpMessageWriter The message writer to use */
    method static public IHttpMessageWriter Build(input poRequest  as IAuthenticatedRequest,
                                                  input poListener as IAuthFilterEventHandler extent):
        define variable oWriter as IHttpMessageWriter no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        assign oWriter = AuthenticationRequestWriterBuilder:Build(poRequest).
        
        /* make sure that the write can (a) handle events, and 
           (b) handle auth filter events */
        if type-of(oWriter, IFilterEvents) then
        do:
            assign iMax = extent(poListener).
            do iLoop = 1 to iMax:
                cast(oWriter, IFilterEvents):SubscribeListener(poListener[iLoop]).
            end. 
        end.
        
        return oWriter.                                                      
    end method.

    
end class.
