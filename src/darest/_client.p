/* ***********************************************************/
/* Copyright (c) 2004-2011 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/

/* ***************************  Definitions  ************************** */
 
define new shared        variable cPDIR            as character.

define                   variable fSocketHandle    as handle    no-undo.
define                   variable aOk              as logical   no-undo.
define                   variable fLoggerHandle    as handle    no-undo.

/* servers */
/*define                   variable fDefaultHandle   as handle    no-undo.*/
DEFINE                   VARIABLE fAPIhandle       AS HANDLE NO-UNDO. 

/* this temp-table only contains a single record and its buffer is used
   like an object to hold onto the options read from the command message.
*/   
define temp-table ttCommand no-undo
    field Name as character
    field Parameters as character
    field Scope as character
    field RequestID as int64
    field ResultIsLongChar as logical.

/* ********************  Preprocessor Definitions  ******************** */

/* declaration for protocol */
&SCOPED-DEFINE MSG_HEADER_SIZE 6
&SCOPED-DEFINE PACKET_HEADER_SIZE 5
&SCOPED-DEFINE MSG_HEADER_BEGIN 254
&SCOPED-DEFINE MSG_HEADER_END   253
&SCOPED-DEFINE PACKET_BEGIN     252
&SCOPED-DEFINE PACKET_END       251
&SCOPED-DEFINE MSG_END          250

/* declarations for command identifiers */

/* the name of the program to run */
&SCOPED-DEFINE COMMAND_PROGRAM 1

/* the parameters to pass to the program that is being run */ 
&SCOPED-DEFINE COMMAND_PARAMETERS 2

/* the scope of the command.  Must be already registered */
&SCOPED-DEFINE COMMAND_SCOPE 3

/* use alternate run statement to allow longchar return value */
&SCOPED-DEFINE COMMAND_USES_LONGCHAR 4

function log returns character 
    ( input msg as character) forward.

&global-define DEFAULT-SERVER-PORT 4444
&global-define MAX-CONNECTION-FAILURES 3

/* ***************************  Main Block  *************************** */

create socket fSocketHandle.
    
run ConnectToServer no-error.

if not aOK or error-status:error or not fSocketHandle:connected() then 
do:
    log( "Error Status: " + string(error-status:error)).
    log( "Return Value: " + return-value ).
    log( "Error Message: " + error-status:get-message(1)).
    log( "aOk variable: " + string(aOk)).
    log( "Socket connected: " + string(fSocketHandle:connected())).
    run quit ("").
    quit.
end.


/* now that we have connected, wait forever listening for
   data from the server
   When we receive data, pass it to the read handler and then
   start looping again. 
*/
RUN darest/rest.p      PERSISTENT SET fAPIhandle.
run SetUseLongChar in fAPIhandle(true).

DONTQUIT:
do on error     undo, retry DONTQUIT
    on stop      undo, retry DONTQUIT
    on endkey    undo, retry DONTQUIT
    on quit      undo, retry DONTQUIT:
    wait-for "CLOSE" of this-procedure.
end.

quit.

/* **********************  Internal Procedures  *********************** */
procedure ConnectToServer.
    define variable cPort as character no-undo.

    cPort = OS-GETENV("OEMMT_PORT").

    if cPort = "" or cPort = ? then cPort = "{&DEFAULT-SERVER-PORT}".  /* Default port */

    log( "Connecting to eclipse project").
    aOk = fSocketHandle:CONNECT("-S " + cPort) no-error.
    log( error-status:get-message(1)).
  
    if not aOK then
        return error "Connection to eclipse project failed on port " + cPort.
    else 
    do:
        run SendConnectionGreeting no-error.
        if error-status:error = true then 
        do:
            return error return-value.
        end.
    end.

end procedure.
 
procedure SendConnectionGreeting:
    define variable greeting    as character no-undo.
    define variable projectname as character no-undo.  
  
    fSocketHandle:SET-READ-RESPONSE-PROCEDURE("ReceiveCommand", this-procedure).   
    greeting = "CLIENT:".
    log( "Connected" ).
  
    run WriteToSocket(0, greeting) no-error.
    
    if error-status:error = true then 
    do:
        return error return-value.
    end.
end.

/** handles writing of response data back to the eclipse session
 *
 * Message format:
   - MSG_HEADER_BEGIN    - 1 byte      - CHR(254)
   - requestId           - 4 bytes
   - MSG_HEADER_END      - 1 byte      - CHR(253)
   - PACKET_BEGIN        - 1 byte      - CHR(252)
   - packetLength        - 4 bytes
   - data                - priceless
   - PACKET_END          - 1 byte      - CHR(251)
   - MSG_END             - 1 byte      - CHR(250)
*/

procedure WriteToSocket:

    define input parameter requestid as integer no-undo.
    define input parameter packet    as longchar no-undo.
  
    define variable messageHeader  as memptr    no-undo.
    define variable packetBuffer   as memptr    no-undo.
    define variable messageTrailer as memptr    no-undo.
  
    define variable packetLength   as integer   no-undo.
    define variable ok             as logical   no-undo.
    define variable msg            as character no-undo.
    
    set-byte-order(messageHeader) = 3.
    set-byte-order(packetBuffer) = 3.
    set-byte-order(messageTrailer) = 3.
  
    if packet = ? then
        packet = "?".
    
    ok = VALID-HANDLE(fSocketHandle).
  
    if ok = true  then 
    do:
        ok = fSocketHandle:CONNECTED().
    
        if ok = true then 
        do:
        
            SET-SIZE(messageHeader) = {&MSG_HEADER_SIZE}.
            PUT-BYTE(messageHeader, 1) = {&MSG_HEADER_BEGIN}.
            PUT-LONG(messageHeader, 2) = RequestId.
            PUT-BYTE(messageHeader, 6) = {&MSG_HEADER_END}.
      
            ok = fSocketHandle:WRITE (messageHeader,1,{&MSG_HEADER_SIZE}) no-error.      
            if ok = true then 
            do:
                /* Bug - OE00198914 */
                /* Modified By - grkumar
                   Here a check is put if the SESSION:CPINTERNAL is UTF-8 or not. If 
                   not then the message is converted in UTF-8 encoding format.
                   Another change is in the calculation of packetLength in the else
                   condition below. One more attribute is given i.e., "RAW" in the LENGTH()
                   function which returns the required length in Bytes. If we don't specify
                   any attribute then by default the length is returned in Characters which
                   may result in loss of some characters at the end of the stream resulting 
                   in error on the Java side.
                   
                   HD - changed to always use utf-8 cpinternal is irrelevant
                   OE00221236 Issues displaying UTF-8 data in IE and chrom
                   
                */    
                
                define variable mpacket as memptr no-undo.
                set-byte-order(mpacket) = 3.
                COPY-LOB packet TO mpacket CONVERT TARGET CODEPAGE "utf-8".
                packetLength = GET-SIZE(mpacket).
                SET-SIZE(packetBuffer) = packetLength + {&PACKET_HEADER_SIZE} + 1.
                PUT-BYTE(packetBuffer, 1) = {&PACKET_BEGIN}.
                PUT-LONG(packetBuffer, 2) = packetLength.
                PUT-BYTES(packetBuffer, 6) = mpacket.

                PUT-BYTE(packetBuffer, {&PACKET_HEADER_SIZE} + packetLength + 1) = {&PACKET_END}.
                
                ok = fSocketHandle:WRITE (packetBuffer,1, {&PACKET_HEADER_SIZE} + packetLength + 1) no-error.
          
                if ok = true then 
                do:
                    SET-SIZE(messageTrailer) = 1.   
                    PUT-BYTE(messageTrailer, 1) = {&MSG_END}.
                    ok = fSocketHandle:WRITE (messageTrailer,1, 1) no-error.
                end.
    
            end.
      
        end.
    
    end.

    SET-SIZE(messageHeader)  = 0.
    SET-SIZE(packetBuffer)   = 0.    
    SET-SIZE(messageTrailer) = 0.
    
    if OK <> true then 
    do:
        msg = error-status:get-message(1).
        run QUIT(msg).
        return error msg.
    end.
    
    return "".
    
end.

/*
This handles incoming commands from the Eclipse JVM.
*/
procedure ReceiveCommand:
  
    /* Read procedure for socket */
    define variable requestId   as integer   no-undo.
    define variable messageSize as integer   no-undo.
    define variable oneByte     as memptr    no-undo.
    define variable fourBytes   as memptr    no-undo.
    define variable theData     as memptr    no-undo.
    define variable cError      as character no-undo.
    define variable ok          as logical   no-undo.
    
    set-byte-order(oneByte) = 3.
    set-byte-order(fourBytes) = 3.
    set-byte-order(theData) = 3.
    
    if not self:CONNECTED() then
    do:
        run QUIT ("Lost connection").
        return error "Socket disconnected".
    end.
    SET-SIZE(oneByte) = 1.
    SET-SIZE(fourBytes) = 4.
    self:READ(oneByte, 1, 1).
    if GET-BYTE(oneByte, 1) = {&MSG_HEADER_BEGIN} then 
    do:
        self:READ(fourBytes, 1, 4).
        requestId = GET-LONG(fourBytes, 1).
        if requestId > -1 then 
        do:
            self:READ(oneByte, 1, 1).
            if GET-BYTE(oneByte, 1) = {&MSG_HEADER_END} then 
            do:
                self:READ(oneByte, 1, 1).
                if GET-BYTE(oneByte, 1) = {&PACKET_BEGIN} then 
                do:
                    self:READ(fourBytes, 1, 4).
                    messageSize = GET-LONG(fourBytes, 1).
                    if messageSize > -1 then 
                    do:
                        SET-SIZE(theData) = messageSize.
                        ok = self:READ(theData, 1, messageSize, read-exact-num).
                        if ok = true then 
                        do:
                            self:READ(oneByte, 1, 1).
                            if GET-BYTE(oneByte, 1) = {&PACKET_END} then 
                            do:
                                self:READ(oneByte, 1, 1).
                                if GET-BYTE(oneByte, 1) = {&MSG_END} then 
                                do:
                                end.
                                else
                                    cError = "Message End Marker".              
                            end.
                            else
                                cError = "Packet End Marker".
                        end.
                        else
                            cError = "Failed to read all of message data".
                    end.
                    else
                        cError = "Packet Size".
                end.
                else
                    cError = "Packet Begin".
            end.
            else
                cError = "Message Header End".
        end.
        else
            cError = "Request Id".
    end.
    else
        cError = "Message Header Begin".
    
    define buffer CommandBuffer for ttCommand.
    
    if cError = "" then 
    do:
        create CommandBuffer.
        CommandBuffer.requestID = requestID.
        run extractCommand(input theData, buffer CommandBuffer) no-error. 
        if (error-status:error) then 
            cError = "ERROR:" + error-status:get-message(1).
    end.      
      
    SET-SIZE(fourBytes) = 0.
    SET-SIZE(oneByte) = 0.
    SET-SIZE(theData) = 0.  
    if cError <> "" then 
    do:
        run QUIT("Error: " + cError).
        if available CommandBuffer then
            delete CommandBuffer.
        return error cError.
    end.
    else 
    do:
        if CommandBuffer.name = "" then
        do:
            run WriteToSocket(CommandBuffer.RequestId, "") no-error.
        end.
        else do:
            run executeCmd(buffer CommandBuffer) no-error.
            delete CommandBuffer. 
            if error-status:error or return-value <> "" then
            do:
                run QUIT("Error: " + return-value).
                return error return-value.
            end.
        end.
    end.  
  
end procedure.

procedure executeCmd:
    define parameter buffer Command for ttCommand.
    
    define variable hTarget as handle    no-undo.
    define variable commandResult as longchar no-undo.
  
    run ClearReturnValue no-error.
    
    do on error undo, leave
        on stop undo, leave:
    
        if valid-handle(fLoggerHandle) then                                                
            log( "Request  " + string(requestId) + ": " + Command.Scope + ":" + Command.Name + "(" + Command.Parameters + ")"). 
    
        if Command.Scope <> "EXTERNAL" then 
        do:
            case Command.Scope:
                when "MTAPI" or 
                when "UNDEFINED" then 
                    hTarget = fAPIHandle.
                when "INTERNAL" then 
                    hTarget = this-procedure.
            end.
        
            /* backward compatibility with internal entry check  */ 
            if Command.Scope = "UNDEFINED"  
                and not can-do(hTarget:internal-entries, Command.Name) then
                assign hTarget = ?
                    Command.Scope = "EXTERNAL".
                  
        end. /* not external */
    
        if Command.Scope = "EXTERNAL" then
        do: 
            file-info:file-name = Command.Name.
            if file-info:full-pathname = ? 
                or (INDEX(file-info:file-type, "F") = 0 and INDEX(file-info:file-type, "M") = 0) then 
                Command.Name = SEARCH(cPDir + "_ide" + Command.Name + ".p").
        end. 
    
        run ClearReturnValue no-error.
           
        if valid-handle(hTarget) then 
        do: 
            do on error  undo,leave on stop undo,leave on endkey undo,leave on quit undo,leave:
              run value(Command.Name) in hTarget (Command.Parameters).
              run getOutput in hTarget(output commandResult).
            end.
        end.
        else if Command.Scope = "EXTERNAL" and Command.Name > "" then 
            do:
                do on error  undo,leave on stop undo,leave on endkey undo,leave on quit undo,leave:
                    if Command.ResultIsLongChar then do:
                        run value(Command.Name)(Command.Parameters, output commandResult).
                    end.
                    else do:
                        run value(Command.Name)(Command.Parameters).
                    end. 
                end.
                if not Command.ResultIsLongChar then
                    commandResult = return-value.      
            end.
        else 
        do:
            commandResult = "ERROR:FileNotFound".
        end.
    end.
    
    if commandResult = "" and (error-status:error or error-status:get-message(1) > "") then 
        commandResult = "ERROR:" + error-status:get-message(1).
 
    if valid-handle(fLoggerHandle) and length(commandResult) < 28000 then 
        log( "Response " + string(Command.requestid) + " : " + string(commandResult)).
  
    run WriteToSocket(Command.RequestId, commandResult) no-error.
  
    if error-status:error or return-value <> "" then
        return error return-value. 
end procedure.

procedure extractCommand:
    define input parameter requestData  as memptr    no-undo.
    define parameter buffer Command for ttCommand.
    
    define variable tlvCount as integer no-undo.
    define variable tlvType as integer no-undo.
    define variable tlvSize as integer no-undo.
    define variable tlvValue as character no-undo.
     
    define variable iPos    as integer no-undo init 1.
    define variable tlvEntry as integer no-undo.

    set-byte-order(requestData) = 3.
    
    run ClearReturnValue no-error.

    do on error undo, leave
        on stop undo, leave:
        iPos = 1.
     
        tlvCount = get-long(requestData, iPos).
        iPos = iPos + 4.
        
        do tlvEntry = 1 to tlvCount:
            tlvType = get-long(requestData, iPos).
            iPos = iPos + 4.
            tlvSize = get-long(requestData, iPos).
            iPos = iPos + 4.
            if (tlvSize > 0) then 
            do:
                tlvValue = GET-STRING(requestData, iPos, tlvSize).
                iPos = iPos + tlvSize.
            end.
            else do:
                tlvValue = "".
            end.
            
            case tlvType:
                when {&COMMAND_PROGRAM} then
                    Command.Name = tlvValue.
                when {&COMMAND_PARAMETERS} then
                    Command.Parameters = tlvValue.
                when {&COMMAND_SCOPE} then
                    Command.Scope = tlvValue.
                when {&COMMAND_USES_LONGCHAR} then do:
                    Command.ResultIsLongChar = logical(tlvValue).
                end.
            end case.
        end.
        
    end.   
end.

/*
*  This is here since it is the only way to clear the return value
*  and the error status flag.
*/
procedure ClearReturnValue:
    return "".
end.

/*
*  This terminates the infinite wait-for "close"
*  and cleans up
*/
procedure QUIT:
    define input parameter cPrm as character no-undo.
    
    /*
    for each ttServer:
        /* Don't add no-error here.  add destroyobject to servers */ 
        if valid-handle(ttServer.ServerHandle) then
            run destroyObject in ttServer.ServerHandle.
        delete ttServer.    
    end.
    */    

    if valid-handle(fSocketHandle) then 
    do:
        if fSocketHandle:connected() then 
        do:
            fSocketHandle:disconnect().
        end.    
    end.
    
    fSocketHandle = ?.
    if cPrm <> ? and LENGTH(cPrm) > 0 then
        log(cPrm).
    log("Quitting.").
    run CloseLogFile (input "").
  
    delete procedure fAPiHandle no-error. 
    apply "CLOSE" to this-procedure.
    return "TERMINATED.".
    
end procedure.

/* ************************  Function Implementations ***************** */
function log returns character 
    ( input msg as character).
    
    if VALID-HANDLE(fLoggerHandle) then 
    do:
    
        DYNAMIC-FUNCTION("log" in fLoggerHandle, msg).
    end.
    
end function.

/*
    start logging process and open the log file
*/
procedure OpenLogFile.

    define input parameter cPrm as character no-undo.
    
    define variable projectname as char no-undo.

    if VALID-HANDLE(fLoggerHandle) then 
    do:
        run CloseLogFile ("").
    end.
    
    run darest/_logger.p persistent set fLoggerHandle.
    run SetLogFile in fLoggerHandle (cPrm).
    run OpenLogFile in fLoggerHandle.
    publish "setLoggerHandle" from this-procedure(fLoggerHandle).
    log( "PATH=" + OS-GETENV("PATH")).
    log( "DLC=" + OS-GETENV("DLC")).
    log( "PROPATH=" + propath).
    log( "OEMMT_PORT=" + OS-GETENV("OEMMT_PORT")).
end procedure.

procedure CloseLogFile.
    define input parameter cPrm as character no-undo.
    if valid-handle(fLoggerHandle) then 
    do:
        run CloseLogFile in fLoggerHandle.
        delete object fLoggerHandle.
        fLoggerHandle = ?.
        publish "setLoggerHandle" from this-procedure(fLoggerHandle).
    end.
end procedure.

 