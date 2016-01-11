&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*  Per S Digre (pdigre@progress.com)                                 *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
    File        : vst.p
    Purpose     : Virtual System Tables Utilities
    Syntax      :
    Description :
    Updated     : 04/04/98 pdigre@progress.com
                    Initial version
                  04/26/01 adams@progress.com
                    WebSpeed version
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{ src/web/method/cgidefs.i }

&GLOBAL-DEFINE cColorHeader " bgcolor=#DEB887 "
&GLOBAL-DEFINE cColorRow1   " bgcolor=#FFFFE6 "
&GLOBAL-DEFINE cBrowseTableDef " border=1 cellpadding=0 cellspacing=0 width=90% "

/* Data Browse control */
DEFINE NEW GLOBAL SHARED VARIABLE cAction   AS CHARACTER  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE cDBid     AS CHARACTER  NO-UNDO.
DEFINE new GLOBAl SHARED VARIABLE cType     AS CHARACTER  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE cTable    AS CHARACTER  NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE hDatabase AS HANDLE     NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE hHTML     AS HANDLE     NO-UNDO.

/* generic object definition section */
DEFINE VARIABLE hParent   AS HANDLE NO-UNDO.
DEFINE VARIABLE cCallback AS CHAR   NO-UNDO.

FUNCTION fRow        RETURNS CHARACTER
  ( cData   AS CHARACTER) IN hHTML.
FUNCTION fHRow       RETURNS CHARACTER
  ( cLabels AS CHARACTER) IN hHTML.
FUNCTION fBeginTable RETURNS CHARACTER
  ( cLabels AS CHARACTER) IN hHTML.
FUNCTION fTable      RETURNS CHARACTER
  ( cLabels AS CHARACTER, cData AS CHARACTER) IN hHTML.

DEFINE STREAM sIni.

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
  ( cLabel AS CHARACTER,
    cValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fOut) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fOut Procedure 
FUNCTION fOut RETURNS CHARACTER
  ( c1 AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fRecid2Table) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fRecid2Table Procedure 
FUNCTION fRecid2Table RETURNS CHARACTER
  ( iRecid AS INTEGER )  FORWARD.

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

DYNAMIC-FUNCTION ("LogNote" IN web-utilities-hdl, "RUN":U, "Init VST-object") NO-ERROR.
DYNAMIC-FUNCTION ("LogNote" IN web-utilities-hdl, "RUN":U, "DB:" + PDBNAME("DICTDB")) NO-ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-callBack) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE callBack Procedure 
PROCEDURE callBack :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER h1 AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER c1 AS CHARACTER NO-UNDO.

  ASSIGN hParent   = h1
         cCallBack = c1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dbVst) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dbVst Procedure 
PROCEDURE dbVst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE cIn         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOut        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRecID      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFile       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCmd        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i1          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cPF         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewPF      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSearch     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iTableLevel AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLevel      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLine       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lConnected  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lServed     AS LOGICAL    NO-UNDO.

  ASSIGN cRecid = GET-VALUE("recid").

  CASE cAction:
    WHEN "vstInfo" OR WHEN "" THEN DO:
      FIND FIRST DICTDB._actbuffer NO-ERROR.

      {&OUT} '    <TABLE>~n'.
      {&OUT} '    <TR>' fDisp("Buffer Reads",STRING(DICTDB._actbuffer._buffer-logicrds)) .
      {&OUT} fDisp("OS Reads",STRING(DICTDB._actbuffer._buffer-osrds)) .
      {&OUT} fDisp("Hit Rate",STRING(100 * DICTDB._actbuffer._buffer-logicrds  / (DICTDB._actbuffer._buffer-logicrds + DICTDB._actbuffer._buffer-osrds),"99.99")) '</tr>~n'.
      {&OUT} '    <TR>' fDisp("Buffer Writes",STRING(DICTDB._actbuffer._buffer-logicwrts)) .
      {&OUT} fDisp("OS Writes",STRING(DICTDB._actbuffer._buffer-oswrts)) .
      {&OUT} fDisp("Hit Rate",STRING(100 * DICTDB._actbuffer._buffer-logicwrts / (DICTDB._actbuffer._buffer-logicwrts + DICTDB._actbuffer._buffer-oswrts),"99.99")) '</tr>~n'.
      {&OUT} '    </TABLE>~n'.

      {&OUT} fBeginTable('FileName|IO-type|Size|Blocksize|LogicalSize|Extend') SKIP.
      FOR EACH DICTDB._filelist:
        {&OUT} fRow(_filelist-name
            + '|' + _filelist-openmode
            + '|' + STRING(_filelist-Size)
            + '|' + STRING(_filelist-blksize)
            + '|' + STRING(_filelist-logicalsz)
            + '|' + STRING(_filelist-extend)) SKIP.
      END.
      {&OUT} "</TABLE>" SKIP.

      {&OUT} fBeginTable('ServerID|Num|Type|PID|Port|Protocol|Logins|Curr|Max|Rec sent|KBytes sent|Rec recvd|Kbytes recvd') SKIP.
      FOR EACH DICTDB._server, EACH DICTDB._actserver OF DICTDB._server:
        {&out} fRow(STRING(_server._server-id)
            + '|' + STRING(_server-num)
            + '|' + _server-type
            + '|' + STRING(_server-pid)
            + '|' + STRING(_server-portnum)
            + '|' + _server-protocol
            + '|' + STRING(_server-logins)
            + '|' + STRING(_server-currusers)
            + '|' + STRING(_server-maxusers)
            + '|' + STRING(_server-msgsent)
            + '|' + STRING(INTEGER(_server-bytesent / 1000))
            + '|' + STRING(_server-msgrec)
            + '|' + STRING(INTEGER(DICTDB._actserver._server-byterec  / 1000))) SKIP.
      END.
      {&OUT} "</TABLE>" SKIP.
    END.
    WHEN "vstUsers" THEN DO:
      {&OUT} fBeginTable('UserNr|Type|Name|Host|PID|Wait|--|Trans|Sem|Server|Time') SKIP.
      FOR EACH DICTDB._connect WHERE DICTDB._connect._connect-usr <> ?:
        {&OUT} fRow(fOut(STRING(_connect-usr))
            + '|' + fOut(_connect-type)
            + '|' + fOut(_connect-name)
            + '|' + fOut(_connect-device)
            + '|' + fOut(STRING(_connect-PID))
            + '|' + fOut(STRING(_connect-wait1))
            + '|' + fOut(STRING(_connect-wait))
            + '|' + fOut(STRING(_connect-transid))
            + '|' + fOut(STRING(_connect-semnum))
            + '|' + fOut(STRING(_connect-server))
            + '|' + fOut(STRING(_connect-time))) SKIP.
      END.
      {&OUT} "</TABLE>" SKIP.
    END.
    WHEN "vstLocks" THEN DO:
      {&OUT} fBeginTable('Device|PID|Name|User|Recid|File|Type') SKIP.

      DEFINE VARIABLE iRecid AS INTEGER NO-UNDO.
      DEFINE VARIABLE iUsr   AS INTEGER NO-UNDO.

      FOR EACH DICTDB._Lock NO-LOCK:
        ASSIGN 
          iRecid = DICTDB._Lock._Lock-recid
          iUsr   = DICTDB._Lock._Lock-Usr.

        IF iRecid = ? OR iRecid = 0 THEN LEAVE.

        FIND FIRST DICTDB._Connect NO-LOCK WHERE
          DICTDB._Connect._Connect-Id = iUsr NO-ERROR.

        IF AVAIL DICTDB._Connect THEN
          {&OUT}  
            "<TR" {&cColorRow1} "><TD>" DICTDB._Connect._Connect-Device
            "</TD><TD>" DICTDB._Connect._Connect-Pid.
        ELSE 
          {&OUT} "<TR" {&cColorRow1} "><TD>N/A</TD><TD>N/A".

        FIND FIRST DICTDB._File NO-LOCK WHERE
          DICTDB._File._File-number = DICTDB._Lock._Lock-Table NO-ERROR.
        ASSIGN cFile = IF AVAIL DICTDB._File THEN DICTDB._File._File-Name
                       ELSE "N/A".

        {&OUT}
          "</TD><TD>" DICTDB._Lock._Lock-Name
          "</TD><TD>" DICTDB._Lock._Lock-Usr
          "</TD><TD>" DICTDB._Lock._Lock-recid
          "</TD><TD><A HREF=databrw.p?Do=edit&tb=" cFile "&db=" cDBid
                         "&recid=" DICTDB._Lock._Lock-recid ">" cFile "</A>"
          "</TD><TD>" DICTDB._Lock._Lock-type + " - " + DICTDB._Lock._Lock-Flags
          "</TD></TR>" SKIP.
      END.
      {&OUT} "</TABLE>" SKIP.
    END.
    WHEN "vstRecid" THEN DO:
      ASSIGN cFile = ''.
      IF cRecid > "" THEN 
        cFile = fRecid2Table(INTEGER(cRecid)).
      IF cFile = "" THEN
        {&OUT} " <B>File: Not Found !</B>" SKIP.
      ELSE 
        {&OUT} " <B>File: <A HREF=databrw.p?Do=edit&db=" cDBid '&tb=' cFile "&recid=" cRecid ">" cFile "</A>"
        "</B>" SKIP.
    END.
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fDisp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fDisp Procedure 
FUNCTION fDisp RETURNS CHARACTER
  ( cLabel AS CHARACTER,
    cValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN 
    '<TD ALIGN="right"><B>' + cLabel + ':</B></TD>' +
    '<TD ALIGN="right">' + html-encode(cValue) + '</TD>'.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fOut) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fOut Procedure 
FUNCTION fOut RETURNS CHARACTER
  ( c1 AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF c1 = ? THEN c1 = "".

  RETURN c1.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fRecid2Table) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fRecid2Table Procedure 
FUNCTION fRecid2Table RETURNS CHARACTER
  ( iRecid AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE q1   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE b1   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cRet AS CHARACTER  NO-UNDO.

  CREATE QUERY q1.
  FOR EACH dictdb._file NO-LOCK WHERE _file-number > 0 AND _file-number < 32000:
    CREATE BUFFER b1 FOR TABLE dictdb._file._file-name.
    q1:SET-BUFFERS(b1).
    q1:QUERY-PREPARE('FOR EACH ' + dictdb._file._file-name + ' where recid(' + dictdb._file._file-name + ') = ' + string(iReciD)).
    q1:QUERY-OPEN().
    q1:GET-NEXT.
    IF NOT q1:QUERY-OFF-END THEN DO:
      DELETE OBJECT b1.
      ASSIGN cRet = dictdb._file._file-name .
      LEAVE.
    END.
    DELETE OBJECT b1.
  END.
  DELETE OBJECT q1.

  RETURN cRet.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

