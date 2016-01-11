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
  File: propath.w
  
  Description: List the PROPATH of a WebSpeed Agent
  Parameters:  <none>

  Modifications:  Added Search option              nhorn 1/7/97

  Author:  Wm. T. Wood
  Created: Aug. 21, 1996
------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed WorkBench.          */
/*----------------------------------------------------------------------*/


/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
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
  DEFINE VAR i    AS INTEGER NO-UNDO.
  DEFINE VAR cnt  AS INTEGER NO-UNDO.
  DEFINE VAR dir  AS CHAR NO-UNDO.
  DEFINE VAR udir AS CHAR NO-UNDO.
  
  /* 
   * Output the MIME header and set up the object as state-less or state-aware. 
   * This is required if any HTML is to be returned to the browser.
   */   
  RUN outputContentType IN web-utilities-hdl ("text/html":U).
 
  {&OUT} 
    {webtools/html.i
	 &SEGMENTS = "head,open-body,title-line"
	 &AUTHOR = "Wm. T. Wood"
	 &TITLE = "ProPath"
	 &CONTEXT = "{&Webtools_ProPath_Help}" 
	 &FRAME = "ws_main" }

    /* End of Standard Header */
    '<CENTER>~n'
    '<TABLE' get-table-phrase('':U) '>~n'
    '<TR><TH>' format-label('ProPath Directory Entry', "COLUMN":U, "":U) '</TH>~n'
    '    <TH>' format-label('Full Pathname', "COLUMN":U, "":U) '</TH>~n'
    '</TR>~n'
    .
  
  /* Propath. */ 
  cnt = NUM-ENTRIES (PROPATH).
  DO i = 1 TO cnt: 
    ASSIGN dir = ENTRY(i, PROPATH).
    IF dir eq "" THEN ASSIGN dir = ".". /* Current directory. */
    FILE-INFO:FILE-NAME = dir.
    /* URL encode the directory name. */
    RUN UrlEncode IN web-utilities-hdl (INPUT dir, OUTPUT udir,  INPUT "QUERY":U).
    
    {&OUT} 
      '<TR><TD> ' 
      IF dir eq '.':U THEN '<i>Working Directory</i>' ELSE dir 
      ' </TD><TD> '
      IF FILE-INFO:FULL-PATHNAME eq ? 
      THEN '<i>Directory does not exist</i>' 
      ELSE ('<A HREF="dirlist.w?filter=*&directory=' + udir + '">' +
             FILE-INFO:FULL-PATHNAME + '<A>')
      '</TD></TR>~n'. 
 END.
         
  
  {&OUT} 
   '</TABLE>~n'
   '<FORM METHOD = "POST"  ACTION = "search.w" ~n' 
   '      onSubmit="if ((this.FileName.value == ~'~')) ~{ ~n'
   '                   window.alert(~'Please enter a filename.~')~; ~n'
   '                   return false~; ~n'
   '                } "> ~n'
   format-label ('Find File', 'INPUT':U, "":U) 
   '<INPUT TYPE = "TEXT" NAME = "FileName" SIZE = "30">~n'
   '<INPUT TYPE = "SUBMIT" VALUE = "Submit Query">~n<BR>~n'
   '<FONT SIZE="-1">(Type name as it would appear in a SpeedScript <I>RUN</I> statement. '
   'Wildcards are not allowed.)</FONT>~n'
   '</FORM>~n'
   '</CENTER>~n'
   '</BODY>~n'
   '</HTML>~n'.
  
END PROCEDURE.
&ANALYZE-RESUME
 

