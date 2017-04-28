/************************************************
Copyright (c)  2016 by Progress Software Corporation. All rights reserved.
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
using OpenEdge.Core.Util.ILogWriter.
using OpenEdge.Core.Util.ISupportLogging.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriterBuilder.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriterRegistry.

class OpenEdge.Web.DataObject.Writer.DefaultArgumentValueWriterBuilder inherits ArgumentValueWriterBuilder:
    
    /** Each concrete builder will implement this differently */
    define override public property Writer as ArgumentValueWriter no-undo 
        get():
            return NewArgumentValueWriter().
        end get.
    
    /* Constructor */
    constructor public DefaultArgumentValueWriterBuilder(input poArgType as class Progress.Lang.Class):
        super(poArgType).
    end method.
    
    method private ArgumentValueWriter NewArgumentValueWriter():
        define variable oWriter as ArgumentValueWriter no-undo.
        define variable oWriterType as class Progress.Lang.Class no-undo.
        define variable oArgValue as Progress.Lang.Object no-undo.
        
        assign oWriterType = GetWriter(this-object:ArgumentType, ArgumentValueWriterRegistry:Registry).
        if not valid-object(oWriterType) then
            return oWriter.
        
        /* double-check we have the correct type */
        Assert:IsType(oWriterType, get-class(ArgumentValueWriter)).
        
        oWriter= dynamic-new string(oWriterType:TypeName) ().
        
        if HasOption('arg':u) then
            /* Direct property on LHS of assigment a no-go because of PSC00336173. We use a temp/intermediary instead */
            assign oArgValue = dynamic-cast(GetOptionObjectValue('arg':u),
                                            GetOptionStringValue('argType':u))                                          
                   oWriter:Value= oArgValue.
        
        /* hook up logging */
        if HasOption(get-class(ILogWriter):TypeName) and
           type-of(oWriter, ISupportLogging) then
            cast(GetOptionObjectValue(get-class(ILogWriter):TypeName), ILogWriter)
                    :SubscribeTo(cast(oWriter, ISupportLogging)).
   
        if type-of(oWriter, ISupportInitialize) then
            cast(oWriter, ISupportInitialize):Initialize().
            
        return oWriter.            
    end method.
        
    /** Returns a value writer from a particular registry
        
        The search alogrithm is
        1. Equality match  - identical type name
        2. IsA / Inherits match. This may be slow, so if one is found, it's registered

        @param Progress.Lang.Class The current argument type for which we are trying to find a writer
        @param BuilderRegistry The registry in which to look 
        @return Progress.Lang.Class The type of the writer. It's the caller's responsibility to invoke and use the writer */        
    method override protected class Progress.Lang.Class GetWriter(input poArgType as class Progress.Lang.Class,
                                                                  input poRegistry as BuilderRegistry):
        define variable oWriterType as Progress.Lang.Class no-undo.
        define variable oIFace as class Progress.Lang.Class extent no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable oType as class Progress.Lang.Class no-undo.
        
        Assert:NotNull(poArgType, 'Argument type').
        Assert:NotNull(poRegistry, 'Value writer registry').
        
        /* 1. Equality */
        assign oWriterType = poRegistry:Get(poArgType:TypeName).
        
        /* 2. IsA() */
        if not valid-object(oWriterType) then
        do:
            assign oType = poArgType.
            do while valid-object(oType) and not valid-object(oWriterType):
                assign extent(oIFace) = ?   
                       oIFace = oType:GetInterfaces()
                       iMax   = extent(oIFace).
                do iLoop = 1 to iMax while not valid-object(oWriterType): 
                    assign oWriterType = poRegistry:Get(oIFace[iLoop]:TypeName).
                end.
                assign oWriterType = poRegistry:Get(oType:TypeName) when not valid-object(oWriterType)
                       oType       = oType:SuperClass.
            end.
            if valid-object(oWriterType) then
                poRegistry:Put(poArgType:TypeName, oWriterType).
        end.
        
        return oWriterType.
    end method.
    
end class.