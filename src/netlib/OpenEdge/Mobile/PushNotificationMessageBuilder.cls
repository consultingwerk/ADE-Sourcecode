/************************************************
Copyright (c)  2014, 2015, 2018 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : PushNotificationMessageBuilder
    Purpose     : Helper class to build a notification message easily 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Jun 13 13:11:41 EDT 2014
    Notes       : * Supported filter types:
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
using OpenEdge.Core.DateTimeAddIntervalEnum.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.ISupportLogging.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Mobile.ApplicationPlatformEnum.
using OpenEdge.Mobile.PushNotificationFilterOperandEnum.
using OpenEdge.Mobile.PushNotificationMessageBuilder.
using OpenEdge.Mobile.PushNotificationService.
using OpenEdge.Net.HTTP.ConfigBuilder.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.

class OpenEdge.Mobile.PushNotificationMessageBuilder abstract inherits ConfigBuilder
        implements ISupportLogging:
    
    define public property Logger as ILogWriter no-undo
        get():
            if not valid-object(this-object:Logger) then
                return LoggerBuilder:GetLogger(this-object:GetClass()).
            
            return this-object:Logger.
        end get.
        set.
    
    /* List of operands that the message need. A property to keep it read-only.
       The index of this array matches the Value of the 
       PushNotificationFilterOperandEnum property in question. */
    define protected property OperandValue as character extent 18
        initial ['$eq':u, '$ne':u, '$in':u,
                 '$nin':u, '$elemMatch':u, '$gt':u, '$gte':u, '$lt':u, '$lte':u, 
                 '$near':u, '$nearSphere':u, '$geoWithin':u, '$geoIntersects':u,
                 '$all':u, 
                 '$and':u, '$or':u, '$not':u, '$nor':u]
        no-undo get.
    
    /** Returns the newly-constructed payload. */
    define abstract public property Payload as JsonObject no-undo get.
    
    /* Some operations ignored if this is a send-immediate */
    define public property SendImmediate as logical no-undo get. protected set.
    
    /** Factory method for retrieving an instance of the server.
        
        @param URI A URI representing the notification server
        @param character The (mandatory) API key to enable notifications */
    method static public PushNotificationMessageBuilder Build():
        define variable oMessageBuilder as PushNotificationMessageBuilder no-undo.
        define variable oPNMBType as Progress.Lang.Class no-undo.

        assign oPNMBType = PushNotificationService:Registry
                                :Get(get-class(PushNotificationMessageBuilder):TypeName).
        Assert:IsType(oPNMBType, get-class(PushNotificationMessageBuilder)).
        
        /* Issue PSC00326382 means that we must use dynamic-new instead of New() */
        oMessageBuilder = dynamic-new string(oPNMBType:TypeName) ().        
        
        if type-of(oMessageBuilder, ISupportInitialize) then
            cast(oMessageBuilder, ISupportInitialize):Initialize().
        
        return oMessageBuilder.
    end method.
        
    /** Constructor.  */
    constructor protected PushNotificationMessageBuilder():
        /* default join operand */
        MatchAll().
    end constructor.
    
    /** Factory for this builder, for messages to send immediately.
    
        @param character The message text to be sent.
        @param integer   The badge counter (only used for iOS). 
        @return PushNotificationMessageBuilder  The new builder */
    method static public PushNotificationMessageBuilder Send(input pcMessage as character,
                                                             input piBadge as integer):
        return PushNotificationMessageBuilder:Build()
                    :Message(pcMessage)
                    :Badges(piBadge)
                    :SendNow(true).
    end method.

    /** Factory for this builder, for messages to schedule for future sending
        
        @param character The message text to be sent.
        @param integer   The badge counter (only used for iOS). 
        @return PushNotificationMessageBuilder  The new builder */
    method static public PushNotificationMessageBuilder Schedule(input pcMessage as character,
                                                                 input piBadge as integer):
        return PushNotificationMessageBuilder:Build()
                    :Message(pcMessage)
                    :Badges(piBadge)
                    :SendNow(false).
    end method.
    
    /** Sets the time at which to schedule the notification. No-op if this is a 
        send-immediate message.
    
        @param datetime-tz A time in the future (at least the following minute)
                           at which to send the notification.
        @return PushNotificationMessageBuilder  This builder */
    method public PushNotificationMessageBuilder At(input ptSendAt as datetime-tz):
        Assert:IsPositive(interval(ptSendAt, now, string(DateTimeAddIntervalEnum:Seconds)), 'Send at delta').

        SendNow(false).
        SetOption('schedule.time':u, ptSendAt).
        
        return this-object.
    end method.
    
    /** Sets the time at which to scheduled notification expire. No-op if this is a 
        send-immediate message.
    
        @param datetime-tz A time in the future (at least the following minute)
                           at which to expire the notification.
        @return PushNotificationMessageBuilder  This builder */
    method public PushNotificationMessageBuilder ExpiresAt(input ptExpireAt as datetime-tz):
        Assert:IsPositive(interval(ptExpireAt, now, string(DateTimeAddIntervalEnum:Seconds)), 'Expire at delta').
        
        SetOption('schedule.expiration':u, ptExpireAt).
        
        return this-object.
    end method.
    
    method public PushNotificationMessageBuilder Message(input pcMessage as character):
        Assert:NotNullOrEmpty(pcMessage, 'message text').
        
        SetOption('message.text':u, pcMessage).
        
        return this-object.
    end method.
    
    method public PushNotificationMessageBuilder SendNow(input plSendNow as logical):
        Assert:NotUnknown(plSendNow, 'send now').
        
        assign this-object:SendImmediate = plSendNow.
        
        return this-object.
    end method.
    
    method public PushNotificationMessageBuilder Badges(input piBadgeCount as integer):
        Assert:NotNull(piBadgeCount, 'badge count').
        SetOption('message.count':u, piBadgeCount).
        
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
        Assert:NotUnknown(plUseDeviceTimeZone, 'use device time zone').
        
        SetOption('schedule.useDeviceTimeZone':u, plUseDeviceTimeZone).
        
        return this-object.
    end method.
    
    /** PLATFORM START **/
    /** Includes the given platform
    
        @param ApplicationPlatformEnum The mobile platform to include
        @return PushNotificationMessageBuilder  The current builder */
    method public PushNotificationMessageBuilder IncludePlatform(input poPlatform as ApplicationPlatformEnum):
        Assert:NotNull(poPlatform, 'Platform').

        AppendArrayCharacterValue(
            'platform.':u + string(PushNotificationFilterOperandEnum:Includes),
            string(poPlatform)).

        return this-object.
    end method.

    /** Exclude only the specified platform from the notification.
    
        @param ApplicationPlatformEnum The mobile platform to include
        @return PushNotificationMessageBuilder  The current builder */
    method public PushNotificationMessageBuilder NotOnPlatform(input poPlatform as ApplicationPlatformEnum):
        Assert:NotNull(poPlatform, 'Platform').
        
        AppendArrayCharacterValue(
            'platform.':u + string(PushNotificationFilterOperandEnum:NotEqual),
            string(poPlatform)).

        return this-object.
    end method.
    
    /** Excludes the given platform (can be multiple)
        
        @param ApplicationPlatformEnum The mobile platform to include
        @return PushNotificationMessageBuilder  The current builder */
    method public PushNotificationMessageBuilder ExcludePlatform(input poPlatform as ApplicationPlatformEnum):
        Assert:NotNull(poPlatform, 'Platform').
        
        AppendArrayCharacterValue(
            'platform.':u + string(PushNotificationFilterOperandEnum:NotIncludes),
            string(poPlatform)).

        return this-object.
    end method.
    
    /** Send the notification to only this platform.
        
        @param ApplicationPlatformEnum The mobile platform to include
        @return PushNotificationMessageBuilder  The current builder */
    method public PushNotificationMessageBuilder OnPlatform(input poPlatform as ApplicationPlatformEnum):
        Assert:NotNull(poPlatform, 'Platform').
        
        AppendArrayCharacterValue(
            'platform.':u + string(PushNotificationFilterOperandEnum:Equals),
            string(poPlatform)).

        return this-object.
    end method.
    /** PLATFORM END **/
    
    /** DEVICE START **/
    /** Push notification for the given device id only.
    
        @param character A device ID  
        @return PushNotificationMessageBuilder This builder object */
    method public PushNotificationMessageBuilder OnDevice(input pcDeviceId as character):
        Assert:NotNullOrEmpty(pcDeviceId, 'Device ID').
        
        AppendArrayCharacterValue(
            'device.id.':u + string(PushNotificationFilterOperandEnum:Equals),
            pcDeviceId).
        
        return this-object.
    end method.

    /** Push notification for all devices except for the given device id
    
        @param character A device ID  
        @return PushNotificationMessageBuilder This builder object */
    method public PushNotificationMessageBuilder NotOnDevice(input pcDeviceId as character):
        Assert:NotNullOrEmpty(pcDeviceId, 'Device ID').
        
        AppendArrayCharacterValue(
            'device.id.':u + string(PushNotificationFilterOperandEnum:NotEqual),
            pcDeviceId).
        
        return this-object.
    end method.
    
    /** Include the device in the Push notification filter .
    
        @param character A device ID  
        @return PushNotificationMessageBuilder This builder object */
    method public PushNotificationMessageBuilder IncludeDevice(input pcDeviceId as character):
        Assert:NotNullOrEmpty(pcDeviceId, 'Device ID').
        
        AppendArrayCharacterValue(
            'device.id.':u + string(PushNotificationFilterOperandEnum:Includes),
            pcDeviceId).
                         
        return this-object.
    end method.
    
    /** Exclude the device from the Push notification filter .
    
        @param character A device ID  
        @return PushNotificationMessageBuilder This builder object */
    method public PushNotificationMessageBuilder ExcludeDevice(input pcDeviceId as character):
        Assert:NotNullOrEmpty(pcDeviceId, 'Device ID').
        
        AppendArrayCharacterValue(
            'device.id.':u + string(PushNotificationFilterOperandEnum:NotIncludes),
            pcDeviceId).

        return this-object.
    end method.
    /** DEVICE END **/
    
    /** CHANNELS START **/
    /** Includes the array of named channels.
    
        @param JsonArray An array of channels.  
        @return PushNotificationMessageBuilder This builder object */
    method public PushNotificationMessageBuilder IncludeChannels(input poChannels as JsonArray):
        Assert:NotNull(poChannels, 'Channels').
        
        SetOption('channels.':u + string(PushNotificationFilterOperandEnum:Includes), poChannels).
        
        return this-object.
    end method.
    
    /** Excludes the array of named channels.
    
        @param JsonArray An array of channels.  
        @return PushNotificationMessageBuilder This builder object */
    method public PushNotificationMessageBuilder ExcludeChannels(input poChannels as JsonArray):
        Assert:NotNull(poChannels, 'Channels').
        
        SetOption('channels.':u + string(PushNotificationFilterOperandEnum:NotIncludes), poChannels).
        return this-object.
    end method.
    
    /** Filter for matching the array of named channels.
    
        @param JsonArray An array of channels.  
        @return PushNotificationMessageBuilder This builder object */
    method public PushNotificationMessageBuilder MatchChannels(input poChannels as JsonArray):
        Assert:NotNull(poChannels, 'Channels').
        
        SetOption('channels.':u + string(PushNotificationFilterOperandEnum:Matches), poChannels).
        return this-object.
    end method.
    /** CHANNELS END **/
    
    /* Sets the title of the notification message
       
       @param character The non-null title 
       @return PushNotificationMessageBuilder This builder object */
    method public PushNotificationMessageBuilder Titled(input pcTitle as character):
        Assert:NotNull(pcTitle, 'Notification title').
        
        SetOption('message.title':u, pcTitle).
        
        return this-object.
    end method.
    
    /* Sets the filter match operand to "All". 
       
       @return PushNotificationMessageBuilder This builder object */
    method public PushNotificationMessageBuilder MatchAll():
        SetOption('match.operand':u, PushNotificationFilterOperandEnum:And).
        return this-object.
    end method.
    
    /* Sets the filter match operand to "Any". 
       
       @return PushNotificationMessageBuilder This builder object */
    method public PushNotificationMessageBuilder MatchAny():
        SetOption('match.operand':u, PushNotificationFilterOperandEnum:Or).
        return this-object.
    end method.
    
    /** General method to add string/character filters to the payload.
    
        Supported operands: Equals/NotEqual/Includes/NotIncludes            
        
        @param character  The name of the type of filter (type/deviceID/etc)
        @param character  The value to add
        @param PushNotificationFilterOperandEnum The operand (eq/ne/etc) 
        @return PushNotificationMessageBuilder This builder object */
    method public PushNotificationMessageBuilder AddStringFilter(input pcFilterName as character,
                                                                 input pcFilterValue as character,
                                                                 input poOperand as PushNotificationFilterOperandEnum).
        Logger:Warn(substitute('AddStringFilter: Filter is not supported in &1', this-object:GetClass():TypeName)).
        return this-object.
    end method.
    
    /** General method to add array filters to the payload.
    
        Supported operands: Includes/NotIncludes/Matches            
        
        @param character      The name of the type of filter (type/deviceID/etc)
        @param JsonConstruct  The value to add. Could be Object (matches only) 
                              or array (Includes/NotIncludes)
        @param PushNotificationFilterOperandEnum The operand (eq/ne/etc) 
        @return PushNotificationMessageBuilder This builder object */
    method  public PushNotificationMessageBuilder AddArrayFilter(input pcFilterName as character,
                                                                 input poFilterValue as JsonConstruct,
                                                                 input poOperand as PushNotificationFilterOperandEnum).
        Logger:Warn(substitute('AddArrayFilter: Filter is Not supported in &1', this-object:GetClass():TypeName)).
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
                                                                  input poOperand as PushNotificationFilterOperandEnum).
        Logger:Warn(substitute('AddPointerFilter: Filter is Not supported in &1', this-object:GetClass():TypeName)).
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
                                                              input poOperand as PushNotificationFilterOperandEnum).    
        Logger:Warn(substitute('AddGeoFilter: Filter is Not supported in &1', this-object:GetClass():TypeName)).
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
                                                                 input poOperand as PushNotificationFilterOperandEnum).
        Logger:Warn(substitute('AddObjectFilter: Filter is Not supported in &1', this-object:GetClass():TypeName)).
        return this-object.
    end method.
    
    /** Returns an object for the property, even if another value was previously
        set.
        
        @param JsonObject  The parent
        @param character   The property name
        @return JsonObject The corresponding property's value (always JsonObject) */
    method protected JsonObject GetObjectProperty(input poParent as JsonObject,
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
    method protected JsonArray GetArrayProperty(input poParent as JsonObject,
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
                                                                  input poOperand as PushNotificationFilterOperandEnum).
        Logger:Warn(substitute('AddNumericFilter: Filter is Not supported in &1', this-object:GetClass():TypeName)).
        return this-object.
    end method.
    
    /** A general method to add Date filter values to the notification
        query/filter. 
        
        Supported operands: eq/ne/gt/ge/lt/le/
        
        @param character The filter name
        @param datetime The filter value
        @param PushNotificationFilterOperandEnum The operand (eg Equals or NotEqual) 
        @return PushNotificationMessageBuilder This builder object */
    method public PushNotificationMessageBuilder AddDateFilter(input pcFilterName as character,
                                                               input ptFilterValue as datetime,
                                                               input poOperand as PushNotificationFilterOperandEnum).
        Logger:Warn(substitute('AddDateFilter: Filter is Not supported in &1', this-object:GetClass():TypeName)).
        return this-object.
    end method.
    
    /** A general method to add logical/boolean filter values to the notification
        query/filter. Only Equals and NotEqual supported
        
        @param character The filter name
        @param logical The filter value
        @param PushNotificationFilterOperandEnum The operand (eg Equals or NotEqual) 
        @return PushNotificationMessageBuilder This builder object */
    method public PushNotificationMessageBuilder AddLogicalFilter(input pcFilterName as character,
                                                                  input plFilterValue as logical,
                                                                  input poOperand as PushNotificationFilterOperandEnum).
        Logger:Warn(substitute('AddLogicalFilter: Filter is Not supported in &1', this-object:GetClass():TypeName)).
        return this-object.
    end method. 
    
end class.