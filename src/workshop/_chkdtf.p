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

Date Created: Feb. 1997
---------------------------------------------------------------------------- */

DEFINE INPUT  PARAMETER p_u_recid       AS RECID NO-UNDO.
DEFINE INPUT  PARAMETER p_dbname        AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER p_table         AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER p_field         AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER p_source        AS CHARACTER NO-UNDO.	
DEFINE OUTPUT PARAMETER p_map           AS LOGICAL NO-UNDO.

/* Include Definitions */
{ workshop/objects.i }
{ workshop/sharvars.i }
{ workshop/uniwidg.i }

DEFINE VARIABLE database-name AS CHARACTER NO-UNDO.
DEFINE VARIABLE i AS INTEGER NO-UNDO.
DEFINE VARIABLE fld-ok AS LOGICAL NO-UNDO INITIAL no.

/* ------------------- Internal Procedures -------------------- */

/* ------------------- Main Code Block  -------------------- */

 p_map = no. 

 IF p_dbname eq ?  OR p_dbname eq "" THEN 
 db-tran:
    DO i = 1 to NUM-DBS:
      ASSIGN database-name = LDBNAME(i).
      CREATE ALIAS "DICTDB" FOR DATABASE VALUE(database-name).
      RUN workshop/_chkfld.p (INPUT p_u_recid,
			      INPUT p_table,
			      INPUT p_field,
			      INPUT p_source,
			      OUTPUT fld-ok ).
      IF fld-ok THEN LEAVE db-tran.
    END.
 ELSE DO:
    CREATE ALIAS "DICTDB" FOR DATABASE VALUE(p_dbname).
    RUN workshop/_chkfld.p (INPUT p_u_recid,
			    INPUT p_table,
			    INPUT p_field,
			    INPUT p_source,
			    OUTPUT fld-ok ).
 END.

 p_map = fld-ok.

 RETURN.     
 
/* 
 * ---- End of file ----- 
 */
