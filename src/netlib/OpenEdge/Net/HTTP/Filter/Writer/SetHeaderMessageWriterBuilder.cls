/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : SetHeaderMessageWriterBuilder
    Purpose     : Builds a message writer for setting headers on a message
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jan 29 09:30:28 EST 2015
    Notes       : * Typically used for cases where a HttpMessage property is
                    populted from different headers (names); also for Cookies.
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Net.HTTP.BuilderRegistry.
using OpenEdge.Net.HTTP.Filter.Header.SetCookieSetHeaderFilter.
using OpenEdge.Net.HTTP.Filter.Header.TransferEncodingSetHeaderFilter.
using OpenEdge.Net.HTTP.Filter.Writer.SetHeaderMessageWriterBuilder.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.IHttpMessage.
using OpenEdge.Net.HTTP.IHttpMessageWriter.

class OpenEdge.Net.HTTP.Filter.Writer.SetHeaderMessageWriterBuilder:
    /** Registry for mapping build types to their implementations */
    define static public property Registry as BuilderRegistry no-undo
        get():
            define variable oRegistry as BuilderRegistry no-undo.
            if not valid-object(SetHeaderMessageWriterBuilder:Registry) then
            do:
                assign oRegistry = new BuilderRegistry(get-class(IHttpMessageWriter)).
                SetHeaderMessageWriterBuilder:InitializeRegistry(oRegistry).                
                assign SetHeaderMessageWriterBuilder:Registry = oRegistry.
            end.
            return SetHeaderMessageWriterBuilder:Registry.
        end get.
        private set.
    
    /** Adds initial values into the registry
    
        @param BuilderRegistry The registry to populate */
    method static private void InitializeRegistry(input poRegistry as BuilderRegistry):
        poRegistry:Put('Set-Cookie':u, get-class(SetCookieSetHeaderFilter)).
        /* from response */
        poRegistry:Put('Transfer-Encoding':u, get-class(TransferEncodingSetHeaderFilter)).
        /* from request */
        poRegistry:Put('Accept-Encoding':u, get-class(TransferEncodingSetHeaderFilter)).
    end method.
    
    /** Returns a response writer for a given content-type.
        
        @param IHttpResponse The response being processed. 
        @return IHttpMessageWriter The message writer to use */
    method static public IHttpMessageWriter Build(input poMessage as IHttpMessage,
                                                  input poHeader as HttpHeader):
        define variable oWriter as IHttpMessageWriter no-undo.
        define variable oWriterType as class Progress.Lang.Class no-undo.
        
        Assert:NotNull(poMessage, 'Message').
        Assert:NotNull(poHeader, 'Header').
        
        assign oWriterType = SetHeaderMessageWriterBuilder:Registry:Get(poHeader:Name).
        if not valid-object(oWriterType) then
            return oWriter.
        
        /* double-check we have the correct type */
        Assert:IsType(oWriterType, get-class(IHttpMessageWriter)).
        
        oWriter = dynamic-new string(oWriterType:TypeName) (input poMessage). 
        
        if type-of(oWriter, ISupportInitialize) then
            cast(oWriter, ISupportInitialize):Initialize().
        
        return oWriter.
    end method.
    
end class.