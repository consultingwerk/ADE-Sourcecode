/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : HttpHeaderBuilder
    Purpose     : Creates an instance of an HttpHeader object. 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Feb 13 13:33:42 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Net.HTTP.BuilderRegistry.
using OpenEdge.Net.HTTP.DefaultHeaderBuilder.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.HttpHeaderBuilder.

class OpenEdge.Net.HTTP.HttpHeaderBuilder abstract: 
    define protected property HeaderName as character no-undo get. private set.
                
    /** Registry for mapping build types to their implementations */
    define static public property Registry as BuilderRegistry no-undo
        get():
            define variable oRegistry as BuilderRegistry no-undo.
            if not valid-object(HttpHeaderBuilder:Registry) then
            do:
                assign oRegistry = new BuilderRegistry(get-class(HttpHeaderBuilder)).
                HttpHeaderBuilder:InitializeRegistry(oRegistry).                
                assign HttpHeaderBuilder:Registry = oRegistry.
            end.
            return HttpHeaderBuilder:Registry.
        end get.
        private set.
    
    /** Each concrete builder will implement this differently */
    define abstract public property Header as HttpHeader no-undo get.
    
    /** Adds initial values into the registry 
        
        @param BuilderRegistry The registry to populate */
    method static private void InitializeRegistry(input poRegistry as BuilderRegistry):
        /* default builder */
        poRegistry:Put('*':u, get-class(DefaultHeaderBuilder)).
    end method.
    
    /** Builder director method.
        
        @return RequestBuilder A builder for the requested type */
    method static public HttpHeaderBuilder Build(input pcName as character):
        define variable oBuilderType as Progress.Lang.Class no-undo.
        define variable oHB as HttpHeaderBuilder no-undo.
        
        Assert:NotNullOrEmpty(pcName, 'Header name').
        
        assign oBuilderType = HttpHeaderBuilder:Registry:Get(pcName).
        if not valid-object(oBuilderType) then
            assign oBuilderType = HttpHeaderBuilder:Registry:Get('*':u).    
        
        Assert:IsType(oBuilderType, get-class(HttpHeaderBuilder)).
        
        oHB = dynamic-new string(oBuilderType:TypeName) (input pcName).
        
        if type-of(oHB, ISupportInitialize) then
            cast(oHB, ISupportInitialize):Initialize().
        
        return oHB.
    end method.
    
    constructor protected HttpHeaderBuilder(input pcHeaderName as character):
        Assert:NotNullOrEmpty(pcHeaderName, 'Header name').
        assign this-object:HeaderName = pcHeaderName.
    end constructor.
    
    /** Sets the header's value 
        
        @param character The complete (unparsed) header value
        @return HttpHeaderBuilder The current builder object. */
    method abstract public HttpHeaderBuilder Value(input pcValue as character).
    
end class.