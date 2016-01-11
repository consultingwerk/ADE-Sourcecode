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
  Web Object: index.w
  
  Description: Index of "WebTools" for the Index List Frame in WebTools.
  Parameters:  <none>
  
  Fields:
    <none>
  
  Author:  Wm. T. Wood
  Created: Aug. 21, 1996
  
  Modified: 
    2/17/98 (wood) remove About" options
------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed WorkBench.          */
/*----------------------------------------------------------------------*/


/* ***************************  Definitions  ************************** */

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
  DEFINE VAR c_title   AS CHAR NO-UNDO INITIAL "Tools":U.
  DEFINE VAR dataFile  AS CHAR NO-UNDO INITIAL "webtools/webtools.dat":U.
  DEFINE VAR aboutFile AS CHAR NO-UNDO INITIAL "webtools/webabout.dat":U.
  
  /* Output the MIME header and start of page. */
  RUN outputContentType IN web-utilities-hdl ("text/html":U).

  {&OUT} {webtools/html.i 
	    &SEGMENTS = "head,open-body"
	    &TITLE    = "' c_title '" 
          &TARGET   = "WS_main"
	    &FRAME    = "WS_index" }  .

  
  /* Look for a WebTools index file.  If it exists, then just dump it into
     the output stream.  Otherwise, put up a default set. */ 
  IF SEARCH(dataFile) ne ? 
  THEN RUN webtools/util/_putfile.w (datafile, ?, "No-Head":U).
  ELSE DO:
    /* Output a simple set of information. */
    {&OUT}
    '<H3>Scripting:</H3>~n'
    '<A HREF="edtscrpt.w">Script Editor</A><br>~n'    
    '<H3>Information:</H3>~n'
    '<A HREF="http://webspeed.progress.com">WebSpeed Home Page</A><br>~n'
    .
  END.

  /* Add the copyright and help links. */
  IF SEARCH(aboutFile) ne ? 
  THEN RUN webtools/util/_putfile.w (aboutFile, ?, "No-Head":U).

  /* Reset the links to the current window if not WS_main is not a sibling. */
  {&OUT}
    '<SCRIPT LANGUAGE="JavaScript">~n'
    '  <!-- // Reset the links to this window if WS_main is not a sibling frame.~n'
    '  if (parent.WS_main == null) ~{~n'                
    '    for (var iLink = 0~; iLink < document.links.length~; iLink++) ~{~n'
    '      if (document.links[iLink].target == "WS_main") ~{~n'
    '        document.links[iLink].target = "_self"~;~n'
    '      ~}~n'     
    '    }~n'
    '  }~n'
    '  //-->~n'
    '</script>~n'
    .

  /* Finish the document. */ 
  {&OUT}
    '</BODY>~n'
    '</HTML>~n'
    .
  
END PROCEDURE.
&ANALYZE-RESUME
 

