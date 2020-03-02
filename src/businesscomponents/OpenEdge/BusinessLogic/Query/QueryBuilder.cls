/* *************************************************************************************************************************
Copyright (c) 2019 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : QueryBuilder
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge & dugrau
    Created     : Thu May 10 12:38:00 EDT 2018
    Notes       : ADAS-101
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.BusinessLogic.IGetDataRequest.
using Ccs.BusinessLogic.JoinEnum.
using Ccs.BusinessLogic.QueryOperatorEnum.
using Ccs.Common.Support.ICharacterArrayHolder.
using Ccs.Common.Support.ICharacterHolder.
using Ccs.Common.Support.IDateArrayHolder.
using Ccs.Common.Support.IDateHolder.
using Ccs.Common.Support.IDateTimeArrayHolder.
using Ccs.Common.Support.IDateTimeHolder.
using Ccs.Common.Support.IDateTimeTzArrayHolder.
using Ccs.Common.Support.IDateTimeTzHolder.
using Ccs.Common.Support.IDecimalArrayHolder.
using Ccs.Common.Support.IDecimalHolder.
using Ccs.Common.Support.IInt64ArrayHolder.
using Ccs.Common.Support.IInt64Holder.
using Ccs.Common.Support.IIntegerArrayHolder.
using Ccs.Common.Support.IIntegerHolder.
using Ccs.Common.Support.ILogicalArrayHolder.
using Ccs.Common.Support.ILogicalHolder.
using Ccs.Common.Support.ILongcharArrayHolder.
using Ccs.Common.Support.ILongcharHolder.
using OpenEdge.BusinessLogic.GetDataTableRequest.
using OpenEdge.BusinessLogic.QueryDefinition.
using OpenEdge.BusinessLogic.QueryGroup.
using OpenEdge.BusinessLogic.QueryPredicate.
using OpenEdge.BusinessLogic.QuerySortEntry.

class OpenEdge.BusinessLogic.Query.QueryBuilder: 

    /* Returns a table/buffer handle for a given name from an input schema
       
       @param handle The input schema (dataset, buffer, table)
       @param character The table name. Can be the 'real' name or the serialize-name
       @return handle A buffer handle for the given name. */
    method protected handle GetTableBuffer (input phSchema    as handle,
                                            input pcTableName as character):
        define variable iBuffer as integer no-undo.
        define variable hTable  as handle  no-undo.

        if not valid-handle(phSchema) or phSchema:type ne "dataset" then
            return phSchema. /* Return handle as-is if not a dataset. */

        if (pcTableName gt "") ne true then
            return phSchema:get-buffer-handle(1). /* No table name, just get the top buffer by default. */
        else do:
            assign hTable= phSchema:get-buffer-handle(pcTableName). /* Get the requested table by name. */
            if valid-handle(hTable) then
                return hTable. /* Return if found by actual table name. */
            
            /* If still here, search by serialize-name of table. */
            do iBuffer = 1 to phSchema:num-buffers:
                assign hTable= phSchema:get-buffer-handle(iBuffer).
                if hTable:serialize-name eq pcTableName then
                    return hTable. /* Found table by serialize-name. */
            end. /* iBuffer */
        end. /* Non-Empty TableName */

        return ?. /* No schema, no table name, no table found, just return unknown value. */
    end method. /* GetTableBuffer */
    
    /* Returns a fiueld handle for a given name from an input buffer
       
       @param handle The input table/buffer
       @param character The field name. Can be the 'real' name or the serialize-name
       @return handle A buffer field handle for the given name. */
    method protected handle GetFieldBuffer (input phTable     as handle,
                                            input pcFieldName as character):
        define variable bhField as handle  no-undo.
        define variable ix      as integer no-undo.

        /* Return the buffer for the field, if it exists in the table. */
        if valid-handle(phTable) then do:
            assign bhField = phTable:buffer-field(pcFieldName).
            if valid-handle(bhField) then
                return bhField.
            
            do ix = 1 to phTable:num-fields:
                assign bhField = phTable:buffer-field(ix) no-error.
                /* Web-based field matches real name or serialized name. */
                if valid-handle(bhField) then do:
                    if bhField:serialize-name eq pcFieldName then
                        return bhField.
                    else
                        delete object bhField no-error.
                end. /* valid-handle */
            end. /* do ix */
        end. /* valid-handle */

        return ?. /* Return unknown value to indicate field is not in the temp-table. */

        finally:
            delete object bhField no-error.
        end finally.
    end method. /* GetFieldBuffer */

    /* Maps a query operator into a string template
       
       @param QueryOperatorEnum The operator
       @param character The the data type 
       @return character A templated operator map of the form "&1 eq &2" */
    method protected character MapOperator (input poOperator as QueryOperatorEnum,
                                            input pcDataType as character ):
        /* http://docs.telerik.com/kendo-ui/api/javascript/data/datasource#configuration-filter.operator */
        define variable cTemplate as character no-undo.

        case poOperator:
            when QueryOperatorEnum:Eq then
                if pcDataType eq "character" then
                    assign cTemplate = '&1 eq "&2"'.
                else
                    assign cTemplate = '&1 eq &2'.
            when QueryOperatorEnum:Ne then
                if pcDataType eq "character" then
                    assign cTemplate = '&1 ne "&2"'.
                else
                    assign cTemplate = '&1 ne &2'.
            when QueryOperatorEnum:Lt then
                assign cTemplate = '&1 lt &2'.
            when QueryOperatorEnum:Le then
                assign cTemplate = '&1 le &2'.
            when QueryOperatorEnum:Gt then
                assign cTemplate = '&1 gt &2'.
            when QueryOperatorEnum:Ge then
                assign cTemplate = '&1 ge &2'.
            when QueryOperatorEnum:Begins then
                assign cTemplate = '&1 begins "&2"'.
            when QueryOperatorEnum:Contains then
                assign cTemplate = '&1 matches "&2"'. /* Value should already be appended/prepended with '*'. */
            when QueryOperatorEnum:Matches then
                assign cTemplate = '&1 matches "&2"'. /* Value should already be appended/prepended with '*'. */
            otherwise
                undo, throw new Progress.Lang.AppError(substitute("Unknown operator '&1' for filter.", poOperator:ToString()), 0).
        end case.

        return cTemplate.
    end method. /* MapOperator */

    /* Creates a templated join phrase for a clause
       
       @param character The current query string
       @param character The query where clause that's being joined
       @param JoinEnum The join to apply
       @return character A new query string, including the join phrase */
    method protected character MapJoin (input pcQuery  as character,
                                        input pcClause as character,
                                        input poJoinAs as JoinEnum):
        if pcQuery eq "" then
            /* When query string is blank, only provide negations as needed. */
            case poJoinAs:
                when JoinEnum:AndNot or
                when JoinEnum:OrNot or
                when JoinEnum:Not then
                    assign pcQuery = substitute("(not &1)", pcClause).
                otherwise
                    assign pcQuery = substitute("(&1)", pcClause).
            end case.
        else
            /* Otherwise join clause to query as described by join. */
            case poJoinAs:
                when JoinEnum:And then
                    assign pcQuery = substitute("&1 and (&2)", pcQuery, pcClause).
                when JoinEnum:AndNot then
                    assign pcQuery = substitute("&1 and (not &2)", pcQuery, pcClause).
                when JoinEnum:Or then
                    assign pcQuery = substitute("&1 or (&2)", pcQuery, pcClause).
                when JoinEnum:OrNot then
                    assign pcQuery = substitute("&1 or (not &2)", pcQuery, pcClause).
                when JoinEnum:None then
                    assign pcQuery = substitute("(&1)", pcClause). /* No join operator. */
                when JoinEnum:Not then
                    assign pcQuery = substitute("(not &1)", pcClause). /* Negate only. */
            end case.
    
        return pcQuery.
    end method. /* MapJoin */
    
    /* Builds a query group string from a group
       
       @param handle The table/buffer for which the group is being built
       @param QueryGroup The group 
       @return character A group string */
    method protected character BuildGroup (input phTable as handle,
                                           input poGroup as QueryGroup):
        define variable cQueryString as character no-undo initial "".
        define variable cClause      as character no-undo.
        define variable iLoop        as integer   no-undo.
        define variable oJoinAs      as JoinEnum  no-undo.

        /**
         * Note: This is a recursive method, as the provided group may consist of either only
         * query predicates (field, operator, value) or an entire group (nested query). For the
         * case of a group the object will be fed into another call to this method which will
         * result in a nested (bracketed) query clause.
         */

        if extent(poGroup:Entries) ne ? and extent(poGroup:Entries) ge 1 then
        do iLoop = 1 to extent(poGroup:Entries):
            if type-of(poGroup:Entries[iLoop], QueryGroup) then
                /* Create a nested query from this child group. */
                assign cClause = this-object:BuildGroup(phTable, cast(poGroup:Entries[iLoop], QueryGroup))
                       oJoinAs = poGroup:join /* Use the overall group join. */
                       .
            else
                /* Create a simple clause frmo the given predicate. */
                assign cClause = this-object:BuildClause(phTable, cast(poGroup:Entries[iLoop], QueryPredicate))
                       oJoinAs = cast(poGroup:Entries[iLoop], QueryPredicate):Join
                       .

            /* Continue with joining the clause (single or nested) to the query if non-blank. */
            if (cClause gt "") eq true then
                assign cQueryString = this-object:MapJoin(cQueryString, cClause, oJoinAs).
        end. /* Looping Entries */

        return cQueryString.
    end method. /* BuildGroup */

    /* Builds a WHERE clause for a table from a QueryPredicate
       
       @param handle The table buffer handle
       @param QueryPredicate The abstract query predicate
       @return character A string representation of the where clause */
    method protected character BuildClause (input phTable  as handle,
                                            input poClause as QueryPredicate):
        define variable hField  as handle     no-undo.
        define variable cClause as character  no-undo.
        define variable cField  as character  no-undo.
        define variable cOper   as character  no-undo.
        define variable cType   as character  no-undo.

        /**
         * This should be the raw (public) field as provided by the front-end and must be mapped to a
         * valid internal temp-table field. This may be a serialized name, though the resulting field
         * buffer should be used to extract the real field name. Additionally, it may be impossible to
         * determine the correct datatype without assistance from the field buffer, so that too will be
         * used to convert the value appropriately for the resulting query phrase. 
         */
        assign hField = this-object:GetFieldBuffer(phTable, poClause:FieldName) no-error.

        if valid-handle(hField) then
            assign
                cField = hField:name
                cType  = hField:data-type
                .
        else
        do:
            assign cField = poClause:FieldName.

            /**
             * Note: There is no expectation that JSON data will map to RowID, Memptr,
             * or Handle datatypes so those are omitted from detection. Additionally,
             * use of the Values property for extent (array) values is not yet
             * supported due to lack of use-cases.
             */

            case true:
                when not valid-object(poClause:Value) and
                     not valid-object(poClause:Values) then
                    assign cType = "character".

                when type-of(poClause:Value, ILongcharHolder) or
                when type-of(poClause:Value, ILongcharArrayHolder) or
                when type-of(poClause:Value, ICharacterHolder) or
                when type-of(poClause:Value, ICharacterArrayHolder) then
                    assign cType = "character".

                when type-of(poClause:Value, IDateHolder) or
                when type-of(poClause:Value, IDateArrayHolder) then
                    assign cType = "date".

                when type-of(poClause:Value, IDateTimeHolder) or
                when type-of(poClause:Value, IDateTimeArrayHolder) then
                    assign cType = "datetime".

                when type-of(poClause:Value, IDateTimeTzHolder) or
                when type-of(poClause:Value, IDateTimeTzArrayHolder) then
                    assign cType = "datetime-tz".

                when type-of(poClause:Value, IDecimalHolder) or
                when type-of(poClause:Value, IDecimalArrayHolder) then
                    assign cType = "decimal".

                when type-of(poClause:Value, IInt64Holder) or
                when type-of(poClause:Value, IInt64arrayHolder) or
                when type-of(poClause:Value, IIntegerHolder) or
                when type-of(poClause:Value, IIntegerArrayHolder) then
                    assign cType = "integer".

                when type-of(poClause:Value, ILogicalHolder) or
                when type-of(poClause:Value, ILogicalArrayHolder) then
                    assign cType = "logical".
            
                otherwise
                    assign cType = "character".
            end case.
        end.

        /**
         * Based on the datatype, convert the value and obtain a valid operation string for the clause.
         * The string contains the replacement operators for a "substitute" using the field name and value.
         */
        case cType:
            when "character" then do:
                /* Assumes the Value should only be of Longchar/Character type. */
                if type-of(poClause:Value, ILongcharHolder) or type-of(poClause:Value, ICharacterHolder) then
                    assign cClause = substitute(this-object:MapOperator(poClause:Operator, cType),
                                                cField, poClause:Value:ToString()).
            end. /* character */

            when "date" then do:
                if type-of(poClause:Value, ILongcharHolder) or type-of(poClause:Value, ICharacterHolder) then
                    assign cClause = substitute(this-object:MapOperator(poClause:Operator, cType),
                                                cField, date(poClause:Value:ToString())).
                else if type-of(poClause:Value, IDateHolder) then
                    assign cClause = substitute(this-object:MapOperator(poClause:Operator, cType),
                                                cField, poClause:Value).
            end. /* date */

            when "datetime" then do:
                if type-of(poClause:Value, ILongcharHolder) or type-of(poClause:Value, ICharacterHolder) then
                    assign cClause = substitute(this-object:MapOperator(poClause:Operator, cType),
                                                cField, datetime(poClause:Value:ToString())).
                else if type-of(poClause:Value, IDateTimeHolder) then
                    assign cClause = substitute(this-object:MapOperator(poClause:Operator, cType),
                                                cField, poClause:Value).
            end. /* datetime */

            when "datetime-tz" then do:
                if type-of(poClause:Value, ILongcharHolder) or type-of(poClause:Value, ICharacterHolder) then
                    assign cClause = substitute(this-object:MapOperator(poClause:Operator, cType),
                                                cField, datetime-tz(poClause:Value:ToString())).
                else if type-of(poClause:Value, IDateTimeTzHolder) then
                    assign cClause = substitute(this-object:MapOperator(poClause:Operator, cType),
                                                cField, poClause:Value).
            end. /* datetime-tz */

            when "decimal" then do:
                if type-of(poClause:Value, ILongcharHolder) or type-of(poClause:Value, ICharacterHolder) then
                    assign cClause = substitute(this-object:MapOperator(poClause:Operator, cType),
                                                cField, decimal(poClause:Value:ToString())).
                else if type-of(poClause:Value, IDecimalHolder) then
                    assign cClause = substitute(this-object:MapOperator(poClause:Operator, cType),
                                                cField, poClause:Value).
            end. /* decimal */

            when "integer" then do:
                if type-of(poClause:Value, ILongcharHolder) or type-of(poClause:Value, ICharacterHolder) then
                    assign cClause = substitute(this-object:MapOperator(poClause:Operator, cType),
                                                cField, integer(poClause:Value:ToString())).
                else if type-of(poClause:Value, IIntegerHolder) or type-of(poClause:Value, IInt64Holder) then
                    assign cClause = substitute(this-object:MapOperator(poClause:Operator, cType),
                                                cField, poClause:Value).
            end. /* integer */

            when "logical" then do:
                if type-of(poClause:Value, ILongcharHolder) or type-of(poClause:Value, ICharacterHolder) then
                    assign cClause = substitute(this-object:MapOperator(poClause:Operator, cType),
                                                cField, logical(poClause:Value:ToString())).
                else if type-of(poClause:Value, ILogicalHolder) then
                    assign cClause = substitute(this-object:MapOperator(poClause:Operator, cType),
                                                cField, poClause:Value).
            end. /* logical */
        end case.

        return cClause.

        catch err as Progress.Lang.Error:
            return "". /* Return empty clause if an error is encountered. */
        end catch.
    end method. /* BuildClause */

    /***** End Protected / Begin Public *****/

    /* Builds a query handle (object) from a IGetDataRequest object. This method maps
       the input names to the input handle's SERIALIZE-NAMEs and uses the 'real'
       names to build the where clause
       
       @param IGetDataRequest A valid queryn definition
       @param handle a Dataset or buffer (TT or DB) handle 
       @return handle A valid QUERY handle */
    method public handle BuildQuery (input pFilter as IGetDataRequest,
                                     input pSchema as handle):
        define variable hQuery as handle no-undo.

        create query hQuery.
        hQuery:set-buffers(pSchema).
        hQuery:query-prepare(substitute("for each &1 &2", pSchema:name, this-object:BuildQueryString(pFilter, pSchema))).
        hQuery:query-open.

        return hQuery.
    end method. /* BuildQueryString */

    /* Builds a query string from a IGetDataRequest object. This method does
       no name conversions - just takes the names from the input object.
       
       @param IGetDataRequest A valid queryn definition
       @return character A complete WHERE clause , with no name conversions */
    method public character BuildQueryString (input pFilter as IGetDataRequest):
        /**
         * Call internal method with filter but no schema. However, due to the
         * need to utilize schema for detecting real field names (from public,
         * serialized names) and field datatypes this will likely result in a
         * thrown error. It is far better to call this method directly with a
         * dataset or temp-table handle.
         */
        return BuildQueryString(pFilter, ?).
    end method. /* BuildQueryString */

    /* Builds a query string from a IGetDataRequest object. This method maps
       the input names to the input handle's SERIALIZE-NAMEs and uses the 'real'
       names to build the where clause
       
       @param IGetDataRequest A valid queryn definition
       @param handle a Dataset or buffer (TT or DB) handle 
       @return character A complete WHERE clause */
    method public character BuildQueryString (input pFilter as IGetDataRequest,
                                              input pSchema as handle):
        define variable oQueryDef    as QueryDefinition no-undo.
        define variable oSortList    as QuerySortEntry  no-undo extent.
        define variable cQueryString as character       no-undo.
        define variable cTableQuery  as character       no-undo extent.
        define variable bhTable      as handle          no-undo.
        define variable bhField      as handle          no-undo.
        define variable iTable       as integer         no-undo.
        define variable iLoop        as integer         no-undo.
        define variable cSortBy      as character       no-undo extent.
        define variable cTable       as character       no-undo extent.

        /* Cycle through all the table requests for this filter. */
        extent(cSortBy) = extent(pFilter:TableRequests).
        extent(cTable) = extent(pFilter:TableRequests).
        extent(cTableQuery) = extent(pFilter:TableRequests).
        do iTable = 1 to extent(pFilter:TableRequests):
            if valid-handle(pSchema) and pSchema:type eq "dataset" then
                assign bhTable = this-object:GetTableBuffer(pSchema,
                                                            cast(pFilter:TableRequests[iTable], GetDataTableRequest):TableName).
            else if valid-handle(pSchema) and pSchema:type eq "temp-table" then
                assign bhTable = pSchema. /* Use given temp-table handle as-is. */

            /* Remember the real name for each table. */
            if valid-handle(bhTable) then
                assign cTable[iTable] = bhTable:name.

            assign oQueryDef = cast(cast(pFilter:TableRequests[iTable], GetDataTableRequest):QueryDefinition, QueryDefinition).
            assign oSortList = cast(oQueryDef:QuerySort, QuerySortEntry).

            /* Build either a nested query or a simple clause, depending on the object available. */
            if type-of(oQueryDef:QuerySelection, QueryGroup) then
                assign cTableQuery[iTable] = this-object:BuildGroup(bhTable, cast(oQueryDef:QuerySelection, QueryGroup)).
            else if type-of(oQueryDef:QuerySelection, QueryPredicate) then
                assign cTableQuery[iTable] = this-object:BuildClause(bhTable, cast(oQueryDef:QuerySelection, QueryPredicate)).

            if extent(oSortList) ne ? then
            do iLoop = 1 to extent(oSortList):
                if valid-object(oSortList[iLoop]) then do:
                    /* Create the sort clause based on the real field information. */
                    assign bhField = this-object:GetFieldBuffer(bhTable, oSortList[iLoop]:FieldName).
                    if valid-object(bhField) then
                        assign cSortBy[iTable] = trim(substitute("&1 by &2 &3", cSortBy[iTable], bhField:name,
                                                                 if oSortList[iLoop]:SortOrder eq Ccs.BusinessLogic.SortOrderEnum:Ascending
                                                                 then "" else oSortList[iLoop]:SortOrder:ToString())).
                    else /* Otherwise use the given field name. */
                        assign cSortBy[iTable] = trim(substitute("&1 by &2 &3", cSortBy[iTable], oSortList[iLoop]:FieldName,
                                                                 if oSortList[iLoop]:SortOrder eq Ccs.BusinessLogic.SortOrderEnum:Ascending
                                                                 then "" else oSortList[iLoop]:SortOrder:ToString())).
                end. /* Valid Sort Entry*/
            end. /* do iLoop */

            /* If query string is blank, set to simply "true". */
            if (cTableQuery[iTable] gt "") ne true then
                assign cTableQuery[iTable] = "true". /* Will add the "where" to this later. */

            /* If the table request's QueryString property is empty, provide the derived table query string and sort phrase. */
            if (cast(pFilter:TableRequests[iTable], GetDataTableRequest):QueryString gt "") ne true then
                cast(pFilter:TableRequests[iTable], GetDataTableRequest):QueryString = substitute("where &1 &2",
                                                                                                  cTableQuery[iTable],
                                                                                                  cSortBy[iTable]).
        end. /* extent pFilter:TableRequests */

        /* Build the query string from each table query. */
        do iLoop = 1 to extent(cTableQuery):
            if (cQueryString gt "") ne true then
                /* Set blank query string to first table's query string. */
                assign cQueryString = substitute("each &1 where &2", cTable[iLoop], cTableQuery[iLoop]).
            else
                /* If we have a valid name for an additional table, append the next table query. */
                assign cQueryString = substitute("&1, each &2 where &3", cQueryString, cTable[iLoop], cTableQuery[iLoop]).

            /* Trim commas and spaces from query string after each table. */
            assign cQueryString = trim(trim(cQueryString, ",")).
        end. /* extent cTableQuery */

        /* Add the sort phrases after all table "where" phrases. */
        do iLoop = 1 to extent(cSortBy):
            assign cQueryString = substitute("&1 &2", cQueryString, cSortBy[iLoop]).
        end. /* extent cSortBy */

        finally:
            /* Return the first TableRequest's query string by default. */
            return trim(cQueryString).
        end finally.
    end method. /* BuildQueryString */
    
end class.