/************************************************
Copyright (c) 2016-2017 by Progress Software Corporation. All rights reserved.
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
        if type-of(oWriter, ISupportLogging) and HasOption(get-class(ILogWriter):TypeName) then
            assign cast(oWriter, ISupportLogging):Logger = cast(GetOptionObjectValue(get-class(ILogWriter):TypeName), ILogWriter).
        
        if type-of(oWriter, ISupportInitialize) then
            cast(oWriter, ISupportInitialize):Initialize().
        
        return oWriter.            
    end method.
    
end class.