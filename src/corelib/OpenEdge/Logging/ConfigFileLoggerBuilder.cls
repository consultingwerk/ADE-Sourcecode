/************************************************
Copyright (c) 2016-2022 by Progress Software Corporation. All rights reserved.
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
using OpenEdge.Core.File.
using OpenEdge.Logging.ConfigFileLoggerBuilder.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.JsonConfigLoggerBuilder.
using OpenEdge.Logging.LogLevelEnum.
using OpenEdge.Logging.LoggerBuilder.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.

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

    /* Returns the time (in seconds) elapsed since last file check (if an initial check was made) */
    define public static property TimeSinceCheck as int64 no-undo 
        get():
            var datetime dtCurrentTime = datetime(today, mtime). // Current time minus timezone.

            if ConfigFileLoggerBuilder:LAST_CHECK_TIMESTAMP eq ? then
                return 0. // If no timestamp then no time has elapsed.
            else
                // Get the elapsed time in seconds between now and then.
                return interval(dtCurrentTime, ConfigFileLoggerBuilder:LAST_CHECK_TIMESTAMP, 'seconds':u).
        end get.
        private set.

    /* Returns whether or not the config file has been changed (or never loaded). */
    define public static property ConfigFileChanged as logical no-undo 
        get():
            var datetime lastTouch.

            if not valid-object(ConfigFileLoggerBuilder:CONFIG_FILE) then
                return false. // If no file then no change.
            else if ConfigFileLoggerBuilder:CONFIG_FILE_TIMESTAMP eq ? then
                return true. // No timestamp means file was not loaded.
            else do:
                // If the config file exists and the file MOD timestamp is after the last value,
                // we must consider that the config file is changed and eligible for re-reading.
                assign lastTouch = ConfigFileLoggerBuilder:CONFIG_FILE:LastUpdatedAt.
                return (lastTouch gt ConfigFileLoggerBuilder:CONFIG_FILE_TIMESTAMP).
            end.
        end get.
        private set.

    // Monitors the time at which the config was last loaded
    define static private variable CONFIG_FILE_TIMESTAMP as datetime initial ? no-undo.

    // The name of the file (in propath) that contains logging configuration.
    define static private variable CONFIG_FILE_NAME as character no-undo initial 'logging.config':u.

    // Instance of File which is the loaded config file.
    define static private variable CONFIG_FILE as File no-undo.

    /* Static constructor */
    constructor static ConfigFileLoggerBuilder():
        ConfigFileLoggerBuilder:LoadFromFile(CONFIG_FILE_NAME).
    end constructor.

    /* Loads logging config from a file

       @param character The filename to load. */
    method static private void LoadFromFile(input pFileName as character):
        // We will skip the file load if any of the following conditions exist:
           // there's no interval (=0) always check
        if     not FileCheckInterval eq 0
           // we haven't checked the file ever
           and not LAST_CHECK_TIMESTAMP eq ?
           // we checked within the last n seconds ...
           and TimeSinceCheck le FileCheckInterval
        then
            return.

        Assert:NotNullOrEmpty(pFileName, 'Config file name').

        assign LAST_CHECK_TIMESTAMP = now.

        // After asserting the filename is present,
        // create a new File object if not available
        if not valid-object(CONFIG_FILE) then
            assign CONFIG_FILE = new File(pFileName).

        // If there's no readable file, do nothing.
        if not CONFIG_FILE:Exists and not CONFIG_FILE:CanRead then
        do:
            // We previously loaded some config, and now have removed the file
            if not CONFIG_FILE_TIMESTAMP eq ? then
                JsonConfigLoggerBuilder:ClearConfig().

            return.
        end.

        // Load config file if determined that the config file has changed (or was never loaded)
        if ConfigFileChanged then
        do:
            JsonConfigLoggerBuilder:ClearConfig().
            assign CONFIG_FILE_TIMESTAMP = ConfigFileLoggerBuilder:CONFIG_FILE:LastUpdatedAt.

            JsonConfigLoggerBuilder:LoadConfig(cast(new ObjectModelParser():ParseFile(CONFIG_FILE:AbsolutePath()), JsonObject)).
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
