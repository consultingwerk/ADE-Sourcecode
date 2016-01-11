&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 Procedure
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
**********************************************************************

  File: _promsgs.w

  Description: Numbered message API that uses the PROMSGS message files.

  Input Parameters:
      p_msg-num  - Number (integer)
      p_options  - Options.  Currently two options are supported:
                     - message type is one of either 
                         error
                         information
                         message (default)
                         question or 
                         warning
                     - output type of one of either 
                         out     (output to the webstream and return as well)
                         no-html (just return; no HTML formatting or HREFS)
      p_val-lst  - Keyword substitution name=value pair list. Each pair is
                   separated with CHR(10) or '~n'. Some mesages may contain
                   "<>" delimited keywords that need run time substitution.
                   For example

              Database killed by <user> on <tty-name>.(2250)

                   contains two keyword phrases "user" and "tty-name".
                   Assuming the values for these phrases are "adams" and
                   "/dev/pts/5", respectively, p_val-lst would be 

              "user=adams~ntty-name=~/dev~/pts~/5"

  Output Parameters:
      p_result   - Error message, currently unused.

  Author: D.M.Adams

  Created: 1/16/97

------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed WorkBench.          */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER p_msg-num  AS INTEGER   NO-UNDO.
DEFINE INPUT  PARAMETER p_options  AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER p_val-lst  AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER p_result   AS CHARACTER NO-UNDO.

/* Local Variable Definitions ---                                       */
{prohelp/msgs.i}

&ANALYZE-RESUME
&ANALYZE-SUSPEND _PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure


&ANALYZE-RESUME


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _INCLUDED-LIBRARIES
/* ************************* Included-Libraries *********************** */

{src/web/method/wrap-cgi.i}
{src/web/method/cgidefs.i}

&ANALYZE-RESUME _END-INCLUDED-LIBRARIES

&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM "Main Code Block" 


/* ************************  Main Code Block  *********************** */

/* Process the latest WEB event. */
RUN process-web-request.

&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE process-web-request 
PROCEDURE process-web-request :
/*------------------------------------------------------------------------------
  Purpose:     Process the web request.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE c-scrap  AS CHARACTER NO-UNDO. /* scrap */
  DEFINE VARIABLE ix       AS INTEGER   NO-UNDO. /* scrap */
  DEFINE VARIABLE msg-hdr  AS CHARACTER NO-UNDO.  
  DEFINE VARIABLE msg-text AS CHARACTER NO-UNDO.  
  DEFINE VARIABLE msg-type AS CHARACTER NO-UNDO.  
  DEFINE VARIABLE val-item AS CHARACTER NO-UNDO.  
  
  RUN outputContentType IN web-utilities-hdl ("text/html":U).

  RUN GetMessageDescription (p_msg-num, OUTPUT msg-text).
  IF msg-text EQ ? OR msg-text EQ "?":U OR msg-text EQ "":U THEN
    msg-text = "No information is available for WebSpeed message " 
             + STRING(p_msg-num) + ".":U.
  ELSE DO:
    ASSIGN 
      msg-text = ENTRY(1,msg-text,CHR(10)) /* keep first line */
      msg-type = ENTRY(1,p_options).

    IF p_val-lst <> "" THEN DO:
      DO ix = 1 TO NUM-ENTRIES(p_val-lst,CHR(10)):
        ASSIGN
          val-item = ENTRY(ix,p_val-lst,CHR(10))
          msg-text  = REPLACE(msg-text,"<":U + ENTRY(1,val-item,"=":U) + ">":U,
                             ENTRY(2,val-item,"=":U)).
      END.
    END.

    RUN AsciiToHtml IN web-utilities-hdl (msg-text, OUTPUT msg-text).

    msg-text  = SUBSTRING(msg-text,1,R-INDEX(msg-text,"(":U) - 1,"CHARACTER":U)
              + '<A HREF="':U + AppURL
              + '/webtools/promsgs.w?PRO_message_number=':U + STRING(p_msg-num) 
              + '" TARGET="WS_error_window">':U
              + SUBSTRING(msg-text,R-INDEX(msg-text,"(":U),-1,"CHARACTER":U) 
              + '</A>':U.
  END.

  IF msg-type BEGINS "err":U THEN
    ASSIGN msg-type = "error":U msg-hdr = "ERROR".
  ELSE IF msg-type BEGINS "inf":U THEN
    ASSIGN msg-type = "inform":U msg-hdr = "INFORMATION".
  ELSE IF msg-type BEGINS "que":U THEN
    ASSIGN msg-type = "question":U msg-hdr = "QUESTION".
  ELSE IF msg-type BEGINS "war":U THEN
    ASSIGN msg-type = "warning":U msg-hdr = "WARNING".
  ELSE
    ASSIGN msg-type = "":U msg-hdr = "MESSAGE".

  IF ENTRY(2,p_options) = "out":U THEN DO:
    IF msg-type <> "" THEN
      {&OUT} '<IMG SRC="' RootURL '/images/':U msg-type '.gif" BORDER="0"> ':U.

    {&OUT}
      '<B>':U msg-hdr ':</B>':U 
      '<HR>':U msg-text SKIP
      '</BODY>':U SKIP
      '</HTML>':U.
  END.

  RETURN msg-text.

END PROCEDURE.

&ANALYZE-RESUME
 

