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

 FIND FIRST DICTDB._db WHERE DICTDB._db._db-name eq p_ldbname NO-ERROR.
 IF AVAILABLE (DICTDB._db) THEN 
    p_dbfound = yes.
 ELSE
    p_dbfound = no.

 RETURN.
