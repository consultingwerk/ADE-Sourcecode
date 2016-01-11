/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : RequestWriterBuilder
    Purpose     : Builds a request writer for a given type of entity
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jan 29 09:30:28 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Net.HTTP.BuilderRegistry.
using OpenEdge.Net.HTTP.Filter.Payload.DefaultRequestFilter.
using OpenEdge.Net.HTTP.Filter.Payload.JsonBodyRequestFilter.
using OpenEdge.Net.HTTP.Filter.Payload.StringBodyRequestFilter.
using OpenEdge.Net.HTTP.Filter.Payload.XmlBodyRequestFilter.
using OpenEdge.Net.HTTP.Filter.Writer.RequestWriterBuilder.
using OpenEdge.Net.HTTP.IHttpMessageWriter.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.Filter.Payload.HtmlBodyRequestFilter.
using OpenEdge.Net.HTTP.Filter.Payload.BinaryBodyRequestFilter.

class OpenEdge.Net.HTTP.Filter.Writer.RequestWriterBuilder:
    
    /** Registry for mapping build types to their implementations */
    define static public property Registry as BuilderRegistry no-undo
        get():
            define variable oRegistry as BuilderRegistry no-undo.
            if not valid-object(RequestWriterBuilder:Registry) then
            do:
                assign oRegistry = new BuilderRegistry(get-class(DefaultRequestFilter)).
                RequestWriterBuilder:InitializeRegistry(oRegistry).                
                assign RequestWriterBuilder:Registry = oRegistry.
            end.
            return RequestWriterBuilder:Registry.
        end get.
        private set.
    
    /** Adds initial values into the registry 
    
        @param BuilderRegistry The registry to populate */
    method static private void InitializeRegistry(input poRegistry as BuilderRegistry):
        /* JSON */
        poRegistry:Put('application/json':u,              get-class(JsonBodyRequestFilter)).
        poRegistry:Put('application/vnd.progress+json':u, get-class(JsonBodyRequestFilter)).
        
        /* TEXT, INCL HTML */
        poRegistry:Put('text/html':u, get-class(HtmlBodyRequestFilter)).
        poRegistry:Put('text/*':u,    get-class(StringBodyRequestFilter)).
        
        /* XML */
        poRegistry:Put('text/xml':u,                               get-class(XmlBodyRequestFilter)).
        poRegistry:Put('text/xml-external-parsed-entity':u,        get-class(XmlBodyRequestFilter)).
        poRegistry:Put('application/xml':u,                        get-class(XmlBodyRequestFilter)).
        poRegistry:Put('application/xml-external-parsed-entity':u, get-class(XmlBodyRequestFilter)).
        poRegistry:Put('application/xml-dtd':u,                    get-class(XmlBodyRequestFilter)).

        /* BINARY */
        poRegistry:Put('application/octet-stream':u, get-class(BinaryBodyRequestFilter)).
        poRegistry:Put('application/pdf':u,          get-class(BinaryBodyRequestFilter)).
        poRegistry:Put('application/zip':u,          get-class(BinaryBodyRequestFilter)).
        poRegistry:Put('application/gzip':u,         get-class(BinaryBodyRequestFilter)).
        
        /* General */
        poRegistry:Put('audio/*':u, get-class(BinaryBodyRequestFilter)).
        poRegistry:Put('image/*':u, get-class(BinaryBodyRequestFilter)).
        poRegistry:Put('video/*':u, get-class(BinaryBodyRequestFilter)).
        
        /* In case all else fails ... */
        poRegistry:Put('*/*':u, get-class(StringBodyRequestFilter)).
        
        /* blank for no body */
        poRegistry:Put('':u, get-class(DefaultRequestFilter)).
    end method.        
    
    /** Returns a request writer for a given entity type.
    
        @param IHttpRequest The request being processed.
        @return IHttpMessageWriter The message writer to use */
    method static public IHttpMessageWriter Build(input poMessage as IHttpRequest):
        define variable oWriter as IHttpMessageWriter no-undo.
        define variable oWriterType as class Progress.Lang.Class no-undo.
        
        Assert:NotNull(poMessage, 'Request').
        
        assign oWriterType = RequestWriterBuilder:GetWriter(poMessage:ContentType).
        if not valid-object(oWriterType) then
            return oWriter.
        
        /* double-check we have the correct type */
        Assert:IsType(oWriterType, get-class(DefaultRequestFilter)).
        
        oWriter= dynamic-new string(oWriterType:TypeName) (input poMessage).
        
        if type-of(oWriter, ISupportInitialize) then
            cast(oWriter, ISupportInitialize):Initialize().
        
        return oWriter.
    end method.
    
    /** Returns a request body writer.
    
        The search alogrithm is
            type/sub-type
            type/*
            */*  
        
        @param character The name of the content type to register
        @return logical True if the content type was previously registered */
    method static class Progress.Lang.Class GetWriter(input pcContentType as character):
        define variable oWriter as Progress.Lang.Class no-undo.
        
        Assert:NotNull(pcContentType, 'Content type').
        
        /* content types are of the form
            type / sub-type ; parameter 
            
            We only care about the type + subtype */        
        assign pcContentType = trim(entry(1, pcContentType, ';':u)).
        
        assign oWriter = RequestWriterBuilder:Registry:Get(pcContentType).
        if not valid-object(oWriter) then
            assign oWriter = RequestWriterBuilder:Registry:Get(trim(entry(1, pcContentType, '/':u)) + '/*':u).
        if not valid-object(oWriter) then
            assign oWriter = RequestWriterBuilder:Registry:Get('*/*':u).
        
        return oWriter.
    end method.
    
end class.