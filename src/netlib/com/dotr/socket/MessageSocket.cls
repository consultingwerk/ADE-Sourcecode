/* MessageSocket.cls

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

using Progress.Lang.*.
using com.dotr.socket.BaseSocket.

class com.dotr.socket.MessageSocket inherits com.dotr.socket.BaseSocket: 
  def public event MessageArrived signature void (p_Object as com.dotr.socket.MessageSocket,p_MessageGUID as char,p_Message as longchar).
    
  def public property NumMessages   as int no-undo get . private set.

  def var MessageFragment as longchar no-undo.

  def public property StoreMessages as logical init no no-undo get . set .
  
  def var TerminatorLength as int no-undo.
    
  def public property Terminator as char no-undo get . 
    set(p_Terminator as char):
      assign TerminatorLength = length(p_Terminator,"RAW")
             Terminator       = p_Terminator.
    end set.
  
  def temp-table TTMessage no-undo
    field DateReceived as datetime
    field MessageGUID as char
    field MessageFragment as CLOB
    
    index MessageGUID 
      MessageGUID
      
    index ByDate is primary
      DateReceived.
    
/* ==========================================================================
   CONSTRUCTOR: create a new socket
   ==========================================================================*/ 

  constructor public MessageSocket (  ):
    super().
    assign Terminator = "~r~n".
  end constructor.
  
/* ==========================================================================
   CONSTRUCTOR: create a new socket
   ==========================================================================*/ 
  constructor public MessageSocket (p_Socket as handle):
    super(p_Socket).
    assign Terminator = "~r~n".    
  end constructor.

/* ==========================================================================
   DESTRUCTOR: cleanup                                      
   ==========================================================================*/
  destructor public MessageSocket ( ):
    empty temp-table TTMessage.
  end destructor.

/* ==========================================================================
   NewMessage: Store received message
   ==========================================================================*/ 

  method private void PublishMessage(p_Message as longchar):
    def var lv_MessageGUID as char init "[]" no-undo.
    
    if StoreMessages then
    do:
      create TTMessage.
    
      assign TTMessage.DateReceived    = now
             TTMessage.MessageFragment = p_message
             TTMessage.MessageGUID     = guid(generate-uuid). 
    end.
    
    MessageArrived:Publish(this-object,lv_MessageGUID,p_Message).
    return.           
  end method.
  
/* ==========================================================================
   ConsumeMessage: get and remove specific message
   ==========================================================================*/ 

  method public longchar ConsumeMessage(p_MessageGUID as char):
    return GetMessage(p_MessageGUID,yes).
  end.

/* ==========================================================================
   GetMessage: get first message
   ==========================================================================*/ 

  method public longchar GetMessage(p_MessageGUID as char):
    return GetMessage(p_MessageGUID ,no).
  end.

/* ==========================================================================
   ConsumeMessage: get and remove first message
   ==========================================================================*/ 

  method public longchar ConsumeMessage():
    return GetMessage(yes).
  end.

/* ==========================================================================
   GetMessage: get specific message
   ==========================================================================*/ 

  method public longchar GetMessage():
    return GetMessage(no).
  end.

/* ==========================================================================
   GetMessage: get oldest message
   ==========================================================================*/ 

  method private longchar GetMessage(p_consume as logical):
    def var lv_message as longchar no-undo.
    
    for first TTMessage no-lock by TTMessage.DateReceived: 
      assign lv_message = TTMessage.MessageFragment.
    
      if p_Consume then 
      do:
        delete TTMessage.
        assign NumMessages   = NumMessages - 1. 
      end.
    end.
        
    if lv_message eq "" then return error "No Message Found".
    return lv_message.
  end method.

/* ==========================================================================
   GetMessage: get specified message
   ==========================================================================*/ 

  method private longchar GetMessage(p_messageGUID as char,p_consume as logical):
    def var lv_message as longchar no-undo.
    
    for first TTMessage no-lock where TTMessage.MessageGUID eq p_MessageGUID: 
      assign lv_message = TTMessage.MessageFragment.
    
      if p_Consume then 
      do:
        delete TTMessage.
        assign NumMessages   = NumMessages - 1. 
      end.
    end.
        
    if lv_message eq "" then return error "No Message Found".
    return lv_message.
  end method.

/* ==========================================================================
   ConsumeAllMessages: get and remove all messages
   ==========================================================================*/ 

  method public longchar ConsumeAllMessages():
    return GetAllMessages(yes).
  end method.

/* ==========================================================================
   GetAllMessages: get all messages
   ==========================================================================*/ 

  method public longchar GetAllMessages():
    return GetAllMessages(no).
  end method.

/* ==========================================================================
   GetAllMessages: get all messages
   ==========================================================================*/ 

  method private longchar GetAllMessages(p_consume as logical):
    def var lv_data as longchar no-undo.
    
    temp-table TTMessage:WRITE-XML("longchar",lv_Data,yes).
    
    if p_Consume then
    do:
      empty temp-table TTMessage.
      assign NumMessages = 0.
    end.
    
    return lv_Data.
  end method.

/* ==========================================================================
   RemoveAllMessages: removes all messages
   ==========================================================================*/ 

  method public void RemoveAllMessages():
    empty temp-table TTMessage.
    assign NumMessages   = 0.
  end method.
     
/* ==========================================================================
   SendMessage
   ==========================================================================*/ 
  
  method public void SendMessage(p_Data as longchar):
    WriteData(p_Data + Terminator).
  end method.

/* ==========================================================================
   SocketDisconnected
   ==========================================================================*/ 

  method override void SocketDisconnected ():
    MessageArrived:Publish(this-object,"[INFO]","Disconnected").
  end method.
  
/* ==========================================================================
   DataReceived
   ==========================================================================*/ 

  method override void DataReceived (p_Data as memptr):
  
    def var lv_messageEnd as int no-undo.
    
    def var lv_Message as longchar no-undo.
  
    assign MessageFragment = MessageFragment + GET-STRING(p_Data,1) /* build up the inbound data string */
           lv_MessageEnd   = index(MessageFragment,Terminator) - 1.  /* check for a complete message */
                   
    do while lv_MessageEnd ge 0: /* we have at least one complete message */
      if lv_messageEnd eq 0 then assign lv_message = "". /* we have a null ("") message */
      
      else copy-lob from MessageFragment starting at 1 for lv_MessageEnd to lv_message.       /* get complete message (excluding terminator) */
         
      SUBSTR(MessageFragment,1,lv_MessageEnd + TerminatorLength) = "". /* clear message from global pile */
      
      assign lv_MessageEnd  = index(MessageFragment,Terminator) - 1. /* try to find next complete message */ 
                 
      PublishMessage(lv_Message). /* process new message */
    end.

    /* now see if we have exceeded a max length. If so, post the message regardless of a "complete" message or not */
    if MaxLength gt 0 and LENGTH(MessageFragment,"RAW") gt MaxLength then 
    do:
      /* get max chunk */
      copy-lob from MessageFragment starting at 1 for MaxLength to lv_message.
             
      /* clear chunk from global pile */
      SUBSTR(MessageFragment,1,MaxLength) = "".

      PublishMessage(lv_Message). /* process new message */
    end.
    
    finally: 
      set-size(p_Data) = 0. /* clear memory */
    end finally.

  end method.

end class.