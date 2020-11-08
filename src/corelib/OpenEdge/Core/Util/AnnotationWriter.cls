 /************************************************
Copyright (c) 2020 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : AnnotationWriter
    Purpose     : Utility to read an XML XREF file and return the annotations for a given ABL program
                  in JSON
    Author(s)   : pjudge
    Created     : 2018-11-08
    Notes       :  
       The JSON returned is either ancontains only a null "program" property  
            { "<xref.unavailable>" : {
                "meta": {
                    "version": "1.0.0",
                    "fileName" : ""
                    }
                }
            }
       
       or has the structure
       {
         // metadata about the program 
         "meta" : {
            "version": "1.0.0"  // the version of this JSON
            "fileName": ""      // the name of the source file that produced the annotations
            "inherits": []      // an optional array of classes that this class inherits. not in procedure-based output
            "implements": []    // an optional array of interface that this class implements. not in procedure-based output
         }
         // these are annotations that belong to the class/procedure
         "program": {
            "annotation-name-1": ANNOTATION-DATA
         
         // these are annotations that match the input user map 
         "user" {
            "group": ANNOTATION-DATA
            ANNOTATION-DATA
         }
         
         // these have no parameters or cannot be overloaded. the name never has a paren
         "destructor"
         "procedure"
         "function"
         "property"
         "event": {
             "name": ANNOTATION-DATA 
          }
         
         // these are members that can be overloaded. the name always has parens.
         "constructor"
         "method": {
             "name(<iomode-1> <param-type-1>, <iomode-n> <param-type-n>)": 
             "name()": 
                 ANNOTATION-DATA
         }
       }
       
       ANNOTATION-DATA :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Assertion.AssertFile.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.IStringStringMap.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Core.StringConstant.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.
using OpenEdge.Core.Json.JsonConverter.
using OpenEdge.Core.String.
using OpenEdge.Core.Json.JsonPropertyHelper.
using Progress.IO.FileInputStream.

class OpenEdge.Core.Util.AnnotationWriter implements ISupportInitialize:
    {OpenEdge/Core/Util/dsxref.i ACCESS-LEVEL=PRIVATE }
    
    // list of JSON properties reserved by this parser
    define private variable mNonUserProperties as character no-undo
        initial 'program,data,method,constructor,destructor,property,event,procedure,function,user':u.
    
    /* Default constructor */
    constructor public AnnotationWriter():
    end constructor.
    
    /* Constructor.
       
       @param character The name of a XML-XREF file to read */
    constructor public AnnotationWriter(input pFilename as character):
        this-object().
        
        // if the file exists, load from it. ParseXref will throw an error if the file doesn't exist 
        // but we don't want to be doing that from the constructor
        assign file-info:file-name = pFilename.
        if not file-info:full-pathname eq ?
           and index(file-info:file-type, 'F':u) gt 0
           and index(file-info:file-type, 'R':u) gt 0
        then
            ParseXref(pFilename).
    end constructor.
    
    /* Constructor.
       
       @param FileInputStream The XML-XREF file to read */
    constructor public AnnotationWriter(input pFile as FileInputStream):
        this-object().
        Assert:NotNull(pFile, 'Xref file').
        ParseXref(pFile).
    end constructor.
    
    /* Initializer/Startup */
    method public void Initialize():
        dataset dsXref:empty-dataset().
    end method.
    
    /* Destroy/Shutdown/Anti-Initializer */
    method public void Destroy():
        dataset dsXref:empty-dataset().
    end method.
    
    /* Reads an XML REF file into the local storage. This method can be called
       mulktiple times to read multiple files.
       
       @param FileInputStream The XML-XREF file to read */
    method public void ParseXref(input pFile as FileInputStream):
        Assert:NotNull(pFile, 'Xref file').
        ParseXref(pFile:FileName).
    end method.
    
    /* Reads an XML REF file into the local storage. This method can be called
       mulktiple times to read multiple files.
       
       @param character The name of the XML-XREF file */
    method public void ParseXref(input pFilename as character):
        AssertFile:FileExists(pFilename).
        assign file-info:file-name = pFilename.
        
        dataset dsXref:read-xml('file':u, file-info:full-pathname, ?,?,?).
    end method.
    
    /* Method to find Source record for a given program. The input buffer is positioned
       to a record, if found.
       
       @param character The program name
       @param buffer Source The buffer in which to find the record */
    method private void FindSourceRecord (input pAblProgram as character,
                                          buffer pSource for Source):
        release pSource.
        
        // look for slash-delimited files
        assign pAblProgram = replace(pAblProgram, StringConstant:BACKSLASH, '/':u).
        if can-find(first pSource where pSource.File-name eq pAblProgram) then
             find first pSource where pSource.File-name eq pAblProgram.
        else
        // look for backslash-delimited files
        do:
            assign pAblProgram = replace(pAblProgram, '/':u, StringConstant:BACKSLASH). 
            if can-find(first pSource where pSource.File-name eq pAblProgram) then
                 find first pSource where pSource.File-name eq pAblProgram.
        end.
    end method.
    
    /* Returns the annotations in JSON form for a given file.
       
       @param character The name of the ABL file (class/procecure/etc) for which to extract annotations
       @param IStringStringMap A map of an annotation to a user-defined group. The group is created under a "user" property. 
                               Unknown values are allowed.
       @return JsonObject A JSON object containing the annotations. A valid object is always returned. */
    method public JsonObject GetAnnotations(input pAblProgram as character,
                                            input pUserMap as IStringStringMap):
        define variable annoData as JsonObject no-undo.
        define variable progData as JsonObject no-undo.
        define variable refName as character no-undo.
        define buffer lbSource for Source.
        define buffer lbRef for Reference.
        
        FindSourceRecord(pAblProgram, buffer lbSource).
        assign annoData = new JsonObject()
               progData = ExtractAnnotations(buffer lbSource, pUserMap)
               .
        if not available lbSource then
        do:
            progData:GetJsonObject('meta':u)
                    :Add('fileName':u, pAblProgram).
            
            annoData:Add('<xref.unavailable>', progData).
            return annoData.
        end.
        
        find  lbRef
        where lbRef.Source-guid eq lbSource.Source-guid
          and lbRef.Reference-type eq 'CLASS':u
        no-error.
        
        if available lbRef then
            assign refName = lbRef.Object-identifier. 
        else
            assign refName = replace(lbSource.File-name, StringConstant:BACKSLASH, '/':u)
                   refName = entry(num-entries(refName, '/':u), refName, '/':u) 
                   .
        annoData:Add(refName, progData).
        
        return annoData.
    end method.
    
    /* Returns the annotations in JSON form for a given file.
       @param IStringStringMap A map of an annotation to a user-defined group. The group is created under a "user" property. 
                               Unknown values are allowed.
       @return JsonObject A JSON object containing the annotations. A valid object is always returned.   */
    method public JsonObject GetAnnotations(input pUserMap as IStringStringMap):
        define variable annoData as JsonObject no-undo.
        define variable progData as JsonObject no-undo.
        define variable progArray as JsonArray no-undo.
        define variable refName as character no-undo.
        define buffer lbSource for Source.
        define buffer lbRef for Reference.
        
        assign annoData = new JsonObject().
        for each lbSource
           where lbSource.File-num eq 1
              by lbSource.File-name:
            find  lbRef
            where lbRef.Source-guid eq lbSource.Source-guid
              and lbRef.Reference-type eq 'CLASS':u
            no-error.
            
            assign progData = ExtractAnnotations(buffer lbSource, pUserMap).
            if available lbRef then
                assign refName = lbRef.Object-identifier. 
            else
                assign refName = replace(lbSource.File-name, StringConstant:BACKSLASH, '/':u)
                       refName = entry(num-entries(refName, '/':u), refName, '/':u) 
                       .
            // in case we have dups
            if annoData:Has(refName) then
            do:
                if annoData:GetType(refName) eq JsonDataType:ARRAY then
                    assign progArray = annoData:GetJsonArray(refName).
                else
                do:
                    assign progArray = new JsonArray().
                    progArray:Add(annoData:GetJsonObject(refName)).
                    
                    annoData:Set(refName, progArray).
                end.
                
                progArray:Add(progData).
            end.
            else
                annoData:Add(refName, progData).
        end.
        
        return annoData.
    end method.
    
    /* Extracts annotations for a single program 
       
       @param buffer Source The current program whose annotations to extract
       @param IStringStringMap A map of an annotation to a user-defined group. The group is created under a "user" property. 
                               Unknown values are allowed.
       @return JsonObject A JSON object containing the annotations. A valid object is always returned.   */
    method protected JsonObject ExtractAnnotations(buffer pSource for Source,
                                                   input  pUserMap as IStringStringMap):
        define variable pos as integer no-undo.
        define variable groupData as JsonObject no-undo.
        define variable annotations as JsonObject no-undo.
        
        define buffer lbSrc for Source. 
        
        assign annotations = new JsonObject()
               groupData   = new JsonObject()
               .
        annotations:Add('meta':u, groupData).
            groupData:Add('version':u, '1.0.0':u).
        
        if not available pSource then
            return annotations.
        
        groupData:Add('fileName':u, pSource.File-name).
        annotations:AddNull('program':u).
        
        assign pos = r-index(pSource.File-name, '.':u).
        if substring(pSource.File-name, pos + 1) eq 'cls':u then
        do:
            groupData:AddNull('inherits':u).
            groupData:AddNull('implements':u).
            
            annotations:AddNull('property':u).
            annotations:AddNull('event':u).
            annotations:AddNull('constructor':u).
            annotations:AddNull('method':u).
            annotations:AddNull('destructor':u).
        end.
        else
        do:
            annotations:AddNull('procedure':u).
            annotations:AddNull('function':u).
        end.
        
        annotations:AddNull('data':u).
        annotations:AddNull('user':u).
        
        // add the file itself 
        AddReferences(buffer pSource, pUserMap, annotations).
       
        for each lbSrc 
           where lbSrc.Source-guid eq pSource.Source-guid
             and lbSrc.File-Num    ge 2    // read any includes 
              by lbSrc.File-Num:
            AddReferences(buffer lbSrc, pUserMap, annotations).
        end.
        
        return annotations.
    end method.
    
    /* Adds references from a "source" element. A single piece of rcode may have many, depending
       on the number includes
       
       @param buffer           The Source record from which to add references  
       @param IStringStringMap Any user-defined annotation mappings
       @param JsonObject       The obejcts to which to add the annotations */
    method protected void AddReferences(buffer pSource for Source,
                                        input pUserMap as IStringStringMap,
                                        input pData as JsonObject):
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        define variable pos as integer no-undo.
        define variable annoVals as character no-undo.
        define variable annoName as character no-undo.
        define variable annoKvp as character no-undo.
        define variable annoKey as character no-undo.
        define variable annoValue as character no-undo.
        define variable listValue as character extent no-undo.
        define variable delim as character no-undo.
        define variable propGroup as character no-undo.
        define variable annotGroup as JsonObject no-undo.
        define variable valueData as JsonObject no-undo.
        define variable jsonData as JsonObject no-undo.
        define variable valueSet as JsonArray no-undo.
        define variable groupName as character extent 2 no-undo.
        
        define buffer lbReference for Reference.
        define buffer lbParam for Parameter-ref.
        define buffer lbCls for Class-ref.
        
        for each lbReference 
           where lbReference.Source-guid eq pSource.Source-guid
             and lbReference.File-num eq pSource.File-num
              by lbReference.Ref-seq:
            case lbReference.Reference-type:
                when 'annotation':u then
                do:
                    // The annotation name is either annotation.name or annotation.name(key=value)  
                    assign pos      = index(lbReference.Object-identifier, '(':u)
                           annoName = trim(substring(lbReference.Object-identifier, 1, pos - 1) )
                           .
                    // no annotation value, just a name
                    if pos eq 0 then
                        assign annoName  = trim(lbReference.Object-identifier)
                               valueData = ?
                               .
                    else
                    do:
                        assign valueData = new JsonObject()
                               // don't TRIM; we only want to remove the last single ) paren
                               annoVals  = substring(lbReference.Object-identifier, pos + 1)
                               annoVals  = substring(annoVals, 1, r-index(annoVals, ')':u) - 1)
                               cnt       = num-entries(annoVals) /* Get a count, which may be inaccurate... */
                               .
                        do loop = 1 to cnt:
                            /**
                             * Annotations with multiple properties (key-value pairs) should be separated with commas.
                             * Values may also contain comma-delimited values. However, because the annotations have
                             * all quotes removed from the string it's difficult to know when a comma-delimited list
                             * of values ends and the next key-value pair begins. Therefore, we should only change the
                             * key value IF we've encountered a portion of the annotation whcih contains an "=" symbol.
                             * By doign this we should keep the old key name and the code will automatically add any
                             * additional items for a key by changing the object to an array.
                             */
                            assign annoKvp = entry(loop, annoVals)
                                   pos     = index(annoKvp, '=':u)
                                   .
                            /* Broke this up as we need the values set above, first. */
                            assign annoKey   = trim(entry(1, annoKvp, '=':u)) when num-entries(annoKvp, '=':u) ge 2
                                   annoValue = trim(substring(annoKvp, pos + 1)) /* Remainder of KVP string */
                                   .
                            if valueData:Has(annoKey) then
                                case valueData:GetType(annoKey):
                                    when JsonDataType:NULL then
                                    do:
                                        assign valueSet = new JsonArray().
                                        valueSet:AddNull().
                                        if pos eq 0 and annoValue eq "" then
                                            valueSet:AddNull(). /* Don't add blank values, just null. */
                                        else
                                            valueSet:Add(annoValue).

                                        valueData:Set(annoKey, valueSet).
                                    end.

                                    when JsonDataType:STRING then
                                    do:
                                        assign valueSet = new JsonArray().
                                        valueSet:Add(valueData:GetCharacter(annoKey)).
                                        if pos eq 0 and annoValue eq "" then
                                            valueSet:AddNull(). /* Don't add blank values, just null. */
                                        else
                                            valueSet:Add(annoValue).
                                        valueData:Set(annoKey, valueSet).
                                    end.

                                    when JsonDataType:ARRAY then
                                    do:
                                        assign valueSet = valueData:GetJsonArray(annoKey).
                                        if pos eq 0 and annoValue eq "" then
                                            valueSet:AddNull(). /* Don't add blank values, just null. */
                                        else
                                            valueSet:Add(annoValue).
                                    end.
                                end. /* case */
                            else
                                if pos eq 0 and annoValue eq "" then
                                    valueData:AddNull(annoKey). /* Just add a null value for this key. */
                                else
                                    valueData:Add(annoKey, annoValue).
                        end.
                    end.
                    
                    if  valid-object(pUserMap)
                    and pUserMap:ContainsKey(annoName)
                    then
                    do:
                        assign propGroup = string(pUserMap:Get(annoName))
                               groupName = ?
                               .
                        if not propGroup eq ?
                        and not propGroup eq '':u
                        then
                        do:
                            assign jsonData     = annotGroup
                                   pos          = index(propGroup, '.':u)
                                   groupName[1] = entry(1, propGroup, '.':u)
                                   .
                            // User annotations can be anywhere but the META group
                            if lookup(groupName[1], mNonUserProperties) eq 0
                            or groupName[1] eq 'meta':u
                            then
                                assign groupName[2] = propGroup
                                       groupName[1] = 'user':u
                                       .
                            else
                            if pos gt 0 then
                                assign groupName[2] = substring(propGroup, pos + 1).
                            
                            // Add this annotation to the group named groupName[1].groupName[2] 
                            AddAnnotationToGroup(groupName, annoName, valueData, pData).
                        end.
                    end.
                    else
                    do:
                        if not valid-object(annotGroup) then
                            assign annotGroup = new JsonObject().
                        
                        // Add this annotation to the current group
                        AddAnnotationToGroup(annotGroup, annoName, valueData).
                    end.
                end.
                
                // We don't need a name for these , since all of these are for a single 
                // program/compile unit 
                when 'compile':u then
                    if valid-object(annotGroup) then
                    do:
                        JsonConverter:Merge(JsonPropertyHelper:GetObjectValue(pData, 'program':u, true),    //target
                                            annotGroup,                                                     // source
                                            true).                                                          // overwrite?
                        assign annotGroup = ?.
                    end.
                
                when 'class':u then
                do:
                    find  lbCls
                    where lbCls.Source-guid eq lbReference.Source-guid
                      and lbCls.Ref-seq     eq lbReference.Ref-seq.
                    
                    assign extent(listValue) = ?
                           listValue         = String:Split(lbCls.Inherited-list, StringConstant:SPACE)
                           .
                    if not extent(listValue) eq ? then
                        JsonPropertyHelper:GetObjectValue(pData, 'meta':u, true)
                                          :Set('inherits':u, new JsonArray(listValue)).
                    
                    assign extent(listValue) = ?
                           listValue         = String:Split(lbCls.Implements-list, StringConstant:SPACE)
                           .
                    if not extent(listValue) eq ? then
                        JsonPropertyHelper:GetObjectValue(pData, 'meta':u, true)
                                          :Set('implements':u, new JsonArray(listValue)).
                    
                    if valid-object(annotGroup) then
                    do:
                        JsonConverter:Merge(JsonPropertyHelper:GetObjectValue(pData, 'program':u, true),    //target
                                            annotGroup,                                                     // source
                                            true).                                                          // overwrite?
                        assign annotGroup = ?.
                    end.
                end.
                
                // these have no parameters
                when 'private-procedure':u or
                when 'private-function':u then
                    if valid-object(annotGroup) then
                    do:
                        assign propGroup = lc(lbReference.reference-type)
                               propGroup = replace(propGroup, 'private-':u, '':u)
                               .
                        JsonConverter:Merge(
                            JsonPropertyHelper:GetObjectValue(              // target
                                JsonPropertyHelper:GetObjectValue(pData, propGroup, true),
                                lbReference.object-identifier,
                                true),
                            annotGroup,                                     // source
                            true).                                          // overwrite?
                        assign annotGroup = ?.
                    end.
                
                // ... nor these
                when 'destructor':u or
                when 'procedure':u or
                when 'function':u or
                when 'property':u or
                when 'event':u then
                    if valid-object(annotGroup) then
                    do:
                        JsonConverter:Merge(
                            JsonPropertyHelper:GetObjectValue(              // target
                                JsonPropertyHelper:GetObjectValue(pData, lc(lbReference.reference-type), true),
                                lbReference.object-identifier,
                                true),
                            annotGroup,                                     // source
                            true).                                          // overwrite?
                        assign annotGroup = ?.
                    end.
                
                // temp-tables and datasets, as long as they're PROTECTED or more open
                // otherwise they go who-knows-where
                when 'data-member':u then
                    if valid-object(annotGroup) then
                    do:
                        JsonConverter:Merge(
                            JsonPropertyHelper:GetObjectValue(              //target
                                JsonPropertyHelper:GetObjectValue(pData, 'data':u, true),
                                lbReference.object-identifier,
                                true),
                            annotGroup,                                     //source
                            true).                                          // overwrite?
                        assign annotGroup = ?.
                    end.
                
                // members that support overloading
                when 'constructor':u or
                when 'method':u then
                    if valid-object(annotGroup) then
                    do:
                        assign annoName = '':u
                               delim    = '':u
                               .
                        for each lbParam
                           where lbParam.Source-guid eq lbReference.Source-guid
                             and lbParam.Ref-seq     eq lbReference.Ref-seq
                              by lbParam.Order:
                            assign annoName = substitute('&1&4&2 &3':u,
                                                         annoName,
                                                         lbParam.Parameter-mode,
                                                         lbParam.Parameter-type,
                                                         delim)
                                  delim    = ',':u
                                  .
                        end.
                        
                        JsonConverter:Merge(
                            JsonPropertyHelper:GetObjectValue(      //target
                                JsonPropertyHelper:GetObjectValue(pData, lc(lbReference.reference-type), true),
                                substitute('&1(&2)':u, lbReference.object-identifier, annoName),
                                true),
                            annotGroup,                             //source
                            true).                                  //overwrite?
                        assign annotGroup = ?.
                    end.
            end case.
        end.
        
        // If there are annotations that are written after any public things, add to the compile unit
        if valid-object(annotGroup) then
            JsonConverter:Merge(JsonPropertyHelper:GetObjectValue(pData, 'program':u, true),    //target
                                annotGroup,                                                     // source
                                true).                                                          // overwrite?
    end method.
    
    /* Adds an annotation and its data to a parent group
       
       @param character[2] A group and (optional) subgroup to find the parent
       @param character The annotation name
       @param JsonObject Annotation data 
       @param JsonObject The parent document to which to add the annotations */
    method protected void AddAnnotationToGroup(input pGroup as character extent 2,
                                               input pAnnoName as character,
                                               input pAnnoData as JsonObject,
                                               input pData as JsonObject):
        define variable annoGrp as JsonObject no-undo.
        
        Assert:NotNullOrEmpty(pGroup[1], 'Annotation group').
        Assert:NotNullOrEmpty(pAnnoName, 'Annotation name').
        Assert:NotNull(pData, 'Annotation output').
        
        assign annoGrp = JsonPropertyHelper:GetObjectValue(pData, pGroup[1], true).
        if not pGroup[2] eq ? then
            assign annoGrp = JsonPropertyHelper:GetObjectValue(annoGrp, pGroup[2], true).
        
        AddAnnotationToGroup(annoGrp, pAnnoName, pAnnoData).
    end method.
    
    /* Adds an annotation and its data to a parent group
       
       @param JsonObject The group to which to add an annotation
       @param character The annotation name
       @param JsonObject Annotation data */
    method protected void AddAnnotationToGroup(input pGroup as JsonObject,
                                               input pAnnoName as character,
                                               input pAnnoData as JsonObject):
        define variable groupSet as JsonArray no-undo.
        
        Assert:NotNull(pGroup, 'Annotation group').
        Assert:NotNullOrEmpty(pAnnoName, 'Annotation name').
        
        // if there's more that one annotation with the same name, we add an object per annotation
        // anno: {a:b, c:d}
        // anno: null
        // anno: [{a:b, c:d}, {f:g}, null]
        if pGroup:Has(pAnnoName) then
        case pGroup:GetType(pAnnoName):
            when JsonDataType:ARRAY then
                pGroup:GetJsonArray(pAnnoName)
                          :Add(pAnnoData).
            
            when JsonDataType:OBJECT or
            when JsonDataType:NULL then
            do:
                assign groupSet = new JsonArray().
                groupSet:Add(pGroup:GetJsonObject(pAnnoName)).
                groupSet:Add(pAnnoData).
                pGroup:Set(pAnnoName, groupSet).
            end.
        end case.
        else
            pGroup:Add(pAnnoName, pAnnoData).
    end method.
    
end class.
