&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 WebTool
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM Definitions 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
  File: dbmain.w
  
  Description: Main program for Database information 
  Parameters:  <none>

  Author:  Nancy E. Horn	 
  Created: January 27, 1997 
   
------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed WorkBench.          */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Included Definitions ---                                             */

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

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE listDBs 
PROCEDURE listDBs:
/*------------------------------------------------------------------------------
  Purpose:     List Connect Databases.
  Parameters:  <none>
  Notes:       
  -----------------------------------------------------------------------*/

  /* Output a Table for the Databases. */
  RUN webtools/util/_dblist.w 
    ("getDBList":U, 
     "",
     "",
     "",
     "",
     "",
     '<A HREF="dblist.w?command=getTableList~&~&ldbname=&1">&1</A>':U, 
     "" ).

END PROCEDURE.

&ANALYZE-RESUME

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE listTBLs 
PROCEDURE listTBLs:
/*------------------------------------------------------------------------------
  Purpose:     List Tables (not hidden) within a database.
  Parameters:  <none>
  Notes:       
  -----------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER p_options AS CHARACTER NO-UNDO.
 DEFINE INPUT PARAMETER p_table   AS CHARACTER NO-UNDO.

 DEFINE VARIABLE database-name AS CHARACTER NO-UNDO.

 RUN GetField IN web-utilities-hdl (INPUT "ldbname":U, OUTPUT database-name). 
 
 CREATE ALIAS "DICTDB":U FOR DATABASE VALUE(database-name).
 
 RUN webtools/util/_dblist.w 
   ("getTableList":U,
    database-name,
    p_table,
    "",
    "",
    "",
    '<A HREF="dblist.w?command=getFieldList~&~&ldbname=&1~&~&table=&2">&2</A>':U,
    p_options ).

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE process-web-request 
PROCEDURE process-web-request :
/*------------------------------------------------------------------------------
  Purpose:     Process the web request.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  /* 
   * Output the MIME header.
   */
  RUN outputContentType IN web-utilities-hdl ("text/html":U).

  {&OUT}
    {webtools/html.i 
	&SEGMENTS   = "head"
	&AUTHOR     = "Nancy.E.Horn"
	&FRAME      = "WS_main"
	&TITLE      = "Connected Database Information" }
    
    /* Create 3 FRAMES for dblist to use */
    '<FRAMESET ROWS="115,*"> ~n':U
    '    <FRAME NAME="WSDB_header" ~n':U
    '        SRC="':U AppURL '/webtools/dblist.w?command=getDBList" ~n':U
    '        FRAMEBORDER=no MARGINHEIGHT=3 MARGINWIDTH=5> ~n':U
    '        <FRAMESET COLS="192,*"> ~n':U
    '        <FRAME NAME ="WSDB_index" ~n':U
    '               SRC="' get-location('blank':U) '" ~n':U
    '               FRAMEBORDER=yes MARGINHEIGHT=3 MARGINWIDTH=5> ~n':U
    '        <FRAME NAME ="WSDB_main" ~n':U
    '               SRC="' get-location('blank':U) '"~n':U
    '               FRAMEBORDER=yes MARGINHEIGHT=3 MARGINWIDTH=5> ~n':U
    '    </FRAMESET>~n':U
    '</FRAMESET>~n':U
    '<NOFRAME>~n':U
    '<H1>WebSpeed Tools</H1>~n'
    'This page can be display with a frame enabled browser.~n'
    '</NOFRAME>~n':U
    '</HTML>~n':U
    .

END PROCEDURE.
&ANALYZE-RESUME
