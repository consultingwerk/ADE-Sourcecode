/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * wtbtest.p
 * Test program for the WebSpeed Transaction Broker (wtb).
 *
 * This program demonstrates a simple event loop for handling Web events
 * along with a method of retrieving the value of CGI environment variables. 
 *
 * Much of the functionality in this program is already provided with the
 * default dispatch program web-disp.p and other procedures.  Places where
 * this is the case have been noted.
 *
 * Nonetheless, this example program may prove useful to see a simplified 
 * version of the WebSpeed event handling and also as an illustration of
 * a number of programming constructs available in the WebSpeed 4GL.
 *
 * Specify the path to this file in the Broker configuration 
 * file (wtb.cnf):
 *    AgentParams -p src/web/examples/wtbtest.p
 *
 * This file can also be run from Agents configured with the default
 * web-disp.p by specifying it in the URL:
 *    http://myhost/cgi-bin/your-messenger-file/src/web/examples/wtbtest.p
 */

/* Delimiter character in octal = CHR(255) */
DEFINE VARIABLE asc-del AS CHARACTER NO-UNDO INITIAL "~377":U.
    
/* When web event comes in, this trigger is fired to return an HTML page. */
ON "WEB-NOTIFY":U ANYWHERE DO:
  DEFINE VARIABLE query_string AS CHARACTER NO-UNDO FORMAT "x(60)":U.
  DEFINE VARIABLE ix           AS INTEGER   NO-UNDO.

  /* Get the contents of QUERY_STRING if any.  The standard web utility
     procedures, including {src/web/method/cgidefs.i} define QUERY_STRING as a
     global variable (along with many other CGI and HTTP variables) which are 
     updated automatically and transparently with each web request.  Any other
     environment variables in a web request can be retrieved with the GetCgi 
     utility procedure. */
  RUN get-cgi ("QUERY_STRING":U).
  ASSIGN query_string = RETURN-VALUE.

  /* Output the HTTP Content-Type header, HTML Head and start of Body sections */
  PUT UNFORMATTED
    'Content-type: text/html~n~n':U
    '<HTML>~n':U
    '<HEAD><TITLE>':U 'WebSpeed Agent Test Output' '</TITLE></HEAD>~n':U
    '<BODY>~n':U
    '<H1>':U 'WebSpeed Agent Test Output' '</H1>~n':U
    '<HR>~n':U.

  /* If the URL specified was .../<any-script.cgi>?view-source, display the
     source to ourself. */
  IF query_string = "view-source":U THEN DO:
    PUT UNFORMATTED
      '<H2>':U 'Source for this program' ' "':U THIS-PROCEDURE:FILE-NAME '"</H2>~n':U.
    RUN view-source (THIS-PROCEDURE:FILE-NAME).
    PUT UNFORMATTED
      '<HR>~n':U
      '<P><A HREF="wtbtest.p">':U 'Return' '</A></P>~n':U.
  END.
  ELSE DO:
    PUT UNFORMATTED
      '<H2>':U 'Environment Variables for This Request' '</H2>~n':U
      '<UL>~n':U.
    /* Dump out all environment name=value pairs */
    DO ix = 1 TO NUM-ENTRIES(WEB-CONTEXT:CURRENT-ENVIRONMENT, asc-del):
      PUT UNFORMATTED
        '<LI>':U ENTRY(ix, WEB-CONTEXT:CURRENT-ENVIRONMENT, asc-del) '~n':U.
    END.
    PUT UNFORMATTED
      '</UL>~n':U
      '<P>':U 'The form input string is: ' '<B>':U WEB-CONTEXT:FORM-INPUT '</B></P>~n':U
      '<P>':U 'The Exclusive Id is: ' '<B>':U WEB-CONTEXT:EXCLUSIVE-ID '</B></P>~n':U
      '<HR>~n':U
      '<P><A HREF="wtbtest.p?view-source">':U 'View source to this program' '</A></P>~n':U.
  END.

  /* Output the HTML trailer */
  PUT UNFORMATTED
    '<ADDRESS>':U 'This page is produced by a WebSpeed application.' '</ADDRESS>~n':U
    '</BODY>~n':U
    '</HTML>~n':U.

END.  /* ON "WEB-NOTIFY" ... */

/* Redirect the unnamed stream for web output */
OUTPUT TO "WEB":U.

/* Detect if this program is being run from web/objects/web-disp.p which
   runs all Web objects persistent.  If so, fire the trigger and return. */
IF THIS-PROCEDURE:PERSISTENT THEN DO:
  APPLY "WEB-NOTIFY":U TO THIS-PROCEDURE.
  RETURN.
END.

/* Otherwise if this procedure is executed directly by an Agent via the -p 
   option in wtb.cnf, then wait for the WEB-NOTIFY event ourself.  Of course, 
   the number of different Web objects or procedures you can run is limited 
   to just this one since there's no mechanism to parse the URL and dispatch 
   a program as a result. */
REPEAT:
  /* Wait for an event to come in from the web. */
  WAIT-FOR "WEB-NOTIFY":U OF DEFAULT-WINDOW. 
END.

/* Procedure to lookup a CGI environment variable for this web request. This 
   procedure has similar functionality to the GetCgi procedure in
   src/web/method/cgiprocs.i except in that case, WEB-CONTEXT:CURRENT-ENVIRONMENT
   is parsed only once per web request.
 
   Input parameter: name of CGI variable to look up
   Return value: value of CGI variable
 */
PROCEDURE get-cgi :
  DEFINE INPUT PARAMETER p-varname AS CHARACTER NO-UNDO.

  DEFINE VARIABLE search-varname AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE out-value      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ix             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE jx             AS INTEGER    NO-UNDO.

  /* Loop through each name=value pair ... */
  DO ix = 1 TO NUM-ENTRIES(WEB-CONTEXT:CURRENT-ENVIRONMENT, asc-del):
    ASSIGN search-varname = ENTRY(ix, WEB-CONTEXT:CURRENT-ENVIRONMENT, asc-del).
    
    /* Does it match? */
    IF search-varname BEGINS p-varname + "=":U THEN DO:
      ASSIGN 
        jx        = INDEX(search-varname, "=":U)
        /* If an equals was found, extract the value after it */
        out-value = IF jx > 0 THEN SUBSTRING(search-varname, jx + 1) ELSE "".
      LEAVE.
    END.
  END.
  RETURN out-value.
END.

/* Procedure to read in a file and send it out.
   Input paramater: file to output as HTML to the web steram
 */
PROCEDURE view-source :
  DEFINE INPUT PARAMETER p-file AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE v-file  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE in-line AS CHARACTER  NO-UNDO.

  /* Find the file in the PROPATH */
  ASSIGN v-file = SEARCH(p-file).
  IF v-file = ? THEN
    ASSIGN v-file = SEARCH("src/web/examples/":U + p-file).

  /* If the file was not found, output an error message */
  IF v-file = ? THEN DO:
    PUT UNFORMATTED
      '<P><B>ERROR:</B> ':U
       SUBSTITUTE('The file &1 was not found.', p-file) 
       '</P>':U SKIP.
    RETURN.
  END.

  /* Open the file, read it in and write it out */
  PUT UNFORMATTED "<PRE>":U SKIP.
  INPUT FROM VALUE(p-file) NO-ECHO.
  REPEAT:
    IMPORT UNFORMATTED in-line.
    /* Now replace some characters with HTML entities so HTML can be
       displayed rather than interpreted.  Note that the web utility
       procedure AsciiToHtml provides the identical functionality to these
       replace statements. */
    in-line = REPLACE(in-line, "&":U, "&amp~;":U).   /* & */
    in-line = REPLACE(in-line, ">":U, "&gt~;":U).    /* > */
    in-line = REPLACE(in-line, "<":U, "&lt~;":U).    /* < */
    in-line = REPLACE(in-line, '"':U, "&quot~;":U).  /* " */

    /* Check for a (very) few keyords at the start of the line.  If there's
       a match, make the whole line bold. */
    IF in-line BEGINS "PROCEDURE":U OR in-line BEGINS "OUTPUT ":U OR
       in-line BEGINS "REPEAT":U    OR in-line BEGINS "END":U     OR 
       in-line BEGINS "ON ":U THEN
      PUT UNFORMATTED "<B>":U in-line "</B>~n":U.
    ELSE 
      PUT UNFORMATTED in-line "~n":U.
  END.
  INPUT CLOSE.
  PUT UNFORMATTED "</PRE>":U SKIP.

END PROCEDURE.

/* wtbtest.p - end of file */
