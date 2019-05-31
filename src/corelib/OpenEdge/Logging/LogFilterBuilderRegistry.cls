/* *************************************************************************************************************************
Copyright (c) 2016, 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : LogFilterBuilderRegistry
    Purpose     : Registry for builders of filters
    Description : 
    Author(s)   : pjudge
    Created     : 2016-11-18
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Util.BuilderRegistry.
using OpenEdge.Logging.AnonymizedTokenFormatBuilder.
using OpenEdge.Logging.Filter.LogFilterBuilder.
using OpenEdge.Logging.LogFilterBuilderRegistry.
using OpenEdge.Logging.LoggerFilterRegistry.
using OpenEdge.Logging.Writer.FileLogWriterBuilder.

class OpenEdge.Logging.LogFilterBuilderRegistry:
    
    /** Registry for mapping build types to their implementations */
    define static public property Registry as BuilderRegistry no-undo
        get():
            define variable oRegistry as BuilderRegistry no-undo.
            if not valid-object(LogFilterBuilderRegistry:Registry) then
            do:
                assign oRegistry = new BuilderRegistry(get-class(LogFilterBuilder)).
                LogFilterBuilderRegistry:InitializeRegistry(oRegistry).                
                assign LogFilterBuilderRegistry:Registry = oRegistry.
            end.
            return LogFilterBuilderRegistry:Registry.
        end get.
        private set.
    
    /** Adds initial values into the registry 
        
        @param BuilderRegistry The registry to populate */
    method static private void InitializeRegistry(input poRegistry as BuilderRegistry):
        poRegistry:Put(LoggerFilterRegistry:LOG_MANAGER_WRITER, get-class(FileLogWriterBuilder)).
        poRegistry:Put(LoggerFilterRegistry:NAMED_FILE_WRITER,  get-class(FileLogWriterBuilder)).
        poRegistry:Put(LoggerFilterRegistry:ANON_FORMAT,        get-class(AnonymizedTokenFormatBuilder)).
    end method.
    
end class.
