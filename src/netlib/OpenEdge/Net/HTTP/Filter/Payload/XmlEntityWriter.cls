/************************************************
Copyright (c) 2015, 2018, 2021-2022 by Progress Software Corporation. All rights reserved.
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
using OpenEdge.Core.IMemoryPointer.
using OpenEdge.Core.Memptr.
using OpenEdge.Core.WidgetHandle.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using Progress.IO.FileInputStream.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Payload.XmlEntityWriter inherits MessageWriter:
    /* Default constructor */
    constructor public XmlEntityWriter():
        super(get-class(IHandleHolder)).
    end constructor.
    
    method override public void Open():
        super:Open().
        
        // make sure that we have an object and XML doc available
        this-object:GetXmlDoc().
    end method.
    
    method override public int64 Write(input poData as Object):
        var longchar lcXml.
        var FileInputStream fileStream.
        var memptr mData.
        
        case true:
            when not valid-object(poData) then
                return 0.
            
            when type-of(poData, IMemoryPointer) then
            do:
                // just reference the data
                set-pointer-value(mData) = cast(poData, IMemoryPointer):PointerValue.
                set-size(mData) = cast(poData, IMemoryPointer):Size.
                
                return this-object:Write(mData).
            end.
            
            when type-of(poData, IMemptrHolder) then
                return this-object:Write(cast(poData, IMemptrHolder):Value).
            
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
                return error new AppError(substitute('Unsupported object type: &1', poData:GetClass():TypeName), 0).
        end case.
        
        return 0.
        finally:
            set-pointer-value(mData) = 0.
            set-size(mData) = 0.
        end finally.
    end method.
    
    /* Returns the current X-DOCUMENT handle, or creates one if it does not yet exist/is invalid
       
       @return handle A valid X-DOCUMENT handle */
    method private handle GetXmlDoc():
        var handle xmlDoc.
        
        if valid-object(this-object:Entity) then
            assign xmlDoc = cast(this-object:Entity, IHandleHolder):Value.
        
        if not valid-handle(xmlDoc)
        or not xmlDoc:type eq 'X-DOCUMENT'
        then
        do:
            create x-document xmlDoc.
            assign xmlDoc:strict-entity-resolution = false
                   // YES = delete the XML doc at GC time
                   this-object:Entity              = new WidgetHandle(xmlDoc, yes)
                   .
        end.
        
        return xmlDoc.
    end method.
    
    method override public int64 Write(input pcData as longchar):
        define variable iSize as int64 no-undo.
        
        Assert:NotNull(pcData, 'Data').
        
        assign iSize = length(pcData, 'raw':u).
        if iSize eq 0 then
            LogMessage('Zero-length data received in longchar', 5).
        else
            GetXmlDoc():load('longchar':u, pcData, false).
        
        return iSize.
    end method.
    
    method override public int64 Write(input pmData as memptr):
        define variable iSize as int64 no-undo.
        
        assign iSize = get-size(pmData).
        if iSize eq ? then
            return 0.
        
        if iSize eq 0 then
            LogMessage('Zero-length data received in memptr', 5).
        else
            GetXmlDoc():load('memptr':u, pmData, false).
        
        return iSize.
    end method.
    
    /** Write data to/from the message.
        
        If the handle is a X-DOCUMENT, overwrite any existing data.
        
        If the handle is an X-NODEREF, add it to the existing X-DOC. If the document has no root node, then add the noderef as
        the root node. If a root node exists, then append the node to the root node.
        
        If the handle is a DATASET or TEMP-TABLE, call WRITE-XML and replace any existing data
        
        If the handle is a BUFFER and it's on a TEMP-TABLE, call WRITE-XML on the table and replace any existing data
        
        Otherwise throw an error.
        
        @param handle Data to write
        @return int64 The number of bytes written. Always returns 0 */
    method override public int64 Write(input phData as handle):
        var handle xmlNode, xmlDoc, rootNode.
        
        if valid-handle(phData) then
        case phData:type:
            when 'X-DOCUMENT':u then
                // do not auto-delete the X-DOC since we don't know who owns it
                assign this-object:Entity = new WidgetHandle(phData, no).
            
            when 'X-NODEREF':u then
            do on error undo, throw:
                assign xmlDoc = GetXmlDoc().
                
                create x-noderef xmlNode.
                xmlDoc:import-node(xmlNode, phData, yes).
                
                // this is a new/empty x-doc
                if xmlDoc:num-children eq 0 then
                    xmlDoc:append-child(xmlNode).
                else
                do:
                    create x-noderef rootNode.
                    xmlDoc:get-document-element(rootNode).
                    
                    rootNode:append-child(xmlNode).
                end.
                finally:
                    delete object xmlNode.
                    if valid-handle(rootNode) then
                        delete object rootNode.
                end finally.
            end.
            
            when 'TEMP-TABLE':u or
            when 'DATASET':u then
                phData:write-xml('handle':u, GetXmlDoc()).
            
            when 'BUFFER':u then
            do:
                // only TEMP-TABLES have a table-handle
                if valid-handle(phData:table-handle) then
                    phData:write-xml('handle':u, GetXmlDoc()).
                else
                    return error new AppError(substitute('Unsupported buffer: &1 is not on a temp-table', phData:name), 0).
            end.
            
            otherwise
                return error new AppError(substitute('Unsupported handle type: &1', phData:type), 0).
        end case.
        
        return 0.
    end method.

    /** Write data to/from the message

        @param character Data to write */
    method override public int64 Write(input pcData as character):
        define variable lcData as longchar no-undo.
        
        assign lcData = pcData.
        
        return this-object:Write(input lcData).
    end method.
    
end class.