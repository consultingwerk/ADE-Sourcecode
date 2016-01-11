/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
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

class OpenEdge.Net.HTTP.Filter.Writer.RequestWriterBuilder inherits ConfigBuilder:
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
                assign oRegistry = new BuilderRegistry(get-class(DefaultRequestFilter)).
                RequestWriterBuilder:InitializeRegistry(oRegistry).                
                assign RequestWriterBuilder:Registry = oRegistry.
            end.
            return RequestWriterBuilder:Registry.
        end get.
        private set.
    
    /** Adds initial values into the registry 
    
        @param BuilderRegistry The registry to populate */
    method static private void InitializeRegistry(input poRegistry as BuilderRegistry):
        poRegistry:Put(get-class(IHttpRequest):TypeName, get-class(DefaultRequestFilter)).
    end method.
    
    /** Returns a request writer for a given entity type.
        
        @return RequestWriterBuilder The  writer to use */
    method static public RequestWriterBuilder Build():
        return new RequestWriterBuilder().
    end method.
    
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
    
    method private MessageWriter NewRequestWriter():
        define variable oWriter as MessageWriter no-undo.
        define variable oWriterType as class Progress.Lang.Class no-undo.
        
        assign oWriterType = RequestWriterBuilder:Registry:Get(get-class(IHttpRequest):TypeName).
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
     
end class.