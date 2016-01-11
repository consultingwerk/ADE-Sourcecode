/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/* ------------------------------------------------------------------------
    File        : SaxWriter
    Purpose     : An OOABL wrapper around the ABL SAX-WRITER handle. 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Nov 22 15:40:24 EST 2010
    Notes       : * The majority of method names correspond to the ABL attributes/methods,
                    which are comprehensively documented in the ABL documentation set.
                  * This program based on the AutoEdge|TheFactory version
  --------------------------------------------------------------------- */
block-level on error undo, throw.

using OpenEdge.Core.XML.SaxWriter.
using OpenEdge.Core.XML.SaxWriterDataTypeEnum.
using OpenEdge.Core.XML.SaxWriteStatusEnum.
using OpenEdge.Core.SerializationModeEnum.
using OpenEdge.Core.Assert.
using OpenEdge.Core.DataTypeEnum.
using Progress.Lang.AppError.

class OpenEdge.Core.XML.SaxWriter use-widget-pool:
    
    /* The actual SAX-WRITER handle */
    define private variable mhSaxWriter as handle no-undo.
    
    /** (derived) Maps to SAX-WRITER WRITE-STATUS attribute. See the ABL documentation for more details. */
    define public property WriteStatus as SaxWriteStatusEnum no-undo
        get():
            if valid-handle(mhSaxWriter) then
                return SaxWriteStatusEnum:EnumFromValue(mhSaxWriter:write-status).
        end get.
    
    /** Maps to SAX-WRITER ENCODING attribute. See the ABL documentation for more details. */
    define public property Encoding  as character no-undo
        get.
        set(input pcEncoding as character):
            ValidateCanUpdateProperty('Encoding').
            mhSaxWriter:encoding = pcEncoding.
            Encoding = pcEncoding.
        end set.
        
    
    /** Maps to SAX-WRITER FORMATTED attribute. See the ABL documentation for more details. */
    define public property IsFormatted as logical no-undo 
        get.
        set (input plFormatted as logical):
            ValidateCanUpdateProperty('IsFormatted').
            IsFormatted = plFormatted.
            mhSaxWriter:formatted = plFormatted.
        end set.
    

    /** Maps to SAX-WRITER FRAGMENT attribute. See the ABL documentation for more details. */
    define public property IsFragment as logical no-undo
        get.
        set (input plFragment as logical):
            ValidateCanUpdateProperty('IsFragment').
            IsFragment = plFragment.
            mhSaxWriter:fragment = plFragment.
        end set.
    
    /** Maps to SAX-WRITER STANDALONE attribute. See the ABL documentation for more details. */ 
    define public property IsStandalone as logical no-undo
        get.
        set(input plStandalone as logical):
            ValidateCanUpdateProperty('IsStandalone').
            IsStandalone = plStandalone.
            mhSaxWriter:standalone = plStandalone.
        end set.
    
    /** Maps to SAX-WRITER STRICT attribute. See the ABL documentation for more details. */
    define public property IsStrict as logical no-undo
        get.
        set(input plStrict as logical):
            ValidateCanUpdateProperty('IsStrict').
            IsStrict = plStrict.
            mhSaxWriter:strict= plStrict.
        end set.
    
    /** Maps to SAX-WRITER VERSION attribute. See the ABL documentation for more details. */
    define public property Version  as character no-undo
        get.
        set(input pcVersion as character):
            ValidateCanUpdateProperty('Version').
            
            if IsStrict and Version ne '1.0' then
                undo, throw new AppError (
                    substitute('Error setting "Version" property when with SaxWriter:IsStrict and version is &1',
                            pcVersion)
                    ,0). 
            mhSaxWriter:version = pcVersion.
            Version = pcVersion.
        end set.
        
    /* Public property setter methods provided to enable a Fluent-style interface 
      ( oSW:SetIsStrict(true):StartDocument(): ... ) */
    method public SaxWriter SetVersion(input pcVersion as character):
        this-object:Version = pcVersion.
        return this-object.
    end method.

    method public SaxWriter SetEncoding(input pcEncoding as character):
        this-object:Encoding = pcEncoding.
        return this-object.
    end method.
    
    method public SaxWriter SetIsFormatted(input plIsFormatted as logical):
        this-object:IsFormatted = plIsFormatted.
        return this-object.
    end method.

    method public SaxWriter SetIsStandalone(input plIsStandalone as logical):
        this-object:IsStandalone = plIsStandalone.
        return this-object.
    end method.

    method public SaxWriter SetIsFragment(input plIsFragment as logical):
        this-object:IsFragment = plIsFragment.
        return this-object.
    end method.

    method public SaxWriter SetIsStrict(input plIsStrict as logical):
        this-object:IsStrict = plIsStrict.
        return this-object.
    end method.
        
    constructor public SaxWriter():
        Initialize().
    end constructor.
    
    constructor public SaxWriter(input pcFilename as character):
        Initialize().
        WriteTo(pcFilename).
    end constructor.

    constructor public SaxWriter(input pcDocument as longchar):
        Initialize().
        WriteTo(pcDocument).
    end constructor.

    constructor public SaxWriter(input phStream as handle):
        Initialize().
        WriteTo(phStream).
    end constructor.

    constructor public SaxWriter(input pmDocument as memptr):
        Initialize().
        WriteTo(pmDocument).            
    end constructor.
    
    method protected void ValidateCanUpdateProperty(input pcPropertyName as character):
        if valid-handle(mhSaxWriter) then
        case WriteStatus:
            when SaxWriteStatusEnum:Idle or when SaxWriteStatusEnum:Complete then
                /* allowed to update property */ .
            otherwise
                undo, throw new AppError(
                    substitute('Error setting &1 property when SaxWriter status is &2',
                            quoter(pcPropertyName),
                            this-object:WriteStatus:ToString())
                        ,0).
        end case.
    end method.
    
    method public void Initialize():
        if not valid-handle(mhSaxWriter) then
            create sax-writer mhSaxWriter.
        else
            Reset().                
    end method.
    
    method public SaxWriter Reset():
        if valid-handle(mhSaxWriter) then
            mhSaxWriter:reset().
        return this-object.            
    end method.
    
    method public SaxWriter WriteTo(input pcFilename as character):
        mhSaxWriter:set-output-destination(SerializationModeEnum:File:ToString(), pcFilename).
        return this-object.    
    end method.

    method public SaxWriter WriteTo(input pcDocument as longchar):
        mhSaxWriter:set-output-destination(SerializationModeEnum:LongChar:ToString(), pcDocument).
        return this-object.
    end method.
    
    method public SaxWriter WriteTo(input phStream as handle):
        Assert:IsType(phStream, DataTypeEnum:Stream, 'stream').
        
        mhSaxWriter:set-output-destination(SerializationModeEnum:StreamHandle:ToString(), phStream).
        return this-object.
    end method.

    method public SaxWriter WriteTo(input pmDocument as memptr):    
        mhSaxWriter:set-output-destination(SerializationModeEnum:Memptr:ToString(), pmDocument).
        return this-object.
    end method.
    
    method public SaxWriter StartDocument():
        mhSaxWriter:start-document().
        return this-object.
    end method. 

    method public void EndDocument():
        mhSaxWriter:end-document().
    end method.

    method public SaxWriter DeclareNamespace(input pcNamespaceURI as longchar):
        return DeclareNamespace(pcNamespaceURI, ?).                                               
    end method.                                               
    
    method public SaxWriter DeclareNamespace(input pcNamespaceURI as longchar,
                                           input pcNamespacePrefix as longchar):
        mhSaxWriter:declare-namespace(pcNamespaceURI, pcNamespacePrefix).
        return this-object.                                               
    end method.                                               
    
    method public SaxWriter StartElement(input pcName as longchar):
        return StartElement(pcName, ?, ?).
    end method.
    
    method public SaxWriter StartElement(input pcName as longchar,
                                       input pcNamespaceURI as longchar):
        return StartElement(pcName, pcNamespaceURI, ?).
    end method.
    
    method public SaxWriter StartElement(input pcName as longchar,
                                       input pcNamespaceURI as longchar,                                       
                                       input phSaxAttributes as handle):
        mhSaxWriter:start-element(pcName, pcNamespaceURI, phSaxAttributes).
        return this-object.
    end method.

    
    method public SaxWriter EndElement(input pcName as longchar):
        return EndElement(pcName, ?).
    end method.
    
    method public SaxWriter EndElement(input pcName as longchar,
                                     input pcNamespaceURI as longchar):
        mhSaxWriter:end-element(pcName, pcNamespaceURI).
        return this-object.                                           
    end method.

    method public SaxWriter InsertAttribute (input pcName as longchar,
                                           input pcValue as longchar):
        return InsertAttribute(pcName, pcValue, ?). 
    end method.            

    method public SaxWriter InsertAttribute (input pcName as longchar,
                                             input pcValue as longchar,
                                             input pcNamespaceURI as longchar):
        mhSaxWriter:insert-attribute(pcName, pcValue, pcNamespaceURI).
        return this-object. 
    end method.
    
    /** Writes a value to the output destination. This method defaults to
        writing characters. 
        
        @param longchar The value being written.
        @return logical Whether the operation succeeded or not. */
    method public SaxWriter WriteValue(input pcValue as longchar):
        return WriteValue(SaxWriterDataTypeEnum:Characters, pcValue).
    end method.
    
    /** Writes a value to the output destination. This method simply writes
        the value for the given type, using the correct WRITE-* call. 
        
        There's a WriteFragment() method which deals with a noderef handle.
        
        @param SaxWriterDataTypeEnum The element type
        @param longchar The value being written.
        @return logical Whether the operation succeeded or not. */
    method public SaxWriter WriteValue(input poType as SaxWriterDataTypeEnum,
                                       input pcValue as longchar):
        case poType:
            when SaxWriterDataTypeEnum:CData then mhSaxWriter:write-cdata(pcValue).
            when SaxWriterDataTypeEnum:Characters then mhSaxWriter:write-characters(pcValue).
            when SaxWriterDataTypeEnum:Comment then mhSaxWriter:write-comment(pcValue).
            when SaxWriterDataTypeEnum:EntityReference then mhSaxWriter:write-entity-ref(pcValue).
            when SaxWriterDataTypeEnum:Fragment then mhSaxWriter:write-fragment(pcValue).
        end case.
        return this-object.
    end method.
    
    /** Writes a fragment's values from a specified XML node ref 
        
        @param handle The valid XML node-ref handle containing the fragment
        @return logical Whether the operation succeeded or not. */
    method public SaxWriter WriteFragment(input phNodeRef as handle):
        Assert:IsType(phNodeRef, DataTypeEnum:XmlNodeRef, 'XML Node Ref').
        
        mhSaxWriter:write-fragment(phNodeRef).
        return this-object.
    end method.
    
    /** Writes a fragment's values from a specified XML node ref 
        
        @param longchar The longchar containing the fragment
        @return logical Whether the operation succeeded or not. */
    method public SaxWriter WriteFragment(input pcValue as longchar):
        mhSaxWriter:write-fragment(pcValue).
        return this-object.
    end method.
    
    method public SaxWriter WriteDataElement(input pcName as longchar,
                                           input pcValue as longchar):
        return WriteDataElement(pcName, pcValue, ?, ?).                                               
    end method.

    method public SaxWriter WriteDataElement(input pcName as longchar,
                                           input pcValue as longchar,
                                           input pcNamespaceURI as longchar):
        return WriteDataElement(pcName, pcValue, pcNamespaceURI, ?).                                               
    end method.
    
    method public SaxWriter WriteDataElement(input pcName as longchar,
                                           input pcValue as longchar,
                                           input pcNamespaceURI as longchar,
                                           input phSaxAttributes as handle ):
        mhSaxWriter:write-data-element(pcName, pcValue, pcNamespaceURI, phSaxAttributes).
        return this-object.                                               
    end method.

    method public SaxWriter WriteEmptyElement(input pcName as longchar):
        return WriteEmptyElement(pcName, ?, ?).
    end method.

    method public SaxWriter WriteEmptyElement(input pcName as longchar,
                                            input pcNamespaceURI as longchar):
        return WriteEmptyElement(pcName, pcNamespaceURI, ?).
    end method.
    
    method public SaxWriter WriteEmptyElement(input pcName as longchar,
                                            input pcNamespaceURI as longchar,
                                            input phSaxAttributes as handle ):
        mhSaxWriter:write-empty-element(pcName, pcNamespaceURI, phSaxAttributes).
        return this-object.
    end method.

    method public SaxWriter WriteExternalDTD(input pcName as longchar,
                                           input pcSystemId as longchar):
        return WriteExternalDTD(pcName, pcSystemId, ?).
    end method.
    
    method public SaxWriter WriteExternalDTD(input pcName as longchar,
                                           input pcSystemId as longchar,
                                           input pcPublicId as longchar):
        mhSaxWriter:write-external-dtd(pcName, pcSystemId, pcPublicId).
        return this-object.
    end method.
    
    method public SaxWriter WriteProcessingInstruction(input pcTarget as longchar,
                                                     input pcData as longchar):
        mhSaxWriter:write-processing-instruction(pcTarget, pcData).
        return this-object.                                                         
    end method.
    
end class.
