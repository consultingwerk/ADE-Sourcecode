&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 WebTool
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
  File: helpsrch.w
  
  Description: Searches for a keyword in the HELP file
  Parameters:  <none>
  
  Fields: This checks for "keyword" as a CGI field. If this 
          exists, then this message is displayed.  This can therefore
          be called from another URL as:
             URL: .../webtools/helpsrch.w?keyword=PROPATH&form=yes
             
          The 'form' field is optional. By default, the form is returned.

      Upon startup, this file looks for and reads the file "keyindex.htm"
      in the PROPATH.  This file contains the list of source to 
      search.  The user may customize this file.
          
          This file looks for help files in /webspeed/doc/langsys in 
      the DOCUMENT_ROOT (and in PROPATH, if not in DOCUMENT_ROOT). 
          

  Modifications:  Add list of sources in which to search   nhorn   2/5/97 
          for help keyword. Remove hardcoding for 
          source names.  Add "MATCHES" functionality.
          Create keyindex.htm file listing help sources.

  Author:  Wm. T. Wood
  Created: Sept 30, 1996
------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed WorkBench.          */
/*----------------------------------------------------------------------*/


/* ***************************  Definitions  ************************** */

/* Preprocessor Definitions ---                                         */
/*-- name of file containing index files & name of default Speedscript  
  -- help file */
&Scoped-define INDEX-FILENAME keyindex.htm

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE help-dir      AS CHAR NO-UNDO INITIAL "/doc/langsys/":U.
DEFINE VARIABLE index-file    AS CHAR NO-UNDO INITIAL "{&INDEX-FILENAME}":U.
DEFINE VARIABLE default-file  AS CHAR NO-UNDO.
DEFINE VARIABLE DOCUMENT_ROOT AS CHAR NO-UNDO.

DEFINE STREAM instream.     /* index file input stream */
DEFINE STREAM idxstream.    /* help file input stream */

DEFINE TEMP-TABLE tt NO-UNDO  
   FIELD doc-name AS CHARACTER 
   FIELD doc-src  AS CHARACTER
   .
   
&ANALYZE-RESUME
&ANALYZE-SUSPEND _PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WebTool


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


/* ************************  Main Code Block  *********************** */

help-dir = TRIM(RootURL,"/":U) + help-dir.

/* Process the latest WEB event. */
RUN process-web-request.
&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE get-help-doc 
PROCEDURE get-help-doc :
/*------------------------------------------------------------------------------
  Purpose:     Open the Help Index and save all doc file selections.
  
  Parameters:  
  Notes:        
------------------------------------------------------------------------------*/

  DEFINE OUTPUT PARAMETER p_error-stat AS INTEGER NO-UNDO.

  DEFINE VARIABLE keyindex-fullname AS CHARACTER NO-UNDO.
  DEFINE VARIABLE help-line  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE b-pos      AS INTEGER NO-UNDO.
  DEFINE VARIABLE e-pos      AS INTEGER NO-UNDO.
  DEFINE VARIABLE lgth       AS INTEGER NO-UNDO.

  keyindex-fullname = DOCUMENT_ROOT + "/" + help-dir + index-file.
  IF SEARCH (keyindex-fullname) eq ? THEN DO:
    /* Look in DLC (in the PROPATH) */
    keyindex-fullname = SEARCH(help-dir + index-file).
  END.
  IF keyindex-fullname eq  ? THEN DO:
    {&OUT}
      '<H3>Help Key Index File not found.</H3>~n'
      format-error ('The HELP Key index file &1 was not found.', index-file, "":U)
      '<BR>~n'.
    p_error-stat = 1.
    RETURN.
  END. 

  INPUT STREAM idxstream FROM VALUE (keyindex-fullname) NO-ECHO.

  IMPORT STREAM idxstream UNFORMATTED help-line.
  Read-Block:
  REPEAT ON ENDKEY UNDO Read-Block, LEAVE Read-Block:
    IF help-line ne " " THEN DO:
      CREATE tt.
       b-pos = INDEX(help-line, '~"') + 1.
       e-pos = INDEX(help-line, "~>") - 1.
       lgth  = (e-pos - b-pos).     
       tt.doc-src = SUBSTRING(help-line, b-pos, lgth).   
       b-pos = (e-pos + 2).
       e-pos = INDEX(help-line, "~<", b-pos).
       lgth  = (e-pos - b-pos).     
       tt.doc-name = SUBSTRING(help-line, b-pos, lgth).
      /* Make the first file the default file for searching. */
      IF default-file eq "":U THEN default-file = tt.doc-src. 
    END.
    IMPORT STREAM idxstream UNFORMATTED help-line.
  END. /* Read-Block: */
  
  INPUT STREAM instream CLOSE.   
  p_error-stat =  0.

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE process-web-request 
PROCEDURE process-web-request :
/*------------------------------------------------------------------------------
  Purpose:     Process the web request.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE c_field        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE index-fullname AS CHARACTER NO-UNDO.
  DEFINE VARIABLE search-for     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE searchfiles    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE l_form         AS LOGICAL NO-UNDO.
  DEFINE VARIABLE o-err-stat     AS INTEGER NO-UNDO.
  DEFINE VARIABLE found          AS INTEGER NO-UNDO.
  DEFINE VARIABLE num-found      AS INTEGER NO-UNDO.
  DEFINE VARIABLE i              AS INTEGER NO-UNDO.
  DEFINE VARIABLE t-cnt          AS INTEGER NO-UNDO.
  
  /* What is the context of this request?  Look at "KEYWORD". */
  RUN GetField IN web-utilities-hdl ('keyword', OUTPUT search-for).

  /* Should the <FORM> be returned so the user can enter a new search? 
     (Default is YES). */
  RUN GetField IN web-utilities-hdl ('form', OUTPUT c_field).
  l_form = (c_field ne "no").
  
  /* 
   * Output the MIME header and set up the object as state-less or state-aware. 
   * This is required if any HTML is to be returned to the browser.
   */
  RUN outputContentType IN web-utilities-hdl ("text/html":U).  

  /* Get the document root for this web-server. */
  RUN GetCgi IN web-utilities-hdl (INPUT "DOCUMENT_ROOT":U, OUTPUT DOCUMENT_ROOT). 
    
  {&OUT}
    {webtools/html.i 
       &SEGMENTS = "head,open-body,title-line"
       &AUTHOR   = "Wm.T.Wood"
       &TITLE    = "Keywords"
       &FRAME    = "WS_main" 
       &CONTEXT  = "{&Webtools_Keywords_Help}" } 
       .

  /* Read in Help options */
  RUN get-help-doc (OUTPUT o-err-stat).

  /* Get the help files to search */
  RUN GetField IN web-utilities-hdl ("SearchFiles", OUTPUT searchfiles).

  IF searchfiles eq "" THEN searchfiles = default-file.

  IF o-err-stat eq 1 THEN  {&OUT} 'Unable to perform Keyword Search ~n'. 
  ELSE DO: 
    {&OUT}
      '<FORM METHOD = "POST"'
      ' ACTION = "' AppURL '/webtools/helpsrch.w">~n'
      '<CENTER>~n'
      '<TABLE BORDER="0" CELLSPACING="0" >~n'
      '<TR><TD COLSPAN=3>' format-label ("Search WebSpeed Reference":U, "TOP":U, "":U) '</TD></TR>~n'
      '<TR>'.
      t-cnt = 0.

    FOR EACH tt:
      IF t-cnt = 3 THEN {&OUT} '<TR>'.
      {&OUT}
         '<TD><FONT COLOR="' get-color("HIGHLIGHT":U) '"><B>~n'
         '<INPUT TYPE = "checkbox" NAME = "SearchFiles" ~n'
         '       VALUE = "' tt.doc-src '"' 
         (IF LOOKUP(tt.doc-src, searchfiles) gt 0  THEN ' CHECKED>' ELSE ' >') 
         tt.doc-name '</FONT></B></TD>~n'
         .
      t-cnt = t-cnt + 1.
      IF t-cnt = 3 THEN {&OUT} '</TR>~n'.
    END.  /* End FOR EACH tt */ 

    IF t-cnt < 3 THEN {&OUT} '</TR>~n'.
    {&OUT} '</TABLE>~n'
      '<HR WIDTH=80%>~n'
      format-label ("Enter Search String", "INPUT":U, "":U)
      '<INPUT TYPE = "TEXT" NAME = "Keyword" SIZE = "30"'
      (IF search-for ne "" THEN ' VALUE = "' + search-for + '">' ELSE '>')
      '&nbsp~;~n'
      '<INPUT TYPE = "SUBMIT" VALUE = "Submit Query"><BR>~n'
      '<FONT SIZE="-1">(Type start of keyword, e.g. <I>SET</I>, or use wildcards, e.g. <I>*ROW*</I>)</FONT>~n'
      '</CENTER></FORM>~n'.

    /* Report results of search. */
    IF search-for ne "":U THEN DO:
      num-found = 0.
      IF searchfiles ne "" THEN
      DO i = 1 TO NUM-ENTRIES(searchfiles):
        index-fullname = DOCUMENT_ROOT + '/' + help-dir + ENTRY(i, searchfiles).
        /* Look in DLC (in the PROPATH) */
        IF SEARCH (index-fullname) eq ? THEN 
          index-fullname = SEARCH(help-dir + ENTRY(i, searchfiles)).
        IF SEARCH (index-fullname) ne ? THEN DO: 
          RUN search-index ( INPUT index-fullname, 
                             INPUT search-for, 
                             INPUT (ENTRY(i, searchfiles)), 
                             OUTPUT found ).
          num-found = (num-found + found).
        END.
        ELSE DO:
          {&OUT} '<H2>Help Index File not found.</H2>~n'
                 format-error ('The HELP index file &1 was not found.<BR>~n', 
                               ENTRY(i, searchfiles), "":U).
        END.
      END.
    END.  /* If search-for ne "" */
  END.
  
  /* Close out the HTML file. */
  {&OUT} '</BODY>~n</HTML>'.
  
END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE search-index 
PROCEDURE search-index :
/*------------------------------------------------------------------------------
  Purpose:     Open the Index file looking for all items that match
               p_keyword
  
  Parameters:  p_index-file (CHAR) - name of file to open containing the index
               p_keyword (CHAR) - the keyword to search for.
           p_ref-name (CHAR) - source file of the document, used to retrieve
                the title in the temp table.  
            p_found (integer) indicating whether references were found. 
  Notes:       p_keyword is NOT empty. 
               p_index-file is known to exist and be fully qualified.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER p_index-file AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER p_keyword    AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER p_ref-name   AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER p_found      AS INTEGER NO-UNDO.
 
  DEFINE VARIABLE i            AS INTEGER   NO-UNDO. 
  DEFINE VARIABLE next-line    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE next-keyword AS CHARACTER NO-UNDO.
  DEFINE VARIABLE l_found-one  AS LOGICAL   NO-UNDO INITIAL NO.
  DEFINE VARIABLE l_match      AS LOGICAL   NO-UNDO. 

  /* Search for anything that begins with the keyword. */
  FIND FIRST tt WHERE tt.doc-src eq p_ref-name NO-ERROR.
  {&OUT} '<HR>~n'
     format-label ('Matches for ' + format-text (p_keyword, "B,I":U), "SIDE":U, "":U)
     format-text (tt.doc-name, 'Highlight,B':U)
     '<UL>'. /* NO ~n */
  
  INPUT STREAM instream FROM VALUE (p_index-file) NO-ECHO.
  Read-Block:
  REPEAT ON ENDKEY UNDO Read-Block, LEAVE Read-Block:
    IF next-line BEGINS '<A HREF' THEN DO:
      /* Get the text associated with the HREF. That is, assume the line is of
         the form: <A HREF="100.htm">SEARCH Function</A>"  */
      next-keyword = ENTRY(1, ENTRY(2, next-line, ">":U), "<":U).
      IF next-keyword BEGINS p_keyword THEN l_match = yes.
      ELSE IF (INDEX(p_keyword, "~*") > 0) AND (next-keyword MATCHES p_keyword) THEN l_match = yes.
      ELSE l_match = no.
      IF l_match THEN DO: 
        /* Add the "/webspeed/doc/langsys/" to the HREF. Check for a quote at the
           start of the line that is not followed by a "/".  If we get one, add
           in the offset to the language reference. */ 
        i = INDEX(next-line, '"':U).
        IF i <= 10 AND SUBSTRING(next-line, i + 1, 1, "CHARACTER":U) ne "/":U
        THEN next-line = SUBSTRING(next-line, 1, i, "CHARACTER":U) +
                         "/":U + help-dir +
                         SUBSTRING(next-line, i + 1, -1, "CHARACTER":U).
        {&OUT} '<LI>' next-line '</LI>~n'.
        l_found-one = yes.
      END.
    END.
    
    IMPORT STREAM instream UNFORMATTED next-line.
  END. /* Read-Block: */
    
  INPUT STREAM instream CLOSE.   
  
  /* Report that nothing was found. */
  IF NOT l_found-one THEN DO: 
      p_found = 0.
      {&OUT} 'No references found. <BR>~n'.
  END.
  ELSE
      p_found = 1. 
  
  {&OUT} '</UL>'.
  
END PROCEDURE.
&ANALYZE-RESUME
 

