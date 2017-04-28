/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : StsDomainConfig
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Apr 27 13:38:38 EDT 2016
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Collections.IStringKeyedMap.
using OpenEdge.Core.Collections.StringKeyedMap.
using Progress.Json.ObjectModel.JsonObject.
using OpenEdge.DataAdmin.Util.StsDomainConfig.
using OpenEdge.Core.Assert.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.DataAdmin.Util.StsDomain.
using OpenEdge.DataAdmin.Util.StsProvider.
using Progress.Json.ObjectModel.JsonArray.

class OpenEdge.DataAdmin.Util.StsDomainConfig serializable:
    define static private property PROP_VERSION as character no-undo
        initial 'version':u
        get.

    define static private property PROP_DOMAINS as character no-undo
        initial 'domains':u
        get.
        
    define static private property PROP_POLICY_PROVIDERS as character no-undo
        initial 'policyProviders':u
        get.

    define static private property PROP_EVENT_PROVIDERS as character no-undo
        initial 'eventProviders':u
        get.
        
    /* the version of the config */
    define public property Version as character no-undo get. private set.
    
    /* The set of domains being worked on */
    define public property Domains as IStringKeyedMap no-undo get. private set.
    
    /* The policy providers supporting these domains */
    define public property PolicyProviders as IStringKeyedMap no-undo get. private set.
    
    /* The event providers supporting these domains */
    define public property EventProviders as IStringKeyedMap no-undo get. private set.
    
    /* Default constructor */
    constructor public StsDomainConfig():
        super().
        
        assign Domains         = new StringKeyedMap()
               PolicyProviders = new StringKeyedMap()
               EventProviders  = new StringKeyedMap()
               Version         = '1.0.0':u
               .
    end constructor.
    
    /* Exports this config to JSON 
       
       @return JsonObject The config as JSON */
    method public JsonObject ExportConfig():
        define variable oConfig as JsonObject no-undo.
        define variable oEntry as Progress.Lang.Object no-undo.
        define variable oItemJson as JsonObject no-undo.
        define variable oGroupJson as JsonObject no-undo.
        define variable oDomainArray as JsonArray no-undo.
        define variable oIterator as IIterator no-undo.
        
        assign oConfig = new JsonObject().
        
        oConfig:Add(PROP_VERSION, this-object:Version).
        
        oDomainArray = new JsonArray().
        oConfig:Add(PROP_DOMAINS, oDomainArray).
        
        assign oIterator = this-object:Domains:Values:Iterator().
        do while oIterator:HasNext():
            oEntry = oIterator:Next().
            oItemJson = cast(oEntry, StsDomain):ExportConfig().
            oDomainArray:Add(oItemJson).
        end.
        
        oGroupJson = new JsonObject().
        oConfig:Add(PROP_POLICY_PROVIDERS, oGroupJson).
        assign oIterator = this-object:PolicyProviders:Values:Iterator().
        do while oIterator:HasNext():
            oEntry = oIterator:Next().
            oItemJson = cast(oEntry, StsProvider):ExportConfig().
            oGroupJson:Add(cast(oEntry, StsProvider):ProviderReference, oItemJson).
        end.
        
        oGroupJson = new JsonObject().
        oConfig:Add(PROP_EVENT_PROVIDERS,  oGroupJson).
        assign oIterator = this-object:EventProviders:Values:Iterator().
        do while oIterator:HasNext():
            oEntry = oIterator:Next().
            oItemJson = cast(oEntry, StsProvider):ExportConfig().
            oGroupJson:Add(cast(oEntry, StsProvider):ProviderReference, oItemJson).
        end.
        
        return oConfig.
    end method.

    /* Imports a config from a JSON file */
    method static public StsDomainConfig ImportConfig(input poConfig as JsonObject):
        define variable oDomainConfig as StsDomainConfig no-undo.
        define variable oGroup as JsonObject no-undo.
        define variable oDomains as JsonArray no-undo.
        define variable oItem as JsonObject no-undo.
        define variable oStsDomain as StsDomain no-undo.
        define variable oStsProvider as StsProvider no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable cNames as character extent no-undo.
        
        assign oDomainConfig = new StsDomainConfig()
               
               oDomains = poConfig:GetJsonArray(PROP_DOMAINS)
               iMax = oDomains:Length 
               .
        do iLoop = 1 to iMax:
            assign oItem = oDomains:GetJsonObject(iLoop)
                   oStsDomain = StsDomain:ImportConfig(oItem).
            oDomainConfig:Domains:Put(oStsDomain:Name, oStsDomain).
        end.
        
        assign oGroup = poConfig:GetJsonObject(PROP_POLICY_PROVIDERS)
               extent(cNames) = ?
               cNames = oGroup:GetNames().
        do iLoop = extent(cNames) to 1 by -1:
            assign oItem        = oGroup:GetJsonObject(cNames[iLoop])
                   oStsProvider = StsProvider:ImportConfig(cNames[iLoop], oItem).
            oDomainConfig:PolicyProviders:Put(oStsProvider:ProviderReference, oStsProvider).
        end.
        
        assign oGroup = poConfig:GetJsonObject(PROP_EVENT_PROVIDERS)
               extent(cNames) = ?
               cNames = oGroup:GetNames().
        do iLoop = extent(cNames) to 1 by -1:
            assign oItem        = oGroup:GetJsonObject(cNames[iLoop])
                   oStsProvider = StsProvider:ImportConfig(cNames[iLoop], oItem).
            oDomainConfig:EventProviders:Put(oStsProvider:ProviderReference, oStsProvider).
        end.
        
        return oDomainConfig.
    end method.
end class.