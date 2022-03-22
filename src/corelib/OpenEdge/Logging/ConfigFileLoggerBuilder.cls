/************************************************
Copyright (c) 2016-2021 by Progress Software Corporation. All rights reserved.
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
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.
using OpenEdge.Logging.ConfigFileLoggerBuilder.

class OpenEdge.Logging.ConfigFileLoggerBuilder inherits JsonConfigLoggerBuilder:
    /* The time at which we last checked the config file */
    define static private variable LAST_CHECK_TIMESTAMP as datetime initial ? no-undo.
    
    /* The interval between checks, in seconds. Default/initial value is 60. A value of 0 means always check */
    define static public property FileCheckInterval as integer no-undo initial 60
        get.
        set(input pInterval as integer):
            // if we get bad values, keep the old one
            if    pInterval eq ?
               or pInterval lt 0
            then
                return.
            
            LoggerBuilder:LogMessage(substitute('Config file check interval changed to &1s (from &2)', pInterval, FileCheckInterval),
                                     LogLevelEnum:INFO).
            assign FileCheckInterval = pInterval.
        end set.
    
    // Monitors the time at which the config was last loaded
    define static private variable CONFIG_FILE_TIMESTAMP as datetime initial ? no-undo.
    
    // The name of the file (in propath) that contains logging configuration.
    define static private variable CONFIG_FILE_NAME as character no-undo
            initial 'logging.config':u.
    
    /* Static constructor */
    constructor static ConfigFileLoggerBuilder():
        ConfigFileLoggerBuilder:LoadFromFile(CONFIG_FILE_NAME).
    end constructor.
    
    /* Loads logging config from a file
       
       @param character The filename to load. */
    method static private void LoadFromFile(input pFileName as character):
        define variable lastTouch as datetime no-undo.
        
           // there's no interval = always check
        if     not FileCheckInterval eq 0
           // we haven't checked ever
           and not LAST_CHECK_TIMESTAMP eq ?
           // we checked within the last n seconds ...
           and add-interval(LAST_CHECK_TIMESTAMP, FileCheckInterval, 'seconds':u) ge now
        then
            return.
        
        Assert:NotNullOrEmpty(pFileName, 'Config file name').
        
        assign LAST_CHECK_TIMESTAMP = now
               file-info:file-name  = pFileName
               .
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
    end constructor.
    
    /* Constructs the actual logger instance
       
       @return ILogWriter A new or cached logged */
    method override protected ILogWriter GetLoggerInstance():
        // reload on every logger request. Will no-op if the file hasn't changed
        ConfigFileLoggerBuilder:LoadFromFile(CONFIG_FILE_NAME).
        
        // build from the JSON config
        return super:GetLoggerInstance().
    end method.
    
    /* Clears the config - resets last-read and other timestamps.
       This will cause the next request for a file-based logger to re-check
       the file on disk */
    method override static public void ClearConfig():
        // "inheritance"
        JsonConfigLoggerBuilder:ClearConfig().
        
        assign LAST_CHECK_TIMESTAMP  = ?
               CONFIG_FILE_TIMESTAMP = ?
               .
    end method.
    
end class.
