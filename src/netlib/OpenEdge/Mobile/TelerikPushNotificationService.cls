/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : TelerikPushNotificationService
    Purpose     : Sends push notifications to a device or devices.
    Author(s)   : pjudge
    Created     : Mon Feb 10 16:41:36 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Mobile.NotificationServiceError.
using OpenEdge.Mobile.PushNotificationMessageBuilder.
using OpenEdge.Mobile.PushNotificationService.
using OpenEdge.Net.HTTP.ClientBuilder.
using OpenEdge.Net.HTTP.IHttpClient.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.RequestBuilder.
using OpenEdge.Net.URI.
using OpenEdge.Net.HTTP.StatusCodeEnum.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.Error.
using Progress.Lang.Object.

class OpenEdge.Mobile.TelerikPushNotificationService inherits PushNotificationService:
                        
    /** Constructor.
        
        @param URI A URI representing the notification server
        @param character The (mandatory) API key to enable notifications */
    constructor public TelerikPushNotificationService(input poURI as URI,
                                                      input pcApiKey as character):
        super(poURI, pcApiKey).
    end constructor.

    /** Constructor.
        
        @param character The (mandatory) API key to enable notifications */
    constructor public TelerikPushNotificationService(input pcApiKey as character):
        /* default to live Telerik servers */
        this-object(URI:Parse('http://api.everlive.com/v1/':u),
                    pcApiKey).
    end constructor.
    
    /** Sends a notification for a given payload. The payload may be built by one
        of the methods in this class, or created by the PushNotificationMessageBuilder
        class (which is also used internally).
        
        This method performs the actual request to the Notification Service.
        
        @param JsonObject The notification payload. 
        @return JsonConstruct The result of the request. Can be an object or array,
                              depending on success or failure. */        
    method override public JsonConstruct SendNotification(input poPayload as JsonObject):
        define variable oRequest  as IHttpRequest no-undo.
        define variable oResponse as IHttpResponse no-undo.
        
        Assert:NotNull(poPayload, 'Payload').
        
        assign oRequest = RequestBuilder:Post(substitute('&1/&2/Push/Notifications',
                                                /* make sure we're not adding 2 slashes here */
                                                right-trim(ServerUri:ToString(), '/':u),
                                                this-object:ApiKey), 
                                              poPayload)
                                :Request
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
        define variable iErrorCode as integer no-undo.
        define variable cErrorDescription as character no-undo.
        
        case poResponse:StatusCode:
            when integer(StatusCodeEnum:OK) or
            when integer(StatusCodeEnum:Created) or 
            when integer(StatusCodeEnum:NoContent) then
                /* 200, 201, 204 no-op */.
            otherwise
            do:
                case true:
                    when type-of(poResponse:Entity, JsonObject) then
                        assign oBody = cast(poResponse:Entity, JsonObject)
                               iErrorCode = oBody:GetInteger('errorCode':u)
                               cErrorDescription = oBody:GetCharacter('message':u).
                    otherwise
                        assign iErrorCode        = poResponse:StatusCode
                               cErrorDescription = poResponse:StatusReason.
                end case.
                return error new NotificationServiceError(string(poResponse:StatusCode),
                                                          string(iErrorCode),
                                                          cErrorDescription).
            end.
        end case.            
    end method.
    
end class.