/************************************************
Copyright (c)  2015, 2018-2019 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : RequestWriterBuilder
    Purpose     : Builds a request writer for a given type of entity
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jan 29 09:30:28 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Net.HTTP.BuilderRegistry.
using OpenEdge.Net.HTTP.ConfigBuilder.
using OpenEdge.Net.HTTP.Filter.Payload.DefaultRequestFilter.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using OpenEdge.Net.HTTP.Filter.Writer.RequestWriterBuilder.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.Filter.Payload.ConnectRequestFilter.

class OpenEdge.Net.HTTP.Filter.Writer.RequestWriterBuilder inherits ConfigBuilder:
    /* The type of request being built. */
    define public property Request as IHttpRequest no-undo
        get.
        private set.
    
    define public property Writer as MessageWriter no-undo 
        get():
            return NewRequestWriter().
        end get.
    
    /** Registry for mapping build types to their implementations */
    define static public property Registry as BuilderRegistry no-undo
        get():
            define variable oRegistry as BuilderRegistry no-undo.
            if not valid-object(RequestWriterBuilder:Registry) then
            do:
                assign oRegistry = new BuilderRegistry(get-class(MessageWriter)).
                RequestWriterBuilder:InitializeRegistry(oRegistry).
                assign RequestWriterBuilder:Registry = oRegistry.
            end.
            return RequestWriterBuilder:Registry.
        end get.
        private set.
    
    /** Adds initial values into the registry 
    
        @param BuilderRegistry The registry to populate */
    method static private void InitializeRegistry(input poRegistry as BuilderRegistry):
        poRegistry:Put('HTTP/1.1':u,         get-class(DefaultRequestFilter)).
        poRegistry:Put('HTTP/1.1+CONNECT':u, get-class(ConnectRequestFilter)).
    end method.
    
    /** Returns a request writer for a given request.
        
        @param IHttpRequest The request for which to build a writer 
        @return RequestWriterBuilder The  writer to use */
    method static public RequestWriterBuilder Build(input pRequest as IHttpRequest):
        return new RequestWriterBuilder(pRequest).
    end method.
    
    /** Returns a request writer for a given request.
        
        @return RequestWriterBuilder The  writer to use */
    method static public RequestWriterBuilder Build():
        return new RequestWriterBuilder(?).
    end method.
    
    /* Default constructor */
    constructor public RequestWriterBuilder ():
        super().
    end constructor.
    
    /* Constructor.
       
       @param IHttpRequest */
    constructor public RequestWriterBuilder (input pRequest as IHttpRequest):
        super().
        
        assign this-object:Request = pRequest.
    end constructor.
    
    /** Adds a message to the writer (for any extra context).   
        
        @param  IHttpRequest The message
        @return RequestWriterBuilder The writer used */
    method public RequestWriterBuilder Request(input poMessage as IHttpRequest):
        Assert:NotNull(poMessage, 'HTTP Message').
        SetOption(get-class(IHttpRequest):TypeName, poMessage).
        
        return this-object.
    end method.    
    
    /** Specifies the ByteBucket to use for the message body   
        
        @param  ByteBucket The bucket to use
        @return RequestWriterBuilder The writer used */
    method public RequestWriterBuilder WriteTo(input poMessageBody as ByteBucket):
        Assert:NotNull(poMessageBody, 'Message Body').
        
        SetOption(get-class(ByteBucket):TypeName, poMessageBody).
        return this-object.
    end method.    
    
    method protected MessageWriter NewRequestWriter():
        define variable oWriter as MessageWriter no-undo.
        define variable oWriterType as class Progress.Lang.Class no-undo.
        
        assign oWriterType = GetWriter(this-object:Request, RequestWriterBuilder:Registry).
        if not valid-object(oWriterType) then
            return oWriter.
        
        /* double-check we have the correct type */
        Assert:IsType(oWriterType, get-class(MessageWriter)).
        
        oWriter= dynamic-new string(oWriterType:TypeName) ().
        
        if HasOption(get-class(ByteBucket):TypeName) then
            oWriter:Entity = cast(GetOptionObjectValue(get-class(ByteBucket):TypeName), ByteBucket).
        else
            oWriter:Entity = ByteBucket:Instance(). 
        
        if type-of(oWriter, ISupportInitialize) then
            cast(oWriter, ISupportInitialize):Initialize().
        
        return oWriter.
    end method.
    
    /** Returns a request writer from a particular registry
        
        The search alogrithm is
        1. A writer for the HTTP Version+METHOD
        2. A writer for the HTTP version
        3. The writer for HTTP/1.1 . We use HTTP/1.1 as a defautl because it's pretty pervasive
        
        @param IHttpRequest The request for which we are seeking a writer
        @param BuilderRegistry The registry in which to look 
        @return Progress.Lang.Class The type of the writer. It's the caller's responsibility to 
                                    invoke and use the writer */
    method protected class Progress.Lang.Class GetWriter(input pRequest as IHttpRequest,
                                                         input pRegistry as BuilderRegistry):
        define variable writerType as Progress.Lang.Class no-undo.
        
        Assert:NotNull(pRegistry, 'Request writer registry').
        
        if not valid-object(pRequest) then
            assign writerType = pRegistry:Get('HTTP/1.1':u).
        
        if not valid-object(writerType) then
            // 1. A writer for the HTTP VERSION+METHOD
            assign writerType = pRegistry:Get(substitute('&1+&2':u, pRequest:Version, pRequest:Method)).
        
        // 2. A writer for the HTTP VERSION (version-default)
        if not valid-object(writerType) then
            assign writerType = pRegistry:Get(pRequest:Version).
        
        // 3. Default to HTTP/1.1
        if not valid-object(writerType) then
            assign writerType = pRegistry:Get('HTTP/1.1':u).
        
        return writerType.
    end method.
end class.