/************************************************
Copyright (c) 2015-2018 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : XmlBodyWriter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jan 29 10:47:13 EST 2015
    Notes       : * Supports String, WidgetHandle, Memptr and FileInputStream types but these MUST contain
                    valid/wellformed XML documents. 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.ICharacterHolder.
using Ccs.Common.Support.IHandleHolder.
using Ccs.Common.Support.ILongcharHolder.
using Ccs.Common.Support.IMemptrHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.DataTypeEnum.
using OpenEdge.Core.DataTypeHelper.
using OpenEdge.Core.ISupportEncoding.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using Progress.IO.FileInputStream.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Payload.XmlBodyWriter inherits MessageWriter
        implements ISupportEncoding:
    /* Content encoding (eg utf-8) used by the implementer */ 
    define public property Encoding as character no-undo get. set. 

    constructor public XmlBodyWriter():
        super(get-class(ByteBucket)).
    end constructor.
    
    method override public void Open():
        if not valid-object(this-object:Entity) then
            assign this-object:Entity = ByteBucket:Instance().
        
        super:Open().
    end method.
    
    method override public int64 Write(input pmData as memptr):
        define variable xmlDecl as character no-undo.
        
        if get-size(pmData) eq 0 then
            return 0.
        
        assign xmlDecl = trim(get-string(pmData, 1 , min(1024, get-size(pmData)))).
        // simple/dumb validation
        if not xmlDecl begins '<':u then
            return error new AppError(substitute('Data does not appear to be XML; starts with "&1"',
                                                    substring(xmlDecl, 1, 10))
                                    , 0).
        
        // Best guess
        run adecomm/convcp.p (input  session:cpinternal,
                              input  'toMime':u,
                              output /*THIS-OBJECT:*/ Encoding ).
        
        cast(this-object:Entity, ByteBucket):PutBytes(get-pointer-value(pmData), get-size(pmData)).
        
        return get-size(pmData).
    end method.
    
    method override public int64 Write(input pData as longchar):
        define variable chrPos as integer no-undo.
        define variable checkString  as character no-undo.
        
        Assert:NotNull(pData, 'XML data').
        
        // simple/dumb validation 
        assign chrPos      = index(pData, '<':u)
               checkString = trim(substring(pData, 1, chrPos)) 
               .
        if    chrPos eq 0
           or not checkString begins '<':u
        then
            return error new AppError(substitute('Character data does not appear to be XML; starts with "&1"', checkString)
                                    , 0).
        
        /* convert to ISO format from ABL */
        run adecomm/convcp.p (input  get-codepage(pData),
                              input  'toMime':u,
                              output /*THIS-OBJECT:*/ Encoding ).
        
        cast(this-object:Entity, ByteBucket):PutString(pData).
        
        return length(pData, 'raw':u).
    end method.
    
    method override public int64 Write(input pData as handle):
        define variable mXml as memptr no-undo.
        
        if valid-handle(pData) then
        case pData:type:
            when DataTypeHelper:GetMask(DataTypeEnum:XmlDocument) then
            do:
                pData:save('memptr':u, mXml).
                
                // Do this _after_ the Write(memptr) call, since that call sets the Encoding too
                run adecomm/convcp.p (input  pData:encoding,
                                      input  'toMime':u,
                                      output /*THIS-OBJECT:*/ Encoding ).
            end.    //XML
            
            when DataTypeHelper:GetMask(DataTypeEnum:TempTable) or
            when DataTypeHelper:GetMask(DataTypeEnum:Buffer) or
            when DataTypeHelper:GetMask(DataTypeEnum:Dataset) then
            do:
                pData:write-xml(DataTypeEnum:Memptr:ToString(), mXml, session:debug-alert).
                // default, per the doc
                assign this-object:Encoding = 'utf-8':u.
            end.
            
            otherwise
                return error new AppError(substitute('Unsupported handle type: &1', pData:type), 0).
        end case.
        
        cast(this-object:Entity, ByteBucket):PutBytes(get-pointer-value(mXml), get-size(mXml)).
        
        return get-size(mXml).
        
        // Don't clean up the hDocument handle - that should be managed by either
        // the holder-object or whoever created it, not this code
        finally:
            if get-size(mXml) gt 0 then
                set-size(mXml) = 0.
        end finally.        
    end method.
    
    method override public int64 Write(input poData as Object):
        define variable mXml as memptr no-undo.
        define variable lcXml as longchar no-undo.
        define variable fileStream as FileInputStream no-undo.
        define variable chrPos as integer no-undo.
        define variable checkString  as character no-undo.
        
        case true:
            when not valid-object(poData) then
                return 0.
            
            when type-of(poData, IMemptrHolder) then
                return this-object:Write(cast(poData, IMemptrHolder):Value).
            
            when type-of(poData, IHandleHolder) then
                return this-object:Write(cast(poData, IHandleHolder):Value).
            
            when type-of(poData, ICharacterHolder) or
            when type-of(poData, ILongcharHolder) then
            do:
                // coerce into using the LONGCHAR version
                assign lcXml       = dynamic-property(poData, 'Value':u)
                       chrPos      = index(lcXml, '<':u)
                       checkString = trim(substring(lcXml, 1, chrPos)) 
                       .
                // simple/dumb validation 
                if    chrPos eq 0
                   or not checkString begins '<':u
                then
                    return error new AppError(substitute('Character data does not appear to be XML; starts with "&1" ',
                                                    checkString)
                                    , 0).
                
                assign this-object:Encoding = get-codepage(lcXml).
                       .
                // longchars are passed by-value, so don't do that
                cast(this-object:Entity, ByteBucket):PutString(lcXml).
                return length(lcXml, 'raw':u).
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
        finally:
            if get-size(mXml) gt 0 then
                set-size(mXml) = 0.
        end finally.        
    end method.

end class.