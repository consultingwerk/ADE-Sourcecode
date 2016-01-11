
/* test/demo how to use HTTP GET to download a binary file */

def var httpClient as com.dotr.socket.httpSocket no-undo.

def var fillin_Host as char no-undo initial "https://bitbucket.org/jmls/dotrsocket/get/f76f9a43ab99.zip". 
def var outputfile  as char no-undo.

def var fillin_Port as int initial 443 no-undo. 

assign httpClient = new com.dotr.socket.httpSocket().

httpClient:NewDataChunk:subscribe("NewDataChunkReceived").
httpClient:NewHeader:Subscribe("ResponseHeaderReceived").

httpClient:Navigate(fillin_Host, fillin_Port).
httpClient:WaitForResponse(). 

httpClient:disconnect().
delete object httpClient.

message "download complete " outputfile view-as alert-box information.

procedure NewDataChunkReceived:
    def input parameter p_socket as class com.dotr.socket.httpSocket no-undo.
    def input parameter p_data as memptr no-undo.

    if get-size(p_data) gt 0 then
       copy-lob from p_data to file outputfile append no-convert.
    
end procedure.
    
procedure ResponseHeaderReceived:
    /* subscribed event, is called when the socket-class receives http header from server */
    def input parameter p_socket as class com.dotr.socket.httpSocket no-undo.
    def input parameter p_message as longchar no-undo.

    /* just display the header. */
    message string(p_message) view-as alert-box title "Header".

    run SetFilename.
end procedure.

procedure SetFilename :
    def var ContentType as char no-undo.
    def var extension   as char no-undo.
    
    ContentType = httpClient:HeaderValue("Content-Type").  /* for example: "application/pdf; charset=utf-8" */
    extension = trim(entry(1, ContentType, ";")).
    if num-entries(extension, "/")>1 then
       extension = trim(entry(2, extension, "/")).
    else
       extension = "".
    if extension=? or extension=""
       then extension="txt".
    outputfile = "c:\temp\testoutput." + extension.
    os-delete VALUE(outputfile).
    
end procedure.