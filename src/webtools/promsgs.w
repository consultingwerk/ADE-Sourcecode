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
  File: promsgs.w
  
  Description: Shows the full text of Progress messages.
  Parameters:  <none>
  
  Fields: This checks for "PRO_message_number" as a CGI field.  If this 
          exists, then this message is displayed.  This can therefore
          be called from another URL as:
             URL: .../webtools/promsgs.w?PRO_message_number=1234
          
  Other Fields:
          form -- if NO then no Query form will be added to the top
                  of the page allowing the user to look for another error.
                  (default is form = yes)
          KBase -- provide a submit button to check the Progress on-line
                  Knowledge base for comments related to this topic.
                  (default is KBase = yes)

  Author:  Wm. T. Wood
  Created: 08/26/96
  Updated: 08/22/00 adams Updated Knowledge Base URL
------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed Workshop.           */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Include the standard files needed to process messages. */
{ prohelp/msgs.i }

/* Define the location of the KBASE web page. */
&Scoped-define KBaseURL http://www.progress.com/services/support/cgi-bin/~
techweb-kbase.cgi/webkb.html?TAB=querye&verrnum=
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
  DEFINE VARIABLE c_field        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE description    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE imsg           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lngth          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE message_number AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lForm          AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lKBase         AS LOGICAL   NO-UNDO.
  
  /* What is the context of this request?  Look at "Message-Number". */
  RUN GetField IN web-utilities-hdl ('PRO_message_number':U, OUTPUT message_number).

  /* Should the <FORM> be returned that allows the user to enter a new number.
     (Default is YES). */
  RUN GetField IN web-utilities-hdl ('form':U, OUTPUT c_field).
  lForm = (c_field ne "no":U).
  
  /* Should there be access into the PROGRESS Kbase. */
  RUN GetField IN web-utilities-hdl ('KBase':U, OUTPUT c_field).
  lKBase = (c_field NE "no":U).
  
  /* Output the MIME header and create the HTML form. */
  RUN outputContentType IN web-utilities-hdl ("text/html":U).  
  
  {&OUT}
    {webtools/html.i
         &SEGMENTS = "head,open-body,title-line"
         &AUTHOR   = "Wm.T.Wood"
         &TITLE    = "Messages"
         &FRAME    = "WS_main"
         &CONTEXT  = "{&Webtools_Messages_Help}" }
         .

  /* Output a FORM to allow the user to enter another message. */
  IF lForm THEN 
  {&OUT}
    '<FORM METHOD="POST" ACTION="promsgs.w" >~n':U
    '<CENTER>~n':U
    format-label ("Enter Message Number", "INPUT":U, "":U)
    '<INPUT TYPE="TEXT" NAME="PRO_message_number"':U
    (IF message_number ne "" 
     THEN ' VALUE="' + message_number + '">~n':U
     ELSE '>~n':U)
    '<INPUT TYPE="SUBMIT" VALUE="View Message">~n':U
    '</CENTER>~n':U
    '</FORM>~n':U
    .
  
  /* Is the number a valid integer? */
  IF message_number ne "" THEN DO:
    ASSIGN imsg = INTEGER(message_number) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
      {&OUT}
        '<B>Error:</B><HR> Message Number must be a valid integer.~n'.
    END.
    ELSE DO:
      /* Get the description. */
      RUN GetMessageDescription (imsg, OUTPUT description).
      
      IF description eq ? OR description eq "?":U OR description eq "":U THEN
        ASSIGN
          lKBase      = FALSE
          description = "No information is available for this WebSpeed message.".
      
      /* Does the description end with "Syntax" if so, delete this. */
      lngth = LENGTH(description, "CHARACTER":U).
      IF R-INDEX(description, "Syntax") > lngth - 6 THEN
        description = SUBSTRING(description, 1, lngth - 6, "CHARACTER":U).
      description = TRIM(description).
      
      /* Make sure the ASCI characters are displayed correctly. */
      RUN AsciiToHtml IN web-utilities-hdl (description, OUTPUT description).
      
      /* Show the message. */
       {&OUT}
        '<B>Message Description:</B><HR>~n<UL>'
        REPLACE(description,CHR(10),"<BR>":U)
        '</UL>':U
        .
    
      /* See if the user wants to look up more information in the progress 
         kbase for valid error numbers. */
      IF lKBase THEN DO:
        {&OUT}
          '<HR><CENTER>~n':U
          '<FORM NAME="KBASE" METHOD="POST"~n':U
          '      ACTION="{&KBaseURL}' message_number '">~n':U
          '<INPUT TYPE="SUBMIT" VALUE="Query Knowledge Base for ':U
          'Error ' message_number '">~n':U
          '<INPUT TYPE="HIDDEN" NAME="PrimaryTopic"   VALUE = "ERRORS">~n':U
          '<INPUT TYPE="HIDDEN" NAME="CType"          VALUE = "PROGRESS">~n':U
          '<INPUT TYPE="HIDDEN" NAME="SecondaryTopic" VALUE = "':U
          message_number '">~n':U
          '</FORM></CENTER>':U
          .
       END. /* IF l_kbase... */
     END. /* IF INTEGER(message_number) is not an error... */
   END. /* IF message_number ne ""... */
  
  /* Output your custom HTML to WEBSTREAM here [using the {&OUT} preprocessor]. */
  
  {&OUT}
    '</BODY>~n
     </HTML>':U
     .
  
END PROCEDURE.
&ANALYZE-RESUME
 
