&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v1r1 GUI
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
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

  File: _dblist.w

  Description: This module will return db schema information based
	       on the input command.  This program is called by
	       workshop/_dbinfo and webtools/_dblist.  It is the back-end
	       for both of these programs.  The calling program passes
	       a template with which the data is to be displayed.  Changes
	       to this program, need to be tested in both Webtools/Databases
	       and workshop/_dbinfo.

  Input Parameters:
    p_command  - The command to execute.  The list of commands is as follows:
      - getDBList:    displays the list of _db records within the schema
      - getTableList: displays the list of tables within p_ldbname
      -	getFieldList: displays the list of fields within p_table
      - getFieldInfo: displays field attributes
      - getIndexList: displays the list of indices within p_table
      - getIndexInfo: displays index attributes
    p_ldbname  - The database name
	p_sdbname  - The schema name (for Progress db, same as db name). 
  	p_table    - The table name
	p_field    - The field name 
	p_index    - The index name 
	p_html     - HTML mechanism to display each item  
    p_options  - accompanying options:
      - indent: fields should be indented
      - field-List: list fields for selected table during table list
      - index-List: list indices for selected table during table list

  Output Parameters:
      <none> 

  Author:  Nancy E. Horn 

  Created: January 23, 1997 

------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed WorkBench.          */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
  DEFINE INPUT PARAMETER p_command     AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p_ldbname     AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p_sdbname     AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p_table       AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p_field       AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p_index       AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p_html        AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p_options     AS CHARACTER NO-UNDO.

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&SCOPED-DEFINE PROCEDURE-TYPE Procedure
&SCOPED-DEFINE debug false
&IF {&debug} &THEN
DEFINE STREAM debug.
OUTPUT STREAM debug TO aa-dblist.log.
&ENDIF

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _INCLUDED-LIBRARIES
/* Standard WebTool Included Libraries --  */
{ webtools/webtool.i }

&ANALYZE-RESUME _END-INCLUDED-LIBRARIES

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by design tool only) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 2.38
         WIDTH              = 36.
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/web/method/wrap-cgi.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 

/* ************************  Main Code Block  *********************** */

/* User Defined Functions */
FUNCTION char_field RETURNS CHARACTER 
  (template AS CHARACTER,
   fname    AS CHARACTER,
   fvalue   AS CHARACTER):

  DEFINE VARIABLE line-out AS CHARACTER NO-UNDO.

  line-out = SUBSTITUTE(template, fname, 
    (IF fvalue eq "" OR fvalue eq ? THEN "&nbsp":U ELSE fvalue)).

  RETURN line-out.

END FUNCTION.

/* Handle the WEB event. */
RUN process-web-request.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE process-web-request Procedure 
PROCEDURE process-web-request:
/*------------------------------------------------------------------------------
  Purpose:     Process Web Request.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE ix       AS INTEGER NO-UNDO.
   
  RUN outputContentType IN web-utilities-hdl("text/html":U).

  CASE p_command:
    WHEN "getDBList":U THEN DO: 
      DO ix = 1 TO NUM-DBS:
        {&OUT} 
          '  ':U SUBSTITUTE(p_html, LDBNAME(ix), DBTYPE(ix), SDBNAME(ix),
            (IF DBTYPE(ix) ne "PROGRESS":U THEN "&nbsp&nbsp~;":U ELSE "") + LDBNAME(ix) +
            ' (':U + DBTYPE(ix) + ')':U).
      END.
    END.

    WHEN "getTableList":U THEN DO: 
      /* If foreign db get the appropriate db record, otherwise use the alias 
         to get the local schema record */
      RUN Find-Dictdb (p_sdbname, p_ldbname).
      &IF {&debug} &THEN
      PUT STREAM debug UNFORMATTED 
        "#1 Available dictdb: " AVAILABLE (dictdb._db) SKIP.
      &ENDIF

      {&OUT} '~n'.
      IF AVAILABLE (DICTDB._db) THEN 
        FOR EACH DICTDB._file OF DICTDB._db WHERE NOT DICTDB._file._hidden: 
          {&OUT} 
            SUBSTITUTE(p_html, url-encode(p_ldbname,"query"), 
                               url-encode(_file._file-name,"query"), 
                               url-encode(p_sdbname,"query"),
                               _file._file-name) '~n':U.
          
          IF CAN-DO(p_options,"List_Fields":U) AND _file._file-name eq p_table THEN 
            RUN webtools/util/_dblist.w 
              ("getFieldList":U,
	          p_ldbname, 	
              p_sdbname,
              _file._file-name,
              "",
              "",
              '<A HREF="dblist.w?command=getFieldInfo~&~&ldbname=&1~&~&table=&2~&~&field=&3~&~&sdbname=&5" TARGET="WSDB_main">&6 </A><BR>':U,
              "indent":U ).

          IF CAN-DO(p_options,"List_Indices":U) AND _file._file-name eq p_table THEN 
            RUN webtools/util/_dblist.w 
              ("getIndexList":U,
	          p_ldbname, 	
              p_sdbname,
              _file._file-name,
              "",
              "",
              '<A HREF="dblist.w?command=getIndexInfo~&~&ldbname=&1~&~&table=&2~&~&index=&3~&~&sdbname=&5" TARGET="WSDB_main">&6 </A><BR>':U,
              "indent":U ).
              
        END.  /* End For Each */
    END.

    WHEN "getFieldList":U THEN DO:																	
      /* Foreign db check */      
      RUN Find-Dictdb (p_sdbname, p_ldbname).
      &IF {&debug} &THEN
      PUT STREAM debug UNFORMATTED 
        "#2 Available dictdb: " AVAILABLE (dictdb._db) SKIP.
      &ENDIF
        
      /* Don't do this if called by the Query Builder - it only wants raw data. */
      IF CAN-DO(p_options,"indent":U) THEN 
        {&OUT} 
          '&nbsp&nbsp&nbsp':U format-text ("Fields:","B":U) '<BR>~n':U.
      
      IF AVAILABLE(DICTDB._db) THEN DO: 
        FIND FIRST DICTDB._file OF DICTDB._db WHERE DICTDB._file._file-name eq p_table NO-ERROR. 
        IF AVAILABLE(DICTDB._file) THEN 
          FOR EACH DICTDB._field OF DICTDB._file:
            {&OUT}
              (IF CAN-DO(p_options,"indent":U) THEN '&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp':U ELSE '')
              SUBSTITUTE(p_html, url-encode(p_ldbname,"query"), 
                                 url-encode(p_table,"query"), 
                                 url-encode(DICTDB._field._field-name,"query"), 
                                 DICTDB._field._data-type, 
                                 url-encode(p_sdbname,"query"),
                                 DICTDB._field._field-name) '~n':U.
          END.
      END.
    END.
      
    WHEN "getFieldInfo":U THEN DO:
      {&OUT} '~n':U.
      RUN Display-Field-Info. 
    END.

    WHEN "getIndexList":U THEN DO:
      /* Foreign db check */      
      RUN Find-Dictdb (p_sdbname, p_ldbname).
      &IF {&debug} &THEN
      PUT STREAM debug UNFORMATTED 
        "#3 Available dictdb: " AVAILABLE (dictdb._db) SKIP.
      &ENDIF
        
      {&OUT} 
        '&nbsp&nbsp&nbsp':U format-text ("Indices:","B":U) '<BR>~n':U.
      
      
      IF AVAILABLE(DICTDB._db) THEN DO: 
        FIND FIRST DICTDB._file OF DICTDB._db WHERE DICTDB._file._file-name eq p_table NO-ERROR. 
        IF AVAILABLE(DICTDB._file) THEN 
          FOR EACH DICTDB._index OF DICTDB._file:
            {&OUT}
              (IF CAN-DO(p_options,"indent":U) THEN '&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp':U ELSE '')
              SUBSTITUTE(p_html, url-encode(p_ldbname,"query"),
                                 url-encode(p_table,"query"),
                                 url-encode(DICTDB._index._index-name,"query"),
                                 "", 
                                 url-encode(p_sdbname,"query"),
                                 DICTDB._index._index-name) '~n':U.
          END.
      END.
    END.
    
    WHEN "getIndexHeader":U THEN DO:
      {&OUT} '~n':U.
      RUN Display-Index-Header.
    END.
    
    WHEN "getIndexFields":U THEN DO:
      {&OUT} '~n':U.
      RUN Display-Index-Fields.
    END.
  END CASE.

  &IF {&debug} &THEN
  OUTPUT STREAM debug CLOSE.
  &ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Display-Field-Info Procedure 
PROCEDURE Display-Field-Info:
/*------------------------------------------------------------------------------
  Purpose:     Display the attributes of the current field.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  /* Foreign db check */      
  RUN Find-Dictdb (p_sdbname, p_ldbname).
  &IF {&debug} &THEN
  PUT STREAM debug UNFORMATTED 
    "#4 Available dictdb: " AVAILABLE (dictdb._db) SKIP.
  &ENDIF

  IF AVAILABLE(DICTDB._db) THEN DO:
    FIND FIRST DICTDB._file OF DICTDB._db WHERE DICTDB._file._file-name eq p_table NO-ERROR.
    IF AVAILABLE(DICTDB._file) THEN DO: 
      FIND FIRST DICTDB._field OF DICTDB._file WHERE DICTDB._field._field-name = p_field NO-ERROR.
      IF AVAILABLE(DICTDB._field) THEN DO:
        {&OUT}
          CHAR_FIELD(p_html, "Description":U, DICTDB._field._desc) '~n':U
          CHAR_FIELD(p_html, "Datatype":U, DICTDB._field._data-type) '~n':U.
          
        IF DICTDB._field._Data-type eq "Decimal":U THEN
          {&OUT}
            SUBSTITUTE(p_html, "Decimal":U, DICTDB._field._decimals) '~n':U.
            
        {&OUT}
          CHAR_FIELD(p_html, "Format":U, DICTDB._field._format) '~n':U
          CHAR_FIELD(p_html, "Format-SA":U, DICTDB._field._format-SA) '~n':U
          CHAR_FIELD(p_html, "Initial":U, DICTDB._field._initial) '~n':U
          CHAR_FIELD(p_html, "Initial-SA":U, DICTDB._field._initial-SA) '~n':U
          CHAR_FIELD(p_html, "Label":U, DICTDB._field._label) '~n':U
          CHAR_FIELD(p_html, "Label-SA":U, DICTDB._field._label-SA) '~n':U
          CHAR_FIELD(p_html, "Col Label":U, DICTDB._field._Col-label) '~n':U
          CHAR_FIELD(p_html, "Col Label-SA":U, DICTDB._field._Col-label-SA) '~n':U
          CHAR_FIELD(p_html, "Help":U, DICTDB._field._help) '~n':U
          CHAR_FIELD(p_html, "Help-SA":U, DICTDB._field._Help-SA) '~n':U
          SUBSTITUTE(p_html, "Order":U, DICTDB._field._Order) '~n':U
          CHAR_FIELD(p_html, "Valexp":U, DICTDB._field._valexp) '~n':U
          CHAR_FIELD(p_html, "Valmsg":U, DICTDB._field._valmsg) '~n':U
          SUBSTITUTE(p_html, "Case Sensitive ":U, DICTDB._field._Fld-Case) '~n':U.
          
        IF _field._extent > 0 THEN
          {&OUT}
	        SUBSTITUTE(p_html, "Extent":U, DICTDB._field._extent) '~n':U.
      END. /* if available _field */
    END.  /* if available _file */
  END. /* if available _db */

END PROCEDURE. 

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Display-Index-Header Procedure 
PROCEDURE Display-Index-Header:
/*------------------------------------------------------------------------------
  Purpose:     Display the header attributes of the current index.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  /* Foreign db check */      
  RUN Find-Dictdb (p_sdbname, p_ldbname).
  &IF {&debug} &THEN
  PUT STREAM debug UNFORMATTED 
    "#5 Available dictdb: " AVAILABLE (dictdb._db) SKIP.
  &ENDIF

  IF AVAILABLE(DICTDB._db) THEN DO:
    FIND FIRST DICTDB._file OF DICTDB._db 
      WHERE DICTDB._file._file-name eq p_table NO-ERROR.
    IF AVAILABLE(DICTDB._file) THEN DO: 
      FIND FIRST DICTDB._index OF DICTDB._file 
        WHERE DICTDB._index._index-name = p_index NO-ERROR.
      
      IF AVAILABLE(DICTDB._index) THEN
        {&OUT}
          CHAR_FIELD(p_html, "Active":U, 
            STRING(DICTDB._index._active,"Yes/No")) '~n':U
          CHAR_FIELD(p_html, "Description":U, DICTDB._index._desc) '~n':U
          CHAR_FIELD(p_html, "Primary":U, 
            STRING(RECID(DICTDB._index) = _file._prime-index,"Yes/No")) '~n':U
          CHAR_FIELD(p_html, "Unique":U, 
            STRING(DICTDB._index._unique,"Yes/No")) '~n':U
          CHAR_FIELD(p_html, "Word Index":U, 
            STRING(DICTDB._index._wordidx = 1,"Yes/No":U)) '~n':U
          .
    END.  /* if available _file */
  END. /* if available _db */

END PROCEDURE. 

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Display-Index-Fields Procedure 
PROCEDURE Display-Index-Fields:
/*------------------------------------------------------------------------------
  Purpose:     Display the header attributes of the current index.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  /* Foreign db check */      
  RUN Find-Dictdb (p_sdbname, p_ldbname).
  &IF {&debug} &THEN
  PUT STREAM debug UNFORMATTED 
    "#6 Available dictdb: " AVAILABLE (dictdb._db) SKIP.
  &ENDIF

  IF AVAILABLE(DICTDB._db) THEN DO:
    FIND FIRST DICTDB._file OF DICTDB._db 
      WHERE DICTDB._file._file-name eq p_table NO-ERROR.
    IF AVAILABLE(DICTDB._file) THEN DO: 
      FIND FIRST DICTDB._index OF DICTDB._file 
        WHERE DICTDB._index._index-name = p_index NO-ERROR.
      
      IF AVAILABLE(DICTDB._index) THEN DO:
        FOR EACH DICTDB._index-field OF DICTDB._index:
          FIND FIRST DICTDB._field 
            WHERE RECID(DICTDB._field) = DICTDB._index-field._field-recid NO-ERROR.
            
          {&OUT}
            SUBSTITUTE(p_html, 
              STRING(DICTDB._index-field._index-seq),
              DICTDB._field._field-name, 
              DICTDB._field._data-type,
              STRING(DICTDB._index-field._ascending,"Yes/No"),
              STRING(DICTDB._index-field._abbreviate,"Yes/No")).
        END.
      END. /* if available _index */
    END.  /* if available _file */
  END. /* if available _db */

END PROCEDURE. 

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Find-Dictdb Procedure 
PROCEDURE Find-Dictdb:
/*------------------------------------------------------------------------------
  Purpose:     Find the correct DICTDB record
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_sdbname AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p_ldbname AS CHARACTER NO-UNDO.
  
  IF p_sdbname ne p_ldbname THEN 
    FIND FIRST DICTDB._db WHERE DICTDB._db._db-name eq p_ldbname NO-ERROR.
  ELSE
    FIND FIRST DICTDB._db WHERE DICTDB._db._db-type eq "PROGRESS":U AND
      (DICTDB._db._db-name eq ? OR DICTDB._db._db-name eq "") NO-ERROR.
END PROCEDURE. 

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
