/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _chkfld.p

Description:  Loops through connected databases to find the table  
	      /field name.  Database name may be passed in or omitted. 

Input Parameters:
   p_u_recid -- The Recid of the current _U record. 
   p_dbname  -- value of unknown (?)
   p_table   -- database table
   p_field   -- Field name
   p_source  -- indicates whether field definition source is in "DB"
		or "local".

Output Parameters:
   p_map -- indicates if the field was found. 

Author:  Nancy E.Horn 
Created: 2/97
Updated: 2/16/98 adams Modified for Skywalker

---------------------------------------------------------------------------- */

DEFINE INPUT  PARAMETER p_u_recid       AS RECID     NO-UNDO.
DEFINE INPUT  PARAMETER p_dbname        AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER p_table         AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER p_field         AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER p_source        AS CHARACTER NO-UNDO.	
DEFINE OUTPUT PARAMETER p_map           AS LOGICAL   NO-UNDO.

/* Include Definitions */
{ adeuib/sharvars.i }
{ adeuib/uniwidg.i }

DEFINE VARIABLE db-name AS CHARACTER NO-UNDO.
DEFINE VARIABLE ix      AS INTEGER   NO-UNDO.
DEFINE VARIABLE fld-ok  AS LOGICAL   NO-UNDO.

/* ------------------- Internal Procedures -------------------- */

/* ------------------- Main Code Block  -------------------- */

IF p_dbname eq ?  OR p_dbname eq "" THEN 
db-tran:
DO ix = 1 to NUM-DBS:
  ASSIGN db-name = LDBNAME(ix).
  CREATE ALIAS "DICTDB":U FOR DATABASE VALUE(db-name).
  RUN adeweb/_chkfld.p (p_u_recid, p_table, p_field, p_source, OUTPUT fld-ok).
  IF fld-ok THEN LEAVE db-tran.
END.
ELSE DO:
  CREATE ALIAS "DICTDB":U FOR DATABASE VALUE(p_dbname).
  RUN adeweb/_chkfld.p (p_u_recid, p_table, p_field, p_source, OUTPUT fld-ok).
END.

p_map = fld-ok.

/* _chkdtf.p - end of file */
