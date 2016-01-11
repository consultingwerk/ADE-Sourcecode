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
  File: workshop/_content.w
  
  Description: Defines the FRAMESET for the File Contents.  The left frame
               is the WSFC_index (and contains an index of contents).
               The right frame is WSFC_main and contains information about
               the selected object in the index.

  Parameters:  
    p_id -- context id of the current open file
    p_options - comma delimited list of options [currently unused]

     
  Author:  Wm. T. Wood
  Created: Jan. 9, 1996
------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed Workshop.           */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p_id      AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER p_options AS CHAR    NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Included Definitions ---                                             */
{webutil/wstyle.i}        /* Standard design definitions.   */
{workshop/objects.i}      /* Shared web-object temp-tables. */

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


/* ********************  Additional Definitions  ******************** */

DEFINE VARIABLE c_directory  AS CHAR    NO-UNDO.
DEFINE VARIABLE c_filename   AS CHAR    NO-UNDO.
DEFINE VARIABLE c_file-id    AS CHAR    NO-UNDO.

/* ************************  Main Code Block  *********************** */
  
/* Output the MIME header and start of page. */
RUN outputContentType IN web-utilities-hdl ("text/html":U).

/* Find the current _P record. */
FIND _P WHERE RECID(_P) eq p_id NO-ERROR.
    
/* Make sure file is specified. */
IF NOT AVAILABLE (_P) THEN DO:
  RUN HtmlError IN web-utilities-hdl 
         (SUBSTITUTE ('File id &1 not valid.', p_id)).
  RETURN.
END.

/* Show the frameset. */
RUN output-Frameset IN THIS-PROCEDURE.

&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE output-Frameset 
PROCEDURE output-frameset :
/*------------------------------------------------------------------------------
  Purpose:     Output the "Frameset" html page.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 {&OUT}
    { workshop/html.i &SEGMENTS = "head"
                      &FRAME    = "WS_main" 
                      &AUTHOR   = "Wm.T.Wood"
                      &TITLE    = "File Contents"  }
   '<FRAMESET COLS="196,*">~n'
   '    <FRAME NAME="WSFC_index"~n'
   '           SRC="_main.w?html=fileAction&amp~;list=yes&amp~;file-id=' RECID(_P) '"~n'
   '           FRAMEBORDER=no MARGINHEIGHT = 3 MARGINWIDTH = 5>~n'
   '    <FRAME NAME="WSFC_main"~n'
   '           SRC="' get-location ("blank") '"~n'
   /* '           SRC="_main.w?html=fileAction&viewFile=yes&filename=' url_file 
    *              '&directory=' url_dir '"~n' */
   '           FRAMEBORDER=yes MARGINHEIGHT=3 MARGINWIDTH=5>~n'
   '</FRAMESET>~n'
   '<NOFRAME>~n'
   '<H1>WebSpeed Workshop</H1>~n'
   'This page can be displayed with a frame enabled browser.~n'
   '</NOFRAME>~n'
   '</HTML>~n'
   .

  
END PROCEDURE.

&ANALYZE-RESUME
 

