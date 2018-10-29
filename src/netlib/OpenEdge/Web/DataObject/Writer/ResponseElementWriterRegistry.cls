/* *************************************************************************************************************************
Copyright (c) 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : ResponseElementWriterRegistry
    Purpose     : Registry for types that write a response element 
    Description : 
    Author(s)   : pjudge
    Created     : 2018-05-08
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.BuilderRegistry.
using OpenEdge.Web.DataObject.ElementTypeEnum.
using OpenEdge.Web.DataObject.Writer.BodyElementWriter.
using OpenEdge.Web.DataObject.Writer.CookieElementWriter.
using OpenEdge.Web.DataObject.Writer.FieldElementWriter.
using OpenEdge.Web.DataObject.Writer.HeaderElementWriter.
using OpenEdge.Web.DataObject.Writer.ResponseElementWriter.
using OpenEdge.Web.DataObject.Writer.ResponseElementWriterRegistry.
using OpenEdge.Web.DataObject.Writer.StatusCodeElementWriter.

class OpenEdge.Web.DataObject.Writer.ResponseElementWriterRegistry:
    
    /** Registry for mapping build types to their implementations */
    define static public property Registry as BuilderRegistry no-undo
        get():
            define variable oRegistry as BuilderRegistry no-undo.
            if not valid-object(ResponseElementWriterRegistry:Registry) then
            do:
                assign oRegistry = new BuilderRegistry(get-class(ResponseElementWriter)).
                ResponseElementWriterRegistry:InitializeRegistry(oRegistry).                
                assign ResponseElementWriterRegistry:Registry = oRegistry.
            end.
            return ResponseElementWriterRegistry:Registry.
        end get.
        private set.
    
    /** Adds initial values into the registry 
        
        @param BuilderRegistry The registry to populate */
    method static private void InitializeRegistry(input poRegistry as BuilderRegistry):
        poRegistry:Put(ElementTypeEnum:Header,         get-class(HeaderElementWriter)).
        poRegistry:Put(ElementTypeEnum:HeaderSet,      get-class(HeaderElementWriter)).
        poRegistry:Put(ElementTypeEnum:Cookie,         get-class(CookieElementWriter)).
        poRegistry:Put(ElementTypeEnum:StatusCode,     get-class(StatusCodeElementWriter)).
        poRegistry:Put(ElementTypeEnum:Body,           get-class(BodyElementWriter)).
        poRegistry:Put(ElementTypeEnum:Field,          get-class(FieldElementWriter)).
    end method.
    
end class.