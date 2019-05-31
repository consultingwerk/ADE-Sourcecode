
/*------------------------------------------------------------------------
    File        : reqdiagpush.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : mbanks
    Created     : Thu Feb 22 13:14:25 EST 2018
    Notes       :
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.Net.HTTP.ClientBuilder.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.IHttpClient.
using OpenEdge.Net.HTTP.RequestBuilder.
using OpenEdge.Net.URI.
using Progress.Json.ObjectModel.JsonObject. 

define variable oRequest    as IHttpRequest  no-undo.
define variable oResponse   as IHttpResponse no-undo.
define variable oJsonEntity as JsonObject    no-undo.
define variable JsonString  as longchar      no-undo.

session:debug-alert = true.

define input parameter HttpUrl as char.
define input parameter AgentPID as int64.
define input parameter ABLSessionID as char.
define input parameter RequestStart as datetime.
define input parameter RequestLength as int64.
define input parameter Transport as char.
define input parameter APIEntryPt as char.
define input parameter TestRun as char.
define input parameter PerfData as longchar.
                 
define variable requestJson as JsonObject no-undo.

assign 
    requestJson = new JsonObject().                  
requestJson:Add( 'AgentPID', AgentPID ).
requestJson:Add( 'ABLSessionID', ABLSessionID ).
requestJson:Add( 'RequestLength', RequestLength ).
requestJson:Add( 'Transport', Transport ).
requestJson:Add( 'EntryPt', APIEntryPt ).
requestJson:Add( 'TestRun', TestRun ).
requestJson:Add( 'PerfData', PerfData ).

oRequest = RequestBuilder:Post( HttpUrl, requestJson )
    :ContentType( 'application/json' )
    :AcceptJson()
    :Request.
/* For Fiddler 
def var oClient as IHttpClient no-undo.
oClient = new OpenEdge.Net.HTTP.ProxyHttpClient(
    ClientBuilder:Build():Client,
    URI:Parse('http://localhost:8888')
    ). 
oResponse = oClient:Execute(oRequest).
*/
oResponse = ClientBuilder:Build():Client:Execute(oRequest).

/* Verify that the request to the diagnostic server is successful.
If it is not then write the message in the agent log
*/

if oResponse:StatusCode NE 201 then 
do:
    message "Unable to access the Diagnostic Server".
    message "Server returned status code - " + String(oResponse:StatusCode).
end.


CATCH e AS Progress.Lang.Error :
    message e:GetMessage(1). 
END CATCH.
