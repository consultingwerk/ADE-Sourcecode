/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : HandleArrayValueWriter
    Purpose     : Writes a primitive value to a IHandleArrayHolder
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-08-01
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.IHandleArrayHolder.
using OpenEdge.Core.DataTypeEnum.
using OpenEdge.Core.DataTypeHelper.
using OpenEdge.Core.HandleArrayHolder.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Lang.AppError.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriterBuilder.
using Ccs.Common.Support.IHandleHolder.

class OpenEdge.Web.DataObject.Writer.HandleArrayValueWriter inherits ArgumentValueWriter:
    define variable moHandleWriter as ArgumentValueWriter no-undo.
    
    constructor public HandleArrayValueWriter ():
        super(get-class(IHandleArrayHolder)).
        
        assign moHandleWriter = ArgumentValueWriterBuilder:Build(get-class(IHandleHolder)):Writer.
    end constructor.
            
    method override public void Write(input pData as handle extent):
        define variable hData as handle extent no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
/****
        /* If we have handles already, use them */
        if valid-object(this-object:Value) then
        do:
            assign hData = cast(this-object:Value, IHandleArrayHolder):Value
                   iMax = extent(hData).

            do iLoop = 1 to iMax:
                moHandleWriter:Open().
                
                if valid-handle(hData[iLoop]) then
                    moHandleWriter:Write(hData[iLoop]).
                
                if valid-handle(hData[iLoop]) then
                    moHandleWriter:Write(pData[iLoop]).

                moHandleWriter:Close().
            end.
        end.
                   
                   
                   
            
            /* if the input array matches the stored array, and we're working with 
               PDS and TT then use that handle as a base schema */                   
            if extent(pData) eq iMax then
            do iLoop = 1 to iMax:
                /* If we're working on the same handle, then it's a no-op */
                if hData[iLoop] eq pData[iLoop] then
                    next.
                
                if valid-handle(hData[iLoop]) then
                case hData[iLoop]:type:
                    when DataTypeHelper:GetMask(DataTypeEnum:TempTable) then
                        hData[iLoop]:copy-temp-table(pData[iLoop]).
                    when DataTypeHelper:GetMask(DataTypeEnum:Dataset) then
                        hData[iLoop]:copy-dataset(pData[iLoop]).
                    otherwise
                    do:
                        assign extent(hData) = ?.
                        leave.
                    end.
                end case.
            end.
        end.    /* have data */
        
        if extent(hData) eq 0 then
            assign this-object:Value = new HandleArrayHolder(pData).
            
       moHandleWriter:Close().
***/       
    end method.
    
    method override public void Write(input pData as Progress.Lang.Object extent):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable hData as handle extent no-undo.
        
        assign iMax = extent(pData)                
                hData = cast(this-object:Value, IHandleArrayHolder):Value.

        do iLoop = 1 to iMax:
            moHandleWriter:Open().
            moHandleWriter:Close().
        end.
    end method.
    
    method override public void Write(input pData as Progress.Lang.Object):
        define variable oArray as JsonArray no-undo.
        define variable mArray as handle extent no-undo.
        
        case true:
            when not valid-object(pData) then
                assign this-object:Value = new HandleArrayHolder(mArray).
            
            when type-of(pData, IHandleArrayHolder) then
               this-object:Write(cast(pData, IHandleArrayHolder):Value).
            
            otherwise 
                return error new AppError(
                            substitute('Unsupported object type: &1', pData:GetClass():TypeName)
                            , 0).
        end case.
    end method.

end class.