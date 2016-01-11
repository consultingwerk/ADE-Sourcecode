/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : DefaultCookieJarBuilder
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Jan 14 14:53:46 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Net.HTTP.CookieJarBuilder.
using OpenEdge.Net.HTTP.HttpClientDecorator.
using OpenEdge.Net.HTTP.ICookieJar.
using OpenEdge.Net.HTTP.ICookieJar.
using OpenEdge.Net.URI.

class OpenEdge.Net.HTTP.DefaultCookieJarBuilder inherits CookieJarBuilder:
                 
    /** Returns a configured client. */
    define override public property CookieJar as ICookieJar no-undo
        get():
            return NewCookieJar().
        end get.

    constructor public DefaultCookieJarBuilder():
        super().
    end method.

    /** Returns a useable HttpClient based on the config.
        
        @return ICookieJar A useable HttpClient instance */
    method private ICookieJar NewCookieJar():
        define variable oCookieJar as ICookieJar no-undo.
        define variable oCookieJarType as Progress.Lang.Class no-undo.
        
        /* INVOKE */
        assign oCookieJarType = CookieJarBuilder:Registry:Get(get-class(ICookieJar):TypeName).
        
        /* We know the signature to the default client's constructor - make sure that the type we
           get is of that type */
        Assert:IsType(oCookieJarType, get-class(ICookieJar)).
        
        oCookieJar = dynamic-new string(oCookieJarType:TypeName) ().

        /* SET OPTIONS */
        if HasOption('cookieJarPath':u) then
            oCookieJar:CookieJarPath = GetOptionStringValue('cookieJarPath':u).

        /* INIT if needed  */
        if type-of(oCookieJar, ISupportInitialize) then
            cast(oCookieJar, ISupportInitialize):Initialize().
        
        return oCookieJar.
    end method.
    
end class.