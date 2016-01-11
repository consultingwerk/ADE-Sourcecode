/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : TelerikPushNotificationAdmin
    Purpose     : Adminstrative service for Telerik Push services
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Apr 07 13:49:22 EDT 2015
    Notes       : * this class must be manually instantiated; it is not registered
                    in the PushNotificationService:Registry 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Mobile.TelerikPushNotificationService.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.HttpHeaderBuilder.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.RequestBuilder.
using OpenEdge.Net.URI.
using Progress.Json.ObjectModel.JsonObject.

class OpenEdge.Mobile.TelerikPushNotificationAdmin inherits TelerikPushNotificationService:
    
    /** (mandatory) The API key for the push notification */
    define public property MasterKey as character no-undo get. private set.
    
    define private variable moAuthHeader as HttpHeader no-undo.
    define private variable moFilterHeader as HttpHeader no-undo.

    /** Constructor.
        
        @param character The (mandatory) API key to enable notifications
        @param character The (mandatory) API master key to edit/manage notifications  */
    constructor public TelerikPushNotificationAdmin(input pcApiKey as character,
                                                    input pcMasterKey as character):
        /* default to live Telerik servers */
        this-object(URI:Parse('http://api.everlive.com/v1/':u),
                    pcApiKey,
                    pcMasterKey).
    end constructor.
    
    /** Constructor.
        
        @param URI A URI representing the notification server
        @param character The (mandatory) API key to use the notification service 
        @param character The (mandatory) API master key to edit/manage notifications */
    constructor public TelerikPushNotificationAdmin(input poURI as URI,
                                                    input pcApiKey as character,
                                                    input pcMasterKey as character):
        super(poUri,pcApiKey). 
        Assert:NotNullOrEmpty(pcMasterKey, 'Master key').
        
        assign this-object:MasterKey = pcMasterKey.
    end constructor.
    
    /* Initializer/Startup */
	method override public void Initialize(  ):
		super:Initialize().
		
        /* Create the header objects just once */
        assign moAuthHeader = HttpHeaderBuilder:Build('Authorization':u)
                                    /* make sure there's a space in the value */
                                    :Value('Masterkey ':u + this-object:MasterKey)
                                    :Header
	           moFilterHeader = HttpHeaderBuilder:Build('X-Everlive-Filter':u):Header.
	end method.
	
    /** Returns all notifications for a user's master key
        
        @return JsonObject The notifications returned. Errors are raised otherwise */
    method public JsonObject GetNotifications():
        return GetNotifications(new JsonObject()).
    end method.
    
    /** Returns all notifications for a user's master key per the provided 
        filter
        
        @param JsonObject JSON representation of a filter
        @return JsonObject The notifications returned. Errors are raised otherwise */
    method public JsonObject GetNotifications(input poFilter as JsonObject):
        define variable oRequest  as IHttpRequest no-undo.
        define variable oResponse as IHttpResponse no-undo.
        
        Assert:NotNull(poFilter, 'Filter').
        
        assign moFilterHeader:Value = string(poFilter:GetJsonText()) 
               oRequest = RequestBuilder:Get(substitute('&1/&2/Push/Notifications':u,
                                                /* make sure we're not adding 2 slashes here */
                                                right-trim(ServerUri:ToString(), '/':u),
                                                this-object:ApiKey))
                                :AddHeader(moAuthHeader)
                                :AddHeader(moFilterHeader)
                                :AcceptJson()
                                :Request
               oResponse = this-object:RestClient:Execute(oRequest).        
        ProcessResponse(oResponse).
        
        return cast(oResponse:Entity, JsonObject).
    end method.
    
    /** Deletes a notification from the server
        
        @param character The id of the notification to delete */
    method public void DeleteNotification(input pcNotificationId as character):
        define variable oRequest  as IHttpRequest no-undo.
        define variable oResponse as IHttpResponse no-undo.
        
        Assert:NotNullOrEmpty(pcNotificationId, 'Notification id').
        
        assign oRequest = RequestBuilder:Delete(substitute('&1/&2/Push/Notifications/&3':u,
                                                /* make sure we're not adding 2 slashes here */
                                                right-trim(ServerUri:ToString(), '/':u),
                                                this-object:ApiKey,
                                                pcNotificationId))
                                :AddHeader(moAuthHeader)
                                :Request
               oResponse = this-object:RestClient:Execute(oRequest).        
        ProcessResponse(oResponse).
    end method.


    /** Updates a notification on the server
        
        @param character The id of the notification to update
        @param JsonObject A new set of properties to apply to the notification.
                          The structure of these notification messages is at
                    http://docs.telerik.com/platform/backend-services/features/push-notifications/structure */
    method public void UpdateNotification(input pcNotificationId as character,
                                          input poUpdateValue as JsonObject):
        define variable oRequest  as IHttpRequest no-undo.
        define variable oResponse as IHttpResponse no-undo.
        
        Assert:NotNullOrEmpty(pcNotificationId, 'Notification id').
        Assert:NotNull(poUpdateValue, 'Update values').
        
        assign oRequest = RequestBuilder:Put(substitute('&1/&2/Push/Notifications/&3':u,
                                                /* make sure we're not adding 2 slashes here */
                                                right-trim(ServerUri:ToString(), '/':u),
                                                this-object:ApiKey,
                                                pcNotificationId),
                                              poUpdateValue)
                                :AddHeader(moAuthHeader)
                                :Request
               oResponse = this-object:RestClient:Execute(oRequest).        
        ProcessResponse(oResponse).
    end method.
    
    /** Returns all devices for a user's master key per the provided 
        filter
        
        @return JsonObject The notifications returned. Errors are raised otherwise */
    method public JsonObject GetDevices():
        return GetDevices(new JsonObject()).
    end method.
    
    /** Returns all devices for a user's master key per the provided 
        filter
        
        @param JsonObject JSON representation of a filter
        @return JsonObject The notifications returned. Errors are raised otherwise */
    method public JsonObject GetDevices(input poFilter as JsonObject):
        define variable oRequest  as IHttpRequest no-undo.
        define variable oResponse as IHttpResponse no-undo.
        
        Assert:NotNull(poFilter, 'Filter').
        
        assign moFilterHeader:Value = string(poFilter:GetJsonText()) 
               oRequest = RequestBuilder:Get(substitute('&1/&2/Push/Devices':u,
                                                /* make sure we're not adding 2 slashes here */
                                                right-trim(ServerUri:ToString(), '/':u),
                                                this-object:ApiKey))
                                :AddHeader(moAuthHeader)
                                :AddHeader(moFilterHeader)
                                :AcceptJson()
                                :Request
               oResponse = this-object:RestClient:Execute(oRequest).        
        ProcessResponse(oResponse).
        
        return cast(oResponse:Entity, JsonObject).
    end method.
    
    /** Returns the count of all devices that are currently registered for push notifications with 
        Telerik Backend Services
        
        @return integer The count of devices */
    method public integer GetDeviceCount():
        define variable oRequest  as IHttpRequest no-undo.
        define variable oResponse as IHttpResponse no-undo.
        
        assign oRequest = RequestBuilder:Get(substitute('&1/&2/Push/Devices/_count':u,
                                                /* make sure we're not adding 2 slashes here */
                                                right-trim(ServerUri:ToString(), '/':u),
                                                this-object:ApiKey))
                                :AddHeader(moAuthHeader)
                                :AcceptJson()
                                :Request
               oResponse = this-object:RestClient:Execute(oRequest).        
        ProcessResponse(oResponse).
        
        return cast(oResponse:Entity, JsonObject):GetInteger('Result':u).
    end method.
    
end class.