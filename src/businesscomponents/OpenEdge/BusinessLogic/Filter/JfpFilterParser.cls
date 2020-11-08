/************************************************
Copyright (c)  2016 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : JfpFilterParser
    Purpose     : Parse for JSON data in the JSON Filter Pattern
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Dec 07 14:11:10 EST 2016
    Notes       : * https://documentation.progress.com/output/ua/OpenEdge_latest/index.html#page/dvwsv/updating-business-entities-for-access-by-telerik.html
                  * ablFilter — Contains the text of an ABL WHERE string (not including the WHERE keyword itself) on which to filter the 
                                 OpenEdge BusinessEntity query that returns the result set, as in the following examples:
                        *"ablFilter" : "(State = 'MA') OR (State = 'GA')"
                        *"ablFilter" : "Name BEGINS 'A'"
                    Saved into TableRequest[n]:QueryDefinition:QuerySelection
                  * orderBy - contains an ABL BY sort phrase.
                    Saved into TableRequest[n]:QueryDefinition:QuerySort
                  * top - a numeric value for the number of records returned.
                    Saved into TableRequest[n]:QueryDefinition:NumRecords
                  * skip - the number of records to skip
                    Saved into TableRequest[n]:QueryDefinition:Skip
                  * id - A unique local id. We used it for page context
                    Saved into TableRequest[n]:QueryDefinition:PagingContext
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.BusinessLogic.IGetDataTableRequest.
using OpenEdge.BusinessLogic.Filter.AblFilterParser.
using OpenEdge.BusinessLogic.GetDataTableRequest.
using OpenEdge.BusinessLogic.QueryDefinition.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.

class OpenEdge.BusinessLogic.Filter.JfpFilterParser inherits AblFilterParser: 
    
    /* Default constructor */
    constructor public JfpFilterParser(): 
        super().
    end constructor.
    
    /* Constructor.
       
       @param character (mandatory) A table name for which to construct the filter */
    constructor public JfpFilterParser(input pTable as character):
        super(pTable).
    end constructor.
    
    /* Constructor.
       
       @param character[] (mandatory) An array of table name for which to construct the filter */
    constructor public JfpFilterParser(input pTable as character extent):
        super(pTable).
    end constructor.
    
    /* Reads a single table's request.
        
       This method knows which properties in the input JSON are for the where clause, for the sort-by etc
       
       @param character The table name to which this filter applies
       @param JsonObject The input filter
       @return IGetDataTableRequest A single table Get Request */
    method override protected IGetDataTableRequest ParseTableRequest(input pTable as character,
                                                                     input pData as JsonObject):
        define variable tableRequest as GetDataTableRequest no-undo.
        define variable qryDef as QueryDefinition no-undo.
        
        assign tableRequest = new GetDataTableRequest(pTable).    // we don't know the table name here
        
        if not valid-object(pData) then
            return tableRequest.
        
        assign qryDef                       = new QueryDefinition()
               tableRequest:QueryDefinition = qryDef
               .
        if     pData:Has('orderBy':u)
           and pData:GetType('orderBy':u) eq JsonDataType:STRING
        then
            assign qryDef:QuerySort = ParseSortString(pData:GetCharacter('orderBy':u)).
        
        if     pData:Has('ablFilter':u)
           and pData:GetType('ablFilter':u) eq JsonDataType:STRING
        then
            assign qryDef:QuerySelection = ParseWhereString(pData:GetCharacter('ablFilter':u)).
        
        if     pData:Has('id':u)
           and pData:GetType('id':u) eq JsonDataType:STRING
        then
            assign tableRequest:PagingContext = pData:GetCharacter('id':u).
        
        if     pData:Has('top':u)
           and pData:GetType('top':u) eq JsonDataType:NUMBER
        then
            assign tableRequest:NumRecords = pData:GetInt64('top':u).
        
        if     pData:Has('skip':u)
           and pData:GetType('skip':u) eq JsonDataType:NUMBER
        then
            assign tableRequest:Skip = pData:GetInt64('skip':u).
        
        return cast(tableRequest, IGetDataTableRequest).
    end method.
    
end class.