/************************************************
Copyright (c)  2018 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : ResponseElementWriterBuilder 
    Purpose     : Builds a response element type writer 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2018-05-08
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Core.Util.BuilderRegistry.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.ISupportLogging.
using OpenEdge.Net.HTTP.ConfigBuilder.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Web.DataObject.ElementTypeEnum.
using OpenEdge.Web.DataObject.Writer.ResponseElementWriterRegistry.
using OpenEdge.Web.DataObject.Writer.ResponseElementWriter.
using OpenEdge.Web.DataObject.Writer.ResponseElementWriterBuilder.
using Progress.Lang.Object.

class OpenEdge.Web.DataObject.Writer.ResponseElementWriterBuilder inherits ConfigBuilder:
    
    /* (mandatory) The argument type to which we want to write */
    define public property ElementType as ElementTypeEnum  no-undo get. private set.
    
    /** Each concrete builder will implement this differently */
    define public property Writer as ResponseElementWriter no-undo
        get():
            return NewResponseElementWriterBuilder().
        end get. 
    
    /** Registry for mapping build types to their implementations */
    define static public property Registry as BuilderRegistry no-undo
        get():
            define variable oRegistry as BuilderRegistry no-undo.
            if not valid-object(ResponseElementWriterBuilder:Registry) then
            do:
                assign oRegistry = new BuilderRegistry(get-class(ResponseElementWriterBuilder)).
                //oRegistry:Put(get-class(ResponseElementWriterBuilder):TypeName, get-class(ResponseElementWriterBuilder)).
                assign ResponseElementWriterBuilder:Registry = oRegistry.
            end.
            return ResponseElementWriterBuilder:Registry.
        end get.
        private set.
        
    /** Returns an argument value writer for a argument type
        
        @param  OperationArgument The operation for which to build the writer
        @return ResponseElementWriterBuilder The entity writer builder to use  */
    method static public ResponseElementWriterBuilder Build(input pElemType as ElementTypeEnum):
        define variable builderType as Progress.Lang.Class no-undo.
        define variable builder as ResponseElementWriterBuilder no-undo.
        
        Assert:NotNull(pElemType, 'Element type').
        
        assign builderType = ResponseElementWriterBuilder:Registry:Get(get-class(ResponseElementWriterBuilder):TypeName).
        if valid-object(builderType) then
        do:
            Assert:IsType(builderType, get-class(ResponseElementWriterBuilder)).
            
            builder = dynamic-new string(builderType:TypeName)(pElemType).
        end.
        else
            builder = new ResponseElementWriterBuilder(pElemType).
        
        if type-of(builder, ISupportInitialize) then
            cast(builder, ISupportInitialize):Initialize().
        
        return builder.
    end method.

    /* Constructor */
    constructor public ResponseElementWriterBuilder (input pElementType as ElementTypeEnum):
        Assert:NotNull(pElementType, 'Element type').
        
        assign this-object:ElementType = pElementType.
    end method.
    
    /** Specifies the Entity object to use for the message body   
        
        @param  ByteBucket The bucket to use
        @return ResponseElementWriterBuilder The writer used */
    method public ResponseElementWriterBuilder WriteTo(input pResponse as IHttpResponse):
        Assert:NotNull(pResponse, 'Response').
        
        SetOption('resp':u, pResponse).
        
        return this-object.
    end method.
    
    /** Adds or overwrites an option for the client library.
        
        @param  character The name of the option
        @param  character The value of the option (can be anything)
        @return ResponseElementWriterBuilder This builder object. */
    method public ResponseElementWriterBuilder Logger(input poLogger as ILogWriter):
        
        Assert:NotNull(poLogger, 'Log writer').
        SetOption(get-class(ILogWriter):TypeName, poLogger).
        
        return this-object.
    end method.
    
    method protected ResponseElementWriter NewResponseElementWriterBuilder():
        define variable elemWriter as ResponseElementWriter no-undo.
        define variable elemWriterBuilder as class Progress.Lang.Class no-undo.
        
        assign elemWriterBuilder = ResponseElementWriterRegistry:Registry:Get(this-object:ElementType:ToString()).
        
        if not valid-object(elemWriterBuilder) then
            return elemWriter.
        
        /* double-check we have the correct type */
        Assert:IsType(elemWriterBuilder, get-class(ResponseElementWriter)).
        
        elemWriter= dynamic-new string(elemWriterBuilder:TypeName)().
        
        /* hook up logging */
        if     type-of(elemWriter, ISupportLogging)
           and HasOption(get-class(ILogWriter):TypeName)
        then
            assign cast(elemWriter, ISupportLogging):Logger = cast(GetOptionObjectValue(get-class(ILogWriter):TypeName), ILogWriter).
        
        if HasOption('resp':u) then
            assign elemWriter:Response = cast(GetOptionObjectValue('resp':u), IHttpResponse).
        
        if type-of(elemWriter, ISupportInitialize) then
            cast(elemWriter, ISupportInitialize):Initialize().        
        
        return elemWriter.
    end method.
    
/*****************************/
    /** Adds or overwrites an option for the client library.
        
        @param  character The name of the option
        @param  character The value of the option (can be anything)
        @return ResponseElementWriterBuilder This builder object. */
    method public ResponseElementWriterBuilder Option(input pcName as character,
                                                    input pcValue as character):
        
        Assert:NotNullOrEmpty(pcName, 'Option name').
        SetOption(pcName, pcValue).
        
        return this-object.
    end method.
    
    /** Adds or overwrites an option for the client library.
        
        @param  character The name of the option
        @param  Object The value of the option (can be anything)
        @return ResponseElementWriterBuilder This builder object. */
    method public ResponseElementWriterBuilder Option(input pcName as character,
                                                    input poValue as Object):
        
        Assert:NotNullOrEmpty(pcName, 'Option name').
        SetOption(pcName, poValue).
        
        return this-object.
    end method.                                                     

    /** Adds or overwrites an option for the client library.
        
        @param  character The name of the option
        @param  int64 The value of the option (can be anything)
        @return ResponseElementWriterBuilder This builder object. */
    method public ResponseElementWriterBuilder Option(input pcName as character,
                                                    input piValue as int64):
        Assert:NotNullOrEmpty(pcName, 'Option name').
        SetOption(pcName, piValue).

        return this-object.
    end method.                                                     

    /** Adds or overwrites an option for the client library.
        
        @param  character The name of the option
        @param  decimal The value of the option (can be anything)
        @return ResponseElementWriterBuilder This builder object. */
    method public ResponseElementWriterBuilder Option(input pcName as character,
                                                    input pdValue as decimal):
        
        Assert:NotNullOrEmpty(pcName, 'Option name').
        SetOption(pcName, pdValue).

        return this-object.
    end method.                                                     

    /** Adds or overwrites an option for the client library.
        
        @param  character The name of the option
        @param  logical The value of the option (can be anything)
        @return ResponseElementWriterBuilder This builder object. */
    method public ResponseElementWriterBuilder Option(input pcName as character,
                                                      input plValue as logical):
        
        Assert:NotNullOrEmpty(pcName, 'Option name').
        SetOption(pcName, plValue).

        return this-object.
    end method.

end class.