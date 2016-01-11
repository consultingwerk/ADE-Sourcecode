/* BaseSocket.cls

Licenced under The MIT License

Copyright (c) 2010 Julian Lyndon-Smith

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
routine-level on error undo, throw.

USING Progress.Lang.*.
USING com.dotr.socket.*.

CLASS com.dotr.socket.BaseSocket: 
  DEF EVENT DataReceived       SIGNATURE VOID (p_Object AS com.dotr.socket.BaseSocket,p_Message AS MEMPTR ).
  DEF EVENT SocketDisconnected SIGNATURE VOID (p_Object AS com.dotr.socket.BaseSocket).
  DEF EVENT TimedOut           SIGNATURE VOID (p_Object AS com.dotr.socket.BaseSocket).
  
  DEF VAR Helper1 AS HANDLE NO-UNDO.
  DEF VAR Socket1 AS HANDLE NO-UNDO.

  DEF VAR DeleteSocket AS LOGICAL NO-UNDO .
  DEF protected VAR ResponseComplete AS LOGICAL NO-UNDO.
    
  DEF PUBLIC PROPERTY Port      AS INT NO-UNDO GET . PRIVATE SET .
  DEF PUBLIC PROPERTY MaxLength AS INT INIT 0 NO-UNDO GET .  SET.
  
  DEF PUBLIC PROPERTY Host AS CHAR NO-UNDO GET . PRIVATE SET .
  
  DEF PUBLIC PROPERTY SSL       AS LOGICAL NO-UNDO GET . SET .
  
  DEF PUBLIC PROPERTY CONNECTED AS LOGICAL NO-UNDO 
    GET():
      RETURN Socket1:CONNECTED().
    END GET. PRIVATE SET .

/* ==========================================================================
   CONSTRUCTOR: create a new socket
   ==========================================================================*/ 

  CONSTRUCTOR PUBLIC BaseSocket (  ):
    CREATE SOCKET Socket1. /* create client handle */
    
    StartUp(). 
  END CONSTRUCTOR.

/* ==========================================================================
   CONSTRUCTOR: use an existing new socket (normally spawned by server socket 
                client connection
   ==========================================================================*/ 

  CONSTRUCTOR PUBLIC BaseSocket (p_Socket AS HANDLE):
    ASSIGN Socket1           = p_Socket /* use current client handle */
           Socket1:SENSITIVE = YES
           DeleteSocket      = YES /* this client socket has been created by a connection to a server socket. We need to clean up when the client disconnects */
           Host              = p_Socket:REMOTE-HOST
           Port              = p_Socket:REMOTE-PORT.

    THIS-OBJECT:StartUp().
    
    Socket1:SET-READ-RESPONSE-PROCEDURE("DataIn",helper1).
    
  END CONSTRUCTOR.

/* ==========================================================================
   DESTRUCTOR: cleanup                                      
   ==========================================================================*/
  DESTRUCTOR PUBLIC BaseSocket ( ):
    this-object:Disconnect().
    
    DELETE PROCEDURE Helper1 NO-ERROR.
    
    if DeleteSocket then
        delete object Socket1 no-error.
  END DESTRUCTOR.

/* ==========================================================================
   Connect: connect socket to host
   ==========================================================================*/ 
  
  METHOD PUBLIC LOGICAL Connect(p_Host AS CHAR,p_Port AS INT):
    ASSIGN Host              = p_Host
           Port              = p_Port.

    /* check for valid host and port */
    IF Host EQ "" OR Host EQ ? THEN RETURN ERROR "Invalid Host".
    
    IF Port LE 0  OR Port GT 65535 OR
       Port EQ ? THEN RETURN ERROR "Invalid Port".
       
    Socket1:SENSITIVE = YES.

    Socket1:SET-READ-RESPONSE-PROCEDURE("DataIn",helper1).
    
    Socket1:CONNECT(SUBSTITUTE("-H &1 -S &2 &3", 
                               Host, 
                               Port, 
                               IF SSL THEN "-ssl -nohostverify" 
                                      ELSE ""
                               )).
    RETURN YES.         
  END METHOD.  
  
/* ==========================================================================
   Disconnect: disconnect socket 
   ==========================================================================*/ 
  
  METHOD PUBLIC VOID Disconnect():
      if valid-handle(socket1) and 
         socket1:connected() then
        Socket1:DISCONNECT().
  END METHOD.

/* ==========================================================================
   StartUp: Initialise stuff
   ==========================================================================*/ 
  METHOD PRIVATE VOID StartUp():

    RUN com/dotr/socket/helper/BaseSocketHelper.p PERSISTENT SET Helper1 (THIS-OBJECT) . 
    
  END METHOD. 

/* ==========================================================================
   ReadData: read data from socket
   ==========================================================================*/ 
  METHOD PUBLIC LOGICAL ReadData():
    DEF VAR lv_bytesAvailable AS INT NO-UNDO. /* count of bytes to read this time */

    DEF VAR memData  AS MEMPTR NO-UNDO. /* memptr for reading from Socket */

    ASSIGN Socket1:SENSITIVE = NO. /* this is needed to stop the read trigger from firing whilst processing
                                         in theory this should not be needed, but after suggestions from Greg Higgins
                                         and experimentation it seems to be the "chicken soup" solution for sockets that
                                         READKEY PAUSE 0 is for other areas */
           lv_bytesAvailable = Socket1:GET-BYTES-AVAILABLE().
  
    IF lv_bytesAvailable EQ 0 THEN /* socket has disconnected. deal with it */
    DO:
      ResponseComplete = TRUE.
      ASSIGN Socket1:SENSITIVE = YES.
      IF THIS-OBJECT:DeleteSocket THEN DELETE OBJECT THIS-OBJECT. /* client has disconnected from server socket. Delete spawned socket class */
      RETURN YES.
    END. /* IF lv_bytesAvailable EQ 0  */
    IF MaxLength GT 0 THEN ASSIGN lv_bytesAvailable = MIN(MaxLength,lv_bytesAvailable). /* need to split it into "chunks" */
           
    SET-SIZE(memData) = lv_bytesAvailable. /* now set the proper size */

    Socket1:READ(memData,1,lv_bytesAvailable,READ-EXACT-NUM). /* read the bytes-available characters */

    DataReceived(memData).
    SET-SIZE(memData) = 0. /* clear memory */
    
    ResponseComplete = TRUE.
    Socket1:SENSITIVE = YES.
   
  END METHOD.

/* ==========================================================================
    MethodName
   ==========================================================================*/ 

  METHOD PROTECTED VOID DataReceived (p_memData AS MEMPTR):
    DataReceived:Publish(CAST(THIS-OBJECT,com.dotr.socket.BaseSocket),p_memData).
    SET-SIZE(p_memData) = 0.
  END METHOD.

/* ==========================================================================
   SocketDisconnected
   ==========================================================================*/ 

  METHOD PROTECTED VOID SocketDisconnected ():
    SocketDisconnected:Publish(CAST(THIS-OBJECT,com.dotr.socket.BaseSocket)).
  END METHOD.
  
/* ==========================================================================
   WriteData
   ==========================================================================*/ 
  
  METHOD PUBLIC VOID WriteData(p_Data AS LONGCHAR ):
    DEF VAR memData AS MEMPTR NO-UNDO.
 
    COPY-LOB FROM p_Data TO memData.
    
    WriteData(memData).
    
    SET-SIZE(memData) = 0.

    RETURN.
  END METHOD.

/* ==========================================================================
   WriteData
   ==========================================================================*/ 
  
  METHOD PUBLIC VOID WriteData(p_Data AS MEMPTR ):
    DEF VAR lv_Size    AS INT NO-UNDO. 
    DEF VAR lv_Written AS INT NO-UNDO.
    DEF VAR lv_Start   AS INT NO-UNDO.
    
    IF NOT Socket1:CONNECTED() THEN RETURN ERROR "Not Connected".

    /* this is needed to prevent other processes from writing to the socket until this write is complete */
    ASSIGN Socket1:SENSITIVE = NO. 
         
    ASSIGN lv_Size  = GET-SIZE(p_Data)
           lv_Start = 1. /* Start writing data from this position */
    
    DO WHILE lv_Size GT 0 :

      Socket1:WRITE(p_Data,lv_Start,lv_Size) . /* now write data to socket.  */
      
      ASSIGN lv_Start = Socket1:BYTES-WRITTEN. /* check to see how much got sent  */
      
      IF lv_Start EQ lv_Size THEN LEAVE. /* no need to check anything else. All was sent */
      
      ASSIGN lv_Start = Socket1:BYTES-WRITTEN + 1 /* calculate new starting position */
             lv_Size  = lv_Size - lv_Start + 1.               /* calculate new size of data to send */

    END. 

    SET-SIZE(p_Data) = 0. /* clear memory */
 
    ASSIGN Socket1:SENSITIVE = YES.
     
    RETURN .
  END METHOD.
  
  
  METHOD PUBLIC VOID WaitForResponse():
    wait-for read-response of Socket1. 
  END METHOD.

/* ==========================================================================
   WaitForResponse 
   use this when you don't have a WAIT-FOR in your session, like in an appserver. 
   ==========================================================================*/ 
  METHOD PUBLIC VOID WaitForResponse(INPUT timeout_seconds AS INTEGER):
      DEFINE VARIABLE readbuffer AS MEMPTR NO-UNDO.
      DEFINE VARIABLE filledbuffer AS MEMPTR NO-UNDO.
      DEFINE VARIABLE maxbytes AS INTEGER NO-UNDO INITIAL 8192.
      DEFINE VARIABLE readbytes AS INTEGER NO-UNDO.
      DEFINE VARIABLE remaining_seconds AS INTEGER NO-UNDO.
      DEFINE VARIABLE old_timeo AS CHARACTER NO-UNDO.       
      DEFINE VARIABLE starttime AS DATETIME-TZ NO-UNDO.
      
      ASSIGN ResponseComplete = FALSE
             maxbytes         = 0x2000 /* 8k */
             starttime        = now
             old_timeo        = socket1:GET-SOCKET-OPTION("SO-RCVTIMEO":U).
                   
      waitloop:
      DO WHILE (NOT ResponseComplete)
          on error undo, throw:
          remaining_seconds = (NOW - (starttime + timeout_seconds * 1000)) / 1000.

          IF timeout_seconds > 0 THEN 
             IF remaining_seconds <= 0 THEN DO:
                TimedOut:Publish(CAST(THIS-OBJECT,com.dotr.socket.BaseSocket)).
                LEAVE waitloop.
             END.
          
          IF NOT socket1:CONNECTED() THEN 
             LEAVE waitloop.
          
          /* get the largest number of bytes possible */
          set-size(readbuffer)=max(maxbytes,socket1:get-bytes-available()).
          
          socket1:SET-SOCKET-OPTION("SO-RCVTIMEO":U, STRING(MAXIMUM(1, remaining_seconds))).
          socket1:READ (readbuffer, 1, get-size(readbuffer), READ-AVAILABLE).
          readbytes = socket1:BYTES-READ.
          IF readbytes > 0 THEN DO:
             Socket1:SENSITIVE = NO.
             set-size(filledbuffer)= readbytes.
             put-bytes(filledbuffer,1)= GET-BYTES(readbuffer,1,readbytes).

             DataReceived(filledbuffer).

             Socket1:SENSITIVE = YES.
          END.
          else
            ResponseComplete = true.
             
          finally:
              /* the 2nd-last loop will allocate the space,
                 but the last loop will never deallocate it. */
              set-size(readbuffer) = 0.
              set-size(filledbuffer) = 0.
          end finally.            
      END.
      
      socket1:SET-SOCKET-OPTION("SO-RCVTIMEO":U, old_timeo).
  END METHOD.
    
END CLASS.