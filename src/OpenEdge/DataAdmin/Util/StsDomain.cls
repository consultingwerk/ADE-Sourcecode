/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : StsDomain
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Apr 27 13:38:38 EDT 2016
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Assertion.AssertJson.
using OpenEdge.Core.JsonDataTypeEnum.
using OpenEdge.DataAdmin.Util.StsDomain.
using OpenEdge.DataAdmin.Util.StsDomainActionEnum.
using OpenEdge.DataAdmin.Util.StsDomainEventGroupEnum.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.AppError.

class OpenEdge.DataAdmin.Util.StsDomain serializable:
    define static private property PROP_NAME as character no-undo
        initial 'name':u
        get.    

    define static private property PROP_ENABLED as character no-undo
        initial 'enabled':u
        get.    
     
    define static private property PROP_DESC as character no-undo
        initial 'description':u
        get.    

    define static private property PROP_OPTIONS as character no-undo
        initial 'options':u
        get.    
     
    define static private property PROP_AUTH_PROVIDER as character no-undo
        initial 'authProvider':u
        get.    
     
    define static private property PROP_POLICY_PROVIDER as character no-undo
        initial 'policyProvider':u
        get.    
     
    define static private property PROP_ACTIONS as character no-undo
        initial 'actions':u
        get.    

    define static private property PROP_EVENTS as character no-undo
        initial 'events':u
        get.    

    define static private property PROP_PROVIDER as character no-undo
        initial 'provider':u
        get.    

    define static private property PROP_GROUPS as character no-undo
        initial 'groups':u
        get.    
     
    /* (mandatory) The name of the domain being updated */
    define public property Name as character no-undo get. private set.
    
    /* Is the domain enabled? */
    define public property Enabled as logical no-undo get. set.
    
    /* A clear-text description of the domain */
    define public property Description as character no-undo get. set.
    
    /* A reference to the auth provider */
    define public property AuthProviderRef as character no-undo get. set.
    /* A reference to the policy callback provider */
    define public property PolicyProviderRef as character no-undo get. set.
    /* A reference to the event callback provider */
    define public property EventProviderRef as character no-undo  get. set. 
    
    /* <fka runtime-options>. A comma-delimited list */
    define public property DomainOptions as character no-undo  get. set. 
    
    /* The domain action groups - a flag for each pam-action */ 
    define public property EnabledDomainActions as StsDomainActionEnum no-undo get. set.

    /* <fka system|pam-options>. A comma-delimited list. These apply to all actions */
    define public property ActionOptions as character extent no-undo  get. set. 
    
    /* The domain action groups - a flag for each pam-action */
    define public property EnabledEventGroups as StsDomainEventGroupEnum no-undo get. set.
    
    constructor public StsDomain(input pcName as character):
        Assert:NotNullOrEmpty(pcName, 'Domain name').
        
        assign this-object:Name     = pcName
               EnabledEventGroups   = StsDomainEventGroupEnum:None
               EnabledDomainActions = StsDomainActionEnum:None
               extent(ActionOptions) = num-entries(get-class(StsDomainActionEnum)
                                                    :GetEnumNames()) 
                                       /* We don't want the 'None' */
                                       - 1
               .
    end constructor.
    
    /* Returns a json representation of this STS Domain 
       
       @return JsonObject The schema-compliant JSON */
    method public JsonObject ExportConfig():
        define variable oDomain as JsonObject no-undo.
        define variable oChild as JsonObject extent 2 no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable oActionEnum as StsDomainActionEnum no-undo.
        define variable oGroupEnum as StsDomainEventGroupEnum no-undo.
        define variable cEnumNames as character no-undo.
        
        assign oDomain = new JsonObject().
        
        oDomain:Add(PROP_NAME, this-object:Name).
        oDomain:Add(PROP_ENABLED, this-object:Enabled).
        oDomain:Add(PROP_DESC, this-object:Description).
        oDomain:Add(PROP_OPTIONS, this-object:DomainOptions).
        oDomain:Add(PROP_AUTH_PROVIDER, this-object:AuthProviderRef).
        oDomain:Add(PROP_POLICY_PROVIDER, this-object:PolicyProviderRef).
        
        /* actions */
        assign oChild[1]  = new JsonObject()
               cEnumNames = get-class(StsDomainActionEnum):GetEnumNames()
               iMax       = num-entries(cEnumNames)
               .
        oDomain:Add(PROP_ACTIONS, oChild[1]).
        do iLoop = 1 to iMax:
            /* Flags are powers of 2, starting with 2^0 (aka 1) */
            assign oActionEnum = StsDomainActionEnum:GetEnum(entry(iLoop, cEnumNames)).
            if integer(oActionEnum) eq 0 then
                next.
            
            oChild[2] = new JsonObject().
            oChild[1]:Add(FormatEnumName(string(oActionEnum)), oChild[2]).
                oChild[2]:Add(PROP_ENABLED, EnabledDomainActions:IsFlagSet(oActionEnum)).
                oChild[2]:Add(PROP_OPTIONS, this-object:ActionOptions[iLoop - 1]).
        end.
        
        /* events */
        oChild[1] = new JsonObject().
        oDomain:Add(PROP_EVENTS, oChild[1]).
            oChild[1]:Add(PROP_PROVIDER, EventProviderRef).
            
        assign oChild[2] = new JsonObject()
               cEnumNames = get-class(StsDomainEventGroupEnum):GetEnumNames()
               iMax       = num-entries(cEnumNames)
               .
        oChild[1]:Add(PROP_GROUPS, oChild[2]).
        
        do iLoop = 1 to iMax:
            /* Flags are powers of 2, starting with 2^0 (aka 1) */
            assign oGroupEnum = StsDomainEventGroupEnum:GetEnum(entry(iLoop, cEnumNames)).
            /* Skip None */
            if integer(oGroupEnum) eq 0 then
                next.
            
            oChild[2]:Add(FormatEnumName(string(oGroupEnum)),
                          EnabledEventGroups:IsFlagSet(oGroupEnum)).
        end.
        
        return oDomain.
    end method.
    
    /* Creates a StsDomain instance from JSON config
    
       @param character The name of the domain to import 
       @param JsonObject the config for a single domain, per the schema above
       @return StsDomain A configured domain */
    method static public StsDomain ImportConfig(input poConfig as JsonObject):
        define variable oDomain as StsDomain no-undo.
        define variable oChild as JsonObject extent 2 no-undo.
        define variable cEnumNames as character no-undo.
        define variable cName as character no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable oActionEnum as StsDomainActionEnum no-undo.
        define variable oEventEnum as StsDomainEventGroupEnum no-undo.
        
        Assert:NotNull(poConfig, 'Domain config').
        
        AssertJson:PropertyIsType(poConfig, PROP_NAME, JsonDataTypeEnum:String).
        
        assign oDomain = new StsDomain(poConfig:GetCharacter(PROP_NAME)).
        
        if poConfig:Has(PROP_ENABLED) then
        do:
            AssertJson:PropertyIsType(poConfig, PROP_ENABLED, JsonDataTypeEnum:Boolean).
            assign oDomain:Enabled = poConfig:GetLogical(PROP_ENABLED).
        end.
        
        if poConfig:Has(PROP_DESC) then
        do:
            AssertJson:PropertyIsType(poConfig, PROP_DESC, JsonDataTypeEnum:String).
            assign oDomain:Description = poConfig:GetCharacter(PROP_DESC).
        end.

        if poConfig:Has(PROP_OPTIONS) then
        do:
            AssertJson:PropertyIsType(poConfig, PROP_OPTIONS, JsonDataTypeEnum:String).
            oDomain:DomainOptions = poConfig:GetCharacter(PROP_OPTIONS).
        end.
        
        if poConfig:Has(PROP_AUTH_PROVIDER) then
        do:
            AssertJson:PropertyIsType(poConfig, PROP_AUTH_PROVIDER, JsonDataTypeEnum:String).
            assign oDomain:AuthProviderRef = poConfig:GetCharacter(PROP_AUTH_PROVIDER).
        end.

        if poConfig:Has(PROP_POLICY_PROVIDER) then
        do:
            AssertJson:PropertyIsType(poConfig, PROP_POLICY_PROVIDER, JsonDataTypeEnum:String).
            assign oDomain:PolicyProviderRef = poConfig:GetCharacter(PROP_POLICY_PROVIDER).
        end.

        if poConfig:Has(PROP_ACTIONS) then
        do:
            AssertJson:PropertyIsType(poConfig, PROP_ACTIONS, JsonDataTypeEnum:Object).
            assign oChild[1] = poConfig:GetJsonObject(PROP_ACTIONS).
        end.
        else
            assign oChild[1] = new JsonObject().

        /* actions */
        assign cEnumNames = get-class(StsDomainActionEnum):GetEnumNames()
               iMax       = num-entries(cEnumNames).
        do iLoop = 1 to iMax:
            assign cName  = FormatEnumName(entry(iLoop, cEnumNames)).
            if not oChild[1]:Has(cName) then
                next.
            
            AssertJson:PropertyIsType(oChild[1], cName, JsonDataTypeEnum:Object).
            
            assign oChild[2]   = oChild[1]:GetJsonObject(cName)
                   oActionEnum = StsDomainActionEnum:GetEnum(cName).
            if oChild[2]:GetLogical(PROP_ENABLED) then
                assign oDomain:EnabledDomainActions = oDomain:EnabledDomainActions or oActionEnum.
            
            assign oDomain:ActionOptions[iLoop - 1] = oChild[2]:GetCharacter(PROP_OPTIONS).                              
        end.
        
        /* events */
        if poConfig:Has(PROP_EVENTS) then
        do:
            AssertJson:PropertyIsType(poConfig, PROP_EVENTS, JsonDataTypeEnum:Object).
            assign oChild[1] = poConfig:GetJsonObject(PROP_EVENTS).

            AssertJson:PropertyIsType(oChild[1], PROP_PROVIDER, JsonDataTypeEnum:String).
            assign oDomain:EventProviderRef = oChild[1]:GetCharacter(PROP_PROVIDER).
            
            if oChild[1]:Has(PROP_GROUPS) and 
               oChild[1]:GetType(PROP_GROUPS) eq JsonDataType:OBJECT then
                assign oChild[2] = oChild[1]:GetJsonObject(PROP_GROUPS).                
            else
                assign oChild[2] = new JsonObject().
        end.

        assign cEnumNames = get-class(StsDomainEventGroupEnum):GetEnumNames()
               iMax       = num-entries(cEnumNames).
        do iLoop = 1 to iMax:
            assign cName  = FormatEnumName(entry(iLoop, cEnumNames)).
            if not oChild[2]:Has(cName) then
                next.
            
            AssertJson:PropertyIsType(oChild[2], cName, JsonDataTypeEnum:Boolean).
            
            if oChild[2]:GetLogical(cName) then
                assign oEventEnum                 = StsDomainEventGroupEnum:GetEnum(cName)
                       oDomain:EnabledEventGroups = oDomain:EnabledEventGroups or oEventEnum.
        end.
        
        return oDomain.    
    end method.
    
    /* formats an enum name to have a leading lower-case letter, per the Java naming 
       convention 
       
       @param character The unformatted string
       @return character The formatted string */
    method static private character FormatEnumName(input pcName as character):
        define variable cFormatted as character no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable cChar as character no-undo.
        define variable lHasLC as logical no-undo.
        
        /* no-op for empty or null */
        Assert:NotNullOrEmpty(pcName, 'Enum name').

        assign cFormatted = lc(substring(pcName, 1, 1)) + substring(pcName, 2)
               /* if there's no lc chars, then make the whole thing LC */
               iMax   = length(pcName)
               lHasLC = false.
        do iLoop = 2 to iMax while not lHasLC:
            assign cChar  = substring(pcName, iLoop, 1)
                   lHasLC = asc(cChar) eq asc(lc(cChar))  
                   .
        end.
        if not lHasLC then
            assign cFormatted = lc(cFormatted).
        
        return cFormatted.
    end method. 
    
end class.