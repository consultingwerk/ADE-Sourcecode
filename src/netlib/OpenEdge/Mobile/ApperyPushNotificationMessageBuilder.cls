/************************************************
Copyright (c)  2014, 2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : ApperyPushNotificationMessageBuilder
    Purpose     : Helper class to build a notification message easily 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Jun 13 13:11:41 EDT 2014
    Notes       : * Per spec/doc the message is as follows 
                        {
                            "payload": {
                                "message": <message>,
                                "badge": <badge>
                            },
                            "status":"sent",
                            "schedule": {
                                "scheduledTime": <scheduled_time>,
                                "timeZone": <time_zone>,
                                "useDeviceTimeZone": <use_time_zone>
                            },
                            "filter": {
                                "deviceID": <deviceIDcriteria>,
                                "<param1>": <criteria>,
                                
                            }
                        }        
                * Supported filter types:
                      Mobile db         ABL
                      -----------------------
                      String            Character
                      Boolean           Logical
                      Number            Decimal
                      Date              Datetime-tz
                      Array             JsonArray/JsonObject
                      Object            JsonArray/JsonObject
                      Pointer           JsonObject
                      Geo               JsonObject
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

class OpenEdge.Mobile.ApperyPushNotificationMessageBuilder inherits PushNotificationMessageBuilder:
    /* platform names per Appery */
    define private variable mcPlatform as character extent 4 no-undo
        init [?, ?, 'A':u,'I':u].
        
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
        define variable oDetail as JsonObject no-undo.
        define variable tSendDate as datetime no-undo.
        define variable tOptionValue as datetime-tz no-undo.
        define variable lOptionValue as logical no-undo.
        define variable oFilterOperand as PushNotificationFilterOperandEnum no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable oChild as JsonArray no-undo.
        define variable oPlatform as ApplicationPlatformEnum no-undo.
         
        assign oPayload = new JsonObject()
               oDetail  = new JsonObject().
        oPayload:Add('payload':u, oDetail).
        
        oDetail:Add('message':u, GetOptionStringValue('message.text':u)). 
        if HasOption('badgeCount':u) then
            oDetail:Add('badge':u, string(GetOptionNumericValue('message.count':u))).
        else
            oDetail:Add('badge':u, '':u).
            
        /* send immediately */
        if this-object:SendImmediate then
            oPayload:Add('status':u, 'sent':u).
        else
        do:
            assign oDetail = new JsonObject()
                   tOptionValue = GetOptionDateTimeValue('schedule.time':u)
                   /* use a datetime variable so that we can make the ABL do the work */
                   tSendDate = datetime(date(tOptionValue), mtime(tOptionValue)).
            
            /* YYYY-MM-DD hh:mm:00.000 (no seconds, millis)  */
            oDetail:Add('scheduledTime':u, replace(iso-date(tSendDate), 'T':u, ' ':u)). 
            assign lOptionValue = GetOptionLogicalValue('schedule.useDeviceTimeZone':u).
            
            /* explicit check for true to avoid unknown values. */
            if lOptionValue eq true then
                oDetail:Add('useDeviceTimeZone':u, 'true':u).
            else
                oDetail:Add('timeZone':u, string(timezone(tOptionValue))).
            
            /* Add schedule to payload */
            oPayload:Add('schedule':u, oDetail).
        end.    /* scheduled */
        
        /* Manual filters */        
        for each ConfigOption where
                 ConfigOption.ParentBuilder eq integer(this-object) and
                 ConfigOption.ConfigName begins 'device.id.':U      :
            
            assign oFilterOperand = PushNotificationFilterOperandEnum:GetEnum(entry(3, ConfigOption.ConfigName, '.':U))
                   no-error.
                   
            assign oChild = cast(ConfigOption.ObjectValue, JsonArray)
                   iMax   = cast(oChild, JsonArray):Length.
            do iLoop = 1 to iMax:
                AddStringFilter('deviceID':u,
                                oChild:GetCharacter(iLoop),
                                oFilterOperand).
            end.
        end.
        
        for each ConfigOption where
                 ConfigOption.ParentBuilder eq integer(this-object) and
                 ConfigOption.ConfigName begins 'channels.':U       :
            
            assign oFilterOperand = PushNotificationFilterOperandEnum:GetEnum(entry(2, ConfigOption.ConfigName, '.':U))
                   no-error.

            AddArrayFilter('channels':u,
                           cast(ConfigOption.ObjectValue, JsonArray),
                           oFilterOperand).
        end.
        
        for each ConfigOption where
                 ConfigOption.ParentBuilder eq integer(this-object) and
                 ConfigOption.ConfigName begins 'platform.':U       :
            
            /* this method needs to wait until the enum changes are checked in */
            assign oFilterOperand = PushNotificationFilterOperandEnum:GetEnum(entry(2, ConfigOption.ConfigName, '.':U))
                   no-error.

            assign oChild = cast(ConfigOption.ObjectValue, JsonArray)
                   iMax   = oChild:Length.
            do iLoop = 1 to iMax:
                assign oPlatform = ApplicationPlatformEnum:GetEnum(cast(ConfigOption.ObjectValue, JsonArray):GetCharacter(iLoop))
                       no-error.
                if valid-object(oPlatform) then
                    AddStringFilter('type':u,
                                   mcPlatform[integer(oPlatform)], 
                                   oFilterOperand).
            end.
        end.
        
        /* add filters to payload */
        assign oDetail = cast(GetOptionObjectValue('filter':u), JsonObject).
        if valid-object(oDetail) then
            oPayload:Add('filter':u, oDetail).
        
        return oPayload.
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
        define variable oFilterParent as JsonObject no-undo.
        define variable oFilterObject as JsonObject no-undo.
        define variable oFilterValue as JsonObject no-undo.
        define variable cNames as character extent no-undo.
        define variable cOperandName as character no-undo.
        define variable lFieldExists as logical no-undo.
        define variable cDateValue as character no-undo.
        
        Assert:NotNull(poOperand, 'Operand').
        Assert:NotNullOrEmpty(pcFilterName, 'Filter Name').
        Assert:NotNull(ptFilterValue, 'Filter Value').

        if not HasOption('filter':u) then
            SetOption('filter':u, new JsonObject()).
        
        assign oFilterParent = cast(GetOptionObjectValue('filter':u), JsonObject)
               lFieldExists  = ValidateOperand(oFilterParent, pcFilterName, poOperand)
               cDateValue = replace(iso-date(ptFilterValue), 'T', ' ').
        
        case poOperand:
            when PushNotificationFilterOperandEnum:Equals then
                if lFieldExists then
                    oFilterParent:Set(pcFilterName, cDateValue).
                else
                    oFilterParent:Add(pcFilterName, cDateValue).
            when PushNotificationFilterOperandEnum:NotEqual or
            when PushNotificationFilterOperandEnum:LessOrEqual or
            when PushNotificationFilterOperandEnum:LessThan or
            when PushNotificationFilterOperandEnum:GreaterOrEqual or
            when PushNotificationFilterOperandEnum:GreaterThan then
            do:
                assign oFilterObject = GetObjectProperty(oFilterParent, pcFilterName).
                if lFieldExists then
                    oFilterObject:Set(OperandValue[integer(poOperand)], cDateValue).
                else
                    oFilterObject:Add(OperandValue[integer(poOperand)], cDateValue).                
            end.    /* notequal/includes/notincludes  */
            otherwise
                undo, throw new AppError(
                                substitute('&1 operand not supported for date filters',
                                    string(poOperand)), 0). 
        end case.   /* operand */
        
        return this-object.
    end.  

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
        define variable lFieldExists as logical no-undo.

        /* If a filter already exists, then the following rules apply:
            - if the existing operand does not match the new operand,
              throw an error. Otherwise,
            - if the existing operand is matches the new operand, replace 
              the filter value. */
        Assert:NotNull(poOperand, 'Operand').
        Assert:NotNullOrEmpty(pcFilterName, 'Filter Name').
        Assert:NotNull(poFilterValue, 'Filter Value').
        
        if not HasOption('filter':u) then
            SetOption('filter':u, new JsonObject()).
        
        assign oFilterParent = cast(GetOptionObjectValue('filter':u), JsonObject)
               lFieldExists  = ValidateOperand(oFilterParent, pcFilterName, poOperand).
        
        case poOperand:
            when PushNotificationFilterOperandEnum:Matches then
            do:
                Assert:IsType(poFilterValue, get-class(JsonObject)).
                assign oFilterObject = GetObjectProperty(oFilterParent, pcFilterName).
                if lFieldExists then
                    oFilterObject:Set(OperandValue[integer(poOperand)], cast(poFilterValue, JsonObject)).
                else
                    oFilterObject:Add(OperandValue[integer(poOperand)], cast(poFilterValue, JsonObject)).
            end.
            when PushNotificationFilterOperandEnum:Includes or
            when PushNotificationFilterOperandEnum:NotIncludes then
            do:
                Assert:IsType(poFilterValue, get-class(JsonArray)).
                assign oFilterObject = GetObjectProperty(oFilterParent, pcFilterName).
                if lFieldExists then
                    oFilterObject:Set(OperandValue[integer(poOperand)], cast(poFilterValue, JsonArray)).
                else
                    oFilterObject:Add(OperandValue[integer(poOperand)], cast(poFilterValue, JsonArray)).
            end.
            otherwise
                undo, throw new AppError(
                                substitute('&1 operand not supported for array filter',
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
        define variable oFilterParent as JsonObject no-undo.
        define variable oFilterObject as JsonObject no-undo.
        define variable oArrayValue as JsonArray no-undo.
        define variable lFieldExists as logical no-undo.
        
        Assert:NotNull(poOperand, 'Operand').
        Assert:NotNullOrEmpty(pcFilterName,  'Filter Name').
        Assert:NotNullOrEmpty(pcFilterValue, 'Filter Value').
        
        if not HasOption('filter':u) then
            SetOption('filter':u, new JsonObject()).
        
        assign oFilterParent = cast(GetOptionObjectValue('filter':u), JsonObject)
               lFieldExists  = ValidateOperand(oFilterParent, pcFilterName, poOperand).
        
        case poOperand:
            when PushNotificationFilterOperandEnum:Equals then
                if lFieldExists then
                    oFilterParent:Set(pcFilterName, pcFilterValue).
                else
                    oFilterParent:Add(pcFilterName, pcFilterValue).
            when PushNotificationFilterOperandEnum:NotEqual then
            do:
                assign oFilterObject = GetObjectProperty(oFilterParent, pcFilterName).
                if lFieldExists then
                    oFilterObject:Set(OperandValue[integer(poOperand)], pcFilterValue).
                else
                    oFilterObject:Add(OperandValue[integer(poOperand)], pcFilterValue).
            end.    /* notequal/includes/notincludes  */
            when PushNotificationFilterOperandEnum:Includes or
            when PushNotificationFilterOperandEnum:NotIncludes then
            do:
                assign oFilterObject = GetObjectProperty(oFilterParent, pcFilterName)
                       oArrayValue = GetArrayProperty(oFilterObject, OperandValue[integer(poOperand)]).
                oArrayValue:Add(pcFilterValue).
            end.
            otherwise
                undo, throw new AppError(
                                substitute('&1 operand not supported for string filters',
                                    string(poOperand)), 0). 
        end case.   /* operand */
        
        return this-object.
    end method.

    /** A general method to add logical/boolean filter values to the notification
        query/filter. Only Equals and NotEqual supported
        
        @param character The filter name
        @param logical The filter value
        @param PushNotificationFilterOperandEnum The operand (eg Equals or NotEqual) 
        @return PushNotificationMessageBuilder This builder object */
    method override public PushNotificationMessageBuilder AddLogicalFilter(input pcFilterName as character,
                                                                           input plFilterValue as logical,
                                                                           input poOperand as PushNotificationFilterOperandEnum):
        define variable oFilterParent as JsonObject no-undo.
        define variable oFilterObject as JsonObject no-undo.
        define variable oFilterValue as JsonObject no-undo.
        define variable cNames as character extent no-undo.
        define variable cOperandName as character no-undo.
        define variable lFieldExists as logical no-undo.
        
        Assert:NotNull(poOperand, 'Operand').
        Assert:NotNullOrEmpty(pcFilterName, 'Filter Name').
        Assert:NotUnknown(plFilterValue, 'Filter Value').
        
        if not HasOption('filter':u) then
            SetOption('filter':u, new JsonObject()).
        
        assign oFilterParent = cast(GetOptionObjectValue('filter':u), JsonObject)
               lFieldExists  = ValidateOperand(oFilterParent, pcFilterName, poOperand).
        
        case poOperand:
            when PushNotificationFilterOperandEnum:Equals then
                if lFieldExists then
                    oFilterParent:Set(pcFilterName, plFilterValue).
                else
                    oFilterParent:Add(pcFilterName, plFilterValue).
            when PushNotificationFilterOperandEnum:NotEqual then
            do:
                assign oFilterObject = GetObjectProperty(oFilterParent, pcFilterName).
                if lFieldExists then
                    oFilterObject:Set(OperandValue[integer(poOperand)], plFilterValue).
                else
                    oFilterObject:Add(OperandValue[integer(poOperand)], plFilterValue).                
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
        define variable oFilterParent as JsonObject no-undo.
        define variable oFilterObject as JsonObject no-undo.
        define variable oFilterValue as JsonObject no-undo.
        define variable oArrayValue as JsonArray no-undo.
        define variable lFieldExists as logical no-undo.
        
        Assert:NotNull(poOperand, 'Operand').
        Assert:NotNullOrEmpty(pcFilterName, 'Filter Name').
        Assert:NotNull(pdFilterValue, 'Filter Value').

        if not HasOption('filter':u) then
            SetOption('filter':u, new JsonObject()).
        
        assign oFilterParent = cast(GetOptionObjectValue('filter':u), JsonObject)
               lFieldExists  = ValidateOperand(oFilterParent, pcFilterName, poOperand).
        
        case poOperand:
            when PushNotificationFilterOperandEnum:Equals then
                if lFieldExists then
                    oFilterParent:Set(pcFilterName, pdFilterValue).
                else
                    oFilterParent:Add(pcFilterName, pdFilterValue).
            when PushNotificationFilterOperandEnum:NotEqual or
            when PushNotificationFilterOperandEnum:LessOrEqual or
            when PushNotificationFilterOperandEnum:LessThan or
            when PushNotificationFilterOperandEnum:GreaterOrEqual or
            when PushNotificationFilterOperandEnum:GreaterThan then
            do:
                assign oFilterObject = GetObjectProperty(oFilterParent, pcFilterName).
                if lFieldExists then
                    oFilterObject:Set(OperandValue[integer(poOperand)], pdFilterValue).
                else
                    oFilterObject:Add(OperandValue[integer(poOperand)], pdFilterValue).                
            end.    /* notequal/includes/notincludes  */
            when PushNotificationFilterOperandEnum:Includes or
            when PushNotificationFilterOperandEnum:NotIncludes then
            do:
                assign oFilterObject = GetObjectProperty(oFilterParent, pcFilterName)
                       oArrayValue = GetArrayProperty(oFilterObject, OperandValue[integer(poOperand)]).
                oArrayValue:Add(pdFilterValue).
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
        define variable oFilterParent as JsonObject no-undo.
        define variable oFilterObject as JsonObject no-undo.
        define variable lFieldExists as logical no-undo.
        
        /* If a filter already exists, then the following rules apply:
            - if the existing operand does not match the new operand,
              throw an error. Otherwise,
            - if the existing operand is matches the new operand, replace 
              the filter value. */
        Assert:NotNull(poOperand, 'Operand').
        Assert:NotNullOrEmpty(pcFilterName, 'Filter Name').
        Assert:NotNull(poFilterValue, 'Filter Value').
        
        if not HasOption('filter':u) then
            SetOption('filter':u, new JsonObject()).
        
        assign oFilterParent = cast(GetOptionObjectValue('filter':u), JsonObject)
               lFieldExists  = ValidateOperand(oFilterParent, pcFilterName, poOperand).
        
        case poOperand:
            when PushNotificationFilterOperandEnum:Equals then
            do:
                Assert:IsType(poFilterValue, get-class(JsonObject)).
                if lFieldExists then
                    oFilterParent:Set(pcFilterName, cast(poFilterValue, JsonObject)).
                else
                    oFilterParent:Add(pcFilterName, cast(poFilterValue, JsonObject)).
            end.
            when PushNotificationFilterOperandEnum:NotEqual then
            do:
                Assert:IsType(poFilterValue, get-class(JsonObject)).
                
                assign oFilterObject = GetObjectProperty(oFilterParent, pcFilterName).
                if lFieldExists then
                    oFilterObject:Set(OperandValue[integer(poOperand)], cast(poFilterValue, JsonObject)).
                else
                    oFilterObject:Add(OperandValue[integer(poOperand)], cast(poFilterValue, JsonObject)).
            end.
            when PushNotificationFilterOperandEnum:Includes or
            when PushNotificationFilterOperandEnum:NotIncludes then
            do:
                Assert:IsType(poFilterValue, get-class(JsonArray)).
                assign oFilterObject = GetObjectProperty(oFilterParent, pcFilterName).
                if lFieldExists then
                    oFilterObject:Set(OperandValue[integer(poOperand)], cast(poFilterValue, JsonArray)).
                else
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
        define variable oFilterParent as JsonObject no-undo.
        define variable oFilterObject as JsonObject no-undo.
        define variable lFieldExists as logical no-undo.
        define variable oTestObject as JsonObject no-undo.
        
        /* If a filter already exists, then the following rules apply:
            - if the existing operand does not match the new operand,
              throw an error. Otherwise,
            - if the existing operand is matches the new operand, replace 
              the filter value. */
        Assert:NotNull(poOperand, 'Operand').
        Assert:NotNullOrEmpty(pcFilterName, 'Filter Name').
        Assert:NotNull(poFilterValue, 'Filter Value').
        
        if not HasOption('filter':u) then
            SetOption('filter':u, new JsonObject()).
        
        assign oFilterParent = cast(GetOptionObjectValue('filter':u), JsonObject)
               lFieldExists  = ValidateOperand(oFilterParent, pcFilterName, poOperand).
        
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
        assign oFilterObject = GetObjectProperty(oFilterParent, pcFilterName).
        if lFieldExists then
            oFilterObject:Set(OperandValue[integer(poOperand)], poFilterValue).
        else
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
        define variable oFilterParent as JsonObject no-undo.
        define variable oFilterObject as JsonObject no-undo.
        define variable lFieldExists as logical no-undo.
        
        /* If a filter already exists, then the following rules apply:
            - if the existing operand does not match the new operand,
              throw an error. Otherwise,
            - if the existing operand is matches the new operand, replace 
              the filter value. */
        Assert:NotNull(poOperand, 'Operand').
        Assert:NotNullOrEmpty(pcFilterName, 'Filter Name').
        Assert:NotNull(poFilterValue, 'Filter Value').
        
        if not HasOption('filter':u) then
            SetOption('filter':u, new JsonObject()).
        
        assign oFilterParent = cast(GetOptionObjectValue('filter':u), JsonObject)
               lFieldExists  = ValidateOperand(oFilterParent, pcFilterName, poOperand).
        
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
            when PushNotificationFilterOperandEnum:Equals then
            do:
                if lFieldExists then
                    oFilterParent:Set(pcFilterName, poFilterValue).
                else
                    oFilterParent:Add(pcFilterName, poFilterValue).
            end.
            when PushNotificationFilterOperandEnum:NotEqual then
            do:
                assign oFilterObject = GetObjectProperty(oFilterParent, pcFilterName).
                if lFieldExists then
                    oFilterObject:Set(OperandValue[integer(poOperand)], poFilterValue).
                else
                    oFilterObject:Add(OperandValue[integer(poOperand)], poFilterValue).
            end.
            otherwise
                undo, throw new AppError(substitute('&1 operand not supported for pointer filter',
                                         string(poOperand)), 0). 
        end case.   /* operand */
        
        return this-object. 
    end method.
    
    /** Validates the incoming operand with any existing operand. The operand
        cannot be changed once set.
        
        @param JsonObject The object representing the 'filter' property.
        @param character  The name of the type of filter (type/deviceID/etc)
        @param PushNotificationFilterOperandEnum The operand (eq/ne/etc)
        @return logical True if a filter already exists     */
    method private logical ValidateOperand (input poFilterParent as JsonObject,
                                            input pcFilterName as character,
                                            input poOperand as PushNotificationFilterOperandEnum):
        define variable oFilterObject as JsonObject no-undo.
        define variable cNames as character extent no-undo.
        define variable cOperandName as character no-undo.
        define variable lFieldExists as logical no-undo.
        
        assign lFieldExists = poFilterParent:Has(pcFilterName). 
        
        if lFieldExists then
        do:
            if poFilterParent:GetType(pcFilterName) eq JsonDataType:STRING then
                assign extent(cNames) = 1
                       /* blank */
                       cNames = OperandValue[integer(PushNotificationFilterOperandEnum:Equals)].
            else
                assign oFilterObject = GetObjectProperty(poFilterParent, pcFilterName)
                       cNames = oFilterObject:GetNames().
            
            /* If there are no properties set, then we can consider the field 
               non-extant. */
            if extent(cNames) eq ? then
                lFieldExists = false.
            else
                assign cOperandName = cNames[1].
            
            /* do not allow operand changes */
            if cOperandName ne OperandValue[integer(poOperand)] then
                undo, throw new AppError(
                                substitute('Filter field &1 value already has operand &2 set',
                                            pcFilterName,
                                            cOperandName
                                            ), 0).
        end.
        
        return lFieldExists.         
    end method.
end class.