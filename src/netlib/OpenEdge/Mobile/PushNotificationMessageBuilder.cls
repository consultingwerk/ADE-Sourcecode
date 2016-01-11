/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : PushNotificationMessageBuilder
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
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.AppError.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonConstruct.

class OpenEdge.Mobile.PushNotificationMessageBuilder:
    
    /* List of operands that the message need. A property to keep it read-only.
       The index of this array matches the Value of the 
       PushNotificationFilterOperandEnum property in question. */
    define private property OperandValue as character extent 12
        initial ['' /* equals doesn't use object like others */, '$ne', '$in',
                 '$nin', '$elemMatch', '$gt', '$gte', '$lt', '$lte', '$near', 
                 '$nearSphere', '$geoWithin']
        no-undo get.
    
    /** Returns the newly-constructed payload. */
    define public property Payload as JsonObject no-undo get. private set.
    
    /* Some operations ignored if this is a send-immediate */
    define public property SendImmediate as logical no-undo get. private set. 
    
    /** Constructor.
        
        @param character The message text to be sent.
        @param integer   The badge counter (only used for iOS). 
        @param logical   TRUE if this messages is for immediate sending */
    constructor private PushNotificationMessageBuilder(input pcMessage as character,
                                                       input piBadge as integer,
                                                       input plSendImmediate as logical):
        define variable oDetail as JsonObject no-undo.
        
        Assert:NotNullOrEmpty(pcMessage, 'Notification message').
        Assert:IsZeroOrPositive(piBadge, 'Notification badge count').
        Assert:NotUnknown(plSendImmediate, 'Send Immediate flag').
                                                                   
        assign this-object:Payload = new JsonObject()
               oDetail = new JsonObject()
               this-object:SendImmediate = plSendImmediate.
        
        this-object:Payload:Add('payload', oDetail).
            oDetail:Add('message', pcMessage).
        
        if piBadge eq 0 then
            oDetail:Add('badge', '').
        else            
            oDetail:Add('badge', string(piBadge)).
    end constructor.
    
    /** Factory for this builder, for messages to send immediately.
    
        @param character The message text to be sent.
        @param integer   The badge counter (only used for iOS). 
        @return PushNotificationMessageBuilder  The new builder */
    method static public PushNotificationMessageBuilder Send(input pcMessage as character,
                                                             input piBadge as integer):
        define variable oBuilder as PushNotificationMessageBuilder no-undo.
        
        oBuilder = new PushNotificationMessageBuilder(pcMessage, piBadge, true).
        
        /* send immediately */
        oBuilder:Payload:Add('status', 'sent').
        
        return oBuilder. 
    end method.

    /** Factory for this builder, for messages to schedule for future sending
        
        @param character The message text to be sent.
        @param integer   The badge counter (only used for iOS). 
        @return PushNotificationMessageBuilder  The new builder */
    method static public PushNotificationMessageBuilder Schedule(input pcMessage as character,
                                                                 input piBadge as integer):
        return new PushNotificationMessageBuilder(pcMessage, piBadge, false).
    end method.
    
    /** Sets the time at which to schedule the notification. No-op if this is a 
        send-immediate message.
    
        @param datetime-tz A time in the future (at least the following minute)
                           at which to send the notification.
        @return PushNotificationMessageBuilder  This builder */
    method public PushNotificationMessageBuilder At(input ptSendAt as datetime-tz):
        define variable oDetail as JsonObject no-undo.
        /* use a datetime variable so that we can make the ABL do the work */
        define variable tSendDate as datetime no-undo.
        
        if not this-object:SendImmediate then
        do:
            Assert:IsPositive(interval(ptSendAt, now, 'seconds'), 'Send at delta').
            
            assign oDetail = GetObjectProperty(this-object:Payload, 'schedule')
                   tSendDate = datetime(date(ptSendAt), mtime(ptSendAt)).
            
            /* YYYY-MM-DD hh:mm:00.000 (no seconds, millis)  */
            oDetail:Add('scheduledTime', replace(iso-date(tSendDate), 'T', ' ')). 
            oDetail:Add('timeZone',      string(timezone(ptSendAt))).
        end.
        
        return this-object.
    end method.
    
    /** Tells the notification to use the device's timezone (not the timezone
        of the scheduled time). No-op for a send-immediate message.
    
        @return PushNotificationMessageBuilder  This builder */
    method public PushNotificationMessageBuilder UseDeviceTimeZone():
        return this-object:UseDeviceTimeZone(true).
    end method.
    
    /** Tells the notification to use the device's timezone (not the timezone
        of the scheduled time). No-op for a send-immediate message.
    
        @param logical TRUE if we are to use the device time zone.
        @return PushNotificationMessageBuilder  The current builder */
    method public PushNotificationMessageBuilder UseDeviceTimeZone(input plUseDeviceTimeZone as logical):
        if not this-object:SendImmediate then
            GetObjectProperty(this-object:Payload, 'schedule')
                    :Add('useDeviceTimeZone', trim(string(plUseDeviceTimeZone, "true/false"))).
        
        return this-object.
    end method.
    
    /** PLATFORM START **/
    /** Includes the given platform
    
        @param ApplicationPlatformEnum The mobile platform to include
        @return PushNotificationMessageBuilder  The current builder */
    method public PushNotificationMessageBuilder IncludePlatform(input poPlatform as ApplicationPlatformEnum):
        Assert:NotNull(poPlatform, 'Platform').
        
        AddStringFilter(
                  'type',
                  poPlatform:Name,
                  PushNotificationFilterOperandEnum:Includes).
        
        return this-object.
    end method.

    /** Exclude only the specified platform from the notification.
    
        @param ApplicationPlatformEnum The mobile platform to include
        @return PushNotificationMessageBuilder  The current builder */
    method public PushNotificationMessageBuilder NotOnPlatform(input poPlatform as ApplicationPlatformEnum):
        Assert:NotNull(poPlatform, 'Platform').
        
        AddStringFilter(
                  'type',
                  poPlatform:Name,
                  PushNotificationFilterOperandEnum:NotEqual).
        
        return this-object.
    end method.
    
    /** Excludes the given platform (can be multiple)
        
        @param ApplicationPlatformEnum The mobile platform to include
        @return PushNotificationMessageBuilder  The current builder */
    method public PushNotificationMessageBuilder ExcludePlatform(input poPlatform as ApplicationPlatformEnum):
        Assert:NotNull(poPlatform, 'Platform').
        
        AddStringFilter(
                  'type',
                  poPlatform:Name,
                  PushNotificationFilterOperandEnum:NotIncludes).
        
        return this-object.
    end method.
    
    /** Send the notification to only this platform.
        
        @param ApplicationPlatformEnum The mobile platform to include
        @return PushNotificationMessageBuilder  The current builder */
    method public PushNotificationMessageBuilder OnPlatform(input poPlatform as ApplicationPlatformEnum):
        Assert:NotNull(poPlatform, 'Platform').
        
        AddStringFilter(
                  'type',
                  poPlatform:Name,
                  PushNotificationFilterOperandEnum:Equals).
        
        return this-object.
    end method.
    /** PLATFORM END **/
    
    /** DEVICE START **/
    /** Push notification for the given device id only.
    
        @param character A device ID  
        @return PushNotificationMessageBuilder This builder object */
    method public PushNotificationMessageBuilder OnDevice(input pcDeviceId as character):
        Assert:NotNullOrEmpty(pcDeviceId, 'Device ID').
        
        AddStringFilter(
                  'deviceID',
                  pcDeviceId,
                  PushNotificationFilterOperandEnum:Equals).
        
        return this-object.
    end method.

    /** Push notification for all devices except for the given device id
    
        @param character A device ID  
        @return PushNotificationMessageBuilder This builder object */
    method public PushNotificationMessageBuilder NotOnDevice(input pcDeviceId as character):
        Assert:NotNullOrEmpty(pcDeviceId, 'Device ID').
        
        AddStringFilter(
                  'deviceID',
                  pcDeviceId,
                  PushNotificationFilterOperandEnum:NotEqual).
        
        return this-object.
    end method.
    
    /** Include the device in the Push notification filter .
    
        @param character A device ID  
        @return PushNotificationMessageBuilder This builder object */
    method public PushNotificationMessageBuilder IncludeDevice(input pcDeviceId as character):
        Assert:NotNullOrEmpty(pcDeviceId, 'Device ID').
        
        AddStringFilter(
                  'deviceID',
                  pcDeviceId,
                  PushNotificationFilterOperandEnum:Includes).
        
        return this-object.
    end method.
    
    /** Exclude the device from the Push notification filter .
    
        @param character A device ID  
        @return PushNotificationMessageBuilder This builder object */
    method public PushNotificationMessageBuilder ExcludeDevice(input pcDeviceId as character):
        Assert:NotNullOrEmpty(pcDeviceId, 'Device ID').
        
        AddStringFilter(
                  'deviceID',
                  pcDeviceId,
                  PushNotificationFilterOperandEnum:NotIncludes).

        return this-object.
    end method.
    /** DEVICE END **/
    
    /** CHANNELS START **/
    /** Includes the array of named channels.
    
        @param JsonArray An array of channels.  
        @return PushNotificationMessageBuilder This builder object */
    method public PushNotificationMessageBuilder IncludeChannels(input poChannels as JsonArray):
        Assert:NotNull(poChannels, 'Channels').
        
        AddArrayFilter('channels',
                       poChannels,
                       PushNotificationFilterOperandEnum:Includes).
        
        return this-object.
    end method.
    
    /** Excludes the array of named channels.
    
        @param JsonArray An array of channels.  
        @return PushNotificationMessageBuilder This builder object */
    method public PushNotificationMessageBuilder ExcludeChannels(input poChannels as JsonArray):
        Assert:NotNull(poChannels, 'Channels').
        
        return AddArrayFilter('channels',
                       poChannels,
                       PushNotificationFilterOperandEnum:NotIncludes).
    end method.
    
    /** Filter for matching the array of named channels.
    
        @param JsonArray An array of channels.  
        @return PushNotificationMessageBuilder This builder object */
    method public PushNotificationMessageBuilder MatchChannels(input poChannels as JsonObject):
        Assert:NotNull(poChannels, 'Channels').
        
        return AddArrayFilter('channels',
                        poChannels,
                        PushNotificationFilterOperandEnum:Includes).
    end method.
    /** CHANNELS END **/
        
    /** General method to add string/character filters to the payload.
    
        Supported operands: Equals/NotEqual/Includes/NotIncludes            
        
        @param character  The name of the type of filter (type/deviceID/etc)
        @param character  The value to add
        @param PushNotificationFilterOperandEnum The operand (eq/ne/etc) 
        @return PushNotificationMessageBuilder This builder object */
    method public PushNotificationMessageBuilder AddStringFilter(input pcFilterName as character,
                                                                 input pcFilterValue as character,
                                                                 input poOperand as PushNotificationFilterOperandEnum):
        define variable oFilterParent as JsonObject no-undo.
        define variable oFilterObject as JsonObject no-undo.
        define variable oArrayValue as JsonArray no-undo.
        define variable lFieldExists as logical no-undo.
        
        Assert:NotNull(poOperand, 'Operand').
        Assert:NotNullOrEmpty(pcFilterName,  'Filter Name').
        Assert:NotNullOrEmpty(pcFilterValue, 'Filter Value').
        
        assign oFilterParent = GetObjectProperty(this-object:Payload, 'filter')
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
                    oFilterObject:Set(OperandValue[poOperand:Value], pcFilterValue).
                else
                    oFilterObject:Add(OperandValue[poOperand:Value], pcFilterValue).
            end.    /* notequal/includes/notincludes  */
            when PushNotificationFilterOperandEnum:Includes or
            when PushNotificationFilterOperandEnum:NotIncludes then
            do:
                assign oFilterObject = GetObjectProperty(oFilterParent, pcFilterName)
                       oArrayValue = GetArrayProperty(oFilterObject, OperandValue[poOperand:Value]).
                oArrayValue:Add(pcFilterValue).
            end.
            otherwise
                undo, throw new AppError(
                                substitute('&1 operand not supported for string filters',
                                    poOperand:Name), 0). 
        end case.   /* operand */
        
        return this-object.
    end method.
    
    /** General method to add array filters to the payload.
    
        Supported operands: Includes/NotIncludes/Matches            
        
        @param character      The name of the type of filter (type/deviceID/etc)
        @param JsonConstruct  The value to add. Could be Object (matches only) 
                              or array (Includes/NotIncludes)
        @param PushNotificationFilterOperandEnum The operand (eq/ne/etc) 
        @return PushNotificationMessageBuilder This builder object */
    method public PushNotificationMessageBuilder AddArrayFilter(input pcFilterName as character,
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
        ASsert:NotNullOrEmpty(pcFilterName, 'Filter Name').
        Assert:NotNull(poFilterValue, 'Filter Value').
        
        assign oFilterParent = GetObjectProperty(this-object:Payload, 'filter')
               lFieldExists  = ValidateOperand(oFilterParent, pcFilterName, poOperand).
        
        case poOperand:
            when PushNotificationFilterOperandEnum:Matches then
            do:
                Assert:IsType(poFilterValue, get-class(JsonObject)).
                assign oFilterObject = GetObjectProperty(oFilterParent, pcFilterName).
                if lFieldExists then
                    oFilterObject:Set(OperandValue[poOperand:Value], cast(poFilterValue, JsonObject)).
                else
                    oFilterObject:Add(OperandValue[poOperand:Value], cast(poFilterValue, JsonObject)).
            end.
            when PushNotificationFilterOperandEnum:Includes or
            when PushNotificationFilterOperandEnum:NotIncludes then
            do:
                Assert:IsType(poFilterValue, get-class(JsonArray)).
                assign oFilterObject = GetObjectProperty(oFilterParent, pcFilterName).
                if lFieldExists then
                    oFilterObject:Set(OperandValue[poOperand:Value], cast(poFilterValue, JsonArray)).
                else
                    oFilterObject:Add(OperandValue[poOperand:Value], cast(poFilterValue, JsonArray)).
            end.
            otherwise
                undo, throw new AppError(
                                substitute('&1 operand not supported for array filter',
                                    poOperand:Name), 0). 
        end case.   /* operand */
        
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
    method public PushNotificationMessageBuilder AddPointerFilter(input pcFilterName as character,
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
        ASsert:NotNullOrEmpty(pcFilterName, 'Filter Name').
        Assert:NotNull(poFilterValue, 'Filter Value').
        
        assign oFilterParent = GetObjectProperty(this-object:Payload, 'filter')
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
                    oFilterObject:Set(OperandValue[poOperand:Value], poFilterValue).
                else
                    oFilterObject:Add(OperandValue[poOperand:Value], poFilterValue).
            end.
            otherwise
                undo, throw new AppError(
                                substitute('&1 operand not supported for pointer filter',
                                    poOperand:Name), 0). 
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
    method public PushNotificationMessageBuilder AddGeoFilter(input pcFilterName as character,
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
        ASsert:NotNullOrEmpty(pcFilterName, 'Filter Name').
        Assert:NotNull(poFilterValue, 'Filter Value').
        
        assign oFilterParent = GetObjectProperty(this-object:Payload, 'filter')
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
                                    poOperand:Name), 0). 
        end case.   /* operand */
        
        /* if we got here, we passed all the validation */
        assign oFilterObject = GetObjectProperty(oFilterParent, pcFilterName).
        if lFieldExists then
            oFilterObject:Set(OperandValue[poOperand:Value], poFilterValue).
        else
            oFilterObject:Add(OperandValue[poOperand:Value], poFilterValue).
            
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
    method public PushNotificationMessageBuilder AddObjectFilter(input pcFilterName as character,
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
        ASsert:NotNullOrEmpty(pcFilterName, 'Filter Name').
        Assert:NotNull(poFilterValue, 'Filter Value').
        
        assign oFilterParent = GetObjectProperty(this-object:Payload, 'filter')
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
                    oFilterObject:Set(OperandValue[poOperand:Value], cast(poFilterValue, JsonObject)).
                else
                    oFilterObject:Add(OperandValue[poOperand:Value], cast(poFilterValue, JsonObject)).
            end.
            when PushNotificationFilterOperandEnum:Includes or
            when PushNotificationFilterOperandEnum:NotIncludes then
            do:
                Assert:IsType(poFilterValue, get-class(JsonArray)).
                assign oFilterObject = GetObjectProperty(oFilterParent, pcFilterName).
                if lFieldExists then
                    oFilterObject:Set(OperandValue[poOperand:Value], cast(poFilterValue, JsonArray)).
                else
                    oFilterObject:Add(OperandValue[poOperand:Value], cast(poFilterValue, JsonArray)).
            end.
            otherwise
                undo, throw new AppError(
                                substitute('&1 operand not supported for object filter',
                                    poOperand:Name), 0). 
        end case.   /* operand */
        
        return this-object. 
    end method.
    
    /** Returns an object for the property, even if another value was previously
        set.
        
        @param JsonObject  The parent
        @param character   The property name
        @return JsonObject The corresponding property's value (always JsonObject) */
    method private JsonObject GetObjectProperty(input poParent as JsonObject,
                                                input pcPropertyName as character):
        if not poParent:Has(pcPropertyName) then
            poParent:Add(pcPropertyName, new JsonObject()).
        else
        if poParent:GetType(pcPropertyName) ne JsonDataType:OBJECT then
            poParent:Set(pcPropertyName, new JsonObject()).
        
        return poParent:GetJsonObject(pcPropertyName).
    end method.

    /** Returns an Array for the property, even if another value was previously
        set.
        
        @param JsonObject  The parent
        @param character   The property name
        @return JsonArray The corresponding property's value (always JsonArray) */
    method private JsonArray GetArrayProperty(input poParent as JsonObject,
                                              input pcPropertyName as character):
        if not poParent:Has(pcPropertyName) then
            poParent:Add(pcPropertyName, new JsonArray()).
        else
        if poParent:GetType(pcPropertyName) ne JsonDataType:ARRAY then
            poParent:Set(pcPropertyName, new JsonArray()).
        
        return poParent:GetJsonArray(pcPropertyName).
    end method.

    /** A general method to add numeric(decimal) filter values to the notification
        query/filter. 
        
        Supported operands: eq/eq/gt/ge/lt/le/inc/ninc
        
        @param character The filter name
        @param decimal The filter value
        @param PushNotificationFilterOperandEnum The operand (eg Equals or NotEqual) 
        @return PushNotificationMessageBuilder This builder object */
    method public PushNotificationMessageBuilder AddNumericFilter(input pcFilterName as character,
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

        assign oFilterParent = GetObjectProperty(this-object:Payload, 'filter')
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
                    oFilterObject:Set(OperandValue[poOperand:Value], pdFilterValue).
                else
                    oFilterObject:Add(OperandValue[poOperand:Value], pdFilterValue).                
            end.    /* notequal/includes/notincludes  */
            when PushNotificationFilterOperandEnum:Includes or
            when PushNotificationFilterOperandEnum:NotIncludes then
            do:
                assign oFilterObject = GetObjectProperty(oFilterParent, pcFilterName)
                       oArrayValue = GetArrayProperty(oFilterObject, OperandValue[poOperand:Value]).
                oArrayValue:Add(pdFilterValue).
            end.
            otherwise
                undo, throw new AppError(
                                substitute('&1 operand not supported for numeric filters',
                                    poOperand:Name), 0). 
        end case.   /* operand */
        
        return this-object.
    end.
    
    /** A general method to add Date filter values to the notification
        query/filter. 
        
        Supported operands: eq/ne/gt/ge/lt/le/
        
        @param character The filter name
        @param datetime The filter value
        @param PushNotificationFilterOperandEnum The operand (eg Equals or NotEqual) 
        @return PushNotificationMessageBuilder This builder object */
    method public PushNotificationMessageBuilder AddDateFilter(input pcFilterName as character,
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

        assign oFilterParent = GetObjectProperty(this-object:Payload, 'filter')
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
                    oFilterObject:Set(OperandValue[poOperand:Value], cDateValue).
                else
                    oFilterObject:Add(OperandValue[poOperand:Value], cDateValue).                
            end.    /* notequal/includes/notincludes  */
            otherwise
                undo, throw new AppError(
                                substitute('&1 operand not supported for date filters',
                                    poOperand:Name), 0). 
        end case.   /* operand */
        
        return this-object.
    end.    
        
    /** A general method to add logical/boolean filter values to the notification
        query/filter. Only Equals and NotEqual supported
        
        @param character The filter name
        @param logical The filter value
        @param PushNotificationFilterOperandEnum The operand (eg Equals or NotEqual) 
        @return PushNotificationMessageBuilder This builder object */
    method public PushNotificationMessageBuilder AddLogicalFilter(input pcFilterName as character,
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

        assign oFilterParent = GetObjectProperty(this-object:Payload, 'filter')
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
                    oFilterObject:Set(OperandValue[poOperand:Value], plFilterValue).
                else
                    oFilterObject:Add(OperandValue[poOperand:Value], plFilterValue).                
            end.    /* notequal/includes/notincludes  */
            otherwise
                undo, throw new AppError(
                                substitute('&1 operand not supported for logical filters',
                                    poOperand:Name), 0). 
        end case.   /* operand */
        
        return this-object.
    end. 
    
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
                       cNames = OperandValue[PushNotificationFilterOperandEnum:Equals:Value].
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
            if cOperandName ne OperandValue[poOperand:Value] then
                undo, throw new AppError(
                                substitute('Filter field &1 value already has operand &2 set',
                                            pcFilterName,
                                            cOperandName
                                            ), 0).
        end.
        
        return lFieldExists.         
    end method.
        
end class.