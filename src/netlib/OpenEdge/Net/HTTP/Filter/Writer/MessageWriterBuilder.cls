/************************************************
Copyright (c) 2015, 2017 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : MessageWriterBuilder
    Purpose     : Builds a request writer for a given type of entity
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jan 29 09:30:28 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Net.HTTP.BuilderRegistry.
using OpenEdge.Net.HTTP.ConfigBuilder.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using OpenEdge.Net.HTTP.Filter.Writer.DefaultMessageWriterBuilder.
using OpenEdge.Net.HTTP.Filter.Writer.MessageWriterBuilder.
using OpenEdge.Net.HTTP.Filter.Writer.VoidMessageWriterBuilder.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.IHttpMessage.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Writer.MessageWriterBuilder inherits ConfigBuilder
            abstract:
    
    /** (mandatory) The content type that this builder is for */
    define protected property ContentType as character no-undo get. private set.
    
    /** (mandatory) The registry used by the message writer to get the actual writer for a (say) content type.
        Passed in from a Build() method */
    define protected property WriterRegistry as BuilderRegistry no-undo get. private set.
    
    /** Each concrete builder will implement this differently */
    define abstract public property Writer as MessageWriter no-undo get. 
    
    /** Registry for mapping build types to their implementations */
    define static public property Registry as BuilderRegistry no-undo
        get():
            define variable oRegistry as BuilderRegistry no-undo.
            if not valid-object(MessageWriterBuilder:Registry) then
            do:
                assign oRegistry = new BuilderRegistry(get-class(MessageWriterBuilder)).
                oRegistry:Put(get-class(MessageWriterBuilder):TypeName,
                              get-class(DefaultMessageWriterBuilder)).
                
                assign MessageWriterBuilder:Registry = oRegistry.
            end.
            return MessageWriterBuilder:Registry.
        end get.
        private set.
        
    /** Returns an entity writer for a message
        
        @param  IHttpMessage The message being processed
        @param  BuilderRegistry The registry that contains the mappings between content types and writers
        @return MessageWriterBuilder The entity writer builder to use */
    method static public MessageWriterBuilder Build(input poMessage as IHttpMessage,
                                                    input poRegistry as BuilderRegistry):
        define variable oHeader as HttpHeader no-undo.
        
        assign oHeader = poMessage:GetHeader('Content-Type':u).
        return MessageWriterBuilder
                            :Build(poMessage:ContentType, poRegistry)
                            :Option('encodedAs':u, oHeader:GetParameterValue('charset':u))
                            :Option('multipartBoundary':u, oHeader:GetParameterValue('boundary':u)).
    end method.
    
    /** Returns an entity writer for a content type
        
        @param  character The content type being processed. 
        @param  BuilderRegistry The registry that contains the mappings between content types and writers
        @return MessageWriterBuilder The entity writer to use */
    method static public MessageWriterBuilder Build(input pcContentType as character,
                                                    input poRegistry as BuilderRegistry):
        define variable oBuilderType as Progress.Lang.Class no-undo.
        define variable oBuilder as MessageWriterBuilder no-undo.
        
        Assert:NotNull(pcContentType, 'Content type').
        Assert:NotNull(poRegistry, 'Writer registry').
        
        assign oBuilderType = MessageWriterBuilder:Registry:Get(get-class(MessageWriterBuilder):TypeName).
        if not valid-object(oBuilderType) then
            assign oBuilderType = get-class(VoidMessageWriterBuilder). 
        
        Assert:IsType(oBuilderType, get-class(MessageWriterBuilder)).

        oBuilder = dynamic-new string(oBuilderType:TypeName) (pcContentType, poRegistry).
        
        if type-of(oBuilder, ISupportInitialize) then
            cast(oBuilder, ISupportInitialize):Initialize().
        
        return oBuilder.
    end method.
    
    /** Constructor
        
        @param character    The content type used by this registry
        @param BuilderRegistry The registry used */
    constructor public MessageWriterBuilder(input pcContentType as character, 
                                            input poRegistry as BuilderRegistry):
        Assert:NotNull(pcContentType, 'Content type').
        Assert:NotNull(poRegistry, 'Writer registry').
        
        assign this-object:ContentType    = pcContentType
               this-object:WriterRegistry = poRegistry.
    end method.
    
    /** Specifies the Entity object to use for the message body   
        
        @param  ByteBucket The bucket to use
        @return MessageWriterBuilder The writer used */
    method public MessageWriterBuilder WriteTo(input poEntity as Object):
        Assert:NotNull(poEntity, 'Message Body').
        
        SetOption('entity':u,     poEntity).
        SetOption('entityType':u, poEntity:GetClass():TypeName).
    
        return this-object.
    end method.

    /** Adds or overwrites an option for the client library.
        
        @param  character The name of the option
        @param  character The value of the option (can be anything)
        @return MessageWriterBuilder This builder object. */
    method public MessageWriterBuilder Option(input pcName as character,
                                                      input pcValue as character):
        
        Assert:NotNullOrEmpty(pcName, 'Option name').
        SetOption(pcName, pcValue).
        
        return this-object.
    end method.                                                     

    /** Adds or overwrites an option for the client library.
        
        @param  character The name of the option
        @param  Object The value of the option (can be anything)
        @return MessageWriterBuilder This builder object. */
    method public MessageWriterBuilder Option(input pcName as character,
                                                      input poValue as Object):
        
        Assert:NotNullOrEmpty(pcName, 'Option name').
        SetOption(pcName, poValue).
        
        return this-object.
    end method.                                                     

    /** Adds or overwrites an option for the client library.
        
        @param  character The name of the option
        @param  int64 The value of the option (can be anything)
        @return MessageWriterBuilder This builder object. */
    method public MessageWriterBuilder Option(input pcName as character,
                                                      input piValue as int64):
        Assert:NotNullOrEmpty(pcName, 'Option name').
        SetOption(pcName, piValue).

        return this-object.
    end method.                                                     

    /** Adds or overwrites an option for the client library.
        
        @param  character The name of the option
        @param  decimal The value of the option (can be anything)
        @return MessageWriterBuilder This builder object. */
    method public MessageWriterBuilder Option(input pcName as character,
                                                      input pdValue as decimal):
        
        Assert:NotNullOrEmpty(pcName, 'Option name').
        SetOption(pcName, pdValue).

        return this-object.
    end method.                                                     

    /** Adds or overwrites an option for the client library.
        
        @param  character The name of the option
        @param  logical The value of the option (can be anything)
        @return MessageWriterBuilder This builder object. */
    method public MessageWriterBuilder Option(input pcName as character,
                                                      input plValue as logical):
        
        Assert:NotNullOrEmpty(pcName, 'Option name').
        SetOption(pcName, plValue).

        return this-object.
    end method.
    
    /** Returns a content type writer.
        
        The search alogrithm is
        1. Exact match  - type / sub-type
        2. Vendor types - type / vendor-prefix-removed-sub-type 
           Suffixes     - type / suffix
        3. General type - type / *
        4. Fallback to HTTP default - application/octet-stream
        
        @param character The name of the content type to register
        @return logical True if the content type was previously registered */
    method protected class Progress.Lang.Class GetWriter(input pcContentType as character):
        define variable oWriter as Progress.Lang.Class no-undo.
        define variable cSubType as character no-undo.
        define variable cType as character no-undo.
        define variable iPos as integer no-undo.
        
        Assert:NotNull(pcContentType, 'Content type').
        
        /* no content type, no handler */
        if pcContentType eq '':u then
            return ?.
        
        /* content types are of the form
            type / sub-type ; parameter 
            
            We only care about the type + subtype */        
        assign pcContentType = trim(entry(1, pcContentType, ';':u)).
        
        /* 1. Exact match */
        assign oWriter = this-object:WriterRegistry:Get(pcContentType).
        if valid-object(oWriter) then
            return oWriter.
        
        /* 2. Suffixed types, may include vendor and personal types
              Vendor types application/vnd.progress+json */
        assign cType    = trim(entry(1, pcContentType, '/':u))
               cSubType = trim(entry(2, pcContentType, '/':u))
               // is there a suffix  like +xml or +json ?
               iPos     = r-index(cSubType, '+':u)
               .
        // if iPos = 0 then we're doing the same as 1 above
        if iPos gt 0 then
            assign oWriter  = this-object:WriterRegistry:Get(cType + '/':u + substring(cSubType, iPos + 1)).
        if valid-object(oWriter) then
            return oWriter.
        
        /* 3. General type */
        assign oWriter = this-object:WriterRegistry:Get(cType + '/*':u).
        if valid-object(oWriter) then
            return oWriter.
        
        /* 4. Fallback to HTTP default */
        return this-object:WriterRegistry:Get('application/octet-stream':u).
    end method.
    
end class.