&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 WebSpeed-Object
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
 

