/************************************************
Copyright (c) 2018 by Progress Software Corporation. All rights reserved.
*************************************************/ 
 /*------------------------------------------------------------------------
    File        : KinveyPushNotificationMessageBuilder
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : htirunag
    Created     : Fri May 25 15:14:18 IST 2018
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Mobile.ApplicationPlatformEnum.
using OpenEdge.Mobile.PushNotificationFilterOperandEnum.
using OpenEdge.Mobile.PushNotificationMessageBuilder.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonObject.

class OpenEdge.Mobile.KinveyPushNotificationMessageBuilder inherits PushNotificationMessageBuilder:
    
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
        define variable oParent as JsonObject no-undo.
        define variable oChild as JsonConstruct no-undo.
        define variable cPlatforms as character no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable oPayload as JsonObject no-undo.
        define variable chrPos as integer no-undo.
        define variable notificationJson as JsonObject no-undo.
        define variable appKeyData  as JsonObject no-undo.
        define variable oPlatform as JsonObject no-undo.
                
        assign oPayload = new JsonObject().
        
        // Build app KVP
        assign appKeyData = new JsonObject()
               chrPos     = 0
               .
        for each ConfigOption where
                 ConfigOption.ParentBuilder eq integer(this-object) and
                 ConfigOption.ConfigName    begins 'data-key+':u
                 :
            assign chrPos = index(ConfigOption.ConfigName, '+':u).
            appKeyData:add(substring(ConfigOption.ConfigName, chrPos + 1), ConfigOption.StringValue).
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
            
            cast(oParent, JsonObject):Add('body':u, GetOptionStringValue('message.text':u)).
            
            if HasOption('message.title':u) then
                cast(oParent, JsonObject):Add('title':u, GetOptionStringValue('message.title':u)).
                
            oPlatform:Add('notification':u, cast(oParent, JsonObject)).
            oPlatform:Add('data':u, appKeyData).
            oPayload:Add('Android':u, oPlatform).
        end.
        
        if can-do(cPlatforms, string(ApplicationPlatformEnum:IOS)) then
        do:
            assign oPlatform = new JsonObject()
                   oParent = new JsonObject()
                   notificationJson = new JsonObject().
            
            cast(oParent, JsonObject):Add('alert':u, notificationJson). 
            
            notificationJson:Add('body', GetOptionStringValue('message.text':u)).
            notificationJson:Add('title', GetOptionStringValue('message.title':u)).
            
            if HasOption('message.count':u) then
                cast(oParent, JsonObject):Add('badge':u, string(GetOptionNumericValue('message.count':u))).
            else
                cast(oParent, JsonObject):Add('badge':u, '+1').
            
            cast(oParent, JsonObject):Add('category':u, GetOptionStringValue('category':u)).
            
            oPlatform:Add('aps':u, cast(oParent, JsonObject)).
            oPlatform:Add('data':u, appKeyData).
            oPayload:Add('IOS':u, oPlatform).
        end.        
        return oPayload.
    end method.
    
    /** UNSUPPORTED OPERATION
        
        Sets the time at which to schedule the notification. No-op if this is a 
        send-immediate message.
    
        @param datetime-tz A time in the future (at least the following minute)
                           at which to send the notification.
        @return PushNotificationMessageBuilder  This builder */
    method public override PushNotificationMessageBuilder At(input ptSendAt as datetime-tz):
        Logger:Warn(substitute('At: Not supported in &1', this-object:GetClass():TypeName)).
        return this-object.
    end method.

    /** UNSUPPORTED OPERATION
        
        Sets the time at which to scheduled notification expire. No-op if this is a 
        send-immediate message.
    
        @param datetime-tz A time in the future (at least the following minute)
                           at which to expire the notification.
        @return PushNotificationMessageBuilder  This builder */
    method public override PushNotificationMessageBuilder ExpiresAt(input ptExpireAt as datetime-tz):
        Logger:Warn(substitute('ExpiresAt: Not supported in &1', this-object:GetClass():TypeName)).
        return this-object.
    end method.
    
    /** UNSUPPORTED OPERATION
    
        Tells the notification to use the device's timezone (not the timezone
        of the scheduled time). No-op for a send-immediate message.
    
        @return PushNotificationMessageBuilder  This builder */
    method public override PushNotificationMessageBuilder UseDeviceTimeZone():
        Logger:Warn(substitute('UseDeviceTimeZone: Not supported in &1', this-object:GetClass():TypeName)).
        return this-object.
    end method.
    
    /** UNSUPPORTED OPERATION
    
        Tells the notification to use the device's timezone (not the timezone
        of the scheduled time). No-op for a send-immediate message.
    
        @param logical TRUE if we are to use the device time zone.
        @return PushNotificationMessageBuilder  The current builder */
    method public override PushNotificationMessageBuilder UseDeviceTimeZone(input plUseDeviceTimeZone as logical):
        Logger:Warn(substitute('UseDeviceTimeZone: Not supported in &1', this-object:GetClass():TypeName)).
        return this-object.
    end method.

    /** PLATFORM START **/
    /** UNSUPPORTED OPERATION
    
        Includes the given platform
    
        @param ApplicationPlatformEnum The mobile platform to include
        @return PushNotificationMessageBuilder  The current builder */
    method public override PushNotificationMessageBuilder IncludePlatform(input poPlatform as ApplicationPlatformEnum):
        Logger:Warn(substitute('IncludePlatform: Not supported in &1', this-object:GetClass():TypeName)).
        return this-object.
    end method.

    /** UNSUPPORTED OPERATION
    
        Exclude only the specified platform from the notification.
    
        @param ApplicationPlatformEnum The mobile platform to include
        @return PushNotificationMessageBuilder  The current builder */
    method public override PushNotificationMessageBuilder NotOnPlatform(input poPlatform as ApplicationPlatformEnum):
        Logger:Warn(substitute('NotOnPlatform: Not supported in &1', this-object:GetClass():TypeName)).
        return this-object.
    end method.
    
    /** UNSUPPORTED OPERATION
        
        Excludes the given platform (can be multiple)
        
        @param ApplicationPlatformEnum The mobile platform to include
        @return PushNotificationMessageBuilder  The current builder */
    method public override PushNotificationMessageBuilder ExcludePlatform(input poPlatform as ApplicationPlatformEnum):
        Logger:Warn(substitute('ExcludePlatform: Not supported in &1', this-object:GetClass():TypeName)).
        return this-object.
    end method.

    /** UNSUPPORTED OPERATION
    
        Send the notification to only this platform.
        
        @param ApplicationPlatformEnum The mobile platform to include
        @return PushNotificationMessageBuilder  The current builder */
    method public override PushNotificationMessageBuilder OnPlatform(input poPlatform as ApplicationPlatformEnum):
        Logger:Warn(substitute('OnPlatform: Not supported in &1', this-object:GetClass():TypeName)).
        return this-object.
    end method.
    /** PLATFORM END **/
    
    /** DEVICE START **/
    /** UNSUPPORTED OPERATION
        
        Push notification for the given device id only.
    
        @param character A device ID  
        @return PushNotificationMessageBuilder This builder object */
    method public override PushNotificationMessageBuilder OnDevice(input pcDeviceId as character):
        Logger:Warn(substitute('OnDevice: Not supported in &1', this-object:GetClass():TypeName)).
        return this-object.
    end method.

    /** UNSUPPORTED OPERATION
    
        Push notification for all devices except for the given device id
    
        @param character A device ID  
        @return PushNotificationMessageBuilder This builder object */
    method public override PushNotificationMessageBuilder NotOnDevice(input pcDeviceId as character):
        Logger:Warn(substitute('NotOnDevice: Not supported in &1', this-object:GetClass():TypeName)).
        return this-object.
    end method.
    
    /** UNSUPPORTED OPERATION
    
        Include the device in the Push notification filter .
    
        @param character A device ID  
        @return PushNotificationMessageBuilder This builder object */
    method public override PushNotificationMessageBuilder IncludeDevice(input pcDeviceId as character):
        Logger:Warn(substitute('IncludeDevice: Not supported in &1', this-object:GetClass():TypeName)).
        return this-object.
    end method.
    
    /** UNSUPPORTED OPERATION
    
        Exclude the device from the Push notification filter .
    
        @param character A device ID  
        @return PushNotificationMessageBuilder This builder object */
    method public override PushNotificationMessageBuilder ExcludeDevice(input pcDeviceId as character):
        Logger:Warn(substitute('ExcludeDevice: Not supported in &1', this-object:GetClass():TypeName)).
        return this-object.
    end method.
    /** DEVICE END **/

    /** CHANNELS START **/
    /** UNSUPPORTED OPERATION
        
        Includes the array of named channels.
    
        @param JsonArray An array of channels.  
        @return PushNotificationMessageBuilder This builder object */
    method public override PushNotificationMessageBuilder IncludeChannels(input poChannels as JsonArray):
        Logger:Warn(substitute('IncludeChannels: Not supported in &1', this-object:GetClass():TypeName)).
        return this-object.
    end method.
    
    /** UNSUPPORTED OPERATION
        
        Excludes the array of named channels.
    
        @param JsonArray An array of channels.  
        @return PushNotificationMessageBuilder This builder object */
    method public override PushNotificationMessageBuilder ExcludeChannels(input poChannels as JsonArray):
        Logger:Warn(substitute('ExcludeChannels: Not supported in &1', this-object:GetClass():TypeName)).
        return this-object.
    end method.
    
    /** UNSUPPORTED OPERATION
    
        Filter for matching the array of named channels.
    
        @param JsonArray An array of channels.  
        @return PushNotificationMessageBuilder This builder object */
    method public override PushNotificationMessageBuilder MatchChannels(input poChannels as JsonArray):
        Logger:Warn(substitute('MatchChannels: Not supported in &1', this-object:GetClass():TypeName)).
        return this-object.
    end method.
    /** CHANNELS END **/
    
    /*  UNSUPPORTED OPERATION
        
        Sets the title of the notification message
       
        @param character The non-null title 
        @return PushNotificationMessageBuilder This builder object */
    method public override PushNotificationMessageBuilder Titled(input pcTitle as character):
        Logger:Warn(substitute('MatchChannels: Not supported in &1', this-object:GetClass():TypeName)).
        return this-object.
    end method.
    
    /*  UNSUPPORTED OPERATION
    
        Sets the filter match operand to "Any". 
       
        @return PushNotificationMessageBuilder This builder object */
    method public override PushNotificationMessageBuilder MatchAny():
        Logger:Warn(substitute('MatchAny: Not supported in &1', this-object:GetClass():TypeName)).
        return this-object.
    end method.
    
end class.