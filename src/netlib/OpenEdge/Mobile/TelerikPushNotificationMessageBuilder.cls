/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : TelerikPushNotificationMessageBuilder
    Purpose     : Helper class to build a notification message easily 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Jun 13 13:11:41 EDT 2014
    Notes       : * The structure of these notification messages is at
                    http://docs.telerik.com/platform/backend-services/features/push-notifications/structure 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Mobile.ApplicationPlatformEnum.
using OpenEdge.Mobile.PushNotificationFilterOperandEnum.
using OpenEdge.Mobile.PushNotificationMessageBuilder.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.AppError.
using Progress.Json.ObjectModel.JsonDataType.

class OpenEdge.Mobile.TelerikPushNotificationMessageBuilder inherits PushNotificationMessageBuilder:
                
    define override public property Payload as JsonObject no-undo
        get(): 
            if not valid-object(this-object:Payload) then
                assign this-object:Payload = NewPayload().
            
            return this-object:Payload.
        end get.
        private set.
    
    /** Returns a useable Payload based on the config.
        
        @return JsonObject A useable push notification message payload */
    method private JsonObject NewPayload():
        define variable oPayload as JsonObject no-undo.
        define variable oPlatform as JsonObject no-undo.
        define variable oParent as JsonConstruct no-undo.
        define variable oChild as JsonConstruct no-undo.
        define variable tSendDate as datetime no-undo.
        define variable tOptionValue as datetime-tz no-undo.
        define variable lOptionValue as logical no-undo.
        define variable oFilterOperand as PushNotificationFilterOperandEnum no-undo.
        define variable cPlatforms as character no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable oFilters as JsonArray no-undo.
        define variable oFilterClause as JsonObject no-undo.
        
        assign oPayload = new JsonObject().
        
        /* general options */
        if HasOption('schedule.useDeviceTimeZone':u) then
            oPayload:Add('UseLocalTime':u, GetOptionLogicalValue('schedule.useDeviceTimeZone':u)).
            
        if not this-object:SendImmediate then
            oPayload:Add('NotificationDate':u, GetOptionDateTimeValue('schedule.time':u)).
        
        /* Check for platform-specific options.
           
           We use the negative form of <all> since we don't want to parse the string further,
           and nor do we want to include everything, which is what ",*" would mean. */
        assign cPlatforms = '!*':u.
        for each ConfigOption where
                 ( ConfigOption.ParentBuilder eq integer(this-object) and
                   ConfigOption.ConfigName    eq 'platform.':U + string(PushNotificationFilterOperandEnum:Equals)) or
                 ( ConfigOption.ParentBuilder eq integer(this-object) and
                   ConfigOption.ConfigName    eq 'platform.':U + string(PushNotificationFilterOperandEnum:Includes))
                 :
            assign oChild = cast(ConfigOption.ObjectValue, JsonArray)
                   iMax   = cast(oChild, JsonArray):Length.
            do iLoop = 1 to iMax:
                assign cPlatforms = cast(oChild, JsonArray):GetCharacter(iLoop)
                                  + ',':u
                                  + cPlatforms.
            end.
        end.
        
        /* If we haven't explicity included any, then we want to add them all and possibly exclude some */
        if cPlatforms eq '!*':u then
            assign cPlatforms = '*':u.
        
        /* exclude these */
        for each ConfigOption where
                 ( ConfigOption.ParentBuilder eq integer(this-object) and
                   ConfigOption.ConfigName    eq 'platform.':U + string(PushNotificationFilterOperandEnum:NotEqual)) or
                 ( ConfigOption.ParentBuilder eq integer(this-object) and
                   ConfigOption.ConfigName    eq 'platform.':U + string(PushNotificationFilterOperandEnum:NotIncludes))
                 :
            assign oChild  = cast(ConfigOption.ObjectValue, JsonArray)
                   iMax    = cast(oChild, JsonArray):Length.
            do iLoop = 1 to iMax:
                assign cPlatforms = '!':u + cast(oChild, JsonArray):GetCharacter(iLoop)
                                  + ',':u
                                  + cPlatforms.
            end.
        end.
        
        if can-do(cPlatforms, string(ApplicationPlatformEnum:Android)) then
        do:
            assign oPlatform = new JsonObject()
                   oParent   = new JsonObject().
            
            cast(oParent, JsonObject):Add('message':u, GetOptionStringValue('message.text':u)).
            
            if HasOption('message.title':u) then
                cast(oParent, JsonObject):Add('title':u, GetOptionStringValue('message.title':u)).
                
            if HasOption('message.count':u) then
                cast(oParent, JsonObject):Add('msgcnt':u, string(GetOptionNumericValue('message.count':u))).
            
            oPlatform:Add('data':u, cast(oParent, JsonObject)).
            oPayload:Add('Android':u, oPlatform).
        end.
        
        if can-do(cPlatforms, string(ApplicationPlatformEnum:WindowsPhone)) then
        do:
            assign oPlatform = new JsonObject()
                   oParent = new JsonObject().
            
            cast(oParent, JsonObject):Add('Message':u, GetOptionStringValue('message.text':u)).
            
            if HasOption('message.title':u) then
                cast(oParent, JsonObject):Add('Title':u, GetOptionStringValue('message.title':u)).
            
            oPlatform:Add('Toast':u, cast(oParent, JsonObject)).
            oPayload:Add('WindowsPhone':u, oPlatform).            
        end.
            
        if can-do(cPlatforms, string(ApplicationPlatformEnum:Windows8)) then
        do:
            assign oPlatform = new JsonObject()
                   oParent = new JsonObject()
                   oChild  = new JsonArray().
            
            cast(oChild, JsonArray):Add(GetOptionStringValue('message.text':u)).
            cast(oParent, JsonObject):Add('text':u, cast(oChild, JsonArray)).
            
            oPlatform:Add('Toast':u, cast(oParent, JsonObject)).
            oPayload:Add('Windows':u, oPlatform).
        end.
        
        if can-do(cPlatforms, string(ApplicationPlatformEnum:IOS)) then
        do:
            assign oPlatform = new JsonObject()
                   oParent = new JsonObject().
            
            cast(oParent, JsonObject):Add('alert':u, GetOptionStringValue('message.text':u)).

            if HasOption('message.count':u) then
                cast(oParent, JsonObject):Add('badge':u, string(GetOptionNumericValue('message.count':u))).
            
            oPlatform:Add('aps':u, cast(oParent, JsonObject)).
            oPayload:Add('IOS':u, oPlatform).
        end.
        
        /* Filters: channels first */
        assign oFilters = new JsonArray().
        for each ConfigOption where
                 ConfigOption.ParentBuilder eq integer(this-object) and
                 ConfigOption.ConfigName begins 'channels.':U       :
            
            assign oFilterOperand = PushNotificationFilterOperandEnum:GetEnum(entry(2, ConfigOption.ConfigName, '.':U))
                   no-error.
            
            case oFilterOperand:
                when PushNotificationFilterOperandEnum:Matches or
                when PushNotificationFilterOperandEnum:Equals or
                when PushNotificationFilterOperandEnum:Includes then
                    /* {"Author" : "Sample Text" } */
                    do iLoop = cast(ConfigOption.ObjectValue, JsonArray):Length to 1 by -1:
                        oFilters:Add(cast(ConfigOption.ObjectValue, JsonArray):GetCharacter(iLoop)).
                    end.  
                when PushNotificationFilterOperandEnum:NotEqual or
                when PushNotificationFilterOperandEnum:NotIncludes then
                    /* {"Author" : { "$ne" : "Sample Text" } } */
                    do iLoop = cast(ConfigOption.ObjectValue, JsonArray):Length to 1 by -1:
                        assign oFilterClause = new JsonObject().
                        oFilters:Add(oFilterClause).
                        
                        oFilterClause:Add(OperandValue[integer(PushNotificationFilterOperandEnum:NotEqual)],
                                          cast(ConfigOption.ObjectValue, JsonArray):GetCharacter(iLoop)).
                    end.  
            end case.
        end.
        if oFilters:Length gt 0 then
            AddArrayFilter('Parameters.channels':u,  oFilters, PushNotificationFilterOperandEnum:Or).
                    
        /* Devices next */
        assign oFilters = new JsonArray().
        for each ConfigOption where
                 ConfigOption.ParentBuilder eq integer(this-object) and
                 ConfigOption.ConfigName begins 'device.id.':U      :
            
            assign oFilterOperand = PushNotificationFilterOperandEnum:GetEnum(entry(3, ConfigOption.ConfigName, '.':U))
                   no-error.

            case oFilterOperand:
                when PushNotificationFilterOperandEnum:Equals or
                when PushNotificationFilterOperandEnum:Includes then
                    /* {"Author" : "Sample Text" } */
                    do iLoop = cast(ConfigOption.ObjectValue, JsonArray):Length to 1 by -1:
                        oFilters:Add(cast(ConfigOption.ObjectValue, JsonArray):GetCharacter(iLoop)).
                    end.  
                when PushNotificationFilterOperandEnum:NotEqual or
                when PushNotificationFilterOperandEnum:NotIncludes then
                    /* {"Author" : { "$ne" : "Sample Text" } } */
                    do iLoop = cast(ConfigOption.ObjectValue, JsonArray):Length to 1 by -1:
                        assign oFilterClause = new JsonObject().
                        oFilters:Add(oFilterClause).
                        
                        oFilterClause:Add(OperandValue[integer(PushNotificationFilterOperandEnum:NotEqual)],
                                          cast(ConfigOption.ObjectValue, JsonArray):GetCharacter(iLoop)).
                    end.  
            end case.
        end.        
        if oFilters:Length gt 0 then
            AddArrayFilter('Id':u,  oFilters, PushNotificationFilterOperandEnum:Or).
            
        /* add filters to payload */
        assign oParent = cast(GetOptionObjectValue('filter':u), JsonObject).
        if valid-object(oParent) then
        do:
            if log-manager:logging-level gt 4 then
                oParent:WriteFile(session:temp-dir + 'push_notification_filter.json':u, true).
            
            oPayload:Add('Filter':u, cast(oParent, JsonObject):GetJsonText()).
        end.
        
        return oPayload.
    end method.
    
    /** General method to add array filters to the payload.
    
        Supported operands: Includes/NotIncludes/Matches            
        
        @param character      The name of the type of filter (type/deviceID/etc)
        @param JsonConstruct  The value to add. Could be Object (matches only) 
                              or array (Includes/NotIncludes)
        @param PushNotificationFilterOperandEnum The operand (eq/ne/etc) 
        @return PushNotificationMessageBuilder This builder object */
    method override public PushNotificationMessageBuilder AddArrayFilter(input pcFilterName as character,
                                                                         input poFilterValue as JsonConstruct,
                                                                         input poOperand as PushNotificationFilterOperandEnum):
        define variable oFilterParent as JsonObject no-undo.
        define variable oFilterObject as JsonObject no-undo.
        define variable oFilterValue as JsonConstruct no-undo.
        define variable oFilterClause as JsonObject no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.

        Assert:NotNull(poOperand, 'Operand').
        Assert:NotNullOrEmpty(pcFilterName, 'Filter Name').
        Assert:NotNull(poFilterValue, 'Filter Value').

        assign oFilterObject = new JsonObject().
        AddFilter(oFilterObject). 

        case poOperand:
            when PushNotificationFilterOperandEnum:Matches then
            do:
                if poFilterValue:GetClass() ne get-class(JsonObject) then
                    undo, throw new AppError(substitute('&1 operand not supported for array filter with JsonArray values',
                                                        string(poOperand)), 0). 
                
                assign oFilterClause = new JsonObject().
                
                oFilterClause:Add(pcFilterName, cast(poFilterValue, JsonObject)).
                oFilterObject:Add(OperandValue[integer(poOperand)], oFilterClause).
            end.    /* $ELEMMATCH */
            when PushNotificationFilterOperandEnum:Includes or
            when PushNotificationFilterOperandEnum:NotIncludes then
            do:
                if poFilterValue:GetClass() ne get-class(JsonArray) then
                    undo, throw new AppError(substitute('&1 operand not supported for array filter with JsonObject values',
                                                        string(poOperand)), 0). 
                
                assign iMax = cast(poFilterValue, JsonArray):Length.
                       oFilterValue = new JsonArray().
                       
                do iLoop = 1 to iMax:
                    assign oFilterClause = new JsonObject().
                    cast(oFilterValue, JsonArray):Add(oFilterClause).
                    
                    case cast(poFilterValue, JsonArray):GetType(iLoop):
                        when JsonDataType:Array   then
                            oFilterClause:Add(pcFilterName, 
                                              cast(poFilterValue, JsonArray):GetJsonArray(iLoop)).
                        when JsonDataType:String  then
                            oFilterClause:Add(pcFilterName, 
                                              cast(poFilterValue, JsonArray):GetCharacter(iLoop)).
                        when JsonDataType:Number  then
                            oFilterClause:Add(pcFilterName, 
                                              cast(poFilterValue, JsonArray):GetDecimal(iLoop)).
                        when JsonDataType:Boolean then 
                            oFilterClause:Add(pcFilterName, 
                                              cast(poFilterValue, JsonArray):GetLogical(iLoop)).
                        when JsonDataType:Object  then
                            oFilterClause:Add(pcFilterName, 
                                              cast(poFilterValue, JsonArray):GetJsonObject(iLoop)).
                        when JsonDataType:Null    then
                            oFilterClause:AddNull(pcFilterName). 
                    end case.   /* data type */
                end.    /* loop through elements */
                
                oFilterObject:Add(OperandValue[integer(poOperand)], cast(oFilterValue, JsonArray)).
            end.    /* $IN $NIN */
            otherwise
                undo, throw new AppError(substitute('&1 operand not supported for array filter',
                                                    string(poOperand)), 0). 
        end case.   /* operand */
        
        return this-object. 
    end method.
    
    
    /** General method to add string/character filters to the payload.
    
        Supported operands: Equals/NotEqual/Includes/NotIncludes            
        
        @param character  The name of the type of filter (type/deviceID/etc)
        @param character  The value to add
        @param PushNotificationFilterOperandEnum The operand (eq/ne/etc) 
        @return PushNotificationMessageBuilder This builder object */
    method override public PushNotificationMessageBuilder AddStringFilter(input pcFilterName as character,
                                                                          input pcFilterValue as character,
                                                                          input poOperand as PushNotificationFilterOperandEnum):
        define variable oFilterObject as JsonObject no-undo.
        define variable oFilterClause as JsonObject no-undo.
        
        Assert:NotNull(poOperand, 'Operand').
        Assert:NotNullOrEmpty(pcFilterName,  'Filter Name').
        Assert:NotNullOrEmpty(pcFilterValue, 'Filter Value').
        
        case poOperand:
            when PushNotificationFilterOperandEnum:Equals or 
            when PushNotificationFilterOperandEnum:NotEqual or
            when PushNotificationFilterOperandEnum:Includes or
            when PushNotificationFilterOperandEnum:NotIncludes then
            do:
                assign oFilterObject = new JsonObject()
                       oFilterClause = new JsonObject().
                
                AddFilter(oFilterObject).
                
                oFilterObject:Add(OperandValue[integer(poOperand)], oFilterClause).
                oFilterClause:Add(pcFilterName, pcFilterValue).
            end.
            otherwise
                undo, throw new AppError(
                                substitute('&1 operand not supported for string filters',
                                    string(poOperand)), 0). 
        end case.   /* operand */
        
        return this-object.
    end method.
    
    /** A general method to add Date filter values to the notification
        query/filter. 
        
        Supported operands: eq/ne/gt/ge/lt/le/
        
        @param character The filter name
        @param datetime The filter value
        @param PushNotificationFilterOperandEnum The operand (eg Equals or NotEqual) 
        @return PushNotificationMessageBuilder This builder object */
    method override public PushNotificationMessageBuilder AddDateFilter(input pcFilterName as character,
                                                                        input ptFilterValue as datetime,
                                                                        input poOperand as PushNotificationFilterOperandEnum):
        define variable oFilterObject as JsonObject no-undo.
        define variable oFilterClause as JsonObject no-undo.
        
        Assert:NotNull(poOperand, 'Operand').
        Assert:NotNullOrEmpty(pcFilterName, 'Filter Name').
        Assert:NotNull(ptFilterValue, 'Filter Value').
        
        case poOperand:
            when PushNotificationFilterOperandEnum:Equals or
            when PushNotificationFilterOperandEnum:NotEqual or
            when PushNotificationFilterOperandEnum:LessOrEqual or
            when PushNotificationFilterOperandEnum:LessThan or
            when PushNotificationFilterOperandEnum:GreaterOrEqual or
            when PushNotificationFilterOperandEnum:GreaterThan then
            do:
                assign oFilterObject = new JsonObject()
                       oFilterClause = new JsonObject().
                
                AddFilter(oFilterObject).
                oFilterObject:Add(OperandValue[integer(poOperand)], oFilterClause).
                oFilterClause:Add(pcFilterName, iso-date(ptFilterValue)).
            end.    /* notequal/includes/notincludes  */
            otherwise
                undo, throw new AppError(
                                substitute('&1 operand not supported for date filters',
                                    string(poOperand)), 0). 
        end case.   /* operand */
        
        return this-object.
    end.        
    
    /** A general method to add logical/boolean filter values to the notification
        query/filter. Only Equals and NotEqual supported
        
        @param character The filter name
        @param logical The filter value
        @param PushNotificationFilterOperandEnum The operand (eg Equals or NotEqual) 
        @return PushNotificationMessageBuilder This builder object */
    method override public PushNotificationMessageBuilder AddLogicalFilter(input pcFilterName as character,
                                                                           input plFilterValue as logical,
                                                                           input poOperand as PushNotificationFilterOperandEnum):
        define variable oFilterObject as JsonObject no-undo.
        define variable oFilterClause as JsonObject no-undo.
        
        Assert:NotNull(poOperand, 'Operand').
        Assert:NotNullOrEmpty(pcFilterName, 'Filter Name').
        Assert:NotUnknown(plFilterValue, 'Filter Value').
        
        case poOperand:
            when PushNotificationFilterOperandEnum:Equals or
            when PushNotificationFilterOperandEnum:NotEqual then
            do:
                assign oFilterObject = new JsonObject()
                       oFilterClause = new JsonObject().
                AddFilter(oFilterObject).
                
                oFilterObject:Add(OperandValue[integer(poOperand)], oFilterClause).
                oFilterClause:Add(pcFilterName, plFilterValue).
            end.    /* notequal/includes/notincludes  */
            otherwise
                undo, throw new AppError(
                                substitute('&1 operand not supported for logical filters',
                                    string(poOperand)), 0). 
        end case.   /* operand */
        
        return this-object.
    end. 
    
    /** A general method to add numeric(decimal) filter values to the notification
        query/filter. 
        
        Supported operands: eq/eq/gt/ge/lt/le/inc/ninc
        
        @param character The filter name
        @param decimal The filter value
        @param PushNotificationFilterOperandEnum The operand (eg Equals or NotEqual) 
        @return PushNotificationMessageBuilder This builder object */
    method override public PushNotificationMessageBuilder AddNumericFilter(input pcFilterName as character,
                                                                           input pdFilterValue as decimal,
                                                                           input poOperand as PushNotificationFilterOperandEnum):
        
        define variable oFilterObject as JsonObject no-undo.
        define variable oFilterClause as JsonObject no-undo.
        
        Assert:NotNull(poOperand, 'Operand').
        Assert:NotNullOrEmpty(pcFilterName, 'Filter Name').
        Assert:NotNull(pdFilterValue, 'Filter Value').

        case poOperand:
            when PushNotificationFilterOperandEnum:Equals or
            when PushNotificationFilterOperandEnum:NotEqual or
            when PushNotificationFilterOperandEnum:LessOrEqual or
            when PushNotificationFilterOperandEnum:LessThan or
            when PushNotificationFilterOperandEnum:GreaterOrEqual or
            when PushNotificationFilterOperandEnum:GreaterThan or
            when PushNotificationFilterOperandEnum:Includes or
            when PushNotificationFilterOperandEnum:NotIncludes then
            do:
                assign oFilterObject = new JsonObject()
                       oFilterClause = new JsonObject().
                
                AddFilter(oFilterObject).
                
                oFilterObject:Add(OperandValue[integer(poOperand)], oFilterClause).
                oFilterClause:Add(pcFilterName, pdFilterValue).
            end.
            otherwise
                undo, throw new AppError(
                                substitute('&1 operand not supported for numeric filters',
                                    string(poOperand)), 0). 
        end case.   /* operand */
        
        return this-object.
    end.

    /** General method to add object filters to the payload. Note that the
        arrays required by Includes/NotIncludes must contain objects themselves,
        but this method does NOT validate the contents of the array. The notification
        service will do so.
        
        Supported operands: Includes/NotIncludes/Equals/NotEqual            
        
        @param character      The name of the type of filter (type/deviceID/etc)
        @param JsonConstruct  The value to add. Could be Object (EqualEquals/NotEqual ) 
                              or array (Includes/NotIncludes)
        @param PushNotificationFilterOperandEnum The operand (eq/ne/etc) 
        @return PushNotificationMessageBuilder This builder object */
    method override public PushNotificationMessageBuilder AddObjectFilter(input pcFilterName as character,
                                                                          input poFilterValue as JsonConstruct,
                                                                          input poOperand as PushNotificationFilterOperandEnum):
        define variable oFilterObject as JsonObject no-undo.
        define variable oFilterClause as JsonObject no-undo.
        
        Assert:NotNull(poOperand, 'Operand').
        Assert:NotNullOrEmpty(pcFilterName, 'Filter Name').
        Assert:NotNull(poFilterValue, 'Filter Value').
        
        case poOperand:
            when PushNotificationFilterOperandEnum:Equals or
            when PushNotificationFilterOperandEnum:NotEqual then
            do:
                Assert:IsType(poFilterValue, get-class(JsonObject)).
                
                assign oFilterObject = new JsonObject().
                AddFilter(oFilterObject).
                
                oFilterObject:Add(OperandValue[integer(poOperand)], cast(poFilterValue, JsonObject)).
            end.
            when PushNotificationFilterOperandEnum:Or or
            when PushNotificationFilterOperandEnum:Includes or
            when PushNotificationFilterOperandEnum:NotIncludes then
            do:
                Assert:IsType(poFilterValue, get-class(JsonArray)).
                assign oFilterObject = new JsonObject().
                
                AddFilter(oFilterObject).
                oFilterObject:Add(OperandValue[integer(poOperand)], cast(poFilterValue, JsonArray)).
            end.
            otherwise
                undo, throw new AppError(
                                substitute('&1 operand not supported for object filter',
                                    string(poOperand)), 0). 
        end case.   /* operand */
        
        return this-object. 
    end method.
    
    /** General method to add Geolocations filters to the payload. Note that the
        objects required by the GEO type must have particular properties, 
        but this method only validates some of the properties.
        
        Supported operands: near/nearSphere/within            
        
        @param character      The name of the type of filter (type/deviceID/etc)
        @param JsonObject     The value to add. 
        @param PushNotificationFilterOperandEnum The operand (eq/ne/etc) 
        @return PushNotificationMessageBuilder This builder object */
    method override public PushNotificationMessageBuilder AddGeoFilter(input pcFilterName as character,
                                                                       input poFilterValue as JsonObject,
                                                                       input poOperand as PushNotificationFilterOperandEnum):
        define variable oFilterObject as JsonObject no-undo.
        define variable oTestObject as JsonObject no-undo.
        
        /* If a filter already exists, then the following rules apply:
            - if the existing operand does not match the new operand,
              throw an error. Otherwise,
            - if the existing operand is matches the new operand, replace 
              the filter value. */
        Assert:NotNull(poOperand, 'Operand').
        Assert:NotNullOrEmpty(pcFilterName, 'Filter Name').
        Assert:NotNull(poFilterValue, 'Filter Value').
        
        case poOperand:
            when PushNotificationFilterOperandEnum:Near then
            do:
                if not poFilterValue:Has('$near') then
                    undo, throw new AppError('Badly formed geo filter: no $near property' , 0).
                    
                if poFilterValue:GetType('$near') ne JsonDataType:ARRAY then
                    undo, throw new AppError('Badly formed geo filter: $near should be ARRAY data type' , 0).
                
                if not poFilterValue:Has('$maxDistance') then
                    undo, throw new AppError('Badly formed geo filter: no $maxDistance property' , 0).
                    
                if poFilterValue:GetType('$maxDistance') ne JsonDataType:NUMBER then
                   undo, throw new AppError('Badly formed geo filter: $maxDistance should be NUMBER data type' , 0).
            end.
            when PushNotificationFilterOperandEnum:NearSphere then
            do:
                if not poFilterValue:Has('$nearSphere') then
                    undo, throw new AppError('Badly formed geo filter: no $nearSphere property' , 0).
                    
                if poFilterValue:GetType('$nearSphere') ne JsonDataType:ARRAY then
                    undo, throw new AppError('Badly formed geo filter: $nearSphere should be ARRAY data type' , 0).
                
                if not poFilterValue:Has('$maxDistance') then
                    undo, throw new AppError('Badly formed geo filter: no $maxDistance property' , 0).
                    
                if poFilterValue:GetType('$maxDistance') ne JsonDataType:NUMBER then
                   undo, throw new AppError('Badly formed geo filter: $maxDistance should be NUMBER data type' , 0).
            end.
            when PushNotificationFilterOperandEnum:Within then
            do:
                /* $geoWithin -> $polygon */
                if not poFilterValue:Has('$geoWithin') then
                    undo, throw new AppError('Badly formed geo filter: no $geoWithin property' , 0).
                    
                if poFilterValue:GetType('$geoWithin') ne JsonDataType:OBJECT then
                    undo, throw new AppError('Badly formed geo filter: $geoWithin should be OBJECT data type' , 0).
                
                assign oTestObject = poFilterValue:GetJsonObject('$geoWithin').

                if not oTestObject:Has('$polygon') then
                    undo, throw new AppError('Badly formed geo filter: no $polygon property' , 0).
                    
                if oTestObject:GetType('$polygon') ne JsonDataType:ARRAY then
                    undo, throw new AppError('Badly formed geo filter: $polygon should be ARRAY data type' , 0).
            end.
            otherwise
                undo, throw new AppError(
                                substitute('&1 operand not supported for pointer filter',
                                    string(poOperand)), 0). 
        end case.   /* operand */
        
        /* if we got here, we passed all the validation */
        assign oFilterObject = new JsonObject().
        AddFilter(oFilterObject).
        
        oFilterObject:Add(OperandValue[integer(poOperand)], poFilterValue).
            
        return this-object. 
    end method.    
        
    /** General method to add object filters to the payload. Note that the
        objects required by the Pointer type must have particular properties, 
        but this method validates some of the properties.
        
        Supported operands: Equals/NotEqual            
        
        @param character      The name of the type of filter (type/deviceID/etc)
        @param JsonObject     The value to add. 
        @param PushNotificationFilterOperandEnum The operand (eq/ne/etc) 
        @return PushNotificationMessageBuilder This builder object */
    method override public PushNotificationMessageBuilder AddPointerFilter(input pcFilterName as character,
                                                                           input poFilterValue as JsonObject,
                                                                           input poOperand as PushNotificationFilterOperandEnum):
        define variable oFilterObject as JsonObject no-undo.

        Assert:NotNull(poOperand, 'Operand').
        Assert:NotNullOrEmpty(pcFilterName, 'Filter Name').
        Assert:NotNull(poFilterValue, 'Filter Value').
        
        /* validate the payload */
        if not poFilterValue:Has('collName') then
            undo, throw new AppError('Badly formed pointer filter: no collName property' , 0).
        if poFilterValue:GetType('collName') ne JsonDataType:STRING then
            undo, throw new AppError('Badly formed pointer filter: collName should be STRING data type' , 0).
        
        if not poFilterValue:Has('_id') then
            undo, throw new AppError('Badly formed pointer filter: no _id property' , 0).
        if poFilterValue:GetType('_id') ne JsonDataType:STRING then
           undo, throw new AppError('Badly formed pointer filter: _id should be STRING data type' , 0).
        
        case poOperand:
            when PushNotificationFilterOperandEnum:Equals or
            when PushNotificationFilterOperandEnum:NotEqual then
            do:
                assign oFilterObject = new JsonObject().
                AddFilter(oFilterObject).
                
                oFilterObject:Add(OperandValue[integer(poOperand)], poFilterValue).
            end.
            otherwise
                undo, throw new AppError(substitute('&1 operand not supported for pointer filter',
                                         string(poOperand)), 0). 
        end case.   /* operand */
        
        return this-object. 
    end method.
    
    method private void AddFilter (input poFilterObject as JsonObject):
        define variable oFilter as JsonObject no-undo.
        define variable oFilterArray as JsonArray no-undo.
        define variable oFilterParent as JsonObject no-undo.
        define variable cPropertyName as character extent no-undo.
                
        /* set the straight filter */
        if not HasOption('filter':u) then
        do:
            SetOption('filter':u, poFilterObject).
            SetOption('singleFilter':u, true).
        end.
        else
        do:            
            assign oFilter = cast(GetOptionObjectValue('filter':u), JsonObject).
            
            if GetOptionLogicalValue('singleFilter':u) then
            do:
                assign oFilterArray = new JsonArray().
                       oFilterParent = new JsonObject().
                oFilterArray:Add(oFilter).                       
                oFilterParent:Add(OperandValue[integer(PushNotificationFilterOperandEnum:And)],
                                  oFilterArray).
                SetOption('filter':u, oFilterParent).                                  
            end.
            else
            do:
                assign cPropertyName = oFilter:GetNames()
                       oFilterArray  = oFilter:GetJsonArray(cPropertyName[1]).
            end.
            
            SetOption('singleFilter':u, false).
            oFilterArray:Add(poFilterObject).
        end.
    end method.
    
end class.