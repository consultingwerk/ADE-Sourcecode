/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : ContentTypeResponseWriterBuilder
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
using OpenEdge.Net.HTTP.Filter.Payload.BinaryBodyResponseFilter.
using OpenEdge.Net.HTTP.Filter.Payload.JsonBodyResponseFilter.
using OpenEdge.Net.HTTP.Filter.Payload.StringBodyResponseFilter.
using OpenEdge.Net.HTTP.Filter.Payload.XmlBodyResponseFilter.
using OpenEdge.Net.HTTP.Filter.Writer.ContentTypeResponseWriterBuilder.
using OpenEdge.Net.HTTP.IHttpMessageWriter.
using OpenEdge.Net.HTTP.IHttpResponse.

class OpenEdge.Net.HTTP.Filter.Writer.ContentTypeResponseWriterBuilder:
    /** Registry for mapping build types to their implementations */
    define static public property Registry as BuilderRegistry no-undo
        get():
            define variable oRegistry as BuilderRegistry no-undo.
            if not valid-object(ContentTypeResponseWriterBuilder:Registry) then
            do:
                assign oRegistry = new BuilderRegistry(get-class(IHttpMessageWriter)).
                ContentTypeResponseWriterBuilder:InitializeRegistry(oRegistry).                
                assign ContentTypeResponseWriterBuilder:Registry = oRegistry.
            end.
            return ContentTypeResponseWriterBuilder:Registry.
        end get.
        private set.
    
    /** Adds initial values into the registry 
    
        @param BuilderRegistry The registry to populate */
    method static private void InitializeRegistry(input poRegistry as BuilderRegistry):
        /* JSON */
        poRegistry:Put('application/json':u,              get-class(JsonBodyResponseFilter)).
        poRegistry:Put('application/vnd.progress+json':u, get-class(JsonBodyResponseFilter)).
        
        /* HTML */
        poRegistry:Put('text/html':u, get-class(StringBodyResponseFilter)).
        poRegistry:Put('text/*':u,    get-class(StringBodyResponseFilter)).
        
        /* XML */
        poRegistry:Put('text/xml':u,                               get-class(XmlBodyResponseFilter)).
        poRegistry:Put('text/xml-external-parsed-entity':u,        get-class(XmlBodyResponseFilter)).
        poRegistry:Put('application/xml':u,                        get-class(XmlBodyResponseFilter)).
        poRegistry:Put('application/xml-external-parsed-entity':u, get-class(XmlBodyResponseFilter)).
        poRegistry:Put('application/xml-dtd':u,                    get-class(XmlBodyResponseFilter)).
        
        /* BINARY */
        poRegistry:Put('application/octet-stream':u, get-class(BinaryBodyResponseFilter)).
        poRegistry:Put('application/pdf':u,          get-class(BinaryBodyResponseFilter)).
        poRegistry:Put('application/zip':u,          get-class(BinaryBodyResponseFilter)).
        poRegistry:Put('application/gzip':u,         get-class(BinaryBodyResponseFilter)).
        
        /* General */
        poRegistry:Put('audio/*':u, get-class(BinaryBodyResponseFilter)).
        poRegistry:Put('image/*':u, get-class(BinaryBodyResponseFilter)).
        poRegistry:Put('video/*':u, get-class(BinaryBodyResponseFilter)).

        /* In case all else fails ... */
        poRegistry:Put('*/*':u, get-class(BinaryBodyResponseFilter)).
    end method.
    
    /** Returns a content type writer.
    
        The search alogrithm is
            type/sub-type
            type/*
            */*  
        
        @param character The name of the content type to register
        @return logical True if the content type was previously registered */
    method static class Progress.Lang.Class GetWriter(input pcContentType as character):
        define variable oWriter as Progress.Lang.Class no-undo.
        
        Assert:NotNull(pcContentType, 'Content type').
        
        /* no content type, no handler */
        if pcContentType eq '':u then
            return ?.
        
        /* content types are of the form
            type / sub-type ; parameter 
            
            We only care about the type + subtype */        
        assign pcContentType = trim(entry(1, pcContentType, ':':u)).
        
        assign oWriter = ContentTypeResponseWriterBuilder:Registry:Get(pcContentType).
        if not valid-object(oWriter) then
            assign oWriter = ContentTypeResponseWriterBuilder:Registry:Get(trim(entry(1, pcContentType, '/':u)) + '/*':u).
        if not valid-object(oWriter) then
            assign oWriter = ContentTypeResponseWriterBuilder:Registry:Get('*/*':u).
        
        return oWriter.
    end method.
    
    /** Returns a response writer for a given content-type.
        
        @param IHttpResponse The response being processed. 
        @return IHttpMessageWriter The message writer to use */
    method static public IHttpMessageWriter Build(input poResponse as IHttpResponse):
        define variable oWriter as IHttpMessageWriter no-undo.
        define variable oWriterType as class Progress.Lang.Class no-undo.
        
        Assert:NotNull(poResponse, 'Response').
        
        assign oWriterType = GetWriter(poResponse:ContentType).
        if not valid-object(oWriterType) then
            return oWriter.
        
        /* double-check we have the correct type */
        Assert:IsType(oWriterType, get-class(IHttpMessageWriter)).
        
        oWriter = dynamic-new string(oWriterType:TypeName) (input poResponse). 
        
        if type-of(oWriter, ISupportInitialize) then
            cast(oWriter, ISupportInitialize):Initialize().
        
        return oWriter.
    end method.

end class.