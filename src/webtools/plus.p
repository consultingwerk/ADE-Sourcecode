&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------
File: plus.p
Purpose: Generic code library for use in all Plus programs.
Updated: 04/04/98 pdigre@progress.com
           Intial version
         04/25/01 adams@progress.com
           WebSpeed integration
---------------------------------------------------------------------*/
{ src/web/method/cgidefs.i }

DEFINE NEW GLOBAL SHARED VARIABLE cBrk         AS CHARACTER NO-UNDO.  /** am server config   **/
DEFINE NEW GLOBAL SHARED VARIABLE cDB          AS CHARACTER NO-UNDO.  /** am server config   **/
DEFINE NEW GLOBAL SHARED VARIABLE cDir         AS CHARACTER NO-UNDO.  /** am app config      **/
DEFINE NEW GLOBAL SHARED VARIABLE cLib         AS CHARACTER NO-UNDO.  /** am app config      **/

DEFINE NEW GLOBAL SHARED VARIABLE cStatic      AS CHARACTER NO-UNDO.  /** location of images **/
DEFINE NEW GLOBAL SHARED VARIABLE cFormTarget  AS CHARACTER NO-UNDO.  /** HTML Header param  **/
DEFINE NEW GLOBAL SHARED VARIABLE cFormHelp    AS CHARACTER NO-UNDO.  /** HTML Header param  **/
DEFINE NEW GLOBAL SHARED VARIABLE cFormBack    AS CHARACTER NO-UNDO.  /** HTML Header param  **/
DEFINE NEW GLOBAL SHARED VARIABLE cFormRefresh AS CHARACTER NO-UNDO.  /** HTML Header param  **/
DEFINE NEW GLOBAL SHARED VARIABLE cFormTitle   AS CHARACTER NO-UNDO.  /** HTML Header param  **/

DEFINE NEW GLOBAL SHARED VARIABLE cAction      AS CHARACTER NO-UNDO.  /** HTML Command       **/
DEFINE NEW GLOBAL SHARED VARIABLE cName        AS CHARACTER NO-UNDO.  /** HTML param         **/
DEFINE NEW GLOBAL SHARED VARIABLE cFiles       AS CHARACTER NO-UNDO.  /** Files selected     **/
DEFINE NEW GLOBAL SHARED VARIABLE cPath        AS CHARACTER NO-UNDO.  /** CodePath selected  **/

DEFINE NEW GLOBAL SHARED VARIABLE cProPath     AS CHARACTER NO-UNDO. /** list of full paths to non progress directories ***/
DEFINE NEW GLOBAL SHARED VARIABLE cDirCD       AS CHARACTER NO-UNDO. /** Current directory **/
DEFINE NEW GLOBAL SHARED VARIABLE cPlusDir     AS CHARACTER NO-UNDO. /** PLUS directory    **/
DEFINE NEW GLOBAL SHARED VARIABLE cPlusHTML    AS CHARACTER NO-UNDO. /** PLUS HTML directory    **/
DEFINE NEW GLOBAL SHARED VARIABLE cDLC         AS CHARACTER NO-UNDO. /** DLC install directory **/

DEFINE STREAM s1.

/* File & directory utilities */
DEFINE VARIABLE cDirRelPP AS CHARACTER  NO-UNDO.

/* Generic object definition section */
DEFINE VARIABLE hParent   AS HANDLE     NO-UNDO.
DEFINE VARIABLE cCallback AS CHARACTER  NO-UNDO.

/* Configuration files read & save */
DEFINE VARIABLE cPlusAppStamp AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cPlusApp      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cPlusIniStamp AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cPlusIni      AS CHARACTER  NO-UNDO.

DEFINE VARIABLE lRunLog   AS LOGICAL    NO-UNDO.

PROCEDURE OpenProcess EXTERNAL "KERNEL32.DLL":
  DEFINE INPUT  PARAMETER intAccess        AS LONG.
  DEFINE INPUT  PARAMETER intInherit       AS LONG.
  DEFINE INPUT  PARAMETER intProcessId     AS LONG.
  DEFINE RETURN PARAMETER intProcessHandle AS LONG.
END PROCEDURE.

PROCEDURE TerminateProcess EXTERNAL "KERNEL32.DLL":
  DEFINE INPUT  PARAMETER intProcessID AS LONG.
  DEFINE INPUT  PARAMETER intExitCode  AS LONG.
  DEFINE RETURN PARAMETER intResult    AS LONG.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fBat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fBat Procedure 
FUNCTION fBat RETURNS CHARACTER
  ( cCmd AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fCheckDir) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fCheckDir Procedure 
FUNCTION fCheckDir RETURNS CHARACTER
  ( cDir AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fFilesInDir) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fFilesInDir Procedure 
FUNCTION fFilesInDir RETURNS CHARACTER
  ( cDir AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fFooter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fFooter Procedure 
FUNCTION fFooter RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fHeader) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fHeader Procedure 
FUNCTION fHeader RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fIniLoad) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fIniLoad Procedure 
FUNCTION fIniLoad RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fIniSave) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fIniSave Procedure 
FUNCTION fIniSave RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fNTKill) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fNTKill Procedure 
FUNCTION fNTKill RETURNS CHARACTER
  ( iPid AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fProPath) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fProPath Procedure 
FUNCTION fProPath RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fSetFiles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fSetFiles Procedure 
FUNCTION fSetFiles RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fTrim) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fTrim Procedure 
FUNCTION fTrim RETURNS CHARACTER
  ( c1 AS CHARACTER )  FORWARD.

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
         HEIGHT             = 17.91
         WIDTH              = 64.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
ASSIGN
  cDLC      = getEnv('DLC').
IF (cDLC = "" OR cDLC = ? ) AND OPSYS = "win32" THEN 
  GET-KEY-VALUE SECTION "Startup" KEY "DLC" VALUE cDlc.
IF cDLC = "" OR cDLC = ? THEN 
  cDLC = REPLACE(SEARCH("convmap.cp"),"/convmap.cp","").

cPlusDir = cDLC + "/properties/".
IF OPSYS = "win32" THEN ASSIGN
  cPlusDir = replace(cPlusDir,"/","~\").


ASSIGN
  cDirCD    = REPLACE(get-config("workdir"),"~\","/")
  cDirCD    = cDirCD + IF (SUBSTRING(cDirCD,LENGTH(cDirCD)) = "/") THEN "" ELSE "/"
  cProPath  = fProPath()
  cPlusApp  = cPlusDir + 'wt_' + WEB-CONTEXT:CONFIG-NAME + '.ini'
  cPlusIni  = cPlusDir + 'webtools.ini'
  cStatic   = get-config('wsRoot')
  .
ASSIGN
  lRunLog = DYNAMIC-FUNCTION("getAgentSetting":U IN web-utilities-hdl,"Logging":U,"","LogTypes":U) > "" NO-ERROR
  .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-setCallBack) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setCallBack Procedure 
PROCEDURE setCallBack :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER h1 AS HANDLE     NO-UNDO.
  DEFINE INPUT PARAMETER c1 AS CHARACTER  NO-UNDO.

  ASSIGN hParent   = h1
         cCallBack = c1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fBat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fBat Procedure 
FUNCTION fBat RETURNS CHARACTER
  ( cCmd AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR cBatfile AS CHAR NO-UNDO.
  ASSIGN cBatfile = SESSION:TEMP-DIR + "wt_" + WEB-CONTEXT:CONFIG-NAME + ".bat".
  DYNAMIC-FUNCTION ("LogNote" IN web-utilities-hdl,
          "RUN", "BAT:" + cBatfile) NO-ERROR.
  OUTPUT STREAM s1 TO VALUE(cBatfile).
  IF OPSYS = "win32" THEN DO:
    PUT STREAM s1 UNFORMATTED "SET DLC=" + cDLC SKIP.
  END.
  ELSE DO:
    PUT STREAM s1 UNFORMATTED "DLC=" + cDLC + ";export DLC" SKIP.
  END.

  PUT STREAM s1 UNFORMATTED cCmd SKIP.
  OUTPUT STREAM s1 CLOSE.
  RETURN '"' + SEARCH(cBatfile) + '"'.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fCheckDir) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fCheckDir Procedure 
FUNCTION fCheckDir RETURNS CHARACTER
  ( cDir AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE i1     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE c1     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE c2     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDirPP AS CHARACTER  NO-UNDO.

  ASSIGN
    cDir      = REPLACE(cDir,"~\","/")
    cDir      = cDir + IF (SUBSTRING(cDir,LENGTH(cDir)) = "/") THEN "" ELSE "/"
    cDirPP    = ?
    cDirRelPP = ?.

  DO i1 = 1 TO NUM-ENTRIES(cProPath):
    c1 = ENTRY(i1,cPropath).
    IF NOT cDir BEGINS c1 THEN NEXT.
    IF c1 < cDirPP THEN NEXT.
    ASSIGN
      cDirPP    = c1
      cDirRelPP = REPLACE(cDir,c1,"")
      .
  END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fFilesInDir) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fFilesInDir Procedure 
FUNCTION fFilesInDir RETURNS CHARACTER
  ( cDir AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cFiles AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE c1     AS CHARACTER  NO-UNDO.

  fCheckDir(cDir).
  IF cDirRelPP = ? THEN 
    cDirRelPP = cDir.

  INPUT STREAM s1 FROM OS-DIR(cDir).
  REPEAT:
    ASSIGN c1 = ''.
    IMPORT STREAM s1 c1.
    IF NOT CAN-DO("html,htm,w,i,p",ENTRY(NUM-ENTRIES(c1,"."),c1,".")) THEN NEXT.
    IF CAN-DO(cFiles,c1) THEN NEXT.
    cFiles = cFiles + (IF cFiles > "" THEN "," ELSE "") + cDirRelPP + c1.
  END.
  INPUT STREAM s1 CLOSE.

  RETURN cFiles.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fFooter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fFooter Procedure 
FUNCTION fFooter RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {&OUT} 
    '</FORM></BODY></HTML>~n'.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fHeader) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fHeader Procedure 
FUNCTION fHeader RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Generic look and feel
    Notes:  
------------------------------------------------------------------------------*/
 
  {&OUT} 
    '<HTML>~n<HEAD>~n<TITLE>' cFormTitle '</TITLE>~n'
    '<META NAME="author" CONTENT="POSSE Developer">~n'
    '<STYLE>BR.page ~{ page-break-after:always ~}</STYLE>~n'
    '</HEAD>~n'
    '<BODY BACKGROUND="' cStatic '/images/bgr/wsbgr.gif" BGCOLOR="#FFFFCC" TEXT="#990000" LINK="#660066" VLINK="#990000" ALINK="#990000">~n'.

  {&OUT} 
    '<FORM NAME="form" METHOD="get" ACTION="' cFormTarget '.p">~n'
    '<TABLE BORDER="0" WIDTH="100%"><TR>~n'
    '<TD ALIGN="LEFT">~n'
    '  <IMG SRC="' cStatic '/images/l-tools.gif" BORDER="0" ALIGN="CENTER"> <FONT SIZE="+2" COLOR="#660066"><B>' cFormTitle '</B></FONT></TD>~n'
    '<TD ALIGN="RIGHT">'.
  IF cFormBack > "" THEN {&OUT} 
    '<INPUT TYPE="button" NAME="Back"    VALUE="Back"    onClick="' cFormBack '">&nbsp;~n'.
  {&OUT} 
    '<INPUT TYPE="button" NAME="Refresh" VALUE="Refresh" onClick="' cFormRefresh '">~n'.
  IF lRunLog THEN 
    {&OUT} 
      '<SMALL><A HREF="viewlog.p">View Log</A></SMALL>~n'.

  {&OUT} 
    '<A HREF="' cStatic '/doc/wshelp/' cFormHelp '.htm" TARGET="helpWindow"~n'
    '  onClick="window.open('''',''helpWindow'',''width=630,height=400,menubar=1,toolbar=1,location=1,scrollbars=1,resizable=1,status=1'')~;">~n'
    '<IMG SRC="' cStatic '/images/help.gif" BORDER="0" ALT="Help"></A></TD>~n'
    '</TR>~n</TABLE>~n'.

  {&OUT} 
    '<CENTER><IMG SRC="' cStatic '/images/wsrule.gif" HEIGHT="3" WIDTH="100%"></CENTER>~n'
    '<INPUT TYPE="hidden" NAME="Name"  VALUE="' GET-VALUE('Name') '">~n'
    '<INPUT TYPE="hidden" NAME="Do"    VALUE="' GET-VALUE('Do') '">~n' SKIP.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fIniLoad) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fIniLoad Procedure 
FUNCTION fIniLoad RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE i1 AS INTEGER    NO-UNDO.
  DEFINE VARIABLE c1 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE c2 AS CHARACTER  NO-UNDO.


  /* Section for reading common variables used in all programs */
  ASSIGN
    cAction  = get-value("Do")
    cName    = get-value('Name').
    cFiles = "".

  /* Reading the server configuration */
  ASSIGN c1 = "".
  IF SEARCH(cPlusIni) > "" THEN DO:
    ASSIGN FILE-INFO:FILE-NAME = cPlusIni.
    IF cPlusIniStamp <> STRING(FILE-INFO:FILE-MOD-DATE) + '-' + 
      STRING(FILE-INFO:FILE-MOD-TIME,'hh:mm:ss') THEN DO:
      DYNAMIC-FUNCTION ("LogNote" IN web-utilities-hdl,
                        "RUN", "Read:" + cPlusIni) NO-ERROR.

      INPUT STREAM s1 FROM value(cPlusIni).
      REPEAT:
        ASSIGN c2 = "".
        IMPORT STREAM s1 UNFORMATTED c2.
        ASSIGN c1  = c1 + TRIM(c2) + "|"
               c2 = "".
      END.
      INPUT STREAM s1 CLOSE.
      ASSIGN
        cPlusIniStamp = STRING(FILE-INFO:FILE-MOD-DATE) + '-' + 
                        STRING(FILE-INFO:FILE-MOD-TIME,'hh:mm:ss')
        c1   = c1 + "|||||||"
        cDB  = ENTRY(1,c1,"|")
        cBrk = ENTRY(2,c1,"|").
    END.
  END.

  /* Reading the application configuration */
  ASSIGN c1 = "".
  IF SEARCH(cPlusApp) > "" THEN DO:
    ASSIGN FILE-INFO:FILE-NAME = cPlusApp.
    IF cPlusAppStamp <> STRING(FILE-INFO:FILE-MOD-DATE) + '-' + 
      STRING(FILE-INFO:FILE-MOD-TIME,'hh:mm:ss') THEN DO:

      DYNAMIC-FUNCTION("LogNote" in web-utilities-hdl, "RUN",'Read:' + cPlusApp) NO-ERROR.
      INPUT STREAM s1 FROM value(cPlusApp).
      REPEAT:
        ASSIGN c2 = "".
        IMPORT STREAM s1 UNFORMATTED c2.
        ASSIGN c1  = c1 + TRIM(c2) + "|"
               c2 = "".
      END.
      INPUT STREAM s1 CLOSE.
      ASSIGN
        cPlusAppStamp = STRING(FILE-INFO:FILE-MOD-DATE) + '-' + 
                        STRING(FILE-INFO:FILE-MOD-TIME,'hh:mm:ss')
        c1   = c1 + "|||||||"
        cDir = ENTRY(1,c1,"|")
        cLib = ENTRY(2,c1,"|").
    END.
  END.
  
  /* Converting from old versions */
  DO i1 = 1 TO NUM-ENTRIES(cBrk): 
    IF NOT ENTRY(i1,cBrk) MATCHES "*:*"
    THEN ASSIGN ENTRY(i1,cBrk) = "WS:" + ENTRY(i1,cBrk).
  END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fIniSave) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fIniSave Procedure 
FUNCTION fIniSave RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DYNAMIC-FUNCTION ("LogNote" IN web-utilities-hdl,
                    "RUN", "Write:" + cPlusIni) NO-ERROR.
  ASSIGN 
    cDB  = fTrim(cDB)
    cDir = fTrim(cDir)
    cLib = fTrim(cLib)
    cBrk = fTrim(cBrk).

  IF cDb  BEGINS ",":U THEN 
    ASSIGN cDB = SUBSTRING(cDB,2).

  IF cBrk BEGINS ",":U THEN 
    ASSIGN cbrk = SUBSTRING(cBrk,2).

  OUTPUT STREAM s1 TO VALUE(cPlusIni).
  PUT STREAM s1 UNFORMATTED
    cDB  " " SKIP
    cBrk " " SKIP.
  OUTPUT STREAM s1 CLOSE.

  OUTPUT STREAM s1 TO VALUE(cPlusApp).
  PUT STREAM s1 UNFORMATTED
    cDir " " SKIP
    cLib " " SKIP.

  OUTPUT STREAM s1 CLOSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fNTKill) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fNTKill Procedure 
FUNCTION fNTKill RETURNS CHARACTER
  ( iPid AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iResult AS INTEGER NO-UNDO.
  DEFINE VARIABLE iHandle AS INTEGER NO-UNDO.

  RUN OpenProcess(1, 0, iPID, OUTPUT iHandle).

  IF iHandle <> 0 THEN DO:
    RUN TerminateProcess(iHandle, 0, OUTPUT iResult).
    RETURN (IF iResult = 1 THEN "Process Terminated" ELSE "Termination Failed").
  END.
  ELSE 
    RETURN "Unable to Obtain Process Handle".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fProPath) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fProPath Procedure 
FUNCTION fProPath RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Gives a simple code related Propath without the DLC related entries
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE i1 AS INTEGER    NO-UNDO.
  DEFINE VARIABLE c1 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE c2 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE c3 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE c4 AS CHARACTER  NO-UNDO.

  ASSIGN
    c1 = REPLACE(PROPATH,".,",cDirCD + ",")
    c2 = REPLACE(cDLC,"~\","/")
    c2 = c2 + IF (SUBSTRING(c2,LENGTH(c2)) = "/") THEN "" ELSE "/".
  DO i1 = 1 TO NUM-ENTRIES(c1):
    ASSIGN
      c4 = REPLACE(ENTRY(i1,c1),"~\","/")
      c4 = c4 + IF (SUBSTRING(c4,LENGTH(c4)) = "/") THEN "" ELSE "/".
    IF ENTRY(1,c4,"/") = "." THEN c4 = cDirCD + SUBSTRING(c4,2).
    IF NOT c4 BEGINS c2 THEN
      IF NOT CAN-DO(c3,c4) THEN
        c3 = c3 + ",":U + c4.
  END.

  RETURN SUBSTRING(c3,2).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fSetFiles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fSetFiles Procedure 
FUNCTION fSetFiles RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE i1 AS INTEGER    NO-UNDO.
  DEFINE VARIABLE c1 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE c2 AS CHARACTER  NO-UNDO.

  ASSIGN
    cFiles = "".
  
  /* Find files in all selected directories */
  DO i1 = 1 TO NUM-ENTRIES(cDir):
    IF GET-VALUE("dir" + STRING(i1)) > ""
    THEN ASSIGN c1 = c1 + "," + ENTRY(i1,cDir).
  END.

  DO i1 = 2 TO NUM-ENTRIES(c1):
    INPUT STREAM s1 FROM OS-DIR(ENTRY(i1,c1)).
    REPEAT:
      ASSIGN c2 = "X".
      IMPORT STREAM s1 c2.
      IF c2 = "X" THEN NEXT.
      IF CAN-DO('html,htm,w,p',ENTRY(NUM-ENTRIES(c2,'.'),c2,'.')) THEN
        cFiles = cFiles + "," + ENTRY(i1,c1) + c2.
    END.
    INPUT STREAM s1 CLOSE.
  END.

  IF cFiles BEGINS "," THEN 
    cFiles = SUBSTRING(cFiles,2).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fTrim) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fTrim Procedure 
FUNCTION fTrim RETURNS CHARACTER
  ( c1 AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  ASSIGN c1 = REPLACE(c1,",,",",")
         c1 = REPLACE(c1,"~\","/")
         .
  IF c1 BEGINS  ","  THEN ASSIGN c1 = SUBSTRING(c1,2).
  IF c1 MATCHES "*," THEN ASSIGN c1 = SUBSTRING(c1,1,LENGTH(c1) - 1).

  RETURN c1.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

