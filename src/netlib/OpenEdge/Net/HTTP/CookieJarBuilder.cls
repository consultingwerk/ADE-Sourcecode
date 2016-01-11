/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : CookieJarBuilder
    Purpose     : Allows the construction of a working CookieJar via a fluent
                  interface. 
    Syntax      : CookieJarBuilder:Build().
    Description : 
    Author(s)   : pjudge
    Created     : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Net.HTTP.BuilderRegistry.
using OpenEdge.Net.HTTP.CookieJarBuilder.
using OpenEdge.Net.HTTP.DefaultCookieJarBuilder.
using OpenEdge.Net.HTTP.ICookieJar.
using OpenEdge.Net.HTTP.CookieJar.
using OpenEdge.Net.HTTP.CookieJarDecorator.
using OpenEdge.Net.HTTP.ConfigBuilder.

class OpenEdge.Net.HTTP.CookieJarBuilder abstract inherits ConfigBuilder:
    
    /** Registry for mapping build types to their implementations */
    define static public property Registry as BuilderRegistry no-undo
        get():
            define variable oRegistry as BuilderRegistry no-undo.
            if not valid-object(CookieJarBuilder:Registry) then
            do:
                assign oRegistry = new BuilderRegistry().
                CookieJarBuilder:InitializeRegistry(oRegistry).                
                assign CookieJarBuilder:Registry = oRegistry.
            end.
            return CookieJarBuilder:Registry.
        end get.
        private set.
   
    /** Returns a configured client. */
    define abstract property CookieJar as ICookieJar no-undo get.
    
    /** Adds initial values into the registry 
    
        @param BuilderRegistry The registry to populate */
    method static private void InitializeRegistry(input poRegistry as BuilderRegistry):
        /* default builder */
        poRegistry:Put(get-class(CookieJarBuilder):TypeName,
                       get-class(DefaultCookieJarBuilder)).
        
        /* default cookie jar type */
        poRegistry:Put(get-class(ICookieJar):TypeName,
                       get-class(CookieJar)).
    end method.
    
    /** Builder director method.
        
        @return CookieJarBuilder A builder for the requested type */
    method static public CookieJarBuilder Build():
        define variable oBuilderType as Progress.Lang.Class no-undo.
        define variable oCB as CookieJarBuilder no-undo.
        
        assign oBuilderType = CookieJarBuilder:Registry:Get(get-class(CookieJarBuilder):TypeName).
        Assert:IsType(oBuilderType, get-class(CookieJarBuilder)).
        
        /* Issue PSC00326382 means that we must use dynamic-new instead of New() */
        oCB = dynamic-new string(oBuilderType:TypeName) ().        
        
        if type-of(oCB, ISupportInitialize) then
            cast(oCB, ISupportInitialize):Initialize().
        
        return oCB.
    end method.
    
    /** Sets the URI to use as a proxy server for all requests
        
        @param character The proxy server URI
        @return CookieJarBuilder This builder object. */
    method public CookieJarBuilder PersistTo(input pcCookieJarPath  as character):
        Assert:NotNullOrEmpty(pcCookieJarPath, 'Cookie Jar Persistence Path').
        
        SetOption('cookieJarPath', pcCookieJarPath).
        
        return this-object.
    end method.
    
    /** Decorate the cookie jar with additional behaviour
            
        @param  Class The type of decorator to use
        @param  ICookieJar The cookie jar/instance we're decorating
        @return ICookieJar The new, decorating cookie jar */
    method static public ICookieJar DecorateCookieJar(input poDecorationType as Progress.Lang.Class,
                                                      input poDecoratedClient as ICookieJar):
        define variable oDecorator as ICookieJar no-undo.
        define variable oDecoratorType as Progress.Lang.Class no-undo.
        define variable oClient as ICookieJar no-undo.
        
        assign oDecoratorType = CookieJarBuilder:Registry:Get(poDecorationType:TypeName).

       if not valid-object(oDecoratorType) then
            return poDecoratedClient.
        
        /* got to be able to decorate ... */            
        Assert:IsType(oDecoratorType, get-class(CookieJarDecorator)).
        
        oClient = dynamic-new string(oDecoratorType:TypeName) (input poDecoratedClient).

        if type-of(oClient, ISupportInitialize) then
            cast(oClient, ISupportInitialize):Initialize().

        return oClient.
    end method.    
end class.