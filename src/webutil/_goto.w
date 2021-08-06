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
{&OUT} '<META NAME="AUTHOR" CONTENT="Douglas M. Adams">~n'.
{&OUT} '<META NAME="wsoptions" CONTENT="compile">~n'.
{&OUT} '<TITLE>Goto Line</TITLE>~n'.

{&OUT} '<SCRIPT LANGUAGE="JavaScript1.2" SRC="/webspeed31E/workshop/common.js"><!-- ~n'.
{&OUT} '  document.write("Included common.js file not found.")~; ~n'.
{&OUT} '//--></SCRIPT> ~n'.
{&OUT} '<SCRIPT LANGUAGE="JavaScript1.2"><!--~n'.
{&OUT} '  function autoGo() ~{~n'.
{&OUT} '    /*-----------------------------------------------------------------------~n'.
{&OUT} '      Purpose:     Redirect the Enter key to the OK button.~n'.
{&OUT} '      Parameters:  <none>~n'.
{&OUT} '      Notes:       ~n'.
{&OUT} '    -------------------------------------------------------------------------*/~n'.
{&OUT} '    var btnOKObj = (isIE4up ? document.form1.btnOk : ~n'.
{&OUT} '                    document.form1.elements[''btnOk''])~;~n'.
{&OUT} '    btnClick(btnOKObj)~;~n'.
{&OUT} '    return false~;~n'.
{&OUT} '  ~}~n'.

{&OUT} '  function btnClick(e) ~{~n'.
{&OUT} '    /*-----------------------------------------------------------------------~n'.
{&OUT} '      Purpose:     Handle a button click.~n'.
{&OUT} '      Parameters:  e - button object~n'.
{&OUT} '      Notes:       ~n'.
{&OUT} '    -------------------------------------------------------------------------*/~n'.
{&OUT} '    if (isIE4up)~n'.
{&OUT} '      var numObj = document.all.lineNum~;~n'.
{&OUT} '    else if (isNav4up)~n'.
{&OUT} '      var numObj = document.form1.elements["lineNum"]~;~n'.

{&OUT} '    if (e.id == "btnOk" || e.name == "btnOk") ~{~n'.
{&OUT} '      if (isNaN(numObj.value) || (numObj.value < 0) || (numObj.value == "-0")) ~{~n'.
{&OUT} '        cURL = "../webutil/_webmsgs.w?type=warning&title=Warning" +~n'.
{&OUT} '               "&context=goToLine" +~n'.
{&OUT} '               "&buttons=ok&text=" +~n'.
{&OUT} '               escape("Line number must be a positive integer.")~;~n'.

{&OUT} '        if (isIE4up) ~{~n'.
{&OUT} '          cReturn = window.showModalDialog (cURL, "msgWin", ~n'.
{&OUT} '             "dialogHeight=150px~; dialogWidth=325px~; center=yes")~;~n'.
{&OUT} '          return false~;~n'.
{&OUT} '        ~}~n'.
{&OUT} '        else if (isNav4up) ~{~n'.
{&OUT} '          cReturn = window.open (cURL, "msgWin", ~n'.
{&OUT} '                                 "dependent,height=120,width=325")~;~n'.
{&OUT} '          return false~;~n'.
{&OUT} '        ~}~n'.
{&OUT} '      ~}~n'.
{&OUT} '      if (isIE4up) ~n'.
{&OUT} '        window.returnValue = numObj.value~;~n'.
{&OUT} '      else if (isNav4up)~n'.
{&OUT} '        parent.opener.goToLine(numObj.value)~;~n'.
{&OUT} '    ~}~n'.
{&OUT} '    window.close()~;~n'.
{&OUT} '  ~}~n'.

{&OUT} '  function init() ~{~n'.
{&OUT} '    /*-----------------------------------------------------------------------~n'.
{&OUT} '      Purpose:     Initialization routine.~n'.
{&OUT} '      Parameters:  <none>~n'.
{&OUT} '      Notes:       ~n'.
{&OUT} '    -------------------------------------------------------------------------*/~n'.
{&OUT} '    getBrowser()~;~n'.

{&OUT} '    if (isIE4up) ~{~n'.
{&OUT} '      document.all.btnOk.style.pixelWidth = ~n'.
{&OUT} '        document.all.tdOk.clientWidth~;~n'.
{&OUT} '      document.all.btnCancel.style.pixelWidth = ~n'.
{&OUT} '        document.all.tdCancel.clientWidth~;~n'.
{&OUT} '      document.all.lineNum.select()~;~n'.
{&OUT} '    ~}~n'.
{&OUT} '    else if (isNav4up) ~{~n'.
{&OUT} '      document.form1.elements["lineNum"].focus()~;~n'.
{&OUT} '      document.form1.elements["lineNum"].select()~; ~n'.
{&OUT} '    ~}~n'.
{&OUT} '  ~}~n'.
{&OUT} '//--></SCRIPT>~n'.
{&OUT} '</HEAD>~n'.

{&OUT} '<BODY onLoad="setTimeout(''init()'', 1)" BGCOLOR="lightgrey">~n'.
{&OUT} '<FORM NAME="form1" onSubmit="return autoGo()">~n'.
{&OUT} '  <BR>&nbsp~;&nbsp~;Line Number:~n'.
{&OUT} '  <INPUT ID="lineNum" NAME="lineNum" TYPE="text" SIZE=12 ~n'.
{&OUT} '    VALUE=' /*Tag=`*/ get-field('lineNum') /*Tag=`*/ '>~n'.
{&OUT} '  <BR><BR>~n'.
{&OUT} '  <TABLE WIDTH="100%"><TR WIDTH="100%">~n'.
{&OUT} '    <TD WIDTH="20%"></TD>~n'.
{&OUT} '    <TD ID="tdOk" WIDTH="30%">~n'.
{&OUT} '      <INPUT ID="btnOk" NAME="btnOk" TYPE="button" VALUE="  OK  "~n'.
{&OUT} '        onClick="btnClick(this)">~n'.
{&OUT} '    </TD>~n'.
{&OUT} '    <TD ID="tdCancel" WIDTH="30%">~n'.
{&OUT} '      <INPUT ID="btnCancel" NAME="btnCancel" TYPE="button" VALUE="Cancel"~n'.
{&OUT} '        onClick="btnClick(this)">~n'.
{&OUT} '    </TD>~n'.
{&OUT} '    <TD WIDTH="20%"></TD>~n'.
{&OUT} '  </TR></TABLE>~n'.
{&OUT} '</FORM>~n'.
{&OUT} '</CENTER>~n'.

{&OUT} '</BODY>~n'.
{&OUT} '</HTML>~n'.
/************************* END OF HTML *************************/
/*
** File: src/main/abl/webutil/_goto.w
** Generated on: 2021-03-15 16:17:37
** By: WebSpeed Embedded SpeedScript Preprocessor
** Version: 2
** Source file: src/main/abl/webutil/_goto.html
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
