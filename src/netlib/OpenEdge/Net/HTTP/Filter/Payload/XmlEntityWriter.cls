/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : XmlEntityWriter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jan 29 10:47:13 EST 2015
    Notes       : - Write() operations are destructive (they replace the existing
                    Entity).
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.DataTypeEnum.
using OpenEdge.Core.Memptr.
using OpenEdge.Core.WidgetHandle.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Payload.XmlEntityWriter inherits MessageWriter: 
    constructor public XmlEntityWriter():
        super(get-class(WidgetHandle)).
    end constructor.

    method override public int64 Write(input poData as Object):
        define variable hDocument as handle no-undo.
        define variable oData as class Memptr no-undo.
        
        if not type-of(poData, Memptr) and 
           not type-of(poData, ByteBucket) then
            return error new AppError(
                            substitute('Unsupported object type: &1', poData:GetClass():TypeName)
                            , 0).
                
        assign oData = dynamic-invoke(poData, 'GetBytes':u).
        
        create x-document hDocument.
        assign hDocument:strict-entity-resolution = false.
        
        if oData:Size eq 0 then
            LogMessage(substitute('Zero-length data received in object &1', substring(poData:ToString(), 1, 50)), 5).
        else
            hDocument:load('memptr':u, oData:Value, false).
        
        assign this-object:Entity = new WidgetHandle(hDocument).
        
        return oData:Size.
    end method.
    
    method override public int64 Write(input pcData as longchar):
        define variable hDocument as handle no-undo.
        define variable iSize as int64 no-undo.
                
        Assert:NotNull(pcData, 'Data').
        
        assign iSize = length(pcData, 'raw':u). 
        
        create x-document hDocument.
        if iSize eq 0 then
            LogMessage('Zero-length data received in longchar', 5).
        else
            hDocument:load('longchar':u, pcData, false).
        
        assign this-object:Entity = new WidgetHandle(hDocument).
        
        return iSize.
    end method.

    method override public int64 Write( input pmData as memptr):
        define variable hDocument as handle no-undo.
        define variable iSize as int64 no-undo.
        
        assign iSize = get-size(pmData).
        
        Assert:IsPositive(iSize, 'Data size').

        create x-document hDocument.
        if iSize eq 0 then
            LogMessage('Zero-length data received in memptr', 5).
        else
            hDocument:load('memptr':u, pmData, false).
        
        assign this-object:Entity = new WidgetHandle(hDocument).
        
        return iSize.
    end method.
    
    /** Write data to/from the message

        @param handle Data to write */
    method override public int64 Write(input phData as handle):    
        Assert:IsType(phData, DataTypeEnum:XmlDocument).
        
        assign this-object:Entity = new WidgetHandle(phData).
        
        return ?.
    end method.

    /** Write data to/from the message

        @param character Data to write */
    method override public int64 Write(input pcData as character):    
        define variable lcData as longchar no-undo.
        
        assign lcData = pcData.
        
        return this-object:Write(input lcData).
    end method.
    
end class.