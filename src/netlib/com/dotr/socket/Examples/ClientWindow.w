&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/* ClientWindow.w

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

create widget-pool.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var oClient as com.dotr.socket.MessageSocket no-undo.

def var NumSent as int no-undo.
def var NumAck  as int no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 fillin_Host fillin_Port ~
ButtonConnect fillin_Message fillin_NumMessages SendButton EDITOR-1 
&Scoped-Define DISPLAYED-OBJECTS fillin_Host fillin_Port fillin_Message ~
fillin_NumMessages EDITOR-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
define var C-Win as widget-handle no-undo.

/* Definitions of the field level widgets                               */
define button ButtonConnect 
     label "&Connect" 
     size 15 by 1.14.

define button SendButton 
     label "&Send" 
     size 15 by 1.14.

define variable EDITOR-1 as character 
     view-as editor scrollbar-vertical large
     size 76 by 10.95 no-undo.

define variable fillin_Host as character format "X(256)":U initial "127.0.0.1" 
     label "&Host" 
     view-as fill-in 
     size 25 by 1 no-undo.

define variable fillin_Message as character format "X(256)":U 
     label "&Message" 
     view-as fill-in 
     size 33 by 1 no-undo.

define variable fillin_NumMessages as integer format ">>>>9":U initial 1 
     label "&Times" 
     view-as fill-in 
     size 9 by 1 no-undo.

define variable fillin_Port as integer format ">>>>9":U initial 56789 
     label "&Port" 
     view-as fill-in 
     size 14 by 1 no-undo.

define rectangle RECT-1
     edge-pixels 2 graphic-edge  no-fill   
     size 80 by 13.33.

define rectangle RECT-2
     edge-pixels 2 graphic-edge  no-fill   
     size 80 by 1.91.


/* ************************  Frame Definitions  *********************** */

define frame DEFAULT-FRAME
     fillin_Host at row 1.95 col 12 colon-aligned widget-id 6
     fillin_Port at row 1.95 col 47 colon-aligned widget-id 8
     ButtonConnect at row 1.95 col 65 widget-id 10
     fillin_Message at row 4.1 col 12 colon-aligned
     fillin_NumMessages at row 4.1 col 52 colon-aligned widget-id 12
     SendButton at row 4.1 col 65
     EDITOR-1 at row 5.52 col 5 no-label
     RECT-1 at row 3.62 col 3 widget-id 2
     RECT-2 at row 1.48 col 3 widget-id 4
    with 1 down no-box keep-tab-order overlay 
         side-labels no-underline three-d 
         at col 1 row 1
         size 84.2 by 16.38.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
if session:display-type = "GUI":U then
  create window C-Win assign
         hidden             = yes
         title              = "ClientWindow"
         height             = 16.48
         width              = 84.8
         max-height         = 23.91
         max-width          = 116.2
         virtual-height     = 23.91
         virtual-width      = 116.2
         resize             = yes
         scroll-bars        = no
         status-area        = no
         bgcolor            = ?
         fgcolor            = ?
         keep-frame-z-order = yes
         three-d            = yes
         message-area       = no
         sensitive          = yes.
else {&WINDOW-NAME} = current-window.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
assign 
       EDITOR-1:READ-ONLY in frame DEFAULT-FRAME        = true.

if session:display-type = "GUI":U and VALID-HANDLE(C-Win)
then C-Win:hidden = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
on end-error of C-Win /* ClientWindow */
or endkey of {&WINDOW-NAME} anywhere do:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  if this-procedure:persistent then return no-apply.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
on window-close of C-Win /* ClientWindow */
do:
  /* This event will close the window and terminate the procedure.  */
  apply "CLOSE":U to this-procedure.
  return no-apply.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ButtonConnect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ButtonConnect C-Win
on choose of ButtonConnect in frame DEFAULT-FRAME /* Connect */
do:
  assign fillin_host fillin_Port .
  
  oClient:CONNECT(fillin_Host,fillin_Port).  
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME SendButton
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SendButton C-Win
on choose of SendButton in frame DEFAULT-FRAME /* Send */
do:
  def var i as int no-undo.
  def var b as char no-undo.
  
  assign fillin_host fillin_Port fillin_Message fillin_NumMessages.
  
  do i = 1 to fillin_NumMessages:
    process events.
    assign b = "client " + string(time,"hh:mm:ss").
    
    if not oClient:Connected then oClient:CONNECT(fillin_Host,fillin_Port).
    
    oClient:SendMessage(string(i) + "->" + fillin_message).
    
    
    assign NumSent = NumSent + 1.
    
    assign {&WINDOW-NAME}:TITLE = substitute("&1: Sent:&2 Ack:&3",now,NumSent,NumAck).
  end. 
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
assign CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

oClient = new com.dotr.socket.MessageSocket().

oClient:MessageArrived:SUBSCRIBE("MessageArrived").

procedure MessageArrived:
    def input parameter p_socket as class com.dotr.socket.MessageSocket no-undo.
    def input parameter p_messageGUID as char no-undo.
    def input parameter p_message as longchar no-undo.

    editor-1:INSERT-STRING(string(p_message) + "~n") in frame {&frame-name}.
    
    if p_message eq "ACK" then assign NumAck = NumAck + 1.
    
    assign {&WINDOW-NAME}:title = substitute("&1: Sent:&2 Ack:&3",now,NumSent,NumAck).
    

end procedure.


/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
on close of this-procedure 
do:
   
 oClient:disconnect().
  
  delete object oClient.
  run disable_UI.
 end.

/* Best default for GUI applications is...                              */
pause 0 before-hide.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
do on error   undo MAIN-BLOCK, leave MAIN-BLOCK 
   on end-key undo MAIN-BLOCK, leave MAIN-BLOCK:
  run enable_UI.
  if not this-procedure:persistent then
    wait-for close of this-procedure.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
procedure disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  if session:display-type = "GUI":U and VALID-HANDLE(C-Win)
  then delete widget C-Win.
  if this-procedure:persistent then delete procedure this-procedure.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
procedure enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  display fillin_Host fillin_Port fillin_Message fillin_NumMessages EDITOR-1 
      with frame DEFAULT-FRAME in window C-Win.
  enable RECT-1 RECT-2 fillin_Host fillin_Port ButtonConnect fillin_Message 
         fillin_NumMessages SendButton EDITOR-1 
      with frame DEFAULT-FRAME in window C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  view C-Win.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

