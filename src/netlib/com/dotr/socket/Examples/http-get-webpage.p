block-level on error undo, throw.

/* test/demo how to use HTTP GET to fetch a webpage (typically in HTML format) */
define variable cDumpfile as character no-undo.
def var httpClient as com.dotr.socket.httpSocket no-undo.

def var fillin_Host as char no-undo initial "http://www.oehive.org". 
/*fillin_Host = 'www.peg.com'.*/
fillin_Host = 'http://oemobiledemo.progress.com/VehicleOrderService/rest/VehicleOrder/Cart/'.

fillin_Host = 'http://oemobiledemo.progress.com/VehicleOrderService/rest/VehicleOrder/BrandData?filter=~{"brandName":"fjord"~}'.

def var fillin_Port as int no-undo initial 80. 

cDumpfile = session:temp-dir + "testoutput.html".

httpClient = new com.dotr.socket.httpSocket().
httpClient:NewDataChunk:subscribe("NewDataChunkReceived").
httpClient:NewHeader:Subscribe("ResponseHeaderReceived").

httpClient:Navigate(fillin_Host, fillin_Port).

def var i1 as int.
def var i2 as int.

i1 = mtime.
httpClient:WaitForResponse(0).
i2 = mtime.

message 
'wait-for' i2 - i1
view-as alert-box.
 

httpClient:disconnect().
delete object httpClient.

/* display the response 
os-command "notepad.exe " + cDumpfile.
*/

procedure NewDataChunkReceived:
    def input parameter p_socket as class com.dotr.socket.httpSocket no-undo.
    def input parameter p_data as memptr no-undo.

    if get-size(p_data) gt 0  then
       copy-lob from p_data to file cDumpfile append no-convert.
    
end procedure.
    
procedure ResponseHeaderReceived:
    /* subscribed event, is called when the socket-class receives http header from server */
    def input parameter p_socket as class com.dotr.socket.httpSocket no-undo.
    def input parameter p_message as longchar no-undo.

    /* just display the header. 
    message string(p_message) view-as alert-box title "Header".
    */
        
end procedure.
    
    
catch e as Progress.Lang.Error :
    
    message 
    e:GetMessage(1)
    view-as alert-box.
		
end catch.    