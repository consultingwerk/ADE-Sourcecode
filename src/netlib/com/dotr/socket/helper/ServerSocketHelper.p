/* ServerSocketHelper.p

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

def input parameter p_ServerSocket as class com.dotr.socket.ServerSocket no-undo.

/* oh, this is so bloody stupid. Why can't we use classes for socket handling ?? */

procedure NewConnection:
  def input parameter p_Socket as handle no-undo. /* socket of new connected client */
  
  def var oMessageSocket as class com.dotr.socket.MessageSocket no-undo.
  
  if not valid-handle(p_Socket) then return. /* check, just in case */

  oMessageSocket = new com.dotr.socket.MessageSocket(p_Socket).
  
  oMessageSocket:MessageArrived:SUBSCRIBE(p_ServerSocket:MessageArrived).
  
  p_ServerSocket:MessageArrived(oMessageSocket,"[INFO]","Client Connected").

  process events.
 end procedure.