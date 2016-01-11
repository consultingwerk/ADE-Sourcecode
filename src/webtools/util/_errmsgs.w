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
*********************************************************************/
/*------------------------------------------------------------------------

  File: _errmsgs.w

  Description: Checks the COMPILER handle for error messages and reports
               these as errors.
               
  Input Parameters:
      p_Comp_File: [CHAR] The name of the compiled file (this is stripped out
                  of error messages because it is usually a temporary file name.
      p_options:   [CHAR] List of options supported
                  COMPACT -- Avoid using headings (e.g. "RESULTS:<HR>") because
                             the space is limited. 
                  NO-HTML -- Don't return HTML, only error text.
                  LINE-NUMBERS -- show errors with line numbers.
     
  Output Parameters:
     <none>

  Author: Wm. T. Wood

  Created: October 30, 1996

------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed WorkBench.          */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p_Comp_File  AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER p_options    AS CHARACTER  NO-UNDO.

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

&ANALYZE-RESUME _END-INCLUDED-LIBRARIES

&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM "Main Code Block" 


/* ************************ Local Definitions ********************** */
DEFINE VARIABLE cEOL        AS CHARACTER NO-UNDO. /* Editor end-of-line */
DEFINE VARIABLE cErrorNum   AS CHARACTER NO-UNDO.
DEFINE VARIABLE curMsg      AS CHARACTER NO-UNDO.
DEFINE VARIABLE errorMsg    AS CHARACTER NO-UNDO.
DEFINE VARIABLE errorNum    AS INTEGER   NO-UNDO.
DEFINE VARIABLE errorFile   AS CHARACTER NO-UNDO.
DEFINE VARIABLE lCompact    AS LOGICAL   NO-UNDO.  /* Use compact style */
DEFINE VARIABLE lEditor     AS LOGICAL   NO-UNDO.  /* Called by Editor */
DEFINE VARIABLE lLineNums   AS LOGICAL   NO-UNDO.  /* Show line-numbers */
DEFINE VARIABLE lTextOnly   AS LOGICAL   NO-UNDO.  /* Return text only */
DEFINE VARIABLE numMessages AS CHARACTER NO-UNDO.

/* PROGRESS Preprocessor system message number. */
&SCOPED-DEFINE PP-4345      4345    

/* PROGRESS 4GL Compiler Messages that contain line numbers. 
   I found these by searching the files in DLC\prohelp\msgdata
   for "line <number>". There are more, but we only want to exclude
   the ones that just mention "Could not understand Line <number>."
*/
&SCOPED-DEFINE CM-LINE      "193,196,198"



/* ************************  Main Code Block  *********************** */
/* Check special options.  */
ASSIGN 
  lCompact  = CAN-DO(p_options,"COMPACT":U)
  lEditor   = CAN-DO(p_options,"EDITOR":U)
  lTextOnly = CAN-DO(p_options,"NO-HTML":U)
  lLineNums = CAN-DO(p_options,"LINE-NUMBERS":U)
  .  

DO ON STOP UNDO, LEAVE:
  /* Display compiler messages. */
  DO errorNum = 1 TO ERROR-STATUS:NUM-MESSAGES:
     
    /* Skip over line-numbers errors. */
    IF lLineNums eq no AND
       CAN-DO( {&CM-LINE}, STRING(ERROR-STATUS:GET-NUMBER( errorNum )) )
    THEN NEXT.
    
    /* If the current message is not a PROGRESS Preprocessor message,
       remove the tempfile name. Otherwise, leave it, because the user
       may be trying to display the file name during preprocessing
       using {&FILE-NAME}.
    */
    ASSIGN 
      curMsg = ERROR-STATUS:GET-MESSAGE( errorNum )
      cEOL   = (IF errorNum < ERROR-STATUS:NUM-MESSAGES THEN "\n' + '":U ELSE "").
      
    IF ERROR-STATUS:GET-NUMBER( errorNum ) <> {&PP-4345} THEN
      ASSIGN curMsg = REPLACE( curMsg , p_Comp_File , "" ) .
    
    /* This message will be output as HTML. */
    IF lTextOnly THEN
      ASSIGN errorMsg = errorMsg + curMsg + (IF lEditor THEN cEOL ELSE CHR(10)).
    ELSE DO:
      RUN AsciiToHtml IN web-utilities-hdl (curMsg, OUTPUT curMsg).
    
      /* If the message ends with a (<error-num>), then link to progress errors. */
      cErrorNum = TRIM(STRING(ERROR-STATUS:GET-NUMBER( errorNum ), ">>>>>9":U)).
      IF INDEX(curMsg, "(":U + cErrorNum + ")":U) > 0 THEN 
        curMsg = REPLACE (curMsg,
                   "(":U + cErrorNum + ")":U,
                   '<A HREF = "' + AppURL + '/webtools/promsgs.w?PRO_message_number=' 
                                 + cErrorNum
                                 + (IF lCompact THEN "&form=no" ELSE "")
                                 + '">' +
                   "(":U + cErrorNum + ")</A>":U).
      ASSIGN errorMsg = errorMsg + "<P>":U + curMsg + "</P>~r~n":U.
    END.
  END.
      
  IF errorMsg <> "" THEN DO:
    IF NOT lCompact AND NOT lTextOnly THEN 
      {&OUT} '<B>Compiler Errors:</B><HR>'. 
    {&OUT} errorMsg.
  END.
      
END. /* DO ON STOP */

&ANALYZE-RESUME
