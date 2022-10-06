/* *************************************************************************************************************************
Copyright (c) 2016-2017, 2019, 2021-2022 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : ResolvedTokenFormat
    Purpose     : Formatter to allow a default message format to be built via this filter
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : Wed Nov 16 13:02:52 EST 2016
    Notes       : - This filter lets the output format be defined via config, as opposed to the standard formats
                    formats like FULL_TEXT_FORMAT or LOG_MANAGER_FORMAT
                  - The format defaults to ${msg.msg} (so only the message is written, without any timestamps etc)
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Core.StringConstant.
using OpenEdge.Core.Util.Token.
using OpenEdge.Core.Util.TokenResolver.
using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.Format.ISupportFormatting.
using OpenEdge.Logging.Format.LogMessageTokenResolver.
using OpenEdge.Logging.LogEvent.

class OpenEdge.Logging.Format.ResolvedTokenFormat
implements ILoggerFilter, ISupportFormatting, ISupportInitialize:
    
    /* Format for the logger name. See the OpenEdge.Core.Util.TokenResolver class for more */
    define public property Format as character no-undo get. set.
    
    /* An array of extracted format tokens */
    define private variable mFormatTokens as Token extent no-undo.
    
    /* Default constructor */
    constructor public ResolvedTokenFormat():
        // default format is simply the whole message
        assign this-object:Format = '$~{msg.msg}':u.
    end constructor.
    
    method public void Initialize():
        assign mFormatTokens = TokenResolver:Parse(this-object:Format).
    end method.
    
    method public void Destroy():
        assign extent(mFormatTokens) = ?.
    end method.
    
    /** Performs implementation-specific filtering for a logger type
        
        @param LogMessage The message to log. */
    method public void ExecuteFilter(input pEvent as LogEvent):
        var integer loop, cnt = extent(mFormatTokens).
        var logical addToken = false.
        
        TOKEN-LOOP:
        do loop = 1 to cnt:
            // We cannot add unknown objects to a Set
            if not valid-object(mFormatTokens[loop]) then
                next TOKEN-LOOP.
            
            assign addToken = yes.
            
            // this is a special token and we don't keep the value.
            if mFormatTokens[loop]:Group eq 'msg' then
            case entry(1, mFormatTokens[loop]:Arg, '.':u):
                when '':u or
                when 'msg':u then
                    assign pEvent:Message:Message = replace(this-object:Format,
                                                            '$':u + StringConstant:CURLY_OPEN + string(mFormatTokens[loop]) + StringConstant:CURLY_CLOSE,
                                                            pEvent:Message:Message )
                           
                           // this token should not be added to the message tokens, since it's special
                           addToken = no
                           .
            end case.
            
            // Add this token to the message. It will be resolved using the
            // TokenContextFormat filter before anything's written out
            if addToken then
                pEvent:Message:AddToken(mFormatTokens[loop]).
        end.
    end method.
    
end class.
