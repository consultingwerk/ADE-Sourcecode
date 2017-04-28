/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : ClientValidator
    Purpose     : Validates the client-principal passed in from an STS 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Feb 26 13:53:15 EST 2016
    Notes       : * PROVIDERS.JSON format
                        - may have named  groups (per operation)
                            - groups are typically named for the ooabl type (concrete implementations better)
                        - groups have properties
                            validateClient : logical (not unknown)
                            sealKey : character 
                            requiredRoles :
                                string
                                array-of-strings
                                object :
                                    "<authz operation>" : string or array-of-strings
                  * Example
                    {
                        "OpenEdge.Security.Provider.UserTableAuthProvider": {
                            "validateClient": true,
                            "requiredRoles": "STS_VALIDATE_USER",
                            "sealKey": "oech1::20333c34252a2137",
                            "passwordProvider": "Sports.Security.PWProvider"
                        },
                        "OpenEdge.Security.STS.EventDispatcher":{
                            "validateClient": true,
                            "requiredRoles": {
                                "EmitEvent": ["STS_EMIT_EVENT"],
                                "ApplyPolicy: ["STS_EMIT_EVENT"] },
                            "sealKey": "oech1::20333c34252a2137"
                        }
                    }    
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.LogLevelEnum.
using OpenEdge.Security.Principal.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.

class OpenEdge.Security.STS.ClientValidator:
    /* Security config for this provider */
    define private variable moConfig as JsonObject no-undo.
    
    /* default constructor */
    constructor public ClientValidator():
        LoadConfig().
    end constructor. 

    /* constructor
    
       @param JsonObject Configuration data */
    constructor public ClientValidator(input poConfig as JsonObject):
        Assert:NotNull(poConfig, 'Config').
        
        assign moConfig = poConfig.
    end constructor.

    /* Loads configuration for this provider */
    method private void LoadConfig():
        file-info:file-name = 'providers.cfg'.
        if file-info:full-pathname eq ? then
            file-info:file-name = os-getenv('PROVIDER_CONFIG':u).
        
        if file-info:full-pathname ne ? then
            assign moConfig = cast(new ObjectModelParser():ParseFile(file-info:full-pathname), JsonObject).        
    end method.

    /* Validates that the STS is allowed to make this call. The caller decides what to
       do with the result
       
       @param character The group containing the operation being authorised
       @param character The operation (in this class) being authorised
       @return logical TRUE if the client is authenticated and authorised to perform this operation
                        FALSE otherwise */
    method public logical Validate(input pcGroup as character,
                                   input pcOperation as character):
        define variable oPrincipal as Principal no-undo.
        define variable cRoles as character extent no-undo.
        define variable lOK as logical no-undo.
        define variable oRoles as JsonArray no-undo.
        define variable oRoleParent as JsonObject no-undo.
        define variable oGroupConfig as JsonObject no-undo.
        
        if not valid-object(moConfig) then
        do:
            LogMessage('No config available', LogLevelEnum:WARN).
            return true.
        end.
        
        if moConfig:Has(pcGroup) and
           moConfig:GetType(pcGroup) eq JsonDataType:OBJECT then
            assign oGroupConfig = moConfig:GetJsonObject(pcGroup). 
        else
        do:
            LogMessage(substitute('Config available but has incorrect format: &1', moConfig:GetType(pcGroup)),
                       LogLevelEnum:WARN).
            return true.
        end.
        
        if not oGroupConfig:GetLogical('validateClient':u) then
        do:
            LogMessage('Client validation disabled',
                       LogLevelEnum:DEBUG).
            return true.
        end.
        
        assign oPrincipal = Principal:Import(session:current-request-info)
               lOK        = oPrincipal:Validate(oGroupConfig:GetCharacter('sealKey':u)).
        if lOK then
        do:
            /* 1. Check if there are any roles
               2. If requiredRoles are STRING, ensure that the principal has that role
               3. If requiredRoles are ARRAY-OF-STRINGS, ensure that the principal has all those role
               4. If requiredRoles are JSON-OBJECT then the operation must exist and the role(s) must exist. */
            if oGroupConfig:Has('requiredRoles':u) then
            case oGroupConfig:GetType('requiredRoles':u):
                when JsonDataType:ARRAY then
                    assign oRoles = oGroupConfig:GetJsonArray('requiredRoles':u)
                           cRoles = oRoles:GetCharacter(1, oRoles:Length).
                when JsonDataType:STRING then 
                    assign extent(cRoles) = 1
                           cRoles[1] = oGroupConfig:GetCharacter('requiredRoles':u).
                when JsonDataType:OBJECT then
                do:
                    Assert:NotNullOrEmpty(pcOperation, 'Authorisation operation').
                    if oGroupConfig:IsNull('requiredRoles':u) then
                        LogMessage(substitute('Undefined roles for operation &1', pcOperation),
                                   LogLevelEnum:WARN).
                    else
                    do:
                        assign oRoleParent = oGroupConfig:GetJsonObject('requiredRoles':u).
                        if oRoleParent:Has(pcOperation) then
                        case oRoleParent:GetType(pcOperation):
                            when JsonDataType:ARRAY then
                                assign oRoles = oRoleParent:GetJsonArray(pcOperation)
                                       cRoles = oRoles:GetCharacter(1, oRoles:Length). 
                            when JsonDataType:STRING then
                                assign extent(cRoles) = 1
                                       cRoles[1] = oRoleParent:GetCharacter(pcOperation).
                            otherwise
                                LogMessage(substitute('Unsupported Undefined roles for operation &1', pcOperation),
                                           LogLevelEnum:WARN).
                        end case.
                    end.
                end.    //OBJECT
                otherwise
                    /* includes NULL values */
                    LogMessage(substitute('Undefined roles for operation &1', pcOperation),
                               LogLevelEnum:WARN).
            end case.
            
            if extent(cRoles) ne ? then          
                assign lOK = oPrincipal:Authorize(cRoles).
        end.
        
        LogMessage(substitute('Validation result for operation &1: &2', pcOperation, lOK),
                   LogLevelEnum:DEBUG).
        
        return lOK.
    end method.
    
    /** Logs a message 
        
        @param character The message to log
        @param integer  The level this message should be logged at */
    method private void LogMessage(input pcMessage as character,
                                   input poLogLevel as LogLevelEnum):
        if log-manager:logfile-name eq ? then
            return.
        
        if log-manager:logging-level ge integer(poLogLevel) then
            log-manager:write-message(pcMessage, 'CLNTVTOR':u).
    end method.
    
end class.