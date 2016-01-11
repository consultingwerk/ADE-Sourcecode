&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r12 WebTool
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
  File: session.w
  
  Description: List the Global WebSpeed session variables defined in 
               cgi-defs.i and in the Session

  Modifications: Cleaned up HTML.                    nhorn 1/8/97
                 Add Web Context Variables           nhorn 1/22/97
                 Added NUMERIC-DECIMAL-POINT and     tsm   5/25/99
                 NUMERIC-SEPARATOR session 
                 attributes for v9.1   
                 Added CONTEXT-HELP-FILE session     tsm   6/11/99
                 attribute for v9.1                                               

  Parameters:  <none>

  Author:  Wm. T. Wood
  Created: Sept. 9, 1996
------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed Workshop.           */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Local Variable Definitions ---                                       */

/* Temp table to hold a list of items to be displayed. */
DEFINE TEMP-TABLE tt NO-UNDO
  FIELD lbl AS CHAR
  FIELD val AS CHAR
  INDEX lbl IS PRIMARY lbl
  .
&ANALYZE-RESUME
&ANALYZE-SUSPEND _PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&SCOPED-DEFINE PROCEDURE-TYPE WebTool


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
/* Standard WebTool Included Libraries --  */
{ webtools/webtool.i }

/* Needed to check CGI Variables List --   */
{ src/web/method/cgiarray.i }
&ANALYZE-RESUME _END-INCLUDED-LIBRARIES

&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM "Main Code Block" 

/* ************************  Main Code Block  *********************** */

/* Process the latest WEB event. */
RUN process-web-request.
&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE create-CGI-list 
PROCEDURE create-CGI-list :
/*------------------------------------------------------------------------------
  Purpose:     Creates a list of raw CGI variables.  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE ch      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cnt     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE ix      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE ipos    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE tmp-lbl AS CHARACTER NO-UNDO.
  DEFINE VARIABLE tmp-var AS CHARACTER NO-UNDO.
  DEFINE VARIABLE asc-del AS CHARACTER NO-UNDO INITIAL "~377":U.
  
  /* Add all the CGI variables to the list. NOTE: the last entry has a CHR(255) 
     (a.k.a. hex "~377") after it so the cnt is inflated by one. */
  ASSIGN
    cnt     = NUM-ENTRIES(WEB-CONTEXT:CURRENT-ENVIRONMENT, asc-del).
  /* Check that the last entry is valid. */
  DO WHILE cnt > 0 AND 
    TRIM(ENTRY(cnt, WEB-CONTEXT:CURRENT-ENVIRONMENT, asc-del)) eq "":U :
    cnt = cnt - 1.
  END.

  /* Now get all the real values. Ignore empty values. */
  DO ix = 1 TO cnt:
    ch = ENTRY(ix,WEB-CONTEXT:CURRENT-ENVIRONMENT, asc-del).
    IF ch ne "":U THEN DO:
      ASSIGN
        ipos    = INDEX(ch, "=":U)
        tmp-lbl = (IF ipos eq 0 THEN ch ELSE 
                  SUBSTRING(ch, 1, ipos - 1, "CHARACTER":U))
        tmp-var = (IF ipos eq 0 THEN "" ELSE 
                  SUBSTRING(ch, ipos + 1, - 1, "CHARACTER":U)).
        
      /* Divide this into label = value pairs. */
      CREATE tt.
      ASSIGN 
        tt.lbl = tmp-lbl
        tt.val = tmp-var.
    END. /* IF ch ne ""... */
  END. /* DO ix = 1 to cnt:... */
       
  /* Make sure that all standard CGI variables are listed, even if they have no 
     values (bug #97-03-27-047). Also add "*" to the name in order to identify these
     as standard names. */
  cnt = NUM-ENTRIES(CgiVarList).
  DO ix = 1 TO cnt:
    ch = ENTRY(ix, CgiVarList).
    FIND FIRST tt WHERE tt.lbl = ch NO-ERROR.
    IF NOT AVAILABLE tt THEN 
      CREATE tt.
    tt.lbl = ch + "<SUP>*</SUP>":U.
  END.
  
END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE create-session-list 
PROCEDURE create-session-list :
/*------------------------------------------------------------------------------
  Purpose    : Create the list of PROGRESS SESSION variables.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE fproc  AS HANDLE NO-UNDO.
  DEFINE VARIABLE lproc  AS HANDLE NO-UNDO.
  
  ASSIGN fproc  = SESSION:FIRST-PROCEDURE
         lproc  = SESSION:LAST-PROCEDURE.
         
  CREATE tt. ASSIGN tt.lbl = "APPL-ALERT-BOXES"
                    tt.val = STRING(SESSION:APPL-ALERT-BOXES).
  CREATE tt. ASSIGN tt.lbl = "BATCH-MODE"
                    tt.val = STRING(SESSION:BATCH-MODE).
  CREATE tt. ASSIGN tt.lbl = "CHARSET"
                    tt.val = SESSION:CHARSET.
  CREATE tt. ASSIGN tt.lbl = "CONTEXT-HELP-FILE"
                    tt.val = (IF SESSION:CONTEXT-HELP-FILE NE ? THEN SESSION:CONTEXT-HELP-FILE ELSE "?").
  CREATE tt. ASSIGN tt.lbl = "CPCASE"
                    tt.val = (IF SESSION:CPCASE NE ? THEN SESSION:CPCASE ELSE "?"). 
  CREATE tt. ASSIGN tt.lbl = "CPCOLL"
                    tt.val = (IF SESSION:CPCOLL NE ? THEN SESSION:CPCOLL ELSE "?").
  CREATE tt. ASSIGN tt.lbl = "CPINTERNAL"
                    tt.val = (IF SESSION:CPINTERNAL NE ? THEN SESSION:CPINTERNAL ELSE "?").
  CREATE tt. ASSIGN tt.lbl = "CPLOG"
                    tt.val = (IF SESSION:CPLOG NE ? THEN SESSION:CPLOG ELSE "?") .
  CREATE tt. ASSIGN tt.lbl = "CPPRINT"
                    tt.val = (IF SESSION:CPPRINT NE ? THEN SESSION:CPPRINT ELSE "?").
  CREATE tt. ASSIGN tt.lbl = "CPRCODEIN"
                    tt.val = (IF SESSION:CPRCODEIN NE ? THEN SESSION:CPRCODEIN ELSE "?").
  CREATE tt. ASSIGN tt.lbl = "CPRCODEOUT"
                    tt.val = (IF SESSION:CPRCODEOUT NE ? THEN SESSION:CPRCODEOUT ELSE "?").
  CREATE tt. ASSIGN tt.lbl = "CPSTREAM"             
                    tt.val = (IF SESSION:CPSTREAM NE ? THEN SESSION:CPSTREAM ELSE "?").
  CREATE tt. ASSIGN tt.lbl = "CPTERM"
                    tt.val = (IF SESSION:CPTERM NE ? THEN SESSION:CPTERM ELSE "?").   
  CREATE tt. ASSIGN tt.lbl = "DATA-ENTRY-RETURN"
                    tt.val = STRING(SESSION:DATA-ENTRY-RETURN).
  CREATE tt. ASSIGN tt.lbl = "DATE-FORMAT"
                    tt.val = STRING(SESSION:DATE-FORMAT).
  CREATE tt. ASSIGN tt.lbl = "DISPLAY-TYPE"
                    tt.val = SESSION:DISPLAY-TYPE . 
  CREATE tt. ASSIGN tt.lbl = "FIRST-PROCEDURE"
                    tt.val = (IF VALID-HANDLE(fproc) THEN fproc:FILE-NAME ELSE "<none>").
  CREATE tt. ASSIGN tt.lbl = "FRAME-SPACING"
                    tt.val = STRING(SESSION:FRAME-SPACING). 
  CREATE tt. ASSIGN tt.lbl = "HEIGHT-CHARS"
                    tt.val = STRING(SESSION:HEIGHT-CHARS). 
  CREATE tt. ASSIGN tt.lbl = "HEIGHT-PIXELS"
                    tt.val = STRING(SESSION:HEIGHT-PIXELS). 
  CREATE tt. ASSIGN tt.lbl = "IMMEDIATE-DISPLAY"
                    tt.val = STRING(SESSION:IMMEDIATE-DISPLAY). 
  CREATE tt. ASSIGN tt.lbl = "LAST-PROCEDURE"
                    tt.val = (IF VALID-HANDLE(lproc) THEN lproc:FILE-NAME ELSE "<none>").
  CREATE tt. ASSIGN tt.lbl = "MULTITASKING-INTERVAL"
                    tt.val = STRING(SESSION:MULTITASKING-INTERVAL).
  CREATE tt. ASSIGN tt.lbl = "NUMERIC-DECIMAL-POINT"
                    tt.val = SESSION:NUMERIC-DECIMAL-POINT.
  CREATE tt. ASSIGN tt.lbl = "NUMERIC-FORMAT"
                    tt.val = SESSION:NUMERIC-FORMAT.
  CREATE tt. ASSIGN tt.lbl = "NUMERIC-SEPARATOR"
                    tt.val = SESSION:NUMERIC-SEPARATOR.
  CREATE tt. ASSIGN tt.lbl = "PARAMETER"
                    tt.val = SESSION:PARAMETER. 
  CREATE tt. ASSIGN tt.lbl = "PIXELS-PER-COLUMN"
                    tt.val = STRING(SESSION:PIXELS-PER-COLUMN). 
  CREATE tt. ASSIGN tt.lbl = "PIXELS-PER-ROW"
                    tt.val = STRING(SESSION:PIXELS-PER-ROW). 
  CREATE tt. ASSIGN tt.lbl = "PRINTER-CONTROL-HANDLE"
                    tt.val = STRING(SESSION:PRINTER-CONTROL-HANDLE).
  CREATE tt. ASSIGN tt.lbl = "REMOTE"
                    tt.val = STRING(SESSION:REMOTE).
  CREATE tt. ASSIGN tt.lbl = "SERVER-CONNECTION-ID"
                    tt.val = SESSION:SERVER-CONNECTION-ID.
  CREATE tt. ASSIGN tt.lbl = "STREAM"
                    tt.val = SESSION:STREAM. 
  CREATE tt. ASSIGN tt.lbl = "SUPPRESS-WARNINGS"
                    tt.val = STRING(SESSION:SUPPRESS-WARNINGS). 
  CREATE tt. ASSIGN tt.lbl = "SYSTEM-ALERT-BOXES"
                    tt.val = STRING(SESSION:SYSTEM-ALERT-BOXES). 
  CREATE tt. ASSIGN tt.lbl = "TEMP-DIRECTORY"
                    tt.val = SESSION:TEMP-DIRECTORY. 
  CREATE tt. ASSIGN tt.lbl = "THREE-D"
                    tt.val = STRING(SESSION:THREE-D).
  CREATE tt. ASSIGN tt.lbl = "TIME-SOURCE"
                    tt.val = SESSION:TIME-SOURCE. 
  CREATE tt. ASSIGN tt.lbl = "TYPE"
                    tt.val = SESSION:TYPE.
  CREATE tt. ASSIGN tt.lbl = "V6DISPLAY"
                    tt.val = STRING(SESSION:V6DISPLAY). 
  CREATE tt. ASSIGN tt.lbl = "WIDTH-CHARS"
                    tt.val = STRING(SESSION:WIDTH-CHARS). 
  CREATE tt. ASSIGN tt.lbl = "WIDTH-PIXELS"
                    tt.val = STRING(SESSION:WIDTH-PIXELS). 
  CREATE tt. ASSIGN tt.lbl = "WINDOW-SYSTEM"
                    tt.val = SESSION:WINDOW-SYSTEM.

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE create-Web-Context-list 
PROCEDURE create-Web-Context-list :
/*------------------------------------------------------------------------------
  Purpose:     Creates a list of Web Context variables.  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
   CREATE tt.
   ASSIGN tt.lbl = "EXCLUSIVE-ID"
          tt.val = WEB-CONTEXT:EXCLUSIVE-ID.

   CREATE tt.
   ASSIGN tt.lbl = "HTML-END-OF-LINE"
          tt.val = WEB-CONTEXT:HTML-END-OF-LINE.

   CREATE tt.
   ASSIGN tt.lbl = "HTML-END-OF-PAGE"
          tt.val = WEB-CONTEXT:HTML-END-OF-PAGE.
          
   CREATE tt.
   ASSIGN tt.lbl = "HTML-FRAME-BEGIN"
          tt.val = WEB-CONTEXT:HTML-FRAME-BEGIN.
	   
   CREATE tt.
   ASSIGN tt.lbl = "HTML-FRAME-END"
          tt.val = WEB-CONTEXT:HTML-FRAME-END.

   CREATE tt.
   ASSIGN tt.lbl = "HTML-HEADER-BEGIN"
          tt.val = WEB-CONTEXT:HTML-HEADER-BEGIN.
	   
   CREATE tt.
   ASSIGN tt.lbl = "HTML-HEADER-END"
          tt.val = WEB-CONTEXT:HTML-HEADER-END.

   CREATE tt.
   ASSIGN tt.lbl = "HTML-TITLE-BEGIN"
          tt.val = WEB-CONTEXT:HTML-TITLE-BEGIN.
	   
   CREATE tt.
   ASSIGN tt.lbl = "HTML-TITLE-END"
          tt.val = WEB-CONTEXT:HTML-TITLE-END.
	   
END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE create-WebSpeed-list 
PROCEDURE create-WebSpeed-list :
/*------------------------------------------------------------------------------
  Purpose: Create the list of WebSpeed Miscellaneous variables.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   CREATE tt.
   ASSIGN tt.lbl = "AppProgram"
          tt.val = AppProgram.
          
   CREATE tt.
   ASSIGN tt.lbl = "AppURL"
          tt.val = AppURL.
          
   CREATE tt.
   ASSIGN tt.lbl = "HostURL"
          tt.val = HostURL.
          
   CREATE tt.
   ASSIGN tt.lbl = "SelfURL"
          tt.val = SelfURL.

   CREATE tt.
   ASSIGN tt.lbl = "OPSYS"
          tt.val = OPSYS.

   CREATE tt.
   ASSIGN tt.lbl = "DATASERVERS"
          tt.val = DATASERVERS. 

   CREATE tt.
   ASSIGN tt.lbl = "PROVERSION"       
          tt.val = PROVERSION.       

   CREATE tt.
   ASSIGN tt.lbl = "WEB-CONTEXT:EXCLUSIVE-ID"
          tt.val = WEB-CONTEXT:EXCLUSIVE-ID.
          
   CREATE tt.
   ASSIGN tt.lbl = "Agent Transaction-State".
   RUN get-transaction-state IN web-utilities-hdl NO-ERROR.
   IF ERROR-STATUS:ERROR OR RETURN-VALUE eq ?
   THEN tt.val = "Unknown".
   ELSE tt.val = RETURN-VALUE.

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE dump-list 
PROCEDURE dump-list :
/*------------------------------------------------------------------------------
  Purpose:     Go through the Temp-Table of lbl-val pairs and output them in 
               a table.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR htmlVal AS CHAR NO-UNDO.

  {&OUT} '<UL><TABLE BORDER = "0" CELLPADDING = "0" CELLSPACING = "0" >~r~n'.
  FOR EACH tt:
    /* Convert all values to html-viewable characters. */
    RUN AsciiToHtml IN web-utilities-hdl (tt.val, OUTPUT htmlVal).
    {&OUT} 
      '<TR><TD>' tt.lbl ': </TD><TD><B>' htmlVal '<B></TD></TR>~r~n'.
    /* Delete the tt record after dumping it. */
    DELETE tt.
  END.
  {&OUT} '</TABLE></UL>~r~n'.
END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE process-web-request 
PROCEDURE process-web-request :
/*------------------------------------------------------------------------------
  Purpose:     Process the web request.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR i       AS INTEGER NO-UNDO.
  DEFINE VAR cnt     AS INTEGER NO-UNDO.
  DEFINE VAR l_CGI   AS LOGICAL NO-UNDO.
  DEFINE VAR l_SES   AS LOGICAL NO-UNDO.
  DEFINE VAR l_WS    AS LOGICAL NO-UNDO.
  DEFINE VAR l_WC    AS LOGICAL NO-UNDO.
  
  DEFINE VAR sections AS CHARACTER NO-UNDO.

  /* 
   * Output the MIME header and set up the object as state-less or state-aware. 
   * This is required if any HTML is to be returned to the browser.
   */   
  RUN outputContentType IN web-utilities-hdl ("text/html":U).
  
  
  /* 
   * Get the list of lists that we are to return. 
   */
  RUN GetField IN web-utilities-hdl ("Sections", OUTPUT sections).
  /* Always show something. */
  IF REQUEST_METHOD eq "GET" AND sections eq "" THEN sections = "CGI".
  ASSIGN l_CGI = LOOKUP ("CGI",sections) > 0
         l_SES = LOOKUP ("SESSION", sections) > 0
         l_WS  = LOOKUP ("WebSpeed", sections) > 0
	 l_WC  = LOOKUP ("Web-Context", sections) > 0
         .
         
  {&OUT} 
   {webtools/html.i 
	 &SEGMENTS = "head,open-body,title-line"
	 &AUTHOR   = "Wm.T.Wood" 
	 &FRAME    = "WS_main"
	 &TITLE    = "Agent Variables"
	 &CONTEXT  = "{&Webtools_Agent_Variables_Help}" }
	 .

  {&OUT} 
    '<CENTER>~n'
    '<FORM METHOD = "POST" ACTION = "session.w">~n'
    '<TABLE BORDER="0" WIDTH="80%">~n'
    '<TR><TD ALIGN="LEFT">'
    format-label ("List Variables for":U, "TOP":U, "":U) '<BR>~n'
    '<FONT COLOR="' get-color("HIGHLIGHT":U) '"><B>'
    '<INPUT TYPE="CHECKBOX" NAME = "Sections" VALUE = "CGI"' 
            (IF l_CGI THEN " CHECKED>" ELSE ">") 'CGI ~n'
    '<INPUT TYPE="CHECKBOX" NAME = "Sections" VALUE = "WebSpeed"' 
            (IF l_WS THEN " CHECKED>" ELSE ">") 'WebSpeed ~n'
    '<INPUT TYPE="CHECKBOX" NAME = "Sections" VALUE = "Web-Context"'
	    (IF l_WC THEN " CHECKED>" ELSE ">") 'Web-Context ~n' 
    '<INPUT TYPE="CHECKBOX" NAME = "Sections" VALUE = "SESSION"' 
            (IF l_SES THEN " CHECKED>" ELSE ">") 'Session <B></TD>~n'
    '<TD><INPUT TYPE = "SUBMIT" VALUE = "Get List"></TD></TR>~n'
    '</TABLE>~n'
    '</CENTER>~n'
    '</FORM>~n'.
  
  /* Output a the global CGI Variables. */
  IF l_CGI THEN DO:
    {&OUT} '<HR>' format-text('CGI Environment Variables', 'H3':U) '~n'.  
    /* Dump the CGI variables. */
    RUN create-CGI-list.
    RUN dump-list.  
    {&OUT} 
      '* - These CGI names are directly accessible as WebSpeed global variables.~n'
      '<BR><BR>For more information on the CGI 1.1 and HTTP variables, see~n' 
      '<A HREF="http://hoohoo.ncsa.uiuc.edu/cgi/env.html">http://hoohoo.ncsa.uiuc.edu/cgi/env.html</A>.~n'
      '<BR><BR> ~n'.  
  END.
   
  /* Output the Miscellaneous WebSpeed Variables. */
  IF l_WS THEN DO:
    {&OUT} '<HR>' format-text('WebSpeed Variables', 'H3':U) '~n'.
    /* Dump the CGI variables. */
    RUN create-WebSpeed-list.
    RUN dump-list.     
  END.  
  
  /* Output the Web Context Variables. */
  IF l_WC THEN DO:
    {&OUT} '<HR>' format-text('WebSpeed WEB-CONTEXT Attributes', 'H3':U) '~n'. 
    /* Dump the Web Context variables. */
    RUN create-Web-Context-list.
    RUN dump-list.     
  END.  

  /* Output the PROGRESS Session Variables. */
  IF l_SES THEN DO:
    {&OUT} '<HR>' format-text('WebSpeed SESSION Attributes', 'H3':U) '~n'. 
    /* Dump the CGI variables. */
    RUN create-session-list.
    RUN dump-list.     
  END.  
  
  {&OUT} 
   '</BODY>~n'
   '</HTML>~n'.
  
END PROCEDURE.
&ANALYZE-RESUME
 

