/************************************************
Copyright (c)  2014, 2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : PushNotificationService
    Purpose     : Sends push notifications to a device or devices.
    Author(s)   : pjudge
    Created     : Mon Feb 10 16:41:36 EST 2014
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Mobile.PushNotificationMessageBuilder.
using OpenEdge.Mobile.PushNotificationService.
using OpenEdge.Mobile.ApperyPushNotificationService.
using OpenEdge.Mobile.TelerikPushNotificationService.
using OpenEdge.Mobile.PushNotificationMessageBuilder.
using OpenEdge.Mobile.ApperyPushNotificationMessageBuilder.
using OpenEdge.Mobile.TelerikPushNotificationMessageBuilder.
using OpenEdge.Net.HTTP.ClientBuilder.
using OpenEdge.Net.HTTP.IHttpClient.
using OpenEdge.Net.URI.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonObject.
using OpenEdge.Net.HTTP.BuilderRegistry.

class OpenEdge.Mobile.PushNotificationService abstract 
                implements ISupportInitialize:
    
    /** Registry for mapping build types to their implementations */
    define static public property Registry as BuilderRegistry no-undo
        get():
            define variable oRegistry as BuilderRegistry no-undo.
            if not valid-object(PushNotificationService:Registry) then
            do:
                assign oRegistry = new BuilderRegistry().
                PushNotificationService:InitializeRegistry(oRegistry).                
                assign PushNotificationService:Registry = oRegistry.
            end.
            return PushNotificationService:Registry.
        end get.
        private set.
    
    /** (mandatory) The API key for the push notification */
    define public property ApiKey as character no-undo get. private set.
    
    /** (mandatory) The host/URI of the notification service */
    define public property ServerUri as URI no-undo get. private set.
    
    /* The library doing the actual work */
    define protected property RestClient as IHttpClient no-undo get. private set.
    
    /** Adds initial values into the registry 
    
        @param BuilderRegistry The registry to populate */
    method static private void InitializeRegistry(input poRegistry as BuilderRegistry):
        /* Appery/Rollbase notification service is default in 11.5.1 */
        poRegistry:Put(get-class(PushNotificationService):TypeName,
                       get-class(ApperyPushNotificationService)).
        
        poRegistry:Put(get-class(PushNotificationMessageBuilder):TypeName,
                       get-class(ApperyPushNotificationMessageBuilder)).

        /* default notification service is Telerik in 11.6.0.  
           
           To use Telerik PNS, add these lines before you call the 
           PushNotificationService or ~MessageBuilder. They can be added anywhere in the
           application code (on startup, say), not just in the PNS calling code.
           
           PushNotificationService:Registry:Put(get-class(PushNotificationService):TypeName,
                                                get-class(TelerikPushNotificationService)).

           PushNotificationService:Registry:Put(get-class(PushNotificationMessageBuilder):TypeName,
                                                get-class(TelerikPushNotificationMessageBuilder)). 
        */
    end method.

    /** Constructor.
        
        @param URI A URI representing the notification server
        @param character The (mandatory) API key to enable notifications */
    constructor public PushNotificationService(input poURI as URI,
                                               input pcApiKey as character):
        Assert:NotNullOrEmpty(pcApiKey, 'API Key').
        Assert:NotNull(poURI, 'Server URI').
        
        assign this-object:ApiKey = pcApiKey
               this-object:ServerUri = poURI.
    end constructor.
    
    destructor PushNotificationService():
        Destroy().
    end destructor.
    
    /** Factory method for retrieving an instance of the server.
    
        @param URI A URI representing the notification server
        @param character The (mandatory) API key to enable notifications */
    method static public PushNotificationService Instance(input poURI as URI, 
                                                          input pcApiKey as character):
        define variable oNotificationSvc as PushNotificationService no-undo.
        define variable oPNSType as Progress.Lang.Class no-undo.

        assign oPNSType = PushNotificationService:Registry:Get(get-class(PushNotificationService):TypeName).
        Assert:IsType(oPNSType, get-class(PushNotificationService)).
        
        /* Issue PSC00326382 means that we must use dynamic-new instead of New() */
        if valid-object(poURI) then
            oNotificationSvc = dynamic-new string(oPNSType:TypeName) (poUri, pcApiKey).        
        else
            oNotificationSvc = dynamic-new string(oPNSType:TypeName) (pcApiKey).
            
        if type-of(oNotificationSvc, ISupportInitialize) then
            cast(oNotificationSvc, ISupportInitialize):Initialize().
        
        return oNotificationSvc.
    end method.
    
    /** Factory method for retrieving an instance of the server.
    
        @param character The (mandatory) API key to enable notifications */
    method static public PushNotificationService Instance(input pcApiKey as character):
        return PushNotificationService:Instance(?, pcApiKey).
    end method.
    
    /* Initializer/Startup */
    method public void Initialize():
        /* stateless/non-cookie client */
        assign this-object:RestClient = ClientBuilder:Build():Client.
    end method.
    
    /* Destroy/Shutdown/Anti-Initializer */
    method public void Destroy():
        assign this-object:RestClient = ?.
    end method.
    
    /** Sends an immediate notification. Defaults to a no-filter query.
        
        @param character The message to be sent.
        @param integer   The badge counter (only used for iOS). */
    method public void SendNotification(input pcMessage as character,
                                        input piBadge as integer):
        define variable oPayload as JsonObject no-undo.
        
        assign oPayload = PushNotificationMessageBuilder
                            :Send(pcMessage, piBadge)
                            :Payload.
        
        SendNotification(oPayload).
    end method.
    
    /** Sends an immediate notification. Defaults to a no-filter query.
        
        @param character   The message to be sent.
        @param integer     The badge counter (only used for iOS).
        @param datetime-tz The time at which to send the notification
        @param logical     Whether the notification should be sent at that time
                           in a particular timezone, or at that time in the 
                           device's timezone. */
    method public void ScheduleNotification(input pcMessage as character,
                                            input piBadge as integer,
                                            input ptSendAt as datetime-tz,
                                            input plUseDeviceTimeZone as logical):
        define variable oPayload as JsonObject no-undo.
        
        assign oPayload = PushNotificationMessageBuilder
                                :Schedule(pcMessage, piBadge)
                                :At(ptSendAt)
                                :UseDeviceTimeZone(plUseDeviceTimeZone)
                                :Payload.
        
        SendNotification(oPayload).
    end method.
    
    /** Sends a notification for a given payload. The payload may be built by one
        of the methods in this class, or created by the PushNotificationMessageBuilder
        class (which is also used internally).
        
        This method performs the actual request to the Notification Service.
        
        @param JsonObject The notification payload. 
        @return JsonConstruct The result of the request. Can be an object or array,
                              depending on success or failure. */        
    method abstract public JsonConstruct SendNotification(input poPayload as JsonObject).
    
end class.