&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r12 Web-Object
/* Maps: HTML */
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
  File: help.w
  
  Description: Defines the FRAMESET and BANNER html screens
               used by WebSpeed Workshop Help

  Parameters:  <none>
  
  Fields:
    html: default = FRAMESET
      "Frameset" -- divides the main window into two frames
                    WSHELP_header, WSHELP_main
      "Banner"  -- create the Banner (for the header)
       
  Author:  Wm. T. Wood
  Created: May 17, 1997
------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed Workshop.           */
/*----------------------------------------------------------------------*/


/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Include Files ---                                                    */
{ webutil/wstyle.i }    /* Workshop style definitions and functions.    */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&SCOPED-DEFINE PROCEDURE-TYPE Web-Object


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
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

/* ************************  Main Code Block  *********************** */

/* Check for Development mode. */
{ webutil/devcheck.i }

/* Process the latest WEB event. */
RUN process-web-request.
&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE output-banner 
PROCEDURE output-banner :
/*------------------------------------------------------------------------------
  Purpose:     Output the "Help Banner" html page. This page links to Sample 
               Applications, and Keywork Search.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Output the header and scripts for the Workshop main window. */
  {&OUT}
    { webtools/html.i  &SEGMENTS = "head,open-body"                      
                       &FRAME    = "WSHELP_header" 
                       &TARGET   = "WSHELP_main"
                       &AUTHOR   = "Wm.T.Wood"
                       &TITLE    = "WebSpeed Library"
                       &TARGET   = "WSHELP_header" }
    '<center>~n'
    '<table border="0" cellpadding="0" cellspacing="0">~n'
    '<tr>~n'
    '    <td><A HREF="http://www.webspeed.com" TARGET="devWindow"><img '
    ' src="' RootURL '/doc/library/images/buttons.gif" width="18" height="14" border="0"></A>~n'
    '    <font size="1"><strong>~n'
    '    <A HREF="http://www.webspeed.com" TARGET="devWindow">WebSpeed Home Page</A></strong></font></td>~n'
    '    <td width="12">&nbsp~;</td>~n' 

    '    <td><A HREF="http://developer.webspeed.com" TARGET="devWindow"><img '
    ' src="' RootURL '/doc/library/images/buttons.gif" width="18" height="14" border="0"></A>~n'
    '    <font size="1"><strong>~n'
    '    <A HREF="http://developer.webspeed.com" TARGET="devWindow">Developer Corner</A></strong></font></td>~n'
    '    <td width="12">&nbsp~;</td>~n' 

    '    <td><A HREF="' AppURL '/samples/web/sample.r" TARGET="demoWindow"><img '
    ' src="' RootURL '/doc/library/images/buttons.gif" width="18" height="14" border="0"></A>~n'
    '    <font size="1"><strong>~n'
    '    <A HREF="' AppURL '/samples/web/sample.r" TARGET="demoWindow">Sample Applications</A></strong></font></td>~n'
    '    <td width="12">&nbsp~;</td>~n'
    '</tr>~n'
    '</table>~n'
    '</center>~n'
    '</BODY>~n'
    '</HTML>~n'
    .
  
END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE output-Frameset 
PROCEDURE output-Frameset :
/*------------------------------------------------------------------------------
  Purpose:     Output the "Frameset" html page.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 {&OUT}
   { webtools/html.i  &SEGMENTS = "head"                      
                      &FRAME    = "HelpWindow" 
                      &AUTHOR   = "Wm.T.Wood"
                      &TITLE    = "Library" }
   '<FRAMESET ROWS="28,*">~n'
   '     <FRAME NAME="WSHELP_header" SRC="help.w?html=Banner" SCROLLING=no~n'
   '            FRAMEBORDER=no MARGINHEIGHT=2 MARGINWIDTH=0>~n'
   '     <FRAME NAME="WSHELP_main" SRC="' RootURL '/doc/wshelp/main.htm"~n'
   '            FRAMEBORDER=yes MARGINHEIGHT=3 MARGINWIDTH=3>~n'
   '</FRAMESET>~n'
   '<NOFRAME>~n'
   '<H1>WebSpeed Workshop Help</H1>~n'
   'This page can be displayed with a frame enabled browser.~n'
   '</NOFRAME>~n'
   '</HTML>~n'
   .
  
END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE process-web-request 
PROCEDURE process-web-request :
/*------------------------------------------------------------------------------
  Purpose:     Process the web request.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE c_html AS CHAR NO-UNDO.
  
  /* Output the MIME header and start of page. */
  RUN outputContentType IN web-utilities-hdl ("text/html":U).
 
  /* Determine Context - default is "FRAMESET" */
  RUN GetField IN web-utilities-hdl (INPUT "html":U, OUTPUT c_html).
  IF c_html eq "":U THEN c_html = "Frameset":U.
  
  CASE c_html:
    WHEN "Frameset":U THEN RUN output-Frameset IN THIS-PROCEDURE.
    WHEN "Banner":U   THEN RUN output-Banner IN THIS-PROCEDURE.
    OTHERWISE
      RUN htmlError IN web-utilities-hdl ('Invalid HTML page requested:' + c_html).
  END CASE.
  
END PROCEDURE.
&ANALYZE-RESUME
 


