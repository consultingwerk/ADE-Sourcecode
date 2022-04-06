&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r12 WebTool
/* Maps: HTML */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM Definitions 
/*********************************************************************
* Copyright (C) 2000,2017 by Progress Software Corporation. All      *
* rights reserved. Prior versions of this work may contain portions  *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
  File: _vstinfo.w
  
  Description: List the Virtual System Tables statistics for DICTDB.

  Fields:
    html   = Name of information to display.
    report = Name of report to generate

  Author:  Wm. T. Wood
  Updated: 08/05/97 wood    Initial version
           06/18/01 adams   Check for no database connection.  This is
                            called from webtools/vstinfo.w.
           07/07/17 rkumar  Use _dbparms instead of _Startup VST in 12.0 
------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed Workshop.           */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE perMinute AS INTEGER NO-UNDO.

/* Preprocessor Definitions ---                                         */
&SCOPED-DEFINE VSTINFO-TITLE Virtual System Tables
&SCOPED-DEFINE ACTIVITY-COLUMN-LABELS "Total" AT 25 "Per Min" AT 37 "Per Sec" AT 47 "Per Tx" AT 57  
&SCOPED-DEFINE BIG-DECIMAL FORMAT ">>>,>>>,>>9.99"
&ANALYZE-RESUME
&ANALYZE-SUSPEND _PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&SCOPED-DEFINE PROCEDURE-TYPE WebTool


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&ANALYZE-RESUME


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _INCLUDED-LIBRARIES
/* Standard WebTool Included Libraries --  */
{ webtools/webtool.i }
&ANALYZE-RESUME _END-INCLUDED-LIBRARIES

&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM "Main Code Block" 

/* ************************  Main Code Block  *********************** */

/* Process the latest WEB event. */
RUN process-web-request.
&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE output-error-page 
PROCEDURE output-error-page :
/*------------------------------------------------------------------------------
  Purpose:     Output a simple page showing the error for this file. That is,
               the requested report has not been implemented.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Output the web object file information. */
  {&OUT}
    { webtools/html.i &SEGMENTS = "head,open-body,title-line"
                      &FRAME    = "WS_main"
                      &AUTHOR   = "Wm.T.Wood"
                      &TITLE    = "{&VSTINFO-TITLE}" 
                      &CONTEXT  = "{&Vstinfo_Messages_Help}" }
     'This feature not yet implemented.'
    '</BODY>~n'
    '</HTML>~n'
    .

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE output-frameset 
PROCEDURE output-frameset :
/*------------------------------------------------------------------------------
  Purpose:     Output the "Frameset" html page.
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
 {&OUT}
   { webtools/html.i  &SEGMENTS = "head"
                      &FRAME    = "WS_main"
                      &AUTHOR   = "Wm.T.Wood"
                      &TITLE    = "{&VSTINFO-TITLE}" }
   '<FRAMESET COLS="160,*">~n'
   '     <FRAME NAME="WSVST_index" SRC="util/_vstinfo.w?html=Menu"~n'
   '                 FRAMEBORDER=yes MARGINHEIGHT=0 MARGINWIDTH=0>~n'
   '     <FRAME NAME="WSVST_main" SRC="util/_vstinfo.w?html=report&report=DbStatus"~n'
   '            FRAMEBORDER=yes MARGINHEIGHT=5 MARGINWIDTH=10>~n'
   '</FRAMESET>~n'
   '<NOFRAME>~n'
   '<H1>WebSpeed Workshop</H1>~n'
   'This page can be displayed with a frame enabled browser.~n'
   '</NOFRAME>~n'
   '</HTML>~n'
   .

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE output-menu 
PROCEDURE output-menu :
/*------------------------------------------------------------------------------
  Purpose:     Output the menu of VST options.  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE link AS CHARACTER NO-UNDO
    INITIAL '&&nbsp~;&&nbsp~;<A HREF="_vstinfo.w?html=Report&&amp~;Report=&1">&2</A><BR>~n'.

  /* Output the header and scripts for the Workshop main window. */
  {&OUT}
    { webtools/html.i  &SEGMENTS = "head,open-body"
                       &FRAME    = "WS_index"
                       &AUTHOR   = "Wm.T.Wood"
                       &TITLE    = "{&VSTINFO-TITLE}"
                       &TARGET   = "WSVST_main" }
    '<B>Status --</B><BR>~n'
    SUBSTITUTE (link, "TwoPhaseCommit":U, "2-Phase&nbsp~;Commit")
    SUBSTITUTE (link, "AILog":U, "AI&nbsp~;Log")
    SUBSTITUTE (link, "Backup":U, "Backup")
    SUBSTITUTE (link, "BILog":U, "BI&nbsp~;Log")
    SUBSTITUTE (link, "Buffers":U, "Buffers")
    SUBSTITUTE (link, "DbStatus":U, "Database")
    SUBSTITUTE (link, "FileList":U, "Files")
    SUBSTITUTE (link, "Logging":U, "Logging")
    SUBSTITUTE (link, "Servers":U, "Servers")
    SUBSTITUTE (link, "Segments":U, "Shared Memory")

    '<BR><B>Locks -- </B><BR>~n'
    SUBSTITUTE (link, "Locks":U, "All Locks")
    SUBSTITUTE (link, "UserLocks":U, "By User")

    '<BR><B>Activity -- </B><BR>~n'
    SUBSTITUTE (link, "ActAiLog":U, "AI&nbsp~;Log")
    SUBSTITUTE (link, "ActBiLog":U, "BI&nbsp~;Log")
    SUBSTITUTE (link, "ActBuffers":U, "Buffer&nbsp~;Cache")
    SUBSTITUTE (link, "ActIOFile":U, "I/O&nbsp~;Ops.&nbsp~;(by&nbsp~;File)")
    SUBSTITUTE (link, "ActIOType":U, "I/O&nbsp~;Ops.&nbsp~;(by&nbsp~;Type)")
    SUBSTITUTE (link, "ActIndex":U, "Index")
    SUBSTITUTE (link, "ActLock":U, "Lock&nbsp~;Table")
    SUBSTITUTE (link, "ActOther":U, "Other")
    SUBSTITUTE (link, "ActPWs":U, "Page&nbsp~;Writers")
    SUBSTITUTE (link, "ActRecord":U, "Record")
    SUBSTITUTE (link, "ActServer":U, "Server")
    SUBSTITUTE (link, "ActSpace":U, "Space&nbsp~;Allocation")
    SUBSTITUTE (link, "ActSummary":U, "Summary")

    '<BR><B>Clients --</B><BR>~n'
    SUBSTITUTE (link, "ActiveProcesses":U, "Active&nbsp~;Transactions")
    SUBSTITUTE (link, "AllProcesses":U, "All&nbsp~;Processes")
    SUBSTITUTE (link, "BackgroundProcesses":U, "Background")
    SUBSTITUTE (link, "BlockedProcesses":U, "Blocked&nbsp~;Clients")
    SUBSTITUTE (link, "BatchProcesses":U, "Local&nbsp~;Batch")
    SUBSTITUTE (link, "InteractiveProcesses":U, "Local&nbsp~;Interactive")
    SUBSTITUTE (link, "RemoteProcesses":U, "Remote&nbsp~;Clients")

    '<BR><B>Other -- </B><BR>~n'
    SUBSTITUTE (link, "Checkpoints":U, "Checkpoints")
    SUBSTITUTE (link, "LockReq":U, "Lock&nbsp~;Requests")
    SUBSTITUTE (link, "StartupParameters":U, "Startup&nbsp~;Parameters")
    
    '&nbsp~;<BR>'
    '</body>~n'
    '</HTML>~n'
    .
 
END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE process-web-request 
PROCEDURE process-web-request :
/*------------------------------------------------------------------------------
  Purpose:     Process the web request.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE c_html   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c_report AS CHARACTER NO-UNDO.
  DEFINE VARIABLE sections AS CHARACTER NO-UNDO.

  /* Output the MIME header. */
  RUN outputContentType IN web-utilities-hdl ("text/html":U).

  /* See what page to output. */
  CASE get-value("html":U):
    WHEN "":U       THEN RUN output-frameset.
    WHEN "Menu":U   THEN RUN output-menu.
    WHEN "Report":U THEN DO:   
      /* Get the name of the report we are to return. This is off the form
         "show-XXXX" where XXXX is the name of the html sub-page we are
         returning. */
      c_report = "show-":U + get-value("report":U).
      /* Does this report exist? */
      IF THIS-PROCEDURE:GET-SIGNATURE (c_report) eq '':U
      THEN RUN output-error-page.
      ELSE DO: 
        RUN VALUE( c_report ) IN THIS-PROCEDURE.
        {&OUT} '~n</BODY>~n</HTML>~n'.
      END.
    END. /* When "Report"... */
    OTHERWISE RUN output-error-page.
  END.

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE report-head 
PROCEDURE report-head :
/*------------------------------------------------------------------------------
  Purpose:     Output a standard report HTML page header
  Parameters:  p_title: The title line
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_title AS CHAR NO-UNDO.
  
  /* Set up for default reports. */
  ASSIGN 
    WEB-CONTEXT:HTML-HEADER-BEGIN = "<PRE><B>"
    WEB-CONTEXT:HTML-HEADER-END   = "</B></PRE>".

  /* Create the HTML form. */
  {&OUT}
    {webtools/html.i
      &SEGMENTS = "head,open-body,title-line"
      &AUTHOR   = "Wm.T.Wood"
      &TITLE    = "{&VSTINFO-TITLE}"
      &FRAME    = "WS_main"
      &CONTEXT  = "{&WebTools_VSTables_Help}" }
  '<TABLE BORDER="0" WIDTH="100%">~n'
  '<TR>~n' 
  '  <TD VALIGN="TOP">' html-encode(STRING(TODAY)) '</TD>~n' 
  '  <TD ALIGN="CENTER" VALIGN="TOP">' format-text(html-encode(p_title), "H2":U) '</TD>~n' 
  '  <TD ALIGN="RIGHT" VALIGN="TOP">'  html-encode(STRING(TIME,"hh:mm:ss am")) '</TD>~n' 
  '</TR>~n'
  '</TABLE>'
  .
END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE show-ActAiLog 
PROCEDURE show-ActAiLog :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN report-head ("Activity: AI Log").

  FOR EACH _ActAiLog NO-LOCK:
    perMinute = _AiLog-UpTime / 60.
    {&display} SKIP(1)
           {&ACTIVITY-COLUMN-LABELS}
            SKIP(1)
            _AiLog-UpTime      LABEL "Database Up Time"       COLON 23
            _AiLog-TotWrites   LABEL "Total AI writes"        COLON 23
            _AiLog-TotWrites / perMinute     NO-LABEL         AT 37
            _AiLog-TotWrites / _AiLog-UpTime NO-LABEL         AT 47
            _AiLog-TotWrites / _AiLog-Trans  NO-LABEL         AT 57
            _AiLog-AIWWrites   LABEL "AIW AI writes"          COLON 23
            _AiLog-AIWWrites / perMinute     NO-LABEL         AT 37
            _AiLog-AIWWrites / _AiLog-UpTime NO-LABEL         AT 47
            _AiLog-AIWWrites / _AiLog-Trans  NO-LABEL         AT 57
            _AiLog-RecWriten   LABEL "Records written"        COLON 23
            _AiLog-RecWriten / perMinute     NO-LABEL         AT 37
            _AiLog-RecWriten / _AiLog-UpTime NO-LABEL         AT 47
            _AiLog-RecWriten / _AiLog-Trans  NO-LABEL         AT 57
            _AiLog-BytesWritn  LABEL "Bytes written"          COLON 23
            _AiLog-BytesWritn / perMinute     NO-LABEL        AT 37
            _AiLog-BytesWritn / _AiLog-UpTime NO-LABEL        AT 47
            _AiLog-BytesWritn / _AiLog-Trans  NO-LABEL        AT 57 {&BIG-DECIMAL}
            _AiLog-BBuffWaits  LABEL "Busy buffer waits"      COLON 23
            _AiLog-BBuffWaits / perMinute     NO-LABEL        AT 37
            _AiLog-BBuffWaits / _AiLog-UpTime NO-LABEL        AT 47
            _AiLog-BBuffWaits / _AiLog-Trans  NO-LABEL        AT 57
            _AiLog-NoBufAvail  LABEL "Buffer not avail"       COLON 23
            _AiLog-NoBufAvail / perMinute     NO-LABEL        AT 37
            _AiLog-NoBufAvail / _AiLog-UpTime NO-LABEL        AT 47
            _AiLog-NoBufAvail / _AiLog-Trans  NO-LABEL        AT 57
            _AiLog-PartialWrt  LABEL "Partial writes"         COLON 23
            _AiLog-PartialWrt / perMinute     NO-LABEL        AT 37
            _AiLog-PartialWrt / _AiLog-UpTime NO-LABEL        AT 47
            _AiLog-PartialWrt / _AiLog-Trans  NO-LABEL        AT 57
            _AiLog-ForceWaits  LABEL "Log force waits"        COLON 23
            _AiLog-ForceWaits / perMinute     NO-LABEL        AT 37
            _AiLog-ForceWaits / _AiLog-UpTime NO-LABEL        AT 47
            _AiLog-ForceWaits / _AiLog-Trans  NO-LABEL        AT 57

            with frame Act-AiLog-frame
                 side-labels.
  end.


END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE show-ActBiLog 
PROCEDURE show-ActBiLog :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN report-head ("Activity: BI Log").

  FOR EACH _ActBiLog NO-LOCK:
    perMinute = _BiLog-UpTime / 60.
    {&display} SKIP(1)
            {&ACTIVITY-COLUMN-LABELS}
            SKIP(1)
            _BiLog-UpTime      LABEL "Database Up Time"       COLON 23
            _BiLog-TotalWrts   LABEL "Total BI writes"        COLON 23
            _BiLog-TotalWrts / perMinute     NO-LABEL         AT 37
            _BiLog-TotalWrts / _BiLog-UpTime NO-LABEL         AT 47
            _BiLog-TotalWrts / _BiLog-Trans  NO-LABEL         AT 57
            _BiLog-BIWWrites   LABEL "BIW BI writes"          COLON 23
            _BiLog-BIWWrites / perMinute     NO-LABEL         AT 37
            _BiLog-BIWWrites / _BiLog-UpTime NO-LABEL         AT 47
            _BiLog-BIWWrites / _BiLog-Trans  NO-LABEL         AT 57
            _BiLog-RecWriten   LABEL "Records written"        COLON 23
            _BiLog-RecWriten / perMinute     NO-LABEL         AT 37
            _BiLog-RecWriten / _BiLog-UpTime NO-LABEL         AT 47
            _BiLog-RecWriten / _BiLog-Trans  NO-LABEL         AT 57
            _BiLog-BytesWrtn   LABEL "Bytes written"          COLON 23
            _BiLog-BytesWrtn / perMinute     NO-LABEL         AT 37
            _BiLog-BytesWrtn / _BiLog-UpTime NO-LABEL         AT 47
            _BiLog-BytesWrtn / _BiLog-Trans  NO-LABEL         AT 57 {&BIG-DECIMAL}
            _BiLog-TotReads    LABEL "Total BI Reads"         COLON 23
            _BiLog-TotReads / perMinute     NO-LABEL          AT 37
            _BiLog-TotReads / _BiLog-UpTime NO-LABEL          AT 47
            _BiLog-TotReads / _BiLog-Trans  NO-LABEL          AT 57
            _BiLog-RecRead     LABEL "Records read"           COLON 23
            _BiLog-RecRead / perMinute     NO-LABEL           AT 37
            _BiLog-RecRead / _BiLog-UpTime NO-LABEL           AT 47
            _BiLog-RecRead / _BiLog-Trans  NO-LABEL           AT 57
            _BiLog-BytesRead   LABEL "Bytes read"             COLON 23
            _BiLog-BytesRead / perMinute     NO-LABEL         AT 37
            _BiLog-BytesRead / _BiLog-UpTime NO-LABEL         AT 47
            _BiLog-BytesRead / _BiLog-Trans  NO-LABEL         AT 57 {&BIG-DECIMAL}
            _BiLog-ClstrClose  LABEL "Clusters closed"        COLON 23
            _BiLog-ClstrClose / perMinute     NO-LABEL        AT 37
            _BiLog-ClstrClose / _BiLog-UpTime NO-LABEL        AT 47
            _BiLog-ClstrClose / _BiLog-Trans  NO-LABEL        AT 57
            _BiLog-BBuffWaits  LABEL "Busy buffer waits"      COLON 23
            _BiLog-BBuffWaits / perMinute     NO-LABEL        AT 37
            _BiLog-BBuffWaits / _BiLog-UpTime NO-LABEL        AT 47
            _BiLog-BBuffWaits / _BiLog-Trans  NO-LABEL        AT 57
            _BiLog-EBuffWaits  LABEL "Empty buffer waits"     COLON 23
            _BiLog-EBuffWaits / perMinute     NO-LABEL        AT 37
            _BiLog-EBuffWaits / _BiLog-UpTime NO-LABEL        AT 47
            _BiLog-EBuffWaits / _BiLog-Trans  NO-LABEL        AT 57
            _BiLog-ForceWaits  LABEL "Log force waits"        COLON 23
            _BiLog-ForceWaits / perMinute     NO-LABEL        AT 37
            _BiLog-ForceWaits / _BiLog-UpTime NO-LABEL        AT 47
            _BiLog-ForceWaits / _BiLog-Trans  NO-LABEL        AT 57
            _BiLog-ForceWrts   LABEL "Log force writes"       COLON 23
            _BiLog-ForceWrts / perMinute     NO-LABEL         AT 37
            _BiLog-ForceWrts / _BiLog-UpTime NO-LABEL         AT 47
            _BiLog-ForceWrts / _BiLog-Trans  NO-LABEL         AT 57
            _BiLog-PartialWrts LABEL "Partial writes"         COLON 23
            _BiLog-PartialWrts / perMinute     NO-LABEL       AT 37
            _BiLog-PartialWrts / _BiLog-UpTime NO-LABEL       AT 47
            _BiLog-PartialWrts / _BiLog-Trans  NO-LABEL       AT 57
            with frame Act-BiLog-frame
                 side-labels.
  end.


END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE show-ActBuffers 
PROCEDURE show-ActBuffers :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN report-head ("Activity: Buffer Cache").

  FOR EACH _ActBuffer NO-LOCK:
    perMinute = _Buffer-UpTime / 60.
    {&display} SKIP(1)
           {&ACTIVITY-COLUMN-LABELS}
            SKIP(1)
            _Buffer-UpTime     LABEL "Database Up Time"       COLON 23
            _Buffer-LogicRds   LABEL "Logical reads"          COLON 23
            _Buffer-LogicRds / perMinute      NO-LABEL        AT 37
            _Buffer-LogicRds / _Buffer-UpTime NO-LABEL        AT 47
            _Buffer-LogicRds / _Buffer-Trans  NO-LABEL        AT 57
            _Buffer-LogicWrts  LABEL "Logical writes"         COLON 23
            _Buffer-LogicWrts / perMinute      NO-LABEL       AT 37
            _Buffer-LogicWrts / _Buffer-UpTime NO-LABEL       AT 47
            _Buffer-LogicWrts / _Buffer-Trans  NO-LABEL       AT 57
            _Buffer-OSRds      LABEL "O/S reads"              COLON 23
            _Buffer-OSRds / perMinute      NO-LABEL           AT 37
            _Buffer-OSRds / _Buffer-UpTime NO-LABEL           AT 47
            _Buffer-OSRds / _Buffer-Trans  NO-LABEL           AT 57
            _Buffer-OSWrts     LABEL "O/S writes"             COLON 23
            _Buffer-OSWrts / perMinute      NO-LABEL          AT 37
            _Buffer-OSWrts / _Buffer-UpTime NO-LABEL          AT 47
            _Buffer-OSWrts / _Buffer-Trans  NO-LABEL          AT 57
            _Buffer-Chkpts     LABEL "Checkpoints"            COLON 23
            _Buffer-Chkpts / perMinute      NO-LABEL          AT 37
            _Buffer-Chkpts / _Buffer-UpTime NO-LABEL          AT 47
            _Buffer-Chkpts / _Buffer-Trans  NO-LABEL          AT 57
            _Buffer-Marked     LABEL "Marked to checkpoint"   COLON 23
            _Buffer-Marked / perMinute      NO-LABEL          AT 37
            _Buffer-Marked / _Buffer-UpTime NO-LABEL          AT 47
            _Buffer-Marked / _Buffer-Trans  NO-LABEL          AT 57
            _Buffer-Flushed    LABEL "Flushed at checkpoint"  COLON 23
            _Buffer-Flushed / perMinute      NO-LABEL         AT 37
            _Buffer-Flushed / _Buffer-UpTime NO-LABEL         AT 47
            _Buffer-Flushed / _Buffer-Trans  NO-LABEL         AT 57
            _Buffer-Deferred   LABEL "Writes deferred"        COLON 23
            _Buffer-Deferred / perMinute      NO-LABEL        AT 37
            _Buffer-Deferred / _Buffer-UpTime NO-LABEL        AT 47
            _Buffer-Deferred / _Buffer-Trans  NO-LABEL        AT 57
            _Buffer-LRUSkips   LABEL "LRU skips"              COLON 23
            _Buffer-LRUSkips / perMinute      NO-LABEL        AT 37
            _Buffer-LRUSkips / _Buffer-UpTime NO-LABEL        AT 47
            _Buffer-LRUSkips / _Buffer-Trans  NO-LABEL        AT 57
            _Buffer-LRUWrts    LABEL "LRU writes"             COLON 23
            _Buffer-LRUWrts / perMinute      NO-LABEL         AT 37
            _Buffer-LRUWrts / _Buffer-UpTime NO-LABEL         AT 47
            _Buffer-LRUWrts / _Buffer-Trans  NO-LABEL         AT 57
            _Buffer-APWEnq     LABEL "APW enqueues"           COLON 23
            _Buffer-APWEnq / perMinute      NO-LABEL          AT 37
            _Buffer-APWEnq / _Buffer-UpTime NO-LABEL          AT 47
            _Buffer-APWEnq / _Buffer-Trans  NO-LABEL          AT 57
            WITH FRAME Act-Buffer-frame SIDE-LABELS.
  END.

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE show-ActIndex 
PROCEDURE show-ActIndex :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN report-head ("Activity: Index").

  FOR EACH _ActIndex NO-LOCK:
    perMinute = _Index-UpTime / 60.
    {&display} SKIP(1)
           {&ACTIVITY-COLUMN-LABELS}
            SKIP(1)
            _Index-UpTime  LABEL "Database Up Time"       COLON 23
            _Index-Find    LABEL "Find index entry"       COLON 23
            _Index-Find / perMinute     NO-LABEL          AT 37
            _Index-Find / _Index-UpTime NO-LABEL          AT 47
            _Index-Find / _Index-Trans  NO-LABEL          AT 57
            _Index-Create  LABEL "Create index entry"     COLON 23
            _Index-Create / perMinute     NO-LABEL        AT 37
            _Index-Create / _Index-UpTime NO-LABEL        AT 47
            _Index-Create / _Index-Trans  NO-LABEL        AT 57
            _Index-Delete  LABEL "Delete index entry"     COLON 23
            _Index-Delete / perMinute     NO-LABEL        AT 37
            _Index-Delete / _Index-UpTime NO-LABEL        AT 47
            _Index-Delete / _Index-Trans  NO-LABEL        AT 57
            _Index-Remove  LABEL "Remove locked entry"    COLON 23
            _Index-Remove / perMinute     NO-LABEL        AT 37
            _Index-Remove / _Index-UpTime NO-LABEL        AT 47
            _Index-Remove / _Index-Trans  NO-LABEL        AT 57
            _Index-Splits  LABEL "Split block"            COLON 23
            _Index-Splits / perMinute     NO-LABEL        AT 37
            _Index-Splits / _Index-UpTime NO-LABEL        AT 47
            _Index-Splits / _Index-Trans  NO-LABEL        AT 57
            _Index-Free    LABEL "Free block"             COLON 23
            _Index-Free / perMinute     NO-LABEL          AT 37
            _Index-Free / _Index-UpTime NO-LABEL          AT 47
            _Index-Free / _Index-Trans  NO-LABEL          AT 57
            WITH FRAME Act-Index-frame SIDE-LABELS.
  END.


END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE show-ActIOFile 
PROCEDURE show-ActIOFile :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN report-head ("Activity: I/O Operations by File").

  FOR EACH _ActIOFile NO-LOCK:
    perMinute = _IOFile-UpTime / 60.
    {&out} '<center>' format-label-text ('File', _IOFile-FileName) '</center>~n'.
    {&display} SKIP(1)
           {&ACTIVITY-COLUMN-LABELS}
            SKIP(1)
            _IOFile-UpTime    Label "Database Uptime"          COLON 23
            SKIP(1)
            _IOFile-Reads     LABEL "Reads"                    COLON 23
            _IOFile-Reads / perMinute    NO-LABEL              AT 37
            _IOFile-Reads / _IOFile-UpTime NO-LABEL            AT 47
            _IOFile-Reads / _IOFile-Trans  NO-LABEL            AT 57
            _IOFile-BufReads     LABEL "Buffered Reads"        COLON 23
            _IOFile-BufReads / perMinute    NO-LABEL           AT 37
            _IOFile-BufReads / _IOFile-UpTime NO-LABEL         AT 47
            _IOFile-BufReads / _IOFile-Trans  NO-LABEL         AT 57
            _IOFile-UbufReads     LABEL "Unbuffered Reads"     COLON 23
            _IOFile-UbufReads / perMinute    NO-LABEL          AT 37
            _IOFile-UbufReads / _IOFile-UpTime NO-LABEL        AT 47
            _IOFile-UbufReads / _IOFile-Trans  NO-LABEL        AT 57

            _IOFile-Writes    LABEL "Writes"                   COLON 23
            _IOFile-Writes / perMinute    NO-LABEL             AT 37
            _IOFile-Writes / _IOFile-UpTime NO-LABEL           AT 47
            _IOFile-Writes / _IOFile-Trans  NO-LABEL           AT 57
            _IOFile-BufWrites    LABEL "Buffered Writes"       COLON 23
            _IOFile-BufWrites / perMinute    NO-LABEL          AT 37
            _IOFile-BufWrites / _IOFile-UpTime NO-LABEL        AT 47
            _IOFile-BufWrites / _IOFile-Trans  NO-LABEL        AT 57
            _IOFile-UbufWrites    LABEL "Unbuffered Writes"    COLON 23
            _IOFile-UbufWrites / perMinute    NO-LABEL         AT 37
            _IOFile-UbufWrites / _IOFile-UpTime NO-LABEL       AT 47
            _IOFile-UbufWrites / _IOFile-Trans  NO-LABEL       AT 57

            _IOFile-Extends   LABEL "Extends"                  COLON 23
            _IOFile-Extends   LABEL "Extends"                  COLON 23
            _IOFile-Extends / perMinute    NO-LABEL            AT 37
            _IOFile-Extends / _IOFile-UpTime NO-LABEL          AT 47
            _IOFile-Extends / _IOFile-Trans  NO-LABEL          AT 57
            WITH FRAME Act-IOFile-frame SIDE-LABELS.
  END.

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE show-ActIOType 
PROCEDURE show-ActIOType :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN report-head ("Activity: I/O Operations by Type").

  FOR EACH _ActIOType NO-LOCK:
    perMinute = _IOType-UpTime / 60.
    {&display} SKIP(1)
           {&ACTIVITY-COLUMN-LABELS}
            SKIP(1)
            _IOType-UpTime    LABEL "Database Up Time"       COLON 23
            _IOType-IdxRds + _IOType-DataReads
                              LABEL "Database reads"         COLON 23
            (_IOType-IdxRds + _IOType-DataReads) / perMinute
                              NO-LABEL                       AT 37
            (_IOType-IdxRds + _IOType-DataReads) / _IOType-UpTime
                              NO-LABEL                       AT 47
            (_IOType-IdxRds + _IOType-DataReads) / _IOType-Trans
                               NO-LABEL                      AT 57
            _IOType-IdxRds    LABEL "DB Index block Reads"   COLON 23
            _IOType-IdxRds / perMinute      NO-LABEL         AT 37
            _IOType-IdxRds / _IOType-UpTime NO-LABEL         AT 47
            _IOType-IdxRds / _IOType-Trans  NO-LABEL         AT 57
            _IOType-DataReads LABEL "DB Data block Reads"    COLON 23
            _IOType-DataReads / perMinute      NO-LABEL      AT 37
            _IOType-DataReads / _IOType-UpTime NO-LABEL      AT 47
            _IOType-DataReads / _IOType-Trans  NO-LABEL      AT 57
            _IOType-BiRds     LABEL "BI reads"               COLON 23
            _IOType-BiRds / perMinute      NO-LABEL          AT 37
            _IOType-BiRds / _IOType-UpTime NO-LABEL          AT 47
            _IOType-BiRds / _IOType-Trans  NO-LABEL          AT 57
            _IOType-AiRds     LABEL "AI reads"               COLON 23
            _IOType-AiRds / perMinute      NO-LABEL          AT 37
            _IOType-AiRds / _IOType-UpTime NO-LABEL          AT 47
            _IOType-AiRds / _IOType-Trans  NO-LABEL          AT 57
            _IOType-IdxRds + _IOType-DataReads + _IOType-BiRds + _IOType-AiRds
                              LABEL "Total reads"            COLON 23
            (_IOType-IdxRds + _IOType-DataReads + _IOType-BiRds + _IOType-AiRds)
              / perMinute     NO-LABEL                       AT 37
            (_IOType-IdxRds + _IOType-DataReads + _IOType-BiRds + _IOType-AiRds)
              / _IOType-UpTime NO-LABEL                      AT 47
            (_IOType-IdxRds + _IOType-DataReads +
             _IOType-BiRds + _IOType-AiRds) / _IOType-Trans
                               NO-LABEL                      AT 57
            SKIP(1)
            _IOType-IdxWrts + _IOType-DataWrts
                              LABEL "Database Writes"        COLON 23
            (_IOType-IdxWrts + _IOType-DataWrts) / perMinute
                              NO-LABEL                       AT 37
            (_IOType-IdxWrts + _IOType-DataWrts) / _IOType-UpTime
                              NO-LABEL                       AT 47
            (_IOType-IdxWrts + _IOType-DataWrts) / _IOType-Trans
                               NO-LABEL                      AT 57
            _IOType-IdxWrts   LABEL "DB Index block Writes"  COLON 23
            _IOType-IdxWrts / perMinute      NO-LABEL        AT 37
            _IOType-IdxWrts / _IOType-UpTime NO-LABEL        AT 47
            _IOType-IdxWrts / _IOType-Trans  NO-LABEL        AT 57
            _IOType-DataWrts  LABEL "DB Data block Writes"   COLON 23
            _IOType-DataWrts / perMinute      NO-LABEL       AT 37
            _IOType-DataWrts / _IOType-UpTime NO-LABEL       AT 47
            _IOType-DataWrts / _IOType-Trans  NO-LABEL       AT 57
            _IOType-BiWrts    LABEL "BI writes"              COLON 23
            _IOType-BiWrts / perMinute      NO-LABEL         AT 37
            _IOType-BiWrts / _IOType-UpTime NO-LABEL         AT 47
            _IOType-BiWrts / _IOType-Trans  NO-LABEL         AT 57
            _IOType-AiWrts    LABEL "AI writes"              COLON 23
            _IOType-AiWrts / perMinute      NO-LABEL         AT 37
            _IOType-AiWrts / _IOType-UpTime NO-LABEL         AT 47
            _IOType-AiWrts / _IOType-Trans  NO-LABEL         AT 57
            _IOType-IdxWrts + _IOType-DataWrts +
                              _IOType-BiWrts + _IOType-AiWrts
                              LABEL "Total writes"           COLON 23
            (_IOType-IdxWrts + _IOType-DataWrts + _IOType-BiWrts +
                              _IOType-AiWrts) / perMinute
                              NO-LABEL                        AT 37
            (_IOType-IdxWrts + _IOType-DataWrts + _IOType-BiWrts +
                              _IOType-AiWrts) / _IOType-UpTime
                              NO-LABEL                        AT 47
            (_IOType-IdxWrts + _IOType-DataWrts +
                              _IOType-BiWrts + _IOType-AiWrts) / _IOType-Trans
                              NO-LABEL                       AT 57
            WITH FRAME Act-IOType-frame SIDE-LABELS.
  END.

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE show-ActiveProcesses 
PROCEDURE show-ActiveProcesses :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN report-head ("Clients: Active Transactions").
    for each _Connect where _Connect-TransId > 0 NO-LOCK:
      {&display} SKIP(1)
                _Connect-Id       LABEL "Usr"    FORMAT ">>>>9"
                _Connect-Name     LABEL "Name"
                _Connect-Type     LABEL "Type"
                _Connect-Wait     LABEL "Wait"   FORMAT "x(5)"
                _Connect-Wait1    LABEL "Wait1"  FORMAT ">>>>>>9"
                _Connect-TransId  LABEL "Trans id"
                _Connect-Pid      LABEL "Pid"    FORMAT ">>>>9"
                with frame Connect-frame
                     down.
    end.
END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE show-ActLock 
PROCEDURE show-ActLock :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN report-head ("Activity: Lock Table").

  FOR EACH _ActLock NO-LOCK:
    perMinute = _Lock-UpTime / 60.
    {&display} SKIP(1)
            {&ACTIVITY-COLUMN-LABELS}
            SKIP(1)
            _Lock-UpTime     LABEL "Database Up Time"       COLON 20
            _Lock-ShrReq     LABEL "Share requests"         COLON 20
            _Lock-ShrReq / perMinute    NO-LABEL            AT 37
            _Lock-ShrReq / _Lock-UpTime NO-LABEL            AT 47
            _Lock-ShrReq / _Lock-Trans  NO-LABEL            AT 57
            _Lock-ExclReq    LABEL "Exclusive requests"     COLON 20
            _Lock-ExclReq / perMinute    NO-LABEL           AT 37
            _Lock-ExclReq / _Lock-UpTime NO-LABEL           AT 47
            _Lock-ExclReq / _Lock-Trans  NO-LABEL           AT 57
            _Lock-UpgReq     LABEL "Upgrade requests"       COLON 20
            _Lock-UpgReq / perMinute    NO-LABEL            AT 37
            _Lock-UpgReq / _Lock-UpTime NO-LABEL            AT 47
            _Lock-UpgReq / _Lock-Trans  NO-LABEL            AT 57
            _Lock-RecGetReq  LABEL "Rec Get requests"       COLON 20
            _Lock-RecGetReq / perMinute    NO-LABEL         AT 37
            _Lock-RecGetReq / _Lock-UpTime NO-LABEL         AT 47
            _Lock-RecGetReq / _Lock-Trans  NO-LABEL         AT 57
            _Lock-RecGetReq / _Lock-Trans  NO-LABEL         AT 57
            _Lock-ShrLock    LABEL "Share grants"           COLON 20
            _Lock-ShrLock / perMinute    NO-LABEL           AT 37
            _Lock-ShrLock / _Lock-UpTime NO-LABEL           AT 47
            _Lock-ShrLock / _Lock-Trans  NO-LABEL           AT 57
            _Lock-ExclLock   LABEL "Exclusive grants"       COLON 20
            _Lock-ExclLock / perMinute    NO-LABEL          AT 37
            _Lock-ExclLock / _Lock-UpTime NO-LABEL          AT 47
            _Lock-ExclLock / _Lock-Trans  NO-LABEL          AT 57
            _Lock-UpgLock    LABEL "Upgrade grants"         COLON 20
            _Lock-UpgLock / perMinute    NO-LABEL           AT 37
            _Lock-UpgLock / _Lock-UpTime NO-LABEL           AT 47
            _Lock-UpgLock / _Lock-Trans  NO-LABEL           AT 57
            _Lock-RecGetLock LABEL "Rec Get grants"         COLON 20
            _Lock-RecGetLock / perMinute    NO-LABEL        AT 37
            _Lock-RecGetLock / _Lock-UpTime NO-LABEL        AT 47
            _Lock-RecGetLock / _Lock-Trans  NO-LABEL        AT 57
            _Lock-ShrWait    LABEL "Share waits"            COLON 20
            _Lock-ShrWait / perMinute    NO-LABEL           AT 37
            _Lock-ShrWait / _Lock-UpTime NO-LABEL           AT 47
            _Lock-ShrWait / _Lock-Trans  NO-LABEL           AT 57
            _Lock-ExclWait   LABEL "Exclusive waits"        COLON 20
            _Lock-ExclWait / perMinute    NO-LABEL          AT 37
            _Lock-ExclWait / _Lock-UpTime NO-LABEL          AT 47
            _Lock-ExclWait / _Lock-Trans  NO-LABEL          AT 57
            _Lock-UpgWait    LABEL "Upgrade waits"          COLON 20
            _Lock-UpgWait / perMinute    NO-LABEL           AT 37
            _Lock-UpgWait / _Lock-UpTime NO-LABEL           AT 47
            _Lock-UpgWait / _Lock-Trans  NO-LABEL           AT 57
            _Lock-RecGetWait LABEL "Rec Get waits"          COLON 20
            _Lock-RecGetWait / perMinute    NO-LABEL        AT 37
            _Lock-RecGetWait / _Lock-UpTime NO-LABEL        AT 47
            _Lock-RecGetWait / _Lock-Trans  NO-LABEL        AT 57
            _Lock-CanclReq   LABEL "Requests cancelled"     COLON 20
            _Lock-CanclReq / perMinute    NO-LABEL          AT 37
            _Lock-CanclReq / _Lock-UpTime NO-LABEL          AT 47
            _Lock-CanclReq / _Lock-Trans  NO-LABEL          AT 57
            _Lock-Downgrade  LABEL "Downgrades"             COLON 20
            _Lock-Downgrade / perMinute    NO-LABEL         AT 37
            _Lock-Downgrade / _Lock-UpTime NO-LABEL         AT 47
            _Lock-Downgrade / _Lock-Trans  NO-LABEL         AT 57
            _Lock-RedReq     LABEL "Redundant requests"     COLON 20
            _Lock-RedReq / perMinute    NO-LABEL            AT 37
            _Lock-RedReq / _Lock-UpTime NO-LABEL            AT 47
            _Lock-RedReq / _Lock-Trans  NO-LABEL            AT 57
            WITH FRAME Act-Lock-frame2 SIDE-LABELS.
  END.


END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE show-ActOther 
PROCEDURE show-ActOther :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN report-head ("Activity: Other").

  FOR EACH _ActOther NO-LOCK:
    perMinute = _Other-UpTime / 60.
    {&display} SKIP(1)
           {&ACTIVITY-COLUMN-LABELS}
            SKIP(1)
            _Other-UpTime     LABEL "Database Up Time"       COLON 23
            _Other-Commit     LABEL "Commit"                 COLON 23
            _Other-Commit / perMinute     NO-LABEL           AT 37
            _Other-Commit / _Other-UpTime NO-LABEL           AT 47
            _Other-Commit / _Other-Trans  NO-LABEL           AT 57
            _Other-Undo       LABEL "Undo"                   COLON 23
            _Other-Undo / perMinute     NO-LABEL             AT 37
            _Other-Undo / _Other-UpTime NO-LABEL             AT 47
            _Other-Undo / _Other-Trans  NO-LABEL             AT 57
            _Other-Wait       LABEL "Wait on semaphore"      COLON 23
            _Other-Wait / perMinute     NO-LABEL             AT 37
            _Other-Wait / _Other-UpTime NO-LABEL             AT 47
            _Other-Wait / _Other-Trans  NO-LABEL             AT 57
            _Other-FlushMblk  LABEL "Flush master block"     COLON 23
            _Other-FlushMblk / perMinute     NO-LABEL        AT 37
            _Other-FlushMblk / _Other-UpTime NO-LABEL        AT 47
            _Other-FlushMblk / _Other-Trans  NO-LABEL        AT 57
            WITH FRAME Act-Other-frame SIDE-LABELS.
  END.
   
END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE show-ActPWs 
PROCEDURE show-ActPWs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN report-head (" Activity: Page Writers").
  for each _ActPWs NO-LOCK:
    perMinute = _PW-UpTime / 60.
    {&display} SKIP(1)
           {&ACTIVITY-COLUMN-LABELS}
            SKIP(1)
            _PW-UpTime       LABEL "Database Up Time"       COLON 23
            _PW-TotDBWrites  LABEL "Total DB writes"        COLON 23
            _PW-TotDBWrites / perMinute  NO-LABEL           AT 37
            _PW-TotDBWrites / _PW-UpTime NO-LABEL           AT 47
            _PW-TotDBWrites / _PW-Trans  NO-LABEL           AT 57
            _PW-DBWrites     LABEL "APW DB writes"          COLON 23
            _PW-DBWrites / perMinute  NO-LABEL              AT 37
            _PW-DBWrites / _PW-UpTime NO-LABEL              AT 47
            _PW-DBWrites / _PW-Trans  NO-LABEL              AT 57
            _PW-ScanWrites   LABEL "    scan writes"        COLON 23
            _PW-ScanWrites / perMinute  NO-LABEL            AT 37
            _PW-ScanWrites / _PW-UpTime NO-LABEL            AT 47
            _PW-ScanWrites / _PW-Trans  NO-LABEL            AT 57
            _PW-ApwQWrites   LABEL "    apw queue writes"   COLON 23
            _PW-ApwQWrites / perMinute  NO-LABEL            AT 37
            _PW-ApwQWrites / _PW-UpTime NO-LABEL            AT 47
            _PW-ApwQWrites / _PW-Trans  NO-LABEL            AT 57
            _PW-CkpQWrites   LABEL "    ckp queue writes"   COLON 23
            _PW-CkpQWrites / perMinute  NO-LABEL            AT 37
            _PW-CkpQWrites / _PW-UpTime NO-LABEL            AT 47
            _PW-CkpQWrites / _PW-Trans  NO-LABEL            AT 57
            _PW-ScanCycles   LABEL "    scan cycles"        COLON 23
            _PW-ScanCycles / perMinute  NO-LABEL            AT 37
            _PW-ScanCycles / _PW-UpTime NO-LABEL            AT 47
            _PW-ScanCycles / _PW-Trans  NO-LABEL            AT 57
            _PW-BuffsScaned  LABEL "    buffers scanned"    COLON 23
            _PW-BuffsScaned / perMinute  NO-LABEL           AT 37
            _PW-BuffsScaned / _PW-UpTime NO-LABEL           AT 47
            _PW-BuffsScaned / _PW-Trans  NO-LABEL           AT 57
            _PW-BufsCkp      LABEL "    bufs checkpointed"  COLON 23
            _PW-BufsCkp / perMinute  NO-LABEL               AT 37
            _PW-BufsCkp / _PW-UpTime NO-LABEL               AT 47
            _PW-BufsCkp / _PW-Trans  NO-LABEL               AT 57
            _PW-Checkpoints  LABEL "Checkpoints"            COLON 23
            _PW-Checkpoints / perMinute  NO-LABEL           AT 37
            _PW-Checkpoints / _PW-UpTime NO-LABEL           AT 47
            _PW-Checkpoints / _PW-Trans  NO-LABEL           AT 57
            _PW-Marked       LABEL "Marked at checkpoint"   COLON 23
            _PW-Marked / perMinute  NO-LABEL                AT 37
            _PW-Marked / _PW-UpTime NO-LABEL                AT 47
            _PW-Marked / _PW-Trans  NO-LABEL                AT 57
            _PW-Flushed      LABEL "Flushed at checkpoint"  COLON 23
            _PW-Flushed / perMinute  NO-LABEL               AT 37
            _PW-Flushed / _PW-UpTime NO-LABEL               AT 47
            _PW-Flushed / _PW-Trans  NO-LABEL               AT 57
            with frame Act-PW-frame
                 side-labels.
  end.

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE show-ActRecord 
PROCEDURE show-ActRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN report-head ("Activity: Record").
  for each _ActRecord NO-LOCK:
    perMinute = _Record-UpTime / 60.
    {&display} SKIP(1)
           {&ACTIVITY-COLUMN-LABELS}
            SKIP(1)
            _Record-UpTime      LABEL "Database Up Time"       COLON 23
            _Record-RecRead     LABEL "Read record"            COLON 23
            _Record-RecRead / perMinute      NO-LABEL          AT 37
            _Record-RecRead / _Record-UpTime NO-LABEL          AT 47
            _Record-RecRead / _Record-Trans  NO-LABEL          AT 57
            _Record-RecUpd      LABEL "Update record"          COLON 23
            _Record-RecUpd / perMinute      NO-LABEL           AT 37
            _Record-RecUpd / _Record-UpTime NO-LABEL           AT 47
            _Record-RecUpd / _Record-Trans  NO-LABEL           AT 57
            _Record-RecCreat    LABEL "Create record"          COLON 23
            _Record-RecCreat / perMinute      NO-LABEL         AT 37
            _Record-RecCreat / _Record-UpTime NO-LABEL         AT 47
            _Record-RecCreat / _Record-Trans  NO-LABEL         AT 57
            _Record-RecDel      LABEL "Delete record"          COLON 23
            _Record-RecDel / perMinute      NO-LABEL           AT 37
            _Record-RecDel / _Record-UpTime NO-LABEL           AT 47
            _Record-RecDel / _Record-Trans  NO-LABEL           AT 57
            _Record-FragRead    LABEL "Fragments read"         COLON 23
            _Record-FragRead / perMinute      NO-LABEL         AT 37
            _Record-FragRead / _Record-UpTime NO-LABEL         AT 47
            _Record-FragRead / _Record-Trans  NO-LABEL         AT 57
            _Record-FragCreat   LABEL "Fragments created"      COLON 23
            _Record-FragCreat / perMinute      NO-LABEL        AT 37
            _Record-FragCreat / _Record-UpTime NO-LABEL        AT 47
            _Record-FragCreat / _Record-Trans  NO-LABEL        AT 57
            _Record-FragDel     LABEL "Fragments deleted"      COLON 23
            _Record-FragDel / perMinute      NO-LABEL          AT 37
            _Record-FragDel / _Record-UpTime NO-LABEL          AT 47
            _Record-FragDel / _Record-Trans  NO-LABEL          AT 57
            _Record-FragUpd     LABEL "Fragments updated"      COLON 23
            _Record-FragUpd / perMinute      NO-LABEL          AT 37
            _Record-FragUpd / _Record-UpTime NO-LABEL          AT 47
            _Record-FragUpd / _Record-Trans  NO-LABEL          AT 57
            _Record-BytesRead   LABEL "Bytes read"             COLON 23
            _Record-BytesRead / perMinute      NO-LABEL        AT 37
            _Record-BytesRead / _Record-UpTime NO-LABEL        AT 47
            _Record-BytesRead / _Record-Trans  NO-LABEL        AT 57 {&BIG-DECIMAL}
            _Record-BytesCreat  LABEL "Bytes created"          COLON 23
            _Record-BytesCreat / perMinute      NO-LABEL       AT 37
            _Record-BytesCreat / _Record-UpTime NO-LABEL       AT 47
            _Record-BytesCreat / _Record-Trans  NO-LABEL       AT 57 {&BIG-DECIMAL}
            _Record-BytesDel    LABEL "Bytes deleted"          COLON 23
            _Record-BytesDel / perMinute      NO-LABEL         AT 37
            _Record-BytesDel / _Record-UpTime NO-LABEL         AT 47
            _Record-BytesDel / _Record-Trans  NO-LABEL         AT 57 {&BIG-DECIMAL}
            _Record-BytesUpd    LABEL "Bytes updated"          COLON 23
            _Record-BytesUpd / perMinute      NO-LABEL         AT 37
            _Record-BytesUpd / _Record-UpTime NO-LABEL         AT 47
            _Record-BytesUpd / _Record-Trans  NO-LABEL         AT 57 {&BIG-DECIMAL}

            with frame Act-Record-frame
                 side-labels.
  end.


END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE show-ActServer 
PROCEDURE show-ActServer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN report-head (" Activity: Servers").
  for each _ActServer NO-LOCK:
      perMinute = _Server-UpTime / 60.
      {&DISPLAY} SKIP(1)
           {&ACTIVITY-COLUMN-LABELS}
            SKIP(1)
            _Server-Id          LABEL "Server Number"          COLON 23
            _Server-MsgRec      LABEL "Messages received"      COLON 23
            _Server-MsgRec / perMinute      NO-LABEL           AT 37
            _Server-MsgRec / _Server-Uptime NO-LABEL           AT 47
            _Server-MsgRec / _Server-Trans  NO-LABEL           AT 57
            _Server-MsgSent     LABEL "Messages sent"          COLON 23
            _Server-MsgSent / perMinute      NO-LABEL          AT 37
            _Server-MsgSent / _Server-Uptime NO-LABEL          AT 47
            _Server-MsgSent / _Server-Trans  NO-LABEL          AT 57 
            _Server-ByteRec     LABEL "Bytes received"         COLON 23
            _Server-ByteRec / perMinute      NO-LABEL          AT 37
            _Server-ByteRec / _Server-Uptime NO-LABEL          AT 47
            _Server-ByteRec / _Server-Trans  NO-LABEL          AT 57 {&BIG-DECIMAL}
            _Server-ByteSent    LABEL "Bytes sent"             COLON 23
            _Server-ByteSent / perMinute      NO-LABEL         AT 37
            _Server-ByteSent / _Server-Uptime NO-LABEL         AT 47
            _Server-ByteSent / _Server-Trans  NO-LABEL         AT 57 {&BIG-DECIMAL}
            _Server-RecRec      LABEL "Records received"       COLON 23
            _Server-RecRec / perMinute      NO-LABEL           AT 37
            _Server-RecRec / _Server-Uptime NO-LABEL           AT 47
            _Server-RecRec / _Server-Trans  NO-LABEL           AT 57
            _Server-RecSent     LABEL "Records sent"           COLON 23
            _Server-RecSent / perMinute      NO-LABEL          AT 37
            _Server-RecSent / _Server-Uptime NO-LABEL          AT 47
            _Server-RecSent / _Server-Trans  NO-LABEL          AT 57
            _Server-QryRec      LABEL "Queries received"       COLON 23
            _Server-QryRec / perMinute      NO-LABEL           AT 37
            _Server-QryRec / _Server-Uptime NO-LABEL           AT 47
            _Server-QryRec / _Server-Trans  NO-LABEL           AT 57
            _Server-TimeSlice   LABEL "Time slices"            COLON 23
            _Server-TimeSlice / perMinute      NO-LABEL        AT 37
            _Server-TimeSlice / _Server-Uptime NO-LABEL        AT 47
            _Server-TimeSlice / _Server-Trans  NO-LABEL        AT 57
            with frame Act-Server-frame
                 Side-labels.
  end.

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE show-ActSpace 
PROCEDURE show-ActSpace :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN report-head ("Activity: Space Allocation").
  for each _ActSpace NO-LOCK:
    perMinute = _Space-UpTime / 60.
    {&display} SKIP(1)
            {&ACTIVITY-COLUMN-LABELS}
            SKIP(1)
            _Space-UpTime      LABEL "Database Up Time"       COLON 24
            _Space-DbExd       LABEL "Database extends"       COLON 24
            _Space-DbExd / perMinute     NO-LABEL             AT 37
            _Space-DbExd / _Space-UpTime NO-LABEL             AT 47
            _Space-DbExd / _Space-Trans  NO-LABEL             AT 57
            _Space-TakeFree    LABEL "Take free block"        COLON 24
            _Space-TakeFree / perMinute     NO-LABEL          AT 37
            _Space-TakeFree / _Space-UpTime NO-LABEL          AT 47
            _Space-TakeFree / _Space-Trans  NO-LABEL          AT 57
            _Space-RetFree     LABEL "Return free block"      COLON 24
            _Space-RetFree / perMinute     NO-LABEL           AT 37
            _Space-RetFree / _Space-UpTime NO-LABEL           AT 47
            _Space-RetFree / _Space-Trans  NO-LABEL           AT 57
            _Space-AllocNewRm  LABEL "Alloc rm space"         COLON 24
            _Space-AllocNewRm / perMinute     NO-LABEL        AT 37
            _Space-AllocNewRm / _Space-UpTime NO-LABEL        AT 47
            _Space-AllocNewRm / _Space-Trans  NO-LABEL        AT 57
            _Space-FromRm      LABEL "Alloc from rm"          COLON 24
            _Space-FromRm / perMinute     NO-LABEL            AT 37
            _Space-FromRm / _Space-UpTime NO-LABEL            AT 47
            _Space-FromRm / _Space-Trans  NO-LABEL            AT 57
            _Space-FromFree    LABEL "Alloc from free"        COLON 24
            _Space-FromFree / perMinute     NO-LABEL          AT 37
            _Space-FromFree / _Space-UpTime NO-LABEL          AT 47
            _Space-FromFree / _Space-Trans  NO-LABEL          AT 57
            _Space-BytesAlloc  LABEL "Bytes allocated"        COLON 24
            _Space-BytesAlloc / perMinute     NO-LABEL        AT 37
            _Space-BytesAlloc / _Space-UpTime NO-LABEL        AT 47
            _Space-BytesAlloc / _Space-Trans  NO-LABEL        AT 57 {&BIG-DECIMAL}
            _Space-Examined    LABEL "rm blocks examined"     COLON 24
            _Space-Examined / perMinute     NO-LABEL          AT 37
            _Space-Examined / _Space-UpTime NO-LABEL          AT 47
            _Space-Examined / _Space-Trans  NO-LABEL          AT 57
            _Space-Removed     LABEL "Remove from rm"         COLON 24
            _Space-Removed / perMinute     NO-LABEL           AT 37
            _Space-Removed / _Space-UpTime NO-LABEL           AT 47
            _Space-Removed / _Space-Trans  NO-LABEL           AT 57
            _Space-FrontAdd    LABEL "Add to rm, front"       COLON 24
            _Space-FrontAdd / perMinute     NO-LABEL          AT 37
            _Space-FrontAdd / _Space-UpTime NO-LABEL          AT 47
            _Space-FrontAdd / _Space-Trans  NO-LABEL          AT 57
            _Space-BackAdd     LABEL "Add to rm, back"        COLON 24
            _Space-BackAdd / perMinute     NO-LABEL           AT 37
            _Space-BackAdd / _Space-UpTime NO-LABEL           AT 47
            _Space-BackAdd / _Space-Trans  NO-LABEL           AT 57
            _Space-Front2Back  LABEL "Move rm front to back"  COLON 24
            _Space-Front2Back / perMinute     NO-LABEL        AT 37
            _Space-Front2Back / _Space-UpTime NO-LABEL        AT 47
            _Space-Front2Back / _Space-Trans  NO-LABEL        AT 57
            _Space-Locked      LABEL "Remove locked rm entry" COLON 24
            _Space-Locked / perMinute     NO-LABEL            AT 37
            _Space-Locked / _Space-UpTime NO-LABEL            AT 47
            _Space-Locked / _Space-Trans  NO-LABEL            AT 57

            with frame Act-Space-frame
                 side-labels.
  end.


END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE show-ActSummary 
PROCEDURE show-ActSummary :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN report-head ("Activity: Summary").
    find first _ActSummary.
    {&display}
                _Summary-UpTime    LABEL "DB Up Time"
                _Summary-Commits   LABEL "Commits"
                _Summary-DbReads   LABEL "DB Reads"
                _Summary-Undos     LABEL "Undos"
                _Summary-DbWrites  LABEL "DB Writes"
                _Summary-RecReads  LABEL "Record Reads"
                _Summary-BiReads   LABEL "BI Reads"
                _Summary-RecUpd    LABEL "Record Updates"
                _Summary-BiWrites  LABEL "BI Writes"
                _Summary-RecCreat  LABEL "Record Creates"
                _Summary-AiWrites  LABEL "AI Writes"
                _Summary-RecDel    LABEL "Record Deletes"
                _Summary-Chkpts    LABEL "Checkpoints"
                _Summary-RecLock   LABEL "Record Locks"
                _Summary-Flushed   LABEL "Flushed at chkpt"
                _Summary-RecWait   LABEL "Record Waits"
            with frame Summary-frame side-labels 3 columns.

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE show-AILog 
PROCEDURE show-AILog :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN report-head ("Status: AI Log").
    for each _Logging NO-LOCK:
      {&display} SKIP(1)
                _Logging-AiBegin     LABEL "After-image begin date"
                                     COLON 32
                _Logging-AiNew       LABEL "After-image new date"
                                     COLON 32
                _Logging-AiOpen      LABEL "After-image open date"
                                     COLON 32
                _Logging-AiGenNum    LABEL "After-image generation number"
                                     COLON 32
                _Logging-AiExtents   LABEL "Number of after-image extents"
                                     COLON 32
                _Logging-AiBuffs     LABEL "Number of AI buffers"
                                     COLON 32
                _Logging-AiBlkSize   LABEL "After-image block size"
                                     COLON 32
                _Logging-AiLogSize   LABEL "After-image log size"
                                     COLON 32
                with frame AI-Logging-Frame
                     side-labels.
    end.

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE show-AllProcesses 
PROCEDURE show-AllProcesses :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN report-head ("Clients: All Processes").
    for each _Connect where _Connect._Connect-name <> ? NO-LOCK:
      {&display} SKIP(1)
                _Connect-Id       LABEL "Usr"    FORMAT ">>>>9"
                _Connect-Name     LABEL "Name"
                _Connect-Type     LABEL "Type"
                _Connect-Wait     LABEL "Wait"   FORMAT "x(5)"
                _Connect-Wait1    LABEL "Wait1"  FORMAT ">>>>>>9"
                _Connect-TransId  LABEL "Trans id"  FORMAT ">>>>>>9"
                _Connect-Time     LABEL "Login time"
                _Connect-Pid      LABEL "Pid"    FORMAT ">>>>9"
                with frame Connect-frame
                     down.
    end.
END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE show-BackgroundProcesses 
PROCEDURE show-BackgroundProcesses :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN report-head ("Clients: Background Processes").
    /* Why is !REMC and !SELF considered Background?! */
    for each _Connect where
                      _Connect-Type <> "REMC" AND
                      _Connect-Type <> "SELF" AND
                      _Connect-name <> ?
                      NO-LOCK:
      {&display} SKIP(1)
                _Connect-Id       LABEL "Usr"    FORMAT ">>>>9"
                _Connect-Name     LABEL "Name"
                _Connect-Type     LABEL "Type"
                _Connect-Time     LABEL "Login time"
                _Connect-Pid      LABEL "Pid"    FORMAT ">>>>9"
                with frame Connect-frame
                     down.
    end.

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE show-Backup 
PROCEDURE show-Backup :
/*------------------------------------------------------------------------------
  Purpose:     Show Backup information (from _DbStatus) record.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN report-head ("Status: Backup").
    for each _DbStatus NO-LOCK:
      {&display} SKIP(1)
                _DbStatus-fbDate  LABEL "Most recent full backup"
                                  COLON 32
                _DbStatus-ibDate  LABEL "Most recent incremental backup"
                                  COLON 32
                _DbStatus-Changed LABEL "Database changed since backup"
                                  COLON 32
                _DbStatus-ibSeq   LABEL "Sequence of last incremental"
                                  COLON 32
                with frame Backup-frame
                     side-labels.
    end.
END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE show-BatchProcesses 
PROCEDURE show-BatchProcesses :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN report-head ("Clients: Local Batch").
    /* BATCHUSER and (!SELF or !REMC) */
    for each _Connect where
                      _Connect-Batch = "Yes"  AND
                      _Connect-Type <> "SELF"  AND
                      _Connect-Type <> "REMC"
                      NO-LOCK:
      {&display} SKIP(1)
                _Connect-Id       LABEL "Usr"    FORMAT ">>>>9"
                _Connect-Name     LABEL "Name"
                _Connect-Type     LABEL "Type"
                _Connect-Wait     LABEL "Wait"   FORMAT "x(5)"
                _Connect-Wait1    LABEL "Wait1"  FORMAT ">>>>>>9"
                _Connect-TransId  LABEL "Trans id"
                _Connect-Time     LABEL "Login time"
                _Connect-Server   LABEL "Serv"   FORMAT ">>>>9"
                with frame Connect-frame
                     down.
    end.

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE show-BILog 
PROCEDURE show-BILog :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN report-head ("Status: BI Log").
    for each _Logging NO-LOCK:
      {&display} SKIP(1)
                _Logging-BiClAge     LABEL "Before-image cluster age time"
                                     COLON 32
                _Logging-BiBlkSize   LABEL "Before-image block size"
                                     COLON 32
                _Logging-BiClSize    LABEL "Before-image cluster size"
                                     COLON 32
                _Logging-BiExtents   LABEL "Number of before-image extents"
                                     COLON 32
                _Logging-BiLogSize   LABEL "Before-image log size (kb)"
                                     COLON 32
                _Logging-BiBytesFree LABEL "Bytes free in current cluster"
                                     COLON 32
                _Logging-BiBytesFree LABEL "Bytes free in current cluster"
                                     COLON 32
                _Logging-LastCkp     LABEL "Last checkpoint was at"
                                     COLON 32
                _Logging-BiBuffs     LABEL "Number of BI buffers"
                                     COLON 32
                _Logging-BiFullBuffs LABEL "Full buffers"
                                     COLON 32
                with frame Bi-Logging-Frame
                     side-labels.
    end.

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE show-BlockedProcesses 
PROCEDURE show-BlockedProcesses :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN report-head ("Clients: Blocked").
    for each _Connect where _Connect-Wait NE " --" and
                            _Connect-Name NE ? NO-LOCK:
      {&display} SKIP(1)
                _Connect-Id       LABEL "Usr"    FORMAT ">>>>9"
                _Connect-Name     LABEL "Name"
                _Connect-Type     LABEL "Type"
                _Connect-Wait     LABEL "Wait"   FORMAT "x(5)"
                _Connect-Wait1    LABEL "Wait1"  FORMAT ">>>>>>9"
                _Connect-TransId  LABEL "Trans id"
                _Connect-Time     LABEL "Login time"
                _Connect-Pid      LABEL "Pid"    FORMAT ">>>>9"
                with frame Connect-frame
                     down.
    end.
END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE show-Blocks 
PROCEDURE show-Blocks :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE ix AS INTEGER NO-UNDO.
  
  RUN report-head ("Other: Blocks").
  
  Block-Block:
  for each _Block NO-LOCK:
    {&display} _Block-Id          LABEL "Id"         FORMAT ">>>>>9"
               _Block-Dbkey       LABEL "DBKEY"      FORMAT ">>>>>9"
               _Block-Type        LABEL "Type"       FORMAT "x(10)"
               _Block-ChainType   LABEL "Chain Type" FORMAT "x(10)"
               _Block-BkupCtr     LABEL "Bkup Ctr"   FORMAT ">>>>>>>9"
               _Block-NextDbkey   LABEL "Next Dbkey" FORMAT ">>>>>>>9"
               _Block-Update      LABEL "Update Ctr" FORMAT ">>>>>>>9"
               _Block-Area        LABEL "Area"       FORMAT ">>>>>>>9"
               with frame Block-frame1 side-labels 1 down.

    ix = 0.
    repeat ix = 1 to 32 ON ENDKEY UNDO, LEAVE Block-block
                        ON ERROR  UNDO, LEAVE Block-block:
      {&display} ix NO-LABEL FORMAT "9999"
                 substr(_Block-Block, (ix +  1), 8) FORMAT "x(8)"
                 substr(_Block-Block, (ix +  9), 8) FORMAT "x(8)"
                 substr(_Block-Block, (ix + 17), 8) FORMAT "x(8)"
                 substr(_Block-Block, (ix + 25), 8) FORMAT "x(8)"
                 substr(_Block-Block, (ix + 33), 8) FORMAT "x(8)"
                 substr(_Block-Block, (ix + 41), 8) FORMAT "x(8)"
                 substr(_Block-Block, (ix + 49), 8) FORMAT "x(8)"
                 substr(_Block-Block, (ix + 57), 8) FORMAT "x(8)"
                 with frame Block-frame down WIDTH 132.
      down with frame Block-frame.
      ix = (ix + 64).
    end.
  end.
    
END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE show-Buffers 
PROCEDURE show-Buffers :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN report-head ("Status: Buffers").
    for each _BuffStatus NO-LOCK:
      {&display} SKIP(1)
                _BfStatus-Id          LABEL "Buffer id"
                                      COLON 25
                _BfStatus-TotBufs     LABEL "Total buffers"
                                      COLON 25
                _BfStatus-HashSize    LABEL "Hash table size"
                                      COLON 25
                _BfStatus-UsedBuffs   LABEL "Used buffers"
                                      COLON 25
                _BfStatus-TotBufs - _BfStatus-UsedBuffs
                                      LABEL "Empty buffers"
                                      COLON 25
                _BfStatus-LRU         LABEL "On lru chain"
                                      COLON 25
                _BfStatus-APWQ        LABEL "On apw queue"
                                      COLON 25
                _BfStatus-CKPQ        LABEL "On ckp queue"
                                      COLON 25
                _BfStatus-ModBuffs    LABEL "Modified buffers"
                                      COLON 25
                _BfStatus-CKPMarked   LABEL "Marked for ckp"
                                      COLON 25
                _BfStatus-LastCkpNum  LABEL "Last checkpoint number"
                                      COLON 25
                with frame BfStatus-frame
                     side-labels.
    end.

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE show-Checkpoints 
PROCEDURE show-Checkpoints :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN report-head ("Other: Checkpoints").

  for each _Checkpoint NO-LOCK:
    {&display} skip(1)
               _Checkpoint-Id     LABEL "Id"            FORMAT ">>>9"
                                  COLON 12
               _Checkpoint-Time   LABEL "Time"
                                  COLON 12
               _Checkpoint-Len    LABEL "End Time"
                                  COLON 12
               _Checkpoint-Dirty  LABEL "Dirty"         FORMAT ">>>9"
                                  COLON 12
               _Checkpoint-CptQ   LABEL "CPT Q"         FORMAT ">>>9"
                                  COLON 12
               _Checkpoint-Scan   LABEL "Scan"          FORMAT ">>>9"
                                  COLON 12
               _Checkpoint-ApwQ   LABEL "APW Q"         FORMAT ">>>9"
                                  COLON 12
               _Checkpoint-Flush  LABEL "Flushes"       FORMAT ">>>9"
                                  COLON 12
               skip(1)
               with frame Checkpoint-frame 
                 down side-labels.
  end.

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE show-DbStatus 
PROCEDURE show-DbStatus :
/*------------------------------------------------------------------------------
  Purpose:     Show all DbStatus information.  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN report-head ("Status: Database").

    for each _DbStatus NO-LOCK:
        {&display} SKIP(1)
            _DbStatus-starttime  LABEL "Database was started at"
                                 COLON 32
            _DbStatus-state      LABEL "Database state"
                                 COLON 32
            _DbStatus-tainted    LABEL "Database damaged flags"
                                 COLON 32
            _DbStatus-IntFlags   LABEL "Integrity flags"
                                 COLON 32
            _DbStatus-LastOpen   LABEL "Most recent database open"
                                 COLON 32
            _DbStatus-PrevOpen   LABEL "Previous database open"
                                 COLON 32
            _DbStatus-CacheStamp LABEL "Local cache file time stamp"
                                 COLON 32
            _DbStatus-DbBlkSize  LABEL "Database block size"
                                 COLON 32
            _DbStatus-TotalBlks  LABEL "Number of blocks allocated"
                                 COLON 32
            _DbStatus-EmptyBlks  LABEL "Empty blocks"
                                 COLON 32
            _DbStatus-FreeBlks   LABEL "Free blocks"
                                 COLON 32
            _DbStatus-RMFreeBlks LABEL "RM blocks with free space"
                                 COLON 32
            _DbStatus-LastTran   LABEL "Last transaction id"
                                 COLON 32
            _DbStatus-LastTable  LABEL "Highest table number defined"
                                 COLON 32
            _DbStatus-DbVers     LABEL "Database version number"
                                 COLON 32
            _DbStatus-ShmVers    LABEL "Shared memory version number"
                                 COLON 32
            _DbStatus-Integrity  LABEL "Integrity flags"
                                 COLON 32
            _DbStatus-HiWater    LABEL "Database blocks high water mark"
                                 COLON 32
            _DbStatus-BiBlkSize  LABEL "Before image block size (bytes)"
                                 COLON 32
            _DbStatus-BiClSize   LABEL "Before image cluster size (kb)"
                                 COLON 32
            _DbStatus-AiBlkSize  LABEL "After image block size (bytes)"
                                 COLON 32
            _DbStatus-CreateDate LABEL "Database created (multi-volume)"
                                 COLON 32
            _DbStatus-BiOpen     LABEL "Most recent .bi file open"
                                 COLON 32
            _DbStatus-BiSize     LABEL "Logical BI Size"
                                 COLON 32
            _DbStatus-BiTrunc    LABEL "Time since last truncate bi"
                                 COLON 32
            _DbStatus-NumAreas   LABEL "Number of areas"
                                 COLON 32
            _DbStatus-NumLocks   LABEL "Lock table entries in use"
                                 COLON 32
            _DbStatus-MostLocks  LABEL "Lock table high water mark"
                                 COLON 32
            _DbStatus-SharedMemVer  LABEL "Shared Memory Version #"
                                 COLON 32
            _DbStatus-NumSems    LABEL "Number of semaphores"
                                 COLON 32
            SKIP(1) 
            with frame DbStatus-frame
                 down
                 use-text
                 side-labels.
    end.

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE show-FileList 
PROCEDURE show-FileList :
/*------------------------------------------------------------------------------
   Purpose:     Show all _FileList information.  
   Parameters:  <none>
   Notes:       
------------------------------------------------------------------------------*/
    RUN report-head ("Status: Files").
    for each _FileList NO-LOCK:
      {&display} SKIP(1)
                _FileList-Id        COLUMN-LABEL "File!Id"      FORMAT ">>>>9"
                _FileList-Size      COLUMN-LABEL "Size!(KB)"    FORMAT ">>>>9"
                _FileList-Extend    COLUMN-LABEL "Extend!(KB)"  FORMAT ">>>>9"
                _FileList-LogicalSz COLUMN-LABEL "Logical!Size" FORMAT ">>>>9"
                _FileList-BlkSize   COLUMN-LABEL "Block!Size"   FORMAT ">>>>9"
                _FileList-Openmode  COLUMN-LABEL "Open!Mode"    FORMAT "x(4)"
                _FileList-Name      COLUMN-LABEL "File Name"    FORMAT "x(40)"
                with frame FileList-frame WIDTH 132
                     down.
    end.
END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE show-InteractiveProcesses 
PROCEDURE show-InteractiveProcesses :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN report-head ("Clients: Local Interactive").
    for each _Connect where _Connect-Type = "SELF" NO-LOCK:
      {&display} SKIP(1)
                _Connect-Id       LABEL "Usr"         FORMAT ">>>>9"
                _Connect-Name     LABEL "Name"
                _Connect-Type     LABEL "Type"
                _Connect-Wait     LABEL "Wait"   FORMAT "x(5)"
                _Connect-Wait1    LABEL "Wait1"  FORMAT ">>>>>>9"
                _Connect-TransId  LABEL "Trans id"
                _Connect-Time     LABEL "Login time"
                _Connect-Pid      LABEL "Pid"    FORMAT ">>>>9"
                with frame Connect-frame
                     down.
    end.
END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE show-LockReq 
PROCEDURE show-LockReq :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN report-head ("Other: Lock Requests").

  for each _LockReq where _LockReq-name <> ? NO-LOCK:
    {&display} SKIP(1)
               _LockReq-Num      COLUMN-LABEL "User!Number"  FORMAT ">>>>9"
               _LockReq-Name     COLUMN-LABEL "User!Name"    FORMAT "x(8)"
               _LockReq-RecLock  COLUMN-LABEL "Record!Locks" FORMAT ">>>>>>>9"
               _LockReq-RecWait  COLUMN-LABEL "Record!Waits" FORMAT ">>>>>>>9"
               _LockReq-TrnLock  COLUMN-LABEL "Trans!Locks"  FORMAT ">>>>>>>9"
               _LockReq-TrnWait  COLUMN-LABEL "Trans!Waits"  FORMAT ">>>>>>>9"
               _LockReq-SchLock  COLUMN-LABEL "Schema!Locks" FORMAT ">>>>>>>9"
               _LockReq-SchWait  COLUMN-LABEL "Schema!Waits" FORMAT ">>>>>>>9"
               skip
               with frame LockReq-frame
                 down.
  end.

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE show-Locks 
PROCEDURE show-Locks :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN report-head ("Locks: All Locks").
    for each _Lock where _Lock-Usr <> ? NO-LOCK:
      {&display} SKIP(1)
                _Lock-Id         COLUMN-LABEL "Lock Id"     FORMAT ">>>>9"
                _Lock-Usr        COLUMN-LABEL "Usr"
                _Lock-Name       COLUMN-LABEL "Name"
                _Lock-Type       COLUMN-LABEL "Type"
                _Lock-Recid      COLUMN-LABEL "RECID"
                _Lock-Chain      COLUMN-LABEL "Chain"
                _Lock-Flags      COLUMN-LABEL "Flags"
                with frame Lock-All-frame
                     down.
    end.

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE show-Logging 
PROCEDURE show-Logging :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN report-head ("Status: Logging Summary ").
    for each _Logging NO-LOCK:
      {&display} SKIP(1)
                _Logging-CrashProt   LABEL "Crash protection"
                                     COLON 32
                _Logging-CommitDelay LABEL "Delayed Commit"
                                     COLON 32
                _Logging-BiIO        LABEL "Before-image I/O"
                                     COLON 32
                _Logging-BiClAge     LABEL "Before-image cluster age time"
                                     COLON 32
/*
                                           "BI Writer status"
*/
                _Logging-2PC         LABEL "Two Phase Commit"
                                     COLON 32
                _Logging-AiJournal   LABEL "After-image journalling"
                                     COLON 32
                _Logging-AiIO        LABEL "After-image I/O"
                                     COLON 32
/*
                                           "AI Writer status"
*/
                with frame Logging-Frame
                     side-labels.
    end.

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE show-RemoteProcesses 
PROCEDURE show-RemoteProcesses :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN report-head ("Clients: Remote").
    for each _Connect where
                      _Connect-Type = "REMC"
                      NO-LOCK:
      {&display} SKIP(1)
                _Connect-Id       LABEL "Usr"    FORMAT ">>>>9"
                _Connect-Name     LABEL "Name"
                _Connect-Type     LABEL "Type"
                _Connect-Wait     LABEL "Wait"   FORMAT "x(5)"
                _Connect-Wait1    LABEL "Wait1"  FORMAT ">>>>>>9"
                _Connect-TransId  LABEL "Trans id"
                _Connect-Time     LABEL "Login time"
                _Connect-Server   LABEL "Serv"   FORMAT ">>>>9"
                with frame Connect-frame
                     down.
    end.

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE show-Segments 
PROCEDURE show-Segments :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN report-head ("Status: Shared Memory Segments").
    for each _Segments NO-LOCK:
        {&display} SKIP(1)
                _Segment-Id        LABEL "Segment #"    FORMAT ">>>9"
                _Segment-SegId     LABEL "Segment Id"
                _Segment-SegSize   LABEL "Segment Size"
                _Segment-BytesUsed LABEL "Used"
                _Segment-ByteFree  LABEL "Free"
                with frame Segment-frame
                     down.
    end.

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE show-Servers 
PROCEDURE show-Servers :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN report-head ("Status: Servers").
    for each _Servers NO-LOCK:
     {&display} SKIP(1)
                _Server-Id          COLUMN-LABEL "Srv!id"      FORMAT ">>>9"
                _Server-Num         COLUMN-LABEL "Srv!Num"     FORMAT ">>>>9"
                _Server-Pid         COLUMN-LABEL "Pid"         FORMAT ">>>>9"
                _Server-Type        COLUMN-LABEL "Type"
                _Server-Protocol    COLUMN-LABEL "Protocol"    FORMAT "x(8)"
                _Server-Logins      COLUMN-LABEL "Logins"      FORMAT ">>>>9"
                _Server-CurrUsers   COLUMN-LABEL "Curr!Users"  FORMAT ">>>>9"
                _Server-MaxUsers    COLUMN-LABEL "Max!Users"   FORMAT ">>>>9"
                _Server-PortNum     COLUMN-LABEL "Port!Num"    FORMAT ">>>>9"
                with frame Server-frame WIDTH 132
                     down.
    end.

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE show-StartupParameters 
PROCEDURE show-StartupParameters :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN report-head ("Other: Startup Parameters").
   /* for each _DbParams NO-LOCK:
      {&display}
         _DbParams-Desc _DbParams-Value
                              COLON 44
       /* _Startup-AiName       LABEL "After-image file name (-a)"
                              COLON 44
        _Startup-Buffs        LABEL "Number of database buffers (-B)"
                              COLON 44
        _Startup-AiBuffs      LABEL "Number of after image buffers (-aibufs)"
                              COLON 44
        _Startup-BiBuffs      LABEL "Number of before image buffers (-bibufs)"
                              COLON 44
        _Startup-BiName       LABEL "Before-image file name (-g)"
                              COLON 44
        _Startup-BiTrunc      LABEL "Before-image truncate interval (-G)"
                              COLON 44
        _Startup-CrashProt    LABEL "No crash protection (-i)"
                              COLON 44
        _Startup-Directio     LABEL "Directio startup option enabled (-dirctio)"
                              COLON 44
        _Startup-LockTable    LABEL "Current size of locking table (-L)"
                              COLON 44
        _Startup-MaxClients   LABEL "Maximum number of clients per server (-Ma)"
                              COLON 44
        _Startup-BiDelay      LABEL "Delay of before-image flush (-Mf)"
                              COLON 44
        _Startup-BiDelay      LABEL "Delay of before-image flush (-Mf)"
                              COLON 44
        _Startup-MaxServers   LABEL "Maximum number of servers (-Mn)"
                              COLON 44
        _Startup-MaxUsers     LABEL "Maximum number of users (-n)"
                              COLON 44
        _Startup-BiIO         LABEL "Before-image file I/O (-r -R)"
                              COLON 44
        _Startup-APWQTime     LABEL "APW queue check time"
                              COLON 44
        _Startup-APWSTime     LABEL "APW scan time"
                              COLON 44
        _Startup-APWBuffs     LABEL "APW buffers to scan"
                              COLON 44
        _Startup-APWMaxWrites LABEL "APW max writes / scan"
                              COLON 44 */
                with frame Startup-Frame
                     side-labels.
    end.  */

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE show-TwoPhaseCommit 
PROCEDURE show-TwoPhaseCommit :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN report-head ("Status: Two-Phase Commit").
    for each _Logging NO-LOCK:
     {&display} SKIP(1)
                _Logging-2PCNickName LABEL "Coordinator nickname"
                                     COLON 32
                _Logging-2PCPriority LABEL "Coordinator priority"
                                     COLON 32
                _Logging-CommitDelay LABEL "Delayed commit"
                                     COLON 32
                _Logging-AiJournal   LABEL "After-image Journalling"
                                     COLON 32
                with frame 2PC-Logging-Frame
                     side-labels.
    end.

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE show-UserLocks 
PROCEDURE show-UserLocks :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var i as integer no-undo.

    RUN report-head ("Locks: By User").
    for each _UserLock where _UserLock-Usr <> ? NO-LOCK
             with frame UserLock-frame:

      {&display} SKIP(1)
                _UserLock-Id
                _UserLock-Usr
                _UserLock-Name.
        do i = 1 to 34:
            if (_UserLock-Recid[i] <> ?)   then
            do:
              {&display}
                    _UserLock-Type[i]
                    _UserLock-Recid[i]
                    _UserLock-Chain[i]
                    _UserLock-Flags[i].
                down with frame UserLock-frame WIDTH 132.
            end.
         end.
    end.

END PROCEDURE.
&ANALYZE-RESUME
 

