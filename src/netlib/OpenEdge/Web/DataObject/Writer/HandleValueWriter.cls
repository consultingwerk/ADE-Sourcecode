/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : HandleValueWriter
    Purpose     : Writes a primitive value to a IHandleHolder
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-06-08
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.IDecimalHolder.
using Ccs.Common.Support.IHandleHolder.
using Ccs.Common.Support.IInt64Holder.
using Ccs.Common.Support.ILongcharHolder.
using Ccs.Common.Support.IPrimitiveHolder.
using OpenEdge.Core.DataTypeEnum.
using OpenEdge.Core.DataTypeHelper.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.AppError.

class OpenEdge.Web.DataObject.Writer.HandleValueWriter inherits ArgumentValueWriter:
    
    constructor public HandleValueWriter ():
        super(get-class(IHandleHolder)).
    end constructor. 
    
    method override public void Write( input pData as character):
        
        assign this-object:Value = new OpenEdge.Core.WidgetHandle(handle(pData)).
    end method.

    method override public void Write(input pData as longchar):
        this-object:Write(string(pData)).
    end method.
    
    method override public void Write(input pData as handle):
        define variable hData as handle no-undo.
        
        /* If we have a handle already, use that. */
        if valid-object(this-object:Value) then
        do:
            assign hData = cast(this-object:Value, IHandleHolder):Value.
            
            /* If we're working on the same handle, then it's a no-op */
            if hData eq pData then
                return.
            
            /* Use loose-copy-mode=true in case we've passed in data that doesn't quite match (missing fields from a client etc) */
            if valid-handle(hData) then
            case hData:type:
                when DataTypeHelper:GetMask(DataTypeEnum:TempTable) then
                    hData:copy-temp-table(pData, ?, ?, true).       // loose-copy-mode 
                when DataTypeHelper:GetMask(DataTypeEnum:Dataset) then
                    hData:copy-dataset(pData, ?, ?, true).          // loose-copy-mode
                otherwise
                    assign hData = ?.
            end case.
        end.    /* have data */
        
        if not valid-handle(hData) then
            assign this-object:Value = new OpenEdge.Core.WidgetHandle(pData).
    end method.
    
    method override public void Write( input pData as decimal):
        this-object:Write(integer(pData)).
    end method.

    method override public void Write( input pData as int64):
        this-object:Write(integer(pData)).
    end method.

    method override public void Write( input pData as integer):
        this-object:Write(string(pData)).
    end method.
    
    method override public void Write(input pData as Progress.Lang.Object):
        define variable hData as handle no-undo.
        define variable lDestroy as logical no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable oReadError as AppError no-undo.
        
        if valid-object(pData) then
            Logger:Trace(substitute('Writing &1 as handle; val=&2', pData:GetClass():TypeName, pData:ToString())).
        
        case true:
            when not valid-object(pData) then
                assign this-object:Value = new OpenEdge.Core.WidgetHandle(?).
            
            when type-of(pData, JsonConstruct) then
            do:
                /* If we have a handle already, use that. */
                if valid-object(this-object:Value) then    
                do:
                    assign hData    = cast(this-object:Value, IHandleHolder):Value
                           lDestroy = false.
                    case hData:type:
                        when DataTypeHelper:GetMask(DataTypeEnum:TempTable) or
                        when DataTypeHelper:GetMask(DataTypeEnum:Buffer) or
                        when DataTypeHelper:GetMask(DataTypeEnum:Dataset) then
                            Logger:Trace(substitute('Using existing &1 &2', hData:type, hData:name)).
                        otherwise
                            assign hData    = ?
                                   lDestroy = true.
                    end case.
                end.
                else
                    assign lDestroy = true.
                
                // we always use a dataset 'cos temp-tables cannot infer
                if not valid-handle(hData) then
                    create dataset hData.
                
                do on error undo, throw:
                    if type-of(pData, JsonArray) then
                        hData:read-json('JsonArray':u, cast(pData, JsonArray)).
                    else
                    if type-of(pData, JsonObject) then                
                        /* JsonObject data can be read into a table or dataset. Try a dataset, since we don't really know the 
                           name of the tables. If it fails, throw an error. */
                        hData:read-json('JsonObject':u, cast(pData, JsonObject)).
                    
                    catch oError as Progress.Lang.Error :
                        assign oReadError = new AppError(substitute('Unable to READ-JSON into &1 "&2"',
                                                            hData:type,
                                                            hData:name),
                                                         0)
                               iMax = oError:NumMessages
                               .
                        do iLoop = 1 to iMax:
                            oREadError:AddMessage(oError:GetMessage(iLoop), oError:GetMessageNum(iLoop)).
                        end.
                        undo, throw oReadError.    
                    end catch.
                end.
                
                /* Auto-destroy this dataset/temp-table if we built it here. If it was passed in, then not */
                this-object:Write(new OpenEdge.Core.WidgetHandle(hData, lDestroy)).
            end.    /* JSON */
            
            when type-of(pData, IHandleHolder) then
                this-object:Write(cast(pData, IHandleHolder):Value).
            
            when type-of(pData, ILongcharHolder) then
               this-object:Write(cast(pData, ILongcharHolder):Value).

            when type-of(pData, IDecimalHolder) then
               this-object:Write(cast(pData, IDecimalHolder):Value).

            when type-of(pData, IInt64Holder) then
               this-object:Write(cast(pData, IInt64Holder):Value).
            
            /* Data types such as RAW, MEMPTR, LVARBINARY, and so on return the 
               Unknown value (?), but this is not considered an error. */
            when type-of(pData, IPrimitiveHolder) then
                assign this-object:Value = new OpenEdge.Core.WidgetHandle(?).
            
            otherwise 
                return error new AppError(
                            substitute('Unsupported object type: &1', pData:GetClass():TypeName)
                            , 0).
        end case.
    end method.

end class.