/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : JsonValueWriter
    Purpose     : Writes values to a JSON construct (object or array)
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-06-08
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.Collections.IMap.
using OpenEdge.Core.Collections.IStringKeyedMap.
using OpenEdge.Core.Collections.IStringStringMap.
using OpenEdge.Core.DataTypeEnum.
using OpenEdge.Core.DataTypeHelper.
using OpenEdge.Core.Memptr.
using OpenEdge.Core.String.
using OpenEdge.Core.WidgetHandle.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Lang.AppError.
using Progress.Lang.Error.
using Progress.Lang.Object.

class OpenEdge.Web.DataObject.Writer.JsonValueWriter inherits ArgumentValueWriter:
    define private variable moParser as ObjectModelParser no-undo.
    
    constructor public JsonValueWriter():
        super(get-class(JsonConstruct)).
    end constructor. 

    method override public void Open():    
        super:Open().
         
        assign moParser = new ObjectModelParser().
    end method.
    
    method override public void Close():
        super:Close().
        
        assign moParser = ?.
    end method.
    
    method override public void Write(input poData as Object):
        define variable oBody as class Memptr no-undo.
        
        Assert:NotNull(poData).
        
        case true:
            when type-of(poData, Memptr) then
                assign oBody = cast(poData, Memptr).
            
            when type-of(poData, ByteBucket) then
                assign oBody = cast(poData, ByteBucket):GetBytes().
            
            when type-of(poData, String) then
            do:
                this-object:Write(cast(poData, String):Value).
                return.
            end.

            when type-of(poData, WidgetHandle) then
            do:
                this-object:Write(cast(poData, WidgetHandle):Value).
                return.
            end.
            
            otherwise 
                return error new AppError(
                            substitute('Unsupported object type: &1', poData:GetClass():TypeName)
                            , 0).
        end case.
        
        if oBody:Size eq 0 then
            assign this-object:Value = new JsonObject().
        else
            assign this-object:Value = cast(moParser:Parse(oBody:Value) , JsonConstruct).
    end method.

    method override public void Write(input pcData as longchar):
        define variable iBytesWritten as int64 no-undo.
        
        assign iBytesWritten = length(pcData, 'raw':u).
        
        Assert:IsZeroOrPositive(iBytesWritten, 'Data').

        if iBytesWritten eq 0 then
            assign this-object:Value = new JsonObject().
        else
            assign this-object:Value = cast(moParser:Parse(pcData), JsonConstruct).
    end method.

    method override public void Write( input pmData as memptr):
        define variable iBytesWritten as int64 no-undo.
        
        assign iBytesWritten = get-size(pmData).
        Assert:IsZeroOrPositive(iBytesWritten, 'Data size').
        
        if iBytesWritten eq 0 then
            assign this-object:Value = new JsonObject().
        else
           assign this-object:Value = cast(moParser:Parse(pmData), JsonConstruct).
    end method.
    
    /** Write data to/from the message

        @param handle Data to write */
    method public void WriteHandle(input phData as handle):
        this-object:Write(phData).
    end method.
    
    /** Write data to/from the message

        @param handle Data to write */
    method override public void Write(input phData as handle):
        define variable lOk as logical no-undo.
        define variable oData as JsonObject no-undo.
        
        Assert:NotNull(phData, 'Data').
        
        case phData:type:
            when DataTypeHelper:GetMask(DataTypeEnum:Buffer) or
            when DataTypeHelper:GetMask(DataTypeEnum:TempTable) or
            when DataTypeHelper:GetMask(DataTypeEnum:Dataset) then
                assign oData = new JsonObject()
                       this-object:Value = oData
                       lOk = oData:Read(phData)
                       .
                       
            /* this should cater for WEB-CONTEXT and that only. */
            when 'pseudo-widget':u then            
                if lookup('HTML-CHARSET':u, list-query-attrs(phData)) gt 0 then
                    assign this-object:Value = cast(moParser:Parse(phData), JsonConstruct).
        end case.
    end method.

    /** Write data to/from the message

        @param character Data to write */
    method override public void Write(input pcData as character):
        define variable iBytesWritten as integer no-undo.
        
        assign iBytesWritten = length(pcData, 'raw':u).
        
        Assert:IsZeroOrPositive(iBytesWritten, 'Data').

        if iBytesWritten eq 0 then
            assign this-object:Value = new JsonObject().
        else
            assign this-object:Value = cast(moParser:Parse(pcData), JsonConstruct).
    end method.
    
end class.