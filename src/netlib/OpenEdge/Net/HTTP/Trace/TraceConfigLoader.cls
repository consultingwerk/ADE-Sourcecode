/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : TraceConfigLoader
    Purpose     : Loads TraceConfig instances from either JSON or files containing such JSON
    Syntax      :
    Description :
    Author(s)   : Dustin Grau
    Created     : Wed Aug 25 10:04:48 EDT 2021
    Notes       : * The JSON must match the schema in $DLC/src/netlib/OpenEdge/Net/HTTP/Trace/hctracing.config.schema
                  * If no file name is provided, then a file named hctracing.config that is in PROPATH is used
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.IDateHolder.
using Ccs.Common.Support.IDateTimeHolder.
using Ccs.Common.Support.IDateTimeTzHolder.
using Ccs.Common.Support.IPrimitiveHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Core.Json.JsonConverter.
using OpenEdge.Core.Json.JsonPropertyHelper.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Net.HTTP.Trace.Formatter.ITraceFormatter.
using OpenEdge.Net.HTTP.Trace.Formatter.JsonFormatter.
using OpenEdge.Net.HTTP.Trace.LocalOutputConfig.
using OpenEdge.Net.HTTP.Trace.MessageTypeEnum.
using OpenEdge.Net.HTTP.Trace.OutputTypeEnum.
using OpenEdge.Net.HTTP.Trace.PolicyTypeEnum.
using OpenEdge.Net.HTTP.Trace.Rule.ITraceDataRule.
using OpenEdge.Net.HTTP.Trace.Rule.ITraceFilterRule.
using OpenEdge.Net.HTTP.Trace.Rule.ITraceRule.
using OpenEdge.Net.HTTP.Trace.Rule.TraceRule.
using OpenEdge.Net.HTTP.Trace.TraceConfig.
using OpenEdge.Net.HTTP.Trace.Writer.FileWriter.
using OpenEdge.Net.HTTP.Trace.Writer.ITraceWriter.
using OpenEdge.Net.URI.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Lang.AppError.
using Progress.Lang.Class.
using Progress.Lang.Object.
using Progress.Lang.ParameterList.
using Progress.Reflect.AccessMode.
using Progress.Reflect.Constructor.
using Progress.Reflect.DataType.
using Progress.Reflect.Property.
using OpenEdge.Net.HTTP.Trace.TraceConfigLoader.

@since(rel='12.5.0').
class OpenEdge.Net.HTTP.Trace.TraceConfigLoader:
    // temp-table to hold the file names (as passed into LoadFile) and their configs, together with last-check timestamps
    define private static temp-table ConfigFile no-undo
        field fileName as character
        field configData as Object
        field lastCheckAt as datetime
        field lastUpdateAt as datetime
        index pu as primary unique fileName
        .
    
    /* Create a static property to handle logging from this class. */
    define static public property Logger as ILogWriter no-undo
        get():
            if not valid-object(TraceConfigLoader:Logger) then
                assign TraceConfigLoader:Logger = LoggerBuilder:GetLogger(get-class(TraceConfigLoader)).

            return TraceConfigLoader:Logger.
        end get.
        set.

    // The name of the file (in propath) that contains tracing configuration.
    define static private variable CONFIG_FILE_NAME as character no-undo initial "hctracing.config":u.
    
    // The interval between checks, in seconds. Default/initial value is 60. A value of 0 means always check.
    define static public property FileCheckInterval as integer no-undo initial 60
        get.
        set(input pInterval as integer):
            // if we get bad values, keep the old one
            if    pInterval eq ?
               or pInterval lt 0
            then
                return.

            TraceConfigLoader:Logger:Info(substitute("Config file check interval changed to &1s (from &2)", pInterval, FileCheckInterval)).

            assign FileCheckInterval = pInterval.
        end set.
    
    // so we only need create these once
    var static private ParameterList mParamListShort, mParamListLong.
    
    /* Always start with an empty static config object. */
    constructor static TraceConfigLoader ( ):
        TraceConfigLoader:ClearConfig(). // Make sure we start an empty object.
        
        // Create the parameter list objects in advance because we know what we're looking for;
        // 'longer' constructor considered better, consisting of both Message and Policy Types.
        mParamListLong = new ParameterList(2).
        mParamListLong:SetParameter(1, substitute("class &1", get-class(MessageTypeEnum):TypeName), "input", ?).
        mParamListLong:SetParameter(2, substitute("class &1", get-class(PolicyTypeEnum):TypeName), "input", ?).

        // Single-parameter constructor will only take a PolicyTypeEnum
        mParamListShort = new ParameterList(1).
        mParamListShort:SetParameter(1, substitute("class &1", get-class(PolicyTypeEnum):TypeName), "input", ?).
    end constructor.

    /* Default constructor. PRIVATE to prevent instantion of this class */
    constructor private TraceConfigLoader ():
        // PRIVATE to prevent instantiation of this class
    end constructor.
    
    /* Clears all the current tracing config options. */
    method static public void ClearConfig ( ):
        define buffer bCfg for ConfigFile.
        
        empty temp-table bCfg.
    end method.
    
    /* Loads tracing config from a file
        
       @param character The filename to load.
       @return TraceConfig A trace config. This may be loaded from the file, or be a default instance */
    method static private TraceConfig LoadFromFile ( input pFileName as character ):
        var datetime dtLastTouch.
        // assign here, we may override this from file contents
        var TraceConfig tc = new TraceConfig().
        
        define buffer bCfg for ConfigFile.
        
        Assert:NotNullOrEmpty(pFileName, "Config file name").
        
        // if we ask for a file, then keep a record of it
        find bCfg
       where bCfg.fileName eq pFileName
        no-error.
        
        if not available bCfg then
        do:
            create bCfg.
            assign bCfg.fileName   = pFileName
                   bCfg.configData = tc
                   .
        end.
        else
            assign tc = cast(bCfg.configData, TraceConfig).
        
        if not FileCheckInterval eq 0
        // we haven't checked ever
        and not bCfg.lastCheckAt eq ?
        // we checked within the last n seconds ...
        and add-interval(bCfg.lastCheckAt, FileCheckInterval, "seconds":u) ge now
        then
            return tc.
        
        assign bCfg.lastCheckAt    = now
               file-info:file-name = pFileName
               .
        // if there's no file, do nothing.
        if file-info:full-pathname eq ? then
        do:
            // no config here, reset
            assign bCfg.configData = tc.
            return tc.
        end.
        
        assign dtLastTouch = add-interval(datetime(file-info:file-mod-date), file-info:file-mod-time, "seconds":u).
        
        // Load config file if it exists and the file MOD timestamp is after the last value
        // if the file differs from the previous config file
        if bCfg.lastUpdateAt eq ?
        or dtLastTouch gt bCfg.lastUpdateAt
        then
            assign bCfg.lastUpdateAt = dtLastTouch
                   tc                = LoadFromJson(cast(new ObjectModelParser():ParseFile(file-info:full-pathname), JsonObject))
                   bCfg.configData   = tc
                   .
        
        catch loadError as Progress.Lang.Error:
            TraceConfigLoader:Logger:Error(substitute("Error loading HttpClient tracing config: &1", pFileName), loadError).
            // Reset the config data if failed to load.
            assign tc              = new TraceConfig()
                   bCfg.configData = tc
                   .
        end catch.
        // always return something
        finally:
            // use a local variable because the local ConfigFile buffer goes out of scope here
            {&_proparse_ prolint-nowarn(returnfinally)}
            return tc.
        end finally.
    end method.
    
    /** Returns a ITraceFormatter implementation based on JSON config data
       
        @param JsonObject JSON Config
        @return ITraceFormatter An implementation of a trace formatter */
    method static private ITraceFormatter GetFormatter ( input poJsonConfig as JsonObject ):
        var Progress.Lang.Class oClass.
        var ITraceFormatter oImpl.
        var character typeName.

        // If an implementation (class package) is explicitly set in the config, create an instance of that class.
        if JsonPropertyHelper:HasTypedProperty(poJsonConfig, "implementation", JsonDataType:String) then do:
            assign typeName = poJsonConfig:GetCharacter("implementation")
                   oClass = Class:GetClass(typeName)
                   no-error.
            // Ensure the class is valid and of the expected interface type.
            if not valid-object(oClass) or not oClass:IsA(get-class(ITraceFormatter)) then
            do:
                TraceConfigLoader:Logger:Warn(substitute('"&1" is not of type &2; using default formatter &3',
                                                         typeName,
                                                         get-class(ITraceFormatter):TypeName,
                                                         get-class(JsonFormatter):TypeName)).
                assign error-status:error = no.
            end.
            else
                assign oImpl = cast(oClass:New(), ITraceFormatter). // Create new instance of formatter class.
        end.
        
        if not valid-object(oImpl) then
            assign oImpl = new JsonFormatter(). // Get the default formatter (JSON serializer).
        
        // Set any options for this implementation, if there is an options object in the configuration.
        if JsonPropertyHelper:HasTypedProperty(poJsonConfig, "options", JsonDataType:Object) then
            SetOptions(poJsonConfig:GetJsonObject("options"), oImpl).
        
        return oImpl.
    end method.
    
    /** Returns a ITraceWriter implementation based on JSON config data
       
        @param JsonObject JSON Config
        @return ITraceWriter An implementation of a trace writer */
    method static private ITraceWriter GetWriter ( input poJsonConfig as JsonObject ):
        var Progress.Lang.Class oClass.
        var ITraceWriter oImpl.
        var character typeName.
        
        // If an implementation (class package) is explicitly set in the config, create an instance of that class.
        if JsonPropertyHelper:HasTypedProperty(poJsonConfig, "implementation", JsonDataType:String) then do:
            assign typeName = poJsonConfig:GetCharacter("implementation")
                   oClass = Class:GetClass(typeName)
                   no-error.
            
            // Ensure the class is valid and of the expected interface type.
            if not valid-object(oClass) or not oClass:IsA(get-class(ITraceWriter)) then
            do:
                TraceConfigLoader:Logger:Warn(substitute('"&1" is not of type &2; using default writer &3',
                                                         typeName,
                                                         get-class(ITraceWriter):TypeName,
                                                         get-class(FileWriter):TypeName)).
                assign error-status:error = no.
            end.
            else
                assign oImpl = cast(oClass:New(), ITraceWriter). // Create new instance of writer class.
        end.
        
        if not valid-object(oImpl) then
            // Get the default writer, using a default file path and naming structure.
            assign oImpl = new FileWriter().
        
        // Set any options for this implementation, if there is an options object in the configuration.
        if JsonPropertyHelper:HasTypedProperty(poJsonConfig, "options", JsonDataType:Object) then
            SetOptions(poJsonConfig:GetJsonObject("options"), oImpl).
        
        return oImpl.
    end method.

    /** Assigns values from the 'options' JSON object to the writer or formatter implementation.
        The properties in the JSON are used to look for a OOABL property in the implementation. This property
        must be an instance public property with a publicly-writable setter. If such a property is found,
        then the JSON value is best-guess converted to that property's ABL data type.
        
        If the conversion or the setting fails, the error is logged and the next property is processed.
        
        @param JsonObject The JSON options
        @param PLO The implementation */
    method static private void SetOptions ( input poJsonConfig     as JsonObject,
                                            input poImplementation as Object ):
        // LONGCHAR arrays don't suffer from certain size constraints
        var longchar[] names.
        var integer cnt, loop.
        var Property prop.
        var character propName.
        var character[] chrArray.
        var JsonArray ja.
        var IPrimitiveHolder ph.
        
        if not valid-object(poJsonConfig)
        or not valid-object(poImplementation)
        then
            return.
        
        assign names = poJsonConfig:GetNames()
               cnt   = extent(names)
               .
        PROPERTY-LOOP:
        do loop = 1 to cnt
        on error undo, throw:
            {&_proparse_ prolint-nowarn(overflow)}
            assign propName = string(names[loop])
                   prop     = poImplementation:GetClass():GetProperty(propName)
                   .
            if not valid-object(prop) then
            do:
                Logger:Debug(substitute('Property "&1" does not exist, or is not public, on class &2', propName, poImplementation:GetClass():TypeName)).
                next PROPERTY-LOOP.
            end.
            if prop:DeclaringClass:SuperClass eq ? then
                next PROPERTY-LOOP.
            
            // must be able to set the value
            if  prop:CanWrite
            and not prop:SetterAccessMode eq AccessMode:Public
            then
            do:
                Logger:Debug(substitute('Property "&1" on class &2 is not settable', propName, poImplementation:GetClass():TypeName)).
                next PROPERTY-LOOP.
            end.
            
            if prop:Extent eq 0 then
            case prop:DataType:
                when DataType:Character then
                    if poJsonConfig:GetType(propName) eq JsonDataType:STRING then
                        prop:Set(poImplementation, poJsonConfig:GetCharacter(propName)).
                
                when DataType:Decimal then
                    if poJsonConfig:GetType(propName) eq JsonDataType:NUMBER then
                        prop:Set(poImplementation, poJsonConfig:GetDecimal(propName)).
                
                when DataType:Integer then
                    if poJsonConfig:GetType(propName) eq JsonDataType:NUMBER then
                        prop:Set(poImplementation, poJsonConfig:GetInteger(propName)).
                
                when DataType:Int64 then
                    if poJsonConfig:GetType(propName) eq JsonDataType:NUMBER then
                        prop:Set(poImplementation, poJsonConfig:GetInt64(propName)).
                
                when DataType:Logical then
                    if poJsonConfig:GetType(propName) eq JsonDataType:BOOLEAN then
                        prop:Set(poImplementation, poJsonConfig:GetLogical(propName)).
                
                when DataType:Date then
                    if poJsonConfig:GetType(propName) eq JsonDataType:STRING then
                    do:
                        ph = JsonConverter:ToScalar(poJsonConfig, propName).
                        if type-of(ph, IDateHolder) then
                            prop:Set(poImplementation, cast(ph, IDateHolder):Value).
                    end.
                
                when DataType:DateTime then
                    if poJsonConfig:GetType(propName) eq JsonDataType:STRING then
                    do:
                        ph = JsonConverter:ToScalar(poJsonConfig, propName).
                        if type-of(ph, IDateTimeHolder) then
                            prop:Set(poImplementation, cast(ph, IDateTimeHolder):Value).
                    end.
                
                when DataType:DateTimeTZ then
                    if poJsonConfig:GetType(propName) eq JsonDataType:STRING then
                    do:
                        ph = JsonConverter:ToScalar(poJsonConfig, propName).
                        if type-of(ph, IDateTimeTzHolder) then
                            prop:Set(poImplementation, cast(ph, IDateTimeTzHolder):Value).
                    end.
                
                when DataType:Object then
                    if poJsonConfig:GetType(propName) eq JsonDataType:ARRAY
                    and get-class(JsonArray):IsA(prop:DataTypeName)
                    then
                        prop:Set(poImplementation, poJsonConfig:GetJsonArray(propName)).
                    else
                    if poJsonConfig:GetType(propName) eq JsonDataType:OBJECT
                    and get-class(JsonArray):IsA(prop:DataTypeName)
                    then
                        prop:Set(poImplementation, poJsonConfig:GetJsonObject(propName)).
            end case.   // SCALAR/NON-ARRAY
            else
            case prop:DataType:
                when DataType:Character then
                    if poJsonConfig:GetType(propName) eq JsonDataType:ARRAY then
                    do:
                        assign extent(chrArray) = ?
                               ja               = poJsonConfig:GetJsonArray(propName)
                               chrArray         = ja:GetCharacter(1, ja:Length)
                               .
                        if    prop:Extent eq ?
                           or prop:Extent eq extent(chrArray)
                        then
                            prop:Set(poImplementation, chrArray).
                    end.
            end case.
            
            catch err as Progress.Lang.Error:
                Logger:Error(substitute('Error setting "&1" in &2', propName, poImplementation:GetClass():TypeName),
                             err).
            end catch.
        end.    // PROPERTY-LOOP
    end method.

    /* Loads tracing config from a JSON object
    
       @param JsonObject The JSON to load.
       @return TraceConfig A trace config. This may be loaded from the JSON, or be a default instance */
    method static private TraceConfig  LoadFromJson ( input poJsonConfig as JsonObject ):
        var JsonObject jsonOutput.
        var TraceConfig tc = new TraceConfig().
        
        if valid-object(poJsonConfig) then do:
            if JsonPropertyHelper:HasTypedProperty(poJsonConfig, "enabled", JsonDataType:Boolean) and poJsonConfig:GetLogical("enabled") then do:
                tc:Enabled = true. // Denotes that tracing was explicitly enabled via config file.

                // Get the output type from the configuration file (eg. Proxy/Local), or set as None if no valid value found.
                if JsonPropertyHelper:HasTypedProperty(poJsonConfig, "output", JsonDataType:Object) then do:
                    assign jsonOutput = poJsonConfig:GetJsonObject("output").

                    if JsonPropertyHelper:HasTypedProperty(jsonOutput, "type", JsonDataType:String) then
                        case jsonOutput:GetCharacter("type"):
                            when "proxy" then do:
                                tc:OutputType = OutputTypeEnum:Proxy.
                                // Determine the proxy server address, specified by the "proxyUri" property on the output object.
                                if JsonPropertyHelper:HasTypedProperty(jsonOutput, "proxyUri", JsonDataType:String) then
                                    tc:OutputConfig = URI:Parse(jsonOutput:GetCharacter("proxyUri")).
                            end. // proxy

                            when "local" or
                            when "internal" then do:
                                // Set the output type and create the initial config object for local output.
                                tc:OutputType = OutputTypeEnum:Local.
                                tc:OutputConfig = new LocalOutputConfig().

                                // Get the formatter for local tracing data, defaulting to the JsonFormatter.
                                if JsonPropertyHelper:HasTypedProperty(jsonOutput, "formatter", JsonDataType:Object) then
                                    cast(tc:OutputConfig, LocalOutputConfig):Formatter = GetFormatter(jsonOutput:GetJsonObject("formatter")).
                                else
                                    // Default if no config property set for output formatter.
                                    cast(tc:OutputConfig, LocalOutputConfig):Formatter = GetFormatter(new JsonObject()).

                                // Get the writer for local tracing data, defaulting to the FileWriter (with temp-dir output).
                                if JsonPropertyHelper:HasTypedProperty(jsonOutput, "writer", JsonDataType:Object) then
                                    cast(tc:OutputConfig, LocalOutputConfig):Writer = GetWriter(jsonOutput:GetJsonObject("writer")).
                                else
                                    // Default if no config property set for output writer.
                                    cast(tc:OutputConfig, LocalOutputConfig):Writer = GetWriter(new JsonObject()).
                            end. // local

                            otherwise
                                tc:OutputType = OutputTypeEnum:None.
                        end case.
                end. // output

                // Get the output type from the configuration file (eg. Proxy/Local), or set as None if no valid value found.
                if JsonPropertyHelper:HasTypedProperty(poJsonConfig, "rules", JsonDataType:Object) then do:
                    if JsonPropertyHelper:HasTypedProperty(poJsonConfig:GetJsonObject("rules"), "filter", JsonDataType:Object) then
                        tc:FilterRules = cast(ParseRules(MessageTypeEnum:Request or MessageTypeEnum:Response,
                                                         get-class(ITraceFilterRule),
                                                         poJsonConfig:GetJsonObject("rules"):GetJsonObject("filter")),
                                              ITraceFilterRule).
                    
                    if JsonPropertyHelper:HasTypedProperty(poJsonConfig:GetJsonObject("rules"), "request", JsonDataType:Object) then
                        tc:RequestRules = cast(ParseRules(MessageTypeEnum:Request,
                                                          get-class(ITraceDataRule),
                                                          poJsonConfig:GetJsonObject("rules"):GetJsonObject("request")),
                                               ITraceDataRule).
                    
                    if JsonPropertyHelper:HasTypedProperty(poJsonConfig:GetJsonObject("rules"), "response", JsonDataType:Object) then
                        tc:ResponseRules = cast(ParseRules(MessageTypeEnum:Response,
                                                           get-class(ITraceDataRule),
                                                           poJsonConfig:GetJsonObject("rules"):GetJsonObject("response")),
                                                ITraceDataRule).
                end. // rules
            end. // Enabled
        end. // Json Available

        catch loadError as Progress.Lang.Error:
            TraceConfigLoader:Logger:Error("Error preparing HttpClient tracing config (JSON)", loadError).
            // Reset the config data if failed to load.
            tc = new TraceConfig().
        end catch.
        // always return something
        finally:
            {&_proparse_ prolint-nowarn(returnfinally)}
            return tc.
        end finally.
    end method.
    
    /* Parses JSON to create a set of trace rules.
       
       @param MessageTypeEnum The type of rules
       @parm Progress.Lang.Class The tracerule type (interface)
       @param JsonObject The config data
       @return ITraceRule[] An array of rules based on the JSON input */
    method static private ITraceRule extent ParseRules (input pMessageType as MessageTypeEnum,
                                                        input pRuleType as Progress.Lang.Class,
                                                        input poJsonRules as JsonObject ):
        var character[] cRuleNames.
        var character cPolicyType.
        var integer iRules, iValidRules, iExceptions, iLoop, iLoop2.
        var JsonArray oJsonExceptions.
        var Progress.Lang.Class oRuleType.
        var Constructor ctor.
        var PolicyTypeEnum ePolicyType.
        var Object[] oExceptions.
        var Object exc.
        var ITraceRule[] rules.
        
        assign cRuleNames = poJsonRules:GetNames().
        assign iRules = extent(cRuleNames).

        RULE-LOOP:
        do iLoop = 1 to iRules
        on error undo, throw:
            // Each rule name should be a valid class string (package + name) so we must
            // get the Progress.Lang.Class instance from a string (the name of the rule).
            oRuleType = Class:GetClass(cRuleNames[iLoop]).
            
            // The rule must be a ITraceDataRule or ITraceFilterRule (and ITraceRule through inheritance)
            if not oRuleType:IsA(pRuleType) then do:
                TraceConfigLoader:Logger:Warn(substitute("&1 is not of type &2, skipping.", oRuleType:TypeName, pRuleType:TypeName)).
                next RULE-LOOP.
            end.
            // Also, the rule type must be a TraceRule (concrete implementation, not interface).
            if not oRuleType:IsA(get-class(TraceRule)) then do:
                TraceConfigLoader:Logger:Warn(substitute("&1 is not of type &2, skipping.", oRuleType:TypeName, get-class(TraceRule):TypeName)).
                next RULE-LOOP.
            end.
            
            // Every rule should have a policy type (eg. AllowAll, DenyAll) which sets the default behavior.
            if JsonPropertyHelper:HasTypedProperty(poJsonRules:GetJsonObject(cRuleNames[iLoop]), "policy", JsonDataType:String) then
                assign cPolicyType = poJsonRules:GetJsonObject(cRuleNames[iLoop]):GetCharacter("policy").
            else
                assign cPolicyType = "none".

            // Make sure the Policy value is correct.
            ePolicyType = PolicyTypeEnum:GetEnum(cPolicyType) no-error.
            if not valid-object(ePolicyType) then do:
                TraceConfigLoader:Logger:Warn(substitute("&1 is not a valid policy type (was &2), skipping.", cPolicyType, get-class(PolicyTypeEnum):GetEnumNames())).
                next RULE-LOOP.
            end.

            // If reaching this point, we have a valid rule.
            iValidRules += 1.
            extent(rules) = iValidRules.
            
            // Check for existence of the longest constructor first.
            assign ctor = oRuleType:GetConstructor(mParamListLong).
            if valid-object(ctor) then do:
                // If we have a constructor, set the values and use it.
                mParamListLong:SetParameter(1, pMessageType).
                mParamListLong:SetParameter(2, ePolicyType).

                rules[iValidRules] = cast(ctor:Invoke(mParamListLong), ITraceRule).
            end.
            else do:
                assign ctor = oRuleType:GetConstructor(mParamListShort).
                if valid-object(ctor) then
                do:
                    // If we have a constructor, set the values and use it.
                    mParamListShort:SetParameter(1, ePolicyType).

                    rules[iValidRules] = cast(ctor:Invoke(mParamListShort), ITraceRule).
                end.
            end.
            
            if not valid-object(ctor) then do:
                TraceConfigLoader:Logger:Warn(substitute("Could not find appropriate constructor for &1, skipping.", oRuleType:TypeName)).
                next RULE-LOOP.
            end.

            // Get the exceptions and set in new rule.
            extent(oExceptions) = ?. // Reset the local exceptions list on each rule.
            if JsonPropertyHelper:HasTypedProperty(poJsonRules:GetJsonObject(cRuleNames[iLoop]), "exceptions", JsonDataType:Array) then
            do on error undo, throw:
                assign oJsonExceptions = poJsonRules:GetJsonObject(cRuleNames[iLoop]):GetJsonArray("exceptions").
                assign iExceptions = oJsonExceptions:Length.
                
                EXCEPTION-LOOP:
                do iLoop2 = 1 to iExceptions
                on error undo, throw:
                    case oJsonExceptions:GetType(iLoop2):
                        when JsonDataType:NULL then
                            next EXCEPTION-LOOP.
                        when JsonDataType:ARRAY then
                        do:
                            // Initialize or increment the size of the exceptions extent.
                            if extent(oExceptions) eq ? then
                                extent(oExceptions) = 1.
                            else
                                extent(oExceptions) += 1.

                            // JSON objects will be cloned and added as such to the exceptions.
                            oExceptions[extent(oExceptions)] = oJsonExceptions:GetJsonArray(iLoop2).
                        end.    // ARRAY
                        when JsonDataType:OBJECT then do:
                            // Initialize or increment the size of the exceptions extent.
                            if extent(oExceptions) eq ? then
                                extent(oExceptions) = 1.
                            else
                                extent(oExceptions) += 1.

                            // JSON objects will be cloned and added as such to the exceptions.
                            oExceptions[extent(oExceptions)] = oJsonExceptions:GetJsonObject(iLoop2).
                        end.
                        otherwise
                        do:
                            // this does the needful to convert JSON data types to OOABL
                            assign exc = JsonConverter:ToScalar(oJsonExceptions, iLoop2).
                            if valid-object(exc) then
                            do:
                                // Initialize or increment the size of the exceptions extent.
                                if extent(oExceptions) eq ? then
                                    extent(oExceptions) = 1.
                                else
                                    extent(oExceptions) += 1.
                                
                                oExceptions[extent(oExceptions)] = exc.
                            end.
                            else
                                TraceConfigLoader:Logger:Info(substitute("Unsupported JSON exception in &1 rule #&2, skipping.", oRuleType:TypeName, iValidRules)).
                        end.
                    end case.
                end. // EXCEPTION-LOOP

                // Add exceptions to this policy in the current rule (should either be an object with extent of ? or 1+ valid exception object.
                rules[iValidRules]:SetPolicyExceptions(oExceptions).
            end. // oExceptions

            // Output information about the new rule as a debug message (when enabled by logging).
            TraceConfigLoader:Logger:Debug(substitute("Added Rule #&1:~n&2~n", iValidRules, rules[iValidRules]:ToString())).

            catch parseError as Progress.Lang.Error:
                // We couldn't find or create one rule, so throw an error so the calling code resets the config object.
                undo, throw new AppError(substitute("Error while parsing trace rules: &1", parseError:GetMessage(1)), 0).
            end catch.
        end. // RULE-LOOP
        
        return rules.
    end method.

    // PUBLIC METHODS

    /* Load HttpClient tracing policy rules from hctracing.config file. */
    method static public TraceConfig LoadRules ( ):
        return TraceConfigLoader:LoadFromFile(CONFIG_FILE_NAME).
    end method.
    
    /** Loads trace config from a specified filename
        
        @param character A file name
        @return TraceConfig The configuration represented by the file. */
    method static public TraceConfig LoadRules(input pConfigFile as character):
        return TraceConfigLoader:LoadFromFile(pConfigFile).
    end method.

    /* Load HttpClient tracing policy rules from a JSON object as given.

       @param JsonObject Config data in format described for hctracing.config */
    method static public TraceConfig LoadRules ( input poJsonConfig as JsonObject ):
        return TraceConfigLoader:LoadFromJson(poJsonConfig).
    end method.

end class.