/************************************************
Copyright (c) 2015, 2018 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : EntityWriterRegistry
    Purpose     : Contains mappings for content-types and message writers used to 
                  populate a message's (request/response/part) entity 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Jul 01 14:50:44 EDT 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.BuilderRegistry.
using OpenEdge.Net.HTTP.Filter.Payload.BinaryEntityWriter.
using OpenEdge.Net.HTTP.Filter.Payload.JsonEntityWriter.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using OpenEdge.Net.HTTP.Filter.Payload.MultipartEntityWriter.
using OpenEdge.Net.HTTP.Filter.Payload.MultipartFormEntityWriter.
using OpenEdge.Net.HTTP.Filter.Payload.StringEntityWriter.
using OpenEdge.Net.HTTP.Filter.Payload.XmlEntityWriter.
using OpenEdge.Net.HTTP.Filter.Writer.EntityWriterRegistry.

class OpenEdge.Net.HTTP.Filter.Writer.EntityWriterRegistry inherits BuilderRegistry:
    /** Registry for mapping build types to their implementations */
    define static public property Registry as BuilderRegistry no-undo
        get():
            define variable oRegistry as BuilderRegistry no-undo.
            if not valid-object(EntityWriterRegistry:Registry) then
            do:
                assign oRegistry = new BuilderRegistry(get-class(MessageWriter)).
                EntityWriterRegistry:InitializeRegistry(oRegistry).                
                assign EntityWriterRegistry:Registry = oRegistry.
            end.
            return EntityWriterRegistry:Registry.
        end get.
        private set.
     
    /** Adds initial values into the registry 
        
        @param BuilderRegistry The registry to populate */
    method static private void InitializeRegistry(input poRegistry as BuilderRegistry):
        /* JSON */
        poRegistry:Put('application/json':u,              get-class(JsonEntityWriter)).
        poRegistry:Put('application/vnd.progress+json':u, get-class(JsonEntityWriter)).
        
        /* TEXT, INCL HTML */
        poRegistry:Put('text/*':u,    get-class(StringEntityWriter)).
        
        /* FORM DATA */
        /*
        poRegistry:Put('application/x-www-form-urlencoded':u, get-class(FormDataEntityWriter)).
        */
        
        /* XML */
        poRegistry:Put('text/xml':u,                               get-class(XmlEntityWriter)).
        poRegistry:Put('text/xml-external-parsed-entity':u,        get-class(XmlEntityWriter)).
        poRegistry:Put('application/xml':u,                        get-class(XmlEntityWriter)).
        poRegistry:Put('application/xml-external-parsed-entity':u, get-class(XmlEntityWriter)).
        poRegistry:Put('application/xml-dtd':u,                    get-class(XmlEntityWriter)).

        /* BINARY */
        poRegistry:Put('application/octet-stream':u, get-class(BinaryEntityWriter)).
        poRegistry:Put('application/pdf':u,          get-class(BinaryEntityWriter)).
        poRegistry:Put('application/zip':u,          get-class(BinaryEntityWriter)).
        poRegistry:Put('application/gzip':u,         get-class(BinaryEntityWriter)).
        
        /* General */
        poRegistry:Put('audio/*':u, get-class(BinaryEntityWriter)).
        poRegistry:Put('image/*':u, get-class(BinaryEntityWriter)).
        poRegistry:Put('video/*':u, get-class(BinaryEntityWriter)).
        
        /* Multipart */
        poRegistry:Put('multipart/form-data':u, get-class(MultipartFormEntityWriter)).
        /* Fastest form-data writer
          poRegistry:Put('multipart/form-data':u, get-class(MultipartFormSimpleEntityWriter)). */
        poRegistry:Put('multipart/*':u,         get-class(MultipartEntityWriter)).
        
        /* In case all else fails ... we use application/octet-stream */
    end method.
    
end class.