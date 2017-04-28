/************************************************
Copyright (c)  2015-2016 by Progress Software Corporation. All rights reserved.
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
                  * Query operators follow the MongoDB rules at 
                    https://docs.mongodb.org/manual/reference/operator/query/
                  * Dates are subject to the rules at https://docs.mongodb.org/manual/reference/bson-types/#date 
                    which basically says that they are process in UTC timezone.  
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Assertion.AssertJson.
using OpenEdge.Core.JsonDataTypeEnum.
using OpenEdge.Core.System.UnsupportedOperationError.
using OpenEdge.Mobile.ApplicationPlatformEnum.
using OpenEdge.Mobile.PushNotificationFilterOperandEnum.
using OpenEdge.Mobile.PushNotificationMessageBuilder.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.AppError.

class OpenEdge.Mobile.TelerikPushNotificationMessageBuilder inherits PushNotificationMessageBuilder:
    
    define override public property Payload as JsonObject no-undo
        get(): 
            if not valid-object(this-object:Payload) then
                assign this-object:Payload = NewPayload().
            
            return this-object:Payload.
        end get.
        private set.
    
    /* Helper method to return date/time/-tz in a decent format
        
       @param date A date value to format
       @return character ISO-DATE format */
    method private character FormatDate(input ptDate as date):
        define variable dtTemp as datetime-tz no-undo.
        
        Assert:NotNull(ptDate, 'Date to format').
        
        assign dtTemp = datetime-tz(ptDate, 0).
        return substitute('&1Z':u, iso-date(datetime(date(dtTemp), mtime(dtTemp)))).
    end method.

    /* Helper method to return date/time/-tz in a decent format
       
       @param datetime A datetime value to format
       @return character ISO-DATE format */
    method private character FormatDate(input ptDate as datetime):
        define variable dtTemp as datetime-tz no-undo.
        
        Assert:NotNull(ptDate, 'Date to format').
        
        assign dtTemp = datetime-tz(ptDate, 0).
        return substitute('&1Z':u, iso-date(datetime(date(dtTemp), mtime(dtTemp)))).
    end method.

    /* Helper method to return date/time/-tz in a decent format
        
       @param datetime-tz A datetime-tz value to format
       @return character ISO-DATE format */
    method private character FormatDate(input ptDate as datetime-tz):
        define variable dtTemp as datetime-tz no-undo.
        define variable cIsoDate as character no-undo.
        
        Assert:NotNull(ptDate, 'Date to format').
        
        assign dtTemp  = datetime-tz(ptDate, 0).
        return substitute('&1Z':u, iso-date(datetime(date(dtTemp), mtime(dtTemp)))).
    end method.
    
    /** Returns a useable Payload based on the config.
        
        @return JsonObject A useable push notification message payload */
    method private JsonObject NewPayload():
        define variable oPayload as JsonObject no-undo.
        define variable oPlatform as JsonObject no-undo.
        define variable oParent as JsonObject no-undo.
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
        define variable oFilterValue as JsonObject no-undo.
        
        assign oPayload = new JsonObject().
        
        /* general options */
        if not this-object:SendImmediate then
        do:
            assign tOptionValue = GetOptionDateTimeValue('schedule.time':u).
            Assert:NotNull(tOptionValue, 'Notification schedule time').
            
            /* Per https://docs.mongodb.org/manual/reference/bson-types/#date we need
               to send time in UTC timezone */
            oPayload:Add('NotificationDate':u, FormatDate(tOptionValue)).
            
            if HasOption('schedule.useDeviceTimeZone':u) then
                oPayload:Add('UseLocalTime':u, GetOptionLogicalValue('schedule.useDeviceTimeZone':u)).
        end.
                
        if HasOption('schedule.expiration':u) then
        do:
            assign tOptionValue = GetOptionDateTimeValue('schedule.expiration':u).
            Assert:NotNull(tOptionValue, 'Notification expiration time').

            oPayload:Add('ExpirationDate':u, FormatDate(tOptionValue)).
        end.
        
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
            /* map some operators */
            case oFilterOperand:
                when PushNotificationFilterOperandEnum:Matches then
                    assign oFilterOperand = PushNotificationFilterOperandEnum:All. 
            end case.
            
            /* build the filter object */
            assign oFilterValue = new JsonObject()
                   oFilterClause = new JsonObject().
            
            oFilterValue:Add('Parameters.channels':u, oFilterClause).
            
            /* { field: { $in: [<value1>, <value2>, ... <valueN> ] } } */
            oFilterClause:Add(OperandValue[integer(oFilterOperand)], 
                              cast(ConfigOption.ObjectValue, JsonArray)).
            AddFilter(oFilterValue).
        end.
        
        /* Devices next */
        assign oFilters = new JsonArray().
        for each ConfigOption where
                 ConfigOption.ParentBuilder eq integer(this-object) and
                 ConfigOption.ConfigName begins 'device.id.':U      :
            
            assign oFilterOperand = PushNotificationFilterOperandEnum:GetEnum(entry(3, ConfigOption.ConfigName, '.':U))
                   no-error.
            /* map some operators */
            case oFilterOperand:
                when PushNotificationFilterOperandEnum:Equals then
                    assign oFilterOperand = PushNotificationFilterOperandEnum:Includes.
                when PushNotificationFilterOperandEnum:NotEqual then
                    assign oFilterOperand = PushNotificationFilterOperandEnum:NotIncludes.
            end case.
            
            /* build the filter object */
            assign oFilterValue = new JsonObject()
                   oFilterClause = new JsonObject().
            
            oFilterValue:Add('HardwareId':u, oFilterClause).
            
            /* { field: { $in: [<value1>, <value2>, ... <valueN> ] } } */
            oFilterClause:Add(OperandValue[integer(oFilterOperand)], 
                              cast(ConfigOption.ObjectValue, JsonArray)).
            AddFilter(oFilterValue).
        end.
        
        /* add filters to payload */
        assign oFilters = cast(GetOptionObjectValue('filter':u), JsonArray).
        if valid-object(oFilters) then
        do:
            assign oFilterOperand = cast(GetOptionObjectValue('match.operand':u), PushNotificationFilterOperandEnum)
                   oParent        = new JsonObject().
            
            oParent:Add(OperandValue[integer(oFilterOperand)], oFilters).
            
            if log-manager:logging-level gt 4 then
                oParent:WriteFile(session:temp-dir + 'push_notification_filter.json':u, true).
            
            oPayload:Add('Filter':u, oParent:GetJsonText()).
        end.
        
        return oPayload.
    end method.
    
    /** General method to add array filters to the payload.
        Supported operands: Includes/NotIncludes/Matches/Equals            
        
        @param character      The name of the type of filter (type/deviceID/etc)
        @param JsonConstruct  The value to add. Could be Object (matches only) 
                              or array (Includes/NotIncludes)
        @param PushNotificationFilterOperandEnum The operand (eq/ne/etc) 
        @return PushNotificationMessageBuilder This builder object */
    method override public PushNotificationMessageBuilder AddArrayFilter(input pcFilterName as character,
                                                                         input poFilterValue as JsonConstruct,
                                                                         input poOperand as PushNotificationFilterOperandEnum):
        define variable oFilterClause as JsonObject no-undo.
        define variable oFilterValue as JsonObject no-undo.
 
        Assert:NotNull(poOperand, 'Operand').
        Assert:NotNullOrEmpty(pcFilterName, 'Filter Name').
        Assert:NotNull(poFilterValue, 'Filter Value').
        Assert:IsType(poFilterValue, get-class(JsonArray)).

        case poOperand:
            when PushNotificationFilterOperandEnum:Matches then
                assign poOperand = PushNotificationFilterOperandEnum:All.
            when PushNotificationFilterOperandEnum:Equals      or
            when PushNotificationFilterOperandEnum:Includes    or
            when PushNotificationFilterOperandEnum:NotIncludes then
                . /* noop; operator stays the same */
            otherwise
                undo, throw new AppError(substitute('&1 operand not supported for array filter',
                                                    string(poOperand)), 0). 
        end case.   /* operand */
        
        /* build the filter object */
        assign oFilterValue = new JsonObject()
               oFilterClause = new JsonObject().
        
        oFilterValue:Add(pcFilterName, oFilterClause).
        
        /* { field: { $in: [<value1>, <value2>, ... <valueN> ] } } */
        oFilterClause:Add(OperandValue[integer(poOperand)], 
                          cast(poFilterValue, JsonArray)).
        AddFilter(oFilterValue).
        
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
            when PushNotificationFilterOperandEnum:NotEqual then
                . /* no-op */
            when PushNotificationFilterOperandEnum:Includes then
                assign poOperand = PushNotificationFilterOperandEnum:Equals. 
                
            when PushNotificationFilterOperandEnum:NotIncludes then
                assign poOperand = PushNotificationFilterOperandEnum:NotEqual.
            otherwise
                undo, throw new AppError(
                                substitute('&1 operand not supported for string filters',
                                    string(poOperand)), 0). 
        end case.   /* operand */
        
        assign oFilterObject = new JsonObject()
               oFilterClause = new JsonObject().
        
        oFilterObject:Add(pcFilterName, oFilterClause).
        oFilterClause:Add(OperandValue[integer(poOperand)], pcFilterValue).
        AddFilter(oFilterObject).
        
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
        define variable oFilterValue as JsonObject no-undo.
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
                /* build the filter object */
                assign oFilterValue = new JsonObject()
                       oFilterClause = new JsonObject().
                
                oFilterValue:Add(pcFilterName, oFilterClause).
                
                /* Per https://docs.mongodb.org/manual/reference/bson-types/#date we need
                   to send time in UTC timezone */
                oFilterClause:Add(OperandValue[integer(poOperand)],
                                  FormatDate(ptFilterValue)).                
                AddFilter(oFilterValue).
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
        define variable oFilterValue as JsonObject no-undo.
        define variable oFilterClause as JsonObject no-undo.
        
        Assert:NotNull(poOperand, 'Operand').
        Assert:NotNullOrEmpty(pcFilterName, 'Filter Name').
        Assert:NotUnknown(plFilterValue, 'Filter Value').
        
        case poOperand:
            when PushNotificationFilterOperandEnum:Equals or
            when PushNotificationFilterOperandEnum:NotEqual then
            do:
                /* build the filter object */
                assign oFilterValue = new JsonObject()
                       oFilterClause = new JsonObject().
                
                oFilterValue:Add(pcFilterName, oFilterClause).
                oFilterClause:Add(OperandValue[integer(poOperand)], plFilterValue).
                AddFilter(oFilterValue).
            end.    /* notequal/includes/notincludes  */
            otherwise
                undo, throw new AppError(
                                substitute('&1 operand not supported for logical filters',
                                    string(poOperand)), 0). 
        end case.   /* operand */
        
        return this-object.
    end method. 
    
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
        define variable oFilterValue as JsonObject no-undo.
        
        Assert:NotNull(poOperand, 'Operand').
        Assert:NotNullOrEmpty(pcFilterName, 'Filter Name').
        Assert:NotNull(pdFilterValue, 'Filter Value').

        case poOperand:
            when PushNotificationFilterOperandEnum:Equals or
            when PushNotificationFilterOperandEnum:NotEqual or
            when PushNotificationFilterOperandEnum:LessOrEqual or
            when PushNotificationFilterOperandEnum:LessThan or
            when PushNotificationFilterOperandEnum:GreaterOrEqual or
            when PushNotificationFilterOperandEnum:GreaterThan then
            do:
                /* build the filter object */
                assign oFilterValue = new JsonObject()
                       oFilterClause = new JsonObject().

                oFilterValue:Add(pcFilterName, oFilterClause).
                oFilterClause:Add(OperandValue[integer(poOperand)], pdFilterValue).
                AddFilter(oFilterValue).
            end.
            otherwise
                undo, throw new AppError(
                                substitute('&1 operand not supported for numeric filters',
                                    string(poOperand)), 0). 
        end case.   /* operand */
        
        return this-object.
    end method.
    
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
        define variable oFilterValue as JsonObject no-undo.
        define variable oFilterClause as JsonObject no-undo.
        
        Assert:NotNull(poOperand, 'Operand').
        Assert:NotNullOrEmpty(pcFilterName, 'Filter Name').
        Assert:NotNull(poFilterValue, 'Filter Value').
        
        if type-of(poFilterValue, JsonArray) then
            return AddArrayFilter(pcFilterName, poFilterValue, poOperand).
        else
        case poOperand:
            when PushNotificationFilterOperandEnum:Equals or
            when PushNotificationFilterOperandEnum:NotEqual then
            do:
                /* build the filter object */
                assign oFilterValue = new JsonObject()
                       oFilterClause = new JsonObject().
                
                oFilterValue:Add(pcFilterName, oFilterClause).
                oFilterClause:Add(OperandValue[integer(poOperand)], cast(poFilterValue, JsonObject)).
                AddFilter(oFilterValue).
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
        
        Supported operands: near/nearSphere/within/Intersects
        
        @param character      The name of the type of filter (type/deviceID/etc)
        @param JsonObject     The value to add. 
        @param PushNotificationFilterOperandEnum The operand (eq/ne/etc) 
        @return PushNotificationMessageBuilder This builder object */
    method override public PushNotificationMessageBuilder AddGeoFilter(input pcFilterName as character,
                                                                       input poFilterValue as JsonObject,
                                                                       input poOperand as PushNotificationFilterOperandEnum):
        define variable oFilterValue as JsonObject no-undo.
        define variable oFilterClause as JsonObject no-undo.
        define variable cGeoType as character no-undo.
        
        /* If a filter already exists, then the following rules apply:
            - if the existing operand does not match the new operand,
              throw an error. Otherwise,
            - if the existing operand is matches the new operand, replace 
              the filter value. */
        Assert:NotNull(poOperand, 'Operand').
        Assert:NotNullOrEmpty(pcFilterName, 'Filter Name').
        Assert:NotNull(poFilterValue, 'Filter Value').
        
        case poOperand:
            when PushNotificationFilterOperandEnum:Near or
            when PushNotificationFilterOperandEnum:NearSphere or
            when PushNotificationFilterOperandEnum:Within or
            when PushNotificationFilterOperandEnum:Intersects then
            do:
                AssertJson:PropertyIsType(poFilterValue, 'type':u, JsonDataTypeEnum:String).
                
                assign cGeoType = poFilterValue:GetCharacter('type':u).
                if lookup(cGeoType, 'Point,MultiPoint,LineString,MultiLineString,Polygon,MultiPolygon,GeometryCollection':u) eq 0 then
                    undo, throw new AppError(substitute('Invalid GeoJSON type: &1', cGeoType), 0).
                
                if cGeoType eq 'GeometryCollection':u then
                    AssertJson:PropertyNotNull(poFilterValue, 'geometries':u).
                else
                    AssertJson:PropertyNotNull(poFilterValue, 'coordinates':u).
                
                /* build the filter object */
                assign oFilterValue = new JsonObject()
                       oFilterClause = new JsonObject().
                
                oFilterValue:Add(pcFilterName, oFilterClause).
                oFilterClause:Add(OperandValue[integer(poOperand)], cast(poFilterValue, JsonObject)).
                AddFilter(oFilterValue).
            end.
            otherwise
                undo, throw new AppError(
                                substitute('&1 operand not supported for pointer filter',
                                    string(poOperand)), 0). 
        end case.   /* operand */
        
        return this-object. 
    end method.    
        
    /** UNSUPPORTED OPERATION
        
        General method to add object filters to the payload. Note that the
        objects required by the Pointer type must have particular properties, 
        but this method validates some of the properties.
        
                    
        
        @param character      The name of the type of filter (type/deviceID/etc)
        @param JsonObject     The value to add. 
        @param PushNotificationFilterOperandEnum The operand (eq/ne/etc) 
        @return PushNotificationMessageBuilder This builder object */
    method override public PushNotificationMessageBuilder AddPointerFilter(input pcFilterName as character,
                                                                           input poFilterValue as JsonObject,
                                                                           input poOperand as PushNotificationFilterOperandEnum):
        
        return error new UnsupportedOperationError('AddPointerFilter', this-object:GetClass():TypeName).
    end method.
    
    /* Adds a filter clause to the filter set.
       
       @param JsonConstruct The filter data - an array or an object */
    method private void AddFilter (input poFilterObject as JsonConstruct):
        define variable oFilterArray as JsonArray no-undo.
        define variable oFilterParent as JsonObject no-undo.
        
        Assert:NotNull(poFilterObject, 'Filter object').
        
        /* set the straight filter */
        if not HasOption('filter':u) then
            SetOption('filter':u, new JsonArray()).
        
        assign oFilterArray = cast(GetOptionObjectValue('filter':u), JsonArray).
        if type-of(poFilterObject, JsonObject) then
            oFilterArray:Add(cast(poFilterObject, JsonObject)).
        else
        if type-of(poFilterObject, JsonArray) then
            oFilterArray:Add(cast(poFilterObject, JsonArray)).
    end method.
    
end class.