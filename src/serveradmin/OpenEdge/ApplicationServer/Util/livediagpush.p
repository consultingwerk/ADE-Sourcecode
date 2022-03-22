/* *************************************************************************************************************************
Copyright (c) 2021 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : OpenEdge/ApplicationServer/Util/livediagpush.p
    Purpose     :
    Author(s)   :
    Created     :
    Notes       : * If the 'url' is unknown, empty or "append" then the pulse data will
                    be written to a file.
                  * For 'Append', the file name is "pulse_<agent-pid>_<YYYY.MM.DD>.json"
                  * For other files, individual pulses are written to disk with a file name of "pulse_<agent-pid>_<ISO8601-timestamp>.json"
                  * In all other cases, the pulse data is sent as JSON to the URL using a POST request. One of the following
                    HTTP status codes is expected:
                        200/OK
                        201/Created
                        202/Accepted
                    If a different status code is received, a message is logged in the agent log
                  * Any errors raised are written to the agent log, but are not rethrown
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.ClientBuilder.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.RequestBuilder.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.

define input parameter HttpUrl      as character no-undo.
define input parameter agentPid     as integer   no-undo.
define input parameter requestPulse as longchar  no-undo.

define variable oRequest   as IHttpRequest  no-undo.
define variable oResponse  as IHttpResponse no-undo.
define variable oFilename  as character     no-undo.
define variable pulseJson  as JsonObject    no-undo.
define variable pulseData  as JsonObject    no-undo.
define variable pulseArray as JsonArray     no-undo.

/* HttpUrl is nil, unknown, or set to 'Append' then don't
 * push the request data; write it to a file
 */
case HttpUrl:
    // write pulse to its own file
    when '':u
    or when ?
    then
    do:
        oFilename = "./pulse_"
                  + string(agentPid) + "_"
                  + replace(iso-date(now), ":", ".")
                  + ".json":u.
        copy-lob requestPulse to file oFilename.
    end.    // per-pulse file
    
    /* Append to an existing file, if present */
    when 'Append':u then
    do:
        // needs  "./" in case "." isn't in PROPATH
        assign pulseJson = cast(new ObjectModelParser():Parse(requestPulse), JsonObject)
               oFilename = "./pulse_"
                         + string(agentPid) + "_"
                         + replace(substring(iso-date(now),1,10), ":", ".")
                         + ".json"
               file-info:file-name = oFilename
               .
        if file-info:full-pathname eq ? then
        do:
            assign pulseData  = new JsonObject()
                   pulseArray = new JsonArray()
                   .
            pulseData:Add('pulses':u, pulseArray).
        end.
        else
            assign pulseData  = cast(new ObjectModelParser():ParseFile(file-info:full-pathname), JsonObject)
                   pulseArray = pulseData:GetJsonArray('pulses':u)
                   .
        pulseArray:Add(pulseJson).
        pulseData:WriteFile(oFilename).
    end.    // append to file
    
    // "write" to URL
    otherwise
    do:
        assign pulseData = new JsonObject().
        pulseData:Add( 'requestData', requestPulse).
        
        oRequest = RequestBuilder:Post( HttpUrl, pulseData )
            :ContentType( 'application/json' )
            :Request.
        oResponse = ClientBuilder:Build():Client:Execute(oRequest).
        
        /* Verify that the request to the diagnostic server is successful.
        If it is not then write the message in the agent log */
        if oResponse:StatusCode < 200
        or oResponse:StatusCode > 202
        then
            message "Unable to access Server: status code - " + string(oResponse:StatusCode).
    end.    // POST()
end case.   // HttpUrl

catch e as Progress.Lang.Error :
    message 'Pulse error: ' + e:GetMessage(1).
end catch.
/* EOF */