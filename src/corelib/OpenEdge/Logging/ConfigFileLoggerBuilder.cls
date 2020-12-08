/************************************************
Copyright (c) 2016-2019 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : ConfigFileLoggerBuilder
    Purpose     : Loads JSON-based logger configuration from a known file 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Dec 05 09:48:11 EST 2016
    Notes       : * Assumes the config is stored in a JSON file
                    - named logging.config that is in PROPATH
                    - matching the schema in $DLC/src/corelib/OpenEdge/Logging/logging.config.schema
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.JsonConfigLoggerBuilder.
using OpenEdge.Logging.LogLevelEnum.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Logging.VoidLogger.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.

class OpenEdge.Logging.ConfigFileLoggerBuilder inherits JsonConfigLoggerBuilder:
    // Monitors the time at which the config was last loaded
    define static private variable CONFIG_FILE_TIMESTAMP as datetime init ? no-undo.
    
    // The name of the file (in propath) that contains logging configuration.
    define static private variable CONFIG_FILE_NAME as character no-undo
            initial 'logging.config':u.
    
    /* Static constructor */
    constructor static ConfigFileLoggerBuilder():
        LoadFromFile(CONFIG_FILE_NAME).
    end constructor.
    
    /* Loads logging config from a file
       
       @param character The filename to load. */
    method static private void LoadFromFile(input pFileName as character):
        define variable lastTouch as datetime no-undo.
        
        Assert:NotNullOrEmpty(pFileName, 'Config file name').
        
        assign file-info:file-name = pFileName.
        
        // if there's no file, do nothing.
        if file-info:full-pathname eq ? then
        do: 
            // We previously loaded some config, and now have removed the file
            if not CONFIG_FILE_TIMESTAMP eq ? then
                JsonConfigLoggerBuilder:ClearConfig().
            
            return.
        end.
        
        assign lastTouch = add-interval(datetime(file-info:file-mod-date), file-info:file-mod-time, 'seconds':u).
        
        // Load config file if it exists and the file MOD timestamp is after the last value
        // if the file differs from the previous config file
        if    CONFIG_FILE_TIMESTAMP eq ?
           or lastTouch gt CONFIG_FILE_TIMESTAMP
        then
        do:
            JsonConfigLoggerBuilder:ClearConfig().
            assign CONFIG_FILE_TIMESTAMP = lastTouch.
            
            JsonConfigLoggerBuilder:LoadConfig(cast(new ObjectModelParser():ParseFile(file-info:full-pathname), JsonObject)).
        end.
        
        catch loadError as Progress.Lang.Error:
            LoggerBuilder:LogMessage(substitute('Error loading &1 : &2', pFileName, loadError:GetMessage(1)),
                                     LogLevelEnum:ERROR).
        end catch.
    end method.
    
    /* Constructor
       
       @param character The logger type being built */
    constructor public ConfigFileLoggerBuilder (input pcLoggerType as character):
        super(pcLoggerType).
    end method.
    
    /* Constructs the actual logger instance
       
       @return ILogWriter A new or cached logged */
    method override protected ILogWriter GetLoggerInstance():
        // reload on every logger request. Will no-op if the file hasn't changed
        LoadFromFile(CONFIG_FILE_NAME).
        
        // build from the JSON config
        return super:GetLoggerInstance().
        
        catch err as Progress.Lang.Error:
            LoggerBuilder:LogMessage(substitute('Error building logger &1: &2', 
                                     this-object:LoggerType,
                                     err:GetMessage(1)),
                                     LogLevelEnum:ERROR).
            
            return new VoidLogger(this-object:LoggerType).
        end catch.
    end method.
    
end class.
