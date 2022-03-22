/* *************************************************************************************************************************
Copyright (c) 2019, 2021 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : KendoFilterParser
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : pjudge & dugrau
    Created     : Wed Dec 07 14:11:10 EST 2016
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.BusinessLogic.IGetDataRequest.
using Ccs.BusinessLogic.IGetDataTableRequest.
using Ccs.BusinessLogic.IQueryEntry.
using Ccs.BusinessLogic.IQuerySortEntry.
using Ccs.BusinessLogic.JoinEnum.
using Ccs.BusinessLogic.QueryOperatorEnum.
using Ccs.Common.Support.IPrimitiveHolder.
using OpenEdge.BusinessLogic.Filter.FilterParser.
using OpenEdge.BusinessLogic.GetDataRequest.
using OpenEdge.BusinessLogic.GetDataTableRequest.
using OpenEdge.BusinessLogic.QueryDefinition.
using OpenEdge.BusinessLogic.QueryGroup.
using OpenEdge.BusinessLogic.QueryOperatorHelper.
using OpenEdge.BusinessLogic.QueryPredicate.
using OpenEdge.BusinessLogic.QuerySortEntry.
using OpenEdge.Core.StringConstant.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.AppError.

class OpenEdge.BusinessLogic.Filter.KendoFilterParser inherits FilterParser:

    /* Default constructor */
    constructor public KendoFilterParser ():
        super().
    end constructor.

    /* Constructor.

       @param character (mandatory) A table name for which to construct the filter */
    constructor public KendoFilterParser (input pTable as character):
        super(pTable).
    end constructor.

    /* Constructor.

       @param character[] (mandatory) An array of table name for which to construct the filter */
    constructor public KendoFilterParser (input pTable as character extent):
        super(pTable).
    end constructor.

    method protected IQueryEntry ParsePredicate (input pJoin as JoinEnum,
                                                 input pFilter as JsonObject):
        define variable oClause     as QueryPredicate    no-undo.
        define variable oFieldValue as IPrimitiveHolder  no-undo.
        define variable oJoinAs     as JoinEnum          no-undo.
        define variable oOperator   as QueryOperatorEnum no-undo.
        define variable cOperator   as character         no-undo.

        /* Field name must be present, otherwise we must skip. */
        if    not pFilter:Has("field":u)
           or not pFilter:GetType("field":u) eq JsonDataType:STRING
        then
            return ?.

        /* Field operator must be present, otherwise we must skip. */
        if    not pFilter:Has("operator":u)
           or not pFilter:GetType("operator":u) eq JsonDataType:STRING
        then
            return ?.

        /* Default the join to that of the overall group (as passed in). */
        assign oJoinAs = pJoin.

        /* Field Value */
        case pFilter:GetType("value":u):
            when JsonDataType:ARRAY  or
            when JsonDataType:OBJECT then
                undo, throw new AppError(substitute("Unsupported filter value type of JsonObject/JsonArray for field &1",
                                            pFilter:GetCharacter("field":u)), 0).

            when JsonDataType:NULL then
                assign oFieldValue = new OpenEdge.Core.String(StringConstant:UNKNOWN).

            // we don"t at this point know what the underlying schmema and data type are, so stringify it all
            otherwise
                assign oFieldValue = new OpenEdge.Core.String(pFilter:GetJsonText("value":u)).
        end case.

        assign cOperator = pFilter:GetCharacter("operator":u).
        case cOperator:
            /* First map complex operators. */

            when "isnull":u then
                assign oOperator   = QueryOperatorEnum:Eq
                       oFieldValue = new OpenEdge.Core.String(StringConstant:UNKNOWN)
                       .
            when "isnotnull":u then
                assign oOperator   = QueryOperatorEnum:Ne
                       oFieldValue = new OpenEdge.Core.String(StringConstant:UNKNOWN)
                       .
            when "isempty":u then
                assign oOperator   = QueryOperatorEnum:Eq
                       oFieldValue = new OpenEdge.Core.String("":u)
                       .
            when "isnotempty":u then
                assign oOperator   = QueryOperatorEnum:Ne
                       oFieldValue = new OpenEdge.Core.String("":u)
                       .
            when "isnullorempty":u then
                /* @TODO: This may need more work. */
                assign oOperator   = QueryOperatorEnum:Eq
                       oFieldValue = new OpenEdge.Core.String("":u)
                       .
            when "isnotnullorempty":u then
                /* @TODO: This may need more work. */
                assign oOperator   = QueryOperatorEnum:Ne
                       oFieldValue = new OpenEdge.Core.String("":u)
                       .
            when "endswith":u then
            do:
                assign oOperator = QueryOperatorEnum:Matches.
                cast(oFieldValue, OpenEdge.Core.String):Prepend("*":u).
            end.
            when "contains":u then
            do:
                assign oOperator = QueryOperatorEnum:Contains.
                cast(oFieldValue, OpenEdge.Core.String):Append("*":u).
                cast(oFieldValue, OpenEdge.Core.String):Prepend("*":u).
            end.
            when "doesnotcontain":u then
            do:
                assign oOperator = QueryOperatorEnum:Contains.
                cast(oFieldValue, OpenEdge.Core.String):Append("*":u).
                cast(oFieldValue, OpenEdge.Core.String):Prepend("*":u).

                /* Convert current join into a "and/or not" .*/
                if oJoinAs eq JoinEnum:And then
                    assign oJoinAs = JoinEnum:AndNot.
                else
                    assign oJoinAs = JoinEnum:OrNot.
            end.

            /* Simpler things are just mapped (EQ, NEQ, LTE, etc.) */
            otherwise
                assign oOperator = QueryOperatorHelper:ToEnum(cOperator).
        end case.

        assign oClause      = new QueryPredicate(pFilter:GetCharacter("field":u), oOperator, oFieldValue)
               oClause:Join = oJoinAs /* Use the determined join value. */
               .

        return oClause.

        finally:
            delete object oOperator no-error.
            delete object oJoinAs no-error.
        end finally.
    end method.

    method protected IQueryEntry ParseWhere (input pGroup  as QueryGroup,
                                             input pFilter as JsonObject):
        define variable iFilters    as integer           no-undo.
        define variable iLoop       as integer           no-undo.
        define variable oFilters    as JsonArray         no-undo.
        define variable oFilter     as JsonObject        no-undo.

        /**
         * Note: This is a recursive method, whereby the QueryGroup passed in may
         * consist of only query predicates (field, operator, value) or another
         * sub-group entirely. For the case of the latter, the newly-found group
         * will be passed again into this method for parsing. This allows for the
         * case of nested queries to be generated from the KendoUI query.
         */

        /* Check for and assign the overall join for this group. */
        if     pFilter:Has("logic":u)
           and pFilter:GetType("logic":u) eq JsonDataType:STRING
        then
            assign pGroup:Join = JoinEnum:GetEnum(pFilter:GetCharacter("logic":u)).

        /* Check for and extract the filters for this group. */
        if     pFilter:Has("filters":u)
           and pFilter:GetType("filters":u) eq JsonDataType:ARRAY
        then
            assign oFilters = pFilter:GetJsonArray("filters":u).

        /* No need to proceed if filters list is empty. */
        if oFilters:length eq 0 then return pGroup.

        /* Set extent of QueryGroup entries equal to number of filters at this level. */
        extent(pGroup:Entries) = oFilters:length.

        /* Iterate over the filters array as provided. */
        assign iFilters = oFilters:Length.
        FILTER-LOOP:
        do iLoop = 1 to iFilters
        on error undo, throw:
            if not oFilters:GetType(iLoop) eq JsonDataType:OBJECT then next FILTER-LOOP.

            assign oFilter = oFilters:GetJsonObject(iLoop).
            if oFilter:Has("logic") then
                /* If the current object contains a "logic" property then this entry is a new group. */
                assign pGroup:Entries[iLoop] = this-object:ParseWhere(new QueryGroup(), oFilter).
            else
                /* Otherwise, the current object is destined to become a new QueryPredicate entry. */
                assign pGroup:Entries[iLoop] = this-object:ParsePredicate(pGroup:Join, oFilter).

            finally:
                delete object oFilter no-error.
            end finally.
        end. /* iLoop */

        return pGroup.

        finally:
            delete object oFilters no-error.
        end finally.
    end method.

    /* Parses where/filter phrase and returns an IQueryEntry object for a single table
       http://docs.telerik.com/kendo-ui/api/javascript/data/datasource#configuration-filter

       @param P.L.Object The filter/where clause data
       @return IQueryEntry The query entry. We return one of an IQueryPredicate (single clause)
                           or an IQueryGroup (many clauses) */
    method override public IQueryEntry ParseWhere (input pWhere as Progress.Lang.Object):
        define variable oJsonFilter as JsonObject no-undo.

        if not valid-object(pWhere) or not type-of(pWhere, JsonConstruct) then
            return new QueryGroup().

        /* Normalize the incoming filter data as a JSON object with a join logic. */
        if type-of(pWhere, JsonArray) then
        do:
            assign oJsonFilter = new JsonObject().
            oJsonFilter:Add("logic":u, JoinEnum:And:ToString()).
            oJsonFilter:Add("filters":u, cast(pWhere, JsonArray)).
        end.
        else if type-of(pWhere, JsonObject) then
            assign oJsonFilter = cast(pWhere, JsonObject).

        /* Return the final QueryGroup (IQueryEntry) as built by the expanded parser. */
        return this-object:ParseWhere(new QueryGroup(), oJsonFilter).
    end method.

    /* Parses an SORT-BY phrase and returns an array of IQuerySortEntry objects.
       http://docs.telerik.com/kendo-ui/api/javascript/data/datasource#configuration-sort

       @param P.L.Object The SORT-BY data
       @return IQuerySortEntry[] An array of sort phrases. An indeterminate array is returned if the input phrase is empty */
    method override public IQuerySortEntry extent ParseSortBy (input pSortBy as Progress.Lang.Object):
        define variable oSortEntry as QuerySortEntry no-undo extent.
        define variable oSortObj   as JsonObject     no-undo.
        define variable iX         as integer        no-undo.

        if not valid-object(pSortBy) or not type-of(pSortBy, JsonConstruct) then
            return oSortEntry.

        if type-of(pSortBy, JsonArray) and cast(pSortBy, JsonArray):Length gt 0 then do:
            /**
             * An extent must be specified, even if some of the fields are not valid for sorting.
             * Since we shouldn't have more sort entries than items in the array, use that count.
             */
            extent(oSortEntry) = cast(pSortBy, JsonArray):length.

            do iX = 1 to cast(pSortBy, JsonArray):length:
                assign oSortObj = cast(pSortBy, JsonArray):GetJsonObject(iX).
                /* Add a new sort entry object with field and direction. */
                oSortEntry[iX] = new QuerySortEntry(oSortObj:GetCharacter("field":u), if oSortObj:GetCharacter("dir":u) eq "asc":u
                                                                                      then Ccs.BusinessLogic.SortOrderEnum:Ascending
                                                                                      else Ccs.BusinessLogic.SortOrderEnum:Descending).
            end. /* do iX */
        end. /* valid-object */

        return oSortEntry.
    end method.

    /* Reads and processes (parses) the filter.

       @param P.L.Object The filter data
       @param IGetDataRequest A new filter object */
    method override public IGetDataRequest Parse (input pData as Progress.Lang.Object):
        define variable dataRequest as GetDataRequest no-undo.

        assign dataRequest = new GetDataRequest().

        /*
         * {
         *   "mappingType": "kendo",
         *   "filter": ~{"logic": "and|or", "filters": []},
         *   "sort": [],
         *   "skip": #,
         *   "top": #
         * }
         */

        /* If no valid JSON object available as input, simply create an empty object. */
        if    not valid-object(pData)
           or not type-of(pData, JsonConstruct)
        then
            assign pData = new JsonObject().

        if type-of(pData, JsonObject) and extent(this-object:FilterTable) ge 1 then
        do:
            /* There should be only 1 table (for now) and filter data should be a JsonObject. */
            assign extent(dataRequest:TableRequests) = 1
                   dataRequest:TableRequests[1]      = this-object:ParseTableRequest(this-object:FilterTable[1],
                                                                                     cast(pData, JsonObject))
                   .
        end.

        return dataRequest.
    end method.

    /* Reads a single table's request.

       This method knows which properties in the input JSON are for the where clause, for the sort-by etc

       @param character The table name to which this filter applies
       @param JsonObject The input filter
       @return IGetDataTableRequest A single table Get Request */
    method protected IGetDataTableRequest ParseTableRequest (input pTable as character,
                                                             input pData as JsonObject):
        define variable tableRequest as GetDataTableRequest no-undo.
        define variable qryDef as QueryDefinition no-undo.

        assign tableRequest = new GetDataTableRequest(pTable). // we don't know the table name here

        if not valid-object(pData) then
            return tableRequest.

        assign qryDef                       = new QueryDefinition()
               tableRequest:QueryDefinition = qryDef
               .

        /* Should be "sort" though for backwards compatibility look for "orderBy" just in case. */
        if     pData:Has("sort":u)
           and pData:GetType("sort":u) eq JsonDataType:ARRAY
        then
            assign qryDef:QuerySort = this-object:ParseSortBy(pData:GetJsonArray("sort":u)).
        else if     pData:Has("orderBy":u)
                and pData:GetType("orderBy":u) eq JsonDataType:ARRAY
        then
            assign qryDef:QuerySort = this-object:ParseSortBy(pData:GetJsonArray("orderBy":u)).

        /* Should have either a "filter" object or "filters" array. */
        if    pData:Has("filter":u)
          and pData:GetType("filter":u) eq JsonDataType:OBJECT
        then
            assign qryDef:QuerySelection = this-object:ParseWhere(pData:GetJsonObject("filter":u)).
        else if    pData:Has("filters":u)
               and pData:GetType("filters":u) eq JsonDataType:ARRAY
        then
            assign qryDef:QuerySelection = this-object:ParseWhere(pData:GetJsonArray("filters":u)).

        if     pData:Has("id":u)
           and pData:GetType("id":u) eq JsonDataType:STRING
        then
            assign tableRequest:PagingContext = pData:GetCharacter("id":u).

        if     pData:Has("top":u)
           and pData:GetType("top":u) eq JsonDataType:NUMBER
        then
            assign tableRequest:NumRecords = pData:GetInt64("top":u).

        if     pData:Has("skip":u)
           and pData:GetType("skip":u) eq JsonDataType:NUMBER
        then
            assign tableRequest:Skip = pData:GetInt64("skip":u).

        return cast(tableRequest, IGetDataTableRequest).
    end method.

end class.