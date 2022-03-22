/* *************************************************************************************************************************
Copyright (c) 2017, 2021 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
 /*------------------------------------------------------------------------
    File        : PingWebHandler
    Purpose     : A service interface around the OpenEdge.Rest.Admin.AppServerStatus
                  class used to establish life on the server. See that class' ServerStatus
                  method for more information.
    Author(s)   : pjudge
    Created     : 2017-09-14
    Notes       : * To configure this, add in openedge.properties
                       handler<n>=OpenEdge.Web.PingWebHandler : _oepingService/_oeping
                    Any uri may be used
                  * Only the GET method is supported; a 405 status is otherwise
                    returned
                  * The PathInfo (URI after the /web/ transport) MUST be
                    identical (equality match) to the URI template;
                    a 404 status is otherwise returned
                  * If the client does not accept JSON (per the Accept header), a 415 status is returned
                  * If a stop is raised during execution, a 408 status is returned
                  * If an error is raised, a 500 status is returned
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.StatusCodeEnum.
using OpenEdge.Rest.Admin.AppServerStatus.
using OpenEdge.Web.IWebRequest.
using OpenEdge.Web.SendExceptionError.
using OpenEdge.Web.WebHandler.
using OpenEdge.Web.WebResponse.
using OpenEdge.Web.WebResponseWriter.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.

class OpenEdge.Web.PingWebHandler inherits WebHandler:

    /* Default constructor */
    constructor public PingWebHandler():
        super().
        // override the logger
        assign this-object:Logger = LoggerBuilder:GetLogger(get-class(OpenEdge.Web.PingWebHandler)).
    end constructor.
    
    /* Default handler for the HTTP GET method
       
       @param IWebRequest The request being serviced
       @return integer An optional status code. A zero or null value means this
                       method will deal with all errors */
    method override protected integer HandleGet ( input pReq as IWebRequest ):
        define variable resp           as IHttpResponse     no-undo.
        define variable pingData       as JsonObject        no-undo.
        define variable statusData     as JsonObject        no-undo.
        define variable ass            as AppServerStatus   no-undo.
        define variable statusResponse as character         no-undo.
        define variable svrStatus      as JsonConstruct     no-undo.
        
        // Log in case we want to see who's been pinging us
        this-object:Logger:Trace(substitute('Ping request received from user: &1 at &2 on &3:&4',
                                            pReq:RemoteUser,
                                            pReq:RemoteAddress,
                                            pReq:RemoteHost,
                                            pReq:RemotePort)).
        
        // ONLY allow instance/webapp/web/<template-uri> and nothing after
        if not trim(pReq:PathInfo, '/':u) eq trim(pReq:UriTemplate, '/':u) then
            return integer(StatusCodeEnum:NotFound).                // 404
        
        if not CanAcceptContentType(pReq, 'application/json':u) then
            return integer(StatusCodeEnum:UnsupportedMediaType).    // 415
        
        assign resp             = new WebResponse(StatusCodeEnum:OK)
               resp:ContentType = 'application/json':u
               statusData       = new JsonObject()
               resp:Entity      = statusData
               .

        do on error undo, throw:
            // Use a CCS Service Manager if extant, and let it control this object's lifecycle.
            if valid-object(Ccs.Common.Application:ServiceManager) then
               assign ass = cast(Ccs.Common.Application:ServiceManager:getService(get-class(AppServerStatus)),
                                AppServerStatus).
            
            if not valid-object(ass) then
                assign ass = new AppServerStatus().
            
            assign pingData       = new JsonObject().
                   statusResponse = ass:ServerStatus()
                   .
            // separate ASSIGN for the Parse() operation to avoid trapping errors
            assign svrStatus = (new ObjectModelParser()):Parse(statusResponse)
                   no-error.
            
            if not valid-object(svrStatus) then
                pingData:Add('_retVal':u, statusResponse).
            else
            if type-of(svrStatus, JsonObject) then
                pingData:Add('_retVal':u, cast(svrStatus, JsonObject)).
            else
            if type-of(svrStatus, JsonArray) then
                pingData:Add('_retVal':u, cast(svrStatus, JsonArray)).
            
            statusData:Add('response':u, pingData).
            
            catch pingError as Progress.Lang.Error:
                // Error conditions are treated as an internal server error.
                this-object:Logger:Error(substitute('Ping from user: &1 at &2 on &3:&4 resulted in an error.',
                                                    pReq:RemoteUser,
                                                    pReq:RemoteAddress,
                                                    pReq:RemoteHost,
                                                    pReq:RemotePort), new SendExceptionError(StatusCodeEnum:InternalServerError, pingError)).
                return integer(StatusCodeEnum:InternalServerError).     // 500
            end catch.
            catch pingstop as Progress.Lang.Stop:
                // Stop conditions are treated as a request timeout (eg. in the case of a stop-after).
                this-object:Logger:Error(substitute('Ping from user: &1 at &2 on &3:&4 resulted in a stop.',
                                                    pReq:RemoteUser,
                                                    pReq:RemoteAddress,
                                                    pReq:RemoteHost,
                                                    pReq:RemotePort), new SendExceptionError(StatusCodeEnum:RequestTimeOut, pingstop)).
                return integer(StatusCodeEnum:RequestTimeOut).          // 408
            end catch.
        end.
        
        // write the response, whatever it is
        WriteResponse(resp).
        
        return 0.
    end method.
    
    /** Writes the response using the WebResponseWriter.
        
        This method allows us to unit test this handler (via gradle/batch).
        
        @param IHttpResponse The response to write */
    method protected void WriteResponse(input pResponse as IHttpResponse):
        define variable writer as WebResponseWriter no-undo.
        
        assign writer = new WebResponseWriter(pResponse).
        writer:Open().
        writer:Close().
    end method.
    
    method override protected integer HandleNotAllowedMethod(input pRequest as IWebRequest):
        return integer(StatusCodeEnum:MethodNotAllowed).    // 405
    end method.

    method override protected integer HandleNotImplemented(input pRequest as IWebRequest):
        return integer(StatusCodeEnum:NotImplemented).      // 501
    end method.
    
end class.