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
/****************************************************************************
 Procedure: printval.p
 Description: Outputs all field names and CGI values for debugging, etc.
   An HTML form allows changing debugging options and a few other
   administrative tasks.
 Author: B. Burton
 Input Parameter: comma separated list of options.  Currently supported
   options are admin, vars, agent, cookies, fields, nohead, http and all.  
   All of the options can be prefixed with "no" to turn that option off.
   Unknown options are ignored.  If all options are unknown, no output is
   generated.  In addition, if "nohead" is specified in conjunction with
   any options, then no HTML header will be output.  This is appropriate
   if this program will be run from within an application.
 Global Variables: debug-options
 Examples:
  run web/support/printval.p ("all").  /* output all information */
  run web/support/printval.p ("all,noadmin").  /* all except admin form */
  run web/support/printval.p ("fields,nohead").  /* fields with no HTML head */
 Note:
  This program was originally written for PROCGI.  It has since been revamped
  to work with WebSpeed.  Due to time constraints, it has not been integrated
  into the WebSpeed runtime framework to the extent it should.
  
 Updates: 12/12/00 adams@progress.com
            Added Unicode support, applied code formatting standards
****************************************************************************/

/* Define preprocessors that allow this file to compile under WorkBench. */     
&IF "{&OPSYS}" = "MSDOS" &THEN
  &SCOPED-DEFINE WEB-NOTIFY WINDOW-CLOSE
  &SCOPED-DEFINE WEB-CURRENT-ENVIRONMENT ""
  &SCOPED-DEFINE WEB-FORM-INPUT ""
  &SCOPED-DEFINE WEB-EXCLUSIVE-ID "="
&ELSE
  &SCOPED-DEFINE WEB-NOTIFY WEB-NOTIFY
  &SCOPED-DEFINE WEB-CURRENT-ENVIRONMENT WEB-CONTEXT:CURRENT-ENVIRONMENT
  &SCOPED-DEFINE WEB-FORM-INPUT WEB-CONTEXT:FORM-INPUT
  &SCOPED-DEFINE WEB-EXCLUSIVE-ID WEB-CONTEXT:EXCLUSIVE-ID
&ENDIF

{src/web/method/cgidefs.i}      /* Basic CGI variables */

DEFINE INPUT PARAMETER p-options AS CHARACTER NO-UNDO.

DEFINE VARIABLE v-admin   AS LOGICAL NO-UNDO.
DEFINE VARIABLE v-agent   AS LOGICAL NO-UNDO.
DEFINE VARIABLE v-cookies AS LOGICAL NO-UNDO.
DEFINE VARIABLE v-vars    AS LOGICAL NO-UNDO.
DEFINE VARIABLE v-fields  AS LOGICAL NO-UNDO.
DEFINE VARIABLE v-http    AS LOGICAL NO-UNDO.
DEFINE VARIABLE ix        AS INTEGER NO-UNDO.

/* The "all" option sets everything.  Check for "all" first so other options 
   can override even if "all" is specified later in the list. */
IF CAN-DO(p-options,"all":U) THEN
  ASSIGN
    v-admin   = True
    v-agent   = TRUE
    v-cookies = TRUE
    v-vars    = TRUE
    v-fields  = TRUE.

/* Check each option in order turning known ones on or off. */
DO ix = 1 TO NUM-ENTRIES(p-options):
  CASE ENTRY(ix, p-options):
    WHEN "admin":U     THEN v-admin   = TRUE.
    WHEN "noadmin":U   THEN v-admin   = FALSE.
    WHEN "agent":U     THEN v-agent   = TRUE.
    WHEN "noagent":U   THEN v-agent   = FALSE.
    WHEN "cookies":U   THEN v-cookies = TRUE.
    WHEN "nocookies":U THEN v-cookies = FALSE.
    WHEN "vars":U      THEN v-vars    = TRUE.
    WHEN "novars":U    THEN v-vars    = FALSE.
    WHEN "fields":U    THEN v-fields  = TRUE.
    WHEN "nofields":U  THEN v-fields  = FALSE.
    WHEN "http":U      THEN v-http    = TRUE.
    WHEN "nohttp":U    THEN v-http    = FALSE.
  /* otherwise, option is ignored */
  END CASE.
END.

/* Only generate output if there's a recognized option */
IF v-admin OR v-agent OR v-cookies OR v-vars OR v-fields THEN DO:
  /* If "nohead" included in options, then don't output HTML heading */
  IF NOT CAN-DO(p-options,"nohead":U) THEN DO:
    output-content-type("text/html":U).
    {&OUT}
      '<HTML>~n':U
      '<HEAD><TITLE>':U 'WebSpeed Request Information' '</TITLE></HEAD>~n':U
      '<BODY BGCOLOR="#FFFFFF">~n':U
      {&END}
  END.

  {&OUT}
    (IF p-options <> "admin":U THEN '~n<HR>~n':U ELSE '')
    '<H1>':U 'WebSpeed Request Information' '</H1>~n~n':U
    {&END}

  /* Links to jump to sections of the output */
  IF v-admin THEN DO:
    /* If not just the admin option */
    IF p-options <> "admin":U THEN
      {&OUT}
        '<P>':U
        '<A HREF="#start-of-admin-form">':U 
          'Skip to start of administration form':U '</A>~n':U
        '</P>~n':U
        {&END}
      {&OUT} '<A NAME="start-of-debugging"></A>~n~n':U {&END}
  END.

  /* Run a procedure if the appropriate option is set */
  IF v-agent   THEN RUN PrintAgent.
  IF v-cookies THEN RUN PrintCookies.
  IF v-vars    THEN RUN PrintVars.
  IF v-fields  THEN RUN PrintFields.

  IF v-admin THEN DO:
    {&OUT} '<A NAME="start-of-admin-form"></A>~n~n':U {&END}
    /* Form to change debugging options */
    RUN PrintAdminForm.
  END.
END.

RETURN.

/****************************************************************************
 Procedure: PrintAdminForm
 Description: Outputs an HTML form to select debugging options
 Input: none
 Output: HTML to web output
 Global Variables: debug-options
****************************************************************************/
PROCEDURE PrintAdminForm:
  DEFINE VARIABLE i-tmp   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i-name  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i-value AS CHARACTER  NO-UNDO.

  /* Get the debugging cookie */
  i-tmp = get-cookie("WSDebug":U).

  {&OUT}
    '<H2>':U 'Debugging and Administrative Options' '</H2>~n':U
    '<P>':U 'Please follow these steps below to change ':U '~n':U
    'persistent debugging options.' '</P>~n':U
    '<OL>~n':U

    '<LI>':U 'First, change debugging options in one of the sections below:' '~n':U

    '<UL>~n':U

    /* link for "on" */
    '<LI>':U 'Set all options ':U '<A HREF="':U SelfURL '?debug=on">ON</A><BR>~n':U

    /* link for "off" */
    '<LI>' 'Set all options ':U '<A HREF="':U SelfURL '?debug=off">OFF</A><BR>~n':U

    '<FORM ACTION="':U SelfURL '" METHOD=POST>~n':U

    '<LI>':U 'Select one or more of the following toggle boxes:':U '<BR>~n':U

    /* Checkbox for this form */
    '<INPUT NAME="debug" TYPE="checkbox" VALUE="admin" ':U
    (IF debug-options = "all":U OR
      CAN-DO(debug-options,"admin":U) THEN "CHECKED":U ELSE "") '>~n':U
    ' This form' '<BR>~n':U

    /* Checkbox for agent */
    '<INPUT NAME="debug" TYPE="checkbox" VALUE="agent" ':U
    (IF debug-options = "all":U OR
      CAN-DO(debug-options,"agent":U) THEN "CHECKED":U ELSE "") '>~n':U
    ' Agent specific information' '<BR>~n':U

    /* Checkbox for cookies */
    '<INPUT NAME="debug" TYPE="checkbox" VALUE="cookies" ':U
    (IF debug-options = "all":U OR
      CAN-DO(debug-options,"cookies":U) THEN "CHECKED":U ELSE "") '>~n':U
    ' Persistent State Cookies' '<BR>~n':U

    /* Checkbox for vars */
    '<INPUT NAME="debug" TYPE="checkbox" VALUE="vars" ':U
    (IF debug-options = "all":U OR
      CAN-DO(debug-options,"vars":U) THEN "CHECKED":U ELSE "") '>~n':U
    ' Environment and other variables' '<BR>~n':U

    /* Checkbox for fields */
    '<INPUT NAME="debug" TYPE="checkbox" VALUE="fields" ':U
    (IF debug-options = "all":U OR
      CAN-DO(debug-options,"fields":U) THEN "CHECKED":U ELSE "") '>~n':U
    ' Form input and arguments' '<BR>~n':U

    /* Checkbox for http output */
    '<INPUT NAME="debug" TYPE="checkbox" VALUE="http" ':U
    (IF /** debug-options = "all" or **/
      CAN-DO(debug-options,"http":U) THEN "CHECKED":U ELSE "") '>~n':U
    ' Output HTTP headers sent by application' '<BR>~n':U

    /* Select checked options, all on or all off */
    'Set above ' '<INPUT TYPE="submit" VALUE="checked">':U ' options' '<BR>~n':U
    '</FORM>~n':U
    {&END}

  {&OUT}
    /* Current debug-options variable and WSDebug cookie */
    '<FORM ACTION="':U SelfURL '" METHOD=GET>~n':U
    '<LI>':U 'Current debug options: '
    '<INPUT NAME="debug" TYPE="input" SIZE=40 VALUE="':U debug-options '">~n':U
    '<INPUT TYPE="submit" VALUE="set options"><BR>~n':U
    'Debugging Cookie WSDebug: <B>' i-tmp '</B> ':U
    '(from the <I>prior</I> request)</P>~n'
    '</FORM>~n':U
    '</UL>~n':U
    {&END}

    /* Convenient way to reload the current page */
  {&OUT}
    '<FORM ACTION="' SelfURL '" METHOD=GET>~n':U
    '<LI><P>Then <INPUT TYPE="submit" VALUE="reload"> this page with no form~n'
    'input and no arguments.  This will also syncronize the WSDebug~n'
    'Cookie with the current debug options.</P>~n'
    '</FORM>~n':U

    '<LI><P>Next, click your browser''s <B>Reload</B> button.  The value ~n'
    'of <EM>Current debug options</EM> and <EM>Debugging Cookie</EM> ~n'
    'should agree.</P>~n'

    '<LI><P>Finally, run your application normally by editing or reentering ~n'
    'the URL to it.  Using the <EM>Back</EM> button or selecting from the ~n'
    'history does not work.  When debugging has been turned on, the ~n'
    'debugging information will appear after any output from your ~n'
    'application.</P>~n'

    '</OL>~n':U
    {&END}

END.  /* procedure PrintAdminForm */

/****************************************************************************
 Procedure: PrintAgent
 Description: Outputs Agent specific information
 Input: none
 Output: HTML to web output
 Global Variables: many
****************************************************************************/
PROCEDURE PrintAgent:
  /* Agent Specific Information */
  DEFINE VARIABLE state-aware       AS LOGICAL    NO-UNDO FORMAT "YES/NO".
  DEFINE VARIABLE transaction-state AS CHARACTER  NO-UNDO.

  RUN find-web-objects IN web-utilities-hdl (OUTPUT state-aware).
  RUN get-transaction-state IN web-utilities-hdl.

  ASSIGN
    transaction-state   = RETURN-VALUE
    FILE-INFO:FILE-NAME = ".":U.

  {&OUT}
    "<H2>Agent Specific Information</H2>~n"
    "<UL>~n"
    "<LI><B>Any State-Aware Web objects?</B> "
      state-aware format "YES/NO " SKIP
    "<LI><B>Database Transaction</B> = "
      TRANSACTION format "ACTIVE/INACTIVE" SKIP
        "<BR>From 4GL <EM>TRANSACTION</EM> function" SKIP
    "<LI><B>Transaction Request State</B> = " transaction-state SKIP
        "<BR>From <EM>get-transaction-state</EM> method" SKIP
    "<LI><B>WEB-CONTEXT:EXCLUSIVE-ID</B> = " {&WEB-EXCLUSIVE-ID} SKIP
    "<LI><B>Default Directory</B> = " FILE-INFO:FULL-PATHNAME SKIP
    {&END}
  RUN print-delimited-list ("<LI>", "<B>Web object path (PROPATH)</B> = ",
                            PROPATH, ",", ?, "").
  {&OUT}
    "</UL>~n~n":U
    {&END}

END.  /* procedure PrintAgent */

/****************************************************************************
 Procedure: PrintCookies
 Description: Outputs Cookies
 Input: none
 Output: HTML to web output
 Global Variables: many
****************************************************************************/
PROCEDURE PrintCookies:
  DEFINE VARIABLE ix            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE i-tmp         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i-cookie-list AS CHARACTER  NO-UNDO.

  /* Get list of cookies */
  i-cookie-list = get-cookie(?).

  {&OUT}
    '<H2>':U 'Persistent State Cookies' '</H2>~n':U
    '<UL>~n':U
    '<LI>':U 'List of Cookies = '
      (IF i-cookie-list = "" THEN "none" ELSE i-cookie-list) '~n':U {&END}

  DO ix = 1 TO NUM-ENTRIES(i-cookie-list):
    {&OUT} "<LI>" ENTRY(ix, i-cookie-list) " = "
      html-encode(get-cookie(ENTRY(ix, i-cookie-list))) "~n" {&END}
  END.

  {&OUT} "</UL>~n~n":U {&END}

END.  /* procedure PrintCookies */


/****************************************************************************
 Procedure: PrintVars
 Description: Outputs CGI, HTTP, cookies and other variables
 Input: none
 Output: HTML to web output
 Global Variables: many
****************************************************************************/
PROCEDURE PrintVars:
  DEFINE VARIABLE asc-del AS CHARACTER  NO-UNDO INITIAL "~377":U. 
  DEFINE VARIABLE i-tmp   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i-name  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i-value AS CHARACTER  NO-UNDO.

  /* HTTP Headers */
  {&OUT}
    "<H2>HTTP Headers Sent</H2>~n"
    {&END}
  IF available-messages("http") THEN
    output-messages("group","http", "HTTP Headers sent by this application").  
  ELSE
    {&OUT} '<P>None or not tracing headers</P>~n' {&END}

  /* Miscellaneous Variables */
  {&OUT}
    "<H2>Miscellaneous Variables</H2>~n"
    "<UL>~n":U
    "<LI>debug-options = " debug-options SKIP
    "<LI>HostURL = " HostURL SKIP
    "<LI>AppURL = " AppURL SKIP
    "<LI>SelfURL = " SelfURL SKIP
    "<LI>AppProgram = " AppProgram SKIP
    "<LI>SelDelim = " SelDelim SKIP
    "<LI>utc-offset = " utc-offset SKIP
    "</UL>~n~n":U
    {&END}

  /* Environment Variables */
  {&OUT}
    "<H2>Environment Variables</H2>~n"
    "<DL>~n":U
    /* NOTE: this method is not recommended for new applications */
    "<DT><B>WEB-CONTEXT:CURRENT-ENVIRONMENT</B> =~n"
    {&END}

  RUN print-delimited-list ("<DD>":U, "", {&WEB-CURRENT-ENVIRONMENT},
                            asc-del,    /* input delimiter  */
                            "<BR>~n":U, /* output delimiter */
                            "</DD>~n":U).

  {&OUT} "</DL>~n~n":U {&END}

END.  /* procedure PrintVars */

/****************************************************************************
 Procedure: PrintFields
 Description: Outputs form field values
 Input: none
 Output: HTML to web output
 Global Variables: many
****************************************************************************/
PROCEDURE PrintFields:
  DEFINE VARIABLE field-list AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ix         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE i-name     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i-value    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i-tmp      AS CHARACTER  NO-UNDO.

  {&OUT}
    '<H2>':U 'Form Fields' '</H2>~n':U
    {&END}

  /* If no form fields ... */
  /** if FieldList = "" then do: **/
  IF {&WEB-FORM-INPUT} = ? THEN DO:
    {&OUT} "<P>No form information available</P>~n" {&END}
    RETURN.
  END.

  /* Get a list of all the form field and argument names */
  field-list = get-field(?).

  {&OUT} "<DL>~n" {&END}

  {&OUT}
    /* NOTE: this method is not recommended for new applications */
    "<DT><B>Raw input from WEB-CONTEXT:FORM-INPUT</B> =~n"
    {&END}

  RUN print-delimited-list ("<DD>":U, "", {&WEB-FORM-INPUT}, "&":U, 
                            "<BR>~n":U, "</DD>":U).

  {&OUT} "<DT><B>List of fields</B> =~n" {&END}

  RUN print-delimited-list ("<DD>":U, "", field-list, ",":U, ?, "</DD>":U).

  /* Output any fields and their data. */
  {&OUT}
    '<DT><B>':U 'Parsed and Decoded Form Input' '</B> =~n':U
    '<DD>':U
    {&END}
  DO ix = 1 TO NUM-ENTRIES(field-list):
    ASSIGN
      i-name  = ENTRY(ix, field-list)  /* Get field name */
      i-value = get-field(i-name).    /* Get field value */

    /* One value per field? */
    IF NUM-ENTRIES(i-value, SelDelim) = 1 THEN
      {&OUT} i-name " = ":U i-value "<BR>~n":U {&END}

    /* Else, more than one value per field */
    ELSE DO:
      {&OUT} i-name "(":U STRING(NUM-ENTRIES(i-value, SelDelim))
         " entries) =<BR>~n"{&END} 

      RUN print-delimited-list ("<UL>~n":U, "", i-value, SelDelim,
                                "<LI>":U, "</UL>":U).
    END.
  END.  /* ... each field */

  {&OUT} "</DL>~n~n":U {&END}

END.  /* procedure PrintFields */


/****************************************************************************
 Procedure: print-delimited-list
 Description: Outputs any character list with a known delimiter in a nicely
     formatted manner.  The actual delimiter character can be replaced with
     something else to obtain different formatting styles from simple
     wrapping to a bulleted list or other formatting.
 Input: Leader, prompt, list to output, delimiter character, width, trailer
 Output: HTML to web output
 Usage: look at usage in src/web/support/printval.p
****************************************************************************/
PROCEDURE print-delimited-list:
  DEFINE INPUT PARAMETER p-leader  AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER p-prompt  AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER p-list    AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER p-delim   AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER p-odelim  AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER p-trailer AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE ix      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE v-item  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE v-delim AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE v-out   AS CHARACTER  NO-UNDO.

  /* If output delimiter is ?, default to same as input delimiter + newline */
  IF p-odelim = ? THEN
    p-odelim = p-delim + "~n":U.

  /* Output HTML leader and prompt */
  {&OUT} p-leader p-prompt {&END}

  /* Output each of the items with delimiters */
  DO ix = 1 TO NUM-ENTRIES(p-list, p-delim):
    /* Sanitize output */
    v-item = html-encode(ENTRY(ix, p-list, p-delim)).

    /* Does the output delimiter contain a <LI> tag? */
    IF p-odelim MATCHES "*<LI*":U THEN
      {&OUT} p-odelim v-item '~n':U {&END}

    /* Only output the delimiter after the first time */
    ELSE DO:
      v-delim = (IF ix = 1 THEN "" ELSE p-odelim).
      {&OUT} v-delim v-item {&END}
    END.
  END.

  /* Output HTML trailer */
  {&OUT} p-trailer "~n" {&END}

END.  /* print-delimited-list */

/* printval.p - end of file */
