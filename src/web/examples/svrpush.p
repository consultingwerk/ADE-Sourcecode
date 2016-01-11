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
  svrpush.p
  
  This program demonstrates how to use server push with WebSpeed. Several 
  customer records are output one at a time with a pause between each record.  
 
  For this program to work, there must be a way of sending output to the web 
  server without it buffing any output destined for the browser.  On most 
  Unix web servers, this can be done with the No-Parse-Headers (NPH) mode.  
  With most Windows web servers, just starting any output with "HTTP" causes 
  the web server to switch to this mode.  Please consult the documentation 
  for your web server software for information on this mode.

  Note: This program has been tested with the cgiip messenger only.
 
  Configuring for Unix:
    Make a symbolic link from a working cgiip Messenger script to one with 
    the same name but with an "nph-" prefix.  For instance:
      ls -s wspd_cgi.sh nph-wspd_cgi.sh
    Use the nph- version of your messenger script to access this program.
 
  Configuring for Windows NT:
    This depends entirely on the web server.  Try running the program as is.
*/

{src/web/method/cgidefs.i}

DEFINE VARIABLE ix            AS INTEGER    NO-UNDO.
DEFINE VARIABLE mime-boundary AS CHARACTER  NO-UNDO INITIAL "BoUnDarYtExT".

/* Make sure DISPLAY doesn't output any HTML tags itself. */
ASSIGN
  WEB-CONTEXT:HTML-END-OF-PAGE  = ""
  WEB-CONTEXT:HTML-FRAME-BEGIN  = ""
  WEB-CONTEXT:HTML-FRAME-END    = ""
  WEB-CONTEXT:HTML-HEADER-BEGIN = ""
  WEB-CONTEXT:HTML-HEADER-END   = "".

/* Output start of HTTP protocol because this must be done with
   No-Parsed-Headers mode. */
output-http-header("", "HTTP/1.0 200 OK":U).
output-http-header("Server":U, SERVER_NAME).

/* Output the initial MIME content type indicating the use of server push. */
output-content-type("multipart/x-mixed-replace~; boundary=" + mime-boundary).

FOR EACH customer NO-LOCK ix = 1 TO 5:
  /* Output the multipart boundary followed by the Content Type and a blank 
     line for the following text.  The output-content-type() function can't 
     be used because it only outputs something the first time called for each 
     web request. */
  {&OUT} 
    '--':U mime-boundary SKIP
    'Content-Type: text/plain':U SKIP(2).

  /* Simple way to display a customer record. */
  DISPLAY {&WEBSTREAM} customer WITH 1 COLUMN WIDTH 255.
  {&OUT} '~n':U.

  /* Flush the web stream which should force previous output to show up
     on the browser. */
  PUT {&WEBSTREAM} CONTROL NULL(0).
  PAUSE 4.
END.

/* Output final boundary indicating the end of multipart output */
{&OUT} SKIP  /* force newline if not at start of line */
  '--' mime-boundary '--' SKIP.

/* svrpush.p - end of file */
