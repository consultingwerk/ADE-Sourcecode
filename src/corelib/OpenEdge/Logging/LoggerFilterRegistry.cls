/* *************************************************************************************************************************
Copyright (c) 2016, 2018-2019 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : LoggerFilterRegistry
    Purpose     : Registry for types that hold log filters (format and writer)
    Description : 
    Author(s)   : pjudge
    Created     : 2016-11-14
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Util.BuilderRegistry.
using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.Format.ABLSubstituteFormat.
using OpenEdge.Logging.Format.AnonymizedTokenFormat.
using OpenEdge.Logging.Format.ErrorFormat.
using OpenEdge.Logging.Format.FullTextFormat.
using OpenEdge.Logging.Format.LogManagerFormat.
using OpenEdge.Logging.Format.MDCTokenFormat.
using OpenEdge.Logging.Format.ResolvedTokenFormat.
using OpenEdge.Logging.Format.StackWriterFormat.
using OpenEdge.Logging.Format.TokenContextFormat.
using OpenEdge.Logging.LoggerFilterRegistry.
using OpenEdge.Logging.Writer.JsonLogWriter.
using OpenEdge.Logging.Writer.LogManagerWriter.
using OpenEdge.Logging.Writer.MessageStatementWriter.
using OpenEdge.Logging.Writer.NamedFileWriter.
using OpenEdge.Logging.Writer.VoidWriter.

class OpenEdge.Logging.LoggerFilterRegistry:
    // Key for log manager logger implementations
    define static public property LOG_MANAGER_WRITER as character initial 'LOG_MANAGER_WRITER':u no-undo get.
    define static public property NAMED_FILE_WRITER  as character initial 'NAMED_FILE_WRITER':u  no-undo get.
    define static public property VOID_WRITER        as character initial 'VOID_WRITER':u        no-undo get.
    define static public property DEFAULT_WRITER     as character initial 'DEFAULT_WRITER':u     no-undo get.
    define static public property MSG_STMT_WRITER    as character initial 'MSG_STMT_WRITER':u    no-undo get.
    define static public property JSON_LOG_WRITER    as character initial 'JSON_LOG_WRITER':u    no-undo get.
    
    // Default filter configs    
    define static public property ABL_SUBSTITUTE_FORMAT as character initial 'ABL_SUBSTITUTE_FORMAT':u  no-undo get.
    define static public property LOG_MANAGER_FORMAT    as character initial 'LOG_MANAGER_FORMAT':u     no-undo get.
    define static public property STACK_WRITER_FORMAT   as character initial 'STACK_WRITER_FORMAT':u    no-undo get.
    define static public property FULL_TEXT_FORMAT      as character initial 'FULL_TEXT_FORMAT':u       no-undo get.
    define static public property ERROR_FORMAT          as character initial 'ERROR_FORMAT':u           no-undo get.
    // this format resolves a set of known tokens
    define static public property TOKEN_FORMAT          as character initial 'TOKEN_FORMAT':u           no-undo get.
    define static public property ANON_FORMAT           as character initial 'ANON_FORMAT':u            no-undo get.
    define static public property MDC_FORMAT            as character initial 'MDC_FORMAT':u             no-undo get.
    // this format combines all resolved tokens into a message string
    define static public property REPLACE_TOKENS_FORMAT as character initial 'REPLACE_TOKENS_FORMAT':u   no-undo get.
    
    /** Registry for mapping build types to their implementations */
    define static public property Registry as BuilderRegistry no-undo
        get():
            define variable oRegistry as BuilderRegistry no-undo.
            if not valid-object(LoggerFilterRegistry:Registry) then
            do:
                assign oRegistry = new BuilderRegistry(get-class(ILoggerFilter)).
                LoggerFilterRegistry:InitializeRegistry(oRegistry).
                assign LoggerFilterRegistry:Registry = oRegistry.
            end.
            return LoggerFilterRegistry:Registry.
        end get.
        private set.
    
    /** Adds initial values into the registry
        
        @param BuilderRegistry The registry to populate */
    method static private void InitializeRegistry(input poRegistry as BuilderRegistry):
        // WRITERS
        poRegistry:Put(LOG_MANAGER_WRITER, get-class(LogManagerWriter)).
        poRegistry:Put(NAMED_FILE_WRITER,  get-class(NamedFileWriter)).
        poRegistry:Put(VOID_WRITER,        get-class(VoidWriter)).
        poRegistry:Put(MSG_STMT_WRITER,    get-class(MessageStatementWriter)).
        poRegistry:Put(JSON_LOG_WRITER,    get-class(JsonLogWriter)).
        
        // Default to LOG-MANAGER for appservers 
        case session:client-type:
            when 'APPSERVER':u or
            when 'MULTI-SESSION-AGENT':u or
            when 'WEBSPEED':u then
                poRegistry:Put(DEFAULT_WRITER, get-class(LogManagerWriter)).
            otherwise
                poRegistry:Put(DEFAULT_WRITER, get-class(VoidWriter)).
        end case.
        
        // FORMATS
        poRegistry:Put(ABL_SUBSTITUTE_FORMAT,   get-class(ABLSubstituteFormat)).
        poRegistry:Put(LOG_MANAGER_FORMAT,      get-class(LogManagerFormat)).
        poRegistry:Put(FULL_TEXT_FORMAT,        get-class(FullTextFormat)).
        poRegistry:Put(STACK_WRITER_FORMAT,     get-class(StackWriterFormat)).
        poRegistry:Put(ERROR_FORMAT,            get-class(ErrorFormat)).
        poRegistry:Put(TOKEN_FORMAT,            get-class(ResolvedTokenFormat)).
        poRegistry:Put(ANON_FORMAT,             get-class(AnonymizedTokenFormat)).
        poRegistry:Put(MDC_FORMAT,              get-class(MDCTokenFormat)).
        poRegistry:Put(REPLACE_TOKENS_FORMAT,   get-class(TokenContextFormat)).
    end method.
    
end class.
