&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 Web-Object
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM Definitions 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
  File: workshop.w
  
  Description: Defines the FRAMESET and MAIN MENU html screens
               used by WebSpeed Workshop

  Parameters:  <none>
  
  Fields:
    html: default = FRAMESET
      "Frameset" -- divides the main window into three frames
                    WS_header, WS_index, WS_main
      "MainMenu"  -- create the main menu (for the header)
       
  Author:  Wm. T. Wood
  Created: Dec. 9, 1996
  Modified:
    2/17/98 (wood) Update for v9.0 -- only show WebTools
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

&Scoped-define PROCEDURE-TYPE Web-Object


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

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE output-Frameset 
PROCEDURE output-frameset :
/*------------------------------------------------------------------------------
  Purpose:     Output the "Frameset" html page.
  Parameters:  <none>
  Notes:       The use of get-location for the Welcome.html is really 
               not necessary as the file is not static anymore. 
               It was kept like this for backwards compatiblility with 
               potential overrides. (Somewhat inconsistent as  
               webspeed/scripts/editor.js don't use get-location when it 
               shows the welcome on close of the editor)
------------------------------------------------------------------------------*/
 {&OUT}
   { workshop/html.i  &SEGMENTS = "head"                      
                      &FRAME    = "WS_header" 
                      &AUTHOR   = "Wm.T.Wood"
                      &TITLE    = "WebTools" }
   '<FRAMESET COLS="152,*">~n'
   '     <FRAMESET ROWS="64,*">~n'
   '          <FRAME NAME="WS_header" SRC="workshop.w?html=MainMenu" SCROLLING=no~n'
   '                 FRAMEBORDER=yes MARGINHEIGHT=0 MARGINWIDTH=0>~n'
   '          <FRAME NAME="WS_index" SRC="webtools/index.w"~n'
   '                 FRAMEBORDER=yes MARGINHEIGHT=3 MARGINWIDTH=3>~n'
   '     </FRAMESET>~n'
   '     <FRAME NAME="WS_main" SRC="' get-location("Welcome":U) '"~n'
   '            FRAMEBORDER=yes MARGINHEIGHT=5 MARGINWIDTH=10>~n'
   '</FRAMESET>~n'
   '<NOFRAME>~n'
   '<H1>WebSpeed Workshop</H1>~n'
   'This page can be displayed with a frame enabled browser.~n'
   '</NOFRAME>~n'
   '</HTML>~n'
   .
  
END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE output-mainmenu 
PROCEDURE output-mainmenu :
/*------------------------------------------------------------------------------
  Purpose:     Output the "mainmenu" html page.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Output the header and scripts for the Workshop main window. */
  {&OUT}
    { workshop/html.i  &SEGMENTS = "head"                      
                       &FRAME    = "WS_header" 
                       &AUTHOR   = "Wm.T.Wood"
                       &TITLE    = "WebTools"
                       &TARGET   = "WS_index" }
    { workshop/html.i &SEGMENTS = "open-body"
                      &FRAME    = "WS_header" }
    /* WebSpeed WebTools name. */
    '<IMG SRC="' RootURL '/workshop/webspeed.gif" ALT="WebSpeed" HEIGHT=27 WIDTH=112><BR>~n'
    '<IMG SRC="' RootURL '/workshop/webtools.gif" ALT="WebTools" HEIGHT=20 WIDTH=88>~n'
    '</BODY>~n'
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
    WHEN "MainMenu":U THEN RUN output-MainMenu IN THIS-PROCEDURE.
    OTHERWISE
      RUN htmlError IN web-utilities-hdl ('Invalid HTML page requested:' + c_html).
  END CASE.
  
END PROCEDURE.
&ANALYZE-RESUME
 

