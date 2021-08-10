/************************************************
Copyright (c) 2018, 2020-2021 by Progress Software Corporation. All rights reserved.
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
using Ccs.BusinessLogic.IQueryGroup.
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
    
    /* Parses an ABL BY expression into an array of IQuerySortEntry.
       
       If the string is malformed (ie can't be used as an ABL sort), then an indeterminate array
       is returned. mallformed might be something like "by eq 21" or "by".
       
       @param longchar The standard ABL BY expression. This can be a complete WHERE ... BY string or just the BY portion
       @return IQuerySortEntry[] An array of sort entries. Will be indeterminate if the input value is empty or null,
                                 or if the string isn't of the format "BY <field> [BY <field-2>]"       */
    method protected IQuerySortEntry extent ParseSortString(input pSortBy as longchar):
        define variable querySortEntry as IQuerySortEntry extent no-undo.
        define variable sortOrder as SortOrderEnum no-undo.
        define variable elems as integer no-undo.
        define variable endPos as integer no-undo.
        define variable startPos as integer no-undo.
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        define variable fieldName as character no-undo.
        define variable sortDirection as character no-undo.
        define variable word as character no-undo.
        
        if String:IsNullOrEmpty(pSortBy) then
            return querySortEntry.
        
        // pad the sort phrase with a space to make our calculations easier
        assign pSortBy  = StringConstant:SPACE + pSortBy
               startPos = index(pSortBy, ' by ':u)
               elems     = 0
               .
        EXPR-LOOP:
        do while startPos gt 0:
            // if there are quotes after the " by " then this is a field name
            assign endPos = index(pSortBy, StringConstant:DOUBLE_QUOTE, startPos + 4).
            if endPos eq 0 then
                assign endPos = index(pSortBy, StringConstant:SINGLE_QUOTE, startPos + 4).
            if endPos eq 0 then
                // if there are quotes after the " by " then this is part of some function
                assign endPos = index(pSortBy, ')':u, startPos + 4).
            if not endPos eq 0 then
            do:
                // is there a by clause?
                assign startPos = index(pSortBy, ' by ':u, endPos).
                next EXPR-LOOP.
            end.
            // we're at the start of the 'real' BY expression
            assign pSortBy  = substring(pSortBy, startPos + 1)
                   startPos = 0
                   .
        end.    //EXPR-LOOP
        
        assign pSortBy = trim(replace(pSortBy, '  ':u, StringConstant:SPACE))
               cnt     = num-entries(pSortBy, StringConstant:SPACE)
               .
        WORD-LOOP:
        do loop = 1 to cnt:
            assign word = entry(loop, pSortBy, StringConstant:SPACE).
            
            // if there are double spaces, skip
            if word eq '':u then
                next WORD-LOOP.
            
            // we want to start at BY and go from there
            // if this is not a BY then we've got a malformed string,
            // and we don't return anything
            if not word eq 'by':u then
            do:
                assign extent(querySortEntry) = ?.
                return querySortEntry.
            end.
            
            // BY <field> or BY <field> <order>
            assign fieldName = entry(loop + 1, pSortBy, StringConstant:SPACE).
            //is there an order?
            if (loop + 2) le cnt then
                assign sortDirection = entry(loop + 2, pSortBy, StringConstant:SPACE).
            else
                assign sortDirection = '':u.
            
            // another by or end-of-string
            if sortDirection begins 'desc':u then
                assign sortOrder = SortOrderEnum:Descending
                       loop      = loop + 2
                       .
            else
            if sortDirection begins 'asc':u then
                assign sortOrder = SortOrderEnum:Ascending
                       loop      = loop + 2
                       .
            else
                assign sortOrder = SortOrderEnum:Ascending
                       loop     = loop + 1
                       .
            assign elems                  = elems + 1
                   extent(querySortEntry) = elems
                   querySortEntry[elems]  = new QuerySortEntry(fieldName, sortOrder)
                   .
        end.    //WORD-LOOP
        
        return querySortEntry.
    end method.
    
    /* Parses a where string into a query entry - either a group or a predicate.
       
       If the parsing runs into problems (eg a malformed string) a null IQueryEntry is returned.
       Splitting of a string into groups using "(<grp-1>)" is not supported.
       
       @param longchar The WHERE string to parse into parts
       @return IQueryEntry A query group, query predicate or unknown (if the string cannot be parsed) */
    method protected IQueryEntry ParseWhereString(input pWhere as longchar):
        define variable qryPredicate as QueryPredicate no-undo.
        define variable operator as QueryOperatorEnum no-undo.
        define variable fieldValue as IPrimitiveHolder no-undo.
        define variable qryGroup as QueryGroup no-undo.
        define variable parentGroup as QueryGroup no-undo.
        define variable topGroup as QueryGroup no-undo.
        define variable haveValue as logical initial no no-undo.
        define variable haveName as logical initial no no-undo.
        define variable haveOperator as logical initial no no-undo.
        define variable inSingleQuotes as logical initial no no-undo.
        define variable inDoubleQuotes as logical initial no no-undo.
        define variable isQuotedNull as logical initial no no-undo.
        define variable isTilde as logical initial no no-undo.
        define variable fieldName as character no-undo.
        define variable chrValue as character no-undo.
        define variable strValue as character no-undo.
        define variable nextChr as character no-undo.
        define variable prevChr as character no-undo.
        define variable loop as integer no-undo.
        define variable len as integer no-undo.
        define variable joinWith as JoinEnum no-undo.
        define variable entries as IQueryEntry extent no-undo.
        define variable joinEnumNames as character no-undo.
        
        // WHERE table.field<operator><value> {and|or|,}
        assign pWhere = trim(pWhere).
        // don't use TRIM since it doesn't always do what you think with multi-character "trim-chars" expressions.
        if pWhere begins 'where':u then
            assign pWhere = trim(substring(pWhere, 6)).
        
        assign len = length(pWhere).
        if String:IsNullOrEmpty(pWhere) then
            return qryPredicate.
        
        CHR-LOOP:
        do loop = 1 to len
        on error undo, throw:
            // read chars until we hit a space or an operator.
            assign chrValue = substring(pWhere, loop, 1)
                   isTilde  = (chrValue eq StringConstant:TILDE)
                   .
            // complete the string, since we'll process it below
            if loop eq len then
            do:
                assign nextChr = '':u.
                // are we quoted? Close quotes if necessary
                if chrValue eq StringConstant:SINGLE_QUOTE then
                do:
                    if not prevChr eq StringConstant:TILDE
                    and inSingleQuotes
                    then
                        assign inSingleQuotes = no
                               isQuotedNull   = (strValue eq '?':u)
                               .
                    else
                    if  not prevChr eq StringConstant:TILDE
                    and not inDoubleQuotes
                    then
                        assign inSingleQuotes = yes
                               strValue       = strValue + chrValue
                               .
                end.
                else
                if chrValue eq StringConstant:DOUBLE_QUOTE then
                do:
                    if not prevChr eq StringConstant:TILDE
                    and inDoubleQuotes
                    then
                        assign inDoubleQuotes = no
                               isQuotedNull   = (strValue eq '?':u)
                               .
                    else
                    if not prevChr eq StringConstant:TILDE
                    and not inSingleQuotes
                    then
                        assign inDoubleQuotes = yes
                               strValue       = strValue + chrValue
                               .
                end.
                else
                if chrValue eq ')':u
                and not inDoubleQuotes
                and not inSingleQuotes
                then
                do:
                    /* NO-OP */
                end.
                else
                    assign strValue = strValue + chrValue.
            end.    // loop= len
            else
                assign nextChr = substring(pWhere, loop + 1, 1).
            
            // we're at the end of a 'word'; strValue (usually) contains the word
            if chrValue eq StringConstant:SPACE
            or loop eq len
            then
            do:
                // we're in a quoted value
                if inDoubleQuotes
                or inSingleQuotes
                then
                do:
                    assign strValue = strValue + chrValue.
                    next CHR-LOOP.
                end.
                else
                // if this is the second space in a row, it's meaningless. skip unless we're at the end of the
                // string. In this case the actual last character may be a quote, that we're ignoring, and the
                // quoted value is blank
                if strValue eq StringConstant:SPACE
                and not loop eq len
                then
                    next CHR-LOOP.
                else
                // if we hit a BY phrase, or we're at a new stanza, we're done with this WHERE
                if strValue eq 'by':u
                or strValue eq ',':u
                then
                do:
                    // if the word "by" is a field value then continue
                    if valid-object(qryPredicate)
                    or valid-object(qryGroup)
                    then
                    do:
                        assign strValue = '':u.
                        leave CHR-LOOP.
                    end.
                end.
                else
                if strValue eq 'and':u
                or strValue eq 'or':u
                or strValue eq 'not':u
                then
                do:
                    assign joinWith = GetJoin(strValue, joinWith).
                    
                    if not valid-object(qryGroup) then
                        assign qryGroup    = new QueryGroup()
                               topGroup    = qryGroup
                               parentGroup = qryGroup
                               .
                    AddToGroup(qryGroup, qryPredicate, ?).
                    assign qryPredicate = ?
                           strValue     = '':u
                           .
                    //nothing more to do here
                    next CHR-LOOP.
                end.    // AND|OR|NOT
                
                //else
                
                // deal with words
                if not haveName then
                do:
                    if trim(strValue) eq string(JoinEnum:Not) then
                        assign joinWith = JoinEnum:Not.
                    else
                        assign fieldName = strValue
                               haveName  = yes
                               .
                    assign strValue = '':u.
                end.
                else
                if not haveOperator then
                    assign operator     = QueryOperatorHelper:ToEnum(strValue)
                           haveOperator = yes
                           strValue     = '':u
                           .
                else
                if not haveValue then
                    assign haveValue    = yes
                           fieldValue   = GetFieldValue(strValue, isQuotedNull, operator)
                           strValue     = '':u
                           isQuotedNull = no
                           .
            end.    // SPACE or end of loop
            else
            do:
                // are we quoted?
                if chrValue eq StringConstant:SINGLE_QUOTE then
                do:
                    if not prevChr eq StringConstant:TILDE
                    and inSingleQuotes
                    then
                        assign inSingleQuotes = no
                               isQuotedNull   = (strValue eq '?':u)
                               fieldValue     = GetFieldValue(strValue, isQuotedNull, operator)
                               strValue       = '':u
                               isQuotedNull   = no
                               haveValue      = yes
                               .
                    else
                    if not prevChr eq StringConstant:TILDE
                    and not inDoubleQuotes
                    then
                        assign inSingleQuotes = yes
                               isQuotedNull   = no
                               .
                    else
                        assign strValue = strValue + chrValue.
                end.    // '
                else
                if chrValue eq StringConstant:DOUBLE_QUOTE then
                do:
                    if not prevChr eq StringConstant:TILDE
                    and inDoubleQuotes then
                        assign inDoubleQuotes = no
                               isQuotedNull   = (strValue eq '?':u)
                               fieldValue     = GetFieldValue(strValue, isQuotedNull, operator)
                               strValue       = '':u
                               isQuotedNull   = no
                               haveValue      = yes
                               .
                    else
                    if not prevChr eq StringConstant:TILDE
                    and not inSingleQuotes then
                        assign inDoubleQuotes = yes
                               isQuotedNull   = no
                               .
                    else
                        assign strValue = strValue + chrValue.
                end.    // "
                else
                if chrValue eq '(':u then
                do:
                    if not inSingleQuotes
                    and not inDoubleQuotes
                    then
                    do:
                        // If there are preceeding characters, then we may be in a function.
                        // If we are in a function, then return an unknown value.
                        //
                        // Since "for each tt where f1='a'and(f1 gt '')" and "where f1='a'and(f2>'')"
                        // are legal ABL, we try to resolve those into query entries.
                        if not strValue eq '':u then
                        do:
                            if joinEnumNames eq '':u then
                                assign joinEnumNames = get-class(JoinEnum):GetEnumNames().
                            
                            if lookup(strValue, joinEnumNames) eq 0 then
                                return ?.
                            
                            if not valid-object(qryGroup) then
                                assign qryGroup    = new QueryGroup()
                                       topGroup    = qryGroup
                                       parentGroup = qryGroup
                                       .
                            else
                                // the previous group is now the parent
                                assign parentGroup = qryGroup.
                            
                            // use any existing join
                            AddToGroup(qryGroup, qryPredicate, joinWith).
                            
                            // the JOIN applies to the following group, not the current predicate
                            assign joinWith     = GetJoin(strValue, joinWith)
                                   qryPredicate = ?
                                   strValue     = '':u
                                   .
                        end.
                        
                        // first ( or there's no other group yet
                        if not valid-object(topGroup) then
                            assign topGroup    = new QueryGroup()
                                   parentGroup = topGroup
                                   .
                        else
                            // the previous group is now the parent
                            assign parentGroup = qryGroup.
                        
                        // Create a group if this is a non-quoted (
                        assign qryGroup = new QueryGroup().
                               strValue = '':u
                               .
                        // add it to its parent
                        AddToGroup(parentGroup, qryGroup, joinWith).
                        
                        // clear the join, since this group may have its own, or not
                        assign joinWith = ?.
                        next CHR-LOOP.
                    end.
                    
                    assign strValue = strValue + chrValue.
                end.    // (
                else
                if chrValue eq ')':u then
                do:
                    if not inDoubleQuotes
                    and not inSingleQuotes
                    then
                    do:
                        if haveName
                        and haveOperator
                        then
                        do:
                            assign fieldValue   = GetFieldValue(strValue, isQuotedNull, operator)
                                   strValue     = '':u
                                   isQuotedNull = no
                                   haveName     = no
                                   haveOperator = no
                                   haveValue    = no
                                   qryPredicate = new QueryPredicate(fieldName, operator, fieldValue)
                                   .
                            // add the predicate to the current group
                            if AddToGroup(qryGroup, qryPredicate, joinWith) then
                                assign qryPredicate = ?
                                       joinWith     = ?
                                       .
                        end.
                        // Now that the group is closed, reset the current group to the parent
                        assign qryGroup    = parentGroup
                               parentGroup = GetGroupParent(topGroup, qryGroup)
                               .
                    end.
                    else
                        assign strValue = strValue + chrValue.
                end.    // )
                else
                if isTilde then
                do:
                    // if we're escaping something then don't write the tilde
                    if nextChr eq StringConstant:TILDE
                    or nextChr eq StringConstant:SINGLE_QUOTE
                    or nextChr eq StringConstant:DOUBLE_QUOTE
                    or nextChr eq StringConstant:CURLY_OPEN
                    then
                        next CHR-LOOP.
                    else
                        assign strValue = strValue + chrValue.
                end.    // ~
                else
                // deal with custnum>23
                if not haveName
                and not inSingleQuotes
                and not inDoubleQuotes
                then
                case chrValue:
                    // allowed: <, >, =, <=, >=, <>
                    when '<':u or
                    when '=':u or
                    when '>':u then
                    do:
                        assign fieldName    = strValue
                               strValue     = '':u
                               haveName     = yes
                               haveOperator = yes
                               .
                        if nextChr eq '=':u
                        or nextChr eq '>':u
                        then
                        do:
                            assign operator = QueryOperatorHelper:ToEnum(chrValue + nextChr)
                                   loop     = loop + 1
                                   .
                            // set nextChr because we bumped the loop value up
                            if loop eq len then
                                assign nextChr = '':u.
                            else
                                assign nextChr = substring(pWhere, loop + 1, 1).
                        end.
                        else
                            assign operator = QueryOperatorHelper:ToEnum(chrValue).
                        
                        // if this is table.field= 20 (space after oprator) then skip the space,
                        // since we're dealing with it here
                        if nextChr eq StringConstant:SPACE then
                            assign loop = loop + 1.
                    end.
                    otherwise
                        assign strValue = strValue + chrValue.
                end case.
                else
                    assign strValue = strValue + chrValue.
            end.
            
            if  haveName
            and haveOperator
            and haveValue
            then
            do:
                assign haveName     = no
                       haveOperator = no
                       haveValue    = no
                       qryPredicate = new QueryPredicate(fieldName, operator, fieldValue)
                       .
                // if it's added to a group, then we don't need the predicate any more
                if AddToGroup(qryGroup, qryPredicate, joinWith) then
                    assign qryPredicate = ?
                           joinWith     = ?
                           .
                else
                // for NOT cases
                if valid-object(joinWith) then
                    assign qryPredicate:Join = joinWith.
            end.
            
            finally:
                assign prevChr = chrValue.
            end finally.
        end.    //CHR-LOOP
        
        // we return one of an IQueryPredicate (single clause) or an IQueryGroup (many clauses)
        if valid-object(topGroup) then
            assign qryGroup = topGroup.
        
        if valid-object(qryGroup) then
        do:
            // We added a group (due to a ( probably) , but it's empty. So there's nothing to resolve here.
            if extent(qryGroup:Entries) eq ? then
                return ?.
            if extent(qryGroup:Entries) eq 1 then
            do:
                // a group started by ( will have a valid Entries[1] but that won't have anything
                if type-of(qryGroup:Entries[1], IQueryGroup) then
                do:
                    assign entries = cast(qryGroup:Entries[1], IQueryGroup):Entries.
                    if extent(entries) eq ? then
                        return ?.
                end.
                
                // if we have a join but no predicate, then something went wrong parsing the
                // last predicate; return null in this case.
                // "WHERE bal = 1 AND TRUE" is an example of this.
                if valid-object(joinWith)
                and not valid-object(qryPredicate)
                then
                    return ?.
                
                // in case there's a stray predicate
                AddToGroup(qryGroup, qryPredicate, joinWith).
                
                // if the string is just "(x=y)" then we only have/need the one group
                if extent(qryGroup:Entries) eq 1 then
                    return qryGroup:Entries[1].
            end.
            
            return qryGroup.
        end.
        else
        // we've been able to parse the whole where clause
        if strValue eq '':u
        and not haveName
        and not haveOperator
        and not haveValue
        and not valid-object(joinWith)
        then
            return qryPredicate.
        else
            return ?.
        
        // if there's an error parsing the string, assume it's rubbish and return null.
        catch e as Progress.Lang.Error:
            return ?.
        end catch.
    end method.
    
    /* Indicates whether a string can be used with a MATCHES operator:
       it needs to have an unescaped * or . in the string.
       
       @param character The expression to evaluate
       @return logical TRUE if the expression contains at least one * or .; FALSE otherwise */
    method private logical IsMatchesExpression(input pExpr as character):
        var integer pos.
        
        if pExpr eq ?
        or pExpr eq '':u
        then
            return false.
        
        // look for unescaped * first
        assign pos = index(pExpr, '*':u).
        do while pos gt 0:
            if pos ge 2
            and substring(pExpr, pos - 1, 1) eq OpenEdge.Core.StringConstant:TILDE
            then
                assign pos = index(pExpr, '*':u, pos + 1).
            else
                return true.
        end.
        
        // then for unescaped .
        assign pos = index(pExpr, '.':u).
        do while pos gt 0:
            if pos ge 2
            and substring(pExpr, pos - 1, 1) eq OpenEdge.Core.StringConstant:TILDE
            then
                assign pos = index(pExpr, '.':u, pos + 1).
            else
                return true.
        end.
        
        return false.
    end method.
    
    /* Reads the whole tree of groups in a group to find a particular group's parent group.
       
       @param QueryGroup The parent group
       @param QueryGroup The group whose parent to find
       @return QueryGroup The parent group, or NULL if none found. */
    method private QueryGroup GetGroupParent(input pParent as QueryGroup,
                                             input pGroup as QueryGroup):
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        define variable qg as QueryGroup no-undo.
        
        if not valid-object(pParent) then
            return ?.
        if pParent:Equals(pGroup) then
            return pParent.
        
        assign cnt = extent(pParent:Entries).
        ENTRY-LOOP:
        do loop = 1 to cnt:
            if pParent:Entries[loop]:Equals(pGroup) then
                return pParent.
            else
            if type-of(pParent:Entries[loop], QueryGroup) then
            do:
                qg = GetGroupParent(cast(pParent:Entries[loop], QueryGroup), pGroup).
                if valid-object(qg) then
                    return qg.
            end.
        end.
        
        return ?.
    end method.
    
    /* Adds a query entry to an existing group.
    
       @param QueryGroup A group to which to add an entry to.
       @param IQueryEntry A new query entry. May be a QueryPredicate or a QueryGroup
       @param JoinEnum How the new entry joins (AND/OR/etc) to any previous entries in the group
       @return logical TRUE if the query entry was added; FALSE otherwise */
    method private logical AddToGroup(input pParentGroup as QueryGroup,
                                      input pEntry as IQueryEntry,
                                      input pJoin as JoinEnum          ):
        define variable idx as integer no-undo.
        
        if not valid-object(pParentGroup)
        or not valid-object(pEntry)
        then
            return false.
        
        assign idx = extent(pParentGroup:Entries) + 1.
        // ? + anything = ?
        if idx eq ? then
            assign idx = 1.
        
        assign extent(pParentGroup:Entries) = idx
               pParentGroup:Entries[idx]    = pEntry
               .
        if valid-object(pJoin) then
        do:
            if type-of(pEntry, QueryGroup) then
                assign cast(pEntry, QueryGroup):Join = pJoin.
            else
            if type-of(pEntry, QueryPredicate) then
                assign cast(pEntry, QueryPredicate):Join = pJoin.
        end.
        
        return true.
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
        
        return qrySort.
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
        define variable tableName as character no-undo.
        define variable nameCnt as integer no-undo.
        
        assign dataRequest = new GetDataRequest().
        
        case true:
            when not valid-object(pData) then
                return dataRequest.
            
            when type-of(pData, ICharacterHolder) or
            when type-of(pData, ILongcharHolder) then
            do:
                assign dataRequest                       = new GetDataRequest(1)
                       tableRequest                      = new GetDataTableRequest(FilterTable[1])
                       dataRequest:TableRequests[1]      = tableRequest
                       qryDef                            = new QueryDefinition()
                       tableRequest:QueryDefinition      = qryDef
                       extent(stringData)                = 1
                       stringData[1]                     = dynamic-property(pData, 'Value':u)
                       qryDef:QuerySelection             = ParseWhereString(stringData[1])
                       .
                // if we can't parse the input string, then just set as a string value
                if not valid-object(qryDef:QuerySelection) then
                    assign tableRequest:QueryDefinition = ?
                           tableRequest:QueryString     = stringData[1]
                           .
            end.
            
            when type-of(pData, ICharacterArrayHolder) or
            when type-of(pData, ILongcharArrayHolder)  then
            do:
                assign stringData = dynamic-property(pData, 'Value':u)
                       cnt        = extent(stringData)
                       nameCnt    = extent(FilterTable)
                       .
                if     not cnt eq ?
                   and cnt ge 1
                then
                    assign extent(dataRequest:TableRequests) = cnt.
                
                do loop = 1 to cnt:
                    // if there's a FilterTable for the query, use that.
                    // if not, use blank to indicate "we don't know"
                    if nameCnt ge loop then
                        assign tableName = FilterTable[loop].
                    else
                        assign tableName = '':u.
                    
                    assign tableRequest                      = new GetDataTableRequest(tableName)
                           dataRequest:TableRequests[loop]   = tableRequest
                           qryDef                            = new QueryDefinition()
                           tableRequest:QueryDefinition      = qryDef
                           qryDef:QuerySelection             = ParseWhereString(stringData[loop])
                           .
                    // if we can't parse the input string, then just set as a string value
                    if not valid-object(qryDef:QuerySelection) then
                        assign tableRequest:QueryDefinition = ?
                               tableRequest:QueryString     = stringData[loop]
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
                assign cnt     = cast(pData, JsonArray):Length
                       nameCnt = extent(FilterTable)
                       .
                if     not cnt eq ?
                   and cnt ge 1
                then
                    assign extent(dataRequest:TableRequests) = cnt.
                
                do loop = 1 to cnt:
                    // if there's a FilterTable for the query, use that.
                    // if not, use blank to indicate "we don't know"
                    if nameCnt ge loop then
                        assign tableName = FilterTable[loop].
                    else
                        assign tableName = '':u.
                    
                    assign dataRequest:TableRequests[loop] = ParseTableRequest(tableName,
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
        define variable names as character extent no-undo.
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        define variable hasQry as logical extent 2 initial false no-undo.
        define variable qryStr as character no-undo.
        
        Assert:NotNull(pTable, 'Table name').
        
        assign tableRequest = new GetDataTableRequest(pTable).
        
        if not valid-object(pData) then
            return tableRequest.
        
        assign qryDef                       = new QueryDefinition()
               tableRequest:QueryDefinition = qryDef
               names = pData:GetNames()
               cnt   = extent(names)
               .
        NAMES-LOOP:
        do loop = 1 to cnt
        while (not hasQry[1] or not hasQry[2]):
            if not pData:GetType(names[loop]) eq JsonDataType:STRING then
                next NAMES-LOOP.
            
            // loop-de-loop cos JSON is case sensitive and ABL is not
            case names[loop]:
                when 'where':u then
                    if not hasQry[1] then
                    do:
                        assign qryStr                = pData:GetCharacter(names[loop])
                               qryDef:QuerySelection = ParseWhereString(qryStr)
                               hasQry[1]             = true
                               .
                        if not valid-object(qryDef:QuerySelection) then
                            assign tableRequest:QueryString     = qryStr
                                   tableRequest:QueryDefinition = ?
                                   .
                    end.
                when 'by':u then
                    if not hasQry[2] then
                        assign qryDef:QuerySort = ParseSortString(pData:GetCharacter(names[loop]))
                               hasQry[2]        = true
                               .
            end case.
        end.    // NAMES-LOOP
        
        // if the query string failed to parse into an IQueryEntry, add the
        // sort phrases to the string
        if hasQry[1]
        and hasQry[2]
        and not valid-object(qryDef:QuerySelection)
        then
        do:
            assign cnt = extent(qryDef:QuerySort).
            // add the BY clauses from the QueryDefinition
            do loop = 1 to cnt:
                assign tableRequest:QueryString = tableRequest:QueryString
                                                + ' by ':u
                                                + qryDef:QuerySort[loop]:FieldName.
                if valid-object(qryDef:QuerySort[loop]:SortOrder)
                and qryDef:QuerySort[loop]:SortOrder eq SortOrderEnum:Descending
                then
                    assign tableRequest:QueryString = tableRequest:QueryString + ' descending ':u.
            end.
        end.
        
        return cast(tableRequest, IGetDataTableRequest).
    end method.
    
    /* Returns a field value from the current parsed string
       
       @param character The parsed character
       @param logical TRUE if the value is a quoted null
       @param QueryOperatorEnum An optional operator
       @return String The String containing the value */
    method private String GetFieldValue(input pVal as character,
                                        input pQuotedNull as logical,
                                        input pOperator as QueryOperatorEnum):
        define variable fldVal as String no-undo.
        
        if pVal eq '?':u
        and not pQuotedNull
        then
            assign fldVal = String:Unknown().
        else
        do:
            // for matches, make sure there's a * or . for matching in the string
            // this turns is into an 'ending' since begins is its own operator
            if valid-object(pOperator)
            and pOperator eq QueryOperatorEnum:Matches
            and not IsMatchesExpression(pVal)
            then
                // add * instead of . since that's a broader match
                assign pVal = '*':u + pVal.
            
            assign fldVal = new String(pVal).
        end.
        
        return fldVal.
    end method.
    
    /* Determines the join value.
       
       If there is an existing join value passed in,
       and it's value is either "And" or "Or", and the current string
       value is "not", then return a new "AndNot" or "OrNot".
       
       If there is an existing join value passed in, and it is not "And" or
       "Or", then that value is returned.
       
       If no join value is passed in, then use the string value to determine the
       enum.
       
       @param character A word representing a join
       @param JoinEnum The current join, if any
       @return JoinEnum The new join. */
    method private JoinEnum GetJoin (input pVal as character,
                                     input pJoin as JoinEnum):
        case pJoin:
            when ?            then return JoinEnum:GetEnum(pVal).
            when JoinEnum:And then return JoinEnum:AndNot.
            when JoinEnum:Or  then return JoinEnum:OrNot.
            otherwise              return pJoin.
        end case.
        
        // should never get here, but have a value anyway
        return JoinEnum:None.
    end method.
    
end class.
