/* *************************************************************************************************************************
Copyright (c) 2022 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : ProviderConfig
    Purpose     : Loads a providers.cfg from disk. This file MUST be in the OEAG's webapps/ROOT/WEB-INF/config folder
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2022-04-15
    Notes       : * PROVIDERS.CFG format
                        - may have named  groups (per operation)
                            - groups are typically named for the ooabl type (concrete implementations better)
                        - groups have properties
                  * Example
                    {
                        "OpenEdge.Security.Provider.UserTableAuthProvider": {
                            "passwordProvider": "Sports.Security.PWProvider",
                        }
                    }
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.File.
using OpenEdge.Core.Folder.
using OpenEdge.Core.Json.JsonPropertyHelper.
using OpenEdge.Core.Util.TokenResolver.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.LoggerBuilder.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.
using OpenEdge.Security.Provider.ProviderConfig.

@since(rel='12.6.0').
class OpenEdge.Security.Provider.ProviderConfig
final:
    
    // A reference to the Logger in use by an implementer
    define static public property Logger as ILogWriter no-undo
        get():
            // The LoggerBuilder handles caching of logwriter instances
            return LoggerBuilder:GetLogger(get-class(ProviderConfig)).
        end get.
        set.
    
    // The interval between checks, in seconds. Default/initial value is 60. A value of 0 means always check.
    define static public property FileCheckInterval as integer no-undo initial 60
        get.
        set(input pInterval as integer):
            // if we get bad values,
            // or nothing has changed,
            // keep the old value
            if pInterval eq ?
            or pInterval lt 0
            or pInterval eq ProviderConfig:FileCheckInterval
            then
                return.
            
            ProviderConfig:Logger:Info(substitute("Config file check interval changed to &1s (from &2)",
                                                  pInterval, ProviderConfig:FileCheckInterval)).
            
            assign ProviderConfig:FileCheckInterval = pInterval.
        end set.
    
    // Holds the JSON from disk
    var static private JsonObject mConfigData.
    
    // The webapps/ROOT/WEB-INF/config in which the File must be
    var static private Folder mCfgFolder.
    // The hard-coded name of the config file
    var static private File mCfgFile.
    // The timestamp of the last time the config file was checked
    var static private datetime-tz mLastCheckAt.
    // The timestamp at which we last read the config file
    var static private datetime-tz mLastUpdateAt.
    
    /** Default constructor */
    constructor private ProviderConfig():
        // Empty to prevent extension and/or calling
    end constructor.
            
    constructor static ProviderConfig():
        assign mCfgFolder = new Folder(TokenResolver:Resolve('$~{env.CATALINA_BASE}/webapps/ROOT/WEB-INF/config')).
        
        // We should always be able to resolve the path. The code should be prepared for cases like unit tests or
        // potentially misconfigured instances.
        if mCfgFolder:AbsolutePath() eq ? then
            assign mCfgFile = new File('providers.cfg').
        else
            assign mCfgFile = new File(mCfgFolder:AbsolutePath() + '/providers.cfg').
        
        LoadConfig().
    end constructor.
    
    /* Removes the currently-cached config
    */
    method public static void ClearConfig():
        // Remove the cached data, reset timers
        assign mConfigData   = ?
               mLastCheckAt  = ?
               mLastUpdateAt = ?
               .
    end method.
    
    /* Returns the Json configuration for a provider.
       
       @param character The group name for which to get the config
       @return logical Returns TRUE if we have loaded config AND if that config contains this group AND if the group contains
                       JSON object data; returns FALSE otherwise */
    method static public logical HasConfig(input pType as character):
        LoadConfig().
        
        return JsonPropertyHelper:HasTypedProperty(mConfigData, pType, JsonDataType:OBJECT).
    end method.
    
    /* Returns the Json configuration for a provider.
       
       @param character The group name for which to get the config
       @return JsonObject If configuration exists for this type, return it. Return unknown value in all other cases */
    method static public JsonObject GetConfig(input pType as character):
        var JsonObject cfg.
        
        Assert:NotNullOrEmpty(pType, 'Provider type').
        
        LoadConfig().
        
        if valid-object(mConfigData) then
            assign cfg = JsonPropertyHelper:GetObjectValue(mConfigData, pType, no).
        
        return cfg.
    end method.
    
    /* Loads configuration for this provider.
       The config file is checked for changes on an interval, and reloaded if there are changes to it. */
    method static private void LoadConfig():
        var JsonObject cfg.
        
        if mCfgFile:Exists then
        do on error undo, throw:
            Logger:Debug(substitute('Found config file &1', mCfgFile:AbsoluteFileName())).
            
            // env var must point under webapp's WEB-INF/config
            if not mCfgFile:AbsoluteFileName() begins mCfgFolder:AbsolutePath() then
            do:
                Logger:Error(substitute('Provider config &1 is not in &2', mCfgFile:Name, mCfgFolder:AbsolutePath())).
                return.
            end.
            
            if not ProviderConfig:FileCheckInterval eq 0
            // we haven't checked ever
            and not mLastCheckAt eq ?
            // we checked within the last n seconds ...
            and add-interval(mLastCheckAt, ProviderConfig:FileCheckInterval, "seconds":u) ge now
            then
            do:
                Logger:Debug(substitute('Config file not loaded: last checked at &1 ; file checked every &2sec',
                                        mLastCheckAt, ProviderConfig:FileCheckInterval)).
                return.
            end.
            assign mLastCheckAt = now.
            
            // Load config file if it exists and the file MOD timestamp is after the last value
            // if the file differs from the previous config file
            if mLastUpdateAt eq ?
            or mCfgFile:LastUpdatedAt gt mLastUpdateAt
            then
            do:
                Logger:Debug('Config file loaded').
                assign mConfigData   = cast(new ObjectModelParser():ParseFile(mCfgFile:AbsoluteFileName()), JsonObject)
                       mLastUpdateAt = now
                       .
                // Update this config too
                assign cfg = JsonPropertyHelper:GetObjectValue(mConfigData, get-class(ProviderConfig):TypeName, no).
                if JsonPropertyHelper:HasTypedProperty(cfg, 'fileCheckInterval', JsonDataType:NUMBER) then
                    assign ProviderConfig:FileCheckInterval = cfg:GetInteger('fileCheckInterval').
            end.
            
            catch uncaught as Progress.Lang.Error:
                // swallow
                Logger:Error('Unable to load providers.cfg', uncaught).
                // couldn't load? try again next time
                assign mLastCheckAt = ?.
            end catch.
        end.
        else
        do:
            Logger:Debug(substitute('Config file &1 not found', mCfgFile:Name)).
            // If the providers.cfg file was deleted, then remove any config here
            ClearConfig().
        end.
    end method.
    
end class.