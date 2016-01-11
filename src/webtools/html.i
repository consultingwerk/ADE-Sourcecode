&IF FALSE &THEN
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
*                                                                    *
*********************************************************************/
/* ------------------------------------------------------------------------
 *  html.i -- common HTML sections used by Webtools  
 *
 * This include file holds all the common HTML code that is
 * re-used by Webtools files. This code can be inserted into an "&OUT"
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
 *   nhorn  1/8/97  Created for Webtools (modelled after the workshop html.i)
 *   wood  3/31/97  Removed BASE tag for HEAD segment
 * ------------------------------------------------------------------------ 
 */
  
/* ------------------------------------------------------------------------
   HEAD --
   The HTML header for generated screen. NOTE that FILE-INFO screens can use
   the same header.  You should pass in:
       TITLE   -- for the title
       FRAME  -- the HTML frame name [This can be used to change the content based on
                 the intended Workshop frame that the document is headed for. 
       AUTHOR -- optional
       TARGET -- The BASE target
  */  
&ENDIF 
&IF LOOKUP ('head', '{&SEGMENTS}') > 0 &THEN
  '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">~n'
  '<HTML>~n'
  '<HEAD>~n'  &IF "{&TITLE}" EQ "" &THEN    
  '  <TITLE>WebSpeed Webtools</TITLE>~n' &ELSE   
  '  <TITLE>WebSpeed {&TITLE}</TITLE>~n' &ENDIF
  '  <META NAME="Generator" CONTENT="WebSpeed [' THIS-PROCEDURE:FILE-NAME ']">~n' 
  &IF "{&AUTHOR}" NE "" &THEN
  '  <META NAME="Author"    CONTENT="{&AUTHOR}">~n' 
  &ENDIF 
  /*
  &IF "{&CHARSET}" NE "" &THEN
  '  <META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset={&CHARSET}">~n' 
  &ENDIF 
  */
  &IF "{&TARGET}" NE "" &THEN
  '  <BASE TARGET = "{&TARGET}">~n' 
  &ENDIF
  '</HEAD>~n'
&ENDIF

&IF FALSE &THEN
/* ------------------------------------------------------------------------
   OPEN-BODY --
   The HTML <BODY> tag for generated screen. You should pass in:
       FRAME  -- the HTML frame name [This can be used to change the content based on
                 the intended Workshop frame that the document is headed for. 
 */  
&ENDIF 

&IF LOOKUP ('open-body', '{&SEGMENTS}') > 0 &THEN
  '<BODY' get-body-phrase ("{&FRAME}") '>~n' 
&ENDIF

&IF FALSE &THEN
/* ------------------------------------------------------------------------
   TITLE-LINE --
   The TITLE LINE for the frame.  You should pass in: 
       TITLE  --  string containing the page title (ie. "Search") 
       LOGO   --  image file to use as a logo [optional]
                  [LOGO was removed from WS_index on 4/28/97 (wood)]
       FRAME  --  the HTML frame name [This can be used to change the content based on
 CONTEXT -- help context value
*/  
&ENDIF 

&IF LOOKUP ('title-line', '{&SEGMENTS}') > 0 &THEN
  &IF "{&FRAME}" = "WS_index" &THEN
    '<NOBR><B><FONT SIZE="+2" COLOR="' get-color ("H1Color":U) '">{&TITLE}</FONT></B>' /* NO NL */
    &IF FALSE AND "{&LOGO}" ne "" &THEN '<IMG SRC="{&LOGO}" ALIGN="CENTER">~n' &ENDIF
    '</NOBR>' 
  &ELSE
    '<TABLE BORDER=0 WIDTH="100%"><TR>~n'
    '<TD ALIGN="LEFT">~n' 
    /* Customization for webtools/dirlist.w */
    &IF DEFINED(TITLESPAN) NE 0 &THEN
      format-titlebar ('{&TITLE}' + ' - ' + LC(dirpath), 
                       &IF DEFINED(LOGO) NE 0 &THEN {&LOGO} &ELSE get-location ('Tools-Logo':U) &ENDIF, "":U)
    /* Customization for wc/wcEvent.p */
    &ELSEIF DEFINED(TITLEDATA) NE 0 &THEN
      format-titlebar ('{&TITLE}' + ' - ' + gcTitleData, 
                       &IF DEFINED(LOGO) NE 0 &THEN {&LOGO} &ELSE get-location ('Tools-Logo':U) &ENDIF, "":U)
    &ELSE
      format-titlebar ('{&TITLE}', &IF DEFINED(LOGO) NE 0 &THEN {&LOGO} &ELSE get-location ('Tools-Logo':U) &ENDIF, "":U)
    &ENDIF
    '</TD>~n'
    '<TD ALIGN= "RIGHT">~n'
    '<A HREF="' RootURL '/doc/wshelp/{&CONTEXT}" ~n'
    '   TARGET="helpWindow"~n'
    '   onClick="window.open(~'~',~'helpWindow~',~'' get-window-settings ("helpWindow":U, "":U) '~')~;"~n'
    '>'
    '<IMG SRC="' RootURL '/images/help.gif" BORDER=0 ALT="Help"></A></TD>~n'
    '</TR></TABLE>~n' &IF LOOKUP ('no-rule', '{&SEGMENTS}') EQ 0 &THEN
    get-rule-tag ('100%', '') &ENDIF
  &ENDIF
&ENDIF

&IF FALSE &THEN
/* ------------------------------------------------------------------------
   SUB-TITLE
   The SUB TITLE LINE for the frame.  You should pass in: 
       TITLE  --  string containing the page title (ie. "Search") 
       FRAME  --  the HTML frame name [This can be used to change the content based on
*/  
&ENDIF 

&IF LOOKUP ('sub-title', '{&SEGMENTS}') > 0 &THEN
  '<TABLE BORDER=0 WIDTH="100%"><TR>~n'
  '<TD ALIGN="CENTER"><B><FONT><FONT COLOR="Red">Web</FONT>Speed: </FONT><FONT COLOR="PURPLE"><I>{&TITLE}</I></FONT></B></TD>~n'
  '</TR></TABLE>~n'
  get-rule-tag ('40%', '')
&ENDIF

/* html.i - end of file */
