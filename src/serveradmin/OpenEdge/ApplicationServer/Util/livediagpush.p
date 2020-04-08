

block-level on error undo, throw.

using OpenEdge.Net.HTTP.ClientBuilder.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.IHttpClient.
using OpenEdge.Net.HTTP.RequestBuilder.
using OpenEdge.Net.URI.
using Progress.Json.ObjectModel.JsonObject. 

define input parameter HttpUrl as char no-undo.
define input parameter agentPid as int no-undo.
define input parameter requestPulse as longchar.
                 
define variable oRequest    as IHttpRequest  no-undo.
define variable oResponse   as IHttpResponse no-undo.
define variable requestJson as JsonObject no-undo.
define variable oFilename   as character no-undo.

/* HttpUrl is nil, unknown, or set to 'Append' then don't
 * push the request data; write it to a file
 */
IF HttpUrl EQ "" OR HttpUrl EQ ? OR HttpUrl EQ "Append" THEN
DO:
   /* Output data to a file instead */
   IF HttpUrl NE "Append" THEN
   DO:
      oFilename = "pulse_" + string(agentPid) + "_" + ISO-DATE(NOW) + ".json".
      oFilename = REPLACE(oFilename, ":", ".").
      COPY-LOB requestPulse TO FILE oFilename.
   END.
   ELSE
   DO: /* Append to an existing file, if present */
      oFilename = "pulse_" + string(agentPid) + "_"
                   + SUBSTRING(ISO-DATE(NOW),1,10) + ".json".
      oFilename = REPLACE(oFilename, ":", ".").
      FILE-INFO:FILENAME = oFilename.
      IF FILE-INFO:FULL-PATHNAME EQ ? THEN
      DO:
         /* file not there -- first time use */
         OUTPUT TO VALUE(oFilename).
         PUT UNFORMATTED "~{~"pulses~":[".
      END.
      ELSE
      DO:
         /* add a comma after the previous write */
         OUTPUT TO VALUE(oFilename) APPEND.
         PUT UNFORMATTED ",".
      END.
      OUTPUT CLOSE.
      COPY-LOB requestPulse TO FILE oFilename APPEND.
   END.
   RETURN.
END.
   
assign 
    requestJson = new JsonObject().                  
requestJson:Add( 'requestData', requestPulse ).

oRequest = RequestBuilder:Post( HttpUrl, requestJson )
    :ContentType( 'application/json' )
    :AcceptJson()
    :Request.
oResponse = ClientBuilder:Build():Client:Execute(oRequest).

/* Verify that the request to the diagnostic server is successful.
If it is not then write the message in the agent log
*/

if oResponse:StatusCode NE 201 then 
do:
    message "Unable to access  Server".
    message "Server returned status code - " + String(oResponse:StatusCode).
end.


CATCH e AS Progress.Lang.Error :
    message e:GetMessage(1). 
END CATCH.
