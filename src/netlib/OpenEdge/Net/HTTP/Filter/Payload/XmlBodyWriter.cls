/************************************************
Copyright (c) 2015-2018, 2021 by Progress Software Corporation. All rights reserved.
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
using Progress.IO.MemoryOutputStream.

class OpenEdge.Net.HTTP.Filter.Payload.XmlBodyWriter inherits MessageWriter
        implements ISupportEncoding:
    /* Content encoding (eg utf-8) used by the implementer */
    define public property Encoding as character no-undo get. set.

    /* Default constructor */
    constructor public XmlBodyWriter():
        super(get-class(ByteBucket)).
    end constructor.
    
    /* Opens the writer for work. Will clear the underlying data structure. */
    method override public void Open():
        if not valid-object(this-object:Entity) then
            assign this-object:Entity = ByteBucket:Instance().
        else
            cast(this-object:Entity, ByteBucket):Clear().
        
        super:Open().
    end method.
    
    /* Writes XML data from a MEMPTR. Input data is concatenated to any existing data.
       
       @param memptr The XML data. Validated as XML by checking for a leading "<"
       @return int64 The number of bytes written */
    method override public int64 Write(input pmData as memptr):
        define variable xmlDecl as character no-undo.
        define variable size as int64 no-undo.
        
        assign size = get-size(pmData).
        if size eq 0 then
            return 0.
        
        assign xmlDecl = trim(get-string(pmData, 1 , min(1024, size))).
        // simple/dumb validation
        if not xmlDecl begins '<':u then
            return error new AppError(substitute('Data does not appear to be XML; starts with "&1"',
                                                    substring(xmlDecl, 1, 10))
                                    , 0).
        
        // Best guess
        run adecomm/convcp.p (input  session:cpinternal,
                              input  'toMime':u,
                              output /*THIS-OBJECT:*/ Encoding ).
        
        cast(this-object:Entity, ByteBucket):PutBytes(get-pointer-value(pmData), size).
        
        return size.
    end method.

    /* Writes XML data from character/longchar. Input data is concatenated to any existing data.
       
       @param longchar The XML data. Validated as XML by checking for a leading "<"
       @return int64 The number of bytes written */
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
    
    /* Writes XML data from a handle. Input data is concatenated to any existing data.
       
       @param handle The XML data, as a X-DOCUMENT, BUFFER, TEMP-TABLE or PRODATASET
       @return int64 The number of bytes written */
    method override public int64 Write(input pData as handle):
        define variable mXml as memptr no-undo.
        
        if valid-handle(pData) then
        case pData:type:
            when DataTypeHelper:GetMask(DataTypeEnum:XmlDocument) then
            do:
                pData:save(DataTypeEnum:Memptr:ToString(), mXml).
                
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
    
    /* Writes XML data from an object representation or wrapper. Input data is concatenated to any existing data.
       
       Supported types:
       - IMemptrHolder: includes OpenEdge.Core.Memptr and .ByteBucket
       - IHandleHolder
       - ICharacterHolder, ILongcharHolder
       - MemoryOutputStream
       - FileInputStream: must have a XML or XSD extension
       
       @param Progress.Lang.Object The XML data
       @return int64 The number of bytes written */
    method override public int64 Write(input poData as Object):
        define variable lcXml as longchar no-undo.
        define variable fileStream as FileInputStream no-undo.
        define variable chrPos as integer no-undo.
        define variable checkString  as character no-undo.
        define variable mXml as memptr no-undo.
        
        if not valid-object(poData) then
            return 0.
        
        if type-of(poData, IMemptrHolder) then
        do on error undo, throw:
            // this makes a deep copy of the data, but also
            // gives us control over the life of this MEMPTR
            assign mXml = cast(poData, IMemptrHolder):Value.
            return this-object:Write(mXml).
            finally:
                set-size(mXml) = 0.
            end finally.
        end.
        
        if type-of(poData, MemoryOutputStream) then
            return this-object:WriteMemoryStream(cast(poData, MemoryOutputStream)).
        
        if type-of(poData, IHandleHolder) then
            return this-object:Write(cast(poData, IHandleHolder):Value).
            
        if type-of(poData, ICharacterHolder)
        or type-of(poData, ILongcharHolder)
        then
        do:
            // coerce into using the LONGCHAR version
            // validate inline to avoid cost of passing LONGCHAR by value into the
            // appropriate Write() method
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
            
            // longchars are passed by-value, so don't do that
            cast(this-object:Entity, ByteBucket):PutString(lcXml).
            return length(lcXml, 'raw':u).
        end.    // characters
        
        if type-of(poData, FileInputStream) then
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
            
        return error new AppError(substitute('Unsupported object type: &1', poData:GetClass():TypeName), 0).
    end method.

end class.