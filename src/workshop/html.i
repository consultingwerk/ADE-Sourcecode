/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
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
*                                                                    *
*********************************************************************/
   &IF FALSE &THEN
  /* ------------------------------------------------------------------------
   *  html.i -- common HTML sections used by WebSpeed Workshop 
   *
   * This include file holds all the common HTML code that is
   * re-used by Workshop files. This code can be inserted into an "&OUT"
   * statement.
   *
   * Parameters:
   *   segments -- a comma delimited list of segments that should be included
   *
   * NOTE: I included comments in IF FALSE blocks to make a preprocess
   * expansion more readable because this section won't appear after expansion.
   *
   * Author: Wm. T. Wood    Created: 12/31/96
   *
   * Modifications:      
   *   wood  3/31/97  Removed BASE tag for HEAD segment
   * ------------------------------------------------------------------------ 
   */
  
    
  /* ------------------------------------------------------------------------
     HEAD --
     The HTML header for generated screen. NOTE that FILE-INFO screens can use
     the same header.  You should pass in:
         TITLE   -- for the title
         FRAME   -- the HTML frame name [This can be used to change the content based on
                    the intended Workshop frame that the document is headed for. 
         AUTHOR  -- optional
         TARGET  -- The BASE target 
         EXPIRES -- Expire the page in {&EXPIRES} seconds 
    */  
  &ENDIF 
  &IF LOOKUP ('head', '{&SEGMENTS}') > 0 &THEN
    '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">~n'
    '<HTML>~n'
    '<HEAD>~n'  &IF "{&TITLE}" eq "" &THEN    
    '  <TITLE>WebSpeed Workshop</TITLE>~n' &ELSE   
    '  <TITLE>WebSpeed {&TITLE}</TITLE>~n' &ENDIF
    '  <META NAME = "Generator"     CONTENT = "WebSpeed [' THIS-PROCEDURE:FILE-NAME ']">~n' &IF "{&AUTHOR}" ne "" &THEN
    '  <META NAME = "Author"        CONTENT = "{&AUTHOR}">~n' &ENDIF &IF "{&EXPIRES}" ne "" &THEN
    '  <META HTTP-EQUIV = "Expires" CONTENT = "' format-datetime ("HTTP":U, TODAY, TIME + {&EXPIRES}, "LOCAL":U) '">~n' &ENDIF &IF "{&TARGET}" ne "" &THEN
    '  <BASE TARGET = "{&TARGET}">~n' &ENDIF
    '</HEAD>~n'
  &ENDIF  &IF FALSE &THEN
  
  /* ------------------------------------------------------------------------
     OPEN-BODY --
     The HTML <BODY> tag for generated screen. You should pass in:
         FRAME  -- the HTML frame name [This can be used to change the content based on
                   the intended Workshop frame that the document is headed for. 
   */  
  &ENDIF 
  &IF LOOKUP ('open-body', '{&SEGMENTS}') > 0 &THEN
     '<BODY' get-body-phrase ("{&FRAME}") '>~n'
  &ENDIF  &IF FALSE &THEN
  
  /* ------------------------------------------------------------------------
     HELP --
     The HELP tag for generated screen. You should pass in:
         CONTEXT -- the help context string
         FRAME   -- the HTML frame name [This can be used to change the content based on
                   the intended Workshop frame that the document is headed for.   
         SIZE    -- if SMALL then the small icon will be used
   */  
  &ENDIF 
  &IF LOOKUP ('help', '{&SEGMENTS}') > 0 &THEN
    '<A HREF="' RootURL '/doc/wshelp/{&CONTEXT}"~n'
    '   TARGET="helpWindow"~n'
    '   onClick="window.open(~'~',~'helpWindow~',~'' 
        get-window-settings ("helpWindow":U, "":U) '~')~;">' &IF "{&SIZE}" eq "SMALL" &THEN
    '<IMG SRC="' RootURL '/images/help-sm.gif" ' &ELSE
    '<IMG SRC="' RootURL '/images/help.gif" ' &ENDIF &IF "{&FRAME}" eq "WSFI_header" &THEN
    'ALIGN="CENTER" ' &ELSE
    'ALIGN="RIGHT" ' &ENDIF
    'ALT="Help" BORDER="0"></A>~n'
  &ENDIF  &IF FALSE &THEN

  /* ------------------------------------------------------------------------
     TITLE-LINE --
     The TITLE LINE for the frame.  You should pass in: 
         TITLE   --  string containing the page title (ie. "New File") 
         LOGO    --  image file to use as a logo [optional]
         FRAME   --  the HTML frame name [This can be used to change the content based on
	 CONTEXT -- help context value
  */  
  &ENDIF 
  &IF LOOKUP ('title-line', '{&SEGMENTS}') > 0 &THEN
    '<TABLE BORDER=0 WIDTH="100%"><TR>~n'
    '<TD ALIGN="LEFT">~n' 
        format-titlebar ("{&TITLE}", &IF "{&LOGO}" ne "" &THEN {&LOGO} &ELSE get-location("Files-Logo":U)  &ENDIF, "":U)
    '</TD>~n'
    '<TD ALIGN= "RIGHT"><A HREF="' RootURL '/doc/wshelp/{&CONTEXT}" TARGET="helpWindow" '
    'onClick="window.open(~'~',~'helpWindow~',~'' get-window-settings ("helpWindow":U, "":U) '~')~;">'
    '<IMG SRC="' RootURL '/images/help.gif" BORDER=0 ALT="Help"></A></TD>~n'
    '</TR></TABLE>~n'
    get-rule-tag ('100%', '') 
  &ENDIF
