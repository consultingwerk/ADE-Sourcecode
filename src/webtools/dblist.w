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
  File: dblist.w
  
  Description: List of all Connected Databases running in a WebSpeed Agent
  Parameters:  <none>

  Author:  Nancy E. Horn
  Created: Jan. 21, 1997
   
 ------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed WorkBench.          */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

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

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE getFLD 
PROCEDURE getFLD:
/*------------------------------------------------------------------------------
  Purpose:    Get Field Information and display it.    
  Parameters:  <none>
  Notes:       
  -----------------------------------------------------------------------*/
  DEFINE VARIABLE database-name AS CHARACTER NO-UNDO.
  DEFINE VARIABLE field-name    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE index-name    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE sdb-name      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE table-name    AS CHARACTER NO-UNDO.

  RUN GetField IN web-utilities-hdl (INPUT "ldbname":U, OUTPUT database-name).
  RUN GetField IN web-utilities-hdl (INPUT "sdbname":U, OUTPUT sdb-name).
  RUN GetField IN web-utilities-hdl (INPUT "table":U, OUTPUT table-name).
  RUN GetField IN web-utilities-hdl (INPUT "field":U, OUTPUT field-name).

  CREATE ALIAS "DICTDB":U FOR DATABASE VALUE(sdb-name).

  {&OUT} 
    '<CENTER>~n':U
    format-text ('Field Attributes: ' + 
      format-text (database-name + '.':U + table-name + '.':U + field-name,"HighLight,I":U),
      "H4":U)
    '<TABLE':U get-table-phrase('') '>~n':U
    '<TR><TH>':U format-label('Attribute', "COLUMN":U, "") 
    '</TH><TH>':U format-label('Value', "COLUMN":U, "")
    '</TH></TR>~n':U. 

  RUN webtools/util/_dblist.w 
    ("getFieldInfo":U, 
     database-name,
     sdb-name,
     table-name,
     field-name,
     "",
     '<TR><TD> &1 </TD><TD> &2 </TD></TR>~n':U, 
     "Field-Table" ).

  {&OUT} 
    '</TABLE>~n':U
    '</CENTER>~n':U.

END PROCEDURE.

&ANALYZE-RESUME

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE getIDX
PROCEDURE getIDX:
/*------------------------------------------------------------------------------
  Purpose:    Get Index Information and display it.    
  Parameters:  <none>
  Notes:       
  -----------------------------------------------------------------------*/
  DEFINE VARIABLE database-name AS CHARACTER NO-UNDO.
  DEFINE VARIABLE index-name    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE sdb-name      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE table-name    AS CHARACTER NO-UNDO.

  RUN GetField IN web-utilities-hdl (INPUT "ldbname":U, OUTPUT database-name).
  RUN GetField IN web-utilities-hdl (INPUT "sdbname":U, OUTPUT sdb-name).
  RUN GetField IN web-utilities-hdl (INPUT "table":U, OUTPUT table-name).
  RUN GetField IN web-utilities-hdl (INPUT "index":U, OUTPUT index-name).

  CREATE ALIAS "DICTDB":U FOR DATABASE VALUE(sdb-name).

  {&OUT} 
    '<CENTER>~n':U
      format-text ('Index Attributes: ' + 
      format-text (index-name + ' for ':U + database-name + '.':U + table-name,"HighLight,I":U),
      "H4":U) '~n':U
    '<TABLE':U get-table-phrase('') '>~n':U
    '<TR><TH>':U format-label('Attribute', "COLUMN":U, "") 
    '</TH><TH>':U format-label('Value', "COLUMN":U, "")
    '</TH></TR>~n':U. 

  /* Display index header information. */
  RUN webtools/util/_dblist.w 
    ("getIndexHeader":U, 
     database-name,
     sdb-name,
     table-name,
     "",
     index-name,
     '<TR><TD> &1 </TD><TD> &2 </TD></TR>~n':U, 
     "Index-Header-Table" ).

  {&OUT} 
    '</TABLE></CENTER>~n':U
    '<CENTER>~n':U
      format-text ('Index Field Attributes: ':U,"H4":U) '~n':U
    '<TABLE':U get-table-phrase('') '>~n':U
    
    '<TR>~n':U
    '  <TH>':U format-label('Sequence', "COLUMN":U, "") '</TH>~n':U
    '  <TH>':U format-label('Field', "COLUMN":U, "") '</TH>~n':U
    '  <TH>':U format-label('Type', "COLUMN":U, "") '</TH>~n':U
    '  <TH>':U format-label('Ascending', "COLUMN":U, "") '</TH>~n':U
    '  <TH>':U format-label('Abbreviate', "COLUMN":U, "") '</TH>~n':U
    '</TR>~n':U. 

  
  /* Display index field component information. */
  RUN webtools/util/_dblist.w 
    ("getIndexFields":U, 
     database-name,
     sdb-name,
     table-name,
     "",
     index-name,
     '<TR><TD> &1 </TD><TD> &2 </TD><TD> &3 </TD><TD> &4 </TD><TD> &5 </TD></TR>~n':U, 
     "Index-Field-Table" ).

  {&OUT} 
    '</TABLE></CENTER>~n':U.
END PROCEDURE.

&ANALYZE-RESUME

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE listDBs 
PROCEDURE listDBs:
/*------------------------------------------------------------------------------
  Purpose:     List Connect Databases.
  Parameters:  <none>
  Notes:       
  -----------------------------------------------------------------------*/

  /* Output a Table for the Databases. */
  RUN webtools/util/_dblist.w 
    ("getDBList", 
    "",
    "",
    "",
    "",
    "",
    '<OPTION VALUE="dblist.w?command=getTableList~&~&ldbname=&1~&~&sdbname=&3" TARGET="WSDB_index">&4</OPTION>~n':U, 
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
  DEFINE VARIABLE sdb-name      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE title-text    AS CHARACTER NO-UNDO.

  /* If p_table is blank, we are only going to list tables in the db.  If
     not, we will list tables and fields in the table. */
  title-text = IF p_table ne "":U THEN 'Tables/Fields: ':U ELSE 'Table Listing: ':U.
 
  RUN GetField IN web-utilities-hdl (INPUT "ldbname":U, OUTPUT database-name). 
  RUN GetField IN web-utilities-hdl (INPUT "sdbname":U, OUTPUT sdb-name). 
 
  {&OUT}  
    format-text (title-text + format-text (database-name, "HighLight,I":U), "H4":U) '~n':U.

  CREATE ALIAS "DICTDB":U FOR DATABASE VALUE(sdb-name).

  RUN webtools/util/_dblist.w 
    ("getTableList":U,
    database-name,
    sdb-name,
    p_table,
    "",
    "",
    '<A HREF="dblist.w?command=getFieldList~&~&ldbname=&1~&~&table=&2~&~&sdbname=&3">&4</A><BR>':U,
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
  DEFINE VARIABLE command           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE database-name     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE table-name        AS CHARACTER NO-UNDO.
  
  /* 
   * Output the MIME header.
   */
  RUN outputContentType IN web-utilities-hdl ("text/html":U).

  RUN GetField IN web-utilities-hdl (INPUT "command":U, OUTPUT command).
  IF command eq "" OR command eq ? THEN         
    command = "getDBList":U.
       
  CASE command:
    WHEN "getDBLIST":U THEN
      {&OUT}
        {webtools/html.i 
          &SEGMENTS   = "head,open-body,title-line,no-rule"
          &AUTHOR     = "Nancy.E.Horn"
          &FRAME      = "WSDB_header"
          &TITLE      = "Databases"
          &CONTEXT    = "{&Webtools_Database_Help}" }
          .
    WHEN "getTableList":U OR WHEN "getFieldList":U THEN 
      {&OUT} 
        {webtools/html.i
          &SEGMENTS = "head,open-body" 
          &AUTHOR   = "Nancy.H.Horn"
          &FRAME    = "WSDB_index"
          &TITLE    = "Tables" } 
          .
    WHEN "getFieldInfo":U THEN 
      {&OUT} 
        {webtools/html.i
          &SEGMENTS = "head,open-body" 
          &AUTHOR   = "Nancy.H.Horn"
          &FRAME    = "WSDB_main"
          &TITLE    = "Tables" } 
          .
    WHEN "getIndexInfo":U THEN 
      {&OUT} 
        {webtools/html.i
          &SEGMENTS = "head,open-body" 
          &AUTHOR   = "Doug.M.Adams"
          &FRAME    = "WSDB_main"
          &TITLE    = "Tables" } 
          .
  END CASE.
  
  /* Connected Databases. */
  IF NUM-DBS eq 0 THEN DO:
    {&OUT} 'There are no connected Databases for this <FONT COLOR="red">Web</FONT>Speed Agent.~n'. 
    RETURN.
  END.
  
  CASE command:
    WHEN "getDBList":U THEN DO:
      /* Generate db list as a selection list. */
      {&OUT}
        '<FORM>~n':U
        '<B>':U format-label ('Connected Databases':U, 'SIDE':U, '':U) '</B>~n':U
        '<SELECT onChange="(!(navigator.appName.indexOf(''Microsoft'') != -1 && navigator.appVersion.charAt(0) == ''2'') && (this[selectedIndex].value)) ? parent.WSDB_index.location=this[selectedIndex].value : null"> ~n':U
        '  <OPTION VALUE="">':U 'Select a Database' '</OPTION> ~n':U.

      RUN listDBs.
      
      {&OUT}
        '</SELECT> ~n':U
        '</FORM> ~n':U.
   END.

    WHEN "getTableList":U THEN
      RUN listTBLs ("", "").

    WHEN "getFieldList":U THEN DO:
      RUN GetField IN web-utilities-hdl (INPUT "ldbname":U, OUTPUT database-name).
      RUN GetField IN web-utilities-hdl (INPUT "table":U, OUTPUT table-name).
      
      /*RUN listTBLs ("List_Fields":U, table-name).*/
      RUN listTBLs ("List_Fields,List_Indices":U, table-name).
      {&OUT} '~n':U.
    END.

    WHEN "getFieldInfo":U THEN
      RUN getFLD.

    WHEN "getIndexInfo":U THEN
      RUN getIDX.

  END CASE.
	
  {&OUT} 
    '</CENTER>~n':U
    '</BODY>~n':U
    '</HTML>~n':U
    .

END PROCEDURE.

&ANALYZE-RESUME
