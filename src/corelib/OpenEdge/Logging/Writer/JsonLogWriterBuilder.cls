/* *************************************************************************************************************************
Copyright (c) 2019 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : JsonLogWriterBuilder
    Purpose     : Builds a JSON array log writer 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2019-08-29
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.Filter.LogFilterBuilder.
using OpenEdge.Logging.Writer.JsonLogWriter.
using Progress.Json.ObjectModel.JsonArray.

class OpenEdge.Logging.Writer.JsonLogWriterBuilder inherits LogFilterBuilder: 
    /* Constructor 
       
       @param character The filter type being built */
    constructor public JsonLogWriterBuilder ( input pcFilterType as character ):
        super (input pcFilterType).
    end constructor.
    
    /* Creates the filter instance
       
       @return ILoggerFilter A filter instance  */
    method override protected ILoggerFilter NewFilter():
        define variable logFilter as ILoggerFilter no-undo.
        
        // default construction
        logFilter = super:NewFilter().
        
        // Set the passedin array as the log target 
        if     type-of(logFilter, JsonLogWriter)
           and HasOption('writeToJsonArray':u) 
        then
            assign cast(logFilter, JsonLogWriter):LogData = cast(GetOptionObjectValue('writeToJsonArray':u), JsonArray).
        
        if type-of(logFilter, ISupportInitialize) then
            cast(logFilter, ISupportInitialize):Initialize().
        
        return logFilter.
    end method.
    
end class.