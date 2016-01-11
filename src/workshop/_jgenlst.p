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
/*
 * _jgenlst.p - generate list of tables for a database
 */

{ workshop/j-define.i }
{ workshop/dbname.i &db="QBF$1"}

DEFINE INPUT PARAMETER ldb-name AS CHARACTER NO-UNDO.

DEFINE VARIABLE next-id AS INTEGER NO-UNDO.

FIND LAST qbf-rel-tt USE-INDEX tidix NO-ERROR.
next-id = IF NOT AVAILABLE qbf-rel-tt THEN 1 ELSE qbf-rel-tt.tid + 1.

FOR EACH QBF$1._File 
  WHERE QBF$1._File._File-Name < "_":U AND NOT QBF$1._File._Hidden
  BY QBF$1._File._File-Name:
  
  CREATE qbf-rel-tt.
  ASSIGN
    qbf-rel-tt.tid    = next-id
    /*
    qbf-rel-tt.tname  = get-dbname(QBF$1._File._db-recid) + ".":U
                      + QBF$1._File._File-Name
    */
    qbf-rel-tt.tname  = ldb-name + ".":U + QBF$1._File._File-Name
    next-id           = next-id + 1.
END.

/* _jgenlst.p - end of file */


