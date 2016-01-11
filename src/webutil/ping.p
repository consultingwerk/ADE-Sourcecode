&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000-2002 by Progress Software Corporation ("PSC"),  *
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

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

------------------------------------------------------------------------*/
/*           This .W file was created with the Progress AppBuilder.     */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-checkFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD checkFile Procedure 
FUNCTION checkFile RETURNS LOGICAL
  ( cFileName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 14.14
         WIDTH              = 60.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/web2/wrap-cgi.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ************************  Main Code Block  *********************** */

/* Process the latest Web event. */
RUN process-web-request.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-checkDir) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkDir Procedure 
PROCEDURE checkDir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcDirName  AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcFileList AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE iCount  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE ix      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lOK     AS LOGICAL   NO-UNDO.

  FILE-INFO:FILE-NAME = pcDirName.
  IF FILE-INFO:FULL-PATHNAME eq ? OR (NOT FILE-INFO:FILE-TYPE BEGINS "D":U) THEN
    {&OUT} '<LI>Directory <I>' pcDirName 
           '</I> does <FONT COLOR="RED" SIZE="+1"><B><BLINK>not</BLINK></B></FONT> exist.</LI>~n'.  
  ELSE DO:
    {&OUT} '<LI>Testing..'.
    ASSIGN 
      ix     = 0
      iCount = NUM-ENTRIES (pcFileList)
      lOK    = yes.

    DO WHILE lOK AND ix < iCount:
      ASSIGN
        ix  = ix + 1
        lOK = checkFile(pcDirName + "/":U + ENTRY(ix, pcFileList)).
    END.
    IF lOK THEN
      {&OUT} ' OK</LI>'.
    ELSE 
      {&OUT} ' <FONT COLOR="RED" SIZE="+2"><B><BLINK>failed</BLINK></B></FONT></LI>'.
  END. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-process-web-request) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE process-web-request Procedure 
PROCEDURE process-web-request :
/*------------------------------------------------------------------------------
  Purpose:     Process the web request.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cEntry   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProPath AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ix       AS INTEGER    NO-UNDO.

  /* Output the MIME header. */
  output-content-type ("text/html":U).

  IF NOT debugging-enabled THEN DO:
    DYNAMIC-FUNCTION ("logNote":U IN web-utilities-hdl, "WARNING":U,
                              SUBSTITUTE ("ping.p was requested by &1 and debugging mode was not set. (Ref: &2)",
                                          REMOTE_ADDR, HTTP_REFERER)) NO-ERROR.
    DYNAMIC-FUNCTION ("ShowErrorScreen":U IN web-utilities-hdl,"Unable to find web object file 'ping.p'") NO-ERROR.  
    RETURN.
  END.
  
  {&OUT}
    '<HTML>':U SKIP
    '<HEAD><TITLE>':U "WebSpeed Agent successfully accessed"
      '</TITLE></HEAD>':U SKIP
    '<BODY BACKGROUND="' RootURL '/images/bgr/wsbgr.gif" TEXT="BLACK">'
    '<H2>':U "WebSpeed Transaction Server successfully accessed." '</H2>':U SKIP
    '<HR WIDTH="100%">'.

  IF debugging-enabled THEN DO:
    ASSIGN 
      FILE-INFO:FILE-NAME = ".":U  /* current directory */
      cProPath            = PROPATH.

    DO ix = 1 TO NUM-ENTRIES(cProPath):
      cEntry = ENTRY(ix, cProPath).
      IF LC(cEntry) = LC(FILE-INFO:FULL-PATHNAME) THEN
        ENTRY(ix, cProPath) = cEntry + " (<I>working directory</I>)".
    END.

    {&OUT}
      '<DL>':U SKIP
      '  <DT><B>':U "Web Object Path (PROPATH):" '</B>':U SKIP
      '    <DD><FONT SIZE="-1">':U REPLACE(cProPath, ",":U, "<BR>~n":U)
      '</FONT><BR><BR>':U SKIP
      '  <DT><B>':U "Connected Databases:" '</B>':U SKIP.

    DO ix = 1 TO NUM-DBS:
      {&OUT}
        '    <DD><FONT SIZE="-1">':U LDBNAME(ix) ' (':U DBTYPE(ix)
        ')</FONT>':U SKIP.
    END.
    IF NUM-DBS = 0 THEN
      {&OUT}
        '<DL>There are no connected databases for this WebSpeed Agent.' SKIP.

    {&OUT} 
      '</DL>':U SKIP
      '<HR WIDTH="100%">':U SKIP
      '<H3>Checking Standard Utilities</H3>' SKIP
      '<UL>':U SKIP.

    /* Check for the DLC/tty/webutil directory. */
    RUN checkDir ('webutil':U, '_genoff.r,_wstyle.r,_promsgs.r,_relname.r,e4gl-gen.r':U).

    {&OUT}
      '</UL>':U SKIP
      '<H3>Checking WebTools Files</H3>' SKIP
      '<UL>':U SKIP.

    /* Check for the DLC/tty/webtools directory. */
    RUN checkDir ('webtools':U, 'edtscrpt.r,dirlist.r,index.r,dblist.r,util/_fileact.r':U).

    {&OUT}
      '</UL>':U SKIP
      '<HR WIDTH="100%">':U SKIP
      
      '<H3>Checking WebTools Installation</H3>' SKIP
      '<UL><LI>Click <A HREF="' AppURL '/workshop" TARGET="_top">here</A> to access WebSpeed WebTools</FONT></LI></UL>' SKIP
      '<HR WIDTH="100%">':U SKIP
      
      '<H3>Checking Image and Documentation Files</H3>' SKIP
      '<P>The list below should show image files if WebSpeed has been configured properly on your web server. If the images show as broken links, then there is some problem with your installation.</P>'
      '<CENTER>':U SKIP
      '<TABLE BORDER=1 WIDTH="80%">':U SKIP
      '<TR>' SKIP
      '  <TH>Image File</TH>'
      '  <TH ALIGN="CENTER">Image <FONT SIZE="-1"><SUP>1</SUP></FONT></TH>'
      '  <TH ALIGN="CENTER">Associated Directory <FONT SIZE="-1"><SUP>2</SUP></FONT></TH>'
      '</TR>'
      '<TR>'
      '  <TD>WebSpeed logo</TD>'
      '  <TD ALIGN="CENTER"><IMG SRC="' RootURL '/workshop/webspeed.gif" HEIGHT=27 WIDTH=112 ALT="WebSpeed Logo"></TD>'
      '  <TD ALIGN="CENTER"><A HREF="' RootURL '/workshop">/webspeed/workshop</A></TD>'
      '</TR>' SKIP
      '<TR>'
      '  <TD>WebTools logo</TD>'
      '  <TD ALIGN="CENTER"><IMG SRC="' RootURL '/images/l-tools.gif" WIDTH=55 HEIGHT=45 ALT="WebTools Logo"></TD>'
      '  <TD ALIGN="CENTER"><A HREF="' RootURL '/images">/webspeed/images</A></TD>'
      '</TR>' SKIP
      '<TR>'
      '  <TD>WebSpeed Library logo</TD>'
      '  <TD ALIGN="CENTER"><img src="' RootURL '/doc/wshelp/images/books2.gif" width="75" height="56" ALT="Library Logo"></TD>'
      '  <TD ALIGN="CENTER"><A HREF="' RootURL '/doc">/webspeed/doc</A></TD>'
      '</TR>' SKIP
      '</TABLE>' SKIP
      '</CENTER><BR>' SKIP
      '<FONT SIZE="-2"><SUP>1</SUP> Broken image links indicate setup problem.</FONT><BR>'
      '<FONT SIZE="-2"><SUP>2</SUP> Your web server may not allow direct access to these links.</FONT>'
      .
  END. /* debugging-enabled */
  {&OUT}
    '</BODY></HTML>':U SKIP.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-checkFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION checkFile Procedure 
FUNCTION checkFile RETURNS LOGICAL
  ( cFileName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
 FILE-INFO:FILE-NAME = cFileName.
 IF FILE-INFO:FULL-PATHNAME eq ? THEN 
   RETURN FALSE.
 ELSE DO:
   {&OUT} '.'.  
   RETURN TRUE.
 END.
 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

