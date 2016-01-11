&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 Web-Object
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
  File: _fileset.w
  
  Description: Defines the FRAMESET and MENU html screens
               used by the "File Info" or "Procedure Settings"
  Parameters:  
    p_fileqs:    the query string to pass to the file location.  
                 This is either --- NOTE that this needs to be
                 URL encoded in advance.
                   "file-id=<context-string>" 
                 or 
                   "filename=<name>&directory=<dir>"
    p_options:   Comma delimited list of options [currently unused]

  Note:
    The actual file menu is drawn by the workshop/_file.w.
     
  Author:  Wm. T. Wood
  Created: Jan. 19, 1996
------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed Workshop.           */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p_fileqs   AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER p_options  AS CHAR NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Included Definitions ---                                             */
{webutil/wstyle.i}        /* Standard design definitions.   */

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
  
/* Output the MIME header and start of page. */
RUN outputContentType IN web-utilities-hdl ("text/html":U).
/* Output the frameset. */
{&OUT}
  { workshop/html.i &SEGMENTS = "head"
                    &FRAME    = "WS_main" 
                    &AUTHOR   = "Wm.T.Wood"
                    &TITLE    = "File Information"  }
  '<FRAMESET ROWS="72,*">~n'
  '    <FRAME NAME="WSFI_header"~n'
  '           SRC="' AppURL '/workshop/_main.w'
  '?html=mainFile~&' p_fileqs '"~n'
  '           FRAMEBORDER=no MARGINHEIGHT = 3 MARGINWIDTH = 5>~n'
  '    <FRAME NAME="WSFI_main"~n'
  '           SRC="' get-location ("blank") '"~n'
  '           FRAMEBORDER=yes MARGINHEIGHT=3 MARGINWIDTH=5>~n'
  '</FRAMESET>~n'
  '<NOFRAME>~n'
  '<H1>WebSpeed Workshop</H1>~n'
  'This page can be displayed with a frame enabled browser.~n'
  '</NOFRAME>~n'
  '</HTML>~n'
  .

&ANALYZE-RESUME
 

