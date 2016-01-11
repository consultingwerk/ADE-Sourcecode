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
    File        : appmgr.p
    Purpose     : Application manager front end
    Syntax      :
    Description :
    Updated     : 04/04/98 pdigre@progress.com
                    Initial version
                  04/25/01 adams@progress.com
                    WebSpeed integration
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{ webtools/plus.i }

DEFINE VARIABLE cPath  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cUtil  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cName2 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i1     AS INTEGER    NO-UNDO.

  /**** Other Object interactions  ************/
FUNCTION fSaveAppCfg     RETURNS CHARACTER() IN hConfig.
FUNCTION fSaveSysCfg     RETURNS CHARACTER() IN hConfig.
FUNCTION fSetConfig      RETURNS CHARACTER
  ( cDo AS CHARACTER, cName AS CHARACTER ) IN hConfig.

FUNCTION fLibraryUpdate  RETURNS CHARACTER() IN hProutil.
FUNCTION fLibraryView    RETURNS CHARACTER() IN hProutil.
FUNCTION fBrkStart       RETURNS CHARACTER
  ( cUtil AS CHARACTER, cName AS CHARACTER, cName1 AS CHARACTER) IN hProutil.
FUNCTION fBrkStop        RETURNS CHARACTER
  ( cUtil AS CHARACTER, cName AS CHARACTER, cName1 AS CHARACTER) IN hProutil.
FUNCTION fBrkKill        RETURNS CHARACTER
  ( cName AS CHARACTER, cPID AS CHARACTER) IN hProutil.
FUNCTION fBrkView        RETURNS CHARACTER
  ( cUtil AS CHARACTER, cName AS CHARACTER, cName1 AS CHARACTER) IN hProutil.
FUNCTION fBrkAdd         RETURNS CHARACTER
  ( cUtil AS CHARACTER, cName AS CHARACTER, cName1 AS CHARACTER) IN hProutil.

FUNCTION fCompileResults RETURNS CHARACTER() IN hCode.
FUNCTION fCompileStart   RETURNS CHARACTER() IN hCode.
FUNCTION fCompile        RETURNS CHARACTER 
  ( cFileFull AS CHARACTER, cAction AS CHARACTER) IN hCode.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



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
  cFormTitle   = "Application Manager"
  cFormTarget  = "appmgr"
  cFormBack    = "window.open('appmgr.p','_self')"
  cFormHelp    = "appmgr"
  cFormRefresh = "document.form.Name.value='';document.form.submit()"
  .

/* Application configuration */
IF CAN-DO('AppCfg,AddDir,RemDir',cAction) THEN DO:
  ASSIGN 
    cFormTitle = "Edit CodePath List"
    cFormHelp  = "appcfg".

  fHeader().
  RUN showAppCfg IN hConfig.
  fFooter().
  RETURN.
END.

/* System configuration */
IF CAN-DO('SysCfg,AddWS,AddNS,AddAS,AddOD,AddOR,AddDB',cAction) THEN DO: 
  ASSIGN 
    cFormTitle = "Edit List of Servers"
    cFormHelp  = "syscfg".

  fHeader().
  RUN showSysCfg IN hConfig.
  fFooter().
  RETURN.
END.

/* Code Utilities */
IF CAN-DO('DirUtil,Compile,Beautify,Listing,PreCompile,XREF,SXR,Debug',cAction) THEN DO:
  ASSIGN 
    cFormTitle = "Code Utilities"
    cFormHelp  = "amfile".

  DYNAMIC-FUNCTION ("LogNote" IN web-utilities-hdl,
                    "RUN", "File/" + cAction + ":" + cName) NO-ERROR.

  IF (cName > '' AND CAN-DO('beautify,Listing,PreCompile,XREF,SXR,Debug',cAction)) THEN 
    ASSIGN
      cFormBack    = "document.form.Name.value='';document.form.submit()"
      cFormRefresh = "document.form.Name.value='" + cName + "';document.form.submit()"
      .
  fHeader().
  {&OUT} 
    '  <INPUT TYPE="hidden" NAME="cd" VALUE="' cPath '">'.

  IF CAN-DO('beautify',cAction) THEN 
    RUN showBeautify IN hCode.

  fDoWithFiles(cAction,cName).
  IF NOT (cName > '' AND CAN-DO('beautify,Listing,PreCompile,XREF,SXR,Debug',cAction)) THEN
    RUN showCode IN hCode.
  ELSE
    fFooter().
  RETURN.
END.

SET-USER-FIELD('Do','').
cFormBack = "".
fHeader().
RUN appMan.

IF cAction MATCHES "*brk*" THEN 
  ASSIGN
    cUtil  = ENTRY(LOOKUP(ENTRY(1,cName,":"),"WS,NS,AS,OD,OR") + 1,",wtbman,nsman,asbman,odbman,oraman")
    cName2 = ENTRY(2,cName,":").

IF CAN-DO("AllCompile,UpdLib,AllDocument",cAction) AND INDEX(',' + GET-VALUE(?),",DIR") < 1 THEN
  {&out} "<br><b>Nothing selected!</b>".
ELSE CASE cAction:
  WHEN "ListLib"    THEN IF cLib > "" THEN fLibraryView().
  WHEN "UpdLib"     THEN IF cLib > "" THEN DO:  
      fLibraryUpdate().
      fLibraryView().
    END.                       
  WHEN "AllCompile" THEN fCompileStart().
  WHEN "DirCompile" THEN fCompileStart().
  WHEN "DoCompile"  THEN fCompileResults().
  WHEN "StartBrk"   THEN fBrkStart(cUtil,cName,cName2).
  WHEN "StopBrk"    THEN fBrkStop(cUtil,cName,cName2).
  WHEN "AddBrk"     THEN fBrkAdd(cUtil,cName,cName2).
  WHEN "AllDocument" THEN DO:
    {&OUT} "</CENTER><H2>Code Summary</H2>" + cFiles.

    DO i1 = 1 TO NUM-ENTRIES(cFiles,","):
      RUN webtools/appdoc.p (ENTRY(i1,cFiles,",")) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN 
        {&OUT} "ERROR:" ERROR-STATUS:GET-MESSAGE(1).
    END.
    {&OUT} "<CENTER>".
  END.
END CASE.

IF cAction BEGINS "KillBrk" THEN 
  fBrkKill(cName,SUBSTRING(cAction,8)).

IF CAN-DO("StartBrk,ViewBrk,AddBrk",cAction) OR cAction BEGINS "KillBrk" THEN 
  fBrkView(cUtil,cName,cName2).

fFooter().

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-appMan) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE appMan Procedure 
PROCEDURE appMan :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE i1 AS INTEGER NO-UNDO.
  DEFINE VARIABLE c1 AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c2 AS CHARACTER NO-UNDO.

  {&OUT} 
    fBeginTable("Servers: &nbsp; &nbsp; &nbsp; "
     + ' <A HREF="appmgr.p?Do=syscfg" title="Edit List of Servers">Edit Server List</A>|&nbsp;').

  DO i1 = 1 TO NUM-ENTRIES(cBrk):
    ASSIGN 
      c1 = ENTRY(i1,cBrk).
     {&OUT} 
       fRow(IF c1 BEGINS "ws:" AND entry(2,c1,":") = web-context:config-name THEN 
       "<i>" + c1 + '</i>|<A HREF="appmgr.p?Do=ViewBrk&name=' + c1 + '" title="View the Agent Status for current Webspeed broker">View</A>'
       else c1 
       + '|<A HREF="appmgr.p?Do=ViewBrk&name=' + c1 + '" title="View the Agent Status for this Server">View</A> '
       + ' <A HREF="appmgr.p?Do=StartBrk&name=' + c1 + '" title="Start this Server">Start</A> '
       + ' <A HREF="appmgr.p?Do=StopBrk&name=' + c1 + '" title="Start this Server">Stop</A> '  
       + (IF c1 BEGINS "ws:" THEN "<A HREF=" + SCRIPT_NAME + "/WService=" + 
           SUBSTRING(c1,4) + '/workshop TARGET=_top title="Enter Webtools with this Webspeed Broker">Go to..</A>' ELSE '') ).
   END.
   DO i1 = 1 TO NUM-ENTRIES(cDB):
     ASSIGN c1 = ENTRY(i1,cDB).
     {&OUT} 
       fRow("DB:" + c1 + "|"
       + " <A HREF=""appcomp.p?db=" + STRING(i1) + '" title="Database Tools for this database">Tools</A>'
       + " <A HREF=""appcomp.p?return=am&Do=serve&db=" + STRING(i1) + '" title="Start this database">Start</A>'
       + " <A HREF=""appcomp.p?return=am&Do=shut&db=" + STRING(i1) + '" title="Stop this database">Stop</A>').
   END.
   {&OUT} 
     fHRow("CodePaths: &nbsp; &nbsp;"
     + ' <A HREF="appmgr.p?Do=appcfg" title="Edit List of Code Paths">Edit CodePath List</A>|'
     + ' <A HREF="JavaScript:document.form.Do.value=~'AllCompile~';document.form.submit()" title="Compile selected directories">Compile</A>'
     + ' <A HREF="JavaScript:document.form.Do.value=~'AllDocument~';document.form.submit()" title="Create a short code summary for selected directories">Code Summary</A>'
           ).
   DO i1 = 1 TO NUM-ENTRIES(cDir):
     ASSIGN c1 = STRING(i1).
     {&OUT} 
       fRow('<INPUT TYPE="checkbox" VALUE=1 NAME="DIR' + c1 + '"':U
       + (IF get-value('DIR' + c1) > "" THEN " CHECKED" ELSE " ") + ">" + ENTRY(i1,cDir) + '|' 
       + ' <A HREF="appmgr.p?Do=DirUtil&name=' + c1 + '" title="Enter Code Utilities with this directory">CodeUtil</A>'
       + ' <A HREF="appmgr.p?Do=DirCompile&name=' + c1 + '" title="Compile this directory">CompileAll</A>'
       + ' <A HREF="../webtools/dirlist.w?filter=*.w%3B*.p%3B*.i%3B*.htm%3B*.html&directory='
       + URL-ENCODE(ENTRY(i1,cDir),"default") + '" title="Enter FileTools with this directory">FileTools</A> ').
   END.

   {&OUT} 
     fHRow( (IF cLib > "" THEN "R-Code Library: " ELSE "")
            + '<A HREF="JavaScript:document.form.Do.value=~'AddLib~';document.form.Name.value=prompt(~'Enter R-code library path.\n Add a .pl extension to the filename of the library.~');document.form.submit()" title="The name of the current r-code library file">' + (IF cLib = "" THEN "Configure R-Code Library" ELSE cLib) + '</a>|&nbsp;'
            + (IF cLib > "" THEN 
               '<A HREF="appmgr.p?Do=ListLib" title="View the files in this R-Code Library">View</A>' 
            + ' <A HREF="appmgr.p?Do=RemLib" title="Close R-Code Library (Does not delete)">Close</A>' 
            + ' <A HREF="JavaScript:document.form.Do.value=~'UpdLib~';document.form.submit()" title="Update R-Code Library with selected CodePaths">Update</A>'
              ELSE '') ).
   {&OUT} "</TABLE>" SKIP.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-output-headers) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE output-headers Procedure 
PROCEDURE output-headers :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF NOT VALID-HANDLE(hProutil) THEN DO:
    RUN webtools/proutil.p PERSISTENT SET hProutil NO-ERROR.
    IF ERROR-STATUS:ERROR THEN
      MESSAGE "Could not run webtools/proutil.p because" SKIP
        ERROR-STATUS:GET-MESSAGE(1) VIEW-AS ALERT-BOX.
  END.
  IF VALID-HANDLE(hProutil) THEN
    RUN setCallBack IN hProutil (THIS-PROCEDURE,'outputHTML').

  IF NOT VALID-HANDLE(hCode) THEN DO:
    RUN webtools/codelib.p PERSISTENT SET hCode NO-ERROR.
    IF ERROR-STATUS:ERROR THEN
      MESSAGE "Could not run webtools/codelib.p because" SKIP
        ERROR-STATUS:GET-MESSAGE(1) VIEW-AS ALERT-BOX.
  END.
  IF VALID-HANDLE(hCode) THEN
    RUN setCallBack IN hCode (THIS-PROCEDURE,'outputHTML').

  IF NOT VALID-HANDLE(hConfig) THEN DO:
    RUN webtools/config.p PERSISTENT SET hConfig NO-ERROR.
    IF ERROR-STATUS:ERROR THEN
      MESSAGE "Could not run webtools/config.p because" SKIP
        ERROR-STATUS:GET-MESSAGE(1) VIEW-AS ALERT-BOX.
  END.
  IF VALID-HANDLE(hConfig) THEN
    RUN setCallBack IN hConfig (THIS-PROCEDURE, "outputHTML":U).

  IF CAN-DO("undefined,null":U,cName) AND cAction BEGINS "add" THEN 
    cName = "".
  IF CAN-DO("AddLib,RemLib,AddDir,RemDir,AddWS,AddNS,AddAS,AddOD,AddOR,AddDB":U,cAction) AND cName > "" THEN
    fSetConfig(cAction,cName).
  IF CAN-DO("saveAppCfg":U,cAction) THEN 
    fSaveAppCfg().
  IF CAN-DO("saveSysCfg":U,cAction) THEN 
    fSaveSysCfg().

  /* operations on checked files */
  IF CAN-DO("AllCompile,AllDocument,ListLib,UpdLib,xcode,xcomp":U,cAction) THEN
    fSetFiles().
  ELSE DO:
    ASSIGN
      cPath  = get-value("CD":U)
      cFiles = "".
    IF cPath = "" AND CAN-DO("DirCompile,DirUtil":U,cAction) THEN 
      cPath = ENTRY(INT(cName),cDir).
    IF cPath > "" THEN 
      cFiles = fFilesInDir(cPath).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-outputHtml) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE outputHtml Procedure 
PROCEDURE outputHtml :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER c1 AS CHARACTER NO-UNDO.

  {&OUT} '<PRE>':U c1 '</PRE>':U SKIP.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

