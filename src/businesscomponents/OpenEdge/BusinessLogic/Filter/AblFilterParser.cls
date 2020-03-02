/************************************************
Copyright (c)  2018 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : AblFilterParser
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Dec 07 14:11:10 EST 2016
    Notes       : * String with "WHERE"... 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.BusinessLogic.IGetDataRequest.
using Ccs.BusinessLogic.IGetDataTableRequest.
using Ccs.BusinessLogic.IQueryEntry.
using Ccs.BusinessLogic.IQuerySortEntry.
using Ccs.BusinessLogic.JoinEnum.
using Ccs.BusinessLogic.QueryOperatorEnum.
using Ccs.BusinessLogic.SortOrderEnum.
using Ccs.Common.Support.ICharacterArrayHolder.
using Ccs.Common.Support.ICharacterHolder.
using Ccs.Common.Support.ILongcharArrayHolder.
using Ccs.Common.Support.ILongcharHolder.
using Ccs.Common.Support.IPrimitiveHolder.
using OpenEdge.BusinessLogic.Filter.FilterParser.
using OpenEdge.BusinessLogic.GetDataRequest.
using OpenEdge.BusinessLogic.GetDataTableRequest.
using OpenEdge.BusinessLogic.QueryDefinition.
using OpenEdge.BusinessLogic.QueryGroup.
using OpenEdge.BusinessLogic.QueryOperatorHelper.
using OpenEdge.BusinessLogic.QueryPredicate.
using OpenEdge.BusinessLogic.QuerySortEntry.
using OpenEdge.Core.Assert.
using OpenEdge.Core.Collections.IList.
using OpenEdge.Core.Collections.List.
using OpenEdge.Core.Collections.ObjectStack.
using OpenEdge.Core.String.
using OpenEdge.Core.StringConstant.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.AppError.

class OpenEdge.BusinessLogic.Filter.AblFilterParser inherits FilterParser:
    
    /* Default constructor */
    constructor public AblFilterParser():
        super().
    end constructor.
    
    /* Constructor.
       
       @param longchar (mandatory) A table name for which to construct the filter */
    constructor public AblFilterParser(input pTable as character):
        super(pTable).
    end constructor.
    
    /* Constructor.
       
       @param longchar[] (mandatory) An array of table name for which to construct the filter */
    constructor public AblFilterParser(input pTable as character extent):
        super(pTable).
    end constructor.
    
    method protected IQuerySortEntry extent ParseSortString(input pSortBy as longchar):
        define variable querySortEntry as  IQuerySortEntry extent no-undo.
        define variable sortOrder as SortOrderEnum no-undo.
        define variable sortDirection as character no-undo.
        define variable wordCnt as integer no-undo.
        define variable wordMax as integer no-undo.
        define variable fieldName as character no-undo.
        
        if String:IsNullOrEmpty(pSortBy) then
            return querySortEntry.
        
        assign wordMax                = num-entries(pSortBy)
               extent(querySortEntry) = wordMax
               .
        do wordCnt = 1 to wordMax:
            assign fieldName = trim(entry(wordCnt, pSortBy))
                   sortOrder = SortOrderEnum:Ascending
                   .
            if num-entries(fieldName, StringConstant:SPACE) gt 1 then
            do:
                assign sortDirection = trim(entry(2, fieldName, StringConstant:SPACE))
                       fieldName     = trim(entry(1, fieldName, StringConstant:SPACE))
                       .
                if sortDirection begins 'DESC':u then
                    assign sortOrder = SortOrderEnum:Descending.
            end.
            
            assign querySortEntry[wordCnt] = new QuerySortEntry(fieldName, sortOrder).
        end.
        
        return querySortEntry.
    end method.
    
    method protected IQueryEntry ParseWhereString(input pWhere as longchar):
        define variable qryGroup as QueryGroup no-undo.
        define variable parentGroup as QueryGroup no-undo.
        define variable groupStack as ObjectStack no-undo.
        define variable qryPredicate as QueryPredicate no-undo.
        define variable wordCnt as integer no-undo.
        define variable wordMax as integer no-undo.
        define variable word as character no-undo. 
        define variable fieldName as character no-undo.
        define variable operator as QueryOperatorEnum no-undo.
        define variable fieldValue as IPrimitiveHolder no-undo.
        define variable chrPos as integer extent 3 no-undo.
        define variable chrValue as character no-undo.
        define variable haveName as logical no-undo.
        define variable haveOperator as logical no-undo.
        define variable haveValue as logical no-undo.
        define variable entryList as IList no-undo.
        define variable operStartPos as integer no-undo.
        define variable operLen as integer no-undo.
        
        // WHERE table.field<operator><value> {and|or} 
        //
        assign pWhere       = trim(pWhere, 'WHERE ':u)
               wordMax      = num-entries(pWhere, StringConstant:SPACE) 
               haveName     = no
               haveOperator = no
               haveValue    = no
               .
        if String:IsNullOrEmpty(pWhere) then
            return qryPredicate.
        
        WORD-LOOP:
        do wordCnt = 1 to wordMax:
            assign word   = entry(wordCnt, pWhere, StringConstant:SPACE)
                   chrPos = 0
                   .
            case word:
                // inter-phrase delimiter; this table is done
                when ',':u then
                do:
                    assign haveName     = no
                           haveOperator = no
                           haveValue    = no
                           .
                    leave WORD-LOOP.
                end.
                
                // explicit groups
                // @todo().
                when '(':u then
                do:
                    // no-op for now
                    //groupStack:Push(qryGroup).
                end.
                    
                when ')':u then
                do:
                    //assign parentGroup = cast(groupStack:Pop(), QueryGroup).
                    // no-op for now
                end.
                
                // special cases that we (for now) IGNORE
                //@todo().
                when 'TRUE'  or
                when 'FALSE' then
                do:
                    assign haveName     = no
                           haveOperator = no
                           haveValue    = no
                           .
                    leave WORD-LOOP.
                end.
                
                // these signal the end of a query predicate 
                when 'AND' or 
                when 'OR':u then
                do:
                    if not valid-object(qryGroup) then
                        assign qryGroup  = new QueryGroup()
                               entryList = new List()
                               .
                    //build a group
                    assign qryPredicate:Join = JoinEnum:GetEnum(word).
                    entryList:Add(qryPredicate).
                    
                    assign haveName     = no
                           haveOperator = no
                           haveValue    = no
                           .
                end.    // JOIN word
                
                when 'NO-LOCK' or
                when 'SHARE-LOCK' or
                when 'EXCLUSIVE-LOCK' then
                    assign haveName     = no
                           haveOperator = no
                           haveValue    = no
                           .
                
                // OPERATOR word
                when 'begins':u            or
                when 'contains':u          or
                when '=':u  or when 'eq':u or
                when '<>':u or when 'ne':u or
                when '>':u  or when 'gt':u or
                when '>=':u or when 'ge':u or
                when '<':u  or when 'lt':u or
                when '<=':u or when 'le':u then
                    assign operator     = QueryOperatorHelper:ToEnum(word)
                           haveOperator = true
                           .
                
                // may be a field name, a name+operator, a name+operator+value,
                // or an operator+value
                otherwise
                do:
                    /* figure out if there's an embedded operator 
                       these are all valid phrases
                           custnum >123
                        or custnum> 123
                        or custnum>123
                        or name>"123"
                        or name >"123"
                        or name> "123"  */
                    
                    // strip off ( and ) for now
                    assign word = trim(word, '(':u)
                           word = trim(word, ')':u)
                           .
                    // If this is a quoted value then it can't be an operator    
                    // get the first instance of a quote symbol
                    assign chrPos[1] = index(word, StringConstant:DOUBLE_QUOTE)
                           chrPos[2] = index(word, StringConstant:SINGLE_QUOTE)
                           chrPos[3] = 0
                           .
                    // save the value
                    if chrPos[1] + chrPos[2] gt 0 then
                    do:
                        //one of these must be > 0
                        if chrPos[1] eq 0 then
                            assign chrPos[1] = chrPos[2]
                                   chrPos[3] = r-index(word, StringConstant:SINGLE_QUOTE)
                                   .
                        else
                        if chrPos[2] eq 0 then
                            assign chrPos[2] = chrPos[1]
                                   chrPos[3] = r-index(word, StringConstant:DOUBLE_QUOTE)
                                   . 
                        // we have both quotes; the first one is the string quoter; the other is the data 
                        else
                        if chrPos[1] gt chrPos[2] then
                            assign chrPos[3] = r-index(word, StringConstant:SINGLE_QUOTE). 
                        else
                            assign chrPos[3] = r-index(word, StringConstant:DOUBLE_QUOTE). 
                        
                        // Use chrPos[1] for the start pos of the quote
                        // chrPos[3] is the pos of the last quote (s/be end-of word) whether single or double
                        assign chrPos[1]  = min(chrPos[1], chrPos[2])
                               chrValue   = substring(word, chrPos[1] + 1, chrPos[3] - chrPos[1] - 1)
                               fieldValue = new String(chrValue)
                               haveValue  = true
                               // remove the value and pass the rest of the word along
                               word       = substring(word, 1, chrPos[1] - 1)
                               // reset for any operators
                               chrPos     = 0
                               .
                    end.    // quoted
                    
                    // first operator index
                    if not haveOperator then
                        assign chrPos[1] = index(word, '<':u)
                               chrPos[2] = index(word, '>':u)
                               chrPos[3] = index(word, '=':u)
                               .
                    // There is an operator in here somewhere 
                    if chrPos[1] + chrPos[2] + chrPos[3] gt 0 then
                    do:
                        // EQ
                        if chrPos[1] + chrPos[2] eq 0 then
                            assign operator     = QueryOperatorEnum:Eq
                                   operStartPos = chrPos[3]
                                   operLen      = 1
                                   .
                        else
                        // LT or GT or NE
                        if chrPos[3] eq 0 then
                        do:
                            if chrPos[1] eq 0 then
                                assign operator     = QueryOperatorEnum:Gt
                                       operStartPos = chrPos[2]
                                       operLen      = 1
                                       .
                            else
                            if chrPos[2] eq 0 then
                                assign operator     = QueryOperatorEnum:Lt
                                       operStartPos = chrPos[1]
                                       operLen      = 1
                                       .
                            else
                                assign operator     = QueryOperatorEnum:Ne
                                       operStartPos = chrPos[1]
                                       operLen      = 2
                                       .
                        end.    // no EQ
                        else
                        // GE
                        if chrPos[1] eq 0 then
                            assign operator     = QueryOperatorEnum:Ge
                                   operStartPos = chrPos[2]
                                   operLen      = 2
                                   .  
                        else
                        //LE
                        if chrPos[2] eq 0 then
                            assign operator     = QueryOperatorEnum:Le
                                   operStartPos = chrPos[1]
                                   operLen      = 2
                                   .
                        // Is the name a leading portion?
                        if not haveName then
                            assign fieldName = substring(word, 1, operStartPos - 1)
                                   haveName  = length(fieldName) gt 0
                                   .
                        // chop off the operator and continue
                        assign haveOperator = valid-object(operator).
                        
                        // if this word is of the format "field.name=" with no value, then don't try
                        // to extract a value
                        if length(substring(word, operStartPos + operLen + 1)) gt 0 then
                            next WORD-LOOP.
                        
                        // we have a value
                        assign word = substring(word, operStartPos + operLen).
                    end.    // there is an operator
                    
                    // all that's in the word now should be the value.
                    // haveValue may be TRUE from earlier code.
                    if not haveName then
                        assign fieldName = word
                               haveName  = true
                               .
                    else
                    if not haveValue then
                    do:
                        // extract the nul values
                        if word eq '?':u then
                            assign word = ?.
                        
                        assign fieldValue = new String(word)
                               haveValue  = true
                               .
                    end.
                end.    //otherwise
            end case.   // a word in this phrase
            
            // create a new predicate and add to a group/set if needed
            if     haveName
               and haveOperator
               and haveValue
            then
                assign qryPredicate = new QueryPredicate(fieldName, operator, fieldValue)
                       haveName     = no
                       haveOperator = no
                       haveValue    = no
                       .
        end.    // WORD-LOOP:
        
        // we return one of an IQueryPredicate (single clause) or an IQueryGroup (many clauses) 
        if valid-object(qryGroup) then
        do:
            assign qryGroup:Entries = cast(entryList:ToArray(), IQueryEntry).
            return qryGroup.
        end.
        else
            return qryPredicate.
    end method.
    
    /* Parses an SORT-BY phrase and returns an array of IQuerySortEntry objects.
       
       @param character The SORT-BY phrase
       @return IQuerySortEntry[] An array of sort phrases. An indeterminate array is returned if the input phrase is empty */
    method override public IQuerySortEntry extent ParseSortBy(input pSortBy as Progress.Lang.Object):
        define variable qrySort as IQuerySortEntry extent no-undo.
        define variable sortByString as character no-undo.
        define variable sortByArray as character extent no-undo.
        define variable cnt as integer no-undo.
        define variable loop as integer no-undo.
        
        case true:
            when not valid-object(pSortBy) then
                return qrySort.
            
            when type-of(pSortBy, ILongcharHolder)  or
            when type-of(pSortBy, ICharacterHolder) then
                assign sortByString = dynamic-property(pSortBy, 'Value':u)
                       qrySort      = ParseSortString(sortByString)
                       .
            
            when type-of(pSortBy, ICharacterArrayHolder) or
            when type-of(pSortBy, ILongcharArrayHolder) then
            do:
                assign sortByArray = dynamic-property(pSortBy, 'Value':u).
                if     not cnt eq ?
                   and cnt ge 1
                then
                    assign cnt = extent(sortByArray).
                
                do loop = 1 to cnt:
                    assign sortByString = sortByString + StringConstant:SPACE + sortByArray[loop].
                end.
                assign qrySort = ParseSortString(sortByString).
            end.
            
            otherwise
                return qrySort.
        end case.
    end method.
    
    /* Parses where/filter phrase and returns an IQueryEntry object for a single table
       
       @param P.L.Object The filter/where clause phrase
       @return IQueryEntry The query entry.We return one of an IQueryPredicate (single clause) 
                           or an IQueryGroup (many clauses) */
    method override public IQueryEntry ParseWhere(input pWhere as Progress.Lang.Object):
        define variable whereString as character no-undo.
        define variable qryEntry as IQueryEntry no-undo.
        define variable qryGrp as QueryGroup no-undo.
        define variable cnt as integer no-undo.
        define variable loop as integer no-undo.
        define variable stringData as longchar extent no-undo.
        
        case true:
            when not valid-object(pWhere) then
                return qryEntry.
            
            when type-of(pWhere, ILongcharHolder)  or
            when type-of(pWhere, ICharacterHolder) then
                assign whereString  = dynamic-property(pWhere, 'Value':u)
                       qryEntry     = ParseWhereString(whereString)
                       .
            
            when type-of(pWhere, ICharacterArrayHolder) or
            when type-of(pWhere, ILongcharArrayHolder) then
            do:
                assign stringData = dynamic-property(pWhere, 'Value':u) 
                       cnt        = extent(stringData)
                       .
                if cnt eq 1 then
                    assign qryEntry = ParseWhereString(string(stringData[1])).
                else
                if not cnt eq ? then
                do:
                    assign qryGrp = new QueryGroup(cnt).
                    do loop = 1 to cnt:
                        assign qryEntry = ParseWhereString(string(stringData[loop])).
                        //yuk, but the interfaces are defined READ-ONLY
                        if type-of(qryEntry, QueryPredicate) then
                            assign cast(qryEntry, QueryPredicate):Join = JoinEnum:And.
                        else
                        if type-of(qryEntry, QueryGroup) then
                            assign cast(qryEntry, QueryGroup):Join = JoinEnum:And.
                    end.
                    // return the groyup, not the predicate
                    assign qryEntry = qryGrp.
                end.
            end.
            
            otherwise
                return qryEntry.
        end case.
        
        return qryEntry.
    end method.
    
    /* Reads and processes (parses) a complete data filter.
       
       @param longchar The filter data
       @param IGetDataRequest A new filter object 
    method override public IGetDataRequest Parse(input pData as longchar):
        define variable dataRequest as GetDataRequest no-undo.
        define variable qryDef as QueryDefinition no-undo.
        define variable tableRequest as GetDataTableRequest no-undo.
        
        assign dataRequest                       = new GetDataRequest(1)
               tableRequest                      = new GetDataTableRequest(FilterTable[1])
               dataRequest:TableRequests[1]      = tableRequest
               qryDef                            = new QueryDefinition()
               tableRequest:QueryDefinition      = qryDef
               qryDef:QuerySelection             = ParseWhereString(string(pData))
               .
        return cast(dataRequest, IGetDataRequest).
    end method.
       */
    
    /* Reads and processes (parses) the filter.
       
       @param P.L.Object The filter data
       @param IGetDataRequest A new filter object */
    method override public IGetDataRequest Parse(input pData as Progress.Lang.Object):
        define variable dataRequest as GetDataRequest no-undo.
        define variable qryDef as QueryDefinition no-undo.
        define variable tableRequest as GetDataTableRequest no-undo.
        define variable cnt as integer no-undo.
        define variable loop as integer no-undo.
        define variable stringData as longchar extent no-undo.
        
        assign dataRequest = new GetDataRequest().
        
        case true:
            when not valid-object(pData) then
                return dataRequest.
            
            when type-of(pData, ICharacterHolder) or
            when type-of(pData, ILongcharHolder) then
                assign dataRequest                       = new GetDataRequest(1)
                       tableRequest                      = new GetDataTableRequest(FilterTable[1])
                       dataRequest:TableRequests[1]      = tableRequest
                       qryDef                            = new QueryDefinition()
                       tableRequest:QueryDefinition      = qryDef
                       qryDef:QuerySelection             = ParseWhereString(dynamic-property(pData, 'Value':u))
                       .
            
            when type-of(pData, ICharacterArrayHolder) or
            when type-of(pData, ILongcharArrayHolder)  then
            do:
                assign stringData = dynamic-property(pData, 'Value':u)
                       cnt        = extent(stringData)
                       .
                if     not cnt eq ?
                   and cnt ge 1
                then
                    assign extent(dataRequest:TableRequests) = cnt.
                
                do loop = 1 to cnt:
                    assign tableRequest                      = new GetDataTableRequest(FilterTable[loop])
                           dataRequest:TableRequests[loop]   = tableRequest
                           qryDef                            = new QueryDefinition()
                           tableRequest:QueryDefinition      = qryDef
                           qryDef:QuerySelection             = ParseWhereString(string(stringData[loop]))
                           .
                end.
            end.
            
            when type-of(pData, JsonObject) then
                assign extent(dataRequest:TableRequests) = 1
                       dataRequest:TableRequests[1]      = ParseTableRequest(FilterTable[1],
                                                                             cast(pData, JsonObject))
                       .
            
            when type-of(pData, JsonArray) then
            do:
                assign cnt = cast(pData, JsonArray):Length.
                if     not cnt eq ?
                   and cnt ge 1
                then
                    assign extent(dataRequest:TableRequests) = cnt.
                
                do loop = 1 to cnt:
                    assign dataRequest:TableRequests[loop] = ParseTableRequest(FilterTable[1],
                                                                               cast(pData, JsonArray):GetJsonObject(loop)).
                end.
            end.
            
            otherwise
                return error new AppError(
                        substitute('Unsupported object type: &1', pData:GetClass():TypeName)
                        , 0).
        end case.
        
        return cast(dataRequest, IGetDataRequest).
    end method.
        
    /* Reads a single table's request
       
       This method knows which properties in the input JSON are for the where clause, for the sort-by etc
       
       @param character The table name to which this filter applies
       @param JsonObject The input filter
       @return IGetDataTableRequest A single table Get Request */
    method protected IGetDataTableRequest ParseTableRequest(input pTable as character,
                                                            input pData as JsonObject):
        define variable tableRequest as GetDataTableRequest no-undo.
        define variable qryDef as QueryDefinition no-undo.
        
        Assert:NotNull(pTable, 'Table name').
        
        assign tableRequest = new GetDataTableRequest(pTable).
        
        if not valid-object(pData) then
            return tableRequest.
        
        assign qryDef                       = new QueryDefinition()
               tableRequest:QueryDefinition = qryDef
               .
        if     pData:Has('WHERE':u) 
           and pData:GetType('WHERE':u) eq JsonDataType:STRING
        then
            assign qryDef:QuerySelection = ParseWhereString(pData:GetCharacter('WHERE':u)).
        
        return cast(tableRequest, IGetDataTableRequest).
    end method.
    
end class.