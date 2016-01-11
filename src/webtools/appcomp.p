&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2001 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*  Per S Digre (pdigre@progress.com)                                 *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
    File        : appcomp.p
    Purpose     : Database utilities
    Updated     : 03/07/01 pdigre@progress.com
                    Initial version
                  04/27/01 adams@progress.com
                    WebSpeed integration
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
{ webtools/plus.i }

DEFINE VARIABLE cDBname        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDBini         AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPFvalue       AS CHARACTER NO-UNDO. /* *.pf file content */
DEFINE VARIABLE cPF            AS CHARACTER NO-UNDO. /* *.pf file location */
DEFINE VARIABLE lServed        AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lConnected     AS LOGICAL   NO-UNDO. /* Auto connections */
DEFINE VARIABLE lPrevConnected AS LOGICAL   NO-UNDO. /* Auto connections */

/***** Table formatting ****************************/
DEFINE VARIABLE iTableLevel    AS INTEGER   NO-UNDO.
DEFINE VARIABLE iLevel         AS INTEGER   NO-UNDO.
DEFINE VARIABLE iLine          AS INTEGER   NO-UNDO.

DEFINE STREAM s1.
DEFINE STREAM s2.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fDisp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fDisp Procedure 
FUNCTION fDisp RETURNS CHARACTER
  ( c1 AS CHARACTER,
    lHeader AS LOGICAL, 
    cformat AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

ASSIGN
  cFormTitle   = "Database Utilities"
  cFormTarget  = "appcomp"
  cFormBack    = "window.open('appmgr.p','_self')"
  cFormHelp    = "appcomp"
  cFormRefresh = "document.form.submit()".

RUN amDBinit.

ASSIGN 
  lPrevConnected = CONNECTED(cDBName)
  lConnected     = CONNECTED(cDBName)
  lServed        = SEARCH(REPLACE(cDBini,".db","") + ".lk") > "".

IF get-value("frame") > "" OR get-value("do") = "" THEN DO:
  fHeader().
  {&OUT}  "<BR>Action: " get-value("do").

  RUN amDBview.
  RUN pFrame("appcomp","db,do,format,return").
  RUN amDBframes.

  fFooter().
END.
ELSE
  RUN pFrame("appcomp","db,do,format,return").

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-amDBFrames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE amDBFrames Procedure 
PROCEDURE amDBFrames :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /**** Start database ****/
  IF (GET-VALUE("frame") = "end" AND cAction = "serve") AND 
    get-value("return") > "" THEN DO:
    IF lServed THEN DO:
      {&OUT} '<H2> Start connecting </H2>~n'
             '<SCRIPT LANGUAGE="Javascript">~n'
             '  window.open("appcomp.p?return=' get-value("return") '&db=' get-value('db') '&Do=connect","_self")~;~n'
             '</SCRIPT>~n'.
    END.
    ELSE {&OUT} "<H2> Cannot start dataserver. </H2>" SKIP.
  END.

  /**** Continue connecting agents ****/
  IF (cAction = "connect" AND (NOT lPrevConnected)) AND 
    get-value("return") > "" THEN DO:
    IF lConnected THEN DO:
      {&OUT} '<H2> Continue connecting </H2>~n'
             '<SCRIPT LANGUAGE="Javascript">~n'
             '  window.open("appcomp.p?return='  GET-VALUE("return")  '&DB='  cDBini  '&Do=connect","_self")~;~n'
             '</SCRIPT>~n'.
    END.
    ELSE {&OUT} "<H2> Cannot connect to dataserver. </H2>" SKIP.
  END.

  /**** Finished connecting *****/
  IF ((cAction = "connect" AND lPrevConnected) OR (cAction = "shut" AND 
    get-value("frame") = "end")) AND get-value("return") > "" THEN DO:
    {&OUT} '<SCRIPT LANGUAGE="Javascript">~n'
           '  window.open("'  GET-VALUE("return")  '.p","_self")~;~n'
           '</SCRIPT>~n'.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-amDBInit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE amDBInit Procedure 
PROCEDURE amDBInit :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE i1  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE c1  AS CHARACTER  NO-UNDO.

  ASSIGN
    cDBini  = ENTRY(INTEGER(GET-VALUE("db")),cDB) /* Default to Unix file syntax (not in URL) */
    cPF     = REPLACE(cDBini,".db","") + ".pf".


  IF GET-VALUE("pf") > "" THEN DO:
    cPFvalue = GET-VALUE("pf").
    IF cAction = "save" THEN DO:         /* Save the *.pf file */
      DYNAMIC-FUNCTION ("LogNote" IN web-utilities-hdl,
                        "RUN", "SAVE PF:" + cPF) NO-ERROR.
      OUTPUT STREAM s1 TO VALUE(cPF).
      PUT STREAM s1 UNFORMATTED cPFvalue "~n".
      OUTPUT STREAM s1 CLOSE.
    END.
  END.
  ELSE DO:
    DYNAMIC-FUNCTION ("LogNote" IN web-utilities-hdl,
                      "RUN", "READ PF:" + cPF) NO-ERROR.
    OUTPUT STREAM s1 TO VALUE(cPF) APPEND. /* Create a *.pf file if not there */
    PUT STREAM s1 UNFORMATTED "~n".        /* Make sure it stops with LF */
    OUTPUT STREAM s1 CLOSE.
    INPUT STREAM s1 FROM VALUE(cPF).     /* Read the *.pf file */
    REPEAT:
      ASSIGN c1 = ''.
      IMPORT STREAM s1 UNFORMATTED c1.
      ASSIGN cPFvalue = cPFvalue + c1 + " ".
    END.
    INPUT STREAM s1 CLOSE.
    ASSIGN 
      cPFvalue = TRIM(REPLACE(REPLACE(cPFvalue,"    "," "),"  "," "))
      cDBName  = (IF LOOKUP("-ld",cPFvalue," ") > 0
                  THEN ENTRY(LOOKUP("-ld",cPFvalue," ") + 1,cPFvalue," ")
                  ELSE ENTRY(1,ENTRY(NUM-ENTRIES(cDBini,"/"),cDBini,"/"),".")).
    DYNAMIC-FUNCTION ("LogNote" IN web-utilities-hdl,
                      "RUN", "PF=" + cPFvalue) NO-ERROR.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-amDBView) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE amDBView Procedure 
PROCEDURE amDBView :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  {&OUT} 
    '  <NOBR>' cPF '&nbsp;&nbsp;<INPUT TYPE="text" NAME="pf" SIZE="40" VALUE="' cPFvalue '">~n'
    '   <INPUT TYPE="hidden" NAME="db" VALUE="' get-value("db") '">~n'
    '   <INPUT TYPE="button" NAME="save" VALUE="Save" onClick="document.form.Do.value=''Save''~;document.form.submit()">~n'
    '  </NOBR>~n'
    '  <BR> ' IF lServed THEN cDBName + ' currently ' + (IF CONNECTED(cDBname) THEN '' ELSE 'not ') + 'connected.' ELSE ''.

  {&OUT} fBeginTable("Type|Options").
  {&OUT} fRow("Manage|"
       + (IF lServed
    THEN fLink("Shut","","Shutdown")
       + fLink("DisConnect","","DisConnect")
       + fLink("Connect","","Connect")
    ELSE fLink("Serve","","Serve")) ).
  {&OUT} fRow("Maintain|"
       + (IF lServed
    THEN fLink("Backup","","Backup")
       + fLink("Incremental","","Incremental")
    ELSE fLink("idxbuild","","Index Rebuild")
       + fLink("Truncate","","Truncate BI")
       + fLink("dellog","","Truncate Log"))).
  IF lServed THEN 
    {&OUT} fRow("Online info|"
       + (IF opsys<>'win32' THEN fLink("sharedmem","","Shared Mem") ELSE '')
       + fLink("ixanalys","","Index Blocks")
       + fLink("tabanalys","","Record Blocks")).
  ELSE 
    {&OUT} fRow("Offline info|"
       + fLink("idxcheck","","Index Check")
       + fLink("chanalys","","Chain Blocks")
       + fLink("structstat","","Storage Util")
       + fLink("iostats","","IO Stats")).
  {&OUT}
         fRow("Other|"
       + fLink("trimV9","","Trim V9 Dumpdata to V8-loadable.")).
  {&OUT} "</TABLE>".

  ASSIGN iLevel = 0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-DBCmd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DBCmd Procedure 
PROCEDURE DBCmd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER cTempfile AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cCmd   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDBini AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cIn    AS CHARACTER  NO-UNDO.

  ASSIGN
    cDBini = ENTRY(INTEGER(get-value("db")),cDB). /* Finding the database */
  DYNAMIC-FUNCTION ("LogNote" IN web-utilities-hdl,
                    "RUN","CMD:DB=" + cDBini) NO-ERROR.

  CASE get-value("do"):
    WHEN "serve"       THEN cCmd = "proserve " + cDBini + " -pf " + cPF.
    WHEN "shut"        THEN cCmd = "proshut " + cDBini + " -by -pf " + cPF.
    WHEN "sharedmem"   THEN cCmd = "proutil " + cDBini + " -C DBIPCS".
    WHEN "truncate"    THEN cCmd = "proutil " + cDBini + " -C truncate BI".
    WHEN "iostats"     THEN cCmd = "proutil " + cDBini + " -C iostats".
    WHEN "holder"      THEN cCmd = "proutil " + cDBini + " -C holder".
    WHEN "busy"        THEN cCmd = "proutil " + cDBini + " -C busy".
    WHEN "dellog"      THEN cCmd = "prolog  " + cDBini.
    WHEN "idxbuild"    THEN cCmd = "proutil " + cDBini + " -C idxbuild all".
    WHEN "ixanalys"    THEN cCmd = "proutil " + cDBini + " -C ixanalys".
    WHEN "tabanalys"   THEN cCmd = "proutil " + cDBini + " -C tabanalys".
    WHEN "idxcheck"    THEN cCmd = "proutil " + cDBini + " -C idxcheck all".
    WHEN "backup"      THEN cCmd = "probkup online " + cDBini + " " + cDBini + ".bkup -com -verbose".
    WHEN "incremental" THEN cCmd = "probkup online " + cDBini + " incremental " + cDBini + ".ibkup -com -verbose".
    WHEN "structstat"  THEN cCmd = "prostrct statistics " + cDBini.
    WHEN "disconnect"  THEN DISCONNECT VALUE(cDBname) NO-ERROR.
    WHEN "connect"     THEN CONNECT VALUE(cDBini) -pf VALUE(cPF) NO-ERROR.
    WHEN "trimV9"      THEN RUN trimV9(cDBini).
  END CASE.

  DYNAMIC-FUNCTION ("LogNote" IN web-utilities-hdl,
                    "RUN", "TEMP:" + cTempfile) NO-ERROR.
  OUTPUT STREAM s2 TO VALUE(cTempfile).
  PUT STREAM s2 UNFORMATTED "<b>" cCmd "</b>~n" SKIP.
  OUTPUT STREAM s2 CLOSE.

  IF cCmd > "" THEN DO:
    DYNAMIC-FUNCTION ("LogNote" IN web-utilities-hdl,
                      "RUN", "DB CMD:" + cCmd) NO-ERROR.
    INPUT STREAM s1 THROUGH VALUE(fBat(cCmd)).
    REPEAT:
      IMPORT STREAM s1 UNFORMATTED cIn.
      OUTPUT STREAM s2 TO VALUE(cTempfile) APPEND.
      PUT STREAM s2 UNFORMATTED cIn "~n".
      OUTPUT STREAM s2 CLOSE.
    END.
    INPUT STREAM s1 CLOSE.
  END.

  OUTPUT STREAM s2 TO VALUE(cTempfile) APPEND.
  PUT STREAM s2 UNFORMATTED SKIP(1) "ReportIsFinished~n".
  OUTPUT STREAM s2 CLOSE.

  RETURN cCmd.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-formatEditor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE formatEditor Procedure 
PROCEDURE formatEditor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER c1 AS CHARACTER NO-UNDO.
  
  {&OUT} c1 "~n".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-formatOutput) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE formatOutput Procedure 
PROCEDURE formatOutput :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  DEFINE INPUT PARAMETER c1 AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE i1        AS INTEGER    NO-UNDO.
  
  CASE cAction:
    WHEN "ixanalys" THEN DO:
      IF c1 MATCHES "*-----*" THEN RETURN.
      IF c1 MATCHES "*=====*" THEN RETURN.
      IF TRIM(c1) = "" THEN RETURN.

      fDisp(c1,NOT c1 MATCHES " *","24,8,8,7,8,8,9,7,100").

      IF c1 MATCHES "* INDEX BLOCK SUMMARY *" THEN 
        iLevel = iLevel + 1.
      IF c1 MATCHES "*Totals:*" THEN 
        iLevel = iLevel - 1.
    END.
    WHEN "tabanalys" THEN DO:
      IF TRIM(c1) = "" THEN RETURN.

      fDisp(c1,c1 MATCHES " *" OR c1 BEGINS "Table ","20,8,10,6,6,7,9,8,7,100").

      IF c1 MATCHES "* RECORD BLOCK SUMMARY *" THEN 
        iLevel = iLevel + 1.
      IF c1 MATCHES "*Totals:*" 
        THEN iLevel = iLevel - 1.
    END.
    OTHERWISE DO:
      IF TRIM(c1) = "" THEN RETURN.
      fDisp(c1,FALSE,"").
    END.
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pFrame) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pFrame Procedure 
PROCEDURE pFrame :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAM cProg  AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAM cLink  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cFrame    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cIn       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTemp     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lFinished AS LOGICAL    NO-UNDO.

  IF get-value('time') = '' THEN 
    set-user-field("time",STRING(TIME)).
  IF get-value('temp') = '' THEN 
    set-user-field("temp",STRING(RANDOM(100000,999999))).

  ASSIGN
    cLink  = cProg + ".p?" + url-field-list("temp,time," + cLink,"&") + "&frame="
    cFrame = get-value("frame")
    cTemp  = SESSION:TEMP-DIR + get-value("TEMP") + ".tmp".

  CASE GET-VALUE("frame"):
    WHEN "Stat" THEN {&OUT} "<B>Executing: " + STRING(TIME - INTEGER(get-value('time')),"HH:MM:SS") + "</B>".
    WHEN "End"  THEN {&OUT} "<B>Finished:</B>".
    WHEN "Exec" THEN {&OUT} "<B>Start:</B>".
  END CASE.
  IF CAN-DO("ixanalys,tabanalys",cAction) THEN /* Show status window */
    set-user-field("format","formatOutput").   /* use formatOutput as formatting procedure */
  ELSE 
    set-user-field("format","formatEditor").   /* use TEXTAREA box */



  DYNAMIC-FUNCTION ("LogNote" IN web-utilities-hdl,
                    "RUN","Frame/" + cFrame + ":" + cLink) NO-ERROR.
  CASE cFrame:
    WHEN "exec" THEN DO:
      RUN DBcmd(cTemp).
      {&OUT}
        '<HTML><HEAD><TITLE>Processing</TITLE></HEAD><BODY>~n'
        '<SCRIPT LANGUAGE="JavaScript"> ~n'
        "window.open('" + cLink + "end','_parent') ~n"
        '</SCRIPT>~n'
        '</BODY></HTML>~n'.
    END.

    WHEN "stat" OR WHEN "end" THEN DO:
      {&OUT} 
        "<BR>Time elapsed:" + 
        STRING(TIME - INTEGER(get-value('time')),"HH:MM:SS") "<BR>" SKIP.
      {&OUT} "<PRE>".
      IF SEARCH(cTemp) > "" THEN DO:
        INPUT STREAM s2 FROM VALUE(cTemp).
        REPEAT:
          IMPORT STREAM s2 UNFORMATTED cIn.
          IF cIn BEGINS "ReportIsFinished" THEN
            lFinished = TRUE.
          ELSE 
            RUN VALUE(get-value("format")) (cIn).
        END.
        INPUT STREAM s2 CLOSE.
      END.
/*
      ELSE 
        lFinished = TRUE.
*/
      {&OUT} "</PRE>".

      IF cFrame = "stat" THEN DO:
        {&OUT} '<SCRIPT LANGUAGE="JavaScript">    ~n'.
        IF lFinished THEN
          {&OUT} "window.open('" + cLink + "end','_parent') ~n".
        ELSE DO:
          {&OUT}
            'var timerID = null  ~n'
            'timerID = setTimeout("RefreshConfirm()",3000)  ~n'
            'function RefreshConfirm() ~{  ~n'
            '  clearTimeout(timerID)  ~n'
            "   window.open('" cLink  + "stat~',~'stat~') ~n"
            '~}  ~n'.
        END.
        {&OUT} '</SCRIPT>~n'
               '</BODY></HTML>~n'.
      END.
    END.
    OTHERWISE DO:
      {&OUT}
        '<HTML><HEAD><TITLE>Start processing</TITLE></HEAD>~n'
        ' <FRAMESET ROWS="*,0">~n'
        '  <FRAME NAME="stat" SRC="' cLink 'stat"~n'
        '         FRAMEBORDER="yes" MARGINHEIGHT="15" MARGINWIDTH="10">~n'
        '  <FRAME NAME="exec" SRC="' cLink 'exec" SCROLLING="no"~n'
        '         FRAMEBORDER="yes" MARGINHEIGHT="0" MARGINWIDTH="0">~n'
        ' </FRAMESET>~n'
        '<NOFRAME></NOFRAME></HTML>~n'.
    END.
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-trimV9) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trimV9 Procedure 
PROCEDURE trimV9 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE i1            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE c1            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE c2            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFile         AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAM cDir       AS CHARACTER  NO-UNDO.

  ASSIGN cDir = SUBSTRING(cDir,1,R-INDEX(cDir,"/") - 1).
  {&OUT} "Trimming Directory: " cDir "<BR>" SKIP.

  INPUT STREAM s1 FROM OS-DIR(cDir).
  REPEAT:
    IMPORT STREAM s1 cFile.
    IF cFile MATCHES "*.df" THEN DO:
      {&OUT} "Processing Definitions: " cFile "<BR>" SKIP.

      INPUT  STREAM s1 FROM VALUE(cDir + "/" + cFile).
      OUTPUT STREAM s2 TO   VALUE(cDir + "/temp.df").
      REPEAT:
        ASSIGN c1 = "".
        IMPORT STREAM s1 UNFORMATTED c1.
        IF c1 MATCHES "* area *"
        OR c1 MATCHES "* SQL-WIDTH *"
        THEN NEXT.
        PUT STREAM s2 UNFORMATTED c1 SKIP.
      END.
      INPUT  STREAM s1 CLOSE.
      OUTPUT STREAM s2 CLOSE.

      OS-DELETE VALUE(cDir + "/" + cFile).
      OS-RENAME VALUE(cDir + "/temp.df") VALUE(cDir + "/" + cFile).
    END.
    IF cFile MATCHES "*.d" THEN DO:
      {&OUT} "Processing Definitions: " cFile "<BR>" SKIP.

      INPUT  STREAM s1 FROM VALUE(cDir + "/" + cFile).
      OUTPUT STREAM s2 TO   VALUE(cDir + "/temp.d").
      REPEAT:
        ASSIGN c1 = "".
        IMPORT STREAM s1 UNFORMATTED c1.
        IF c1 MATCHES "*numformat=44,46*"
        THEN c1 = "numformat=.".
        PUT STREAM s2 UNFORMATTED c1 SKIP.
      END.
      INPUT  STREAM s1 CLOSE.
      OUTPUT STREAM s2 CLOSE.

      OS-DELETE VALUE(cDir + "/" + cFile).
      OS-RENAME VALUE(cDir + "/temp.d") VALUE(cDir + "/" + cFile).
    END.
  END.
  INPUT STREAM s1 CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fDisp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fDisp Procedure 
FUNCTION fDisp RETURNS CHARACTER
  ( c1 AS CHARACTER,
    lHeader AS LOGICAL, 
    cformat AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE i1         AS INTEGER  NO-UNDO.

  IF iTableLevel > iLevel AND iTableLevel > 0 THEN 
    {&OUT} "</TD></TR>" SKIP.
  IF iTablelevel > iLevel                     THEN 
    {&OUT} "</TABLE><PRE>" SKIP.
  IF iTableLevel < iLevel AND iLevel > 0      THEN 
    {&OUT} "<TR" {&cColorRow1} "><TD>".
  IF iTablelevel < iLevel                     THEN 
    {&OUT} "</PRE><TABLE>".

  IF iLevel > 0 THEN DO:
    {&OUT} IF lHeader THEN ("<TR" + {&cColorHeader} + ">") 
                      ELSE ("<TR" + {&cColorRow1} + ">").
    DO i1 = 1 TO NUM-ENTRIES(cFormat):
      IF lHeader THEN
        {&OUT} 
          "<TH><NOBR>" TRIM(SUBSTRING(c1,1,INTEGER(ENTRY(i1,cFormat)))) 
          "</NOBR></TH>".
      ELSE 
        {&OUT} 
          "<TD><NOBR>" TRIM(SUBSTRING(c1,1,INTEGER(ENTRY(i1,cFormat)))) 
          "</NOBR></TD>".
      ASSIGN SUBSTRING(c1,1,INTEGER(ENTRY(i1,cFormat))) = "".
    END.
    {&OUT} "</TR>" SKIP.
  END.
  ELSE {&OUT} c1 SKIP.

  ASSIGN iTableLevel = iLevel.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

