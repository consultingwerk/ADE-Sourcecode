/************************************************
Copyright (c) 2015, 2017-2018  by Progress Software Corporation. All rights reserved.
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
using OpenEdge.Core.AssertionFailedError.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Net.HTTP.BuilderRegistry.
using OpenEdge.Net.HTTP.ConfigBuilder.
using OpenEdge.Net.HTTP.ContentDispositionHeaderBuilder.
using OpenEdge.Net.HTTP.ContentTypeHeaderBuilder.
using OpenEdge.Net.HTTP.DefaultHeaderBuilder.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.HttpHeaderBuilder.
using OpenEdge.Net.HTTP.SemicolonParamHeaderBuilder.
using OpenEdge.Net.HTTP.AuthorizationHeaderBuilder.

class OpenEdge.Net.HTTP.HttpHeaderBuilder inherits ConfigBuilder 
            abstract: 
                
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
        poRegistry:Put('Content-Type':u, get-class(ContentTypeHeaderBuilder)).
        poRegistry:Put('Content-Disposition':u, get-class(ContentDispositionHeaderBuilder)).
        poRegistry:Put('Cookie':u, get-class(SemicolonParamHeaderBuilder)).
        
        poRegistry:Put('WWW-Authentication':u, get-class(AuthorizationHeaderBuilder)).
        poRegistry:Put('Authorization':u, get-class(AuthorizationHeaderBuilder)).
        
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
    method public HttpHeaderBuilder Value(input pcValue as character):
        Assert:NotNull(pcValue, 'Header value').
        
        SetOption('hdrValue':u, pcValue). 
        
        return this-object.
    end method.

    /* Sets the header's parameter delimiter
       
       @param character The delimter to use between parameters
       @return HttpHeaderBuilder The current builder object. */
    method public HttpHeaderBuilder ParametersDelimitedBy(input pcDelim as character):
        Assert:NotNull(pcDelim, 'Parameter delimiter').
        // we allow spaces as delimiters (length > 0)
        if length(pcDelim) eq 0 then
            undo, throw new AssertionFailedError('Parameter delimiter cannot be empty', 0).
        
        SetOption('paramDelimiter':u, pcDelim).
        
        return this-object.
    end method.
    
    /* Adds a header parameter name and value 
       
       @param character The parameter name
       @param character The parameter value
       @return HttpHeaderBuilder The current builder object. */
    method public HttpHeaderBuilder AddParameter(input pName as character,
                                                 input pValue as character):
        Assert:NotNullOrEmpty(pName, 'Parameter name').
        Assert:NotNull(pValue, 'Parameter value').
        
        SetOption('param+':u + pName, pValue).
        
        return this-object.
    end method.
    
end class.