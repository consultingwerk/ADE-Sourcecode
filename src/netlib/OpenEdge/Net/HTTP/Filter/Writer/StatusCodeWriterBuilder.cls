/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : StatusCodeWriterBuilder
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
using OpenEdge.Net.HTTP.Filter.Writer.StatusCodeWriterBuilder.
using OpenEdge.Net.HTTP.Filter.Status.AuthorizationStatusFilter.
using OpenEdge.Net.HTTP.Filter.Status.RedirectStatusFilter.
using OpenEdge.Net.HTTP.IHttpMessageWriter.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.StatusCodeEnum.
using Progress.Lang.Object.
using OpenEdge.Net.HTTP.BuilderRegistry.

class OpenEdge.Net.HTTP.Filter.Writer.StatusCodeWriterBuilder:
    
    /** Registry for mapping build types to their implementations */
    define static public property Registry as BuilderRegistry no-undo
        get():
            define variable oRegistry as BuilderRegistry no-undo.
            if not valid-object(StatusCodeWriterBuilder:Registry) then
            do:
                assign oRegistry = new BuilderRegistry(get-class(IHttpMessageWriter)).
                StatusCodeWriterBuilder:InitializeRegistry(oRegistry).                
                assign StatusCodeWriterBuilder:Registry = oRegistry.
            end.
            return StatusCodeWriterBuilder:Registry.
        end get.
        private set.
    
    /** Adds initial values into the registry 
    
        @param BuilderRegistry The registry to populate */
    method static private void InitializeRegistry(input poRegistry as BuilderRegistry):        /* redirects */
        /* redirects */
        poRegistry:Put(string(integer(StatusCodeEnum:Found)),
                       get-class(RedirectStatusFilter)).
        poRegistry:Put(string(integer(StatusCodeEnum:MovedPermanently)),
                       get-class(RedirectStatusFilter)).

        /* authorization */
        poRegistry:Put(string(integer(StatusCodeEnum:Unauthorized)),
                       get-class(AuthorizationStatusFilter)).
    end method.        
    
    /** Returns a response writer for a given content-type.
        
        @param IHttpResponse The response being processed.
        @return IHttpMessageWriter The message writer to use */
    method static public IHttpMessageWriter Build(input poRequest as IHttpRequest,
                                                  input poResponse as IHttpResponse):
        define variable oWriter as IHttpMessageWriter no-undo.
        define variable oWriterType as class Progress.Lang.Class no-undo.
        
        Assert:NotNull(poResponse, 'Response').
        
        assign oWriterType = StatusCodeWriterBuilder:Registry:Get(string(poResponse:StatusCode)).
        
        /* no handler for this type */
        if not valid-object(oWriterType) then
            return oWriter.
        
        /* double-check we have the correct type */
        Assert:IsType(oWriterType, get-class(IHttpMessageWriter)).
        
        oWriter = dynamic-new string(oWriterType:TypeName) (input poRequest).
                
        if type-of(oWriter, ISupportInitialize) then
            cast(oWriter, ISupportInitialize):Initialize().
        
        return oWriter.
    end method.
    
end class.