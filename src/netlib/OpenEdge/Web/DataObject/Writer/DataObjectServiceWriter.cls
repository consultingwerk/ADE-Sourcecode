/* *************************************************************************************************************************
Copyright (c) 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : DataObjectServiceWriter
    Purpose     : Serializes a DataObjectService to an alternate format
    Author(s)   : pjudge
    Created     : 2018-08-30
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.IHandleHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Core.Assertion.AssertObject.
using OpenEdge.Core.KeyValuePair.
using OpenEdge.Core.SemanticVersion.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.ISupportLogging.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Net.URI.
using OpenEdge.Web.DataObject.DataObjectService.
using OpenEdge.Web.DataObject.MappedOperation.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.Object.

class OpenEdge.Web.DataObject.Writer.DataObjectServiceWriter abstract
            implements ISupportLogging:
    /* A reference to the Logger in use by an implementer */
    define public property Logger as ILogWriter no-undo 
        get(): 
            if not valid-object(this-object:Logger) then
                assign this-object:Logger = LoggerBuilder:GetLogger(this-object:GetClass()).
            
            return this-object:Logger.
        end get.
        set.
    
    /** (mandatory) The type that the entity this writer can write to. */
    define public property ValueType as class Progress.Lang.Class no-undo
        get.
        protected set(input pType as class Progress.Lang.Class):
            Assert:NotNull(pType, 'Argument type').
            
            assign ValueType = pType.
        end set.
    
    /** (mandatory) The message entity that's being written to. The values passed 
        in to the Write() methods will be parsed/processed and written to this entity. */
    define public property Value as Progress.Lang.Object no-undo
        get.
        set(input poValue as Progress.Lang.Object):
            /* needs to match this type */
            AssertObject:IsType(poValue, this-object:ValueType).
            
            assign this-object:Value = poValue.
        end set.
    
    // Stateful variables for the case where Write(MappedOperation) is called independently from the Write(DataObjectService) call
    // The current service 
    define private variable mCurrentService as DataObjectService no-undo.
    
    /** Constructor.
        
        @param Class  The type of the entity - pseudo-generics here.
        @param Object The 'real' entity being written */
    constructor protected DataObjectServiceWriter (input poType as class Progress.Lang.Class,
                                                   input poValue as Object):
        this-object(poType).
        
        Assert:NotNull(poValue, 'Value holder').
        assign this-object:Value = poValue.
    end method.
    
    /** Constructor.
        
        @param Object The target object to write to */
    constructor protected DataObjectServiceWriter (input pValue as Progress.Lang.Object):
        Assert:NotNull(pValue, 'Argument value').
        
        assign this-object:ValueType = pValue:GetClass()
               this-object:Value        = pValue
               .
    end constructor.
    
    /** Constructor.
        
        @param Class  The type of the entity - pseudo-generics here. */
    constructor protected DataObjectServiceWriter (input poType as class Progress.Lang.Class):
        assign ValueType = poType.
    end constructor.
    
    /** Clears or empties the target */
    method public void Clear():
        assign this-object:Value = ?.
    end method.
    
    /** Flushes(writes) the input to the target */
    method public void Flush():
    end method.
    
    /** Opens the writer for output. Open/Close allows us to write the same message multiple
        times without requiring a new writer each time. */
    method public void Open():
    end method.
    
    /**  Closes the writer. */
    method public void Close():
        this-object:Flush().
    end method.
    
    /* Writes an object array into the Value. 
       
       @param Progress.Lang.Object[] A set of objects to write. They will typically
                                     be in the OpenEdge.Web.DataObject package and be part of 
                                     a DataObjectService */
    method public void Write(input pData as Progress.Lang.Object extent):
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        
        assign cnt = extent(pData). 
        if cnt eq ? then
            return.
        
        do loop = 1 to cnt:
            this-object:Write(pData[loop]).
        end.
    end method.
    
    /* Writes an object array into the Value. 
       
       @param Progress.Lang.Object An object to write. It will typically
                                   be in the OpenEdge.Web.DataObject package and be part of 
                                   a DataObjectService */
    method public void Write(input pData as Progress.Lang.Object):
        case true:
            when not valid-object(pData) then
                return.
            
            when type-of(pData, URI) then
                WriteURI(cast(pData, URI)).
                
            when type-of(pData, DataObjectService) then
                WriteDOS(cast(pData, DataObjectService)).
            
            when type-of(pData, MappedOperation) then
                WriteOperation(mCurrentService, cast(pData, MappedOperation)).
            
            when type-of(pData, IHandleHolder) then
                WriteSchema(mCurrentService, cast(pData, IHandleHolder):Value).
            
            when type-of(pData, KeyValuePair) then
                WriteTuple(cast(pData, KeyValuePair):Key,
                           cast(pData, KeyValuePair):Value).
            
            otherwise
                logger:Warn(substitute('Unsupported object type: &1', pData:GetClass():TypeName)).
        end case.
    end method.
    
    /* Writes a URI to the output. This is effectively a VIRTUAL method (no default behaviour 
       but not compiled enforcement either).
       
       @param URI The URI to write */
    method protected void WriteURI(input pData as URI):
    end method.
    
    /* Writes a tuple (key-value pair).
       This is effectively a VIRTUAL method (no default behaviour but not compiled enforcement either).
       
       @param Progress.Lang.Object The key value - property name (required)
       @param Progress.Lang.Object A value to be written for the property. May be null. */
    method protected void WriteTuple(input pKey as Progress.Lang.Object,
                                     input pValue as Progress.Lang.Object):
    end method.
    
    /* Writes a single Data Object Service
       
       @param DataObjectService The service to write */
    method protected void WriteDOS(input pData as DataObjectService):
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        define variable ops as MappedOperation extent no-undo.
        define variable schemas as handle extent no-undo.
        
        if not valid-object(pData) then
            return.
        
        assign mCurrentService = pData.
        WriteService(pData).
        
        assign schemas = pData:GetSchemas()
               cnt     = extent(schemas)
               .
        do loop = 1 to cnt:
            WriteSchema(pData, schemas[loop]).
        end.
        
        // operations
        assign ops = pData:GetOperations()
               cnt = extent(ops)
               .
        do loop = 1 to cnt:
            WriteOperation(pData, ops[loop]).
        end.
    end method.
    
    /* Writes a single Data Object Service 
       
       @param DataObjectService The service to write */
    method abstract protected void WriteService(input pData as DataObjectService).
    
    /* Writes a single MappedOperation 
       
       @param DataObjectService The parent DOService 
       @param MappedOperation The service operation to write */
    method abstract protected void WriteOperation(input pSvc as DataObjectService,
                                                  input pData as MappedOperation).
    
    /* Writes a single schema
       
       @param DataObjectService The parent DOService
       @param handle The service schema to write */
    method abstract protected void WriteSchema(input pSvc as DataObjectService,
                                               input pData as handle).
    
    /* Returns a schema for a Data Object Service Catalog
       
       @param  SemanticVersion The catalog version
       @return JsonObject The catalog JSON-schema   */
    method protected JsonObject GetCatalogSchema(input pVersion as SemanticVersion):
        define variable catalogRef as JsonObject no-undo.
        
        assign catalogRef = new JsonObject().
        catalogRef:Add('$ref':u,
                       'https://raw.githubusercontent.com/progress/CDO/master/catalog%20validation/JSONSchemaForCDOCatalog.json':u). 
        
        return catalogRef.
    end method.
    
end class.
