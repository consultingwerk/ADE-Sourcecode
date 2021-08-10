/************************************************
Copyright (c) 2016-2019 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : FileLogFilterBuilder
    Purpose     : Builds a (named) file logger
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-11-14
    Notes       : * Token substitutions are allowed for file names
                    the token format is ${<token>}, where
                    token = group "." arg
                  * See OpenEdge.Logging.TokenResolver for more info about supported tokens
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Core.StringConstant.
using OpenEdge.Core.Util.TokenResolver.
using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.Filter.LogFilterBuilder.
using OpenEdge.Logging.LogLevelEnum.
using OpenEdge.Logging.LoggerFilterRegistry.
using OpenEdge.Logging.Writer.IFileWriter.
using OpenEdge.Logging.Writer.VoidWriter.
using Progress.IO.FileOutputStream.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.AppError.

class OpenEdge.Logging.Writer.FileLogWriterBuilder inherits LogFilterBuilder:
    // illegal characters for file names (on windows). 
    define protected property illegalChars as character extent 7 no-undo 
        initial ['<','>',':','"','|','?','*':u]
        get.
    
    /* Constructor */
    constructor public FileLogWriterBuilder(input filterName as character):
        super(filterName).
    end method.
    
    /** Returns a filter writer from a registry; either the optional one set via loggerFilterRegistry or
        the default LoggerFilterRegistry:Registry. It's the caller's responsibility to invoke and 
        use the filter type returned. 
        
        @return Progress.Lang.Class The type of the filter writer. */
    method override protected Progress.Lang.Class GetFilterType(input filterTypeName as character):
        define variable filterType as class Progress.Lang.Class no-undo.                
        
        assign filterType = super:GetFilterType(this-object:FilterType).
        
        /* If we get the VoidWriter when we didn't ask for it AND if the
           log-manager is running, use the log manager instead.       */
        if not valid-object(filterType) or
          ( filterType:IsA(get-class(VoidWriter)) 
            and this-object:FilterType ne LoggerFilterRegistry:VOID_WRITER 
            and log-manager:logfile-name ne ?                              )
        then
            assign filterType = this-object:GetFilterType(LoggerFilterRegistry:LOG_MANAGER_WRITER).
        
        return filterType.            
    end method.
    
    /* Creates the instance.
       
       @return ILoggerFilter A filter instance  */
    method override protected ILoggerFilter NewFilter(  ):
        define variable filter as ILoggerFilter no-undo.
        define variable filterType as class Progress.Lang.Class no-undo.
        define variable fileStream as FileOutputStream no-undo.
        define variable appendToFile as logical no-undo.
        define variable logfileName as character no-undo.
        define variable chrLoop as integer no-undo.
        define variable chrMax as integer no-undo.
        define variable chrStart as integer no-undo.
        
        assign filterType = GetFilterType(this-object:FilterType).
        
        case true:
            when not valid-object(filterType) then
                return filter.
            
            // if this is not a file writer then let the default writer take over
            when not filterType:IsA(get-class(IFileWriter)) then
                return super:newFilter().
            
            when HasOption('writeToFileStream':u) then
            do:
                assign fileStream = cast(GetOptionObjectValue('writeToFileStream':u), FileOutputStream).
                filter = dynamic-new string(filterType:TypeName) (fileStream).
            end.
            
            otherwise
            do:
                assign logfileName = GetOptionStringValue('fileName':u).
                
                // if there's no file name (from either the input or the log-manager) then
                // we cannot create a meaningful writer
                if     logfileName eq ?
                   and log-manager:logfile-name eq ?
                then 
                    return filter.
                
                assign logfileName = replace(TokenResolver:Resolve(logfileName), StringConstant:BACKSLASH, '/':u).
                
                // certain characters are illegal on windows
                if opsys eq 'win32':u then
                do:
                    assign chrMax   = extent(illegalChars)
                           chrStart = 3.
                    if logfileName begins '/':u then
                        assign chrStart = 1.
                    
                    do chrLoop = 1 to chrMax:
                        if index(logfileName, illegalChars[chrLoop], chrStart) gt 0 then
                            return error new AppError(substitute('Illegal character &1 in filename &2',
                                                        illegalChars[chrLoop],
                                                        logfileName),
                                                     0). 
                    end.
                end.
                
                assign appendToFile = GetOptionLogicalValue('appendTo':u).
                if appendToFile eq ? then
                    assign appendToFile = true.
                
                filter = dynamic-new string(filterType:TypeName) (logfileName, appendToFile).
            end.
        end case.
        
        if type-of(filter, ISupportInitialize) then
            cast(filter, ISupportInitialize):Initialize().
        
        return filter.
    end method.
    
end class.
