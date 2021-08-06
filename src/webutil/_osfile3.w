/*E4GL-W*/ {src/web/method/e4gl.i} {&OUT} '<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">~n'.
{&OUT} '<!--------------------------------------------------------------------~n'.
{&OUT} '* Copyright (C) 2002 by Progress Software Corporation ("PSC"),       *~n'.
{&OUT} '* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *~n'.
{&OUT} '* below.  All Rights Reserved.                                       *~n'.
{&OUT} '*                                                                    *~n'.
{&OUT} '* The Initial Developer of the Original Code is PSC.  The Original   *~n'.
{&OUT} '* Code is Progress IDE code released to open source December 1, 2000.*~n'.
{&OUT} '*                                                                    *~n'.
{&OUT} '* The contents of this file are subject to the Possenet Public       *~n'.
{&OUT} '* License Version 1.0 (the "License")~; you may not use this file     *~n'.
{&OUT} '* except in compliance with the License.  A copy of the License is   *~n'.
{&OUT} '* available as of the date of this notice at                         *~n'.
{&OUT} '* http://www.possenet.org/license.html                               *~n'.
{&OUT} '*                                                                    *~n'.
{&OUT} '* Software distributed under the License is distributed on an "AS IS"*~n'.
{&OUT} '* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*~n'.
{&OUT} '* should refer to the License for the specific language governing    *~n'.
{&OUT} '* rights and limitations under the License.                          *~n'.
{&OUT} '*                                                                    *~n'.
{&OUT} '* Contributors:                                                      *~n'.
{&OUT} '*                                                                    *~n'.
{&OUT} '--------------------------------------------------------------------->~n'.
{&OUT} '<HTML>~n'.
{&OUT} '<HEAD>~n'.
{&OUT} '<META NAME="author" CONTENT="Douglas M. Adams">~n'.
{&OUT} '<META NAME="wsoptions" CONTENT="compile">~n'.

 /*Tag=<SCRIPT LANGUAGE="SpeedScript">*/ 
  DEFINE VARIABLE isIE     AS LOGICAL NO-UNDO.
  IF INDEX(get-cgi('HTTP_USER_AGENT':U), " MSIE ":U) > 0 THEN isIE = TRUE.

  {&OUT} '<STYLE TYPE="text/css">':U SKIP.
  IF isIE THEN
    {&OUT} '  FONT ~{ font-family:sans-serif; font-size:8pt }':U SKIP
           '  TD   ~{ font-family:sans-serif; font-size:8pt }':U SKIP.
  ELSE
    {&OUT} '  FONT ~{ font-family:sans-serif; font-size:9pt }':U SKIP
           '  TD   ~{ font-family:sans-serif; font-size:9pt }':U SKIP.
  {&OUT} '</STYLE>':U SKIP.
 /*Tag=</SCRIPT>*/ 

{&OUT} '<SCRIPT LANGUAGE="JavaScript1.2" SRC="/webspeed31E/workshop/common.js"><!--~n'.
{&OUT} '  document.write("Included common.js file not found.")~;~n'.
{&OUT} '//--></SCRIPT>~n'.
{&OUT} '<SCRIPT LANGUAGE="JavaScript1.2"><!--~n'.
{&OUT} '  var cMode   = "' /*Tag=`*/ get-field('mode') /*Tag=`*/ '"~;~n'.
{&OUT} '  var cTarget = "' /*Tag=`*/ get-field('target') /*Tag=`*/ '"~;~n'.
{&OUT} '  var defaultBtn~;~n'.
{&OUT} '  var hBtnCancel~;~n'.
{&OUT} '  var hBtnOpen~;~n'.
{&OUT} '  var hBtnSave~;~n'.
{&OUT} '  var hFileName~;~n'.
{&OUT} '  var hFileType~;~n'.
{&OUT} '  var oldCell~;~n'.

 /*Tag=<SCRIPT LANGUAGE="SpeedScript">*/ 
    DEFINE VARIABLE cNewLine AS CHARACTER NO-UNDO.
    {&OUT} '  var cNewLine = ' (IF OPSYS = "UNIX" THEN '"\\n";' ELSE '"\n";').
 /*Tag=</SCRIPT>*/ 

{&OUT} '  function autoGo() ~{~n'.
{&OUT} '    /*-----------------------------------------------------------------------~n'.
{&OUT} '      Purpose:     Redirect the Enter key to the Open or Save button.~n'.
{&OUT} '      Parameters:  <none>~n'.
{&OUT} '      Notes:       ~n'.
{&OUT} '    -------------------------------------------------------------------------*/~n'.
{&OUT} '    var btnOKObj = (isIE4up ?~n'.
{&OUT} '                    (document.form1.btnOpen != null ?~n'.
{&OUT} '                     document.form1.btnOpen : ~n'.
{&OUT} '                     document.form1.btnSave) :~n'.
{&OUT} '                    (document.form1.elements[''btnOpen''] != null ?~n'.
{&OUT} '                     document.form1.elements[''btnOpen''] : ~n'.
{&OUT} '                     document.form1.elements[''btnSave'']))~;~n'.
{&OUT} '    btnClick(btnOKObj)~;~n'.
{&OUT} '    return false~;~n'.
{&OUT} '  ~}~n'.

{&OUT} '  function btnClick(e) ~{~n'.
{&OUT} '    var btnId   = getBtnId(e)~;~n'.
{&OUT} '    var cFullPath~;~n'.
{&OUT} '    var cString = new String(hFileName.value)~;~n'.
{&OUT} '    var iPos    = cString.indexOf("(DIR)")~;~n'.
{&OUT} '    var isDir   = ((iPos != -1) || hFileName.value == "..")~;~n'.

{&OUT} '    if (hFileName.value == "" &&~n'.
{&OUT} '       (btnId == "btnOpen" || btnId == "btnSave")) ~{~n'.
{&OUT} '      alert("Please select a file to ' /*Tag=`*/ get-field('mode') /*Tag=`*/ '.")~;~n'.
{&OUT} '      return false~;~n'.
{&OUT} '    ~}~n'.
{&OUT} '    if (btnId == "btnOpen" || btnId == "btnSave") ~{~n'.
{&OUT} '      if (parent.OS_flist.cNewDir == getUnknown()) ~{~n'.
{&OUT} '        alert("The destination directory is unknown." + cNewLine + cNewLine +~n'.
{&OUT} '              "Please wait until the file list has" + cNewLine +~n'.
{&OUT} '              "finished loading and try again.")~;~n'.
{&OUT} '        return false~;~n'.
{&OUT} '      ~}~n'.
{&OUT} '      cFullPath = parent.OS_flist.cNewDir + hFileName.value~;~n'.

{&OUT} '      if (isDir) ~{~n'.
{&OUT} '        parent.OS_flist.location.href = ~n'.
{&OUT} '          ''../webutil/_weblist.w'' +~n'.
{&OUT} '          ''?directory='' + (getDir(iPos)) +~n'.
{&OUT} '          ''&filter='' + (getFilter()) +~n'.
{&OUT} '          ''&options=editor''~;~n'.

{&OUT} '        setFileName("")~; // don''t do for fileSaveAs or changing dir~n'.
{&OUT} '      ~}~n'.
{&OUT} '      else ~{~n'.
{&OUT} '        if (isIE4up)~n'.
{&OUT} '           /* 19990724-004~n'.
{&OUT} '              parent.returnValue = parent.OS_flist.cNewDir + "|" +~n'.
{&OUT} '                                hFileName.value~; */~n'.
{&OUT} '           parent.returnValue = cFullPath~;~n'.
{&OUT} '        else if (isNav4up) ~{~n'.
{&OUT} '          if (btnId == "btnOpen")~n'.
{&OUT} '            parent.opener.fileOpen(cFullPath)~;~n'.
{&OUT} '          else if (btnId == "btnSave")~n'.
{&OUT} '            parent.opener.fileSaveAs(cFullPath, "fileSaveAs", cTarget)~;~n'.
{&OUT} '        ~}~n'.
{&OUT} '        parent.close()~;~n'.
{&OUT} '      ~}~n'.
{&OUT} '    ~}~n'.
{&OUT} '    else~n'.
{&OUT} '      parent.close()~;~n'.
{&OUT} '  ~}~n'.

{&OUT} '  function getBtnCancel() ~{~n'.
{&OUT} '    if (isIE4up) ~n'.
{&OUT} '      return document.all.btnCancel~;~n'.
{&OUT} '    else if (isNav4up)~n'.
{&OUT} '      return document.form1.elements["btnCancel"]~;~n'.
{&OUT} '  ~}~n'.

{&OUT} '  function getBtnId(e) ~{~n'.
{&OUT} '    if (isIE4up) ~n'.
{&OUT} '      return e.id~;~n'.
{&OUT} '    else if (isNav4up)~n'.
{&OUT} '      return e.name~;~n'.
{&OUT} '  ~}~n'.

{&OUT} '  function getBtnOpen() ~{~n'.
{&OUT} '    if (isIE4up) ~{~n'.
{&OUT} '      if (document.all.btnOpen != null)~n'.
{&OUT} '        return document.all.btnOpen~;~n'.
{&OUT} '    ~}~n'.
{&OUT} '    else if (isNav4up) ~{~n'.
{&OUT} '      if (document.form1.elements["btnOpen"] != undefined)~n'.
{&OUT} '        return document.form1.elements["btnOpen"]~;~n'.
{&OUT} '    ~}~n'.
{&OUT} '  ~}~n'.

{&OUT} '  function getBtnSave() ~{~n'.
{&OUT} '    if (isIE4up) ~{~n'.
{&OUT} '      if (document.all.btnSave != null)~n'.
{&OUT} '        return document.all.btnSave~;~n'.
{&OUT} '    ~}~n'.
{&OUT} '    else if (isNav4up) ~{~n'.
{&OUT} '      if (document.form1.elements["btnSave"] != undefined)~n'.
{&OUT} '        return document.form1.elements["btnSave"]~;~n'.
{&OUT} '    ~}~n'.
{&OUT} '  ~}~n'.

{&OUT} '  function getDir(iPos) ~{~n'.
{&OUT} '    var cSubDir~;~n'.

{&OUT} '    if (hFileName.value == "..")~n'.
{&OUT} '      cSubDir = ".."~;~n'.
{&OUT} '    else ~{~n'.
{&OUT} '      cSubDir = new String(hFileName.value)~;~n'.
{&OUT} '      cSubDir = cSubDir.substr(0, (iPos - 1))~;~n'.
{&OUT} '    ~}~n'.

{&OUT} '    return (parent.OS_flist.cNewDir + cSubDir)~;~n'.
{&OUT} '  ~}~n'.

{&OUT} '  function getFileName() ~{~n'.
{&OUT} '    if (isIE4up) ~n'.
{&OUT} '      return document.all.fileName~;~n'.
{&OUT} '    else if (isNav4up)~n'.
{&OUT} '      return document.form1.elements["fileName"]~;~n'.
{&OUT} '  ~}~n'.

{&OUT} '  function getFileType() ~{~n'.
{&OUT} '    if (isIE4up) ~n'.
{&OUT} '      return document.all.fileType~;~n'.
{&OUT} '    else if (isNav4up)~n'.
{&OUT} '      return document.form1.elements["fileType"]~;~n'.
{&OUT} '  ~}~n'.

{&OUT} '  function getFilter() ~{~n'.
{&OUT} '    return (hFileType.options[hFileType.selectedIndex].value)~;~n'.
{&OUT} '  ~}~n'.

{&OUT} '  function highlight(e) ~{~n'.
{&OUT} '    if (isIE4up) ~{~n'.
{&OUT} '      e.style.color      = "white"~;~n'.
{&OUT} '      e.style.background = "navy"~;~n'.
{&OUT} '    ~}~n'.
{&OUT} '  ~}~n'.

{&OUT} '  function init() ~{~n'.
{&OUT} '    getBrowser()~;~n'.

{&OUT} '    hBtnCancel = getBtnCancel()~;~n'.
{&OUT} '    hFileName  = getFileName()~;~n'.
{&OUT} '    hFileType  = getFileType()~;~n'.
{&OUT} '    hBtnOpen   = getBtnOpen()~;~n'.
{&OUT} '    hBtnSave   = getBtnSave()~;~n'.

{&OUT} '    if (isIE4up) ~{~n'.
{&OUT} '      if (hBtnOpen != null) ~{~n'.
{&OUT} '        defaultBtn                = hBtnOpen~;~n'.
{&OUT} '        hBtnOpen.style.pixelWidth = document.all.tdCancel.clientWidth - 10~;~n'.
{&OUT} '        setTimeout(''hBtnOpen.focus()'',1)~;~n'.
{&OUT} '      ~}~n'.

{&OUT} '      if (hBtnSave != null) ~{~n'.
{&OUT} '        defaultBtn                = hBtnSave~;~n'.
{&OUT} '        hBtnSave.style.pixelWidth = document.all.tdCancel.clientWidth - 10~;~n'.
{&OUT} '        setTimeout(''hBtnSave.focus()'',1)~;~n'.
{&OUT} '      ~}~n'.
{&OUT} '      hBtnCancel.style.pixelWidth = document.all.tdCancel.clientWidth - 10~;~n'.
{&OUT} '      hFileName.style.pixelWidth  = hFileType.clientWidth~;~n'.
{&OUT} '    ~}~n'.
{&OUT} '    else if (isNav4up) ~{~n'.
{&OUT} '      if (hBtnOpen != undefined) ~{~n'.
{&OUT} '        defaultBtn = hBtnOpen~;~n'.
{&OUT} '        setTimeout(''hBtnOpen.focus()'',1)~;~n'.
{&OUT} '      ~}~n'.

{&OUT} '      if (hBtnSave != undefined) ~{~n'.
{&OUT} '        defaultBtn = hBtnSave~;~n'.
{&OUT} '        setTimeout(''hBtnSave.focus()'',1)~;~n'.
{&OUT} '      ~}~n'.
{&OUT} '    ~}~n'.

{&OUT} '    if (cMode.toLowerCase() == "save") ~{~n'.
{&OUT} '      if (isIE4up) ~{~n'.
{&OUT} '        if (parent.window.dialogArguments != "")~n'.
{&OUT} '          hFileName.value = parent.window.dialogArguments~;~n'.
{&OUT} '      ~}~n'.
{&OUT} '      else if (isNav4up) ~{~n'.
{&OUT} '        if (!parent.opener.parent.WS_edit.lUntitled)~n'.
{&OUT} '          hFileName.value = parent.opener.parent.WS_edit.cFileName~;~n'.

{&OUT} '        setTimeout(''hFileName.focus()'', 1)~;~n'.
{&OUT} '      ~}~n'.
{&OUT} '      hFileName.select()~;   ~n'.
{&OUT} '    ~}~n'.
{&OUT} '  ~}~n'.

{&OUT} '  function normal(e) ~{~n'.
{&OUT} '    if (isIE4up) ~{~n'.
{&OUT} '      e.style.color      = "black"~;~n'.
{&OUT} '      e.style.background = "white"~;~n'.
{&OUT} '    ~}~n'.
{&OUT} '    else if (isNav4up) ~{~n'.
{&OUT} '      e.bgColor          = "white"~;~n'.
{&OUT} '    ~}~n'.
{&OUT} '  ~}~n'.

{&OUT} '  function resetCell(e) ~{  ~n'.
{&OUT} '    if (oldCell != null)~n'.
{&OUT} '      normal(oldCell)~;~n'.
{&OUT} '    oldCell = e~;~n'.
{&OUT} '  ~}~n'.

{&OUT} '  function setFileName(cFile) ~{~n'.
{&OUT} '    if (isIE4up) ~n'.
{&OUT} '      document.all.fileName.value = cFile~;~n'.
{&OUT} '    else if (isNav4up)~n'.
{&OUT} '      document.form1.elements["fileName"].value = cFile~;~n'.
{&OUT} '  ~}~n'.

{&OUT} '  function setImage(e, fName) ~{~n'.
{&OUT} '    e.src = "' /*Tag=`*/ RootURL /*Tag=`*/ '/images/" + fName + ".gif"~;~n'.
{&OUT} '  ~}~n'.

{&OUT} '  function typeChange() ~{~n'.
{&OUT} '    parent.OS_flist.location.href = ~n'.
{&OUT} '      ''../webutil/_weblist.w'' +~n'.
{&OUT} '      ''?directory='' + parent.OS_flist.cNewDir +~n'.
{&OUT} '      ''&filter='' + (getFilter()) +~n'.
{&OUT} '      ''&options=editor''~;~n'.
{&OUT} '  ~}~n'.

{&OUT} '  function updateName(e) ~{~n'.
{&OUT} '    resetCell(e)~;~n'.
{&OUT} '    highlight(e)~;~n'.
{&OUT} '    hFileName.value = e.innerText~;~n'.
{&OUT} '  ~}~n'.

{&OUT} '//--></SCRIPT>~n'.
{&OUT} '</HEAD>~n'.

{&OUT} '<BODY BGCOLOR="lightgrey" onLoad="setTimeout(''init()'', 1)">~n'.
{&OUT} '<FORM ID="form1" NAME="form1" onSubmit="return autoGo()">~n'.
{&OUT} '  <TABLE ID="table1" NAME="table1" CELLPADDING=2 WIDTH="100%">~n'.
{&OUT} '    <TR>~n'.
 /*Tag=<SCRIPT LANGUAGE="SpeedScript">*/ 
        IF isIE THEN
          {&OUT} '      <TD WIDTH="30%"><B>File Name:</B></TD>':U SKIP
                 '      <TD WIDTH="40%">':U SKIP.
        ELSE
          {&OUT} '      <TD WIDTH="40%"><B>File Name:</B></TD>':U SKIP
                 '      <TD WIDTH="50%">':U SKIP.
 /*Tag=</SCRIPT>*/ 
{&OUT} '        <INPUT ID="fileName" NAME="fileName" TYPE="text" SIZE=18> ~n'.
{&OUT} '      </TD>~n'.
{&OUT} '      <TD ID="tdMode" NAME="tdMode" ALIGN="right">~n'.
 /*Tag=<SCRIPT LANGUAGE="SpeedScript">*/ 
          IF LOOKUP("open",get-field("buttons"),"-") > 0 THEN DO:
            IF isIE THEN
              {&OUT} 
                '        <BUTTON ID="btnOpen" '
                'onClick="return btnClick(this)">Open</BUTTON>':U SKIP.
            ELSE
              {&OUT} 
                '        <INPUT NAME="btnOpen" TYPE="button" VALUE="  Open  " '
                'onClick="return btnClick(this)">':U SKIP.
          END.
          IF LOOKUP("save",get-field("buttons"),"-") > 0 THEN DO:
            IF isIE THEN
              {&OUT} 
                '        <BUTTON ID="btnSave" NAME="btnSave" '
                'onClick="return btnClick(this)">Save</BUTTON>':U SKIP.
            ELSE
              {&OUT} 
                '        <INPUT NAME="btnSave" TYPE="button" VALUE="  Save  " '
                'onClick="return btnClick(this)">':U SKIP.
          END.
 /*Tag=</SCRIPT>*/ 
{&OUT} '      </TD>~n'.
{&OUT} '    </TR>~n'.
{&OUT} '    <TR>~n'.
 /*Tag=<SCRIPT LANGUAGE="SpeedScript">*/ 
        IF isIE THEN
          {&OUT} '      <TD WIDTH="30%"><B>Files of Type:</B></TD>':U SKIP
                 '      <TD WIDTH="40%">':U SKIP.
        ELSE
          {&OUT} '      <TD WIDTH="40%"><B>Files of Type:</B></TD>':U SKIP
                 '      <TD WIDTH="50%">':U SKIP.
 /*Tag=</SCRIPT>*/ 
{&OUT} '        <SELECT ID="fileType" NAME="fileType" SIZE=1 onChange="typeChange()">~n'.
{&OUT} '          <OPTION VALUE="*.w~;*.p~;*.i~;*.htm*">All Source(*.w~;*.p~;*.i~;*.htm*)~n'.
{&OUT} '          <OPTION VALUE="*.w">Web Objects(*.w)~n'.
{&OUT} '          <OPTION VALUE="*.p">Procedures(*.p)~n'.
{&OUT} '          <OPTION VALUE="*.i">Includes(*.i)~n'.
{&OUT} '          <OPTION VALUE="*.html~;*.htm">HTML(*.html~;*.htm)~n'.
{&OUT} '          <OPTION VALUE="*.*">All Files(*.*)~n'.
{&OUT} '        </SELECT>~n'.
{&OUT} '      </TD>~n'.
{&OUT} '      <TD ID="tdCancel" NAME="tdCancel" ALIGN="right">~n'.
 /*Tag=<SCRIPT LANGUAGE="SpeedScript">*/ 
          IF LOOKUP("cancel",get-field("buttons"),"-") > 0 THEN DO:
            IF isIE THEN
              {&OUT} 
                '        <BUTTON ID="btnCancel" NAME="btnCancel" VALUE="Cancel" '
                'onClick="return btnClick(this)">Cancel</BUTTON>':U SKIP.
            ELSE
              {&OUT} 
                '        <INPUT NAME="btnCancel" TYPE="button" VALUE="Cancel " '
                'onClick="return btnClick(this)">':U SKIP.
          END.
 /*Tag=</SCRIPT>*/ 
{&OUT} '      </TD>~n'.
{&OUT} '    </TR>~n'.
{&OUT} '  </TABLE>~n'.
{&OUT} '</FORM>  ~n'.

{&OUT} '</BODY>~n'.
{&OUT} '</HTML>~n'.
/************************* END OF HTML *************************/
/*
** File: src/main/abl/webutil/_osfile3.w
** Generated on: 2021-03-15 16:17:37
** By: WebSpeed Embedded SpeedScript Preprocessor
** Version: 2
** Source file: src/main/abl/webutil/_osfile3.html
** Options: compile,wsoptions-found,web-object
**
** WARNING: DO NOT EDIT THIS FILE.  Make changes to the original
** HTML file and regenerate this file from it.
**
*/
/********************* Internal Definitions ********************/

/* This procedure returns the generation options at runtime.
   It is invoked by src/web/method/e4gl.i included at the start
   of this file. */
PROCEDURE local-e4gl-options :
  DEFINE OUTPUT PARAMETER p_version AS DECIMAL NO-UNDO
    INITIAL 2.0.
  DEFINE OUTPUT PARAMETER p_options AS CHARACTER NO-UNDO
    INITIAL "compile,wsoptions-found,web-object":U.
  DEFINE OUTPUT PARAMETER p_content-type AS CHARACTER NO-UNDO
    INITIAL "text/html":U.
END PROCEDURE.

/* end */
