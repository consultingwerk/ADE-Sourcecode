&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 WebTool
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM Definitions 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: edtscrpt.w

  Description: Runs a small amount of WebSpeed Scripting code and displays
               the results. 
               
               All code is prefaces with src/web/method/cgidefs.i
               and 'OUTPUT TO "WEB"'.

  Modifications:
               All code is prefaces with PUT "<PRE>"      sjf 8/30/96
               With an option to change back

               Add the ability to save/open scripts       sjf 9/4/96
               With an option to change back
               
               Error messages now access the              wood 9/6/96   
               
               Support SQL, HTML, JavaScript              wood 9/20/96
               
               New WebSpeed Logo, and misc. formatting    wood 9/24/96

           Cleaned up HTML code. Removed references   nhorn 1/7/97 
           to 'output-type' and 'preformatted'. Added
           style/color consistencies.


  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Wm. T. Wood

  Created: August 10, 1996

------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed WorkBench.          */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Included Files ---                                                   */

/* Preprocessor Definitions ---                                         */
&Scoped-define ScriptDir src/web/scripts

/* Stream to save file into. */
DEFINE STREAM instream.
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

/* ***************************  Functions  **************************** */

&ANALYZE-SUSPEND _CODE-BLOCK _FUNCTION load-script 
FUNCTION load-script RETURNS CHAR (INPUT p_name AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:     Loads a file from the script directory into the CODE variable.
  Parameters:  p_name: filename of the script
  Returns:     "Error" message if code failed.
------------------------------------------------------------------------------*/
  DEF VAR next-line AS CHAR NO-UNDO.
  DEF VAR code-text AS CHAR NO-UNDO.

  /* Make sure the file exists. */
  FILE-INFO:FILE-NAME = "{&ScriptDir}/" + p_name.
  IF FILE-INFO:FULL-PATHNAME eq ? THEN RETURN "** Error loading script file.".
  ELSE DO:
    code-text = "":U.
    /* Read the file line by line. */
    INPUT STREAM instream FROM VALUE(FILE-INFO:FULL-PATHNAME) NO-ECHO.
    Read-Block:
    REPEAT ON ENDKEY UNDO Read-Block, LEAVE Read-Block:
      IMPORT STREAM instream UNFORMATTED next-line.
      code-text = code-text + next-line + '~n'.
    END. /* Read-Block: */
    /* Trim the end of the code. */
    code-text = RIGHT-TRIM(code-text) + '~n':U.
    /* Load succeeded. */
    RETURN code-text.
  END. /* IF FILE [exists]... */
END FUNCTION.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM "Main Code Block" 


/* ************************  Main Code Block  *********************** */

/* Handle the WEB event. */
RUN process-web-request.
&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE get-sample 
PROCEDURE get-sample :
/*------------------------------------------------------------------------------
  Purpose:     Returns a piece of sample code.
  Parameters:  p_lang   -- language
               p_i -- number of sample
               p_sample -- code.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER p_lang   AS CHAR NO-UNDO.
  DEFINE INPUT  PARAMETER p_i      AS INTEGER NO-UNDO.
  DEFINE OUTPUT PARAMETER p_sample AS CHAR NO-UNDO.
  
  &Scoped-define LF CHR(10)
  
  CASE p_lang:
    WHEN "HTML":U THEN
      p_sample = '<B>Hello World!</B>'.
    
    WHEN "JavaScript":U THEN 
      p_sample = 'document.write ("<B>Hello World!</B>")~;' + {&LF} +
                 'window.alert ("I love JavaScript")~;'.

    WHEN "VBScript":U THEN 
      p_sample = 'document.write ("<B>Hello World!</B>")' + {&LF} +
                 'window.alert ("I love VBScript")'.
    
    WHEN "SQL":U THEN
      p_sample = '/* SQL Sample */' + {&LF} +
                 'SELECT * FROM Customer WITH NO-BOX.'. 

    
    WHEN "SpeedScript":U THEN DO:
      CASE p_i:
        WHEN 1 THEN /* 'Hello World' */
          p_sample = 
            '/* Simple example (#1) */' + {&LF} +
            '~{&OUT}' + {&LF} +
            '  "<B>HELLO WORLD!</B>".' 
            .
        WHEN 2 THEN /* Display PROPATH. */
          p_sample = 
            '/* Propath Listing example (#2) */' + {&LF} +
            '~{&OUT}' + {&LF} +
            '  "<I>Propath is:</I><LI>"' + {&LF} +
            '  REPLACE (PROPATH, ",", "<LI>").'
            .
        WHEN 3 THEN /* Connected Databases */
          p_sample =
            '/* Connected Databases example (#3) */' + {&LF} +
            'DEF VAR i AS INTEGER NO-UNDO.' + {&LF} +
            'IF NUM-DBS eq 0 THEN ~{&OUT} "No Databases Connected".' + {&LF} +
            'ELSE DO:' + {&LF} +
            '  ~{&OUT} "<I>Connected Databases:</I>" .' + {&LF} +
            '  DO i = 1 TO NUM-DBS:' + {&LF} +
            '    ~{&OUT} "<LI>" LDBNAME(i).' + {&LF} +
            '  END.' + {&LF} +
            'END.'
            .
        WHEN 4 THEN /* DO loop */
          p_sample = 
            '/* DO loop example (#4) */' + {&LF} +
            'DEF VAR i AS INTEGER NO-UNDO.' + {&LF} + 
            'DO i = 1 TO 5:' + {&LF} +
            '  ~{&OUT} "Line number " i "<BR>".' + {&LF} +
            'END.'
            .
        WHEN 5 THEN /* CGI variables   */
          p_sample = 
            '/* CGI Variable example (#5) */' + {&LF} +
            '~{&OUT}' + {&LF} + 
            '  "<I>CGI and Global Variables:</I><UL>"' + {&LF} + 
            '  "AppProgram:<B> "       AppProgram      "</B><BR>"' + {&LF} +
            '  "SERVER_SOFTWARE:<B> "  SERVER_SOFTWARE "</B><BR>"' + {&LF} +
            '  "REMOTE_ADDR:<B> "      REMOTE_ADDR     "</B><BR>"' + {&LF} +
            '  "HTTP_USER_AGENT:<B> "  HTTP_USER_AGENT "</B><BR>"' + {&LF} +
            '  "</UL>" .'      
            .
      END CASE.
    END. /* WHEN 4GL... */
  END CASE.
   
END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE process-web-request 
PROCEDURE process-web-request :
/*------------------------------------------------------------------------------
  Purpose:     Process Web Request.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR ch          AS CHAR NO-UNDO.
  DEFINE VAR code        AS CHAR NO-UNDO.
  DEFINE VAR cols        AS CHAR NO-UNDO.
  DEFINE VAR i           AS INTEGER NO-UNDO.
  DEFINE VAR iSelected   AS INTEGER NO-UNDO.
  DEFINE VAR lang        AS CHAR NO-UNDO.
  DEFINE VAR langFilter  AS CHAR NO-UNDO INITIAL "*.ss,*.sql,*.js,*.vs,*.html".
  DEFINE VAR langList    AS CHAR NO-UNDO INITIAL "SpeedScript,SQL,JavaScript,VBScript,HTML".
  DEFINE VAR load-name   AS CHAR NO-UNDO.
  DEFINE VAR l_loadOK    AS LOGICAL NO-UNDO INITIAL yes.
  DEFINE VAR l_run       AS LOGICAL NO-UNDO.
  DEFINE VAR l_scriptDir AS LOGICAL NO-UNDO.
  DEFINE VAR sample-list AS CHAR NO-UNDO.
  DEFINE VAR sample-num  AS INTEGER NO-UNDO.
  
  /* 
   * Output the MIME header, and start returning the HTML form. This object is
   * not State-Aware, so run this directly.
   */
  RUN outputContentType IN web-utilities-hdl ("text/html":U).
  
  /* Get the Language to process. Make sure it is valid. */
  lang = get-value("language":U).
  IF LOOKUP(lang, langList) eq 0 THEN lang = "SpeedScript".
  
  /* See if there is a "Sample Script Dir" */
  FILE-INFO:FILE-NAME = "{&ScriptDir}".
  l_scriptDir = FILE-INFO:FULL-PATHNAME ne ? AND FILE-INFO:FILE-TYPE BEGINS "D":U.

  /* Does the user explicitly want a particular sample. 
     (You would request this by setting your URL to 'webtools/edtscrpt.p?sample=1' )*/
  ch = get-value("Sample":U).
  IF ch ne "" THEN DO:
    l_run = no.  /* Don't run sample code the first time. */
    ASSIGN sample-num = INTEGER(ch) NO-ERROR.
    RUN get-sample (lang, sample-num, OUTPUT code).
  END.
  ELSE DO:
   /* Are we loading a script? */
   load-name = get-value ('loadScript':U).
   IF load-name ne '':U 
   THEN code = load-script(INPUT load-name).
   ELSE 
     /* Get the code, and see if the user wants to RUN. */
     ASSIGN code  = get-value("CODE":U)
            l_run = (get-value ('Run':U) ne '':U)
            . 
  END.

  /* On an intial GET of this web object, either show a sample, or show the list of
     samples in the scripts directory. */
  IF NOT l_run AND code eq "" THEN DO:
    IF NOT l_scriptDir THEN DO: 
      ASSIGN sample-num = RANDOM(1, 5).
      RUN get-sample (lang, sample-num, OUTPUT code).
    END.
  END.   

  /*
   * Create the HTML form.  
   */
  {&OUT}
    {webtools/html.i 
     &SEGMENTS = "head,open-body,title-line"
     &AUTHOR   = "Wm.T.Wood"
     &TITLE    = "Scripting Lab" 
     &FRAME    = "WS_main"  
     &CONTEXT  = "{&Webtools_Script_Editor_Help}" }
    . 

  {&OUT}
    '<CENTER>~n'
    '<FORM METHOD="POST" ACTION="' AppURL '/' THIS-PROCEDURE:FILE-NAME '">~n'
    '<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2"><TR>~n'
    '<TD ALIGN = "LEFT" COLSPAN="2">~n'
    '<B>' format-label ('Language', 'SIDE':U, '':U) '</B>'
    .
   
   /* Output the Scripting Language options, and a hidden field with the current
      language. */
   {&OUT} '<INPUT TYPE="HIDDEN" NAME="language" VALUE="' lang '">~n'.
   DO i = 1 TO NUM-ENTRIES (langList):
     ch = ENTRY (i, langList).
     IF ch eq lang THEN
       {&OUT} '<FONT COLOR="' get-color("LabelledText":U) '" SIZE="+1"><B>' ch '</B></FONT>~n'.
     ELSE
       {&OUT} SUBSTITUTE ('<A HREF="&1/&2?language=&3">&3</A>~n',
                          AppURL,
                          THIS-PROCEDURE:FILE-NAME,
                          ch).
   END. /* DO... */
  
  {&OUT}  '</TD></TR>~n'.

  /* Place the CODE textarea in a cell. Followed by the Submit button. For Explorer
     browsers, show this as an wider view because we can adjust the font. */ 
  {&OUT} '<TR><TD ALIGN="CENTER" COLSPAN="2">'.
  IF INDEX(get-cgi('HTTP_USER_AGENT':U), " MSIE ":U) > 0 THEN {&OUT}
      '<TEXTAREA NAME="CODE" ROWS="9" COLS="90">'  /* NO ~n */
     html-encode(code)
     '</TEXTAREA>'   /* NO ~n */
     .
  ELSE {&OUT}
     '<TEXTAREA NAME="CODE" ROWS="9" COLS="72">'  /* NO ~n */
     html-encode(code)
     '</TEXTAREA>' /* NO ~n -- */
     .
  {&OUT} '</TD></TR>~n'.

  /* The final ROW of the table contains the buttons for Run (SUBMIT), Clear, and Reset
      (plus any samples) */
  {&OUT}
     '<TR>~n'
     '<TD><INPUT TYPE="SUBMIT" NAME="Run" VALUE="Run Script"></TD>~n'
     '<TD ALIGN="RIGHT">~n'
     .
  /* Are there samples? */
  IF l_scriptDir 
  THEN {&OUT} '<INPUT TYPE="SUBMIT" NAME="ListScripts" VALUE="Load Script...">':U. 
  ELSE DO:
    /* We have multiple SpeedScript samples, even without a "Script" sample directory.*/
    IF lang eq "SpeedScript":U THEN DO:
      {&OUT}
        '  'format-label ("Sample", "SIDE":U, "":U)
        '  <SELECT NAME="SampleCode" SIZE=1 '
        'onChange = "window.location.href=~'' AppURL '/' THIS-PROCEDURE:FILE-NAME 
        '?sample=~' + (this.selectedIndex + 1);">'.  /* No ~n */
      /* If a new sample has not been set, then retain the last value. */
      sample-list = 'Hello World,Display PROPATH,Connected Databases,Simple DO Loop,CGI Variables':U.
      IF sample-num > 0 THEN iSelected = sample-num.
      ELSE iSelected = LOOKUP(get-value('SampleCode':U), sample-list).
      DO i = 1 TO 5:
        {&OUT} '    <OPTION' (IF iSelected eq i THEN ' SELECTED>' ELSE '>') ENTRY(i, sample-list) '~n'.
      END. /* DO... */   
      {&OUT} '  </SELECT>~n'.
    END. /* IF lang eq "SpeedScript"... */
  END. /* IF [not] l_scriptDir... */
  
  /* Add Reset and Clear buttons. */
   {&OUT}
     '  <INPUT TYPE="BUTTON" VALUE="Clear" ' /* No ~n */
     /* On IE3, we have to set the value twice (first time to ' ') in order to get the
        CLEAR to work. */
     'onClick="var Code=document.forms[0].CODE; Code.focus()~; Code.value=~' ~'~; Code.value=~'~'~;">~n'
     '  <INPUT TYPE="RESET"  VALUE="Reset">' /* No ~n */
     '</TD>~n'
     '</TR>~n'
     '</TABLE>~n'
     '</FORM>~n'
     '</CENTER>~n'
     .
    
  /* Run new, non-blank code. Don't run any newly created sample code. */
  IF code ne "":U AND l_run THEN DO:
    CASE lang:
      WHEN "HTML":U THEN
        {&OUT} format-text ('Results:', 'CENTER,H3':U) '<HR>~n' code.
      WHEN "JavaScript":U THEN
        {&OUT} format-text ('Results:', 'CENTER,H3':U) '<HR>~n'
               '<SCRIPT LANGUAGE = "JavaScript">~n'
               code
               '</SCRIPT>'.
      WHEN "VBScript":U THEN
        {&OUT} format-text ('Results:', 'CENTER,H3':U) '<HR>~n' 
               '<SCRIPT LANGUAGE = "VBScript">~n'
               code
               '</SCRIPT>'.
      OTHERWISE RUN webtools/util/_run4gl.w (code, ?, "NO-HEAD" ).
    END CASE.
  END. /* IF code... */
  ELSE IF l_scriptDir AND get-value ("ListScripts":U) ne 'no':U AND load-name eq '':U THEN DO:
    /* Does the user want a list of saved scripts? This is the default. */
    {&OUT} format-text (lang + ' Sample Scripts:', 'CENTER,H3':U) '<HR><CENTER>~n'.
    /* Output a list of files in the scripts directory that match this type. */
    RUN webtools/util/_dirlist.w
           ("{&ScriptDir}",            /* Directory */
            ENTRY(LOOKUP(lang,langList), langFilter), /* Filter */
            false,                     /* No directories */
            ' <A HREF="edtscrpt.w?language=' + lang + '~&~&loadScript=&4">&1</A> ',
            '',                        /* non-empty leader */
            '',                        /* non-empty trailer */
            'No Scripts Available',    /* "empty" string. */
            '4,0,0,3':U,               /* Table columns, border,cellpadding, cellspacing,  */
            'Clean-Name':U,            /* Remove "_" and extension from name.  */
            OUTPUT i).         
   {&OUT} '</CENTER>~n'.
 
  END. /* IF...ListScripts... */
  
  /* Finish the Page. */  
  {&OUT}
   '</BODY>~n'
   '</HTML>~n'
    .
  
END PROCEDURE.
&ANALYZE-RESUME
 

