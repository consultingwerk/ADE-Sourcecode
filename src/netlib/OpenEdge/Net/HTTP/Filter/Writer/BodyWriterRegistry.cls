/************************************************
Copyright (c) 2015, 2018-2019 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : BodyWriterRegistry
    Purpose     : Contains mappings for content-types and message writers used to 
                  populate a message body 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Jul 01 14:54:10 EDT 2015
    Notes       : ** OCTA-11217 -- update to support variable assignment for put get-class condition
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
using OpenEdge.Net.HTTP.Filter.Payload.MultipartFormBodyWriter.

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
        
        DEFINE VARIABLE opType AS CLASS Progress.Lang.Class.
        
        ASSIGN
          opType = get-class(JsonBodyWriter).
        /* JSON */
        poRegistry:Put('application/json':u,              opType).
        poRegistry:Put('application/vnd.progress+json':u, opType).
        
        /* TEXT, INCL HTML */
        poRegistry:Put('text/html':u, get-class(HtmlBodyWriter)).
        poRegistry:Put('text/*':u,    get-class(StringBodyWriter)).
        
        /* FORM DATA */
        poRegistry:Put('application/x-www-form-urlencoded':u, get-class(FormDataBodyWriter)).
        
        ASSIGN
          opType = get-class(XmlBodyWriter).
        /* XML */
        poRegistry:Put('text/xml':u,                               opType).
        poRegistry:Put('text/xml-external-parsed-entity':u,        opType).
        poRegistry:Put('application/xml':u,                        opType).
        poRegistry:Put('application/xml-external-parsed-entity':u, opType).
        poRegistry:Put('application/xml-dtd':u,                    opType).

        ASSIGN
          opType = GET-CLASS(BinaryBodyWriter).
        /* BINARY */
        poRegistry:Put('application/octet-stream':u, opType).
        poRegistry:Put('application/pdf':u,          opType).
        poRegistry:Put('application/zip':u,          opType).
        poRegistry:Put('application/gzip':u,         opType).
        
        /* General */
        poRegistry:Put('audio/*':u,                  opType).
        poRegistry:Put('image/*':u,                  opType).
        poRegistry:Put('video/*':u,                  opType).
        
        /* Multipart */
        poRegistry:Put('multipart/form-data':u, get-class(MultipartFormBodyWriter)).
        poRegistry:Put('multipart/*':u, get-class(MultipartBodyWriter)).
        
        /* In case all else fails ... we use application/octet-stream */
    end method.
    
end class.