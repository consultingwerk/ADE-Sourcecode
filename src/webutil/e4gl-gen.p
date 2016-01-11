&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000,2015 by Progress Software Corporation. All      *
* rights reserved. Prior versions of this work may contain portions  *
* contributed by participants of Possenet.                           *
*                                                                    *
**********************************************************************

File: e4gl-gen.p

Description:
    Reads an HTML file with Embedded 4GL and generates a web-object or
    include file wrapping the HTML with PUT UNFORMATTED statements
    implemented by the {&OUT} preprocessor.  Various Statement and
    Expression Escapes are supported so 4GL statements and expressions
    respectively can be embedded in the HTML allowing dynamic page
    generation.

Input Parameters:
    p_html-file: Name of HTML file to open.

Input/Output Parameters:
    p_output-file: Name of output file web-object/include to open.
    p_options: Comma-delimited option list for generating the output file.  
        web-object  - generate a web-object .w file (default)
        include     - generate an include file
        debug       - turn on debugging mode
        no-content-type - if generating a web-object and this option is
          specified, no statement to output the Content-Type header will
          be generated.  This logic is actually implemented in
          src/web/method/e4gl.i. 
        keep-meta-content-type - if specified, a 
          <META HTTP-EQUIV="Content-Type" ...> tag found in the input file
          will be left alone.  Otherwise, the default is to comment out
          this tag in the output .w file thus preventing conflicts between
          the actual HTTP Content-Type header and this tag at runtime.
        Any options found in the <META NAME="wsoptions" or <!--WSMETA
        tags are added to this list.  The calling program can then examine
        them.
        get-options - causes the HTML HEAD section or entired file to be
          parsed which adds the list of options found in the
          <META NAME="wsoptions" or <!--WSMETA tags to any specified options.
          In addition, when one of these forms of wsoptions is found,
          "wsoptions-found" is appended to the options.  This allows the
          calling program to determine if the HTML file supports WebSpeed
          SpeedScripting or is just a static HTML file. The program then
          returns without generating any output file.
        Note: this option list is not complete.  Other options can be
        specified in which case they are ignored by this program.

Output Parameters:
    None

Return Value
    Return value is non blank if there's some error.

Author: B.Burton

Date Created:  December 1996

Modifications
Date      Who       Description
--------  --------  ----------------------------------------------------------
1/17/97   nhorn     Changed p_output-file to be an input-output parameter.  
1/20/97   nhorn     Added RETURN at end of procedure.
1/30/97   billb     * Added function quote-4GL-text() to quote the text and
                      escape certain characters.
                    * Opening and closing Statement and Expression Escape
                      tags no longer require a space before or after
                      expression respectively.
                    * A new standard include file src/web/method/e4gl.i is
                      output to a generated Web object.
                    * Changed nocontenttype option to no-content-type.
                    * Changed all references of "procedure" to "web-object".
                    * Web object files are generated with a .w suffix.
                    * Added LANGUAGE=WebSpeed4GL and LANGUAGE=SpeedScript
                      as a synonyms for LANGUAGE=PROGRESS.
                    * Added a check for closed input stream which happens
                      when EOF is hit while parsing the <HEAD> section.
                    * Added <SERVER>,</SERVER> as Statement Escape tags.
                      This seems helpful for Navigator Gold users.
                    * Changed p_options to be an input-output parameter.
                    * Added new option "get-options" which returns without
                      generating the output file.
2/8/97    billb     * Added function un-html() which replaces all occurances
                      of "&amp;" with "&" in 4GL text (between tags).  {&AMP}
                      is defined in e4gl.i which can be used instead of
                      "&amp;" if needed.
                    * Added new tags <% ,%> and <%=,%> for compatibility with
                      Microsoft Active Server Pages (ASP).
                    * Added new expression tags {=,=} as an alternative to
                      back tics `` since they are often difficult to see.
                    * Added detailed explanations of the currently supported
                      tags.
2/14/97   billb     * Added the HTML entities "&quot;", "&lt;" and "&gt;" to
                      the un-html() function.  Also URL decode the 4GL if
                      in an Expression Escape.
                    * Fixed minor bug where blank lines have a "."
4/16/97   billb     * Added support for <!--WSMETA tag.
                    * When "get-options" is passed an an option,
                      "wsoptions-found" is set if wsoptions was found.
                    * Changed parsing all around so tags are defined in a
                      work-table.  The first of all tags found in the line
                      is used instead of the first one in the list of tags.
                    * The <SCRIPT tag can now be split across lines.
4/22/97   billb     * New tags <!--WSS ...--> and <!--WSE ...--> for
                      statement and expression escapes respectively.
                    * Unless the new "keep-meta-content-type" option is
                      specified, the <META HTTP-EQUIV="Content-Type" ...>
                      tag is commented out in the output .w so the web
                      browser will never see it.
2/23/00   adams     * Added decode-url(), x-2-c() functions to replace 
                      WEB-CONTEXT:URL-DECODE() method for local conversion of 
                      HTML files at design time.
6/17/2015 rkumar    * Incorporate Ken Mcintosh's changes to 11.6
 
Note: To find bug fix numbers, search for "Bug".
---------------------------------------------------------------------------- */

&GLOBAL-DEFINE VERSION 2.0              /* decimal version number */
{src/web/method/cgidefs.i}

DEFINE INPUT        PARAMETER  p_html-file     AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER  p_options       AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER  p_output-file   AS CHARACTER NO-UNDO.

/* Supported options.  Each preprocessor evaluates to TRUE or FALSE
   depending if the option is set or not. */
&GLOBAL-DEFINE DEBUG-IS-SET CAN-DO(p_options,"debug":U)
&GLOBAL-DEFINE WEB-OBJECT-IS-SET CAN-DO(p_options,"web-object":U)
&GLOBAL-DEFINE INCLUDE-IS-SET CAN-DO(p_options,"include":U)
&GLOBAL-DEFINE GET-OPTIONS-IS-SET CAN-DO(p_options,"get-options":U)
&GLOBAL-DEFINE KEEP-META-CONTENT-TYPE CAN-DO(p_options,"keep-meta-content-type":U)

DEFINE VARIABLE html-file       AS CHARACTER NO-UNDO.
DEFINE VARIABLE in-buf          AS CHARACTER NO-UNDO.
DEFINE VARIABLE prev-in-buf     AS CHARACTER NO-UNDO.
DEFINE VARIABLE out-buf         AS CHARACTER NO-UNDO.
DEFINE VARIABLE tmp-buf         AS CHARACTER NO-UNDO.
DEFINE VARIABLE html-open-tag   AS CHARACTER NO-UNDO.
DEFINE VARIABLE html-close-tag  AS CHARACTER NO-UNDO.
DEFINE VARIABLE start-offset    AS INTEGER   NO-UNDO.
DEFINE VARIABLE end-offset      AS INTEGER   NO-UNDO.
DEFINE VARIABLE tag-start       AS INTEGER   NO-UNDO.
DEFINE VARIABLE tag-end         AS INTEGER   NO-UNDO.
DEFINE VARIABLE tag-start-save  AS INTEGER   NO-UNDO.
DEFINE VARIABLE tag-state       AS INTEGER   NO-UNDO.
DEFINE VARIABLE wsmeta-start    AS INTEGER   NO-UNDO.
DEFINE VARIABLE meta-start      AS INTEGER   NO-UNDO.
DEFINE VARIABLE meta-end        AS INTEGER   NO-UNDO.
DEFINE VARIABLE attr-start      AS INTEGER   NO-UNDO.
DEFINE VARIABLE attr-end        AS INTEGER   NO-UNDO.
DEFINE VARIABLE attr-name       AS CHARACTER NO-UNDO.
DEFINE VARIABLE i               AS INTEGER   NO-UNDO.
DEFINE VARIABLE meta-name       AS CHARACTER NO-UNDO.
DEFINE VARIABLE meta-value      AS CHARACTER NO-UNDO.
DEFINE VARIABLE wsoptions       AS CHARACTER NO-UNDO.
/* Starting and ending line and column positions for the
   <META HTTP-EQUIV="Content-Type" tag. */
DEFINE VARIABLE meta-start-line   AS INTEGER NO-UNDO INITIAL 0.
DEFINE VARIABLE meta-start-col    AS INTEGER NO-UNDO INITIAL 0.
DEFINE VARIABLE meta-end-line     AS INTEGER NO-UNDO INITIAL 0.
DEFINE VARIABLE meta-end-col      AS INTEGER NO-UNDO INITIAL 0.
DEFINE VARIABLE metact-start-line AS INTEGER NO-UNDO INITIAL 0.
DEFINE VARIABLE metact-end-line   AS INTEGER NO-UNDO INITIAL 0.
DEFINE VARIABLE metact-start-col  AS INTEGER NO-UNDO INITIAL 0.
DEFINE VARIABLE metact-end-col    AS INTEGER NO-UNDO INITIAL 0.

DEFINE VARIABLE opt             AS CHARACTER NO-UNDO.
DEFINE VARIABLE opt-num         AS INTEGER   NO-UNDO INITIAL 0.
DEFINE VARIABLE content-type    AS CHARACTER NO-UNDO.
DEFINE VARIABLE qchar           AS CHARACTER NO-UNDO.
DEFINE VARIABLE debug-mode      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE line-num        AS INTEGER   NO-UNDO.

DEFINE VARIABLE curr-state      AS INTEGER   NO-UNDO.
DEFINE VARIABLE next-state      AS INTEGER   NO-UNDO.
DEFINE VARIABLE prev-state      AS INTEGER   NO-UNDO.
DEFINE VARIABLE cTopStatements  AS CHARACTER NO-UNDO.
DEFINE VARIABLE iStatement      AS INTEGER   NO-UNDO.

&GLOBAL-DEFINE INITIAL-STATE    0
&GLOBAL-DEFINE NORMAL-STATE     1
&GLOBAL-DEFINE STMNT-TAG-OPEN   2
&GLOBAL-DEFINE STMNT-4GL        4
&GLOBAL-DEFINE EXPR-TAG-OPEN    8
&GLOBAL-DEFINE EXPR-4GL         16

/* Work table to store all tags.  This allows searching for all possible
   tags on a line and then using the earliest one in the line.  It's important
   that longer tags are created as earlier records with shorter tags last. */
DEFINE WORK-TABLE tag NO-UNDO
  FIELD tag-state   AS INTEGER   FORMAT ">>9" INITIAL {&STMNT-TAG-OPEN}
  FIELD open-tag    AS CHARACTER FORMAT "x(10)"
  FIELD close-tag   AS CHARACTER FORMAT "x(10)"
  .

DEFINE STREAM instr.
DEFINE STREAM outstr.

/* _UIB-CODE-BLOCK-END */
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
         HEIGHT             = 2
         WIDTH              = 40.
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* **********************  Internal Functions  ************************ */

/* In case someone attempts to compile this procedure under WebSpeed 1.0 */
&IF PROVERSION = "1.0" &THEN
&MESSAGE THIS PROCEDURE CANNOT BE COMPILED UNDER WebSpeed 1.0.
&MESSAGE It utilizes user defined functions which were not available in
&MESSAGE that release.
&ENDIF

FUNCTION decode-url RETURNS CHARACTER
( INPUT pURL AS CHARACTER ) FORWARD.

FUNCTION x-2-c RETURNS CHARACTER
  (INPUT pHex AS CHARACTER) FORWARD.

FUNCTION decode-url RETURNS CHARACTER
  ( INPUT pURL AS CHARACTER ):
  /* Adapted from unescape_url() in $RDLC/web/cgihtml/cgi-lib.c */

  DEFINE VARIABLE cChar AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cURL  AS CHARACTER NO-UNDO. /* RETURN string */
  DEFINE VARIABLE cX    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cY    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE ix    AS INTEGER   NO-UNDO.  
  DEFINE VARIABLE iy    AS INTEGER   NO-UNDO INITIAL 1.

  DO ix = 1 TO LENGTH(pURL, "CHARACTER":U):
    ASSIGN
      cY = SUBSTRING(pURL, iy, 1, "CHARACTER":U)
      cX = cY.
      
    IF cX = "%":U THEN 
      ASSIGN
        cChar = x-2-c(SUBSTRING(pURL, iy + 1, 2, "CHARACTER":U))
        iy    = iy + 2.
    ELSE 
      cChar = cX.
    
    ASSIGN
      cURL = cURL + cChar
      iy   = iy + 1.
  END.
  
  RETURN cURL.

END FUNCTION.

/*
** Procedure: init-tags
** Description: Initializes tag definitions in a work table.
*/
PROCEDURE init-tags:

  /*
  ** Statement Escape tags - any number of 4GL statements can appear between
  ** these tags.
  **
  ** Expression Escape tags - any 4GL expressions can appear between
  ** these tags. The output of these expressions are inserted in-line
  ** with the HTML.
  */

  /*
  ** So we can have a language like everyone else.  Some HTML authoring tools
  ** like FrontPage support a language of "other" for this tag.
  **   <SCRIPT LANGUAGE={SpeedScript|WebSpeed4GL|PROGRESS}>, </SCRIPT>
  */
  CREATE tag.
  ASSIGN tag.tag-state = {&STMNT-TAG-OPEN}
         tag.open-tag = "<SCRIPT":U
         tag.close-tag = "</SCRIPT>":U.
  /*
  ** If a tag needs to be placed in a location considered to be illegal HTML
  ** by an authoring tool (either before <HTML> or after </HTML>, using a
  ** comment is less likely to be a problem.  This tag is obsolete.  <!--WSS
  ** should be used instead.
  **   "<!--WS4GL", "-->"
  */
  CREATE tag.
  ASSIGN tag.tag-state = {&STMNT-TAG-OPEN}
         tag.open-tag = "<!--WS4GL":U
         tag.close-tag = "-->":U.
  /*
  ** A tag that's a comment is generally useful for situations where a tag
  ** needs to be placed in a location considered to be illegal HTML
  ** by an authoring tools (either before <HTML> or after </HTML>.  It's also
  ** much less verbose than the <SCRIPT tag.  WSS equates to "WebSpeed
  ** Statement escape."
  **   "<!--WSS", "-->"
  */
  CREATE tag.
  ASSIGN tag.tag-state = {&STMNT-TAG-OPEN}
         tag.open-tag = "<!--WSS":U
         tag.close-tag = "-->":U.
  /*
  ** This comment tag for expression escapes is provided for symmetry with
  ** <!--WSS.  There may be occasions with certain authoring tools where
  ** something that looks like an HTML tag is needed for an expression escape.
  ** This could be useful in an authoring tool dialog that allows entering
  ** any HTML tag or a comment without encoding or converting the content.
  ** WSE equates to "WebSpeed Expression escape."
  **   "<!--WSE", "-->"
  */
  CREATE tag.
  ASSIGN tag.tag-state = {&EXPR-TAG-OPEN}
         tag.open-tag = "<!--WSE":U
         tag.close-tag = "-->":U.
  /*
  ** Short and sweet.  In SGML, <? is a directive.  However, some strict
  ** authoring tools such as HotMetal Pro won't let you enter this tag because
  ** it isn't legal HTML 3.2, etc.
  **   <?WS>, </?WS>
  */
  CREATE tag.
  ASSIGN tag.tag-state = {&STMNT-TAG-OPEN}
         tag.open-tag = "<?WS>":U
         tag.close-tag = "</?WS>":U.
  /*
  ** Navigator Gold supports this tag for server-side JavaScript in LiveWire.
  ** The <SCRIPT> tag is also supported but the language can't be specified.
  ** This tag is supported to allow a reasonable way for Navigator Gold users
  ** to author HTML with SpeedScript.
  **   <SERVER>, </SERVER>
  */
  CREATE tag.
  ASSIGN tag.tag-state = {&STMNT-TAG-OPEN}
         tag.open-tag = "<SERVER>":U
         tag.close-tag = "</SERVER>":U.
  /*
  ** Microsoft Active Server Pages (ASP) output expression tags.  These tags
  ** may cause problems with many authoring tools because the < and >
  ** characters are used.  This can be problematic when using tags inside of
  ** an HREF or VALUE attributes, etc.
  **   "<%=", "%>"
  */
  CREATE tag.
  ASSIGN tag.tag-state = {&EXPR-TAG-OPEN}
         tag.open-tag = "<%=":U
         tag.close-tag = "%>":U.
  /*
  ** Microsoft Active Server Pages (ASP) command (statement) tags.  Note
  ** that the opening tag is a subset of the output expression tag which
  ** requires it be defined after that tag.
  **   "<%", "%>"
  */
  CREATE tag.
  ASSIGN tag.tag-state = {&STMNT-TAG-OPEN}
         tag.open-tag = "<%":U
         tag.close-tag = "%>":U.
  /*
  ** This tag is easier to see on the screen than the back tic and also not
  ** likely to cause problems with authoring tools.  
  **   "{=", "=}"
  */
  CREATE tag.
  ASSIGN tag.tag-state = {&EXPR-TAG-OPEN}
         tag.open-tag = "~{=":U
         tag.close-tag = "=~}":U.
  /*
  ** Netscape LiveWire supports the back tic but they almost certainly took
  ** the idea from UNIX shells.  The back tic is small and often difficult
  ** to find on the screen depending on the font so other tags are provided.
  **   "`", "`"
  */
  CREATE tag.
  ASSIGN tag.tag-state = {&EXPR-TAG-OPEN}
         tag.open-tag = "`":U
         tag.close-tag = "`":U.

END PROCEDURE.


/*
** Function: quote-4GL-text
** Description: returns a character string quoted properly for use
**   in a PUT UNFORMATTED statement.
** Input parameters:
**   p_text - character string to quote
**   p_newline - logical to indicate if a newline should be added in before
**     closing quote.
** Bug: 19970114-044
*/
FUNCTION quote-4GL-text RETURNS CHARACTER
    (INPUT p_text AS CHARACTER,
     INPUT p_newline AS LOGICAL) :

    DEFINE VARIABLE iPos AS INTEGER    NO-UNDO.

    /* Escape tilde's with tilde's so for every one there are now two. */
    ASSIGN p_text = REPLACE(p_text, "~~", "~~~~").  /* "~" -> "~~" */
    /* Add quotes to start, end and double up in-between.  If a newline was
       requested, add it in before the final closing quote. */
    ASSIGN p_text = "'":U +
        REPLACE(p_text, "'":U, "''":U) +
        (IF p_newline THEN "~~n" ELSE "") + "'":U.
    ASSIGN p_text = REPLACE(p_text, "~{", "~~~{").  /* "{" -> "~{" */
    ASSIGN p_text = REPLACE(p_text, "~}", "~~~}").  /* "}" -> "~}" */
    ASSIGN p_text = REPLACE(p_text, "~;", "~~~;").  /* ";" -> "~;" */

    /* Convert all "\n" to "\\n" for UNIX */
    IF OPSYS = "unix":U THEN DO:
      iPos = INDEX(p_text, "~\n":U).
      REPEAT:
        IF iPos = 0 THEN LEAVE.
        IF SUBSTRING(p_text, iPos - 1, 1, "character":U) NE "~\":U THEN
          SUBSTRING(p_text, iPos, 0, "character":U) = "~\":U.
        iPos = INDEX(p_text, "~\n":U, (iPos + 3)).
      END.
    END.

    RETURN p_text.
END FUNCTION.


/*
** Function: un-html
** Description: Converts HTML entities to text and URL decodes if in an
**   Expression Escape.
** Input parameters:
**   p_text - character string to quote
** Bugs: 19970207-068, 19970214-009
*/
FUNCTION un-html RETURNS CHARACTER
  (INPUT p_text AS CHARACTER,
   INPUT p_state AS INTEGER) :

  /* Only URL decode text if in an Expression Escape, in case the authoring 
     tool encoded the text for use in an <A HREF="". */
  IF p_state = {&EXPR-4GL} THEN DO:
    /* If AppBuilder is running, use the decode-url() function instead of the
       WEB-CONTEXT:URL-DECODE() method, removing the dependency on the latter 
       and allowing for local conversion of .html-->.w-->.r. */
    p_text = IF SESSION:WINDOW-SYSTEM = "TTY":U THEN 
               WEB-CONTEXT:URL-DECODE(p_text)
             ELSE
               /* DYNAMIC-FUNCTION("decode-url":U IN _h_func_lib, p_text). */
               decode-url(p_text).
  END.
  
  ASSIGN
    /* Replace common HTML entities with their respective literal characters.
       Many HTML authoring tools convert the literal characters entered to 
       the entity form so we convert it back again so the 4GL code is valid 
       again.  Depending on the tool, the user may be able to manually fix 
       this but it can be a pain. */
    p_text = REPLACE(p_text, "&amp~;":U, "&":U)   /* &amp;  -> & */
    p_text = REPLACE(p_text, "&quot~;":U, '"':U)  /* &quot; -> " */
    p_text = REPLACE(p_text, "&lt~;":U, "<":U)    /* &lt;   -> < */
    p_text = REPLACE(p_text, "&gt~;":U, ">":U).   /* &gt;   -> > */
  RETURN p_text.
END FUNCTION.

FUNCTION x-2-c RETURNS CHARACTER
  (INPUT pHex AS CHARACTER):
  /* Adapted from x2c() in $RDLC/web/cgihtml/cgi-lib.c */
  
  DEFINE VARIABLE cChar1  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cChar2  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cString AS CHARACTER NO-UNDO INITIAL "ABCDEF":U.
  DEFINE VARIABLE iDigit  AS INTEGER   NO-UNDO.  

  ASSIGN
    cChar1 = SUBSTRING(pHex, 1, 1, "CHARACTER":U)
    iDigit = (IF INDEX(cString, cChar1) = 0 THEN INTEGER(cChar1)
              ELSE INDEX(cString, cChar1) + 9)
    iDigit = iDigit * 16
    cChar2 = SUBSTRING(pHex, 2, 1, "CHARACTER":U)
    iDigit = (IF INDEX(cString, cChar2) = 0 THEN INTEGER(cChar2)
              ELSE INDEX(cString, cChar2) + 9) + iDigit.

  RETURN CHR(iDigit).
  
END FUNCTION.

/* ***************************  Main Block  *************************** */

/* Check if "debug" was specified as an option.  If so, turn on debug mode. */
ASSIGN debug-mode = {&DEBUG-IS-SET}.

/* Look for HTML input file */
ASSIGN html-file = SEARCH(p_html-file).
IF html-file = ? THEN DO: /* ERROR: cannot find HTML file */
  RETURN ERROR "NOTFOUND,input file was not found".
END.

/* Open the HTML input file */
INPUT STREAM instr FROM VALUE(html-file) NO-ECHO.

/* Set default values in the event META tags aren't found */
ASSIGN
  wsoptions = ""
  content-type = "text/html":U.

/* Parse <HEAD> section looking for <META> tags. The ones we're looking for
   contain either NAME="wsoptions" or HTTP-EQUIV="Content-Type".
   For instance:
     <META NAME="wsoptions" CONTENT="include">
     <META HTTP-EQUIV="Content-Type"
        CONTENT="text/html; charset=iso-8859-1">
   In addition, since the input file may not be self contained but an HTML
   fragment, look for the tag <!--WSMETA ... --> parsing it in an identical
   manner as the real META tag. For instance:
     <!--WSMETA NAME="wsoptions" CONTENT="web-object,no-compile"-->
     <!--WSMETA HTTP-EQUIV="Content-Type"
         CONTENT="text/html; charset=iso-8859-1"-->
*/
ASSIGN
  line-num = 0
  start-offset = 1.
parse-loop:
DO WHILE TRUE
    ON ENDKEY UNDO parse-loop, LEAVE parse-loop
    ON ERROR UNDO parse-loop, LEAVE parse-loop:

  /* If a start tag was found in the prior input line ... */
  IF meta-start > 0 THEN DO:
    /* Read in a line and append it to the prior input line if no meta 
       tag ending was found. [Bug 19970114-046] */
    IF meta-end = ? THEN DO:
      IMPORT STREAM instr UNFORMATTED tmp-buf.
      ASSIGN line-num = line-num + 1.  /* Line counter */
      IF html-open-tag = "<META":U THEN
        ASSIGN
          /* Save the current line number and look for the position of the
	     <META tag close ">" before the input line is merged with the 
	     prior input line distorting the actual position. */
          meta-end-line = line-num
	  meta-end-col = INDEX(tmp-buf, html-close-tag).
      /* No end tag was found in the prior input line. Get the prior input
         line starting with the <META tag and append the new line. */
      ASSIGN in-buf = SUBSTRING(in-buf, meta-start, -1, "CHARACTER") + " ":U +
                      TRIM(tmp-buf).
    END.
    ELSE
      /* A <META tag was found earlier in the current input line.  Just set 
         the starting offset to where the search for the next META tag should
	 begin. */
      ASSIGN start-offset = meta-end + 1.
  END.
  /* Else, just read the next line in */
  ELSE DO:
    IMPORT STREAM instr UNFORMATTED in-buf.
    
    IF TRIM(in-buf) BEGINS "ROUTINE-LEVEL ON" OR
       TRIM(in-buf) BEGINS "BLOCK-LEVEL ON" OR
       TRIM(in-buf) BEGINS "USING " THEN
      cTopStatements = cTopStatements + 
                       (IF (cTopStatements GT "") EQ TRUE THEN 
                          CHR(1) 
                        ELSE "") +
                       in-buf.
    ASSIGN
      start-offset = 1
      line-num = line-num + 1.  /* Line counter */
  END.

  IF debug-mode THEN
    MESSAGE "in-buf:" in-buf.

  /* Look for <META and <!--WSMETA tags */
  ASSIGN
    meta-start = INDEX(in-buf, "<META":U, start-offset)
    wsmeta-start = INDEX(in-buf, "<!--WSMETA":U, start-offset).

  /* If both tags were found, take the one earlier in the line */
  IF meta-start > 0 AND wsmeta-start > 0 THEN DO:
    ASSIGN meta-start = MINIMUM(meta-start, wsmeta-start).
    /* If earlier tag isn't <!--WSMETA, pretend it wasn't found */
    IF wsmeta-start <> meta-start THEN
      ASSIGN wsmeta-start = 0.
  END.
  ELSE
    ASSIGN meta-start = MAXIMUM(meta-start, wsmeta-start).

  /* Found a <META or <!--WSMETA tag? */
  IF meta-start > 0 THEN DO:
    /* If <!--WSMETA was found, set opening and closing tags for that, else
       the <META tag. */
    IF wsmeta-start > 0 THEN
      ASSIGN
        html-open-tag = "<!--WSMETA":U
        html-close-tag = "-->":U.
    ELSE DO:
      ASSIGN
        html-open-tag = "<META":U
        html-close-tag = ">":U.
      /* If the line is not being re-parsed due to the lack of a closing ">"
         for the <META tag, remember the line and column where the <META tag
	 starts (and ends) in case this is needed for
	 <META HTTP-EQUIV="Content-Type"...>. */
      IF meta-end <> ? THEN
        ASSIGN
          meta-start-line = line-num
          meta-start-col = meta-start
          meta-end-line = line-num
          /* This may be zero but will be retried above if meta-end below
	     is also zero. */
	  meta-end-col = INDEX(in-buf, html-close-tag).
    END.

    /* Look for tag end starting after the tag start */
    ASSIGN
      meta-end = INDEX(in-buf, html-close-tag, meta-start).

    /* If no end of tag found, then get the next line, append it to this one
       and try again. */
    IF meta-end = 0 THEN DO:
      ASSIGN meta-end = ?.              /* indicates no end tag yet */
      NEXT parse-loop.
    END.

    /* Extract entire <META ... > or <!--WSMETA ... --> tag */
    ASSIGN tmp-buf = SUBSTRING(in-buf, meta-start, meta-end - meta-start +
                               LENGTH(html-close-tag)).
    IF debug-mode THEN
      MESSAGE "meta tag:" tmp-buf.

    /* See if we have a match on the desired NAME attribute */
    IF tmp-buf MATCHES "*NAME*=*wsoptions*":U THEN
      ASSIGN meta-name = "wsoptions":U.
    ELSE IF tmp-buf MATCHES "*HTTP-EQUIV*=*Content-Type*":U THEN DO:
      ASSIGN meta-name = "Content-Type":U.
      /* If <META HTTP-EQUIV="Content-Type" ... >, then remember where the
         <META tag starts and ends so it can be commented out when
         generating output.  */
      IF html-open-tag = "<META":U THEN
        ASSIGN
          metact-start-line = meta-start-line
          metact-start-col = meta-start-col
          metact-end-line = meta-end-line
          metact-end-col = meta-end-col.
    END.
    ELSE
      ASSIGN meta-name = "".

    /* If one of the desired meta names was found, look for the CONTENT
       attribute and extract the contents */
    IF meta-name <> "" THEN DO:
      /* Replace any tabs with spaces */
      ASSIGN tmp-buf = REPLACE(tmp-buf, CHR(9), " ":U).

      /* Get starting position of the CONTENT attribute. This two step
         approach is required to avoid finding ContentðType instead! */
      ASSIGN attr-start = INDEX(tmp-buf, "CONTENT=":U).
      IF attr-start = 0 THEN
        ASSIGN attr-start = INDEX(tmp-buf, "CONTENT ":U).
      IF attr-start > 0 THEN
        ASSIGN attr-name = "CONTENT":U.

      /* If no CONTENT attribute was found, ignore META tag */
      IF attr-start > 0 THEN DO:
        ASSIGN
          attr-start = attr-start + LENGTH(attr-name) + 1
          /* Extract after CONTENT attribute removing leading spaces
             and equals sign. */
          tmp-buf = LEFT-TRIM(SUBSTRING(tmp-buf, attr-start), " =":U)
          attr-start = 1
          /* See if the first character is a quote */
          qchar = SUBSTRING(tmp-buf, 1, 1) .
        IF debug-mode THEN
          MESSAGE "CONTENT attr:" tmp-buf "quote:" qchar.

        /* If quoted value */
        IF qchar = '"':U OR qchar = "'":U THEN DO:
          ASSIGN
            attr-start = attr-start + 1
            /* Look for the matching ending quote */
            attr-end = INDEX(tmp-buf, qchar, attr-start).
          IF debug-mode THEN
            MESSAGE "attr-start:" attr-start "attr-end:" attr-end.
          ASSIGN meta-value =
            (IF attr-end > 0 THEN
                SUBSTRING(tmp-buf, attr-start, attr-end - attr-start)
             ELSE "").
        END.

        /* Else, handle unquoted value */
        ELSE DO:
          /* Look for the end of the attribute value */
          ASSIGN attr-end = INDEX(tmp-buf, " ":U, attr-start).
          IF attr-end = 0 THEN
            /* Get the length less the tag close and any trailing spaces */
            attr-end = LENGTH(RIGHT-TRIM(tmp-buf," ":U)) -
                       LENGTH(html-close-tag).
          IF debug-mode THEN
            MESSAGE "attr-start:" attr-start "attr-end:" attr-end.
          ASSIGN meta-value =
            (IF attr-end > 0 THEN
                SUBSTRING(tmp-buf, attr-start, attr-end - attr-start + 1)
             ELSE "").
        END.
        IF debug-mode THEN
          MESSAGE "meta-name:" meta-name "meta-value:" meta-value.

        /* Set appropriate variable with the CONTENT attribute value */
        CASE meta-name:
          WHEN "wsoptions":U THEN DO:
            /* Assign meta value after replacing spaces with commas and double
               commas with a single one. Then append to pðoptions. */
            ASSIGN wsoptions = TRIM(REPLACE(REPLACE(meta-value," ":U,",":U),
                                            ",,":U, ",")).
            /* If any wsoptions found in the <META tag ... */
            IF wsoptions <> "" THEN DO:
              IF p_options = "" THEN
                /* No options passed via input paramater.  Just set them. */
                ASSIGN p_options = wsoptions.
              ELSE
                /* Else, loop through each of the parameter options and only
                   add <META tag options that aren't already set. */
                DO opt-num = 1 TO NUM-ENTRIES(wsoptions):
                  ASSIGN opt = ENTRY(opt-num, wsoptions).
                  IF NOT CAN-DO(p_options, opt) THEN
                    ASSIGN p_options = p_options + ",":U + opt.
                END.
              /* Indicate to the calling program that wsoptions was found 
                 in the file. */
              IF NOT CAN-DO(p_options, "wsoptions-found":U) THEN
                ASSIGN p_options = p_options + ",wsoptions-found":U.
            END.
          END.
          WHEN "Content-Type":U THEN
            ASSIGN content-type = meta-value.
        END CASE.
      END. /* found CONTENT attribute */
    END. /* matching meta name */
  END. /* <META tag found */

  /* Else, no <META tag was found.  Look for tags indicating the end of
     the </HEAD> section.  We have to check for several tags in case there
     is no <HEAD> section.  The file could be an HTML fragment containing
     only a table. */
  ELSE IF in-buf MATCHES "*</HEAD*":U OR
          in-buf MATCHES "*<BODY*":U OR
          in-buf MATCHES "*<TABLE*":U THEN LEAVE parse-loop.

END. /* parse-loop */

IF debug-mode THEN
  MESSAGE "p_options:" p_options.

/* Verify minimum options were specified */
IF NOT {&WEB-OBJECT-IS-SET} AND
   NOT {&INCLUDE-IS-SET} THEN DO:
  /* If neither "web-object" or "include" was specified, add "web-object" to
     any existing options. */
  ASSIGN p_options = p_options +
    (IF p_options = "" THEN "" ELSE ",":U) +
    "web-object":U.
  IF debug-mode THEN
    MESSAGE "no generation type specified, setting to web-object".
END.

/* If output file parameter is blank, strip any suffix from the input
   file name and add either a .w or .i suffix as appropriate. 
   [Bug 19970120-026] */
IF p_output-file = "" THEN DO:
  i = R-INDEX(p_html-file,".":U).
  IF i > 0 THEN
    p_output-file = SUBSTRING(p_html-file,1,i) +
      (IF {&WEB-OBJECT-IS-SET} THEN "w":U ELSE "i":U).
  ELSE
    p_output-file = p_html-file +
      (IF {&WEB-OBJECT-IS-SET} THEN ".w":U ELSE ".i":U).
END.

/* If "get-options" was specified, return without generating an output file.
   This allows the calling program to determine the options and output file
   name without actually generating the output file. */
IF {&GET-OPTIONS-IS-SET} THEN DO:
  INPUT STREAM instr CLOSE.
  RETURN.
END.

/* Is the stream "instr" still valid?  If ? is returned, then we hit EOF and
   have to reopen the input file. [Bug 19970122-041] */
IF SEEK(instr) = ? THEN
  /* Open the HTML input file */
  INPUT STREAM instr FROM VALUE(html-file) NO-ECHO.
/* Else, we hit the end of </HEAD> section. */
ELSE
  /* Rewind input stream */
  SEEK STREAM instr TO 0.

/* Initialize tags work-table */
RUN init-tags.

IF debug-mode AND NOT VALID-HANDLE(web-utilities-hdl) THEN DO:
    FOR EACH tag:
        DISPLAY tag.
    END.
END.

/* Open the web-object or include output file */
OUTPUT STREAM outstr TO VALUE(p_output-file).

DO iStatement = 1 TO NUM-ENTRIES(cTopStatements):
  PUT STREAM outstr UNFORMATTED ENTRY(iStatement,cTopStatements,CHR(1)) CHR(10).
END.

/* NOTE: Any output written from here up until main-loop below must not write
   any newlines or compile errors will have the wrong line numbers. */

/* If generating a web-object file ... */
IF {&WEB-OBJECT-IS-SET} THEN DO:
  /* Output a special tag indicating this is a generated web-object file */
  PUT STREAM outstr UNFORMATTED '/*E4GL-W*/ ':U.
  /* Insert the standard E4GL include file.  It determines the options and
     content type by running an internal procedure at the end of the
     generated web-object which returns the values.  This keeps the amount
     of text added to the first line of the output to a minimum.
     [Bug 19970114-033] */
  PUT STREAM outstr UNFORMATTED
  '~{src/web/method/e4gl.i~} '.
END.
/* If generating an include file ... */
ELSE IF {&INCLUDE-IS-SET} THEN DO:
  /* Output a special tag indicating this is a generated include file */
  PUT STREAM outstr UNFORMATTED '/*E4GL-I*/ ':U.
END.

/* Repeat the following block for each offset line. */
ASSIGN
  line-num = 0
  curr-state = {&INITIAL-STATE}
  next-state = {&NORMAL-STATE}.
main-loop:
DO WHILE TRUE
    ON ENDKEY UNDO main-loop, LEAVE main-loop
    ON ERROR UNDO main-loop, LEAVE main-loop:
    
  CASE curr-state:
  
    /*
    ** {&INITIAL-STATE} outputs anything accumulated in the output buffer
    ** from the prior line and then reads in a new line after which it's
    ** directed to the requested state in next-state.
    */
    WHEN {&INITIAL-STATE} THEN DO:
      /* Print anything accumulated in the line output buffer */
      IF line-num > 0 THEN DO:
         IF NOT (TRIM(out-buf) BEGINS "ROUTINE-LEVEL ON") AND
            NOT (TRIM(out-buf) BEGINS "BLOCK-LEVEL ON") AND
            NOT (TRIM(out-buf) BEGINS "USING ") THEN
            PUT STREAM outstr UNFORMATTED out-buf "~n":U.
        ASSIGN out-buf = "".
      END.
      /* Read next line in */
      IMPORT STREAM instr UNFORMATTED in-buf.
      /*XXX: Convert tabs to appropriate number of spaces here???
        Note: if it's added here, it has to be added above to the
        IMPORT's for header parsing.  Otherwise, the positions where
        the <META tag starts or ends may be inconsistent. */
      IF TRIM(in-buf) = "" THEN in-buf = "".
      /* If prev-in-buf is non blank, then there was a dangling <SCRIPT tag
         from the previous line.  Tack it onto the start of this line so
         the whole tag can be parsed together. */
      IF prev-in-buf <> "" THEN
        ASSIGN
          in-buf = prev-in-buf + " ":U + in-buf
          prev-in-buf = "".  /* so we don't tack it onto the next line too */
      ASSIGN
        line-num = line-num + 1
        start-offset = 1
        prev-state = curr-state         /* [Bug 19970214-058] */
        curr-state = next-state.

      /* Unless the "keep-meta-content-type" option is specified, check if this
         line starts or ends the <META HTTP-EQUIV="Content-Type" ...> tag and
         if so, comment out the entire tag.  Fix end of tag first in case
         it's on the same line as the tag start.
             This prevents conflicts between the actual Content-Type header
         output from e4gl.i and the <META version in the HTML.  The end
         result was that Netscape 3.0 would reload the page when it found the
         <META HTTP-EQUIV="Content-Type" ...> tag.  This behaviour was
         noticable.  Sometimes "> Transferr Interupted" was displayed.
         [Bug 19970315-001] */
      IF NOT {&KEEP-META-CONTENT-TYPE} THEN DO:
        IF line-num = metact-end-line THEN
          /* Replace closing ">" with " -->". */
          SUBSTRING(in-buf, metact-end-col, 1, "CHARACTER":U) = " -->":U.
        IF line-num = metact-start-line THEN
          /* Replace opening "<" with "<!-- ". */
          SUBSTRING(in-buf, metact-start-col, 1, "CHARACTER":U) =
	    "<!-- E4GL Disabled: ":U.
      END.

      NEXT main-loop.
    END.

    /*
    ** {&NORMAL-STATE} parses and outputs HTML looking for Statement and
    ** Expression Escape opening tags.
    */
    WHEN {&NORMAL-STATE} THEN DO:
      ASSIGN next-state = {&NORMAL-STATE}.  /* return here by default */

      /* Check for all tags on the line finding the earliest tag in the line.
         This logic assumes if there are any tags where one tag is a subset
         of another, the longer of the tags is defined earlier in the
         work table. */
      ASSIGN tag-start-save = 0.
      FOR EACH tag:
        ASSIGN tag-start = INDEX(in-buf, tag.open-tag, start-offset).
        IF debug-mode AND tag-start > 0 THEN
            MESSAGE "tag" tag.open-tag "found on line" line-num
                "at offset" tag-start
                VIEW-AS ALERT-BOX.
        /* If the tag was found and it's earlier in the line than a prior
           tag, remember that one instead. */
        IF tag-start > 0 AND (tag-start-save = 0 OR
                              tag-start < tag-start-save) THEN DO:
          ASSIGN tag-state = tag.tag-state
                 html-open-tag = tag.open-tag
                 html-close-tag = tag.close-tag
                 tag-start-save = tag-start.
          IF debug-mode THEN
            MESSAGE "saved tag" VIEW-AS ALERT-BOX.
        END.
      END.
      /* Restore the position of the best matched tag if one was found */
      ASSIGN tag-start = tag-start-save.

      /* Found opening tag? */
      IF tag-start > 0 THEN DO:
        IF debug-mode THEN
          MESSAGE "found opening tag" VIEW-AS ALERT-BOX.
        /* Check for <SCRIPT LANGUAGE=SpeedScript or WebSpeed4GL ... > tag */
        IF html-open-tag BEGINS "<SCRIPT":U THEN DO:
          IF debug-mode THEN
            MESSAGE "found <SCRIPT tag" VIEW-AS ALERT-BOX.
          /* Look for end of tag */
          ASSIGN tag-end = INDEX(in-buf, ">":U, tag-start).
          IF tag-end > 0 THEN DO:
            ASSIGN
              /* Get entire tag */
              html-open-tag = SUBSTRING(in-buf, tag-start,
                                        tag-end - tag-start + 1,"CHARACTER":U).
            /* If <SCRIPT ...> tag doesn't contain LANGUAGE=SpeedScript or
               LANGUAGE=WebSpeed4GL, drop out. */
            IF NOT html-open-tag MATCHES "*LANGUAGE*=*SpeedScript*":U AND
               NOT html-open-tag MATCHES "*LANGUAGE*=*WebSpeed4GL*":U AND
               NOT html-open-tag MATCHES "*LANGUAGE*=*PROGRESS*":U THEN
              ASSIGN tag-start = -1.  /* forget tag was found */
          END.
          /* Else, end of <SCRIPT ...> tag was not found.  Probably FrontPage
             was used and it split the tag. [Bug 19970304-012] */
          ELSE DO:
            ASSIGN
              /* Save start of tag to end of line.  {&INITIAL-STATE} will
                 add this to the start of the next line it reads in. */
              prev-in-buf = SUBSTRING(in-buf, tag-start, -1, "CHARACTER":U)
              /* Delete tag from input line */
              in-buf = SUBSTRING(in-buf, 1, tag-start - 1, "CHARACTER":U)
              /* Forget tag was found */
              tag-start = -1.
          END.
        END.
        /* If tag matched, then handle it */
        IF tag-start > 0 THEN DO:
          ASSIGN
            prev-state = curr-state
            curr-state = tag-state.     /* set state depending on tag type */
          NEXT main-loop.
        END.
        /* Else, clear any previously saved tag names to forget a match
           with <SCRIPT. [Bug 19970312-056] */
        ELSE IF tag-start = -1 THEN
          ASSIGN
            html-open-tag = ""
            html-close-tag = "".
      END.

      /* Else, no matching opening tags were found.  Output any remainder
         of the input buffer if appropriate. */
      ASSIGN
        /* Extract input buffer from starting offset to end */
        tmp-buf = SUBSTRING(in-buf, start-offset, -1, "CHARACTER":U).
      /* If previous state was an Expression Escape, terminate the statement
         even if there's no more output */
      IF prev-state = {&EXPR-4GL} AND TRIM(tmp-buf) = "" THEN
        ASSIGN out-buf = out-buf + ".":U.
      /* Else, if nothing left on the line or the input buffer consists of
         just the opening or closing tag, do nothing else but output the 
         remainder of the line. */
      ELSE IF NOT (TRIM(tmp-buf) = "" OR
              TRIM(in-buf) = html-open-tag OR
              TRIM(in-buf) = html-close-tag)
      THEN
        ASSIGN
          out-buf = out-buf +
                (IF out-buf = "" OR prev-state = {&STMNT-4GL}
                 THEN "~{&OUT~} ":U ELSE "") +
                quote-4GL-text (tmp-buf, TRUE) + ".":U.
      ASSIGN curr-state = {&INITIAL-STATE}.  /* read next line */
    END.

    /*
    ** {&STMNT-TAG-OPEN} causes any HTML preceding the Statement Open Tag
    ** to be output and then sets the context for a Statement Escape.
    */
    WHEN {&STMNT-TAG-OPEN} THEN DO:
      ASSIGN
        /* Extract input buffer from starting offset to tag start */
        tmp-buf = SUBSTRING(in-buf, start-offset,
                            tag-start - start-offset, "CHARACTER":U)
        /* Adjust input buffer starting offset to position after tag */
        start-offset = tag-start + LENGTH(html-open-tag,"CHARACTER":U).
      /* Only output remainder of input line preceding the tag if it's
         non blank. */
      IF TRIM(tmp-buf) <> "" THEN
        /* Append to output buffer after fixing quotes and adding a
           terminator */
        ASSIGN out-buf = out-buf +
                (IF out-buf = "" OR prev-state = {&STMNT-4GL}
                 THEN "~{&OUT~} ":U ELSE "") +
                quote-4GL-text (tmp-buf, FALSE) + ".":U.
      ASSIGN
        /* Append opening tag as a 4GL comment */
        out-buf = RIGHT-TRIM(out-buf) + ' /*Tag=':U +
                  SUBSTRING(in-buf, tag-start,
                            LENGTH(html-open-tag,"CHARACTER":U),
                            "CHARACTER":U) + '*/ ':U
        curr-state = {&STMNT-4GL}.  /* state for next iteration */
      NEXT main-loop.
    END.

    /*
    ** {&EXPR-TAG-OPEN} causes any HTML preceding the Expression Open Tag
    ** to be output and then sets the context for an Expression Escape.
    */
    WHEN {&EXPR-TAG-OPEN} THEN DO:
      ASSIGN
        /* Extract input buffer from starting offset to tag start */
        tmp-buf = SUBSTRING(in-buf, start-offset,
                            tag-start - start-offset, "CHARACTER":U)
        /* Adjust input buffer starting offset to position after tag */
        start-offset = tag-start + LENGTH(html-open-tag,"CHARACTER":U).
      /* Begin a new statement if there's no output yet or previous state
         was a Statement Escape. */
      IF out-buf = "" OR prev-state = {&STMNT-4GL} THEN
        ASSIGN out-buf = out-buf + "~{&OUT~} ":U.
      /* Only output remainder of input line preceding the tag if it's
         non blank. */
      IF TRIM(tmp-buf) <> "" THEN
        /* Append input buffer to output buffer after fixing quotes */
        ASSIGN out-buf = out-buf +
                quote-4GL-text (tmp-buf, FALSE) + " ":U.
      ASSIGN
        /* Append opening tag as a 4GL comment */
        out-buf = RIGHT-TRIM(out-buf) + ' /*Tag=':U + html-open-tag + '*/ ':U
        curr-state = {&EXPR-4GL}.  /* state for next iteration */
      NEXT main-loop.
    END.

    /*
    ** {&STMNT-4GL} and {&EXPR-4GL} states output any 4GL prior to a
    ** closing Statement or Expression escape tag or through the end 
    ** of the line.
    */
    WHEN {&STMNT-4GL} OR
    WHEN {&EXPR-4GL} THEN DO:
      ASSIGN next-state = curr-state.  /* return here by default */
      tag-start = INDEX(in-buf, html-close-tag, start-offset).
      /* Found a closing tag? */
      IF tag-start > 0 THEN DO:
        ASSIGN
          /* Append input buffer from starting offset to tag start. Since
             HTML authoring tools can do unpleasant things to the 4GL code
             inside tags, convert HTML entities back to literal text and
             URL decode depending on the value of curr-state. */
          out-buf = out-buf +
            un-html(RIGHT-TRIM(SUBSTRING(in-buf, start-offset,
                               tag-start - start-offset, "CHARACTER":U)),
                               curr-state) +
            /* and, append closing tag as a 4GL comment */
            ' /*Tag=':U + SUBSTRING(in-buf, tag-start,
                                    LENGTH(html-close-tag,"CHARACTER"),
                                    "CHARACTER":U) + '*/ ':U.
        ASSIGN
          /* Adjust input buffer starting offset to after tag */
          start-offset = tag-start + LENGTH(html-close-tag,"CHARACTER":U).
        ASSIGN
          prev-state = curr-state       /* save current state */
          curr-state = {&NORMAL-STATE}.
        NEXT main-loop.
      END.
      /* Else, no matching Statement or Expression Escape closing tags were
         found.  Output any remainder of the input buffer. */
      ASSIGN
          /* Append input buffer from starting offset to end */
          out-buf = out-buf + un-html(SUBSTRING(in-buf, start-offset,
                              -1, "CHARACTER":U), curr-state).
      ASSIGN curr-state = {&INITIAL-STATE}.  /* read next line */
    END.
    
  END CASE.

END.  /* main-loop */

/*
** Write out comment indicating end of HTML
*/
PUT STREAM outstr UNFORMATTED
  '/************************* END OF HTML *************************/~n':U.

/*
** Write output file heading at the end of the generated file so it will
** not alter the line numbers from the source file.  
*/
PUT STREAM outstr UNFORMATTED
  '/*~n':U
  '** File: ':U p_output-file '~n':U
  '** Generated on: ':U
    STRING(YEAR(TODAY),"9999") '-':U
    STRING(MONTH(TODAY),"99") '-':U
    STRING(DAY(TODAY),"99") ' ':U
    STRING(TIME,"HH:MM:SS") '~n':U
  '** By: WebSpeed Embedded SpeedScript Preprocessor~n':U
  '** Version: ':U {&VERSION} '~n':U
  '** Source file: ':U p_html-file '~n':U
  '** Options: ':U p_options '~n':U
  '**~n':U
  '** WARNING: DO NOT EDIT THIS FILE.  Make changes to the original~n':U
  '** HTML file and regenerate this file from it.~n':U
  '**~n':U
  '*/~n':U.

/*
** Write out internal definitions but only if a Web object is being
** generated, not an include file.
*/
IF {&WEB-OBJECT-IS-SET} THEN DO:
  PUT STREAM outstr UNFORMATTED
    '/********************* Internal Definitions ********************/~n~n':U
    '/* This procedure returns the generation options at runtime.~n':U
    '   It is invoked by src/web/method/e4gl.i included at the start~n':U
    '   of this file. */~n':U
    'PROCEDURE local-e4gl-options :~n':U
    '  DEFINE OUTPUT PARAMETER p_version AS DECIMAL NO-UNDO~n':U
    '    INITIAL {&VERSION}.~n':U
    '  DEFINE OUTPUT PARAMETER p_options AS CHARACTER NO-UNDO~n':U
    '    INITIAL "':U p_options '":U.~n':U
    '  DEFINE OUTPUT PARAMETER p_content-type AS CHARACTER NO-UNDO~n':U
         /* Replace ; with ~; in content-type */
    '    INITIAL "':U REPLACE(content-type,"~;":U,"~~~;":U) '":U.~n':U
    'END PROCEDURE.~n':U.
END.

PUT STREAM outstr UNFORMATTED
  '~n/* end */~n':U.

INPUT STREAM instr CLOSE.
OUTPUT STREAM outstr CLOSE.

RETURN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
