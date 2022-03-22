/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _fnddb.p

Description:
    This program finds a _db record in a schema, and is part of the 
    HTML mapping validation to verify that the database-name supplied
    is a valid db.  Assumes the alias of DICTDB. 

Input Parameters:
   p_ldbname -- Logical database name 

Output Parameters:
   p_dbfound -- Indicates _db record found in schema  

Author:  Nancy E.Horn 
  
Modifications:  

Date Created: April 1997
---------------------------------------------------------------------------- */

DEFINE INPUT  PARAMETER p_ldbname       AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER p_dbfound       AS LOGICAL NO-UNDO.

/* Include Definitions */

/* ------------------- Internal Procedures -------------------- */

/* ------------------- Main Code Block  -------------------- */
 p_dbfound = no.

 FIND FIRST DICTDB._db NO-LOCK WHERE DICTDB._db._db-name eq p_ldbname NO-ERROR.
 IF AVAILABLE (DICTDB._db) THEN 
    p_dbfound = yes.
 ELSE
    p_dbfound = no.

 RETURN.
