/* *************************************************************************************************************************
Copyright (c) 2017,2021,2026 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
 /*------------------------------------------------------------------------
    File        : PingWebHandler
    Purpose     : A service interface around the OpenEdge.Rest.Admin.AppServerStatus
                  class used to establish life on the server. See that class' ServerStatus
                  method for more information.
    Author(s)   : pjudge
    Created     : 2017-09-14
    Notes       : Provides an _oeping service for the WEB transport with
                  identical behavior to the REST-based _oeping service.

    To directly utilize the WebHandler add in openedge.properties:
      handler<n>=OpenEdge.Web.PingWebHandler : _oepingService/_oeping

    OEDS DEPLOYMENT AND USAGE:
    --------------------------

    >cd $CATALINA_BASE
    >bin/tcman deployablsvc -oeds {DLC}/servers/pasoe/extras/oepingWebService.oeds -webapp {webapp-name} -ablapp {ablapp-name}

    GET { http | https }://{host}:{port}/[{web_app}/]web/_oepingService/_oeping
------------------------------------------------------------------------*/

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

class OpenEdge.Web.PingWebHandler
    inherits WebHandler
    use-widget-pool
:

    /* Default constructor */
    constructor public PingWebHandler():
        super().

        // Override the logger with one for this class.
        assign this-object:Logger = LoggerBuilder:GetLogger(get-class(OpenEdge.Web.PingWebHandler)).
    end constructor.

    /* Default handler for the HTTP GET method

       @param IWebRequest The request being serviced
       @return integer An optional status code. A zero or null value means this
                       method will deal with all errors */
    method override protected integer HandleGet ( input poRequest as IWebRequest ):
        define variable oResponse       as IHttpResponse     no-undo.
        define variable oPingData       as JsonObject        no-undo.
        define variable oStatusData     as JsonObject        no-undo.
        define variable oAppSrvStatus   as AppServerStatus   no-undo.
        define variable cStatusResponse as character         no-undo.
        define variable oServerStatus   as JsonConstruct     no-undo.

        this-object:Logger:Debug(substitute('HandleGet Called - PathInfo: &1, UriTemplate: &2':u,
                                            poRequest:PathInfo, poRequest:UriTemplate)).

        // Log in case we want to see who's been pinging us
        this-object:Logger:Trace(substitute('Ping request received from user: &1 at &2 on &3:&4',
                                            poRequest:RemoteUser,
                                            poRequest:RemoteAddress,
                                            poRequest:RemoteHost,
                                            poRequest:RemotePort)).

        // ONLY allow instance/webapp/web/<template-uri> and nothing after
        if trim(poRequest:PathInfo, '/':u) ne trim(poRequest:UriTemplate, '/':u) then
        do:
            this-object:Logger:Debug('Path validation failed - returning 404').
            {&_proparse_ prolint-nowarn(overflow)}
            return integer(StatusCodeEnum:NotFound:GetValue()). // 404
        end.

        if not CanAcceptContentType(poRequest, 'application/json':u) then
        do:
            this-object:Logger:Debug('Content type validation failed - returning 415').
            {&_proparse_ prolint-nowarn(overflow)}
            return integer(StatusCodeEnum:UnsupportedMediaType:GetValue()). // 415
        end.

        assign
            oResponse             = new WebResponse(StatusCodeEnum:OK)
            oResponse:ContentType = 'application/json':u
            oStatusData           = new JsonObject()
            oResponse:Entity      = oStatusData
            .

        do on error undo, throw:
            // Use a CCS Service Manager if exists, and let it control this object's lifecycle.
            if valid-object(Ccs.Common.Application:ServiceManager) then
               assign oAppSrvStatus = cast(Ccs.Common.Application:ServiceManager:getService(get-class(AppServerStatus)), AppServerStatus).

            if not valid-object(oAppSrvStatus) then
                assign oAppSrvStatus = new AppServerStatus().

            assign
                oPingData       = new JsonObject()
                cStatusResponse = oAppSrvStatus:ServerStatus()
                .

            // Separate ASSIGN for the Parse() operation to avoid trapping errors
            assign oServerStatus = (new ObjectModelParser()):Parse(cStatusResponse) no-error.

            if not valid-object(oServerStatus) then
                oPingData:Add('_retVal':u, cStatusResponse).
            else
            if type-of(oServerStatus, JsonObject) then
                oPingData:Add('_retVal':u, cast(oServerStatus, JsonObject)).
            else
            if type-of(oServerStatus, JsonArray) then
                oPingData:Add('_retVal':u, cast(oServerStatus, JsonArray)).

            oStatusData:Add('response':u, oPingData).

            catch pingError as Progress.Lang.Error:
                // Error conditions are treated as an internal server error.
                this-object:Logger:Error(substitute('Ping from user: &1 at &2 on &3:&4 resulted in an error.':u,
                                                    poRequest:RemoteUser,
                                                    poRequest:RemoteAddress,
                                                    poRequest:RemoteHost,
                                                    poRequest:RemotePort), new SendExceptionError(StatusCodeEnum:InternalServerError, pingError)).
                {&_proparse_ prolint-nowarn(overflow)}
                return integer(StatusCodeEnum:InternalServerError:GetValue()). // 500
            end catch.
            catch pingstop as Progress.Lang.Stop:
                // Stop conditions are treated as a request timeout (eg. in the case of a stop-after).
                this-object:Logger:Error(substitute('Ping from user: &1 at &2 on &3:&4 resulted in a stop.':u,
                                                    poRequest:RemoteUser,
                                                    poRequest:RemoteAddress,
                                                    poRequest:RemoteHost,
                                                    poRequest:RemotePort), new SendExceptionError(StatusCodeEnum:RequestTimeOut, pingstop)).
                {&_proparse_ prolint-nowarn(overflow)}
                return integer(StatusCodeEnum:RequestTimeOut:GetValue()). // 408
            end catch.
        end.

        // write the response, whatever it is
        WriteResponse(oResponse).

        return 0.
    end method.

    /** Writes the response using the WebResponseWriter.

        This method allows us to unit test this handler (via gradle/batch).

        @param IHttpResponse The response to write */
    method protected void WriteResponse(input poResponse as IHttpResponse):
        define variable writer as WebResponseWriter no-undo.

        this-object:Logger:Debug(substitute('WriteResponse - Status: &1, ContentType: &2':u,
                                            poResponse:StatusCode, poResponse:ContentType)).

        assign writer = new WebResponseWriter(poResponse).
        writer:Open().
        writer:Close().
    end method.

    method override protected integer HandleNotAllowedMethod(input poRequest as IWebRequest):
        {&_proparse_ prolint-nowarn(overflow)}
        return integer(StatusCodeEnum:MethodNotAllowed:GetValue()). // 405
    end method.

    method override protected integer HandleNotImplemented(input poRequest as IWebRequest):
        {&_proparse_ prolint-nowarn(overflow)}
        return integer(StatusCodeEnum:NotImplemented:GetValue()). // 501
    end method.

end class.