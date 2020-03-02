/* *************************************************************************************************************************
Copyright (c) 2016-2017, 2019 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
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
using OpenEdge.Core.ReadModeEnum.
using OpenEdge.Logging.Logger.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.AppError.
using Progress.Lang.SysError.

class OpenEdge.Web.DataObject.Writer.HandleValueWriter inherits ArgumentValueWriter:
    
    constructor public HandleValueWriter ():
        super(get-class(IHandleHolder)).
    end constructor. 
    
    method override public void Write( input pData as character):
        
        assign this-object:Value = new OpenEdge.Core.WidgetHandle(handle(pData)).
    end method.
    
    /** Clears or empties the target */
    method override public void Clear():
        define variable hData as handle no-undo.
        
        /* If we have a handle already, use that. */
        if valid-object(this-object:Value) then
        do:
            assign hData = cast(this-object:Value, IHandleHolder):Value.
            if valid-handle(hData) then
            do on error undo, throw:
                case hData:type:
                    when string(DataTypeEnum:Buffer) or
                    when string(DataTypeEnum:TempTable) then
                        hData:empty-temp-table().
                    
                    when string(DataTypeEnum:Dataset) then
                        hData:empty-dataset().
                end case.
                
                catch eSysError as SysError:
                    case eSysError:GetMessageNum(1):
                        // 12758=You may not EMPTY temp-table <table-name> when TRACKING-CHANGES is true.
                        // We want to ignore the failure in this case, and simply report that it failed
                        when 12758 then
                            Logger:Warn(substitute('Unable to clear &1 "&2": &3',
                                          hData:type, hData:name, eSysError:GetMessage(1))).
                        otherwise
                            undo, throw eSysError.
                    end case.
                end catch.
            end.
        end.
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
                when string(DataTypeEnum:TempTable) then
                    hData:copy-temp-table(pData, ?, ?, true).       // loose-copy-mode 
                when string(DataTypeEnum:Dataset) then
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
                        when string(DataTypeEnum:TempTable) or
                        when string(DataTypeEnum:Buffer) or
                        when string(DataTypeEnum:Dataset) then
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
                        // use EMPTY read-mode in case there are index conflicts in the input data
                        hData:read-json('JsonArray':u, cast(pData, JsonArray), ReadModeEnum:Empty:ToString()).
                    else
                    if type-of(pData, JsonObject) then
                        /* JsonObject data can be read into a table or dataset. Try a dataset, since we don't really know the 
                           name of the tables. If it fails, throw an error. 
                           
                           Use EMPTY read-mode in case there are index conflicts in the input data */
                        hData:read-json('JsonObject':u, cast(pData, JsonObject), ReadModeEnum:Empty:ToString()).
                    
                    catch oError as Progress.Lang.Error :
                        assign oReadError = new AppError(substitute('Unable to READ-JSON into &1 "&2"',
                                                            hData:type,
                                                            hData:name),
                                                         0)
                               iMax = oError:NumMessages
                               .
                        do iLoop = 1 to iMax:
                            oReadError:AddMessage(oError:GetMessage(iLoop), oError:GetMessageNum(iLoop)).
                        end.
                        undo, throw oReadError.    
                    end catch.
                end.
                
                /* Auto-destroy this dataset/temp-table if we built it here. If it was passed in, then not */
                assign this-object:Value = new OpenEdge.Core.WidgetHandle(hData, lDestroy).
            end.    /* JSON */
            
            when type-of(pData, IHandleHolder) then
                // Use the input value as-is; no need to create a new object
                assign this-object:Value = cast(pData, IHandleHolder).
            
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