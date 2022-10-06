/* *************************************************************************************************************************
Copyright (c) 2019-2020, 2022 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : JsonLogWriter
    Purpose     : Writes log messages to a JSON Array
    Description :
    Author(s)   : pjudge
    Created     : 2019-08-29
    Notes       : * This class uses an array for the messages because that
                    ensures the order
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.ILongcharArrayHolder.
using OpenEdge.Core.Json.JsonConverter.
using OpenEdge.Core.Util.Token.
using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.LogEvent.
using Progress.Collections.IIterator.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonObject.

class OpenEdge.Logging.Writer.JsonLogWriter implements ILoggerFilter:
    /* An array of log messages */
    define public property LogData as JsonArray no-undo
        get.
        set.
    
    /* Default constructor */
    constructor public JsonLogWriter():
        assign this-object:LogData = new JsonArray().
    end constructor.
    
    /* Performs implementation-specific filtering for a logger type
        
       @param LogEvent The event to capture. */
    method public void ExecuteFilter(input pEvent as LogEvent ):
        define variable ctx as Progress.Lang.Object no-undo.
        define variable localLogData as JsonObject no-undo.
        var IIterator<Token> iter.
        var JsonObject tokens.
        
        // because the LogData property is mutable, don't fail if someone's
        // 'accidentally' deleted it
        if not valid-object(this-object:LogData) then
            assign this-object:LogData = new JsonArray().
        
        assign localLogData = new JsonObject().
        // append this log event to the array
        this-object:LogData:Add(localLogData).
        
        // don't write the LoggedBy user; we may want to anonymise that or otherwise
        // mask it.
        localLogData:Add('loggedAt':u,   pEvent:TimeStamp).
        localLogData:Add('level':u,      string(pEvent:LogLevel)).
        localLogData:Add('msg':u,        pEvent:Message:Message).
        
        localLogData:Add('hasError':u,   valid-object(pEvent:Error)).
        if valid-object(pEvent:Error) then
        localLogData:Add('error':u, JsonConverter:ToObject(pEvent:Error)).
        
        localLogData:Add('loggerName':u, pEvent:LoggerName).
        localLogData:Add('msgStack':u,   new JsonArray(pEvent:CallStack)).
        
        // tokens, names and values
        if pEvent:Message:Tokens:Count gt 0 then
        do:
            localLogData:Add('baseText', pEvent:Message:BaseText).
            assign tokens = new JsonObject()
                   iter   = pEvent:Message:Tokens:GetIterator()
                   .
            localLogData:Add('tokens', tokens).
            do while iter:MoveNext():
                // the Token's ToString() reconstitutes the group.arg value
                tokens:Add(string(iter:Current), iter:Current:Value).
            end.
        end.
        
        // args
        assign ctx = pEvent:Message:GetContext('args':u).
        if  valid-object(ctx)
        and type-of(ctx, ILongcharArrayHolder)
        then
            localLogData:Add('ctx.args':u, JsonConverter:ToArray(cast(ctx, ILongcharArrayHolder))).
    end method.
    
end class.
