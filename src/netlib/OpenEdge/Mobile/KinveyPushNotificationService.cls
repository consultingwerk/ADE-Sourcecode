/************************************************
Copyright (c) 2018 by Progress Software Corporation. All rights reserved.
*************************************************/ 
 /*------------------------------------------------------------------------
    File        : KinveyPushNotificationService
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : htirunag
    Created     : Fri May 25 12:46:01 IST 2018
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Mobile.NotificationServiceError.
using OpenEdge.Mobile.PushNotificationService.
using OpenEdge.Net.HTTP.Credentials.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.RequestBuilder.
using OpenEdge.Net.HTTP.StatusCodeEnum.
using OpenEdge.Net.URI.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.Error.

class OpenEdge.Mobile.KinveyPushNotificationService inherits PushNotificationService:
    
    /** Constructor.
        
        @param URI A URI representing the notification server
        @param character An API key for this service. This is the base64-encoded username/password for HTTP Basic authorization. */
    constructor public KinveyPushNotificationService ( input poURI as URI, input pcApiKey as character ):
        super(poURI, pcApiKey).
    end constructor.
    
    /** Constructor.
        
        @param character An API key for this service. This is the base64-encoded username/password for HTTP Basic authorization */
    constructor public KinveyPushNotificationService(input pcApiKey as character ):
        //default live server, though likely to fail
        this-object(URI:Parse('https://baas.kinvey.com':u), pcApiKey).
    end constructor.
    
    /** Constructor.
        
        @param URI A URI representing the notification server
        @param Credentials The (mandatory) Credentials to authenticate */
    constructor public KinveyPushNotificationService(input poURI as URI,
                                                     input oCredentials as Credentials):
        super(poURI, oCredentials).
    end constructor.
    
    /** Factory method for retrieving an instance of the server.
    
        @param URI A URI representing the notification server
        @param character A (mandatory) ApplicationName representing the Kinvey
        @param character A (mandatory) CustomEndpointName representing the Kinvey
        @param Credentials The (mandatory) Credentials to authenticate  */
    constructor public KinveyPushNotificationService(input pApplicationName as character,
                                                     input pCustomEndpoint as character,
                                                     input pCredentials as Credentials):
        //default live server
        this-object(URI:Parse('https://baas.kinvey.com':u), pCredentials).
        
        assign this-object:ServerUri:Path = substitute('/rpc/&1/custom/&2',
                                                pApplicationName,
                                                pCustomEndpoint). 
    end method.
    
    /** Sends a notification for a given payload. The payload may be built by one
        of the methods in this class, or created by the PushNotificationMessageBuilder
        class (which is also used internally).
        
        This method performs the actual request to the Notification Service.
        
        @param JsonObject The notification payload. 
        @return JsonConstruct The result of the request. Can be an object or array,
                              depending on success or failure. */        
    method override public JsonConstruct SendNotification(input poPayload as JsonObject):
        define variable oResponse as IHttpResponse no-undo.
        define variable reqBldr as RequestBuilder no-undo.
        
        Assert:NotNull(poPayload, 'Payload').
        
        assign reqBldr = RequestBuilder:Post(right-trim(ServerUri:ToString(), '/':u), poPayload)
                            :AcceptJson()
                            :ContentType('application/json':u).
        // Add either the credentials or the API Key as a Basic auth header
        if valid-object(ServerCredentials) then
            reqBldr:UsingBasicAuthentication(ServerCredentials).
        else
            reqBldr:AddHeader('Authorization':u, substitute('Basic &1':u, this-object:ApiKey)).
        
        assign oResponse = this-object:RestClient:Execute(reqBldr:Request).
        ProcessResponse(oResponse).
        
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
        define variable cError as character no-undo.
        define variable cDebugMessage as character no-undo.
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
                               cError = oBody:GetCharacter('error')
                               cDebugMessage = oBody:GetCharacter('debug')
                               cErrorDescription = oBody:GetCharacter('description').
                    otherwise
                        assign cError        = string(poResponse:StatusCode)
                               cErrorDescription = poResponse:StatusReason.
                end case.
                return error new NotificationServiceError(string(poResponse:StatusCode),
                                                          string(cError + ". " + cDebugMessage),
                                                          cErrorDescription).
            end.
        end case.            
    end method.
    
end class.