/* ServerSocket.cls

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

class com.dotr.socket.ServerSocket: 
  def public event MessageArrived signature void (p_Object as com.dotr.socket.MessageSocket,p_MessageGUID as char,p_Message as longchar).
  
  def public property PortNumber as int no-undo            get . set .
  def public property StartPort  as int no-undo init 40000 get . set .
  def public property EndPort    as int no-undo init 49999 get . set .

  def private var oServerSocket as handle no-undo.
  
  def protected var hHelper as handle no-undo.

	constructor public ServerSocket (  ):
		super ().
	  create server-socket 	oServerSocket.
	end constructor.

  destructor ServerSocket():
    if valid-handle(hHelper) then delete procedure hHelper no-error.
  end destructor. 
  
/*  =========================================================================
    StartServer: open a server socket on the first free port in the portrange 
    ==========================================================================*/ 

  method public logical StartServer():
    def var lv_i as int no-undo.
     
    def var lv_Port as char no-undo.
    
    if this-object:PortNumber gt 0 then return StartServer(this-object:PortNumber).
     
    do lv_i = this-object:StartPort to this-object:EndPort:
      if StartServer(lv_i) then return yes.
    end.

    return no.
  end method.
    
/*  =========================================================================
    StartServer
    This method starts a server socket on the supplied port
    ==========================================================================*/ 

    method public logical StartServer(p_Port as int):

     this-object:oServerSocket:enable-connections(substitute("-S &1",p_Port)) no-error.
     
     if error-status:num-messages gt 0 then return no.

     assign this-object:PortNumber = p_Port.
     
     run com/dotr/socket/helper/ServerSocketHelper.p persistent set hHelper (this-object).
     
     oServerSocket:set-connect-procedure("NewConnection",this-object:hHelper).
     
     return yes.
    end method.
    
/* ==========================================================================
   MessageArrived: message received from client
   ==========================================================================*/ 
  method public void MessageArrived(p_Object as com.dotr.socket.MessageSocket,p_messageGUID as char,p_Message as longchar):
    MessageArrived:publish(p_Object,p_MessageGUID,p_Message).
  end method.
      
end class.