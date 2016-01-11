&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 Web-Procedure
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM Definitions 
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
/*------------------------------------------------------------------------

  File: util/_putfile.w

  Description: PUT's the input file to the WEBSTREAM.

  Input Parameters:
    p_FileName -- The name of the file. The file is assumed to exist
                  (relative to PROPATH). If the file is not there then
                  the PROGRESS error will be reported.
    p_ContentType -- The Content-Type of the file. Expected types are
                                text/plain and text/html
                     However, if this is BLANK ("") then the content type
                     is assumed to have been output already.
    p_options -- A comma-delimited list of options, including:
                   AsciiToHtml -- Convert ASCII to HTML codes before 
                                  outputting to the Web. (except for listings).
                   4GL -- in 4GL code, turn the comments green and the 
                          procedures bold   
                   No-Head -- Don't put out the content-type and header information  
                   Line-Num -- Add a line number every line (not supported for anything
                               except 4GL and Listing files).
                   Listing -- Make the text BLACK on WHITE and outputs the file
                      as if it were a listing.
                      NOTE: If listing, then AsciiToHtml is set to true
                      NOTE: This should use the LISTING tag but that is not
                      supported on all browsers, so it does <PRE> with AsciiToHtml
                                  
  Output Parameters:
      <none>

  Author:  Wm. T. Wood
  Created: Oct. 21, 1996 

------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed WorkBench.          */
/*----------------------------------------------------------------------*/

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p_FileName    AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER p_ContentType AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER p_options     AS CHAR NO-UNDO.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Web-Procedure


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


/* ************************  Local Definitions  ************************ */
DEFINE STREAM instream. 

DEFINE VAR l_2Html   AS LOGICAL NO-UNDO.
DEFINE VAR l_4GL     AS LOGICAL NO-UNDO.
DEFINE VAR l_head    AS LOGICAL NO-UNDO INITIAL yes.
DEFINE VAR l_listing AS LOGICAL NO-UNDO.  
DEFINE VAR l_num     AS LOGICAL NO-UNDO.  

DEFINE VAR line-num  AS INTEGER NO-UNDO.
DEFINE VAR next-line AS CHAR NO-UNDO.
DEFINE VAR orig-line AS CHAR NO-UNDO.
DEFINE VAR wsRoot    AS CHAR NO-UNDO.

/* Preprocessor to add line numbers. */
&Scoped-define OUT-LINE-NUMBER IF l_num THEN DO:~
 line-num = line-num + 1.~
 {&OUT} '<FONT COLOR=GRAY>' STRING(line-num, ">>>>9") '</FONT>  '. ~
END.

/* ************************  Main Code Block  *********************** */

/* Figure out options. */
IF p_options ne "":U THEN DO:
  IF LOOKUP("AsciiToHtml", p_options) > 0 THEN l_2html   = yes.
  IF LOOKUP("4GL", p_options) > 0         THEN l_4GL     = yes.
  IF LOOKUP("Line-Num", p_options) > 0    THEN l_num     = yes.
  IF LOOKUP("Listing", p_options) > 0     THEN l_listing = yes.
  IF LOOKUP("No-Head", p_options) > 1     THEN l_head    = no.
END.

/* Return Header, if necessary */
IF l_head AND (p_ContentType ne "") AND (p_ContentType ne ?)
THEN DO:
  RUN outputContentType IN web-utilities-hdl (p_ContentType).
END.

/* Read the file line by line. */
INPUT STREAM instream FROM VALUE(SEARCH(p_FileName)) NO-ECHO.

/* Output the datafile specially if it is 4GL.*/ 
IF l_4GL THEN DO:
  /* Output 4GL in structured HTML format. */
  IF l_head THEN {&OUT}
     '<HTML>~n'
     '<HEAD><TITLE>View File</TITLE></HEAD>~n'
     '<BODY' get-body-phrase("Listing":U) '>~n'
     .
  {&OUT} '<PRE>~n'.  
  /* Show header for line numbers. */
  IF l_num THEN {&OUT} '<FONT COLOR=GRAY><B>Lines</B></FONT>~n'.
  Read-Block:
    REPEAT ON ENDKEY UNDO Read-Block, LEAVE Read-Block:
    IMPORT STREAM instream UNFORMATTED next-line.

    /* Output Line Numbers */
    {&OUT-LINE-NUMBER}
    /* 4GL Code. */
    orig-line = next-line. 
    /* Show Comments in GREEN */
    ASSIGN next-line = html-encode(next-line)
           next-line = REPLACE (next-line, '/*', '<FONT COLOR="GREEN">/*')
           next-line = REPLACE (next-line, '*/', '*/</FONT>').

    /* Show &ANALYZE- lines in GREY */     
    IF orig-line BEGINS "&ANALYZE-" THEN 
      {&OUT} '<FONT COLOR="GRAY">' next-line '</FONT>~n'.
    ELSE IF orig-line BEGINS "FUNCTION " OR orig-line BEGINS "PROCEDURE " THEN
      {&OUT} '</PRE><H2>' next-line '</H2><PRE>~n'.
    ELSE {&OUT} next-line '~n'.
  END. /* Read-Block: */
  {&OUT} '</PRE>~n'.  
  
  /* Finish the page. */ 
  IF l_head THEN {&OUT} '</BODY>~n</HTML>~n'.
  
END. /* 4GL output. */
ELSE IF l_listing THEN DO:  
  /*
   * This should use the <LISTING> tag, but that does not always work, so
   * we do AsciiToHtml and <PRE>
   */
  IF l_head THEN {&OUT}
     '<HTML>~n'
     '<HEAD><TITLE>View File</TITLE></HEAD>~n'
     '<BODY' get-body-phrase("Listing":U) '>~n'                             
     . 
  {&OUT} '<PRE>~n'. 
  /* Show header for line numbers. */
  IF l_num THEN {&OUT} '<FONT COLOR=GRAY><B>Lines</B></FONT>~n'.
  /* Return the listing as html encoded text. */
  Read-Block:
  REPEAT ON ENDKEY UNDO Read-Block, LEAVE Read-Block:
    IMPORT STREAM instream UNFORMATTED next-line.
    /* Output Line Numbers */
    {&OUT-LINE-NUMBER}
    {&OUT} html-encode(next-line) '~n'.
  END. /* Read-Block: */
  {&OUT} '</PRE>~n'.
  /* Finish the page. */ 
  IF l_head THEN {&OUT} '</BODY>~n</HTML>~n'.
 END.
ELSE DO:
  wsRoot = GET-CONFIG('wsroot').
  /* Return text exactly as given. */
  Read-Block:
  REPEAT ON ENDKEY UNDO Read-Block, LEAVE Read-Block:
    IMPORT STREAM instream UNFORMATTED next-line.
    next-line = REPLACE(next-line,'`wsRoot`',wsRoot).  /* PSD - for references to Webspeed static files */
    IF l_2html THEN {&OUT} html-encode(next-line) '~n'.
    ELSE {&OUT} next-line '~n'.
  END. /* Read-Block: */
END.
 
INPUT STREAM instream CLOSE.
&ANALYZE-RESUME
 

