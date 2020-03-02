/* *************************************************************************************************************************
Copyright (c) 2019 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : DataRequestValueWriter
    Purpose     : Writes the contents of a IGetDataRequest object based on other inputs         
    Description : 
    Author(s)   : pjudge
    Created     : 2016-12-17
    Notes       : * The ablRef message element determines the JSON property name we create. If we don't have that,
                    we assume the entire input is JSON and overrides the filter
                  * In all cases the mappingType is optional (though nice-to-have)
                  
                  * For the JFP, we consume
                    "msgElem": [
                        {"type": "CONSTANT","name": "JFP",      "ablRef": "mappingType"},
                        {"type": "QUERY",   "name": "filter" }
                    ]
                    
                  * For the ABL pattern, we consume the JFP but in parts (not a whole object)
                    "msgElem": [
                        {"type": "CONSTANT","name": "JFP",      "ablRef": "mappingType"},
                        {"type": "QUERY",   "name": "filter",   "ablRef": "ablFilter"},
                        {"type": "QUERY",   "name": "sort",     "ablRef": "orderBy"},
                        {"type": "QUERY",   "name": "top",      "ablRef": "top"},
                        {"type": "QUERY",   "name": "skip",     "ablRef": "skip"}
                    ]
                  * For a KendoUI pattern, we consume
                    "msgElem": [
                        {"type": "CONSTANT","name": "KENDO",    "ablRef": "mappingType"},
                        {"type": "QUERY",   "name": "filter",   "ablRef": "filter"},
                        {"type": "QUERY",   "name": "sort",     "ablRef": "sort"},
                        {"type": "QUERY",   "name": "top",      "ablRef": "page"},
                        {"type": "QUERY",   "name": "skip",     "ablRef": "pageSize"}
                    ]
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.ICharacterHolder.
using Ccs.Common.Support.ILongcharHolder.
using OpenEdge.Core.KeyValuePair.
using OpenEdge.Web.DataObject.Writer.JsonObjectValueWriter.
using OpenEdge.Web.DataObject.Writer.ObjectValueWriter.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Lang.ParameterList.
using OpenEdge.Core.StringConstant.

class OpenEdge.Web.DataObject.Writer.DataRequestValueWriter inherits ObjectValueWriter:
    // Because we don't want to introduce a hard dependency to the OpenEdge.BusinessLogic namespace into the OpenEdge.Net,
    // we soft-code the references.
    // THIS SHOULD BE REFACTORED
    define static private property FilterParserBuilderType as Progress.Lang.Class no-undo get. set.
    define static private property FilterParserType as Progress.Lang.Class no-undo get. set.
    define private variable mTargetTypeName as character no-undo initial 'Ccs.BusinessLogic.IGetDataRequest':u.
    
    /* The writer to convert strings etc into JSON */
    define private variable mJsonValueWriter as JsonObjectValueWriter no-undo.
    
    /* A parser for string to convert to JSON */
    define private variable mJsonParser as ObjectModelParser no-undo.

    constructor static DataRequestValueWriter():
        assign FilterParserBuilderType = Progress.Lang.Class:GetClass('OpenEdge.BusinessLogic.Filter.FilterParserBuilder':u)
               FilterParserType        = Progress.Lang.Class:GetClass('OpenEdge.BusinessLogic.Filter.FilterParser':u)
               no-error.
        assign error-status:error = false.
    end constructor.
    
    /* Default constructor */
    constructor public DataRequestValueWriter():
        define variable argType as Progress.Lang.Class no-undo.
        
        //super(get-class(IGetDataRequest)).
        super().
        
        assign argType = Progress.Lang.Class:GetClass(mTargetTypeName)
               no-error. 
        // if this fails we will still have Progress.Lang.Object as the ArgumentType
        if valid-object(argType) then
            assign this-object:ArgumentType = argType.
        
        assign mJsonParser        = new ObjectModelParser()
               mJsonValueWriter   = new JsonObjectValueWriter()
               error-status:error = false
               .
    end constructor.
    
    method override public void Open():
        super:Open().
        
        assign mJsonValueWriter:Value = new JsonObject().
    end method.
    
    method override public void Close():
        super:Close().
        
        assign mJsonValueWriter:Value = ?.
    end method.
    
    method override public void Flush():
        // process the the whole input JSON as one thing
        assign this-object:Value = ParseFilter(cast(mJsonValueWriter:Value, JsonObject)).
    end method.
    
    method override public void Write(input pData as Progress.Lang.Object):
        define variable jsonData as JsonConstruct no-undo.
        define variable stringData as longchar no-undo.
        define variable kvp as KeyValuePair no-undo.
        
        case true:
            // Don't assign anything
            when not valid-object(pData) then
                return.
            
            // Simple straight assignment
            // when type-of(pData, IGetDataRequest) then
            when pData:GetClass():IsA(ArgumentType) then
                assign this-object:Value = pData.
            
            when type-of(pData, ICharacterHolder) then
                this-object:Write(cast(pData, ICharacterHolder):Value).
            
            when type-of(pData, ILongcharHolder)  then
                this-object:Write(cast(pData, ILongcharHolder):Value).
            
            when type-of(pData, KeyValuePair) then
            do:
                assign kvp = cast(pData, KeyValuePair).
                if     valid-object(kvp:Value)
                   and (   type-of(kvp:Value, ILongcharHolder)
                        or type-of(kvp:Value, ICharacterHolder))
                then
                do:
                    // if the input data is JSON, then we JSON-ify it
                    assign stringData = dynamic-property(pData, 'Value':u).
                    if    stringData begins StringConstant:CURLY_OPEN
                       or stringData begins '[':u
                    then
                        assign kvp:Value = mJsonParser:Parse(stringData).
                end.
                
                mJsonValueWriter:Write(kvp:Value).
            end.
            
            otherwise
                mJsonValueWriter:Write(pData).
        end case.
    end method.
    
    method override public void Write(input pData as longchar):
        if    pData begins StringConstant:CURLY_OPEN
           or pData begins '[':u
        then
            this-object:Write(mJsonParser:Parse(pData)).
        else
            mJsonValueWriter:Write(pData).
    end method.
    
    method override public void Write(input pData as character):
        if    pData begins StringConstant:CURLY_OPEN
           or pData begins '[':u
        then
            this-object:Write(mJsonParser:Parse(pData)).
        else
            mJsonValueWriter:Write(pData).
    end method.
    
    /* Parses JSON to produce a IGetDataRequest object.
        
       This is a reflection-based method that we want to replace at some point with the 
       strongly-typed one below 
       
       @param JsonObject Filter data encoded as JSON
       @return Progress.Lang.Object A filter based on the JSON input */
    method protected Progress.Lang.Object ParseFilter(input pValue as JsonObject):
        define variable parserBuilder as Progress.Lang.Object no-undo.
        define variable parser as Progress.Lang.Object no-undo.
        define variable dataRequest as Progress.Lang.Object no-undo.
        define variable paramList as Progress.Lang.ParameterList no-undo.
        
        if    not valid-object(FilterParserBuilderType) 
           or not valid-object(FilterParserType)
        then
            return dataRequest.
        
        assign paramList = new ParameterList(1).
        paramList:SetParameter(1, 'class Progress.Json.ObjectModel.JsonObject':u, 'input':u, pValue).
        
        assign parserBuilder = FilterParserBuilderType:Invoke('Build':u, paramList)
               parser        = FilterParserBuilderType:GetPropertyValue(parserBuilder, 'Parser':u)
               dataRequest   = FilterParserType:Invoke(parser, 'Parse':u, paramList)
               .
        return dataRequest.
    end method.
    
    /* Parses JSON to produce a IGetDataRequest object 
       
       This is a strongly-typed method.
       
       @param JsonObject Filter data encoded as JSON
       @return IGetDataRequest A filter based on the JSON input 
    method protected IGetDataRequest ParseFilter(input pValue as JsonObject):
        define variable filterParser as FilterParser no-undo.
        define variable dataRequest as IGetDataRequest no-undo.
        
        assign filterParser = FilterParserBuilder:Build(pValue):Parser.
        if valid-object(filterParser) then
            assign dataRequest = filterParser:Parse(pValue).
        
        return dataRequest.
    end method.     */
    
end class.
