&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v1r1 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
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
  File: dbinfo.w
  
  Description: Process requests for and return information about the 
      Connected Databases running in a WebSpeed Agent.  This program 
      calls a back-end processor, webtools/util/_dblist.w, which retrieves
      the schema information. 

  Parameters: Command - getDBList, getTableList, getFieldList, getAutoJoin
              ldbname - database name
              sdbname - schema name               
              table   - table name

  Author:  Nancy E. Horn 
  Created: January 27, 1997

  Modifications:   Added getAutoJoin                4/9/97  adams
                   Updated for sdbname              4/4/97  nhorn

------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed WorkBench.          */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Web-Object

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME

/* ***********************  Control Definitions  ********************** */

/* ************************  Frame Definitions  *********************** */

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Web-Object
   Allow: 
   Frames: 0
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by design tool only) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 2.38
         WIDTH              = 36.
                                                                        */
&ANALYZE-RESUME

/* ***************  Runtime Attributes and Tool Settings  ************* */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/web/method/wrap-cgi.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 

/* ************************  Main Code Block  *********************** */

/* Process the latest WEB event. */
RUN process-web-request.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE process-web-request Procedure 
PROCEDURE process-web-request :
/*------------------------------------------------------------------------------
  Purpose:     Process the web request.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE command           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE database-name     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE join-list         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE table-name        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE schema-name       AS CHARACTER NO-UNDO.
  
  /* 
   * Output the MIME header and set up the object as state-less or state-aware. 
   * This is required if any HTML is to be returned to the browser.
   */
  RUN outputContentType IN web-utilities-hdl ("text/plain":U).

  RUN GetField IN web-utilities-hdl (INPUT "command":U, OUTPUT command).
  IF command eq "" OR command eq ? THEN         
    ASSIGN command = "getDBList":U.
       
  /* Connected Databases. */
  CASE command:
    WHEN "getDBList":U THEN DO:
      {&OUT} '~n'.
      
      /* Output a Table for the Databases. */
      RUN webtools/util/_dblist.w 
              ("getDBList":U,
              "",
              "",
              "",
              "",
              "",
              '&1,&3':U,
              "").
    END.

    WHEN "getTableList":U THEN DO:
      {&OUT} '~n':U.
      RUN listTBLs ("","").
    END.

    WHEN "getFieldList":U THEN DO:
      RUN GetField IN web-utilities-hdl (INPUT "ldbname":U, OUTPUT database-name).
      RUN GetField IN web-utilities-hdl (INPUT "sdbname":U, OUTPUT schema-name).
      RUN GetField IN web-utilities-hdl (INPUT "table":U, OUTPUT table-name).
      
      {&OUT} '~n':U.

      CREATE ALIAS "DICTDB":U FOR DATABASE VALUE(schema-name).
      RUN webtools/util/_dblist.w 
              ("getFieldList":U, 
              database-name, 
              schema-name,
              table-name,
              "",
              "",
              '&3,&4':U,  /* &3=Field, &4=Datatype */
              "").
    END.
    
    WHEN "getAutoJoin":U THEN DO:
      RUN webutil/_jfind.p (get-value("table":U), OUTPUT join-list).
      
      {&OUT}
        (IF join-list BEGINS "ERROR" THEN '' ELSE '~n':U) join-list '~n':U.
    END.

    OTHERWISE
      {&OUT} "Unrecognized Workshop command".
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE listTBLs Procedure 
PROCEDURE listTBLs:
/*------------------------------------------------------------------------------
  Purpose:     List Tables (not hidden) within a database.
  Parameters:  <none>
  Notes:       
  -----------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER p_options AS CHARACTER NO-UNDO.
 DEFINE INPUT PARAMETER p_table   AS CHARACTER NO-UNDO.

 DEFINE VARIABLE database-name AS CHARACTER NO-UNDO.
 DEFINE VARIABLE schema-name   AS CHARACTER NO-UNDO.

 RUN GetField IN web-utilities-hdl (INPUT "ldbname":U, OUTPUT database-name). 
 RUN GetField IN web-utilities-hdl (INPUT "sdbname":U, OUTPUT schema-name). 

 CREATE ALIAS "DICTDB":U FOR DATABASE VALUE(schema-name).
 RUN webtools/util/_dblist.w 
	     ("getTableList":U,
	     database-name,
         schema-name, 
	     p_table,
	     "",
         "",
	     '&2':U,
	     ""  ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* _dbinfo.w - end of file */
