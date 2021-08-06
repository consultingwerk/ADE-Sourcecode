/* *************************************************************************************************************************
Copyright (c) 2020 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : QueryEntryDeserializer
    Purpose     : Helper class to deserialize a JSON object into an instance of
                  IQueryEntry - either a IQueryGroup or IQueryPredicate
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2020-09-17
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.BusinessLogic.IQueryEntry.
using Ccs.BusinessLogic.IQueryGroup.
using Ccs.BusinessLogic.IQueryPredicate.
using OpenEdge.BusinessLogic.QueryGroup.
using OpenEdge.BusinessLogic.QueryPredicate.
using OpenEdge.Core.Json.IJsonSerializer.
using OpenEdge.Core.Json.JsonSerializer.
using Progress.Json.ObjectModel.JsonObject.

class OpenEdge.BusinessLogic.IO.QueryEntryDeserializer:
    
    /* Default constructor is private to avoid instantiation */
    constructor private QueryEntryDeserializer():
        /* Default constructor is private to avoid instantiation */
    end constructor.
    
    /* Attempts to convert a JSON object into a IQueryEntry (either an IQueryGroup or IQueryPredicate).
       
       @param JsonObject The serialised JSON data. May be null/unknown.
       @return IQueryEntry The query entry representing that JSON. Either an IQueryGroup or IQueryPredicate. Always
                           returns at least a IQueryPRedicate, even if the JSON is null or badly-formed. */
    method static public IQueryEntry QueryEntryFromJson(input pJson as JsonObject):
        define variable qe as IQueryEntry no-undo.
        define variable array as Progress.Lang.Object extent no-undo.
        
        assign qe = cast(JsonSerializer:ToAblObject(pJson,
                                                    get-class(IQueryGroup),
                                                    get-class(QueryGroup)),
                         IQueryEntry).
        if valid-object(qe)
        and type-of(qe, IQueryGroup)
        then
        do:
            assign array = cast(qe, IQueryGroup):Entries.
            // nothing changed here
            if extent(array) eq ? then
                assign qe = ?.
        end.
        
        if not valid-object(qe) then
            assign qe = cast(JsonSerializer:ToAblObject(pJson,
                                                        get-class(IQueryPredicate),
                                                        get-class(QueryPredicate)),
                             IQueryEntry).
        
        return qe.
    end method.
end class.