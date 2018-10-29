/************************************************
Copyright (c) 2016-2018 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : ArgumentValueWriterBuilder 
    Purpose     : Builds a argument value writer for a given type (like a ILongcharHolder)
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-06-08
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Core.Util.BuilderRegistry.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Net.HTTP.ConfigBuilder.
using OpenEdge.Web.DataObject.OperationArgument.
using OpenEdge.Web.DataObject.OperationParameter.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriterBuilder.
using OpenEdge.Web.DataObject.Writer.DefaultArgumentValueWriterBuilder.
using Progress.Lang.Object.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriterRegistry.

class OpenEdge.Web.DataObject.Writer.ArgumentValueWriterBuilder inherits ConfigBuilder
            abstract:
    
    /* (mandatory) The argument type to which we want to write */
    define public property ArgumentType as class Progress.Lang.Class no-undo get. private set.
    
    /** Each concrete builder will implement this differently */
    define abstract public property Writer as ArgumentValueWriter no-undo get. 

    /** Registry for mapping build types to their implementations */
    define static public property Registry as BuilderRegistry no-undo
        get():
            define variable oRegistry as BuilderRegistry no-undo.
            if not valid-object(ArgumentValueWriterBuilder:Registry) then
            do:
                assign oRegistry = new BuilderRegistry(get-class(ArgumentValueWriterBuilder)).
                oRegistry:Put(get-class(ArgumentValueWriterBuilder):TypeName,
                              get-class(DefaultArgumentValueWriterBuilder)).
                assign ArgumentValueWriterBuilder:Registry = oRegistry.
            end.
            return ArgumentValueWriterBuilder:Registry.
        end get.
        private set.
    
    /** Returns an argument value writer for a argument
        
        @param  OperationArgument The operation for which to build the writer
        @return ArgumentValueWriterBuilder The entity writer builder to use  */
    method static public ArgumentValueWriterBuilder Build(input poArg as OperationArgument):
        Assert:NotNull(poArg, 'Operation argument').
        
        return ArgumentValueWriterBuilder:Build(poArg:ArgumentType)
                    :FromRegistry(poArg:Service:ArgumentWriters).
    end method.
    
    /** Returns an argument value writer for a argument type.
        
        @param  P.L.Class The argument type for which to build the writer
        @return ArgumentValueWriterBuilder The entity writer builder to use  */
    method static public ArgumentValueWriterBuilder Build(input poArgType as class Progress.Lang.Class):
        return ArgumentValueWriterBuilder:Build(poArgType, ArgumentValueWriterBuilder:Registry).
    end method.
    
    /** Returns an argument value writer for a argument type
        
        @param  P.L.Class The argument type for which to build the writer
        @param  BuilderRegistry The registry from which to find the writer 
        @return ArgumentValueWriterBuilder The entity writer builder to use  */
    method static public ArgumentValueWriterBuilder Build(input pArgType as class Progress.Lang.Class,
                                                          input pRegistry as BuilderRegistry):
        define variable builderType as Progress.Lang.Class no-undo.
        define variable builder as ArgumentValueWriterBuilder no-undo.
        
        Assert:NotNull(pArgType, 'Argument type').
        Assert:NotNull(pRegistry, 'Argument writer builder registry').
        
        assign builderType = pRegistry:Get(get-class(ArgumentValueWriterBuilder):TypeName).
        Assert:IsType(builderType, get-class(ArgumentValueWriterBuilder)).
        
        builder = dynamic-new string(builderType:TypeName) (pArgType).
        
        if type-of(builder, ISupportInitialize) then
            cast(builder, ISupportInitialize):Initialize().
        
        return builder.
    end method.

    /* Constructor */
    constructor public ArgumentValueWriterBuilder (input poArgType as class Progress.Lang.Class):
        Assert:NotNull(poArgType, 'Argument type').
        assign this-object:ArgumentType = poArgType.
    end method.
    
    /** Specifies the Entity object to use for the message body   
        
        @param  Progress.Lang.Object The argument value into which to write
        @param  Progress.Lang.Class The type of the argument (actual type or maybe interface)        
        @return ArgumentValueWriterBuilder The writer used */
    method public ArgumentValueWriterBuilder WriteTo(input pArgValue as Object,
                                                     input pArgType as class Progress.Lang.Class):
        if not valid-object(pArgValue)
           or  not valid-object(pArgType)
        then
            return this-object.
        
        SetOption('arg':u,     pArgValue).
        SetOption('argType':u, pArgType:TypeName).
        
        return this-object.
    end method.
    
    /** Specifies the Entity object to use for the message body   
        
        @param  Progress.Lang.Object The argument value into which to write
        @return ArgumentValueWriterBuilder The writer used */
    method public ArgumentValueWriterBuilder WriteTo(input poValue as Object):
        if not valid-object(poValue) then
            return this-object.
        
        return WriteTo(poValue, poValue:GetClass()).
    end method.
    
    /** Adds or overwrites an option for the client library.
        
        @param  character The name of the option
        @param  character The value of the option (can be anything)
        @return ArgumentValueWriterBuilder This builder object. */
    method public ArgumentValueWriterBuilder Option(input pcName as character,
                                                    input pcValue as character):
        
        Assert:NotNullOrEmpty(pcName, 'Option name').
        SetOption(pcName, pcValue).
        
        return this-object.
    end method.
    
    /** Adds or overwrites an option for the client library.
        
        @param  character The name of the option
        @param  character The value of the option (can be anything)
        @return ArgumentValueWriterBuilder This builder object. */
    method public ArgumentValueWriterBuilder Logger(input poLogger as ILogWriter):
        
        Assert:NotNull(poLogger, 'Log writer').
        SetOption(get-class(ILogWriter):TypeName, poLogger).
        
        return this-object.
    end method.                                                     

    /** Adds or overwrites an option for the client library.
        
        @param  character The name of the option
        @param  Object The value of the option (can be anything)
        @return ArgumentValueWriterBuilder This builder object. */
    method public ArgumentValueWriterBuilder Option(input pcName as character,
                                                    input poValue as Object):
        
        Assert:NotNullOrEmpty(pcName, 'Option name').
        SetOption(pcName, poValue).
        
        return this-object.
    end method.                                                     
    
    /** Adds or overwrites an option for the client library.
        
        @param  character The name of the option
        @param  int64 The value of the option (can be anything)
        @return ArgumentValueWriterBuilder This builder object. */
    method public ArgumentValueWriterBuilder Option(input pcName as character,
                                                    input piValue as int64):
        Assert:NotNullOrEmpty(pcName, 'Option name').
        SetOption(pcName, piValue).
    
        return this-object.
    end method.                                                     
    
    /** Adds or overwrites an option for the client library.
        
        @param  character The name of the option
        @param  decimal The value of the option (can be anything)
        @return ArgumentValueWriterBuilder This builder object. */
    method public ArgumentValueWriterBuilder Option(input pcName as character,
                                                    input pdValue as decimal):
        
        Assert:NotNullOrEmpty(pcName, 'Option name').
        SetOption(pcName, pdValue).
    
        return this-object.
    end method.                                                     
        
    /** Adds or overwrites an option for the client library.
        
        @param  character The name of the option
        @param  logical The value of the option (can be anything)
        @return ArgumentValueWriterBuilder This builder object. */
    method public ArgumentValueWriterBuilder Option(input pcName as character,
                                                    input plValue as logical):
        Assert:NotNullOrEmpty(pcName, 'Option name').
        SetOption(pcName, plValue).
        
        return this-object.
    end method.
    
    /** Adds a custom/service-level registry for ArgumentValueWriters
        
        @param  BuilderRegistry The registry
        @return ArgumentValueWriterBuilder This builder object. */
    method public ArgumentValueWriterBuilder FromRegistry(input pValue as BuilderRegistry):
        Assert:NotNull(pValue, 'Writer Registry').
        Assert:IsType(pValue:ValueType, get-class(ArgumentValueWriter)).
        
        SetOption(get-class(ArgumentValueWriterRegistry), pValue).
        
        return this-object.
    end method.
    
    /** Returns a value writer from a particular registry
        
        The search alogrithm is
        0. Empty registry returns nothing
        1. Equality match  - identical type name
        2. IsA / Inherits match. This may be slow, so if one is found, it's registered
        
        @param Progress.Lang.Class The current argument type for which we are trying to find a writer
        @param BuilderRegistry The registry in which to look 
        @return Progress.Lang.Class The type of the writer. It's the caller's responsibility to invoke and use the writer */
    method protected class Progress.Lang.Class GetWriter(input poArgType as class Progress.Lang.Class,
                                                         input poRegistry as BuilderRegistry):
        define variable writerType as Progress.Lang.Class no-undo.
        define variable ifaceType as class Progress.Lang.Class extent no-undo.
        define variable cnt as integer no-undo.
        define variable loopMax as integer no-undo.
        define variable currentType as class Progress.Lang.Class no-undo.
        
        Assert:NotNull(poArgType, 'Argument type').
        Assert:NotNull(poRegistry, 'Value writer registry').
        
        /* 0. Empty */
        if poRegistry:Size eq 0 then
            return writerType.
        
        /* 1. Equality */
        assign writerType = poRegistry:Get(poArgType:TypeName).
        
        /* 2. IsA() */
        if not valid-object(writerType) then
        do:
            assign currentType = poArgType.
            do while valid-object(currentType) and not valid-object(writerType):
                assign extent(ifaceType) = ?   
                       ifaceType = currentType:GetInterfaces()
                       loopMax   = extent(ifaceType).
                do cnt = 1 to loopMax while not valid-object(writerType): 
                    assign writerType = poRegistry:Get(ifaceType[cnt]:TypeName).
                end.
                assign writerType  = poRegistry:Get(currentType:TypeName) when not valid-object(writerType)
                       currentType = currentType:SuperClass.
            end.
            if valid-object(writerType) then
                poRegistry:Put(poArgType:TypeName, writerType).
        end.
        
        return writerType.
    end method.
    
end class.