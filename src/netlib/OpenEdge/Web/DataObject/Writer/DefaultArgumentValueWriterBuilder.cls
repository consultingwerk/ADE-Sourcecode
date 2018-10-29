/************************************************
Copyright (c) 2016-2018 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : DefaultArgumentValueWriterBuilder
    Purpose     : The default implementation of a ArgumentValueWriterBuilder
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-06-08
    Notes       : * Uses the ArgumentValueWriterRegistry to find an appropriate
                    implementation
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Core.Util.BuilderRegistry.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.ISupportLogging.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriterBuilder.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriterRegistry.
using Progress.Lang.ParameterList.
using Progress.Reflect.Constructor.

class OpenEdge.Web.DataObject.Writer.DefaultArgumentValueWriterBuilder inherits ArgumentValueWriterBuilder:
    
    /** Each concrete builder will implement this differently */
    define override public property Writer as ArgumentValueWriter no-undo 
        get():
            return NewArgumentValueWriter().
        end get.
    
    /* Constructor
       
       @param Progress.Lang.Class The argument type for this Arg Writer */
    constructor public DefaultArgumentValueWriterBuilder(input poArgType as class Progress.Lang.Class):
        super(poArgType).
    end method.
    
    /* Instantiates a new Arg Writer for the passed-in type 
       
       @return ArgumentValueWriter A new Arg Writer for the arg type */
    method private ArgumentValueWriter NewArgumentValueWriter():
        define variable oWriter as ArgumentValueWriter no-undo.
        define variable oWriterType as class Progress.Lang.Class no-undo.
        define variable oArgValue as Progress.Lang.Object no-undo.
        define variable ctor as Constructor no-undo.
        define variable paramList as ParameterList no-undo.
        define variable writerRegistry as BuilderRegistry no-undo.
        
        // Use the custom registry if one's set
        if HasOption(get-class(ArgumentValueWriterRegistry):TypeName) then
        do:
            assign writerRegistry = cast(GetOptionObjectValue(get-class(ArgumentValueWriterRegistry):TypeName), BuilderRegistry).
            if valid-object(writerRegistry) then
                assign oWriterType = GetWriter(this-object:ArgumentType, writerRegistry).
        end.
        
        // if there's nothing in the custom registry, or there's not one set, use the default
        if not valid-object(oWriterType) then
            assign oWriterType = GetWriter(this-object:ArgumentType, ArgumentValueWriterRegistry:Registry).
        if not valid-object(oWriterType) then
            return oWriter.
        
        /* double-check we have the correct type */
        Assert:IsType(oWriterType, get-class(ArgumentValueWriter)).
        
        // Some ArgValueWriters accept the Arg Type as a ctor param 
        assign paramList = new ParameterList(1).
        paramList:SetParameter(1, 'CLASS ':u + get-class(Progress.Lang.Class):TypeName, 'INPUT':u, this-object:ArgumentType).
        
        assign ctor = oWriterType:GetConstructor(paramList).
        if valid-object(ctor) then
            oWriter = cast(ctor:Invoke(paramList), ArgumentValueWriter).
        else
            oWriter = dynamic-new string(oWriterType:TypeName)().
        
        if HasOption('arg':u) then
            /* Direct property on LHS of assigment a no-go because of PSC00336173. We use a temp/intermediary instead */
            assign oArgValue     = dynamic-cast(GetOptionObjectValue('arg':u),
                                                GetOptionStringValue('argType':u))
                   oWriter:Value = oArgValue.
        
        /* hook up logging */
        if type-of(oWriter, ISupportLogging) and HasOption(get-class(ILogWriter):TypeName) then
            assign cast(oWriter, ISupportLogging):Logger = cast(GetOptionObjectValue(get-class(ILogWriter):TypeName), ILogWriter).
        
        if type-of(oWriter, ISupportInitialize) then
            cast(oWriter, ISupportInitialize):Initialize().
        
        return oWriter.
    end method.
    
end class.
