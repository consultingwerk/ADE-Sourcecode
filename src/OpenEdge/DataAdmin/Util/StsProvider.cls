/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : StsProvider
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Apr 27 13:38:38 EDT 2016
    Notes       : * export per schema below
                    "providers": {
                            "type": "object",
                            "patternProperties": {
                                "^[A-Za-z] * / [A-Za-z$0-9-.]*$": {
                                    "type": "object",
                                    "properties": {
                                        "type": {
                                            "type": "string",
                                            "pattern": "^[A-Za-z]+[A-Za-z$0-9-&#%.]+[A-Za-z$0-9-&#%]*$"
                                        },
                                        "hash": {
                                            "type": "string",
                                            "description": "A hash value to validate that the running handler is the expected version."
                                        }
                                    },
                                    "required": [
                                        "type"
                                    ]
                                }
                            }
                        },        
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Assertion.AssertJson.
using OpenEdge.Core.JsonDataTypeEnum.
using OpenEdge.DataAdmin.Util.StsProvider.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.AppError.

class OpenEdge.DataAdmin.Util.StsProvider:
    
    /* The (short) reference of the provider */
    define public property ProviderReference as character no-undo get. private set.

    /* An ABL type name for the provider */
    define public property ProviderType as character no-undo get. set.
    
    /* A hash value to validate that the running handler is the expected version. */
    define public property TypeHash as character no-undo get. set.
    
    constructor public StsProvider(input pcRef as character):
        Assert:NotNullOrEmpty(pcRef, 'Provider reference').
        assign ProviderReference = pcRef.
    end constructor.

    /* Creates a StsProvider instance from JSON config
    
       @param JsonObject the config for a single provider, per the schema above
       @return StsProvider A configured provider */
    method static public StsProvider ImportConfig(input poConfig as JsonObject):
        define variable cPropNames as character extent no-undo.
        define variable oDetail as JsonObject no-undo.
        
        Assert:NotNull(poConfig, 'Provider config').
        
        assign cPropNames = poConfig:GetNames().
        
        if extent(cPropNames) eq ? or extent(cPropNames) gt 1 then
            return error new AppError(substitute('Expecting a single provider configuration, received &1',
                                            extent(cPropNames))
                                      , 0).           
        
        AssertJson:PropertyIsType(poConfig, cPropNames[1], JsonDataTypeEnum:Object).
        
        return ImportConfig(cPropNames[1], 
                            poConfig:GetJsonObject(cPropNames[1])).
    end method.
                    
    /* Creates a StsProvider instance from JSON config
    
       @param character The provider reference
       @param JsonObject the config for a single provider, per the schema above
       @return StsProvider A configured provider */
    method static public StsProvider ImportConfig(input pcRef as character,
                                                  input poConfig as JsonObject):
        define variable oProvider as StsProvider no-undo.
        
        Assert:NotNull(poConfig, 'Provider config').
        Assert:NotNullOrEmpty(pcRef, 'Provider reference').
        
        assign oProvider = new StsProvider(pcRef).
        
        AssertJson:PropertyIsType(poConfig, 'type':u, JsonDataTypeEnum:String).
        assign oProvider:ProviderType = poConfig:GetCharacter('type':u).
        
        if poConfig:Has('hash':u) then
            assign oProvider:TypeHash = poConfig:GetCharacter('hash':u).
        
        return oProvider.
    end method.
    
    /* Returns a JSON representation of this
       
       @return JsonObject A JSON representation  of this object */
    method public JsonObject ExportConfig():
        define variable oProvider as JsonObject no-undo.
        
        assign oProvider = new JsonObject().
        
        oProvider:Add('type':u, this-object:ProviderType).
        oProvider:Add('hash':u, this-object:TypeHash).
        
        return oProvider.
    end method.
    
end class.    
