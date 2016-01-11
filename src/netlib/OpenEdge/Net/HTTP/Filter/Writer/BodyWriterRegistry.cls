/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : BodyWriterRegistry
    Purpose     : Contains mappings for content-types and message writers used to 
                  populate a message body 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Jul 01 14:54:10 EDT 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.BuilderRegistry.
using OpenEdge.Net.HTTP.Filter.Payload.BinaryBodyWriter.
using OpenEdge.Net.HTTP.Filter.Payload.HtmlBodyWriter.
using OpenEdge.Net.HTTP.Filter.Payload.JsonBodyWriter.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using OpenEdge.Net.HTTP.Filter.Payload.MultipartBodyWriter.
using OpenEdge.Net.HTTP.Filter.Payload.StringBodyWriter.
using OpenEdge.Net.HTTP.Filter.Payload.XmlBodyWriter.
using OpenEdge.Net.HTTP.Filter.Writer.BodyWriterRegistry.
using OpenEdge.Net.HTTP.Filter.Payload.FormDataBodyWriter.

class OpenEdge.Net.HTTP.Filter.Writer.BodyWriterRegistry: 
    /** Registry for mapping build types to their implementations */
    define static public property Registry as BuilderRegistry no-undo
        get():
            define variable oRegistry as BuilderRegistry no-undo.
            if not valid-object(BodyWriterRegistry:Registry) then
            do:
                assign oRegistry = new BuilderRegistry(get-class(MessageWriter)).
                BodyWriterRegistry:InitializeRegistry(oRegistry).                
                assign BodyWriterRegistry:Registry = oRegistry.
            end.
            return BodyWriterRegistry:Registry.
        end get.
        private set.

    /** Adds initial values into the registry 
    
        @param BuilderRegistry The registry to populate */
    method static private void InitializeRegistry(input poRegistry as BuilderRegistry):
        /* JSON */
        poRegistry:Put('application/json':u,              get-class(JsonBodyWriter)).
        poRegistry:Put('application/vnd.progress+json':u, get-class(JsonBodyWriter)).
        
        /* TEXT, INCL HTML */
        poRegistry:Put('text/html':u, get-class(HtmlBodyWriter)).
        poRegistry:Put('text/*':u,    get-class(StringBodyWriter)).
        
        /* FORM DATA */
        poRegistry:Put('application/x-www-form-urlencoded':u, get-class(FormDataBodyWriter)).
        
        /* XML */
        poRegistry:Put('text/xml':u,                               get-class(XmlBodyWriter)).
        poRegistry:Put('text/xml-external-parsed-entity':u,        get-class(XmlBodyWriter)).
        poRegistry:Put('application/xml':u,                        get-class(XmlBodyWriter)).
        poRegistry:Put('application/xml-external-parsed-entity':u, get-class(XmlBodyWriter)).
        poRegistry:Put('application/xml-dtd':u,                    get-class(XmlBodyWriter)).

        /* BINARY */
        poRegistry:Put('application/octet-stream':u, get-class(BinaryBodyWriter)).
        poRegistry:Put('application/pdf':u,          get-class(BinaryBodyWriter)).
        poRegistry:Put('application/zip':u,          get-class(BinaryBodyWriter)).
        poRegistry:Put('application/gzip':u,         get-class(BinaryBodyWriter)).
        
        /* General */
        poRegistry:Put('audio/*':u, get-class(BinaryBodyWriter)).
        poRegistry:Put('image/*':u, get-class(BinaryBodyWriter)).
        poRegistry:Put('video/*':u, get-class(BinaryBodyWriter)).
        
        /* Multipart */
        poRegistry:Put('multipart/*':u, get-class(MultipartBodyWriter)).
        
        /* In case all else fails ... we use application/octet-stream */
    end method.
    
end class.