/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : ApperyPushNotificationService
    Purpose     : Sends push notifications to a device or devices.
    Author(s)   : pjudge
    Created     : Mon Feb 10 16:41:36 EST 2014
    Notes       : * Doc at http://docs.mobile.rollbase.com/documentation/backendservices/push/
        
                  * For examples of the JSON required for filtered notification
                    requests, see the JSON generated when using the
                    "Devices filtered using query builder" functionality in the
                    Push Notifications / Send push notification page at 
                    https://mobile.rollbase.com/push/.

                  * To send Push Notification using Push API Key, send POST request
                    to the according URL. filter is the optional parameter, when 
                    its empty Push Notification is sent to all devices. 
                    schedule is the optional parameter, when its not empty 
                    Push Notification can be scheduled.
            curl -X POST \
            -H "X-Appery-Push-API-Key:<pushAPIKey>" \
            -H "Content-Type: application/json" \
            -d '{"payload":{"message" : <message>, "badge" : <badge>}[, "filter" : {"deviceID" : <deviceID criteria>,"<param1>" : <criteria>, ...}][, "schedule": {"scheduledTime": <scheduled_time>, "useTimeZone": <use_time_zone>}]}' \
            https://api.appery.io/rest/push/msg
        
        where:
            <pushAPIKey> is a unique key, issued by server, which allows sending Push Notifications;
            <message> is the message text (mandatory);
            <badge> is the number shown with app icon in iOS (optional, if empty - badge is not changed on device);
            <deviceID criteria> is deviceID criteria for searching device;
            <param1> is a custom field of _devices table;
            <criteria> is param1 criteria for searching device;
            <scheduled_time> is the date when Push Notification should be sent (it is always truncated to minute);
            <use_time_zone> is a boolean parameter indicating whether Push Notification should be sent in device time zone.
        
        If Push Notification is scheduled, server returns HTTP 200 and list of saved Push Notifications, else server returns HTTP 204 NO CONTENT status even if no messages were sent or delivered.
            Error                           HTTP    Code        Description
            Push API Key not found          404     PNMM004     Master Key: <pushAPIKey> not found
            Empty message                   400     PNMM017     Message cant be empty
            Badge negative                  400     PNMM062     Badge cannot be negative
            No iOS certificate              400     PNMM082     iOS Push certificate is not set
            No android API key              400     PNMM084     Android API key is not set
            No iOS certificate password     400     PNMM085     iOS Push certificate password is not set
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Mobile.NotificationServiceError.
using OpenEdge.Mobile.PushNotificationService.
using OpenEdge.Net.URI.
using OpenEdge.Net.HTTP.RequestBuilder.
using OpenEdge.Net.HTTP.StatusCodeEnum.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.IHttpResponse.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Lang.Error.

class OpenEdge.Mobile.ApperyPushNotificationService inherits PushNotificationService:
                        
    /** Constructor.
        
        @param URI A URI representing the notification server
        @param character The (mandatory) API key to enable notifications */
    constructor public ApperyPushNotificationService(input poURI as URI,
                                                     input pcApiKey as character):
        super(poURI, pcApiKey).                                                   
    end constructor.
    
    /** Constructor.
        
        @param character The (mandatory) API key to enable notifications */
    constructor public ApperyPushNotificationService(input pcApiKey as character):
        this-object(URI:Parse('https://api.mobile.rollbase.com/':u),
                    pcApiKey).
    end constructor.
    
    
    /** Sends a notification for a given payload. The payload may be built by one
        of the methods in this class, or created by the PushNotificationMessageBuilder
        class (which is also used internally).
        
        This method performs the actual request to the Notification Service.
        
        @param JsonObject The notification payload.  */
    method override public JsonConstruct SendNotification(input poPayload as JsonObject):
        define variable oRequest as IHttpRequest no-undo.
        define variable oResponse as IHttpResponse no-undo.
        
        Assert:NotNull(poPayload, 'Payload').
        
        assign oRequest = RequestBuilder:Post(/* make sure we're not adding 2 slashes here */
                                              right-trim(ServerUri:ToString(), '/':u) + '/rest/push/msg':u,
                                              poPayload)
                               :AddHeader('X-Appery-Push-API-Key':u, this-object:ApiKey)
                               :Request.

        oResponse = this-object:RestClient:Execute(oRequest).
        ProcessResponse(oResponse).
        
        if session:debug-alert then
        do:
            cast(oRequest:Entity, JsonConstruct):WriteFile(session:temp-dir + 'request.json', true).
            cast(oResponse:Entity, JsonConstruct):WriteFile(session:temp-dir + 'response.json', true).
        end.
                
        if valid-object(oResponse:Entity) and type-of(oResponse:Entity, JsonConstruct) then 
            return cast(oResponse:Entity, JsonConstruct).
        else
            return ?.
                
        /* Simply return NSE's */
        catch oNSE as NotificationServiceError:
            undo, throw oNSE.
        end catch.
        /* Wrap all errors into NotificationServiceError and
           attach the original error as InnerError. */
        catch oError as Error:
            return error new NotificationServiceError(
                                    '000':u,
                                    'PNS':u + string(oError:GetMessageNum(1), '>>>9999':u),
                                    oError:GetMessage(1),
                                    oError).
        end catch.
    end method.
    
    /** Processes a response from the Notification service. Creates and throws
        a NotificationServiceError if necessary.
        
        @param HttpResponse The result of the REST request.
        @throws NotificationServiceError Throws an error if the return code is 
                                         not 200 or 204 */
    method protected void ProcessResponse(input poResponse as IHttpResponse):
        define variable oBody as JsonObject no-undo.
        define variable cErrorCode as character no-undo.
        define variable cErrorDescription as character no-undo.
        
        case poResponse:StatusCode:
            when integer(StatusCodeEnum:OK) or 
            when integer(StatusCodeEnum:NoContent) then
                /* 200, 204 no-op */.
            otherwise
            do:
                case true:
                    when type-of(poResponse:Entity, JsonObject) then
                        assign oBody = cast(poResponse:Entity, JsonObject)
                               cErrorCode = oBody:GetCharacter('code':u)
                               cErrorDescription = oBody:GetCharacter('description':u).
                    otherwise
                        assign cErrorCode        = string(poResponse:StatusCode)
                               cErrorDescription = poResponse:StatusReason.
                end case.
                return error new NotificationServiceError(string(poResponse:StatusCode),
                                                          cErrorCode,
                                                          cErrorDescription).
            end.
        end case.            
    end method.
    
end class.