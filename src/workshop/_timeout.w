&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 WebSpeed-Object
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM Definitions 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
  File: _timeout.w
  
  Description: Displays the message received on a WebSpeed Timeout.

  Input Parameters:   
    <none>
  Output Parameters:  
    <none>
     
  Fields:
    <none>

  Author:  Wm. T. Wood
  Created: Feb. 6, 1997
------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed Workshop.           */
/*----------------------------------------------------------------------*/


/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Included Definitions ---                                             */
{ webutil/wstyle.i }        /* Standard style definitions.    */

/* Local Variable Definitions ---                                       */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WebSpeed-Object


&ANALYZE-RESUME


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _INCLUDED-LIBRARIES
/* ************************* Included-Libraries *********************** */

{ src/web/method/wrap-cgi.i }
&ANALYZE-RESUME _END-INCLUDED-LIBRARIES

&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM "Main Code Block" 


/* ********************** Main Code Block *********************** */    

/* Generate the header and timeout message. */
RUN outputContentType IN web-utilities-hdl ("text/html":U).
{&OUT} 
  { workshop/html.i &SEGMENTS = "head,open-body"
                    &FRAME    = "WS_main" 
                    &AUTHOR   = "Wm.T.Wood"
                    &TITLE    = "Workshop Timed Out" 
                    &TARGET   = "_top" }
  '<p>The transaction agent servicing your~n'
  '<B><FONT COLOR="RED">Web</FONT>Speed</B>~n'
  'Workshop has timed out.~n'
  'All changes that were not saved have been lost.</p>~n'
  '<p>Click <A HREF="' AppURL '/workshop?timeoutAt=' TIME '">here</A>~n'
  'to restart Workshop.</p>~n'
  '</BODY>~n'
  '</HTML>~n'
  .
&ANALYZE-RESUME
 

