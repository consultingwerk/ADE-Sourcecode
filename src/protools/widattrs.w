&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
/* Procedure Description
"Object Attribute Reference"
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File: widattrs.w

  Description: Object Attribute Reference
               Intended to be run persistently from Pro*Tools, but
               can be run directly


  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Tim Townsend

  Created: 6/1/99

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var dLastWindowHeight as decimal no-undo.
def var dLastWindowWidth  as decimal no-undo.
def var hList as widget-handle extent 3 no-undo.
def var hProc as handle no-undo.
def var hWin as handle no-undo.

def temp-table ttJunk
  field Junk1 as int.
def query qJunk for ttJunk.
def browse bJunk query qJunk
  display ttJunk.Junk1
  enable ttJunk.Junk1
  with 4 down.
def frame fJunk bJunk.

def stream sOut.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME fMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS cWidget vbWidHelp slRO slEvents slRW ~
vRWLabel vROLabel vEventLabel 
&Scoped-Define DISPLAYED-OBJECTS cWidget slRO slEvents slRW vRWLabel ~
vROLabel vEventLabel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON vbWidHelp 
     LABEL "Help" 
     SIZE 15 BY 1.

DEFINE VARIABLE cWidget AS CHARACTER FORMAT "X(40)":U 
     LABEL "Object" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 18
     LIST-ITEMS "Frame","Fill-in","Toggle-box","Combo-box","Radio-set","Slider","Editor","Text","Literal","Selection-list","Button","Image","Rectangle","Control-frame","Window","Field-group","Browse","Browse Column","Error-status","Compiler","File-info","Rcode-info","Session","Color-table","Procedure","Clipboard","Debugger","Last-event","Menu","Sub-menu","Menu-item (normal)","Menu-item (toggle)","Dialog-box","Server","Font-table" 
     DROP-DOWN-LIST
     SIZE 24 BY 1 NO-UNDO.

DEFINE VARIABLE vEventLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Events" 
      VIEW-AS TEXT 
     SIZE 32 BY .62 NO-UNDO.

DEFINE VARIABLE vROLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Read-only and Methods" 
      VIEW-AS TEXT 
     SIZE 32 BY .62 NO-UNDO.

DEFINE VARIABLE vRWLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Read/Write" 
      VIEW-AS TEXT 
     SIZE 32 BY .62 NO-UNDO.

DEFINE VARIABLE slEvents AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SORT SCROLLBAR-VERTICAL 
     SIZE 34 BY 16.19 NO-UNDO.

DEFINE VARIABLE slRO AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SORT SCROLLBAR-VERTICAL 
     SIZE 34 BY 16.19 NO-UNDO.

DEFINE VARIABLE slRW AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SORT SCROLLBAR-VERTICAL 
     SIZE 34 BY 16.19 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     cWidget AT ROW 1.48 COL 18 COLON-ALIGNED
     vbWidHelp AT ROW 1.48 COL 45
     slRO AT ROW 3.81 COL 38 NO-LABEL
     slEvents AT ROW 3.81 COL 74 NO-LABEL
     slRW AT ROW 3.86 COL 2 NO-LABEL
     vRWLabel AT ROW 3.14 COL 2 NO-LABEL
     vROLabel AT ROW 3.14 COL 38 NO-LABEL
     vEventLabel AT ROW 3.14 COL 74 NO-LABEL
     "(or double-click in any list)" VIEW-AS TEXT
          SIZE 33 BY .62 AT ROW 1.71 COL 61
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 108 BY 19.57.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Object Attribute Reference"
         HEIGHT             = 19.57
         WIDTH              = 108
         MAX-HEIGHT         = 19.57
         MAX-WIDTH          = 108
         VIRTUAL-HEIGHT     = 19.57
         VIRTUAL-WIDTH      = 108
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
                                                                        */
/* SETTINGS FOR FILL-IN vEventLabel IN FRAME fMain
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN vROLabel IN FRAME fMain
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN vRWLabel IN FRAME fMain
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Object Attribute Reference */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Object Attribute Reference */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-RESIZED OF C-Win /* Object Attribute Reference */
DO:
  def var lSuppressWarnings as logical no-undo.
  
  assign lSuppressWarnings         = session:suppress-warnings
         session:suppress-warnings = true

         /* vertical size */
         frame {&FRAME-NAME}:height-chars = 
         frame {&FRAME-NAME}:height-chars +
           (self:height-chars - dLastWindowHeight)
         dLastWindowHeight = self:height-chars
         slRW:height-chars = frame {&FRAME-NAME}:height-chars -
                             slRW:row + 0.5
         slRO:height-chars = frame {&FRAME-NAME}:height-chars -
                             slRO:row + 0.5
         slEvents:height-chars = frame {&FRAME-NAME}:height-chars -
                             slEvents:row + 0.5
                             
         /* horizontal size */
         frame {&FRAME-NAME}:width-chars = 
         frame {&FRAME-NAME}:width-chars +
           (self:width-chars - dLastWindowWidth)
         dLastWindowWidth     = self:width-chars
         slRW:width-chars     = (frame {&FRAME-NAME}:width-chars - 6) / 3
         slRO:column          = slRW:column + slRW:width-chars + 2
         slRO:width-chars     = slRW:width-chars
         slEvents:column      = slRO:column + slRO:width-chars + 2
         slEvents:width-chars = slRW:width-chars

         /* labels */
         vRWLabel:column         = slRW:column
         vROLabel:column         = slRO:column
         vEventLabel:column      = slEvents:column
         vRWLabel:width-chars    = slRW:width-chars
         vROLabel:width-chars    = slRO:width-chars
         vEventLabel:width-chars = slEvents:width-chars

         /* finish */
         frame {&FRAME-NAME}:scrollable = false
         self:scroll-bars               = false
         session:suppress-warnings      = lSuppressWarnings.
         
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fMain
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fMain C-Win
ON MOUSE-MENU-DBLCLICK OF FRAME fMain
DO:
  run DumpAllData.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cWidget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cWidget C-Win
ON VALUE-CHANGED OF cWidget IN FRAME fMain /* Object */
DO:
  run ShowLists(self:screen-value).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME slEvents
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL slEvents C-Win
ON DEFAULT-ACTION OF slEvents IN FRAME fMain
DO:
  RUN adecomm/_adehelp.p
      (INPUT "lgrf":U, 
       INPUT "PARTIAL-KEY":U, 
       INPUT ?, 
       INPUT self:screen-value).
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL slEvents C-Win
ON MOUSE-MENU-DBLCLICK OF slEvents IN FRAME fMain
DO:
  if self:screen-value > "" then
    message replace(list-widgets(self:screen-value),",","~r~n")
      view-as alert-box info button ok 
              title substitute("List of Widgets For &1 Event",self:screen-value).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME slRO
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL slRO C-Win
ON DEFAULT-ACTION OF slRO IN FRAME fMain
DO:
  RUN adecomm/_adehelp.p
      (INPUT "lgrf":U, 
       INPUT "PARTIAL-KEY":U, 
       INPUT ?, 
       INPUT self:screen-value).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME slRW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL slRW C-Win
ON DEFAULT-ACTION OF slRW IN FRAME fMain
DO:
  RUN adecomm/_adehelp.p
      (INPUT "lgrf":U, 
       INPUT "PARTIAL-KEY":U, 
       INPUT ?, 
       INPUT self:screen-value + " attribute").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME vbWidHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL vbWidHelp C-Win
ON CHOOSE OF vbWidHelp IN FRAME fMain /* Help */
DO:
  DEFINE VARIABLE cSearchKey AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWid       AS CHARACTER  NO-UNDO.

  ASSIGN
    cWid = trim(entry(1,cWidget:screen-value," "))
    cSearchKey = cWid + " " +
                (if can-do("clipboard,color-table,compiler,debugger,error-status,file-info,last-event,rcode-info,session,profiler",cWid)
                 then "system handle" else
                (if can-do("buffer,buffer-field,socket,transaction,x-document,x-noderef",cWid)
                 then "object handle" else
                (if can-do("procedure,server,web-context,temp-table,query,async-request",cWid)
                 then ""
                 else "widget"))).

  RUN adecomm/_adehelp.p
    (INPUT "lgrf":U, 
     INPUT "PARTIAL-KEY":U, 
     INPUT ?, 
     INPUT cSearchKey).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME vEventLabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL vEventLabel C-Win
ON MOUSE-SELECT-DBLCLICK OF vEventLabel IN FRAME fMain
DO:
  assign clipboard:value = replace(lc(slEvents:list-items),",","~r~n").  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME vROLabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL vROLabel C-Win
ON MOUSE-SELECT-DBLCLICK OF vROLabel IN FRAME fMain
DO:
  assign clipboard:value = replace(lc(slRO:list-items),",","~r~n").  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME vRWLabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL vRWLabel C-Win
ON MOUSE-SELECT-DBLCLICK OF vRWLabel IN FRAME fMain
DO:
  assign clipboard:value = replace(lc(slRW:list-items),",","~r~n").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */
/* see if already running */
if this-procedure:persistent then do:
  hProc = session:first-procedure.
  do while valid-handle(hProc):
    if hProc:file-name = this-procedure:file-name and
       valid-handle(hProc:current-window) then do:
      hWin = hProc:current-window.
      if hWin:window-state = window-minimized then
        hWin:window-state = window-normal.
      hWin:move-to-top().
      apply "entry" to hWin.
      delete procedure this-procedure.
      return.
    end.
    hProc = hProc:next-sibling.
  end.
end.

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}
       {&WINDOW-NAME}:max-width-chars = ?
       {&WINDOW-NAME}:min-width-chars = 95
       {&WINDOW-NAME}:max-height-chars = ?
       {&WINDOW-NAME}:min-height-chars = 8
       {&WINDOW-NAME}:title = {&WINDOW-NAME}:title + " - " + proversion
       dLastWindowHeight = {&WINDOW-NAME}:height-chars
       dLastWindowWidth  = {&WINDOW-NAME}:width-chars
       hList[1] = slRW:handle
       hList[2] = slRO:handle
       hList[3] = slEvents:handle.

&if decimal(substr(proversion,1,index(proversion,".") + 1)) >= 9 &then
  cWidget:add-last("Buffer"       + cWidget:delimiter +
                   "Buffer-field" + cWidget:delimiter +
                   "Profiler"     + cWidget:delimiter +
                   "Query"        + cWidget:delimiter +
                   "Web-context").
  &if decimal(substr(proversion,1,index(proversion,".") + 1)) >= 9.1 &then
    cWidget:add-last("Async-request"   + cWidget:delimiter +
                     "Server-Socket"   + cWidget:delimiter +
                     "Socket"          + cWidget:delimiter +
                     "Temp-table"      + cWidget:delimiter +
                     "Transaction"     + cWidget:delimiter +
                     "X-Document"      + cWidget:delimiter +
                     "X-Noderef").
  &endif
&endif

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
on close of this-procedure
do:
   put-key-value
     section "WidAttr"
     key     "ObjRef-Object"
     value   cWidget:screen-value in frame {&FRAME-NAME}.
   run disable_UI.
end.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

do with frame {&FRAME-NAME}:
  get-key-value
     section "WidAttr"
     key     "ObjRef-Object"
     value   cWidget.

  assign cWidget:inner-lines = min(30,max(1,cWidget:num-items))
         cWidget = cWidget:entry(1)
           when cWidget = ? or cWidget:lookup(cWidget) = 0.
  slRO:load-mouse-pointer("glove") no-error.
  slRW:load-mouse-pointer("glove") no-error.
  slEvents:load-mouse-pointer("glove") no-error.
end.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  apply "value-changed" to cWidget in frame {&FRAME-NAME}.
  apply "entry" to {&WINDOW-NAME}.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE focus cWidget in frame {&FRAME-NAME}.
END.

if program-name(2) = ? then quit.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DumpAllData C-Win 
PROCEDURE DumpAllData :
/*------------------------------------------------------------------------------
  Purpose:     This procedure dumps all attributes and events for all
               widget types to a file.  This file can then be parsed and
               compared with the file generated for a different Progress
               version to obtain  a list of all attributes and events added
               in between those versions.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def var iWidNo as int no-undo.
def var iListNo as int no-undo.
def var iItemNo as int no-undo.

do with frame {&FRAME-NAME}:
  session:set-wait-state("general").
  
  output stream sOut to value("attrs" + replace(proversion,".","") + ".txt").
  
  do iWidNo = 1 to cWidget:num-items:
    run ShowLists(cWidget:entry(iWidno)).

    do iListNo = 1 to 3:
      do iItemNo = 1 to hList[iListNo]:num-items:
        put stream sOut unformatted
          cWidget:entry(iWidNo) "~t"
          substr(hList[iListNo]:name,3) "~t"
          hList[iListNo]:entry(iItemNo) skip.
      end.  /* 1..? */
    end.  /* 1..3 */
  end.  /* 1..? */

  output stream sOut close.  
  apply "value-changed" to cWidget.
  
  session:set-wait-state("").
end.  /* do with frame */

return.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY cWidget slRO slEvents slRW vRWLabel vROLabel vEventLabel 
      WITH FRAME fMain IN WINDOW C-Win.
  ENABLE cWidget vbWidHelp slRO slEvents slRW vRWLabel vROLabel vEventLabel 
      WITH FRAME fMain IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE JunkProc C-Win 
PROCEDURE JunkProc :
/*------------------------------------------------------------------------------
  Purpose:     Empty procedure for getting async-request handle
  Notes:
------------------------------------------------------------------------------*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ShowLists C-Win 
PROCEDURE ShowLists :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  cWidType
  Notes:       
------------------------------------------------------------------------------*/
def input parameter cWidType as char.

def var hWid as handle no-undo.
def var i as int no-undo.
def var lDelIt as logical init no no-undo.

do with frame {&FRAME-NAME}:
  case cWidType:
    when "literal" then
      assign hWid = cWidget:side-label-handle.
    when "field-group" then
      assign hWid = frame {&FRAME-NAME}:current-iteration.
    when "clipboard" then
      assign hWid = clipboard:handle.
    when "color-table" then
      assign hWid = color-table:handle.
    when "compiler" then
      assign hWid = compiler:handle.
    when "debugger" then
      assign hWid = debugger:handle.
    when "error-status" then
      assign hWid = error-status:handle.
    when "file-info" then
      assign hWid = file-info:handle.
    when "font-table" then
      assign hWid = font-table:handle.
    when "last-event" then
      assign hWid = last-event:handle.
    when "rcode-info" then
      assign hWid = rcode-info:handle.
    when "session" then
      assign hWid = session:handle.
    when "procedure" then
      assign hWid = this-procedure.
    when "browse" then
      assign hWid = bJunk:handle in frame fJunk.
    when "browse column" then
      assign hWid = bJunk:handle in frame fJunk
             hWid = hWid:first-column.
    when "server" then
    do:
      create server hWid.
      assign lDelIt = true.
    end.
    when "menu-item (normal)" then
    do:
      create menu-item hWid.
      assign lDelIt = true.
    end.
    when "menu-item (toggle)" then
    do:
      create menu-item hWid
        assign toggle-box = true.
      assign lDelIt = true.
    end.
    &if decimal(substr(proversion,1,index(proversion,".") + 1)) >= 9 &then
      when "buffer" or when "buffer-field" then do:
        hWid = buffer ttJunk:handle.
        if cWidType = "buffer-field" then
          hWid = hWid:buffer-field(1).
      end.
      when "profiler" then do:
        hWid = profiler:handle.
      end.
      when "web-context" then do:
        hWid = web-context:handle.
      end.
      &if decimal(substr(proversion,1,index(proversion,".") + 1)) >= 9.1 &then
        when "transaction" then do:
          hWid = this-procedure:transaction.
        end.
        when "async-request" then do:
          run JunkProc on session asynchronous set hWid.
          lDelIt = true.
        end.
      &endif
    &endif
    otherwise
    do:
      create value(cWidType) hWid.
      assign lDelIt = true.
    end.
  end case.

  assign slRW:list-items     = list-set-attrs(hWid)
         /* some objects cause GPFs with some versions */
         slRO:list-items     = (if (proversion begins "8." and
                                    cWidType = "Server") then
                                "***Out of Order***" else
                                list-query-attrs(hWid))
         slEvents:list-items = list-events(hWid).

  /* remove all R/W attrs from R/O list */
  slRO:delete(slRW:list-items) no-error.

  if lDelIt then
    delete object hWid no-error.

end.  /* do with frame */

return.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

