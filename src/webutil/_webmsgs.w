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
{&OUT} '<TITLE>' /*Tag=`*/ get-field("title") /*Tag=`*/ '</TITLE>~n'.
{&OUT} '<STYLE type="text/css">~n'.
{&OUT} '  FONT ~{ font-family:sans-serif~; font-size:8pt ~}~n'.
{&OUT} '</STYLE>~n'.

{&OUT} '<SCRIPT LANGUAGE="JavaScript1.2" SRC="/webspeed31E/workshop/common.js"><!--~n'.
{&OUT} '  document.write("Included common.js file not found.")~;~n'.
{&OUT} '//--></SCRIPT>~n'.
{&OUT} '<SCRIPT LANGUAGE="JavaScript1.2"><!--~n'.
{&OUT} '  var cTarget = "' /*Tag=`*/ get-field('target') /*Tag=`*/ '"~;~n'.

{&OUT} '  function init() ~{~n'.
{&OUT} '    getBrowser()~;~n'.
{&OUT} '    if (isIE4up)~n'.
{&OUT} '      var imgObj = document.all.img_product~;~n'.
{&OUT} '    else if (isNav4up)~n'.
{&OUT} '      var imgObj = document.images[0]~;~n'.

{&OUT} '    switch ("' /*Tag=`*/ get-field("type") /*Tag=`*/ '") ~{~n'.
{&OUT} '      case "error":~n'.
{&OUT} '        imgObj.src = "' /*Tag=`*/ RootURL /*Tag=`*/ '/images/error.gif"~;~n'.
{&OUT} '        break~;~n'.
{&OUT} '      case "information":~n'.
{&OUT} '        imgObj.src = "' /*Tag=`*/ RootURL /*Tag=`*/ '/images/inform.gif"~;~n'.
{&OUT} '        break~;~n'.
{&OUT} '      case "message":~n'.
{&OUT} '        break~;~n'.
{&OUT} '      case "question":~n'.
{&OUT} '        imgObj.src = "' /*Tag=`*/ RootURL /*Tag=`*/ '/images/question.gif"~;~n'.
{&OUT} '        break~;~n'.
{&OUT} '      case "warning":~n'.
{&OUT} '        imgObj.src = "' /*Tag=`*/ RootURL /*Tag=`*/ '/images/warning.gif"~;~n'.
{&OUT} '        break~;~n'.
{&OUT} '    ~}~n'.
{&OUT} '  ~}~n'.

{&OUT} '  function btnClick(e) ~{~n'.
{&OUT} '    var context = "' /*Tag=`*/ get-field('context') /*Tag=`*/ '"~;~n'.

 /*Tag=<SCRIPT LANGUAGE="SpeedScript">*/ 
      IF OPSYS = "UNIX" THEN
        {&OUT} 
          'var regexp  = /\\s\\s/;             // double spaces' SKIP.
      ELSE
        {&OUT} 
          'var regexp  = /\s\s/;               // double spaces' SKIP.
 /*Tag=</SCRIPT>*/ 

{&OUT} '    e.value     = e.value.replace(regexp, "")~; // first occurance~n'.
{&OUT} '    e.value     = e.value.replace(regexp, "")~; // second occurance~n'.

{&OUT} '    if (isIE4up)~n'.
{&OUT} '      window.returnValue = e.value~;~n'.
{&OUT} '    else if (isNav4up) ~{~n'.
{&OUT} '      e.value = e.value.toLowerCase()~;~n'.

{&OUT} '      switch (context) ~{~n'.
{&OUT} '        case "body":~n'.
{&OUT} '          break~;~n'.
{&OUT} '        case "fileClose":~n'.
{&OUT} '          opener.fileClose(e.value)~;~n'.
{&OUT} '          break~;~n'.
{&OUT} '        case "fileNew":~n'.
{&OUT} '          if (e.value == "ok" || e.value == "yes") ~{~n'.
{&OUT} '            if (opener.lUntitled)~n'.
{&OUT} '              opener.fileSaveAs(undefined, "fileSaveAs", "fileNew")~;~n'.
{&OUT} '            else~n'.
{&OUT} '              opener.fileSave("fileNew")~;~n'.
{&OUT} '          ~}~n'.
{&OUT} '          else if (e.value != "cancel")~n'.
{&OUT} '            opener.fileNew(e.value)~;~n'.
{&OUT} '          break~;~n'.
{&OUT} '        case "fileOpen":~n'.
{&OUT} '          if (e.value == "no")~n'.
{&OUT} '            opener.fileOpen("")~;~n'.
{&OUT} '          else if (e.value != "cancel")~n'.
{&OUT} '            opener.fileSave("fileOpen")~;~n'.
{&OUT} '          break~;~n'.
{&OUT} '        case "fileSave":~n'.
{&OUT} '          break~;~n'.
{&OUT} '        case "fileSaveAs":~n'.
{&OUT} '          break~;~n'.
{&OUT} '      ~}~n'.
{&OUT} '    ~}~n'.
{&OUT} '    window.close()~;~n'.
{&OUT} '  ~}~n'.

{&OUT} '//--></SCRIPT>~n'.
{&OUT} '</HEAD>~n'.

{&OUT} '<BODY BGCOLOR="lightgrey" onLoad="init()">~n'.
{&OUT} '<TABLE CELLPADDING=2>~n'.
{&OUT} '  <TR>~n'.
{&OUT} '    <TD VALIGN="top">~n'.
{&OUT} '      <IMG ID="img_product" SRC="' /*Tag=`*/ RootURL /*Tag=`*/ '/images/results.gif"></TD>~n'.
{&OUT} '    <TD>' /*Tag=`*/ get-field("text") /*Tag=`*/ '</TD>~n'.
{&OUT} '  </TR>~n'.
{&OUT} '</TABLE>~n'.

{&OUT} '<CENTER>~n'.
{&OUT} '<FORM>~n'.
 /*Tag=<SCRIPT LANGUAGE="SpeedScript">*/ 
  IF LOOKUP("ok",get-field("buttons"),"-") > 0 THEN
    {&OUT} 
      '<INPUT ID="btnOk" TYPE="button" VALUE="  OK  " '
      'onClick="btnClick(this)">&nbsp;'.
  IF LOOKUP("yes",get-field("buttons"),"-") > 0 THEN
    {&OUT} 
      '<INPUT ID="btnYes" TYPE="button" VALUE="  Yes  " '
      'onClick="btnClick(this)">&nbsp;'.
  IF LOOKUP("no",get-field("buttons"),"-") > 0 THEN
    {&OUT} 
      '<INPUT ID="btnNo" TYPE="button" VALUE="  No  " '
      'onClick="btnClick(this)">&nbsp;'.
  IF LOOKUP("cancel",get-field("buttons"),"-") > 0 THEN
    {&OUT} 
      '<INPUT ID="btnCancel" TYPE="button" VALUE="  Cancel  " '
      'onClick="btnClick(this)">'.
 /*Tag=</SCRIPT>*/ 
{&OUT} '</FORM>~n'.
{&OUT} '</CENTER>~n'.

{&OUT} '</BODY>~n'.
{&OUT} '</HTML>~n'.
/************************* END OF HTML *************************/
/*
** File: src/main/abl/webutil/_webmsgs.w
** Generated on: 2021-03-15 16:17:37
** By: WebSpeed Embedded SpeedScript Preprocessor
** Version: 2
** Source file: src/main/abl/webutil/_webmsgs.html
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
