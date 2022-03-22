/************************************************
Copyright (c) 2016-2019, 2021 by Progress Software Corporation. All rights reserved.
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

using OpenEdge.Core.File.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Core.Util.TokenResolver.
using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.Filter.LogFilterBuilder.
using OpenEdge.Logging.LoggerFilterRegistry.
using OpenEdge.Logging.Writer.IFileWriter.
using OpenEdge.Logging.Writer.VoidWriter.
using Progress.IO.FileOutputStream.
using Progress.Lang.AppError.

class OpenEdge.Logging.Writer.FileLogWriterBuilder inherits LogFilterBuilder:
    /* Constructor */
    constructor public FileLogWriterBuilder(input filterName as character):
        super(filterName).
    end constructor.
    
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
        var File logfile.
        
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
                
                // might be ? for LOG-MANAGER
                if not logfileName eq ? then
                do:
                    // the File's ctor will barf on illegal characters
                    assign logfile = new File(TokenResolver:Resolve(logfileName)).
                
                    // If the folder or file cannot be written to, throw an error now, before we go any further
                    if not logfile:CanWriteToFile() then
                        undo, throw new AppError(substitute('Unable to write to &1', logfile:Name), 0).
                    
                    // this is the token-resolved, forward-slashed file name
                    assign logfileName = logfile:Name.
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
