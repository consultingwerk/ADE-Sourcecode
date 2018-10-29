/************************************************
Copyright (c) 2015, 2018 by Progress Software Corporation. All rights reserved.
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

using Ccs.Common.Support.ICharacterHolder.
using Ccs.Common.Support.IHandleHolder.
using Ccs.Common.Support.ILongcharHolder.
using Ccs.Common.Support.IMemptrHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.Memptr.
using OpenEdge.Core.WidgetHandle.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using Progress.IO.FileInputStream.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Payload.XmlEntityWriter inherits MessageWriter: 
    constructor public XmlEntityWriter():
        super(get-class(IHandleHolder)).
    end constructor.
    
    method override public int64 Write(input poData as Object):
        define variable hDocument as handle no-undo.
        define variable oData as class Memptr no-undo.
        define variable lcXml as longchar no-undo.
        define variable fileStream as FileInputStream no-undo.
        
        case true:
            when not valid-object(poData) then
                return 0.
            
            when type-of(poData, IMemptrHolder) then
                return this-object:Write(cast(poData, IMemptrHolder):Value).
            
            when type-of(poData, ByteBucket) then
            do:
                // we must use an intermediary variable so that GC doesn't kill the Memptr
                // instance represented by the GetBytes() call
                assign oData = cast(poData, ByteBucket):GetBytes().
                return this-object:Write(oData:Value).
            end.
            
            when type-of(poData, IHandleHolder) then
                return this-object:Write(cast(poData, IHandleHolder):Value).
            
            when type-of(poData, ICharacterHolder) or
            when type-of(poData, ILongcharHolder)  then
            do:
                // coerce into using the LONGCHAR version
                assign lcXml = dynamic-property(poData, 'Value':u).
                return this-object:Write(lcXml).
            end.    // characters
            
            when type-of(poData, FileInputStream) then
            do:
                assign fileStream = cast(poData, FileInputStream).
                case entry(num-entries(fileStream:FileName, '.':u), fileStream:FileName, '.':u):
                    when 'xml':u or
                    when 'xsd':u then
                        return WriteFileStream(fileStream). 
                    otherwise 
                    return error new AppError(substitute('Unsupported file extension .&1 for XML', 
                                                    entry(num-entries(fileStream:FileName, '.':u), fileStream:FileName, '.':u))
                                    , 0).
                end case.
            end.    // file stream
            
            otherwise
                return error new AppError(
                                substitute('Unsupported object type: &1', poData:GetClass():TypeName)
                                , 0).
        end case.
        
        return 0.
    end method.
    
    method override public int64 Write(input pcData as longchar):
        define variable hDocument as handle no-undo.
        define variable iSize as int64 no-undo.
        
        Assert:NotNull(pcData, 'Data').
        
        create x-document hDocument.
        assign hDocument:strict-entity-resolution = false
               this-object:Entity                 = new WidgetHandle(hDocument)
               iSize                              = length(pcData, 'raw':u)
               .
        if iSize eq 0 then
            LogMessage('Zero-length data received in longchar', 5).
        else
            hDocument:load('longchar':u, pcData, false).
        
        return iSize.
    end method.
    
    method override public int64 Write(input pmData as memptr):
        define variable hDocument as handle no-undo.
        define variable iSize as int64 no-undo.
        
        assign iSize = get-size(pmData).
        if iSize eq ? then
            return 0.
        
        create x-document hDocument.
        assign hDocument:strict-entity-resolution = false
               this-object:Entity                 = new WidgetHandle(hDocument)
               .
        if iSize eq 0 then
            LogMessage('Zero-length data received in memptr', 5).
        else
            hDocument:load('memptr':u, pmData, false).
        
        return iSize.
    end method.
    
    /** Write data to/from the message
        
        @param handle Data to write */
    method override public int64 Write(input phData as handle):
        define variable xmlDoc as handle no-undo.
        if not valid-handle(phData) then
            return 0.
        
        case phData:type:
            when 'X-DOCUMENT':u then
                assign this-object:Entity = new WidgetHandle(phData).
            when 'X-NODEREF':u then
            do:
                if valid-object(this-object:Entity) then
                    assign xmlDoc = cast(this-object:Entity, IHandleHolder):Value.
                
                if not valid-handle(xmlDoc) then
                do:
                    create x-document xmlDoc.
                    assign xmlDoc:strict-entity-resolution = false
                           this-object:Entity              = new WidgetHandle(xmlDoc)
                           .
                end.
                
                xmlDoc:append-child(phData).
            end.
            otherwise
                return error new AppError(
                                substitute('Unsupported handle type: &1', phData:type)
                                , 0).
        end case.
        
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