/************************************************
Copyright (c)  2014, 2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : ResponseBuilder
    Purpose     : Creates an instance of an HttpResponse object. Most of the
                  contents of the response are populated by a response filter.
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Feb 10 14:50:10 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.
  
using OpenEdge.Core.Assert.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Net.HTTP.BuilderRegistry.
using OpenEdge.Net.HTTP.DefaultResponseBuilder.
using OpenEdge.Net.HTTP.HttpResponse.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.ResponseBuilder.
using OpenEdge.Core.Util.ConfigBuilder.

class OpenEdge.Net.HTTP.ResponseBuilder abstract inherits ConfigBuilder
        implements ISupportInitialize:
    
    /** Registry for mapping build types to their implementations */
    define static public property Registry as BuilderRegistry no-undo
        get():
            define variable oRegistry as BuilderRegistry no-undo.
            if not valid-object(ResponseBuilder:Registry) then
            do:
                assign oRegistry = new BuilderRegistry().
                ResponseBuilder:InitializeRegistry(oRegistry).                
                assign ResponseBuilder:Registry = oRegistry.
            end.
            return ResponseBuilder:Registry.
        end get.
        private set.
    
    /** Each concrete builder will implement this differently */
    define abstract public property Response as IHttpResponse no-undo get.
    
    destructor public ResponseBuilder():
        Destroy().
    end destructor.  
    
    /** Adds initial values into the registry 
    
        @param BuilderRegistry The registry to populate */
    method static private void InitializeRegistry(input poRegistry as BuilderRegistry):
        /* default builder */
        poRegistry:Put(get-class(ResponseBuilder):TypeName,
                       get-class(DefaultResponseBuilder)).
        
        /* default response type */
        poRegistry:Put(get-class(IHttpResponse):TypeName,
                       get-class(HttpResponse)).
    end method.
    
    /** Builder director method.
        
        @return RequestBuilder A builder for the requested type */
    method static public ResponseBuilder Build():
        define variable oBuilderType as Progress.Lang.Class no-undo.
        define variable oRB as ResponseBuilder no-undo.
        
        assign oBuilderType = ResponseBuilder:Registry:Get(get-class(ResponseBuilder):TypeName).
        Assert:IsType(oBuilderType, get-class(ResponseBuilder)).

        oRB = dynamic-new string(oBuilderType:TypeName) ().
        
        if type-of(oRB, ISupportInitialize) then
            cast(oRB, ISupportInitialize):Initialize().
        
        return oRB.
    end method.
    
    constructor protected ResponseBuilder():
    end constructor.
    
    /* Initializer/Startup */
    method public void Initialize():
        HttpVersion('HTTP/1.1':u).
    end method.
    
    /* Destroy/Shutdown/Anti-Initializer */
    method public void Destroy():
    end method.
    
    /** Sets the HTTP version of the request   
    
        @param character A version
        @return ResponseBuilder The response builder being constructed. */
    method public ResponseBuilder HttpVersion(input pcVersion as character):
        Assert:NotNullOrEmpty(pcVersion, 'HTTP version').
        
        SetOption('version':u, pcVersion).
        
        return this-object.
    end method.
    
end class.